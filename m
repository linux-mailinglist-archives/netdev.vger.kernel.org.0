Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8AA5A1D8B
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 02:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244444AbiHZAH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 20:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244170AbiHZAHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 20:07:54 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C26C8769;
        Thu, 25 Aug 2022 17:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661472473; x=1693008473;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xgJ5UCRiGkYB82BgWGk27kXitxudv885PYYW9mWyfQc=;
  b=lw2hWRIY1x7l7kDBmEUIQDadgLXjVuwt1Ps2wD0lzN7PTlUJ7gn38CTL
   IFPwYCperGKeth9DcAnXbAb07x9wwkd0xXbfUNTfeodVZ58Q4RbLPJnSZ
   FGvf1kTnJVHtyRwHoI9UUWDPOe6W3uQkb/r2RQlvfpR51oGFT13eFPBGx
   o=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-5c4a15b1.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 00:07:40 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-5c4a15b1.us-west-2.amazon.com (Postfix) with ESMTPS id C695945195;
        Fri, 26 Aug 2022 00:07:38 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 26 Aug 2022 00:07:36 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.140) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Fri, 26 Aug 2022 00:07:33 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v1 net-next 08/13] tcp: Introduce optional per-netns ehash.
Date:   Thu, 25 Aug 2022 17:04:40 -0700
Message-ID: <20220826000445.46552-9-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220826000445.46552-1-kuniyu@amazon.com>
References: <20220826000445.46552-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.140]
X-ClientProxiedBy: EX13D10UWB001.ant.amazon.com (10.43.161.111) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The more sockets we have in the hash table, the more time we spend
looking up the socket.  While running a number of small workloads on
the same host, they penalise each other and cause performance degradation.

Also, the root cause might be a single workload that consumes much more
resources than the others.  It often happens on a cloud service where
different workloads share the same computing resource.

To resolve the issue, we introduce an optional per-netns hash table for
TCP, but it's just ehash, and we still share the global bhash and lhash2.

With a smaller ehash, we can look up non-listener sockets faster and
isolate such noisy neighbours.  Also, we can reduce lock contention.

We can control the ehash size by a new sysctl knob.  However, depending
on workloads, it will require very sensitive tuning, so we disable the
feature by default (net.ipv4.tcp_child_ehash_entries == 0).  Moreover,
we can fall back to using the global ehash in case we fail to allocate
enough memory for a new ehash.

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

  # sysctl net.ipv4.tcp_child_ehash_entries
  net.ipv4.tcp_child_ehash_entries = 128  # rounded up to 2^n

  # ip netns add test2
  # ip netns exec test2 sysctl net.ipv4.tcp_ehash_entries
  net.ipv4.tcp_ehash_entries = 128  # own per-netns ehash

When more than two processes in the same netns create per-netns ehash
concurrently with different sizes, we need to guarantee the size in
one of the following ways:

  1) Share the global ehash and create per-netns ehash

  First, unshare() with tcp_child_ehash_entries==0.  It creates dedicated
  netns sysctl knobs where we can safely change tcp_child_ehash_entries
  and clone()/unshare() to create a per-netns ehash.

  2) Lock the sysctl knob

  We can use flock(LOCK_MAND) or BPF_PROG_TYPE_CGROUP_SYSCTL to allow/deny
  read/write on sysctl knobs.

Note the default values of two sysctl knobs depend on the ehash size and
should be tuned carefully:

  tcp_max_tw_buckets  : tcp_child_ehash_entries / 2
  tcp_max_syn_backlog : max(128, tcp_child_ehash_entries / 128)

Also, we could optimise ehash lookup/iteration further by removing netns
comparison for the per-netns ehash in the future.

