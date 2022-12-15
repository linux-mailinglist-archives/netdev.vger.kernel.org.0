Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6374864D531
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 03:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiLOCCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 21:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiLOCCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 21:02:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D168752883
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 18:02:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 660D1B81AD8
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 02:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FAAC433F0;
        Thu, 15 Dec 2022 02:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671069726;
        bh=gwLpqkXHdFgrY/vpVNHxuEpY+M0oAitt+7vSFmPFXyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HouxQuSJPyYH4maNTG+JzqALYuQJUd+c3PWaZifKK7k60sMMB8Mi0qdV9qPATCrlZ
         ktreI/E8BsgtDjLL2HDVXPZNTX0U+cfMQBJB1FfmDKh7yaWetjO5RWQEgIulWOBQh7
         UIjAfyvXbvIShVfVwEC6836DkoIkspHUcvhsV6qtgZ9hoMd9hZE2RmHloiwtiATyBQ
         1UII3EFxigJBz3jA4pL42uuCrztkCnNv1P4jl/GshPhrMKD6Lw2EgtLGAnmedR4xj1
         F7V7PUnkx3mcWpnKctzadWKjAcO2U3q2Z84CYWT7GXbce9A4U0idJldsrbLrxqJCVK
         d++5n4I2wFiwA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, jacob.e.keller@intel.com, leon@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 06/15] devlink: use an explicit structure for dump context
Date:   Wed, 14 Dec 2022 18:01:46 -0800
Message-Id: <20221215020155.1619839-7-kuba@kernel.org>
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

Create a dump context structure instead of using cb->args
as an unsigned long array. This is a pure conversion which
is intended to be as much of a noop as possible.
Subsequent changes will use this to simplify the code.

The two non-trivial parts are:
 - devlink_nl_cmd_health_reporter_dump_get_dumpit() checks args[0]
   to see if devlink_fmsg_dumpit() has already been called (whether
   this is the first msg), but doesn't use the exact value, so we
   can drop the local variable there already
 - devlink_nl_cmd_region_read_dumpit() uses args[0] for address
   but we'll use args[1] now, shouldn't matter

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/basic.c         | 98 ++++++++++++++++++++++---------------
 net/devlink/devl_internal.h | 23 +++++++++
 2 files changed, 81 insertions(+), 40 deletions(-)

diff --git a/net/devlink/basic.c b/net/devlink/basic.c
index e01ba7999b91..bcc930b7cfcf 100644
--- a/net/devlink/basic.c
+++ b/net/devlink/basic.c
@@ -1222,9 +1222,10 @@ static void devlink_rate_notify(struct devlink_rate *devlink_rate,
 static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 					  struct netlink_callback *cb)
 {
+	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	struct devlink_rate *devlink_rate;
 	struct devlink *devlink;
-	int start = cb->args[0];
+	int start = dump->idx;
 	unsigned long index;
 	int idx = 0;
 	int err = 0;
@@ -1256,7 +1257,7 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 	if (err != -EMSGSIZE)
 		return err;
 
-	cb->args[0] = idx;
+	dump->idx = idx;
 	return msg->len;
 }
 
@@ -1317,8 +1318,9 @@ static int devlink_nl_cmd_get_doit(struct sk_buff *skb, struct genl_info *info)
 static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
 				     struct netlink_callback *cb)
 {
+	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	struct devlink *devlink;
-	int start = cb->args[0];
+	int start = dump->idx;
 	unsigned long index;
 	int idx = 0;
 	int err;
@@ -1342,7 +1344,7 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
 		idx++;
 	}
 out:
-	cb->args[0] = idx;
+	dump->idx = idx;
 	return msg->len;
 }
 
@@ -1371,10 +1373,11 @@ static int devlink_nl_cmd_port_get_doit(struct sk_buff *skb,
 static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 					  struct netlink_callback *cb)
 {
+	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	struct devlink *devlink;
 	struct devlink_port *devlink_port;
 	unsigned long index, port_index;
-	int start = cb->args[0];
+	int start = dump->idx;
 	int idx = 0;
 	int err;
 
@@ -1401,7 +1404,7 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	cb->args[0] = idx;
+	dump->idx = idx;
 	return msg->len;
 }
 
