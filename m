Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC73BFADB5
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 10:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbfKMJ4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 04:56:00 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:43905 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727472AbfKMJz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 04:55:58 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iUpNU-0006Nh-0m; Wed, 13 Nov 2019 10:55:56 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH 1/9] can: af_can: export can_sock_destruct()
Date:   Wed, 13 Nov 2019 10:55:42 +0100
Message-Id: <20191113095550.26527-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191113095550.26527-1-mkl@pengutronix.de>
References: <20191113095550.26527-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

In j1939 we need our own struct sock::sk_destruct callback. Export the
generic af_can can_sock_destruct() that allows us to chain-call it.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 include/linux/can/core.h | 1 +
 net/can/af_can.c         | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/can/core.h b/include/linux/can/core.h
index 8339071ab08b..e20a0cd09ba5 100644
--- a/include/linux/can/core.h
+++ b/include/linux/can/core.h
@@ -65,5 +65,6 @@ extern void can_rx_unregister(struct net *net, struct net_device *dev,
 			      void *data);
 
 extern int can_send(struct sk_buff *skb, int loop);
+void can_sock_destruct(struct sock *sk);
 
 #endif /* !_CAN_CORE_H */
diff --git a/net/can/af_can.c b/net/can/af_can.c
index 5518a7d9eed9..128d37a4c2e0 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -86,11 +86,12 @@ static atomic_t skbcounter = ATOMIC_INIT(0);
 
 /* af_can socket functions */
 
-static void can_sock_destruct(struct sock *sk)
+void can_sock_destruct(struct sock *sk)
 {
 	skb_queue_purge(&sk->sk_receive_queue);
 	skb_queue_purge(&sk->sk_error_queue);
 }
+EXPORT_SYMBOL(can_sock_destruct);
 
 static const struct can_proto *can_get_proto(int protocol)
 {
-- 
2.24.0

