Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E84B3B10AA
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 01:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhFVXij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 19:38:39 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:6849 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbhFVXii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 19:38:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1624404983; x=1655940983;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KiWM31DEZ9fCZKAZ2n31GvpR84Di+uhdfpU02AmyVmI=;
  b=ZwfKpftf1DQti99amxMNqCi658QX49PE8rcFCGQi7A+0McgZXfHqMNWc
   b7tyAMtKiwdTGDPHl5ZEvAVOFW3aNBwQNQ0WES17LXNQZEyO5mqmyBfK+
   eN72/3ExgQWHFOBQ1UL/cPRWHOmquNTw8K7QljQSqUZIpxQKBM1RiFHXf
   4=;
X-IronPort-AV: E=Sophos;i="5.83,292,1616457600"; 
   d="scan'208";a="117694856"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-76e0922c.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 22 Jun 2021 23:36:21 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-76e0922c.us-west-2.amazon.com (Postfix) with ESMTPS id 0240FA3103;
        Tue, 22 Jun 2021 23:36:18 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 22 Jun 2021 23:36:18 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.115) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 22 Jun 2021 23:36:14 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
CC:     Yuchung Cheng <ycheng@google.com>, Martin KaFai Lau <kafai@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>
Subject: [PATCH net-next] tcp: Add stats for socket migration.
Date:   Wed, 23 Jun 2021 08:35:29 +0900
Message-ID: <20210622233529.65158-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.115]
X-ClientProxiedBy: EX13D07UWB003.ant.amazon.com (10.43.161.66) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds two stats for the socket migration feature to evaluate the
effectiveness: LINUX_MIB_TCPMIGRATEREQ(SUCCESS|FAILURE).

If the migration fails because of the own_req race in receiving ACK and
sending SYN+ACK paths, we do not increment the failure stat. Then another
CPU is responsible for the req.

Link: https://lore.kernel.org/bpf/CAK6E8=cgFKuGecTzSCSQ8z3YJ_163C0uwO9yRvfDSE7vOe9mJA@mail.gmail.com/
Suggested-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 include/uapi/linux/snmp.h       |  2 ++
 net/core/sock_reuseport.c       | 15 +++++++++++----
 net/ipv4/inet_connection_sock.c | 15 +++++++++++++--
 net/ipv4/proc.c                 |  2 ++
 net/ipv4/tcp_minisocks.c        |  3 +++
 5 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 26fc60ce9298..904909d020e2 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -290,6 +290,8 @@ enum
 	LINUX_MIB_TCPDUPLICATEDATAREHASH,	/* TCPDuplicateDataRehash */
 	LINUX_MIB_TCPDSACKRECVSEGS,		/* TCPDSACKRecvSegs */
 	LINUX_MIB_TCPDSACKIGNOREDDUBIOUS,	/* TCPDSACKIgnoredDubious */
+	LINUX_MIB_TCPMIGRATEREQSUCCESS,		/* TCPMigrateReqSuccess */
+	LINUX_MIB_TCPMIGRATEREQFAILURE,		/* TCPMigrateReqFailure */
 	__LINUX_MIB_MAX
 };
 
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index de5ee3ae86d5..3f00a28fe762 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -6,6 +6,7 @@
  * selecting the socket index from the array of available sockets.
  */
 
+#include <net/ip.h>
 #include <net/sock_reuseport.h>
 #include <linux/bpf.h>
 #include <linux/idr.h>
