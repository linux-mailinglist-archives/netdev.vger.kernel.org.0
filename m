Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53EF966BB27
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 11:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjAPKEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 05:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjAPKEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 05:04:33 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F264193D0;
        Mon, 16 Jan 2023 02:04:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673863464; x=1705399464;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sTsxJqX2e2ybi62OwFJhMFA7w+2USmVJlU5/icGHZIQ=;
  b=hbSmm/XRHUUGsqxW/uJoyYZveKtb5oNR5Y7A+fyphEsTfi2VxkSryqA4
   /OedHjItW2YkhpiijAQSUz+WcNQACP7t6baD9J7LJl6vBnEPNiIHWv7uI
   PkHMoHZZ1VbI5C2M12r2G5v797kocuNqR09yFITBroM8Pe/J4KPfycpjq
   bLOQZzRUUKWd/gojGPhpAmMvVLBFSQGfuNJy+RLHiCId5rdEdwspMe4Yq
   /TsKGRHmZDrU35IQbaH2dQbOmmMZzsdJiv+BrekudhfTPqSH1YvAGyK/A
   GVzAG/p6xc9ffvbQ3S0IUw8SEpEZhuDrXshVuVwOae0H//ER+CZbNgTv+
   w==;
X-IronPort-AV: E=Sophos;i="5.97,220,1669100400"; 
   d="scan'208";a="132508148"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Jan 2023 03:04:23 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 03:04:21 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 16 Jan 2023 03:04:16 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <arun.ramadoss@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>
Subject: [PATCH net 2/2] net: dsa: microchip: lan937x: run phy initialization during each link update
Date:   Mon, 16 Jan 2023 15:35:00 +0530
Message-ID: <20230116100500.614444-3-rakesh.sankaranarayanan@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230116100500.614444-1-rakesh.sankaranarayanan@microchip.com>
References: <20230116100500.614444-1-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PHY initialization is supposed to run on every mode changes.
"lan87xx_config_aneg()" verifies every mode change using
"phy_modify_changed()" function. Earlier code had phy_modify_changed()
followed by genphy_soft_reset. But soft_reset resets all the
pre-configured register values to default state, and lost all the
initialization done. With this reason gen_phy_reset was removed.
But it need to go through init sequence each time the mode changed.
Update lan97xx_config_aneg() to invoke phy_init once successful mode
update is detected.

PHY init sequence added in lan87xx_phy_init() have slave init
commands executed every time. Update the init sequence to run
slave init only if phydev is in slave mode.

Test setup contains LAN9370 EVB connected to SAMA5D3 (Running DSA),
and issue can be reproduced by connecting link to any of the available
ports after SAMA5D3 boot-up. With this issue, port will fail to
update link state. But once the SAMA5D3 is reset with LAN9370 link in
connected state itself, on boot-up link state will be reported as UP. But
Again after some time, if link is moved to DOWN state, it will not get
reported.

Fixes: b2cd2cde7d69 ("net: phy: LAN87xx: remove genphy_softreset in config_aneg")
Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
---
 drivers/net/phy/microchip_t1.c | 70 +++++++++++++++++++++++++++-------
 1 file changed, 56 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index 8569a545e0a3..78618c8cb6bf 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -245,15 +245,42 @@ static int lan87xx_config_rgmii_delay(struct phy_device *phydev)
 			   PHYACC_ATTR_BANK_MISC, LAN87XX_CTRL_1, rc);
 }
 
