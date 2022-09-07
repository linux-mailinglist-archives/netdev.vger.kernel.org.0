Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 426695AF93C
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 02:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiIGA4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 20:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiIGA4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 20:56:53 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9E789CF7
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 17:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1662512211; x=1694048211;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VNcw9TmLwu9c/Y8IIq9tS9rvPTqx+qN2QS42oMCbtb8=;
  b=drzJ/b8MHhDKKtMDcaubyhZZ6WJz1kCjABItkklepB12wkjEAuR1gYmI
   gfGiYhJIWSQCFbV29DcgF2iObQowfaBrd+RiDaGmEmm4y0OSXxxQHZmHP
   pfSI9irMpCcF4DTpdonRfYyJ/+RkfDLqEqWsPTm0BrcDYZ4j4K8ZTNXfh
   4=;
X-IronPort-AV: E=Sophos;i="5.93,295,1654560000"; 
   d="scan'208";a="127451472"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-6fd66c4a.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2022 00:56:37 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-6fd66c4a.us-west-2.amazon.com (Postfix) with ESMTPS id 0621AE0F6A;
        Wed,  7 Sep 2022 00:56:37 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Wed, 7 Sep 2022 00:56:18 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.230) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Wed, 7 Sep 2022 00:56:15 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v5 net-next 2/6] tcp: Don't allocate tcp_death_row outside of struct netns_ipv4.
Date:   Tue, 6 Sep 2022 17:55:30 -0700
Message-ID: <20220907005534.72876-3-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220907005534.72876-1-kuniyu@amazon.com>
References: <20220907005534.72876-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.230]
X-ClientProxiedBy: EX13D35UWB001.ant.amazon.com (10.43.161.47) To
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

We will soon introduce an optional per-netns ehash and access hash
tables via net->ipv4.tcp_death_row->hashinfo instead of &tcp_hashinfo
in most places.

It could harm the fast path because dereferences of two fields in net
and tcp_death_row might incur two extra cache line misses.  To save one
dereference, let's place tcp_death_row back in netns_ipv4 and fetch
hashinfo via net->ipv4.tcp_death_row"."hashinfo.

Note tcp_death_row was initially placed in netns_ipv4, and commit
fbb8295248e1 ("tcp: allocate tcp_death_row outside of struct netns_ipv4")
changed it to a pointer so that we can fire TIME_WAIT timers after freeing
net.  However, we don't do so after commit 04c494e68a13 ("Revert "tcp/dccp:
get rid of inet_twsk_purge()""), so we need not define tcp_death_row as a
pointer.

Also, we move refcount_dec_and_test(&tw_refcount) from tcp_sk_exit() to
tcp_sk_exit_batch() as a debug check.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/netns/ipv4.h      |  3 ++-
 net/ipv4/inet_timewait_sock.c |  4 +---
 net/ipv4/proc.c               |  2 +-
 net/ipv4/sysctl_net_ipv4.c    |  8 ++------
 net/ipv4/tcp_ipv4.c           | 19 +++++++------------
 net/ipv4/tcp_minisocks.c      |  2 +-
 net/ipv6/tcp_ipv6.c           |  2 +-
 7 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 6320a76cefdc..2c7df93e3403 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -34,6 +34,7 @@ struct inet_hashinfo;
 struct inet_timewait_death_row {
 	refcount_t		tw_refcount;
 
+	/* Padding to avoid false sharing, tw_refcount can be often written */
 	struct inet_hashinfo 	*hashinfo ____cacheline_aligned_in_smp;
 	int			sysctl_max_tw_buckets;
 };
