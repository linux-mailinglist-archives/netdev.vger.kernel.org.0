Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 483323C747F
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 18:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbhGMQcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 12:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbhGMQcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 12:32:04 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1375C0613DD;
        Tue, 13 Jul 2021 09:29:13 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id b5-20020a17090a9905b029016fc06f6c5bso2464423pjp.5;
        Tue, 13 Jul 2021 09:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0if1JKGz6Y+FvBAbIJIXUcoRPTBbCA20QOj+Wr5C6ZA=;
        b=oDvHV80APNi2CCXFUVu82VLZOUFwYr5tsWH4aMZJ46xkF2BXqKfPcpLgYo10OiQ1KN
         MdFS/GxucV+VTgbkIwW03WFOAxWHIB1ABVwtpgXZ+qKgBV6J/Y7LhKIwe1aK2J6mpDaB
         iKHkRHZUzdXV9k3dfs/WitHRz0MRncWxfNT765ztasMS8E+uVjLtjd3QehJNy+tioGsS
         b/pA3rDNy9O7WNTTab5OwJWRvKGUqjbsb9YG7NcxvxLbgathM2Mr7dLuw3ooD6c7GV5o
         2rz8HJ8b/00YeYIx/gHH6npnpGk/N7fuqaOaIKi5pyf6qvpyG5QJzbG25nMtWmwkX///
         NQzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0if1JKGz6Y+FvBAbIJIXUcoRPTBbCA20QOj+Wr5C6ZA=;
        b=DsFLWScx+PmMKRA2YKchsQ6/hV60daObDjWIGg17xM/AI5/tJ+i/O6Q9DBX232wxzY
         0rHMCJ4jjwQiZypi4Z/Ov+ihWN1UE3S9nuRSLFA3BYfdNqnI8oS0F1JpiFeoWQxqQ13f
         bWvDhjCskLT8yI1+UfwUIjYWXfI/holbaK+8rzE5YDuXviz2z+BXtvIgUIYOIVGp522O
         k5E3Jh8m6cP5yM5z9gL5LeEETuFNCbIOpO1pazrSxYGGg3X3gp6l6xbtgN/kAIWiliGL
         ekqMMMU5ZTFeUu+rxeggEd9OWWyhcFpF1qMzie5ZiFceH5oT5EU1EIcAVY4BOjQKMAnA
         gpfg==
X-Gm-Message-State: AOAM531Y/1XLpnPqasGj7cxeN57gA282gpFXFT1AJr+7eGWozbkcFpUX
        73sQHyZbUhjpYuRpqRv3kic=
X-Google-Smtp-Source: ABdhPJz6v3FuQLY/R/FqBGyR1r2uQhUl0i7qarzPr6/Ir5EdlkqZ2FxD8rc/YLfFPehCSv3r3TvJnw==
X-Received: by 2002:a17:902:aa86:b029:116:3e3a:2051 with SMTP id d6-20020a170902aa86b02901163e3a2051mr4076009plr.38.1626193753280;
        Tue, 13 Jul 2021 09:29:13 -0700 (PDT)
Received: from localhost.localdomain ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id oj4sm2979413pjb.56.2021.07.13.09.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 09:29:12 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org, stefan@datenfreihafen.org
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
Subject: [PATCH v2] Bluetooth: fix inconsistent lock state in sco
Date:   Wed, 14 Jul 2021 00:28:38 +0800
Message-Id: <20210713162838.693266-1-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
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

As sco_conn_del now disables local bh before calling sco_chan_del,
instead of disabling local bh for the calls to sco_conn_lock in
sco_chan_del, we instead wrap other calls to sco_chan_del with
local_bh_disable/enable.

Reported-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
Tested-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
---

Hi,

The previous version of this patch was a bit of a mess, so I made the
following changes.

v1 -> v2:
- Instead of pulling out the clean-up code out from sco_chan_del and
using it directly in sco_conn_del, disable local irqs for relevant
sections.
- Disable local irqs more thoroughly for instances of
bh_lock_sock/bh_lock_sock_nested in the bluetooth subsystem.
Specifically, the calls in af_bluetooth.c and rfcomm/sock.c are now made
with local irqs disabled as well.

Best wishes,
Desmond

 net/bluetooth/rfcomm/sock.c |  2 ++
 net/bluetooth/sco.c         | 26 +++++++++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index ae6f80730561..d8734abb2df4 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -974,6 +974,7 @@ int rfcomm_connect_ind(struct rfcomm_session *s, u8 channel, struct rfcomm_dlc *
 	if (!parent)
 		return 0;
 
+	local_bh_disable();
 	bh_lock_sock(parent);
 
 	/* Check for backlog size */
@@ -1002,6 +1003,7 @@ int rfcomm_connect_ind(struct rfcomm_session *s, u8 channel, struct rfcomm_dlc *
 
 done:
 	bh_unlock_sock(parent);
+	local_bh_enable();
 
 	if (test_bit(BT_SK_DEFER_SETUP, &bt_sk(parent)->flags))
 		parent->sk_state_change(parent);
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 3bd41563f118..2548b8f81473 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -167,16 +167,22 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
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
@@ -202,6 +208,7 @@ static int sco_chan_add(struct sco_conn *conn, struct sock *sk,
 {
 	int err = 0;
 
+	local_bh_disable();
 	sco_conn_lock(conn);
 	if (conn->sk)
 		err = -EBUSY;
@@ -209,6 +216,7 @@ static int sco_chan_add(struct sco_conn *conn, struct sock *sk,
 		__sco_chan_add(conn, sk, parent);
 
 	sco_conn_unlock(conn);
+	local_bh_enable();
 	return err;
 }
 
@@ -303,9 +311,11 @@ static void sco_recv_frame(struct sco_conn *conn, struct sk_buff *skb)
 {
 	struct sock *sk;
 
+	local_bh_disable();
 	sco_conn_lock(conn);
 	sk = conn->sk;
 	sco_conn_unlock(conn);
+	local_bh_enable();
 
 	if (!sk)
 		goto drop;
@@ -420,18 +430,25 @@ static void __sco_sock_close(struct sock *sk)
 		if (sco_pi(sk)->conn->hcon) {
 			sk->sk_state = BT_DISCONN;
 			sco_sock_set_timer(sk, SCO_DISCONN_TIMEOUT);
+			local_bh_disable();
 			sco_conn_lock(sco_pi(sk)->conn);
 			hci_conn_drop(sco_pi(sk)->conn->hcon);
 			sco_pi(sk)->conn->hcon = NULL;
 			sco_conn_unlock(sco_pi(sk)->conn);
-		} else
+			local_bh_enable();
+		} else {
+			local_bh_disable();
 			sco_chan_del(sk, ECONNRESET);
+			local_bh_enable();
+		}
 		break;
 
 	case BT_CONNECT2:
 	case BT_CONNECT:
 	case BT_DISCONN:
+		local_bh_disable();
 		sco_chan_del(sk, ECONNRESET);
+		local_bh_enable();
 		break;
 
 	default:
@@ -1084,21 +1101,26 @@ static void sco_conn_ready(struct sco_conn *conn)
 
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
 
@@ -1109,6 +1131,7 @@ static void sco_conn_ready(struct sco_conn *conn)
 		if (!sk) {
 			bh_unlock_sock(parent);
 			sco_conn_unlock(conn);
+			local_bh_enable();
 			return;
 		}
 
@@ -1131,6 +1154,7 @@ static void sco_conn_ready(struct sco_conn *conn)
 		bh_unlock_sock(parent);
 
 		sco_conn_unlock(conn);
+		local_bh_enable();
 	}
 }
 
-- 
2.25.1

