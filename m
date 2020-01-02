Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC3512E887
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 17:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbgABQJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 11:09:59 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:46347 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728804AbgABQJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 11:09:40 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1in32Z-0000mM-2R; Thu, 02 Jan 2020 17:09:39 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Dan Murphy <dmurphy@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5/9] can: tcan4x5x: tcan4x5x_parse_config(): fix inconsistent IS_ERR and PTR_ERR
Date:   Thu,  2 Jan 2020 17:09:30 +0100
Message-Id: <20200102160934.1524-6-mkl@pengutronix.de>
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

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

Fix inconsistent IS_ERR and PTR_ERR in tcan4x5x_parse_config().

The proper pointer to be passed as argument is tcan4x5x->device_wake_gpio.

This bug was detected with the help of Coccinelle.

Fixes: 2de497356955 ("can: tcan45x: Make wake-up GPIO an optional GPIO")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Acked-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/tcan4x5x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/tcan4x5x.c b/drivers/net/can/m_can/tcan4x5x.c
index a413e7548546..eacd428e07e9 100644
--- a/drivers/net/can/m_can/tcan4x5x.c
+++ b/drivers/net/can/m_can/tcan4x5x.c
@@ -387,7 +387,7 @@ static int tcan4x5x_parse_config(struct m_can_classdev *cdev)
 	tcan4x5x->device_wake_gpio = devm_gpiod_get(cdev->dev, "device-wake",
 						    GPIOD_OUT_HIGH);
 	if (IS_ERR(tcan4x5x->device_wake_gpio)) {
-		if (PTR_ERR(tcan4x5x->power) == -EPROBE_DEFER)
+		if (PTR_ERR(tcan4x5x->device_wake_gpio) == -EPROBE_DEFER)
 			return -EPROBE_DEFER;
 
 		tcan4x5x_disable_wake(cdev);
-- 
2.24.1

