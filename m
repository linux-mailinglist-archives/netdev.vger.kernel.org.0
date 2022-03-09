Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BADE14D30FC
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 15:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbiCIO2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 09:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiCIO2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 09:28:49 -0500
X-Greylist: delayed 99655 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Mar 2022 06:27:50 PST
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [217.70.178.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A59B14996F;
        Wed,  9 Mar 2022 06:27:47 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 42BD320000C;
        Wed,  9 Mar 2022 14:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1646836066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=U3b9JKl+whxxFYER3+TbWqGu0XYGvAJiDu3r8aHo2Kk=;
        b=LFg2jACWoHBQY2aeNvIgN2QI5L64yld51sDWlQT0r7EDxCVirhSx1V07kh0kTXzJVCEGXh
        +pGHXmK5GzeZ1BVQu0C4bT7ZbDEQXbmcgRtDUyWN7fzJZhcQcZqYFplv4g7vAs5GABV8RE
        1JfO+bsp8ZwbF/U+rA67FDF4RaNZ9TxxqnY2ndvOTxigQjxvcCmbu/Js6D+ajNdZM/75Ng
        /OWZrH75xu3Dd14pIdY7zYzf8zIEdvVx87JoLktEUHPUQzF3AFJehDteGy7OdPEeqaUWhj
        SlO+AOZyCGbyFDTDd7mmVUgMIurNcHrdMHgdP9/Yon3Agp4MsJJNfBDUlyL/8w==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Andrew F . Davis" <afd@ti.com>, Dan Murphy <dmurphy@ti.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
Subject: [PATCH] net: phy: DP83822: clear MISR2 register to disable interrupts
Date:   Wed,  9 Mar 2022 15:22:28 +0100
Message-Id: <20220309142228.761153-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MISR1 was cleared twice but the original author intention was probably
to clear MISR1 & MISR2 to completely disable interrupts. Fix it to
clear MISR2.

Fixes: 87461f7a58ab ("net: phy: DP83822 initial driver submission")
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/phy/dp83822.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index 211b5476a6f5..ce17b2af3218 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -274,7 +274,7 @@ static int dp83822_config_intr(struct phy_device *phydev)
 		if (err < 0)
 			return err;
 
-		err = phy_write(phydev, MII_DP83822_MISR1, 0);
+		err = phy_write(phydev, MII_DP83822_MISR2, 0);
 		if (err < 0)
 			return err;
 
-- 
2.34.1

