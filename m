Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A531A30006A
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 11:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbhAVK2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 05:28:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727725AbhAVJsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 04:48:14 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA214C061353
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:46:52 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id c12so4439775wrc.7
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Acx36WlCbB6aLe/20IKU6G6dYCKa0jkK+44/7VwBEuU=;
        b=h0l3+oXGpg04WUPXUUiDM6z7Zrx/QEegzK4vC/jcHKRF5NXm0nKYjTK8nGEXevPvLm
         fYsGQqgHtF9Fl8M0wMaZIEmo+A2SzXjbg+GdS8VzD556h7FxaPipyvLztEDTsboT9lq1
         I/MbUSqiQKNc47V5XFxBa9t0tX64M3noMNAx3e9fjesDpX92B1EJ+cgCzXy3MD/0dE+N
         g/obW1ejvBuMfWjnFKUr9iJt1AOnadrmUn8qOlRTOSHzoODcy0P03P07myJHRwaMQsDP
         /sKtfDcLCAEno1UzqL+imcZ/dj7XefmARHfqWuhOsQAummrJYarwDwbUI/SZCH5jxmtj
         smkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Acx36WlCbB6aLe/20IKU6G6dYCKa0jkK+44/7VwBEuU=;
        b=goSxf/AhvzieVg6BnqUNTwooEwG8nxh6AJtzjxKus08fJHc++bnernz/hh96tg6Dfi
         UoDd1bN/LgJFDeN9MNbNSnOa3cANZhGa8f7urQsKkaiSGV5Jl1E4wo53F7et5eoDFbyM
         57BxDe2lQEpIW4qxN1+jyJoH37ghYrJ+j/IuCi9lgCwKYE6ZPnF10IEBBNGlfB10xdmC
         oO2VStlIOeczEhUXPzDeAZOWywEXMGUD4c52O6bmm9OywcbXxGoiFedPhQPFHc+3yJez
         E7yBrpgT1g99x5pPGOFq47iF7yHCPLeutPcxHwFhmmTIBWrtr3tWpVmvHPi7NSFG1KSs
         7HTw==
X-Gm-Message-State: AOAM533tHs+iTsHYxjhHpD9JHjYH0yN7OVuFqKfoBr6hQ39gx9mglvdb
        RYo2Afj2j6tSJ8RMIcX+/iA0qT/h/R/aWHEeVso=
X-Google-Smtp-Source: ABdhPJyZSfJ8U5oojeEFMFC1qagJfK5BhNq192xh5WmzaUfasCJodhwFMGWoAWStQ8VYsOVSk8IF2g==
X-Received: by 2002:a5d:6d06:: with SMTP id e6mr3602844wrq.425.1611308811082;
        Fri, 22 Jan 2021 01:46:51 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id n16sm11311116wrj.26.2021.01.22.01.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 01:46:50 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jacob.e.keller@intel.com,
        roopa@nvidia.com, andrew@lunn.ch, dsahern@gmail.com,
        mlxsw@nvidia.com
