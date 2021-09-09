Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6674051CA
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353455AbhIIMig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:38:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352939AbhIIMd5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:33:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E99561B4F;
        Thu,  9 Sep 2021 11:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188409;
        bh=JkjHzb2IXx1DMQfODn17W6AP5tiBSMMmVi6CHfo4fSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L0g22sEk6+5BlF0NpDTWE6IsN97fcKxmHwwBlQa9JHOuq0A3ZbH3XcwLbA1pFNWW/
         PEwcMC0GVFy4xOOIXKngsGDFtET3gN20NL7oTLjAysTZoEq5hzkkRJw6xECEElPCyx
         aKeo12F9gAQuNUtqHlsR/3QvaZOlCgpc0TjKfWUdR3OC/6dwfRDqvUc0FZhJ6SNxjO
         a7znbYtr91S25ZYS2iDhlpGtGIdEFFcPt/mgKTgvlcvKvlm0MfrdpD8MZCnmkj9Wew
         MmT8ZMJrsuw44vsu+CeCa7PNbLizPJXnY63OzKTbkXEZecgYJoshmu3gAROr7shxSQ
         fc0Dt9cHzVOMg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 101/176] Bluetooth: schedule SCO timeouts with delayed_work
Date:   Thu,  9 Sep 2021 07:50:03 -0400
Message-Id: <20210909115118.146181-101-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>

[ Upstream commit ba316be1b6a00db7126ed9a39f9bee434a508043 ]

struct sock.sk_timer should be used as a sock cleanup timer. However,
SCO uses it to implement sock timeouts.

This causes issues because struct sock.sk_timer's callback is run in
an IRQ context, and the timer callback function sco_sock_timeout takes
a spin lock on the socket. However, other functions such as
sco_conn_del and sco_conn_ready take the spin lock with interrupts
enabled.

This inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} lock usage could
lead to deadlocks as reported by Syzbot [1]:
       CPU0
       ----
  lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
  <Interrupt>
    lock(slock-AF_BLUETOOTH-BTPROTO_SCO);

To fix this, we use delayed work to implement SCO sock timouts
instead. This allows us to avoid taking the spin lock on the socket in
an IRQ context, and corrects the misuse of struct sock.sk_timer.

As a note, cancel_delayed_work is used instead of
cancel_delayed_work_sync in sco_sock_set_timer and
sco_sock_clear_timer to avoid a deadlock. In the future, the call to
bh_lock_sock inside sco_sock_timeout should be changed to lock_sock to
synchronize with other functions using lock_sock. However, since
sco_sock_set_timer and sco_sock_clear_timer are sometimes called under
the locked socket (in sco_connect and __sco_sock_close),
cancel_delayed_work_sync might cause them to sleep until an
sco_sock_timeout that has started finishes running. But
sco_sock_timeout would also sleep until it can grab the lock_sock.

Using cancel_delayed_work is fine because sco_sock_timeout does not
change from run to run, hence there is no functional difference
between:
1. waiting for a timeout to finish running before scheduling another
timeout
2. scheduling another timeout while a timeout is running.

Link: https://syzkaller.appspot.com/bug?id=9089d89de0502e120f234ca0fc8a703f7368b31e [1]
Reported-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
Tested-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/sco.c | 35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 22a110f37abc..8f4389370d33 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -48,6 +48,8 @@ struct sco_conn {
 	spinlock_t	lock;
 	struct sock	*sk;
 
+	struct delayed_work	timeout_work;
+
 	unsigned int    mtu;
 };
 
@@ -74,9 +76,20 @@ struct sco_pinfo {
 #define SCO_CONN_TIMEOUT	(HZ * 40)
 #define SCO_DISCONN_TIMEOUT	(HZ * 2)
 
-static void sco_sock_timeout(struct timer_list *t)
+static void sco_sock_timeout(struct work_struct *work)
 {
-	struct sock *sk = from_timer(sk, t, sk_timer);
+	struct sco_conn *conn = container_of(work, struct sco_conn,
+					     timeout_work.work);
+	struct sock *sk;
+
+	sco_conn_lock(conn);
+	sk = conn->sk;
+	if (sk)
+		sock_hold(sk);
+	sco_conn_unlock(conn);
+
+	if (!sk)
+		return;
 
 	BT_DBG("sock %p state %d", sk, sk->sk_state);
 
@@ -91,14 +104,21 @@ static void sco_sock_timeout(struct timer_list *t)
 
 static void sco_sock_set_timer(struct sock *sk, long timeout)
 {
+	if (!sco_pi(sk)->conn)
+		return;
+
 	BT_DBG("sock %p state %d timeout %ld", sk, sk->sk_state, timeout);
-	sk_reset_timer(sk, &sk->sk_timer, jiffies + timeout);
+	cancel_delayed_work(&sco_pi(sk)->conn->timeout_work);
+	schedule_delayed_work(&sco_pi(sk)->conn->timeout_work, timeout);
 }
 
 static void sco_sock_clear_timer(struct sock *sk)
 {
+	if (!sco_pi(sk)->conn)
+		return;
+
 	BT_DBG("sock %p state %d", sk, sk->sk_state);
-	sk_stop_timer(sk, &sk->sk_timer);
+	cancel_delayed_work(&sco_pi(sk)->conn->timeout_work);
 }
 
 /* ---- SCO connections ---- */
@@ -179,6 +199,9 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
 		bh_unlock_sock(sk);
 		sco_sock_kill(sk);
 		sock_put(sk);
+
+		/* Ensure no more work items will run before freeing conn. */
+		cancel_delayed_work_sync(&conn->timeout_work);
 	}
 
 	hcon->sco_data = NULL;
@@ -193,6 +216,8 @@ static void __sco_chan_add(struct sco_conn *conn, struct sock *sk,
 	sco_pi(sk)->conn = conn;
 	conn->sk = sk;
 
+	INIT_DELAYED_WORK(&conn->timeout_work, sco_sock_timeout);
+
 	if (parent)
 		bt_accept_enqueue(parent, sk, true);
 }
@@ -500,8 +525,6 @@ static struct sock *sco_sock_alloc(struct net *net, struct socket *sock,
 
 	sco_pi(sk)->setting = BT_VOICE_CVSD_16BIT;
 
-	timer_setup(&sk->sk_timer, sco_sock_timeout, 0);
-
 	bt_sock_link(&sco_sk_list, sk);
 	return sk;
 }
-- 
2.30.2

