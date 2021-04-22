Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8472367DF5
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 11:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235782AbhDVJn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 05:43:57 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:51808 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235553AbhDVJnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 05:43:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1619084601; x=1650620601;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GIs/plfeDvT2Hgt+valhauIgDZPDSW3pYTisyyuAU+c=;
  b=zXG1+RRcQyxpMSqnmWb5GyZWPPPlMP5DqWigLRG9jhamEMyrqWmt7Z9V
   x7FAhYSEn5I/IDyGaSvwY51IAZDhavU68BKEJ+eEc4T8i0Ti6OB1UeHqk
   LQObe7sYkNDhSo1Qbau+K9RONDK/3OQBNmSrW3B916qd9vJW4RDzoV7J6
   L8z1IhwyApMMW6w0UpzKd8z0CgZI+wL0LDf1rPyMFPvQwkL3GC5AtD3I2
   Z1HRFCsMuOTFypyFErXKgjV5fj/knHz4Z/FForauMtPhPAJTL0ySLv83E
   D9tCRcKsLWBBHYSd6rudIwRBlTQ2Q2DXKizRQ9tLdXOU7vep/zXaQu4gD
   w==;
IronPort-SDR: aDPaKmnctRYwAQHeQMZVzMOB01FToL1vCcESfldFPI6WxD+fRzcIE5SmAJc+FKZ1LseCetPWfG
 n5LASBt7JG3HTtT4qYAsj055iLytb+tXjwFKqKukF0tM/aBAfxvckZoSGkZ4vTKtRFvTipY7+K
 +622h/jGmqHre+YUciffJE1OhFzcUPmvQjFwd48OHPf+6DuwHoLItFn6JuP+5t4PTIbYvckNPy
 9RPBX2FvhO2yKNKNqH60w58XZK/z6dtPpqgCpaiPBd3GNnzaBI5RGi+o44YPjW9pHZ1Su0+hUO
 LCQ=
X-IronPort-AV: E=Sophos;i="5.82,242,1613458800"; 
   d="scan'208";a="52098046"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Apr 2021 02:43:20 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Apr 2021 02:43:20 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Thu, 22 Apr 2021 02:43:14 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v2 net-next 2/9] net: phy: Add support for LAN937x T1 phy driver
Date:   Thu, 22 Apr 2021 15:12:50 +0530
Message-ID: <20210422094257.1641396-3-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added support for Microchip LAN937x T1 phy driver. The sequence of
initialization is used commonly for both LAN87xx and LAN937x
drivers. The new initialization sequence is an improvement to
existing LAN87xx and the same is shared with LAN937x.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
---
 drivers/net/phy/microchip_t1.c | 361 +++++++++++++++++++++++++++------
 1 file changed, 300 insertions(+), 61 deletions(-)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index 4dc00bd5a8d2..348ee7885bfd 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -30,16 +30,86 @@
 #define	PHYACC_ATTR_MODE_READ		0
 #define	PHYACC_ATTR_MODE_WRITE		1
 #define	PHYACC_ATTR_MODE_MODIFY		2
+#define PHYACC_ATTR_MODE_POLL		3
 
 #define	PHYACC_ATTR_BANK_SMI		0
 #define	PHYACC_ATTR_BANK_MISC		1
 #define	PHYACC_ATTR_BANK_PCS		2
 #define	PHYACC_ATTR_BANK_AFE		3
+#define PHYACC_ATTR_BANK_DSP		4
 #define	PHYACC_ATTR_BANK_MAX		7
 
 #define DRIVER_AUTHOR	"Nisar Sayed <nisar.sayed@microchip.com>"
 #define DRIVER_DESC	"Microchip LAN87XX T1 PHY driver"
 
