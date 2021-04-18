Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 720E23637A3
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 23:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbhDRVEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 17:04:53 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34974 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbhDRVEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 17:04:52 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 44E3263E87;
        Sun, 18 Apr 2021 23:03:53 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 01/14] netfilter: flowtable: add vlan match offload support
Date:   Sun, 18 Apr 2021 23:04:02 +0200
Message-Id: <20210418210415.4719-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210418210415.4719-1-pablo@netfilter.org>
References: <20210418210415.4719-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch adds support for vlan_id, vlan_priority and vlan_proto match
for flowtable offload.

Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |  2 ++
 net/netfilter/nf_flow_table_offload.c | 37 +++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 583b327d8fc0..d46e422c9d10 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -21,6 +21,8 @@ struct nf_flow_key {
 	struct flow_dissector_key_control		control;
 	struct flow_dissector_key_control		enc_control;
 	struct flow_dissector_key_basic			basic;
+	struct flow_dissector_key_vlan			vlan;
+	struct flow_dissector_key_vlan			cvlan;
 	union {
 		struct flow_dissector_key_ipv4_addrs	ipv4;
 		struct flow_dissector_key_ipv6_addrs	ipv6;
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 7d0d128407be..dc1d6b4e35f8 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -78,6 +78,16 @@ static void nf_flow_rule_lwt_match(struct nf_flow_match *match,
 	match->dissector.used_keys |= enc_keys;
 }
 
+static void nf_flow_rule_vlan_match(struct flow_dissector_key_vlan *key,
+				    struct flow_dissector_key_vlan *mask,
+				    u16 vlan_id, __be16 proto)
+{
+	key->vlan_id = vlan_id;
+	mask->vlan_id = VLAN_VID_MASK;
+	key->vlan_tpid = proto;
+	mask->vlan_tpid = 0xffff;
+}
+
 static int nf_flow_rule_match(struct nf_flow_match *match,
 			      const struct flow_offload_tuple *tuple,
 			      struct dst_entry *other_dst)
@@ -85,6 +95,7 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 	struct nf_flow_key *mask = &match->mask;
 	struct nf_flow_key *key = &match->key;
 	struct ip_tunnel_info *tun_info;
+	bool vlan_encap = false;
 
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_META, meta);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_CONTROL, control);
@@ -102,6 +113,32 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 	key->meta.ingress_ifindex = tuple->iifidx;
 	mask->meta.ingress_ifindex = 0xffffffff;
 
+	if (tuple->encap_num > 0 && !(tuple->in_vlan_ingress & BIT(0)) &&
+	    tuple->encap[0].proto == htons(ETH_P_8021Q)) {
+		NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_VLAN, vlan);
+		nf_flow_rule_vlan_match(&key->vlan, &mask->vlan,
+					tuple->encap[0].id,
+					tuple->encap[0].proto);
+		vlan_encap = true;
+	}
+
+	if (tuple->encap_num > 1 && !(tuple->in_vlan_ingress & BIT(1)) &&
+	    tuple->encap[1].proto == htons(ETH_P_8021Q)) {
+		if (vlan_encap) {
+			NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_CVLAN,
+					  cvlan);
+			nf_flow_rule_vlan_match(&key->cvlan, &mask->cvlan,
+						tuple->encap[1].id,
+						tuple->encap[1].proto);
+		} else {
+			NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_VLAN,
+					  vlan);
+			nf_flow_rule_vlan_match(&key->vlan, &mask->vlan,
+						tuple->encap[1].id,
+						tuple->encap[1].proto);
+		}
+	}
+
 	switch (tuple->l3proto) {
 	case AF_INET:
 		key->control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
-- 
2.30.2

