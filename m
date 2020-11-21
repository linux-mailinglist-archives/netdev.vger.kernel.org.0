Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55062BBEF7
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 13:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgKUMgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 07:36:21 -0500
Received: from correo.us.es ([193.147.175.20]:60566 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727733AbgKUMgU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 07:36:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A2363EBACA
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 13:36:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9565DDA73D
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 13:36:15 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8AEA4DA78F; Sat, 21 Nov 2020 13:36:15 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 11257DA73D;
        Sat, 21 Nov 2020 13:36:13 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 21 Nov 2020 13:36:13 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id D7F974265A5A;
        Sat, 21 Nov 2020 13:36:12 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/4] netfilter: nftables_offload: build mask based from the matching bytes
Date:   Sat, 21 Nov 2020 13:35:59 +0100
Message-Id: <20201121123601.21733-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201121123601.21733-1-pablo@netfilter.org>
References: <20201121123601.21733-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Userspace might match on prefix bytes of header fields if they are on
the byte boundary, this requires that the mask is adjusted accordingly.
Use NFT_OFFLOAD_MATCH_EXACT() for meta since prefix byte matching is not
allowed for this type of selector.

Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_offload.h |  3 ++
 net/netfilter/nft_cmp.c                   |  8 +--
 net/netfilter/nft_meta.c                  | 16 +++---
 net/netfilter/nft_payload.c               | 66 +++++++++++++++++------
 4 files changed, 64 insertions(+), 29 deletions(-)

diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index bddd34c5bd79..1d34fe154fe0 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -78,6 +78,9 @@ int nft_flow_rule_offload_commit(struct net *net);
 		offsetof(struct nft_flow_key, __base.__field);		\
 	(__reg)->len		= __len;				\
 	(__reg)->key		= __key;				\
+
+#define NFT_OFFLOAD_MATCH_EXACT(__key, __base, __field, __len, __reg)	\
+	NFT_OFFLOAD_MATCH(__key, __base, __field, __len, __reg)		\
 	memset(&(__reg)->mask, 0xff, (__reg)->len);
 
 int nft_chain_offload_priority(struct nft_base_chain *basechain);
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index bc079d68a536..00e563a72d3d 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -123,11 +123,11 @@ static int __nft_cmp_offload(struct nft_offload_ctx *ctx,
 	u8 *mask = (u8 *)&flow->match.mask;
 	u8 *key = (u8 *)&flow->match.key;
 
-	if (priv->op != NFT_CMP_EQ || reg->len != priv->len)
+	if (priv->op != NFT_CMP_EQ || priv->len > reg->len)
 		return -EOPNOTSUPP;
 
-	memcpy(key + reg->offset, &priv->data, priv->len);
-	memcpy(mask + reg->offset, &reg->mask, priv->len);
+	memcpy(key + reg->offset, &priv->data, reg->len);
+	memcpy(mask + reg->offset, &reg->mask, reg->len);
 
 	flow->match.dissector.used_keys |= BIT(reg->key);
 	flow->match.dissector.offset[reg->key] = reg->base_offset;
@@ -137,7 +137,7 @@ static int __nft_cmp_offload(struct nft_offload_ctx *ctx,
 	    nft_reg_load16(priv->data.data) != ARPHRD_ETHER)
 		return -EOPNOTSUPP;
 
-	nft_offload_update_dependency(ctx, &priv->data, priv->len);
+	nft_offload_update_dependency(ctx, &priv->data, reg->len);
 
 	return 0;
 }
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index b37bd02448d8..bf4b3ad5314c 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -724,22 +724,22 @@ static int nft_meta_get_offload(struct nft_offload_ctx *ctx,
 
 	switch (priv->key) {
 	case NFT_META_PROTOCOL:
-		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic, n_proto,
-				  sizeof(__u16), reg);
+		NFT_OFFLOAD_MATCH_EXACT(FLOW_DISSECTOR_KEY_BASIC, basic, n_proto,
+					sizeof(__u16), reg);
 		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_NETWORK);
 		break;
 	case NFT_META_L4PROTO:
-		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic, ip_proto,
-				  sizeof(__u8), reg);
+		NFT_OFFLOAD_MATCH_EXACT(FLOW_DISSECTOR_KEY_BASIC, basic, ip_proto,
+					sizeof(__u8), reg);
 		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_TRANSPORT);
 		break;
 	case NFT_META_IIF:
-		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_META, meta,
-				  ingress_ifindex, sizeof(__u32), reg);
+		NFT_OFFLOAD_MATCH_EXACT(FLOW_DISSECTOR_KEY_META, meta,
+					ingress_ifindex, sizeof(__u32), reg);
 		break;
 	case NFT_META_IIFTYPE:
-		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_META, meta,
-				  ingress_iftype, sizeof(__u16), reg);
+		NFT_OFFLOAD_MATCH_EXACT(FLOW_DISSECTOR_KEY_META, meta,
+					ingress_iftype, sizeof(__u16), reg);
 		break;
 	default:
 		return -EOPNOTSUPP;
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index bbf811d030d5..47d4e0e21651 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -165,6 +165,34 @@ static int nft_payload_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static bool nft_payload_offload_mask(struct nft_offload_reg *reg,
+				     u32 priv_len, u32 field_len)
+{
+	unsigned int remainder, delta, k;
+	struct nft_data mask = {};
+	__be32 remainder_mask;
+
+	if (priv_len == field_len) {
+		memset(&reg->mask, 0xff, priv_len);
+		return true;
+	} else if (priv_len > field_len) {
+		return false;
+	}
+
+	memset(&mask, 0xff, field_len);
+	remainder = priv_len % sizeof(u32);
+	if (remainder) {
+		k = priv_len / sizeof(u32);
+		delta = field_len - priv_len;
+		remainder_mask = htonl(~((1 << (delta * BITS_PER_BYTE)) - 1));
+		mask.data[k] = (__force u32)remainder_mask;
+	}
+
+	memcpy(&reg->mask, &mask, field_len);
+
+	return true;
+}
+
 static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
 				  struct nft_flow_rule *flow,
 				  const struct nft_payload *priv)
