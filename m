Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C047F57B265
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240298AbiGTILe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239535AbiGTILY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:11:24 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2364D149
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:11:23 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oE4nh-0008R2-JY
        for netdev@vger.kernel.org; Wed, 20 Jul 2022 10:11:21 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 52F26B5959
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:10:42 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 73B20B591E;
        Wed, 20 Jul 2022 08:10:41 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 1e02cd0a;
        Wed, 20 Jul 2022 08:10:36 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 14/29] can: ctucanfd: Update CTU CAN FD IP core registers to match version 3.x.
Date:   Wed, 20 Jul 2022 10:10:19 +0200
Message-Id: <20220720081034.3277385-15-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720081034.3277385-1-mkl@pengutronix.de>
References: <20220720081034.3277385-1-mkl@pengutronix.de>
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

From: Pavel Pisa <pisa@cmp.felk.cvut.cz>

The update is compatible/pure extension of 2.x IP core version

 - new option for 2, 4, or 8 Tx buffers option during synthesis.
   The 2.x version has fixed 4 Tx buffers. 3.x version default
   is 4 as well
 - new REG_TX_COMMAND_TXT_BUFFER_COUNT provides synthesis
   choice. When read as 0 assume 2.x core with fixed 4 Tx buffers.
 - new REG_ERR_CAPT_TS_BITS field to provide most significant
   active/implemented timestamp bit. For 2.x read as zero,
   assume value 63 is such case for 64 bit counter.
 - new REG_MODE_RXBAM bit which controls automatic advance
   to next word after Rx FIFO register read. Bit is set
   to 1 by default after the core reset (REG_MODE_RST)
   and value 1 has to be preserved for the normal ctucanfd
   Linux driver operation. Even preceding driver version
   resets core and then modifies only known/required MODE
   register bits so backward and forward compatibility is
   ensured.

See complete datasheet for time-triggered and other
updated capabilities

  http://canbus.pages.fel.cvut.cz/ctucanfd_ip_core/doc/Datasheet.pdf

The fields related to ongoing Ondrej Ille's work
on fault tolerant version with parity protected buffers
and FIFOs are not included for now. Their inclusion will
be considered when design is settled and tested.

Link: https://lore.kernel.org/all/14a98ed1829121f0f3bde784f1aa533bc3cc7fe0.1658139843.git.pisa@cmp.felk.cvut.cz
Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/ctucanfd/ctucanfd_kregs.h | 32 ++++++++++++++++++++---
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/ctucanfd/ctucanfd_kregs.h b/drivers/net/can/ctucanfd/ctucanfd_kregs.h
index edc1c1a24348..0c181ab51bf8 100644
--- a/drivers/net/can/ctucanfd/ctucanfd_kregs.h
+++ b/drivers/net/can/ctucanfd/ctucanfd_kregs.h
@@ -4,9 +4,9 @@
  * CTU CAN FD IP Core
  *
  * Copyright (C) 2015-2018 Ondrej Ille <ondrej.ille@gmail.com> FEE CTU
- * Copyright (C) 2018-2021 Ondrej Ille <ondrej.ille@gmail.com> self-funded
+ * Copyright (C) 2018-2022 Ondrej Ille <ondrej.ille@gmail.com> self-funded
  * Copyright (C) 2018-2019 Martin Jerabek <martin.jerabek01@gmail.com> FEE CTU
- * Copyright (C) 2018-2021 Pavel Pisa <pisa@cmp.felk.cvut.cz> FEE CTU/self-funded
+ * Copyright (C) 2018-2022 Pavel Pisa <pisa@cmp.felk.cvut.cz> FEE CTU/self-funded
  *
  * Project advisors:
  *     Jiri Novak <jnovak@fel.cvut.cz>
