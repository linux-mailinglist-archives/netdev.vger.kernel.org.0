Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7239165E466
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbjAEEGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbjAEEGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:06:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383063724E
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 20:05:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96F34B8198C
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 04:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097BEC433D2;
        Thu,  5 Jan 2023 04:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672891545;
        bh=r9ly4Kd8sMU4Vtd7X1DJOusN4kLAZKkGUf0oyXVHhIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=StR3HmaOnFPRcjJT1PNWmOEJ6isjKpUfMyKqZjKIf7SJfX2ga8RS99fxkTpvwwr6e
         RcQ8saDhWb4HyYw++i9sPr6fL5U11rahMFFvXo7LMFfhi8LBrYS5/ep97g3rRyCC/Q
         yKopEvwg5F5cWXXlX+yzaiSZXdIHMtKeeIDVo3bLhbbd9z5vSqNMFR1435r4EaR+x7
         uCNbd2/XoEvzJaJbQRRBBSzxVY8oYWa2TCyJRV8nr0z+03jZn8cnqfqKkUVSm9xijh
         rFUcymNH/wZCOWT+qhfp5G3qhaKykTmE6gMHJloAzpT8E2oZtFhLlIeo6zoIbejuP2
         XW9oe7F5Z86SA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 15/15] devlink: convert remaining dumps to the by-instance scheme
Date:   Wed,  4 Jan 2023 20:05:31 -0800
Message-Id: <20230105040531.353563-16-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230105040531.353563-1-kuba@kernel.org>
References: <20230105040531.353563-1-kuba@kernel.org>
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

Soon we'll have to check if a devlink instance is alive after
locking it. Convert to the by-instance dumping scheme to make
refactoring easier.

Most of the subobject code no longer has to worry about any devlink
locking / lifetime rules (the only ones that still do are the two subject
types which stubbornly use their own locking). Both dump and do callbacks
are given a devlink instance which is already locked and good-to-access
(do from the .pre_doit handler, dump from the new dump indirection).

Note that we'll now check presence of an op (e.g. for sb_pool_get)
under the devlink instance lock, that will soon be necessary anyway,
because we don't hold refs on the driver modules so the memory
in which ops live may be gone for a dead instance, after upcoming
locking changes.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/devl_internal.h |  15 +
 net/devlink/leftover.c      | 686 +++++++++++++++---------------------
 net/devlink/netlink.c       |  13 +
 3 files changed, 320 insertions(+), 394 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 734553beccde..cb6c7ec6409f 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -156,6 +156,21 @@ devlink_dump_state(struct netlink_callback *cb)
 	return (struct devlink_nl_dump_state *)cb->ctx;
 }
 
+/* gen cmds */
+extern const struct devlink_gen_cmd devl_gen_inst;
+extern const struct devlink_gen_cmd devl_gen_port;
+extern const struct devlink_gen_cmd devl_gen_sb;
+extern const struct devlink_gen_cmd devl_gen_sb_pool;
+extern const struct devlink_gen_cmd devl_gen_sb_port_pool;
+extern const struct devlink_gen_cmd devl_gen_sb_tc_pool_bind;
+extern const struct devlink_gen_cmd devl_gen_selftests;
+extern const struct devlink_gen_cmd devl_gen_param;
+extern const struct devlink_gen_cmd devl_gen_region;
+extern const struct devlink_gen_cmd devl_gen_info;
+extern const struct devlink_gen_cmd devl_gen_trap;
+extern const struct devlink_gen_cmd devl_gen_trap_group;
+extern const struct devlink_gen_cmd devl_gen_trap_policer;
+
 /* Ports */
 int devlink_port_netdevice_event(struct notifier_block *nb,
 				 unsigned long event, void *ptr);
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 6b5d60c91816..e6d6c7f74ae7 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -1307,28 +1307,19 @@ static int devlink_nl_cmd_get_doit(struct sk_buff *skb, struct genl_info *info)
 	return genlmsg_reply(msg, info);
 }
 
-static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
-				     struct netlink_callback *cb)
+static int
+devlink_nl_cmd_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
+			    struct netlink_callback *cb)
 {
-	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
-	struct devlink *devlink;
-	int err;
-
-	devlink_dump_for_each_instance_get(msg, state, devlink) {
-		devl_lock(devlink);
-		err = devlink_nl_fill(msg, devlink, DEVLINK_CMD_NEW,
-				      NETLINK_CB(cb->skb).portid,
-				      cb->nlh->nlmsg_seq, NLM_F_MULTI);
-		devl_unlock(devlink);
-		devlink_put(devlink);
-
-		if (err)
-			goto out;
-	}
-out:
-	return msg->len;
+	return devlink_nl_fill(msg, devlink, DEVLINK_CMD_NEW,
+			       NETLINK_CB(cb->skb).portid,
+			       cb->nlh->nlmsg_seq, NLM_F_MULTI);
 }
 
