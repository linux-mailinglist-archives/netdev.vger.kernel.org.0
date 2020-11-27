Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C072C627E
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 11:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgK0KEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 05:04:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbgK0KED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 05:04:03 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F480C061A04
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 02:04:03 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kiabi-0007fp-5S
        for netdev@vger.kernel.org; Fri, 27 Nov 2020 11:04:02 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 49CAA59DE98
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 10:03:59 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 3A05D59DE6C;
        Fri, 27 Nov 2020 10:03:54 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id a1ada382;
        Fri, 27 Nov 2020 10:03:53 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Dan Murphy <dmurphy@ti.com>,
        Sriram Dash <sriram.dash@samsung.com>,
        Pankaj Sharma <pankj.sharma@samsung.com>
Subject: [net 3/6] can: m_can: m_can_open(): remove IRQF_TRIGGER_FALLING from request_threaded_irq()'s flags
Date:   Fri, 27 Nov 2020 11:02:58 +0100
Message-Id: <20201127100301.512603-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201127100301.512603-1-mkl@pengutronix.de>
References: <20201127100301.512603-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The threaded IRQ handler is used for the tcan4x5x driver only. The IRQ pin of
the tcan4x5x controller is active low, so better not use IRQF_TRIGGER_FALLING
when requesting the IRQ. As this can result in missing interrupts.

Further, if the device tree specified the interrupt as "IRQ_TYPE_LEVEL_LOW",
unloading and reloading of the driver results in the following error during
ifup:

| irq: type mismatch, failed to map hwirq-31 for gpio@20a8000!
| tcan4x5x spi1.1: m_can device registered (irq=0, version=32)
| tcan4x5x spi1.1 can2: TCAN4X5X successfully initialized.
| tcan4x5x spi1.1 can2: failed to request interrupt

This patch fixes the problem by removing the IRQF_TRIGGER_FALLING from the
request_threaded_irq().

Fixes: f524f829b75a ("can: m_can: Create a m_can platform framework")
Cc: Dan Murphy <dmurphy@ti.com>
Cc: Sriram Dash <sriram.dash@samsung.com>
Cc: Pankaj Sharma <pankj.sharma@samsung.com>
Link: https://lore.kernel.org/r/20201127093548.509253-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index f3fc37e96b08..c62439bdee28 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1653,7 +1653,7 @@ static int m_can_open(struct net_device *dev)
 		INIT_WORK(&cdev->tx_work, m_can_tx_work_queue);
 
 		err = request_threaded_irq(dev->irq, NULL, m_can_isr,
-					   IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
+					   IRQF_ONESHOT,
 					   dev->name, dev);
 	} else {
 		err = request_irq(dev->irq, m_can_isr, IRQF_SHARED, dev->name,
-- 
2.29.2


