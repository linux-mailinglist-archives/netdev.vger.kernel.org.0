Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC13A56D289
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 03:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiGKBbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 21:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiGKBbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 21:31:34 -0400
Received: from azure-sdnproxy-3.icoremail.net (azure-sdnproxy.icoremail.net [20.232.28.96])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id E7F84165BF;
        Sun, 10 Jul 2022 18:31:30 -0700 (PDT)
Received: from ubuntu.localdomain (unknown [218.12.16.13])
        by mail-app4 (Coremail) with SMTP id cS_KCgDnIfxgfctie5I1AA--.29416S2;
        Mon, 11 Jul 2022 09:31:20 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-hams@vger.kernel.org, pabeni@redhat.com
Cc:     ralf@linux-mips.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH net v6] net: rose: fix null-ptr-deref caused by rose_kill_by_neigh
Date:   Mon, 11 Jul 2022 09:31:11 +0800
Message-Id: <20220711013111.33183-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgDnIfxgfctie5I1AA--.29416S2
X-Coremail-Antispam: 1UD129KBjvJXoW3ZF1xuw1kAF45WrWrCFWUCFg_yoWkJFyUpF
        nIkay3Gr4Utw4qqF4DJanrZw4YqFn2yry3Gr109FyIyF1UGrWYva4ktFW5Cr1xXFZ8JFyY
        gF1xW3yIyrsFyw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyv14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
        JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxG
        rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
        vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IY
        x2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26c
        xKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAF
        wI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgMIAVZdtanBoQAKs1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the link layer connection is broken, the rose->neighbour is
set to null. But rose->neighbour could be used by rose_connection()
and rose_release() later, because there is no synchronization among
them. As a result, the null-ptr-deref bugs will happen.

One of the null-ptr-deref bugs is shown below:

    (thread 1)                  |        (thread 2)
                                |  rose_connect
rose_kill_by_neigh              |    lock_sock(sk)
  spin_lock_bh(&rose_list_lock) |    if (!rose->neighbour)
  rose->neighbour = NULL;//(1)  |
                                |    rose->neighbour->use++;//(2)

The rose->neighbour is set to null in position (1) and dereferenced
in position (2).

The KASAN report triggered by POC is shown below:

KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
...
RIP: 0010:rose_connect+0x6c2/0xf30
RSP: 0018:ffff88800ab47d60 EFLAGS: 00000206
RAX: 0000000000000005 RBX: 000000000000002a RCX: 0000000000000000
RDX: ffff88800ab38000 RSI: ffff88800ab47e48 RDI: ffff88800ab38309
RBP: dffffc0000000000 R08: 0000000000000000 R09: ffffed1001567062
R10: dfffe91001567063 R11: 1ffff11001567061 R12: 1ffff11000d17cd0
R13: ffff8880068be680 R14: 0000000000000002 R15: 1ffff11000d17cd0
...
Call Trace:
  <TASK>
  ? __local_bh_enable_ip+0x54/0x80
  ? selinux_netlbl_socket_connect+0x26/0x30
  ? rose_bind+0x5b0/0x5b0
  __sys_connect+0x216/0x280
  __x64_sys_connect+0x71/0x80
  do_syscall_64+0x43/0x90
  entry_SYSCALL_64_after_hwframe+0x46/0xb0

This patch adds lock_sock() in rose_kill_by_neigh() in order to
synchronize with rose_connect() and rose_release(). Then, changing
type of 'neighbour->use' from unsigned short to atomic_t in order to
mitigate race conditions caused by holding different socket lock while
updating 'neighbour->use'.

Meanwhile, this patch adds sock_hold() protected by rose_list_lock
that could synchronize with rose_remove_socket() in order to mitigate
UAF bug caused by lock_sock() we add.

