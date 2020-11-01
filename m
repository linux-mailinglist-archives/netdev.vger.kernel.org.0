Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103112A1E03
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 13:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgKAMwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 07:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbgKAMwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 07:52:37 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22D6C0617A6;
        Sun,  1 Nov 2020 04:52:36 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id b9so1151777edu.10;
        Sun, 01 Nov 2020 04:52:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ph00Ugh39PVqFDs4lBscS/11fmLrPsVQlvgYh8LlOpw=;
        b=Tl1cHVl2nJFThu2vEfzc77S+jESDUsPAEqvkplfubNw3gT0z42MWVCzdj2+3aOPO1s
         FkWn+Pgr/9rNtp264L7fb3yz+f6T4QcdeQMLOCfteTZ7kvKMKtw+oS8+P0790CCNNuH3
         n7YHNEpJDGgE29h0zxbCEE0EOrsp1kUSblOCr2oum6nej4kuakwPH7FAJDnv9m4hzaIi
         9ubB0aTGtXFRNkUXjrbB4/yRsAjILbpltTYc+ykOMsIId419Tp5YTaqUx5BrtvO4Kko/
         Dz6fglQ/mhewKG4YcWv4qX3y3ebsal9QKoelYj0W0HOMUH63vp1ELFawA9CJqZfrM2k2
         rl3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ph00Ugh39PVqFDs4lBscS/11fmLrPsVQlvgYh8LlOpw=;
        b=WJns7I/m0w0xJWUHAhVNZW4lc0zkUmZWH20aim63VyyA8a8JNAcCS4pptkebJ4LZw7
         hg2i9xQs8oGFlUG+FGAyFJVckUeWppxbN+J1vGROzVaYD2RUeM/l6uDUfe4vlBQpIonQ
         dR4Vy4uM36TpzXEBBhHDWcDCbJq8grYAqUe2itHH3kXaGglqgBTjcJ9N5zc57d5t//nY
         HjuV8j0N/sDpv38HaRDIQFuVuK4DgIEqwM5Dwy9eVZuyvLzVKJRXtmQRpExLLCHy+DiY
         9CpWGXXMMb2WfNeeZYrxyZm80CDLvSfWDtrTEPBF0BFpMNL0tndO9NNvAoVjWi6g8ODv
         2JJg==
X-Gm-Message-State: AOAM533IriD6Bp/BAJicbuq2G1AUDeAwEXNuI3+CbkLhLj12sPBrM4/b
        Z4quMCR8u1Fcp+fw8AFgK+Q=
X-Google-Smtp-Source: ABdhPJxg0h2MZkHtfYujVzMsejf7bXA5uKahvnKZOq4A4u+cO6AwgEM2mMyIimFucyD512Q0kqfG5w==
X-Received: by 2002:aa7:cc84:: with SMTP id p4mr11580009edt.97.1604235155302;
        Sun, 01 Nov 2020 04:52:35 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c5sm8133603edx.58.2020.11.01.04.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 04:52:34 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v2 11/19] net: phy: broadcom: implement generic .handle_interrupt() callback
Date:   Sun,  1 Nov 2020 14:51:06 +0200
Message-Id: <20201101125114.1316879-12-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201101125114.1316879-1-ciorneiioana@gmail.com>
References: <20201101125114.1316879-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

In an attempt to actually support shared IRQs in phylib, we now move the
responsibility of triggering the phylib state machine or just returning
IRQ_NONE, based on the IRQ status register, to the PHY driver. Having
3 different IRQ handling callbacks (.handle_interrupt(),
.did_interrupt() and .ack_interrupt() ) is confusing so let the PHY
driver implement directly an IRQ handler like any other device driver.
Make this driver follow the new convention.

Cc: Michael Walle <michael@walle.cc>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - Adjust .handle_interrupt() so that we only take into account the
   enabled IRQs. The BCM8706, BCM8727, BCMAC131 and BCM5241 were the
   only devices which I did not do this change since I do not have
   access to the register map.

 drivers/net/phy/bcm-cygnus.c  |  1 +
 drivers/net/phy/bcm-phy-lib.c | 31 ++++++++++++++++++++++++++++++
 drivers/net/phy/bcm-phy-lib.h |  1 +
 drivers/net/phy/bcm54140.c    | 26 ++++++++++++++++++++-----
 drivers/net/phy/bcm63xx.c     |  2 ++
 drivers/net/phy/bcm87xx.c     | 32 +++++++++++++++++++++----------
 drivers/net/phy/broadcom.c    | 36 +++++++++++++++++++++++++++++++++++
 7 files changed, 114 insertions(+), 15 deletions(-)

