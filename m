Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012FC3929F1
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 10:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235715AbhE0IuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 04:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235555AbhE0Itw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 04:49:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4C0C061344
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 01:48:19 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lmBgf-00020v-GD
        for netdev@vger.kernel.org; Thu, 27 May 2021 10:48:17 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 6B6ED62D49B
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 08:45:44 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 18F7B62D3F3;
        Thu, 27 May 2021 08:45:36 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 4070e316;
        Thu, 27 May 2021 08:45:34 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        kernel test robot <lkp@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [net-next 11/21] can: mcp251x: mcp251x_can_probe(): silence clang warning
Date:   Thu, 27 May 2021 10:45:22 +0200
Message-Id: <20210527084532.1384031-12-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210527084532.1384031-1-mkl@pengutronix.de>
References: <20210527084532.1384031-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch silences the following clang warning:

| drivers/net/can/spi/mcp251x.c:1333:17: warning: cast to smaller integer type
| 'enum mcp251x_model' from 'const void *' [-Wvoid-pointer-to-enum-cast]
|                 priv->model = (enum mcp251x_model)match;
|                               ^~~~~~~~~~~~~~~~~~~~~~~~~

Fixes: 8de29a5c34a5 ("can: mcp251x: Make use of device property API")
Link: https://lore.kernel.org/r/20210504200520.1179635-2-mkl@pengutronix.de
Reported-by: kernel test robot <lkp@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 173c6614086f..0579ab74f728 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -1330,7 +1330,7 @@ static int mcp251x_can_probe(struct spi_device *spi)
 	priv->can.ctrlmode_supported = CAN_CTRLMODE_3_SAMPLES |
 		CAN_CTRLMODE_LOOPBACK | CAN_CTRLMODE_LISTENONLY;
 	if (match)
-		priv->model = (enum mcp251x_model)match;
+		priv->model = (enum mcp251x_model)(uintptr_t)match;
 	else
 		priv->model = spi_get_device_id(spi)->driver_data;
 	priv->net = net;
-- 
2.30.2