As a bonus, we can dismantle netns faster.  Currently, while destroying
netns, we call inet_twsk_purge(), which walks through the global ehash.
It can be potentially big because it can have many sockets other than
TIME_WAIT in all netns.  Splitting ehash changes that situation, where
it's only necessary for inet_twsk_purge() to clean up TIME_WAIT sockets
in each netns.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 Documentation/networking/ip-sysctl.rst | 20 +++++++++
 include/net/inet_hashtables.h          |  6 +++
 include/net/netns/ipv4.h               |  1 +
 net/dccp/proto.c                       |  2 +
 net/ipv4/inet_hashtables.c             | 57 ++++++++++++++++++++++++++
 net/ipv4/inet_timewait_sock.c          |  4 +-
 net/ipv4/sysctl_net_ipv4.c             | 57 ++++++++++++++++++++++++++
 net/ipv4/tcp.c                         |  1 +
 net/ipv4/tcp_ipv4.c                    | 53 ++++++++++++++++++++----
 net/ipv6/tcp_ipv6.c                    | 12 +++++-
 10 files changed, 202 insertions(+), 11 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 56cd4ea059b2..97a0952b11e3 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1037,6 +1037,26 @@ tcp_challenge_ack_limit - INTEGER
 	in RFC 5961 (Improving TCP's Robustness to Blind In-Window Attacks)
 	Default: 1000
 
+tcp_ehash_entries - INTEGER
+	Read-only number of hash buckets for TCP sockets in the current
+	networking namespace.
+
+	A negative value means the networking namespace does not own its
+	hash buckets and shares the initial networking namespace's one.
+
+tcp_child_ehash_entries - INTEGER
+	Control the number of hash buckets for TCP sockets in the child
+	networking namespace, which must be set before clone() or unshare().
+
+	The written value except for 0 is rounded up to 2^n.  0 is a special
+	value, meaning the child networking namespace will share the initial
+	networking namespace's hash buckets.
+
+	Note that the child will use the global one in case the kernel
+	fails to allocate enough memory.
+
+	Default: 0
+
 UDP variables
 =============
 
diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 2c866112433e..039440936ab2 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -168,6 +168,8 @@ struct inet_hashinfo {
 	/* The 2nd listener table hashed by local port and address */
 	unsigned int			lhash2_mask;
 	struct inet_listen_hashbucket	*lhash2;
+
+	bool				pernet;
 };
 
 static inline struct inet_hashinfo *inet_get_hashinfo(const struct sock *sk)
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
index c7320ef356d9..6d9c01879027 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -170,6 +170,7 @@ struct netns_ipv4 {
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
index 5eb21a95179b..a57932b14bc6 100644
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
+					     GFP_KERNEL);
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
diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index 47ccc343c9fb..a5d40acde9d6 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -59,8 +59,10 @@ static void inet_twsk_kill(struct inet_timewait_sock *tw)
 	inet_twsk_bind_unhash(tw, hashinfo);
 	spin_unlock(&bhead->lock);
 
-	if (refcount_dec_and_test(&tw->tw_dr->tw_refcount))
+	if (refcount_dec_and_test(&tw->tw_dr->tw_refcount)) {
+		inet_pernet_hashinfo_free(hashinfo);
 		kfree(tw->tw_dr);
+	}
 
 	inet_twsk_put(tw);
 }
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 5490c285668b..03a3187c4705 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -382,6 +382,48 @@ static int proc_tcp_available_ulp(struct ctl_table *ctl,
 	return ret;
 }
 
