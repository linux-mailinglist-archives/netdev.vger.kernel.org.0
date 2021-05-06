Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D30A37504E
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 09:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbhEFHla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 03:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233543AbhEFHlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 03:41:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3905C061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 00:40:24 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1leYcR-0003Ci-8j
        for netdev@vger.kernel.org; Thu, 06 May 2021 09:40:23 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 8D4AF61DD87
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 07:40:19 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 1BCB061DD6D;
        Thu,  6 May 2021 07:40:18 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id ecd8dc44;
        Thu, 6 May 2021 07:40:17 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Dan Carpenter <dan.carpenter@oracle.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 1/4] can: mcp251xfd: mcp251xfd_probe(): fix an error pointer dereference in probe
Date:   Thu,  6 May 2021 09:40:12 +0200
Message-Id: <20210506074015.1300591-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210506074015.1300591-1-mkl@pengutronix.de>
References: <20210506074015.1300591-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

When we converted this code to use dev_err_probe() we accidentally
removed a return. It means that if devm_clk_get() it will lead to an
Oops when we call clk_get_rate() on the next line.

Fixes: cf8ee6de2543 ("can: mcp251xfd: mcp251xfd_probe(): use dev_err_probe() to simplify error handling")
Link: https://lore.kernel.org/r/YJANZf13Qxd5Mhr1@mwanda
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 970dc570e7a5..f122976e90da 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -2885,8 +2885,8 @@ static int mcp251xfd_probe(struct spi_device *spi)
 
 	clk = devm_clk_get(&spi->dev, NULL);
 	if (IS_ERR(clk))
-		dev_err_probe(&spi->dev, PTR_ERR(clk),
-			      "Failed to get Oscillator (clock)!\n");
+		return dev_err_probe(&spi->dev, PTR_ERR(clk),
+				     "Failed to get Oscillator (clock)!\n");
 	freq = clk_get_rate(clk);
 
 	/* Sanity check */

base-commit: 8621436671f3a4bba5db57482e1ee604708bf1eb
-- 
2.30.2


