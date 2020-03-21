Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF2818DFD0
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 12:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgCUL3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 07:29:23 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:47574 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbgCUL3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 07:29:22 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 02CC4410B3;
        Sat, 21 Mar 2020 19:29:19 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, paulb@mellanox.com
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH nf-next 1/3] netfilter: nf_flow_table: add nf_conn_acct for SW flowtable offload
Date:   Sat, 21 Mar 2020 19:29:16 +0800
Message-Id: <1584790158-9752-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584790158-9752-1-git-send-email-wenxu@ucloud.cn>
References: <1584790158-9752-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSk9LS0tLSE9ISElJTE5ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PxQ6Agw*ITg8AhMVORUVIRZR
        MT5PChVVSlVKTkNPTEJLSk5CSktKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhDTko3Bg++
X-HM-Tid: 0a70fcdabeb22086kuqy02cc4410b3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add nf_conn_acct counter for the software flowtable offload

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/net/netfilter/nf_flow_table.h |  4 ++++
 net/netfilter/nf_flow_table_core.c    | 19 +++++++++++++++++++
 net/netfilter/nf_flow_table_ip.c      |  4 ++++
 3 files changed, 27 insertions(+)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index f523ea8..11f9d50 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -180,6 +180,10 @@ struct flow_offload_tuple_rhash *flow_offload_lookup(struct nf_flowtable *flow_t
 
 void flow_offload_teardown(struct flow_offload *flow);
 
+void flow_offload_update_acct(struct flow_offload *flow, unsigned int pkts,
+			      unsigned int bytes,
+			      enum flow_offload_tuple_dir dir);
+
 int nf_flow_snat_port(const struct flow_offload *flow,
 		      struct sk_buff *skb, unsigned int thoff,
 		      u8 protocol, enum flow_offload_tuple_dir dir);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 9a477bd..8667e31 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -13,6 +13,7 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
+#include <net/netfilter/nf_conntrack_acct.h>
 
 static DEFINE_MUTEX(flowtable_lock);
 static LIST_HEAD(flowtables);
@@ -618,6 +619,24 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
 
+void flow_offload_update_acct(struct flow_offload *flow, unsigned int pkts,
+			      unsigned int bytes,
+			      enum flow_offload_tuple_dir dir)
+{
+	struct nf_conn_acct *acct;
+
+	if (flow && flow->ct) {
+		acct = nf_conn_acct_find(flow->ct);
+		if (acct) {
+			struct nf_conn_counter *counter = acct->counter;
+
+			atomic64_add(pkts, &counter[dir].packets);
+			atomic64_add(bytes, &counter[dir].bytes);
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(flow_offload_update_acct);
+
 static int __init nf_flow_table_module_init(void)
 {
 	return nf_flow_table_offload_init();
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 5272721..53680a8 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -279,6 +279,8 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 		return NF_ACCEPT;
 	}
 
+	flow_offload_update_acct(flow, 1, skb->len, dir);
+
 	if (nf_flow_nat_ip(flow, skb, thoff, dir) < 0)
 		return NF_DROP;
 
@@ -506,6 +508,8 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 		return NF_ACCEPT;
 	}
 
+	flow_offload_update_acct(flow, 1, skb->len, dir);
+
 	if (skb_try_make_writable(skb, sizeof(*ip6h)))
 		return NF_DROP;
 
-- 
1.8.3.1

