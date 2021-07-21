Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0AF3D0C29
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 12:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237463AbhGUJTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 05:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236422AbhGUI6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 04:58:38 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE815C061766;
        Wed, 21 Jul 2021 02:39:07 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id y17so1306815pgf.12;
        Wed, 21 Jul 2021 02:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k2mLgBDMkGUQBCzSqER4QTCbdvyrdYf6Xh8AVOpZnfA=;
        b=ArZINa6/qI3WjclTauQmOlJBrbzAMYikrIoXzATfH4tpPwAuGtISWHbSimJ5bG5Kef
         xM5N1f9hVofqmrTgwtKgjPq5H8PB57RmQQCYGz1HTckWQ1KkqWH3jxLrmNNDMtNwf70w
         UxgOCyuWpqPL95r4xuG4CB3ClLuhG2suK2v0caTs2wzMt7BhjvV1zTQtsBSnbIQO5l2S
         F9Q6ZS3Cdp34UlAGmY0+pS+1ynGqgrHYkEpW6lhW8/Jgt0npqrKiRmuIZeyEHPljGqxx
         FFCIgbMqDov3n07kNA1QaZD/UkMKYQJXCPWdTspMTMAr7/v1f4m1zsuseWa4QMeYui+W
         Az/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k2mLgBDMkGUQBCzSqER4QTCbdvyrdYf6Xh8AVOpZnfA=;
        b=hOcDxxYyEmCJcMiCXfO+3fUDBl2vVwcfS82B1tFF3vfbZSNOr7vhQ81fta1w6UMak9
         FEog3zuSfhO9c4BNUpRJoPpbwbBSOQ4BBTF+Z/rKLmhu3mP464suyxjLdtX+kZXw23q5
         mqZ2mHyu0TBoLKjUBhAuU82izvIEQoVPhJ2jHvKV1tw9HcrzryYqft3Kw3v39rdMGy2/
         vHqr3eoN2stIgDIUXnDS0+NDvtt+8pSqL1cchNIDFyU/mbiAy6660GNeNUIBlEtos5FC
         4AsFYoGnH9m9POS6rkGfNHWJmZfxADLNbrNAcRLjRAAJn+z3Z8PwsLmb0/pLKA3uAG6+
         fraw==
X-Gm-Message-State: AOAM533x9Qk30E54aqJP9LIJMkzg7KdJG8UAAMrAcavRIkFdqClwg7Vw
        NyPAZE2oK5xWFwOYmE80o24=
X-Google-Smtp-Source: ABdhPJwBTejj1XHrX4y16hWCM4hlBtLGRRRXmK1BYT/mRVpTxnfWRRPZGaq1F2YsM8xhjWqOj3M4zg==
X-Received: by 2002:a63:f40e:: with SMTP id g14mr35216908pgi.158.1626860347326;
        Wed, 21 Jul 2021 02:39:07 -0700 (PDT)
Received: from localhost.localdomain ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id j129sm27311956pfb.132.2021.07.21.02.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 02:39:06 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        stefan@datenfreihafen.org
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
Subject: [PATCH v3 1/2] Bluetooth: fix inconsistent lock state in SCO
Date:   Wed, 21 Jul 2021 17:38:31 +0800
Message-Id: <20210721093832.78081-2-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210721093832.78081-1-desmondcheongzx@gmail.com>
References: <20210721093832.78081-1-desmondcheongzx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported an inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} lock
usage in sco_conn_del and sco_sock_timeout that could lead to
deadlocks.

This inconsistent lock state can also happen in sco_conn_ready,
rfcomm_connect_ind, and bt_accept_enqueue.

The issue is that these functions take a spin lock on the socket with
interrupts enabled, but sco_sock_timeout takes the lock in an IRQ
context. This could lead to deadlocks:

       CPU0
       ----
  lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
  <Interrupt>
    lock(slock-AF_BLUETOOTH-BTPROTO_SCO);

 *** DEADLOCK ***

We fix this by ensuring that local bh is disabled before calling
bh_lock_sock.

After doing this, we additionally need to protect sco_conn_lock by
disabling local bh.

