Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCE632058
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 20:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfFASYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 14:24:16 -0400
Received: from mail.us.es ([193.147.175.20]:40076 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbfFASYK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Jun 2019 14:24:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 19A66FF126
        for <netdev@vger.kernel.org>; Sat,  1 Jun 2019 20:24:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 07746DA702
        for <netdev@vger.kernel.org>; Sat,  1 Jun 2019 20:24:01 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D660EFF2E5; Sat,  1 Jun 2019 20:23:59 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 48369DA729;
        Sat,  1 Jun 2019 20:23:57 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 01 Jun 2019 20:23:57 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.178.197])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DC7124265A31;
        Sat,  1 Jun 2019 20:23:56 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 13/15] netfilter: tcpmss, optstrip: prefer skb_ensure_writable
Date:   Sat,  1 Jun 2019 20:23:38 +0200
Message-Id: <20190601182340.2662-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190601182340.2662-1-pablo@netfilter.org>
References: <20190601182340.2662-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This also changes optstrip to only make the tcp header writeable
rather than the entire packet.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_TCPMSS.c      |  2 +-
 net/netfilter/xt_TCPOPTSTRIP.c | 28 +++++++++++++---------------
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 98efb202f8b4..3e24443ab81c 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -89,7 +89,7 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 	if (par->fragoff != 0)
 		return 0;
 
-	if (!skb_make_writable(skb, skb->len))
+	if (skb_ensure_writable(skb, skb->len))
 		return -1;
 
 	len = skb->len - tcphoff;
diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
index eb92bffff11c..5a274813076a 100644
--- a/net/netfilter/xt_TCPOPTSTRIP.c
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -31,33 +31,33 @@ static inline unsigned int optlen(const u_int8_t *opt, unsigned int offset)
 static unsigned int
 tcpoptstrip_mangle_packet(struct sk_buff *skb,
 			  const struct xt_action_param *par,
-			  unsigned int tcphoff, unsigned int minlen)
+			  unsigned int tcphoff)
 {
 	const struct xt_tcpoptstrip_target_info *info = par->targinfo;
+	struct tcphdr *tcph, _th;
 	unsigned int optl, i, j;
-	struct tcphdr *tcph;
 	u_int16_t n, o;
 	u_int8_t *opt;
-	int len, tcp_hdrlen;
+	int tcp_hdrlen;
 
 	/* This is a fragment, no TCP header is available */
 	if (par->fragoff != 0)
 		return XT_CONTINUE;
 
-	if (!skb_make_writable(skb, skb->len))
+	tcph = skb_header_pointer(skb, tcphoff, sizeof(_th), &_th);
+	if (!tcph)
 		return NF_DROP;
 
-	len = skb->len - tcphoff;
-	if (len < (int)sizeof(struct tcphdr))
-		return NF_DROP;
-
-	tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
 	tcp_hdrlen = tcph->doff * 4;
+	if (tcp_hdrlen < sizeof(struct tcphdr))
+		return NF_DROP;
 
-	if (len < tcp_hdrlen)
+	if (skb_ensure_writable(skb, tcphoff + tcp_hdrlen))
 		return NF_DROP;
 
-	opt  = (u_int8_t *)tcph;
+	/* must reload tcph, might have been moved */
+	tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
+	opt  = (u8 *)tcph;
 
 	/*
 	 * Walk through all TCP options - if we find some option to remove,
@@ -91,8 +91,7 @@ tcpoptstrip_mangle_packet(struct sk_buff *skb,
 static unsigned int
 tcpoptstrip_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 {
-	return tcpoptstrip_mangle_packet(skb, par, ip_hdrlen(skb),
-	       sizeof(struct iphdr) + sizeof(struct tcphdr));
+	return tcpoptstrip_mangle_packet(skb, par, ip_hdrlen(skb));
 }
 
 #if IS_ENABLED(CONFIG_IP6_NF_MANGLE)
@@ -109,8 +108,7 @@ tcpoptstrip_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 	if (tcphoff < 0)
 		return NF_DROP;
 
-	return tcpoptstrip_mangle_packet(skb, par, tcphoff,
-	       sizeof(*ipv6h) + sizeof(struct tcphdr));
+	return tcpoptstrip_mangle_packet(skb, par, tcphoff);
 }
 #endif
 
-- 
2.11.0

