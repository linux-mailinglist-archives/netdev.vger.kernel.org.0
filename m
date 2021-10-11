Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52AEC4296A2
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 20:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbhJKSRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 14:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbhJKSRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 14:17:10 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40207C061570;
        Mon, 11 Oct 2021 11:15:10 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id v11so11551440pgb.8;
        Mon, 11 Oct 2021 11:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kIyV8cR5GS2rxg2p2WwgQNqm6Dtb0bm+QAw3FrSnNHs=;
        b=mpifQseRXNKTi9FRbbAFKy+rTYsJrgDaYBasQLtPhOg3EIEBbTof5+DgIJKAoQAjOj
         rY5jcQKPzhkrgzalaw4snJZMiy3nIMEV2F03PDl2rE/fS/nR9HCtWcRILIxxm7pWS+oi
         MnZwEU5vPNnzOBl5h0NIH/nW5ZGwrz92cI4DWxlR2ofmKlnhNk3DnOY69op8PU0B0kvJ
         CBHqnT0TrVelZ5OWEzaQ5YcULxlelzIZqxUGTHoe0PSrHRsiUfySBy7Jyx0zdXtxfmej
         0RTdQoZuyz4hx9YXFho1BeCACGlIA6qOgbiFiGEKfoIhQEu2F+K0qSy93wvM+22CwhPL
         AIjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kIyV8cR5GS2rxg2p2WwgQNqm6Dtb0bm+QAw3FrSnNHs=;
        b=IfimMRhCHFmOo9NvBS6tSZkK0o/u9BuewAsnU4MGuo4YuhIXUH4BFfv+z0mmOaLglc
         I4lElMSdEoXfIOEHOCMHdat+WDKNlY4hn7mic9oxzyMjeJMaME2bClpSfFr8Mw9A6x3F
         3scMD6z8Ri054rVz5ba0XPktgmhcMAP9xrQLxVCWJn98ASa5oSL2YMCKU9YT5ybHobpj
         W3q8omM2D+Gf5bCKUBcPqp/p1/sWbFvArsPVBoe6PbCHZYb+yYEv4vkkFASR2oXSoaN+
         IAD5s7+oqR9Ynat4rhkibOvRIwL3kaxC048hkwCvnnemQj3MEHzkvLEeNyLsNUlmhp4V
         I0tA==
X-Gm-Message-State: AOAM530GNhSRMuLsaQgjAGUElSGcB6CGURb15994QzUbHDmaj+Zr9ytg
        QuEB6zjDpHhchpH1GGOVrko/LLEQBhM=
X-Google-Smtp-Source: ABdhPJzdcwt2Cycw2thuAovS8gONxp7BCjEUfnYv8mdL2tyQJJpzLK9xK9nRR3P+WDnCTYO4V1H0/g==
X-Received: by 2002:a63:5453:: with SMTP id e19mr19394477pgm.178.1633976109236;
        Mon, 11 Oct 2021 11:15:09 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 14sm8109939pfu.29.2021.10.11.11.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 11:15:08 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev@vger.kernel.org (open list:ETHERNET PHY LIBRARY)
Subject: [PATCH stable 5.4] net: phy: bcm7xxx: Fixed indirect MMD operations
Date:   Mon, 11 Oct 2021 11:15:00 -0700
Message-Id: <20211011181500.103617-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit d88fd1b546ff19c8040cfaea76bf16aed1c5a0bb upstream

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
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/phy/bcm7xxx.c | 114 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 110 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
index af8eabe7a6d4..d372626c603d 100644
--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -26,7 +26,12 @@
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
@@ -210,25 +215,37 @@ static int bcm7xxx_28nm_resume(struct phy_device *phydev)
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
@@ -392,6 +409,93 @@ static int bcm7xxx_28nm_ephy_config_init(struct phy_device *phydev)
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
@@ -563,6 +667,8 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
 	.get_strings	= bcm_phy_get_strings,				\
 	.get_stats	= bcm7xxx_28nm_get_phy_stats,			\
 	.probe		= bcm7xxx_28nm_probe,				\
+	.read_mmd	= bcm7xxx_28nm_ephy_read_mmd,			\
+	.write_mmd	= bcm7xxx_28nm_ephy_write_mmd,			\
 }
 
 #define BCM7XXX_40NM_EPHY(_oui, _name)					\
-- 
2.25.1

