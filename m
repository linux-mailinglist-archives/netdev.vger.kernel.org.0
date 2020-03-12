Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCDB182D6A
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 11:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgCLKXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 06:23:55 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:56534 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726845AbgCLKXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 06:23:33 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 12 Mar 2020 12:23:28 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02CANSTe017875;
        Thu, 12 Mar 2020 12:23:28 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next ct-offload v4 06/15] net/sched: act_ct: Support refreshing the flow table entries
Date:   Thu, 12 Mar 2020 12:23:08 +0200
Message-Id: <1584008597-15875-7-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1584008597-15875-1-git-send-email-paulb@mellanox.com>
References: <1584008597-15875-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If driver deleted an FT entry, a FT failed to offload, or registered to the
flow table after flows were already added, we still get packets in
software.

For those packets, while restoring the ct state from the flow table
entry, refresh it's hardware offload.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/netfilter/nf_flow_table.h |  3 +++
 net/netfilter/nf_flow_table_core.c    | 13 +++++++++++++
 net/netfilter/nf_flow_table_ip.c      | 15 ++-------------
 net/sched/act_ct.c                    |  1 +
 4 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index c2d5cdd..6890f1c 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -162,6 +162,9 @@ int flow_offload_route_init(struct flow_offload *flow,
 			    const struct nf_flow_route *route);
 
 int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow);
+void flow_offload_refresh(struct nf_flowtable *flow_table,
+			  struct flow_offload *flow);
+
 struct flow_offload_tuple_rhash *flow_offload_lookup(struct nf_flowtable *flow_table,
 						     struct flow_offload_tuple *tuple);
 void nf_flow_table_cleanup(struct net_device *dev);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 4af0327..9a477bd 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -252,6 +252,19 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 }
 EXPORT_SYMBOL_GPL(flow_offload_add);
 
+void flow_offload_refresh(struct nf_flowtable *flow_table,
+			  struct flow_offload *flow)
+{
+	flow->timeout = nf_flowtable_time_stamp + NF_FLOW_TIMEOUT;
+
+	if (likely(!nf_flowtable_hw_offload(flow_table) ||
+		   !test_and_clear_bit(NF_FLOW_HW_REFRESH, &flow->flags)))
+		return;
+
+	nf_flow_offload_add(flow_table, flow);
+}
+EXPORT_SYMBOL_GPL(flow_offload_refresh);
+
 static inline bool nf_flow_has_expired(const struct flow_offload *flow)
 {
 	return nf_flow_timeout_delta(flow->timeout) <= 0;
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 9e563fd..5272721 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -232,13 +232,6 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 	return NF_STOLEN;
 }
 
-static bool nf_flow_offload_refresh(struct nf_flowtable *flow_table,
-				    struct flow_offload *flow)
-{
-	return nf_flowtable_hw_offload(flow_table) &&
-	       test_and_clear_bit(NF_FLOW_HW_REFRESH, &flow->flags);
-}
-
 unsigned int
 nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 			const struct nf_hook_state *state)
@@ -279,8 +272,7 @@ static bool nf_flow_offload_refresh(struct nf_flowtable *flow_table,
 	if (nf_flow_state_check(flow, ip_hdr(skb)->protocol, skb, thoff))
 		return NF_ACCEPT;
 
-	if (unlikely(nf_flow_offload_refresh(flow_table, flow)))
-		nf_flow_offload_add(flow_table, flow);
+	flow_offload_refresh(flow_table, flow);
 
 	if (nf_flow_offload_dst_check(&rt->dst)) {
 		flow_offload_teardown(flow);
@@ -290,7 +282,6 @@ static bool nf_flow_offload_refresh(struct nf_flowtable *flow_table,
 	if (nf_flow_nat_ip(flow, skb, thoff, dir) < 0)
 		return NF_DROP;
 
-	flow->timeout = nf_flowtable_time_stamp + NF_FLOW_TIMEOUT;
 	iph = ip_hdr(skb);
 	ip_decrease_ttl(iph);
 	skb->tstamp = 0;
@@ -508,8 +499,7 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 				sizeof(*ip6h)))
 		return NF_ACCEPT;
 
-	if (unlikely(nf_flow_offload_refresh(flow_table, flow)))
-		nf_flow_offload_add(flow_table, flow);
+	flow_offload_refresh(flow_table, flow);
 
 	if (nf_flow_offload_dst_check(&rt->dst)) {
 		flow_offload_teardown(flow);
@@ -522,7 +512,6 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 	if (nf_flow_nat_ipv6(flow, skb, dir) < 0)
 		return NF_DROP;
 
-	flow->timeout = nf_flowtable_time_stamp + NF_FLOW_TIMEOUT;
 	ip6h = ipv6_hdr(skb);
 	ip6h->hop_limit--;
 	skb->tstamp = 0;
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 31eef8a..16fc731 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -531,6 +531,7 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 	ctinfo = dir == FLOW_OFFLOAD_DIR_ORIGINAL ? IP_CT_ESTABLISHED :
 						    IP_CT_ESTABLISHED_REPLY;
 
+	flow_offload_refresh(nf_ft, flow);
 	nf_conntrack_get(&ct->ct_general);
 	nf_ct_set(skb, ct, ctinfo);
 
-- 
1.8.3.1

