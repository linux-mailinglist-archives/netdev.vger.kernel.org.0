Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBEFB397C2F
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235030AbhFAWIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:08:43 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39552 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234960AbhFAWIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 18:08:22 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5165C64194;
        Wed,  2 Jun 2021 00:05:33 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 12/16] netfilter: nf_tables: add and use nft_thoff helper
Date:   Wed,  2 Jun 2021 00:06:25 +0200
Message-Id: <20210601220629.18307-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210601220629.18307-1-pablo@netfilter.org>
References: <20210601220629.18307-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This allows to change storage placement later on without changing readers.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  5 +++++
 net/netfilter/nf_tables_core.c    |  2 +-
 net/netfilter/nf_tables_trace.c   |  6 +++---
 net/netfilter/nft_exthdr.c        |  8 ++++----
 net/netfilter/nft_flow_offload.c  |  2 +-
 net/netfilter/nft_payload.c       | 10 +++++-----
 net/netfilter/nft_synproxy.c      |  4 ++--
 net/netfilter/nft_tproxy.c        |  4 ++--
 8 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index af1228f58e5a..10c1b8759990 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -34,6 +34,11 @@ static inline struct sock *nft_sk(const struct nft_pktinfo *pkt)
 	return pkt->xt.state->sk;
 }
 
