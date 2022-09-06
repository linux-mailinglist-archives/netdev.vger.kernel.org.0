Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEF55AF16C
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 19:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238107AbiIFRAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 13:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238511AbiIFQ7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 12:59:45 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F72F7F25C
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 09:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1662482830; x=1694018830;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZLNgIrr9S5cQDa8g1/QwWUiRJeLZFvinHmBHLqoDaEU=;
  b=uVF6rcU4Av0k7Ddc/LKy2Q5aQn3AMkn2hjZpxh3GvGmhi4dwYm/G+pWh
   RE/Bi9Hs510xyZKhGwiIRUiKehotIyfTI5hoys8B2tWUoDYaxU8AQFqwQ
   cQKGN12sqj5YZ4bgoLvYlI2zWlUmCvlXo4w6crbibOKci9L2tVzdhM2l4
   Q=;
X-IronPort-AV: E=Sophos;i="5.93,294,1654560000"; 
   d="scan'208";a="1051765541"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-02ee77e7.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 16:26:43 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-02ee77e7.us-west-2.amazon.com (Postfix) with ESMTPS id 96F9F44FF3;
        Tue,  6 Sep 2022 16:26:43 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 6 Sep 2022 16:26:40 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.172) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 6 Sep 2022 16:26:38 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v4 net-next 6/6] tcp: Introduce optional per-netns ehash.
Date:   Tue, 6 Sep 2022 09:24:23 -0700
Message-ID: <20220906162423.44410-7-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220906162423.44410-1-kuniyu@amazon.com>
References: <20220906162423.44410-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.172]
X-ClientProxiedBy: EX13D30UWC002.ant.amazon.com (10.43.162.235) To
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

Note the default values of two sysctl knobs depend on the ehash size and
should be tuned carefully:

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
 Documentation/networking/ip-sysctl.rst | 23 +++++++++++
 include/net/inet_hashtables.h          |  6 +++
 include/net/netns/ipv4.h               |  1 +
 net/dccp/proto.c                       |  2 +
 net/ipv4/inet_hashtables.c             | 57 ++++++++++++++++++++++++++
 net/ipv4/sysctl_net_ipv4.c             | 39 ++++++++++++++++++
 net/ipv4/tcp.c                         |  1 +
 net/ipv4/tcp_ipv4.c                    | 41 ++++++++++++++----
 net/ipv4/tcp_minisocks.c               |  9 +++-
 9 files changed, 170 insertions(+), 9 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index a759872a2883..ff6553dade3a 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1040,6 +1040,29 @@ tcp_challenge_ack_limit - INTEGER
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
+	fails to allocate enough memory.
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
index c440de998910..e94e1316fcc3 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -1145,3 +1145,60 @@ int inet_ehash_locks_alloc(struct inet_hashinfo *hashinfo)
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
+	new_hashinfo = kmalloc(sizeof(*new_hashinfo), GFP_KERNEL);
+	if (!new_hashinfo)
+		goto err;
+
+	new_hashinfo->ehash = kvmalloc_array(ehash_entries,
+					     sizeof(struct inet_ehash_bucket),
+					     GFP_KERNEL_ACCOUNT);
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
+	new_hashinfo->bind_bucket_cachep = hashinfo->bind_bucket_cachep;
+	new_hashinfo->bhash = hashinfo->bhash;
+	new_hashinfo->bind2_bucket_cachep = hashinfo->bind2_bucket_cachep;
+	new_hashinfo->bhash2 = hashinfo->bhash2;
+	new_hashinfo->bhash_size = hashinfo->bhash_size;
+
+	new_hashinfo->lhash2_mask = hashinfo->lhash2_mask;
+	new_hashinfo->lhash2 = hashinfo->lhash2;
+
+	new_hashinfo->pernet = true;
+
+	return new_hashinfo;
+
+free_ehash:
+	kvfree(new_hashinfo->ehash);
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
+	kvfree(hashinfo->ehash);
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
index 306b94dedc8d..08baf7f7ca96 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4788,6 +4788,7 @@ void __init tcp_init(void)
 		INIT_HLIST_HEAD(&tcp_hashinfo.bhash2[i].chain);
 	}
 
+	tcp_hashinfo.pernet = false;
 
 	cnt = tcp_hashinfo.ehash_mask + 1;
 	sysctl_tcp_max_orphans = cnt / 2;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 531b833a8056..f0a62b134e7d 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3110,9 +3110,39 @@ static void __net_exit tcp_sk_exit(struct net *net)
 			       net->ipv4.tcp_congestion_control->owner);
 }
 
+static void __net_init tcp_set_hashinfo(struct net *net)
+{
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
+
 static int __net_init tcp_sk_init(struct net *net)
 {
-	int cnt;
+	tcp_set_hashinfo(net);
 
 	net->ipv4.sysctl_tcp_ecn = 2;
 	net->ipv4.sysctl_tcp_ecn_fallback = 1;
@@ -3139,11 +3169,6 @@ static int __net_init tcp_sk_init(struct net *net)
 	net->ipv4.sysctl_tcp_tw_reuse = 2;
 	net->ipv4.sysctl_tcp_no_ssthresh_metrics_save = 1;
 
-	cnt = tcp_hashinfo.ehash_mask + 1;
-	net->ipv4.tcp_death_row.sysctl_max_tw_buckets = cnt / 2;
-	net->ipv4.tcp_death_row.hashinfo = &tcp_hashinfo;
-
-	net->ipv4.sysctl_max_syn_backlog = max(128, cnt / 128);
 	net->ipv4.sysctl_tcp_sack = 1;
 	net->ipv4.sysctl_tcp_window_scaling = 1;
 	net->ipv4.sysctl_tcp_timestamps = 1;
@@ -3207,8 +3232,10 @@ static void __net_exit tcp_sk_exit_batch(struct list_head *net_exit_list)
 
 	tcp_twsk_purge(net_exit_list, AF_INET);
 
-	list_for_each_entry(net, net_exit_list, exit_list)
+	list_for_each_entry(net, net_exit_list, exit_list) {
+		inet_pernet_hashinfo_free(net->ipv4.tcp_death_row.hashinfo);
 		tcp_fastopen_ctx_destroy(net);
+	}
 }
 
 static struct pernet_operations __net_initdata tcp_sk_ops = {
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 10d84a854e4d..89a285a165c2 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -349,14 +349,19 @@ EXPORT_SYMBOL_GPL(tcp_twsk_destructor);
 
 void tcp_twsk_purge(struct list_head *net_exit_list, int family)
 {
+	bool purged_once = false;
 	struct net *net;
 
 	list_for_each_entry(net, net_exit_list, exit_list) {
 		if (!refcount_read(&net->ipv4.tcp_death_row.tw_refcount))
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