Subject: [patch net-next RFCv2 01/10] devlink: add support to create line card and expose to user
Date:   Fri, 22 Jan 2021 10:46:39 +0100
Message-Id: <20210122094648.1631078-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122094648.1631078-1-jiri@resnulli.us>
References: <20210122094648.1631078-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Extend the devlink API so the driver is going to be able to create and
destroy linecard instances. There can be multiple line cards per devlink
device. Expose this new type of object over devlink netlink API to the
userspace, with notifications.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->RFCv2:
- s/register/create in function comment
- s/create/destroy/ for destroy exported symbol
---
 include/net/devlink.h        |  10 ++
 include/uapi/linux/devlink.h |   7 ++
 net/core/devlink.c           | 227 ++++++++++++++++++++++++++++++++++-
 3 files changed, 243 insertions(+), 1 deletion(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index dd0c0b8fba6e..67c2547d5ef9 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -45,6 +45,7 @@ struct devlink {
 	struct list_head trap_list;
 	struct list_head trap_group_list;
 	struct list_head trap_policer_list;
+	struct list_head linecard_list;
 	const struct devlink_ops *ops;
 	struct xarray snapshot_ids;
 	struct devlink_dev_stats stats;
@@ -138,6 +139,12 @@ struct devlink_port {
 	struct mutex reporters_lock; /* Protects reporter_list */
 };
 
+struct devlink_linecard {
+	struct list_head list;
+	struct devlink *devlink;
+	unsigned int index;
+};
+
 struct devlink_sb_pool_info {
 	enum devlink_sb_pool_type pool_type;
 	u32 size;
@@ -1407,6 +1414,9 @@ void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u32 contro
 				   u16 pf, bool external);
 void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 controller,
 				   u16 pf, u16 vf, bool external);
+struct devlink_linecard *devlink_linecard_create(struct devlink *devlink,
+						 unsigned int linecard_index);
+void devlink_linecard_destroy(struct devlink_linecard *linecard);
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index cf89c318f2ac..e5ed0522591f 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -126,6 +126,11 @@ enum devlink_command {
 
 	DEVLINK_CMD_HEALTH_REPORTER_TEST,
 
+	DEVLINK_CMD_LINECARD_GET,		/* can dump */
+	DEVLINK_CMD_LINECARD_SET,
+	DEVLINK_CMD_LINECARD_NEW,
+	DEVLINK_CMD_LINECARD_DEL,
+
 	/* add new commands above here */
 	__DEVLINK_CMD_MAX,
 	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
@@ -529,6 +534,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_RELOAD_ACTION_INFO,        /* nested */
 	DEVLINK_ATTR_RELOAD_ACTION_STATS,       /* nested */
 
+	DEVLINK_ATTR_LINECARD_INDEX,		/* u32 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index f86688bfad46..70154bed9950 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -187,6 +187,46 @@ static struct devlink_port *devlink_port_get_from_info(struct devlink *devlink,
 	return devlink_port_get_from_attrs(devlink, info->attrs);
 }
 
+static struct devlink_linecard *
+devlink_linecard_get_by_index(struct devlink *devlink,
+			      unsigned int linecard_index)
+{
+	struct devlink_linecard *devlink_linecard;
+
+	list_for_each_entry(devlink_linecard, &devlink->linecard_list, list) {
+		if (devlink_linecard->index == linecard_index)
+			return devlink_linecard;
+	}
+	return NULL;
+}
+
+static bool devlink_linecard_index_exists(struct devlink *devlink,
+					  unsigned int linecard_index)
+{
+	return devlink_linecard_get_by_index(devlink, linecard_index);
+}
+
+static struct devlink_linecard *
+devlink_linecard_get_from_attrs(struct devlink *devlink, struct nlattr **attrs)
+{
+	if (attrs[DEVLINK_ATTR_LINECARD_INDEX]) {
+		u32 linecard_index = nla_get_u32(attrs[DEVLINK_ATTR_LINECARD_INDEX]);
+		struct devlink_linecard *linecard;
+
+		linecard = devlink_linecard_get_by_index(devlink, linecard_index);
+		if (!linecard)
+			return ERR_PTR(-ENODEV);
+		return linecard;
+	}
+	return ERR_PTR(-EINVAL);
+}
+
+static struct devlink_linecard *
+devlink_linecard_get_from_info(struct devlink *devlink, struct genl_info *info)
+{
+	return devlink_linecard_get_from_attrs(devlink, info->attrs);
+}
+
 struct devlink_sb {
 	struct list_head list;
 	unsigned int index;
@@ -405,16 +445,18 @@ devlink_region_snapshot_get_by_id(struct devlink_region *region, u32 id)
 
 #define DEVLINK_NL_FLAG_NEED_PORT		BIT(0)
 #define DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT	BIT(1)
+#define DEVLINK_NL_FLAG_NEED_LINECARD		BIT(2)
 
 /* The per devlink instance lock is taken by default in the pre-doit
  * operation, yet several commands do not require this. The global
  * devlink lock is taken and protects from disruption by user-calls.
  */
-#define DEVLINK_NL_FLAG_NO_LOCK			BIT(2)
+#define DEVLINK_NL_FLAG_NO_LOCK			BIT(3)
 
 static int devlink_nl_pre_doit(const struct genl_ops *ops,
 			       struct sk_buff *skb, struct genl_info *info)
 {
+	struct devlink_linecard *linecard;
 	struct devlink_port *devlink_port;
 	struct devlink *devlink;
 	int err;
@@ -439,6 +481,13 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
 		devlink_port = devlink_port_get_from_info(devlink, info);
 		if (!IS_ERR(devlink_port))
 			info->user_ptr[1] = devlink_port;
+	} else if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_LINECARD) {
+		linecard = devlink_linecard_get_from_info(devlink, info);
+		if (IS_ERR(linecard)) {
+			err = PTR_ERR(linecard);
+			goto unlock;
+		}
+		info->user_ptr[1] = linecard;
 	}
 	return 0;
 
@@ -1136,6 +1185,121 @@ static int devlink_nl_cmd_port_unsplit_doit(struct sk_buff *skb,
 	return devlink_port_unsplit(devlink, port_index, info->extack);
 }
 
+static int devlink_nl_linecard_fill(struct sk_buff *msg,
+				    struct devlink *devlink,
+				    struct devlink_linecard *linecard,
+				    enum devlink_command cmd, u32 portid,
+				    u32 seq, int flags,
+				    struct netlink_ext_ack *extack)
+{
+	void *hdr;
+
+	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (devlink_nl_put_handle(msg, devlink))
+		goto nla_put_failure;
+	if (nla_put_u32(msg, DEVLINK_ATTR_LINECARD_INDEX, linecard->index))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+	return 0;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
+static void devlink_linecard_notify(struct devlink_linecard *linecard,
+				    enum devlink_command cmd)
+{
+	struct devlink *devlink = linecard->devlink;
+	struct sk_buff *msg;
+	int err;
+
+	WARN_ON(cmd != DEVLINK_CMD_LINECARD_NEW &&
+		cmd != DEVLINK_CMD_LINECARD_DEL);
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	err = devlink_nl_linecard_fill(msg, devlink, linecard, cmd, 0, 0, 0,
+				       NULL);
+	if (err) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink),
+				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
+}
+
+static int devlink_nl_cmd_linecard_get_doit(struct sk_buff *skb,
+					    struct genl_info *info)
+{
+	struct devlink_linecard *linecard = info->user_ptr[1];
+	struct devlink *devlink = linecard->devlink;
+	struct sk_buff *msg;
+	int err;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	err = devlink_nl_linecard_fill(msg, devlink, linecard,
+				       DEVLINK_CMD_LINECARD_NEW,
+				       info->snd_portid, info->snd_seq, 0,
+				       info->extack);
+	if (err) {
+		nlmsg_free(msg);
+		return err;
+	}
+
+	return genlmsg_reply(msg, info);
+}
+
+static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
+					      struct netlink_callback *cb)
+{
+	struct devlink_linecard *linecard;
+	struct devlink *devlink;
+	int start = cb->args[0];
+	int idx = 0;
+	int err;
+
+	mutex_lock(&devlink_mutex);
+	list_for_each_entry(devlink, &devlink_list, list) {
+		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
+			continue;
+		mutex_lock(&devlink->lock);
+		list_for_each_entry(linecard, &devlink->linecard_list, list) {
+			if (idx < start) {
+				idx++;
+				continue;
+			}
+			err = devlink_nl_linecard_fill(msg, devlink, linecard,
+						       DEVLINK_CMD_LINECARD_NEW,
+						       NETLINK_CB(cb->skb).portid,
+						       cb->nlh->nlmsg_seq,
+						       NLM_F_MULTI,
+						       cb->extack);
+			if (err) {
+				mutex_unlock(&devlink->lock);
+				goto out;
+			}
+			idx++;
+		}
+		mutex_unlock(&devlink->lock);
+	}
+out:
+	mutex_unlock(&devlink_mutex);
+
+	cb->args[0] = idx;
+	return msg->len;
+}
+
 static int devlink_nl_sb_fill(struct sk_buff *msg, struct devlink *devlink,
 			      struct devlink_sb *devlink_sb,
 			      enum devlink_command cmd, u32 portid,
@@ -7594,6 +7758,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_RELOAD_ACTION] = NLA_POLICY_RANGE(NLA_U8, DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
 							DEVLINK_RELOAD_ACTION_MAX),
 	[DEVLINK_ATTR_RELOAD_LIMITS] = NLA_POLICY_BITFIELD32(DEVLINK_RELOAD_LIMITS_VALID_MASK),
