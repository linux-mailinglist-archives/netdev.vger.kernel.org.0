Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8CF84ADED1
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 18:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383616AbiBHRBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 12:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381616AbiBHRBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 12:01:44 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0662EC061578
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 09:01:44 -0800 (PST)
Date:   Tue, 8 Feb 2022 18:01:41 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644339702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=L32iZaEBXsS8v1MC8PoTrh7Ir1boWXnniuLY8R47Tj0=;
        b=fYFxSc1fg/N2WtX4hUeKpAYCaOzPpcxGCBeoDIf9GX27abTqsNYZUj8m6w4sWjA/FKuWUv
        RsH0lWKWEdHkCJHzKa3UzkEMXAnvHGKm3lWwaZcmNr/mQHZS8RgriNZ/0rQxqo4j94EH59
        WwEe0OyngbeSHGJ3Oaj1skyJlyAHx+Sa9rb0sg4Ut4YiHfP3iiwwFduYemYsxL+Flcppyq
        iymyX8RwnWpcCEx0ezPKrPYY0HGb0VAip3PDEdPsbiHQ3FMJsJ4ddFZKG7cJ3k8zvDli8t
        qSHj5ExkMPAoPIP0nCX1tpVYouwbqOIR8xgJ6rLk3SnvvQbGoxsGvpYAzaGhVA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644339702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=L32iZaEBXsS8v1MC8PoTrh7Ir1boWXnniuLY8R47Tj0=;
        b=6KwNKmMqqMQBg+8dNa39tqGCNzLgwhXbn+8RrduGC4WBavTEuCat1XlMZwIJHm3YmcCdbj
        nPWvHHyyLYA9gEAA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        eric.dumazet@gmail.com, davem@davemloft.net, dsahern@kernel.org,
        efault@gmx.de, tglx@linutronix.de, yoshfuji@linux-ipv6.org,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH net v3] tcp: Don't acquire inet_listen_hashbucket::lock with
 disabled BH.
Message-ID: <YgKh9fbQ2dcBu3e1@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
      sk->sk_prot->hash() :=3D inet_hash()
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
Link: https://lkml.kernel.org/r/12d6f9879a97cd56c09fb53dee343cbb14f7f1f7.ca=
mel@gmx.de
Link: https://lkml.kernel.org/r/X9CheYjuXWc75Spa@hirez.programming.kicks-as=
s.net
---
v2=E2=80=A6v3:
   - Update commit description with ilb2 instead ilb (requested by
     Martin KaFai Lau).

v1=E2=80=A6v2:=20
   Reposted with fixes and net-tree as requested. Please keep in mind that
   this only effects the PREEMPT_RT preemption model and I'm posting this
   as part of the merging efforts. Therefore I didn't add the Fixes: tag
   and used net-next as I didn't expect any -stable backports (but then
   Greg sometimes backports RT-only patches since "it makes the life of
   some folks easier" as he puts it).

 net/ipv4/inet_hashtables.c  |   53 ++++++++++++++++++++++++++-------------=
-----
 net/ipv6/inet6_hashtables.c |    5 ----
 2 files changed, 33 insertions(+), 25 deletions(-)

--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -637,7 +637,9 @@ int __inet_hash(struct sock *sk, struct
 	int err =3D 0;
=20
 	if (sk->sk_state !=3D TCP_LISTEN) {
+		local_bh_disable();
 		inet_ehash_nolisten(sk, osk, NULL);
+		local_bh_enable();
 		return 0;
 	}
 	WARN_ON(!sk_unhashed(sk));
@@ -669,45 +671,54 @@ int inet_hash(struct sock *sk)
 {
 	int err =3D 0;
=20
-	if (sk->sk_state !=3D TCP_CLOSE) {
-		local_bh_disable();
+	if (sk->sk_state !=3D TCP_CLOSE)
 		err =3D __inet_hash(sk, NULL);
-		local_bh_enable();
-	}
=20
 	return err;
 }
 EXPORT_SYMBOL_GPL(inet_hash);
=20
-void inet_unhash(struct sock *sk)
+static void __inet_unhash(struct sock *sk, struct inet_listen_hashbucket *=
ilb)
 {
-	struct inet_hashinfo *hashinfo =3D sk->sk_prot->h.hashinfo;
-	struct inet_listen_hashbucket *ilb =3D NULL;
-	spinlock_t *lock;
-
 	if (sk_unhashed(sk))
 		return;
=20
-	if (sk->sk_state =3D=3D TCP_LISTEN) {
-		ilb =3D &hashinfo->listening_hash[inet_sk_listen_hashfn(sk)];
-		lock =3D &ilb->lock;
-	} else {
-		lock =3D inet_ehash_lockp(hashinfo, sk->sk_hash);
-	}
-	spin_lock_bh(lock);
-	if (sk_unhashed(sk))
-		goto unlock;
-
 	if (rcu_access_pointer(sk->sk_reuseport_cb))
 		reuseport_stop_listen_sock(sk);
 	if (ilb) {
+		struct inet_hashinfo *hashinfo =3D sk->sk_prot->h.hashinfo;
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
+	struct inet_hashinfo *hashinfo =3D sk->sk_prot->h.hashinfo;
+
+	if (sk_unhashed(sk))
+		return;
+
+	if (sk->sk_state =3D=3D TCP_LISTEN) {
+		struct inet_listen_hashbucket *ilb;
+
+		ilb =3D &hashinfo->listening_hash[inet_sk_listen_hashfn(sk)];
+		/* Don't disable bottom halves while acquiring the lock to
+		 * avoid circular locking dependency on PREEMPT_RT.
+		 */
+		spin_lock(&ilb->lock);
+		__inet_unhash(sk, ilb);
+		spin_unlock(&ilb->lock);
+	} else {
+		spinlock_t *lock =3D inet_ehash_lockp(hashinfo, sk->sk_hash);
+
+		spin_lock_bh(lock);
+		__inet_unhash(sk, NULL);
+		spin_unlock_bh(lock);
+	}
 }
 EXPORT_SYMBOL_GPL(inet_unhash);
=20
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -333,11 +333,8 @@ int inet6_hash(struct sock *sk)
 {
 	int err =3D 0;
=20
-	if (sk->sk_state !=3D TCP_CLOSE) {
-		local_bh_disable();
+	if (sk->sk_state !=3D TCP_CLOSE)
 		err =3D __inet_hash(sk, NULL);
-		local_bh_enable();
-	}
=20
 	return err;
 }
