Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 546851175B6
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 20:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfLIT1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 14:27:02 -0500
Received: from correo.us.es ([193.147.175.20]:58470 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727065AbfLIT1A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 14:27:00 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C5D35120848
        for <netdev@vger.kernel.org>; Mon,  9 Dec 2019 20:26:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B6A92DA701
        for <netdev@vger.kernel.org>; Mon,  9 Dec 2019 20:26:57 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AC263DA710; Mon,  9 Dec 2019 20:26:57 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 84CCADA702;
        Mon,  9 Dec 2019 20:26:55 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 09 Dec 2019 20:26:55 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 937E541E4800;
        Mon,  9 Dec 2019 20:26:54 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 17/17] netfilter: nf_flow_table_offload: Correct memcpy size for flow_overload_mangle()
Date:   Mon,  9 Dec 2019 20:26:38 +0100
Message-Id: <20191209192638.71184-18-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191209192638.71184-1-pablo@netfilter.org>
References: <20191209192638.71184-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In function 'memcpy',
     inlined from 'flow_offload_mangle' at net/netfilter/nf_flow_table_offload.c:112:2,
     inlined from 'flow_offload_port_dnat' at net/netfilter/nf_flow_table_offload.c:373:2,
     inlined from 'nf_flow_rule_route_ipv4' at net/netfilter/nf_flow_table_offload.c:424:3:
./include/linux/string.h:376:4: error: call to '__read_overflow2' declared with attribute error: detected read beyond size of object passed as 2nd parameter
   376 |    __read_overflow2();
       |    ^~~~~~~~~~~~~~~~~~

The original u8* was done in the hope to make this more adaptable but
consensus is to keep this like it is in tc pedit.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Reported-by: Laura Abbott <labbott@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 59 +++++++++++++++++------------------
 1 file changed, 28 insertions(+), 31 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index c94ebad78c5c..de7a0d1e15c8 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -112,8 +112,8 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 }
 
 static void flow_offload_mangle(struct flow_action_entry *entry,
-				enum flow_action_mangle_base htype,
-				u32 offset, u8 *value, u8 *mask)
+				enum flow_action_mangle_base htype, u32 offset,
+				const __be32 *value, const __be32 *mask)
 {
 	entry->id = FLOW_ACTION_MANGLE;
 	entry->mangle.htype = htype;
@@ -150,12 +150,12 @@ static int flow_offload_eth_src(struct net *net,
 	memcpy(&val16, dev->dev_addr, 2);
 	val = val16 << 16;
 	flow_offload_mangle(entry0, FLOW_ACT_MANGLE_HDR_TYPE_ETH, 4,
-			    (u8 *)&val, (u8 *)&mask);
+			    &val, &mask);
 
 	mask = ~0xffffffff;
 	memcpy(&val, dev->dev_addr + 2, 4);
 	flow_offload_mangle(entry1, FLOW_ACT_MANGLE_HDR_TYPE_ETH, 8,
-			    (u8 *)&val, (u8 *)&mask);
+			    &val, &mask);
 	dev_put(dev);
 
 	return 0;
@@ -180,13 +180,13 @@ static int flow_offload_eth_dst(struct net *net,
 	mask = ~0xffffffff;
 	memcpy(&val, n->ha, 4);
 	flow_offload_mangle(entry0, FLOW_ACT_MANGLE_HDR_TYPE_ETH, 0,
-			    (u8 *)&val, (u8 *)&mask);
+			    &val, &mask);
 
 	mask = ~0x0000ffff;
 	memcpy(&val16, n->ha + 4, 2);
 	val = val16;
 	flow_offload_mangle(entry1, FLOW_ACT_MANGLE_HDR_TYPE_ETH, 4,
-			    (u8 *)&val, (u8 *)&mask);
+			    &val, &mask);
 	neigh_release(n);
 
 	return 0;
@@ -216,7 +216,7 @@ static void flow_offload_ipv4_snat(struct net *net,
 	}
 
 	flow_offload_mangle(entry, FLOW_ACT_MANGLE_HDR_TYPE_IP4, offset,
-			    (u8 *)&addr, (u8 *)&mask);
+			    &addr, &mask);
 }
 
 static void flow_offload_ipv4_dnat(struct net *net,
@@ -243,12 +243,12 @@ static void flow_offload_ipv4_dnat(struct net *net,
 	}
 
 	flow_offload_mangle(entry, FLOW_ACT_MANGLE_HDR_TYPE_IP4, offset,
-			    (u8 *)&addr, (u8 *)&mask);
+			    &addr, &mask);
 }
 
 static void flow_offload_ipv6_mangle(struct nf_flow_rule *flow_rule,
 				     unsigned int offset,
-				     u8 *addr, u8 *mask)
+				     const __be32 *addr, const __be32 *mask)
 {
 	struct flow_action_entry *entry;
 	int i;
@@ -256,8 +256,7 @@ static void flow_offload_ipv6_mangle(struct nf_flow_rule *flow_rule,
 	for (i = 0; i < sizeof(struct in6_addr) / sizeof(u32); i += sizeof(u32)) {
 		entry = flow_action_entry_next(flow_rule);
 		flow_offload_mangle(entry, FLOW_ACT_MANGLE_HDR_TYPE_IP6,
-				    offset + i,
-				    &addr[i], mask);
+				    offset + i, &addr[i], mask);
 	}
 }
 
