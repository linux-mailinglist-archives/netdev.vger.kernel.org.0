Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1507064D52D
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 03:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiLOCCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 21:02:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiLOCCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 21:02:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3562ED6D
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 18:02:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76BE4B81AD6
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 02:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFA9C43392;
        Thu, 15 Dec 2022 02:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671069724;
        bh=rYaAImiSA+dtp2M63DDNorIp6oRzQbehSJk4AF6N9/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f0W4xaAIWNLUeBTUke4agJGD34ni9K4lB6tMmURJ1zHvDFJ4dl80zpeANocHDW1Ws
         IZGCNp7krmBM7dgrqWqL5fwaGSwLmhb6Dj2bhQbz/ypBCqZgYHrCyWb/mgd7RpDw2g
         mUv/1wx+iL50rF3VKlVfjeetzGcjK1t/tOYQsc1sb2xdqA4XodAT8XJ2UyKF/n9Eq7
         bDVEQAi4iJjbqM5dMszg4EtjmfXK9uBVMBG9bk0yDwf6oZNB0CCRuwCTh4PrEizB8W
         G0jYQKajUOck2ZEbjPI9DaaZINutvsktoeHsUYvAl63Agg4/FYxPQiNy3Hv5SUzL6U
         ErCTEgjCqRubA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, jacob.e.keller@intel.com, leon@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 03/15] devlink: split out netlink code
Date:   Wed, 14 Dec 2022 18:01:43 -0800
Message-Id: <20221215020155.1619839-4-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221215020155.1619839-1-kuba@kernel.org>
References: <20221215020155.1619839-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move out the netlink glue into a separate file.
Leave the ops in the old file because we'd have to export a ton
of functions. Going forward we should switch to split ops which
will let us to put the new ops in the netlink.c file.

Pure code move, no functional changes.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/Makefile        |   2 +-
 net/devlink/basic.c         | 212 ++----------------------------------
 net/devlink/devl_internal.h |  31 ++++++
 net/devlink/netlink.c       | 195 +++++++++++++++++++++++++++++++++
 4 files changed, 235 insertions(+), 205 deletions(-)
 create mode 100644 net/devlink/netlink.c

diff --git a/net/devlink/Makefile b/net/devlink/Makefile
index 425532776929..d8ad2d6af002 100644
--- a/net/devlink/Makefile
+++ b/net/devlink/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-y := basic.o core.o
+obj-y := basic.o core.o netlink.o
diff --git a/net/devlink/basic.c b/net/devlink/basic.c
index 3c53a742f472..4b0938a1854e 100644
--- a/net/devlink/basic.c
+++ b/net/devlink/basic.c
@@ -148,30 +148,6 @@ static const struct nla_policy devlink_selftest_nl_policy[DEVLINK_ATTR_SELFTEST_
 	[DEVLINK_ATTR_SELFTEST_ID_FLASH] = { .type = NLA_FLAG },
 };
 
-static struct devlink *devlink_get_from_attrs(struct net *net,
-					      struct nlattr **attrs)
-{
-	struct devlink *devlink;
-	unsigned long index;
-	char *busname;
-	char *devname;
-
-	if (!attrs[DEVLINK_ATTR_BUS_NAME] || !attrs[DEVLINK_ATTR_DEV_NAME])
-		return ERR_PTR(-EINVAL);
-
-	busname = nla_data(attrs[DEVLINK_ATTR_BUS_NAME]);
-	devname = nla_data(attrs[DEVLINK_ATTR_DEV_NAME]);
-
-	devlinks_xa_for_each_registered_get(net, index, devlink) {
-		if (strcmp(devlink->dev->bus->name, busname) == 0 &&
-		    strcmp(dev_name(devlink->dev), devname) == 0)
-			return devlink;
-		devlink_put(devlink);
-	}
-
-	return ERR_PTR(-ENODEV);
-}
-
 #define ASSERT_DEVLINK_PORT_REGISTERED(devlink_port)				\
 	WARN_ON_ONCE(!(devlink_port)->registered)
 #define ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port)			\
@@ -200,8 +176,8 @@ static struct devlink_port *devlink_port_get_from_attrs(struct devlink *devlink,
 	return ERR_PTR(-EINVAL);
 }
 
