Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258802F583A
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbhANCQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:16:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729073AbhAMVW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 16:22:57 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08441C0617A2
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 13:22:05 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kznad-0002wq-K4
        for netdev@vger.kernel.org; Wed, 13 Jan 2021 22:22:03 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 8EF295C30ED
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 21:22:01 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 20F1D5C30D9;
        Wed, 13 Jan 2021 21:22:00 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 5eea5b43;
        Wed, 13 Jan 2021 21:21:59 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Qinglang Miao <miaoqinglang@huawei.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 2/2] can: mcp251xfd: mcp251xfd_handle_rxif_one(): fix wrong NULL pointer check
Date:   Wed, 13 Jan 2021 22:21:58 +0100
Message-Id: <20210113212158.925513-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210113212158.925513-1-mkl@pengutronix.de>
References: <20210113212158.925513-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

If alloc_canfd_skb() returns NULL, 'cfg' is an uninitialized variable, so we
should check 'skb' rather than 'cfd' after calling alloc_canfd_skb(priv->ndev,
&cfd).

Fixes: 55e5b97f003e ("can: mcp25xxfd: add driver for Microchip MCP25xxFD SPI CAN")
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20210113073100.79552-1-miaoqinglang@huawei.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 36235afb0bc6..f07e8b737d31 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -1491,7 +1491,7 @@ mcp251xfd_handle_rxif_one(struct mcp251xfd_priv *priv,
 	else
 		skb = alloc_can_skb(priv->ndev, (struct can_frame **)&cfd);
 
-	if (!cfd) {
+	if (!skb) {
 		stats->rx_dropped++;
 		return 0;
 	}
-- 
2.29.2


