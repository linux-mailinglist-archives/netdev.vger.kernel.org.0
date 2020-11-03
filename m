Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9144D2A5973
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 23:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730685AbgKCWHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 17:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731038AbgKCWGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 17:06:50 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9359FC0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 14:06:50 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ka4S0-0006Ui-Mm; Tue, 03 Nov 2020 23:06:48 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Dan Carpenter <dan.carpenter@oracle.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 18/27] can: peak_usb: add range checking in decode operations
Date:   Tue,  3 Nov 2020 23:06:27 +0100
Message-Id: <20201103220636.972106-19-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103220636.972106-1-mkl@pengutronix.de>
References: <20201103220636.972106-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

These values come from skb->data so Smatch considers them untrusted.  I
believe Smatch is correct but I don't have a way to test this.

The usb_if->dev[] array has 2 elements but the index is in the 0-15
range without checks.  The cfd->len can be up to 255 but the maximum
valid size is CANFD_MAX_DLEN (64) so that could lead to memory
corruption.

Fixes: 0a25e1f4f185 ("can: peak_usb: add support for PEAK new CANFD USB adapters")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20200813140604.GA456946@mwanda
Acked-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c | 48 +++++++++++++++++-----
 1 file changed, 37 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index ab63fd9eb982..d29d20525588 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -468,12 +468,18 @@ static int pcan_usb_fd_decode_canmsg(struct pcan_usb_fd_if *usb_if,
 				     struct pucan_msg *rx_msg)
 {
 	struct pucan_rx_msg *rm = (struct pucan_rx_msg *)rx_msg;
-	struct peak_usb_device *dev = usb_if->dev[pucan_msg_get_channel(rm)];
-	struct net_device *netdev = dev->netdev;
+	struct peak_usb_device *dev;
+	struct net_device *netdev;
 	struct canfd_frame *cfd;
 	struct sk_buff *skb;
 	const u16 rx_msg_flags = le16_to_cpu(rm->flags);
 
+	if (pucan_msg_get_channel(rm) >= ARRAY_SIZE(usb_if->dev))
+		return -ENOMEM;
+
+	dev = usb_if->dev[pucan_msg_get_channel(rm)];
+	netdev = dev->netdev;
+
 	if (rx_msg_flags & PUCAN_MSG_EXT_DATA_LEN) {
 		/* CANFD frame case */
 		skb = alloc_canfd_skb(netdev, &cfd);
@@ -519,15 +525,21 @@ static int pcan_usb_fd_decode_status(struct pcan_usb_fd_if *usb_if,
 				     struct pucan_msg *rx_msg)
 {
 	struct pucan_status_msg *sm = (struct pucan_status_msg *)rx_msg;
-	struct peak_usb_device *dev = usb_if->dev[pucan_stmsg_get_channel(sm)];
-	struct pcan_usb_fd_device *pdev =
-			container_of(dev, struct pcan_usb_fd_device, dev);
+	struct pcan_usb_fd_device *pdev;
 	enum can_state new_state = CAN_STATE_ERROR_ACTIVE;
 	enum can_state rx_state, tx_state;
-	struct net_device *netdev = dev->netdev;
+	struct peak_usb_device *dev;
+	struct net_device *netdev;
 	struct can_frame *cf;
 	struct sk_buff *skb;
 
+	if (pucan_stmsg_get_channel(sm) >= ARRAY_SIZE(usb_if->dev))
+		return -ENOMEM;
+
+	dev = usb_if->dev[pucan_stmsg_get_channel(sm)];
+	pdev = container_of(dev, struct pcan_usb_fd_device, dev);
+	netdev = dev->netdev;
+
 	/* nothing should be sent while in BUS_OFF state */
 	if (dev->can.state == CAN_STATE_BUS_OFF)
 		return 0;
@@ -579,9 +591,14 @@ static int pcan_usb_fd_decode_error(struct pcan_usb_fd_if *usb_if,
 				    struct pucan_msg *rx_msg)
 {
 	struct pucan_error_msg *er = (struct pucan_error_msg *)rx_msg;
-	struct peak_usb_device *dev = usb_if->dev[pucan_ermsg_get_channel(er)];
-	struct pcan_usb_fd_device *pdev =
-			container_of(dev, struct pcan_usb_fd_device, dev);
+	struct pcan_usb_fd_device *pdev;
+	struct peak_usb_device *dev;
+
+	if (pucan_ermsg_get_channel(er) >= ARRAY_SIZE(usb_if->dev))
+		return -EINVAL;
+
+	dev = usb_if->dev[pucan_ermsg_get_channel(er)];
+	pdev = container_of(dev, struct pcan_usb_fd_device, dev);
 
 	/* keep a trace of tx and rx error counters for later use */
 	pdev->bec.txerr = er->tx_err_cnt;
@@ -595,11 +612,17 @@ static int pcan_usb_fd_decode_overrun(struct pcan_usb_fd_if *usb_if,
 				      struct pucan_msg *rx_msg)
 {
 	struct pcan_ufd_ovr_msg *ov = (struct pcan_ufd_ovr_msg *)rx_msg;
-	struct peak_usb_device *dev = usb_if->dev[pufd_omsg_get_channel(ov)];
-	struct net_device *netdev = dev->netdev;
+	struct peak_usb_device *dev;
+	struct net_device *netdev;
 	struct can_frame *cf;
 	struct sk_buff *skb;
 
+	if (pufd_omsg_get_channel(ov) >= ARRAY_SIZE(usb_if->dev))
+		return -EINVAL;
+
+	dev = usb_if->dev[pufd_omsg_get_channel(ov)];
+	netdev = dev->netdev;
+
 	/* allocate an skb to store the error frame */
 	skb = alloc_can_err_skb(netdev, &cf);
 	if (!skb)
@@ -716,6 +739,9 @@ static int pcan_usb_fd_encode_msg(struct peak_usb_device *dev,
 	u16 tx_msg_size, tx_msg_flags;
 	u8 can_dlc;
 
+	if (cfd->len > CANFD_MAX_DLEN)
+		return -EINVAL;
+
 	tx_msg_size = ALIGN(sizeof(struct pucan_tx_msg) + cfd->len, 4);
 	tx_msg->size = cpu_to_le16(tx_msg_size);
 	tx_msg->type = cpu_to_le16(PUCAN_MSG_CAN_TX);
-- 
2.28.0

