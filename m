Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCB743D08D
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 20:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236888AbhJ0SWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 14:22:22 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:52126 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbhJ0SWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 14:22:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635358796; x=1666894796;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MKaR2BgnMEsrdNpD185esRZRpFVpOKpvtgpzcfZ0K+k=;
  b=X/Ytrdf3AfyTcCLrTM2kr8N7jwm8UkU3+JXVZ7jXOqodZzpOtcgCiOCm
   m8ueTcFbNZyxRE14uYPASJlCwnzcD84//HFWwG+099LQP5SiIQRvNBbph
   X2z2FrDRiC8tRNalgQz7p3L2oavrv8/rX3ncwK0HL9kSPaq0EyZIOHlaT
   xQmUTCejOkepcNmUVmTcBkZxwsQZKzcizyFaZO0tTmS+9fM0v8kaEMMBI
   xgVExpIx3rNuUaVDuJEMx+MlYzE/+Lulh0nQCdDrhFqDuDznFvmRdPo+S
   /DJJh5yv6I3dXSkJMAqz+UgrK27go3cOwuBQu07JZk7CvBg1UcdeJd1At
   w==;
IronPort-SDR: EtvgwThj4Qkuw96xCYoheHvne4OdL9XlvOkaNcEjnyab/uL6xIk1JwV8B4z9YfiWVTA/nPGgBv
 SfIPpCyNr6eMvTKrFdxZFg+tlZpBHkuHkmS7ozb3ICeM7FmpKePd/6Y3dpgPrDFZkmSxKoZQdG
 VLzgctXyhyHiB5KA8QHYtfj5KPCVxZZNVnWAqoKPx3MzmgLiP9Ji8MCXbNmqF2DKqwbYveRp7b
 IcUBYCr8yj7A1C2euJzYNkRfw0kP77voCGHVcZwwi9lHREgnevk6+XORyRs1Y9UJ2Vi1qwsBl9
 lzXCEwU1/Yx7nYy2JAr8k3Ew
X-IronPort-AV: E=Sophos;i="5.87,187,1631602800"; 
   d="scan'208";a="137091778"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Oct 2021 11:19:55 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 27 Oct 2021 11:19:54 -0700
Received: from validation1-XPS-8900.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 27 Oct 2021 11:19:54 -0700
From:   Yuiko Oshino <yuiko.oshino@microchip.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <nisar.sayed@microchip.com>, <UNGLinuxDriver@microchip.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>
Subject: [PATCH v2 net-next] net: phy: microchip_t1: add cable test support for lan87xx phy
Date:   Wed, 27 Oct 2021 14:20:51 -0400
Message-ID: <20211027182051.11922-1-yuiko.oshino@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a basic cable test (diagnostic) support for lan87xx phy.
Tested with LAN8770 for connected/open/short wires using ethtool.

Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
---
v1 -> v2
	Removed unused register defines
	Removed unnecessary register value check
	Added LAN87xx_CABLE_TEST defines
---
 drivers/net/phy/microchip_t1.c | 239 +++++++++++++++++++++++++++++++++
 1 file changed, 239 insertions(+)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index 4dc00bd5a8d2..a4de3d2081c5 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -6,6 +6,8 @@
 #include <linux/delay.h>
 #include <linux/mii.h>
 #include <linux/phy.h>
+#include <linux/ethtool.h>
+#include <linux/ethtool_netlink.h>
 
 /* External Register Control Register */
 #define LAN87XX_EXT_REG_CTL                     (0x14)
@@ -35,8 +37,14 @@
 #define	PHYACC_ATTR_BANK_MISC		1
 #define	PHYACC_ATTR_BANK_PCS		2
 #define	PHYACC_ATTR_BANK_AFE		3
+#define	PHYACC_ATTR_BANK_DSP		4
 #define	PHYACC_ATTR_BANK_MAX		7
 
+/* measurement defines */
+#define	LAN87XX_CABLE_TEST_OK		0
+#define	LAN87XX_CABLE_TEST_OPEN	1
+#define	LAN87XX_CABLE_TEST_SAME_SHORT	2
+
 #define DRIVER_AUTHOR	"Nisar Sayed <nisar.sayed@microchip.com>"
 #define DRIVER_DESC	"Microchip LAN87XX T1 PHY driver"
 
@@ -226,11 +234,240 @@ static int lan87xx_config_init(struct phy_device *phydev)
 	return rc < 0 ? rc : 0;
 }
 