+#define REG_PORT_T1_PHY_BASIC_CTRL 0x00
+
+#define PORT_T1_PHY_RESET	BIT(15)
+#define PORT_T1_PHY_LOOPBACK	BIT(14)
+#define PORT_T1_SPEED_100MBIT	BIT(13)
+#define PORT_T1_POWER_DOWN	BIT(11)
+#define PORT_T1_ISOLATE	BIT(10)
+#define PORT_T1_FULL_DUPLEX	BIT(8)
+
+#define REG_PORT_T1_PHY_BASIC_STATUS 0x01
+
+#define PORT_T1_MII_SUPPRESS_CAPABLE	BIT(6)
+#define PORT_T1_LINK_STATUS		BIT(2)
+#define PORT_T1_EXTENDED_CAPABILITY	BIT(0)
+
+#define REG_PORT_T1_PHY_ID_HI 0x02
+#define REG_PORT_T1_PHY_ID_LO 0x03
+
+#define LAN937X_T1_ID_HI 0x0007
+#define LAN937X_T1_ID_LO 0xC150
+
+#define REG_PORT_T1_PHY_M_CTRL 0x09
+
+#define PORT_T1_MANUAL_CFG	BIT(12)
+#define PORT_T1_M_CFG		BIT(11)
+
+#define REG_PORT_T1_MODE_STAT			0x11
+#define T1_PORT_DSCR_LOCK_STATUS_MSK		BIT(3)
+#define T1_PORT_LINK_UP_MSK			BIT(0)
+
+#define REG_PORT_T1_LOOPBACK_CTRL 0x12
+
+#define REG_PORT_T1_RESET_CTRL 0x13
+
+#define T1_PHYADDR_S 11
+
+#define REG_PORT_T1_EXT_REG_CTRL 0x14
+
+#define T1_PCS_STS_CNT_RESET		BIT(15)
+#define T1_IND_DATA_READ		BIT(12)
+#define T1_IND_DATA_WRITE		BIT(11)
+#define T1_REG_BANK_SEL_M		0x7
+#define T1_REG_BANK_SEL_S		8
+#define T1_REG_ADDR_M			0xFF
+
+#define REG_PORT_T1_EXT_REG_RD_DATA 0x15
+#define REG_PORT_T1_EXT_REG_WR_DATA 0x16
+
+#define REG_PORT_T1_PHY_INT_STATUS 0x18
+#define REG_PORT_T1_PHY_INT_ENABLE 0x19
+
+#define T1_LINK_UP_INT		BIT(2)
+#define T1_LINK_DOWN_INT	BIT(1)
+
+#define REG_PORT_T1_POWER_DOWN_CTRL 0x1A
+
+#define T1_HW_INIT_SEQ_ENABLE BIT(8)
+
+#define REG_PORT_T1_PHY_M_STATUS 0x0A
+
+#define PORT_T1_LOCAL_RX_OK	BIT(13)
+#define PORT_T1_REMOTE_RX_OK	BIT(12)
+
+#define LAN87XX_PHY_ID		0x0007c150
+#define LAN937X_T1_PHY_ID	0x0007c181
+#define LAN87XX_PHY_ID_MASK 0xfffffff0
+#define LAN937X_PHY_ID_MASK 0xfffffff0
+
 struct access_ereg_val {
 	u8  mode;
 	u8  bank;
@@ -51,12 +121,15 @@ struct access_ereg_val {
 static int access_ereg(struct phy_device *phydev, u8 mode, u8 bank,
 		       u8 offset, u16 val)
 {
+	u8 prev_bank;
 	u16 ereg = 0;
 	int rc = 0;
 
+	/* return if mode and bank are invalid */
 	if (mode > PHYACC_ATTR_MODE_WRITE || bank > PHYACC_ATTR_BANK_MAX)
 		return -EINVAL;
 
+	/* if the bank is SMI, then call phy_read() & phy_write() directly */
 	if (bank == PHYACC_ATTR_BANK_SMI) {
 		if (mode == PHYACC_ATTR_MODE_WRITE)
 			rc = phy_write(phydev, offset, val);
@@ -66,16 +139,43 @@ static int access_ereg(struct phy_device *phydev, u8 mode, u8 bank,
 	}
 
 	if (mode == PHYACC_ATTR_MODE_WRITE) {
+		/* Initialize to Write Mode */
 		ereg = LAN87XX_EXT_REG_CTL_WR_CTL;
+
+		/* Write the data to be written in to the Bank */
 		rc = phy_write(phydev, LAN87XX_EXT_REG_WR_DATA, val);
 		if (rc < 0)
 			return rc;
 	} else {
+		/* Initialize to Read Mode */
 		ereg = LAN87XX_EXT_REG_CTL_RD_CTL;
 	}
 
 	ereg |= (bank << 8) | offset;
 
+	/* DSP bank access register workaround for lan937x*/
+	if (phydev->phy_id == LAN937X_T1_PHY_ID) {
+		/* Read previous selected bank */
+		rc = phy_read(phydev, LAN87XX_EXT_REG_CTL);
+		if (rc < 0)
+			return rc;
+
+		/* Store the prev_bank */
+		prev_bank = (rc >> T1_REG_BANK_SEL_S) & T1_REG_BANK_SEL_M;
+
+		if (bank != prev_bank && bank == PHYACC_ATTR_BANK_DSP) {
+			u16 t = ereg & ~T1_REG_ADDR_M;
+
+			t &= ~LAN87XX_EXT_REG_CTL_WR_CTL;
+			t |= LAN87XX_EXT_REG_CTL_RD_CTL;
+
+			/* Need to access twice for DSP bank change - dummy access*/
+			rc = phy_write(phydev, LAN87XX_EXT_REG_CTL, t);
+			if (rc < 0)
+				return rc;
+		}
+	}
+
 	rc = phy_write(phydev, LAN87XX_EXT_REG_CTL, ereg);
 	if (rc < 0)
 		return rc;
@@ -104,63 +204,151 @@ static int access_ereg_modify_changed(struct phy_device *phydev,
 	return rc;
 }
 
-static int lan87xx_phy_init(struct phy_device *phydev)
+static int access_ereg_clr_poll_timeout(struct phy_device *phydev, u8 bank,
+					u8 offset, u16 mask, u16 clr)
+{
+	int val;
+
+	if (bank != PHYACC_ATTR_BANK_SMI)
+		return -EINVAL;
+
+	return phy_read_poll_timeout(phydev, offset, val, (val & mask) == clr,
+				     150, 30000, true);
+}
+
+static int mchp_t1_phy_init(struct phy_device *phydev)
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
+		/* TXPD/TXAMP6 Configs*/
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_AFE, 0x0B, 0x002D,
+		  0 },
+		/* HW_Init Hi and Force_ED */
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_SMI, 0x1A, 0x0308,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x18, 0x0D53,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x05, 0x0AB2,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x06, 0x0AB3,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x1A, 0x0AEA,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x1B, 0x0AEB,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x1C, 0x0AEB,
+		  0 },
+		/* Pointer delay */
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x02, 0x1C00,
+		  0 },
+		/* ---- tx iir edits ---- */
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x1000,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x1861,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x1061,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x1922,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x1122,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x1983,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x1183,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x1944,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x1144,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x18c5,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x10c5,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x1846,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x1046,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x1807,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x1007,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x1808,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x1008,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x1809,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x1009,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x180A,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x100A,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x180B,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x100B,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x180C,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x100C,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x180D,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x100D,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x180E,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x100E,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x180F,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x100F,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x1810,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x1010,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x1811,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x1011,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x55, 0x1000,
+		  0 },
+		/* SQI enable */
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 0x2E, 0x9572,
+		  0 },
+		/* Flag LPS and WUR as idle errors */
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_SMI, 0x10, 0x0014,
+		  0 },
+		/* Restore state machines without clearing registers */
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_SMI, 0x1A, 0x0200,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_SMI, 0x10, 0x0094,
+		  0 },
+		{ PHYACC_ATTR_MODE_POLL, PHYACC_ATTR_BANK_SMI, 0x10, 0x0080,
+		  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_AFE, 0x0B, 0x000C,
+		  0 },
+		/* Read INTERRUPT_SOURCE Register */
+		{ PHYACC_ATTR_MODE_READ, PHYACC_ATTR_BANK_SMI, 0x18, 0, 0 },
+		/* Read INTERRUPT_SOURCE Register */
+		{ PHYACC_ATTR_MODE_READ, PHYACC_ATTR_BANK_MISC, 0x08, 0, 0 },
+		/* HW_Init Hi */
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_SMI, 0x1A, 0x0300,
+		  0 },
 	};
 	int rc, i;
 
