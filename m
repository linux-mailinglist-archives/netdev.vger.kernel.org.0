Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF8E2E6255
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 13:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfJ0MCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 08:02:45 -0400
Received: from correo.us.es ([193.147.175.20]:60146 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbfJ0MCn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Oct 2019 08:02:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6FEAE7FC3F
        for <netdev@vger.kernel.org>; Sun, 27 Oct 2019 13:02:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6140EB8009
        for <netdev@vger.kernel.org>; Sun, 27 Oct 2019 13:02:39 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 56FA9B8004; Sun, 27 Oct 2019 13:02:39 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5FCA8DA72F;
        Sun, 27 Oct 2019 13:02:37 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 27 Oct 2019 13:02:37 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2E56C42EE38F;
        Sun, 27 Oct 2019 13:02:37 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 5/5] netfilter: nft_payload: fix missing check for matching length in offloads
Date:   Sun, 27 Oct 2019 13:02:21 +0100
Message-Id: <20191027120221.2884-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191027120221.2884-1-pablo@netfilter.org>
References: <20191027120221.2884-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Payload offload rule should also check the length of the match.
Moreover, check for unsupported link-layer fields:

 nft --debug=netlink add rule firewall zones vlan id 100
 ...
 [ payload load 2b @ link header + 0 => reg 1 ]

this loads 2byte base on ll header and offset 0.

This also fixes unsupported raw payload match.

Fixes: 92ad6325cb89 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_payload.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 22a80eb60222..5cb2d8908d2a 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -161,13 +161,21 @@ static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
 
 	switch (priv->offset) {
 	case offsetof(struct ethhdr, h_source):
+		if (priv->len != ETH_ALEN)
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_ETH_ADDRS, eth_addrs,
 				  src, ETH_ALEN, reg);
 		break;
 	case offsetof(struct ethhdr, h_dest):
+		if (priv->len != ETH_ALEN)
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_ETH_ADDRS, eth_addrs,
 				  dst, ETH_ALEN, reg);
 		break;
+	default:
+		return -EOPNOTSUPP;
 	}
 
 	return 0;
@@ -181,14 +189,23 @@ static int nft_payload_offload_ip(struct nft_offload_ctx *ctx,
 
 	switch (priv->offset) {
 	case offsetof(struct iphdr, saddr):
+		if (priv->len != sizeof(struct in_addr))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4, src,
 				  sizeof(struct in_addr), reg);
 		break;
 	case offsetof(struct iphdr, daddr):
+		if (priv->len != sizeof(struct in_addr))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4, dst,
 				  sizeof(struct in_addr), reg);
 		break;
 	case offsetof(struct iphdr, protocol):
+		if (priv->len != sizeof(__u8))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic, ip_proto,
 				  sizeof(__u8), reg);
 		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_TRANSPORT);
@@ -208,14 +225,23 @@ static int nft_payload_offload_ip6(struct nft_offload_ctx *ctx,
 
 	switch (priv->offset) {
 	case offsetof(struct ipv6hdr, saddr):
+		if (priv->len != sizeof(struct in6_addr))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6, src,
 				  sizeof(struct in6_addr), reg);
 		break;
 	case offsetof(struct ipv6hdr, daddr):
+		if (priv->len != sizeof(struct in6_addr))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6, dst,
 				  sizeof(struct in6_addr), reg);
 		break;
 	case offsetof(struct ipv6hdr, nexthdr):
+		if (priv->len != sizeof(__u8))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic, ip_proto,
 				  sizeof(__u8), reg);
 		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_TRANSPORT);
@@ -255,10 +281,16 @@ static int nft_payload_offload_tcp(struct nft_offload_ctx *ctx,
 
 	switch (priv->offset) {
 	case offsetof(struct tcphdr, source):
+		if (priv->len != sizeof(__be16))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, src,
 				  sizeof(__be16), reg);
 		break;
 	case offsetof(struct tcphdr, dest):
+		if (priv->len != sizeof(__be16))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, dst,
 				  sizeof(__be16), reg);
 		break;
@@ -277,10 +309,16 @@ static int nft_payload_offload_udp(struct nft_offload_ctx *ctx,
 
 	switch (priv->offset) {
 	case offsetof(struct udphdr, source):
+		if (priv->len != sizeof(__be16))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, src,
 				  sizeof(__be16), reg);
 		break;
 	case offsetof(struct udphdr, dest):
+		if (priv->len != sizeof(__be16))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, dst,
 				  sizeof(__be16), reg);
 		break;
-- 
2.11.0

