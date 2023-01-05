Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D44665E45C
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjAEEFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbjAEEFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:05:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA5737255
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 20:05:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACEC460C95
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 04:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D95C433F0;
        Thu,  5 Jan 2023 04:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672891541;
        bh=YX03cy8yjEPAhzPi1pdn2cl/aT97a3Jv0KdsNrvQz6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZfEbu7rcs7HmSY1X6meaLkDaKA+t8ot4vkrv7JJpxcaI1akeNUdY8U/8ELm2D05U8
         pcuwSCzB2EXcoI7RiY/gZTgHSi+bm9cNxbw0pvKbzIfYDtsjZY1VjtszAvgV03wk7j
         5YYiX5ofM4LiBwr7XTt7CmGy29Q2iPqeXzqacBvHpqhX2dqDiB1ofjFjJhyW5RxIZB
         RBGH9AqonVgE3gr6AJVLnS7jK2QzcnM7sV23RgCvxp6w8Hn+sbb5xt+bzMdTaD4GGn
         tXEKkitbZRWz8OpUyUd6+nu3SDQfOcLE8ZarQQEAIFBH9L3Tjdpqu9bCnMnHdC+ITw
         NXo74b3Ik17JQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 07/15] devlink: remove start variables from dumps
Date:   Wed,  4 Jan 2023 20:05:23 -0800
Message-Id: <20230105040531.353563-8-kuba@kernel.org>
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

The start variables made the code clearer when we had to access
cb->args[0] directly, as the name args doesn't explain much.
Now that we use a structure to hold state this seems no longer
needed.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/leftover.c | 55 +++++++++++++++---------------------------
 1 file changed, 19 insertions(+), 36 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 56ff63b41e96..d88461b33ddf 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -1225,7 +1225,6 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
 	struct devlink_rate *devlink_rate;
 	struct devlink *devlink;
-	int start = state->idx;
 	unsigned long index;
 	int idx = 0;
 	int err = 0;
@@ -1236,7 +1235,7 @@ static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
 			enum devlink_command cmd = DEVLINK_CMD_RATE_NEW;
 			u32 id = NETLINK_CB(cb->skb).portid;
 
