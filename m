Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7AE96C9C29
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 09:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbjC0Hee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 03:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232578AbjC0HeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 03:34:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E5B213F
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 00:34:07 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pghMj-0000Oj-Dv
        for netdev@vger.kernel.org; Mon, 27 Mar 2023 09:34:05 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 4AC2719CE20
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 07:34:04 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id CB4AA19CDEE;
        Mon, 27 Mar 2023 07:34:01 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 8cf9f6fe;
        Mon, 27 Mar 2023 07:33:56 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Markus Schneider-Pargmann <msp@baylibre.com>,
        Simon Horman <simon.horman@corigine.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 08/11] can: m_can: Always acknowledge all interrupts
Date:   Mon, 27 Mar 2023 09:33:51 +0200
Message-Id: <20230327073354.1003134-9-mkl@pengutronix.de>
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

The code already exits the function on !ir before this condition. No
need to check again if anything is set as IR_ALL_INT is 0xffffffff.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/all/20230315110546.2518305-3-msp@baylibre.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 563625a701fc..8eb327ae3bdf 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1083,8 +1083,7 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 		return IRQ_NONE;
 
 	/* ACK all irqs */
-	if (ir & IR_ALL_INT)
-		m_can_write(cdev, M_CAN_IR, ir);
+	m_can_write(cdev, M_CAN_IR, ir);
 
 	if (cdev->ops->clear_interrupts)
 		cdev->ops->clear_interrupts(cdev);
-- 
2.39.2


