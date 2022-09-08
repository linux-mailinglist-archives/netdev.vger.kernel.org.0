Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64CEF5B11ED
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 03:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiIHBMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 21:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbiIHBML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 21:12:11 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5409BC6CCA
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 18:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1662599529; x=1694135529;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Gh1sVpbq0ruSYSyHwQSO4qGCOatl+Psn7Nyz57yOvnU=;
  b=G5Z4m8dIffUzI0o0doBpQaW6cg5YjvZBgAHzzPNaVvsoGA4QmrC3Txa/
   E4/xyMTCQN/bAPKPeBU399Z7s4axr5+/osWMNO98c60BtxFF0cWfJAw5i
   24o1XYkdtbCJe+YtplvrWPBusA4bSf60WSUtfuSZ+DNBLnEKJco+F3z/q
   M=;
X-IronPort-AV: E=Sophos;i="5.93,298,1654560000"; 
   d="scan'208";a="127861754"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-92ba9394.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 01:12:09 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-92ba9394.us-west-2.amazon.com (Postfix) with ESMTPS id 8681F4518E;
        Thu,  8 Sep 2022 01:12:08 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 8 Sep 2022 01:12:07 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.222) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 8 Sep 2022 01:12:05 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v6 net-next 6/6] tcp: Introduce optional per-netns ehash.
Date:   Wed, 7 Sep 2022 18:10:22 -0700
Message-ID: <20220908011022.45342-7-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220908011022.45342-1-kuniyu@amazon.com>
References: <20220908011022.45342-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.222]
X-ClientProxiedBy: EX13D05UWC002.ant.amazon.com (10.43.162.92) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The more sockets we have in the hash table, the longer we spend looking
up the socket.  While running a number of small workloads on the same
host, they penalise each other and cause performance degradation.

The root cause might be a single workload that consumes much more
resources than the others.  It often happens on a cloud service where
different workloads share the same computing resource.

On EC2 c5.24xlarge instance (196 GiB memory and 524288 (1Mi / 2) ehash
entries), after running iperf3 in different netns, creating 24Mi sockets
without data transfer in the root netns causes about 10% performance
regression for the iperf3's connection.

 thash_entries		sockets		length		Gbps
	524288		      1		     1		50.7
			   24Mi		    48		45.1

It is basically related to the length of the list of each hash bucket.
For testing purposes to see how performance drops along the length,
I set 131072 (1Mi / 8) to thash_entries, and here's the result.

 thash_entries		sockets		length		Gbps
        131072		      1		     1		50.7
			    1Mi		     8		49.9
			    2Mi		    16		48.9
			    4Mi		    32		47.3
			    8Mi		    64		44.6
			   16Mi		   128		40.6
			   24Mi		   192		36.3
			   32Mi		   256		32.5
			   40Mi		   320		27.0
			   48Mi		   384		25.0

To resolve the socket lookup degradation, we introduce an optional
per-netns hash table for TCP, but it's just ehash, and we still share
the global bhash, bhash2 and lhash2.

With a smaller ehash, we can look up non-listener sockets faster and
isolate such noisy neighbours.  In addition, we can reduce lock contention.

We can control the ehash size by a new sysctl knob.  However, depending
on workloads, it will require very sensitive tuning, so we disable the
feature by default (net.ipv4.tcp_child_ehash_entries == 0).  Moreover,
we can fall back to using the global ehash in case we fail to allocate
enough memory for a new ehash.  The maximum size is 16Mi, which is large
enough that even if we have 48Mi sockets, the average list length is 3,
and regression would be less than 1%.

We can check the current ehash size by another read-only sysctl knob,
net.ipv4.tcp_ehash_entries.  A negative value means the netns shares
the global ehash (per-netns ehash is disabled or failed to allocate
memory).

  # dmesg | cut -d ' ' -f 5- | grep "established hash"
  TCP established hash table entries: 524288 (order: 10, 4194304 bytes, vmalloc hugepage)

  # sysctl net.ipv4.tcp_ehash_entries
  net.ipv4.tcp_ehash_entries = 524288  # can be changed by thash_entries

  # sysctl net.ipv4.tcp_child_ehash_entries
  net.ipv4.tcp_child_ehash_entries = 0  # disabled by default

  # ip netns add test1
  # ip netns exec test1 sysctl net.ipv4.tcp_ehash_entries
  net.ipv4.tcp_ehash_entries = -524288  # share the global ehash

  # sysctl -w net.ipv4.tcp_child_ehash_entries=100
  net.ipv4.tcp_child_ehash_entries = 100

  # ip netns add test2
  # ip netns exec test2 sysctl net.ipv4.tcp_ehash_entries
  net.ipv4.tcp_ehash_entries = 128  # own a per-netns ehash with 2^n buckets

