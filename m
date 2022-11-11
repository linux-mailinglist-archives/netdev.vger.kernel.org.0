Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A85AE625224
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 05:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbiKKEFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 23:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbiKKEE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 23:04:28 -0500
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C981B6B204
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 20:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1668139400; x=1699675400;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bK76DXPybIITKN0hIeCzoDste60ipqWpTYTIj7DvW4s=;
  b=Oiy9e6Ai3Ybk8lRon2jjoY9FMOr6KBaYeKQ7J7UsuBqJozZGIePnSdL1
   eEsYWHM22kNkbxNX5I+Cb1K59D7JGQIUeAqeWuToN1qvva0n/zMZb1bdV
   6YIPdGee4zFkW9779nshLB3Ivf5hlGpxze6Gyku4Nj4u7RwXNB2WmoVzq
   4=;
X-IronPort-AV: E=Sophos;i="5.96,155,1665446400"; 
   d="scan'208";a="261983657"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-3e1fab07.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2022 04:03:19 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-m6i4x-3e1fab07.us-east-1.amazon.com (Postfix) with ESMTPS id A3DCB82C08;
        Fri, 11 Nov 2022 04:03:17 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 11 Nov 2022 04:03:16 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.178) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Fri, 11 Nov 2022 04:03:14 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net-next 6/6] udp: Introduce optional per-netns hash table.
Date:   Thu, 10 Nov 2022 20:00:34 -0800
Message-ID: <20221111040034.29736-7-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221111040034.29736-1-kuniyu@amazon.com>
References: <20221111040034.29736-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.178]
X-ClientProxiedBy: EX13D22UWB004.ant.amazon.com (10.43.161.165) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The maximum hash table size is 64K due to the nature of the protocol. [0]
It's smaller than TCP, and fewer sockets can cause a performance drop.

On an EC2 c5.24xlarge instance (192 GiB memory), after running iperf3 in
different netns, creating 32Mi sockets without data transfer in the root
netns causes regression for the iperf3's connection.

  uhash_entries		sockets		length		Gbps
	    64K		      1		     1		5.69
			    1Mi		    16		5.27
			    2Mi		    32		4.90
			    4Mi		    64		4.09
			    8Mi		   128		2.96
			   16Mi		   256		2.06
			   32Mi		   512		1.12

The per-netns hash table breaks the lengthy lists into shorter ones.  It is
useful on a multi-tenant system with thousands of netns.  With smaller hash
tables, we can look up sockets faster, isolate noisy neighbours, and reduce
lock contention.

The max size of the per-netns table is 64K as well.  This is because the
possible hash range by udp_hashfn() always fits in 64K within the same
netns and we cannot make full use of the whole buckets larger than 64K.

  /* 0 < num < 64K  ->  X < hash < X + 64K */
  (num + net_hash_mix(net)) & mask;

The sysctl usage is the same with TCP:

  $ dmesg | cut -d ' ' -f 6- | grep "UDP hash"
  UDP hash table entries: 65536 (order: 9, 2097152 bytes, vmalloc)

  # sysctl net.ipv4.udp_hash_entries
  net.ipv4.udp_hash_entries = 65536  # can be changed by uhash_entries

  # sysctl net.ipv4.udp_child_hash_entries
  net.ipv4.udp_child_hash_entries = 0  # disabled by default

  # ip netns add test1
  # ip netns exec test1 sysctl net.ipv4.udp_hash_entries
  net.ipv4.udp_hash_entries = -65536  # share the global table

  # sysctl -w net.ipv4.udp_child_hash_entries=100
  net.ipv4.udp_child_hash_entries = 100

  # ip netns add test2
  # ip netns exec test2 sysctl net.ipv4.udp_hash_entries
  net.ipv4.udp_hash_entries = 128  # own a per-netns table with 2^n buckets

We could optimise the hash table lookup/iteration further by removing
the netns comparison for the per-netns one in the future.  Also, we
could optimise the sparse udp_hslot layout by putting it in udp_table.

[0]: https://lore.kernel.org/netdev/4ACC2815.7010101@gmail.com/

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 Documentation/networking/ip-sysctl.rst |  27 +++++++
 include/linux/udp.h                    |   1 +
 include/net/netns/ipv4.h               |   2 +
 net/ipv4/sysctl_net_ipv4.c             |  38 ++++++++++
 net/ipv4/udp.c                         | 100 +++++++++++++++++++++++--
 5 files changed, 163 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 815efc89ad73..ea788ef4def0 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1177,6 +1177,33 @@ udp_rmem_min - INTEGER
 udp_wmem_min - INTEGER
 	UDP does not have tx memory accounting and this tunable has no effect.
 
