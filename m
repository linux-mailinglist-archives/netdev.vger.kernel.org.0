Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A68279ABF
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 18:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729821AbgIZQ1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 12:27:08 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:53092 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729363AbgIZQ1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 12:27:08 -0400
Received: from tomoyo.flets-east.jp ([153.230.197.127])
        by mwinf5d10 with ME
        id YgSs230022lQRaH03gT107; Sat, 26 Sep 2020 18:27:05 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Sat, 26 Sep 2020 18:27:05 +0200
X-ME-IP: 153.230.197.127
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     linux-can@vger.kernel.org
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] can: raw: add missing error queue support
Date:   Sun, 27 Sep 2020 01:24:31 +0900
Message-Id: <20200926162527.270030-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
index 94a9405658dc..98abab119136 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -804,6 +804,10 @@ static int raw_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	noblock =  flags & MSG_DONTWAIT;
 	flags   &= ~MSG_DONTWAIT;
 
+	if (flags & MSG_ERRQUEUE)
+		return sock_recv_errqueue(sk, msg, size,
+					  SOL_CAN_RAW, SCM_CAN_RAW_ERRQUEUE);
+
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb)
 		return err;
-- 
2.26.2