@@ -2150,9 +2153,10 @@ static int devlink_nl_cmd_linecard_get_doit(struct sk_buff *skb,
 static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 					      struct netlink_callback *cb)
 {
+	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	struct devlink_linecard *linecard;
 	struct devlink *devlink;
-	int start = cb->args[0];
+	int start = dump->idx;
 	unsigned long index;
 	int idx = 0;
 	int err;
@@ -2183,7 +2187,7 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	cb->args[0] = idx;
+	dump->idx = idx;
 	return msg->len;
 }
 
@@ -2412,9 +2416,10 @@ static int devlink_nl_cmd_sb_get_doit(struct sk_buff *skb,
 static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 					struct netlink_callback *cb)
 {
+	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	struct devlink *devlink;
 	struct devlink_sb *devlink_sb;
-	int start = cb->args[0];
+	int start = dump->idx;
 	unsigned long index;
 	int idx = 0;
 	int err;
@@ -2442,7 +2447,7 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	cb->args[0] = idx;
+	dump->idx = idx;
 	return msg->len;
 }
 
@@ -2554,9 +2559,10 @@ static int __sb_pool_get_dumpit(struct sk_buff *msg, int start, int *p_idx,
 static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 					     struct netlink_callback *cb)
 {
+	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	struct devlink *devlink;
 	struct devlink_sb *devlink_sb;
-	int start = cb->args[0];
+	int start = dump->idx;
 	unsigned long index;
 	int idx = 0;
 	int err = 0;
@@ -2587,7 +2593,7 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 	if (err != -EMSGSIZE)
 		return err;
 
-	cb->args[0] = idx;
+	dump->idx = idx;
 	return msg->len;
 }
 
@@ -2769,9 +2775,10 @@ static int __sb_port_pool_get_dumpit(struct sk_buff *msg, int start, int *p_idx,
 static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 						  struct netlink_callback *cb)
 {
+	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	struct devlink *devlink;
 	struct devlink_sb *devlink_sb;
-	int start = cb->args[0];
+	int start = dump->idx;
 	unsigned long index;
 	int idx = 0;
 	int err = 0;
@@ -2802,7 +2809,7 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 	if (err != -EMSGSIZE)
 		return err;
 
-	cb->args[0] = idx;
+	dump->idx = idx;
 	return msg->len;
 }
 
@@ -3012,9 +3019,10 @@ static int
 devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 					  struct netlink_callback *cb)
 {
+	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	struct devlink *devlink;
 	struct devlink_sb *devlink_sb;
-	int start = cb->args[0];
+	int start = dump->idx;
 	unsigned long index;
 	int idx = 0;
 	int err = 0;
@@ -3046,7 +3054,7 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 	if (err != -EMSGSIZE)
 		return err;
 
-	cb->args[0] = idx;
+	dump->idx = idx;
 	return msg->len;
 }
 