-	/* Start manual initialization procedures in Managed Mode */
-	rc = access_ereg_modify_changed(phydev, PHYACC_ATTR_BANK_SMI,
-					0x1a, 0x0000, 0x0100);
-	if (rc < 0)
-		return rc;
-
-	/* Soft Reset the SMI block */
+	/* Set Master Mode */
 	rc = access_ereg_modify_changed(phydev, PHYACC_ATTR_BANK_SMI,
-					0x00, 0x8000, 0x8000);
+					REG_PORT_T1_PHY_M_CTRL, PORT_T1_M_CFG,
+					PORT_T1_M_CFG);
 	if (rc < 0)
 		return rc;
 
-	/* Check to see if the self-clearing bit is cleared */
-	usleep_range(1000, 2000);
-	rc = access_ereg(phydev, PHYACC_ATTR_MODE_READ,
-			 PHYACC_ATTR_BANK_SMI, 0x00, 0);
+	/* phy Soft reset */
+	rc = genphy_soft_reset(phydev);
 	if (rc < 0)
 		return rc;
-	if ((rc & 0x8000) != 0)
-		return -ETIMEDOUT;
 
 	/* PHY Initialization */
 	for (i = 0; i < ARRAY_SIZE(init); i++) {
@@ -169,6 +357,11 @@ static int lan87xx_phy_init(struct phy_device *phydev)
 							init[i].offset,
 							init[i].val,
 							init[i].mask);
