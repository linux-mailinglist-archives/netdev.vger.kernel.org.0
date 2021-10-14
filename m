Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7531A42D8FF
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 14:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbhJNMNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 08:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbhJNMN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 08:13:26 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D736DC061570;
        Thu, 14 Oct 2021 05:11:21 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mazZw-0002ld-9c; Thu, 14 Oct 2021 14:11:20 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, me@ubique.spb.ru,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH RFC nf-next 4/9] netfilter: make hook functions accept only one argument
Date:   Thu, 14 Oct 2021 14:10:41 +0200
Message-Id: <20211014121046.29329-6-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211014121046.29329-1-fw@strlen.de>
References: <20211014121046.29329-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF conversion requirement: one pointer-to-structure as argument.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 drivers/net/ipvlan/ipvlan_l3s.c            |  4 +-
 include/linux/netfilter.h                  | 10 ++--
 include/net/netfilter/br_netfilter.h       |  7 +--
 include/net/netfilter/nf_flow_table.h      |  6 +--
 include/net/netfilter/nf_synproxy.h        |  6 +--
 net/bridge/br_netfilter_hooks.c            | 27 ++++------
 net/bridge/br_netfilter_ipv6.c             |  5 +-
 net/bridge/netfilter/ebtable_broute.c      |  8 +--
 net/bridge/netfilter/ebtable_filter.c      |  5 +-
 net/bridge/netfilter/ebtable_nat.c         |  5 +-
 net/bridge/netfilter/nf_conntrack_bridge.c |  8 +--
 net/ipv4/netfilter/arptable_filter.c       |  5 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c         |  6 +--
 net/ipv4/netfilter/iptable_filter.c        |  5 +-
 net/ipv4/netfilter/iptable_mangle.c        |  7 +--
 net/ipv4/netfilter/iptable_nat.c           |  6 +--
 net/ipv4/netfilter/iptable_raw.c           |  5 +-
 net/ipv4/netfilter/iptable_security.c      |  5 +-
 net/ipv4/netfilter/nf_defrag_ipv4.c        |  5 +-
 net/ipv6/netfilter/ip6table_filter.c       |  5 +-
 net/ipv6/netfilter/ip6table_mangle.c       |  6 ++-
 net/ipv6/netfilter/ip6table_nat.c          |  6 +--
 net/ipv6/netfilter/ip6table_raw.c          |  5 +-
 net/ipv6/netfilter/ip6table_security.c     |  5 +-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c  |  5 +-
 net/netfilter/core.c                       |  5 +-
 net/netfilter/ipvs/ip_vs_core.c            | 48 ++++++++----------
 net/netfilter/nf_conntrack_proto.c         | 34 +++++--------
 net/netfilter/nf_flow_table_inet.c         |  9 ++--
 net/netfilter/nf_flow_table_ip.c           | 12 ++---
 net/netfilter/nf_nat_core.c                | 10 ++--
 net/netfilter/nf_nat_proto.c               | 56 +++++++++++----------
 net/netfilter/nf_synproxy_core.c           |  8 +--
 net/netfilter/nft_chain_filter.c           | 48 ++++++++----------
 net/netfilter/nft_chain_nat.c              |  7 ++-
 net/netfilter/nft_chain_route.c            | 22 ++++----
 security/selinux/hooks.c                   | 58 +++++-----------------
 37 files changed, 207 insertions(+), 277 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan_l3s.c b/drivers/net/ipvlan/ipvlan_l3s.c
index 943d26cbf39f..a6af569fcc27 100644
--- a/drivers/net/ipvlan/ipvlan_l3s.c
+++ b/drivers/net/ipvlan/ipvlan_l3s.c
@@ -90,9 +90,9 @@ static const struct l3mdev_ops ipvl_l3mdev_ops = {
 	.l3mdev_l3_rcv = ipvlan_l3_rcv,
 };
 
