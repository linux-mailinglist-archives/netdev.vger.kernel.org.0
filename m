Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24CC449A7A
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 18:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241424AbhKHRJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 12:09:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:44616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241428AbhKHRJI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 12:09:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FF2B6120A;
        Mon,  8 Nov 2021 17:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636391184;
        bh=6QHJrw69sX3p9BOYrufp6NKlS1pMEGA87i1Q8hTrm4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sUdrBzMtKMJRapjw59yDtOEZPqTTXkWBKOfqugGLImqJoePn5JP/+EC+KWuYK95zO
         Hac3HffaMc6eLoTLh6QP5/MZJZnan0iXrvqI2v5jVmmvPhyb+n1fv59Tq8hAVghcU1
         JjWVXPCa+CfWf99IQH7K/IScRjsx+r6MsM9owCQajJSlImTuUWWkBDa1EU4j93A0LG
         7wnl9fM05uM4OqFvjjqZZMdLGbWoNH+xKjhFStOVusvr+eFIPc2L+3t0JExXRFSFtl
         GtCg5NrcwWUE/qRrWNJLUAmiVgIF8Epd52XI/UAF2B8EqqrmsDYGGmyxMRfFGTushS
         k4TGNh6p/QAHQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Subject: [RFC PATCH 08/16] devlink: Protect resource list with specific lock
