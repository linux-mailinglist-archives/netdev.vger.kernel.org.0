Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B9F119914
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbfLJVma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:42:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:38634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729326AbfLJVd6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:33:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9211022464;
        Tue, 10 Dec 2019 21:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013638;
        bh=6Ve9dJgXvkid6EqjAKU+C/eDNUi6JUFV6zDuf7RN9Gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H+nb64CEzVub9om0l5rb8ToTVDPsfNk1peYdEnCEaccSH0jaqzU64zCtexmq1Cwyz
         ZjOztkCJUsd6WB3Re/GTRprPrN20qQOrYF01uX0PzsRZIjF3crYnAfHOiBY446CUw0
         kAEGAPI71qky8TXm+Uw5mjDT3yqeT2zIzOrYk+q8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 078/177] net: phy: dp83867: enable robust auto-mdix
Date:   Tue, 10 Dec 2019 16:30:42 -0500
Message-Id: <20191210213221.11921-78-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 5a7f08c2abb0efc9d17aff2fc75d6d3b85e622e4 ]

The link detection timeouts can be observed (or link might not be detected
at all) when dp83867 PHY is configured in manual mode (speed/duplex).

CFG3[9] Robust Auto-MDIX option allows to significantly improve link detection
in case dp83867 is configured in manual mode and reduce link detection
time.
As per DM: "If link partners are configured to operational modes that are
not supported by normal Auto MDI/MDIX mode (like Auto-Neg versus Force
100Base-TX or Force 100Base-TX versus Force 100Base-TX), this Robust Auto
MDI/MDIX mode allows MDI/MDIX resolution and prevents deadlock."

Hence, enable this option by default as there are no known reasons
not to do so.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83867.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index eeadfde159401..879096d3ff412 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -86,6 +86,10 @@
 #define DP83867_IO_MUX_CFG_CLK_O_SEL_MASK	(0x1f << 8)
 #define DP83867_IO_MUX_CFG_CLK_O_SEL_SHIFT	8
 
+/* CFG3 bits */
+#define DP83867_CFG3_INT_OE			BIT(7)
+#define DP83867_CFG3_ROBUST_AUTO_MDIX		BIT(9)
+
 /* CFG4 bits */
 #define DP83867_CFG4_PORT_MIRROR_EN              BIT(0)
 
@@ -331,12 +335,13 @@ static int dp83867_config_init(struct phy_device *phydev)
 			return ret;
 	}
 
+	val = phy_read(phydev, DP83867_CFG3);
 	/* Enable Interrupt output INT_OE in CFG3 register */
-	if (phy_interrupt_is_valid(phydev)) {
-		val = phy_read(phydev, DP83867_CFG3);
-		val |= BIT(7);
-		phy_write(phydev, DP83867_CFG3, val);
-	}
+	if (phy_interrupt_is_valid(phydev))
+		val |= DP83867_CFG3_INT_OE;
+
+	val |= DP83867_CFG3_ROBUST_AUTO_MDIX;
+	phy_write(phydev, DP83867_CFG3, val);
 
 	if (dp83867->port_mirroring != DP83867_PORT_MIRROING_KEEP)
 		dp83867_config_port_mirroring(phydev);
-- 
2.20.1

