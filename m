Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B53A0A364C
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 14:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbfH3MHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 08:07:22 -0400
Received: from correo.us.es ([193.147.175.20]:36300 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728155AbfH3MHQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 08:07:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EAC7DD2AE7
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 14:07:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DBD40B8001
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 14:07:12 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D194BB7FFB; Fri, 30 Aug 2019 14:07:12 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BBCD0D2B1E;
        Fri, 30 Aug 2019 14:07:10 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 30 Aug 2019 14:07:10 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8945F4251481;
        Fri, 30 Aug 2019 14:07:10 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 4/5] netfilter: nf_flow_table: clear skb tstamp before xmit
Date:   Fri, 30 Aug 2019 14:07:03 +0200
Message-Id: <20190830120704.6147-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190830120704.6147-1-pablo@netfilter.org>
References: <20190830120704.6147-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

If 'fq' qdisc is used and a program has requested timestamps,
skb->tstamp needs to be cleared, else fq will treat these as
'transmit time'.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index d68c801dd614..b9e7dd6e60ce 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -228,7 +228,6 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 {
 	skb_orphan(skb);
 	skb_dst_set_noref(skb, dst);
-	skb->tstamp = 0;
 	dst_output(state->net, state->sk, skb);
 	return NF_STOLEN;
 }
@@ -284,6 +283,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
 	iph = ip_hdr(skb);
 	ip_decrease_ttl(iph);
+	skb->tstamp = 0;
 
 	if (unlikely(dst_xfrm(&rt->dst))) {
 		memset(skb->cb, 0, sizeof(struct inet_skb_parm));
@@ -512,6 +512,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
 	ip6h = ipv6_hdr(skb);
 	ip6h->hop_limit--;
+	skb->tstamp = 0;
 
 	if (unlikely(dst_xfrm(&rt->dst))) {
 		memset(skb->cb, 0, sizeof(struct inet6_skb_parm));
-- 
2.11.0

