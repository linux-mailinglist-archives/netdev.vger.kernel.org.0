Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A3A64D52F
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 03:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiLOCCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 21:02:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiLOCCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 21:02:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3352B56D59
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 18:02:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4E90B81A26
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 02:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598E8C43392;
        Thu, 15 Dec 2022 02:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671069728;
        bh=UtmbjDYfnS2mvIY+y9IePSz5+lnPWdmmasafDo80taQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dFF1ZfznSsI4hIQVtwJGniUjyseDaOTZS4KOhTfeoZ/al+NaIJ5ArzgEobMVK640I
         yjYe66CZgGxS1zWWRSv+T9Tr2AKbFMkwZ48xlXki0JoVXeTcawFsQM8fCh8EDYDPDJ
         rrl/dm2YlC10jmYOLE7cycIxce4gVzrPqLPZCyy58SmhIOY3F/oizVlVJxfrk67QyH
         +RBa4AT0fGK9WN3st7k+V2jI3UAK2Q0YgsM6LxNP/B5YTQ4rFdTCoKsx8zTXpEO/Vb
         MeoGwBfGjDx1ScGCvM3hF0AGd8ezw+Uxp8MDAP48YdlgGM/OivkTPI+OdQq5tcnMtc
         PD1pwbtPDn3IQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, jacob.e.keller@intel.com, leon@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 11/15] devlink: restart dump based on devlink instance ids (nested)
Date:   Wed, 14 Dec 2022 18:01:51 -0800
Message-Id: <20221215020155.1619839-12-kuba@kernel.org>
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

Use xarray id for cases of simple sub-object iteration.
We'll now use the dump->instance for the devlink instances
and dump->idx for subobject index.

Moving the definition of idx into the inner loop makes sense,
so while at it also move other sub-object local variables into
the loop.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/basic.c         | 93 +++++++++++++++++++------------------
 net/devlink/devl_internal.h |  2 +-
 2 files changed, 49 insertions(+), 46 deletions(-)

