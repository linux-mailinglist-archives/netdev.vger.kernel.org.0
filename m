Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23077F7E9
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 14:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfD3MDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 08:03:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729786AbfD3LnL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 07:43:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19FAD21670;
        Tue, 30 Apr 2019 11:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624590;
        bh=RU4mK/lyV2YcpKM6d1fmjpTa63CWyC5n9Ief//LGfdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BfnXHvOubA7O9T42gQinkQUlkhdbx/I6OQG/fa5YKdV0AMsxgwPbQewPldTdJ7WTW
         x3X1Me1bzFnD4Od0loBTKgDFjSDcjgDRfkqNr6Kbwx9B3F7354C5O6q0/mBwjAeniO
         aU1EzeWWy2pVMBsiQOallUOsNsugwb1ta7FBjA7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 4.14 51/53] net/rose: Convert timers to use timer_setup()
Date:   Tue, 30 Apr 2019 13:38:58 +0200
Message-Id: <20190430113559.530628190@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113549.400132183@linuxfoundation.org>
References: <20190430113549.400132183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 4966babd904d7f8e9e20735f3637a98fd7ca538c upstream.

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-hams@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/rose/af_rose.c       |   17 +++++++++--------
 net/rose/rose_link.c     |   16 +++++++---------
 net/rose/rose_loopback.c |    9 +++------
 net/rose/rose_route.c    |    8 ++++----
 net/rose/rose_timer.c    |   30 +++++++++++++-----------------
 5 files changed, 36 insertions(+), 44 deletions(-)

--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -318,9 +318,11 @@ void rose_destroy_socket(struct sock *);
 /*
  *	Handler for deferred kills.
  */
-static void rose_destroy_timer(unsigned long data)
+static void rose_destroy_timer(struct timer_list *t)
 {
-	rose_destroy_socket((struct sock *)data);
+	struct sock *sk = from_timer(sk, t, sk_timer);
+
+	rose_destroy_socket(sk);
 }
 
 /*
@@ -353,8 +355,7 @@ void rose_destroy_socket(struct sock *sk
 
 	if (sk_has_allocations(sk)) {
 		/* Defer: outstanding buffers */
-		setup_timer(&sk->sk_timer, rose_destroy_timer,
-				(unsigned long)sk);
+		timer_setup(&sk->sk_timer, rose_destroy_timer, 0);
 		sk->sk_timer.expires  = jiffies + 10 * HZ;
 		add_timer(&sk->sk_timer);
 	} else
