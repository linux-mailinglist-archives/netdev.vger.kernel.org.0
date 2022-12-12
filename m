Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82653649DE8
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbiLLLcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbiLLLbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:31:17 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0FC65CC
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:31:13 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p4h1b-0000lz-6I
        for netdev@vger.kernel.org; Mon, 12 Dec 2022 12:31:11 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id E946B13CC7C
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 11:30:58 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id CD7D513CC2C;
        Mon, 12 Dec 2022 11:30:56 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id d8c32322;
        Mon, 12 Dec 2022 11:30:48 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Markus Schneider-Pargmann <msp@baylibre.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 34/39] can: m_can: Batch acknowledge transmit events
Date:   Mon, 12 Dec 2022 12:30:40 +0100
Message-Id: <20221212113045.222493-35-mkl@pengutronix.de>
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

Transmit events from the txe fifo can be batch acknowledged by
acknowledging the last read txe fifo item. This will save txe_count
writes which is important for peripheral chips.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
Link: https://lore.kernel.org/all/20221206115728.1056014-7-msp@baylibre.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 9476d96013fa..656d2daafad1 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1023,7 +1023,9 @@ static int m_can_echo_tx_event(struct net_device *dev)
 	u32 txe_count = 0;
 	u32 m_can_txefs;
 	u32 fgi = 0;
+	int ack_fgi = -1;
 	int i = 0;
+	int err = 0;
 	unsigned int msg_mark;
 
 	struct m_can_classdev *cdev = netdev_priv(dev);
@@ -1038,28 +1040,29 @@ static int m_can_echo_tx_event(struct net_device *dev)
 	/* Get and process all sent elements */
 	for (i = 0; i < txe_count; i++) {
 		u32 txe, timestamp = 0;
-		int err;
 
 		/* get message marker, timestamp */
 		err = m_can_txe_fifo_read(cdev, fgi, 4, &txe);
 		if (err) {
 			netdev_err(dev, "TXE FIFO read returned %d\n", err);
-			return err;
+			break;
 		}
 
 		msg_mark = FIELD_GET(TX_EVENT_MM_MASK, txe);
 		timestamp = FIELD_GET(TX_EVENT_TXTS_MASK, txe) << 16;
 
-		/* ack txe element */
-		m_can_write(cdev, M_CAN_TXEFA, FIELD_PREP(TXEFA_EFAI_MASK,
-							  fgi));
+		ack_fgi = fgi;
 		fgi = (++fgi >= cdev->mcfg[MRAM_TXE].num ? 0 : fgi);
 
 		/* update stats */
 		m_can_tx_update_stats(cdev, msg_mark, timestamp);
 	}
 
-	return 0;
+	if (ack_fgi != -1)
+		m_can_write(cdev, M_CAN_TXEFA, FIELD_PREP(TXEFA_EFAI_MASK,
+							  ack_fgi));
+
+	return err;
 }
 
 static irqreturn_t m_can_isr(int irq, void *dev_id)
-- 
2.35.1


