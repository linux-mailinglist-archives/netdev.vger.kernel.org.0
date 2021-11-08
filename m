Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E7C449A75
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 18:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240479AbhKHRIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 12:08:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:44360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240461AbhKHRIu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 12:08:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6971661406;
        Mon,  8 Nov 2021 17:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636391166;
        bh=CLRTIdZSHTcwYmS1NxkLbfrYZ0AZbXpTrl8Y0wpdR/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uW/AXhp8ygKBpRLzN7PZHow1EmuBhkQBDMJ2stO+RZRhV9Acq6BFqEV/Yq5d+s8zh
         Xhzi7Wxl2zO/huQNVcl3E0UOfbospYf4rBDzPCBqF48BLSHz+j7Re3NWpXai2ai9kA
         eQOfhEDXUhvJtXpcSfhxBNEMZI5jCimBEqMT+BpOdbFjWSYJYf6oH2rpIRqTAkITNC
         lVCJwuKFZ/uh3agviJnQgXeyc1q1d7FAzoTaQBaIFc5pcvcB5wjTQf6c3KepuXWmGj
         cjdhPO/foCAVohffQFELdC3J/si8Qr5FcPfLiq53pBNMDMFsMgno8vZQdhvbSmi/LN
         og3COEsQYibhA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Subject: [RFC PATCH 07/16] devlink: Inline sb related functions
Date:   Mon,  8 Nov 2021 19:05:29 +0200
Message-Id: <985847373a397a708bb5d86dec806d5d025fb080.1636390483.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1636390483.git.leonro@nvidia.com>
References: <cover.1636390483.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Remove useless indirection of sb related functions, which called only
once and do nothing except accessing specific struct field.

As part of this cleanup, properly report an programming erro if already
existing sb index was supplied during SB registration.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 110 ++++++++++++++-------------------------------
 1 file changed, 33 insertions(+), 77 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index a2cd27fd767e..86db7cf1f3ca 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -364,12 +364,6 @@ static struct devlink_sb *devlink_sb_get_by_index(struct devlink *devlink,
 	return NULL;
 }
 
