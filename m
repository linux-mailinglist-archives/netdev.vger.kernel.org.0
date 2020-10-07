Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B49286A3A
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 23:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbgJGVcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 17:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728771AbgJGVce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 17:32:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E24C0613AA
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 14:32:22 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kQH2r-0005qi-0R; Wed, 07 Oct 2020 23:32:21 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Srinivas Neeli <srinivas.neeli@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 17/17] can: xilinx_can: Fix incorrect variable and initialize with a default value
Date:   Wed,  7 Oct 2020 23:31:59 +0200
Message-Id: <20201007213159.1959308-18-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201007213159.1959308-1-mkl@pengutronix.de>
References: <20201007213159.1959308-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Srinivas Neeli <srinivas.neeli@xilinx.com>

Some variables with incorrect type were passed to "of_property_read_u32"
API, "of_property_read_u32" API was expecting an "u32 *" but the formal
parameter that was passed was of type "int *". Fixed the issue by
changing the variable types from "int" to "u32" and initialized with a
default value. Fixed sparse warning.

Addresses-Coverity: "incompatible_param"
Addresses-Coverity: "UNINIT(Using uninitialized value)"
Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Link: https://lore.kernel.org/r/0651544d22f3c25893ca9d445b14823f0dfddfc8.1600073396.git.michal.simek@xilinx.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/xilinx_can.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 9ea6ad73b07d..6c4d00d2dbdc 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -1671,7 +1671,7 @@ static int xcan_probe(struct platform_device *pdev)
 	void __iomem *addr;
 	int ret;
 	int rx_max, tx_max;
-	int hw_tx_max, hw_rx_max;
+	u32 hw_tx_max = 0, hw_rx_max = 0;
 	const char *hw_tx_max_property;
 
 	/* Get the virtual base address for the device */
@@ -1724,7 +1724,7 @@ static int xcan_probe(struct platform_device *pdev)
 	 */
 	if (!(devtype->flags & XCAN_FLAG_TX_MAILBOXES) &&
 	    (devtype->flags & XCAN_FLAG_TXFEMP))
-		tx_max = min(hw_tx_max, 2);
+		tx_max = min(hw_tx_max, 2U);
 	else
 		tx_max = 1;
 
-- 
2.28.0

