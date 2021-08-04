Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593FD3DFFCF
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 13:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237759AbhHDLEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 07:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237728AbhHDLED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 07:04:03 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB574C0613D5;
        Wed,  4 Aug 2021 04:03:50 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso2975962pjf.4;
        Wed, 04 Aug 2021 04:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=srAeYY/EiQIT3OULRf8vlai9yqHxF+kaop05ae2z79I=;
        b=RGgUEIqv7EX3sOd8lMSiTQDivsxOgCMUFZDXh5+/jjewhAEgrysmVO+ACv84Gf2w+A
         nQvFXo5L5BeKS/AclyuD/jDVzlU8JHSUx4LkDfkP7IJXcPbZ/iswMHVf1PeLe70q2To6
         0njJsUWQCZxsr3L0PIe49RDhHRk+f7qhlKmtQ0la10XXrC2nWaK5lLP4kaUyskd9M7vU
         PsAbUjFV6XCKlq9spLCty/nSROfI3o8y38vWlv+3ffgaNpczEc3OK1XOje8itSD3U03z
         diDle0TVvD0uA08W8tWF1IKt+efuaEvVqhyLK7YpVS+wm6pi44fQTcyvrg9wkfNG+ZLj
         1s9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=srAeYY/EiQIT3OULRf8vlai9yqHxF+kaop05ae2z79I=;
        b=T60x0ZgDShcNkuGbXjz86CShLXYgULZaNbMePPKDao3XY8i5ZOB4PBF+Z0lBNd3+Nr
         bkKwsRd+7l2z9TTUGAv14ShN5/Ga1NlsdIVSjB1GieClg8cQ9Lc11nqtSMeH/iOblsgs
         UtaZjuYnig4/wo6Zrw/ce2edlrKHwxJ2lVvCPYrYCp546YBYBJ7ILdBIX/gGsDFbLEHv
         MFUTRrmWAfmUypk6f6qJFJCOCNLCIrVerF1VeCNUyxT6NQql+4U42r9Hwb3Xpa8c3Z4K
         IBZRDgG15H9Eg5jX/Tcpt2nuMDKQWof7ak69FnUkcienvYN1C5HflWKr0o2gROZLQUhy
         3RVA==
X-Gm-Message-State: AOAM533XhWvI8om8WmY6WOqtZKHsRUkH6htGI/bUw3sxkXm1SlRi7kD7
        lOo881IeEHU2TuGo2ER+Yfs=
X-Google-Smtp-Source: ABdhPJw+OpqNnmqZmZ5BJkWvuLH5QpMKkTC47+FumpiJAWxcQOjVU/x/c2N0mXuzUKoSrM9tSOIZlw==
X-Received: by 2002:a17:90a:c57:: with SMTP id u23mr9270081pje.186.1628075030416;
        Wed, 04 Aug 2021 04:03:50 -0700 (PDT)
Received: from localhost.localdomain ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id k4sm2206147pjs.55.2021.08.04.04.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 04:03:50 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org, sudipm.mukherjee@gmail.com
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
Subject: [PATCH v5 1/6] Bluetooth: schedule SCO timeouts with delayed_work
Date:   Wed,  4 Aug 2021 19:03:03 +0800
Message-Id: <20210804110308.910744-2-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804110308.910744-1-desmondcheongzx@gmail.com>
References: <20210804110308.910744-1-desmondcheongzx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 net/bluetooth/sco.c | 41 +++++++++++++++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index ffa2a77a3e4c..89cb987ca9eb 100644
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
 
@@ -91,14 +104,27 @@ static void sco_sock_timeout(struct timer_list *t)
 
 static void sco_sock_set_timer(struct sock *sk, long timeout)
 {
+	struct delayed_work *work;
+
+	if (!sco_pi(sk)->conn)
+		return;
+	work = &sco_pi(sk)->conn->timeout_work;
+
 	BT_DBG("sock %p state %d timeout %ld", sk, sk->sk_state, timeout);
-	sk_reset_timer(sk, &sk->sk_timer, jiffies + timeout);
+	cancel_delayed_work(work);
+	schedule_delayed_work(work, timeout);
 }
 
 static void sco_sock_clear_timer(struct sock *sk)
 {
+	struct delayed_work *work;
+
+	if (!sco_pi(sk)->conn)
+		return;
+	work = &sco_pi(sk)->conn->timeout_work;
+
 	BT_DBG("sock %p state %d", sk, sk->sk_state);
-	sk_stop_timer(sk, &sk->sk_timer);
+	cancel_delayed_work(work);
 }
 
 /* ---- SCO connections ---- */
@@ -179,6 +205,9 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
 		bh_unlock_sock(sk);
 		sco_sock_kill(sk);
 		sock_put(sk);
+
+		/* Ensure no more work items will run before freeing conn. */
+		cancel_delayed_work_sync(&conn->timeout_work);
 	}
 
 	hcon->sco_data = NULL;
@@ -193,6 +222,8 @@ static void __sco_chan_add(struct sco_conn *conn, struct sock *sk,
 	sco_pi(sk)->conn = conn;
 	conn->sk = sk;
 
+	INIT_DELAYED_WORK(&conn->timeout_work, sco_sock_timeout);
+
 	if (parent)
 		bt_accept_enqueue(parent, sk, true);
 }
@@ -500,8 +531,6 @@ static struct sock *sco_sock_alloc(struct net *net, struct socket *sock,
 
 	sco_pi(sk)->setting = BT_VOICE_CVSD_16BIT;
 
-	timer_setup(&sk->sk_timer, sco_sock_timeout, 0);
-
 	bt_sock_link(&sco_sk_list, sk);
 	return sk;
 }
-- 
2.25.1