-static bool devlink_sb_index_exists(struct devlink *devlink,
-				    unsigned int sb_index)
-{
-	return devlink_sb_get_by_index(devlink, sb_index);
-}
-
 static struct devlink_sb *devlink_sb_get_from_attrs(struct devlink *devlink,
 						    struct nlattr **attrs)
 {
@@ -385,16 +379,11 @@ static struct devlink_sb *devlink_sb_get_from_attrs(struct devlink *devlink,
 	return ERR_PTR(-EINVAL);
 }
 
-static struct devlink_sb *devlink_sb_get_from_info(struct devlink *devlink,
-						   struct genl_info *info)
-{
-	return devlink_sb_get_from_attrs(devlink, info->attrs);
-}
-
-static int devlink_sb_pool_index_get_from_attrs(struct devlink_sb *devlink_sb,
-						struct nlattr **attrs,
-						u16 *p_pool_index)
+static int devlink_sb_pool_index_get_from_info(struct devlink_sb *devlink_sb,
+					       struct genl_info *info,
+					       u16 *p_pool_index)
 {
+	struct nlattr **attrs = info->attrs;
 	u16 val;
 
 	if (!attrs[DEVLINK_ATTR_SB_POOL_INDEX])
@@ -407,18 +396,11 @@ static int devlink_sb_pool_index_get_from_attrs(struct devlink_sb *devlink_sb,
 	return 0;
 }
 
-static int devlink_sb_pool_index_get_from_info(struct devlink_sb *devlink_sb,
-					       struct genl_info *info,
-					       u16 *p_pool_index)
-{
-	return devlink_sb_pool_index_get_from_attrs(devlink_sb, info->attrs,
-						    p_pool_index);
-}
-
 static int
-devlink_sb_pool_type_get_from_attrs(struct nlattr **attrs,
-				    enum devlink_sb_pool_type *p_pool_type)
+devlink_sb_pool_type_get_from_info(struct genl_info *info,
+				   enum devlink_sb_pool_type *p_pool_type)
 {
+	struct nlattr **attrs = info->attrs;
 	u8 val;
 
 	if (!attrs[DEVLINK_ATTR_SB_POOL_TYPE])
@@ -433,16 +415,10 @@ devlink_sb_pool_type_get_from_attrs(struct nlattr **attrs,
 }
 
 static int
-devlink_sb_pool_type_get_from_info(struct genl_info *info,
-				   enum devlink_sb_pool_type *p_pool_type)
-{
-	return devlink_sb_pool_type_get_from_attrs(info->attrs, p_pool_type);
-}
-
-static int
-devlink_sb_th_type_get_from_attrs(struct nlattr **attrs,
-				  enum devlink_sb_threshold_type *p_th_type)
+devlink_sb_th_type_get_from_info(struct genl_info *info,
+				 enum devlink_sb_threshold_type *p_th_type)
 {
+	struct nlattr **attrs = info->attrs;
 	u8 val;
 
 	if (!attrs[DEVLINK_ATTR_SB_POOL_THRESHOLD_TYPE])
@@ -457,18 +433,12 @@ devlink_sb_th_type_get_from_attrs(struct nlattr **attrs,
 }
 
 static int
-devlink_sb_th_type_get_from_info(struct genl_info *info,
-				 enum devlink_sb_threshold_type *p_th_type)
-{
-	return devlink_sb_th_type_get_from_attrs(info->attrs, p_th_type);
-}
-
-static int
-devlink_sb_tc_index_get_from_attrs(struct devlink_sb *devlink_sb,
-				   struct nlattr **attrs,
-				   enum devlink_sb_pool_type pool_type,
-				   u16 *p_tc_index)
+devlink_sb_tc_index_get_from_info(struct devlink_sb *devlink_sb,
+				  struct genl_info *info,
+				  enum devlink_sb_pool_type pool_type,
+				  u16 *p_tc_index)
 {
+	struct nlattr **attrs = info->attrs;
 	u16 val;
 
 	if (!attrs[DEVLINK_ATTR_SB_TC_INDEX])
@@ -485,16 +455,6 @@ devlink_sb_tc_index_get_from_attrs(struct devlink_sb *devlink_sb,
 	return 0;
 }
 
-static int
-devlink_sb_tc_index_get_from_info(struct devlink_sb *devlink_sb,
-				  struct genl_info *info,
-				  enum devlink_sb_pool_type pool_type,
-				  u16 *p_tc_index)
-{
-	return devlink_sb_tc_index_get_from_attrs(devlink_sb, info->attrs,
-						  pool_type, p_tc_index);
-}
-
 struct devlink_region {
 	struct devlink *devlink;
 	struct devlink_port *port;
@@ -1975,7 +1935,7 @@ static int devlink_nl_cmd_sb_get_doit(struct sk_buff *skb,
 	struct sk_buff *msg;
 	int err;
 
-	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	devlink_sb = devlink_sb_get_from_attrs(devlink, info->attrs);
 	if (IS_ERR(devlink_sb))
 		return PTR_ERR(devlink_sb);
 
@@ -2093,7 +2053,7 @@ static int devlink_nl_cmd_sb_pool_get_doit(struct sk_buff *skb,
 	u16 pool_index;
 	int err;
 
-	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	devlink_sb = devlink_sb_get_from_attrs(devlink, info->attrs);
 	if (IS_ERR(devlink_sb))
 		return PTR_ERR(devlink_sb);
 
@@ -2217,7 +2177,7 @@ static int devlink_nl_cmd_sb_pool_set_doit(struct sk_buff *skb,
 	u32 size;
 	int err;
 
-	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	devlink_sb = devlink_sb_get_from_attrs(devlink, info->attrs);
 	if (IS_ERR(devlink_sb))
 		return PTR_ERR(devlink_sb);
 
@@ -2308,7 +2268,7 @@ static int devlink_nl_cmd_sb_port_pool_get_doit(struct sk_buff *skb,
 	u16 pool_index;
 	int err;
 
-	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	devlink_sb = devlink_sb_get_from_attrs(devlink, info->attrs);
 	if (IS_ERR(devlink_sb))
 		return PTR_ERR(devlink_sb);
 
@@ -2438,7 +2398,7 @@ static int devlink_nl_cmd_sb_port_pool_set_doit(struct sk_buff *skb,
 	u32 threshold;
 	int err;
 
-	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	devlink_sb = devlink_sb_get_from_attrs(devlink, info->attrs);
 	if (IS_ERR(devlink_sb))
 		return PTR_ERR(devlink_sb);
 
@@ -2531,7 +2491,7 @@ static int devlink_nl_cmd_sb_tc_pool_bind_get_doit(struct sk_buff *skb,
 	u16 tc_index;
 	int err;
 
-	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	devlink_sb = devlink_sb_get_from_attrs(devlink, info->attrs);
 	if (IS_ERR(devlink_sb))
 		return PTR_ERR(devlink_sb);
 
@@ -2695,7 +2655,7 @@ static int devlink_nl_cmd_sb_tc_pool_bind_set_doit(struct sk_buff *skb,
 	u32 threshold;
 	int err;
 
-	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	devlink_sb = devlink_sb_get_from_attrs(devlink, info->attrs);
 	if (IS_ERR(devlink_sb))
 		return PTR_ERR(devlink_sb);
 
@@ -2729,7 +2689,7 @@ static int devlink_nl_cmd_sb_occ_snapshot_doit(struct sk_buff *skb,
 	const struct devlink_ops *ops = devlink->ops;
 	struct devlink_sb *devlink_sb;
 
-	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	devlink_sb = devlink_sb_get_from_attrs(devlink, info->attrs);
 	if (IS_ERR(devlink_sb))
 		return PTR_ERR(devlink_sb);
 
@@ -2745,7 +2705,7 @@ static int devlink_nl_cmd_sb_occ_max_clear_doit(struct sk_buff *skb,
 	const struct devlink_ops *ops = devlink->ops;
 	struct devlink_sb *devlink_sb;
 
-	devlink_sb = devlink_sb_get_from_info(devlink, info);
+	devlink_sb = devlink_sb_get_from_attrs(devlink, info->attrs);
 	if (IS_ERR(devlink_sb))
 		return PTR_ERR(devlink_sb);
 
@@ -9653,29 +9613,24 @@ int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u16 egress_tc_count)
 {
 	struct devlink_sb *devlink_sb;
-	int err = 0;
 
-	mutex_lock(&devlink->lock);
-	if (devlink_sb_index_exists(devlink, sb_index)) {
-		err = -EEXIST;
-		goto unlock;
-	}
+	WARN_ON(devlink_sb_get_by_index(devlink, sb_index));
 
 	devlink_sb = kzalloc(sizeof(*devlink_sb), GFP_KERNEL);
-	if (!devlink_sb) {
-		err = -ENOMEM;
-		goto unlock;
-	}
+	if (!devlink_sb)
+		return -ENOMEM;
+
 	devlink_sb->index = sb_index;
 	devlink_sb->size = size;
 	devlink_sb->ingress_pools_count = ingress_pools_count;
 	devlink_sb->egress_pools_count = egress_pools_count;
 	devlink_sb->ingress_tc_count = ingress_tc_count;
 	devlink_sb->egress_tc_count = egress_tc_count;
+
+	mutex_lock(&devlink->lock);
 	list_add_tail(&devlink_sb->list, &devlink->sb_list);
-unlock:
 	mutex_unlock(&devlink->lock);
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(devlink_sb_register);
 
@@ -9683,9 +9638,10 @@ void devlink_sb_unregister(struct devlink *devlink, unsigned int sb_index)
 {
 	struct devlink_sb *devlink_sb;
 
-	mutex_lock(&devlink->lock);
 	devlink_sb = devlink_sb_get_by_index(devlink, sb_index);
 	WARN_ON(!devlink_sb);
+
+	mutex_lock(&devlink->lock);
 	list_del(&devlink_sb->list);
 	mutex_unlock(&devlink->lock);
 	kfree(devlink_sb);
-- 
2.33.1

