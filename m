Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF86D12A70F
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 10:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbfLYJs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 04:48:28 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:26304 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfLYJs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 04:48:27 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 5125641B6E;
        Wed, 25 Dec 2019 17:48:25 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, paulb@mellanox.com, netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, jiri@mellanox.com
Subject: [PATCH net-next 4/5] netfilter: nf_flow_table_offload: add tunnel match offload support
Date:   Wed, 25 Dec 2019 17:48:22 +0800
Message-Id: <1577267303-24780-5-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1577267303-24780-1-git-send-email-wenxu@ucloud.cn>
References: <1577267303-24780-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUlOQkJCQk5KSE1JTUpZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MDI6Gjo5EDg8SEJNChZWMhEf
        NTNPFBdVSlVKTkxMSU1MSEtOT05OVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU5MQ003Bg++
X-HM-Tid: 0a6f3c751b8f2086kuqy5125641b6e
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch support both ipv4 and ipv6 tunnel_id, tunnel_src and
tunnel_dst match for flowtable offload

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_flow_table_offload.c | 67 +++++++++++++++++++++++++++++++++--
 1 file changed, 65 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 80d44a0..93ff2e6 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -26,11 +26,17 @@ struct flow_offload_work {
 
 struct nf_flow_key {
 	struct flow_dissector_key_control		control;
+	struct flow_dissector_key_control               enc_control;
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
@@ -50,11 +56,61 @@ struct nf_flow_rule {
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
 
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_CONTROL, control);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_BASIC, basic);
@@ -63,6 +119,11 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_TCP, tcp);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_PORTS, tp);
 
+	if (other_dst->lwtstate) {
+		tun_info = lwt_tun_info(other_dst->lwtstate);
+		nf_flow_rule_lwt_match(match, tun_info);
+	}
+
 	switch (tuple->l3proto) {
 	case AF_INET:
 		key->control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
@@ -475,6 +536,7 @@ int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
 	const struct flow_offload *flow = offload->flow;
 	const struct flow_offload_tuple *tuple;
 	struct nf_flow_rule *flow_rule;
+	struct dst_entry *other_dst;
 	int err = -ENOMEM;
 
 	flow_rule = kzalloc(sizeof(*flow_rule), GFP_KERNEL);
@@ -490,7 +552,8 @@ int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
 	flow_rule->rule->match.key = &flow_rule->match.key;
 
 	tuple = &flow->tuplehash[dir].tuple;
-	err = nf_flow_rule_match(&flow_rule->match, tuple);
+	other_dst = flow->tuplehash[!dir].tuple.dst_cache;
+	err = nf_flow_rule_match(&flow_rule->match, tuple, other_dst);
 	if (err < 0)
 		goto err_flow_match;
 
-- 
1.8.3.1

