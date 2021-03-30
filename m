Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2566234E69D
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 13:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbhC3LrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 07:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbhC3Lq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 07:46:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4BCC061765
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 04:46:27 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lRCpF-000615-KN
        for netdev@vger.kernel.org; Tue, 30 Mar 2021 13:46:25 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 80E5A603E45
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 11:46:14 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 66CA3603DF2;
        Tue, 30 Mar 2021 11:46:06 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 4bb851a8;
        Tue, 30 Mar 2021 11:46:00 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Michal Simek <michal.simek@xilinx.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 12/39] can: xilinx_can: Simplify code by using dev_err_probe()
Date:   Tue, 30 Mar 2021 13:45:32 +0200
Message-Id: <20210330114559.1114855-13-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330114559.1114855-1-mkl@pengutronix.de>
References: <20210330114559.1114855-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>

Use already prepared dev_err_probe() introduced by commit a787e5400a1c
("driver core: add device probe log helper").
It simplifies EPROBE_DEFER handling.

Also unify message format for similar error cases.

Link: https://lore.kernel.org/r/91af0945ed7397b08f1af0c829450620bd92b804.1612442564.git.michal.simek@xilinx.com
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/xilinx_can.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 37fa19c62d73..3b883e607d8b 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -1772,17 +1772,15 @@ static int xcan_probe(struct platform_device *pdev)
 	/* Getting the CAN can_clk info */
 	priv->can_clk = devm_clk_get(&pdev->dev, "can_clk");
 	if (IS_ERR(priv->can_clk)) {
-		if (PTR_ERR(priv->can_clk) != -EPROBE_DEFER)
-			dev_err(&pdev->dev, "Device clock not found.\n");
-		ret = PTR_ERR(priv->can_clk);
+		ret = dev_err_probe(&pdev->dev, PTR_ERR(priv->can_clk),
+				    "device clock not found\n");
 		goto err_free;
 	}
 
 	priv->bus_clk = devm_clk_get(&pdev->dev, devtype->bus_clk_name);
 	if (IS_ERR(priv->bus_clk)) {
-		if (PTR_ERR(priv->bus_clk) != -EPROBE_DEFER)
-			dev_err(&pdev->dev, "bus clock not found\n");
-		ret = PTR_ERR(priv->bus_clk);
+		ret = dev_err_probe(&pdev->dev, PTR_ERR(priv->bus_clk),
+				    "bus clock not found\n");
 		goto err_free;
 	}
 
-- 
2.30.2