-static struct devlink_port *devlink_port_get_from_info(struct devlink *devlink,
-						       struct genl_info *info)
+struct devlink_port *devlink_port_get_from_info(struct devlink *devlink,
+						struct genl_info *info)
 {
 	return devlink_port_get_from_attrs(devlink, info->attrs);
 }
@@ -261,13 +237,13 @@ devlink_rate_node_get_from_attrs(struct devlink *devlink, struct nlattr **attrs)
 	return devlink_rate_node_get_by_name(devlink, rate_node_name);
 }
 
-static struct devlink_rate *
+struct devlink_rate *
 devlink_rate_node_get_from_info(struct devlink *devlink, struct genl_info *info)
 {
 	return devlink_rate_node_get_from_attrs(devlink, info->attrs);
 }
 
-static struct devlink_rate *
+struct devlink_rate *
 devlink_rate_get_from_info(struct devlink *devlink, struct genl_info *info)
 {
 	struct nlattr **attrs = info->attrs;
@@ -318,13 +294,13 @@ devlink_linecard_get_from_attrs(struct devlink *devlink, struct nlattr **attrs)
 	return ERR_PTR(-EINVAL);
 }
 
-static struct devlink_linecard *
+struct devlink_linecard *
 devlink_linecard_get_from_info(struct devlink *devlink, struct genl_info *info)
 {
 	return devlink_linecard_get_from_attrs(devlink, info->attrs);
 }
 
