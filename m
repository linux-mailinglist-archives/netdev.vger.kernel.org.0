Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E123B5A0D
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 09:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbhF1Hwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 03:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbhF1Hwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 03:52:38 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9657CC061574;
        Mon, 28 Jun 2021 00:50:13 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id c8so13424189pfp.5;
        Mon, 28 Jun 2021 00:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a9SnhaSC0KGtJA4jbcNzI1RmFExj/PoChJSbMbViqHo=;
        b=SlBZfW/vVWkuCoPhugNlcjB4fJuggEiyWrFbzXOSBp0G7zrKUI/R531RyHgcoG8efT
         xMZRK6yAyqGWqh6LYzljI4DeFQA6oX0HXvbVZiflZqrioI0gcIFrYOmwvNwC+87d4SbO
         NJBa4WTI/IOXtT7RPXxYE5OfokS/CmNnGGm8fCay/OWPwkl7L3GQ27x0aeMElR28679S
         jmhnHhLXd6cdg+2kzk9jbWHc4Djt1aagDnGCpDyux6srGhw/DsjbElHyZkCzY1B+UOMK
         prjZCWbYlh6BlTl6D0YBgmoYDCpNn/zSsUvf9ifiRhd2nQzDTtjAjpJRJVd6DAU21lzH
         QC1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a9SnhaSC0KGtJA4jbcNzI1RmFExj/PoChJSbMbViqHo=;
        b=pIsiLEP/7dSkozWCBaxSz2VxR1szpukwInDRZSPLfce8XC/IqDup4dYuI7SC8LNfPF
         E0Z7CmgQgRTF9v6n4zH6Ri8kssH6xdyAYSxzFJJYOYQU6BVU9zgMqxNW43A1Mhk/Y6A5
         DT36NFZdsNfVUbaYWWxW/7XP6ZU2LESS5rf60KKuPx3EYA1CetGepAvjt88+bNyDqELV
         jOeZFZrvQeFwL8wSUOdywYVBytxefM4iVSZ14Ae8vAuPAoWER/6+l0kp8qdbmHrV2xAD
         /BxzQmGFKixJHIPwFmpXjgfZbIPunT24keVPKj97h/H1efxVubPfF8OFvETaC/8T3qru
         mUWQ==
X-Gm-Message-State: AOAM531P96fqLelzBjNX3xzat4OgecncH1w0s1IRKhO3Xx4gya1HkEHT
        /aZ9YBcsSk6ulnFRA+Ze92Q=
X-Google-Smtp-Source: ABdhPJzmLptl5YBBhs4A80NLCSgl3oM4vlhA0HLGNblaK7RuNiVK3F/VD3Cb07Y/TvBgBZzt9AUuaw==
X-Received: by 2002:a65:6555:: with SMTP id a21mr5312004pgw.53.1624866613181;
        Mon, 28 Jun 2021 00:50:13 -0700 (PDT)
Received: from localhost.localdomain ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id c24sm14519028pgj.11.2021.06.28.00.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 00:50:12 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
Subject: [PATCH] Bluetooth: fix inconsistent lock state in sco
Date:   Mon, 28 Jun 2021 15:48:34 +0800
Message-Id: <20210628074834.161640-1-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported an inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} lock
usage in sco_conn_del and sco_sock_timeout that could lead to
deadlocks:
https://syzkaller.appspot.com/bug?id=9089d89de0502e120f234ca0fc8a703f7368b31e

This inconsistent lock state can also happen between sco_conn_ready
and sco_sock_timeout.

The issue is that these three functions take a spin lock on the
socket, but sco_sock_timeout is called from an IRQ context. Since
bh_lock_sock calls spin_lock but does not disable softirqs, this could
lead to deadlocks:

       CPU0
       ----
  lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
  <Interrupt>
    lock(slock-AF_BLUETOOTH-BTPROTO_SCO);

 *** DEADLOCK ***

We fix this by replacing bh_lock_sock with spin_lock_bh in
sco_conn_del and sco_conn_ready.

Additionally, to avoid regressions, we pull the clean-up code out from
sco_chan_del and use it directly in sco_conn_del. This is necessary
because sco_chan_del makes a call to sco_conn_lock which takes an
SOFTIRQ-unsafe lock. This means that calling sco_chan_del while
holding the socket lock would result in a SOFTIRQ-safe ->
SOFTIRQ-unsafe lock hierarchy between slock-AF_BLUETOOTH-BTPROTO_SCO
and &conn->lock#2. This could lead to a deadlock as well:

        CPU0                    CPU1
        ----                    ----
   lock(&conn->lock#2);
                                local_irq_disable();
                                lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
                                lock(&conn->lock#2);
   <Interrupt>
     lock(slock-AF_BLUETOOTH-BTPROTO_SCO);

  *** DEADLOCK ***

Pulling out the code from sco_chan_del allows us to avoid this lock
dependency by holding the two locks for only their required critical
sections.

Reported-and-tested-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
---
 net/bluetooth/sco.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 3bd41563f118..d05629d7cc55 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -173,10 +173,22 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
 
 	if (sk) {
 		sock_hold(sk);
-		bh_lock_sock(sk);
+
+		spin_lock_bh(&sk->sk_lock.slock);
 		sco_sock_clear_timer(sk);
-		sco_chan_del(sk, err);
-		bh_unlock_sock(sk);
+		sco_pi(sk)->conn = NULL;
+		if (conn->hcon)
+			hci_conn_drop(conn->hcon);
+		sk->sk_state = BT_CLOSED;
+		sk->sk_err   = err;
+		sk->sk_state_change(sk);
+		sock_set_flag(sk, SOCK_ZAPPED);
+		spin_unlock_bh(&sk->sk_lock.slock);
+
+		sco_conn_lock(conn);
+		conn->sk = NULL;
+		sco_conn_unlock(conn);
+
 		sco_sock_kill(sk);
 		sock_put(sk);
 	}
@@ -1084,10 +1096,10 @@ static void sco_conn_ready(struct sco_conn *conn)
 
 	if (sk) {
 		sco_sock_clear_timer(sk);
-		bh_lock_sock(sk);
+		spin_lock_bh(&sk->sk_lock.slock);
 		sk->sk_state = BT_CONNECTED;
 		sk->sk_state_change(sk);
-		bh_unlock_sock(sk);
+		spin_unlock_bh(&sk->sk_lock.slock);
 	} else {
 		sco_conn_lock(conn);
 
@@ -1102,12 +1114,12 @@ static void sco_conn_ready(struct sco_conn *conn)
 			return;
 		}
 
-		bh_lock_sock(parent);
+		spin_lock_bh(&parent->sk_lock.slock);
 
 		sk = sco_sock_alloc(sock_net(parent), NULL,
 				    BTPROTO_SCO, GFP_ATOMIC, 0);
 		if (!sk) {
-			bh_unlock_sock(parent);
+			spin_unlock_bh(&parent->sk_lock.slock);
 			sco_conn_unlock(conn);
 			return;
 		}
@@ -1128,7 +1140,7 @@ static void sco_conn_ready(struct sco_conn *conn)
 		/* Wake up parent */
 		parent->sk_data_ready(parent);
 
-		bh_unlock_sock(parent);
+		spin_unlock_bh(&parent->sk_lock.slock);
 
 		sco_conn_unlock(conn);
 	}
-- 
2.25.1

