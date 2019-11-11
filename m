Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C20BCF6EFC
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 08:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfKKHUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 02:20:25 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:45880 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726360AbfKKHUZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 02:20:25 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 23B4FBE7B83F4ABC15A6;
        Mon, 11 Nov 2019 15:20:23 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Mon, 11 Nov 2019
 15:20:14 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <mail@david-bauer.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] mdio_bus: Fix PTR_ERR applied after initialization to constant
Date:   Mon, 11 Nov 2019 15:13:47 +0800
Message-ID: <20191111071347.21712-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix coccinelle warning:

./drivers/net/phy/mdio_bus.c:67:5-12: ERROR: PTR_ERR applied after initialization to constant on line 62
./drivers/net/phy/mdio_bus.c:68:5-12: ERROR: PTR_ERR applied after initialization to constant on line 62

Fix this by using IS_ERR before PTR_ERR

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 71dd6c0dff51 ("net: phy: add support for reset-controller")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/phy/mdio_bus.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 2e29ab8..3587656 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -64,11 +64,12 @@ static int mdiobus_register_reset(struct mdio_device *mdiodev)
 	if (mdiodev->dev.of_node)
 		reset = devm_reset_control_get_exclusive(&mdiodev->dev,
 							 "phy");
-	if (PTR_ERR(reset) == -ENOENT ||
-	    PTR_ERR(reset) == -ENOTSUPP)
-		reset = NULL;
-	else if (IS_ERR(reset))
-		return PTR_ERR(reset);
+	if (IS_ERR(reset)) {
+		if (PTR_ERR(reset) == -ENOENT || PTR_ERR(reset) == -ENOSYS)
+			reset = NULL;
+		else
+			return PTR_ERR(reset);
+	}
 
 	mdiodev->reset_ctrl = reset;
 
-- 
2.7.4


