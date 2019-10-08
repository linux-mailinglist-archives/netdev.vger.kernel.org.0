Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 983F1CF839
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730734AbfJHLbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:31:10 -0400
Received: from aer-iport-3.cisco.com ([173.38.203.53]:5453 "EHLO
        aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730723AbfJHLbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:31:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=12192; q=dns/txt;
  s=iport; t=1570534267; x=1571743867;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=yBlmqX0U/W49nENDKJQ1G45Ndto/gr9eXp/qxCIyE+I=;
  b=LSLouvibjrj+x8B+67hIf9ghm1m50pd9LjlSvtkEMIQLMIfZpxuDbWZY
   A/gJZrntZwIPgtRMgLfbqKRwP8FDr3bCNt2hHgfkt6TYadRjTlBUnWoJx
   vUbfWn1Rv156JqC31FNETrog18VSW7FoAxhk9KNIbjmpxEmzlWaTlkwoD
   c=;
X-IronPort-AV: E=Sophos;i="5.67,270,1566864000"; 
   d="scan'208";a="17686707"
Received: from aer-iport-nat.cisco.com (HELO aer-core-2.cisco.com) ([173.38.203.22])
  by aer-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 08 Oct 2019 11:23:58 +0000
Received: from rdbuild16.cisco.com.rd.cisco.com (rdbuild16.cisco.com [10.47.15.16])
        by aer-core-2.cisco.com (8.15.2/8.15.2) with ESMTP id x98BNe56031991;
        Tue, 8 Oct 2019 11:23:58 GMT
From:   Georg Kohmann <geokohma@cisco.com>
To:     netdev@vger.kernel.org
Cc:     Georg Kohmann <geokohma@cisco.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.4 stable 08/10] ipv6: remove dependency of nf_defrag_ipv6 on ipv6 module
Date:   Tue,  8 Oct 2019 13:23:07 +0200
Message-Id: <20191008112309.9571-9-geokohma@cisco.com>
X-Mailer: git-send-email 2.10.2
In-Reply-To: <20191008112309.9571-1-geokohma@cisco.com>
References: <20191008112309.9571-1-geokohma@cisco.com>
X-Outbound-SMTP-Client: 10.47.15.16, rdbuild16.cisco.com
X-Outbound-Node: aer-core-2.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 70b095c84326 ("ipv6: remove dependency of nf_defrag_ipv6 on ipv6
module")
From: Florian Westphal <fw@strlen.de>

IPV6=m
DEFRAG_IPV6=m
CONNTRACK=y yields:

net/netfilter/nf_conntrack_proto.o: In function `nf_ct_netns_do_get':
net/netfilter/nf_conntrack_proto.c:802: undefined reference to `nf_defrag_ipv6_enable'
net/netfilter/nf_conntrack_proto.o:(.rodata+0x640): undefined reference to `nf_conntrack_l4proto_icmpv6'

Setting DEFRAG_IPV6=y causes undefined references to ip6_rhash_params
ip6_frag_init and ip6_expire_frag_queue so it would be needed to force
IPV6=y too.

This patch gets rid of the 'followup linker error' by removing
the dependency of ipv6.ko symbols from netfilter ipv6 defrag.

Shared code is placed into a header, then used from both.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ipv6.h                        |  29 ---------
 include/net/ipv6_frag.h                   | 104 ++++++++++++++++++++++++++++++
 net/ieee802154/6lowpan/reassembly.c       |   2 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c   |  17 +++--
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c |   3 +-
 net/ipv6/reassembly.c                     |  92 ++------------------------
 net/openvswitch/conntrack.c               |   1 +
 7 files changed, 126 insertions(+), 122 deletions(-)
 create mode 100644 include/net/ipv6_frag.h

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index c07cf95..bd7c2ab 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -486,35 +486,6 @@ static inline bool ipv6_prefix_equal(const struct in6_addr *addr1,
 }
 #endif
 
-struct inet_frag_queue;
-
-enum ip6_defrag_users {
-	IP6_DEFRAG_LOCAL_DELIVER,
-	IP6_DEFRAG_CONNTRACK_IN,
-	__IP6_DEFRAG_CONNTRACK_IN	= IP6_DEFRAG_CONNTRACK_IN + USHRT_MAX,
-	IP6_DEFRAG_CONNTRACK_OUT,
-	__IP6_DEFRAG_CONNTRACK_OUT	= IP6_DEFRAG_CONNTRACK_OUT + USHRT_MAX,
-	IP6_DEFRAG_CONNTRACK_BRIDGE_IN,
-	__IP6_DEFRAG_CONNTRACK_BRIDGE_IN = IP6_DEFRAG_CONNTRACK_BRIDGE_IN + USHRT_MAX,
-};
-
-void ip6_frag_init(struct inet_frag_queue *q, const void *a);
-extern const struct rhashtable_params ip6_rhash_params;
-
-/*
- *	Equivalent of ipv4 struct ip
- */
-struct frag_queue {
-	struct inet_frag_queue	q;
-
-	int			iif;
-	unsigned int		csum;
-	__u16			nhoffset;
-	u8			ecn;
-};
-
-void ip6_expire_frag_queue(struct net *net, struct frag_queue *fq);
-
 static inline bool ipv6_addr_any(const struct in6_addr *a)
 {
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
diff --git a/include/net/ipv6_frag.h b/include/net/ipv6_frag.h
new file mode 100644
index 00000000..749e1dc
--- /dev/null
+++ b/include/net/ipv6_frag.h
@@ -0,0 +1,104 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _IPV6_FRAG_H
+#define _IPV6_FRAG_H
+#include <linux/kernel.h>
+#include <net/addrconf.h>
+#include <net/ipv6.h>
+#include <net/inet_frag.h>
+
+enum ip6_defrag_users {
+	IP6_DEFRAG_LOCAL_DELIVER,
+	IP6_DEFRAG_CONNTRACK_IN,
+	__IP6_DEFRAG_CONNTRACK_IN	= IP6_DEFRAG_CONNTRACK_IN + USHRT_MAX,
+	IP6_DEFRAG_CONNTRACK_OUT,
+	__IP6_DEFRAG_CONNTRACK_OUT	= IP6_DEFRAG_CONNTRACK_OUT + USHRT_MAX,
+	IP6_DEFRAG_CONNTRACK_BRIDGE_IN,
+	__IP6_DEFRAG_CONNTRACK_BRIDGE_IN = IP6_DEFRAG_CONNTRACK_BRIDGE_IN + USHRT_MAX,
+};
+
+/*
+ *	Equivalent of ipv4 struct ip
+ */
+struct frag_queue {
+	struct inet_frag_queue	q;
+
+	int			iif;
+	__u16			nhoffset;
+	u8			ecn;
+};
+
+#if IS_ENABLED(CONFIG_IPV6)
+static inline void ip6frag_init(struct inet_frag_queue *q, const void *a)
+{
+	struct frag_queue *fq = container_of(q, struct frag_queue, q);
+	const struct frag_v6_compare_key *key = a;
+
+	q->key.v6 = *key;
+	fq->ecn = 0;
+}
+
+static inline u32 ip6frag_key_hashfn(const void *data, u32 len, u32 seed)
+{
+	return jhash2(data,
+		      sizeof(struct frag_v6_compare_key) / sizeof(u32), seed);
+}
+
+static inline u32 ip6frag_obj_hashfn(const void *data, u32 len, u32 seed)
+{
+	const struct inet_frag_queue *fq = data;
+
+	return jhash2((const u32 *)&fq->key.v6,
+		      sizeof(struct frag_v6_compare_key) / sizeof(u32), seed);
+}
+
+static inline int
+ip6frag_obj_cmpfn(struct rhashtable_compare_arg *arg, const void *ptr)
+{
+	const struct frag_v6_compare_key *key = arg->key;
+	const struct inet_frag_queue *fq = ptr;
+
+	return !!memcmp(&fq->key, key, sizeof(*key));
+}
+
+static inline void
+ip6frag_expire_frag_queue(struct net *net, struct frag_queue *fq)
+{
+	struct net_device *dev = NULL;
+	struct sk_buff *head;
+
+	rcu_read_lock();
+	spin_lock(&fq->q.lock);
+
+	if (fq->q.flags & INET_FRAG_COMPLETE)
+		goto out;
+
+	inet_frag_kill(&fq->q);
+
+	dev = dev_get_by_index_rcu(net, fq->iif);
+	if (!dev)
+		goto out;
+
+	IP6_INC_STATS_BH(net, __in6_dev_get(dev), IPSTATS_MIB_REASMFAILS);
+	IP6_INC_STATS_BH(net, __in6_dev_get(dev), IPSTATS_MIB_REASMTIMEOUT);
+
+	/* Don't send error if the first segment did not arrive. */
+	head = fq->q.fragments;
+	if (!(fq->q.flags & INET_FRAG_FIRST_IN) || !head)
+		goto out;
+
+	head->dev = dev;
+	skb_get(head);
+	spin_unlock(&fq->q.lock);
+
+	icmpv6_send(head, ICMPV6_TIME_EXCEED, ICMPV6_EXC_FRAGTIME, 0);
+	kfree_skb(head);
+	goto out_rcu_unlock;
+
+out:
+	spin_unlock(&fq->q.lock);
+out_rcu_unlock:
+	rcu_read_unlock();
+	inet_frag_put(&fq->q);
+}
+#endif
+#endif
diff --git a/net/ieee802154/6lowpan/reassembly.c b/net/ieee802154/6lowpan/reassembly.c
index 6183730..a67ef73 100644
--- a/net/ieee802154/6lowpan/reassembly.c
+++ b/net/ieee802154/6lowpan/reassembly.c
@@ -25,7 +25,7 @@
 
 #include <net/ieee802154_netdev.h>
 #include <net/6lowpan.h>
-#include <net/ipv6.h>
+#include <net/ipv6_frag.h>
 #include <net/inet_frag.h>
 
 #include "6lowpan_i.h"
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 5640e041..49fd3c6 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -33,9 +33,8 @@
 
 #include <net/sock.h>
 #include <net/snmp.h>
-#include <net/inet_frag.h>
+#include <net/ipv6_frag.h>
 
-#include <net/ipv6.h>
 #include <net/protocol.h>
 #include <net/transp_v6.h>
 #include <net/rawv6.h>
@@ -158,7 +157,7 @@ static void nf_ct_frag6_expire(unsigned long data)
 	fq = container_of((struct inet_frag_queue *)data, struct frag_queue, q);
 	net = container_of(fq->q.net, struct net, nf_frag.frags);
 
-	ip6_expire_frag_queue(net, fq);
+	ip6frag_expire_frag_queue(net, fq);
 }
 
 /* Creation primitives. */
@@ -630,16 +629,24 @@ static struct pernet_operations nf_ct_net_ops = {
 	.exit = nf_ct_net_exit,
 };
 
+static const struct rhashtable_params nfct_rhash_params = {
+	.head_offset		= offsetof(struct inet_frag_queue, node),
+	.hashfn			= ip6frag_key_hashfn,
+	.obj_hashfn		= ip6frag_obj_hashfn,
+	.obj_cmpfn		= ip6frag_obj_cmpfn,
+	.automatic_shrinking	= true,
+};
+
 int nf_ct_frag6_init(void)
 {
 	int ret = 0;
 
-	nf_frags.constructor = ip6_frag_init;
+	nf_frags.constructor = ip6frag_init;
 	nf_frags.destructor = NULL;
 	nf_frags.qsize = sizeof(struct frag_queue);
 	nf_frags.frag_expire = nf_ct_frag6_expire;
 	nf_frags.frags_cache_name = nf_frags_cache_name;
-	nf_frags.rhash_params = ip6_rhash_params;
+	nf_frags.rhash_params = nfct_rhash_params;
 	ret = inet_frags_init(&nf_frags);
 	if (ret)
 		goto out;
diff --git a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
index f7aab5a..169bed9 100644
--- a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
+++ b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
@@ -14,8 +14,7 @@
 #include <linux/skbuff.h>
 #include <linux/icmp.h>
 #include <linux/sysctl.h>
-#include <net/ipv6.h>
-#include <net/inet_frag.h>
+#include <net/ipv6_frag.h>
 
 #include <linux/netfilter_ipv6.h>
 #include <linux/netfilter_bridge.h>
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index c708fc5..ec90b84 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -57,7 +57,7 @@
 #include <net/rawv6.h>
 #include <net/ndisc.h>
 #include <net/addrconf.h>
-#include <net/inet_frag.h>
+#include <net/ipv6_frag.h>
 #include <net/inet_ecn.h>
 
 static const char ip6_frag_cache_name[] = "ip6-frags";
@@ -79,61 +79,6 @@ static struct inet_frags ip6_frags;
 static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *prev,
 			  struct net_device *dev);
 
-void ip6_frag_init(struct inet_frag_queue *q, const void *a)
-{
-	struct frag_queue *fq = container_of(q, struct frag_queue, q);
-	const struct frag_v6_compare_key *key = a;
-
-	q->key.v6 = *key;
-	fq->ecn = 0;
-}
-EXPORT_SYMBOL(ip6_frag_init);
-
-void ip6_expire_frag_queue(struct net *net, struct frag_queue *fq)
-{
-	struct net_device *dev = NULL;
-	struct sk_buff *head;
-
-	rcu_read_lock();
-	spin_lock(&fq->q.lock);
-
-	if (fq->q.flags & INET_FRAG_COMPLETE)
-		goto out;
-
-	inet_frag_kill(&fq->q);
-
-	dev = dev_get_by_index_rcu(net, fq->iif);
-	if (!dev)
-		goto out;
-
-	IP6_INC_STATS_BH(net, __in6_dev_get(dev), IPSTATS_MIB_REASMFAILS);
-	IP6_INC_STATS_BH(net, __in6_dev_get(dev), IPSTATS_MIB_REASMTIMEOUT);
-
-	/* Don't send error if the first segment did not arrive. */
-	head = fq->q.fragments;
-	if (!(fq->q.flags & INET_FRAG_FIRST_IN) || !head)
-		goto out;
-
-	/* But use as source device on which LAST ARRIVED
-	 * segment was received. And do not use fq->dev
-	 * pointer directly, device might already disappeared.
-	 */
-	head->dev = dev;
-	skb_get(head);
-	spin_unlock(&fq->q.lock);
-
-	icmpv6_send(head, ICMPV6_TIME_EXCEED, ICMPV6_EXC_FRAGTIME, 0);
-	kfree_skb(head);
-	goto out_rcu_unlock;
-
-out:
-	spin_unlock(&fq->q.lock);
-out_rcu_unlock:
-	rcu_read_unlock();
-	inet_frag_put(&fq->q);
-}
-EXPORT_SYMBOL(ip6_expire_frag_queue);
-
 static void ip6_frag_expire(unsigned long data)
 {
 	struct frag_queue *fq;
@@ -142,7 +87,7 @@ static void ip6_frag_expire(unsigned long data)
 	fq = container_of((struct inet_frag_queue *)data, struct frag_queue, q);
 	net = container_of(fq->q.net, struct net, ipv6.frags);
 
-	ip6_expire_frag_queue(net, fq);
+	ip6frag_expire_frag_queue(net, fq);
 }
 
 static struct frag_queue *
@@ -705,42 +650,19 @@ static struct pernet_operations ip6_frags_ops = {
 	.exit = ipv6_frags_exit_net,
 };
 
-static u32 ip6_key_hashfn(const void *data, u32 len, u32 seed)
-{
-	return jhash2(data,
-		      sizeof(struct frag_v6_compare_key) / sizeof(u32), seed);
-}
-
-static u32 ip6_obj_hashfn(const void *data, u32 len, u32 seed)
-{
-	const struct inet_frag_queue *fq = data;
-
-	return jhash2((const u32 *)&fq->key.v6,
-		      sizeof(struct frag_v6_compare_key) / sizeof(u32), seed);
-}
-
-static int ip6_obj_cmpfn(struct rhashtable_compare_arg *arg, const void *ptr)
-{
-	const struct frag_v6_compare_key *key = arg->key;
-	const struct inet_frag_queue *fq = ptr;
-
-	return !!memcmp(&fq->key, key, sizeof(*key));
-}
-
-const struct rhashtable_params ip6_rhash_params = {
+static const struct rhashtable_params ip6_rhash_params = {
 	.head_offset		= offsetof(struct inet_frag_queue, node),
-	.hashfn			= ip6_key_hashfn,
-	.obj_hashfn		= ip6_obj_hashfn,
-	.obj_cmpfn		= ip6_obj_cmpfn,
+	.hashfn			= ip6frag_key_hashfn,
+	.obj_hashfn		= ip6frag_obj_hashfn,
+	.obj_cmpfn		= ip6frag_obj_cmpfn,
 	.automatic_shrinking	= true,
 };
-EXPORT_SYMBOL(ip6_rhash_params);
 
 int __init ipv6_frag_init(void)
 {
 	int ret;
 
-	ip6_frags.constructor = ip6_frag_init;
+	ip6_frags.constructor = ip6frag_init;
 	ip6_frags.destructor = NULL;
 	ip6_frags.qsize = sizeof(struct frag_queue);
 	ip6_frags.frag_expire = ip6_frag_expire;
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 3ed0331..9b74e72 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -19,6 +19,7 @@
 #include <net/netfilter/nf_conntrack_labels.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
+#include <net/ipv6_frag.h>
 
 #include "datapath.h"
 #include "conntrack.h"
-- 
2.10.2

