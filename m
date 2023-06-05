Return-Path: <netdev+bounces-7852-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF4E0721D17
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 06:22:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46A0A1C20AB7
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 04:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7BA41FD3;
	Mon,  5 Jun 2023 04:22:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6B820F9
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 04:22:35 +0000 (UTC)
X-Greylist: delayed 904 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 04 Jun 2023 21:22:33 PDT
Received: from baidu.com (mx21.baidu.com [220.181.3.85])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857929F;
	Sun,  4 Jun 2023 21:22:33 -0700 (PDT)
From: Duan Muquan <duanmuquan@baidu.com>
To: <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Duan Muquan
	<duanmuquan@baidu.com>
Subject: [PATCH v1] tcp: fix connection reset due to tw hashdance race.
Date: Mon, 5 Jun 2023 11:51:40 +0800
Message-ID: <20230605035140.89106-1-duanmuquan@baidu.com>
X-Mailer: git-send-email 2.32.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.31.62.19]
X-ClientProxiedBy: BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) To
 BJHW-MAIL-EX26.internal.baidu.com (10.127.64.41)
X-FEAS-Client-IP: 172.31.51.57
X-FE-Policy-ID: 15:10:21:SYSTEM
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

If the FIN from passive closer and the ACK for active closer's FIN are
processed on different CPUs concurrently, tw hashdance race may occur.
On loopback interface, transmit function queues a skb to current CPU's
softnet's input queue by default. Suppose active closer runs on CPU 0,
and passive closer runs on CPU 1. If the ACK for the active closer's
FIN is sent with no delay, it will be processed and tw hashdance will
be done on CPU 0; The passive closer's FIN will be sent in another
segment and processed on CPU 1, it may fail to find tw sock in the
ehash table due to tw hashdance on CPU 0, then get a RESET.
If application reconnects immediately with the same source port, it
will get reset because tw sock's tw_substate is still TCP_FIN_WAIT2.

The dmesg to trace down this issue:

.333516] tcp_send_fin: sk 0000000092105ad2 cookie 9 cpu 3
.333524] rcv_state_process:FIN_WAIT2 sk 0000000092105ad2 cookie 9 cpu 3
.333534] tcp_close: tcp_time_wait: sk 0000000092105ad2 cookie 9 cpu 3
.333538] hashdance: tw 00000000690fdb7a added to ehash cookie 9 cpu 3
.333541] hashdance: sk 0000000092105ad2 removed cookie 9 cpu 3
.333544] !refcount_inc_not_zero 00000000690fdb7a ref 0 cookie 9 cpu 0
.333549] hashdance: tw 00000000690fdb7a before add ref 0 cookie 9 cpu 3
.333552] rcv_state: RST for FIN listen 000000003c50afa6 cookie 0 cpu 0
.333574] tcp_send_fin: sk 0000000066757bf8 ref 2 cookie 0 cpu 0
.333611] timewait_state: TCP_TW_RST tw 00000000690fdb7a cookie 9 cpu 0
.333626] tcp_connect: sk 0000000066757bf8 cpu 0 cookie 0

Here is the call trace map:

CPU 0                                    CPU 1

--------                                 --------
tcp_close()
tcp_send_fin()
loopback_xmit()
netif_rx()
tcp_v4_rcv()
tcp_ack_snd_check()
loopback_xmit
netif_rx()                              tcp_close()
...                                     tcp_send_fin()
										loopback_xmit()
										netif_rx()
										tcp_v4_rcv()
										...
tcp_time_wait()
inet_twsk_hashdance() {
...
                                    <-__inet_lookup_established()
									(find sk, may fail tw_refcnt check)
inet_twsk_add_node_tail_rcu(tw, ...)
                                    <-__inet_lookup_established()
									(find sk, may fail tw_refcnt check)
__sk_nulls_del_node_init_rcu(sk)
                                    <-__inet_lookup_established()
								    (find tw, may fail tw_refcnt check)
refcount_set(&tw->tw_refcnt, 3)
                                    <-__inet_lookup_established()
									(find tw, tw_refcnt is ok)
...
}

This issue occurs with a small probability on our application working
on loopback interface, client gets a connection refused error when it
reconnects. In a reproducing environment, modifying tcp_ack_snd_check()
to disable delay ack all the time, and let the client bind the same
source port everytime, it can be reproduced in about 20 minutes.

Brief of the scenario:

1. Server runs on CPU 0 and Client runs on CPU 1. Server closes
connection actively and sends a FIN to client. The lookback's driver
enqueues the FIN segment to backlog queue of CPU 0 via
loopback_xmit()->netif_rx(), one of the conditions for non-delay ack
meets in __tcp_ack_snd_check(), and the ACK is sent immediately.