-static void devlink_linecard_put(struct devlink_linecard *linecard)
+void devlink_linecard_put(struct devlink_linecard *linecard)
 {
 	if (refcount_dec_and_test(&linecard->refcount)) {
 		mutex_destroy(&linecard->state_lock);
@@ -633,93 +609,6 @@ devlink_region_snapshot_get_by_id(struct devlink_region *region, u32 id)
 	return NULL;
 }
 
-#define DEVLINK_NL_FLAG_NEED_PORT		BIT(0)
-#define DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT	BIT(1)
-#define DEVLINK_NL_FLAG_NEED_RATE		BIT(2)
-#define DEVLINK_NL_FLAG_NEED_RATE_NODE		BIT(3)
-#define DEVLINK_NL_FLAG_NEED_LINECARD		BIT(4)
-
-static int devlink_nl_pre_doit(const struct genl_split_ops *ops,
-			       struct sk_buff *skb, struct genl_info *info)
-{
-	struct devlink_linecard *linecard;
-	struct devlink_port *devlink_port;
-	struct devlink *devlink;
-	int err;
-
-	devlink = devlink_get_from_attrs(genl_info_net(info), info->attrs);
-	if (IS_ERR(devlink))
-		return PTR_ERR(devlink);
-	devl_lock(devlink);
-	info->user_ptr[0] = devlink;
-	if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_PORT) {
-		devlink_port = devlink_port_get_from_info(devlink, info);
-		if (IS_ERR(devlink_port)) {
-			err = PTR_ERR(devlink_port);
-			goto unlock;
-		}
-		info->user_ptr[1] = devlink_port;
-	} else if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT) {
-		devlink_port = devlink_port_get_from_info(devlink, info);
-		if (!IS_ERR(devlink_port))
-			info->user_ptr[1] = devlink_port;
-	} else if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_RATE) {
-		struct devlink_rate *devlink_rate;
-
-		devlink_rate = devlink_rate_get_from_info(devlink, info);
-		if (IS_ERR(devlink_rate)) {
-			err = PTR_ERR(devlink_rate);
-			goto unlock;
-		}
-		info->user_ptr[1] = devlink_rate;
-	} else if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_RATE_NODE) {
-		struct devlink_rate *rate_node;
-
-		rate_node = devlink_rate_node_get_from_info(devlink, info);
-		if (IS_ERR(rate_node)) {
-			err = PTR_ERR(rate_node);
-			goto unlock;
-		}
-		info->user_ptr[1] = rate_node;
-	} else if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_LINECARD) {
-		linecard = devlink_linecard_get_from_info(devlink, info);
-		if (IS_ERR(linecard)) {
-			err = PTR_ERR(linecard);
-			goto unlock;
-		}
-		info->user_ptr[1] = linecard;
-	}
-	return 0;
-
-unlock:
-	devl_unlock(devlink);
-	devlink_put(devlink);
-	return err;
-}
-
-static void devlink_nl_post_doit(const struct genl_split_ops *ops,
-				 struct sk_buff *skb, struct genl_info *info)
-{
-	struct devlink_linecard *linecard;
-	struct devlink *devlink;
-
-	devlink = info->user_ptr[0];
-	if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_LINECARD) {
-		linecard = info->user_ptr[1];
-		devlink_linecard_put(linecard);
-	}
-	devl_unlock(devlink);
-	devlink_put(devlink);
-}
-
-enum devlink_multicast_groups {
-	DEVLINK_MCGRP_CONFIG,
-};
-
-static const struct genl_multicast_group devlink_nl_mcgrps[] = {
-	[DEVLINK_MCGRP_CONFIG] = { .name = DEVLINK_GENL_MCGRP_CONFIG_NAME },
-};
-
 static int devlink_nl_put_handle(struct sk_buff *msg, struct devlink *devlink)
 {
 	if (nla_put_string(msg, DEVLINK_ATTR_BUS_NAME, devlink->dev->bus->name))
@@ -9231,76 +9120,7 @@ static int devlink_nl_cmd_trap_policer_set_doit(struct sk_buff *skb,
 	return devlink_trap_policer_set(devlink, policer_item, info);
 }
 
-static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
-	[DEVLINK_ATTR_UNSPEC] = { .strict_start_type =
-		DEVLINK_ATTR_TRAP_POLICER_ID },
-	[DEVLINK_ATTR_BUS_NAME] = { .type = NLA_NUL_STRING },
-	[DEVLINK_ATTR_DEV_NAME] = { .type = NLA_NUL_STRING },
-	[DEVLINK_ATTR_PORT_INDEX] = { .type = NLA_U32 },
-	[DEVLINK_ATTR_PORT_TYPE] = NLA_POLICY_RANGE(NLA_U16, DEVLINK_PORT_TYPE_AUTO,
-						    DEVLINK_PORT_TYPE_IB),
-	[DEVLINK_ATTR_PORT_SPLIT_COUNT] = { .type = NLA_U32 },
-	[DEVLINK_ATTR_SB_INDEX] = { .type = NLA_U32 },
-	[DEVLINK_ATTR_SB_POOL_INDEX] = { .type = NLA_U16 },
-	[DEVLINK_ATTR_SB_POOL_TYPE] = { .type = NLA_U8 },
-	[DEVLINK_ATTR_SB_POOL_SIZE] = { .type = NLA_U32 },
-	[DEVLINK_ATTR_SB_POOL_THRESHOLD_TYPE] = { .type = NLA_U8 },
-	[DEVLINK_ATTR_SB_THRESHOLD] = { .type = NLA_U32 },
-	[DEVLINK_ATTR_SB_TC_INDEX] = { .type = NLA_U16 },
-	[DEVLINK_ATTR_ESWITCH_MODE] = NLA_POLICY_RANGE(NLA_U16, DEVLINK_ESWITCH_MODE_LEGACY,
-						       DEVLINK_ESWITCH_MODE_SWITCHDEV),
-	[DEVLINK_ATTR_ESWITCH_INLINE_MODE] = { .type = NLA_U8 },
-	[DEVLINK_ATTR_ESWITCH_ENCAP_MODE] = { .type = NLA_U8 },
-	[DEVLINK_ATTR_DPIPE_TABLE_NAME] = { .type = NLA_NUL_STRING },
-	[DEVLINK_ATTR_DPIPE_TABLE_COUNTERS_ENABLED] = { .type = NLA_U8 },
-	[DEVLINK_ATTR_RESOURCE_ID] = { .type = NLA_U64},
-	[DEVLINK_ATTR_RESOURCE_SIZE] = { .type = NLA_U64},
-	[DEVLINK_ATTR_PARAM_NAME] = { .type = NLA_NUL_STRING },
-	[DEVLINK_ATTR_PARAM_TYPE] = { .type = NLA_U8 },
-	[DEVLINK_ATTR_PARAM_VALUE_CMODE] = { .type = NLA_U8 },
-	[DEVLINK_ATTR_REGION_NAME] = { .type = NLA_NUL_STRING },
-	[DEVLINK_ATTR_REGION_SNAPSHOT_ID] = { .type = NLA_U32 },
-	[DEVLINK_ATTR_REGION_CHUNK_ADDR] = { .type = NLA_U64 },
-	[DEVLINK_ATTR_REGION_CHUNK_LEN] = { .type = NLA_U64 },
-	[DEVLINK_ATTR_HEALTH_REPORTER_NAME] = { .type = NLA_NUL_STRING },
-	[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD] = { .type = NLA_U64 },
-	[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER] = { .type = NLA_U8 },
-	[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME] = { .type = NLA_NUL_STRING },
-	[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT] = { .type = NLA_NUL_STRING },
-	[DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK] =
-		NLA_POLICY_BITFIELD32(DEVLINK_SUPPORTED_FLASH_OVERWRITE_SECTIONS),
-	[DEVLINK_ATTR_TRAP_NAME] = { .type = NLA_NUL_STRING },
-	[DEVLINK_ATTR_TRAP_ACTION] = { .type = NLA_U8 },
-	[DEVLINK_ATTR_TRAP_GROUP_NAME] = { .type = NLA_NUL_STRING },
-	[DEVLINK_ATTR_NETNS_PID] = { .type = NLA_U32 },
-	[DEVLINK_ATTR_NETNS_FD] = { .type = NLA_U32 },
-	[DEVLINK_ATTR_NETNS_ID] = { .type = NLA_U32 },
-	[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP] = { .type = NLA_U8 },
-	[DEVLINK_ATTR_TRAP_POLICER_ID] = { .type = NLA_U32 },
-	[DEVLINK_ATTR_TRAP_POLICER_RATE] = { .type = NLA_U64 },
-	[DEVLINK_ATTR_TRAP_POLICER_BURST] = { .type = NLA_U64 },
-	[DEVLINK_ATTR_PORT_FUNCTION] = { .type = NLA_NESTED },
-	[DEVLINK_ATTR_RELOAD_ACTION] = NLA_POLICY_RANGE(NLA_U8, DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
-							DEVLINK_RELOAD_ACTION_MAX),
-	[DEVLINK_ATTR_RELOAD_LIMITS] = NLA_POLICY_BITFIELD32(DEVLINK_RELOAD_LIMITS_VALID_MASK),
-	[DEVLINK_ATTR_PORT_FLAVOUR] = { .type = NLA_U16 },
-	[DEVLINK_ATTR_PORT_PCI_PF_NUMBER] = { .type = NLA_U16 },
-	[DEVLINK_ATTR_PORT_PCI_SF_NUMBER] = { .type = NLA_U32 },
-	[DEVLINK_ATTR_PORT_CONTROLLER_NUMBER] = { .type = NLA_U32 },
-	[DEVLINK_ATTR_RATE_TYPE] = { .type = NLA_U16 },
-	[DEVLINK_ATTR_RATE_TX_SHARE] = { .type = NLA_U64 },
-	[DEVLINK_ATTR_RATE_TX_MAX] = { .type = NLA_U64 },
-	[DEVLINK_ATTR_RATE_NODE_NAME] = { .type = NLA_NUL_STRING },
-	[DEVLINK_ATTR_RATE_PARENT_NODE_NAME] = { .type = NLA_NUL_STRING },
-	[DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
-	[DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
-	[DEVLINK_ATTR_SELFTESTS] = { .type = NLA_NESTED },
-	[DEVLINK_ATTR_RATE_TX_PRIORITY] = { .type = NLA_U32 },
-	[DEVLINK_ATTR_RATE_TX_WEIGHT] = { .type = NLA_U32 },
-	[DEVLINK_ATTR_REGION_DIRECT] = { .type = NLA_FLAG },
-};
-
-static const struct genl_small_ops devlink_nl_ops[] = {
+const struct genl_small_ops devlink_nl_ops[56] = {
 	{
 		.cmd = DEVLINK_CMD_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -9661,23 +9481,7 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.doit = devlink_nl_cmd_selftests_run,
 		.flags = GENL_ADMIN_PERM,
 	},
-};
-
-struct genl_family devlink_nl_family __ro_after_init = {
-	.name		= DEVLINK_GENL_NAME,
-	.version	= DEVLINK_GENL_VERSION,
-	.maxattr	= DEVLINK_ATTR_MAX,
-	.policy = devlink_nl_policy,
-	.netnsok	= true,
-	.parallel_ops	= true,
-	.pre_doit	= devlink_nl_pre_doit,
-	.post_doit	= devlink_nl_post_doit,
-	.module		= THIS_MODULE,
-	.small_ops	= devlink_nl_ops,
-	.n_small_ops	= ARRAY_SIZE(devlink_nl_ops),
-	.resv_start_op	= DEVLINK_CMD_SELFTESTS_RUN + 1,
-	.mcgrps		= devlink_nl_mcgrps,
-	.n_mcgrps	= ARRAY_SIZE(devlink_nl_mcgrps),
+	/* -- No new ops here! Use split ops going forward! -- */
 };
 
 bool devlink_reload_actions_valid(const struct devlink_ops *ops)
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 0cca1f92d733..bc7df9b0f775 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -97,6 +97,20 @@ devlinks_xa_find_get_next(struct net *net, unsigned long *indexp,
 			  xa_mark_t filter);
 
 /* Netlink */
+#define DEVLINK_NL_FLAG_NEED_PORT		BIT(0)
+#define DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT	BIT(1)
+#define DEVLINK_NL_FLAG_NEED_RATE		BIT(2)
+#define DEVLINK_NL_FLAG_NEED_RATE_NODE		BIT(3)
+#define DEVLINK_NL_FLAG_NEED_LINECARD		BIT(4)
+
+enum devlink_multicast_groups {
+	DEVLINK_MCGRP_CONFIG,
+};
+
+extern const struct genl_small_ops devlink_nl_ops[56];
+
+struct devlink *devlink_get_from_attrs(struct net *net, struct nlattr **attrs);
+
 void devlink_notify_unregister(struct devlink *devlink);
 void devlink_notify_register(struct devlink *devlink);
 
@@ -104,6 +118,9 @@ void devlink_notify_register(struct devlink *devlink);
 int devlink_port_netdevice_event(struct notifier_block *nb,
 				 unsigned long event, void *ptr);
 
+struct devlink_port *
+devlink_port_get_from_info(struct devlink *devlink, struct genl_info *info);
+
 /* Reload */
 bool devlink_reload_actions_valid(const struct devlink_ops *ops);
 int devlink_reload(struct devlink *devlink, struct net *dest_net,
@@ -115,3 +132,17 @@ static inline bool devlink_reload_supported(const struct devlink_ops *ops)
 {
 	return ops->reload_down && ops->reload_up;
 }
+
+/* Line cards */
+struct devlink_linecard;
+
+struct devlink_linecard *
+devlink_linecard_get_from_info(struct devlink *devlink, struct genl_info *info);
+void devlink_linecard_put(struct devlink_linecard *linecard);
+
+/* Rates */
+struct devlink_rate *
+devlink_rate_get_from_info(struct devlink *devlink, struct genl_info *info);
+struct devlink_rate *
+devlink_rate_node_get_from_info(struct devlink *devlink,
+				struct genl_info *info);
diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
new file mode 100644
index 000000000000..ce1a7d674d14
--- /dev/null
+++ b/net/devlink/netlink.c
@@ -0,0 +1,195 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2016 Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2016 Jiri Pirko <jiri@mellanox.com>
+ */
+
+#include <net/genetlink.h>
+
+#include "devl_internal.h"
+
+static const struct genl_multicast_group devlink_nl_mcgrps[] = {
+	[DEVLINK_MCGRP_CONFIG] = { .name = DEVLINK_GENL_MCGRP_CONFIG_NAME },
+};
+
+static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
+	[DEVLINK_ATTR_UNSPEC] = { .strict_start_type =
+		DEVLINK_ATTR_TRAP_POLICER_ID },
+	[DEVLINK_ATTR_BUS_NAME] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_DEV_NAME] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_PORT_INDEX] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_PORT_TYPE] = NLA_POLICY_RANGE(NLA_U16, DEVLINK_PORT_TYPE_AUTO,
+						    DEVLINK_PORT_TYPE_IB),
+	[DEVLINK_ATTR_PORT_SPLIT_COUNT] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_SB_INDEX] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_SB_POOL_INDEX] = { .type = NLA_U16 },
+	[DEVLINK_ATTR_SB_POOL_TYPE] = { .type = NLA_U8 },
+	[DEVLINK_ATTR_SB_POOL_SIZE] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_SB_POOL_THRESHOLD_TYPE] = { .type = NLA_U8 },
+	[DEVLINK_ATTR_SB_THRESHOLD] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_SB_TC_INDEX] = { .type = NLA_U16 },
+	[DEVLINK_ATTR_ESWITCH_MODE] = NLA_POLICY_RANGE(NLA_U16, DEVLINK_ESWITCH_MODE_LEGACY,
+						       DEVLINK_ESWITCH_MODE_SWITCHDEV),
+	[DEVLINK_ATTR_ESWITCH_INLINE_MODE] = { .type = NLA_U8 },
+	[DEVLINK_ATTR_ESWITCH_ENCAP_MODE] = { .type = NLA_U8 },
+	[DEVLINK_ATTR_DPIPE_TABLE_NAME] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_DPIPE_TABLE_COUNTERS_ENABLED] = { .type = NLA_U8 },
+	[DEVLINK_ATTR_RESOURCE_ID] = { .type = NLA_U64},
+	[DEVLINK_ATTR_RESOURCE_SIZE] = { .type = NLA_U64},
+	[DEVLINK_ATTR_PARAM_NAME] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_PARAM_TYPE] = { .type = NLA_U8 },
+	[DEVLINK_ATTR_PARAM_VALUE_CMODE] = { .type = NLA_U8 },
+	[DEVLINK_ATTR_REGION_NAME] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_REGION_SNAPSHOT_ID] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_REGION_CHUNK_ADDR] = { .type = NLA_U64 },
+	[DEVLINK_ATTR_REGION_CHUNK_LEN] = { .type = NLA_U64 },
+	[DEVLINK_ATTR_HEALTH_REPORTER_NAME] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD] = { .type = NLA_U64 },
+	[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER] = { .type = NLA_U8 },
+	[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK] =
+		NLA_POLICY_BITFIELD32(DEVLINK_SUPPORTED_FLASH_OVERWRITE_SECTIONS),
+	[DEVLINK_ATTR_TRAP_NAME] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_TRAP_ACTION] = { .type = NLA_U8 },
+	[DEVLINK_ATTR_TRAP_GROUP_NAME] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_NETNS_PID] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_NETNS_FD] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_NETNS_ID] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP] = { .type = NLA_U8 },
+	[DEVLINK_ATTR_TRAP_POLICER_ID] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_TRAP_POLICER_RATE] = { .type = NLA_U64 },
+	[DEVLINK_ATTR_TRAP_POLICER_BURST] = { .type = NLA_U64 },
+	[DEVLINK_ATTR_PORT_FUNCTION] = { .type = NLA_NESTED },
+	[DEVLINK_ATTR_RELOAD_ACTION] = NLA_POLICY_RANGE(NLA_U8, DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
+							DEVLINK_RELOAD_ACTION_MAX),
+	[DEVLINK_ATTR_RELOAD_LIMITS] = NLA_POLICY_BITFIELD32(DEVLINK_RELOAD_LIMITS_VALID_MASK),
+	[DEVLINK_ATTR_PORT_FLAVOUR] = { .type = NLA_U16 },
+	[DEVLINK_ATTR_PORT_PCI_PF_NUMBER] = { .type = NLA_U16 },
+	[DEVLINK_ATTR_PORT_PCI_SF_NUMBER] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_PORT_CONTROLLER_NUMBER] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_RATE_TYPE] = { .type = NLA_U16 },
+	[DEVLINK_ATTR_RATE_TX_SHARE] = { .type = NLA_U64 },
+	[DEVLINK_ATTR_RATE_TX_MAX] = { .type = NLA_U64 },
+	[DEVLINK_ATTR_RATE_NODE_NAME] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_RATE_PARENT_NODE_NAME] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
+	[DEVLINK_ATTR_SELFTESTS] = { .type = NLA_NESTED },
+	[DEVLINK_ATTR_RATE_TX_PRIORITY] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_RATE_TX_WEIGHT] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_REGION_DIRECT] = { .type = NLA_FLAG },
+};
+
+struct devlink *devlink_get_from_attrs(struct net *net, struct nlattr **attrs)
+{
+	struct devlink *devlink;
+	unsigned long index;
+	char *busname;
+	char *devname;
+
+	if (!attrs[DEVLINK_ATTR_BUS_NAME] || !attrs[DEVLINK_ATTR_DEV_NAME])
+		return ERR_PTR(-EINVAL);
+
+	busname = nla_data(attrs[DEVLINK_ATTR_BUS_NAME]);
+	devname = nla_data(attrs[DEVLINK_ATTR_DEV_NAME]);
+
+	devlinks_xa_for_each_registered_get(net, index, devlink) {
+		if (strcmp(devlink->dev->bus->name, busname) == 0 &&
+		    strcmp(dev_name(devlink->dev), devname) == 0)
+			return devlink;
+		devlink_put(devlink);
+	}
+
+	return ERR_PTR(-ENODEV);
+}
+
+static int devlink_nl_pre_doit(const struct genl_split_ops *ops,
+			       struct sk_buff *skb, struct genl_info *info)
+{
+	struct devlink_linecard *linecard;
+	struct devlink_port *devlink_port;
+	struct devlink *devlink;
+	int err;
+
+	devlink = devlink_get_from_attrs(genl_info_net(info), info->attrs);
+	if (IS_ERR(devlink))
+		return PTR_ERR(devlink);
+	devl_lock(devlink);
+	info->user_ptr[0] = devlink;
+	if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_PORT) {
+		devlink_port = devlink_port_get_from_info(devlink, info);
+		if (IS_ERR(devlink_port)) {
+			err = PTR_ERR(devlink_port);
+			goto unlock;
+		}
+		info->user_ptr[1] = devlink_port;
+	} else if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT) {
+		devlink_port = devlink_port_get_from_info(devlink, info);
+		if (!IS_ERR(devlink_port))
+			info->user_ptr[1] = devlink_port;
+	} else if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_RATE) {
+		struct devlink_rate *devlink_rate;
+
+		devlink_rate = devlink_rate_get_from_info(devlink, info);
+		if (IS_ERR(devlink_rate)) {
+			err = PTR_ERR(devlink_rate);
+			goto unlock;
+		}
+		info->user_ptr[1] = devlink_rate;
+	} else if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_RATE_NODE) {
+		struct devlink_rate *rate_node;
+
+		rate_node = devlink_rate_node_get_from_info(devlink, info);
+		if (IS_ERR(rate_node)) {
+			err = PTR_ERR(rate_node);
+			goto unlock;
+		}
+		info->user_ptr[1] = rate_node;
+	} else if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_LINECARD) {
+		linecard = devlink_linecard_get_from_info(devlink, info);
+		if (IS_ERR(linecard)) {
+			err = PTR_ERR(linecard);
+			goto unlock;
+		}
+		info->user_ptr[1] = linecard;
+	}
+	return 0;
+
+unlock:
+	devl_unlock(devlink);
+	devlink_put(devlink);
+	return err;
+}
+
+static void devlink_nl_post_doit(const struct genl_split_ops *ops,
+				 struct sk_buff *skb, struct genl_info *info)
+{
+	struct devlink_linecard *linecard;
+	struct devlink *devlink;
+
+	devlink = info->user_ptr[0];
+	if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_LINECARD) {
+		linecard = info->user_ptr[1];
+		devlink_linecard_put(linecard);
+	}
+	devl_unlock(devlink);
+	devlink_put(devlink);
+}
+
+struct genl_family devlink_nl_family __ro_after_init = {
+	.name		= DEVLINK_GENL_NAME,
+	.version	= DEVLINK_GENL_VERSION,
+	.maxattr	= DEVLINK_ATTR_MAX,
+	.policy		= devlink_nl_policy,
+	.netnsok	= true,
+	.parallel_ops	= true,
+	.pre_doit	= devlink_nl_pre_doit,
+	.post_doit	= devlink_nl_post_doit,
+	.module		= THIS_MODULE,
+	.small_ops	= devlink_nl_ops,
+	.n_small_ops	= ARRAY_SIZE(devlink_nl_ops),
+	.resv_start_op	= DEVLINK_CMD_SELFTESTS_RUN + 1,
+	.mcgrps		= devlink_nl_mcgrps,
+	.n_mcgrps	= ARRAY_SIZE(devlink_nl_mcgrps),
+};
-- 
2.38.1

