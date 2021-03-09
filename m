Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1378C3323F1
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 12:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhCIL0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 06:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhCIL0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 06:26:22 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C24C06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 03:26:21 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lJaVF-0006wd-8I; Tue, 09 Mar 2021 12:26:17 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lJaVE-0000BM-2Z; Tue, 09 Mar 2021 12:26:16 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: [PATCH v2 2/7] ARM: imx6q: remove TX clock delay of ar8031_phy_fixup()
Date:   Tue,  9 Mar 2021 12:26:10 +0100
Message-Id: <20210309112615.625-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210309112615.625-1-o.rempel@pengutronix.de>
References: <20210309112615.625-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case the at803x PHY driver is activated in the kernel, the TX clock
fixup is overwritten by at803x_config_init(), in this case no additional
device tree changes are needed.

If this patch breaks your system, please enable AT803X_PHY driver and
add the following device tree property to the PHY node:

    phy-mode = "rgmii-txid";

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 arch/arm/mach-imx/mach-imx6q.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index 78205f90da27..1abefe7e1c3a 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -82,12 +82,6 @@ static int ar8031_phy_fixup(struct phy_device *dev)
 	val |= 0x18;
 	phy_write(dev, 0xe, val);
 
-	/* introduce tx clock delay */
-	phy_write(dev, 0x1d, 0x5);
-	val = phy_read(dev, 0x1e);
-	val |= 0x0100;
-	phy_write(dev, 0x1e, val);
-
 	return 0;
 }
 
-- 
2.29.2