2. On loopback interface, the ACK is received and processed on CPU 0,
the 'dance' from original sock to tw sock will perfrom, tw sock will
be inserted to ehash table, then the original sock will be removed.

3. On CPU 1, client closes the connection, a FIN segment is sent and
processed on CPU 1. When it is looking up sock in ehash table (with no
lock), tw hashdance race may occur, it fails to find the tw sock and
get a listener sock in the flowing 3 cases:

  (1) Original sock is found, but it has been destroyed and sk_refcnt
	  has become 0 when validating it.
  (2) tw sock is found, but its tw_refcnt has not been set to 3, it is
	  still 0, validating for sk_refcnt will fail.
  (3) For versions that tw sock is added to the head of the list.
	  It will be missed if the list is traversed before tw sock added.
	  And the original sock is removed before it is found. No
	  established will be found.

The listener sock will reset the FIN segment which has ack bit set.

4. If client reconnects immediately and is assigned with the same
source port as previous connection, the tw sock with tw_substate
TCP_FIN_WAIT2 will reset client's SYN and destroy itself in
inet_twsk_deschedule_put(). Application gets a connection refused
error.

5. If client reconnects again, it will succeed.

Introduce the flowing 2 modifications to solve the above 3 bad cases:

For case (1):
Set tw_refcnt to 3 before adding it into list.

For case (2) and (3):
In function tcp_v4_rcv(), if __inet_lookup_skb() returns a listener sock,
and this segment has FIN bit set, then retry the lookup process one time.

There may be another bad case, if the original sock is found and passes
validation, but during further process for the passive closer's FIN on
CPU 1, the sock has been destroyed on CPU 0, then the FIN segment will
be dropped and retransmitted. This case does not hurt application as
much as resetting reconnection, and this case has less possibility than
the other bad cases, it does not occur in on our product or
experimental environment, so it is not considered in this patch.

Could you please check whether this fix is OK, or any suggestions?
Looking forward for your precious comments!

Signed-off-by: Duan Muquan <duanmuquan@baidu.com>
---
 net/ipv4/inet_timewait_sock.c | 15 +++++++--------
 net/ipv4/tcp_ipv4.c           | 13 +++++++++++++
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index 40052414c7c7..ed1f255c9aa8 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -144,14 +144,6 @@ void inet_twsk_hashdance(struct inet_timewait_sock *tw, struct sock *sk,
 
 	spin_lock(lock);
 
-	inet_twsk_add_node_tail_rcu(tw, &ehead->chain);
-
-	/* Step 3: Remove SK from hash chain */
-	if (__sk_nulls_del_node_init_rcu(sk))
-		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
-
-	spin_unlock(lock);
-
 	/* tw_refcnt is set to 3 because we have :
 	 * - one reference for bhash chain.
 	 * - one reference for ehash chain.
@@ -162,6 +154,13 @@ void inet_twsk_hashdance(struct inet_timewait_sock *tw, struct sock *sk,
 	 * so we are not allowed to use tw anymore.
 	 */
 	refcount_set(&tw->tw_refcnt, 3);
+	inet_twsk_add_node_tail_rcu(tw, &ehead->chain);
+
+	/* Step 3: Remove SK from hash chain */
+	if (__sk_nulls_del_node_init_rcu(sk))
+		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
+
+	spin_unlock(lock);
 }
 EXPORT_SYMBOL_GPL(inet_twsk_hashdance);
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 06d2573685ca..3e3cef202f76 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2018,6 +2018,19 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	sk = __inet_lookup_skb(net->ipv4.tcp_death_row.hashinfo,
 			       skb, __tcp_hdrlen(th), th->source,
 			       th->dest, sdif, &refcounted);
+
+	/* If tw "dance" is performed on another CPU, the lookup process may find
+	 * no tw sock for the passive closer's FIN segment, but a listener sock,
+	 * which will reset the FIN segment. If application reconnects immediately
+	 * with the same source port, it will get reset because the tw sock's
+	 * tw_substate is still TCP_FIN_WAIT2. Try to get the tw sock in another try.
+	 */
+	if (unlikely(th->fin && sk && sk->sk_state == TCP_LISTEN)) {
+		sk = __inet_lookup_skb(net->ipv4.tcp_death_row.hashinfo,
+				       skb, __tcp_hdrlen(th), th->source,
+				       th->dest, sdif, &refcounted);
+	}
+
 	if (!sk)
 		goto no_tcp_socket;
 
-- 
2.32.0


