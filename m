Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C5B2AED57
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 10:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbgKKJTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 04:19:44 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:37906 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgKKJTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 04:19:38 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 0DA305C18A9;
        Wed, 11 Nov 2020 17:19:34 +0800 (CST)
From:   wenxu@ucloud.cn
To:     kuba@kernel.org, marcelo.leitner@gmail.com, vladbu@nvidia.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH v9 net-next 2/3] net/sched: act_mirred: refactor the handle of xmit
Date:   Wed, 11 Nov 2020 17:19:31 +0800
Message-Id: <1605086372-22822-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605086372-22822-1-git-send-email-wenxu@ucloud.cn>
References: <1605086372-22822-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZTxlMSUoaQx1MHx5JVkpNS05LQ01ITE9KSEJVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hOT1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MQg6Cio*Fj00Ij86DAkYQ0kK
        CTgaCghVSlVKTUtOS0NNSExPT0lOVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlCT0I3Bg++
X-HM-Tid: 0a75b69a68bd2087kuqy0da305c18a9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This one is prepare for the next patch.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v9: no change

 include/net/sch_generic.h |  5 -----
 net/sched/act_mirred.c    | 21 +++++++++++++++------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index d8fd867..dd74f06 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -1281,9 +1281,4 @@ void mini_qdisc_pair_init(struct mini_Qdisc_pair *miniqp, struct Qdisc *qdisc,
 void mini_qdisc_pair_block_init(struct mini_Qdisc_pair *miniqp,
 				struct tcf_block *block);
 
-static inline int skb_tc_reinsert(struct sk_buff *skb, struct tcf_result *res)
-{
-	return res->ingress ? netif_receive_skb(skb) : dev_queue_xmit(skb);
-}
-
 #endif
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index e24b7e2..17d0095 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -205,6 +205,18 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 	return err;
 }
 
+static int tcf_mirred_forward(bool want_ingress, struct sk_buff *skb)
+{
+	int err;
+
+	if (!want_ingress)
+		err = dev_queue_xmit(skb);
+	else
+		err = netif_receive_skb(skb);
+
+	return err;
+}
+
 static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 			  struct tcf_result *res)
 {
@@ -287,18 +299,15 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 		/* let's the caller reinsert the packet, if possible */
 		if (use_reinsert) {
 			res->ingress = want_ingress;
-			if (skb_tc_reinsert(skb, res))
+			err = tcf_mirred_forward(res->ingress, skb);
+			if (err)
 				tcf_action_inc_overlimit_qstats(&m->common);
 			__this_cpu_dec(mirred_rec_level);
 			return TC_ACT_CONSUMED;
 		}
 	}
 
-	if (!want_ingress)
-		err = dev_queue_xmit(skb2);
-	else
-		err = netif_receive_skb(skb2);
-
+	err = tcf_mirred_forward(want_ingress, skb2);
 	if (err) {
 out:
 		tcf_action_inc_overlimit_qstats(&m->common);
-- 
1.8.3.1

