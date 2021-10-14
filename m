Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2112A42D05D
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 04:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbhJNC3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 22:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbhJNC3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 22:29:32 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E77CC061570
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 19:27:28 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id d23so4103727pgh.8
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 19:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qG1QZteHyhJ4PqCPzeaYcyhO6Fvl1xw2t621gFXyn00=;
        b=HJdOvLZuYGJ25oX+NAq4jnNS0hrvGjiNJm55tI5osUo1mniH6GlhVvm6NNyclGpmGz
         z8nICCRyMnb2z0+kpBE1+7AdzuUezNo2MVYqkj4OELUJyECI+GwVAs/Xk6PffEuU+jW9
         VwZcAbYxBTg8pQ67VSxqhcUJoe3ja6xgXu379J/IyLpRClKy6JHtAI5aBdK/mxCxstBA
         qxw18ltqdegO5Vf/dbSceklGK9dRwZYdMFZwyJBDIMGZZfDiQ8G+ofOHLaRrs5+tgTOT
         c1vxn565qy1B8GZxcoRYX205aBZKrurOQRXxBjrBldxXClJSCG5Uiga0qJi4VAJI4E00
         DeRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qG1QZteHyhJ4PqCPzeaYcyhO6Fvl1xw2t621gFXyn00=;
        b=18wYp2Bnu4BCJpweaZuchoUHYTPyCbt/GPVt1Nb5eRv2rij6nF6CmoSb8yv0PDgeS6
         RQ4moZ/ppJ/o2KXZzdAYhMeUuqyiA1FIL2yIbxZv7rJKBxcr090qARF6LCpD7nzSm7d5
         tQTn2cxETN6QyzOKTikLbsHlIaSHXz25zE+L+RkR7l73A14NCTjpqk+ZbRe5nr+QxnfY
         LixH/CBeoSjPUuqnJJFBWgKimb8NeSl/k9AAM0FOASLUmkSQ1mxfBEH5qcOYm2t2ekzY
         WBHCuo8Z3uBsYH/gSJ0KdQYlFZH3Qb8raasHsxoIqBTx7Jx8QshhrUJ9hU2SG4iYhGox
         rZ2g==
X-Gm-Message-State: AOAM530+TtDWx3HItrRaB+ZV+AsFlyUzGG9t4zmF8+EQ7D9AYv1w6S+3
        0yFKHFnasy7H4izI5zBiIBo=
X-Google-Smtp-Source: ABdhPJxxDbjsU40zJHOSZmVR/lPVUzN3CZf7ecetQkx+sUUPpWyGJr65/ozR8szZ3DiXHxgxtv9JAA==
X-Received: by 2002:aa7:9282:0:b0:3e2:800a:b423 with SMTP id j2-20020aa79282000000b003e2800ab423mr2610468pfa.21.1634178447567;
        Wed, 13 Oct 2021 19:27:27 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f474:fafd:2716:afd])
        by smtp.gmail.com with ESMTPSA id h24sm728824pfn.180.2021.10.13.19.27.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 19:27:27 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stefan Bach <sfb@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH net-next] tcp: switch orphan_count to bare per-cpu counters
Date:   Wed, 13 Oct 2021 19:27:23 -0700
Message-Id: <20211014022723.3477478-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Use of percpu_counter structure to track count of orphaned
sockets is causing problems on modern hosts with 256 cpus
or more.

Stefan Bach reported a serious spinlock contention in real workloads,
that I was able to reproduce with a netfilter rule dropping
incoming FIN packets.

    53.56%  server  [kernel.kallsyms]      [k] queued_spin_lock_slowpath
            |
            ---queued_spin_lock_slowpath
               |
                --53.51%--_raw_spin_lock_irqsave
                          |
                           --53.51%--__percpu_counter_sum
                                     tcp_check_oom
                                     |
                                     |--39.03%--__tcp_close
                                     |          tcp_close
                                     |          inet_release
                                     |          inet6_release
                                     |          sock_close
                                     |          __fput
                                     |          ____fput
                                     |          task_work_run
                                     |          exit_to_usermode_loop
                                     |          do_syscall_64
                                     |
                                      --14.48%--tcp_out_of_resources
                                                tcp_write_timeout
                                                tcp_retransmit_timer
                                                tcp_write_timer_handler
                                                tcp_write_timer
                                                call_timer_fn
                                                expire_timers
                                                __run_timers
                                                run_timer_softirq
                                                __softirqentry_text_start