@@ -64,9 +64,12 @@ enum ctu_can_fd_can_registers {
 	CTUCANFD_RX_DATA              = 0x6c,
 	CTUCANFD_TX_STATUS            = 0x70,
 	CTUCANFD_TX_COMMAND           = 0x74,
+	CTUCANFD_TXTB_INFO            = 0x76,
 	CTUCANFD_TX_PRIORITY          = 0x78,
 	CTUCANFD_ERR_CAPT             = 0x7c,
+	CTUCANFD_RETR_CTR             = 0x7d,
 	CTUCANFD_ALC                  = 0x7e,
+	CTUCANFD_TS_INFO              = 0x7f,
 	CTUCANFD_TRV_DELAY            = 0x80,
 	CTUCANFD_SSP_CFG              = 0x82,
 	CTUCANFD_RX_FR_CTR            = 0x84,
@@ -102,8 +105,12 @@ enum ctu_can_fd_can_registers {
 #define REG_MODE_STM BIT(2)
 #define REG_MODE_AFM BIT(3)
 #define REG_MODE_FDE BIT(4)
+#define REG_MODE_TTTM BIT(5)
+#define REG_MODE_ROM BIT(6)
 #define REG_MODE_ACF BIT(7)
 #define REG_MODE_TSTM BIT(8)
+#define REG_MODE_RXBAM BIT(9)
+#define REG_MODE_SAM BIT(11)
 #define REG_MODE_RTRLE BIT(16)
 #define REG_MODE_RTRTH GENMASK(20, 17)
 #define REG_MODE_ILBP BIT(21)
@@ -123,8 +130,10 @@ enum ctu_can_fd_can_registers {
 #define REG_STATUS_EWL BIT(6)
 #define REG_STATUS_IDLE BIT(7)
 #define REG_STATUS_PEXS BIT(8)
+#define REG_STATUS_STCNT BIT(16)
 
 /*  COMMAND registers */
+#define REG_COMMAND_RXRPMV BIT(1)
 #define REG_COMMAND_RRB BIT(2)
 #define REG_COMMAND_CDO BIT(3)
 #define REG_COMMAND_ERCRST BIT(4)
@@ -263,8 +272,12 @@ enum ctu_can_fd_can_registers {
 #define REG_TX_STATUS_TX2S GENMASK(7, 4)
 #define REG_TX_STATUS_TX3S GENMASK(11, 8)
 #define REG_TX_STATUS_TX4S GENMASK(15, 12)
+#define REG_TX_STATUS_TX5S GENMASK(19, 16)
+#define REG_TX_STATUS_TX6S GENMASK(23, 20)
+#define REG_TX_STATUS_TX7S GENMASK(27, 24)
+#define REG_TX_STATUS_TX8S GENMASK(31, 28)
 
-/*  TX_COMMAND registers */
+/*  TX_COMMAND TXTB_INFO registers */
 #define REG_TX_COMMAND_TXCE BIT(0)
 #define REG_TX_COMMAND_TXCR BIT(1)
 #define REG_TX_COMMAND_TXCA BIT(2)
@@ -272,18 +285,29 @@ enum ctu_can_fd_can_registers {
 #define REG_TX_COMMAND_TXB2 BIT(9)
 #define REG_TX_COMMAND_TXB3 BIT(10)
 #define REG_TX_COMMAND_TXB4 BIT(11)
+#define REG_TX_COMMAND_TXB5 BIT(12)
+#define REG_TX_COMMAND_TXB6 BIT(13)
+#define REG_TX_COMMAND_TXB7 BIT(14)
+#define REG_TX_COMMAND_TXB8 BIT(15)
+#define REG_TX_COMMAND_TXT_BUFFER_COUNT GENMASK(19, 16)
 
 /*  TX_PRIORITY registers */
 #define REG_TX_PRIORITY_TXT1P GENMASK(2, 0)
 #define REG_TX_PRIORITY_TXT2P GENMASK(6, 4)
 #define REG_TX_PRIORITY_TXT3P GENMASK(10, 8)
 #define REG_TX_PRIORITY_TXT4P GENMASK(14, 12)
+#define REG_TX_PRIORITY_TXT5P GENMASK(18, 16)
+#define REG_TX_PRIORITY_TXT6P GENMASK(22, 20)
+#define REG_TX_PRIORITY_TXT7P GENMASK(26, 24)
+#define REG_TX_PRIORITY_TXT8P GENMASK(30, 28)
 
-/*  ERR_CAPT ALC registers */
+/*  ERR_CAPT RETR_CTR ALC TS_INFO registers */
 #define REG_ERR_CAPT_ERR_POS GENMASK(4, 0)
 #define REG_ERR_CAPT_ERR_TYPE GENMASK(7, 5)
+#define REG_ERR_CAPT_RETR_CTR_VAL GENMASK(11, 8)
 #define REG_ERR_CAPT_ALC_BIT GENMASK(20, 16)
 #define REG_ERR_CAPT_ALC_ID_FIELD GENMASK(23, 21)
+#define REG_ERR_CAPT_TS_BITS GENMASK(29, 24)
 
 /*  TRV_DELAY SSP_CFG registers */
 #define REG_TRV_DELAY_TRV_DELAY_VALUE GENMASK(6, 0)
-- 
2.35.1


