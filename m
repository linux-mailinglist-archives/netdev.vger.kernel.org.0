Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B083929D9
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 10:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235606AbhE0Itv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 04:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235555AbhE0Itr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 04:49:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033E1C061574
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 01:48:15 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lmBgb-0001wL-Cj
        for netdev@vger.kernel.org; Thu, 27 May 2021 10:48:13 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 25A5F62D47B
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 08:45:42 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D75A362D3EF;
        Thu, 27 May 2021 08:45:35 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 443cdd57;
        Thu, 27 May 2021 08:45:34 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 10/21] can: hi311x: hi3110_can_probe(): silence clang warning
Date:   Thu, 27 May 2021 10:45:21 +0200
Message-Id: <20210527084532.1384031-11-mkl@pengutronix.de>
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

| drivers/net/can/spi/hi311x.c:874:17: warning: cast to smaller integer type
| 'enum hi3110_model' from 'const void *' [-Wvoid-pointer-to-enum-cast]
|                 priv->model = (enum hi3110_model)of_id->data;
|                               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fixes: 57e83fb9b746 ("can: hi311x: Add Holt HI-311x CAN driver")
Link: https://lore.kernel.org/r/20210504200520.1179635-3-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/hi311x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index 6f5d6d04a8b9..dd17b8c53e1c 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -871,7 +871,7 @@ static int hi3110_can_probe(struct spi_device *spi)
 		CAN_CTRLMODE_BERR_REPORTING;
 
 	if (of_id)
-		priv->model = (enum hi3110_model)of_id->data;
+		priv->model = (enum hi3110_model)(uintptr_t)of_id->data;
 	else
 		priv->model = spi_get_device_id(spi)->driver_data;
 	priv->net = net;
-- 
2.30.2


