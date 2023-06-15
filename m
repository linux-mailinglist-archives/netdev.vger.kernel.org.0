Return-Path: <netdev+bounces-11085-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8B38731863
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:14:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2A6A1C20E5A
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 12:14:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06263156F8;
	Thu, 15 Jun 2023 12:14:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DF4156E4
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 12:14:32 +0000 (UTC)
Received: from baidu.com (mx21.baidu.com [220.181.3.85])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4ED819B5;
	Thu, 15 Jun 2023 05:14:29 -0700 (PDT)
From: Duan Muquan <duanmuquan@baidu.com>
To: <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Duan Muquan
	<duanmuquan@baidu.com>
Subject: [PATCH v3] tcp: fix connection reset due to tw hashdance race.
Date: Thu, 15 Jun 2023 20:13:45 +0800
Message-ID: <20230615121345.83597-1-duanmuquan@baidu.com>
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
X-ClientProxiedBy: BC-Mail-Ex24.internal.baidu.com (172.31.51.18) To
 BJHW-MAIL-EX26.internal.baidu.com (10.127.64.41)
X-FEAS-Client-IP: 172.31.51.15
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
.333544] __inet_lookup_established: Failed the refcount check:
		 !refcount_inc_not_zero 00000000690fdb7a ref 0 cookie 9 cpu 0
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
								(bad case (1), find sk, may fail tw_refcnt check)
inet_twsk_add_node_tail_rcu(tw, ...)
                                    <-__inet_lookup_established()
								(bad case (1), find sk, may fail tw_refcnt check)

__sk_nulls_del_node_init_rcu(sk)
                                    <-__inet_lookup_established()
								(bad case (2), find tw, may fail tw_refcnt check)
refcount_set(&tw->tw_refcnt, 3)
                                    <-__inet_lookup_established()
								(good case, find tw, tw_refcnt is not 0)
...
}

This issue occurs with a small probability on our application working
on loopback interface, client gets a connection refused error when it
reconnects. In reproducing environments on kernel 4.14,5.10 or
6.4-rc1, modify tcp_ack_snd_check() to disable delay ack all the
time; Let client connect server and server sends a message to client
then close the connection; Repeat this process forever; Let the client
bind the same source port every time, it can be reproduced in about 20
minutes.

Brief of the scenario:

1. Server runs on CPU 0 and Client runs on CPU 1. Server closes
connection actively and sends a FIN to client. The lookback's driver
enqueues the FIN segment to backlog queue of CPU 0 via
loopback_xmit()->netif_rx(), one of the conditions for non-delay ack
meets in __tcp_ack_snd_check(), and the ACK is sent immediately.

2. On loopback interface, the ACK is received and processed on CPU 0,
the 'dance' from original sock to tw sock will perform, tw sock will
be inserted to ehash table, then the original sock will be removed.

3. On CPU 1, client closes the connection, a FIN segment is sent and
processed on CPU 1. When it is looking up sock in ehash table (with no
lock), tw hashdance race may occur, it fails to find the tw sock and
get a listener sock in the flowing 3 cases:

  (1) Original sock is found, but it has been destroyed and sk_refcnt
	  has become 0 when validating it.
  (2) tw sock is found, but its tw_refcnt has not been set to 3, it is
	  still 0, validating for sk_refcnt will fail.
  (3) For versions without Eric and Jason's fix(3f4ca5fafc08881d7a5
	  7daa20449d171f2887043), tw sock is added to the head of the list.
	  It will be missed if the list is traversed before tw sock is
	  added. And if the original sock is removed before it is found, no
	  established sock will be found.

The listener sock will reset the FIN segment which has ack bit set.

4. If client reconnects immediately and is assigned with the same
source port as previous connection, the tw sock with tw_substate
TCP_FIN_WAIT2 will reset client's SYN and destroy itself in
inet_twsk_deschedule_put(). Application gets a connection refused
error.

5. If client reconnects again, it will succeed.

Introduce the following modification to solve this 'connection refused'
issue:

If we do the tw hashdance in real TCP_TIME_WAIT state with substate
TCP_TIME_WAIT, instead of in substate TCP_FIN_WAIT2, the connection
refused issue will not occur. The race of the lookup process for the
new SYN segment and the tw hashdance can come to the following
results:
1) get tw sock, SYN segment will be accepted via TCP_TW_SYN.
2) fail to get tw sock and original sock, get a listener sock,
   SYN segment will be accepted by listener sock.
