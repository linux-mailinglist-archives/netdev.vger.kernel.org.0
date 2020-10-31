Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A092A1349
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 04:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbgJaDLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 23:11:08 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7120 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgJaDLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 23:11:08 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CNPMX5YHGzLrv5;
        Sat, 31 Oct 2020 11:11:04 +0800 (CST)
Received: from localhost (10.174.176.180) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Sat, 31 Oct 2020
 11:10:58 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <linux@armlinux.org.uk>, <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] sfp: Fix error handing in sfp_probe()
Date:   Sat, 31 Oct 2020 11:10:53 +0800
Message-ID: <20201031031053.25264-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.176.180]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gpiod_to_irq() never return 0, but returns negative in
case of error, check it and set gpio_irq to 0.

Fixes: 73970055450e ("sfp: add SFP module support")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/phy/sfp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 1d18c10e8f82..34aa196b7465 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -2389,7 +2389,8 @@ static int sfp_probe(struct platform_device *pdev)
 			continue;
 
 		sfp->gpio_irq[i] = gpiod_to_irq(sfp->gpio[i]);
-		if (!sfp->gpio_irq[i]) {
+		if (sfp->gpio_irq[i] < 0) {
+			sfp->gpio_irq[i] = 0;
 			sfp->need_poll = true;
 			continue;
 		}
-- 
2.17.1

