Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66C245646B1
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 12:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbiGCK0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 06:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbiGCK0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 06:26:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC06631A
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 03:26:11 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o7wnp-0006C1-Q6
        for netdev@vger.kernel.org; Sun, 03 Jul 2022 12:26:09 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 6EB95A69D0
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 10:14:37 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id B92A6A69A4;
        Sun,  3 Jul 2022 10:14:36 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 99863f2f;
        Sun, 3 Jul 2022 10:14:31 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 10/15] can: slcan: set bitrate by CAN device driver API
Date:   Sun,  3 Jul 2022 12:14:24 +0200
Message-Id: <20220703101430.1306048-11-mkl@pengutronix.de>
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

It allows to set the bitrate via ip tool, as it happens for the other
CAN device drivers. It still remains possible to set the bitrate via
slcand or slcan_attach utilities. In case the ip tool is used, the
driver will send the serial command to the adapter.

Link: https://lore.kernel.org/all/20220628163137.413025-8-dario.binacchi@amarulasolutions.com
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Tested-by: Jeroen Hofstee <jhofstee@victronenergy.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/slcan.c | 41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index dfccf8d6c9a5..74033e2d7097 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -104,6 +104,11 @@ struct slcan {
 
 static struct net_device **slcan_devs;
 
+static const u32 slcan_bitrate_const[] = {
+	10000, 20000, 50000, 100000, 125000,
+	250000, 500000, 800000, 1000000
+};
+
  /************************************************************************
   *			SLCAN ENCAPSULATION FORMAT			 *
   ************************************************************************/
@@ -439,6 +444,9 @@ static int slc_close(struct net_device *dev)
 	netif_stop_queue(dev);
 	close_candev(dev);
 	sl->can.state = CAN_STATE_STOPPED;
+	if (sl->can.bittiming.bitrate == CAN_BITRATE_UNKNOWN)
+		sl->can.bittiming.bitrate = CAN_BITRATE_UNSET;
+
 	sl->rcount   = 0;
 	sl->xleft    = 0;
 	spin_unlock_bh(&sl->lock);
@@ -450,7 +458,8 @@ static int slc_close(struct net_device *dev)
 static int slc_open(struct net_device *dev)
 {
 	struct slcan *sl = netdev_priv(dev);
-	int err;
+	unsigned char cmd[SLC_MTU];
+	int err, s;
 
 	if (sl->tty == NULL)
 		return -ENODEV;
@@ -460,15 +469,39 @@ static int slc_open(struct net_device *dev)
 	 * can.bittiming.bitrate is CAN_BITRATE_UNSET (0), causing
 	 * open_candev() to fail. So let's set to a fake value.
 	 */
-	sl->can.bittiming.bitrate = CAN_BITRATE_UNKNOWN;
+	if (sl->can.bittiming.bitrate == CAN_BITRATE_UNSET)
+		sl->can.bittiming.bitrate = CAN_BITRATE_UNKNOWN;
+
 	err = open_candev(dev);
 	if (err) {
 		netdev_err(dev, "failed to open can device\n");
 		return err;
 	}
 
-	sl->can.state = CAN_STATE_ERROR_ACTIVE;
 	sl->flags &= BIT(SLF_INUSE);
+
+	if (sl->can.bittiming.bitrate != CAN_BITRATE_UNKNOWN) {
+		for (s = 0; s < ARRAY_SIZE(slcan_bitrate_const); s++) {
+			if (sl->can.bittiming.bitrate == slcan_bitrate_const[s])
+				break;
+		}
+
+		/* The CAN framework has already validate the bitrate value,
+		 * so we can avoid to check if `s' has been properly set.
+		 */
+
+		snprintf(cmd, sizeof(cmd), "C\rS%d\r", s);
+		err = slcan_transmit_cmd(sl, cmd);
+		if (err) {
+			netdev_err(dev,
+				   "failed to send bitrate command 'C\\rS%d\\r'\n",
+				   s);
+			close_candev(dev);
+			return err;
+		}
+	}
+
+	sl->can.state = CAN_STATE_ERROR_ACTIVE;
 	netif_start_queue(dev);
 	return 0;
 }
@@ -581,6 +614,8 @@ static struct slcan *slc_alloc(void)
 	/* Initialize channel control data */
 	sl->magic = SLCAN_MAGIC;
 	sl->dev	= dev;
+	sl->can.bitrate_const = slcan_bitrate_const;
+	sl->can.bitrate_const_cnt = ARRAY_SIZE(slcan_bitrate_const);
 	spin_lock_init(&sl->lock);
 	INIT_WORK(&sl->tx_work, slcan_transmit);
 	init_waitqueue_head(&sl->xcmd_wait);
-- 
2.35.1


