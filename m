Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99E6C1915B3
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 17:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgCXQKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 12:10:18 -0400
Received: from foss.arm.com ([217.140.110.172]:37608 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727545AbgCXQKS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 12:10:18 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A9B31FB;
        Tue, 24 Mar 2020 09:10:18 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.25])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D99F33F52E;
        Tue, 24 Mar 2020 09:10:16 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH] net: PHY: bcm-unimac: Fix clock handling
Date:   Tue, 24 Mar 2020 16:10:10 +0000
Message-Id: <20200324161010.81107-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DT binding for this PHY describes an *optional* clock property.
Due to a bug in the error handling logic, we are actually ignoring this
clock *all* of the time so far.

Fix this by using devm_clk_get_optional() to handle this clock properly.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 drivers/net/phy/mdio-bcm-unimac.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/mdio-bcm-unimac.c b/drivers/net/phy/mdio-bcm-unimac.c
index 4a28fb29adaa..fbd36891ee64 100644
--- a/drivers/net/phy/mdio-bcm-unimac.c
+++ b/drivers/net/phy/mdio-bcm-unimac.c
@@ -242,11 +242,9 @@ static int unimac_mdio_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	priv->clk = devm_clk_get(&pdev->dev, NULL);
-	if (PTR_ERR(priv->clk) == -EPROBE_DEFER)
+	priv->clk = devm_clk_get_optional(&pdev->dev, NULL);
+	if (IS_ERR(priv->clk))
 		return PTR_ERR(priv->clk);
-	else
-		priv->clk = NULL;
 
 	ret = clk_prepare_enable(priv->clk);
 	if (ret)
-- 
2.17.1

