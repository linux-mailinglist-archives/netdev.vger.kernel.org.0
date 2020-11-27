Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6DC02C6C0D
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 20:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730101AbgK0Th2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 14:37:28 -0500
Received: from correo.us.es ([193.147.175.20]:53154 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729843AbgK0TD3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 14:03:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AC99EBAEF6
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 20:03:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9CBC0DA8F2
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 20:03:25 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 92359DA704; Fri, 27 Nov 2020 20:03:25 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 545FADA73F;
        Fri, 27 Nov 2020 20:03:23 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 27 Nov 2020 20:03:23 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 254EA4265A5A;
        Fri, 27 Nov 2020 20:03:23 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 4/5] netfilter: nftables_offload: set address type in control dissector
Date:   Fri, 27 Nov 2020 20:03:12 +0100
Message-Id: <20201127190313.24947-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201127190313.24947-1-pablo@netfilter.org>
References: <20201127190313.24947-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds nft_flow_rule_set_addr_type() to set the address type
from the nft_payload expression accordingly.

If the address type is not set in the control dissector then a rule that
matches either on source or destination IP address does not work.

After this patch, nft hardware offload generates the flow dissector
configuration as tc-flower does to match on an IP address.

This patch has been also tested functionally to make sure packets are
filtered out by the NIC.

This is also getting the code aligned with the existing netfilter flow
offload infrastructure which is also setting the control dissector.

Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_offload.h |  4 ++++
 net/netfilter/nf_tables_offload.c         | 17 +++++++++++++++++
 net/netfilter/nft_payload.c               |  4 ++++
 3 files changed, 25 insertions(+)

diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index ea7d1d78b92d..bddd34c5bd79 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -37,6 +37,7 @@ void nft_offload_update_dependency(struct nft_offload_ctx *ctx,
 
 struct nft_flow_key {
 	struct flow_dissector_key_basic			basic;
+	struct flow_dissector_key_control		control;
 	union {
 		struct flow_dissector_key_ipv4_addrs	ipv4;
 		struct flow_dissector_key_ipv6_addrs	ipv6;
@@ -62,6 +63,9 @@ struct nft_flow_rule {
 
 #define NFT_OFFLOAD_F_ACTION	(1 << 0)
 
+void nft_flow_rule_set_addr_type(struct nft_flow_rule *flow,
+				 enum flow_dissector_key_id addr_type);
+
 struct nft_rule;
 struct nft_flow_rule *nft_flow_rule_create(struct net *net, const struct nft_rule *rule);
 void nft_flow_rule_destroy(struct nft_flow_rule *flow);
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 9f625724a20f..9ae14270c543 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -28,6 +28,23 @@ static struct nft_flow_rule *nft_flow_rule_alloc(int num_actions)
 	return flow;
 }
 
+void nft_flow_rule_set_addr_type(struct nft_flow_rule *flow,
+				 enum flow_dissector_key_id addr_type)
+{
+	struct nft_flow_match *match = &flow->match;
+	struct nft_flow_key *mask = &match->mask;
+	struct nft_flow_key *key = &match->key;
+
+	if (match->dissector.used_keys & BIT(FLOW_DISSECTOR_KEY_CONTROL))
+		return;
+
+	key->control.addr_type = addr_type;
+	mask->control.addr_type = 0xffff;
+	match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_CONTROL);
+	match->dissector.offset[FLOW_DISSECTOR_KEY_CONTROL] =
+		offsetof(struct nft_flow_key, control);
+}
+
 struct nft_flow_rule *nft_flow_rule_create(struct net *net,
 					   const struct nft_rule *rule)
 {
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index dcd3c7b8a367..bbf811d030d5 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -244,6 +244,7 @@ static int nft_payload_offload_ip(struct nft_offload_ctx *ctx,
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4, src,
 				  sizeof(struct in_addr), reg);
+		nft_flow_rule_set_addr_type(flow, FLOW_DISSECTOR_KEY_IPV4_ADDRS);
 		break;
 	case offsetof(struct iphdr, daddr):
 		if (priv->len != sizeof(struct in_addr))
@@ -251,6 +252,7 @@ static int nft_payload_offload_ip(struct nft_offload_ctx *ctx,
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4, dst,
 				  sizeof(struct in_addr), reg);
+		nft_flow_rule_set_addr_type(flow, FLOW_DISSECTOR_KEY_IPV4_ADDRS);
 		break;
 	case offsetof(struct iphdr, protocol):
 		if (priv->len != sizeof(__u8))
@@ -280,6 +282,7 @@ static int nft_payload_offload_ip6(struct nft_offload_ctx *ctx,
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6, src,
 				  sizeof(struct in6_addr), reg);
+		nft_flow_rule_set_addr_type(flow, FLOW_DISSECTOR_KEY_IPV6_ADDRS);
 		break;
 	case offsetof(struct ipv6hdr, daddr):
 		if (priv->len != sizeof(struct in6_addr))
@@ -287,6 +290,7 @@ static int nft_payload_offload_ip6(struct nft_offload_ctx *ctx,
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6, dst,
 				  sizeof(struct in6_addr), reg);
+		nft_flow_rule_set_addr_type(flow, FLOW_DISSECTOR_KEY_IPV6_ADDRS);
 		break;
 	case offsetof(struct ipv6hdr, nexthdr):
 		if (priv->len != sizeof(__u8))
-- 
2.20.1

