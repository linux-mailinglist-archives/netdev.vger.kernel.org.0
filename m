Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7A33B0FCD
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 00:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbhFVWDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 18:03:16 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59280 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbhFVWC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 18:02:59 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 056A164252;
        Tue, 22 Jun 2021 23:59:17 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 6/8] netfilter: nf_tables_offload: check FLOW_DISSECTOR_KEY_BASIC in VLAN transfer logic
Date:   Tue, 22 Jun 2021 23:59:59 +0200
Message-Id: <20210622220001.198508-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210622220001.198508-1-pablo@netfilter.org>
References: <20210622220001.198508-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VLAN transfer logic should actually check for
FLOW_DISSECTOR_KEY_BASIC, not FLOW_DISSECTOR_KEY_CONTROL. Moreover, do
not fallback to case 2) .n_proto is set to 802.1q or 802.1ad, if
FLOW_DISSECTOR_KEY_BASIC is unset.

Fixes: 783003f3bb8a ("netfilter: nftables_offload: special ethertype handling for VLAN")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_offload.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index ec701b84844f..b58d73a96523 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -54,15 +54,10 @@ static void nft_flow_rule_transfer_vlan(struct nft_offload_ctx *ctx,
 					struct nft_flow_rule *flow)
 {
 	struct nft_flow_match *match = &flow->match;
-	struct nft_offload_ethertype ethertype;
-
-	if (match->dissector.used_keys & BIT(FLOW_DISSECTOR_KEY_CONTROL) &&
-	    match->key.basic.n_proto != htons(ETH_P_8021Q) &&
-	    match->key.basic.n_proto != htons(ETH_P_8021AD))
-		return;
-
-	ethertype.value = match->key.basic.n_proto;
-	ethertype.mask = match->mask.basic.n_proto;
+	struct nft_offload_ethertype ethertype = {
+		.value	= match->key.basic.n_proto,
+		.mask	= match->mask.basic.n_proto,
+	};
 
 	if (match->dissector.used_keys & BIT(FLOW_DISSECTOR_KEY_VLAN) &&
 	    (match->key.vlan.vlan_tpid == htons(ETH_P_8021Q) ||
@@ -76,7 +71,9 @@ static void nft_flow_rule_transfer_vlan(struct nft_offload_ctx *ctx,
 		match->dissector.offset[FLOW_DISSECTOR_KEY_CVLAN] =
 			offsetof(struct nft_flow_key, cvlan);
 		match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_CVLAN);
-	} else {
+	} else if (match->dissector.used_keys & BIT(FLOW_DISSECTOR_KEY_BASIC) &&
+		   (match->key.basic.n_proto == htons(ETH_P_8021Q) ||
+		    match->key.basic.n_proto == htons(ETH_P_8021AD))) {
 		match->key.basic.n_proto = match->key.vlan.vlan_tpid;
 		match->mask.basic.n_proto = match->mask.vlan.vlan_tpid;
 		match->key.vlan.vlan_tpid = ethertype.value;
-- 
2.30.2

