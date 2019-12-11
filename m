Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB1E11A957
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 11:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbfLKK4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 05:56:22 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39512 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbfLKK4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 05:56:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZwsTLmYFtAN+Y+XcuKPtlnkG5oUkfo6khvjT5X42Dpk=; b=Z4u5E9zG9DuIAaZ+iIotoKNEzZ
        Ak4+1S4Sohw7sqNM0O7J4TAuUbXi1wDkAnbaALXCI2RRAFKilPihERtcHpyrMJpz9wZInJrwxifD2
        /waGTA5Nw3kzh/ChpLe/l0mJoO2iCgmrRE+05zDYOaey8YD/JiFLRngl3HyQrqDcpvrMMMZi63nWY
        DF4cmAYjnQiQYAv0BeQZcRg5ytQn1XcWsAFTPmPnuon2cZLuBxOwKYQqIymcYkdiA0pvfz7re5SMp
        efXbL4HjaJpzqfigdlVi9/eiYgB+wVfyts7Axa24bX7YvihL2RMgQxIjaVD2vbI6jKMkCdg1JsUk4
        S1BhS+cQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:56732 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iezf4-0007uR-O4; Wed, 11 Dec 2019 10:56:06 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iezf2-0002xs-KW; Wed, 11 Dec 2019 10:56:04 +0000
In-Reply-To: <20191211104821.GB25745@shell.armlinux.org.uk>
References: <20191211104821.GB25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 03/14] net: sfp: add more extended compliance
 codes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iezf2-0002xs-KW@rmk-PC.armlinux.org.uk>
Date:   Wed, 11 Dec 2019 10:56:04 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SFF-8024 is used to define various constants re-used in several SFF
SFP-related specifications.  Split these constants from the enum, and
rename them to indicate that they're defined by SFF-8024.

