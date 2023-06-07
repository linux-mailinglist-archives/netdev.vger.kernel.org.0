Return-Path: <netdev+bounces-8903-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C0B107263A4
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:04:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A0D92812F0
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC5E51ACCE;
	Wed,  7 Jun 2023 15:03:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E8F1ACC1
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 15:03:26 +0000 (UTC)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273B619BC
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:03:25 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1q6uh1-0001DS-Kb; Wed, 07 Jun 2023 17:03:23 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: jhs@mojatatu.com,
	xiyou.wangcong@gmail.com,
	jiri@resnulli.us,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH net 2/3] net/sched: act_ipt: add sanity checks on skb before calling target
Date: Wed,  7 Jun 2023 16:59:53 +0200
Message-Id: <20230607145954.19324-3-fw@strlen.de>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230607145954.19324-1-fw@strlen.de>
References: <20230607145954.19324-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Netfilter targets make assumptions on the skb state, for example
iphdr is supposed to be in the linear area.

This is normally done by IP stack, but in act_ipt case no
such checks are made.

Some targets can even assume that skb_dst will be valid.
Make a minimum effort to check for this:

- Don't call the targets eval function for non-ipv4 skbs.
- Don't call the targets eval function for POSTROUTING
  emulation when the skb has no dst set.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/sched/act_ipt.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index ea7f151e7dd2..2f0b39cc4e37 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -230,6 +230,26 @@ static int tcf_xt_init(struct net *net, struct nlattr *nla,
 			      a, &act_xt_ops, tp, flags);
 }
 
+static bool tcf_ipt_act_check(struct sk_buff *skb)
+{
+	const struct iphdr *iph;
+	unsigned int nhoff, len;
+
+	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+		return false;
+
+	nhoff = skb_network_offset(skb);
+	iph = ip_hdr(skb);
+	if (iph->ihl < 5 || iph->version != 4)
+		return false;
+
+	len = skb_ip_totlen(skb);
+	if (skb->len < nhoff + len || len < (iph->ihl * 4u))
+		return false;
+
+	return pskb_may_pull(skb, iph->ihl * 4u);
+}
+
 TC_INDIRECT_SCOPE int tcf_ipt_act(struct sk_buff *skb,
 				  const struct tc_action *a,
 				  struct tcf_result *res)
@@ -244,9 +264,22 @@ TC_INDIRECT_SCOPE int tcf_ipt_act(struct sk_buff *skb,
 		.pf	= NFPROTO_IPV4,
 	};
 
+	if (skb->protocol != htons(ETH_P_IP))
+		return TC_ACT_UNSPEC;
+
 	if (skb_unclone(skb, GFP_ATOMIC))
 		return TC_ACT_UNSPEC;
 
+	if (!tcf_ipt_act_check(skb))
+		return TC_ACT_UNSPEC;
+
+	if (state.hook == NF_INET_POST_ROUTING) {
+		if (!skb_dst(skb))
+			return TC_ACT_UNSPEC;
+
+		state.out = skb->dev;
+	}
+
 	spin_lock(&ipt->tcf_lock);
 
 	tcf_lastuse_update(&ipt->tcf_tm);
-- 
2.39.3