+static int lan87xx_phy_init_cmd(struct phy_device *phydev,
+				const struct access_ereg_val *cmd_seq, int cnt)
+{
+	int ret, i;
+
+	for (i = 0; i < cnt; i++) {
+		if (cmd_seq[i].mode == PHYACC_ATTR_MODE_POLL &&
+		    cmd_seq[i].bank == PHYACC_ATTR_BANK_SMI) {
+			ret = access_smi_poll_timeout(phydev,
+						      cmd_seq[i].offset,
+						      cmd_seq[i].val,
+						      cmd_seq[i].mask);
+		} else {
+			ret = access_ereg(phydev, cmd_seq[i].mode,
+					  cmd_seq[i].bank, cmd_seq[i].offset,
+					  cmd_seq[i].val);
+		}
+		if (ret < 0)
+			return ret;
+	}
+
+	return ret;
+}
+
 static int lan87xx_phy_init(struct phy_device *phydev)
 {
-	static const struct access_ereg_val init[] = {
+	static const struct access_ereg_val hw_init[] = {
 		/* TXPD/TXAMP6 Configs */
 		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_AFE,
 		  T1_AFE_PORT_CFG1_REG,       0x002D,  0 },
 		/* HW_Init Hi and Force_ED */
 		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_SMI,
 		  T1_POWER_DOWN_CONTROL_REG,  0x0308,  0 },
+	};
+
+	static const struct access_ereg_val slave_init[] = {
 		/* Equalizer Full Duplex Freeze - T1 Slave */
 		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
 		  T1_EQ_FD_STG1_FRZ_CFG,     0x0002,  0 },
@@ -267,6 +294,9 @@ static int lan87xx_phy_init(struct phy_device *phydev)
 		  T1_EQ_WT_FD_LCK_FRZ_CFG,    0x0002,  0 },
 		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
 		  T1_PST_EQ_LCK_STG1_FRZ_CFG, 0x0002,  0 },
+	};
+
+	static const struct access_ereg_val phy_init[] = {
 		/* Slave Full Duplex Multi Configs */
 		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
 		  T1_SLV_FD_MULT_CFG_REG,     0x0D53,  0 },
@@ -397,7 +427,7 @@ static int lan87xx_phy_init(struct phy_device *phydev)
 		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_SMI,
 		  T1_POWER_DOWN_CONTROL_REG,	0x0300, 0 },
 	};
-	int rc, i;
+	int rc;
 
 	/* phy Soft reset */
 	rc = genphy_soft_reset(phydev);
@@ -405,21 +435,28 @@ static int lan87xx_phy_init(struct phy_device *phydev)
 		return rc;
 
 	/* PHY Initialization */
-	for (i = 0; i < ARRAY_SIZE(init); i++) {
-		if (init[i].mode == PHYACC_ATTR_MODE_POLL &&
-		    init[i].bank == PHYACC_ATTR_BANK_SMI) {
-			rc = access_smi_poll_timeout(phydev,
-						     init[i].offset,
-						     init[i].val,
-						     init[i].mask);
-		} else {
-			rc = access_ereg(phydev, init[i].mode, init[i].bank,
-					 init[i].offset, init[i].val);
-		}
+	rc = lan87xx_phy_init_cmd(phydev, hw_init, ARRAY_SIZE(hw_init));
+	if (rc < 0)
+		return rc;
+
+	rc = genphy_read_master_slave(phydev);
+	if (rc)
+		return rc;
+
+	/* Following squence need to run only if phydev is in
+	 * slave mode.
+	 */
+	if (phydev->master_slave_state == MASTER_SLAVE_STATE_SLAVE) {
+		rc = lan87xx_phy_init_cmd(phydev, slave_init,
+					  ARRAY_SIZE(slave_init));
 		if (rc < 0)
 			return rc;
 	}
 
+	rc = lan87xx_phy_init_cmd(phydev, phy_init, ARRAY_SIZE(phy_init));
+	if (rc < 0)
+		return rc;
+
 	return lan87xx_config_rgmii_delay(phydev);
 }
 
@@ -775,6 +812,7 @@ static int lan87xx_read_status(struct phy_device *phydev)
 static int lan87xx_config_aneg(struct phy_device *phydev)
 {
 	u16 ctl = 0;
+	int ret;
 
 	switch (phydev->master_slave_set) {
 	case MASTER_SLAVE_CFG_MASTER_FORCE:
@@ -790,7 +828,11 @@ static int lan87xx_config_aneg(struct phy_device *phydev)
 		return -EOPNOTSUPP;
 	}
 
-	return phy_modify_changed(phydev, MII_CTRL1000, CTL1000_AS_MASTER, ctl);
+	ret = phy_modify_changed(phydev, MII_CTRL1000, CTL1000_AS_MASTER, ctl);
+	if (ret == 1)
+		return phy_init_hw(phydev);
+
+	return ret;
 }
 
 static int lan87xx_get_sqi(struct phy_device *phydev)
-- 
2.34.1

