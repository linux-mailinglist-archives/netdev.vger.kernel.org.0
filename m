Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABB71178FC7
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 12:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387847AbgCDLtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 06:49:49 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:43224 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387774AbgCDLtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 06:49:49 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 4 Mar 2020 13:49:43 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 024BnhYk021118;
        Wed, 4 Mar 2020 13:49:43 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net-next 1/2] net/sched: act_ct: Fix ipv6 lookup of offloaded connections
Date:   Wed,  4 Mar 2020 13:49:38 +0200
Message-Id: <1583322579-11558-2-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1583322579-11558-1-git-send-email-paulb@mellanox.com>
References: <1583322579-11558-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When checking the protocol number tcf_ct_flow_table_lookup() handles
the flow as if it's always ipv4, while it can be ipv6.

Instead, refactor the code to fetch the tcp header, if available,
in the relevant family (ipv4/ipv6) filler function, and do the
check on the returned tcp header.

Fixes: 46475bb20f4b ("net/sched: act_ct: Software offload of established flows")
Signed-off-by: Paul Blakey <paulb@mellanox.com>
---
 net/sched/act_ct.c | 60 +++++++++++++++++++++++-------------------------------
 1 file changed, 26 insertions(+), 34 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index a2d5582..f434db7 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -188,7 +188,8 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
 
 static bool
 tcf_ct_flow_table_fill_tuple_ipv4(struct sk_buff *skb,
-				  struct flow_offload_tuple *tuple)
+				  struct flow_offload_tuple *tuple,
+				  struct tcphdr **tcph)
 {
 	struct flow_ports *ports;
 	unsigned int thoff;
@@ -211,11 +212,16 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
 	if (iph->ttl <= 1)
 		return false;
 
-	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
+	if (!pskb_may_pull(skb, iph->protocol == IPPROTO_TCP ?
+			   thoff + sizeof(struct tcphdr) :
+			   thoff + sizeof(*ports)))
 		return false;
 
-	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
+	iph = ip_hdr(skb);
+	if (iph->protocol == IPPROTO_TCP)
+		*tcph = (void *)(skb_network_header(skb) + thoff);
 
+	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
 	tuple->src_v4.s_addr = iph->saddr;
 	tuple->dst_v4.s_addr = iph->daddr;
 	tuple->src_port = ports->source;
@@ -228,7 +234,8 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
 
 static bool
 tcf_ct_flow_table_fill_tuple_ipv6(struct sk_buff *skb,
-				  struct flow_offload_tuple *tuple)
+				  struct flow_offload_tuple *tuple,
+				  struct tcphdr **tcph)
 {
 	struct flow_ports *ports;
 	struct ipv6hdr *ip6h;
@@ -247,11 +254,16 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
 		return false;
 
 	thoff = sizeof(*ip6h);
-	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
+	if (!pskb_may_pull(skb, ip6h->nexthdr == IPPROTO_TCP ?
+			   thoff + sizeof(struct tcphdr) :
+			   thoff + sizeof(*ports)))
 		return false;
 
-	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
+	ip6h = ipv6_hdr(skb);
+	if (ip6h->nexthdr == IPPROTO_TCP)
+		*tcph = (void *)(skb_network_header(skb) + thoff);
 
+	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
 	tuple->src_v6 = ip6h->saddr;
 	tuple->dst_v6 = ip6h->daddr;
 	tuple->src_port = ports->source;
@@ -262,24 +274,6 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
 	return true;
 }
 
-static bool tcf_ct_flow_table_check_tcp(struct flow_offload *flow,
-					struct sk_buff *skb,
-					unsigned int thoff)
-{
-	struct tcphdr *tcph;
-
-	if (!pskb_may_pull(skb, thoff + sizeof(*tcph)))
-		return false;
-
-	tcph = (void *)(skb_network_header(skb) + thoff);
-	if (unlikely(tcph->fin || tcph->rst)) {
-		flow_offload_teardown(flow);
-		return false;
-	}
-
-	return true;
-}
-
 static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 				     struct sk_buff *skb,
 				     u8 family)
@@ -288,10 +282,9 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 	struct flow_offload_tuple_rhash *tuplehash;
 	struct flow_offload_tuple tuple = {};
 	enum ip_conntrack_info ctinfo;
+	struct tcphdr *tcph = NULL;
 	struct flow_offload *flow;
 	struct nf_conn *ct;
-	unsigned int thoff;
-	int ip_proto;
 	u8 dir;
 
 	/* Previously seen or loopback */
@@ -301,11 +294,11 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 
 	switch (family) {
 	case NFPROTO_IPV4:
-		if (!tcf_ct_flow_table_fill_tuple_ipv4(skb, &tuple))
+		if (!tcf_ct_flow_table_fill_tuple_ipv4(skb, &tuple, &tcph))
 			return false;
 		break;
 	case NFPROTO_IPV6:
-		if (!tcf_ct_flow_table_fill_tuple_ipv6(skb, &tuple))
+		if (!tcf_ct_flow_table_fill_tuple_ipv6(skb, &tuple, &tcph))
 			return false;
 		break;
 	default:
@@ -320,15 +313,14 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 	ct = flow->ct;
 
+	if (tcph && (unlikely(tcph->fin || tcph->rst))) {
+		flow_offload_teardown(flow);
+		return false;
+	}
+
 	ctinfo = dir == FLOW_OFFLOAD_DIR_ORIGINAL ? IP_CT_ESTABLISHED :
 						    IP_CT_ESTABLISHED_REPLY;
 
-	thoff = ip_hdr(skb)->ihl * 4;
-	ip_proto = ip_hdr(skb)->protocol;
-	if (ip_proto == IPPROTO_TCP &&
-	    !tcf_ct_flow_table_check_tcp(flow, skb, thoff))
-		return false;
-
 	nf_conntrack_get(&ct->ct_general);
 	nf_ct_set(skb, ct, ctinfo);
 
-- 
1.8.3.1