+const struct devlink_gen_cmd devl_gen_inst = {
+	.dump_one		= devlink_nl_cmd_get_dump_one,
+};
+
 static int devlink_nl_cmd_port_get_doit(struct sk_buff *skb,
 					struct genl_info *info)
 {
@@ -1351,44 +1342,40 @@ static int devlink_nl_cmd_port_get_doit(struct sk_buff *skb,
 	return genlmsg_reply(msg, info);
 }
 
-static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
-					  struct netlink_callback *cb)
+static int
+devlink_nl_cmd_port_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
+				 struct netlink_callback *cb)
 {
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
-	struct devlink *devlink;
-	int err;
-
-	devlink_dump_for_each_instance_get(msg, state, devlink) {
-		struct devlink_port *devlink_port;
-		unsigned long port_index;
-		int idx = 0;
+	struct devlink_port *devlink_port;
+	unsigned long port_index;
+	int idx = 0;
+	int err = 0;
 
-		devl_lock(devlink);
-		xa_for_each(&devlink->ports, port_index, devlink_port) {
-			if (idx < state->idx) {
-				idx++;
-				continue;
-			}
-			err = devlink_nl_port_fill(msg, devlink_port,
-						   DEVLINK_CMD_NEW,
-						   NETLINK_CB(cb->skb).portid,
-						   cb->nlh->nlmsg_seq,
-						   NLM_F_MULTI, cb->extack);
-			if (err) {
-				devl_unlock(devlink);
-				devlink_put(devlink);
-				state->idx = idx;
-				goto out;
-			}
+	xa_for_each(&devlink->ports, port_index, devlink_port) {
+		if (idx < state->idx) {
 			idx++;
+			continue;
 		}
-		devl_unlock(devlink);
-		devlink_put(devlink);
+		err = devlink_nl_port_fill(msg, devlink_port,
+					   DEVLINK_CMD_NEW,
+					   NETLINK_CB(cb->skb).portid,
+					   cb->nlh->nlmsg_seq,
+					   NLM_F_MULTI, cb->extack);
+		if (err) {
+			state->idx = idx;
+			break;
+		}
+		idx++;
 	}
-out:
-	return msg->len;
+
+	return err;
 }
 
+const struct devlink_gen_cmd devl_gen_port = {
+	.dump_one		= devlink_nl_cmd_port_get_dump_one,
+};
+
 static int devlink_port_type_set(struct devlink_port *devlink_port,
 				 enum devlink_port_type port_type)
 
@@ -2393,43 +2380,39 @@ static int devlink_nl_cmd_sb_get_doit(struct sk_buff *skb,
 	return genlmsg_reply(msg, info);
 }
 
-static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
-					struct netlink_callback *cb)
+static int
+devlink_nl_cmd_sb_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
+			       struct netlink_callback *cb)
 {
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
-	struct devlink *devlink;
-	int err;
-
-	devlink_dump_for_each_instance_get(msg, state, devlink) {
-		struct devlink_sb *devlink_sb;
-		int idx = 0;
+	struct devlink_sb *devlink_sb;
+	int idx = 0;
+	int err = 0;
 
-		devl_lock(devlink);
-		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
-			if (idx < state->idx) {
-				idx++;
-				continue;
-			}
-			err = devlink_nl_sb_fill(msg, devlink, devlink_sb,
-						 DEVLINK_CMD_SB_NEW,
-						 NETLINK_CB(cb->skb).portid,
-						 cb->nlh->nlmsg_seq,
-						 NLM_F_MULTI);
-			if (err) {
-				devl_unlock(devlink);
-				devlink_put(devlink);
-				state->idx = idx;
-				goto out;
-			}
+	list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
+		if (idx < state->idx) {
 			idx++;
+			continue;
 		}
-		devl_unlock(devlink);
-		devlink_put(devlink);
+		err = devlink_nl_sb_fill(msg, devlink, devlink_sb,
+					 DEVLINK_CMD_SB_NEW,
+					 NETLINK_CB(cb->skb).portid,
+					 cb->nlh->nlmsg_seq,
+					 NLM_F_MULTI);
+		if (err) {
+			state->idx = idx;
+			break;
+		}
+		idx++;
 	}
-out:
-	return msg->len;
+
+	return err;
 }
 