As explained in commit cf86a086a180 ("net/dst: use a smaller percpu_counter
batch for dst entries accounting"), default batch size is too big
for the default value of tcp_max_orphans (262144).

But even if we reduce batch sizes, there would still be cases
where the estimated count of orphans is beyond the limit,
and where tcp_too_many_orphans() has to call the expensive
percpu_counter_sum_positive().

One solution is to use plain per-cpu counters, and have
a timer to periodically refresh this cache.

Updating this cache every 100ms seems about right, tcp pressure
state is not radically changing over shorter periods.

percpu_counter was nice 15 years ago while hosts had less
than 16 cpus, not anymore by current standards.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Stefan Bach <sfb@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
---
 include/net/inet_connection_sock.h |  2 +-
 include/net/sock.h                 |  2 +-
 include/net/tcp.h                  | 17 +++-----------
 net/dccp/dccp.h                    |  2 +-
 net/dccp/proto.c                   | 14 ++++--------
 net/ipv4/inet_connection_sock.c    |  4 ++--
 net/ipv4/inet_hashtables.c         |  2 +-
 net/ipv4/proc.c                    |  2 +-
 net/ipv4/tcp.c                     | 36 ++++++++++++++++++++++++++----
 9 files changed, 46 insertions(+), 35 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index b06c2d02ec84e96c6222ac608473d7eaf71e5590..fa6a87246a7b85d3358b6ec66e6029445fe3b066 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -289,7 +289,7 @@ static inline void inet_csk_prepare_for_destroy_sock(struct sock *sk)
 {
 	/* The below has to be done to allow calling inet_csk_destroy_sock */
 	sock_set_flag(sk, SOCK_DEAD);
-	percpu_counter_inc(sk->sk_prot->orphan_count);
+	this_cpu_inc(*sk->sk_prot->orphan_count);
 }
 
 void inet_csk_destroy_sock(struct sock *sk);
diff --git a/include/net/sock.h b/include/net/sock.h
index d08ab55fa4a05f403d7591eff9752145ea73e008..596ba85611bc786affed2bf2b18e455b015f3774 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1235,7 +1235,7 @@ struct proto {
 	unsigned int		useroffset;	/* Usercopy region offset */
 	unsigned int		usersize;	/* Usercopy region size */
 
-	struct percpu_counter	*orphan_count;
+	unsigned int __percpu	*orphan_count;
 
 	struct request_sock_ops	*rsk_prot;
 	struct timewait_sock_ops *twsk_prot;
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 4c2898ac65698a097ccaedcc59542041f15f4f70..af77e6453b1b461780df2d6e2fb94ab1baab688e 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -48,7 +48,9 @@
 
 extern struct inet_hashinfo tcp_hashinfo;
 
-extern struct percpu_counter tcp_orphan_count;
+DECLARE_PER_CPU(unsigned int, tcp_orphan_count);
+int tcp_orphan_count_sum(void);
+
 void tcp_time_wait(struct sock *sk, int state, int timeo);
 
 #define MAX_TCP_HEADER	L1_CACHE_ALIGN(128 + MAX_HEADER)
@@ -290,19 +292,6 @@ static inline bool tcp_out_of_memory(struct sock *sk)
 
 void sk_forced_mem_schedule(struct sock *sk, int size);
 
-static inline bool tcp_too_many_orphans(struct sock *sk, int shift)
-{
-	struct percpu_counter *ocp = sk->sk_prot->orphan_count;
-	int orphans = percpu_counter_read_positive(ocp);
-
-	if (orphans << shift > sysctl_tcp_max_orphans) {
-		orphans = percpu_counter_sum_positive(ocp);
-		if (orphans << shift > sysctl_tcp_max_orphans)
-			return true;
-	}
-	return false;
-}
-
 bool tcp_check_oom(struct sock *sk, int shift);
 
 
diff --git a/net/dccp/dccp.h b/net/dccp/dccp.h
index c5c1d2b8045e8efd9bf32a2db1e679c13cbf1852..5183e627468d8901f4f80ed8d74a655aa2a6557f 100644
--- a/net/dccp/dccp.h
+++ b/net/dccp/dccp.h
@@ -48,7 +48,7 @@ extern bool dccp_debug;
 
 extern struct inet_hashinfo dccp_hashinfo;
 
-extern struct percpu_counter dccp_orphan_count;
+DECLARE_PER_CPU(unsigned int, dccp_orphan_count);
 
 void dccp_time_wait(struct sock *sk, int state, int timeo);
 
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index abb5c596a81763b3a571c48137e98d61d21207bf..fc44dadc778bbef72b2cade8b453f012831f592d 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -42,8 +42,8 @@ DEFINE_SNMP_STAT(struct dccp_mib, dccp_statistics) __read_mostly;
 
 EXPORT_SYMBOL_GPL(dccp_statistics);
 
-struct percpu_counter dccp_orphan_count;
-EXPORT_SYMBOL_GPL(dccp_orphan_count);
+DEFINE_PER_CPU(unsigned int, dccp_orphan_count);
+EXPORT_PER_CPU_SYMBOL_GPL(dccp_orphan_count);
 
 struct inet_hashinfo dccp_hashinfo;
 EXPORT_SYMBOL_GPL(dccp_hashinfo);
@@ -1055,7 +1055,7 @@ void dccp_close(struct sock *sk, long timeout)
 	bh_lock_sock(sk);
 	WARN_ON(sock_owned_by_user(sk));
 
-	percpu_counter_inc(sk->sk_prot->orphan_count);
+	this_cpu_inc(dccp_orphan_count);
 
 	/* Have we already been destroyed by a softirq or backlog? */
 	if (state != DCCP_CLOSED && sk->sk_state == DCCP_CLOSED)
@@ -1115,13 +1115,10 @@ static int __init dccp_init(void)
 
 	BUILD_BUG_ON(sizeof(struct dccp_skb_cb) >
 		     sizeof_field(struct sk_buff, cb));
-	rc = percpu_counter_init(&dccp_orphan_count, 0, GFP_KERNEL);
-	if (rc)
-		goto out_fail;
 	inet_hashinfo_init(&dccp_hashinfo);
 	rc = inet_hashinfo2_init_mod(&dccp_hashinfo);
 	if (rc)
-		goto out_free_percpu;
+		goto out_fail;
 	rc = -ENOBUFS;
 	dccp_hashinfo.bind_bucket_cachep =
 		kmem_cache_create("dccp_bind_bucket",
@@ -1226,8 +1223,6 @@ static int __init dccp_init(void)
 	kmem_cache_destroy(dccp_hashinfo.bind_bucket_cachep);
 out_free_hashinfo2:
 	inet_hashinfo2_free_mod(&dccp_hashinfo);
-out_free_percpu:
-	percpu_counter_destroy(&dccp_orphan_count);
 out_fail:
 	dccp_hashinfo.bhash = NULL;
 	dccp_hashinfo.ehash = NULL;
@@ -1250,7 +1245,6 @@ static void __exit dccp_fini(void)
 	dccp_ackvec_exit();
 	dccp_sysctl_exit();
 	inet_hashinfo2_free_mod(&dccp_hashinfo);
-	percpu_counter_destroy(&dccp_orphan_count);
 }
 
 module_init(dccp_init);
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index f25d02ad4a8af41790261a0c79188111ed408efc..f7fea3a7c5e64b92ca9c6b56293628923649e58c 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1015,7 +1015,7 @@ void inet_csk_destroy_sock(struct sock *sk)
 
 	sk_refcnt_debug_release(sk);
 
-	percpu_counter_dec(sk->sk_prot->orphan_count);
+	this_cpu_dec(*sk->sk_prot->orphan_count);
 
 	sock_put(sk);
 }
@@ -1074,7 +1074,7 @@ static void inet_child_forget(struct sock *sk, struct request_sock *req,
 
 	sock_orphan(child);
 
-	percpu_counter_inc(sk->sk_prot->orphan_count);
+	this_cpu_inc(*sk->sk_prot->orphan_count);
 
 	if (sk->sk_protocol == IPPROTO_TCP && tcp_rsk(req)->tfo_listener) {
 		BUG_ON(rcu_access_pointer(tcp_sk(child)->fastopen_rsk) != req);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index bfb522e513461a92cbd19c0c2c14b2dda33bb4f7..75737267746f85a5be82fbe04bbfb429914334c1 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -598,7 +598,7 @@ bool inet_ehash_nolisten(struct sock *sk, struct sock *osk, bool *found_dup_sk)
 	if (ok) {
 		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
 	} else {
-		percpu_counter_inc(sk->sk_prot->orphan_count);
+		this_cpu_inc(*sk->sk_prot->orphan_count);
 		inet_sk_set_state(sk, TCP_CLOSE);
 		sock_set_flag(sk, SOCK_DEAD);
 		inet_csk_destroy_sock(sk);
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index b0d3a09dc84e7a1126bb45b0f8d4ff1d36131d25..f30273afb5399ddf0122e46e36da2ddae720a1c3 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -53,7 +53,7 @@ static int sockstat_seq_show(struct seq_file *seq, void *v)
 	struct net *net = seq->private;
 	int orphans, sockets;
 
-	orphans = percpu_counter_sum_positive(&tcp_orphan_count);
+	orphans = tcp_orphan_count_sum();
 	sockets = proto_sockets_allocated_sum_positive(&tcp_prot);
 
 	socket_seq_show(seq);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 414c179c28e0dd5b91194456d34b46faf2b122e4..a4481748cdf08809bbb600a8559647db83624c43 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -287,8 +287,8 @@ enum {
 	TCP_CMSG_TS = 2
 };
 
-struct percpu_counter tcp_orphan_count;
-EXPORT_SYMBOL_GPL(tcp_orphan_count);
+DEFINE_PER_CPU(unsigned int, tcp_orphan_count);
+EXPORT_PER_CPU_SYMBOL_GPL(tcp_orphan_count);
 
 long sysctl_tcp_mem[3] __read_mostly;
 EXPORT_SYMBOL(sysctl_tcp_mem);
@@ -2673,6 +2673,31 @@ void tcp_shutdown(struct sock *sk, int how)
 }
 EXPORT_SYMBOL(tcp_shutdown);
 
+int tcp_orphan_count_sum(void)
+{
+	int i, total = 0;
+
+	for_each_possible_cpu(i)
+		total += per_cpu(tcp_orphan_count, i);
+
+	return max(total, 0);
+}
+
+static int tcp_orphan_cache;
+static struct timer_list tcp_orphan_timer;
+#define TCP_ORPHAN_TIMER_PERIOD msecs_to_jiffies(100)
+
+static void tcp_orphan_update(struct timer_list *unused)
+{
+	WRITE_ONCE(tcp_orphan_cache, tcp_orphan_count_sum());
+	mod_timer(&tcp_orphan_timer, jiffies + TCP_ORPHAN_TIMER_PERIOD);
+}
+
+static bool tcp_too_many_orphans(struct sock *sk, int shift)
+{
+	return READ_ONCE(tcp_orphan_cache) << shift > sysctl_tcp_max_orphans;
+}
+
 bool tcp_check_oom(struct sock *sk, int shift)
 {
 	bool too_many_orphans, out_of_socket_memory;
@@ -2786,7 +2811,7 @@ void __tcp_close(struct sock *sk, long timeout)
 	/* remove backlog if any, without releasing ownership. */
 	__release_sock(sk);
 
-	percpu_counter_inc(sk->sk_prot->orphan_count);
+	this_cpu_inc(tcp_orphan_count);
 
 	/* Have we already been destroyed by a softirq or backlog? */
 	if (state != TCP_CLOSE && sk->sk_state == TCP_CLOSE)
@@ -4479,7 +4504,10 @@ void __init tcp_init(void)
 		     sizeof_field(struct sk_buff, cb));
 
 	percpu_counter_init(&tcp_sockets_allocated, 0, GFP_KERNEL);
-	percpu_counter_init(&tcp_orphan_count, 0, GFP_KERNEL);
+
+	timer_setup(&tcp_orphan_timer, tcp_orphan_update, TIMER_DEFERRABLE);
+	mod_timer(&tcp_orphan_timer, jiffies + TCP_ORPHAN_TIMER_PERIOD);
+
 	inet_hashinfo_init(&tcp_hashinfo);
 	inet_hashinfo2_init(&tcp_hashinfo, "tcp_listen_portaddr_hash",
 			    thash_entries, 21,  /* one slot per 2 MB*/
-- 
2.33.0.882.g93a45727a2-goog

