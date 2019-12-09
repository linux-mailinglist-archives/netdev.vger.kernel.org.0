Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 794D81175C8
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 20:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbfLIT12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 14:27:28 -0500
Received: from correo.us.es ([193.147.175.20]:58472 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbfLIT0z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 14:26:55 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AAD3C120858
        for <netdev@vger.kernel.org>; Mon,  9 Dec 2019 20:26:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 96FBBDA70E
        for <netdev@vger.kernel.org>; Mon,  9 Dec 2019 20:26:49 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 88E04DA705; Mon,  9 Dec 2019 20:26:49 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8DE8ADA707;
        Mon,  9 Dec 2019 20:26:47 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 09 Dec 2019 20:26:47 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5DF094265A5A;
        Mon,  9 Dec 2019 20:26:47 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 06/17] netfilter: nf_flow_table_offload: add IPv6 match description
Date:   Mon,  9 Dec 2019 20:26:27 +0100
Message-Id: <20191209192638.71184-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191209192638.71184-1-pablo@netfilter.org>
References: <20191209192638.71184-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing IPv6 matching description to flow_rule object.

Fixes: 5c27d8d76ce8 ("netfilter: nf_flow_table_offload: add IPv6 support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index dd78ae5441e9..c94ebad78c5c 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -28,6 +28,7 @@ struct nf_flow_key {
 	struct flow_dissector_key_basic			basic;
 	union {
 		struct flow_dissector_key_ipv4_addrs	ipv4;
+		struct flow_dissector_key_ipv6_addrs	ipv6;
 	};
 	struct flow_dissector_key_tcp			tcp;
 	struct flow_dissector_key_ports			tp;
@@ -57,6 +58,7 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_CONTROL, control);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_BASIC, basic);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4);
+	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_TCP, tcp);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_PORTS, tp);
 
@@ -69,9 +71,18 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 		key->ipv4.dst = tuple->dst_v4.s_addr;
 		mask->ipv4.dst = 0xffffffff;
 		break;
+       case AF_INET6:
+		key->control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+		key->basic.n_proto = htons(ETH_P_IPV6);
+		key->ipv6.src = tuple->src_v6;
+		memset(&mask->ipv6.src, 0xff, sizeof(mask->ipv6.src));
+		key->ipv6.dst = tuple->dst_v6;
+		memset(&mask->ipv6.dst, 0xff, sizeof(mask->ipv6.dst));
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
+	match->dissector.used_keys |= BIT(key->control.addr_type);
 	mask->basic.n_proto = 0xffff;
 
 	switch (tuple->l4proto) {
@@ -96,7 +107,6 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 
 	match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_CONTROL) |
 				      BIT(FLOW_DISSECTOR_KEY_BASIC) |
-				      BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS) |
 				      BIT(FLOW_DISSECTOR_KEY_PORTS);
 	return 0;
 }
-- 
2.11.0