Date:   Mon,  8 Nov 2021 19:05:30 +0200
Message-Id: <461d1e1b3d0399d6cab1117a796f0b02b634597f.1636390483.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1636390483.git.leonro@nvidia.com>
References: <cover.1636390483.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Devlink resource flows relied on devlink instance lock to protect
from parallel addition and deletion from resource_list. So instead
of overloading devlink->lock, let's introduce new lock with much more
clear scope.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 100 +++++++++++++++++++++++++--------------------
 1 file changed, 56 insertions(+), 44 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 86db7cf1f3ca..97154219fca2 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -46,6 +46,7 @@ struct devlink {
 	struct list_head sb_list;
 	struct list_head dpipe_table_list;
 	struct list_head resource_list;
+	struct mutex resource_list_lock; /* protects resource_list */
 	struct list_head param_list;
 	struct list_head region_list;
 	struct list_head reporter_list;
@@ -3587,12 +3588,15 @@ devlink_resource_find(struct devlink *devlink,
 }
 
 static void
-devlink_resource_validate_children(struct devlink_resource *resource)
+devlink_resource_validate_children(struct devlink *devlink,
+				   struct devlink_resource *resource)
 {
 	struct devlink_resource *child_resource;
 	bool size_valid = true;
 	u64 parts_size = 0;
 
+	lockdep_assert_held(&devlink->lock);
+
 	if (list_empty(&resource->resource_list))
 		goto out;
 
@@ -3645,20 +3649,25 @@ static int devlink_nl_cmd_resource_set(struct sk_buff *skb,
 		return -EINVAL;
 	resource_id = nla_get_u64(info->attrs[DEVLINK_ATTR_RESOURCE_ID]);
 
+	mutex_lock(&devlink->resource_list_lock);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
-	if (!resource)
-		return -EINVAL;
+	if (!resource) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	size = nla_get_u64(info->attrs[DEVLINK_ATTR_RESOURCE_SIZE]);
 	err = devlink_resource_validate_size(resource, size, info->extack);
 	if (err)
-		return err;
+		goto out;
 
 	resource->size_new = size;
-	devlink_resource_validate_children(resource);
+	devlink_resource_validate_children(devlink, resource);
 	if (resource->parent)
-		devlink_resource_validate_children(resource->parent);
-	return 0;
+		devlink_resource_validate_children(devlink, resource->parent);
+out:
+	mutex_unlock(&devlink->resource_list_lock);
+	return err;
 }
 
 static int
@@ -3742,31 +3751,36 @@ static int devlink_resource_put(struct devlink *devlink, struct sk_buff *skb,
 	return -EMSGSIZE;
 }
 
-static int devlink_resource_fill(struct genl_info *info,
-				 enum devlink_command cmd, int flags)
+static int devlink_nl_cmd_resource_dump(struct sk_buff *sk,
+					struct genl_info *info)
 {
 	struct devlink *devlink = info->user_ptr[0];
 	struct devlink_resource *resource;
 	struct nlattr *resources_attr;
 	struct sk_buff *skb = NULL;
+	int err = -EOPNOTSUPP;
 	struct nlmsghdr *nlh;
 	bool incomplete;
 	void *hdr;
 	int i;
-	int err;
+
+	mutex_lock(&devlink->resource_list_lock);
+	if (list_empty(&devlink->resource_list))
+		goto out;
 
 	resource = list_first_entry(&devlink->resource_list,
 				    struct devlink_resource, list);
 start_again:
 	err = devlink_dpipe_send_and_alloc_skb(&skb, info);
 	if (err)
-		return err;
+		goto out;
 
 	hdr = genlmsg_put(skb, info->snd_portid, info->snd_seq,
-			  &devlink_nl_family, NLM_F_MULTI, cmd);
+			  &devlink_nl_family, NLM_F_MULTI,
+			  DEVLINK_CMD_RESOURCE_DUMP);
 	if (!hdr) {
-		nlmsg_free(skb);
-		return -EMSGSIZE;
+		err = -EMSGSIZE;
+		goto err_resource_put;
 	}
 
 	if (devlink_nl_put_handle(skb, devlink))
@@ -3793,9 +3807,10 @@ static int devlink_resource_fill(struct genl_info *info,
 	genlmsg_end(skb, hdr);
 	if (incomplete)
 		goto start_again;
+	mutex_unlock(&devlink->resource_list_lock);
 send_done:
-	nlh = nlmsg_put(skb, info->snd_portid, info->snd_seq,
-			NLMSG_DONE, 0, flags | NLM_F_MULTI);
+	nlh = nlmsg_put(skb, info->snd_portid, info->snd_seq, NLMSG_DONE, 0,
+			NLM_F_MULTI);
 	if (!nlh) {
 		err = devlink_dpipe_send_and_alloc_skb(&skb, info);
 		if (err)
@@ -3808,28 +3823,20 @@ static int devlink_resource_fill(struct genl_info *info,
 	err = -EMSGSIZE;
 err_resource_put:
 	nlmsg_free(skb);
+out:
+	mutex_unlock(&devlink->resource_list_lock);
 	return err;
 }
 
-static int devlink_nl_cmd_resource_dump(struct sk_buff *skb,
-					struct genl_info *info)
-{
-	struct devlink *devlink = info->user_ptr[0];
-
-	if (list_empty(&devlink->resource_list))
-		return -EOPNOTSUPP;
-
-	return devlink_resource_fill(info, DEVLINK_CMD_RESOURCE_DUMP, 0);
-}
-
 static int
 devlink_resources_validate(struct devlink *devlink,
-			   struct devlink_resource *resource,
-			   struct genl_info *info)
+			   struct devlink_resource *resource)
 {
 	struct list_head *resource_list;
 	int err = 0;
 
+	lockdep_assert_held(&devlink->lock);
+
 	if (resource)
 		resource_list = &resource->resource_list;
 	else
@@ -3838,9 +3845,10 @@ devlink_resources_validate(struct devlink *devlink,
 	list_for_each_entry(resource, resource_list, list) {
 		if (!resource->size_valid)
 			return -EINVAL;
-		err = devlink_resources_validate(devlink, resource, info);
+
+		err = devlink_resources_validate(devlink, resource);
 		if (err)
-			return err;
+			break;
 	}
 	return err;
 }
@@ -4064,7 +4072,9 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 	if (!(devlink->features & DEVLINK_F_RELOAD))
 		return -EOPNOTSUPP;
 
-	err = devlink_resources_validate(devlink, NULL, info);
+	mutex_lock(&devlink->resource_list_lock);
+	err = devlink_resources_validate(devlink, NULL);
+	mutex_unlock(&devlink->resource_list_lock);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(info->extack, "resources size validation failed");
 		return err;
@@ -8955,7 +8965,10 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	INIT_LIST_HEAD(&devlink->rate_list);
 	INIT_LIST_HEAD(&devlink->sb_list);
 	INIT_LIST_HEAD_RCU(&devlink->dpipe_table_list);
+
 	INIT_LIST_HEAD(&devlink->resource_list);
+	mutex_init(&devlink->resource_list_lock);
+
 	INIT_LIST_HEAD(&devlink->param_list);
 	INIT_LIST_HEAD(&devlink->region_list);
 	INIT_LIST_HEAD(&devlink->reporter_list);
@@ -9108,6 +9121,7 @@ void devlink_free(struct devlink *devlink)
 
 	mutex_destroy(&devlink->reporters_lock);
 	mutex_destroy(&devlink->port_list_lock);
+	mutex_destroy(&devlink->resource_list_lock);
 	mutex_destroy(&devlink->lock);
 	WARN_ON(!list_empty(&devlink->trap_policer_list));
 	WARN_ON(!list_empty(&devlink->trap_group_list));
@@ -9825,7 +9839,7 @@ int devlink_resource_register(struct devlink *devlink,
 	       sizeof(resource->size_params));
 	INIT_LIST_HEAD(&resource->resource_list);
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->resource_list_lock);
 	if (parent_resource_id == DEVLINK_RESOURCE_ID_PARENT_TOP) {
 		resource_list = &devlink->resource_list;
 	} else {
@@ -9845,7 +9859,7 @@ int devlink_resource_register(struct devlink *devlink,
 
 	list_add_tail(&resource->list, resource_list);
 out:
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->resource_list_lock);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_resource_register);
@@ -9872,16 +9886,14 @@ void devlink_resources_unregister(struct devlink *devlink)
 {
 	struct devlink_resource *tmp, *child_resource;
 
-	mutex_lock(&devlink->lock);
-
+	mutex_lock(&devlink->resource_list_lock);
 	list_for_each_entry_safe(child_resource, tmp, &devlink->resource_list,
 				 list) {
 		devlink_resource_unregister(devlink, child_resource);
 		list_del(&child_resource->list);
 		kfree(child_resource);
 	}
-
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->resource_list_lock);
 }
 EXPORT_SYMBOL_GPL(devlink_resources_unregister);
 
@@ -9899,7 +9911,7 @@ int devlink_resource_size_get(struct devlink *devlink,
 	struct devlink_resource *resource;
 	int err = 0;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->resource_list_lock);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
 	if (!resource) {
 		err = -EINVAL;
@@ -9908,7 +9920,7 @@ int devlink_resource_size_get(struct devlink *devlink,
 	*p_resource_size = resource->size_new;
 	resource->size = resource->size_new;
 out:
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->resource_list_lock);
 	return err;
 }
 EXPORT_SYMBOL_GPL(devlink_resource_size_get);
@@ -9959,7 +9971,7 @@ void devlink_resource_occ_get_register(struct devlink *devlink,
 {
 	struct devlink_resource *resource;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->resource_list_lock);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
 	if (WARN_ON(!resource))
 		goto out;
@@ -9968,7 +9980,7 @@ void devlink_resource_occ_get_register(struct devlink *devlink,
 	resource->occ_get = occ_get;
 	resource->occ_get_priv = occ_get_priv;
 out:
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->resource_list_lock);
 }
 EXPORT_SYMBOL_GPL(devlink_resource_occ_get_register);
 
@@ -9983,7 +9995,7 @@ void devlink_resource_occ_get_unregister(struct devlink *devlink,
 {
 	struct devlink_resource *resource;
 
-	mutex_lock(&devlink->lock);
+	mutex_lock(&devlink->resource_list_lock);
 	resource = devlink_resource_find(devlink, NULL, resource_id);
 	if (WARN_ON(!resource))
 		goto out;
@@ -9992,7 +10004,7 @@ void devlink_resource_occ_get_unregister(struct devlink *devlink,
 	resource->occ_get = NULL;
 	resource->occ_get_priv = NULL;
 out:
-	mutex_unlock(&devlink->lock);
+	mutex_unlock(&devlink->resource_list_lock);
 }
 EXPORT_SYMBOL_GPL(devlink_resource_occ_get_unregister);
 
-- 
2.33.1

