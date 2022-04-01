Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564384EF0EC
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347783AbiDAOgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347421AbiDAOcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:32:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585481EC99C;
        Fri,  1 Apr 2022 07:29:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD903B8250D;
        Fri,  1 Apr 2022 14:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C22C340F2;
        Fri,  1 Apr 2022 14:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823340;
        bh=j9WdN/9Te1uDxMxf4k+nuh4Ft/G5q0vw4zAZWMlA4dU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ain7ZzLbfTDDa8RcCJ2T27qhPe4kZc/crlTVz4jThAjdShLq43CwexOCws4z7NJ6z
         j7jVCWW86fnI1J8Ad58bqd8irRr0mB5/KUQhE3ZTd+3p44kbDiu0gvaV8EFBKuLks0
         1nY0W9OtjjPO3K5h0lUBxResk4nLcFIZUfpRp6sGwMUuBji/fnNjUc1v7YMZqGw6dg
         2Ssh3wcDsSfHkfzG+bjtnKM3hSwTteRRJa5k49gqm93jN6PRWkVDJdrQHlC/yHH+sP
         N68qt4a2jgGkxQrsPqk7zKy1f4/THH2sLKAgptakidh0PVSjJu02k8SR+1MiJSdXse
         Z37uOzB4ZvN2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mike Galbraith <efault@gmx.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 064/149] tcp: Don't acquire inet_listen_hashbucket::lock with disabled BH.
Date:   Fri,  1 Apr 2022 10:24:11 -0400
Message-Id: <20220401142536.1948161-64-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 4f9bf2a2f5aacf988e6d5e56b961ba45c5a25248 ]

Commit
   9652dc2eb9e40 ("tcp: relax listening_hash operations")

removed the need to disable bottom half while acquiring
listening_hash.lock. There are still two callers left which disable
bottom half before the lock is acquired.

On PREEMPT_RT the softirqs are preemptible and local_bh_disable() acts
as a lock to ensure that resources, that are protected by disabling
bottom halves, remain protected.
This leads to a circular locking dependency if the lock acquired with
disabled bottom halves is also acquired with enabled bottom halves
followed by disabling bottom halves. This is the reverse locking order.
It has been observed with inet_listen_hashbucket::lock:

local_bh_disable() + spin_lock(&ilb->lock):
  inet_listen()
    inet_csk_listen_start()
      sk->sk_prot->hash() := inet_hash()
	local_bh_disable()
	__inet_hash()
	  spin_lock(&ilb->lock);
	    acquire(&ilb->lock);

Reverse order: spin_lock(&ilb2->lock) + local_bh_disable():
  tcp_seq_next()
    listening_get_next()
      spin_lock(&ilb2->lock);
	acquire(&ilb2->lock);

  tcp4_seq_show()
    get_tcp4_sock()
      sock_i_ino()
	read_lock_bh(&sk->sk_callback_lock);
	  acquire(softirq_ctrl)	// <---- whoops
	  acquire(&sk->sk_callback_lock)

Drop local_bh_disable() around __inet_hash() which acquires
listening_hash->lock. Split inet_unhash() and acquire the
listen_hashbucket lock without disabling bottom halves; the inet_ehash
lock with disabled bottom halves.

Reported-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lkml.kernel.org/r/12d6f9879a97cd56c09fb53dee343cbb14f7f1f7.camel@gmx.de
Link: https://lkml.kernel.org/r/X9CheYjuXWc75Spa@hirez.programming.kicks-ass.net
Link: https://lore.kernel.org/r/YgQOebeZ10eNx1W6@linutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_hashtables.c  | 53 ++++++++++++++++++++++---------------
 net/ipv6/inet6_hashtables.c |  5 +---
 2 files changed, 33 insertions(+), 25 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 30ab717ff1b8..17440840a791 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -637,7 +637,9 @@ int __inet_hash(struct sock *sk, struct sock *osk)
 	int err = 0;
 
 	if (sk->sk_state != TCP_LISTEN) {
+		local_bh_disable();
 		inet_ehash_nolisten(sk, osk, NULL);
+		local_bh_enable();
 		return 0;
 	}
 	WARN_ON(!sk_unhashed(sk));
@@ -669,45 +671,54 @@ int inet_hash(struct sock *sk)
 {
 	int err = 0;
 
-	if (sk->sk_state != TCP_CLOSE) {
-		local_bh_disable();
+	if (sk->sk_state != TCP_CLOSE)
 		err = __inet_hash(sk, NULL);
-		local_bh_enable();
-	}
 
 	return err;
 }
 EXPORT_SYMBOL_GPL(inet_hash);
 
-void inet_unhash(struct sock *sk)
+static void __inet_unhash(struct sock *sk, struct inet_listen_hashbucket *ilb)
 {
-	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
-	struct inet_listen_hashbucket *ilb = NULL;
-	spinlock_t *lock;
-
 	if (sk_unhashed(sk))
 		return;
 
-	if (sk->sk_state == TCP_LISTEN) {
-		ilb = &hashinfo->listening_hash[inet_sk_listen_hashfn(sk)];
-		lock = &ilb->lock;
-	} else {
-		lock = inet_ehash_lockp(hashinfo, sk->sk_hash);
-	}
-	spin_lock_bh(lock);
-	if (sk_unhashed(sk))
-		goto unlock;
-
 	if (rcu_access_pointer(sk->sk_reuseport_cb))
 		reuseport_stop_listen_sock(sk);
 	if (ilb) {
+		struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
+
 		inet_unhash2(hashinfo, sk);
 		ilb->count--;
 	}
 	__sk_nulls_del_node_init_rcu(sk);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
-unlock:
-	spin_unlock_bh(lock);
+}
+
+void inet_unhash(struct sock *sk)
+{
+	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
+
+	if (sk_unhashed(sk))
+		return;
+
+	if (sk->sk_state == TCP_LISTEN) {
+		struct inet_listen_hashbucket *ilb;
+
+		ilb = &hashinfo->listening_hash[inet_sk_listen_hashfn(sk)];
+		/* Don't disable bottom halves while acquiring the lock to
+		 * avoid circular locking dependency on PREEMPT_RT.
+		 */
+		spin_lock(&ilb->lock);
+		__inet_unhash(sk, ilb);
+		spin_unlock(&ilb->lock);
+	} else {
+		spinlock_t *lock = inet_ehash_lockp(hashinfo, sk->sk_hash);
+
+		spin_lock_bh(lock);
+		__inet_unhash(sk, NULL);
+		spin_unlock_bh(lock);
+	}
 }
 EXPORT_SYMBOL_GPL(inet_unhash);
 
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index 4514444e96c8..4740afecf7c6 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -333,11 +333,8 @@ int inet6_hash(struct sock *sk)
 {
 	int err = 0;
 
-	if (sk->sk_state != TCP_CLOSE) {
-		local_bh_disable();
+	if (sk->sk_state != TCP_CLOSE)
 		err = __inet_hash(sk, NULL);
-		local_bh_enable();
-	}
 
 	return err;
 }
-- 
2.34.1