+	[DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
 };
 
 static const struct genl_small_ops devlink_nl_ops[] = {
@@ -7633,6 +7798,14 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
 	},
+	{
+		.cmd = DEVLINK_CMD_LINECARD_GET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = devlink_nl_cmd_linecard_get_doit,
+		.dumpit = devlink_nl_cmd_linecard_get_dumpit,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_LINECARD,
+		/* can be retrieved by unprivileged users */
+	},
 	{
 		.cmd = DEVLINK_CMD_SB_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -7982,6 +8155,7 @@ struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size)
 	xa_init_flags(&devlink->snapshot_ids, XA_FLAGS_ALLOC);
 	__devlink_net_set(devlink, &init_net);
 	INIT_LIST_HEAD(&devlink->port_list);
+	INIT_LIST_HEAD(&devlink->linecard_list);
 	INIT_LIST_HEAD(&devlink->sb_list);
 	INIT_LIST_HEAD_RCU(&devlink->dpipe_table_list);
 	INIT_LIST_HEAD(&devlink->resource_list);
@@ -8084,6 +8258,7 @@ void devlink_free(struct devlink *devlink)
 	WARN_ON(!list_empty(&devlink->resource_list));
 	WARN_ON(!list_empty(&devlink->dpipe_table_list));
 	WARN_ON(!list_empty(&devlink->sb_list));