@@ -267,23 +266,23 @@ static void flow_offload_ipv6_snat(struct net *net,
 				   struct nf_flow_rule *flow_rule)
 {
 	u32 mask = ~htonl(0xffffffff);
-	const u8 *addr;
+	const __be32 *addr;
 	u32 offset;
 
 	switch (dir) {
 	case FLOW_OFFLOAD_DIR_ORIGINAL:
-		addr = flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_v6.s6_addr;
+		addr = flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_v6.s6_addr32;
 		offset = offsetof(struct ipv6hdr, saddr);
 		break;
 	case FLOW_OFFLOAD_DIR_REPLY:
-		addr = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_v6.s6_addr;
+		addr = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_v6.s6_addr32;
 		offset = offsetof(struct ipv6hdr, daddr);
 		break;
 	default:
 		return;
 	}
 
-	flow_offload_ipv6_mangle(flow_rule, offset, (u8 *)addr, (u8 *)&mask);
+	flow_offload_ipv6_mangle(flow_rule, offset, addr, &mask);
 }
 
 static void flow_offload_ipv6_dnat(struct net *net,
@@ -292,23 +291,23 @@ static void flow_offload_ipv6_dnat(struct net *net,
 				   struct nf_flow_rule *flow_rule)
 {
 	u32 mask = ~htonl(0xffffffff);
-	const u8 *addr;
+	const __be32 *addr;
 	u32 offset;
 
 	switch (dir) {
 	case FLOW_OFFLOAD_DIR_ORIGINAL:
-		addr = flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.src_v6.s6_addr;
+		addr = flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.src_v6.s6_addr32;
 		offset = offsetof(struct ipv6hdr, daddr);
 		break;
 	case FLOW_OFFLOAD_DIR_REPLY:
-		addr = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst_v6.s6_addr;
+		addr = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst_v6.s6_addr32;
 		offset = offsetof(struct ipv6hdr, saddr);
 		break;
 	default:
 		return;
 	}
 
-	flow_offload_ipv6_mangle(flow_rule, offset, (u8 *)addr, (u8 *)&mask);
+	flow_offload_ipv6_mangle(flow_rule, offset, addr, &mask);
 }
 
 static int flow_offload_l4proto(const struct flow_offload *flow)
@@ -336,25 +335,24 @@ static void flow_offload_port_snat(struct net *net,
 				   struct nf_flow_rule *flow_rule)
 {
 	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
-	u32 mask = ~htonl(0xffff0000);
-	__be16 port;
+	u32 mask = ~htonl(0xffff0000), port;
 	u32 offset;
 
 	switch (dir) {
 	case FLOW_OFFLOAD_DIR_ORIGINAL:
-		port = flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_port;
+		port = ntohs(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_port);
 		offset = 0; /* offsetof(struct tcphdr, source); */
 		break;
 	case FLOW_OFFLOAD_DIR_REPLY:
-		port = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_port;
+		port = ntohs(flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_port);
 		offset = 0; /* offsetof(struct tcphdr, dest); */
 		break;
 	default:
 		return;
 	}
-
+	port = htonl(port << 16);
 	flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
-			    (u8 *)&port, (u8 *)&mask);
+			    &port, &mask);
 }
 
 static void flow_offload_port_dnat(struct net *net,
@@ -363,25 +361,24 @@ static void flow_offload_port_dnat(struct net *net,
 				   struct nf_flow_rule *flow_rule)
 {
 	struct flow_action_entry *entry = flow_action_entry_next(flow_rule);
-	u32 mask = ~htonl(0xffff);
-	__be16 port;
+	u32 mask = ~htonl(0xffff), port;
 	u32 offset;
 
 	switch (dir) {
 	case FLOW_OFFLOAD_DIR_ORIGINAL:
-		port = flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_port;
+		port = ntohs(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_port);
 		offset = 0; /* offsetof(struct tcphdr, source); */
 		break;
 	case FLOW_OFFLOAD_DIR_REPLY:
-		port = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_port;
+		port = ntohs(flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_port);
 		offset = 0; /* offsetof(struct tcphdr, dest); */
 		break;
 	default:
 		return;
 	}
-
+	port = htonl(port);
 	flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
-			    (u8 *)&port, (u8 *)&mask);
+			    &port, &mask);
 }
 
 static void flow_offload_ipv4_checksum(struct net *net,
-- 
2.11.0

