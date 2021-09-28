Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6FC41B865
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 22:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242744AbhI1UfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 16:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242016AbhI1UfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 16:35:06 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411E4C06161C;
        Tue, 28 Sep 2021 13:33:26 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id g14so33078pfm.1;
        Tue, 28 Sep 2021 13:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kySCmJwQTNBaLQ15HXjhSRvmbp4B7/SgTzjLTTphRIE=;
        b=cG1uRxtTwyHB9fINlklztTvktw3SSGeRLBkU/arxqBqoMgHDRNInbC/2lU4DYZqNth
         Lzz3WwQw0NUF2VJO+9ObEsx2hRo/3btLK48qaRO6cA9EaLYPS3NQUG+jysP5+cm+98e+
         kN76/98poKMOYJ3vbDOh11bAqKtwNiqzM0FpD+N0fnBQuyBqStokwRBsI0sjAECBafqd
         5yBZo8DR//r/aAtEij/hwZHsG6z/bVPS3blRaMW3aTAWglHJSIzbeWOo1mSovkBzhfhE
         Z/G/THBvAGFmzOWhXuzy3rvUmiZr/Hr02ZB7pDyFrMt5ETDKsQvfOYwGE3RGE5weAL1A
         k1Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kySCmJwQTNBaLQ15HXjhSRvmbp4B7/SgTzjLTTphRIE=;
        b=D08BWJcpw9/jduO5gEN6Lb5ZZQhqXitJep/Oh5LA51OlG69XwqvbmQoqDq09K1xqBk
         feRMzFks7lAlBqCG2+OP8uTj+4YSTrjMwfyiRrJAQCijEOC91ifwe0k4SC+97BVBKGYV
         t7neYD6xOzmG5EWT75m+Cej90ZEQPnZKuaZyPDliixgcBNf9+qhhXIFhPWBh455aAbhF
         L0ODTrng59W54bdyrofOpVx4XTbyAlaxKLvkc1AH1S6H0Kv8XqWOVupWSeQadeppLamr
         QJnbqp8zJ3ryZ7mYaUNWhf9+r/PYga4Q2jYRGXwf8SU1nSDD8CNs/4NoDR/NA31lA76a
         jEhA==
X-Gm-Message-State: AOAM531VspGYQB2ONVTdhz9EfQLvRymFozDbmvN6q3V5WILhbHpj9vPP
        1HIPJkgEs9esusbojIkjDePE5AnZKJU=
X-Google-Smtp-Source: ABdhPJwfBTstu7AyqljQX5sdzlT1IzK+lHH9KEQ82jcPnTn6659Bw1diPGORFkvKzDeqI8NIJ/haMQ==
X-Received: by 2002:a63:e613:: with SMTP id g19mr6426470pgh.12.1632861205261;
        Tue, 28 Sep 2021 13:33:25 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e9sm18457pjl.41.2021.09.28.13.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 13:33:24 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM ETHERNET PHY
        DRIVERS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: phy: bcm7xxx: Fixed indirect MMD operations
Date:   Tue, 28 Sep 2021 13:32:33 -0700
Message-Id: <20210928203234.772724-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When EEE support was added to the 28nm EPHY it was assumed that it would
be able to support the standard clause 45 over clause 22 register access
method. It turns out that the PHY does not support that, which is the
very reason for using the indirect shadow mode 2 bank 3 access method.

Implement {read,write}_mmd to allow the standard PHY library routines
pertaining to EEE querying and configuration to work correctly on these
PHYs. This forces us to implement a __phy_set_clr_bits() function that
does not grab the MDIO bus lock since the PHY driver's {read,write}_mmd
functions are always called with that lock held.

Fixes: 83ee102a6998 ("net: phy: bcm7xxx: add support for 28nm EPHY")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/bcm7xxx.c | 114 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 110 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
index e79297a4bae8..27b6a3f507ae 100644
--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -27,7 +27,12 @@
 #define MII_BCM7XXX_SHD_2_ADDR_CTRL	0xe
 #define MII_BCM7XXX_SHD_2_CTRL_STAT	0xf
 #define MII_BCM7XXX_SHD_2_BIAS_TRIM	0x1a
+#define MII_BCM7XXX_SHD_3_PCS_CTRL	0x0
+#define MII_BCM7XXX_SHD_3_PCS_STATUS	0x1
+#define MII_BCM7XXX_SHD_3_EEE_CAP	0x2
 #define MII_BCM7XXX_SHD_3_AN_EEE_ADV	0x3
+#define MII_BCM7XXX_SHD_3_EEE_LP	0x4
+#define MII_BCM7XXX_SHD_3_EEE_WK_ERR	0x5
 #define MII_BCM7XXX_SHD_3_PCS_CTRL_2	0x6
 #define  MII_BCM7XXX_PCS_CTRL_2_DEF	0x4400
 #define MII_BCM7XXX_SHD_3_AN_STAT	0xb
@@ -216,25 +221,37 @@ static int bcm7xxx_28nm_resume(struct phy_device *phydev)
 	return genphy_config_aneg(phydev);
 }
 
-static int phy_set_clr_bits(struct phy_device *dev, int location,
-					int set_mask, int clr_mask)
+static int __phy_set_clr_bits(struct phy_device *dev, int location,
+			      int set_mask, int clr_mask)
 {
 	int v, ret;
 
-	v = phy_read(dev, location);
+	v = __phy_read(dev, location);
 	if (v < 0)
 		return v;
 
 	v &= ~clr_mask;
 	v |= set_mask;
 
-	ret = phy_write(dev, location, v);
+	ret = __phy_write(dev, location, v);
 	if (ret < 0)
 		return ret;
 
 	return v;
 }
 
