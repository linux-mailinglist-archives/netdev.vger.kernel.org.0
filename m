Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9A63ADBF0
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 00:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhFSWDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 18:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbhFSWDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 18:03:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8962C061768
        for <netdev@vger.kernel.org>; Sat, 19 Jun 2021 15:01:27 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1luj1q-0005YB-BD
        for netdev@vger.kernel.org; Sun, 20 Jun 2021 00:01:26 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 5ECC663F816
        for <netdev@vger.kernel.org>; Sat, 19 Jun 2021 22:01:23 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 5A90763F7E7;
        Sat, 19 Jun 2021 22:01:19 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id bf06fd0f;
        Sat, 19 Jun 2021 22:01:18 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oleksij Rempel <o.rempel@pengutronix.de>,
        linux-stable <stable@vger.kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        syzbot+bdf710cfc41c186fdff3@syzkaller.appspotmail.com,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 4/5] can: j1939: j1939_sk_init(): set SOCK_RCU_FREE to call sk_destruct() after RCU is done
Date:   Sun, 20 Jun 2021 00:01:14 +0200
Message-Id: <20210619220115.2830761-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210619220115.2830761-1-mkl@pengutronix.de>
References: <20210619220115.2830761-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

Set SOCK_RCU_FREE to let RCU to call sk_destruct() on completion.
Without this patch, we will run in to j1939_can_recv() after priv was
freed by j1939_sk_release()->j1939_sk_sock_destruct()

Fixes: 25fe97cb7620 ("can: j1939: move j1939_priv_put() into sk_destruct callback")
Link: https://lore.kernel.org/r/20210617130623.12705-1-o.rempel@pengutronix.de
Cc: linux-stable <stable@vger.kernel.org>
Reported-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Reported-by: syzbot+bdf710cfc41c186fdff3@syzkaller.appspotmail.com
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/j1939/main.c   | 4 ++++
 net/can/j1939/socket.c | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
index da3a7a7bcff2..08c8606cfd9c 100644
--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -193,6 +193,10 @@ static void j1939_can_rx_unregister(struct j1939_priv *priv)
 	can_rx_unregister(dev_net(ndev), ndev, J1939_CAN_ID, J1939_CAN_MASK,
 			  j1939_can_recv, priv);
 
+	/* The last reference of priv is dropped by the RCU deferred
+	 * j1939_sk_sock_destruct() of the last socket, so we can
+	 * safely drop this reference here.
+	 */
 	j1939_priv_put(priv);
 }
 
diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 56aa66147d5a..fce8bc8afeb7 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -398,6 +398,9 @@ static int j1939_sk_init(struct sock *sk)
 	atomic_set(&jsk->skb_pending, 0);
 	spin_lock_init(&jsk->sk_session_queue_lock);
 	INIT_LIST_HEAD(&jsk->sk_session_queue);
+
+	/* j1939_sk_sock_destruct() depends on SOCK_RCU_FREE flag */
+	sock_set_flag(sk, SOCK_RCU_FREE);
 	sk->sk_destruct = j1939_sk_sock_destruct;
 	sk->sk_protocol = CAN_J1939;
 
-- 
2.30.2