+udp_hash_entries - INTEGER
+	Show the number of hash buckets for UDP sockets in the current
+	networking namespace.
+
+	A negative value means the networking namespace does not own its
+	hash buckets and shares the initial networking namespace's one.
+
+udp_child_ehash_entries - INTEGER
+	Control the number of hash buckets for UDP sockets in the child
+	networking namespace, which must be set before clone() or unshare().
+
+	If the value is not 0, the kernel uses a value rounded up to 2^n
+	as the actual hash bucket size.  0 is a special value, meaning
+	the child networking namespace will share the initial networking
+	namespace's hash buckets.
+
+	Note that the child will use the global one in case the kernel
+	fails to allocate enough memory.  In addition, the global hash
+	buckets are spread over available NUMA nodes, but the allocation
+	of the child hash table depends on the current process's NUMA
+	policy, which could result in performance differences.
+
+	Possible values: 0, 2^n (n: 0 - 16 (64K))
+
+	Default: 0
+
+
 RAW variables
 =============
 
diff --git a/include/linux/udp.h b/include/linux/udp.h
index 779a7c065a32..18c8c9b7e39a 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -25,6 +25,7 @@ static inline struct udphdr *udp_hdr(const struct sk_buff *skb)
 
 #define UDP_MAX_PORT_LOG		16
 #define UDP_HTABLE_SIZE_MIN		(CONFIG_BASE_SMALL ? 128 : 256)
