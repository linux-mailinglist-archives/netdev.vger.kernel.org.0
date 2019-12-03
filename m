Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C59510FBF6
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 11:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbfLCKrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 05:47:11 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:41679 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfLCKrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 05:47:10 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ic5i0-0001BG-DU; Tue, 03 Dec 2019 11:47:08 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Venkatesh Yadav Abbarapu <venkatesh.abbarapu@xilinx.com>,
        Srinivas Neeli <srinivas.neeli@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5/6] can: xilinx_can: skip error message on deferred probe
Date:   Tue,  3 Dec 2019 11:47:02 +0100
Message-Id: <20191203104703.14620-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203104703.14620-1-mkl@pengutronix.de>
References: <20191203104703.14620-1-mkl@pengutronix.de>
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

From: Venkatesh Yadav Abbarapu <venkatesh.abbarapu@xilinx.com>

When the CAN bus clock is provided from the clock wizard, clock wizard
driver may not be available when can driver probes resulting to the
error message "bus clock not found error".

As this error message is not very useful to the end user, skip printing
in the case of deferred probe.

Signed-off-by: Venkatesh Yadav Abbarapu <venkatesh.abbarapu@xilinx.com>
Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Reviewed-by: Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/xilinx_can.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 4a96e2dd7d77..c5f05b994435 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -1772,7 +1772,8 @@ static int xcan_probe(struct platform_device *pdev)
 
 	priv->bus_clk = devm_clk_get(&pdev->dev, devtype->bus_clk_name);
 	if (IS_ERR(priv->bus_clk)) {
-		dev_err(&pdev->dev, "bus clock not found\n");
+		if (PTR_ERR(priv->bus_clk) != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "bus clock not found\n");
 		ret = PTR_ERR(priv->bus_clk);
 		goto err_free;
 	}
-- 
2.24.0