-			if (idx < start) {
+			if (idx < state->idx) {
 				idx++;
 				continue;
 			}
@@ -1320,13 +1319,12 @@ static int devlink_nl_cmd_get_dumpit(struct sk_buff *msg,
 {
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
 	struct devlink *devlink;
-	int start = state->idx;
 	unsigned long index;
 	int idx = 0;
 	int err;
 
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
-		if (idx < start) {
+		if (idx < state->idx) {
 			idx++;
 			devlink_put(devlink);
 			continue;
@@ -1377,14 +1375,13 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 	struct devlink *devlink;
 	struct devlink_port *devlink_port;
 	unsigned long index, port_index;
-	int start = state->idx;
 	int idx = 0;
 	int err;
 
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		devl_lock(devlink);
 		xa_for_each(&devlink->ports, port_index, devlink_port) {
-			if (idx < start) {
+			if (idx < state->idx) {
 				idx++;
 				continue;
 			}
@@ -2156,7 +2153,6 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
 	struct devlink_linecard *linecard;
 	struct devlink *devlink;
-	int start = state->idx;
 	unsigned long index;
 	int idx = 0;
 	int err;
@@ -2164,7 +2160,7 @@ static int devlink_nl_cmd_linecard_get_dumpit(struct sk_buff *msg,
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		mutex_lock(&devlink->linecards_lock);
 		list_for_each_entry(linecard, &devlink->linecard_list, list) {
-			if (idx < start) {
+			if (idx < state->idx) {
 				idx++;
 				continue;
 			}
@@ -2419,7 +2415,6 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
 	struct devlink *devlink;
 	struct devlink_sb *devlink_sb;
-	int start = state->idx;
 	unsigned long index;
 	int idx = 0;
 	int err;
@@ -2427,7 +2422,7 @@ static int devlink_nl_cmd_sb_get_dumpit(struct sk_buff *msg,
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		devl_lock(devlink);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
-			if (idx < start) {
+			if (idx < state->idx) {
 				idx++;
 				continue;
 			}
@@ -2562,7 +2557,6 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
 	struct devlink *devlink;
 	struct devlink_sb *devlink_sb;
-	int start = state->idx;
 	unsigned long index;
 	int idx = 0;
 	int err = 0;
@@ -2573,8 +2567,8 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 
 		devl_lock(devlink);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
-			err = __sb_pool_get_dumpit(msg, start, &idx, devlink,
-						   devlink_sb,
+			err = __sb_pool_get_dumpit(msg, state->idx, &idx,
+						   devlink, devlink_sb,
 						   NETLINK_CB(cb->skb).portid,
 						   cb->nlh->nlmsg_seq);
 			if (err == -EOPNOTSUPP) {
@@ -2778,7 +2772,6 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
 	struct devlink *devlink;
 	struct devlink_sb *devlink_sb;
-	int start = state->idx;
 	unsigned long index;
 	int idx = 0;
 	int err = 0;
@@ -2789,7 +2782,7 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 
 		devl_lock(devlink);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
-			err = __sb_port_pool_get_dumpit(msg, start, &idx,
+			err = __sb_port_pool_get_dumpit(msg, state->idx, &idx,
 							devlink, devlink_sb,
 							NETLINK_CB(cb->skb).portid,
 							cb->nlh->nlmsg_seq);
@@ -3022,7 +3015,6 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
 	struct devlink *devlink;
 	struct devlink_sb *devlink_sb;
-	int start = state->idx;
 	unsigned long index;
 	int idx = 0;
 	int err = 0;
@@ -3033,9 +3025,8 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 
 		devl_lock(devlink);
 		list_for_each_entry(devlink_sb, &devlink->sb_list, list) {
-			err = __sb_tc_pool_bind_get_dumpit(msg, start, &idx,
-							   devlink,
-							   devlink_sb,
+			err = __sb_tc_pool_bind_get_dumpit(msg, state->idx, &idx,
+							   devlink, devlink_sb,
 							   NETLINK_CB(cb->skb).portid,
 							   cb->nlh->nlmsg_seq);
 			if (err == -EOPNOTSUPP) {
@@ -4881,13 +4872,12 @@ static int devlink_nl_cmd_selftests_get_dumpit(struct sk_buff *msg,
 {
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
 	struct devlink *devlink;
-	int start = state->idx;
 	unsigned long index;
 	int idx = 0;
 	int err = 0;
 
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
-		if (idx < start || !devlink->ops->selftest_check)
+		if (idx < state->idx || !devlink->ops->selftest_check)
 			goto inc;
 
 		devl_lock(devlink);
@@ -5363,7 +5353,6 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
 	struct devlink_param_item *param_item;
 	struct devlink *devlink;
-	int start = state->idx;
 	unsigned long index;
 	int idx = 0;
 	int err = 0;
@@ -5371,7 +5360,7 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		devl_lock(devlink);
 		list_for_each_entry(param_item, &devlink->param_list, list) {
-			if (idx < start) {
+			if (idx < state->idx) {
 				idx++;
 				continue;
 			}
@@ -6107,14 +6096,13 @@ static int devlink_nl_cmd_region_get_dumpit(struct sk_buff *msg,
 {
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
 	struct devlink *devlink;
-	int start = state->idx;
 	unsigned long index;
 	int idx = 0;
 	int err = 0;
 
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		err = devlink_nl_cmd_region_get_devlink_dumpit(msg, cb, devlink,
-							       &idx, start);
+							       &idx, state->idx);
 		devlink_put(devlink);
 		if (err)
 			goto out;
@@ -6759,13 +6747,12 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 {
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
 	struct devlink *devlink;
-	int start = state->idx;
 	unsigned long index;
 	int idx = 0;
 	int err = 0;
 
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
-		if (idx < start)
+		if (idx < state->idx)
 			goto inc;
 
 		devl_lock(devlink);
@@ -7930,7 +7917,6 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 	unsigned long index, port_index;
 	struct devlink_port *port;
 	struct devlink *devlink;
-	int start = state->idx;
 	int idx = 0;
 	int err;
 
@@ -7938,7 +7924,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		mutex_lock(&devlink->reporters_lock);
 		list_for_each_entry(reporter, &devlink->reporter_list,
 				    list) {
-			if (idx < start) {
+			if (idx < state->idx) {
 				idx++;
 				continue;
 			}
@@ -7962,7 +7948,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		xa_for_each(&devlink->ports, port_index, port) {
 			mutex_lock(&port->reporters_lock);
 			list_for_each_entry(reporter, &port->reporter_list, list) {
-				if (idx < start) {
+				if (idx < state->idx) {
 					idx++;
 					continue;
 				}
@@ -8513,7 +8499,6 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
 	struct devlink_trap_item *trap_item;
 	struct devlink *devlink;
-	int start = state->idx;
 	unsigned long index;
 	int idx = 0;
 	int err;
@@ -8521,7 +8506,7 @@ static int devlink_nl_cmd_trap_get_dumpit(struct sk_buff *msg,
 	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
 		devl_lock(devlink);
 		list_for_each_entry(trap_item, &devlink->trap_list, list) {
-			if (idx < start) {
+			if (idx < state->idx) {
 				idx++;
 				continue;
 			}
@@ -8731,7 +8716,6 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 	struct devlink_trap_group_item *group_item;
 	u32 portid = NETLINK_CB(cb->skb).portid;
 	struct devlink *devlink;
-	int start = state->idx;
 	unsigned long index;
 	int idx = 0;
 	int err;
@@ -8740,7 +8724,7 @@ static int devlink_nl_cmd_trap_group_get_dumpit(struct sk_buff *msg,
 		devl_lock(devlink);
 		list_for_each_entry(group_item, &devlink->trap_group_list,
 				    list) {
-			if (idx < start) {
+			if (idx < state->idx) {
 				idx++;
 				continue;
 			}
@@ -9036,7 +9020,6 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 	struct devlink_trap_policer_item *policer_item;
 	u32 portid = NETLINK_CB(cb->skb).portid;
 	struct devlink *devlink;
-	int start = state->idx;
 	unsigned long index;
 	int idx = 0;
 	int err;
@@ -9045,7 +9028,7 @@ static int devlink_nl_cmd_trap_policer_get_dumpit(struct sk_buff *msg,
 		devl_lock(devlink);
 		list_for_each_entry(policer_item, &devlink->trap_policer_list,
 				    list) {
-			if (idx < start) {
+			if (idx < state->idx) {
 				idx++;
 				continue;
 			}
-- 
2.38.1

