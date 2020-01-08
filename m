Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24DCA134FE3
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 00:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbgAHXR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 18:17:29 -0500
Received: from correo.us.es ([193.147.175.20]:43218 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727159AbgAHXR0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 18:17:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 37D1EFF9B2
        for <netdev@vger.kernel.org>; Thu,  9 Jan 2020 00:17:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2DDF0DA712
        for <netdev@vger.kernel.org>; Thu,  9 Jan 2020 00:17:24 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2D50DDA714; Thu,  9 Jan 2020 00:17:24 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 07528DA712;
        Thu,  9 Jan 2020 00:17:22 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 09 Jan 2020 00:17:22 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CF3F3426CCB9;
        Thu,  9 Jan 2020 00:17:21 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 7/9] netfilter: flowtable: add nf_flowtable_time_stamp
Date:   Thu,  9 Jan 2020 00:17:11 +0100
Message-Id: <20200108231713.100458-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200108231713.100458-1-pablo@netfilter.org>
References: <20200108231713.100458-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds nf_flowtable_time_stamp and updates the existing code to
use it.

This patch is also implicitly fixing up hardware statistic fetching via
nf_flow_offload_stats() where casting to u32 is missing. Use
nf_flow_timeout_delta() to fix this.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: wenxu <wenxu@ucloud.cn>
---
 include/net/netfilter/nf_flow_table.h | 6 ++++++
 net/netfilter/nf_flow_table_core.c    | 7 +------
 net/netfilter/nf_flow_table_ip.c      | 4 ++--
 net/netfilter/nf_flow_table_offload.c | 4 ++--
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index f0897b3c97fb..415b8f49d150 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -106,6 +106,12 @@ struct flow_offload {
 };
 
 #define NF_FLOW_TIMEOUT (30 * HZ)
+#define nf_flowtable_time_stamp	(u32)jiffies
+
+static inline __s32 nf_flow_timeout_delta(unsigned int timeout)
+{
+	return (__s32)(timeout - nf_flowtable_time_stamp);
+}
 
 struct nf_flow_route {
 	struct {
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 9889d52eda82..e33a73cb1f42 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -134,11 +134,6 @@ static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
 #define NF_FLOWTABLE_TCP_PICKUP_TIMEOUT	(120 * HZ)
 #define NF_FLOWTABLE_UDP_PICKUP_TIMEOUT	(30 * HZ)
 
-static inline __s32 nf_flow_timeout_delta(unsigned int timeout)
-{
-	return (__s32)(timeout - (u32)jiffies);
-}
-
 static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
 {
 	const struct nf_conntrack_l4proto *l4proto;
@@ -232,7 +227,7 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 {
 	int err;
 
-	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
+	flow->timeout = nf_flowtable_time_stamp + NF_FLOW_TIMEOUT;
 
 	err = rhashtable_insert_fast(&flow_table->rhashtable,
 				     &flow->tuplehash[0].node,
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index b9e7dd6e60ce..7ea2ddc2aa93 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -280,7 +280,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_nat_ip(flow, skb, thoff, dir) < 0)
 		return NF_DROP;
 
-	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
+	flow->timeout = nf_flowtable_time_stamp + NF_FLOW_TIMEOUT;
 	iph = ip_hdr(skb);
 	ip_decrease_ttl(iph);
 	skb->tstamp = 0;
@@ -509,7 +509,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_nat_ipv6(flow, skb, dir) < 0)
 		return NF_DROP;
 
-	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
+	flow->timeout = nf_flowtable_time_stamp + NF_FLOW_TIMEOUT;
 	ip6h = ipv6_hdr(skb);
 	ip6h->hop_limit--;
 	skb->tstamp = 0;
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 6c162c954c4f..d06969af1085 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -781,9 +781,9 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
 			   struct flow_offload *flow)
 {
 	struct flow_offload_work *offload;
-	s64 delta;
+	__s32 delta;
 
-	delta = flow->timeout - jiffies;
+	delta = nf_flow_timeout_delta(flow->timeout);
 	if ((delta >= (9 * NF_FLOW_TIMEOUT) / 10) ||
 	    flow->flags & FLOW_OFFLOAD_HW_DYING)
 		return;
-- 
2.11.0