This is necessary because sco_conn_del makes a call to sco_chan_del
while holding on to the sock lock, and sco_chan_del itself makes a
call to sco_conn_lock. If sco_conn_lock is held elsewhere with
interrupts enabled, there could still be a
slock-AF_BLUETOOTH-BTPROTO_SCO --> &conn->lock#2 lock inversion as
follows:

        CPU0                    CPU1
        ----                    ----
   lock(&conn->lock#2);
                                local_irq_disable();
                                lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
                                lock(&conn->lock#2);
   <Interrupt>
     lock(slock-AF_BLUETOOTH-BTPROTO_SCO);

  *** DEADLOCK ***

Although sco_conn_del disables local bh before calling sco_chan_del,
we can still wrap the calls to sco_conn_lock in sco_chan_del, with
local_bh_disable/enable as this pair of functions are reentrant.

Reported-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
Tested-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
---
 net/bluetooth/sco.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 3bd41563f118..34f3419c3330 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -140,10 +140,12 @@ static void sco_chan_del(struct sock *sk, int err)
 	BT_DBG("sk %p, conn %p, err %d", sk, conn, err);
 
 	if (conn) {
+		local_bh_disable();
 		sco_conn_lock(conn);
 		conn->sk = NULL;
 		sco_pi(sk)->conn = NULL;
 		sco_conn_unlock(conn);
+		local_bh_enable();
 
 		if (conn->hcon)
 			hci_conn_drop(conn->hcon);
@@ -167,16 +169,22 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
 	BT_DBG("hcon %p conn %p, err %d", hcon, conn, err);
 
 	/* Kill socket */
+	local_bh_disable();
 	sco_conn_lock(conn);
 	sk = conn->sk;
 	sco_conn_unlock(conn);
+	local_bh_enable();
 
 	if (sk) {
 		sock_hold(sk);
+
+		local_bh_disable();
 		bh_lock_sock(sk);
 		sco_sock_clear_timer(sk);
 		sco_chan_del(sk, err);
 		bh_unlock_sock(sk);
+		local_bh_enable();
+
 		sco_sock_kill(sk);
 		sock_put(sk);
 	}
@@ -202,6 +210,7 @@ static int sco_chan_add(struct sco_conn *conn, struct sock *sk,
 {
 	int err = 0;
 
+	local_bh_disable();
 	sco_conn_lock(conn);
 	if (conn->sk)
 		err = -EBUSY;
@@ -209,6 +218,7 @@ static int sco_chan_add(struct sco_conn *conn, struct sock *sk,
 		__sco_chan_add(conn, sk, parent);
 
 	sco_conn_unlock(conn);
+	local_bh_enable();
 	return err;
 }
 
@@ -303,9 +313,11 @@ static void sco_recv_frame(struct sco_conn *conn, struct sk_buff *skb)
 {
 	struct sock *sk;
 
+	local_bh_disable();
 	sco_conn_lock(conn);
 	sk = conn->sk;
 	sco_conn_unlock(conn);
+	local_bh_enable();
 
 	if (!sk)
 		goto drop;
@@ -420,10 +432,12 @@ static void __sco_sock_close(struct sock *sk)
 		if (sco_pi(sk)->conn->hcon) {
 			sk->sk_state = BT_DISCONN;
 			sco_sock_set_timer(sk, SCO_DISCONN_TIMEOUT);
+			local_bh_disable();
 			sco_conn_lock(sco_pi(sk)->conn);
 			hci_conn_drop(sco_pi(sk)->conn->hcon);
 			sco_pi(sk)->conn->hcon = NULL;
 			sco_conn_unlock(sco_pi(sk)->conn);
+			local_bh_enable();
 		} else
 			sco_chan_del(sk, ECONNRESET);
 		break;
@@ -1084,21 +1098,26 @@ static void sco_conn_ready(struct sco_conn *conn)
 
 	if (sk) {
 		sco_sock_clear_timer(sk);
+		local_bh_disable();
 		bh_lock_sock(sk);
 		sk->sk_state = BT_CONNECTED;
 		sk->sk_state_change(sk);
 		bh_unlock_sock(sk);
+		local_bh_enable();
 	} else {
+		local_bh_disable();
 		sco_conn_lock(conn);
 
 		if (!conn->hcon) {
 			sco_conn_unlock(conn);
+			local_bh_enable();
 			return;
 		}
 
 		parent = sco_get_sock_listen(&conn->hcon->src);
 		if (!parent) {
 			sco_conn_unlock(conn);
+			local_bh_enable();
 			return;
 		}
 
@@ -1109,6 +1128,7 @@ static void sco_conn_ready(struct sco_conn *conn)
 		if (!sk) {
 			bh_unlock_sock(parent);
 			sco_conn_unlock(conn);
+			local_bh_enable();
 			return;
 		}
 
@@ -1131,6 +1151,7 @@ static void sco_conn_ready(struct sco_conn *conn)
 		bh_unlock_sock(parent);
 
 		sco_conn_unlock(conn);
+		local_bh_enable();
 	}
 }
 
-- 
2.25.1

