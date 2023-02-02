Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B9268791C
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 10:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbjBBJlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 04:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbjBBJlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 04:41:44 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4678326C
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 01:41:42 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pNW68-0000dh-QY
        for netdev@vger.kernel.org; Thu, 02 Feb 2023 10:41:40 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 6EDF916D0CC
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 09:41:39 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id C1E2916D0A8;
        Thu,  2 Feb 2023 09:41:37 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 769e57da;
        Thu, 2 Feb 2023 09:41:36 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 2/5] can: raw: fix CAN FD frame transmissions over CAN XL devices
Date:   Thu,  2 Feb 2023 10:41:32 +0100
Message-Id: <20230202094135.2293939-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230202094135.2293939-1-mkl@pengutronix.de>
References: <20230202094135.2293939-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

A CAN XL device is always capable to process CAN FD frames. The former
check when sending CAN FD frames relied on the existence of a CAN FD
device and did not check for a CAN XL device that would be correct
too.

With this patch the CAN FD feature is enabled automatically when CAN
XL is switched on - and CAN FD cannot be switch off while CAN XL is
enabled.

This precondition also leads to a clean up and reduction of checks in
the hot path in raw_rcv() and raw_sendmsg(). Some conditions are
reordered to handle simple checks first.

changes since v1: https://lore.kernel.org/all/20230131091012.50553-1-socketcan@hartkopp.net
- fixed typo: devive -> device
changes since v2: https://lore.kernel.org/all/20230131091824.51026-1-socketcan@hartkopp.net/
- reorder checks in if statements to handle simple checks first

Fixes: 626332696d75 ("can: raw: add CAN XL support")
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20230131105613.55228-1-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/raw.c | 47 +++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/net/can/raw.c b/net/can/raw.c
index 81071cdb0301..ba86782ba8bb 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -132,8 +132,8 @@ static void raw_rcv(struct sk_buff *oskb, void *data)
 		return;
 
 	/* make sure to not pass oversized frames to the socket */
-	if ((can_is_canfd_skb(oskb) && !ro->fd_frames && !ro->xl_frames) ||
-	    (can_is_canxl_skb(oskb) && !ro->xl_frames))
+	if ((!ro->fd_frames && can_is_canfd_skb(oskb)) ||
+	    (!ro->xl_frames && can_is_canxl_skb(oskb)))
 		return;
 
 	/* eliminate multiple filter matches for the same skb */
@@ -670,6 +670,11 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 		if (copy_from_sockptr(&ro->fd_frames, optval, optlen))
 			return -EFAULT;
 
+		/* Enabling CAN XL includes CAN FD */
+		if (ro->xl_frames && !ro->fd_frames) {
+			ro->fd_frames = ro->xl_frames;
+			return -EINVAL;
+		}
 		break;
 
 	case CAN_RAW_XL_FRAMES:
@@ -679,6 +684,9 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 		if (copy_from_sockptr(&ro->xl_frames, optval, optlen))
 			return -EFAULT;
 
+		/* Enabling CAN XL includes CAN FD */
+		if (ro->xl_frames)
+			ro->fd_frames = ro->xl_frames;
 		break;
 
 	case CAN_RAW_JOIN_FILTERS:
@@ -786,6 +794,25 @@ static int raw_getsockopt(struct socket *sock, int level, int optname,
 	return 0;
 }
 
+static bool raw_bad_txframe(struct raw_sock *ro, struct sk_buff *skb, int mtu)
+{
+	/* Classical CAN -> no checks for flags and device capabilities */
+	if (can_is_can_skb(skb))
+		return false;
+
+	/* CAN FD -> needs to be enabled and a CAN FD or CAN XL device */
+	if (ro->fd_frames && can_is_canfd_skb(skb) &&
+	    (mtu == CANFD_MTU || can_is_canxl_dev_mtu(mtu)))
+		return false;
+
+	/* CAN XL -> needs to be enabled and a CAN XL device */
+	if (ro->xl_frames && can_is_canxl_skb(skb) &&
+	    can_is_canxl_dev_mtu(mtu))
+		return false;
+
+	return true;
+}
+
 static int raw_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 {
 	struct sock *sk = sock->sk;
@@ -833,20 +860,8 @@ static int raw_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 		goto free_skb;
 
 	err = -EINVAL;
-	if (ro->xl_frames && can_is_canxl_dev_mtu(dev->mtu)) {
-		/* CAN XL, CAN FD and Classical CAN */
-		if (!can_is_canxl_skb(skb) && !can_is_canfd_skb(skb) &&
-		    !can_is_can_skb(skb))
-			goto free_skb;
-	} else if (ro->fd_frames && dev->mtu == CANFD_MTU) {
-		/* CAN FD and Classical CAN */
-		if (!can_is_canfd_skb(skb) && !can_is_can_skb(skb))
-			goto free_skb;
-	} else {
-		/* Classical CAN */
-		if (!can_is_can_skb(skb))
-			goto free_skb;
-	}
+	if (raw_bad_txframe(ro, skb, dev->mtu))
+		goto free_skb;
 
 	sockcm_init(&sockc, sk);
 	if (msg->msg_controllen) {
-- 
2.39.1


