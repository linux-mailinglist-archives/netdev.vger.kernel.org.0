Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3572FFF89
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 10:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbhAVJuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 04:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727128AbhAVJrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 04:47:51 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9AE3C061356
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:46:53 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id 190so3721110wmz.0
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sS0QldToSTXte0Df+rAgEJxB2PEFjKwYcDLQbVqdlYM=;
        b=gkT7du3xI5w0X5BDT20QT9Ox+aW/xXb1D1YIvZnGMKlhSrJJZ4Wa5AcS6wQGej4XSw
         U4lUzOhVy9l+Ceh8Sf7aCk0Af5R4V44tqP710YPgc5nOquSxFIBSXq3lWd/fEpymRR4Y
         WsxF7FMuVa0AsEsb5YSx65FMBzGo2SwukX+LPAR0mP/nB153OZOJGMS/WRd7CiYumo3j
         6wdpNZIswJse2Xqr8HgXSti87vKcuFs0rphzyXw0J6lo/gHypk8XiEOE+8SJJDaL6j+P
         +pnzHmaTynJi2wVPyXmnlGEaVqHHeQipj2hFHuAl1u+ovyZh9yjTEN20YyboEr1VvPvZ
         IZzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sS0QldToSTXte0Df+rAgEJxB2PEFjKwYcDLQbVqdlYM=;
        b=EXql5BzkgyagJ56mSnoCro+pNGypf9dWW7vW502CmbJVYZXwWzkKNmzVH/lv7YKDww
         wAgpH7dqoxwl3ia/Timf+rEFX9mABqYi5m+yogBrskVy5Vhflm8JGIoWRgdECW0DgG7r
         6luixMHZx8FMmel2UK9k7WpESih8BpqumFCCogCCV5Tx9k7Y0Dm6oPhoGPAn7JFJzu1A
         6GGoVyQvNoeKXhVn6FKmwJzk/khJAbqn2bdf19Z1CeBtajPAd6ICemunloC6GF1rPmPR
         3nSdyjCd6x2+0tNNmoGiFD+/OdT26QLR7mBt8nLplnheVs+PyHTrGcROe+fuwVx98TD3
         pfXw==
X-Gm-Message-State: AOAM532ygSPpIrYMM+4rhTgZV/PAivleSt54nNQKqMGr/cAL00S3gIUS
        BIXP6bA6Xt9IQ5rBq8qmdtpDft0FygosDIrPj8Q=
X-Google-Smtp-Source: ABdhPJzbRjApcsBQfQNEnlWp+Xb0eFwqQ+qRK37/aR9vON64jTvUdj3tQ50/C6yDOIvPBq/LABw10w==
X-Received: by 2002:a1c:1dc2:: with SMTP id d185mr3084850wmd.175.1611308812158;
        Fri, 22 Jan 2021 01:46:52 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id 62sm11416038wmd.34.2021.01.22.01.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 01:46:51 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jacob.e.keller@intel.com,
        roopa@nvidia.com, andrew@lunn.ch, dsahern@gmail.com,
        mlxsw@nvidia.com
Subject: [patch net-next RFCv2 02/10] devlink: implement line card provisioning
Date:   Fri, 22 Jan 2021 10:46:40 +0100
Message-Id: <20210122094648.1631078-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122094648.1631078-1-jiri@resnulli.us>
References: <20210122094648.1631078-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

In order to be able to configure all needed stuff on a port/netdevice
of a line card without the line card being present, introduce line card
provisioning. Basically by setting a type, provisioning process will
start and driver is supposed to create a placeholder for instances
(ports/netdevices) for a line card type.

Allow the user to query the supported line card types over line card
get command. Then implement two netlink command SET to allow user to
set/unset the card type.

On the driver API side, add provision/unprovision ops and supported
types array to be advertised. Upon provision op call, the driver should
take care of creating the instances for the particular line card type.
Introduce provision_set/clear() functions to be called by the driver
once the provisioning/unprovisioning is done on its side. These helpers
are not to be called directly due to the async nature of provisioning.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->RFCv2:
- added missed const to supported_types
- converted provision/unprovision commands to SET.type command
- adjusted the patch description a bit
- added state "provisioning_failed" and a helper to set it from driver
---
 include/net/devlink.h        |  32 ++++++-
 include/uapi/linux/devlink.h |  15 +++
 net/core/devlink.c           | 177 ++++++++++++++++++++++++++++++++++-
 3 files changed, 220 insertions(+), 4 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 67c2547d5ef9..bca3b2fc180a 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -139,10 +139,33 @@ struct devlink_port {
 	struct mutex reporters_lock; /* Protects reporter_list */
 };
 
