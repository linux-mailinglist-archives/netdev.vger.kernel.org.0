Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C86461401C
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 22:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiJaVqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 17:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJaVqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 17:46:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFD91402D
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 14:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667252677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LLip2xTqpp4Q7LYGXVxecegB1M1ZXMLgU5BzOAXZhAI=;
        b=EKy0pQQOSZ0vgqnHwJfFduM1/lNi57B22L+pg9bZPH+Rd5uTXfXLva25tp9zH2PLQ1bpvb
        HYZkFocIdpL6nqbWaEPgjcFTAiRH9xsLPBTYy5MHq6PITqERvhRq+jAME0UA5Nu1n2k9z6
        jbbLnUcJu3Al9JH3r8ryVnj9UoexbzA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-98-cDm-x7BvMrCU2JX9A4anSg-1; Mon, 31 Oct 2022 17:44:34 -0400
X-MC-Unique: cDm-x7BvMrCU2JX9A4anSg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AAFB229ABA01;
        Mon, 31 Oct 2022 21:44:33 +0000 (UTC)
Received: from dcaratti.users.ipa.redhat.com (ovpn-192-52.brq.redhat.com [10.40.192.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2AEC5111E3E4;
        Mon, 31 Oct 2022 21:44:31 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     dcaratti@redhat.com
Cc:     jhs@mojatatu.com, jiri@resnulli.us, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, pabeni@redhat.com, wizhao@redhat.com,
        xiyou.wangcong@gmail.com, peilin.ye@bytedance.com
Subject: [RFC net-next] net/sched: act_mirred: allow mirred ingress through networking backlog
Date:   Mon, 31 Oct 2022 22:44:26 +0100
Message-Id: <0b153a5ab818dff51110f81550a4050538605a4b.1667252314.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

using TC mirrred in the ingress direction, packets are passed directly
to the receiver in the same context. There are a couple of reasons that
justify the proposal to use kernel networking backlog instead:

a) avoid the soft lockup observed with TCP when it sends data+ack after
   receiving packets through mirred (William sees them using OVS,
   something similar can be obtained with a kselftest [1)]
b) avoid packet drops caused by mirred hitting MIRRED_RECURSION_LIMIT
   in the above scenario

however, like Cong pointed out [2], we can't just change mirred redirect to
use the networking backlog: this would break users expectation, because it
would be impossible to know the RX status after a packet has been enqueued
to the backlog.

A possible approach can be to extend the current set of TC mirred "eaction",
so that the application can choose to use the backlog instead of the classic
ingress redirect. This would also ease future decisions of performing a
complete scrub of the skb metadata for those packets, without changing the
behavior of existing TC ingress redirect rules.

Any feedback appreciated, thanks!

[1] https://lore.kernel.org/netdev/33dc43f587ec1388ba456b4915c75f02a8aae226.1663945716.git.dcaratti@redhat.com/
[2] https://lore.kernel.org/netdev/YzCZMHYmk53mQ+HK@pop-os.localdomain/

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 include/net/tc_act/tc_mirred.h        |  3 ++-
 include/uapi/linux/tc_act/tc_mirred.h |  1 +
 net/sched/act_mirred.c                | 29 +++++++++++++++++++++------
 3 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/include/net/tc_act/tc_mirred.h b/include/net/tc_act/tc_mirred.h
index 32ce8ea36950..9e10ad1adb57 100644
--- a/include/net/tc_act/tc_mirred.h
+++ b/include/net/tc_act/tc_mirred.h
@@ -37,7 +37,8 @@ static inline bool is_tcf_mirred_ingress_redirect(const struct tc_action *a)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	if (a->ops && a->ops->id == TCA_ID_MIRRED)
-		return to_mirred(a)->tcfm_eaction == TCA_INGRESS_REDIR;
+		return (to_mirred(a)->tcfm_eaction == TCA_INGRESS_REDIR ||
+			to_mirred(a)->tcfm_eaction == TCA_INGRESS_BACKLOG);
 #endif
 	return false;
 }
diff --git a/include/uapi/linux/tc_act/tc_mirred.h b/include/uapi/linux/tc_act/tc_mirred.h
index 2500a0005d05..e5939a3c9d86 100644
--- a/include/uapi/linux/tc_act/tc_mirred.h
+++ b/include/uapi/linux/tc_act/tc_mirred.h
@@ -9,6 +9,7 @@
 #define TCA_EGRESS_MIRROR 2 /* mirror packet to EGRESS */
 #define TCA_INGRESS_REDIR 3  /* packet redirect to INGRESS*/
 #define TCA_INGRESS_MIRROR 4 /* mirror packet to INGRESS */
+#define TCA_INGRESS_BACKLOG 5 /* packet redirect to INGRESS (using Linux backlog) */
 
 struct tc_mirred {
 	tc_gen;
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index b8ad6ae282c0..9526bc0ee3d2 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -33,7 +33,13 @@ static DEFINE_PER_CPU(unsigned int, mirred_rec_level);
 
 static bool tcf_mirred_is_act_redirect(int action)
 {
-	return action == TCA_EGRESS_REDIR || action == TCA_INGRESS_REDIR;
+	switch (action) {
+	case TCA_EGRESS_REDIR:
+	case TCA_INGRESS_REDIR:
+	case TCA_INGRESS_BACKLOG:
+		return true;
+	}
+	return false;
 }
 
 static bool tcf_mirred_act_wants_ingress(int action)
@@ -44,6 +50,7 @@ static bool tcf_mirred_act_wants_ingress(int action)
 		return false;
 	case TCA_INGRESS_REDIR:
 	case TCA_INGRESS_MIRROR:
+	case TCA_INGRESS_BACKLOG:
 		return true;
 	default:
 		BUG();
@@ -130,6 +137,7 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 	case TCA_EGRESS_REDIR:
 	case TCA_INGRESS_REDIR:
 	case TCA_INGRESS_MIRROR:
+	case TCA_INGRESS_BACKLOG:
 		break;
 	default:
 		if (exists)
@@ -205,14 +213,23 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 	return err;
 }
 
-static int tcf_mirred_forward(bool want_ingress, struct sk_buff *skb)
+static int tcf_mirred_forward(int eaction, struct sk_buff *skb)
 {
 	int err;
 
-	if (!want_ingress)
+	switch (eaction) {
+	case TCA_EGRESS_MIRROR:
+	case TCA_EGRESS_REDIR:
 		err = tcf_dev_queue_xmit(skb, dev_queue_xmit);
-	else
+		break;
+	case TCA_INGRESS_MIRROR:
+	case TCA_INGRESS_REDIR:
 		err = netif_receive_skb(skb);
+		break;
+	case TCA_INGRESS_BACKLOG:
+		err = netif_rx(skb);
+		break;
+	}
 
 	return err;
 }
@@ -305,7 +322,7 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 
 		/* let's the caller reinsert the packet, if possible */
 		if (use_reinsert) {
-			err = tcf_mirred_forward(want_ingress, skb);
+			err = tcf_mirred_forward(m_eaction, skb);
 			if (err)
 				tcf_action_inc_overlimit_qstats(&m->common);
 			__this_cpu_dec(mirred_rec_level);
@@ -313,7 +330,7 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 		}
 	}
 
-	err = tcf_mirred_forward(want_ingress, skb2);
+	err = tcf_mirred_forward(m_eaction, skb2);
 	if (err) {
 out:
 		tcf_action_inc_overlimit_qstats(&m->common);
-- 
2.37.3

