Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D8160DD3E
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 10:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbiJZIkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 04:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233068AbiJZIkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 04:40:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD2C356E8
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 01:40:17 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1onbxQ-0006i3-3O
        for netdev@vger.kernel.org; Wed, 26 Oct 2022 10:40:16 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id E1A3F10A0BA
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 08:40:13 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id C70B110A088;
        Wed, 26 Oct 2022 08:40:11 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 13e6c347;
        Wed, 26 Oct 2022 08:40:08 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Vivek Yadav <vivek.2311@samsung.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 07/29] can: m_can: m_can_handle_bus_errors(): add support for handling DLEC error on CAN-FD frames
Date:   Wed, 26 Oct 2022 10:39:45 +0200
Message-Id: <20221026084007.1583333-8-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026084007.1583333-1-mkl@pengutronix.de>
References: <20221026084007.1583333-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivek Yadav <vivek.2311@samsung.com>

When a frame in CAN FD format has reached the data phase, the next CAN
event (error or valid frame) will be shown in DLEC.

Utilize the dedicated flag (Data Phase Last Error Code: DLEC flag) to
determine the type of last error that occurred in the data phase of a
CAN-FD frame and handle the bus errors.

Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>
Link: https://lore.kernel.org/all/20221018081934.1336690-1-mkl@pengutronix.de
Reviewed-by: Chandrasekar Ramakrishnan <rcsekar@samsung.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index ebdd3c164d7b..34c76ee87c6e 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -156,6 +156,7 @@ enum m_can_reg {
 #define PSR_EW		BIT(6)
 #define PSR_EP		BIT(5)
 #define PSR_LEC_MASK	GENMASK(2, 0)
+#define PSR_DLEC_MASK	GENMASK(10, 8)
 
 /* Interrupt Register (IR) */
 #define IR_ALL_INT	0xffffffff
@@ -875,9 +876,17 @@ static int m_can_handle_bus_errors(struct net_device *dev, u32 irqstatus,
 	/* handle lec errors on the bus */
 	if (cdev->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING) {
 		u8 lec = FIELD_GET(PSR_LEC_MASK, psr);
+		u8 dlec = FIELD_GET(PSR_DLEC_MASK, psr);
 
-		if (is_lec_err(lec))
+		if (is_lec_err(lec)) {
+			netdev_dbg(dev, "Arbitration phase error detected\n");
 			work_done += m_can_handle_lec_err(dev, lec);
+		}
+		
+		if (is_lec_err(dlec)) {
+			netdev_dbg(dev, "Data phase error detected\n");
+			work_done += m_can_handle_lec_err(dev, dlec);
+		}
 	}
 
 	/* handle protocol errors in arbitration phase */
-- 
2.35.1