What's more, there is no need using rose_neigh_list_lock to protect
rose_kill_by_neigh(). Because we have already used rose_neigh_list_lock
to protect the state change of rose_neigh in rose_link_failed(), which
is well synchronized.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
Changes in v6:
  - Change sk_for_each() to sk_for_each_safe().
  - Change type of 'neighbour->use' from unsigned short to atomic_t.

 include/net/rose.h    |  2 +-
 net/rose/af_rose.c    | 19 +++++++++++++------
 net/rose/rose_in.c    | 12 ++++++------
 net/rose/rose_route.c | 24 ++++++++++++------------
 net/rose/rose_timer.c |  2 +-
 5 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/include/net/rose.h b/include/net/rose.h
index 0f0a4ce0fee..d5ddebc556d 100644
--- a/include/net/rose.h
+++ b/include/net/rose.h
@@ -95,7 +95,7 @@ struct rose_neigh {
 	ax25_cb			*ax25;
 	struct net_device		*dev;
 	unsigned short		count;
-	unsigned short		use;
+	atomic_t		use;
 	unsigned int		number;
 	char			restarted;
 	char			dce_mode;
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index bf2d986a6bc..54e7b76c4f3 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -163,16 +163,23 @@ static void rose_remove_socket(struct sock *sk)
 void rose_kill_by_neigh(struct rose_neigh *neigh)
 {
 	struct sock *s;
+	struct hlist_node *tmp;
 
 	spin_lock_bh(&rose_list_lock);
-	sk_for_each(s, &rose_list) {
+	sk_for_each_safe(s, tmp, &rose_list) {
 		struct rose_sock *rose = rose_sk(s);
 
+		sock_hold(s);
+		spin_unlock_bh(&rose_list_lock);
+		lock_sock(s);
 		if (rose->neighbour == neigh) {
 			rose_disconnect(s, ENETUNREACH, ROSE_OUT_OF_ORDER, 0);
-			rose->neighbour->use--;
+			atomic_dec(&rose->neighbour->use);
 			rose->neighbour = NULL;
 		}
+		release_sock(s);
+		sock_put(s);
+		spin_lock_bh(&rose_list_lock);
 	}
 	spin_unlock_bh(&rose_list_lock);
 }
@@ -191,7 +198,7 @@ static void rose_kill_by_device(struct net_device *dev)
 		if (rose->device == dev) {
 			rose_disconnect(s, ENETUNREACH, ROSE_OUT_OF_ORDER, 0);
 			if (rose->neighbour)
-				rose->neighbour->use--;
+				atomic_dec(&rose->neighbour->use);
 			rose->device = NULL;
 		}
 	}
@@ -618,7 +625,7 @@ static int rose_release(struct socket *sock)
 		break;
 
 	case ROSE_STATE_2:
-		rose->neighbour->use--;
+		atomic_dec(&rose->neighbour->use);
 		release_sock(sk);
 		rose_disconnect(sk, 0, -1, -1);
 		lock_sock(sk);
@@ -819,7 +826,7 @@ static int rose_connect(struct socket *sock, struct sockaddr *uaddr, int addr_le
 
 	rose->state = ROSE_STATE_1;
 
-	rose->neighbour->use++;
+	atomic_inc(&rose->neighbour->use);
 
 	rose_write_internal(sk, ROSE_CALL_REQUEST);
 	rose_start_heartbeat(sk);
@@ -1019,7 +1026,7 @@ int rose_rx_call_request(struct sk_buff *skb, struct net_device *dev, struct ros
 	make_rose->device        = dev;
 	make_rose->facilities    = facilities;
 
-	make_rose->neighbour->use++;
+	atomic_inc(&make_rose->neighbour->use);
 
 	if (rose_sk(sk)->defer) {
 		make_rose->state = ROSE_STATE_5;
diff --git a/net/rose/rose_in.c b/net/rose/rose_in.c
index 4d67f36dce1..86168f29943 100644
--- a/net/rose/rose_in.c
+++ b/net/rose/rose_in.c
@@ -56,7 +56,7 @@ static int rose_state1_machine(struct sock *sk, struct sk_buff *skb, int framety
 	case ROSE_CLEAR_REQUEST:
 		rose_write_internal(sk, ROSE_CLEAR_CONFIRMATION);
 		rose_disconnect(sk, ECONNREFUSED, skb->data[3], skb->data[4]);
-		rose->neighbour->use--;
+		atomic_dec(&rose->neighbour->use);
 		break;
 
 	default:
@@ -79,12 +79,12 @@ static int rose_state2_machine(struct sock *sk, struct sk_buff *skb, int framety
 	case ROSE_CLEAR_REQUEST:
 		rose_write_internal(sk, ROSE_CLEAR_CONFIRMATION);
 		rose_disconnect(sk, 0, skb->data[3], skb->data[4]);
-		rose->neighbour->use--;
+		atomic_dec(&rose->neighbour->use);
 		break;
 
 	case ROSE_CLEAR_CONFIRMATION:
 		rose_disconnect(sk, 0, -1, -1);
-		rose->neighbour->use--;
+		atomic_dec(&rose->neighbour->use);
 		break;
 
 	default:
@@ -120,7 +120,7 @@ static int rose_state3_machine(struct sock *sk, struct sk_buff *skb, int framety
 	case ROSE_CLEAR_REQUEST:
 		rose_write_internal(sk, ROSE_CLEAR_CONFIRMATION);
 		rose_disconnect(sk, 0, skb->data[3], skb->data[4]);
-		rose->neighbour->use--;
+		atomic_dec(&rose->neighbour->use);
 		break;
 
 	case ROSE_RR:
@@ -233,7 +233,7 @@ static int rose_state4_machine(struct sock *sk, struct sk_buff *skb, int framety
 	case ROSE_CLEAR_REQUEST:
 		rose_write_internal(sk, ROSE_CLEAR_CONFIRMATION);
 		rose_disconnect(sk, 0, skb->data[3], skb->data[4]);
-		rose->neighbour->use--;
+		atomic_dec(&rose->neighbour->use);
 		break;
 
 	default:
@@ -253,7 +253,7 @@ static int rose_state5_machine(struct sock *sk, struct sk_buff *skb, int framety
 	if (frametype == ROSE_CLEAR_REQUEST) {
 		rose_write_internal(sk, ROSE_CLEAR_CONFIRMATION);
 		rose_disconnect(sk, 0, skb->data[3], skb->data[4]);
-		rose_sk(sk)->neighbour->use--;
+		atomic_dec(&rose_sk(sk)->neighbour->use);
 	}
 
 	return 0;
diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index eb0b8197ac8..8be00a44540 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -93,7 +93,7 @@ static int __must_check rose_add_node(struct rose_route_struct *rose_route,
 		rose_neigh->ax25      = NULL;
 		rose_neigh->dev       = dev;
 		rose_neigh->count     = 0;
-		rose_neigh->use       = 0;
+		atomic_set(&rose_neigh->use, 0);
 		rose_neigh->dce_mode  = 0;
 		rose_neigh->loopback  = 0;
 		rose_neigh->number    = rose_neigh_no++;
@@ -263,10 +263,10 @@ static void rose_remove_route(struct rose_route *rose_route)
 	struct rose_route *s;
 
 	if (rose_route->neigh1 != NULL)
-		rose_route->neigh1->use--;
+		atomic_dec(&rose_route->neigh1->use);
 
 	if (rose_route->neigh2 != NULL)
-		rose_route->neigh2->use--;
+		atomic_dec(&rose_route->neigh2->use);
 
 	if ((s = rose_route_list) == rose_route) {
 		rose_route_list = rose_route->next;
@@ -331,7 +331,7 @@ static int rose_del_node(struct rose_route_struct *rose_route,
 		if (rose_node->neighbour[i] == rose_neigh) {
 			rose_neigh->count--;
 
-			if (rose_neigh->count == 0 && rose_neigh->use == 0)
+			if (rose_neigh->count == 0 && atomic_read(&rose_neigh->use) == 0)
 				rose_remove_neigh(rose_neigh);
 
 			rose_node->count--;
@@ -381,7 +381,7 @@ void rose_add_loopback_neigh(void)
 	sn->ax25      = NULL;
 	sn->dev       = NULL;
 	sn->count     = 0;
-	sn->use       = 0;
+	atomic_set(&sn->use, 0);
 	sn->dce_mode  = 1;
 	sn->loopback  = 1;
 	sn->number    = rose_neigh_no++;
@@ -573,7 +573,7 @@ static int rose_clear_routes(void)
 		s          = rose_neigh;
 		rose_neigh = rose_neigh->next;
 
-		if (s->use == 0 && !s->loopback) {
+		if (atomic_read(&s->use) == 0 && !s->loopback) {
 			s->count = 0;
 			rose_remove_neigh(s);
 		}
@@ -789,13 +789,13 @@ static void rose_del_route_by_neigh(struct rose_neigh *rose_neigh)
 		}
 
 		if (rose_route->neigh1 == rose_neigh) {
-			rose_route->neigh1->use--;
+			atomic_dec(&rose_route->neigh1->use);
 			rose_route->neigh1 = NULL;
 			rose_transmit_clear_request(rose_route->neigh2, rose_route->lci2, ROSE_OUT_OF_ORDER, 0);
 		}
 
 		if (rose_route->neigh2 == rose_neigh) {
-			rose_route->neigh2->use--;
+			atomic_dec(&rose_route->neigh2->use);
 			rose_route->neigh2 = NULL;
 			rose_transmit_clear_request(rose_route->neigh1, rose_route->lci1, ROSE_OUT_OF_ORDER, 0);
 		}
@@ -924,7 +924,7 @@ int rose_route_frame(struct sk_buff *skb, ax25_cb *ax25)
 			rose_clear_queues(sk);
 			rose->cause	 = ROSE_NETWORK_CONGESTION;
 			rose->diagnostic = 0;
-			rose->neighbour->use--;
+			atomic_dec(&rose->neighbour->use);
 			rose->neighbour	 = NULL;
 			rose->lci	 = 0;
 			rose->state	 = ROSE_STATE_0;
@@ -1067,8 +1067,8 @@ int rose_route_frame(struct sk_buff *skb, ax25_cb *ax25)
 	rose_route->lci2      = new_lci;
 	rose_route->neigh2    = new_neigh;
 
-	rose_route->neigh1->use++;
-	rose_route->neigh2->use++;
+	atomic_inc(&rose_route->neigh1->use);
+	atomic_inc(&rose_route->neigh2->use);
 
 	rose_route->next = rose_route_list;
 	rose_route_list  = rose_route;
@@ -1195,7 +1195,7 @@ static int rose_neigh_show(struct seq_file *seq, void *v)
 			   (rose_neigh->loopback) ? "RSLOOP-0" : ax2asc(buf, &rose_neigh->callsign),
 			   rose_neigh->dev ? rose_neigh->dev->name : "???",
 			   rose_neigh->count,
-			   rose_neigh->use,
+			   atomic_read(&rose_neigh->use),
 			   (rose_neigh->dce_mode) ? "DCE" : "DTE",
 			   (rose_neigh->restarted) ? "yes" : "no",
 			   ax25_display_timer(&rose_neigh->t0timer) / HZ,
diff --git a/net/rose/rose_timer.c b/net/rose/rose_timer.c
index f06ddbed3fe..9dfd4eae5d5 100644
--- a/net/rose/rose_timer.c
+++ b/net/rose/rose_timer.c
@@ -171,7 +171,7 @@ static void rose_timer_expiry(struct timer_list *t)
 		break;
 
 	case ROSE_STATE_2:	/* T3 */
-		rose->neighbour->use--;
+		atomic_dec(&rose->neighbour->use);
 		rose_disconnect(sk, ETIMEDOUT, -1, -1);
 		break;
 
-- 
2.17.1

