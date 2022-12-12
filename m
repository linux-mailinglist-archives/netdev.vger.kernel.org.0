Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1BB649DE9
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbiLLLch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbiLLLbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:31:19 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6651A9FC5
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:31:14 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p4h1c-0000s7-J1
        for netdev@vger.kernel.org; Mon, 12 Dec 2022 12:31:12 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id CDF0E13CC8A
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 11:30:59 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 7F9AA13CC21;
        Mon, 12 Dec 2022 11:30:56 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 474f95a7;
        Mon, 12 Dec 2022 11:30:48 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Markus Schneider-Pargmann <msp@baylibre.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 33/39] can: m_can: Count read getindex in the driver
Date:   Mon, 12 Dec 2022 12:30:39 +0100
Message-Id: <20221212113045.222493-34-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221212113045.222493-1-mkl@pengutronix.de>
References: <20221212113045.222493-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Schneider-Pargmann <msp@baylibre.com>

The getindex gets increased by one every time. We can calculate the
correct getindex in the driver and avoid the additional reads of rxfs.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
Link: https://lore.kernel.org/all/20221206115728.1056014-6-msp@baylibre.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 83d3a7f191bf..9476d96013fa 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -477,19 +477,16 @@ static void m_can_receive_skb(struct m_can_classdev *cdev,
 	}
 }
 
-static int m_can_read_fifo(struct net_device *dev, u32 rxfs)
+static int m_can_read_fifo(struct net_device *dev, u32 fgi)
 {
 	struct net_device_stats *stats = &dev->stats;
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	struct canfd_frame *cf;
 	struct sk_buff *skb;
 	struct id_and_dlc fifo_header;
-	u32 fgi;
 	u32 timestamp = 0;
 	int err;
 
-	/* calculate the fifo get index for where to read data */
-	fgi = FIELD_GET(RXFS_FGI_MASK, rxfs);
 	err = m_can_fifo_read(cdev, fgi, M_CAN_FIFO_ID, &fifo_header, 2);
 	if (err)
 		goto out_fail;
@@ -554,6 +551,9 @@ static int m_can_do_rx_poll(struct net_device *dev, int quota)
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	u32 pkts = 0;
 	u32 rxfs;
+	u32 rx_count;
+	u32 fgi;
+	int i;
 	int err;
 
 	rxfs = m_can_read(cdev, M_CAN_RXF0S);
@@ -562,14 +562,17 @@ static int m_can_do_rx_poll(struct net_device *dev, int quota)
 		return 0;
 	}
 
-	while ((rxfs & RXFS_FFL_MASK) && (quota > 0)) {
-		err = m_can_read_fifo(dev, rxfs);
+	rx_count = FIELD_GET(RXFS_FFL_MASK, rxfs);
+	fgi = FIELD_GET(RXFS_FGI_MASK, rxfs);
+
+	for (i = 0; i < rx_count && quota > 0; ++i) {
+		err = m_can_read_fifo(dev, fgi);
 		if (err)
 			return err;
 
 		quota--;
 		pkts++;
-		rxfs = m_can_read(cdev, M_CAN_RXF0S);
+		fgi = (++fgi >= cdev->mcfg[MRAM_RXF0].num ? 0 : fgi);
 	}
 
 	return pkts;
-- 
2.35.1


