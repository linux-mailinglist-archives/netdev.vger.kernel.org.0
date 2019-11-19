Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0C5C1022F8
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 12:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbfKSLZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 06:25:29 -0500
Received: from laurent.telenet-ops.be ([195.130.137.89]:54682 "EHLO
        laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfKSLZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 06:25:29 -0500
Received: from ramsan ([84.195.182.253])
        by laurent.telenet-ops.be with bizsmtp
        id TnRS210045USYZQ01nRSVD; Tue, 19 Nov 2019 12:25:27 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iX1dN-00021D-Tz; Tue, 19 Nov 2019 12:25:25 +0100
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iX1dN-0006TQ-Ro; Tue, 19 Nov 2019 12:25:25 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] mdio_bus: Fix init if CONFIG_RESET_CONTROLLER=n
Date:   Tue, 19 Nov 2019 12:25:24 +0100
Message-Id: <20191119112524.24841-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 1d4639567d970de0 ("mdio_bus: Fix PTR_ERR applied after
initialization to constant") accidentally changed a check from -ENOTSUPP
to -ENOSYS, causing failures if reset controller support is not enabled.
E.g. on r7s72100/rskrza1:

    sh-eth e8203000.ethernet: MDIO init failed: -524
    sh-eth: probe of e8203000.ethernet failed with error -524

Fixes: 1d4639567d970de0 ("mdio_bus: Fix PTR_ERR applied after initialization to constant")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
This is a regression in v5.4-rc8.
Seen on r8a7740/armadillo, r7s72100/rskrza1, and r7s9210/rza2mevb.
---
 drivers/net/phy/mdio_bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 35876562e32a02ce..dbacb00318775ff1 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -65,7 +65,7 @@ static int mdiobus_register_reset(struct mdio_device *mdiodev)
 		reset = devm_reset_control_get_exclusive(&mdiodev->dev,
 							 "phy");
 	if (IS_ERR(reset)) {
-		if (PTR_ERR(reset) == -ENOENT || PTR_ERR(reset) == -ENOSYS)
+		if (PTR_ERR(reset) == -ENOENT || PTR_ERR(reset) == -ENOTSUPP)
 			reset = NULL;
 		else
 			return PTR_ERR(reset);
-- 
2.17.1