diff --git a/net/devlink/basic.c b/net/devlink/basic.c
index 0f24b321b0bb..028a763feb50 100644
--- a/net/devlink/basic.c
+++ b/net/devlink/basic.c
@@ -1223,13 +1223,13 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 					  struct netlink_callback *cb)
 {
 	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
-	struct devlink_rate *devlink_rate;
 	struct devlink *devlink;
-	unsigned long index;
-	int idx = 0;
 	int err = 0;
 
-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
+	devlink_dump_for_each_instance_get(msg, dump, devlink) {
+		struct devlink_rate *devlink_rate;
+		int idx = 0;
+
 		devl_lock(devlink);
 		list_for_each_entry(devlink_rate, &devlink->rate_list, list) {
 			enum devlink_command cmd = DEVLINK_CMD_RATE_NEW;
@@ -1245,6 +1245,7 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 			if (err) {
 				devl_unlock(devlink);
 				devlink_put(devlink);
+				dump->idx = idx;
 				goto out;
 			}
 			idx++;
@@ -1256,7 +1257,6 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 	if (err != -EMSGSIZE)
 		return err;
 
-	dump->idx = idx;
 	return msg->len;
 }
 
@@ -1363,12 +1363,13 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 {
 	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	struct devlink *devlink;
-	struct devlink_port *devlink_port;
-	unsigned long index, port_index;
-	int idx = 0;
 	int err;
 
-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
+	devlink_dump_for_each_instance_get(msg, dump, devlink) {
+		struct devlink_port *devlink_port;
+		unsigned long port_index;
+		int idx = 0;
+
 		devl_lock(devlink);
 		xa_for_each(&devlink->ports, port_index, devlink_port) {
 			if (idx < dump->idx) {
@@ -1383,6 +1384,7 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 			if (err) {
 				devl_unlock(devlink);
 				devlink_put(devlink);
+				dump->idx = idx;
 				goto out;
 			}
 			idx++;
@@ -1391,7 +1393,6 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	dump->idx = idx;
 	return msg->len;
 }
 
@@ -2143,11 +2144,11 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	struct devlink_linecard *linecard;
 	struct devlink *devlink;
-	unsigned long index;
-	int idx = 0;
 	int err;
 
-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
+	devlink_dump_for_each_instance_get(msg, dump, devlink) {
+		int idx = 0;
+
 		mutex_lock(&devlink->linecards_lock);
 		list_for_each_entry(linecard, &devlink->linecard_list, list) {
 			if (idx < dump->idx) {
@@ -2165,6 +2166,7 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 			if (err) {
 				mutex_unlock(&devlink->linecards_lock);
 				devlink_put(devlink);
+				dump->idx = idx;
 				goto out;
 			}
 			idx++;
@@ -2173,7 +2175,6 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	dump->idx = idx;
 	return msg->len;
 }
 
@@ -2404,12 +2405,12 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 {
 	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	struct devlink *devlink;
-	struct devlink_sb *devlink_sb;
-	unsigned long index;
-	int idx = 0;
 	int err;
 
-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
+	devlink_dump_for_each_instance_get(msg, dump, devlink) {
+		struct devlink_sb *devlink_sb;
+		int idx = 0;
+
 		devl_lock(devlink);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
 			if (idx < dump->idx) {
@@ -2424,6 +2425,7 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 			if (err) {
 				devl_unlock(devlink);
 				devlink_put(devlink);
+				dump->idx = idx;
 				goto out;
 			}
 			idx++;
@@ -2432,7 +2434,6 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	dump->idx = idx;
 	return msg->len;
 }
 
@@ -5339,13 +5340,13 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 					   struct netlink_callback *cb)
 {
 	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
-	struct devlink_param_item *param_item;
 	struct devlink *devlink;
-	unsigned long index;
-	int idx = 0;
 	int err = 0;
 
-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
+	devlink_dump_for_each_instance_get(msg, dump, devlink) {
+		struct devlink_param_item *param_item;
+		int idx = 0;
+
 		devl_lock(devlink);
 		list_for_each_entry(param_item, &devlink->param_list, list) {
 			if (idx < dump->idx) {
@@ -5362,6 +5363,7 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 			} else if (err) {
 				devl_unlock(devlink);
 				devlink_put(devlink);
+				dump->idx = idx;
 				goto out;
 			}
 			idx++;
@@ -5373,7 +5375,6 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 	if (err != -EMSGSIZE)
 		return err;
 
-	dump->idx = idx;
 	return msg->len;
 }
 
@@ -7893,14 +7894,15 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 					  struct netlink_callback *cb)
 {
 	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
-	struct devlink_health_reporter *reporter;
-	unsigned long index, port_index;
-	struct devlink_port *port;
 	struct devlink *devlink;
-	int idx = 0;
 	int err;
 
-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
+	devlink_dump_for_each_instance_get(msg, dump, devlink) {
+		struct devlink_health_reporter *reporter;
+		struct devlink_port *port;
+		unsigned long port_index;
+		int idx = 0;
+
 		mutex_lock(&devlink->reporters_lock);
 		list_for_each_entry(reporter, &devlink->reporter_list,
 				    list) {
@@ -7915,6 +7917,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 			if (err) {
 				mutex_unlock(&devlink->reporters_lock);
 				devlink_put(devlink);
+				dump->idx = idx;
 				goto out;
 			}
 			idx++;
@@ -7938,6 +7941,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 					mutex_unlock(&port->reporters_lock);
 					devl_unlock(devlink);
 					devlink_put(devlink);
+					dump->idx = idx;
 					goto out;
 				}
 				idx++;
@@ -7948,7 +7952,6 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	dump->idx = idx;
 	return msg->len;
 }
 
@@ -8474,13 +8477,13 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 					  struct netlink_callback *cb)
 {
 	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
-	struct devlink_trap_item *trap_item;
 	struct devlink *devlink;
-	unsigned long index;
-	int idx = 0;
 	int err;
 
-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
+	devlink_dump_for_each_instance_get(msg, dump, devlink) {
+		struct devlink_trap_item *trap_item;
+		int idx = 0;
+
 		devl_lock(devlink);
 		list_for_each_entry(trap_item, &devlink->trap_list, list) {
 			if (idx < dump->idx) {
@@ -8495,6 +8498,7 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 			if (err) {
 				devl_unlock(devlink);
 				devlink_put(devlink);
+				dump->idx = idx;
 				goto out;
 			}
 			idx++;
@@ -8503,7 +8507,6 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	dump->idx = idx;
 	return msg->len;
 }
 
@@ -8690,14 +8693,14 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 {
 	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	enum devlink_command cmd = DEVLINK_CMD_TRAP_GROUP_NEW;
-	struct devlink_trap_group_item *group_item;
 	u32 portid = NETLINK_CB(cb->skb).portid;
 	struct devlink *devlink;
-	unsigned long index;
-	int idx = 0;
 	int err;
 
-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
+	devlink_dump_for_each_instance_get(msg, dump, devlink) {
+		struct devlink_trap_group_item *group_item;
+		int idx = 0;
+
 		devl_lock(devlink);
 		list_for_each_entry(group_item, &devlink->trap_group_list,
 				    list) {
@@ -8713,6 +8716,7 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 			if (err) {
 				devl_unlock(devlink);
 				devlink_put(devlink);
+				dump->idx = idx;
 				goto out;
 			}
 			idx++;
@@ -8721,7 +8725,6 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	dump->idx = idx;
 	return msg->len;
 }
 
@@ -8994,14 +8997,14 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 {
 	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	enum devlink_command cmd = DEVLINK_CMD_TRAP_POLICER_NEW;
-	struct devlink_trap_policer_item *policer_item;
 	u32 portid = NETLINK_CB(cb->skb).portid;
 	struct devlink *devlink;
-	unsigned long index;
-	int idx = 0;
 	int err;
 
-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
+	devlink_dump_for_each_instance_get(msg, dump, devlink) {
+		struct devlink_trap_policer_item *policer_item;
+		int idx = 0;
+
 		devl_lock(devlink);
 		list_for_each_entry(policer_item, &devlink->trap_policer_list,
 				    list) {
@@ -9017,6 +9020,7 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 			if (err) {
 				devl_unlock(devlink);
 				devlink_put(devlink);
+				dump->idx = idx;
 				goto out;
 			}
 			idx++;
@@ -9025,7 +9029,6 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 		devlink_put(devlink);
 	}
 out:
-	dump->idx = idx;
 	return msg->len;
 }
 
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index a567ff77601d..5adac38454fd 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -129,7 +129,7 @@ struct devlink_nl_dump_state {
 #define devlink_dump_for_each_instance_get(msg, dump, devlink)		\
 	for (; (devlink = devlinks_xa_find_get(sock_net(msg->sk),	\
 					       &dump->instance, xa_find)); \
-	     dump->instance++)
+	     dump->instance++, dump->idx = 0)
 
 extern const struct genl_small_ops devlink_nl_ops[56];
 
-- 
2.38.1