@@ -4871,8 +4879,9 @@ static int devlink_nl_cmd_selftests_get_doit(struct sk_buff *skb,
 static int devlink_nl_cmd_selftests_get_dumpit(struct sk_buff *msg,
 					       struct netlink_callback *cb)
 {
+	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	struct devlink *devlink;
-	int start = cb->args[0];
+	int start = dump->idx;
 	unsigned long index;
 	int idx = 0;
 	int err = 0;
@@ -4899,7 +4908,7 @@ static int devlink_nl_cmd_selftests_get_dumpit(struct sk_buff *msg,
 	if (err != -EMSGSIZE)
 		return err;
 
-	cb->args[0] = idx;
+	dump->idx = idx;
 	return msg->len;
 }
 
@@ -5351,9 +5360,10 @@ static void devlink_param_notify(struct devlink *devlink,
 static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 					   struct netlink_callback *cb)
 {
+	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	struct devlink_param_item *param_item;
 	struct devlink *devlink;
-	int start = cb->args[0];
+	int start = dump->idx;
 	unsigned long index;
 	int idx = 0;
 	int err = 0;
@@ -5386,7 +5396,7 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 	if (err != -EMSGSIZE)
 		return err;
 
-	cb->args[0] = idx;
+	dump->idx = idx;
 	return msg->len;
 }
 
@@ -6095,8 +6105,9 @@ static int devlink_nl_cmd_region_get_devlink_dumpit(struct sk_buff *msg,
 static int devlink_nl_cmd_region_get_dumpit(struct sk_buff *msg,
 					    struct netlink_callback *cb)
 {
+	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	struct devlink *devlink;
-	int start = cb->args[0];
+	int start = dump->idx;
 	unsigned long index;
 	int idx = 0;
 	int err = 0;
@@ -6109,7 +6120,7 @@ static int devlink_nl_cmd_region_get_dumpit(struct sk_buff *msg,
 			goto out;
 	}
 out:
-	cb->args[0] = idx;
+	dump->idx = idx;
 	return msg->len;
 }
 
@@ -6394,6 +6405,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 					     struct netlink_callback *cb)
 {
 	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
+	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	struct nlattr *chunks_attr, *region_attr, *snapshot_attr;
 	u64 ret_offset, start_offset, end_offset = U64_MAX;
 	struct nlattr **attrs = info->attrs;
@@ -6407,7 +6419,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	void *hdr;
 	int err;
 
-	start_offset = *((u64 *)&cb->args[0]);
+	start_offset = dump->start_offset;
 
 	devlink = devlink_get_from_attrs(sock_net(cb->skb->sk), attrs);
 	if (IS_ERR(devlink))
@@ -6546,7 +6558,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		goto nla_put_failure;
 	}
 
-	*((u64 *)&cb->args[0]) = ret_offset;
+	dump->start_offset = ret_offset;
 
 	nla_nest_end(skb, chunks_attr);
 	genlmsg_end(skb, hdr);
@@ -6745,8 +6757,9 @@ static int devlink_nl_cmd_info_get_doit(struct sk_buff *skb,
 static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 					  struct netlink_callback *cb)
 {
+	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	struct devlink *devlink;
-	int start = cb->args[0];
+	int start = dump->idx;
 	unsigned long index;
 	int idx = 0;
 	int err = 0;
@@ -6775,7 +6788,7 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 	if (err != -EMSGSIZE)
 		return err;
 
-	cb->args[0] = idx;
+	dump->idx = idx;
 	return msg->len;
 }
 
@@ -7344,7 +7357,8 @@ static int devlink_fmsg_dumpit(struct devlink_fmsg *fmsg, struct sk_buff *skb,
 			       struct netlink_callback *cb,
 			       enum devlink_command cmd)
 {
-	int index = cb->args[0];
+	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
+	int index = dump->idx;
 	int tmp_index = index;
 	void *hdr;
 	int err;
@@ -7360,7 +7374,7 @@ static int devlink_fmsg_dumpit(struct devlink_fmsg *fmsg, struct sk_buff *skb,
 	if ((err && err != -EMSGSIZE) || tmp_index == index)
 		goto nla_put_failure;
 
-	cb->args[0] = index;
+	dump->idx = index;
 	genlmsg_end(skb, hdr);
 	return skb->len;
 
@@ -7911,11 +7925,12 @@ static int
 devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 					  struct netlink_callback *cb)
 {
+	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	struct devlink_health_reporter *reporter;
 	unsigned long index, port_index;
 	struct devlink_port *port;
 	struct devlink *devlink;
-	int start = cb->args[0];
+	int start = dump->idx;
 	int idx = 0;
 	int err;
 
@@ -7970,7 +7985,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	cb->args[0] = idx;
+	dump->idx = idx;
 	return msg->len;
 }
 
@@ -8082,8 +8097,8 @@ static int
 devlink_nl_cmd_health_reporter_dump_get_dumpit(struct sk_buff *skb,
 					       struct netlink_callback *cb)
 {
+	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	struct devlink_health_reporter *reporter;
-	u64 start = cb->args[0];
 	int err;
 
 	reporter = devlink_health_reporter_get_from_cb(cb);
@@ -8095,13 +8110,13 @@ devlink_nl_cmd_health_reporter_dump_get_dumpit(struct sk_buff *skb,
 		goto out;
 	}
 	mutex_lock(&reporter->dump_lock);
-	if (!start) {
+	if (!dump->idx) {
 		err = devlink_health_do_dump(reporter, NULL, cb->extack);
 		if (err)
 			goto unlock;
-		cb->args[1] = reporter->dump_ts;
+		dump->dump_ts = reporter->dump_ts;
 	}
-	if (!reporter->dump_fmsg || cb->args[1] != reporter->dump_ts) {
+	if (!reporter->dump_fmsg || dump->dump_ts != reporter->dump_ts) {
 		NL_SET_ERR_MSG_MOD(cb->extack, "Dump trampled, please retry");
 		err = -EAGAIN;
 		goto unlock;
@@ -8495,9 +8510,10 @@ static int devlink_nl_cmd_trap_get_doit(struct sk_buff *skb,
 static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 					  struct netlink_callback *cb)
 {
+	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	struct devlink_trap_item *trap_item;
 	struct devlink *devlink;
-	int start = cb->args[0];
+	int start = dump->idx;
 	unsigned long index;
 	int idx = 0;
 	int err;
@@ -8525,7 +8541,7 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	cb->args[0] = idx;
+	dump->idx = idx;
 	return msg->len;
 }
 
@@ -8710,11 +8726,12 @@ static int devlink_nl_cmd_trap_group_get_doit(struct sk_buff *skb,
 static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 						struct netlink_callback *cb)
 {
+	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	enum devlink_command cmd = DEVLINK_CMD_TRAP_GROUP_NEW;
 	struct devlink_trap_group_item *group_item;
 	u32 portid = NETLINK_CB(cb->skb).portid;
 	struct devlink *devlink;
-	int start = cb->args[0];
+	int start = dump->idx;
 	unsigned long index;
 	int idx = 0;
 	int err;
@@ -8743,7 +8760,7 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	cb->args[0] = idx;
+	dump->idx = idx;
 	return msg->len;
 }
 
@@ -9014,11 +9031,12 @@ static int devlink_nl_cmd_trap_policer_get_doit(struct sk_buff *skb,
 static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 						  struct netlink_callback *cb)
 {
+	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	enum devlink_command cmd = DEVLINK_CMD_TRAP_POLICER_NEW;
 	struct devlink_trap_policer_item *policer_item;
 	u32 portid = NETLINK_CB(cb->skb).portid;
 	struct devlink *devlink;
-	int start = cb->args[0];
+	int start = dump->idx;
 	unsigned long index;
 	int idx = 0;
 	int err;
@@ -9047,7 +9065,7 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	cb->args[0] = idx;
+	dump->idx = idx;
 	return msg->len;
 }
 
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index bc7df9b0f775..91059311f18d 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -107,6 +107,21 @@ enum devlink_multicast_groups {
 	DEVLINK_MCGRP_CONFIG,
 };
 
+/* state held across netlink dumps */
+struct devlink_nl_dump_state {
+	int idx;
+	union {
+		/* DEVLINK_CMD_REGION_READ */
+		struct {
+			u64 start_offset;
+		};
+		/* DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET */
+		struct {
+			u64 dump_ts;
+		};
+	};
+};
+
 extern const struct genl_small_ops devlink_nl_ops[56];
 
 struct devlink *devlink_get_from_attrs(struct net *net, struct nlattr **attrs);
@@ -114,6 +129,14 @@ struct devlink *devlink_get_from_attrs(struct net *net, struct nlattr **attrs);
 void devlink_notify_unregister(struct devlink *devlink);
 void devlink_notify_register(struct devlink *devlink);
 
+static inline struct devlink_nl_dump_state *
+devl_dump_state(struct netlink_callback *cb)
+{
+	NL_ASSET_DUMP_CTX_FITS(struct devlink_nl_dump_state);
+
+	return (struct devlink_nl_dump_state *)cb->ctx;
+}
+
 /* Ports */
 int devlink_port_netdevice_event(struct notifier_block *nb,
 				 unsigned long event, void *ptr);
-- 
2.38.1

