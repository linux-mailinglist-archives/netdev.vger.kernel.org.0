Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF02712E870
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 17:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgABQJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 11:09:39 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:54449 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728755AbgABQJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 11:09:38 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1in32X-0000mM-5Y; Thu, 02 Jan 2020 17:09:37 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Sean Nyekjaer <sean@geanix.com>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 1/9] can: tcan4x5x: tcan4x5x_can_probe(): get the device out of standby before register access
Date:   Thu,  2 Jan 2020 17:09:26 +0100
Message-Id: <20200102160934.1524-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102160934.1524-1-mkl@pengutronix.de>
References: <20200102160934.1524-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Nyekjaer <sean@geanix.com>

The m_can tries to detect if Non ISO Operation is available while in
standby mode, this function results in the following error:

| tcan4x5x spi2.0 (unnamed net_device) (uninitialized): Failed to init module
| tcan4x5x spi2.0: m_can device registered (irq=84, version=32)
| tcan4x5x spi2.0 can2: TCAN4X5X successfully initialized.

When the tcan device comes out of reset it goes in standby mode. The
m_can driver tries to access the control register but fails due to the
device being in standby mode.

So this patch will put the tcan device in normal mode before the m_can
driver does the initialization.

Fixes: 5443c226ba91 ("can: tcan4x5x: Add tcan4x5x driver to the kernel")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Acked-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/tcan4x5x.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
index 4e1789ea2bc3..c9fb864fcfa1 100644
--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -457,6 +457,10 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 
 	tcan4x5x_power_enable(priv->power, 1);
 
+	ret = tcan4x5x_init(mcan_class);
+	if (ret)
+		goto out_power;
+
 	ret = m_can_class_register(mcan_class);
 	if (ret)
 		goto out_power;
-- 
2.24.1