When more than two processes in the same netns create per-netns ehash
concurrently with different sizes, we need to guarantee the size in
one of the following ways:

  1) Share the global ehash and create per-netns ehash

  First, unshare() with tcp_child_ehash_entries==0.  It creates dedicated
  netns sysctl knobs where we can safely change tcp_child_ehash_entries
  and clone()/unshare() to create a per-netns ehash.

  2) Control write on sysctl by BPF

  We can use BPF_PROG_TYPE_CGROUP_SYSCTL to allow/deny read/write on
  sysctl knobs.

Note that the global ehash allocated at the boot time is spread over
available NUMA nodes, but inet_pernet_hashinfo_alloc() will allocate
pages for each per-netns ehash depending on the current process's NUMA
policy.  By default, the allocation is done in the local node only, so
the per-netns hash table could fully reside on a random node.  Thus,
depending on the NUMA policy the netns is created with and the CPU the
current thread is running on, we could see some performance differences
for highly optimised networking applications.

Note also that the default values of two sysctl knobs depend on the ehash
size and should be tuned carefully:

  tcp_max_tw_buckets  : tcp_child_ehash_entries / 2
  tcp_max_syn_backlog : max(128, tcp_child_ehash_entries / 128)

As a bonus, we can dismantle netns faster.  Currently, while destroying
netns, we call inet_twsk_purge(), which walks through the global ehash.
It can be potentially big because it can have many sockets other than
TIME_WAIT in all netns.  Splitting ehash changes that situation, where
it's only necessary for inet_twsk_purge() to clean up TIME_WAIT sockets
in each netns.

With regard to this, we do not free the per-netns ehash in inet_twsk_kill()
to avoid UAF while iterating the per-netns ehash in inet_twsk_purge().
Instead, we do it in tcp_sk_exit_batch() after calling tcp_twsk_purge() to
keep it protocol-family-independent.

In the future, we could optimise ehash lookup/iteration further by removing
netns comparison for the per-netns ehash.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 Documentation/networking/ip-sysctl.rst | 29 ++++++++++++++++
 include/net/inet_hashtables.h          |  6 ++++
 include/net/netns/ipv4.h               |  1 +
 net/dccp/proto.c                       |  2 ++
 net/ipv4/inet_hashtables.c             | 47 ++++++++++++++++++++++++++
 net/ipv4/sysctl_net_ipv4.c             | 39 +++++++++++++++++++++
 net/ipv4/tcp.c                         |  1 +
 net/ipv4/tcp_ipv4.c                    | 38 +++++++++++++++++----
 net/ipv4/tcp_minisocks.c               |  9 +++--
 9 files changed, 164 insertions(+), 8 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index a759872a2883..e7b3fa7bb3f7 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1040,6 +1040,35 @@ tcp_challenge_ack_limit - INTEGER
 	TCP stack implements per TCP socket limits anyway.
 	Default: INT_MAX (unlimited)
 
+tcp_ehash_entries - INTEGER
+	Show the number of hash buckets for TCP sockets in the current
+	networking namespace.
+
+	A negative value means the networking namespace does not own its
+	hash buckets and shares the initial networking namespace's one.
+
+tcp_child_ehash_entries - INTEGER
+	Control the number of hash buckets for TCP sockets in the child
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
+	Note also that the default value of tcp_max_tw_buckets and
+	tcp_max_syn_backlog depend on the hash bucket size.
+
+	Possible values: 0, 2^n (n: 0 - 24 (16Mi))
+
+	Default: 0
+
 UDP variables
 =============
 
diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 520dd894b73d..9121ccab1fa1 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -168,6 +168,8 @@ struct inet_hashinfo {
 	/* The 2nd listener table hashed by local port and address */
 	unsigned int			lhash2_mask;
 	struct inet_listen_hashbucket	*lhash2;
+
+	bool				pernet;
 };
 
 static inline struct inet_hashinfo *tcp_or_dccp_get_hashinfo(const struct sock *sk)
@@ -214,6 +216,10 @@ static inline void inet_ehash_locks_free(struct inet_hashinfo *hashinfo)
 	hashinfo->ehash_locks = NULL;
 }
 
