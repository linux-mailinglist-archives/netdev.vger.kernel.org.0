Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD82A3637B8
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 23:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236839AbhDRVFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 17:05:10 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35002 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbhDRVE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 17:04:57 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 58CF163E87;
        Sun, 18 Apr 2021 23:03:58 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 09/14] netfilter: nft_payload: fix C-VLAN offload support
Date:   Sun, 18 Apr 2021 23:04:10 +0200
Message-Id: <20210418210415.4719-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210418210415.4719-1-pablo@netfilter.org>
References: <20210418210415.4719-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add another struct flow_dissector_key_vlan for C-VLAN
- update layer 3 dependency to allow to match on IPv4/IPv6

Fixes: 89d8fd44abfb ("netfilter: nft_payload: add C-VLAN offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_offload.h | 1 +
 net/netfilter/nft_payload.c               | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index 1d34fe154fe0..b4d080061399 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -45,6 +45,7 @@ struct nft_flow_key {
 	struct flow_dissector_key_ports			tp;
 	struct flow_dissector_key_ip			ip;
 	struct flow_dissector_key_vlan			vlan;
+	struct flow_dissector_key_vlan			cvlan;
 	struct flow_dissector_key_eth_addrs		eth_addrs;
 	struct flow_dissector_key_meta			meta;
 } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index cb1c8c231880..a990f37e0a60 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -241,7 +241,7 @@ static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
 		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
-		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_CVLAN, vlan,
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_CVLAN, cvlan,
 				  vlan_tci, sizeof(__be16), reg);
 		break;
 	case offsetof(struct vlan_ethhdr, h_vlan_encapsulated_proto) +
@@ -249,8 +249,9 @@ static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
 		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
-		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_CVLAN, vlan,
+		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_CVLAN, cvlan,
 				  vlan_tpid, sizeof(__be16), reg);
+		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_NETWORK);
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
2.30.2

