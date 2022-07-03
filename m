Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA5D5646B5
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 12:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbiGCK0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 06:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232144AbiGCK0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 06:26:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872AB634D
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 03:26:15 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o7wnt-0006Iy-NO
        for netdev@vger.kernel.org; Sun, 03 Jul 2022 12:26:13 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id CFED4A6A10
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 10:14:38 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id C72D0A69DF;
        Sun,  3 Jul 2022 10:14:37 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id a9ef0832;
        Sun, 3 Jul 2022 10:14:32 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 14/15] can: slcan: extend the protocol with error info
Date:   Sun,  3 Jul 2022 12:14:28 +0200
Message-Id: <20220703101430.1306048-15-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220703101430.1306048-1-mkl@pengutronix.de>
References: <20220703101430.1306048-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

It extends the protocol to receive the adapter CAN communication errors
and forward them to the netdev upper levels.

Link: https://lore.kernel.org/all/20220628163137.413025-12-dario.binacchi@amarulasolutions.com
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/slcan/slcan-core.c | 140 ++++++++++++++++++++++++++++-
 1 file changed, 139 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index c1fd1e934d93..4269b2267be2 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -175,7 +175,7 @@ int slcan_enable_err_rst_on_open(struct net_device *ndev, bool on)
   ************************************************************************/
 
 /* Send one completely decapsulated can_frame to the network layer */
-static void slc_bump(struct slcan *sl)
+static void slc_bump_frame(struct slcan *sl)
 {
 	struct sk_buff *skb;
 	struct can_frame *cf;
@@ -254,6 +254,144 @@ static void slc_bump(struct slcan *sl)
 	dev_kfree_skb(skb);
 }
 
+/* An error frame can contain more than one type of error.
+ *
+ * Examples:
+ *
+ * e1a : len 1, errors: ACK error
+ * e3bcO: len 3, errors: Bit0 error, CRC error, Tx overrun error
+ */
+static void slc_bump_err(struct slcan *sl)
+{
+	struct net_device *dev = sl->dev;
+	struct sk_buff *skb;
+	struct can_frame *cf;
+	char *cmd = sl->rbuff;
+	bool rx_errors = false, tx_errors = false, rx_over_errors = false;
+	int i, len;
+
+	/* get len from sanitized ASCII value */
+	len = cmd[1];
+	if (len >= '0' && len < '9')
+		len -= '0';
+	else
+		return;
+
+	if ((len + SLC_CMD_LEN + 1) > sl->rcount)
+		return;
+
+	skb = alloc_can_err_skb(dev, &cf);
+
+	if (skb)
+		cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
+
+	cmd += SLC_CMD_LEN + 1;
+	for (i = 0; i < len; i++, cmd++) {
+		switch (*cmd) {
+		case 'a':
+			netdev_dbg(dev, "ACK error\n");
+			tx_errors = true;
+			if (skb) {
+				cf->can_id |= CAN_ERR_ACK;
+				cf->data[3] = CAN_ERR_PROT_LOC_ACK;
+			}
+
+			break;
+		case 'b':
+			netdev_dbg(dev, "Bit0 error\n");
+			tx_errors = true;
+			if (skb)
+				cf->data[2] |= CAN_ERR_PROT_BIT0;
+
+			break;
+		case 'B':
+			netdev_dbg(dev, "Bit1 error\n");
+			tx_errors = true;
+			if (skb)
+				cf->data[2] |= CAN_ERR_PROT_BIT1;
+
+			break;
+		case 'c':
+			netdev_dbg(dev, "CRC error\n");
+			rx_errors = true;
+			if (skb) {
+				cf->data[2] |= CAN_ERR_PROT_BIT;
+				cf->data[3] = CAN_ERR_PROT_LOC_CRC_SEQ;
+			}
+
+			break;
+		case 'f':
+			netdev_dbg(dev, "Form Error\n");
+			rx_errors = true;
+			if (skb)
+				cf->data[2] |= CAN_ERR_PROT_FORM;
+
+			break;
+		case 'o':
+			netdev_dbg(dev, "Rx overrun error\n");
+			rx_over_errors = true;
+			rx_errors = true;
+			if (skb) {
+				cf->can_id |= CAN_ERR_CRTL;
+				cf->data[1] = CAN_ERR_CRTL_RX_OVERFLOW;
+			}
+
+			break;
+		case 'O':
+			netdev_dbg(dev, "Tx overrun error\n");
+			tx_errors = true;
+			if (skb) {
+				cf->can_id |= CAN_ERR_CRTL;
+				cf->data[1] = CAN_ERR_CRTL_TX_OVERFLOW;
+			}
+
+			break;
+		case 's':
+			netdev_dbg(dev, "Stuff error\n");
+			rx_errors = true;
+			if (skb)
+				cf->data[2] |= CAN_ERR_PROT_STUFF;
+
+			break;
+		default:
+			if (skb)
+				dev_kfree_skb(skb);
+
+			return;
+		}
+	}
+
+	if (rx_errors)
+		dev->stats.rx_errors++;
+
+	if (rx_over_errors)
+		dev->stats.rx_over_errors++;
+
+	if (tx_errors)
+		dev->stats.tx_errors++;
+
+	if (skb)
+		netif_rx(skb);
+}
+
+static void slc_bump(struct slcan *sl)
+{
+	switch (sl->rbuff[0]) {
+	case 'r':
+		fallthrough;
+	case 't':
+		fallthrough;
+	case 'R':
+		fallthrough;
+	case 'T':
+		return slc_bump_frame(sl);
+	case 'e':
+		return slc_bump_err(sl);
+	default:
+		return;
+	}
+}
+
 /* parse tty input stream */
 static void slcan_unesc(struct slcan *sl, unsigned char s)
 {
-- 
2.35.1


