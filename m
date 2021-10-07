Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363C242565A
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 17:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242423AbhJGPO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 11:14:29 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:53495 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242346AbhJGPO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 11:14:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1633619554; x=1665155554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FTT9yMdaaOjUOFVKFOngR8wdMzU1JDwlumhO/5njwW8=;
  b=ypL8hpWzWH83ZmHV2bhPAUgLpf6ZRdTcW8A5IhVbruL/17H2pEXPvIol
   0iM6JZekm6Ksy1sXNNW9XLBRYpW5d5Vnx3nl7ok2MLl5jkJPnJUQcv477
   d077S3J8Lhoxin6yCVJh4b2j91/xR5quR/cjXJmX6Gm5KNk8SfjJDzgJq
   r2l7jw8q6/R4Gr/5rMHEh3jDP07AcVP8jijv3660oQnOVuzjLqU5fRgqI
   vis94iASzgLKoxR+ifDB7WaSnGhmng/aCBcTVIWGU6ygxnDc6d4MUBbtq
   FTRckTMv3IDqsENKDg8EDlOY9g526JA/5RE0tETKvQhHzO8CigMFA/rHV
   w==;
IronPort-SDR: yXOQ5Bzd2ZTSArgwQ5QKGXtdPws6yPOmX4HyDqsD83k8eVv4aHcnChXm98v8zhncOXCYMN64BN
 LBK1CuGxfxJDu5gGVaH1shpCsB7dO+/25+6BLpzDaUCUVB/w9H07CNQNWhmd+sxZ8n52ZU8KQg
 CyvjB0lojkTvdoBxQQLBLvvshgvX0rUQDHxri/KtY949Ly4Mmman4XGFzGkwRk9VgCLdhi7gpF
 kOoxiHagIFBP1eosySsm14uK2a4l7JFx0LVImMsNbVJnEM29b3Zx0wqSdM76lhLKmZNjErh0Pe
 ZyKOfADSq2jBkSW1gNUOCkom
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="72033957"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Oct 2021 08:12:33 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 7 Oct 2021 08:12:32 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 7 Oct 2021 08:12:26 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v4 net-next 03/10] net: phy: Add support for LAN937x T1 phy driver
Date:   Thu, 7 Oct 2021 20:41:53 +0530
Message-ID: <20211007151200.748944-4-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211007151200.748944-1-prasanna.vengateshan@microchip.com>
References: <20211007151200.748944-1-prasanna.vengateshan@microchip.com>
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
 drivers/net/phy/microchip_t1.c | 339 +++++++++++++++++++++++++++------
 1 file changed, 276 insertions(+), 63 deletions(-)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index 4dc00bd5a8d2..022cc36c72c7 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -30,15 +30,59 @@
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
+#define T1_EQ_FD_STG1_FRZ_CFG		0x69
+#define T1_EQ_FD_STG2_FRZ_CFG		0x6A
+#define T1_EQ_FD_STG3_FRZ_CFG		0x6B
+#define T1_EQ_FD_STG4_FRZ_CFG		0x6C
+#define T1_EQ_WT_FD_LCK_FRZ_CFG		0x6D
+#define T1_PST_EQ_LCK_STG1_FRZ_CFG	0x6E
+
 #define DRIVER_AUTHOR	"Nisar Sayed <nisar.sayed@microchip.com>"
-#define DRIVER_DESC	"Microchip LAN87XX T1 PHY driver"
+#define DRIVER_DESC	"Microchip LAN87XX/LAN937X T1 PHY driver"
 
 struct access_ereg_val {
 	u8  mode;
@@ -51,12 +95,16 @@ struct access_ereg_val {
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
@@ -66,16 +114,43 @@ static int access_ereg(struct phy_device *phydev, u8 mode, u8 bank,
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
 
+	/* DSP bank access workaround for lan937x */
+	if (phydev->phy_id == LAN937X_T1_PHY_ID) {
+		/* Read previous selected bank */
+		rc = phy_read(phydev, LAN87XX_EXT_REG_CTL);
+		if (rc < 0)
+			return rc;
+
+		/* store the prev_bank */
+		prev_bank = (rc >> T1_REG_BANK_SEL) & T1_REG_BANK_SEL_MASK;
+
+		if (bank != prev_bank && bank == PHYACC_ATTR_BANK_DSP) {
+			t = ereg & ~T1_REG_ADDR_MASK;
+
+			t &= ~LAN87XX_EXT_REG_CTL_WR_CTL;
+			t |= LAN87XX_EXT_REG_CTL_RD_CTL;
+
+			/* access twice for DSP bank change,dummy access */
+			rc = phy_write(phydev, LAN87XX_EXT_REG_CTL, t);
+			if (rc < 0)
+				return rc;
+		}
+	}
+
 	rc = phy_write(phydev, LAN87XX_EXT_REG_CTL, ereg);
 	if (rc < 0)
 		return rc;
@@ -104,64 +179,159 @@ static int access_ereg_modify_changed(struct phy_device *phydev,
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
+		/* TXPD/TXAMP6 Configs */
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
-	rc = access_ereg_modify_changed(phydev, PHYACC_ATTR_BANK_SMI,
-					0x00, 0x8000, 0x8000);
+	/* phy Soft reset */
+	rc = genphy_soft_reset(phydev);
 	if (rc < 0)
 		return rc;
 
-	/* Check to see if the self-clearing bit is cleared */
-	usleep_range(1000, 2000);
-	rc = access_ereg(phydev, PHYACC_ATTR_MODE_READ,
-			 PHYACC_ATTR_BANK_SMI, 0x00, 0);
-	if (rc < 0)
-		return rc;
-	if ((rc & 0x8000) != 0)
-		return -ETIMEDOUT;
-
 	/* PHY Initialization */
 	for (i = 0; i < ARRAY_SIZE(init); i++) {
 		if (init[i].mode == PHYACC_ATTR_MODE_MODIFY) {
@@ -169,6 +339,11 @@ static int lan87xx_phy_init(struct phy_device *phydev)
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
@@ -223,32 +398,70 @@ static int lan87xx_config_init(struct phy_device *phydev)
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
+
+	phydev->duplex = DUPLEX_FULL;
+	phydev->speed = SPEED_100;
+	phydev->pause = 0;
+	phydev->asym_pause = 0;
 
-		.suspend        = genphy_suspend,
-		.resume         = genphy_resume,
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

