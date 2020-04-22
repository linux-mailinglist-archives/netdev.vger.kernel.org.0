Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1632B1B39C3
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 10:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgDVIOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 04:14:24 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:2390 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgDVIOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 04:14:23 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.1]) by rmmx-syy-dmz-app10-12010 (RichMail) with SMTP id 2eea5e9ffcc0d7f-02096; Wed, 22 Apr 2020 16:13:53 +0800 (CST)
X-RM-TRANSID: 2eea5e9ffcc0d7f-02096
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[112.25.154.146])
        by rmsmtp-syy-appsvr01-12001 (RichMail) with SMTP id 2ee15e9ffcbef88-bc4f9;
        Wed, 22 Apr 2020 16:13:53 +0800 (CST)
X-RM-TRANSID: 2ee15e9ffcbef88-bc4f9
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Subject: [PATCH] net: phy: Use IS_ERR() to check and simplify code
Date:   Wed, 22 Apr 2020 16:15:42 +0800
Message-Id: <20200422081542.8344-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use IS_ERR() and PTR_ERR() instead of PTR_ZRR_OR_ZERO()
to simplify code, avoid redundant paramenter definitions
and judgements.

Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 drivers/net/phy/mdio_bus.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 9bb9f37f2..b1114f204 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -42,14 +42,11 @@
 
 static int mdiobus_register_gpiod(struct mdio_device *mdiodev)
 {
-	int error;
-
 	/* Deassert the optional reset signal */
 	mdiodev->reset_gpio = gpiod_get_optional(&mdiodev->dev,
 						 "reset", GPIOD_OUT_LOW);
-	error = PTR_ERR_OR_ZERO(mdiodev->reset_gpio);
-	if (error)
-		return error;
+	if (IS_ERR(mdiodev->reset_gpio))
+		return PTR_ERR(mdiodev->reset_gpio);
 
 	if (mdiodev->reset_gpio)
 		gpiod_set_consumer_name(mdiodev->reset_gpio, "PHY reset");
-- 
2.20.1.windows.1



