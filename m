Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A303D3EC0
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 19:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbhGWQvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:51:13 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:8405 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbhGWQvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 12:51:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1627061503; x=1658597503;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FctFW+tal6+eUas/qA16gGgOiIeXTlxFcnI3y94altg=;
  b=OnS91AJj8Mcy8eeiQpTvOxJIlWW4vqowmy6ayPayLS4AxteDP5sFPYYk
   xlHuvIED9NdLCFgNbL2yXdR2VbGEi4lnC+wGVLEKGMs+tjI/FCjkf9Mx4
   IBrJLDxCkxetQuOE7kIIyEKI30qDWQWEHLlzTEoxvc9YGva1J0hRz9nM5
   sBnHb+ylrA6p+4bi+ZIcEqjWj9n2Qum4lph60TKgcny/O1LHIJsajR7i4
   p8p6T86ATtPP6Eg4f1t+MRSwN3bT75cQumU5SC1AlTGc4TP0shvKOBnww
   OJ17HBz5+7bOiusk804/0VE3ahKx4vdZpiIB8UXhWoa2MOvcpOrnBaHjL
   Q==;
IronPort-SDR: Yk9kI1Hv7lpKTVyvOisdRtxtF4T3/Jg4eBxbN7W3OK8GzF9wz0vfKDip/ht3RmZ5Y2YyJSfkhA
 uEjsT68Tsj4Rxj2SXxmZZ/AEe5wHARRKqWCgj5i9DPplogGptDzDa2Ty4/ivKPK8ckkj9HBA+0
 DbiTZkWB4ZlwV4rSiCpZ97jCTcgwSbw6TOvUPTxtgtM25+yDnfQNMVGmdWPdySsC5mOcY9NtMf
 gFVN1Bs7W1Bkn/SXtvScnDF9rsG3JpSl0f6f2BUwc5N8OY+r1a/oiVVR58PdfAp2eqvN4Dtm5g
 SH1S7AL58QMv6dmFhijgbt26
X-IronPort-AV: E=Sophos;i="5.84,264,1620716400"; 
   d="scan'208";a="125755635"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jul 2021 10:31:42 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Jul 2021 10:31:33 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 23 Jul 2021 10:31:28 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v3 net-next 03/10] net: phy: Add support for LAN937x T1 phy driver
Date:   Fri, 23 Jul 2021 23:01:01 +0530
Message-ID: <20210723173108.459770-4-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added support for Microchip LAN937x T1 phy driver. The sequence of
initialization is used commonly for both LAN87xx and LAN937x
drivers. The new initialization sequence is an improvement to
existing LAN87xx and it is shared with LAN937x.

Also relevant comments are added in the existing code and existing
soft-reset customized code has been replaced with
genphy_soft_reset().

access_ereg_clr_poll_timeout() API is introduced for polling phy
bank write and this is linked with PHYACC_ATTR_MODE_POLL.

Finally introduced function table for LAN937X_T1_PHY_ID along with
microchip_t1_phy_driver struct.

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
---
 drivers/net/phy/microchip_t1.c | 319 +++++++++++++++++++++++++++------
 1 file changed, 260 insertions(+), 59 deletions(-)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index 4dc00bd5a8d2..a3f1b5d123ce 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -30,15 +30,53 @@
 #define	PHYACC_ATTR_MODE_READ		0
 #define	PHYACC_ATTR_MODE_WRITE		1
 #define	PHYACC_ATTR_MODE_MODIFY		2
+#define	PHYACC_ATTR_MODE_POLL		3
 
 #define	PHYACC_ATTR_BANK_SMI		0
 #define	PHYACC_ATTR_BANK_MISC		1
 #define	PHYACC_ATTR_BANK_PCS		2
 #define	PHYACC_ATTR_BANK_AFE		3
+#define	PHYACC_ATTR_BANK_DSP		4
 #define	PHYACC_ATTR_BANK_MAX		7
 