+struct devlink_linecard_ops;
+
 struct devlink_linecard {
 	struct list_head list;
 	struct devlink *devlink;
 	unsigned int index;
+	const struct devlink_linecard_ops *ops;
+	void *priv;
+	enum devlink_linecard_state state;
+	const char *type;
+};
+
+/**
+ * struct devlink_linecard_ops - Linecard operations
+ * @supported_types: array of supported types of linecards
+ * @supported_types_count: number of elements in the array above
+ * @provision: callback to provision the linecard slot with certain
+ *	       type of linecard
+ * @unprovision: callback to unprovision the linecard slot
+ */
+struct devlink_linecard_ops {
+	const char * const *supported_types;
+	unsigned int supported_types_count;
+	int (*provision)(struct devlink_linecard *linecard, void *priv,
+			 u32 type_index, struct netlink_ext_ack *extack);
+	int (*unprovision)(struct devlink_linecard *linecard, void *priv,
+			   struct netlink_ext_ack *extack);
 };
 
 struct devlink_sb_pool_info {
@@ -1414,9 +1437,14 @@ void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u32 contro
 				   u16 pf, bool external);
 void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 controller,
 				   u16 pf, u16 vf, bool external);
-struct devlink_linecard *devlink_linecard_create(struct devlink *devlink,
-						 unsigned int linecard_index);
+struct devlink_linecard *
+devlink_linecard_create(struct devlink *devlink, unsigned int linecard_index,
+			const struct devlink_linecard_ops *ops, void *priv);
 void devlink_linecard_destroy(struct devlink_linecard *linecard);
