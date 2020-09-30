Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196D027F337
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 22:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730407AbgI3US4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 16:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730117AbgI3USZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 16:18:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA8BC061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 13:18:25 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kNiYR-0002Qt-LQ; Wed, 30 Sep 2020 22:18:23 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Dan Carpenter <dan.carpenter@oracle.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 03/13] can: mcp25xxfd: mcp25xxfd_ring_free(): fix memory leak during cleanup
Date:   Wed, 30 Sep 2020 22:18:06 +0200
Message-Id: <20200930201816.1032054-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200930201816.1032054-1-mkl@pengutronix.de>
References: <20200930201816.1032054-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

This loop doesn't free the first element of the array.  The "i > 0" has
to be changed to "i >= 0".

Fixes: 55e5b97f003e ("can: mcp25xxfd: add driver for Microchip MCP25xxFD SPI CAN")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20200923112752.GA1473821@mwanda
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c
index c094bb716256..b91180b560fd 100644
--- a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-core.c
@@ -377,7 +377,7 @@ static void mcp25xxfd_ring_free(struct mcp25xxfd_priv *priv)
 {
 	int i;
 
-	for (i = ARRAY_SIZE(priv->rx) - 1; i > 0; i--) {
+	for (i = ARRAY_SIZE(priv->rx) - 1; i >= 0; i--) {
 		kfree(priv->rx[i]);
 		priv->rx[i] = NULL;
 	}
-- 
2.28.0

