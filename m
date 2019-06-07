Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C44739785
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 23:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731292AbfFGVP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 17:15:57 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51411 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731275AbfFGVPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 17:15:55 -0400
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <mkl@pengutronix.de>)
        id 1hZMDK-00006I-29; Fri, 07 Jun 2019 23:15:54 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Willem de Bruijn <willemb@google.com>,
        syzbot+a90604060cb40f5bdd16@syzkaller.appspotmail.com,
        linux-stable <stable@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 9/9] can: purge socket error queue on sock destruct
Date:   Fri,  7 Jun 2019 23:15:41 +0200
Message-Id: <20190607211541.16095-10-mkl@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190607211541.16095-1-mkl@pengutronix.de>
References: <20190607211541.16095-1-mkl@pengutronix.de>
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

From: Willem de Bruijn <willemb@google.com>

CAN supports software tx timestamps as of the below commit. Purge
any queued timestamp packets on socket destroy.

Fixes: 51f31cabe3ce ("ip: support for TX timestamps on UDP and RAW sockets")
Reported-by: syzbot+a90604060cb40f5bdd16@syzkaller.appspotmail.com
Signed-off-by: Willem de Bruijn <willemb@google.com>
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/af_can.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 743470680127..80281ef2ccbd 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -99,6 +99,7 @@ EXPORT_SYMBOL(can_ioctl);
 static void can_sock_destruct(struct sock *sk)
 {
 	skb_queue_purge(&sk->sk_receive_queue);
+	skb_queue_purge(&sk->sk_error_queue);
 }
 
 static const struct can_proto *can_get_proto(int protocol)
-- 
2.20.1

