Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1472CEEDD
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 14:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730270AbgLDNgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 08:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgLDNgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 08:36:36 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79218C08C5F2
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 05:35:17 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1klBEy-0004f3-1S
        for netdev@vger.kernel.org; Fri, 04 Dec 2020 14:35:16 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 589655A43B7
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 13:35:13 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id BD0A85A439D;
        Fri,  4 Dec 2020 13:35:10 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 13ab1853;
        Fri, 4 Dec 2020 13:35:10 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Thomas Wagner <thwa1@web.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 3/3] can: isotp: add SF_BROADCAST support for functional addressing
Date:   Fri,  4 Dec 2020 14:35:08 +0100
Message-Id: <20201204133508.742120-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201204133508.742120-1-mkl@pengutronix.de>
References: <20201204133508.742120-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

When CAN_ISOTP_SF_BROADCAST is set in the CAN_ISOTP_OPTS flags the CAN_ISOTP
socket is switched into functional addressing mode, where only single frame
(SF) protocol data units can be send on the specified CAN interface and the
given tp.tx_id after bind().

In opposite to normal and extended addressing this socket does not register a
CAN-ID for reception which would be needed for a 1-to-1 ISOTP connection with a
segmented bi-directional data transfer.

Sending SFs on this socket is therefore a TX-only 'broadcast' operation.

Suggested-by: Thomas Wagner <thwa1@web.de>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Tested-by: Thomas Wagner <thwa1@web.de>
Link: https://lore.kernel.org/r/20201203140604.25488-3-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 include/uapi/linux/can/isotp.h |  2 +-
 net/can/isotp.c                | 29 ++++++++++++++++++++---------
 2 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/can/isotp.h b/include/uapi/linux/can/isotp.h
index 7793b26aa154..c55935b64ccc 100644
--- a/include/uapi/linux/can/isotp.h
+++ b/include/uapi/linux/can/isotp.h
@@ -135,7 +135,7 @@ struct can_isotp_ll_options {
 #define CAN_ISOTP_FORCE_RXSTMIN	0x100	/* ignore CFs depending on rx stmin */
 #define CAN_ISOTP_RX_EXT_ADDR	0x200	/* different rx extended addressing */
 #define CAN_ISOTP_WAIT_TX_DONE	0x400	/* wait for tx completion */
-
+#define CAN_ISOTP_SF_BROADCAST	0x800	/* 1-to-N functional addressing */
 
 /* default values */
 
diff --git a/net/can/isotp.c b/net/can/isotp.c
index 26bdc3c20b7e..5ce26e568f16 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -865,6 +865,14 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	if (!size || size > MAX_MSG_LENGTH)
 		return -EINVAL;
 
+	/* take care of a potential SF_DL ESC offset for TX_DL > 8 */
+	off = (so->tx.ll_dl > CAN_MAX_DLEN) ? 1 : 0;
+
+	/* does the given data fit into a single frame for SF_BROADCAST? */
+	if ((so->opt.flags & CAN_ISOTP_SF_BROADCAST) &&
+	    (size > so->tx.ll_dl - SF_PCI_SZ4 - ae - off))
+		return -EINVAL;
+
 	err = memcpy_from_msg(so->tx.buf, msg, size);
 	if (err < 0)
 		return err;
@@ -891,9 +899,6 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	cf = (struct canfd_frame *)skb->data;
 	skb_put(skb, so->ll.mtu);
 
-	/* take care of a potential SF_DL ESC offset for TX_DL > 8 */
-	off = (so->tx.ll_dl > CAN_MAX_DLEN) ? 1 : 0;
-
 	/* check for single frame transmission depending on TX_DL */
 	if (size <= so->tx.ll_dl - SF_PCI_SZ4 - ae - off) {
 		/* The message size generally fits into a SingleFrame - good.
@@ -1016,7 +1021,7 @@ static int isotp_release(struct socket *sock)
 	hrtimer_cancel(&so->rxtimer);
 
 	/* remove current filters & unregister */
-	if (so->bound) {
+	if (so->bound && (!(so->opt.flags & CAN_ISOTP_SF_BROADCAST))) {
 		if (so->ifindex) {
 			struct net_device *dev;
 
@@ -1052,6 +1057,7 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	struct net_device *dev;
 	int err = 0;
 	int notify_enetdown = 0;
+	int do_rx_reg = 1;
 
 	if (len < CAN_REQUIRED_SIZE(struct sockaddr_can, can_addr.tp))
 		return -EINVAL;
@@ -1066,6 +1072,10 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	if (!addr->can_ifindex)
 		return -ENODEV;
 
+	/* do not register frame reception for functional addressing */
+	if (so->opt.flags & CAN_ISOTP_SF_BROADCAST)
+		do_rx_reg = 0;
+
 	lock_sock(sk);
 
 	if (so->bound && addr->can_ifindex == so->ifindex &&
@@ -1093,13 +1103,14 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 
 	ifindex = dev->ifindex;
 
-	can_rx_register(net, dev, addr->can_addr.tp.rx_id,
-			SINGLE_MASK(addr->can_addr.tp.rx_id), isotp_rcv, sk,
-			"isotp", sk);
+	if (do_rx_reg)
+		can_rx_register(net, dev, addr->can_addr.tp.rx_id,
+				SINGLE_MASK(addr->can_addr.tp.rx_id),
+				isotp_rcv, sk, "isotp", sk);
 
 	dev_put(dev);
 
-	if (so->bound) {
+	if (so->bound && do_rx_reg) {
 		/* unregister old filter */
 		if (so->ifindex) {
 			dev = dev_get_by_index(net, so->ifindex);
@@ -1302,7 +1313,7 @@ static int isotp_notifier(struct notifier_block *nb, unsigned long msg,
 	case NETDEV_UNREGISTER:
 		lock_sock(sk);
 		/* remove current filters & unregister */
-		if (so->bound)
+		if (so->bound && (!(so->opt.flags & CAN_ISOTP_SF_BROADCAST)))
 			can_rx_unregister(dev_net(dev), dev, so->rxid,
 					  SINGLE_MASK(so->rxid),
 					  isotp_rcv, sk);
-- 
2.29.2


