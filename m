Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFBC286A2B
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 23:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbgJGVcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 17:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728657AbgJGVcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 17:32:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22591C0613D9
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 14:32:11 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kQH2f-0005qi-8z; Wed, 07 Oct 2020 23:32:09 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 05/17] can: raw: add missing error queue support
Date:   Wed,  7 Oct 2020 23:31:47 +0200
Message-Id: <20201007213159.1959308-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201007213159.1959308-1-mkl@pengutronix.de>
References: <20201007213159.1959308-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Error queue are not yet implemented in CAN-raw sockets.

The problem: a userland call to recvmsg(soc, msg, MSG_ERRQUEUE) on a
CAN-raw socket would unqueue messages from the normal queue without
any kind of error or warning. As such, it prevented CAN drivers from
using the functionalities that relies on the error queue such as
skb_tx_timestamp().

SCM_CAN_RAW_ERRQUEUE is defined as the type for the CAN raw error
queue. SCM stands for "Socket control messages". The name is inspired
from SCM_J1939_ERRQUEUE of include/uapi/linux/can/j1939.h.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/r/20200926162527.270030-1-mailhol.vincent@wanadoo.fr
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 include/uapi/linux/can/raw.h | 3 +++
 net/can/raw.c                | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/can/raw.h b/include/uapi/linux/can/raw.h
index 6a11d308eb5c..3386aa81fdf2 100644
--- a/include/uapi/linux/can/raw.h
+++ b/include/uapi/linux/can/raw.h
@@ -49,6 +49,9 @@
 #include <linux/can.h>
 
 #define SOL_CAN_RAW (SOL_CAN_BASE + CAN_RAW)
+enum {
+	SCM_CAN_RAW_ERRQUEUE = 1,
+};
 
 /* for socket options affecting the socket (not the global system) */
 
diff --git a/net/can/raw.c b/net/can/raw.c
index 24db4b4afdc7..ea70850f9152 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -804,6 +804,10 @@ static int raw_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	noblock = flags & MSG_DONTWAIT;
 	flags &= ~MSG_DONTWAIT;
 
+	if (flags & MSG_ERRQUEUE)
+		return sock_recv_errqueue(sk, msg, size,
+					  SOL_CAN_RAW, SCM_CAN_RAW_ERRQUEUE);
+
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb)
 		return err;
-- 
2.28.0

