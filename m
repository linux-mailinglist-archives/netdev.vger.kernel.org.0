Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7A03929FE
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 10:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235767AbhE0Iub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 04:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235665AbhE0IuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 04:50:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CB0C061344
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 01:48:26 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lmBgm-0002EE-9f
        for netdev@vger.kernel.org; Thu, 27 May 2021 10:48:24 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id A527762D4D2
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 08:45:46 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 300A562D437;
        Thu, 27 May 2021 08:45:39 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id dbfd6183;
        Thu, 27 May 2021 08:45:34 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Torin Cooper-Bennun <torin@maxiluxsystems.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 20/21] can: m_can: make TXESC, RXESC config more explicit
Date:   Thu, 27 May 2021 10:45:31 +0200
Message-Id: <20210527084532.1384031-21-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210527084532.1384031-1-mkl@pengutronix.de>
References: <20210527084532.1384031-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Torin Cooper-Bennun <torin@maxiluxsystems.com>

Introduce masks for the three RXESC fields (RBDS, F1DS, F0DS) and the
one TXESC field (TBDS). Update m_can_chip_config() to explicitly set all
four fields to the 64-byte option (0x7) (and these defs are renamed to
be more concise).

This is an improvement in maintainability, and also makes it easier to
implement more flexible configuration of the M_CAN buffers in the
future.

Link: https://lore.kernel.org/r/20210504125123.500553-4-torin@maxiluxsystems.com
Signed-off-by: Torin Cooper-Bennun <torin@maxiluxsystems.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index cee542c0fdd5..ce7722229964 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -235,8 +235,10 @@ enum m_can_reg {
 #define RXFS_FFL_MASK	GENMASK(6, 0)
 
 /* Rx Buffer / FIFO Element Size Configuration (RXESC) */
-#define M_CAN_RXESC_8BYTES	0x0
-#define M_CAN_RXESC_64BYTES	0x777
+#define RXESC_RBDS_MASK		GENMASK(10, 8)
+#define RXESC_F1DS_MASK		GENMASK(6, 4)
+#define RXESC_F0DS_MASK		GENMASK(2, 0)
+#define RXESC_64B		0x7
 
 /* Tx Buffer Configuration (TXBC) */
 #define TXBC_TFQS_MASK		GENMASK(29, 24)
@@ -249,8 +251,8 @@ enum m_can_reg {
 #define TXFQS_TFFL_MASK		GENMASK(5, 0)
 
 /* Tx Buffer Element Size Configuration(TXESC) */
-#define TXESC_TBDS_8BYTES	0x0
-#define TXESC_TBDS_64BYTES	0x7
+#define TXESC_TBDS_MASK		GENMASK(2, 0)
+#define TXESC_TBDS_64B		0x7
 
 /* Tx Event FIFO Configuration (TXEFC) */
 #define TXEFC_EFS_MASK		GENMASK(21, 16)
@@ -1191,7 +1193,10 @@ static void m_can_chip_config(struct net_device *dev)
 	m_can_config_endisable(cdev, true);
 
 	/* RX Buffer/FIFO Element Size 64 bytes data field */
-	m_can_write(cdev, M_CAN_RXESC, M_CAN_RXESC_64BYTES);
+	m_can_write(cdev, M_CAN_RXESC,
+		    FIELD_PREP(RXESC_RBDS_MASK, RXESC_64B) |
+		    FIELD_PREP(RXESC_F1DS_MASK, RXESC_64B) |
+		    FIELD_PREP(RXESC_F0DS_MASK, RXESC_64B));
 
 	/* Accept Non-matching Frames Into FIFO 0 */
 	m_can_write(cdev, M_CAN_GFC, 0x0);
@@ -1209,7 +1214,8 @@ static void m_can_chip_config(struct net_device *dev)
 	}
 
 	/* support 64 bytes payload */
-	m_can_write(cdev, M_CAN_TXESC, TXESC_TBDS_64BYTES);
+	m_can_write(cdev, M_CAN_TXESC,
+		    FIELD_PREP(TXESC_TBDS_MASK, TXESC_TBDS_64B));
 
 	/* TX Event FIFO */
 	if (cdev->version == 30) {
-- 
2.30.2