+#define T1_M_CTRL_REG			0x09
+#define T1_M_CFG			BIT(11)
+
+#define T1_MODE_STAT_REG		0x11
+#define T1_DSCR_LOCK_STATUS_MSK		BIT(3)
+#define T1_LINK_UP_MSK			BIT(0)
+
+#define T1_REG_BANK_SEL_MASK		0x7
+#define T1_REG_BANK_SEL			8
+#define T1_REG_ADDR_MASK		0xFF
+
+#define T1_M_STATUS_REG			0x0A
+#define T1_LOCAL_RX_OK			BIT(13)
+#define T1_REMOTE_RX_OK			BIT(12)
+
+#define LAN87XX_PHY_ID			0x0007c150
+#define LAN937X_T1_PHY_ID		0x0007c181
+#define LAN87XX_PHY_ID_MASK		0xfffffff0
+#define LAN937X_PHY_ID_MASK		0xfffffff0
+
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
+
 #define DRIVER_AUTHOR	"Nisar Sayed <nisar.sayed@microchip.com>"
-#define DRIVER_DESC	"Microchip LAN87XX T1 PHY driver"
+#define DRIVER_DESC	"Microchip LAN87XX/LAN937X T1 PHY driver"
 
 struct access_ereg_val {
 	u8  mode;
@@ -51,12 +89,16 @@ struct access_ereg_val {
 static int access_ereg(struct phy_device *phydev, u8 mode, u8 bank,
 		       u8 offset, u16 val)
 {
+	u8 prev_bank;
 	u16 ereg = 0;
 	int rc = 0;
+	u16 t;
 
+	/* return if mode and bank are invalid */
 	if (mode > PHYACC_ATTR_MODE_WRITE || bank > PHYACC_ATTR_BANK_MAX)
 		return -EINVAL;
 
+	/* if the bank is SMI, then call phy_read() & phy_write() directly */
 	if (bank == PHYACC_ATTR_BANK_SMI) {
 		if (mode == PHYACC_ATTR_MODE_WRITE)
 			rc = phy_write(phydev, offset, val);
@@ -66,16 +108,43 @@ static int access_ereg(struct phy_device *phydev, u8 mode, u8 bank,
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
 
+	/* DSP bank access workaround for lan937x*/
+	if (phydev->phy_id == LAN937X_T1_PHY_ID) {
+		/* Read previous selected bank */
+		rc = phy_read(phydev, LAN87XX_EXT_REG_CTL);
+		if (rc < 0)
+			return rc;
+
+		/* Store the prev_bank */
+		prev_bank = (rc >> T1_REG_BANK_SEL) & T1_REG_BANK_SEL_MASK;
+
+		if (bank != prev_bank && bank == PHYACC_ATTR_BANK_DSP) {
+			t = ereg & ~T1_REG_ADDR_MASK;
+
+			t &= ~LAN87XX_EXT_REG_CTL_WR_CTL;
+			t |= LAN87XX_EXT_REG_CTL_RD_CTL;
+
+			/*access twice for DSP bank change,dummy access*/
+			rc = phy_write(phydev, LAN87XX_EXT_REG_CTL, t);
+			if (rc < 0)
+				return rc;
+		}
+	}
+
 	rc = phy_write(phydev, LAN87XX_EXT_REG_CTL, ereg);
 	if (rc < 0)
 		return rc;
@@ -104,63 +173,152 @@ static int access_ereg_modify_changed(struct phy_device *phydev,
 	return rc;
 }
 
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
+		/* TXPD/TXAMP6 Configs*/
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_AFE,
+		  T1_AFE_PORT_CFG1_REG,       0x002D,  0 },
+		/* HW_Init Hi and Force_ED */
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_SMI,
+		  T1_POWER_DOWN_CONTROL_REG,  0x0308,  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_SLV_FD_MULT_CFG_REG,     0x0D53,  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_CDR_CFG_PRE_LOCK_REG,    0x0AB2,  0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
+		  T1_CDR_CFG_POST_LOCK_REG,   0x0AB3,  0 },
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
+		/* Restore state machines without clearing registers */
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_SMI,
+		  T1_POWER_DOWN_CONTROL_REG,	0x0200, 0 },
+		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_SMI,
+		  T1_MDIO_CONTROL2_REG,		0x0094, 0 },
+		{ PHYACC_ATTR_MODE_POLL, PHYACC_ATTR_BANK_SMI,
+		  T1_MDIO_CONTROL2_REG,		0x0080, 0 },
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
-	/* Soft Reset the SMI block */
+	/* Set Master Mode */
 	rc = access_ereg_modify_changed(phydev, PHYACC_ATTR_BANK_SMI,
-					0x00, 0x8000, 0x8000);
+					T1_M_CTRL_REG, T1_M_CFG, T1_M_CFG);
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
@@ -169,6 +327,11 @@ static int lan87xx_phy_init(struct phy_device *phydev)
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
@@ -223,32 +386,70 @@ static int lan87xx_config_init(struct phy_device *phydev)
 {
 	int rc = lan87xx_phy_init(phydev);
 
+	if (rc < 0)
+		phydev_err(phydev, "failed to initialize phy\n");
+
 	return rc < 0 ? rc : 0;
 }
 
