Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C45D517766C
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 13:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbgCCMxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 07:53:02 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60841 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728056AbgCCMxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 07:53:01 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 3 Mar 2020 14:52:56 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 023Cqu3u009481;
        Tue, 3 Mar 2020 14:52:56 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next v3 3/3] net/sched: act_ct: Software offload of established flows
Date:   Tue,  3 Mar 2020 14:52:53 +0200
Message-Id: <1583239973-3728-4-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1583239973-3728-1-git-send-email-paulb@mellanox.com>
References: <1583239973-3728-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Offload nf conntrack processing by looking up the 5-tuple in the
zone's flow table.

The nf conntrack module will process the packets until a connection is
in established state. Once in established state, the ct state pointer
(nf_conn) will be restored on the skb from a successful ft lookup.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
Changelog:
  v1->v2:
   Add !skip_add curly braces
   Removed extra setting thoff again
   Check tcp proto outside of tcf_ct_flow_table_check_tcp

 net/sched/act_ct.c | 160 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 158 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 6ad0553..2017f8f 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -186,6 +186,155 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
 	tcf_ct_flow_table_add(ct_ft, ct, tcp);
 }
 
+static bool
+tcf_ct_flow_table_fill_tuple_ipv4(struct sk_buff *skb,
+				  struct flow_offload_tuple *tuple)
+{
+	struct flow_ports *ports;
+	unsigned int thoff;
+	struct iphdr *iph;
+
+	if (!pskb_may_pull(skb, sizeof(*iph)))
+		return false;
+
+	iph = ip_hdr(skb);
+	thoff = iph->ihl * 4;
+
+	if (ip_is_fragment(iph) ||
+	    unlikely(thoff != sizeof(struct iphdr)))
+		return false;
+
+	if (iph->protocol != IPPROTO_TCP &&
+	    iph->protocol != IPPROTO_UDP)
+		return false;
+
+	if (iph->ttl <= 1)
+		return false;
+
+	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
+		return false;
+
+	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
+
+	tuple->src_v4.s_addr = iph->saddr;
+	tuple->dst_v4.s_addr = iph->daddr;
+	tuple->src_port = ports->source;
+	tuple->dst_port = ports->dest;
+	tuple->l3proto = AF_INET;
+	tuple->l4proto = iph->protocol;
+
+	return true;
+}
+
+static bool
+tcf_ct_flow_table_fill_tuple_ipv6(struct sk_buff *skb,
+				  struct flow_offload_tuple *tuple)
+{
+	struct flow_ports *ports;
+	struct ipv6hdr *ip6h;
+	unsigned int thoff;
+
+	if (!pskb_may_pull(skb, sizeof(*ip6h)))
+		return false;
+
+	ip6h = ipv6_hdr(skb);
+
+	if (ip6h->nexthdr != IPPROTO_TCP &&
+	    ip6h->nexthdr != IPPROTO_UDP)
+		return false;
+
+	if (ip6h->hop_limit <= 1)
+		return false;
+
+	thoff = sizeof(*ip6h);
+	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
+		return false;
+
+	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
+
+	tuple->src_v6 = ip6h->saddr;
+	tuple->dst_v6 = ip6h->daddr;
+	tuple->src_port = ports->source;
+	tuple->dst_port = ports->dest;
+	tuple->l3proto = AF_INET6;
+	tuple->l4proto = ip6h->nexthdr;
+
+	return true;
+}
+
+static bool tcf_ct_flow_table_check_tcp(struct flow_offload *flow,
+					struct sk_buff *skb,
+					unsigned int thoff)
+{
+	struct tcphdr *tcph;
+
+	if (!pskb_may_pull(skb, thoff + sizeof(*tcph)))
+		return false;
+
+	tcph = (void *)(skb_network_header(skb) + thoff);
+	if (unlikely(tcph->fin || tcph->rst)) {
+		flow_offload_teardown(flow);
+		return false;
+	}
+
+	return true;
+}
+
+static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
+				     struct sk_buff *skb,
+				     u8 family)
+{
+	struct nf_flowtable *nf_ft = &p->ct_ft->nf_ft;
+	struct flow_offload_tuple_rhash *tuplehash;
+	struct flow_offload_tuple tuple = {};
+	enum ip_conntrack_info ctinfo;
+	struct flow_offload *flow;
+	struct nf_conn *ct;
+	unsigned int thoff;
+	int ip_proto;
+	u8 dir;
+
+	/* Previously seen or loopback */
+	ct = nf_ct_get(skb, &ctinfo);
+	if ((ct && !nf_ct_is_template(ct)) || ctinfo == IP_CT_UNTRACKED)
+		return false;
+
+	switch (family) {
+	case NFPROTO_IPV4:
+		if (!tcf_ct_flow_table_fill_tuple_ipv4(skb, &tuple))
+			return false;
+		break;
+	case NFPROTO_IPV6:
+		if (!tcf_ct_flow_table_fill_tuple_ipv6(skb, &tuple))
+			return false;
+		break;
+	default:
+		return false;
+	}
+
+	tuplehash = flow_offload_lookup(nf_ft, &tuple);
+	if (!tuplehash)
+		return false;
+
+	dir = tuplehash->tuple.dir;
+	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
+	ct = flow->ct;
+
+	ctinfo = dir == FLOW_OFFLOAD_DIR_ORIGINAL ? IP_CT_ESTABLISHED :
+						    IP_CT_ESTABLISHED_REPLY;
+
+	thoff = ip_hdr(skb)->ihl * 4;
+	ip_proto = ip_hdr(skb)->protocol;
+	if (ip_proto == IPPROTO_TCP &&
+	    !tcf_ct_flow_table_check_tcp(flow, skb, thoff))
+		return false;
+
+	nf_conntrack_get(&ct->ct_general);
+	nf_ct_set(skb, ct, ctinfo);
+
+	return true;
+}
+
 static int tcf_ct_flow_tables_init(void)
 {
 	return rhashtable_init(&zones_ht, &zones_params);
@@ -554,6 +703,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	struct nf_hook_state state;
 	int nh_ofs, err, retval;
 	struct tcf_ct_params *p;
+	bool skip_add = false;
 	struct nf_conn *ct;
 	u8 family;
 
@@ -603,6 +753,11 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	 */
 	cached = tcf_ct_skb_nfct_cached(net, skb, p->zone, force);
 	if (!cached) {
+		if (!commit && tcf_ct_flow_table_lookup(p, skb, family)) {
+			skip_add = true;
+			goto do_nat;
+		}
+
 		/* Associate skb with specified zone. */
 		if (tmpl) {
 			ct = nf_ct_get(skb, &ctinfo);
@@ -620,6 +775,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 			goto out_push;
 	}
 
+do_nat:
 	ct = nf_ct_get(skb, &ctinfo);
 	if (!ct)
 		goto out_push;
@@ -637,10 +793,10 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 		 * even if the connection is already confirmed.
 		 */
 		nf_conntrack_confirm(skb);
+	} else if (!skip_add) {
+		tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
 	}
 
-	tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
-
 out_push:
 	skb_push_rcsum(skb, nh_ofs);
 
-- 
1.8.3.1