@@ -41,7 +42,7 @@ struct inet_timewait_death_row {
 struct tcp_fastopen_context;
 
 struct netns_ipv4 {
-	struct inet_timewait_death_row *tcp_death_row;
+	struct inet_timewait_death_row tcp_death_row;
 
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header	*forw_hdr;
diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index 47ccc343c9fb..71d3bb0abf6c 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -59,9 +59,7 @@ static void inet_twsk_kill(struct inet_timewait_sock *tw)
 	inet_twsk_bind_unhash(tw, hashinfo);
 	spin_unlock(&bhead->lock);
 
-	if (refcount_dec_and_test(&tw->tw_dr->tw_refcount))
-		kfree(tw->tw_dr);
-
+	refcount_dec(&tw->tw_dr->tw_refcount);
 	inet_twsk_put(tw);
 }
 
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 0088a4c64d77..5386f460bd20 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -59,7 +59,7 @@ static int sockstat_seq_show(struct seq_file *seq, void *v)
 	socket_seq_show(seq);
 	seq_printf(seq, "TCP: inuse %d orphan %d tw %d alloc %d mem %ld\n",
 		   sock_prot_inuse_get(net, &tcp_prot), orphans,
-		   refcount_read(&net->ipv4.tcp_death_row->tw_refcount) - 1,
+		   refcount_read(&net->ipv4.tcp_death_row.tw_refcount) - 1,
 		   sockets, proto_memory_allocated(&tcp_prot));
 	seq_printf(seq, "UDP: inuse %d mem %ld\n",
 		   sock_prot_inuse_get(net, &udp_prot),
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 5490c285668b..4d7c110c772f 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -530,10 +530,9 @@ static struct ctl_table ipv4_table[] = {
 };
 
 static struct ctl_table ipv4_net_table[] = {
-	/* tcp_max_tw_buckets must be first in this table. */
 	{
 		.procname	= "tcp_max_tw_buckets",
-/*		.data		= &init_net.ipv4.tcp_death_row.sysctl_max_tw_buckets, */
+		.data		= &init_net.ipv4.tcp_death_row.sysctl_max_tw_buckets,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec
@@ -1361,8 +1360,7 @@ static __net_init int ipv4_sysctl_init_net(struct net *net)
 		if (!table)
 			goto err_alloc;
 
-		/* skip first entry (sysctl_max_tw_buckets) */
-		for (i = 1; i < ARRAY_SIZE(ipv4_net_table) - 1; i++) {
+		for (i = 0; i < ARRAY_SIZE(ipv4_net_table) - 1; i++) {
 			if (table[i].data) {
 				/* Update the variables to point into
 				 * the current struct net
@@ -1377,8 +1375,6 @@ static __net_init int ipv4_sysctl_init_net(struct net *net)
 		}
 	}
 
-	table[0].data = &net->ipv4.tcp_death_row->sysctl_max_tw_buckets;
-
 	net->ipv4.ipv4_hdr = register_net_sysctl(net, "net/ipv4", table);
 	if (!net->ipv4.ipv4_hdr)
 		goto err_reg;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index a07243f66d4c..3930b6a1e0d6 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -292,7 +292,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 * complete initialization after this.
 	 */
 	tcp_set_state(sk, TCP_SYN_SENT);
-	tcp_death_row = net->ipv4.tcp_death_row;
+	tcp_death_row = &net->ipv4.tcp_death_row;
 	err = inet_hash_connect(tcp_death_row, sk);
 	if (err)
 		goto failure;
@@ -3091,13 +3091,9 @@ EXPORT_SYMBOL(tcp_prot);
 
 static void __net_exit tcp_sk_exit(struct net *net)
 {
-	struct inet_timewait_death_row *tcp_death_row = net->ipv4.tcp_death_row;
-
 	if (net->ipv4.tcp_congestion_control)
 		bpf_module_put(net->ipv4.tcp_congestion_control,
 			       net->ipv4.tcp_congestion_control->owner);
-	if (refcount_dec_and_test(&tcp_death_row->tw_refcount))
-		kfree(tcp_death_row);
 }
 
 static int __net_init tcp_sk_init(struct net *net)
@@ -3129,13 +3125,10 @@ static int __net_init tcp_sk_init(struct net *net)
 	net->ipv4.sysctl_tcp_tw_reuse = 2;
 	net->ipv4.sysctl_tcp_no_ssthresh_metrics_save = 1;
 
-	net->ipv4.tcp_death_row = kzalloc(sizeof(struct inet_timewait_death_row), GFP_KERNEL);
-	if (!net->ipv4.tcp_death_row)
-		return -ENOMEM;
-	refcount_set(&net->ipv4.tcp_death_row->tw_refcount, 1);
+	refcount_set(&net->ipv4.tcp_death_row.tw_refcount, 1);
 	cnt = tcp_hashinfo.ehash_mask + 1;
-	net->ipv4.tcp_death_row->sysctl_max_tw_buckets = cnt / 2;
-	net->ipv4.tcp_death_row->hashinfo = &tcp_hashinfo;
+	net->ipv4.tcp_death_row.sysctl_max_tw_buckets = cnt / 2;
+	net->ipv4.tcp_death_row.hashinfo = &tcp_hashinfo;
 
 	net->ipv4.sysctl_max_syn_backlog = max(128, cnt / 128);
 	net->ipv4.sysctl_tcp_sack = 1;
@@ -3201,8 +3194,10 @@ static void __net_exit tcp_sk_exit_batch(struct list_head *net_exit_list)
 
 	inet_twsk_purge(&tcp_hashinfo, AF_INET);
 
-	list_for_each_entry(net, net_exit_list, exit_list)
+	list_for_each_entry(net, net_exit_list, exit_list) {
+		WARN_ON_ONCE(!refcount_dec_and_test(&net->ipv4.tcp_death_row.tw_refcount));
 		tcp_fastopen_ctx_destroy(net);
+	}
 }
 
 static struct pernet_operations __net_initdata tcp_sk_ops = {
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 80ce27f8f77e..8bddb2a78b21 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -250,7 +250,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 	struct net *net = sock_net(sk);
 	struct inet_timewait_sock *tw;
 
-	tw = inet_twsk_alloc(sk, net->ipv4.tcp_death_row, state);
+	tw = inet_twsk_alloc(sk, &net->ipv4.tcp_death_row, state);
 
 	if (tw) {
 		struct tcp_timewait_sock *tcptw = tcp_twsk((struct sock *)tw);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 5c562d69fddf..eb1da7a63fbb 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -325,7 +325,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	inet->inet_dport = usin->sin6_port;
 
 	tcp_set_state(sk, TCP_SYN_SENT);
-	tcp_death_row = net->ipv4.tcp_death_row;
+	tcp_death_row = &net->ipv4.tcp_death_row;
 	err = inet6_hash_connect(tcp_death_row, sk);
 	if (err)
 		goto late_failure;
-- 
2.30.2