Add and use updated SFF-8024 extended compliance code definitions for
10GBASE-T, 5GBASE-T and 2.5GBASE-T modules.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp-bus.c | 60 ++++++++++++++++------------
 drivers/net/phy/sfp.c     |  4 +-
 include/linux/sfp.h       | 82 ++++++++++++++++++++++++++-------------
 3 files changed, 93 insertions(+), 53 deletions(-)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 1561962fda30..c6627f1e5d68 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -124,35 +124,35 @@ int sfp_parse_port(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 
 	/* port is the physical connector, set this from the connector field. */
 	switch (id->base.connector) {
-	case SFP_CONNECTOR_SC:
-	case SFP_CONNECTOR_FIBERJACK:
-	case SFP_CONNECTOR_LC:
-	case SFP_CONNECTOR_MT_RJ:
-	case SFP_CONNECTOR_MU:
-	case SFP_CONNECTOR_OPTICAL_PIGTAIL:
+	case SFF8024_CONNECTOR_SC:
+	case SFF8024_CONNECTOR_FIBERJACK:
+	case SFF8024_CONNECTOR_LC:
+	case SFF8024_CONNECTOR_MT_RJ:
+	case SFF8024_CONNECTOR_MU:
+	case SFF8024_CONNECTOR_OPTICAL_PIGTAIL:
+	case SFF8024_CONNECTOR_MPO_1X12:
+	case SFF8024_CONNECTOR_MPO_2X16:
 		port = PORT_FIBRE;
 		break;
 
-	case SFP_CONNECTOR_RJ45:
+	case SFF8024_CONNECTOR_RJ45:
 		port = PORT_TP;
 		break;
 
-	case SFP_CONNECTOR_COPPER_PIGTAIL:
+	case SFF8024_CONNECTOR_COPPER_PIGTAIL:
 		port = PORT_DA;
 		break;
 
-	case SFP_CONNECTOR_UNSPEC:
+	case SFF8024_CONNECTOR_UNSPEC:
 		if (id->base.e1000_base_t) {
 			port = PORT_TP;
 			break;
 		}
 		/* fallthrough */
-	case SFP_CONNECTOR_SG: /* guess */
-	case SFP_CONNECTOR_MPO_1X12:
-	case SFP_CONNECTOR_MPO_2X16:
-	case SFP_CONNECTOR_HSSDC_II:
-	case SFP_CONNECTOR_NOSEPARATE:
-	case SFP_CONNECTOR_MXC_2X16:
+	case SFF8024_CONNECTOR_SG: /* guess */
+	case SFF8024_CONNECTOR_HSSDC_II:
+	case SFF8024_CONNECTOR_NOSEPARATE:
+	case SFF8024_CONNECTOR_MXC_2X16:
 		port = PORT_OTHER;
 		break;
 	default:
@@ -261,22 +261,33 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 	}
 
 	switch (id->base.extended_cc) {
-	case 0x00: /* Unspecified */
+	case SFF8024_ECC_UNSPEC:
 		break;
-	case 0x02: /* 100Gbase-SR4 or 25Gbase-SR */
+	case SFF8024_ECC_100GBASE_SR4_25GBASE_SR:
 		phylink_set(modes, 100000baseSR4_Full);
 		phylink_set(modes, 25000baseSR_Full);
 		break;
-	case 0x03: /* 100Gbase-LR4 or 25Gbase-LR */
-	case 0x04: /* 100Gbase-ER4 or 25Gbase-ER */
+	case SFF8024_ECC_100GBASE_LR4_25GBASE_LR:
+	case SFF8024_ECC_100GBASE_ER4_25GBASE_ER:
 		phylink_set(modes, 100000baseLR4_ER4_Full);
 		break;
-	case 0x0b: /* 100Gbase-CR4 or 25Gbase-CR CA-L */
-	case 0x0c: /* 25Gbase-CR CA-S */
-	case 0x0d: /* 25Gbase-CR CA-N */
+	case SFF8024_ECC_100GBASE_CR4:
 		phylink_set(modes, 100000baseCR4_Full);
+		/* fallthrough */
+	case SFF8024_ECC_25GBASE_CR_S:
+	case SFF8024_ECC_25GBASE_CR_N:
 		phylink_set(modes, 25000baseCR_Full);
 		break;
+	case SFF8024_ECC_10GBASE_T_SFI:
+	case SFF8024_ECC_10GBASE_T_SR:
+		phylink_set(modes, 10000baseT_Full);
+		break;
+	case SFF8024_ECC_5GBASE_T:
+		phylink_set(modes, 5000baseT_Full);
+		break;
+	case SFF8024_ECC_2_5GBASE_T:
+		phylink_set(modes, 2500baseT_Full);
+		break;
 	default:
 		dev_warn(bus->sfp_dev,
 			 "Unknown/unsupported extended compliance code: 0x%02x\n",
@@ -301,7 +312,7 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 	 */
 	if (bitmap_empty(modes, __ETHTOOL_LINK_MODE_MASK_NBITS)) {
 		/* If the encoding and bit rate allows 1000baseX */
-		if (id->base.encoding == SFP_ENCODING_8B10B && br_nom &&
+		if (id->base.encoding == SFF8024_ENCODING_8B10B && br_nom &&
 		    br_min <= 1300 && br_max >= 1200)
 			phylink_set(modes, 1000baseX_Full);
 	}
@@ -332,7 +343,8 @@ phy_interface_t sfp_select_interface(struct sfp_bus *bus,
 	    phylink_test(link_modes, 10000baseSR_Full) ||
 	    phylink_test(link_modes, 10000baseLR_Full) ||
 	    phylink_test(link_modes, 10000baseLRM_Full) ||
-	    phylink_test(link_modes, 10000baseER_Full))
+	    phylink_test(link_modes, 10000baseER_Full) ||
+	    phylink_test(link_modes, 10000baseT_Full))
 		return PHY_INTERFACE_MODE_10GKR;
 
 	if (phylink_test(link_modes, 2500baseX_Full))
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index ae6a52a19458..ad3808307dba 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -242,7 +242,7 @@ struct sfp {
 
 static bool sff_module_supported(const struct sfp_eeprom_id *id)
 {
-	return id->base.phys_id == SFP_PHYS_ID_SFF &&
+	return id->base.phys_id == SFF8024_ID_SFF_8472 &&
 	       id->base.phys_ext_id == SFP_PHYS_EXT_ID_SFP;
 }
 
@@ -253,7 +253,7 @@ static const struct sff_data sff_data = {
 
 static bool sfp_module_supported(const struct sfp_eeprom_id *id)
 {
-	return id->base.phys_id == SFP_PHYS_ID_SFP &&
+	return id->base.phys_id == SFF8024_ID_SFP &&
 	       id->base.phys_ext_id == SFP_PHYS_EXT_ID_SFP;
 }
 
diff --git a/include/linux/sfp.h b/include/linux/sfp.h
index 8d7b98c214d7..373d8b67ea86 100644
--- a/include/linux/sfp.h
+++ b/include/linux/sfp.h
@@ -275,6 +275,61 @@ struct sfp_diag {
 	__be16 cal_v_offset;
 } __packed;
 
+/* SFF8024 defined constants */
+enum {
+	SFF8024_ID_UNK			= 0x00,
+	SFF8024_ID_SFF_8472		= 0x02,
+	SFF8024_ID_SFP			= 0x03,
+	SFF8024_ID_DWDM_SFP		= 0x0b,
+	SFF8024_ID_QSFP_8438		= 0x0c,
+	SFF8024_ID_QSFP_8436_8636	= 0x0d,
+	SFF8024_ID_QSFP28_8636		= 0x11,
+
+	SFF8024_ENCODING_UNSPEC		= 0x00,
+	SFF8024_ENCODING_8B10B		= 0x01,
+	SFF8024_ENCODING_4B5B		= 0x02,
+	SFF8024_ENCODING_NRZ		= 0x03,
+	SFF8024_ENCODING_8472_MANCHESTER= 0x04,
+	SFF8024_ENCODING_8472_SONET	= 0x05,
+	SFF8024_ENCODING_8472_64B66B	= 0x06,
+	SFF8024_ENCODING_8436_MANCHESTER= 0x06,
+	SFF8024_ENCODING_8436_SONET	= 0x04,
+	SFF8024_ENCODING_8436_64B66B	= 0x05,
+	SFF8024_ENCODING_256B257B	= 0x07,
+	SFF8024_ENCODING_PAM4		= 0x08,
+
+	SFF8024_CONNECTOR_UNSPEC	= 0x00,
+	/* codes 01-05 not supportable on SFP, but some modules have single SC */
+	SFF8024_CONNECTOR_SC		= 0x01,
+	SFF8024_CONNECTOR_FIBERJACK	= 0x06,
+	SFF8024_CONNECTOR_LC		= 0x07,
+	SFF8024_CONNECTOR_MT_RJ		= 0x08,
+	SFF8024_CONNECTOR_MU		= 0x09,
+	SFF8024_CONNECTOR_SG		= 0x0a,
+	SFF8024_CONNECTOR_OPTICAL_PIGTAIL= 0x0b,
+	SFF8024_CONNECTOR_MPO_1X12	= 0x0c,
+	SFF8024_CONNECTOR_MPO_2X16	= 0x0d,
+	SFF8024_CONNECTOR_HSSDC_II	= 0x20,
+	SFF8024_CONNECTOR_COPPER_PIGTAIL= 0x21,
+	SFF8024_CONNECTOR_RJ45		= 0x22,
+	SFF8024_CONNECTOR_NOSEPARATE	= 0x23,
+	SFF8024_CONNECTOR_MXC_2X16	= 0x24,
+
+	SFF8024_ECC_UNSPEC		= 0x00,
+	SFF8024_ECC_100G_25GAUI_C2M_AOC	= 0x01,
+	SFF8024_ECC_100GBASE_SR4_25GBASE_SR = 0x02,
+	SFF8024_ECC_100GBASE_LR4_25GBASE_LR = 0x03,
+	SFF8024_ECC_100GBASE_ER4_25GBASE_ER = 0x04,
+	SFF8024_ECC_100GBASE_SR10	= 0x05,
+	SFF8024_ECC_100GBASE_CR4	= 0x0b,
+	SFF8024_ECC_25GBASE_CR_S	= 0x0c,
+	SFF8024_ECC_25GBASE_CR_N	= 0x0d,
+	SFF8024_ECC_10GBASE_T_SFI	= 0x16,
+	SFF8024_ECC_10GBASE_T_SR	= 0x1c,
+	SFF8024_ECC_5GBASE_T		= 0x1d,
+	SFF8024_ECC_2_5GBASE_T		= 0x1e,
+};
+
 /* SFP EEPROM registers */
 enum {
 	SFP_PHYS_ID			= 0x00,
@@ -309,34 +364,7 @@ enum {
 	SFP_SFF8472_COMPLIANCE		= 0x5e,
 	SFP_CC_EXT			= 0x5f,
 
-	SFP_PHYS_ID_SFF			= 0x02,
-	SFP_PHYS_ID_SFP			= 0x03,
 	SFP_PHYS_EXT_ID_SFP		= 0x04,
-	SFP_CONNECTOR_UNSPEC		= 0x00,
-	/* codes 01-05 not supportable on SFP, but some modules have single SC */
-	SFP_CONNECTOR_SC		= 0x01,
-	SFP_CONNECTOR_FIBERJACK		= 0x06,
-	SFP_CONNECTOR_LC		= 0x07,
-	SFP_CONNECTOR_MT_RJ		= 0x08,
-	SFP_CONNECTOR_MU		= 0x09,
-	SFP_CONNECTOR_SG		= 0x0a,
-	SFP_CONNECTOR_OPTICAL_PIGTAIL	= 0x0b,
-	SFP_CONNECTOR_MPO_1X12		= 0x0c,
-	SFP_CONNECTOR_MPO_2X16		= 0x0d,
-	SFP_CONNECTOR_HSSDC_II		= 0x20,
-	SFP_CONNECTOR_COPPER_PIGTAIL	= 0x21,
-	SFP_CONNECTOR_RJ45		= 0x22,
-	SFP_CONNECTOR_NOSEPARATE	= 0x23,
-	SFP_CONNECTOR_MXC_2X16		= 0x24,
-	SFP_ENCODING_UNSPEC		= 0x00,
-	SFP_ENCODING_8B10B		= 0x01,
-	SFP_ENCODING_4B5B		= 0x02,
-	SFP_ENCODING_NRZ		= 0x03,
-	SFP_ENCODING_8472_MANCHESTER	= 0x04,
-	SFP_ENCODING_8472_SONET		= 0x05,
-	SFP_ENCODING_8472_64B66B	= 0x06,
-	SFP_ENCODING_256B257B		= 0x07,
-	SFP_ENCODING_PAM4		= 0x08,
 	SFP_OPTIONS_HIGH_POWER_LEVEL	= BIT(13),
 	SFP_OPTIONS_PAGING_A2		= BIT(12),
 	SFP_OPTIONS_RETIMER		= BIT(11),
-- 
2.20.1

