Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 058B44CD190
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 10:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239347AbiCDJp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 04:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239331AbiCDJpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 04:45:50 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6055199E2A;
        Fri,  4 Mar 2022 01:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646387103; x=1677923103;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u/gmUcMkWFyReBAWL5lT+ofztv+GlIIobDDuvp/iOYk=;
  b=QH9UkdcdCk+bXfgQO7ojLozEHIh8b74IoOco217X/+oVhYYHgqoGRBLq
   6647pa0dZFEQQyo+4GHKwv+Dj1nrTw9/nhJzHyqZ5fslB3h//0/t40492
   aLtwc3stYTTwSlxqIyruY5VDflVe005bMne/tQ4Mr4/UZrPF2LNRqoeM+
   v628h+myjxs9oUmyFBt/t0EI/K23BqWkVLYo9fs/8y47cfHzbdrnCe6Ag
   joZdHHmP356zq+vH+8jW+hg3GpgyGgW4P6n4pTz+YVaXpSO2s0QCMdFB6
   Sc6xXo4QoRl+pMakh+lJYgpGNvqTp8TgHpzOhTCEpD15z9XLO2g1ANJZb
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,154,1643698800"; 
   d="scan'208";a="148081568"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2022 02:45:02 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Mar 2022 02:45:01 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Mar 2022 02:44:57 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next 4/6] net: phy: updated the initialization routine for LAN87xx
Date:   Fri, 4 Mar 2022 15:13:59 +0530
Message-ID: <20220304094401.31375-5-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220304094401.31375-1-arun.ramadoss@microchip.com>
References: <20220304094401.31375-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR,UPPERCASE_50_75 autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new initialization sequence is the improvement to the existing init
routine. Init routine does soft reset, run init script and set
Hw_init. Added the new access_smi_poll_timeout() for polling smi
bank write.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/phy/microchip_t1.c | 217 ++++++++++++++++++++++++++-------
 1 file changed, 175 insertions(+), 42 deletions(-)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index f247892902f7..d0bc0125f3ef 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -39,6 +39,7 @@
 #define	PHYACC_ATTR_MODE_READ		0
 #define	PHYACC_ATTR_MODE_WRITE		1
 #define	PHYACC_ATTR_MODE_MODIFY		2
+#define	PHYACC_ATTR_MODE_POLL		3
 
 #define	PHYACC_ATTR_BANK_SMI		0
 #define	PHYACC_ATTR_BANK_MISC		1
@@ -52,6 +53,28 @@
 #define	LAN87XX_CABLE_TEST_OPEN	1
 #define	LAN87XX_CABLE_TEST_SAME_SHORT	2
 
+/* T1 Registers */
+#define T1_AFE_PORT_CFG1_REG		0x0B
+#define T1_POWER_DOWN_CONTROL_REG	0x1A
+#define T1_SLV_FD_MULT_CFG_REG		0x18
+#define T1_CDR_CFG_PRE_LOCK_REG		0x05
+#define T1_CDR_CFG_POST_LOCK_REG	0x06
+#define T1_LCK_STG2_MUFACT_CFG_REG	0x1A
+#define T1_LCK_STG3_MUFACT_CFG_REG	0x1B
+#define T1_POST_LCK_MUFACT_CFG_REG	0x1C
+#define T1_TX_RX_FIFO_CFG_REG		0x02
+#define T1_TX_LPF_FIR_CFG_REG		0x55
+#define T1_SQI_CONFIG_REG		0x2E
+#define T1_MDIO_CONTROL2_REG		0x10
+#define T1_INTERRUPT_SOURCE_REG		0x18
+#define T1_INTERRUPT2_SOURCE_REG	0x08
+#define T1_EQ_FD_STG1_FRZ_CFG		0x69
+#define T1_EQ_FD_STG2_FRZ_CFG		0x6A
+#define T1_EQ_FD_STG3_FRZ_CFG		0x6B
+#define T1_EQ_FD_STG4_FRZ_CFG		0x6C
+#define T1_EQ_WT_FD_LCK_FRZ_CFG		0x6D
+#define T1_PST_EQ_LCK_STG1_FRZ_CFG	0x6E
+
 #define DRIVER_AUTHOR	"Nisar Sayed <nisar.sayed@microchip.com>"
 #define DRIVER_DESC	"Microchip LAN87XX T1 PHY driver"
 
