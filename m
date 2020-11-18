Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26082B816D
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgKRQEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 11:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgKRQEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 11:04:22 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C62C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 08:04:21 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kfPwR-0001km-PI; Wed, 18 Nov 2020 17:04:19 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 4/4] can: m_can: process interrupt only when not runtime suspended
Date:   Wed, 18 Nov 2020 17:04:14 +0100
Message-Id: <20201118160414.2731659-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201118160414.2731659-1-mkl@pengutronix.de>
References: <20201118160414.2731659-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

Avoid processing bogus interrupt statuses when the HW is runtime suspended and
the M_CAN_IR register read may get all bits 1's. Handler can be called if the
interrupt request is shared with other peripherals or at the end of free_irq().

Therefore check the runtime suspended status before processing.

Fixes: cdf8259d6573 ("can: m_can: Add PM Support")
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/r/20200915134715.696303-1-jarkko.nikula@linux.intel.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index e7264043f79a..f3fc37e96b08 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -956,6 +956,8 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 	struct net_device_stats *stats = &dev->stats;
 	u32 ir;
 
+	if (pm_runtime_suspended(cdev->dev))
+		return IRQ_NONE;
 	ir = m_can_read(cdev, M_CAN_IR);
 	if (!ir)
 		return IRQ_NONE;
-- 
2.29.2