diff --git a/drivers/net/phy/bcm-cygnus.c b/drivers/net/phy/bcm-cygnus.c
index 9ccf28b0a04d..a236e0b8d04d 100644
--- a/drivers/net/phy/bcm-cygnus.c
+++ b/drivers/net/phy/bcm-cygnus.c
@@ -258,6 +258,7 @@ static struct phy_driver bcm_cygnus_phy_driver[] = {
 	.config_init   = bcm_cygnus_config_init,
 	.ack_interrupt = bcm_phy_ack_intr,
 	.config_intr   = bcm_phy_config_intr,
+	.handle_interrupt = bcm_phy_handle_interrupt,
 	.suspend       = genphy_suspend,
 	.resume        = bcm_cygnus_resume,
 }, {
diff --git a/drivers/net/phy/bcm-phy-lib.c b/drivers/net/phy/bcm-phy-lib.c
index ef6825b30323..c232fcfe0e20 100644
--- a/drivers/net/phy/bcm-phy-lib.c
+++ b/drivers/net/phy/bcm-phy-lib.c
@@ -196,6 +196,37 @@ int bcm_phy_config_intr(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(bcm_phy_config_intr);
 
+irqreturn_t bcm_phy_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status, irq_mask;
+
+	irq_status = phy_read(phydev, MII_BCM54XX_ISR);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	/* If a bit from the Interrupt Mask register is set, the corresponding
+	 * bit from the Interrupt Status register is masked. So read the IMR
+	 * and then flip the bits to get the list of possible interrupt
+	 * sources.
+	 */
+	irq_mask = phy_read(phydev, MII_BCM54XX_IMR);
+	if (irq_mask < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+	irq_mask = ~irq_mask;
+
+	if (!(irq_status & irq_mask))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+EXPORT_SYMBOL_GPL(bcm_phy_handle_interrupt);
+
 int bcm_phy_read_shadow(struct phy_device *phydev, u16 shadow)
 {
 	phy_write(phydev, MII_BCM54XX_SHD, MII_BCM54XX_SHD_VAL(shadow));
diff --git a/drivers/net/phy/bcm-phy-lib.h b/drivers/net/phy/bcm-phy-lib.h
index 237a8503c9b4..c3842f87c33b 100644
--- a/drivers/net/phy/bcm-phy-lib.h
+++ b/drivers/net/phy/bcm-phy-lib.h
@@ -63,6 +63,7 @@ int bcm_phy_modify_rdb(struct phy_device *phydev, u16 rdb, u16 mask,
 
 int bcm_phy_ack_intr(struct phy_device *phydev);
 int bcm_phy_config_intr(struct phy_device *phydev);
+irqreturn_t bcm_phy_handle_interrupt(struct phy_device *phydev);
 
 int bcm_phy_enable_apd(struct phy_device *phydev, bool dll_pwr_down);
 
diff --git a/drivers/net/phy/bcm54140.c b/drivers/net/phy/bcm54140.c
index 8998e68bb26b..36c899a88c5d 100644
--- a/drivers/net/phy/bcm54140.c
+++ b/drivers/net/phy/bcm54140.c
@@ -637,13 +637,29 @@ static int bcm54140_config_init(struct phy_device *phydev)
 				  BCM54140_RDB_C_PWR_ISOLATE, 0);
 }
 
-static int bcm54140_did_interrupt(struct phy_device *phydev)
+static irqreturn_t bcm54140_handle_interrupt(struct phy_device *phydev)
 {
-	int ret;
+	int irq_status, irq_mask;
+
+	irq_status = bcm_phy_read_rdb(phydev, BCM54140_RDB_ISR);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	irq_mask = bcm_phy_read_rdb(phydev, BCM54140_RDB_IMR);
+	if (irq_mask < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+	irq_mask = ~irq_mask;
+
+	if (!(irq_status & irq_mask))
+		return IRQ_NONE;
 
-	ret = bcm_phy_read_rdb(phydev, BCM54140_RDB_ISR);
+	phy_trigger_machine(phydev);
 
-	return (ret < 0) ? 0 : ret;
+	return IRQ_HANDLED;
 }
 
 static int bcm54140_ack_intr(struct phy_device *phydev)
@@ -834,8 +850,8 @@ static struct phy_driver bcm54140_drivers[] = {
 		.flags		= PHY_POLL_CABLE_TEST,
 		.features       = PHY_GBIT_FEATURES,
 		.config_init    = bcm54140_config_init,
-		.did_interrupt	= bcm54140_did_interrupt,
 		.ack_interrupt  = bcm54140_ack_intr,
+		.handle_interrupt = bcm54140_handle_interrupt,
 		.config_intr    = bcm54140_config_intr,
 		.probe		= bcm54140_probe,
 		.suspend	= genphy_suspend,
diff --git a/drivers/net/phy/bcm63xx.c b/drivers/net/phy/bcm63xx.c
index 459fb2069c7e..818c853b6638 100644
--- a/drivers/net/phy/bcm63xx.c
+++ b/drivers/net/phy/bcm63xx.c
@@ -69,6 +69,7 @@ static struct phy_driver bcm63xx_driver[] = {
 	.config_init	= bcm63xx_config_init,
 	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm63xx_config_intr,
+	.handle_interrupt = bcm_phy_handle_interrupt,
 }, {
 	/* same phy as above, with just a different OUI */
 	.phy_id		= 0x002bdc00,
@@ -79,6 +80,7 @@ static struct phy_driver bcm63xx_driver[] = {
 	.config_init	= bcm63xx_config_init,
 	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm63xx_config_intr,
+	.handle_interrupt = bcm_phy_handle_interrupt,
 } };
 
 module_phy_driver(bcm63xx_driver);
diff --git a/drivers/net/phy/bcm87xx.c b/drivers/net/phy/bcm87xx.c
index df360e1c5069..f20cfb05ef04 100644
--- a/drivers/net/phy/bcm87xx.c
+++ b/drivers/net/phy/bcm87xx.c
@@ -153,10 +153,29 @@ static int bcm87xx_config_intr(struct phy_device *phydev)
 	return err;
 }
 
-static int bcm87xx_did_interrupt(struct phy_device *phydev)
+static irqreturn_t bcm87xx_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, BCM87XX_LASI_STATUS);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (irq_status == 0)
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
+static int bcm87xx_ack_interrupt(struct phy_device *phydev)
 {
 	int reg;
 
+	/* Reading the LASI status clears it. */
 	reg = phy_read(phydev, BCM87XX_LASI_STATUS);
 
 	if (reg < 0) {
@@ -168,13 +187,6 @@ static int bcm87xx_did_interrupt(struct phy_device *phydev)
 	return (reg & 1) != 0;
 }
 
-static int bcm87xx_ack_interrupt(struct phy_device *phydev)
-{
-	/* Reading the LASI status clears it. */
-	bcm87xx_did_interrupt(phydev);
-	return 0;
-}
-
 static int bcm8706_match_phy_device(struct phy_device *phydev)
 {
 	return phydev->c45_ids.device_ids[4] == PHY_ID_BCM8706;
@@ -196,7 +208,7 @@ static struct phy_driver bcm87xx_driver[] = {
 	.read_status	= bcm87xx_read_status,
 	.ack_interrupt	= bcm87xx_ack_interrupt,
 	.config_intr	= bcm87xx_config_intr,
-	.did_interrupt	= bcm87xx_did_interrupt,
+	.handle_interrupt = bcm87xx_handle_interrupt,
 	.match_phy_device = bcm8706_match_phy_device,
 }, {
 	.phy_id		= PHY_ID_BCM8727,
@@ -208,7 +220,7 @@ static struct phy_driver bcm87xx_driver[] = {
 	.read_status	= bcm87xx_read_status,
 	.ack_interrupt	= bcm87xx_ack_interrupt,
 	.config_intr	= bcm87xx_config_intr,
-	.did_interrupt	= bcm87xx_did_interrupt,
+	.handle_interrupt = bcm87xx_handle_interrupt,
 	.match_phy_device = bcm8727_match_phy_device,
 } };
 
diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index cd271de9609b..8bcdb94ef2fc 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -643,6 +643,24 @@ static int brcm_fet_config_intr(struct phy_device *phydev)
 	return err;
 }
 
+static irqreturn_t brcm_fet_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, MII_BRCM_FET_INTREG);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (irq_status == 0)
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 struct bcm53xx_phy_priv {
 	u64	*stats;
 };
@@ -683,6 +701,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init	= bcm54xx_config_init,
 	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
+	.handle_interrupt = bcm_phy_handle_interrupt,
 }, {
 	.phy_id		= PHY_ID_BCM5421,
 	.phy_id_mask	= 0xfffffff0,
@@ -691,6 +710,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init	= bcm54xx_config_init,
 	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
+	.handle_interrupt = bcm_phy_handle_interrupt,
 }, {
 	.phy_id		= PHY_ID_BCM54210E,
 	.phy_id_mask	= 0xfffffff0,
@@ -699,6 +719,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init	= bcm54xx_config_init,
 	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
+	.handle_interrupt = bcm_phy_handle_interrupt,
 }, {
 	.phy_id		= PHY_ID_BCM5461,
 	.phy_id_mask	= 0xfffffff0,
@@ -707,6 +728,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init	= bcm54xx_config_init,
 	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
+	.handle_interrupt = bcm_phy_handle_interrupt,
 }, {
 	.phy_id		= PHY_ID_BCM54612E,
 	.phy_id_mask	= 0xfffffff0,
@@ -715,6 +737,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init	= bcm54xx_config_init,
 	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
+	.handle_interrupt = bcm_phy_handle_interrupt,
 }, {
 	.phy_id		= PHY_ID_BCM54616S,
 	.phy_id_mask	= 0xfffffff0,
@@ -724,6 +747,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_aneg	= bcm54616s_config_aneg,
 	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
+	.handle_interrupt = bcm_phy_handle_interrupt,
 	.read_status	= bcm54616s_read_status,
 	.probe		= bcm54616s_probe,
 }, {
@@ -734,6 +758,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init	= bcm54xx_config_init,
 	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
+	.handle_interrupt = bcm_phy_handle_interrupt,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
@@ -745,6 +770,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_aneg	= bcm5481_config_aneg,
 	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
+	.handle_interrupt = bcm_phy_handle_interrupt,
 }, {
 	.phy_id         = PHY_ID_BCM54810,
 	.phy_id_mask    = 0xfffffff0,
@@ -754,6 +780,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_aneg    = bcm5481_config_aneg,
 	.ack_interrupt  = bcm_phy_ack_intr,
 	.config_intr    = bcm_phy_config_intr,
+	.handle_interrupt = bcm_phy_handle_interrupt,
 	.suspend	= genphy_suspend,
 	.resume		= bcm54xx_resume,
 }, {
@@ -765,6 +792,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_aneg    = bcm5481_config_aneg,
 	.ack_interrupt  = bcm_phy_ack_intr,
 	.config_intr    = bcm_phy_config_intr,
+	.handle_interrupt = bcm_phy_handle_interrupt,
 	.suspend	= genphy_suspend,
 	.resume		= bcm54xx_resume,
 }, {
@@ -776,6 +804,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.read_status	= bcm5482_read_status,
 	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
+	.handle_interrupt = bcm_phy_handle_interrupt,
 }, {
 	.phy_id		= PHY_ID_BCM50610,
 	.phy_id_mask	= 0xfffffff0,
@@ -784,6 +813,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init	= bcm54xx_config_init,
 	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
+	.handle_interrupt = bcm_phy_handle_interrupt,
 }, {
 	.phy_id		= PHY_ID_BCM50610M,
 	.phy_id_mask	= 0xfffffff0,
@@ -792,6 +822,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init	= bcm54xx_config_init,
 	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
+	.handle_interrupt = bcm_phy_handle_interrupt,
 }, {
 	.phy_id		= PHY_ID_BCM57780,
 	.phy_id_mask	= 0xfffffff0,
@@ -800,6 +831,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init	= bcm54xx_config_init,
 	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
+	.handle_interrupt = bcm_phy_handle_interrupt,
 }, {
 	.phy_id		= PHY_ID_BCMAC131,
 	.phy_id_mask	= 0xfffffff0,
@@ -808,6 +840,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init	= brcm_fet_config_init,
 	.ack_interrupt	= brcm_fet_ack_interrupt,
 	.config_intr	= brcm_fet_config_intr,
+	.handle_interrupt = brcm_fet_handle_interrupt,
 }, {
 	.phy_id		= PHY_ID_BCM5241,
 	.phy_id_mask	= 0xfffffff0,
@@ -816,6 +849,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init	= brcm_fet_config_init,
 	.ack_interrupt	= brcm_fet_ack_interrupt,
 	.config_intr	= brcm_fet_config_intr,
+	.handle_interrupt = brcm_fet_handle_interrupt,
 }, {
 	.phy_id		= PHY_ID_BCM5395,
 	.phy_id_mask	= 0xfffffff0,
@@ -839,6 +873,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init	= bcm54xx_config_init,
 	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
+	.handle_interrupt = bcm_phy_handle_interrupt,
 }, {
 	.phy_id         = PHY_ID_BCM89610,
 	.phy_id_mask    = 0xfffffff0,
@@ -847,6 +882,7 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init    = bcm54xx_config_init,
 	.ack_interrupt  = bcm_phy_ack_intr,
 	.config_intr    = bcm_phy_config_intr,
+	.handle_interrupt = bcm_phy_handle_interrupt,
 } };
 
 module_phy_driver(broadcom_drivers);
-- 
2.28.0

