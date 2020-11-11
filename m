Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE0D2AE6B0
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 03:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731899AbgKKC7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 21:59:31 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:16014 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbgKKC7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 21:59:25 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 1030B5C1F46;
        Wed, 11 Nov 2020 10:49:28 +0800 (CST)
From:   wenxu@ucloud.cn
To:     kuba@kernel.org, marcelo.leitner@gmail.com, dcaratti@redhat.com,
        vladbu@nvidia.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH v7 net-next 2/3] net/sched: act_mirred: refactor the handle of xmit
Date:   Wed, 11 Nov 2020 10:49:26 +0800
Message-Id: <1605062967-19819-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605062967-19819-1-git-send-email-wenxu@ucloud.cn>
References: <1605062967-19819-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZHk5ISRlOTUJMS0sYVkpNS05LTUlCTUNKT01VGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PD46Nio*Hz0#EDgLThgUDE4d
        OjUwFClVSlVKTUtOS01JQk1DSE1IVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlCQkg3Bg++
X-HM-Tid: 0a75b535431d2087kuqy1030b5c1f46
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This one is prepare for the next patch.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v7: no change

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