3) get original sock, SYN segment can be discarded in further
process after the sock is destroyed, in this case the peer will
retransmit the SYN segment. This is a very rare case, seems no need to
add lock for it.

I tested this modification in my reproducing environment,
the connection reset issue did not occur and no performance impact
observed.The side effect I currently can think out is that the original
sock will live a little longer and hold some resources longer.
The new patch is a temporary version which has a sysctl
switch for comparing the 2 methods, and some modifications
for statistics of the states not included.
I checked the implementation in FreeBSD 13.1, it does the dance in
state TCP_TIMEWAIT.

Could you please help check whether this modification makes sense, and
any side effect? Thanks!

Signed-off-by: Duan Muquan <duanmuquan@baidu.com>
---
 include/net/tcp.h          | 1 +
 net/ipv4/sysctl_net_ipv4.c | 8 ++++++++
 net/ipv4/tcp.c             | 5 ++++-
 net/ipv4/tcp_input.c       | 9 +++++++--
 net/ipv4/tcp_timer.c       | 5 ++++-
 5 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 18a038d16434..c04b62d5a6b2 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -247,6 +247,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
 /* sysctl variables for tcp */
 extern int sysctl_tcp_max_orphans;
 extern long sysctl_tcp_mem[3];
+extern int sysctl_tcp_fin_wait2_dance;
 
 #define TCP_RACK_LOSS_DETECTION  0x1 /* Use RACK to detect losses */
 #define TCP_RACK_STATIC_REO_WND  0x2 /* Use static RACK reo wnd */
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 40fe70fc2015..bb217c338ac3 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -578,6 +578,14 @@ static struct ctl_table ipv4_table[] = {
 		.extra1		= &sysctl_fib_sync_mem_min,
 		.extra2		= &sysctl_fib_sync_mem_max,
 	},
+	{
+		.procname	= "tcp_fin_wait2_dance",
+		.data		= &sysctl_tcp_fin_wait2_dance,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+	},
 	{ }
 };
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index a60f6f4e7cd9..f27b670fa8d0 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2985,7 +2985,10 @@ void __tcp_close(struct sock *sk, long timeout)
 				inet_csk_reset_keepalive_timer(sk,
 						tmo - TCP_TIMEWAIT_LEN);
 			} else {
-				tcp_time_wait(sk, TCP_FIN_WAIT2, tmo);
+				if (sysctl_tcp_fin_wait2_dance)
+					tcp_time_wait(sk, TCP_FIN_WAIT2, tmo);
+				else
+					inet_csk_reset_keepalive_timer(sk, tmo);
 				goto out;
 			}
 		}
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 61b6710f337a..e53e39cf16f3 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -82,6 +82,7 @@
 #include <net/mptcp.h>
 
 int sysctl_tcp_max_orphans __read_mostly = NR_FILE;
+int sysctl_tcp_fin_wait2_dance = 1;
 
 #define FLAG_DATA		0x01 /* Incoming frame contained data.		*/
 #define FLAG_WIN_UPDATE		0x02 /* Incoming ACK was a window update.	*/
@@ -6636,8 +6637,12 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			 */
 			inet_csk_reset_keepalive_timer(sk, tmo);
 		} else {
-			tcp_time_wait(sk, TCP_FIN_WAIT2, tmo);
-			goto consume;
+			if (sysctl_tcp_fin_wait2_dance) {
+				tcp_time_wait(sk, TCP_FIN_WAIT2, tmo);
+				goto consume;
+			} else {
+				inet_csk_reset_keepalive_timer(sk, tmo);
+			}
 		}
 		break;
 	}
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index b839c2f91292..e800aecfa67d 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -691,7 +691,10 @@ static void tcp_keepalive_timer (struct timer_list *t)
 			const int tmo = tcp_fin_time(sk) - TCP_TIMEWAIT_LEN;
 
 			if (tmo > 0) {
-				tcp_time_wait(sk, TCP_FIN_WAIT2, tmo);
+				if (sysctl_tcp_fin_wait2_dance)
+					tcp_time_wait(sk, TCP_FIN_WAIT2, tmo);
+				else
+					inet_csk_reset_keepalive_timer(sk, tmo);
 				goto out;
 			}
 		}
-- 
2.32.0