+static inline unsigned int nft_thoff(const struct nft_pktinfo *pkt)
+{
+	return pkt->xt.thoff;
+}
+
 static inline struct net *nft_net(const struct nft_pktinfo *pkt)
 {
 	return pkt->xt.state->net;
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index dbc2e945c98e..7780342e2f2d 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -81,7 +81,7 @@ static bool nft_payload_fast_eval(const struct nft_expr *expr,
 	else {
 		if (!pkt->tprot_set)
 			return false;
-		ptr = skb_network_header(skb) + pkt->xt.thoff;
+		ptr = skb_network_header(skb) + nft_thoff(pkt);
 	}
 
 	ptr += priv->offset;
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index 0cf3278007ba..e4fe2f0780eb 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -113,17 +113,17 @@ static int nf_trace_fill_pkt_info(struct sk_buff *nlskb,
 	int off = skb_network_offset(skb);
 	unsigned int len, nh_end;
 
-	nh_end = pkt->tprot_set ? pkt->xt.thoff : skb->len;
+	nh_end = pkt->tprot_set ? nft_thoff(pkt) : skb->len;
 	len = min_t(unsigned int, nh_end - skb_network_offset(skb),
 		    NFT_TRACETYPE_NETWORK_HSIZE);
 	if (trace_fill_header(nlskb, NFTA_TRACE_NETWORK_HEADER, skb, off, len))
 		return -1;
 
 	if (pkt->tprot_set) {
-		len = min_t(unsigned int, skb->len - pkt->xt.thoff,
+		len = min_t(unsigned int, skb->len - nft_thoff(pkt),
 			    NFT_TRACETYPE_TRANSPORT_HSIZE);
 		if (trace_fill_header(nlskb, NFTA_TRACE_TRANSPORT_HEADER, skb,
-				      pkt->xt.thoff, len))
+				      nft_thoff(pkt), len))
 			return -1;
 	}
 
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 4d0b8e1c40c0..1b0579cb62d0 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -167,7 +167,7 @@ nft_tcp_header_pointer(const struct nft_pktinfo *pkt,
 	if (!pkt->tprot_set || pkt->tprot != IPPROTO_TCP)
 		return NULL;
 
-	tcph = skb_header_pointer(pkt->skb, pkt->xt.thoff, sizeof(*tcph), buffer);
+	tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt), sizeof(*tcph), buffer);
 	if (!tcph)
 		return NULL;
 
@@ -175,7 +175,7 @@ nft_tcp_header_pointer(const struct nft_pktinfo *pkt,
 	if (*tcphdr_len < sizeof(*tcph) || *tcphdr_len > len)
 		return NULL;
 
-	return skb_header_pointer(pkt->skb, pkt->xt.thoff, *tcphdr_len, buffer);
+	return skb_header_pointer(pkt->skb, nft_thoff(pkt), *tcphdr_len, buffer);
 }
 
 static void nft_exthdr_tcp_eval(const struct nft_expr *expr,
@@ -251,7 +251,7 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 			return;
 
 		if (skb_ensure_writable(pkt->skb,
-					pkt->xt.thoff + i + priv->len))
+					nft_thoff(pkt) + i + priv->len))
 			return;
 
 		tcph = nft_tcp_header_pointer(pkt, sizeof(buff), buff,
@@ -306,7 +306,7 @@ static void nft_exthdr_sctp_eval(const struct nft_expr *expr,
 				 struct nft_regs *regs,
 				 const struct nft_pktinfo *pkt)
 {
-	unsigned int offset = pkt->xt.thoff + sizeof(struct sctphdr);
+	unsigned int offset = nft_thoff(pkt) + sizeof(struct sctphdr);
 	struct nft_exthdr *priv = nft_expr_priv(expr);
 	u32 *dest = &regs->data[priv->dreg];
 	const struct sctp_chunkhdr *sch;
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 4843dd2b410c..0af34ad41479 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -291,7 +291,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 
 	switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
 	case IPPROTO_TCP:
-		tcph = skb_header_pointer(pkt->skb, pkt->xt.thoff,
+		tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt),
 					  sizeof(_tcph), &_tcph);
 		if (unlikely(!tcph || tcph->fin || tcph->rst))
 			goto out;
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 501c5b24cc39..a44b14f6c0dc 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -110,7 +110,7 @@ void nft_payload_eval(const struct nft_expr *expr,
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
 		if (!pkt->tprot_set)
 			goto err;
-		offset = pkt->xt.thoff;
+		offset = nft_thoff(pkt);
 		break;
 	default:
 		BUG();
@@ -507,7 +507,7 @@ static int nft_payload_l4csum_offset(const struct nft_pktinfo *pkt,
 		*l4csum_offset = offsetof(struct tcphdr, check);
 		break;
 	case IPPROTO_UDP:
-		if (!nft_payload_udp_checksum(skb, pkt->xt.thoff))
+		if (!nft_payload_udp_checksum(skb, nft_thoff(pkt)))
 			return -1;
 		fallthrough;
 	case IPPROTO_UDPLITE:
@@ -520,7 +520,7 @@ static int nft_payload_l4csum_offset(const struct nft_pktinfo *pkt,
 		return -1;
 	}
 
-	*l4csum_offset += pkt->xt.thoff;
+	*l4csum_offset += nft_thoff(pkt);
 	return 0;
 }
 
@@ -612,7 +612,7 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
 		if (!pkt->tprot_set)
 			goto err;
-		offset = pkt->xt.thoff;
+		offset = nft_thoff(pkt);
 		break;
 	default:
 		BUG();
@@ -643,7 +643,7 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 	if (priv->csum_type == NFT_PAYLOAD_CSUM_SCTP &&
 	    pkt->tprot == IPPROTO_SCTP &&
 	    skb->ip_summed != CHECKSUM_PARTIAL) {
-		if (nft_payload_csum_sctp(skb, pkt->xt.thoff))
+		if (nft_payload_csum_sctp(skb, nft_thoff(pkt)))
 			goto err;
 	}
 
diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 4fda8b3f1762..a0109fa1e92d 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -109,7 +109,7 @@ static void nft_synproxy_do_eval(const struct nft_synproxy *priv,
 {
 	struct synproxy_options opts = {};
 	struct sk_buff *skb = pkt->skb;
-	int thoff = pkt->xt.thoff;
+	int thoff = nft_thoff(pkt);
 	const struct tcphdr *tcp;
 	struct tcphdr _tcph;
 
@@ -123,7 +123,7 @@ static void nft_synproxy_do_eval(const struct nft_synproxy *priv,
 		return;
 	}
 
-	tcp = skb_header_pointer(skb, pkt->xt.thoff,
+	tcp = skb_header_pointer(skb, thoff,
 				 sizeof(struct tcphdr),
 				 &_tcph);
 	if (!tcp) {
diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index accef672088c..18e79c0fd3cf 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -82,9 +82,9 @@ static void nft_tproxy_eval_v6(const struct nft_expr *expr,
 	const struct nft_tproxy *priv = nft_expr_priv(expr);
 	struct sk_buff *skb = pkt->skb;
 	const struct ipv6hdr *iph = ipv6_hdr(skb);
-	struct in6_addr taddr;
-	int thoff = pkt->xt.thoff;
+	int thoff = nft_thoff(pkt);
 	struct udphdr _hdr, *hp;
+	struct in6_addr taddr;
 	__be16 tport = 0;
 	struct sock *sk;
 	int l4proto;
-- 
2.30.2