+const struct devlink_gen_cmd devl_gen_sb = {
+	.dump_one		= devlink_nl_cmd_sb_get_dump_one,
+};
+
 static int devlink_nl_sb_pool_fill(struct sk_buff *msg, struct devlink *devlink,
 				   struct devlink_sb *devlink_sb,
 				   u16 pool_index, enum devlink_command cmd,
@@ -2535,46 +2518,39 @@ static int __sb_pool_get_dumpit(struct sk_buff *msg, int start, int *p_idx,
 	return 0;
 }
 
-static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
-					     struct netlink_callback *cb)
+static int
+devlink_nl_cmd_sb_pool_get_dump_one(struct sk_buff *msg,
+				    struct devlink *devlink,
+				    struct netlink_callback *cb)
 {
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
-	struct devlink *devlink;
+	struct devlink_sb *devlink_sb;
 	int err = 0;
+	int idx = 0;
 
-	devlink_dump_for_each_instance_get(msg, state, devlink) {
-		struct devlink_sb *devlink_sb;
-		int idx = 0;
-
-		if (!devlink->ops->sb_pool_get)
-			goto retry;
+	if (!devlink->ops->sb_pool_get)
+		return 0;
 
-		devl_lock(devlink);
-		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
-			err = __sb_pool_get_dumpit(msg, state->idx, &idx,
-						   devlink, devlink_sb,
-						   NETLINK_CB(cb->skb).portid,
-						   cb->nlh->nlmsg_seq);
-			if (err == -EOPNOTSUPP) {
-				err = 0;
-			} else if (err) {
-				devl_unlock(devlink);
-				devlink_put(devlink);
-				state->idx = idx;
-				goto out;
-			}
+	list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
+		err = __sb_pool_get_dumpit(msg, state->idx, &idx,
+					   devlink, devlink_sb,
+					   NETLINK_CB(cb->skb).portid,
+					   cb->nlh->nlmsg_seq);
+		if (err == -EOPNOTSUPP) {
+			err = 0;
+		} else if (err) {
+			state->idx = idx;
+			break;
 		}
-		devl_unlock(devlink);
-retry:
-		devlink_put(devlink);
 	}
-out:
-	if (err != -EMSGSIZE)
-		return err;
 
-	return msg->len;
+	return err;
 }
 
+const struct devlink_gen_cmd devl_gen_sb_pool = {
+	.dump_one		= devlink_nl_cmd_sb_pool_get_dump_one,
+};
+
 static int devlink_sb_pool_set(struct devlink *devlink, unsigned int sb_index,
 			       u16 pool_index, u32 size,
 			       enum devlink_sb_threshold_type threshold_type,
@@ -2750,46 +2726,39 @@ static int __sb_port_pool_get_dumpit(struct sk_buff *msg, int start, int *p_idx,
 	return 0;
 }
 
-static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
-						  struct netlink_callback *cb)
+static int
+devlink_nl_cmd_sb_port_pool_get_dump_one(struct sk_buff *msg,
+					 struct devlink *devlink,
+					 struct netlink_callback *cb)
 {
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
-	struct devlink *devlink;
+	struct devlink_sb *devlink_sb;
+	int idx = 0;
 	int err = 0;
 
-	devlink_dump_for_each_instance_get(msg, state, devlink) {
-		struct devlink_sb *devlink_sb;
-		int idx = 0;
-
-		if (!devlink->ops->sb_port_pool_get)
-			goto retry;
+	if (!devlink->ops->sb_port_pool_get)
+		return 0;
 
-		devl_lock(devlink);
-		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
-			err = __sb_port_pool_get_dumpit(msg, state->idx, &idx,
-							devlink, devlink_sb,
-							NETLINK_CB(cb->skb).portid,
-							cb->nlh->nlmsg_seq);
-			if (err == -EOPNOTSUPP) {
-				err = 0;
-			} else if (err) {
-				devl_unlock(devlink);
-				devlink_put(devlink);
-				state->idx = idx;
-				goto out;
-			}
+	list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
+		err = __sb_port_pool_get_dumpit(msg, state->idx, &idx,
+						devlink, devlink_sb,
+						NETLINK_CB(cb->skb).portid,
+						cb->nlh->nlmsg_seq);
+		if (err == -EOPNOTSUPP) {
+			err = 0;
+		} else if (err) {
+			state->idx = idx;
+			break;
 		}
-		devl_unlock(devlink);
-retry:
-		devlink_put(devlink);
 	}
-out:
-	if (err != -EMSGSIZE)
-		return err;
 
-	return msg->len;
+	return err;
 }
 
+const struct devlink_gen_cmd devl_gen_sb_port_pool = {
+	.dump_one		= devlink_nl_cmd_sb_port_pool_get_dump_one,
+};
+
 static int devlink_sb_port_pool_set(struct devlink_port *devlink_port,
 				    unsigned int sb_index, u16 pool_index,
 				    u32 threshold,
@@ -2993,46 +2962,38 @@ static int __sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 }
 
 static int
-devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
-					  struct netlink_callback *cb)
+devlink_nl_cmd_sb_tc_pool_bind_get_dump_one(struct sk_buff *msg,
+					    struct devlink *devlink,
+					    struct netlink_callback *cb)
 {
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
-	struct devlink *devlink;
+	struct devlink_sb *devlink_sb;
+	int idx = 0;
 	int err = 0;
 
-	devlink_dump_for_each_instance_get(msg, state, devlink) {
-		struct devlink_sb *devlink_sb;
-		int idx = 0;
-
-		if (!devlink->ops->sb_tc_pool_bind_get)
-			goto retry;
+	if (!devlink->ops->sb_tc_pool_bind_get)
+		return 0;
 
-		devl_lock(devlink);
-		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
-			err = __sb_tc_pool_bind_get_dumpit(msg, state->idx, &idx,
-							   devlink, devlink_sb,
-							   NETLINK_CB(cb->skb).portid,
-							   cb->nlh->nlmsg_seq);
-			if (err == -EOPNOTSUPP) {
-				err = 0;
-			} else if (err) {
-				devl_unlock(devlink);
-				devlink_put(devlink);
-				state->idx = idx;
-				goto out;
-			}
+	list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
+		err = __sb_tc_pool_bind_get_dumpit(msg, state->idx, &idx,
+						   devlink, devlink_sb,
+						   NETLINK_CB(cb->skb).portid,
+						   cb->nlh->nlmsg_seq);
+		if (err == -EOPNOTSUPP) {
+			err = 0;
+		} else if (err) {
+			state->idx = idx;
+			break;
 		}
-		devl_unlock(devlink);
-retry:
-		devlink_put(devlink);
 	}
-out:
-	if (err != -EMSGSIZE)
-		return err;
 
-	return msg->len;
+	return err;
 }
 