+		} else if (init[i].mode == PHYACC_ATTR_MODE_POLL) {
+			rc = access_ereg_clr_poll_timeout(phydev, init[i].bank,
+							  init[i].offset,
+							  init[i].val,
+							  init[i].mask);
 		} else {
 			rc = access_ereg(phydev, init[i].mode, init[i].bank,
 					 init[i].offset, init[i].val);
@@ -221,33 +414,79 @@ static irqreturn_t lan87xx_handle_interrupt(struct phy_device *phydev)
 
 static int lan87xx_config_init(struct phy_device *phydev)
 {
-	int rc = lan87xx_phy_init(phydev);
+	int rc = mchp_t1_phy_init(phydev);
+
+	if (rc < 0)
+		phydev_err(phydev, "failed to initialize phy\n");
 
 	return rc < 0 ? rc : 0;
 }
 
-static struct phy_driver microchip_t1_phy_driver[] = {
-	{
-		.phy_id         = 0x0007c150,
-		.phy_id_mask    = 0xfffffff0,
-		.name           = "Microchip LAN87xx T1",
+static int lan937x_read_status(struct phy_device *phydev)
+{
+	int val1, val2;
 
-		.features       = PHY_BASIC_T1_FEATURES,
+	val1 = phy_read(phydev, REG_PORT_T1_PHY_M_STATUS);
 
-		.config_init	= lan87xx_config_init,
+	if (val1 < 0)
+		return val1;
 
-		.config_intr    = lan87xx_phy_config_intr,
-		.handle_interrupt = lan87xx_handle_interrupt,
+	val2 = phy_read(phydev, REG_PORT_T1_MODE_STAT);
 
-		.suspend        = genphy_suspend,
-		.resume         = genphy_resume,
-	}
-};
+	if (val2 < 0)
+		return val2;
+
+	if (val1 & (PORT_T1_LOCAL_RX_OK | PORT_T1_REMOTE_RX_OK) &&
+	    val2 & (T1_PORT_DSCR_LOCK_STATUS_MSK | T1_PORT_LINK_UP_MSK))
+		phydev->link = 1;
+	else
+		phydev->link = 0;
+
+	phydev->duplex = DUPLEX_FULL;
+	phydev->speed = SPEED_100;
+	phydev->pause = 0;
+	phydev->asym_pause = 0;
+
+	return 0;
+}
+
+static int lan937x_config_init(struct phy_device *phydev)
+{
+	int rc = mchp_t1_phy_init(phydev);
+
+	if (rc < 0)
+		phydev_err(phydev, "failed to initialize phy\n");
+
+	return rc < 0 ? rc : 0;
+}
+
+static struct phy_driver microchip_t1_phy_driver[] = {
+{
+	.phy_id         = LAN87XX_PHY_ID,
+	.phy_id_mask    = LAN87XX_PHY_ID_MASK,
+	.name           = "LAN87xx T1",
+	.features       = PHY_BASIC_T1_FEATURES,
+	.config_init	= lan87xx_config_init,
+	.config_intr    = lan87xx_phy_config_intr,
+	.handle_interrupt = lan87xx_handle_interrupt,
+	.suspend        = genphy_suspend,
+	.resume         = genphy_resume,
+}, {
+	.phy_id		= LAN937X_T1_PHY_ID,
+	.phy_id_mask	= LAN937X_PHY_ID_MASK,
+	.name			= "LAN937x T1",
+	.read_status	= lan937x_read_status,
+	.features		= PHY_BASIC_T1_FEATURES,
+	.config_init	= lan937x_config_init,
+	.suspend		= genphy_suspend,
+	.resume		= genphy_resume,
+} };
 
 module_phy_driver(microchip_t1_phy_driver);
 
 static struct mdio_device_id __maybe_unused microchip_t1_tbl[] = {
-	{ 0x0007c150, 0xfffffff0 },
+	{ LAN87XX_PHY_ID, LAN87XX_PHY_ID_MASK },
+	{ LAN937X_T1_PHY_ID, LAN937X_PHY_ID_MASK },
 	{ }
 };
 
-- 
2.27.0

