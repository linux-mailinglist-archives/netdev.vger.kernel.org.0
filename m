Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C992B03C3
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgKLLWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:22:34 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7177 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgKLLWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:22:32 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CWzhZ3Pj5z15VfX;
        Thu, 12 Nov 2020 19:22:06 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Thu, 12 Nov 2020 19:22:12 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <m.felsch@pengutronix.de>, <f.fainelli@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: phy: smsc: add missed clk_disable_unprepare in smsc_phy_probe()
Date:   Thu, 12 Nov 2020 19:23:59 +0800
Message-ID: <1605180239-1792-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missing clk_disable_unprepare() before return from
smsc_phy_probe() in the error handling case.

Fixes: bedd8d78aba3 ("net: phy: smsc: LAN8710/20: add phy refclk in support")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/phy/smsc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index ec97669..0fc39ac 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -291,8 +291,10 @@ static int smsc_phy_probe(struct phy_device *phydev)
 		return ret;
 
 	ret = clk_set_rate(priv->refclk, 50 * 1000 * 1000);
-	if (ret)
+	if (ret) {
+		clk_disable_unprepare(priv->refclk);
 		return ret;
+	}
 
 	return 0;
 }
-- 
2.9.5

