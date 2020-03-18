Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C49C1892FD
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 01:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgCRAkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 20:40:24 -0400
Received: from correo.us.es ([193.147.175.20]:45596 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727301AbgCRAkW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 20:40:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C666A27F8C6
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B7BE3DA3A4
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:47 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AD77CDA390; Wed, 18 Mar 2020 01:39:47 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C8348DA390;
        Wed, 18 Mar 2020 01:39:45 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 01:39:45 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A131A426CCB9;
        Wed, 18 Mar 2020 01:39:45 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 13/29] netfilter: flowtable: add tunnel match offload support
Date:   Wed, 18 Mar 2020 01:39:40 +0100
Message-Id: <20200318003956.73573-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200318003956.73573-1-pablo@netfilter.org>
References: <20200318003956.73573-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch support both ipv4 and ipv6 tunnel_id, tunnel_src and
tunnel_dst match for flowtable offload

Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |  6 ++++
 net/netfilter/nf_flow_table_offload.c | 61 +++++++++++++++++++++++++++++++++--
 2 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 6890f1ca3e31..f523ea87b6ae 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -19,11 +19,17 @@ enum flow_offload_tuple_dir;
 struct nf_flow_key {
 	struct flow_dissector_key_meta			meta;
 	struct flow_dissector_key_control		control;
+	struct flow_dissector_key_control		enc_control;
 	struct flow_dissector_key_basic			basic;
 	union {
 		struct flow_dissector_key_ipv4_addrs	ipv4;
 		struct flow_dissector_key_ipv6_addrs	ipv6;
 	};
+	struct flow_dissector_key_keyid			enc_key_id;
+	union {
+		struct flow_dissector_key_ipv4_addrs	enc_ipv4;
+		struct flow_dissector_key_ipv6_addrs	enc_ipv6;
+	};
 	struct flow_dissector_key_tcp			tcp;
 	struct flow_dissector_key_ports			tp;
 } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index f60f01e929b8..3101b35eac80 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -28,11 +28,61 @@ struct flow_offload_work {
 	(__match)->dissector.offset[__type] =		\
 		offsetof(struct nf_flow_key, __field)
 
+static void nf_flow_rule_lwt_match(struct nf_flow_match *match,
+				   struct ip_tunnel_info *tun_info)
+{
+	struct nf_flow_key *mask = &match->mask;
+	struct nf_flow_key *key = &match->key;
+	unsigned int enc_keys;
+
+	if (!tun_info || !(tun_info->mode & IP_TUNNEL_INFO_TX))
+		return;
+
+	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_ENC_CONTROL, enc_control);
+	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_ENC_KEYID, enc_key_id);
+	key->enc_key_id.keyid = tunnel_id_to_key32(tun_info->key.tun_id);
+	mask->enc_key_id.keyid = 0xffffffff;
+	enc_keys = BIT(FLOW_DISSECTOR_KEY_ENC_KEYID) |
+		   BIT(FLOW_DISSECTOR_KEY_ENC_CONTROL);
+
+	if (ip_tunnel_info_af(tun_info) == AF_INET) {
+		NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS,
+				  enc_ipv4);
+		key->enc_ipv4.src = tun_info->key.u.ipv4.dst;
+		key->enc_ipv4.dst = tun_info->key.u.ipv4.src;
+		if (key->enc_ipv4.src)
+			mask->enc_ipv4.src = 0xffffffff;
+		if (key->enc_ipv4.dst)
+			mask->enc_ipv4.dst = 0xffffffff;
+		enc_keys |= BIT(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS);
+		key->enc_control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+	} else {
+		memcpy(&key->enc_ipv6.src, &tun_info->key.u.ipv6.dst,
+		       sizeof(struct in6_addr));
+		memcpy(&key->enc_ipv6.dst, &tun_info->key.u.ipv6.src,
+		       sizeof(struct in6_addr));
+		if (memcmp(&key->enc_ipv6.src, &in6addr_any,
+			   sizeof(struct in6_addr)))
+			memset(&key->enc_ipv6.src, 0xff,
+			       sizeof(struct in6_addr));
+		if (memcmp(&key->enc_ipv6.dst, &in6addr_any,
+			   sizeof(struct in6_addr)))
+			memset(&key->enc_ipv6.dst, 0xff,
+			       sizeof(struct in6_addr));
+		enc_keys |= BIT(FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS);
+		key->enc_control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+	}
+
+	match->dissector.used_keys |= enc_keys;
+}
+
 static int nf_flow_rule_match(struct nf_flow_match *match,
-			      const struct flow_offload_tuple *tuple)
+			      const struct flow_offload_tuple *tuple,
+			      struct dst_entry *other_dst)
 {
 	struct nf_flow_key *mask = &match->mask;
 	struct nf_flow_key *key = &match->key;
+	struct ip_tunnel_info *tun_info;
 
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_META, meta);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_CONTROL, control);
@@ -42,6 +92,11 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_TCP, tcp);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_PORTS, tp);
 
+	if (other_dst->lwtstate) {
+		tun_info = lwt_tun_info(other_dst->lwtstate);
+		nf_flow_rule_lwt_match(match, tun_info);
+	}
+
 	key->meta.ingress_ifindex = tuple->iifidx;
 	mask->meta.ingress_ifindex = 0xffffffff;
 
@@ -480,6 +535,7 @@ nf_flow_offload_rule_alloc(struct net *net,
 	const struct flow_offload *flow = offload->flow;
 	const struct flow_offload_tuple *tuple;
 	struct nf_flow_rule *flow_rule;
+	struct dst_entry *other_dst;
 	int err = -ENOMEM;
 
 	flow_rule = kzalloc(sizeof(*flow_rule), GFP_KERNEL);
@@ -495,7 +551,8 @@ nf_flow_offload_rule_alloc(struct net *net,
 	flow_rule->rule->match.key = &flow_rule->match.key;
 
 	tuple = &flow->tuplehash[dir].tuple;
-	err = nf_flow_rule_match(&flow_rule->match, tuple);
+	other_dst = flow->tuplehash[!dir].tuple.dst_cache;
+	err = nf_flow_rule_match(&flow_rule->match, tuple, other_dst);
 	if (err < 0)
 		goto err_flow_match;
 
-- 
2.11.0