+#define UDP_HTABLE_SIZE_MAX		(1 << UDP_MAX_PORT_LOG)
 
 static inline u32 udp_hashfn(const struct net *net, u32 num, u32 mask)
 {
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index e4cc4d3cacc4..db762e35aca9 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -208,6 +208,8 @@ struct netns_ipv4 {
 
 	atomic_t dev_addr_genid;
 
+	unsigned int sysctl_udp_child_hash_entries;
+
 #ifdef CONFIG_SYSCTL
 	unsigned long *sysctl_local_reserved_ports;
 	int sysctl_ip_prot_sock;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 0af28cedd071..34a601b9e57d 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -40,6 +40,7 @@ static int one_day_secs = 24 * 3600;
 static u32 fib_multipath_hash_fields_all_mask __maybe_unused =
 	FIB_MULTIPATH_HASH_FIELD_ALL_MASK;
 static unsigned int tcp_child_ehash_entries_max = 16 * 1024 * 1024;
+static unsigned int udp_child_hash_entries_max = UDP_HTABLE_SIZE_MAX;
 static int tcp_plb_max_rounds = 31;
 static int tcp_plb_max_cong_thresh = 256;
 
@@ -408,6 +409,28 @@ static int proc_tcp_ehash_entries(struct ctl_table *table, int write,
 	return proc_dointvec(&tbl, write, buffer, lenp, ppos);
 }
 
+static int proc_udp_hash_entries(struct ctl_table *table, int write,
+				 void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct net *net = container_of(table->data, struct net,
+				       ipv4.sysctl_udp_child_hash_entries);
+	int udp_hash_entries;
+	struct ctl_table tbl;
+
+	udp_hash_entries = net->ipv4.udp_table->mask + 1;
+
+	/* A negative number indicates that the child netns
+	 * shares the global udp_table.
+	 */
+	if (!net_eq(net, &init_net) && net->ipv4.udp_table == &udp_table)
+		udp_hash_entries *= -1;
+
+	tbl.data = &udp_hash_entries;
+	tbl.maxlen = sizeof(int);
+
+	return proc_dointvec(&tbl, write, buffer, lenp, ppos);
+}
+
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
 static int proc_fib_multipath_hash_policy(struct ctl_table *table, int write,
 					  void *buffer, size_t *lenp,
@@ -1361,6 +1384,21 @@ static struct ctl_table ipv4_net_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &tcp_child_ehash_entries_max,
 	},
+	{
+		.procname	= "udp_hash_entries",
+		.data		= &init_net.ipv4.sysctl_udp_child_hash_entries,
+		.mode		= 0444,
+		.proc_handler	= proc_udp_hash_entries,
+	},
+	{
+		.procname	= "udp_child_hash_entries",
+		.data		= &init_net.ipv4.sysctl_udp_child_hash_entries,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_douintvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &udp_child_hash_entries_max,
+	},
 	{
 		.procname	= "udp_rmem_min",
 		.data		= &init_net.ipv4.sysctl_udp_rmem_min,
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 42d7b84a5f16..c76a4d7ee74e 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -3276,7 +3276,7 @@ void __init udp_table_init(struct udp_table *table, const char *name)
 					      &table->log,
 					      &table->mask,
 					      UDP_HTABLE_SIZE_MIN,
-					      64 * 1024);
+					      UDP_HTABLE_SIZE_MAX);
 
 	table->hash2 = table->hash + (table->mask + 1);
 	for (i = 0; i <= table->mask; i++) {
@@ -3308,22 +3308,112 @@ u32 udp_flow_hashrnd(void)
 }
 EXPORT_SYMBOL(udp_flow_hashrnd);
 
-static int __net_init udp_sysctl_init(struct net *net)
+static void __net_init udp_sysctl_init(struct net *net)
 {
-	net->ipv4.udp_table = &udp_table;
-
 	net->ipv4.sysctl_udp_rmem_min = PAGE_SIZE;
 	net->ipv4.sysctl_udp_wmem_min = PAGE_SIZE;
 
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	net->ipv4.sysctl_udp_l3mdev_accept = 0;
 #endif
+}
+
+static struct udp_table __net_init *udp_pernet_table_alloc(unsigned int hash_entries)
+{
+	unsigned long hash_size, bitmap_size;
+	struct udp_table *udptable;
+	int i;
+
+	udptable = kmalloc(sizeof(*udptable), GFP_KERNEL);
+	if (!udptable)
+		goto out;
+
+	udptable->log = ilog2(hash_entries);
+	udptable->mask = hash_entries - 1;
+
+	hash_size = L1_CACHE_ALIGN(hash_entries * 2 * sizeof(struct udp_hslot));
+	bitmap_size = hash_entries *
+		BITS_TO_LONGS(udp_bitmap_size(udptable)) * sizeof(unsigned long);
+
+	udptable->hash = vmalloc_huge(hash_size + bitmap_size, GFP_KERNEL_ACCOUNT);
+	if (!udptable->hash)
+		goto free_table;
+
+	udptable->hash2 = udptable->hash + hash_entries;
+	udptable->bitmap = (void *)udptable->hash + hash_size;
+
+	for (i = 0; i < hash_entries; i++) {
+		INIT_HLIST_HEAD(&udptable->hash[i].head);
+		udptable->hash[i].count = 0;
+		spin_lock_init(&udptable->hash[i].lock);
+
+		INIT_HLIST_HEAD(&udptable->hash2[i].head);
+		udptable->hash2[i].count = 0;
+		spin_lock_init(&udptable->hash2[i].lock);
+	}
+
+	return udptable;
+
+free_table:
+	kfree(udptable);
+out:
+	return NULL;
+}
+
+static void __net_exit udp_pernet_table_free(struct net *net)
+{
+	struct udp_table *udptable = net->ipv4.udp_table;
+
+	if (udptable == &udp_table)
+		return;
+
+	kvfree(udptable->hash);
+	kfree(udptable);
+}
+
+static void __net_init udp_set_table(struct net *net)
+{
+	struct udp_table *udptable;
+	unsigned int hash_entries;
+	struct net *old_net;
+
+	if (net_eq(net, &init_net))
+		goto fallback;
+
+	old_net = current->nsproxy->net_ns;
+	hash_entries = READ_ONCE(old_net->ipv4.sysctl_udp_child_hash_entries);
+	if (!hash_entries)
+		goto fallback;
+
+	hash_entries = roundup_pow_of_two(hash_entries);
+	udptable = udp_pernet_table_alloc(hash_entries);
+	if (udptable) {
+		net->ipv4.udp_table = udptable;
+	} else {
+		pr_warn("Failed to allocate UDP hash table (entries: %u) "
+			"for a netns, fallback to the global one\n",
+			hash_entries);
+fallback:
+		net->ipv4.udp_table = &udp_table;
+	}
+}
+
+static int __net_init udp_pernet_init(struct net *net)
+{
+	udp_sysctl_init(net);
+	udp_set_table(net);
 
 	return 0;
 }
 
+static void __net_exit udp_pernet_exit(struct net *net)
+{
+	udp_pernet_table_free(net);
+}
+
 static struct pernet_operations __net_initdata udp_sysctl_ops = {
-	.init	= udp_sysctl_init,
+	.init	= udp_pernet_init,
+	.exit	= udp_pernet_exit,
 };
 
 #if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
-- 
2.30.2

