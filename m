Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150A426F8A2
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 10:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgIRItL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 04:49:11 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13296 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725900AbgIRItL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 04:49:11 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4A0AE62D3D8A4CDEAB09;
        Fri, 18 Sep 2020 16:49:07 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Fri, 18 Sep 2020 16:48:58 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <ulli.kroll@googlemail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: cortina: Remove set but not used variable
Date:   Fri, 18 Sep 2020 16:49:51 +0800
Message-ID: <20200918084951.21130-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/ethernet/cortina/gemini.c: In function gmac_get_ringparam:
drivers/net/ethernet/cortina/gemini.c:2125:21: warning: variable ‘config0’ set but not used [-Wunused-but-set-variable]

drivers/net/ethernet/cortina/gemini.c: In function gmac_init:
drivers/net/ethernet/cortina/gemini.c:512:6: warning: variable ‘val’ set but not used [-Wunused-but-set-variable]

these variable is never used, so remove it.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/cortina/gemini.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index ffec0f3dd957..1ca4da9909c3 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -509,7 +509,6 @@ static int gmac_init(struct net_device *netdev)
 		.rel_threshold = 0,
 	} };
 	union gmac_config0 tmp;
-	u32 val;
 
 	config0.bits.max_len = gmac_pick_rx_max_len(netdev->mtu);
 	tmp.bits32 = readl(port->gmac_base + GMAC_CONFIG0);
@@ -519,7 +518,7 @@ static int gmac_init(struct net_device *netdev)
 	writel(config2.bits32, port->gmac_base + GMAC_CONFIG2);
 	writel(config3.bits32, port->gmac_base + GMAC_CONFIG3);
 
-	val = readl(port->dma_base + GMAC_AHB_WEIGHT_REG);
+	readl(port->dma_base + GMAC_AHB_WEIGHT_REG);
 	writel(ahb_weight.bits32, port->dma_base + GMAC_AHB_WEIGHT_REG);
 
 	writel(hw_weigh.bits32,
@@ -2122,9 +2121,8 @@ static void gmac_get_ringparam(struct net_device *netdev,
 			       struct ethtool_ringparam *rp)
 {
 	struct gemini_ethernet_port *port = netdev_priv(netdev);
-	union gmac_config0 config0;
 
-	config0.bits32 = readl(port->gmac_base + GMAC_CONFIG0);
+	readl(port->gmac_base + GMAC_CONFIG0);
 
 	rp->rx_max_pending = 1 << 15;
 	rp->rx_mini_max_pending = 0;
-- 
2.17.1

