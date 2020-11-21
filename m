Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80AD62BC06C
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 17:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgKUQJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 11:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgKUQJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 11:09:18 -0500
Received: from mail.buslov.dev (mail.buslov.dev [IPv6:2001:19f0:5001:2e3f:5400:1ff:feed:a259])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B4FC0613CF
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 08:09:17 -0800 (PST)
Received: from vlad-x1g6.localdomain (unknown [IPv6:2a0b:2bc3:193f:1:a5fe:a7d6:6345:fe8d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id 181BE1F4E0;
        Sat, 21 Nov 2020 18:09:13 +0200 (EET)
From:   Vlad Buslov <vlad@buslov.dev>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Vlad Buslov <vlad@buslov.dev>
Subject: [PATCH net-next] net: sched: alias action flags with TCA_ACT_ prefix
Date:   Sat, 21 Nov 2020 18:09:02 +0200
Message-Id: <20201121160902.808705-1-vlad@buslov.dev>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently both filter and action flags use same "TCA_" prefix which makes
them hard to distinguish to code and confusing for users. Create aliases
for existing action flags constants with "TCA_ACT_" prefix.

Signed-off-by: Vlad Buslov <vlad@buslov.dev>
---
 include/uapi/linux/rtnetlink.h | 11 +++++++----
 net/sched/act_api.c            | 10 +++++-----
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 2ffbef5da6c1..91db081e5360 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -768,16 +768,19 @@ enum {
 #define TA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct tcamsg))
 /* tcamsg flags stored in attribute TCA_ROOT_FLAGS
  *
- * TCA_FLAG_LARGE_DUMP_ON user->kernel to request for larger than TCA_ACT_MAX_PRIO
- * actions in a dump. All dump responses will contain the number of actions
- * being dumped stored in for user app's consumption in TCA_ROOT_COUNT
+ * TCA_ACT_FLAG_LARGE_DUMP_ON user->kernel to request for larger than
+ * TCA_ACT_MAX_PRIO actions in a dump. All dump responses will contain the
+ * number of actions being dumped stored in for user app's consumption in
+ * TCA_ROOT_COUNT
  *
- * TCA_FLAG_TERSE_DUMP user->kernel to request terse (brief) dump that only
+ * TCA_ACT_FLAG_TERSE_DUMP user->kernel to request terse (brief) dump that only
  * includes essential action info (kind, index, etc.)
  *
  */
 #define TCA_FLAG_LARGE_DUMP_ON		(1 << 0)
+#define TCA_ACT_FLAG_LARGE_DUMP_ON	TCA_FLAG_LARGE_DUMP_ON
 #define TCA_FLAG_TERSE_DUMP		(1 << 1)
+#define TCA_ACT_FLAG_TERSE_DUMP		TCA_FLAG_TERSE_DUMP
 
 /* New extended info filters for IFLA_EXT_MASK */
 #define RTEXT_FILTER_VF		(1 << 0)
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index fc23f46a315c..99db1c77426b 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -278,7 +278,7 @@ static int tcf_dump_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 			index--;
 			goto nla_put_failure;
 		}
-		err = (act_flags & TCA_FLAG_TERSE_DUMP) ?
+		err = (act_flags & TCA_ACT_FLAG_TERSE_DUMP) ?
 			tcf_action_dump_terse(skb, p, true) :
 			tcf_action_dump_1(skb, p, 0, 0);
 		if (err < 0) {
@@ -288,7 +288,7 @@ static int tcf_dump_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 		}
 		nla_nest_end(skb, nest);
 		n_i++;
-		if (!(act_flags & TCA_FLAG_LARGE_DUMP_ON) &&
+		if (!(act_flags & TCA_ACT_FLAG_LARGE_DUMP_ON) &&
 		    n_i >= TCA_ACT_MAX_PRIO)
 			goto done;
 	}
@@ -298,7 +298,7 @@ static int tcf_dump_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 
 	mutex_unlock(&idrinfo->lock);
 	if (n_i) {
-		if (act_flags & TCA_FLAG_LARGE_DUMP_ON)
+		if (act_flags & TCA_ACT_FLAG_LARGE_DUMP_ON)
 			cb->args[1] = n_i;
 	}
 	return n_i;
@@ -1473,8 +1473,8 @@ static int tcf_action_add(struct net *net, struct nlattr *nla,
 }
 
 static const struct nla_policy tcaa_policy[TCA_ROOT_MAX + 1] = {
-	[TCA_ROOT_FLAGS] = NLA_POLICY_BITFIELD32(TCA_FLAG_LARGE_DUMP_ON |
-						 TCA_FLAG_TERSE_DUMP),
+	[TCA_ROOT_FLAGS] = NLA_POLICY_BITFIELD32(TCA_ACT_FLAG_LARGE_DUMP_ON |
+						 TCA_ACT_FLAG_TERSE_DUMP),
 	[TCA_ROOT_TIME_DELTA]      = { .type = NLA_U32 },
 };
 
-- 
2.29.1