+struct inet_hashinfo *inet_pernet_hashinfo_alloc(struct inet_hashinfo *hashinfo,
+						 unsigned int ehash_entries);
+void inet_pernet_hashinfo_free(struct inet_hashinfo *hashinfo);
+
 struct inet_bind_bucket *
 inet_bind_bucket_create(struct kmem_cache *cachep, struct net *net,
 			struct inet_bind_hashbucket *head,
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 2c7df93e3403..1b8004679445 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -171,6 +171,7 @@ struct netns_ipv4 {
 	int sysctl_tcp_pacing_ca_ratio;
 	int sysctl_tcp_wmem[3];
 	int sysctl_tcp_rmem[3];
+	unsigned int sysctl_tcp_child_ehash_entries;
 	unsigned long sysctl_tcp_comp_sack_delay_ns;
 	unsigned long sysctl_tcp_comp_sack_slack_ns;
 	int sysctl_max_syn_backlog;
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index 7cd4a6cc99fc..c548ca3e9b0e 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -1197,6 +1197,8 @@ static int __init dccp_init(void)
 		INIT_HLIST_HEAD(&dccp_hashinfo.bhash2[i].chain);
 	}
 
+	dccp_hashinfo.pernet = false;
+
 	rc = dccp_mib_init();
 	if (rc)
 		goto out_free_dccp_bhash2;
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index c440de998910..74e64aad5114 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -1145,3 +1145,50 @@ int inet_ehash_locks_alloc(struct inet_hashinfo *hashinfo)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(inet_ehash_locks_alloc);
+
+struct inet_hashinfo *inet_pernet_hashinfo_alloc(struct inet_hashinfo *hashinfo,
+						 unsigned int ehash_entries)
+{
+	struct inet_hashinfo *new_hashinfo;
+	int i;
+
+	new_hashinfo = kmemdup(hashinfo, sizeof(*hashinfo), GFP_KERNEL);
+	if (!new_hashinfo)
+		goto err;
+
+	new_hashinfo->ehash = vmalloc_huge(ehash_entries * sizeof(struct inet_ehash_bucket),
+					   GFP_KERNEL_ACCOUNT);
+	if (!new_hashinfo->ehash)
+		goto free_hashinfo;
+
+	new_hashinfo->ehash_mask = ehash_entries - 1;
+
+	if (inet_ehash_locks_alloc(new_hashinfo))
+		goto free_ehash;
+
+	for (i = 0; i < ehash_entries; i++)
+		INIT_HLIST_NULLS_HEAD(&new_hashinfo->ehash[i].chain, i);
+
+	new_hashinfo->pernet = true;
+
+	return new_hashinfo;
+
+free_ehash:
+	vfree(new_hashinfo->ehash);
+free_hashinfo:
+	kfree(new_hashinfo);
+err:
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(inet_pernet_hashinfo_alloc);
+
+void inet_pernet_hashinfo_free(struct inet_hashinfo *hashinfo)
+{
+	if (!hashinfo->pernet)
+		return;
+
+	inet_ehash_locks_free(hashinfo);
+	vfree(hashinfo->ehash);
+	kfree(hashinfo);
+}
+EXPORT_SYMBOL_GPL(inet_pernet_hashinfo_free);
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 4d7c110c772f..9b8a6db7a66b 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -39,6 +39,7 @@ static u32 u32_max_div_HZ = UINT_MAX / HZ;
 static int one_day_secs = 24 * 3600;
 static u32 fib_multipath_hash_fields_all_mask __maybe_unused =
 	FIB_MULTIPATH_HASH_FIELD_ALL_MASK;
+static unsigned int tcp_child_ehash_entries_max = 16 * 1024 * 1024;
 
 /* obsolete */
 static int sysctl_tcp_low_latency __read_mostly;
@@ -382,6 +383,29 @@ static int proc_tcp_available_ulp(struct ctl_table *ctl,
 	return ret;
 }
 
+static int proc_tcp_ehash_entries(struct ctl_table *table, int write,
+				  void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct net *net = container_of(table->data, struct net,
+				       ipv4.sysctl_tcp_child_ehash_entries);
+	struct inet_hashinfo *hinfo = net->ipv4.tcp_death_row.hashinfo;
+	int tcp_ehash_entries;
+	struct ctl_table tbl;
+
+	tcp_ehash_entries = hinfo->ehash_mask + 1;
+
+	/* A negative number indicates that the child netns
+	 * shares the global ehash.
+	 */
+	if (!net_eq(net, &init_net) && !hinfo->pernet)
+		tcp_ehash_entries *= -1;
+
+	tbl.data = &tcp_ehash_entries;
+	tbl.maxlen = sizeof(int);
+
+	return proc_dointvec(&tbl, write, buffer, lenp, ppos);
+}
+
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
 static int proc_fib_multipath_hash_policy(struct ctl_table *table, int write,
 					  void *buffer, size_t *lenp,
@@ -1320,6 +1344,21 @@ static struct ctl_table ipv4_net_table[] = {
 		.extra1         = SYSCTL_ZERO,
 		.extra2         = SYSCTL_ONE,
 	},
+	{
+		.procname	= "tcp_ehash_entries",
+		.data		= &init_net.ipv4.sysctl_tcp_child_ehash_entries,
+		.mode		= 0444,
+		.proc_handler	= proc_tcp_ehash_entries,
+	},
+	{
+		.procname	= "tcp_child_ehash_entries",
+		.data		= &init_net.ipv4.sysctl_tcp_child_ehash_entries,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_douintvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &tcp_child_ehash_entries_max,
+	},
 	{
 		.procname	= "udp_rmem_min",
 		.data		= &init_net.ipv4.sysctl_udp_rmem_min,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 52b8879e7d20..7c286214e2be 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4790,6 +4790,7 @@ void __init tcp_init(void)
 		INIT_HLIST_HEAD(&tcp_hashinfo.bhash2[i].chain);
 	}
 
+	tcp_hashinfo.pernet = false;
 
 	cnt = tcp_hashinfo.ehash_mask + 1;
 	sysctl_tcp_max_orphans = cnt / 2;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 73e6854ea662..6376ad915765 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3110,10 +3110,38 @@ static void __net_exit tcp_sk_exit(struct net *net)
 			       net->ipv4.tcp_congestion_control->owner);
 }
 
-static int __net_init tcp_sk_init(struct net *net)
+static void __net_init tcp_set_hashinfo(struct net *net)
 {
-	int cnt;
+	struct inet_hashinfo *hinfo;
+	unsigned int ehash_entries;
+	struct net *old_net;
+
+	if (net_eq(net, &init_net))
+		goto fallback;
+
+	old_net = current->nsproxy->net_ns;
+	ehash_entries = READ_ONCE(old_net->ipv4.sysctl_tcp_child_ehash_entries);
+	if (!ehash_entries)
+		goto fallback;
+
+	ehash_entries = roundup_pow_of_two(ehash_entries);
+	hinfo = inet_pernet_hashinfo_alloc(&tcp_hashinfo, ehash_entries);
+	if (!hinfo) {
+		pr_warn("Failed to allocate TCP ehash (entries: %u) "
+			"for a netns, fallback to the global one\n",
+			ehash_entries);
+fallback:
+		hinfo = &tcp_hashinfo;
+		ehash_entries = tcp_hashinfo.ehash_mask + 1;
+	}
+
+	net->ipv4.tcp_death_row.hashinfo = hinfo;
+	net->ipv4.tcp_death_row.sysctl_max_tw_buckets = ehash_entries / 2;
+	net->ipv4.sysctl_max_syn_backlog = max(128U, ehash_entries / 128);
+}
 
+static int __net_init tcp_sk_init(struct net *net)
+{
 	net->ipv4.sysctl_tcp_ecn = 2;
 	net->ipv4.sysctl_tcp_ecn_fallback = 1;
 
@@ -3140,11 +3168,8 @@ static int __net_init tcp_sk_init(struct net *net)
 	net->ipv4.sysctl_tcp_no_ssthresh_metrics_save = 1;
 
 	refcount_set(&net->ipv4.tcp_death_row.tw_refcount, 1);
-	cnt = tcp_hashinfo.ehash_mask + 1;
-	net->ipv4.tcp_death_row.sysctl_max_tw_buckets = cnt / 2;
-	net->ipv4.tcp_death_row.hashinfo = &tcp_hashinfo;
+	tcp_set_hashinfo(net);
 
-	net->ipv4.sysctl_max_syn_backlog = max(128, cnt / 128);
 	net->ipv4.sysctl_tcp_sack = 1;
 	net->ipv4.sysctl_tcp_window_scaling = 1;
 	net->ipv4.sysctl_tcp_timestamps = 1;
@@ -3209,6 +3234,7 @@ static void __net_exit tcp_sk_exit_batch(struct list_head *net_exit_list)
 	tcp_twsk_purge(net_exit_list, AF_INET);
 
 	list_for_each_entry(net, net_exit_list, exit_list) {
+		inet_pernet_hashinfo_free(net->ipv4.tcp_death_row.hashinfo);
 		WARN_ON_ONCE(!refcount_dec_and_test(&net->ipv4.tcp_death_row.tw_refcount));
 		tcp_fastopen_ctx_destroy(net);
 	}
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 98c576d4b671..442838ab0253 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -349,6 +349,7 @@ EXPORT_SYMBOL_GPL(tcp_twsk_destructor);
 
 void tcp_twsk_purge(struct list_head *net_exit_list, int family)
 {
+	bool purged_once = false;
 	struct net *net;
 
 	list_for_each_entry(net, net_exit_list, exit_list) {
@@ -356,8 +357,12 @@ void tcp_twsk_purge(struct list_head *net_exit_list, int family)
 		if (refcount_read(&net->ipv4.tcp_death_row.tw_refcount) == 1)
 			continue;
 
-		inet_twsk_purge(&tcp_hashinfo, family);
-		break;
+		if (net->ipv4.tcp_death_row.hashinfo->pernet) {
+			inet_twsk_purge(net->ipv4.tcp_death_row.hashinfo, family);
+		} else if (!purged_once) {
+			inet_twsk_purge(&tcp_hashinfo, family);
+			purged_once = true;
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(tcp_twsk_purge);
-- 
2.30.2

