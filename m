Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6043FD788C
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 16:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732797AbfJOObM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 10:31:12 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:49136 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732087AbfJOObM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 10:31:12 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 92D10AC8FF81A9E06E9B;
        Tue, 15 Oct 2019 22:31:10 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 15 Oct 2019
 22:31:00 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <wsa+renesas@sang-engineering.com>, <horms+renesas@verge.net.au>,
        <swboyd@chromium.org>, <fabrizio.castro@bp.renesas.com>,
        <geert+renesas@glider.be>, <yuehaibing@huawei.com>,
        <nikita.yoush@cogentembedded.com>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] can: rcar: use devm_platform_ioremap_resource() to simplify code
Date:   Tue, 15 Oct 2019 22:30:47 +0800
Message-ID: <20191015143047.19440-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_platform_ioremap_resource() to simplify the code a bit.
This is detected by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/can/rcar/rcar_can.c   | 4 +---
 drivers/net/can/rcar/rcar_canfd.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_can.c b/drivers/net/can/rcar/rcar_can.c
index bf5adea..4857590 100644
--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -744,7 +744,6 @@ static int rcar_can_probe(struct platform_device *pdev)
 {
 	struct rcar_can_priv *priv;
 	struct net_device *ndev;
-	struct resource *mem;
 	void __iomem *addr;
 	u32 clock_select = CLKR_CLKP1;
 	int err = -ENODEV;
@@ -759,8 +758,7 @@ static int rcar_can_probe(struct platform_device *pdev)
 		goto fail;
 	}
 
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	addr = devm_ioremap_resource(&pdev->dev, mem);
+	addr = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(addr)) {
 		err = PTR_ERR(addr);
 		goto fail;
diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index edaa1ca..de59dd6 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1630,7 +1630,6 @@ static void rcar_canfd_channel_remove(struct rcar_canfd_global *gpriv, u32 ch)
 
 static int rcar_canfd_probe(struct platform_device *pdev)
 {
-	struct resource *mem;
 	void __iomem *addr;
 	u32 sts, ch, fcan_freq;
 	struct rcar_canfd_global *gpriv;
@@ -1704,8 +1703,7 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 		/* CANFD clock is further divided by (1/2) within the IP */
 		fcan_freq /= 2;
 
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	addr = devm_ioremap_resource(&pdev->dev, mem);
+	addr = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(addr)) {
 		err = PTR_ERR(addr);
 		goto fail_dev;
-- 
2.7.4