+	WARN_ON(!list_empty(&devlink->linecard_list));
 	WARN_ON(!list_empty(&devlink->port_list));
 
 	xa_destroy(&devlink->snapshot_ids);
@@ -8428,6 +8603,56 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 	return 0;
 }
 
+/**
+ *	devlink_linecard_create - Create devlink linecard
+ *
+ *	@devlink: devlink
+ *	@devlink_linecard: devlink linecard
+ *	@linecard_index: driver-specific numerical identifier of the linecard
+ *
+ *	Create devlink linecard instance with provided linecard index.
+ *	Caller can use any indexing, even hw-related one.
+ */
+struct devlink_linecard *devlink_linecard_create(struct devlink *devlink,
+						 unsigned int linecard_index)
+{
+	struct devlink_linecard *linecard;
+
+	mutex_lock(&devlink->lock);
+	if (devlink_linecard_index_exists(devlink, linecard_index)) {
+		mutex_unlock(&devlink->lock);
+		return ERR_PTR(-EEXIST);
+	}
+
+	linecard = kzalloc(sizeof(*linecard), GFP_KERNEL);
+	if (!linecard)
+		return ERR_PTR(-ENOMEM);
+
+	linecard->devlink = devlink;
+	linecard->index = linecard_index;
+	list_add_tail(&linecard->list, &devlink->linecard_list);
+	mutex_unlock(&devlink->lock);
+	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
+	return linecard;
+}
+EXPORT_SYMBOL_GPL(devlink_linecard_create);
+
+/**
+ *	devlink_linecard_destroy - Destroy devlink linecard
+ *
+ *	@devlink_linecard: devlink linecard
+ */
+void devlink_linecard_destroy(struct devlink_linecard *linecard)
+{
+	struct devlink *devlink = linecard->devlink;
+
+	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_DEL);
+	mutex_lock(&devlink->lock);
+	list_del(&linecard->list);
+	mutex_unlock(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devlink_linecard_destroy);
+
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
-- 
2.26.2