@@ -173,21 +201,21 @@ static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
 
 	switch (priv->offset) {
 	case offsetof(struct ethhdr, h_source):
-		if (priv->len != ETH_ALEN)
+		if (!nft_payload_offload_mask(reg, priv->len, ETH_ALEN))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_ETH_ADDRS, eth_addrs,
 				  src, ETH_ALEN, reg);
 		break;
 	case offsetof(struct ethhdr, h_dest):
-		if (priv->len != ETH_ALEN)
+		if (!nft_payload_offload_mask(reg, priv->len, ETH_ALEN))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_ETH_ADDRS, eth_addrs,
 				  dst, ETH_ALEN, reg);
 		break;
 	case offsetof(struct ethhdr, h_proto):
-		if (priv->len != sizeof(__be16))
+		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic,
@@ -195,14 +223,14 @@ static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
 		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_NETWORK);
 		break;
 	case offsetof(struct vlan_ethhdr, h_vlan_TCI):
-		if (priv->len != sizeof(__be16))
+		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_VLAN, vlan,
 				  vlan_tci, sizeof(__be16), reg);
 		break;
 	case offsetof(struct vlan_ethhdr, h_vlan_encapsulated_proto):
-		if (priv->len != sizeof(__be16))
+		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_VLAN, vlan,
@@ -210,7 +238,7 @@ static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
 		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_NETWORK);
 		break;
 	case offsetof(struct vlan_ethhdr, h_vlan_TCI) + sizeof(struct vlan_hdr):
-		if (priv->len != sizeof(__be16))
+		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_CVLAN, vlan,
@@ -218,7 +246,7 @@ static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
 		break;
 	case offsetof(struct vlan_ethhdr, h_vlan_encapsulated_proto) +
 							sizeof(struct vlan_hdr):
-		if (priv->len != sizeof(__be16))
+		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_CVLAN, vlan,
@@ -239,7 +267,8 @@ static int nft_payload_offload_ip(struct nft_offload_ctx *ctx,
 
 	switch (priv->offset) {
 	case offsetof(struct iphdr, saddr):
-		if (priv->len != sizeof(struct in_addr))
+		if (!nft_payload_offload_mask(reg, priv->len,
+					      sizeof(struct in_addr)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4, src,
@@ -247,7 +276,8 @@ static int nft_payload_offload_ip(struct nft_offload_ctx *ctx,
 		nft_flow_rule_set_addr_type(flow, FLOW_DISSECTOR_KEY_IPV4_ADDRS);
 		break;
 	case offsetof(struct iphdr, daddr):
-		if (priv->len != sizeof(struct in_addr))
+		if (!nft_payload_offload_mask(reg, priv->len,
+					      sizeof(struct in_addr)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4, dst,
@@ -255,7 +285,7 @@ static int nft_payload_offload_ip(struct nft_offload_ctx *ctx,
 		nft_flow_rule_set_addr_type(flow, FLOW_DISSECTOR_KEY_IPV4_ADDRS);
 		break;
 	case offsetof(struct iphdr, protocol):
-		if (priv->len != sizeof(__u8))
+		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__u8)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic, ip_proto,
@@ -277,7 +307,8 @@ static int nft_payload_offload_ip6(struct nft_offload_ctx *ctx,
 
 	switch (priv->offset) {
 	case offsetof(struct ipv6hdr, saddr):
-		if (priv->len != sizeof(struct in6_addr))
+		if (!nft_payload_offload_mask(reg, priv->len,
+					      sizeof(struct in6_addr)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6, src,
@@ -285,7 +316,8 @@ static int nft_payload_offload_ip6(struct nft_offload_ctx *ctx,
 		nft_flow_rule_set_addr_type(flow, FLOW_DISSECTOR_KEY_IPV6_ADDRS);
 		break;
 	case offsetof(struct ipv6hdr, daddr):
-		if (priv->len != sizeof(struct in6_addr))
+		if (!nft_payload_offload_mask(reg, priv->len,
+					      sizeof(struct in6_addr)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6, dst,
@@ -293,7 +325,7 @@ static int nft_payload_offload_ip6(struct nft_offload_ctx *ctx,
 		nft_flow_rule_set_addr_type(flow, FLOW_DISSECTOR_KEY_IPV6_ADDRS);
 		break;
 	case offsetof(struct ipv6hdr, nexthdr):
-		if (priv->len != sizeof(__u8))
+		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__u8)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic, ip_proto,
@@ -335,14 +367,14 @@ static int nft_payload_offload_tcp(struct nft_offload_ctx *ctx,
 
 	switch (priv->offset) {
 	case offsetof(struct tcphdr, source):
-		if (priv->len != sizeof(__be16))
+		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, src,
 				  sizeof(__be16), reg);
 		break;
 	case offsetof(struct tcphdr, dest):
-		if (priv->len != sizeof(__be16))
+		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, dst,
@@ -363,14 +395,14 @@ static int nft_payload_offload_udp(struct nft_offload_ctx *ctx,
 
 	switch (priv->offset) {
 	case offsetof(struct udphdr, source):
-		if (priv->len != sizeof(__be16))
+		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, src,
 				  sizeof(__be16), reg);
 		break;
 	case offsetof(struct udphdr, dest):
-		if (priv->len != sizeof(__be16))
+		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, dst,
-- 
2.20.1