-static struct phy_driver microchip_t1_phy_driver[] = {
-	{
-		.phy_id         = 0x0007c150,
-		.phy_id_mask    = 0xfffffff0,
-		.name           = "Microchip LAN87xx T1",
+static int lan937x_read_status(struct phy_device *phydev)
+{
+	int val;
 
-		.features       = PHY_BASIC_T1_FEATURES,
+	val = phy_read(phydev, T1_MODE_STAT_REG);
 
-		.config_init	= lan87xx_config_init,
+	if (val < 0)
+		return val;
 
-		.config_intr    = lan87xx_phy_config_intr,
-		.handle_interrupt = lan87xx_handle_interrupt,
+	if (val & T1_LINK_UP_MSK)
+		phydev->link = 1;
+	else
+		phydev->link = 0;
 
-		.suspend        = genphy_suspend,
-		.resume         = genphy_resume,
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
+	/* lan87xx & lan937x follows same init sequence */
+	return lan87xx_config_init(phydev);
+}
+
+static struct phy_driver microchip_t1_phy_driver[] = {
+	{
+		.phy_id = LAN87XX_PHY_ID,
+		.phy_id_mask = LAN87XX_PHY_ID_MASK,
+		.name = "LAN87xx T1",
+		.features = PHY_BASIC_T1_FEATURES,
+		.config_init = lan87xx_config_init,
+		.config_intr = lan87xx_phy_config_intr,
+		.handle_interrupt = lan87xx_handle_interrupt,
+		.suspend = genphy_suspend,
+		.resume = genphy_resume,
+	},
+	{
+		.phy_id = LAN937X_T1_PHY_ID,
+		.phy_id_mask = LAN937X_PHY_ID_MASK,
+		.name = "LAN937x T1",
+		.read_status = lan937x_read_status,
+		.features = PHY_BASIC_T1_FEATURES,
+		.config_init = lan937x_config_init,
+		.suspend = genphy_suspend,
+		.resume = genphy_resume,
 	}
 };
 
 module_phy_driver(microchip_t1_phy_driver);
 
 static struct mdio_device_id __maybe_unused microchip_t1_tbl[] = {
-	{ 0x0007c150, 0xfffffff0 },
-	{ }
+	{ LAN87XX_PHY_ID, LAN87XX_PHY_ID_MASK },
+	{ LAN937X_T1_PHY_ID, LAN937X_PHY_ID_MASK },
+	{}
 };
 
 MODULE_DEVICE_TABLE(mdio, microchip_t1_tbl);
-- 
2.27.0

