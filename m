Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7654A44BACA
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 05:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhKJENF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 23:13:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:53584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230221AbhKJENC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 23:13:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA2CA61184;
        Wed, 10 Nov 2021 04:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636517416;
        bh=G+6fVK7jAdXV3OQ+8vLKg8mn15HTfheweA4+GGlagMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KjMaZsw+Q1ZkaLcoDz6CsorLkHSYpgJfJQvw7YpIt5+TpgvZuxkrX4ctXSG3YyuCO
         K45Flo34BNnM7fbt2kmwpi7fCvxuwWRPPUuCQVDg97vzRzXXTfMChjmbt8DzskTLCm
         hHktSvQFsQfYMo1W2mQ7GMl2hZHlG43tykIYG/+qXHP+lomoMs8aVfj3xLIgt/wQai
         Sso/dEKGUECE+T/SyhZSFy4npCOnrxQL/vDUVTMfU+k2zRi6WUsF/y1gcQbCn9swIx
         F0rdgiHx1i0vHbEy7e6jBPrWv71zAtMjISkasvaCaHECcLizFDv56sICrv2i+Yg22+
         cFdA2BSYP42tA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net 2/3] net: dsa: mv88e6xxx: Fix reading sgmii link status register
Date:   Wed, 10 Nov 2021 05:10:09 +0100
Message-Id: <20211110041010.2402-2-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211110041010.2402-1-kabel@kernel.org>
References: <20211110041010.2402-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The documentation says this about the SerDes PHY register 4.2001.2:
  This register bit indicates when link was lost since the last
  read. For the current link status, read this register
  back-to-back.

Thus we need to read it twice to get the current value of the register.

The wrong value is read when phylink requests change from sgmii to
2500base-x mode, and link won't come up. This fixes the bug.

Fixes: a5a6858b793f ("net: dsa: mv88e6xxx: extend phylink to Serdes PHYs")
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 6ea003678798..bc198ef06745 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -1041,15 +1041,25 @@ static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
 	u16 bmsr;
 	int err;
 
-	/* If the link has dropped, we want to know about it. */
+	/* If the link has dropped, we want to know about it.
+	 * This register bit indicates when link was lost since the last read.
+	 * We need to read it twice to get the current value.
+	 */
 	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
 				    MV88E6390_SGMII_BMSR, &bmsr);
-	if (err) {
-		dev_err(chip->dev, "can't read Serdes BMSR: %d\n", err);
-		return;
-	}
+	if (err)
+		goto err;
+
+	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6390_SGMII_BMSR, &bmsr);
+	if (err)
+		goto err;
 
 	dsa_port_phylink_mac_change(chip->ds, port, !!(bmsr & BMSR_LSTATUS));
+
+	return;
+err:
+	dev_err(chip->dev, "can't read Serdes BMSR: %d\n", err);
 }
 
 static void mv88e6393x_serdes_irq_link_10g(struct mv88e6xxx_chip *chip,
-- 
2.32.0