+void devlink_linecard_provision_set(struct devlink_linecard *linecard,
+				    u32 type_index);
+void devlink_linecard_provision_clear(struct devlink_linecard *linecard);
+void devlink_linecard_provision_fail(struct devlink_linecard *linecard);
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index e5ed0522591f..24091391fa89 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -329,6 +329,18 @@ enum devlink_reload_limit {
 
 #define DEVLINK_RELOAD_LIMITS_VALID_MASK (_BITUL(__DEVLINK_RELOAD_LIMIT_MAX) - 1)
 
+enum devlink_linecard_state {
+	DEVLINK_LINECARD_STATE_UNSPEC,
+	DEVLINK_LINECARD_STATE_UNPROVISIONED,
+	DEVLINK_LINECARD_STATE_UNPROVISIONING,
+	DEVLINK_LINECARD_STATE_PROVISIONING,
+	DEVLINK_LINECARD_STATE_PROVISIONING_FAILED,
+	DEVLINK_LINECARD_STATE_PROVISIONED,
+
+	__DEVLINK_LINECARD_STATE_MAX,
+	DEVLINK_LINECARD_STATE_MAX = __DEVLINK_LINECARD_STATE_MAX - 1
+};
+
 enum devlink_attr {
 	/* don't change the order or add anything between, this is ABI! */
 	DEVLINK_ATTR_UNSPEC,
@@ -535,6 +547,9 @@ enum devlink_attr {
 	DEVLINK_ATTR_RELOAD_ACTION_STATS,       /* nested */
 
 	DEVLINK_ATTR_LINECARD_INDEX,		/* u32 */
+	DEVLINK_ATTR_LINECARD_STATE,		/* u8 */
+	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
+	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 70154bed9950..2ff950da3417 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1192,7 +1192,9 @@ static int devlink_nl_linecard_fill(struct sk_buff *msg,
 				    u32 seq, int flags,
 				    struct netlink_ext_ack *extack)
 {
+	struct nlattr *attr;
 	void *hdr;
+	int i;
 
 	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
 	if (!hdr)
@@ -1202,6 +1204,21 @@ static int devlink_nl_linecard_fill(struct sk_buff *msg,
 		goto nla_put_failure;
 	if (nla_put_u32(msg, DEVLINK_ATTR_LINECARD_INDEX, linecard->index))
 		goto nla_put_failure;
+	if (nla_put_u8(msg, DEVLINK_ATTR_LINECARD_STATE, linecard->state))
+		goto nla_put_failure;
+	if (linecard->state >= DEVLINK_LINECARD_STATE_PROVISIONED &&
+	    nla_put_string(msg, DEVLINK_ATTR_LINECARD_TYPE, linecard->type))
+		goto nla_put_failure;
+
+	attr = nla_nest_start(msg, DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES);
+	if (!attr)
+		return -EMSGSIZE;
+	for (i = 0; i < linecard->ops->supported_types_count; i++) {
+		if (nla_put_string(msg, DEVLINK_ATTR_LINECARD_TYPE,
+				   linecard->ops->supported_types[i]))
+			goto nla_put_failure;
+	}
+	nla_nest_end(msg, attr);
 
 	genlmsg_end(msg, hdr);
 	return 0;
@@ -1300,6 +1317,95 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 	return msg->len;
 }
 
+static int devlink_linecard_type_set(struct devlink_linecard *linecard,
+				     const char *type,
+				     struct netlink_ext_ack *extack)
+{
+	int i;
+
+	if (linecard->state == DEVLINK_LINECARD_STATE_PROVISIONING) {
+		NL_SET_ERR_MSG_MOD(extack, "Linecard is currently being provisioned");
+		return -EBUSY;
+	}
+	if (linecard->state == DEVLINK_LINECARD_STATE_UNPROVISIONING) {
+		NL_SET_ERR_MSG_MOD(extack, "Linecard is currently being unprovisioned");
+		return -EBUSY;
+	}
+	if (linecard->state != DEVLINK_LINECARD_STATE_UNPROVISIONED &&
+	    linecard->state != DEVLINK_LINECARD_STATE_PROVISIONING_FAILED) {
+		NL_SET_ERR_MSG_MOD(extack, "Linecard already provisioned");
+		return -EBUSY;
+	}
+
+	for (i = 0; i < linecard->ops->supported_types_count; i++) {
+		if (!strcmp(linecard->ops->supported_types[i], type)) {
+			linecard->state = DEVLINK_LINECARD_STATE_PROVISIONING;
+			linecard->type = linecard->ops->supported_types[i];
+			devlink_linecard_notify(linecard,
+						DEVLINK_CMD_LINECARD_NEW);
+			return linecard->ops->provision(linecard,
+							linecard->priv, i,
+							extack);
+		}
+	}
+	NL_SET_ERR_MSG_MOD(extack, "Unsupported provision type provided");
+	return -EINVAL;
+}
+
+static int devlink_linecard_type_unset(struct devlink_linecard *linecard,
+				       struct netlink_ext_ack *extack)
+{
+	if (linecard->state == DEVLINK_LINECARD_STATE_PROVISIONING) {
+		NL_SET_ERR_MSG_MOD(extack, "Linecard is currently being provisioned");
+		return -EBUSY;
+	}
+	if (linecard->state == DEVLINK_LINECARD_STATE_UNPROVISIONING) {
+		NL_SET_ERR_MSG_MOD(extack, "Linecard is currently being unprovisioned");
+		return -EBUSY;
+	}
+	if (linecard->state == DEVLINK_LINECARD_STATE_PROVISIONING_FAILED) {
+		linecard->state = DEVLINK_LINECARD_STATE_UNPROVISIONED;
+		linecard->type = NULL;
+		devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
+		return 0;
+	}
+
+	if (linecard->state == DEVLINK_LINECARD_STATE_UNPROVISIONED) {
+		NL_SET_ERR_MSG_MOD(extack, "Linecard is not provisioned");
+		return -EOPNOTSUPP;
+	}
+	linecard->state = DEVLINK_LINECARD_STATE_UNPROVISIONING;
+	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
+	return linecard->ops->unprovision(linecard, linecard->priv,
+					  extack);
+}
+
+
+static int devlink_nl_cmd_linecard_set_doit(struct sk_buff *skb,
+					    struct genl_info *info)
+{
+	struct devlink_linecard *linecard = info->user_ptr[1];
+	struct netlink_ext_ack *extack = info->extack;
+	int err;
+
+	if (info->attrs[DEVLINK_ATTR_LINECARD_TYPE]) {
+		const char *type;
+
+		type = nla_data(info->attrs[DEVLINK_ATTR_LINECARD_TYPE]);
+		if (strcmp(type, "")) {
+			err = devlink_linecard_type_set(linecard, type, extack);
+			if (err)
+				return err;
+		} else {
+			err = devlink_linecard_type_unset(linecard, extack);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
+
 static int devlink_nl_sb_fill(struct sk_buff *msg, struct devlink *devlink,
 			      struct devlink_sb *devlink_sb,
 			      enum devlink_command cmd, u32 portid,
@@ -7759,6 +7865,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 							DEVLINK_RELOAD_ACTION_MAX),
 	[DEVLINK_ATTR_RELOAD_LIMITS] = NLA_POLICY_BITFIELD32(DEVLINK_RELOAD_LIMITS_VALID_MASK),
 	[DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
 };
 
 static const struct genl_small_ops devlink_nl_ops[] = {
@@ -7806,6 +7913,13 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.internal_flags = DEVLINK_NL_FLAG_NEED_LINECARD,
 		/* can be retrieved by unprivileged users */
 	},
+	{
+		.cmd = DEVLINK_CMD_LINECARD_SET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = devlink_nl_cmd_linecard_set_doit,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_LINECARD,
+	},
 	{
 		.cmd = DEVLINK_CMD_SB_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -8613,11 +8727,17 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
  *	Create devlink linecard instance with provided linecard index.
  *	Caller can use any indexing, even hw-related one.
  */
-struct devlink_linecard *devlink_linecard_create(struct devlink *devlink,
-						 unsigned int linecard_index)
+struct devlink_linecard *
+devlink_linecard_create(struct devlink *devlink, unsigned int linecard_index,
+			const struct devlink_linecard_ops *ops, void *priv)
 {
 	struct devlink_linecard *linecard;
 
+	if (WARN_ON(!ops || !ops->supported_types ||
+		    !ops->supported_types_count ||
+		    !ops->provision || !ops->unprovision))
+		return ERR_PTR(-EINVAL);
+
 	mutex_lock(&devlink->lock);
 	if (devlink_linecard_index_exists(devlink, linecard_index)) {
 		mutex_unlock(&devlink->lock);
@@ -8630,6 +8750,9 @@ struct devlink_linecard *devlink_linecard_create(struct devlink *devlink,
 
 	linecard->devlink = devlink;
 	linecard->index = linecard_index;
+	linecard->ops = ops;
+	linecard->priv = priv;
+	linecard->state = DEVLINK_LINECARD_STATE_UNPROVISIONED;
 	list_add_tail(&linecard->list, &devlink->linecard_list);
 	mutex_unlock(&devlink->lock);
 	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
@@ -8653,6 +8776,56 @@ void devlink_linecard_destroy(struct devlink_linecard *linecard)
 }
 EXPORT_SYMBOL_GPL(devlink_linecard_destroy);
 
+/**
+ *	devlink_linecard_provision_set - Set provisioning on linecard
+ *
+ *	@devlink_linecard: devlink linecard
+ *	@type_index: index of the linecard type (in array of types in ops)
+ */
+void devlink_linecard_provision_set(struct devlink_linecard *linecard,
+				    u32 type_index)
+{
+	WARN_ON(type_index >= linecard->ops->supported_types_count);
+	mutex_lock(&linecard->devlink->lock);
+	WARN_ON(linecard->type &&
+		linecard->type != linecard->ops->supported_types[type_index]);
+	linecard->state = DEVLINK_LINECARD_STATE_PROVISIONED;
+	linecard->type = linecard->ops->supported_types[type_index];
+	mutex_unlock(&linecard->devlink->lock);
+	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
+
+}
+EXPORT_SYMBOL_GPL(devlink_linecard_provision_set);
+
+/**
+ *	devlink_linecard_provision_clear - Clear provisioning on linecard
+ *
+ *	@devlink_linecard: devlink linecard
+ */
+void devlink_linecard_provision_clear(struct devlink_linecard *linecard)
+{
+	mutex_lock(&linecard->devlink->lock);
+	linecard->state = DEVLINK_LINECARD_STATE_UNPROVISIONED;
+	linecard->type = NULL;
+	mutex_unlock(&linecard->devlink->lock);
+	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
+}
+EXPORT_SYMBOL_GPL(devlink_linecard_provision_clear);
+
+/**
+ *	devlink_linecard_provision_fail - Fail provisioning on linecard
+ *
+ *	@devlink_linecard: devlink linecard
+ */
+void devlink_linecard_provision_fail(struct devlink_linecard *linecard)
+{
+	mutex_lock(&linecard->devlink->lock);
+	linecard->state = DEVLINK_LINECARD_STATE_PROVISIONING_FAILED;
+	mutex_unlock(&linecard->devlink->lock);
+	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
+}
+EXPORT_SYMBOL_GPL(devlink_linecard_provision_fail);
+
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
-- 
2.26.2