+static int proc_tcp_ehash_entries(struct ctl_table *table, int write,
+				  void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct net *net = container_of(table->data, struct net,
+				       ipv4.sysctl_tcp_child_ehash_entries);
+	struct inet_hashinfo *hinfo = net->ipv4.tcp_death_row->hashinfo;
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
+static int proc_tcp_child_ehash_entries(struct ctl_table *table, int write,
+					void *buffer, size_t *lenp, loff_t *ppos)
+{
+	unsigned int tcp_child_ehash_entries;
+	int ret;
+
+	ret = proc_douintvec(table, write, buffer, lenp, ppos);
+	if (!write || ret)
+		return ret;
+
+	tcp_child_ehash_entries = READ_ONCE(*(unsigned int *)table->data);
+	if (tcp_child_ehash_entries)
+		tcp_child_ehash_entries = roundup_pow_of_two(tcp_child_ehash_entries);
+
+	WRITE_ONCE(*(unsigned int *)table->data, tcp_child_ehash_entries);
+
+	return 0;
+}
+
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
 static int proc_fib_multipath_hash_policy(struct ctl_table *table, int write,
 					  void *buffer, size_t *lenp,
@@ -1321,6 +1363,21 @@ static struct ctl_table ipv4_net_table[] = {
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
+		.proc_handler	= proc_tcp_child_ehash_entries,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_INT_MAX,
+	},
 	{
 		.procname	= "udp_rmem_min",
 		.data		= &init_net.ipv4.sysctl_udp_rmem_min,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index baf6adb723ad..f8ce673e32cb 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4788,6 +4788,7 @@ void __init tcp_init(void)
 		INIT_HLIST_HEAD(&tcp_hashinfo.bhash2[i].chain);
 	}
 
+	tcp_hashinfo.pernet = false;
 
 	cnt = tcp_hashinfo.ehash_mask + 1;
 	sysctl_tcp_max_orphans = cnt / 2;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index b07930643b11..604119f46b52 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3109,14 +3109,23 @@ static void __net_exit tcp_sk_exit(struct net *net)
 	if (net->ipv4.tcp_congestion_control)
 		bpf_module_put(net->ipv4.tcp_congestion_control,
 			       net->ipv4.tcp_congestion_control->owner);
-	if (refcount_dec_and_test(&tcp_death_row->tw_refcount))
+	if (refcount_dec_and_test(&tcp_death_row->tw_refcount)) {
+		inet_pernet_hashinfo_free(tcp_death_row->hashinfo);
 		kfree(tcp_death_row);
+	}
 }
 
-static int __net_init tcp_sk_init(struct net *net)
+static void __net_init tcp_set_hashinfo(struct net *net, struct inet_hashinfo *hinfo)
 {
-	int cnt;
+	int ehash_entries = hinfo->ehash_mask + 1;
 
+	net->ipv4.tcp_death_row->hashinfo = hinfo;
+	net->ipv4.tcp_death_row->sysctl_max_tw_buckets = ehash_entries / 2;
+	net->ipv4.sysctl_max_syn_backlog = max(128, ehash_entries / 128);
+}
+
+static int __net_init tcp_sk_init(struct net *net)
+{
 	net->ipv4.sysctl_tcp_ecn = 2;
 	net->ipv4.sysctl_tcp_ecn_fallback = 1;
 
@@ -3145,12 +3154,10 @@ static int __net_init tcp_sk_init(struct net *net)
 	net->ipv4.tcp_death_row = kzalloc(sizeof(struct inet_timewait_death_row), GFP_KERNEL);
 	if (!net->ipv4.tcp_death_row)
 		return -ENOMEM;
+
 	refcount_set(&net->ipv4.tcp_death_row->tw_refcount, 1);
-	cnt = tcp_hashinfo.ehash_mask + 1;
-	net->ipv4.tcp_death_row->sysctl_max_tw_buckets = cnt / 2;
-	net->ipv4.tcp_death_row->hashinfo = &tcp_hashinfo;
+	tcp_set_hashinfo(net, &tcp_hashinfo);
 
-	net->ipv4.sysctl_max_syn_backlog = max(128, cnt / 128);
 	net->ipv4.sysctl_tcp_sack = 1;
 	net->ipv4.sysctl_tcp_window_scaling = 1;
 	net->ipv4.sysctl_tcp_timestamps = 1;
@@ -3206,18 +3213,46 @@ static int __net_init tcp_sk_init(struct net *net)
 	return 0;
 }
 
+static int __net_init tcp_sk_init_pernet_hashinfo(struct net *net, struct net *old_net)
+{
+	struct inet_hashinfo *child_hinfo;
+	int ehash_entries;
+
+	ehash_entries = READ_ONCE(old_net->ipv4.sysctl_tcp_child_ehash_entries);
+	if (!ehash_entries)
+		goto out;
+
+	child_hinfo = inet_pernet_hashinfo_alloc(&tcp_hashinfo, ehash_entries);
+	if (child_hinfo)
+		tcp_set_hashinfo(net, child_hinfo);
+	else
+		pr_warn("Failed to allocate TCP ehash (entries: %u) "
+			"for a netns, fallback to use the global one\n",
+			ehash_entries);
+out:
+	return 0;
+}
+
 static void __net_exit tcp_sk_exit_batch(struct list_head *net_exit_list)
 {
+	bool purge_once = true;
 	struct net *net;
 
-	inet_twsk_purge(&tcp_hashinfo, AF_INET);
+	list_for_each_entry(net, net_exit_list, exit_list) {
+		if (net->ipv4.tcp_death_row->hashinfo->pernet) {
+			inet_twsk_purge(net->ipv4.tcp_death_row->hashinfo, AF_INET);
+		} else if (purge_once) {
+			inet_twsk_purge(&tcp_hashinfo, AF_INET);
+			purge_once = false;
+		}
 
-	list_for_each_entry(net, net_exit_list, exit_list)
 		tcp_fastopen_ctx_destroy(net);
+	}
 }
 
 static struct pernet_operations __net_initdata tcp_sk_ops = {
        .init	   = tcp_sk_init,
+       .init2	   = tcp_sk_init_pernet_hashinfo,
        .exit	   = tcp_sk_exit,
        .exit_batch = tcp_sk_exit_batch,
 };
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 27b2fd98a2c4..19f730428720 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2229,7 +2229,17 @@ static void __net_exit tcpv6_net_exit(struct net *net)
 
 static void __net_exit tcpv6_net_exit_batch(struct list_head *net_exit_list)
 {
-	inet_twsk_purge(&tcp_hashinfo, AF_INET6);
+	bool purge_once = true;
+	struct net *net;
+
+	list_for_each_entry(net, net_exit_list, exit_list) {
+		if (net->ipv4.tcp_death_row->hashinfo->pernet) {
+			inet_twsk_purge(net->ipv4.tcp_death_row->hashinfo, AF_INET6);
+		} else if (purge_once) {
+			inet_twsk_purge(&tcp_hashinfo, AF_INET6);
+			purge_once = false;
+		}
+	}
 }
 
 static struct pernet_operations tcpv6_net_ops = {
-- 
2.30.2