@@ -538,8 +539,8 @@ static int rose_create(struct net *net,
 	sock->ops    = &rose_proto_ops;
 	sk->sk_protocol = protocol;
 
-	init_timer(&rose->timer);
-	init_timer(&rose->idletimer);
+	timer_setup(&rose->timer, NULL, 0);
+	timer_setup(&rose->idletimer, NULL, 0);
 
 	rose->t1   = msecs_to_jiffies(sysctl_rose_call_request_timeout);
 	rose->t2   = msecs_to_jiffies(sysctl_rose_reset_request_timeout);
@@ -582,8 +583,8 @@ static struct sock *rose_make_new(struct
 	sk->sk_state    = TCP_ESTABLISHED;
 	sock_copy_flags(sk, osk);
 
-	init_timer(&rose->timer);
-	init_timer(&rose->idletimer);
+	timer_setup(&rose->timer, NULL, 0);
+	timer_setup(&rose->idletimer, NULL, 0);
 
 	orose		= rose_sk(osk);
 	rose->t1	= orose->t1;
--- a/net/rose/rose_link.c
+++ b/net/rose/rose_link.c
@@ -27,8 +27,8 @@
 #include <linux/interrupt.h>
 #include <net/rose.h>
 
-static void rose_ftimer_expiry(unsigned long);
-static void rose_t0timer_expiry(unsigned long);
+static void rose_ftimer_expiry(struct timer_list *);
+static void rose_t0timer_expiry(struct timer_list *);
 
 static void rose_transmit_restart_confirmation(struct rose_neigh *neigh);
 static void rose_transmit_restart_request(struct rose_neigh *neigh);
@@ -37,8 +37,7 @@ void rose_start_ftimer(struct rose_neigh
 {
 	del_timer(&neigh->ftimer);
 
-	neigh->ftimer.data     = (unsigned long)neigh;
-	neigh->ftimer.function = &rose_ftimer_expiry;
+	neigh->ftimer.function = (TIMER_FUNC_TYPE)rose_ftimer_expiry;
 	neigh->ftimer.expires  =
 		jiffies + msecs_to_jiffies(sysctl_rose_link_fail_timeout);
 
@@ -49,8 +48,7 @@ static void rose_start_t0timer(struct ro
 {
 	del_timer(&neigh->t0timer);
 
-	neigh->t0timer.data     = (unsigned long)neigh;
-	neigh->t0timer.function = &rose_t0timer_expiry;
+	neigh->t0timer.function = (TIMER_FUNC_TYPE)rose_t0timer_expiry;
 	neigh->t0timer.expires  =
 		jiffies + msecs_to_jiffies(sysctl_rose_restart_request_timeout);
 
@@ -77,13 +75,13 @@ static int rose_t0timer_running(struct r
 	return timer_pending(&neigh->t0timer);
 }
 
-static void rose_ftimer_expiry(unsigned long param)
+static void rose_ftimer_expiry(struct timer_list *t)
 {
 }
 
-static void rose_t0timer_expiry(unsigned long param)
+static void rose_t0timer_expiry(struct timer_list *t)
 {
-	struct rose_neigh *neigh = (struct rose_neigh *)param;
+	struct rose_neigh *neigh = from_timer(neigh, t, t0timer);
 
 	rose_transmit_restart_request(neigh);
 
--- a/net/rose/rose_loopback.c
+++ b/net/rose/rose_loopback.c
@@ -19,12 +19,13 @@ static struct sk_buff_head loopback_queu
 static struct timer_list loopback_timer;
 
 static void rose_set_loopback_timer(void);
+static void rose_loopback_timer(struct timer_list *unused);
 
 void rose_loopback_init(void)
 {
 	skb_queue_head_init(&loopback_queue);
 
-	init_timer(&loopback_timer);
+	timer_setup(&loopback_timer, rose_loopback_timer, 0);
 }
 
 static int rose_loopback_running(void)
@@ -50,20 +51,16 @@ int rose_loopback_queue(struct sk_buff *
 	return 1;
 }
 
-static void rose_loopback_timer(unsigned long);
 
 static void rose_set_loopback_timer(void)
 {
 	del_timer(&loopback_timer);
 
-	loopback_timer.data     = 0;
-	loopback_timer.function = &rose_loopback_timer;
 	loopback_timer.expires  = jiffies + 10;
-
 	add_timer(&loopback_timer);
 }
 
-static void rose_loopback_timer(unsigned long param)
+static void rose_loopback_timer(struct timer_list *unused)
 {
 	struct sk_buff *skb;
 	struct net_device *dev;
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -104,8 +104,8 @@ static int __must_check rose_add_node(st
 
 		skb_queue_head_init(&rose_neigh->queue);
 
-		init_timer(&rose_neigh->ftimer);
-		init_timer(&rose_neigh->t0timer);
+		timer_setup(&rose_neigh->ftimer, NULL, 0);
+		timer_setup(&rose_neigh->t0timer, NULL, 0);
 
 		if (rose_route->ndigis != 0) {
 			rose_neigh->digipeat =
@@ -390,8 +390,8 @@ void rose_add_loopback_neigh(void)
 
 	skb_queue_head_init(&sn->queue);
 
-	init_timer(&sn->ftimer);
-	init_timer(&sn->t0timer);
+	timer_setup(&sn->ftimer, NULL, 0);
+	timer_setup(&sn->t0timer, NULL, 0);
 
 	spin_lock_bh(&rose_neigh_list_lock);
 	sn->next = rose_neigh_list;
--- a/net/rose/rose_timer.c
+++ b/net/rose/rose_timer.c
@@ -29,8 +29,8 @@
 #include <net/rose.h>
 
 static void rose_heartbeat_expiry(unsigned long);
-static void rose_timer_expiry(unsigned long);
-static void rose_idletimer_expiry(unsigned long);
+static void rose_timer_expiry(struct timer_list *);
+static void rose_idletimer_expiry(struct timer_list *);
 
 void rose_start_heartbeat(struct sock *sk)
 {
@@ -49,8 +49,7 @@ void rose_start_t1timer(struct sock *sk)
 
 	del_timer(&rose->timer);
 
-	rose->timer.data     = (unsigned long)sk;
-	rose->timer.function = &rose_timer_expiry;
+	rose->timer.function = (TIMER_FUNC_TYPE)rose_timer_expiry;
 	rose->timer.expires  = jiffies + rose->t1;
 
 	add_timer(&rose->timer);
@@ -62,8 +61,7 @@ void rose_start_t2timer(struct sock *sk)
 
 	del_timer(&rose->timer);
 
-	rose->timer.data     = (unsigned long)sk;
-	rose->timer.function = &rose_timer_expiry;
+	rose->timer.function = (TIMER_FUNC_TYPE)rose_timer_expiry;
 	rose->timer.expires  = jiffies + rose->t2;
 
 	add_timer(&rose->timer);
@@ -75,8 +73,7 @@ void rose_start_t3timer(struct sock *sk)
 
 	del_timer(&rose->timer);
 
-	rose->timer.data     = (unsigned long)sk;
-	rose->timer.function = &rose_timer_expiry;
+	rose->timer.function = (TIMER_FUNC_TYPE)rose_timer_expiry;
 	rose->timer.expires  = jiffies + rose->t3;
 
 	add_timer(&rose->timer);
@@ -88,8 +85,7 @@ void rose_start_hbtimer(struct sock *sk)
 
 	del_timer(&rose->timer);
 
-	rose->timer.data     = (unsigned long)sk;
-	rose->timer.function = &rose_timer_expiry;
+	rose->timer.function = (TIMER_FUNC_TYPE)rose_timer_expiry;
 	rose->timer.expires  = jiffies + rose->hb;
 
 	add_timer(&rose->timer);
@@ -102,8 +98,7 @@ void rose_start_idletimer(struct sock *s
 	del_timer(&rose->idletimer);
 
 	if (rose->idle > 0) {
-		rose->idletimer.data     = (unsigned long)sk;
-		rose->idletimer.function = &rose_idletimer_expiry;
+		rose->idletimer.function = (TIMER_FUNC_TYPE)rose_idletimer_expiry;
 		rose->idletimer.expires  = jiffies + rose->idle;
 
 		add_timer(&rose->idletimer);
@@ -163,10 +158,10 @@ static void rose_heartbeat_expiry(unsign
 	bh_unlock_sock(sk);
 }
 
-static void rose_timer_expiry(unsigned long param)
+static void rose_timer_expiry(struct timer_list *t)
 {
-	struct sock *sk = (struct sock *)param;
-	struct rose_sock *rose = rose_sk(sk);
+	struct rose_sock *rose = from_timer(rose, t, timer);
+	struct sock *sk = &rose->sock;
 
 	bh_lock_sock(sk);
 	switch (rose->state) {
@@ -192,9 +187,10 @@ static void rose_timer_expiry(unsigned l
 	bh_unlock_sock(sk);
 }
 
-static void rose_idletimer_expiry(unsigned long param)
+static void rose_idletimer_expiry(struct timer_list *t)
 {
-	struct sock *sk = (struct sock *)param;
+	struct rose_sock *rose = from_timer(rose, t, idletimer);
+	struct sock *sk = &rose->sock;
 
 	bh_lock_sock(sk);
 	rose_clear_queues(sk);


