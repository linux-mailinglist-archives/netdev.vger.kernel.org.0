Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909F756469C
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 12:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbiGCK0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 06:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbiGCK0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 06:26:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC42632C
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 03:26:07 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o7wnl-00066l-Jx
        for netdev@vger.kernel.org; Sun, 03 Jul 2022 12:26:05 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 10802A6A1D
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 10:14:39 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 40648A69F8;
        Sun,  3 Jul 2022 10:14:38 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 51277cfe;
        Sun, 3 Jul 2022 10:14:32 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 15/15] can: slcan: extend the protocol with CAN state info
Date:   Sun,  3 Jul 2022 12:14:29 +0200
Message-Id: <20220703101430.1306048-16-mkl@pengutronix.de>
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

It extends the protocol to receive the adapter CAN state changes
(warning, busoff, etc.) and forward them to the netdev upper levels.

Link: https://lore.kernel.org/all/20220628163137.413025-13-dario.binacchi@amarulasolutions.com
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/slcan/slcan-core.c | 74 +++++++++++++++++++++++++++++-
 1 file changed, 73 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index 4269b2267be2..54d29a410ad5 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -78,7 +78,11 @@ MODULE_PARM_DESC(maxdev, "Maximum number of slcan interfaces");
 #define SLC_CMD_LEN 1
 #define SLC_SFF_ID_LEN 3
 #define SLC_EFF_ID_LEN 8
-
+#define SLC_STATE_LEN 1
+#define SLC_STATE_BE_RXCNT_LEN 3
+#define SLC_STATE_BE_TXCNT_LEN 3
+#define SLC_STATE_FRAME_LEN       (1 + SLC_CMD_LEN + SLC_STATE_BE_RXCNT_LEN + \
+				   SLC_STATE_BE_TXCNT_LEN)
 struct slcan {
 	struct can_priv         can;
 	int			magic;
@@ -254,6 +258,72 @@ static void slc_bump_frame(struct slcan *sl)
 	dev_kfree_skb(skb);
 }
 
+/* A change state frame must contain state info and receive and transmit
+ * error counters.
+ *
+ * Examples:
+ *
+ * sb256256 : state bus-off: rx counter 256, tx counter 256
+ * sa057033 : state active, rx counter 57, tx counter 33
+ */
+static void slc_bump_state(struct slcan *sl)
+{
+	struct net_device *dev = sl->dev;
+	struct sk_buff *skb;
+	struct can_frame *cf;
+	char *cmd = sl->rbuff;
+	u32 rxerr, txerr;
+	enum can_state state, rx_state, tx_state;
+
+	switch (cmd[1]) {
+	case 'a':
+		state = CAN_STATE_ERROR_ACTIVE;
+		break;
+	case 'w':
+		state = CAN_STATE_ERROR_WARNING;
+		break;
+	case 'p':
+		state = CAN_STATE_ERROR_PASSIVE;
+		break;
+	case 'b':
+		state = CAN_STATE_BUS_OFF;
+		break;
+	default:
+		return;
+	}
+
+	if (state == sl->can.state || sl->rcount < SLC_STATE_FRAME_LEN)
+		return;
+
+	cmd += SLC_STATE_BE_RXCNT_LEN + SLC_CMD_LEN + 1;
+	cmd[SLC_STATE_BE_TXCNT_LEN] = 0;
+	if (kstrtou32(cmd, 10, &txerr))
+		return;
+
+	*cmd = 0;
+	cmd -= SLC_STATE_BE_RXCNT_LEN;
+	if (kstrtou32(cmd, 10, &rxerr))
+		return;
+
+	skb = alloc_can_err_skb(dev, &cf);
+	if (skb) {
+		cf->data[6] = txerr;
+		cf->data[7] = rxerr;
+	} else {
+		cf = NULL;
+	}
+
+	tx_state = txerr >= rxerr ? state : 0;
+	rx_state = txerr <= rxerr ? state : 0;
+	can_change_state(dev, cf, tx_state, rx_state);
+
+	if (state == CAN_STATE_BUS_OFF)
+		can_bus_off(dev);
+
+	if (skb)
+		netif_rx(skb);
+}
+
 /* An error frame can contain more than one type of error.
  *
  * Examples:
@@ -387,6 +457,8 @@ static void slc_bump(struct slcan *sl)
 		return slc_bump_frame(sl);
 	case 'e':
 		return slc_bump_err(sl);
+	case 's':
+		return slc_bump_state(sl);
 	default:
 		return;
 	}
-- 
2.35.1


