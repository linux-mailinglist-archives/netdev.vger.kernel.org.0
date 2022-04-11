Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF774FB99D
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 12:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345530AbiDKKaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 06:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345487AbiDKKaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 06:30:08 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AECD03DDEB;
        Mon, 11 Apr 2022 03:27:52 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5974063042;
        Mon, 11 Apr 2022 12:23:51 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 05/11] netfilter: nf_log_syslog: Merge MAC header dumpers
Date:   Mon, 11 Apr 2022 12:27:38 +0200
Message-Id: <20220411102744.282101-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220411102744.282101-1-pablo@netfilter.org>
References: <20220411102744.282101-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

The functions for IPv4 and IPv6 were almost identical apart from extra
SIT tunnel device handling in the latter.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_log_syslog.c | 91 ++++++++++-------------------------
 1 file changed, 25 insertions(+), 66 deletions(-)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index 13234641cdb3..d1dcf36545d7 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -766,9 +766,9 @@ dump_ipv6_packet(struct net *net, struct nf_log_buf *m,
 		nf_log_buf_add(m, "MARK=0x%x ", skb->mark);
 }
 
-static void dump_ipv4_mac_header(struct nf_log_buf *m,
-				 const struct nf_loginfo *info,
-				 const struct sk_buff *skb)
+static void dump_mac_header(struct nf_log_buf *m,
+			    const struct nf_loginfo *info,
+			    const struct sk_buff *skb)
 {
 	struct net_device *dev = skb->dev;
 	unsigned int logflags = 0;
@@ -798,9 +798,26 @@ static void dump_ipv4_mac_header(struct nf_log_buf *m,
 		const unsigned char *p = skb_mac_header(skb);
 		unsigned int i;
 
-		nf_log_buf_add(m, "%02x", *p++);
-		for (i = 1; i < dev->hard_header_len; i++, p++)
-			nf_log_buf_add(m, ":%02x", *p);
+		if (dev->type == ARPHRD_SIT) {
+			p -= ETH_HLEN;
+
+			if (p < skb->head)
+				p = NULL;
+		}
+
+		if (p) {
+			nf_log_buf_add(m, "%02x", *p++);
+			for (i = 1; i < dev->hard_header_len; i++)
+				nf_log_buf_add(m, ":%02x", *p++);
+		}
+
+		if (dev->type == ARPHRD_SIT) {
+			const struct iphdr *iph =
+				(struct iphdr *)skb_mac_header(skb);
+
+			nf_log_buf_add(m, " TUNNEL=%pI4->%pI4", &iph->saddr,
+				       &iph->daddr);
+		}
 	}
 	nf_log_buf_add(m, " ");
 }
@@ -827,7 +844,7 @@ static void nf_log_ip_packet(struct net *net, u_int8_t pf,
 				  out, loginfo, prefix);
 
 	if (in)
-		dump_ipv4_mac_header(m, loginfo, skb);
+		dump_mac_header(m, loginfo, skb);
 
 	dump_ipv4_packet(net, m, loginfo, skb, 0);
 
@@ -841,64 +858,6 @@ static struct nf_logger nf_ip_logger __read_mostly = {
 	.me		= THIS_MODULE,
 };
 
-static void dump_ipv6_mac_header(struct nf_log_buf *m,
-				 const struct nf_loginfo *info,
-				 const struct sk_buff *skb)
-{
-	struct net_device *dev = skb->dev;
-	unsigned int logflags = 0;
-
-	if (info->type == NF_LOG_TYPE_LOG)
-		logflags = info->u.log.logflags;
-
-	if (!(logflags & NF_LOG_MACDECODE))
-		goto fallback;
-
-	switch (dev->type) {
-	case ARPHRD_ETHER:
-		nf_log_buf_add(m, "MACSRC=%pM MACDST=%pM ",
-			       eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest);
-		nf_log_dump_vlan(m, skb);
-		nf_log_buf_add(m, "MACPROTO=%04x ",
-			       ntohs(eth_hdr(skb)->h_proto));
-		return;
-	default:
-		break;
-	}
-
-fallback:
-	nf_log_buf_add(m, "MAC=");
-	if (dev->hard_header_len &&
-	    skb->mac_header != skb->network_header) {
-		const unsigned char *p = skb_mac_header(skb);
-		unsigned int len = dev->hard_header_len;
-		unsigned int i;
-
-		if (dev->type == ARPHRD_SIT) {
-			p -= ETH_HLEN;
-
-			if (p < skb->head)
-				p = NULL;
-		}
-
-		if (p) {
-			nf_log_buf_add(m, "%02x", *p++);
-			for (i = 1; i < len; i++)
-				nf_log_buf_add(m, ":%02x", *p++);
-		}
-		nf_log_buf_add(m, " ");
-
-		if (dev->type == ARPHRD_SIT) {
-			const struct iphdr *iph =
-				(struct iphdr *)skb_mac_header(skb);
-			nf_log_buf_add(m, "TUNNEL=%pI4->%pI4 ", &iph->saddr,
-				       &iph->daddr);
-		}
-	} else {
-		nf_log_buf_add(m, " ");
-	}
-}
-
 static void nf_log_ip6_packet(struct net *net, u_int8_t pf,
 			      unsigned int hooknum, const struct sk_buff *skb,
 			      const struct net_device *in,
@@ -921,7 +880,7 @@ static void nf_log_ip6_packet(struct net *net, u_int8_t pf,
 				  loginfo, prefix);
 
 	if (in)
-		dump_ipv6_mac_header(m, loginfo, skb);
+		dump_mac_header(m, loginfo, skb);
 
 	dump_ipv6_packet(net, m, loginfo, skb, skb_network_offset(skb), 1);
 
-- 
2.30.2

