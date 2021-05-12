Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3D937B69F
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 09:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhELHMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 03:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbhELHME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 03:12:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBC0C061760
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 00:10:56 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lgj1D-0005yj-4O
        for netdev@vger.kernel.org; Wed, 12 May 2021 09:10:55 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 98BB0622BEC
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 07:10:53 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 92FD1622BDE;
        Wed, 12 May 2021 07:10:52 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 165f187f;
        Wed, 12 May 2021 07:10:52 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Norbert Slusarek <nslusarek@gmx.net>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net] can: isotp: prevent race between isotp_bind() and isotp_setsockopt()
Date:   Wed, 12 May 2021 09:10:50 +0200
Message-Id: <20210512071050.1760001-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512071050.1760001-1-mkl@pengutronix.de>
References: <20210512071050.1760001-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Norbert Slusarek <nslusarek@gmx.net>

A race condition was found in isotp_setsockopt() which allows to
change socket options after the socket was bound.
For the specific case of SF_BROADCAST support, this might lead to possible
use-after-free because can_rx_unregister() is not called.

Checking for the flag under the socket lock in isotp_bind() and taking
the lock in isotp_setsockopt() fixes the issue.

Fixes: 921ca574cd38 ("can: isotp: add SF_BROADCAST support for functional addressing")
Link: https://lore.kernel.org/r/trinity-e6ae9efa-9afb-4326-84c0-f3609b9b8168-1620773528307@3c-app-gmx-bs06
Reported-by: Norbert Slusarek <nslusarek@gmx.net>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Norbert Slusarek <nslusarek@gmx.net>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 49 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 9f94ad3caee9..253b24417c8e 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1062,27 +1062,31 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	if (len < ISOTP_MIN_NAMELEN)
 		return -EINVAL;
 
+	if (addr->can_addr.tp.tx_id & (CAN_ERR_FLAG | CAN_RTR_FLAG))
+		return -EADDRNOTAVAIL;
+
+	if (!addr->can_ifindex)
+		return -ENODEV;
+
+	lock_sock(sk);
+
 	/* do not register frame reception for functional addressing */
 	if (so->opt.flags & CAN_ISOTP_SF_BROADCAST)
 		do_rx_reg = 0;
 
 	/* do not validate rx address for functional addressing */
 	if (do_rx_reg) {
-		if (addr->can_addr.tp.rx_id == addr->can_addr.tp.tx_id)
-			return -EADDRNOTAVAIL;
+		if (addr->can_addr.tp.rx_id == addr->can_addr.tp.tx_id) {
+			err = -EADDRNOTAVAIL;
+			goto out;
+		}
 
-		if (addr->can_addr.tp.rx_id & (CAN_ERR_FLAG | CAN_RTR_FLAG))
-			return -EADDRNOTAVAIL;
+		if (addr->can_addr.tp.rx_id & (CAN_ERR_FLAG | CAN_RTR_FLAG)) {
+			err = -EADDRNOTAVAIL;
+			goto out;
+		}
 	}
 
-	if (addr->can_addr.tp.tx_id & (CAN_ERR_FLAG | CAN_RTR_FLAG))
-		return -EADDRNOTAVAIL;
-
-	if (!addr->can_ifindex)
-		return -ENODEV;
-
-	lock_sock(sk);
-
 	if (so->bound && addr->can_ifindex == so->ifindex &&
 	    addr->can_addr.tp.rx_id == so->rxid &&
 	    addr->can_addr.tp.tx_id == so->txid)
@@ -1164,16 +1168,13 @@ static int isotp_getname(struct socket *sock, struct sockaddr *uaddr, int peer)
 	return ISOTP_MIN_NAMELEN;
 }
 
-static int isotp_setsockopt(struct socket *sock, int level, int optname,
+static int isotp_setsockopt_locked(struct socket *sock, int level, int optname,
 			    sockptr_t optval, unsigned int optlen)
 {
 	struct sock *sk = sock->sk;
 	struct isotp_sock *so = isotp_sk(sk);
 	int ret = 0;
 
-	if (level != SOL_CAN_ISOTP)
-		return -EINVAL;
-
 	if (so->bound)
 		return -EISCONN;
 
@@ -1248,6 +1249,22 @@ static int isotp_setsockopt(struct socket *sock, int level, int optname,
 	return ret;
 }
 
+static int isotp_setsockopt(struct socket *sock, int level, int optname,
+			    sockptr_t optval, unsigned int optlen)
+
+{
+	struct sock *sk = sock->sk;
+	int ret;
+
+	if (level != SOL_CAN_ISOTP)
+		return -EINVAL;
+
+	lock_sock(sk);
+	ret = isotp_setsockopt_locked(sock, level, optname, optval, optlen);
+	release_sock(sk);
+	return ret;
+}
+
 static int isotp_getsockopt(struct socket *sock, int level, int optname,
 			    char __user *optval, int __user *optlen)
 {

base-commit: 440c3247cba3d9433ac435d371dd7927d68772a7
-- 
2.30.2