@@ -119,6 +142,15 @@ static int access_ereg_modify_changed(struct phy_device *phydev,
 	return rc;
 }
 
+static int access_smi_poll_timeout(struct phy_device *phydev,
+				   u8 offset, u16 mask, u16 clr)
+{
+	int val;
+
+	return phy_read_poll_timeout(phydev, offset, val, (val & mask) == clr,
+				     150, 30000, true);
+}
+
 static int lan87xx_config_rgmii_delay(struct phy_device *phydev)
 {
 	int rc;
@@ -159,46 +191,146 @@ static int lan87xx_config_rgmii_delay(struct phy_device *phydev)
 static int lan87xx_phy_init(struct phy_device *phydev)
 {
 	static const struct access_ereg_val init[] = {
-		/* TX Amplitude = 5 */
-		{PHYACC_ATTR_MODE_MODIFY, PHYACC_ATTR_BANK_AFE, 0x0B,
-		 0x000A, 0x001E},
-		/* Clear SMI interrupts */
-		{PHYACC_ATTR_MODE_READ, PHYACC_ATTR_BANK_SMI, 0x18,
-		 0, 0},
-		/* Clear MISC interrupts */
-		{PHYACC_ATTR_MODE_READ, PHYACC_ATTR_BANK_MISC, 0x08,
-		 0, 0},
-		/* Turn on TC10 Ring Oscillator (ROSC) */
-		{PHYACC_ATTR_MODE_MODIFY, PHYACC_ATTR_BANK_MISC, 0x20,
-		 0x0020, 0x0020},
-		/* WUR Detect Length to 1.2uS, LPC Detect Length to 1.09uS */
-		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_PCS, 0x20,
-		 0x283C, 0},
-		/* Wake_In Debounce Length to 39uS, Wake_Out Length to 79uS */
-		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_MISC, 0x21,
-		 0x274F, 0},
-		/* Enable Auto Wake Forward to Wake_Out, ROSC on, Sleep,
-		 * and Wake_In to wake PHY
-		 */
-		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_MISC, 0x20,
-		 0x80A7, 0},
-		/* Enable WUP Auto Fwd, Enable Wake on MDI, Wakeup Debouncer
-		 * to 128 uS
-		 */
-		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_MISC, 0x24,
-		 0xF110, 0},
-		/* Enable HW Init */
-		{PHYACC_ATTR_MODE_MODIFY, PHYACC_ATTR_BANK_SMI, 0x1A,
-		 0x0100, 0x0100},
+		/* TXPD/TXAMP6 Configs */
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_AFE,
+		  T1_AFE_PORT_CFG1_REG,       0x002D,  0 },
+		/* HW_Init Hi and Force_ED */
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_SMI,
+		  T1_POWER_DOWN_CONTROL_REG,  0x0308,  0 },
+		/* Equalizer Full Duplex Freeze - T1 Slave */
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_EQ_FD_STG1_FRZ_CFG,     0x0002,  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_EQ_FD_STG2_FRZ_CFG,     0x0002,  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_EQ_FD_STG3_FRZ_CFG,     0x0002,  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_EQ_FD_STG4_FRZ_CFG,     0x0002,  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_EQ_WT_FD_LCK_FRZ_CFG,    0x0002,  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_PST_EQ_LCK_STG1_FRZ_CFG, 0x0002,  0 },
+		/* Slave Full Duplex Multi Configs */
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_SLV_FD_MULT_CFG_REG,     0x0D53,  0 },
+		/* CDR Pre and Post Lock Configs */
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_CDR_CFG_PRE_LOCK_REG,    0x0AB2,  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_CDR_CFG_POST_LOCK_REG,   0x0AB3,  0 },
+		/* Lock Stage 2-3 Multi Factor Config */
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_LCK_STG2_MUFACT_CFG_REG, 0x0AEA,  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_LCK_STG3_MUFACT_CFG_REG, 0x0AEB,  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_POST_LCK_MUFACT_CFG_REG, 0x0AEB,  0 },
+		/* Pointer delay */
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_RX_FIFO_CFG_REG, 0x1C00, 0 },
+		/* Tx iir edits */
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x1000, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x1861, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x1061, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x1922, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x1122, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x1983, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x1183, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x1944, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x1144, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x18c5, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x10c5, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x1846, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x1046, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x1807, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x1007, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x1808, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x1008, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x1809, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x1009, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x180A, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x100A, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x180B, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x100B, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x180C, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x100C, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x180D, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x100D, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x180E, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x100E, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x180F, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x100F, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x1810, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x1010, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x1811, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x1011, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_TX_LPF_FIR_CFG_REG, 0x1000, 0 },
+		/* SQI enable */
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_SQI_CONFIG_REG,		0x9572, 0 },
+		/* Flag LPS and WUR as idle errors */
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_SMI,
+		  T1_MDIO_CONTROL2_REG,		0x0014, 0 },
+		/* HW_Init toggle, undo force ED, TXPD off */
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_SMI,
+		  T1_POWER_DOWN_CONTROL_REG,	0x0200, 0 },
+		/* Reset PCS to trigger hardware initialization */
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_SMI,
+		  T1_MDIO_CONTROL2_REG,		0x0094, 0 },
+		/* Poll till Hardware is initialized */
+		{ PHYACC_ATTR_MODE_POLL, PHYACC_ATTR_BANK_SMI,
+		  T1_MDIO_CONTROL2_REG,		0x0080, 0 },
+		/* Tx AMP - 0x06  */
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_AFE,
+		  T1_AFE_PORT_CFG1_REG,		0x000C, 0 },
+		/* Read INTERRUPT_SOURCE Register */
+		{ PHYACC_ATTR_MODE_READ, PHYACC_ATTR_BANK_SMI,
+		  T1_INTERRUPT_SOURCE_REG,	0,	0 },
+		/* Read INTERRUPT_SOURCE Register */
+		{ PHYACC_ATTR_MODE_READ, PHYACC_ATTR_BANK_MISC,
+		  T1_INTERRUPT2_SOURCE_REG,	0,	0 },
+		/* HW_Init Hi */
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_SMI,
+		  T1_POWER_DOWN_CONTROL_REG,	0x0300, 0 },
 	};
 	int rc, i;
 
-	/* Start manual initialization procedures in Managed Mode */
-	rc = access_ereg_modify_changed(phydev, PHYACC_ATTR_BANK_SMI,
-					0x1a, 0x0000, 0x0100);
-	if (rc < 0)
-		return rc;
-
 	/* phy Soft reset */
 	rc = genphy_soft_reset(phydev);
 	if (rc < 0)
@@ -206,11 +338,12 @@ static int lan87xx_phy_init(struct phy_device *phydev)
 
 	/* PHY Initialization */
 	for (i = 0; i < ARRAY_SIZE(init); i++) {
-		if (init[i].mode == PHYACC_ATTR_MODE_MODIFY) {
-			rc = access_ereg_modify_changed(phydev, init[i].bank,
-							init[i].offset,
-							init[i].val,
-							init[i].mask);
+		if (init[i].mode == PHYACC_ATTR_MODE_POLL &&
+		    init[i].bank == PHYACC_ATTR_BANK_SMI) {
+			rc = access_smi_poll_timeout(phydev,
+						     init[i].offset,
+						     init[i].val,
+						     init[i].mask);
 		} else {
 			rc = access_ereg(phydev, init[i].mode, init[i].bank,
 					 init[i].offset, init[i].val);
-- 
2.33.0

