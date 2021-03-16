Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5EE33CFB8
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 09:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbhCPIVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 04:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234430AbhCPIVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 04:21:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0092FC061756
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 01:21:22 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lM4x7-0003En-IO
        for netdev@vger.kernel.org; Tue, 16 Mar 2021 09:21:21 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 04F365F6471
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 08:21:17 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 030605F643A;
        Tue, 16 Mar 2021 08:21:10 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 89c33ec4;
        Tue, 16 Mar 2021 08:21:06 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Torin Cooper-Bennun <torin@maxiluxsystems.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 11/11] can: m_can: m_can_rx_peripheral(): fix RX being blocked by errors
Date:   Tue, 16 Mar 2021 09:21:04 +0100
Message-Id: <20210316082104.4027260-12-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210316082104.4027260-1-mkl@pengutronix.de>
References: <20210316082104.4027260-1-mkl@pengutronix.de>
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

For M_CAN peripherals, m_can_rx_handler() was called with quota = 1,
which caused any error handling to block RX from taking place until
the next time the IRQ handler is called. This had been observed to
cause RX to be blocked indefinitely in some cases.

This is fixed by calling m_can_rx_handler with a sensibly high quota.

Fixes: f524f829b75a ("can: m_can: Create a m_can platform framework")
Link: https://lore.kernel.org/r/20210303144350.4093750-1-torin@maxiluxsystems.com
Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Torin Cooper-Bennun <torin@maxiluxsystems.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index d783c46cac16..0c8d36bc668c 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -873,7 +873,7 @@ static int m_can_rx_peripheral(struct net_device *dev)
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
 
-	m_can_rx_handler(dev, 1);
+	m_can_rx_handler(dev, M_CAN_NAPI_WEIGHT);
 
 	m_can_enable_all_interrupts(cdev);
 
-- 
2.30.1