+static int phy_set_clr_bits(struct phy_device *dev, int location,
+			    int set_mask, int clr_mask)
+{
+	int ret;
+
+	mutex_lock(&dev->mdio.bus->mdio_lock);
+	ret = __phy_set_clr_bits(dev, location, set_mask, clr_mask);
+	mutex_unlock(&dev->mdio.bus->mdio_lock);
+
+	return ret;
+}
+
 static int bcm7xxx_28nm_ephy_01_afe_config_init(struct phy_device *phydev)
 {
 	int ret;
@@ -398,6 +415,93 @@ static int bcm7xxx_28nm_ephy_config_init(struct phy_device *phydev)
 	return bcm7xxx_28nm_ephy_apd_enable(phydev);
 }
 
+#define MII_BCM7XXX_REG_INVALID	0xff
+
+static u8 bcm7xxx_28nm_ephy_regnum_to_shd(u16 regnum)
+{
+	switch (regnum) {
+	case MDIO_CTRL1:
+		return MII_BCM7XXX_SHD_3_PCS_CTRL;
+	case MDIO_STAT1:
+		return MII_BCM7XXX_SHD_3_PCS_STATUS;
+	case MDIO_PCS_EEE_ABLE:
+		return MII_BCM7XXX_SHD_3_EEE_CAP;
+	case MDIO_AN_EEE_ADV:
+		return MII_BCM7XXX_SHD_3_AN_EEE_ADV;
+	case MDIO_AN_EEE_LPABLE:
+		return MII_BCM7XXX_SHD_3_EEE_LP;
+	case MDIO_PCS_EEE_WK_ERR:
+		return MII_BCM7XXX_SHD_3_EEE_WK_ERR;
+	default:
+		return MII_BCM7XXX_REG_INVALID;
+	}
+}
+
+static bool bcm7xxx_28nm_ephy_dev_valid(int devnum)
+{
+	return devnum == MDIO_MMD_AN || devnum == MDIO_MMD_PCS;
+}
+
+static int bcm7xxx_28nm_ephy_read_mmd(struct phy_device *phydev,
+				      int devnum, u16 regnum)
+{
+	u8 shd = bcm7xxx_28nm_ephy_regnum_to_shd(regnum);
+	int ret;
+
+	if (!bcm7xxx_28nm_ephy_dev_valid(devnum) ||
+	    shd == MII_BCM7XXX_REG_INVALID)
+		return -EOPNOTSUPP;
+
+	/* set shadow mode 2 */
+	ret = __phy_set_clr_bits(phydev, MII_BCM7XXX_TEST,
+				 MII_BCM7XXX_SHD_MODE_2, 0);
+	if (ret < 0)
+		return ret;
+
+	/* Access the desired shadow register address */
+	ret = __phy_write(phydev, MII_BCM7XXX_SHD_2_ADDR_CTRL, shd);
+	if (ret < 0)
+		goto reset_shadow_mode;
+
+	ret = __phy_read(phydev, MII_BCM7XXX_SHD_2_CTRL_STAT);
+
+reset_shadow_mode:
+	/* reset shadow mode 2 */
+	__phy_set_clr_bits(phydev, MII_BCM7XXX_TEST, 0,
+			   MII_BCM7XXX_SHD_MODE_2);
+	return ret;
+}
+
+static int bcm7xxx_28nm_ephy_write_mmd(struct phy_device *phydev,
+				       int devnum, u16 regnum, u16 val)
+{
+	u8 shd = bcm7xxx_28nm_ephy_regnum_to_shd(regnum);
+	int ret;
+
+	if (!bcm7xxx_28nm_ephy_dev_valid(devnum) ||
+	    shd == MII_BCM7XXX_REG_INVALID)
+		return -EOPNOTSUPP;
+
+	/* set shadow mode 2 */
+	ret = __phy_set_clr_bits(phydev, MII_BCM7XXX_TEST,
+				 MII_BCM7XXX_SHD_MODE_2, 0);
+	if (ret < 0)
+		return ret;
+
+	/* Access the desired shadow register address */
+	ret = __phy_write(phydev, MII_BCM7XXX_SHD_2_ADDR_CTRL, shd);
+	if (ret < 0)
+		goto reset_shadow_mode;
+
+	/* Write the desired value in the shadow register */
+	__phy_write(phydev, MII_BCM7XXX_SHD_2_CTRL_STAT, val);
+
+reset_shadow_mode:
+	/* reset shadow mode 2 */
+	return __phy_set_clr_bits(phydev, MII_BCM7XXX_TEST, 0,
+				  MII_BCM7XXX_SHD_MODE_2);
+}
+
 static int bcm7xxx_28nm_ephy_resume(struct phy_device *phydev)
 {
 	int ret;
@@ -595,6 +699,8 @@ static void bcm7xxx_28nm_remove(struct phy_device *phydev)
 	.get_stats	= bcm7xxx_28nm_get_phy_stats,			\
 	.probe		= bcm7xxx_28nm_probe,				\
 	.remove		= bcm7xxx_28nm_remove,				\
+	.read_mmd	= bcm7xxx_28nm_ephy_read_mmd,			\
+	.write_mmd	= bcm7xxx_28nm_ephy_write_mmd,			\
 }
 
 #define BCM7XXX_40NM_EPHY(_oui, _name)					\
-- 
2.25.1

