Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95606C9C2E
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 09:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbjC0Hei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 03:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232590AbjC0HeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 03:34:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0924C2E
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 00:34:08 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pghMk-0000T4-TX
        for netdev@vger.kernel.org; Mon, 27 Mar 2023 09:34:06 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id A69B019CE2F
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 07:34:05 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 4D1B019CE09;
        Mon, 27 Mar 2023 07:34:03 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 567e06d9;
        Mon, 27 Mar 2023 07:33:56 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Markus Schneider-Pargmann <msp@baylibre.com>,
        Simon Horman <simon.horman@corigine.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 11/11] can: m_can: Keep interrupts enabled during peripheral read
Date:   Mon, 27 Mar 2023 09:33:54 +0200
Message-Id: <20230327073354.1003134-12-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230327073354.1003134-1-mkl@pengutronix.de>
References: <20230327073354.1003134-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Schneider-Pargmann <msp@baylibre.com>

Interrupts currently get disabled if the interrupt status shows new
received data. Non-peripheral chips handle receiving in a worker thread,
but peripheral chips are handling the receive process in the threaded
interrupt routine itself without scheduling it for a different worker.
So there is no need to disable interrupts for peripheral chips.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/all/20230315110546.2518305-6-msp@baylibre.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index e7aceeba3759..a5003435802b 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -972,8 +972,8 @@ static int m_can_rx_peripheral(struct net_device *dev, u32 irqstatus)
 	/* Don't re-enable interrupts if the driver had a fatal error
 	 * (e.g., FIFO read failure).
 	 */
-	if (work_done >= 0)
-		m_can_enable_all_interrupts(cdev);
+	if (work_done < 0)
+		m_can_disable_all_interrupts(cdev);
 
 	return work_done;
 }
@@ -1095,11 +1095,12 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 	 */
 	if ((ir & IR_RF0N) || (ir & IR_ERR_ALL_30X)) {
 		cdev->irqstatus = ir;
-		m_can_disable_all_interrupts(cdev);
-		if (!cdev->is_peripheral)
+		if (!cdev->is_peripheral) {
+			m_can_disable_all_interrupts(cdev);
 			napi_schedule(&cdev->napi);
-		else if (m_can_rx_peripheral(dev, ir) < 0)
+		} else if (m_can_rx_peripheral(dev, ir) < 0) {
 			goto out_fail;
+		}
 	}
 
 	if (cdev->version == 30) {
-- 
2.39.2


