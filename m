Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B2A2F452F
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 08:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbhAMH0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 02:26:15 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10719 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726235AbhAMH0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 02:26:14 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DFzTS32hbzl4FT;
        Wed, 13 Jan 2021 15:24:12 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Wed, 13 Jan 2021 15:25:21 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Thomas Kopp <thomas.kopp@microchip.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Qinglang Miao <miaoqinglang@huawei.com>
Subject: [PATCH] can: mcp251xfd: fix wrong check in mcp251xfd_handle_rxif_one
Date:   Wed, 13 Jan 2021 15:31:00 +0800
Message-ID: <20210113073100.79552-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If alloc_canfd_skb returns NULL, 'cfg' is an uninitialized
variable, so we should check 'skb' rather than 'cfd' after
calling alloc_canfd_skb(priv->ndev, &cfd).

Fixes: 55e5b97f003e ("can: mcp25xxfd: add driver for Microchip MCP25xxFD SPI CAN")
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 77129d5f4..792d55ba4 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -1492,7 +1492,7 @@ mcp251xfd_handle_rxif_one(struct mcp251xfd_priv *priv,
 	else
 		skb = alloc_can_skb(priv->ndev, (struct can_frame **)&cfd);
 
-	if (!cfd) {
+	if (!skb) {
 		stats->rx_dropped++;
 		return 0;
 	}
-- 
2.23.0