@@ -536,7 +537,7 @@ struct sock *reuseport_migrate_sock(struct sock *sk,
 
 	socks = READ_ONCE(reuse->num_socks);
 	if (unlikely(!socks))
-		goto out;
+		goto failure;
 
 	/* paired with smp_wmb() in __reuseport_add_sock() */
 	smp_rmb();
@@ -546,13 +547,13 @@ struct sock *reuseport_migrate_sock(struct sock *sk,
 	if (!prog || prog->expected_attach_type != BPF_SK_REUSEPORT_SELECT_OR_MIGRATE) {
 		if (sock_net(sk)->ipv4.sysctl_tcp_migrate_req)
 			goto select_by_hash;
-		goto out;
+		goto failure;
 	}
 
 	if (!skb) {
 		skb = alloc_skb(0, GFP_ATOMIC);
 		if (!skb)
-			goto out;
+			goto failure;
 		allocated = true;
 	}
 
@@ -565,12 +566,18 @@ struct sock *reuseport_migrate_sock(struct sock *sk,
 	if (!nsk)
 		nsk = reuseport_select_sock_by_hash(reuse, hash, socks);
 
-	if (IS_ERR_OR_NULL(nsk) || unlikely(!refcount_inc_not_zero(&nsk->sk_refcnt)))
+	if (IS_ERR_OR_NULL(nsk) || unlikely(!refcount_inc_not_zero(&nsk->sk_refcnt))) {
 		nsk = NULL;
+		goto failure;
+	}
 
 out:
 	rcu_read_unlock();
 	return nsk;
+
+failure:
+	__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMIGRATEREQFAILURE);
+	goto out;
 }
 EXPORT_SYMBOL(reuseport_migrate_sock);
 
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 0eea878edc30..754013fa393b 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -703,6 +703,8 @@ static struct request_sock *inet_reqsk_clone(struct request_sock *req,
 
 	nreq = kmem_cache_alloc(req->rsk_ops->slab, GFP_ATOMIC | __GFP_NOWARN);
 	if (!nreq) {
+		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMIGRATEREQFAILURE);
+
 		/* paired with refcount_inc_not_zero() in reuseport_migrate_sock() */
 		sock_put(sk);
 		return NULL;
@@ -876,9 +878,10 @@ static void reqsk_timer_handler(struct timer_list *t)
 		if (!inet_ehash_insert(req_to_sk(nreq), req_to_sk(oreq), NULL)) {
 			/* delete timer */
 			inet_csk_reqsk_queue_drop(sk_listener, nreq);
-			goto drop;
+			goto no_ownership;
 		}
 
+		__NET_INC_STATS(net, LINUX_MIB_TCPMIGRATEREQSUCCESS);
 		reqsk_migrate_reset(oreq);
 		reqsk_queue_removed(&inet_csk(oreq->rsk_listener)->icsk_accept_queue, oreq);
 		reqsk_put(oreq);
@@ -887,17 +890,19 @@ static void reqsk_timer_handler(struct timer_list *t)
 		return;
 	}
 
-drop:
 	/* Even if we can clone the req, we may need not retransmit any more
 	 * SYN+ACKs (nreq->num_timeout > max_syn_ack_retries, etc), or another
 	 * CPU may win the "own_req" race so that inet_ehash_insert() fails.
 	 */
 	if (nreq) {
+		__NET_INC_STATS(net, LINUX_MIB_TCPMIGRATEREQFAILURE);
+no_ownership:
 		reqsk_migrate_reset(nreq);
 		reqsk_queue_removed(queue, nreq);
 		__reqsk_free(nreq);
 	}
 
+drop:
 	inet_csk_reqsk_queue_drop_and_put(oreq->rsk_listener, oreq);
 }
 
@@ -1135,11 +1140,13 @@ struct sock *inet_csk_complete_hashdance(struct sock *sk, struct sock *child,
 
 			refcount_set(&nreq->rsk_refcnt, 1);
 			if (inet_csk_reqsk_queue_add(sk, nreq, child)) {
+				__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMIGRATEREQSUCCESS);
 				reqsk_migrate_reset(req);
 				reqsk_put(req);
 				return child;
 			}
 
+			__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMIGRATEREQFAILURE);
 			reqsk_migrate_reset(nreq);
 			__reqsk_free(nreq);
 		} else if (inet_csk_reqsk_queue_add(sk, req, child)) {
@@ -1188,8 +1195,12 @@ void inet_csk_listen_stop(struct sock *sk)
 				refcount_set(&nreq->rsk_refcnt, 1);
 
 				if (inet_csk_reqsk_queue_add(nsk, nreq, child)) {
+					__NET_INC_STATS(sock_net(nsk),
+							LINUX_MIB_TCPMIGRATEREQSUCCESS);
 					reqsk_migrate_reset(req);
 				} else {
+					__NET_INC_STATS(sock_net(nsk),
+							LINUX_MIB_TCPMIGRATEREQFAILURE);
 					reqsk_migrate_reset(nreq);
 					__reqsk_free(nreq);
 				}
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 6d46297a99f8..b0d3a09dc84e 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -295,6 +295,8 @@ static const struct snmp_mib snmp4_net_list[] = {
 	SNMP_MIB_ITEM("TcpDuplicateDataRehash", LINUX_MIB_TCPDUPLICATEDATAREHASH),
 	SNMP_MIB_ITEM("TCPDSACKRecvSegs", LINUX_MIB_TCPDSACKRECVSEGS),
 	SNMP_MIB_ITEM("TCPDSACKIgnoredDubious", LINUX_MIB_TCPDSACKIGNOREDDUBIOUS),
+	SNMP_MIB_ITEM("TCPMigrateReqSuccess", LINUX_MIB_TCPMIGRATEREQSUCCESS),
+	SNMP_MIB_ITEM("TCPMigrateReqFailure", LINUX_MIB_TCPMIGRATEREQFAILURE),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index f258a4c0da71..0a4f3f16140a 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -786,6 +786,9 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 	return inet_csk_complete_hashdance(sk, child, req, own_req);
 
 listen_overflow:
+	if (sk != req->rsk_listener)
+		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMIGRATEREQFAILURE);
+
 	if (!sock_net(sk)->ipv4.sysctl_tcp_abort_on_overflow) {
 		inet_rsk(req)->acked = 1;
 		return NULL;
-- 
2.30.2

