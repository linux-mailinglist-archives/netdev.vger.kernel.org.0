Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A47892A1A83
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 21:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728498AbgJaURU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 16:17:20 -0400
Received: from mail.buslov.dev ([199.247.26.29]:54993 "EHLO mail.buslov.dev"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728451AbgJaURU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 16:17:20 -0400
Received: from vlad-x1g6.localdomain (unknown [IPv6:2a0b:2bc3:193f:1:a5fe:a7d6:6345:fe8d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id 3D8851F8EB;
        Sat, 31 Oct 2020 22:17:16 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=buslov.dev; s=2019;
        t=1604175436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/MRsBptjn2ARqX2kGNDWJoXIS7Wq2Lijdo8HX/wnMps=;
        b=Z5RFMjt36mc6CSBXEGWhuY6zTkTQcV41YtWP//BcG383tG4WHKhLI7Av62ty7T4ZNPn1kJ
        r11G9hljYeto6eOnKGbSc2mUiDg6xZP4ItZGkkuUGXrMFoVYYWTN+FlwIl1KhAigVcINVu
        Y/plfiBy3AhwAfW2X+lJocF5s427aIezGqGdmJEqGqTmHltpm1DXXd/YjqwGbULGsIYmXZ
        +YOCQiTd5dU5BYWTkdkIjnIctReMeSEyfiatw4a7AEF6k1zdo52RNcfAaH4ZhQ0RSF6384
        96X+Q/uHxMunUb8rmFQfzgQNhgvEDCCWbhc9NSWrYS8rujNChKJnNPMQNgEecw==
From:   Vlad Buslov <vlad@buslov.dev>
To:     jhs@mojatatu.com, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Vlad Buslov <vlad@buslov.dev>
Subject: [PATCH net-next] net: sched: implement action-specific terse dump
Date:   Sat, 31 Oct 2020 22:16:44 +0200
Message-Id: <20201031201644.247605-1-vlad@buslov.dev>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=vlad@buslov.dev smtp.mailfrom=vlad@buslov.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow user to request action terse dump with new flag value
TCA_FLAG_TERSE_DUMP. Only output essential action info in terse dump (kind,
stats and index). This is different from filter terse dump where index is
excluded (filter can be identified by its own handle) and cookie is
included.

Move tcf_action_dump_terse() function to the beginning of source file in
order to call it from tcf_dump_walker().

Signed-off-by: Vlad Buslov <vlad@buslov.dev>
Suggested-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/uapi/linux/rtnetlink.h |  4 ++
 net/sched/act_api.c            | 69 ++++++++++++++++++----------------
 2 files changed, 41 insertions(+), 32 deletions(-)

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index fdd408f6a5d2..d1325ffb0060 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -770,8 +770,12 @@ enum {
  * actions in a dump. All dump responses will contain the number of actions
  * being dumped stored in for user app's consumption in TCA_ROOT_COUNT
  *
+ * TCA_FLAG_TERSE_DUMP user->kernel to request terse (brief) dump that only
+ * includes essential action info (kind, index, etc.)
+ *
  */
 #define TCA_FLAG_LARGE_DUMP_ON		(1 << 0)
+#define TCA_FLAG_TERSE_DUMP		(1 << 1)
 
 /* New extended info filters for IFLA_EXT_MASK */
 #define RTEXT_FILTER_VF		(1 << 0)
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index f66417d5d2c3..107e8ce3a57c 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -215,6 +215,36 @@ static size_t tcf_action_fill_size(const struct tc_action *act)
 	return sz;
 }
 
+static int
+tcf_action_dump_terse(struct sk_buff *skb, struct tc_action *a, bool from_act)
+{
+	unsigned char *b = skb_tail_pointer(skb);
+	struct tc_cookie *cookie;
+
+	if (nla_put_string(skb, TCA_KIND, a->ops->kind))
+		goto nla_put_failure;
+	if (tcf_action_copy_stats(skb, a, 0))
+		goto nla_put_failure;
+	if (from_act && nla_put_u32(skb, TCA_ACT_INDEX, a->tcfa_index))
+		goto nla_put_failure;
+
+	rcu_read_lock();
+	cookie = rcu_dereference(a->act_cookie);
+	if (cookie && !from_act) {
+		if (nla_put(skb, TCA_ACT_COOKIE, cookie->len, cookie->data)) {
+			rcu_read_unlock();
+			goto nla_put_failure;
+		}
+	}
+	rcu_read_unlock();
+
+	return 0;
+
+nla_put_failure:
+	nlmsg_trim(skb, b);
+	return -1;
+}
+
 static int tcf_dump_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 			   struct netlink_callback *cb)
 {
@@ -248,7 +278,9 @@ static int tcf_dump_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 			index--;
 			goto nla_put_failure;
 		}
-		err = tcf_action_dump_1(skb, p, 0, 0);
+		err = (act_flags & TCA_FLAG_TERSE_DUMP) ?
+			tcf_action_dump_terse(skb, p, true) :
+			tcf_action_dump_1(skb, p, 0, 0);
 		if (err < 0) {
 			index--;
 			nlmsg_trim(skb, nest);
@@ -752,34 +784,6 @@ tcf_action_dump_old(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 	return a->ops->dump(skb, a, bind, ref);
 }
 
-static int
-tcf_action_dump_terse(struct sk_buff *skb, struct tc_action *a)
-{
-	unsigned char *b = skb_tail_pointer(skb);
-	struct tc_cookie *cookie;
-
-	if (nla_put_string(skb, TCA_KIND, a->ops->kind))
-		goto nla_put_failure;
-	if (tcf_action_copy_stats(skb, a, 0))
-		goto nla_put_failure;
-
-	rcu_read_lock();
-	cookie = rcu_dereference(a->act_cookie);
-	if (cookie) {
-		if (nla_put(skb, TCA_ACT_COOKIE, cookie->len, cookie->data)) {
-			rcu_read_unlock();
-			goto nla_put_failure;
-		}
-	}
-	rcu_read_unlock();
-
-	return 0;
-
-nla_put_failure:
-	nlmsg_trim(skb, b);
-	return -1;
-}
-
 int
 tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 {
@@ -787,7 +791,7 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 	unsigned char *b = skb_tail_pointer(skb);
 	struct nlattr *nest;
 
-	if (tcf_action_dump_terse(skb, a))
+	if (tcf_action_dump_terse(skb, a, false))
 		goto nla_put_failure;
 
 	if (a->hw_stats != TCA_ACT_HW_STATS_ANY &&
@@ -832,7 +836,7 @@ int tcf_action_dump(struct sk_buff *skb, struct tc_action *actions[],
 		nest = nla_nest_start_noflag(skb, i + 1);
 		if (nest == NULL)
 			goto nla_put_failure;
-		err = terse ? tcf_action_dump_terse(skb, a) :
+		err = terse ? tcf_action_dump_terse(skb, a, false) :
 			tcf_action_dump_1(skb, a, bind, ref);
 		if (err < 0)
 			goto errout;
@@ -1469,7 +1473,8 @@ static int tcf_action_add(struct net *net, struct nlattr *nla,
 }
 
 static const struct nla_policy tcaa_policy[TCA_ROOT_MAX + 1] = {
-	[TCA_ROOT_FLAGS] = NLA_POLICY_BITFIELD32(TCA_FLAG_LARGE_DUMP_ON),
+	[TCA_ROOT_FLAGS] = NLA_POLICY_BITFIELD32(TCA_FLAG_LARGE_DUMP_ON |
+						 TCA_FLAG_TERSE_DUMP),
 	[TCA_ROOT_TIME_DELTA]      = { .type = NLA_U32 },
 };
 
-- 
2.29.1