+static int microchip_cable_test_start_common(struct phy_device *phydev)
+{
+	int bmcr, bmsr, ret;
+
+	/* If auto-negotiation is enabled, but not complete, the cable
+	 * test never completes. So disable auto-neg.
+	 */
+	bmcr = phy_read(phydev, MII_BMCR);
+	if (bmcr < 0)
+		return bmcr;
+
+	bmsr = phy_read(phydev, MII_BMSR);
+
+	if (bmsr < 0)
+		return bmsr;
+
+	if (bmcr & BMCR_ANENABLE) {
+		ret =  phy_modify(phydev, MII_BMCR, BMCR_ANENABLE, 0);
+		if (ret < 0)
+			return ret;
+		ret = genphy_soft_reset(phydev);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* If the link is up, allow it some time to go down */
+	if (bmsr & BMSR_LSTATUS)
+		msleep(1500);
+
+	return 0;
+}
+
+static int lan87xx_cable_test_start(struct phy_device *phydev)
+{
+	static const struct access_ereg_val cable_test[] = {
+		/* min wait */
+		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 93,
+		 0, 0},
+		/* max wait */
+		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 94,
+		 10, 0},
+		/* pulse cycle */
+		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 95,
+		 90, 0},
+		/* cable diag thresh */
+		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 92,
+		 60, 0},
+		/* max gain */
+		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 79,
+		 31, 0},
+		/* clock align for each iteration */
+		{PHYACC_ATTR_MODE_MODIFY, PHYACC_ATTR_BANK_DSP, 55,
+		 0, 0x0038},
+		/* max cycle wait config */
+		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 94,
+		 70, 0},
+		/* start cable diag*/
+		{PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 90,
+		 1, 0},
+	};
+	int rc, i;
+
+	rc = microchip_cable_test_start_common(phydev);
+	if (rc < 0)
+		return rc;
+
+	/* start cable diag */
+	/* check if part is alive - if not, return diagnostic error */
+	rc = access_ereg(phydev, PHYACC_ATTR_MODE_READ, PHYACC_ATTR_BANK_SMI,
+			 0x00, 0);
+	if (rc < 0)
+		return rc;
+
+	/* master/slave specific configs */
+	rc = access_ereg(phydev, PHYACC_ATTR_MODE_READ, PHYACC_ATTR_BANK_SMI,
+			 0x0A, 0);
+	if (rc < 0)
+		return rc;
+
+	if ((rc & 0x4000) != 0x4000) {
+		/* DUT is Slave */
+		rc = access_ereg_modify_changed(phydev, PHYACC_ATTR_BANK_AFE,
+						0x0E, 0x5, 0x7);
+		if (rc < 0)
+			return rc;
+		rc = access_ereg_modify_changed(phydev, PHYACC_ATTR_BANK_SMI,
+						0x1A, 0x8, 0x8);
+		if (rc < 0)
+			return rc;
+	} else {
+		/* DUT is Master */
+		rc = access_ereg_modify_changed(phydev, PHYACC_ATTR_BANK_SMI,
+						0x10, 0x8, 0x40);
+		if (rc < 0)
+			return rc;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(cable_test); i++) {
+		if (cable_test[i].mode == PHYACC_ATTR_MODE_MODIFY) {
+			rc = access_ereg_modify_changed(phydev,
+							cable_test[i].bank,
+							cable_test[i].offset,
+							cable_test[i].val,
+							cable_test[i].mask);
+			/* wait 50ms */
+			msleep(50);
+		} else {
+			rc = access_ereg(phydev, cable_test[i].mode,
+					 cable_test[i].bank,
+					 cable_test[i].offset,
+					 cable_test[i].val);
+		}
+		if (rc < 0)
+			return rc;
+	}
+	/* cable diag started */
+
+	return 0;
+}
+
+static int lan87xx_cable_test_report_trans(u32 result)
+{
+	switch (result) {
+	case LAN87XX_CABLE_TEST_OK:
+		return ETHTOOL_A_CABLE_RESULT_CODE_OK;
+	case LAN87XX_CABLE_TEST_OPEN:
+		return ETHTOOL_A_CABLE_RESULT_CODE_OPEN;
+	case LAN87XX_CABLE_TEST_SAME_SHORT:
+		return ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT;
+	default:
+		/* DIAGNOSTIC_ERROR */
+		return ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC;
+	}
+}
+
+static int lan87xx_cable_test_report(struct phy_device *phydev)
+{
+	int pos_peak_cycle = 0, pos_peak_in_phases = 0, pos_peak_phase = 0;
+	int neg_peak_cycle = 0, neg_peak_in_phases = 0, neg_peak_phase = 0;
+	int noise_margin = 20, time_margin = 89, jitter_var = 30;
+	int min_time_diff = 96, max_time_diff = 96 + time_margin;
+	bool fault = false, check_a = false, check_b = false;
+	int gain_idx = 0, pos_peak = 0, neg_peak = 0;
+	int pos_peak_time = 0, neg_peak_time = 0;
+	int pos_peak_in_phases_hybrid = 0;
+	int detect = -1;
+
+	gain_idx = access_ereg(phydev, PHYACC_ATTR_MODE_READ,
+			       PHYACC_ATTR_BANK_DSP, 151, 0);
+	/* read non-hybrid results */
+	pos_peak = access_ereg(phydev, PHYACC_ATTR_MODE_READ,
+			       PHYACC_ATTR_BANK_DSP, 153, 0);
+	neg_peak = access_ereg(phydev, PHYACC_ATTR_MODE_READ,
+			       PHYACC_ATTR_BANK_DSP, 154, 0);
+	pos_peak_time = access_ereg(phydev, PHYACC_ATTR_MODE_READ,
+				    PHYACC_ATTR_BANK_DSP, 156, 0);
+	neg_peak_time = access_ereg(phydev, PHYACC_ATTR_MODE_READ,
+				    PHYACC_ATTR_BANK_DSP, 157, 0);
+
+	pos_peak_cycle = (pos_peak_time >> 7) & 0x7F;
+	/* calculate non-hybrid values */
+	pos_peak_phase = pos_peak_time & 0x7F;
+	pos_peak_in_phases = (pos_peak_cycle * 96) + pos_peak_phase;
+	neg_peak_cycle = (neg_peak_time >> 7) & 0x7F;
+	neg_peak_phase = neg_peak_time & 0x7F;
+	neg_peak_in_phases = (neg_peak_cycle * 96) + neg_peak_phase;
+
+	/* process values */
+	check_a =
+		((pos_peak_in_phases - neg_peak_in_phases) >= min_time_diff) &&
+		((pos_peak_in_phases - neg_peak_in_phases) < max_time_diff) &&
+		pos_peak_in_phases_hybrid < pos_peak_in_phases &&
+		(pos_peak_in_phases_hybrid < (neg_peak_in_phases + jitter_var));
+	check_b =
+		((neg_peak_in_phases - pos_peak_in_phases) >= min_time_diff) &&
+		((neg_peak_in_phases - pos_peak_in_phases) < max_time_diff) &&
+		pos_peak_in_phases_hybrid < neg_peak_in_phases &&
+		(pos_peak_in_phases_hybrid < (pos_peak_in_phases + jitter_var));
+
+	if (pos_peak_in_phases > neg_peak_in_phases && check_a)
+		detect = 2;
+	else if ((neg_peak_in_phases > pos_peak_in_phases) && check_b)
+		detect = 1;
+
+	if (pos_peak > noise_margin && neg_peak > noise_margin &&
+	    gain_idx >= 0) {
+		if (detect == 1 || detect == 2)
+			fault = true;
+	}
+
+	if (!fault)
+		detect = 0;
+
+	ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_A,
+				lan87xx_cable_test_report_trans(detect));
+
+	return 0;
+}
+
+static int lan87xx_cable_test_get_status(struct phy_device *phydev,
+					 bool *finished)
+{
+	int rc = 0;
+
+	*finished = false;
+
+	/* check if cable diag was finished */
+	rc = access_ereg(phydev, PHYACC_ATTR_MODE_READ, PHYACC_ATTR_BANK_DSP,
+			 90, 0);
+	if (rc < 0)
+		return rc;
+
+	if ((rc & 2) == 2) {
+		/* stop cable diag*/
+		rc = access_ereg(phydev, PHYACC_ATTR_MODE_WRITE,
+				 PHYACC_ATTR_BANK_DSP,
+				 90, 0);
+		if (rc < 0)
+			return rc;
+
+		*finished = true;
+
+		return lan87xx_cable_test_report(phydev);
+	}
+
+	return 0;
+}
+
 static struct phy_driver microchip_t1_phy_driver[] = {
 	{
 		.phy_id         = 0x0007c150,
 		.phy_id_mask    = 0xfffffff0,
 		.name           = "Microchip LAN87xx T1",
+		.flags          = PHY_POLL_CABLE_TEST,
 
 		.features       = PHY_BASIC_T1_FEATURES,
 
@@ -241,6 +478,8 @@ static struct phy_driver microchip_t1_phy_driver[] = {
 
 		.suspend        = genphy_suspend,
 		.resume         = genphy_resume,
+		.cable_test_start = lan87xx_cable_test_start,
+		.cable_test_get_status = lan87xx_cable_test_get_status,
 	}
 };
 
-- 
2.25.1

