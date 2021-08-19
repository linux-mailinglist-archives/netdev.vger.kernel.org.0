Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03CEC3F1ABF
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 15:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240377AbhHSNkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 09:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240328AbhHSNkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 09:40:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C39EC061292
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 06:39:45 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mGiGl-00058h-FG
        for netdev@vger.kernel.org; Thu, 19 Aug 2021 15:39:43 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id AD5BC66A897
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 13:39:36 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 673F866A847;
        Thu, 19 Aug 2021 13:39:28 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 745edfd6;
        Thu, 19 Aug 2021 13:39:16 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Dario Binacchi <dariobin@libero.it>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 19/22] can: c_can: remove struct c_can_priv::priv field
Date:   Thu, 19 Aug 2021 15:39:10 +0200
Message-Id: <20210819133913.657715-20-mkl@pengutronix.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210819133913.657715-1-mkl@pengutronix.de>
References: <20210819133913.657715-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dario Binacchi <dariobin@libero.it>

It references the clock but it is never used. So let's remove it.

Link: https://lore.kernel.org/r/20210807130800.5246-2-dariobin@libero.it
Signed-off-by: Dario Binacchi <dariobin@libero.it>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/c_can/c_can.h          | 1 -
 drivers/net/can/c_can/c_can_platform.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index 4247ff80a29c..8f23e9c83c84 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -200,7 +200,6 @@ struct c_can_priv {
 	void (*write_reg32)(const struct c_can_priv *priv, enum reg index, u32 val);
 	void __iomem *base;
 	const u16 *regs;
-	void *priv;		/* for board-specific data */
 	enum c_can_dev_id type;
 	struct c_can_raminit raminit_sys;	/* RAMINIT via syscon regmap */
 	void (*raminit)(const struct c_can_priv *priv, bool enable);
diff --git a/drivers/net/can/c_can/c_can_platform.c b/drivers/net/can/c_can/c_can_platform.c
index 36950363682f..86e95e9d6533 100644
--- a/drivers/net/can/c_can/c_can_platform.c
+++ b/drivers/net/can/c_can/c_can_platform.c
@@ -385,7 +385,6 @@ static int c_can_plat_probe(struct platform_device *pdev)
 	priv->base = addr;
 	priv->device = &pdev->dev;
 	priv->can.clock.freq = clk_get_rate(clk);
-	priv->priv = clk;
 	priv->type = drvdata->id;
 
 	platform_set_drvdata(pdev, dev);
-- 
2.32.0