+const struct devlink_gen_cmd devl_gen_sb_tc_pool_bind = {
+	.dump_one		= devlink_nl_cmd_sb_tc_pool_bind_get_dump_one,
+};
+
 static int devlink_sb_tc_pool_bind_set(struct devlink_port *devlink_port,
 				       unsigned int sb_index, u16 tc_index,
 				       enum devlink_sb_pool_type pool_type,
@@ -4851,39 +4812,24 @@ static int devlink_nl_cmd_selftests_get_doit(struct sk_buff *skb,
 	return genlmsg_reply(msg, info);
 }
 
-static int devlink_nl_cmd_selftests_get_dumpit(struct sk_buff *msg,
-					       struct netlink_callback *cb)
+static int
+devlink_nl_cmd_selftests_get_dump_one(struct sk_buff *msg,
+				      struct devlink *devlink,
+				      struct netlink_callback *cb)
 {
-	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
-	struct devlink *devlink;
-	int err = 0;
-
-	devlink_dump_for_each_instance_get(msg, state, devlink) {
-		if (!devlink->ops->selftest_check) {
-			devlink_put(devlink);
-			continue;
-		}
-
-		devl_lock(devlink);
-		err = devlink_nl_selftests_fill(msg, devlink,
-						NETLINK_CB(cb->skb).portid,
-						cb->nlh->nlmsg_seq, NLM_F_MULTI,
-						cb->extack);
-		devl_unlock(devlink);
-		if (err) {
-			devlink_put(devlink);
-			break;
-		}
-
-		devlink_put(devlink);
-	}
-
-	if (err != -EMSGSIZE)
-		return err;
+	if (!devlink->ops->selftest_check)
+		return 0;
 
-	return msg->len;
+	return devlink_nl_selftests_fill(msg, devlink,
+					 NETLINK_CB(cb->skb).portid,
+					 cb->nlh->nlmsg_seq, NLM_F_MULTI,
+					 cb->extack);
 }
 
+const struct devlink_gen_cmd devl_gen_selftests = {
+	.dump_one		= devlink_nl_cmd_selftests_get_dump_one,
+};
+
 static int devlink_selftest_result_put(struct sk_buff *skb, unsigned int id,
 				       enum devlink_selftest_status test_status)
 {
@@ -5329,48 +5275,41 @@ static void devlink_param_notify(struct devlink *devlink,
 				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
 }
 
-static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
-					   struct netlink_callback *cb)
+static int
+devlink_nl_cmd_param_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
+				  struct netlink_callback *cb)
 {
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
-	struct devlink *devlink;
+	struct devlink_param_item *param_item;
+	int idx = 0;
 	int err = 0;
 
-	devlink_dump_for_each_instance_get(msg, state, devlink) {
-		struct devlink_param_item *param_item;
-		int idx = 0;
-
-		devl_lock(devlink);
-		list_for_each_entry(param_item, &devlink->param_list, list) {
-			if (idx < state->idx) {
-				idx++;
-				continue;
-			}
-			err = devlink_nl_param_fill(msg, devlink, 0, param_item,
-						    DEVLINK_CMD_PARAM_GET,
-						    NETLINK_CB(cb->skb).portid,
-						    cb->nlh->nlmsg_seq,
-						    NLM_F_MULTI);
-			if (err == -EOPNOTSUPP) {
-				err = 0;
-			} else if (err) {
-				devl_unlock(devlink);
-				devlink_put(devlink);
-				state->idx = idx;
-				goto out;
-			}
+	list_for_each_entry(param_item, &devlink->param_list, list) {
+		if (idx < state->idx) {
 			idx++;
+			continue;
 		}
-		devl_unlock(devlink);
-		devlink_put(devlink);
+		err = devlink_nl_param_fill(msg, devlink, 0, param_item,
+					    DEVLINK_CMD_PARAM_GET,
+					    NETLINK_CB(cb->skb).portid,
+					    cb->nlh->nlmsg_seq,
+					    NLM_F_MULTI);
+		if (err == -EOPNOTSUPP) {
+			err = 0;
+		} else if (err) {
+			state->idx = idx;
+			break;
+		}
+		idx++;
 	}
-out:
-	if (err != -EMSGSIZE)
-		return err;
 
-	return msg->len;
+	return err;
 }
 
+const struct devlink_gen_cmd devl_gen_param = {
+	.dump_one		= devlink_nl_cmd_param_get_dump_one,
+};
+
 static int
 devlink_param_type_get_from_info(struct genl_info *info,
 				 enum devlink_param_type *param_type)
@@ -6034,20 +5973,20 @@ static int devlink_nl_cmd_region_get_port_dumpit(struct sk_buff *msg,
 	return err;
 }
 
-static int devlink_nl_cmd_region_get_devlink_dumpit(struct sk_buff *msg,
-						    struct netlink_callback *cb,
-						    struct devlink *devlink,
-						    int *idx,
-						    int start)
+static int
+devlink_nl_cmd_region_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
+				   struct netlink_callback *cb)
 {
+	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
 	struct devlink_region *region;
 	struct devlink_port *port;
 	unsigned long port_index;
+	int idx = 0;
 	int err;
 
 	list_for_each_entry(region, &devlink->region_list, list) {
-		if (*idx < start) {
-			(*idx)++;
+		if (idx < state->idx) {
+			idx++;
 			continue;
 		}
 		err = devlink_nl_region_fill(msg, devlink,
@@ -6055,44 +5994,28 @@ static int devlink_nl_cmd_region_get_devlink_dumpit(struct sk_buff *msg,
 					     NETLINK_CB(cb->skb).portid,
 					     cb->nlh->nlmsg_seq,
 					     NLM_F_MULTI, region);
-		if (err)
+		if (err) {
+			state->idx = idx;
 			return err;
-		(*idx)++;
+		}
+		idx++;
 	}
 
 	xa_for_each(&devlink->ports, port_index, port) {
-		err = devlink_nl_cmd_region_get_port_dumpit(msg, cb, port, idx,
-							    start);
-		if (err)
+		err = devlink_nl_cmd_region_get_port_dumpit(msg, cb, port, &idx,
+							    state->idx);
+		if (err) {
+			state->idx = idx;
 			return err;
+		}
 	}
 
 	return 0;
 }
 
-static int devlink_nl_cmd_region_get_dumpit(struct sk_buff *msg,
-					    struct netlink_callback *cb)
-{
-	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
-	struct devlink *devlink;
-	int err = 0;
-
-	devlink_dump_for_each_instance_get(msg, state, devlink) {
-		int idx = 0;
-
-		devl_lock(devlink);
-		err = devlink_nl_cmd_region_get_devlink_dumpit(msg, cb, devlink,
-							       &idx, state->idx);
-		devl_unlock(devlink);
-		devlink_put(devlink);
-		if (err) {
-			state->idx = idx;
-			goto out;
-		}
-	}
-out:
-	return msg->len;
-}
+const struct devlink_gen_cmd devl_gen_region = {
+	.dump_one		= devlink_nl_cmd_region_get_dump_one,
+};
 
 static int devlink_nl_cmd_region_del(struct sk_buff *skb,
 				     struct genl_info *info)
@@ -6724,35 +6647,25 @@ static int devlink_nl_cmd_info_get_doit(struct sk_buff *skb,
 	return genlmsg_reply(msg, info);
 }
 
-static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
-					  struct netlink_callback *cb)
+static int
+devlink_nl_cmd_info_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
+				 struct netlink_callback *cb)
 {
-	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
-	struct devlink *devlink;
-	int err = 0;
-
-	devlink_dump_for_each_instance_get(msg, state, devlink) {
-		devl_lock(devlink);
-		err = devlink_nl_info_fill(msg, devlink, DEVLINK_CMD_INFO_GET,
-					   NETLINK_CB(cb->skb).portid,
-					   cb->nlh->nlmsg_seq, NLM_F_MULTI,
-					   cb->extack);
-		devl_unlock(devlink);
-		if (err == -EOPNOTSUPP)
-			err = 0;
-		else if (err) {
-			devlink_put(devlink);
-			break;
-		}
-		devlink_put(devlink);
-	}
-
-	if (err != -EMSGSIZE)
-		return err;
+	int err;
 
-	return msg->len;
+	err = devlink_nl_info_fill(msg, devlink, DEVLINK_CMD_INFO_GET,
+				   NETLINK_CB(cb->skb).portid,
+				   cb->nlh->nlmsg_seq, NLM_F_MULTI,
+				   cb->extack);
+	if (err == -EOPNOTSUPP)
+		err = 0;
+	return err;
 }
 
+const struct devlink_gen_cmd devl_gen_info = {
+	.dump_one		= devlink_nl_cmd_info_get_dump_one,
+};
+
 struct devlink_fmsg_item {
 	struct list_head list;
 	int attrtype;
@@ -8466,43 +8379,39 @@ static int devlink_nl_cmd_trap_get_doit(struct sk_buff *skb,
 	return err;
 }
 
-static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
-					  struct netlink_callback *cb)
+static int
+devlink_nl_cmd_trap_get_dump_one(struct sk_buff *msg, struct devlink *devlink,
+				 struct netlink_callback *cb)
 {
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
-	struct devlink *devlink;
-	int err;
-
-	devlink_dump_for_each_instance_get(msg, state, devlink) {
-		struct devlink_trap_item *trap_item;
-		int idx = 0;
+	struct devlink_trap_item *trap_item;
+	int idx = 0;
+	int err = 0;
 
-		devl_lock(devlink);
-		list_for_each_entry(trap_item, &devlink->trap_list, list) {
-			if (idx < state->idx) {
-				idx++;
-				continue;
-			}
-			err = devlink_nl_trap_fill(msg, devlink, trap_item,
-						   DEVLINK_CMD_TRAP_NEW,
-						   NETLINK_CB(cb->skb).portid,
-						   cb->nlh->nlmsg_seq,
-						   NLM_F_MULTI);
-			if (err) {
-				devl_unlock(devlink);
-				devlink_put(devlink);
-				state->idx = idx;
-				goto out;
-			}
+	list_for_each_entry(trap_item, &devlink->trap_list, list) {
+		if (idx < state->idx) {
 			idx++;
+			continue;
 		}
-		devl_unlock(devlink);
-		devlink_put(devlink);
+		err = devlink_nl_trap_fill(msg, devlink, trap_item,
+					   DEVLINK_CMD_TRAP_NEW,
+					   NETLINK_CB(cb->skb).portid,
+					   cb->nlh->nlmsg_seq,
+					   NLM_F_MULTI);
+		if (err) {
+			state->idx = idx;
+			break;
+		}
+		idx++;
 	}
-out:
-	return msg->len;
+
+	return err;
 }
 
+const struct devlink_gen_cmd devl_gen_trap = {
+	.dump_one		= devlink_nl_cmd_trap_get_dump_one,
+};
+
 static int __devlink_trap_action_set(struct devlink *devlink,
 				     struct devlink_trap_item *trap_item,
 				     enum devlink_trap_action trap_action,
@@ -8681,46 +8590,41 @@ static int devlink_nl_cmd_trap_group_get_doit(struct sk_buff *skb,
 	return err;
 }
 
-static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
-						struct netlink_callback *cb)
+static int
+devlink_nl_cmd_trap_group_get_dump_one(struct sk_buff *msg,
+				       struct devlink *devlink,
+				       struct netlink_callback *cb)
 {
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
-	enum devlink_command cmd = DEVLINK_CMD_TRAP_GROUP_NEW;
-	u32 portid = NETLINK_CB(cb->skb).portid;
-	struct devlink *devlink;
-	int err;
+	struct devlink_trap_group_item *group_item;
+	int idx = 0;
+	int err = 0;
 
-	devlink_dump_for_each_instance_get(msg, state, devlink) {
-		struct devlink_trap_group_item *group_item;
-		int idx = 0;
 
-		devl_lock(devlink);
-		list_for_each_entry(group_item, &devlink->trap_group_list,
-				    list) {
-			if (idx < state->idx) {
-				idx++;
-				continue;
-			}
-			err = devlink_nl_trap_group_fill(msg, devlink,
-							 group_item, cmd,
-							 portid,
-							 cb->nlh->nlmsg_seq,
-							 NLM_F_MULTI);
-			if (err) {
-				devl_unlock(devlink);
-				devlink_put(devlink);
-				state->idx = idx;
-				goto out;
-			}
+	list_for_each_entry(group_item, &devlink->trap_group_list, list) {
+		if (idx < state->idx) {
 			idx++;
+			continue;
 		}
-		devl_unlock(devlink);
-		devlink_put(devlink);
+		err = devlink_nl_trap_group_fill(msg, devlink, group_item,
+						 DEVLINK_CMD_TRAP_GROUP_NEW,
+						 NETLINK_CB(cb->skb).portid,
+						 cb->nlh->nlmsg_seq,
+						 NLM_F_MULTI);
+		if (err) {
+			state->idx = idx;
+			break;
+		}
+		idx++;
 	}
-out:
-	return msg->len;
+
+	return err;
 }
 
+const struct devlink_gen_cmd devl_gen_trap_group = {
+	.dump_one		= devlink_nl_cmd_trap_group_get_dump_one,
+};
+
 static int
 __devlink_trap_group_action_set(struct devlink *devlink,
 				struct devlink_trap_group_item *group_item,
@@ -8985,46 +8889,40 @@ static int devlink_nl_cmd_trap_policer_get_doit(struct sk_buff *skb,
 	return err;
 }
 
-static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
-						  struct netlink_callback *cb)
+static int
+devlink_nl_cmd_trap_policer_get_dump_one(struct sk_buff *msg,
+					 struct devlink *devlink,
+					 struct netlink_callback *cb)
 {
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
-	enum devlink_command cmd = DEVLINK_CMD_TRAP_POLICER_NEW;
-	u32 portid = NETLINK_CB(cb->skb).portid;
-	struct devlink *devlink;
-	int err;
-
-	devlink_dump_for_each_instance_get(msg, state, devlink) {
-		struct devlink_trap_policer_item *policer_item;
-		int idx = 0;
+	struct devlink_trap_policer_item *policer_item;
+	int idx = 0;
+	int err = 0;
 
-		devl_lock(devlink);
-		list_for_each_entry(policer_item, &devlink->trap_policer_list,
-				    list) {
-			if (idx < state->idx) {
-				idx++;
-				continue;
-			}
-			err = devlink_nl_trap_policer_fill(msg, devlink,
-							   policer_item, cmd,
-							   portid,
-							   cb->nlh->nlmsg_seq,
-							   NLM_F_MULTI);
-			if (err) {
-				devl_unlock(devlink);
-				devlink_put(devlink);
-				state->idx = idx;
-				goto out;
-			}
+	list_for_each_entry(policer_item, &devlink->trap_policer_list, list) {
+		if (idx < state->idx) {
 			idx++;
+			continue;
 		}
-		devl_unlock(devlink);
-		devlink_put(devlink);
+		err = devlink_nl_trap_policer_fill(msg, devlink, policer_item,
+						   DEVLINK_CMD_TRAP_POLICER_NEW,
+						   NETLINK_CB(cb->skb).portid,
+						   cb->nlh->nlmsg_seq,
+						   NLM_F_MULTI);
+		if (err) {
+			state->idx = idx;
+			break;
+		}
+		idx++;
 	}
-out:
-	return msg->len;
+
+	return err;
 }
 
+const struct devlink_gen_cmd devl_gen_trap_policer = {
+	.dump_one		= devlink_nl_cmd_trap_policer_get_dump_one,
+};
+
 static int
 devlink_trap_policer_set(struct devlink *devlink,
 			 struct devlink_trap_policer_item *policer_item,
@@ -9102,14 +9000,14 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 		.cmd = DEVLINK_CMD_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_get_doit,
-		.dumpit = devlink_nl_cmd_get_dumpit,
+		.dumpit = devlink_nl_instance_iter_dump,
 		/* can be retrieved by unprivileged users */
 	},
 	{
 		.cmd = DEVLINK_CMD_PORT_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_port_get_doit,
-		.dumpit = devlink_nl_cmd_port_get_dumpit,
+		.dumpit = devlink_nl_instance_iter_dump,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT,
 		/* can be retrieved by unprivileged users */
 	},
@@ -9185,14 +9083,14 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 		.cmd = DEVLINK_CMD_SB_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_sb_get_doit,
-		.dumpit = devlink_nl_cmd_sb_get_dumpit,
+		.dumpit = devlink_nl_instance_iter_dump,
 		/* can be retrieved by unprivileged users */
 	},
 	{
 		.cmd = DEVLINK_CMD_SB_POOL_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_sb_pool_get_doit,
-		.dumpit = devlink_nl_cmd_sb_pool_get_dumpit,
+		.dumpit = devlink_nl_instance_iter_dump,
 		/* can be retrieved by unprivileged users */
 	},
 	{
@@ -9205,7 +9103,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 		.cmd = DEVLINK_CMD_SB_PORT_POOL_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_sb_port_pool_get_doit,
-		.dumpit = devlink_nl_cmd_sb_port_pool_get_dumpit,
+		.dumpit = devlink_nl_instance_iter_dump,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT,
 		/* can be retrieved by unprivileged users */
 	},
@@ -9220,7 +9118,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 		.cmd = DEVLINK_CMD_SB_TC_POOL_BIND_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_sb_tc_pool_bind_get_doit,
-		.dumpit = devlink_nl_cmd_sb_tc_pool_bind_get_dumpit,
+		.dumpit = devlink_nl_instance_iter_dump,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT,
 		/* can be retrieved by unprivileged users */
 	},
@@ -9301,7 +9199,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 		.cmd = DEVLINK_CMD_PARAM_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_param_get_doit,
-		.dumpit = devlink_nl_cmd_param_get_dumpit,
+		.dumpit = devlink_nl_instance_iter_dump,
 		/* can be retrieved by unprivileged users */
 	},
 	{
@@ -9329,7 +9227,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 		.cmd = DEVLINK_CMD_REGION_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_region_get_doit,
-		.dumpit = devlink_nl_cmd_region_get_dumpit,
+		.dumpit = devlink_nl_instance_iter_dump,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
@@ -9355,7 +9253,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 		.cmd = DEVLINK_CMD_INFO_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_info_get_doit,
-		.dumpit = devlink_nl_cmd_info_get_dumpit,
+		.dumpit = devlink_nl_instance_iter_dump,
 		/* can be retrieved by unprivileged users */
 	},
 	{
@@ -9417,7 +9315,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 	{
 		.cmd = DEVLINK_CMD_TRAP_GET,
 		.doit = devlink_nl_cmd_trap_get_doit,
-		.dumpit = devlink_nl_cmd_trap_get_dumpit,
+		.dumpit = devlink_nl_instance_iter_dump,
 		/* can be retrieved by unprivileged users */
 	},
 	{
@@ -9428,7 +9326,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 	{
 		.cmd = DEVLINK_CMD_TRAP_GROUP_GET,
 		.doit = devlink_nl_cmd_trap_group_get_doit,
-		.dumpit = devlink_nl_cmd_trap_group_get_dumpit,
+		.dumpit = devlink_nl_instance_iter_dump,
 		/* can be retrieved by unprivileged users */
 	},
 	{
@@ -9439,7 +9337,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 	{
 		.cmd = DEVLINK_CMD_TRAP_POLICER_GET,
 		.doit = devlink_nl_cmd_trap_policer_get_doit,
-		.dumpit = devlink_nl_cmd_trap_policer_get_dumpit,
+		.dumpit = devlink_nl_instance_iter_dump,
 		/* can be retrieved by unprivileged users */
 	},
 	{
@@ -9450,7 +9348,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 	{
 		.cmd = DEVLINK_CMD_SELFTESTS_GET,
 		.doit = devlink_nl_cmd_selftests_get_doit,
-		.dumpit = devlink_nl_cmd_selftests_get_dumpit
+		.dumpit = devlink_nl_instance_iter_dump,
 		/* can be retrieved by unprivileged users */
 	},
 	{
diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
index 82ee5621bd9c..a552e723f4a6 100644
--- a/net/devlink/netlink.c
+++ b/net/devlink/netlink.c
@@ -179,7 +179,20 @@ static void devlink_nl_post_doit(const struct genl_split_ops *ops,
 }
 
 static const struct devlink_gen_cmd *devl_gen_cmds[] = {
+	[DEVLINK_CMD_GET]		= &devl_gen_inst,
+	[DEVLINK_CMD_PORT_GET]		= &devl_gen_port,
+	[DEVLINK_CMD_SB_GET]		= &devl_gen_sb,
+	[DEVLINK_CMD_SB_POOL_GET]	= &devl_gen_sb_pool,
+	[DEVLINK_CMD_SB_PORT_POOL_GET]	= &devl_gen_sb_port_pool,
+	[DEVLINK_CMD_SB_TC_POOL_BIND_GET] = &devl_gen_sb_tc_pool_bind,
+	[DEVLINK_CMD_PARAM_GET]		= &devl_gen_param,
+	[DEVLINK_CMD_REGION_GET]	= &devl_gen_region,
+	[DEVLINK_CMD_INFO_GET]		= &devl_gen_info,
 	[DEVLINK_CMD_RATE_GET]		= &devl_gen_rate_get,
+	[DEVLINK_CMD_TRAP_GET]		= &devl_gen_trap,
+	[DEVLINK_CMD_TRAP_GROUP_GET]	= &devl_gen_trap_group,
+	[DEVLINK_CMD_TRAP_POLICER_GET]	= &devl_gen_trap_policer,
+	[DEVLINK_CMD_SELFTESTS_GET]	= &devl_gen_selftests,
 };
 
 int devlink_nl_instance_iter_dump(struct sk_buff *msg,
-- 
2.38.1