-static unsigned int ipvlan_nf_input(void *priv, struct sk_buff *skb,
-				    const struct nf_hook_state *state)
+static unsigned int ipvlan_nf_input(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
 	struct ipvl_addr *addr;
 	unsigned int len;
 
diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 61a8c8ded57b..c5de525218c2 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -65,6 +65,8 @@ struct nf_hook_ops;
 struct sock;
 
 struct nf_hook_state {
+	struct sk_buff *skb;
+	void *priv;
 	u8 hook;
 	u8 pf;
 	u16 hook_index; /* index in hook_entries->hook[] */
@@ -75,9 +77,7 @@ struct nf_hook_state {
 	int (*okfn)(struct net *, struct sock *, struct sk_buff *);
 };
 
-typedef unsigned int nf_hookfn(void *priv,
-			       struct sk_buff *skb,
-			       const struct nf_hook_state *state);
+typedef unsigned int nf_hookfn(const struct nf_hook_state *state);
 enum nf_hook_ops_type {
 	NF_HOOK_OP_UNDEFINED,
 	NF_HOOK_OP_NF_TABLES,
@@ -140,7 +140,9 @@ static inline int
 nf_hook_entry_hookfn(const struct nf_hook_entry *entry, struct sk_buff *skb,
 		     struct nf_hook_state *state)
 {
-	return entry->hook(entry->priv, skb, state);
+	state->skb = skb;
+	state->priv = entry->priv;
+	return entry->hook(state);
 }
 
 static inline void nf_hook_state_init(struct nf_hook_state *p,
diff --git a/include/net/netfilter/br_netfilter.h b/include/net/netfilter/br_netfilter.h
index 371696ec11b2..9c37bf316077 100644
--- a/include/net/netfilter/br_netfilter.h
+++ b/include/net/netfilter/br_netfilter.h
@@ -57,9 +57,7 @@ struct net_device *setup_pre_routing(struct sk_buff *skb,
 
 #if IS_ENABLED(CONFIG_IPV6)
 int br_validate_ipv6(struct net *net, struct sk_buff *skb);
-unsigned int br_nf_pre_routing_ipv6(void *priv,
-				    struct sk_buff *skb,
-				    const struct nf_hook_state *state);
+unsigned int br_nf_pre_routing_ipv6(const struct nf_hook_state *state);
 #else
 static inline int br_validate_ipv6(struct net *net, struct sk_buff *skb)
 {
@@ -67,8 +65,7 @@ static inline int br_validate_ipv6(struct net *net, struct sk_buff *skb)
 }
 
 static inline unsigned int
-br_nf_pre_routing_ipv6(void *priv, struct sk_buff *skb,
-		       const struct nf_hook_state *state)
+br_nf_pre_routing_ipv6(const struct nf_hook_state *state)
 {
 	return NF_ACCEPT;
 }
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index a3647fadf1cc..50947d52f7c2 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -284,10 +284,8 @@ struct flow_ports {
 	__be16 source, dest;
 };
 
-unsigned int nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
-				     const struct nf_hook_state *state);
-unsigned int nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
-				       const struct nf_hook_state *state);
+unsigned int nf_flow_offload_ip_hook(const struct nf_hook_state *state);
+unsigned int nf_flow_offload_ipv6_hook(const struct nf_hook_state *state);
 
 #define MODULE_ALIAS_NF_FLOWTABLE(family)	\
 	MODULE_ALIAS("nf-flowtable-" __stringify(family))
diff --git a/include/net/netfilter/nf_synproxy.h b/include/net/netfilter/nf_synproxy.h
index a336f9434e73..9cf8db712e88 100644
--- a/include/net/netfilter/nf_synproxy.h
+++ b/include/net/netfilter/nf_synproxy.h
@@ -60,8 +60,7 @@ bool synproxy_recv_client_ack(struct net *net,
 
 struct nf_hook_state;
 
-unsigned int ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
-				const struct nf_hook_state *nhs);
+unsigned int ipv4_synproxy_hook(const struct nf_hook_state *nhs);
 int nf_synproxy_ipv4_init(struct synproxy_net *snet, struct net *net);
 void nf_synproxy_ipv4_fini(struct synproxy_net *snet, struct net *net);
 
@@ -75,8 +74,7 @@ bool synproxy_recv_client_ack_ipv6(struct net *net, const struct sk_buff *skb,
 				   const struct tcphdr *th,
 				   struct synproxy_options *opts, u32 recv_seq);
 
-unsigned int ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
-				const struct nf_hook_state *nhs);
+unsigned int ipv6_synproxy_hook(const struct nf_hook_state *nhs);
 int nf_synproxy_ipv6_init(struct synproxy_net *snet, struct net *net);
 void nf_synproxy_ipv6_fini(struct synproxy_net *snet, struct net *net);
 #else
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 5ed8b698ce11..1c297db5e7cf 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -472,10 +472,9 @@ struct net_device *setup_pre_routing(struct sk_buff *skb, const struct net *net)
  * receiving device) to make netfilter happy, the REDIRECT
  * target in particular.  Save the original destination IP
  * address to be able to detect DNAT afterwards. */
-static unsigned int br_nf_pre_routing(void *priv,
-				      struct sk_buff *skb,
-				      const struct nf_hook_state *state)
+static unsigned int br_nf_pre_routing(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
 	struct nf_bridge_info *nf_bridge;
 	struct net_bridge_port *p;
 	struct net_bridge *br;
@@ -502,7 +501,7 @@ static unsigned int br_nf_pre_routing(void *priv,
 		}
 
 		nf_bridge_pull_encap_header_rcsum(skb);
-		return br_nf_pre_routing_ipv6(priv, skb, state);
+		return br_nf_pre_routing_ipv6(state);
 	}
 
 	if (!brnet->call_iptables && !br_opt_get(br, BROPT_NF_CALL_IPTABLES))
@@ -572,10 +571,9 @@ static int br_nf_forward_finish(struct net *net, struct sock *sk, struct sk_buff
  * but we are still able to filter on the 'real' indev/outdev
  * because of the physdev module. For ARP, indev and outdev are the
  * bridge ports. */
-static unsigned int br_nf_forward_ip(void *priv,
-				     struct sk_buff *skb,
-				     const struct nf_hook_state *state)
+static unsigned int br_nf_forward_ip(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
 	struct nf_bridge_info *nf_bridge;
 	struct net_device *parent;
 	u_int8_t pf;
@@ -638,10 +636,9 @@ static unsigned int br_nf_forward_ip(void *priv,
 	return NF_STOLEN;
 }
 
-static unsigned int br_nf_forward_arp(void *priv,
-				      struct sk_buff *skb,
-				      const struct nf_hook_state *state)
+static unsigned int br_nf_forward_arp(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
 	struct net_bridge_port *p;
 	struct net_bridge *br;
 	struct net_device **d = (struct net_device **)(skb->cb);
@@ -812,10 +809,9 @@ static int br_nf_dev_queue_xmit(struct net *net, struct sock *sk, struct sk_buff
 }
 
 /* PF_BRIDGE/POST_ROUTING ********************************************/
-static unsigned int br_nf_post_routing(void *priv,
-				       struct sk_buff *skb,
-				       const struct nf_hook_state *state)
+static unsigned int br_nf_post_routing(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
 	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
 	struct net_device *realoutdev = bridge_parent(skb->dev);
 	u_int8_t pf;
@@ -861,10 +857,9 @@ static unsigned int br_nf_post_routing(void *priv,
 /* IP/SABOTAGE *****************************************************/
 /* Don't hand locally destined packets to PF_INET(6)/PRE_ROUTING
  * for the second time. */
-static unsigned int ip_sabotage_in(void *priv,
-				   struct sk_buff *skb,
-				   const struct nf_hook_state *state)
+static unsigned int ip_sabotage_in(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
 	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
 
 	if (nf_bridge && !nf_bridge->in_prerouting &&
diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index e4e0c836c3f5..e558f8b2175a 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -212,11 +212,10 @@ static int br_nf_pre_routing_finish_ipv6(struct net *net, struct sock *sk, struc
 /* Replicate the checks that IPv6 does on packet reception and pass the packet
  * to ip6tables.
  */
-unsigned int br_nf_pre_routing_ipv6(void *priv,
-				    struct sk_buff *skb,
-				    const struct nf_hook_state *state)
+unsigned int br_nf_pre_routing_ipv6(const struct nf_hook_state *state)
 {
 	struct nf_bridge_info *nf_bridge;
+	struct sk_buff *skb = state->skb;
 
 	if (br_validate_ipv6(state->net, skb))
 		return NF_DROP;
diff --git a/net/bridge/netfilter/ebtable_broute.c b/net/bridge/netfilter/ebtable_broute.c
index a7af4eaff17d..54616a888f3f 100644
--- a/net/bridge/netfilter/ebtable_broute.c
+++ b/net/bridge/netfilter/ebtable_broute.c
@@ -51,9 +51,9 @@ static const struct ebt_table broute_table = {
 	.me		= THIS_MODULE,
 };
 
-static unsigned int ebt_broute(void *priv, struct sk_buff *skb,
-			       const struct nf_hook_state *s)
+static unsigned int ebt_broute(const struct nf_hook_state *s)
 {
+	struct sk_buff *skb = s->skb;
 	struct net_bridge_port *p = br_port_get_rcu(skb->dev);
 	struct nf_hook_state state;
 	unsigned char *dest;
@@ -66,7 +66,9 @@ static unsigned int ebt_broute(void *priv, struct sk_buff *skb,
 			   NFPROTO_BRIDGE, s->in, NULL, NULL,
 			   s->net, NULL);
 
-	ret = ebt_do_table(skb, &state, priv);
+	state.skb = skb;
+	state.priv = s->priv;
+	ret = ebt_do_table(skb, &state, s->priv);
 	if (ret != NF_DROP)
 		return ret;
 
diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
index c0b121df4a9a..aa36541a4f92 100644
--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -59,10 +59,9 @@ static const struct ebt_table frame_filter = {
 };
 
 static unsigned int
-ebt_filter_hook(void *priv, struct sk_buff *skb,
-		const struct nf_hook_state *state)
+ebt_filter_hook(const struct nf_hook_state *state)
 {
-	return ebt_do_table(skb, state, priv);
+	return ebt_do_table(state->skb, state, state->priv);
 }
 
 static const struct nf_hook_ops ebt_ops_filter[] = {
diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
index 4078151c224f..901029d1e34c 100644
--- a/net/bridge/netfilter/ebtable_nat.c
+++ b/net/bridge/netfilter/ebtable_nat.c
@@ -58,10 +58,9 @@ static const struct ebt_table frame_nat = {
 	.me		= THIS_MODULE,
 };
 
-static unsigned int ebt_nat_hook(void *priv, struct sk_buff *skb,
-				 const struct nf_hook_state *state)
+static unsigned int ebt_nat_hook(const struct nf_hook_state *state)
 {
-	return ebt_do_table(skb, state, priv);
+	return ebt_do_table(state->skb, state, state->priv);
 }
 
 static const struct nf_hook_ops ebt_ops_nat[] = {
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index fdbed3158555..7c9e533fec0d 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -236,10 +236,10 @@ static int nf_ct_br_ipv6_check(const struct sk_buff *skb)
 	return 0;
 }
 
-static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
-				     const struct nf_hook_state *state)
+static unsigned int nf_ct_bridge_pre(const struct nf_hook_state *state)
 {
 	struct nf_hook_state bridge_state = *state;
+	struct sk_buff *skb = state->skb;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
 	u32 len;
@@ -395,9 +395,9 @@ static unsigned int nf_ct_bridge_confirm(struct sk_buff *skb)
 	return nf_confirm(skb, protoff, ct, ctinfo);
 }
 
-static unsigned int nf_ct_bridge_post(void *priv, struct sk_buff *skb,
-				      const struct nf_hook_state *state)
+static unsigned int nf_ct_bridge_post(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
 	int ret;
 
 	ret = nf_ct_bridge_confirm(skb);
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 3de78416ec76..14f7316c0563 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -28,10 +28,9 @@ static const struct xt_table packet_filter = {
 
 /* The work comes in here from netfilter.c */
 static unsigned int
-arptable_filter_hook(void *priv, struct sk_buff *skb,
-		     const struct nf_hook_state *state)
+arptable_filter_hook(const struct nf_hook_state *state)
 {
-	return arpt_do_table(skb, state, priv);
+	return arpt_do_table(state->skb, state, state->priv);
 }
 
 static struct nf_hook_ops *arpfilter_ops __read_mostly;
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 8fd1aba8af31..0610933c503a 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -75,7 +75,7 @@ struct clusterip_net {
 	unsigned int hook_users;
 };
 
-static unsigned int clusterip_arp_mangle(void *priv, struct sk_buff *skb, const struct nf_hook_state *state);
+static unsigned int clusterip_arp_mangle(const struct nf_hook_state *state);
 
 static const struct nf_hook_ops cip_arp_ops = {
 	.hook = clusterip_arp_mangle,
@@ -635,9 +635,9 @@ static void arp_print(struct arp_payload *payload)
 #endif
 
 static unsigned int
-clusterip_arp_mangle(void *priv, struct sk_buff *skb,
-		     const struct nf_hook_state *state)
+clusterip_arp_mangle(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
 	struct arphdr *arp = arp_hdr(skb);
 	struct arp_payload *payload;
 	struct clusterip_config *c;
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 0eb0e2ab9bfc..d67577320d05 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -29,10 +29,9 @@ static const struct xt_table packet_filter = {
 };
 
 static unsigned int
-iptable_filter_hook(void *priv, struct sk_buff *skb,
-		    const struct nf_hook_state *state)
+iptable_filter_hook(const struct nf_hook_state *state)
 {
-	return ipt_do_table(skb, state, priv);
+	return ipt_do_table(state->skb, state, state->priv);
 }
 
 static struct nf_hook_ops *filter_ops __read_mostly;
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 40417a3f930b..b1585a9dd128 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -70,10 +70,11 @@ ipt_mangle_out(struct sk_buff *skb, const struct nf_hook_state *state, void *pri
 
 /* The work comes in here from netfilter.c. */
 static unsigned int
-iptable_mangle_hook(void *priv,
-		     struct sk_buff *skb,
-		     const struct nf_hook_state *state)
+iptable_mangle_hook(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
+	void *priv = state->priv;
+
 	if (state->hook == NF_INET_LOCAL_OUT)
 		return ipt_mangle_out(skb, state, priv);
 	return ipt_do_table(skb, state, priv);
diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index 45d7e072e6a5..d51901b367e4 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -29,11 +29,9 @@ static const struct xt_table nf_nat_ipv4_table = {
 	.af		= NFPROTO_IPV4,
 };
 
-static unsigned int iptable_nat_do_chain(void *priv,
-					 struct sk_buff *skb,
-					 const struct nf_hook_state *state)
+static unsigned int iptable_nat_do_chain(const struct nf_hook_state *state)
 {
-	return ipt_do_table(skb, state, priv);
+	return ipt_do_table(state->skb, state, state->priv);
 }
 
 static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 8265c6765705..88dc4b8ab2ac 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -34,10 +34,9 @@ static const struct xt_table packet_raw_before_defrag = {
 
 /* The work comes in here from netfilter.c. */
 static unsigned int
-iptable_raw_hook(void *priv, struct sk_buff *skb,
-		 const struct nf_hook_state *state)
+iptable_raw_hook(const struct nf_hook_state *state)
 {
-	return ipt_do_table(skb, state, priv);
+	return ipt_do_table(state->skb, state, state->priv);
 }
 
 static struct nf_hook_ops *rawtable_ops __read_mostly;
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index f519162a2fa5..8ab59e0d04ae 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -34,10 +34,9 @@ static const struct xt_table security_table = {
 };
 
 static unsigned int
-iptable_security_hook(void *priv, struct sk_buff *skb,
-		      const struct nf_hook_state *state)
+iptable_security_hook(const struct nf_hook_state *state)
 {
-	return ipt_do_table(skb, state, priv);
+	return ipt_do_table(state->skb, state, state->priv);
 }
 
 static struct nf_hook_ops *sectbl_ops __read_mostly;
diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index 613432a36f0a..82fa58b9276a 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -63,10 +63,9 @@ static enum ip_defrag_users nf_ct_defrag_user(unsigned int hooknum,
 		return IP_DEFRAG_CONNTRACK_OUT + zone_id;
 }
 
-static unsigned int ipv4_conntrack_defrag(void *priv,
-					  struct sk_buff *skb,
-					  const struct nf_hook_state *state)
+static unsigned int ipv4_conntrack_defrag(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
 	struct sock *sk = skb->sk;
 
 	if (sk && sk_fullsock(sk) && (sk->sk_family == PF_INET) &&
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 727ee8097012..90c475ac13d6 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -29,10 +29,9 @@ static const struct xt_table packet_filter = {
 
 /* The work comes in here from netfilter.c. */
 static unsigned int
-ip6table_filter_hook(void *priv, struct sk_buff *skb,
-		     const struct nf_hook_state *state)
+ip6table_filter_hook(const struct nf_hook_state *state)
 {
-	return ip6t_do_table(skb, state, priv);
+	return ip6t_do_table(state->skb, state, state->priv);
 }
 
 static struct nf_hook_ops *filter_ops __read_mostly;
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 9b518ce37d6a..fc1f7a4b9d59 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -64,9 +64,11 @@ ip6t_mangle_out(struct sk_buff *skb, const struct nf_hook_state *state, void *pr
 
 /* The work comes in here from netfilter.c. */
 static unsigned int
-ip6table_mangle_hook(void *priv, struct sk_buff *skb,
-		     const struct nf_hook_state *state)
+ip6table_mangle_hook(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
+	void *priv = state->priv;
+
 	if (state->hook == NF_INET_LOCAL_OUT)
 		return ip6t_mangle_out(skb, state, priv);
 	return ip6t_do_table(skb, state, priv);
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index 921c1723a01e..d4c9f5d0dc37 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -31,11 +31,9 @@ static const struct xt_table nf_nat_ipv6_table = {
 	.af		= NFPROTO_IPV6,
 };
 
-static unsigned int ip6table_nat_do_chain(void *priv,
-					  struct sk_buff *skb,
-					  const struct nf_hook_state *state)
+static unsigned int ip6table_nat_do_chain(const struct nf_hook_state *state)
 {
-	return ip6t_do_table(skb, state, priv);
+	return ip6t_do_table(state->skb, state, state->priv);
 }
 
 static const struct nf_hook_ops nf_nat_ipv6_ops[] = {
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 4f2a04af71d3..9655f93927ce 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -33,10 +33,9 @@ static const struct xt_table packet_raw_before_defrag = {
 
 /* The work comes in here from netfilter.c. */
 static unsigned int
-ip6table_raw_hook(void *priv, struct sk_buff *skb,
-		  const struct nf_hook_state *state)
+ip6table_raw_hook(const struct nf_hook_state *state)
 {
-	return ip6t_do_table(skb, state, priv);
+	return ip6t_do_table(state->skb, state, state->priv);
 }
 
 static struct nf_hook_ops *rawtable_ops __read_mostly;
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index 931674034d8b..ff2c244488ec 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -33,10 +33,9 @@ static const struct xt_table security_table = {
 };
 
 static unsigned int
-ip6table_security_hook(void *priv, struct sk_buff *skb,
-		       const struct nf_hook_state *state)
+ip6table_security_hook(const struct nf_hook_state *state)
 {
-	return ip6t_do_table(skb, state, priv);
+	return ip6t_do_table(state->skb, state, state->priv);
 }
 
 static struct nf_hook_ops *sectbl_ops __read_mostly;
diff --git a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
index e8a59d8bf2ad..e02f798702d4 100644
--- a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
+++ b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
@@ -50,10 +50,9 @@ static enum ip6_defrag_users nf_ct6_defrag_user(unsigned int hooknum,
 		return IP6_DEFRAG_CONNTRACK_OUT + zone_id;
 }
 
-static unsigned int ipv6_defrag(void *priv,
-				struct sk_buff *skb,
-				const struct nf_hook_state *state)
+static unsigned int ipv6_defrag(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
 	int err;
 
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 129d48304821..3fd268afc13e 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -88,9 +88,7 @@ static void nf_hook_entries_free(struct nf_hook_entries *e)
 	call_rcu(&head->head, __nf_hook_entries_free);
 }
 
-static unsigned int accept_all(void *priv,
-			       struct sk_buff *skb,
-			       const struct nf_hook_state *state)
+static unsigned int accept_all(const struct nf_hook_state *state)
 {
 	return NF_ACCEPT; /* ACCEPT makes nf_hook_slow call next hook */
 }
@@ -585,6 +583,7 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
 	unsigned int verdict, s = state->hook_index;
 	int ret;
 
+	state->skb = skb;
 	for (; s < e->num_hook_entries; s++) {
 		verdict = nf_hook_entry_hookfn(&e->hooks[s], skb, state);
 		switch (verdict & NF_VERDICT_MASK) {
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 128690c512df..f69ed7648c71 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1474,10 +1474,9 @@ ip_vs_out(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, in
  *	Check if packet is reply for established ip_vs_conn.
  */
 static unsigned int
-ip_vs_reply4(void *priv, struct sk_buff *skb,
-	     const struct nf_hook_state *state)
+ip_vs_reply4(const struct nf_hook_state *state)
 {
-	return ip_vs_out(net_ipvs(state->net), state->hook, skb, AF_INET);
+	return ip_vs_out(net_ipvs(state->net), state->hook, state->skb, AF_INET);
 }
 
 /*
@@ -1485,10 +1484,9 @@ ip_vs_reply4(void *priv, struct sk_buff *skb,
  *	Check if packet is reply for established ip_vs_conn.
  */
 static unsigned int
-ip_vs_local_reply4(void *priv, struct sk_buff *skb,
-		   const struct nf_hook_state *state)
+ip_vs_local_reply4(const struct nf_hook_state *state)
 {
-	return ip_vs_out(net_ipvs(state->net), state->hook, skb, AF_INET);
+	return ip_vs_out(net_ipvs(state->net), state->hook, state->skb, AF_INET);
 }
 
 #ifdef CONFIG_IP_VS_IPV6
@@ -1499,10 +1497,9 @@ ip_vs_local_reply4(void *priv, struct sk_buff *skb,
  *	Check if packet is reply for established ip_vs_conn.
  */
 static unsigned int
-ip_vs_reply6(void *priv, struct sk_buff *skb,
-	     const struct nf_hook_state *state)
+ip_vs_reply6(const struct nf_hook_state *state)
 {
-	return ip_vs_out(net_ipvs(state->net), state->hook, skb, AF_INET6);
+	return ip_vs_out(net_ipvs(state->net), state->hook, state->skb, AF_INET6);
 }
 
 /*
@@ -1510,10 +1507,9 @@ ip_vs_reply6(void *priv, struct sk_buff *skb,
  *	Check if packet is reply for established ip_vs_conn.
  */
 static unsigned int
-ip_vs_local_reply6(void *priv, struct sk_buff *skb,
-		   const struct nf_hook_state *state)
+ip_vs_local_reply6(const struct nf_hook_state *state)
 {
-	return ip_vs_out(net_ipvs(state->net), state->hook, skb, AF_INET6);
+	return ip_vs_out(net_ipvs(state->net), state->hook, state->skb, AF_INET6);
 }
 
 #endif
@@ -2142,10 +2138,9 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
  *	Schedule and forward packets from remote clients
  */
 static unsigned int
-ip_vs_remote_request4(void *priv, struct sk_buff *skb,
-		      const struct nf_hook_state *state)
+ip_vs_remote_request4(const struct nf_hook_state *state)
 {
-	return ip_vs_in(net_ipvs(state->net), state->hook, skb, AF_INET);
+	return ip_vs_in(net_ipvs(state->net), state->hook, state->skb, AF_INET);
 }
 
 /*
@@ -2153,10 +2148,9 @@ ip_vs_remote_request4(void *priv, struct sk_buff *skb,
  *	Schedule and forward packets from local clients
  */
 static unsigned int
-ip_vs_local_request4(void *priv, struct sk_buff *skb,
-		     const struct nf_hook_state *state)
+ip_vs_local_request4(const struct nf_hook_state *state)
 {
-	return ip_vs_in(net_ipvs(state->net), state->hook, skb, AF_INET);
+	return ip_vs_in(net_ipvs(state->net), state->hook, state->skb, AF_INET);
 }
 
 #ifdef CONFIG_IP_VS_IPV6
@@ -2166,10 +2160,9 @@ ip_vs_local_request4(void *priv, struct sk_buff *skb,
  *	Schedule and forward packets from remote clients
  */
 static unsigned int
-ip_vs_remote_request6(void *priv, struct sk_buff *skb,
-		      const struct nf_hook_state *state)
+ip_vs_remote_request6(const struct nf_hook_state *state)
 {
-	return ip_vs_in(net_ipvs(state->net), state->hook, skb, AF_INET6);
+	return ip_vs_in(net_ipvs(state->net), state->hook, state->skb, AF_INET6);
 }
 
 /*
@@ -2177,10 +2170,9 @@ ip_vs_remote_request6(void *priv, struct sk_buff *skb,
  *	Schedule and forward packets from local clients
  */
 static unsigned int
-ip_vs_local_request6(void *priv, struct sk_buff *skb,
-		     const struct nf_hook_state *state)
+ip_vs_local_request6(const struct nf_hook_state *state)
 {
-	return ip_vs_in(net_ipvs(state->net), state->hook, skb, AF_INET6);
+	return ip_vs_in(net_ipvs(state->net), state->hook, state->skb, AF_INET6);
 }
 
 #endif
@@ -2196,11 +2188,11 @@ ip_vs_local_request6(void *priv, struct sk_buff *skb,
  *      and send them to ip_vs_in_icmp.
  */
 static unsigned int
-ip_vs_forward_icmp(void *priv, struct sk_buff *skb,
-		   const struct nf_hook_state *state)
+ip_vs_forward_icmp(const struct nf_hook_state *state)
 {
 	int r;
 	struct netns_ipvs *ipvs = net_ipvs(state->net);
+	struct sk_buff *skb = state->skb;
 
 	if (ip_hdr(skb)->protocol != IPPROTO_ICMP)
 		return NF_ACCEPT;
@@ -2214,11 +2206,11 @@ ip_vs_forward_icmp(void *priv, struct sk_buff *skb,
 
 #ifdef CONFIG_IP_VS_IPV6
 static unsigned int
-ip_vs_forward_icmp_v6(void *priv, struct sk_buff *skb,
-		      const struct nf_hook_state *state)
+ip_vs_forward_icmp_v6(const struct nf_hook_state *state)
 {
 	int r;
 	struct netns_ipvs *ipvs = net_ipvs(state->net);
+	struct sk_buff *skb = state->skb;
 	struct ip_vs_iphdr iphdr;
 
 	ip_vs_fill_iph_skb(AF_INET6, skb, false, &iphdr);
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 8f7a9837349c..3207bb64e4ca 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -155,10 +155,9 @@ unsigned int nf_confirm(struct sk_buff *skb, unsigned int protoff,
 }
 EXPORT_SYMBOL_GPL(nf_confirm);
 
-static unsigned int ipv4_confirm(void *priv,
-				 struct sk_buff *skb,
-				 const struct nf_hook_state *state)
+static unsigned int ipv4_confirm(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
 
@@ -171,17 +170,15 @@ static unsigned int ipv4_confirm(void *priv,
 			  ct, ctinfo);
 }
 
-static unsigned int ipv4_conntrack_in(void *priv,
-				      struct sk_buff *skb,
-				      const struct nf_hook_state *state)
+static unsigned int ipv4_conntrack_in(const struct nf_hook_state *state)
 {
-	return nf_conntrack_in(skb, state);
+	return nf_conntrack_in(state->skb, state);
 }
 
-static unsigned int ipv4_conntrack_local(void *priv,
-					 struct sk_buff *skb,
-					 const struct nf_hook_state *state)
+static unsigned int ipv4_conntrack_local(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
+
 	if (ip_is_fragment(ip_hdr(skb))) { /* IP_NODEFRAG setsockopt set */
 		enum ip_conntrack_info ctinfo;
 		struct nf_conn *tmpl;
@@ -360,10 +357,9 @@ static struct nf_sockopt_ops so_getorigdst6 = {
 	.owner		= THIS_MODULE,
 };
 
-static unsigned int ipv6_confirm(void *priv,
-				 struct sk_buff *skb,
-				 const struct nf_hook_state *state)
+static unsigned int ipv6_confirm(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	unsigned char pnum = ipv6_hdr(skb)->nexthdr;
@@ -384,18 +380,14 @@ static unsigned int ipv6_confirm(void *priv,
 	return nf_confirm(skb, protoff, ct, ctinfo);
 }
 
-static unsigned int ipv6_conntrack_in(void *priv,
-				      struct sk_buff *skb,
-				      const struct nf_hook_state *state)
+static unsigned int ipv6_conntrack_in(const struct nf_hook_state *state)
 {
-	return nf_conntrack_in(skb, state);
+	return nf_conntrack_in(state->skb, state);
 }
 
-static unsigned int ipv6_conntrack_local(void *priv,
-					 struct sk_buff *skb,
-					 const struct nf_hook_state *state)
+static unsigned int ipv6_conntrack_local(const struct nf_hook_state *state)
 {
-	return nf_conntrack_in(skb, state);
+	return nf_conntrack_in(state->skb, state);
 }
 
 static const struct nf_hook_ops ipv6_conntrack_ops[] = {
diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index bc4126d8ef65..8091d79d76cc 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -8,14 +8,15 @@
 #include <net/netfilter/nf_tables.h>
 
 static unsigned int
-nf_flow_offload_inet_hook(void *priv, struct sk_buff *skb,
-			  const struct nf_hook_state *state)
+nf_flow_offload_inet_hook(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
+
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
-		return nf_flow_offload_ip_hook(priv, skb, state);
+		return nf_flow_offload_ip_hook(state);
 	case htons(ETH_P_IPV6):
-		return nf_flow_offload_ipv6_hook(priv, skb, state);
+		return nf_flow_offload_ipv6_hook(state);
 	}
 
 	return NF_ACCEPT;
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 889cf88d3dba..80dd90ee4ffc 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -325,12 +325,12 @@ static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
 }
 
 unsigned int
-nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
-			const struct nf_hook_state *state)
+nf_flow_offload_ip_hook(const struct nf_hook_state *state)
 {
+	struct nf_flowtable *flow_table = state->priv;
 	struct flow_offload_tuple_rhash *tuplehash;
-	struct nf_flowtable *flow_table = priv;
 	struct flow_offload_tuple tuple = {};
+	struct sk_buff *skb = state->skb;
 	enum flow_offload_tuple_dir dir;
 	struct flow_offload *flow;
 	struct net_device *outdev;
@@ -561,12 +561,12 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 }
 
 unsigned int
-nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
-			  const struct nf_hook_state *state)
+nf_flow_offload_ipv6_hook(const struct nf_hook_state *state)
 {
+	struct nf_flowtable *flow_table = state->priv;
 	struct flow_offload_tuple_rhash *tuplehash;
-	struct nf_flowtable *flow_table = priv;
 	struct flow_offload_tuple tuple = {};
+	struct sk_buff *skb = state->skb;
 	enum flow_offload_tuple_dir dir;
 	const struct in6_addr *nexthop;
 	struct flow_offload *flow;
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index a6a273fff3f6..9105764d52a4 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -700,20 +700,24 @@ unsigned int nf_nat_packet(struct nf_conn *ct,
 EXPORT_SYMBOL_GPL(nf_nat_packet);
 
 static unsigned int nf_nat_inet_run_hooks(const struct nf_hook_state *state,
-					  struct sk_buff *skb,
 					  struct nf_conn *ct,
 					  struct nf_nat_lookup_hook_priv *lpriv)
 {
 	enum nf_nat_manip_type maniptype = HOOK2MANIP(state->hook);
 	struct nf_hook_entries *e = rcu_dereference(lpriv->entries);
+	struct nf_hook_state __state;
 	unsigned int ret;
 	int i;
 
 	if (!e)
 		goto null_bind;
 
+	__state = *state;
+
 	for (i = 0; i < e->num_hook_entries; i++) {
-		ret = e->hooks[i].hook(e->hooks[i].priv, skb, state);
+		__state.priv = e->hooks[i].priv;
+
+		ret = e->hooks[i].hook(&__state);
 		if (ret != NF_ACCEPT)
 			return ret;
 
@@ -758,7 +762,7 @@ nf_nat_inet_fn(void *priv, struct sk_buff *skb,
 			struct nf_nat_lookup_hook_priv *lpriv = priv;
 			unsigned int ret;
 
-			ret = nf_nat_inet_run_hooks(state, skb, ct, lpriv);
+			ret = nf_nat_inet_run_hooks(state, ct, lpriv);
 			if (ret != NF_ACCEPT)
 				return ret;
 		} else {
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 48cc60084d28..187d3e59fb53 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -622,11 +622,12 @@ int nf_nat_icmp_reply_translation(struct sk_buff *skb,
 EXPORT_SYMBOL_GPL(nf_nat_icmp_reply_translation);
 
 static unsigned int
-nf_nat_ipv4_fn(void *priv, struct sk_buff *skb,
-	       const struct nf_hook_state *state)
+nf_nat_ipv4_fn(const struct nf_hook_state *state)
 {
-	struct nf_conn *ct;
+	struct sk_buff *skb = state->skb;
+	void *priv = state->priv;
 	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (!ct)
@@ -646,13 +647,13 @@ nf_nat_ipv4_fn(void *priv, struct sk_buff *skb,
 }
 
 static unsigned int
-nf_nat_ipv4_pre_routing(void *priv, struct sk_buff *skb,
-			const struct nf_hook_state *state)
+nf_nat_ipv4_pre_routing(const struct nf_hook_state *state)
 {
-	unsigned int ret;
+	struct sk_buff *skb = state->skb;
 	__be32 daddr = ip_hdr(skb)->daddr;
+	unsigned int ret;
 
-	ret = nf_nat_ipv4_fn(priv, skb, state);
+	ret = nf_nat_ipv4_fn(state);
 	if (ret == NF_ACCEPT && daddr != ip_hdr(skb)->daddr)
 		skb_dst_drop(skb);
 
@@ -698,14 +699,14 @@ static int nf_xfrm_me_harder(struct net *net, struct sk_buff *skb, unsigned int
 #endif
 
 static unsigned int
-nf_nat_ipv4_local_in(void *priv, struct sk_buff *skb,
-		     const struct nf_hook_state *state)
+nf_nat_ipv4_local_in(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
 	__be32 saddr = ip_hdr(skb)->saddr;
 	struct sock *sk = skb->sk;
 	unsigned int ret;
 
-	ret = nf_nat_ipv4_fn(priv, skb, state);
+	ret = nf_nat_ipv4_fn(state);
 
 	if (ret == NF_ACCEPT && sk && saddr != ip_hdr(skb)->saddr &&
 	    !inet_sk_transparent(sk))
@@ -715,9 +716,9 @@ nf_nat_ipv4_local_in(void *priv, struct sk_buff *skb,
 }
 
 static unsigned int
-nf_nat_ipv4_out(void *priv, struct sk_buff *skb,
-		const struct nf_hook_state *state)
+nf_nat_ipv4_out(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
 #ifdef CONFIG_XFRM
 	const struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
@@ -725,7 +726,7 @@ nf_nat_ipv4_out(void *priv, struct sk_buff *skb,
 #endif
 	unsigned int ret;
 
-	ret = nf_nat_ipv4_fn(priv, skb, state);
+	ret = nf_nat_ipv4_fn(state);
 #ifdef CONFIG_XFRM
 	if (ret != NF_ACCEPT)
 		return ret;
@@ -752,15 +753,15 @@ nf_nat_ipv4_out(void *priv, struct sk_buff *skb,
 }
 
 static unsigned int
-nf_nat_ipv4_local_fn(void *priv, struct sk_buff *skb,
-		     const struct nf_hook_state *state)
+nf_nat_ipv4_local_fn(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
 	const struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	unsigned int ret;
 	int err;
 
-	ret = nf_nat_ipv4_fn(priv, skb, state);
+	ret = nf_nat_ipv4_fn(state);
 	if (ret != NF_ACCEPT)
 		return ret;
 
@@ -901,9 +902,10 @@ int nf_nat_icmpv6_reply_translation(struct sk_buff *skb,
 EXPORT_SYMBOL_GPL(nf_nat_icmpv6_reply_translation);
 
 static unsigned int
-nf_nat_ipv6_fn(void *priv, struct sk_buff *skb,
-	       const struct nf_hook_state *state)
+nf_nat_ipv6_fn(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
+	void *priv = state->priv;
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	__be16 frag_off;
@@ -938,13 +940,13 @@ nf_nat_ipv6_fn(void *priv, struct sk_buff *skb,
 }
 
 static unsigned int
-nf_nat_ipv6_in(void *priv, struct sk_buff *skb,
-	       const struct nf_hook_state *state)
+nf_nat_ipv6_in(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
 	unsigned int ret;
 	struct in6_addr daddr = ipv6_hdr(skb)->daddr;
 
-	ret = nf_nat_ipv6_fn(priv, skb, state);
+	ret = nf_nat_ipv6_fn(state);
 	if (ret != NF_DROP && ret != NF_STOLEN &&
 	    ipv6_addr_cmp(&daddr, &ipv6_hdr(skb)->daddr))
 		skb_dst_drop(skb);
@@ -953,9 +955,9 @@ nf_nat_ipv6_in(void *priv, struct sk_buff *skb,
 }
 
 static unsigned int
-nf_nat_ipv6_out(void *priv, struct sk_buff *skb,
-		const struct nf_hook_state *state)
+nf_nat_ipv6_out(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
 #ifdef CONFIG_XFRM
 	const struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
@@ -963,7 +965,7 @@ nf_nat_ipv6_out(void *priv, struct sk_buff *skb,
 #endif
 	unsigned int ret;
 
-	ret = nf_nat_ipv6_fn(priv, skb, state);
+	ret = nf_nat_ipv6_fn(state);
 #ifdef CONFIG_XFRM
 	if (ret != NF_ACCEPT)
 		return ret;
@@ -990,15 +992,15 @@ nf_nat_ipv6_out(void *priv, struct sk_buff *skb,
 }
 
 static unsigned int
-nf_nat_ipv6_local_fn(void *priv, struct sk_buff *skb,
-		     const struct nf_hook_state *state)
+nf_nat_ipv6_local_fn(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
 	const struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	unsigned int ret;
 	int err;
 
-	ret = nf_nat_ipv6_fn(priv, skb, state);
+	ret = nf_nat_ipv6_fn(state);
 	if (ret != NF_ACCEPT)
 		return ret;
 
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 3d6d49420db8..3da1b13ccd8e 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -659,10 +659,10 @@ synproxy_recv_client_ack(struct net *net,
 EXPORT_SYMBOL_GPL(synproxy_recv_client_ack);
 
 unsigned int
-ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
-		   const struct nf_hook_state *nhs)
+ipv4_synproxy_hook(const struct nf_hook_state *nhs)
 {
 	struct net *net = nhs->net;
+	struct sk_buff *skb = nhs->skb;
 	struct synproxy_net *snet = synproxy_pernet(net);
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
@@ -1076,9 +1076,9 @@ synproxy_recv_client_ack_ipv6(struct net *net,
 EXPORT_SYMBOL_GPL(synproxy_recv_client_ack_ipv6);
 
 unsigned int
-ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
-		   const struct nf_hook_state *nhs)
+ipv6_synproxy_hook(const struct nf_hook_state *nhs)
 {
+	struct sk_buff *skb = nhs->skb;
 	struct net *net = nhs->net;
 	struct synproxy_net *snet = synproxy_pernet(net);
 	enum ip_conntrack_info ctinfo;
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 5b02408a920b..df5a84996baa 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -11,16 +11,15 @@
 #include <net/netfilter/nf_tables_ipv6.h>
 
 #ifdef CONFIG_NF_TABLES_IPV4
-static unsigned int nft_do_chain_ipv4(void *priv,
-				      struct sk_buff *skb,
-				      const struct nf_hook_state *state)
+static unsigned int nft_do_chain_ipv4(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
 	struct nft_pktinfo pkt;
 
 	nft_set_pktinfo(&pkt, skb, state);
 	nft_set_pktinfo_ipv4(&pkt);
 
-	return nft_do_chain(&pkt, priv);
+	return nft_do_chain(&pkt, state->priv);
 }
 
 static const struct nft_chain_type nft_chain_filter_ipv4 = {
@@ -56,15 +55,15 @@ static inline void nft_chain_filter_ipv4_fini(void) {}
 #endif /* CONFIG_NF_TABLES_IPV4 */
 
 #ifdef CONFIG_NF_TABLES_ARP
-static unsigned int nft_do_chain_arp(void *priv, struct sk_buff *skb,
-				     const struct nf_hook_state *state)
+static unsigned int nft_do_chain_arp(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
 	struct nft_pktinfo pkt;
 
 	nft_set_pktinfo(&pkt, skb, state);
 	nft_set_pktinfo_unspec(&pkt);
 
-	return nft_do_chain(&pkt, priv);
+	return nft_do_chain(&pkt, state->priv);
 }
 
 static const struct nft_chain_type nft_chain_filter_arp = {
@@ -95,16 +94,15 @@ static inline void nft_chain_filter_arp_fini(void) {}
 #endif /* CONFIG_NF_TABLES_ARP */
 
 #ifdef CONFIG_NF_TABLES_IPV6
-static unsigned int nft_do_chain_ipv6(void *priv,
-				      struct sk_buff *skb,
-				      const struct nf_hook_state *state)
+static unsigned int nft_do_chain_ipv6(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
 	struct nft_pktinfo pkt;
 
 	nft_set_pktinfo(&pkt, skb, state);
 	nft_set_pktinfo_ipv6(&pkt);
 
-	return nft_do_chain(&pkt, priv);
+	return nft_do_chain(&pkt, state->priv);
 }
 
 static const struct nft_chain_type nft_chain_filter_ipv6 = {
@@ -140,9 +138,9 @@ static inline void nft_chain_filter_ipv6_fini(void) {}
 #endif /* CONFIG_NF_TABLES_IPV6 */
 
 #ifdef CONFIG_NF_TABLES_INET
-static unsigned int nft_do_chain_inet(void *priv, struct sk_buff *skb,
-				      const struct nf_hook_state *state)
+static unsigned int nft_do_chain_inet(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
 	struct nft_pktinfo pkt;
 
 	nft_set_pktinfo(&pkt, skb, state);
@@ -158,13 +156,13 @@ static unsigned int nft_do_chain_inet(void *priv, struct sk_buff *skb,
 		break;
 	}
 
-	return nft_do_chain(&pkt, priv);
+	return nft_do_chain(&pkt, state->priv);
 }
 
-static unsigned int nft_do_chain_inet_ingress(void *priv, struct sk_buff *skb,
-					      const struct nf_hook_state *state)
+static unsigned int nft_do_chain_inet_ingress(const struct nf_hook_state *state)
 {
 	struct nf_hook_state ingress_state = *state;
+	struct sk_buff *skb = state->skb;
 	struct nft_pktinfo pkt;
 
 	switch (skb->protocol) {
@@ -189,7 +187,7 @@ static unsigned int nft_do_chain_inet_ingress(void *priv, struct sk_buff *skb,
 		return NF_ACCEPT;
 	}
 
-	return nft_do_chain(&pkt, priv);
+	return nft_do_chain(&pkt, state->priv);
 }
 
 static const struct nft_chain_type nft_chain_filter_inet = {
@@ -228,10 +226,9 @@ static inline void nft_chain_filter_inet_fini(void) {}
 
 #if IS_ENABLED(CONFIG_NF_TABLES_BRIDGE)
 static unsigned int
-nft_do_chain_bridge(void *priv,
-		    struct sk_buff *skb,
-		    const struct nf_hook_state *state)
+nft_do_chain_bridge(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
 	struct nft_pktinfo pkt;
 
 	nft_set_pktinfo(&pkt, skb, state);
@@ -248,7 +245,7 @@ nft_do_chain_bridge(void *priv,
 		break;
 	}
 
-	return nft_do_chain(&pkt, priv);
+	return nft_do_chain(&pkt, state->priv);
 }
 
 static const struct nft_chain_type nft_chain_filter_bridge = {
@@ -284,14 +281,13 @@ static inline void nft_chain_filter_bridge_fini(void) {}
 #endif /* CONFIG_NF_TABLES_BRIDGE */
 
 #ifdef CONFIG_NF_TABLES_NETDEV
-static unsigned int nft_do_chain_netdev(void *priv, struct sk_buff *skb,
-					const struct nf_hook_state *state)
+static unsigned int nft_do_chain_netdev(const struct nf_hook_state *state)
 {
 	struct nft_pktinfo pkt;
 
-	nft_set_pktinfo(&pkt, skb, state);
+	nft_set_pktinfo(&pkt, state->skb, state);
 
-	switch (skb->protocol) {
+	switch (state->skb->protocol) {
 	case htons(ETH_P_IP):
 		nft_set_pktinfo_ipv4_validate(&pkt);
 		break;
@@ -303,7 +299,7 @@ static unsigned int nft_do_chain_netdev(void *priv, struct sk_buff *skb,
 		break;
 	}
 
-	return nft_do_chain(&pkt, priv);
+	return nft_do_chain(&pkt, state->priv);
 }
 
 static const struct nft_chain_type nft_chain_filter_netdev = {
diff --git a/net/netfilter/nft_chain_nat.c b/net/netfilter/nft_chain_nat.c
index 98e4946100c5..7eff7e499f54 100644
--- a/net/netfilter/nft_chain_nat.c
+++ b/net/netfilter/nft_chain_nat.c
@@ -7,12 +7,11 @@
 #include <net/netfilter/nf_tables_ipv4.h>
 #include <net/netfilter/nf_tables_ipv6.h>
 
-static unsigned int nft_nat_do_chain(void *priv, struct sk_buff *skb,
-				     const struct nf_hook_state *state)
+static unsigned int nft_nat_do_chain(const struct nf_hook_state *state)
 {
 	struct nft_pktinfo pkt;
 
-	nft_set_pktinfo(&pkt, skb, state);
+	nft_set_pktinfo(&pkt, state->skb, state);
 
 	switch (state->pf) {
 #ifdef CONFIG_NF_TABLES_IPV4
@@ -29,7 +28,7 @@ static unsigned int nft_nat_do_chain(void *priv, struct sk_buff *skb,
 		break;
 	}
 
-	return nft_do_chain(&pkt, priv);
+	return nft_do_chain(&pkt, state->priv);
 }
 
 #ifdef CONFIG_NF_TABLES_IPV4
diff --git a/net/netfilter/nft_chain_route.c b/net/netfilter/nft_chain_route.c
index 925db0dce48d..8c9f31a96d6f 100644
--- a/net/netfilter/nft_chain_route.c
+++ b/net/netfilter/nft_chain_route.c
@@ -13,10 +13,10 @@
 #include <net/ip.h>
 
 #ifdef CONFIG_NF_TABLES_IPV4
-static unsigned int nf_route_table_hook4(void *priv,
-					 struct sk_buff *skb,
-					 const struct nf_hook_state *state)
+static unsigned int nf_route_table_hook4(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
+	void *priv = state->priv;
 	const struct iphdr *iph;
 	struct nft_pktinfo pkt;
 	__be32 saddr, daddr;
@@ -62,10 +62,10 @@ static const struct nft_chain_type nft_chain_route_ipv4 = {
 #endif
 
 #ifdef CONFIG_NF_TABLES_IPV6
-static unsigned int nf_route_table_hook6(void *priv,
-					 struct sk_buff *skb,
-					 const struct nf_hook_state *state)
+static unsigned int nf_route_table_hook6(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
+	void *priv = state->priv;
 	struct in6_addr saddr, daddr;
 	struct nft_pktinfo pkt;
 	u32 mark, flowlabel;
@@ -112,17 +112,17 @@ static const struct nft_chain_type nft_chain_route_ipv6 = {
 #endif
 
 #ifdef CONFIG_NF_TABLES_INET
-static unsigned int nf_route_table_inet(void *priv,
-					struct sk_buff *skb,
-					const struct nf_hook_state *state)
+static unsigned int nf_route_table_inet(const struct nf_hook_state *state)
 {
+	struct sk_buff *skb = state->skb;
+	void *priv = state->priv;
 	struct nft_pktinfo pkt;
 
 	switch (state->pf) {
 	case NFPROTO_IPV4:
-		return nf_route_table_hook4(priv, skb, state);
+		return nf_route_table_hook4(state);
 	case NFPROTO_IPV6:
-		return nf_route_table_hook6(priv, skb, state);
+		return nf_route_table_hook6(state);
 	default:
 		nft_set_pktinfo(&pkt, skb, state);
 		break;
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index e7ebd45ca345..688e8dabc037 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5746,22 +5746,11 @@ static unsigned int selinux_ip_forward(struct sk_buff *skb,
 	return NF_ACCEPT;
 }
 
-static unsigned int selinux_ipv4_forward(void *priv,
-					 struct sk_buff *skb,
-					 const struct nf_hook_state *state)
+static unsigned int selinux_hook_forward(const struct nf_hook_state *state)
 {
-	return selinux_ip_forward(skb, state->in, PF_INET);
+	return selinux_ip_forward(state->skb, state->in, state->pf);
 }
 
-#if IS_ENABLED(CONFIG_IPV6)
-static unsigned int selinux_ipv6_forward(void *priv,
-					 struct sk_buff *skb,
-					 const struct nf_hook_state *state)
-{
-	return selinux_ip_forward(skb, state->in, PF_INET6);
-}
-#endif	/* IPV6 */
-
 static unsigned int selinux_ip_output(struct sk_buff *skb,
 				      u16 family)
 {
@@ -5804,21 +5793,10 @@ static unsigned int selinux_ip_output(struct sk_buff *skb,
 	return NF_ACCEPT;
 }
 
-static unsigned int selinux_ipv4_output(void *priv,
-					struct sk_buff *skb,
-					const struct nf_hook_state *state)
-{
-	return selinux_ip_output(skb, PF_INET);
-}
-
-#if IS_ENABLED(CONFIG_IPV6)
-static unsigned int selinux_ipv6_output(void *priv,
-					struct sk_buff *skb,
-					const struct nf_hook_state *state)
+static unsigned int selinux_hook_output(const struct nf_hook_state *state)
 {
-	return selinux_ip_output(skb, PF_INET6);
+	return selinux_ip_output(state->skb, state->pf);
 }
-#endif	/* IPV6 */
 
 static unsigned int selinux_ip_postroute_compat(struct sk_buff *skb,
 						int ifindex,
@@ -5994,22 +5972,10 @@ static unsigned int selinux_ip_postroute(struct sk_buff *skb,
 	return NF_ACCEPT;
 }
 
-static unsigned int selinux_ipv4_postroute(void *priv,
-					   struct sk_buff *skb,
-					   const struct nf_hook_state *state)
-{
-	return selinux_ip_postroute(skb, state->out, PF_INET);
-}
-
-#if IS_ENABLED(CONFIG_IPV6)
-static unsigned int selinux_ipv6_postroute(void *priv,
-					   struct sk_buff *skb,
-					   const struct nf_hook_state *state)
+static unsigned int selinux_hook_postroute(const struct nf_hook_state *state)
 {
-	return selinux_ip_postroute(skb, state->out, PF_INET6);
+	return selinux_ip_postroute(state->skb, state->out, state->pf);
 }
-#endif	/* IPV6 */
-
 #endif	/* CONFIG_NETFILTER */
 
 static int selinux_netlink_send(struct sock *sk, struct sk_buff *skb)
@@ -7470,38 +7436,38 @@ DEFINE_LSM(selinux) = {
 
 static const struct nf_hook_ops selinux_nf_ops[] = {
 	{
-		.hook =		selinux_ipv4_postroute,
+		.hook =		selinux_hook_postroute,
 		.pf =		NFPROTO_IPV4,
 		.hooknum =	NF_INET_POST_ROUTING,
 		.priority =	NF_IP_PRI_SELINUX_LAST,
 	},
 	{
-		.hook =		selinux_ipv4_forward,
+		.hook =		selinux_hook_forward,
 		.pf =		NFPROTO_IPV4,
 		.hooknum =	NF_INET_FORWARD,
 		.priority =	NF_IP_PRI_SELINUX_FIRST,
 	},
 	{
-		.hook =		selinux_ipv4_output,
+		.hook =		selinux_hook_output,
 		.pf =		NFPROTO_IPV4,
 		.hooknum =	NF_INET_LOCAL_OUT,
 		.priority =	NF_IP_PRI_SELINUX_FIRST,
 	},
 #if IS_ENABLED(CONFIG_IPV6)
 	{
-		.hook =		selinux_ipv6_postroute,
+		.hook =		selinux_hook_postroute,
 		.pf =		NFPROTO_IPV6,
 		.hooknum =	NF_INET_POST_ROUTING,
 		.priority =	NF_IP6_PRI_SELINUX_LAST,
 	},
 	{
-		.hook =		selinux_ipv6_forward,
+		.hook =		selinux_hook_forward,
 		.pf =		NFPROTO_IPV6,
 		.hooknum =	NF_INET_FORWARD,
 		.priority =	NF_IP6_PRI_SELINUX_FIRST,
 	},
 	{
-		.hook =		selinux_ipv6_output,
+		.hook =		selinux_hook_output,
 		.pf =		NFPROTO_IPV6,
 		.hooknum =	NF_INET_LOCAL_OUT,
 		.priority =	NF_IP6_PRI_SELINUX_FIRST,
-- 
2.32.0

