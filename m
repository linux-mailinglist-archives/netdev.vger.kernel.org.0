Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3519FF5F94
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 15:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfKIOnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 09:43:23 -0500
Received: from mail-wm1-f49.google.com ([209.85.128.49]:37056 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfKIOnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 09:43:22 -0500
Received: by mail-wm1-f49.google.com with SMTP id b17so771633wmj.2
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 06:43:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BqvPYixLuCSghtXn9RyMIwLfFMPwbW4QIY3dteX6qGg=;
        b=HuES5BmBYfX//Pc6QPxo0gRymnYSkL0X9OFBv15vVOYlegM+plLuNtn15MO6Y+V1S+
         +gXiQtaWSKDmtKZtvRQNo91h7Qt1jM8tRA001x5CRoJ1M26j6W+wqY6yDbpYFNH0XQ6y
         oqjS5k6+jOSpGrM/5uOepDswY9JExgD5m0kFdNcRMnUdgoXUl/z7RGIIpaB6vFeYIBsJ
         OXLEevo5QOQIQisa2hQ5w9I5PJHUbwUNA0AZy/2Aoom/YExL/BSSH+x2f/WiHXgmk/5Z
         Cjd1aGfTqDwQvI8/3nfoObk75bduHtMtFDjRdTmNFcITy2mnDCyTGJpm2PvdiMz6Yges
         3QQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BqvPYixLuCSghtXn9RyMIwLfFMPwbW4QIY3dteX6qGg=;
        b=jqoWGtf4yrJrrfaVKRw+sRt3uef00ivsSum20L9wblL7zntr1kjmCPP3OfFt6sdor9
         4bpUa/lCjqrIEJIGmLO3qsP+ViBBXEqqNl+OERGh+rEg7z/c20HmiJPYh5gIgNQG1QXG
         sxyN+a0msfF+FktClZ81ok0xn841LmRRL330+GDVHXI2FicERx0JJzZ++lrd9tzdgkuf
         Yc/U7o84ikUSuKxPMfEfcEoF/Mg6xRIlRs/za7/JQi8cr6MEeZPMtGWbwQEE9mYh0IVB
         NEbhZjMxpUFr9+yH210XGEsqzsST+qHU8rFTYIN4MzrnhQlkH8MRAxchFBQLQdVOaG34
         iqHA==
X-Gm-Message-State: APjAAAU5MSJRzF6TUMZYaKLobaqVrr2PbTXkWs0/qe3aO6Qsa+MoPWs9
        q1ShNKCpZwo9/VU1ja1HZNGMNAG4aDQ=
X-Google-Smtp-Source: APXvYqzRc6KU+RUvm3F/9L/Go/Wlaw84pZnOs+wduK6in+MMUGGgMaKwe1X3xgy6agiurbF14oP3Zg==
X-Received: by 2002:a7b:c4c7:: with SMTP id g7mr6533322wmk.144.1573310595481;
        Sat, 09 Nov 2019 06:43:15 -0800 (PST)
Received: from localhost.localdomain ([185.85.187.123])
        by smtp.googlemail.com with ESMTPSA id y19sm13202794wmd.29.2019.11.09.06.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 06:43:14 -0800 (PST)
From:   Adrian Pop <popadrian1996@gmail.com>
Cc:     netdev@vger.kernel.org, linville@tuxdriver.com,
        Adrian Pop <popadrian1996@gmail.com>
Subject: [PATCH] ethtool: Add QSFP-DD support
Date:   Sat,  9 Nov 2019 14:42:05 +0200
Message-Id: <20191109124205.11273-1-popadrian1996@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Common Management Interface Specification (CMIS) for QSFP-DD shares
some similarities with other form factors such as QSFP or SFP, but due to
the fact that the module memory map is different, the current ethtool
version is not able to provide relevant information about an interface.

This patch adds QSFP-DD support to ethtool. The changes are similar to
the ones already existing in qsfp.c, but customized to use the memory
addresses and logic as defined in the specifications document.

Page 0x00 (lower and higher memory) are always implemented, so the ethtool
expects at least 256 bytes if the identifier matches the one for QSFP-DD.
For optical connected cables, additional pages are usually available (the
contain module defined  thresholds or lane diagnostic information). In
this case, ethtool expects to receive 768 bytes in the following format:

    +----------+----------+----------+----------+----------+----------+
    |   Page   |   Page   |   Page   |   Page   |   Page   |   Page   |
    |   0x00   |   0x00   |   0x01   |   0x02   |   0x10   |   0x11   |
    |  (lower) | (higher) | (higher) | (higher) | (higher) | (higher) |
    |   128B   |   128B   |   128B   |   128B   |   128B   |   128B   |
    +----------+----------+----------+----------+----------+----------

Several functions from qsfp.c could be reused, so an additional parameter
was added to each and the functions were moved to sff-common.c.

Signed-off-by: Adrian Pop <popadrian1996@gmail.com>
---
 Makefile.am  |   3 +-
 qsfp-dd.c    | 560 +++++++++++++++++++++++++++++++++++++++++++++++++++
 qsfp-dd.h    | 236 ++++++++++++++++++++++
 qsfp.c       |  60 ++----
 qsfp.h       |   8 -
 sff-common.c |  52 +++++
 sff-common.h |  26 ++-
 7 files changed, 891 insertions(+), 54 deletions(-)
 create mode 100644 qsfp-dd.c
 create mode 100644 qsfp-dd.h

diff --git a/Makefile.am b/Makefile.am
index 3af4d4c..cb48bd9 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -14,7 +14,8 @@ ethtool_SOURCES += \
 		  pcnet32.c realtek.c tg3.c marvell.c vioc.c	\
 		  smsc911x.c at76c50x-usb.c sfc.c stmmac.c	\
 		  sff-common.c sff-common.h sfpid.c sfpdiag.c	\
-		  ixgbevf.c tse.c vmxnet3.c qsfp.c qsfp.h fjes.c lan78xx.c
+		  ixgbevf.c tse.c vmxnet3.c qsfp.c qsfp.h fjes.c lan78xx.c \
+		  qsfp-dd.c qsfp-dd.h
 endif
 
 if ENABLE_BASH_COMPLETION
diff --git a/qsfp-dd.c b/qsfp-dd.c
new file mode 100644
index 0000000..be84647
--- /dev/null
+++ b/qsfp-dd.c
@@ -0,0 +1,560 @@
+/**
+ * Description:
+ *
+ * This module adds QSFP-DD support to ethtool. The changes are similar to
+ * the ones already existing in qsfp.c, but customized to use the memory
+ * addresses and logic as defined in the specification's document.
+ *
+ * Page 0x00 (lower and higher memory) are always implemented, so the ethtool
+ * expects at least 256 bytes if the identifier matches the one for QSFP-DD.
+ * For optical connected cables, additional pages are usually available (they
+ * contain module defined thresholds or lane diagnostic information). In
+ * this case, ethtool expects to receive 768 bytes in the following format:
+ *
+ *     +----------+----------+----------+----------+----------+----------+
+ *     |   Page   |   Page   |   Page   |   Page   |   Page   |   Page   |
+ *     |   0x00   |   0x00   |   0x01   |   0x02   |   0x10   |   0x11   |
+ *     |  (lower) | (higher) | (higher) | (higher) | (higher) | (higher) |
+ *     |   128b   |   128b   |   128b   |   128b   |   128b   |   128b   |
+ *     +----------+----------+----------+----------+----------+----------+
+ */
+
+#include <stdio.h>
+#include <math.h>
+#include "internal.h"
+#include "sff-common.h"
+#include "qsfp-dd.h"
+
+static void qsfp_dd_show_identifier(const __u8 *id)
+{
+	sff8024_show_identifier(id, QSFP_DD_ID_OFFSET);
+}
+
+static void qsfp_dd_show_connector(const __u8 *id)
+{
+	sff8024_show_connector(id, QSFP_DD_CTOR_OFFSET);
+}
+
+static void qsfp_dd_show_oui(const __u8 *id)
+{
+	sff8024_show_oui(id, QSFP_DD_VENDOR_OUI_OFFSET);
+}
+
+/**
+ * Print the revision compliance. Relevant documents:
+ * [1] CMIS Rev. 3, pag. 45, section 1.7.2.1, Table 18
+ * [2] CMIS Rev. 4, pag. 81, section 8.2.1, Table 8-2
+ */
+static void qsfp_dd_show_rev_compliance(const __u8 *id)
+{
+	__u8 rev = id[QSFP_DD_REV_COMPLIANCE_OFFSET];
+	int major = (rev >> 4) & 0x0F;
+	int minor = rev & 0x0F;
+
+	printf("\t%-41s : Rev. %d.%d\n", "Revision compliance", major, minor);
+}
+
+/**
+ * Print information about the device's power consumption.
+ * Relevant documents:
+ * [1] CMIS Rev. 3, pag. 59, section 1.7.3.9, Table 30
+ * [2] CMIS Rev. 4, pag. 94, section 8.3.9, Table 8-18
+ * [3] QSFP-DD Hardware Rev 5.0, pag. 22, section 4.2.1
+ */
+static void qsfp_dd_show_power_info(const __u8 *id)
+{
+	float max_power = 0.0f;
+	__u8 base_power = 0;
+	__u8 power_class;
+
+	/* Get the power class (first 3 most significat bytes) */
+	power_class = (id[QSFP_DD_PWR_CLASS_OFFSET] >> 5) & 0x07;
+
+	/* Get the base power in multiples of 0.25W */
+	base_power = id[QSFP_DD_PWR_MAX_POWER_OFFSET];
+	max_power = base_power * 0.25f;
+
+	printf("\t%-41s : %d\n", "Power class", power_class + 1);
+	printf("\t%-41s : %.02fW\n", "Max power", max_power);
+}
+
+/**
+ * Print the cable assembly length, for both passive copper and active
+ * optical or electrical cables. The base length (bits 5-0) must be
+ * multiplied with the SMF length multiplier (bits 7-6) to obtain the
+ * correct value. Relevant documents:
+ * [1] CMIS Rev. 3, pag. 59, section 1.7.3.10, Table 31
+ * [2] CMIS Rev. 4, pag. 94, section 8.3.10, Table 8-19
+ */
+static void qsfp_dd_show_cbl_asm_len(const __u8 *id)
+{
+	static const char *fn = "Cable assembly length";
+	float mul = 1.0f;
+	float val = 0.0f;
+
+	/* Check if max length */
+	if (id[QSFP_DD_CBL_ASM_LEN_OFFSET] == QSFP_DD_6300M_MAX_LEN) {
+		printf("\t%-41s : > 6.3km\n", fn);
+		return;
+	}
+
+	/* Get the multiplier from the first two bits */
+	switch (id[QSFP_DD_CBL_ASM_LEN_OFFSET] & QSFP_DD_LEN_MUL_MASK) {
+	case QSFP_DD_MULTIPLIER_00:
+		mul = 0.1f;
+		break;
+	case QSFP_DD_MULTIPLIER_01:
+		mul = 1.0f;
+		break;
+	case QSFP_DD_MULTIPLIER_10:
+		mul = 10.0f;
+		break;
+	case QSFP_DD_MULTIPLIER_11:
+		mul = 100.0f;
+		break;
+	default:
+		break;
+	}
+
+	/* Get base value from first 6 bits and multiply by mul */
+	val = (id[QSFP_DD_CBL_ASM_LEN_OFFSET] & QSFP_DD_LEN_VAL_MASK);
+	val = (float)val * mul;
+	printf("\t%-41s : %0.2fkm\n", fn, val);
+}
+
+/**
+ * Print the length for SMF fiber. The base length (bits 5-0) must be
+ * multiplied with the SMF length multiplier (bits 7-6) to obtain the
+ * correct value. Relevant documents:
+ * [1] CMIS Rev. 3, pag. 63, section 1.7.4.2, Table 39
+ * [2] CMIS Rev. 4, pag. 99, section 8.4.2, Table 8-27
+ */
+static void qsfp_dd_print_smf_cbl_len(const __u8 *id)
+{
+	static const char *fn = "Length (SMF)";
+	float mul = 1.0f;
+	float val = 0.0f;
+
+	/* Get the multiplier from the first two bits */
+	switch (id[QSFP_DD_SMF_LEN_OFFSET] & QSFP_DD_LEN_MUL_MASK) {
+	case QSFP_DD_MULTIPLIER_00:
+		mul = 0.1f;
+		break;
+	case QSFP_DD_MULTIPLIER_01:
+		mul = 1.0f;
+		break;
+	default:
+		break;
+	}
+
+	/* Get base value from first 6 bits and multiply by mul */
+	val = (id[QSFP_DD_SMF_LEN_OFFSET] & QSFP_DD_LEN_VAL_MASK);
+	val = (float)val * mul;
+	printf("\t%-41s : %0.2fkm\n", fn, val);
+}
+
+/**
+ * Print relevant signal integrity control properties. Relevant documents:
+ * [1] CMIS Rev. 3, pag. 71, section 1.7.4.10, Table 46
+ * [2] CMIS Rev. 4, pag. 105, section 8.4.10, Table 8-34
+ */
+static void qsfp_dd_show_sig_integrity(const __u8 *id)
+{
+	/* CDR Bypass control: 2nd bit from each byte */
+	printf("\t%-41s : ", "Tx CDR bypass control");
+	printf("%s\n", YESNO(id[QSFP_DD_SIG_INTEG_TX_OFFSET] & 0x02));
+
+	printf("\t%-41s : ", "Rx CDR bypass control");
+	printf("%s\n", YESNO(id[QSFP_DD_SIG_INTEG_RX_OFFSET] & 0x02));
+
+	/* CDR Implementation: 1st bit from each byte */
+	printf("\t%-41s : ", "Tx CDR");
+	printf("%s\n", YESNO(id[QSFP_DD_SIG_INTEG_TX_OFFSET] & 0x01));
+
+	printf("\t%-41s : ", "Rx CDR");
+	printf("%s\n", YESNO(id[QSFP_DD_SIG_INTEG_RX_OFFSET] & 0x01));
+}
+
+/**
+ * Print relevant media interface technology info. Relevant documents:
+ * [1] CMIS Rev. 3
+ * --> pag. 61, section 1.7.3.14, Table 36
+ * --> pag. 64, section 1.7.4.3, 1.7.4.4
+ * [2] CMIS Rev. 4
+ * --> pag. 97, section 8.3.14, Table 8-24
+ * --> pag. 98, section 8.4, Table 8-25
+ * --> page 100, section 8.4.3, 8.4.4
+ */
+static void qsfp_dd_show_mit_compliance(const __u8 *id)
+{
+	static const char *cc = " (Copper cable,";
+
+	printf("\t%-41s : 0x%02x", "Transmitter technology",
+	       id[QSFP_DD_MEDIA_INTF_TECH_OFFSET]);
+
+	switch (id[QSFP_DD_MEDIA_INTF_TECH_OFFSET]) {
+	case QSFP_DD_850_VCSEL:
+		printf(" (850 nm VCSEL)\n");
+		break;
+	case QSFP_DD_1310_VCSEL:
+		printf(" (1310 nm VCSEL)\n");
+		break;
+	case QSFP_DD_1550_VCSEL:
+		printf(" (1550 nm VCSEL)\n");
+		break;
+	case QSFP_DD_1310_FP:
+		printf(" (1310 nm FP)\n");
+		break;
+	case QSFP_DD_1310_DFB:
+		printf(" (1310 nm DFB)\n");
+		break;
+	case QSFP_DD_1550_DFB:
+		printf(" (1550 nm DFB)\n");
+		break;
+	case QSFP_DD_1310_EML:
+		printf(" (1310 nm EML)\n");
+		break;
+	case QSFP_DD_1550_EML:
+		printf(" (1550 nm EML)\n");
+		break;
+	case QSFP_DD_OTHERS:
+		printf(" (Others/Undefined)\n");
+		break;
+	case QSFP_DD_1490_DFB:
+		printf(" (1490 nm DFB)\n");
+		break;
+	case QSFP_DD_COPPER_UNEQUAL:
+		printf("%s unequalized)\n", cc);
+		break;
+	case QSFP_DD_COPPER_PASS_EQUAL:
+		printf("%s passive equalized)\n", cc);
+		break;
+	case QSFP_DD_COPPER_NF_EQUAL:
+		printf("%s near and far end limiting active equalizers)\n", cc);
+		break;
+	case QSFP_DD_COPPER_F_EQUAL:
+		printf("%s far end limiting active equalizers)\n", cc);
+		break;
+	case QSFP_DD_COPPER_N_EQUAL:
+		printf("%s near end limiting active equalizers)\n", cc);
+		break;
+	case QSFP_DD_COPPER_LINEAR_EQUAL:
+		printf("%s linear active equalizers)\n", cc);
+		break;
+	}
+
+	if (id[QSFP_DD_MEDIA_INTF_TECH_OFFSET] >= QSFP_DD_COPPER_UNEQUAL) {
+		printf("\t%-41s : %udb\n", "Attenuation at 5GHz",
+		       id[QSFP_DD_COPPER_ATT_5GHZ]);
+		printf("\t%-41s : %udb\n", "Attenuation at 7GHz",
+		       id[QSFP_DD_COPPER_ATT_7GHZ]);
+		printf("\t%-41s : %udb\n", "Attenuation at 12.9GHz",
+		       id[QSFP_DD_COPPER_ATT_12P9GHZ]);
+		printf("\t%-41s : %udb\n", "Attenuation at 25.8GHz",
+		       id[QSFP_DD_COPPER_ATT_25P8GHZ]);
+	} else {
+		printf("\t%-41s : %.3lfnm\n", "Laser wavelength",
+		       (((id[QSFP_DD_NOM_WAVELENGTH_MSB] << 8) |
+				id[QSFP_DD_NOM_WAVELENGTH_LSB]) * 0.05));
+		printf("\t%-41s : %.3lfnm\n", "Laser wavelength tolerance",
+		       (((id[QSFP_DD_WAVELENGTH_TOL_MSB] << 8) |
+		       id[QSFP_DD_WAVELENGTH_TOL_LSB]) * 0.005));
+	}
+}
+
+/**
+ * Read the high/low alarms or warnings for a specific channel. This
+ * information is found in the i'th bit of each byte associated with
+ * one of the aforementioned properties. A value greater than zero
+ * means the alarm/warning is turned on.
+ * The values are stored in the qsfp_dd_diags structure, in the rxaw
+ * or txaw array (each element corresponds to an alarm/warning).
+ */
+static void qsfp_dd_read_aw_for_channel(const __u8 *id, int ch, int mode,
+					struct qsfp_dd_diags * const sd)
+{
+	__u8 cmsk = (1 << ch);
+
+	if (mode == QSFP_DD_READ_TX) {
+		sd->txaw[ch][HA] = id[QSFP_DD_TX_HA_OFFSET] & cmsk;
+		sd->txaw[ch][LA] = id[QSFP_DD_TX_LA_OFFSET] & cmsk;
+		sd->txaw[ch][HW] = id[QSFP_DD_TX_HW_OFFSET] & cmsk;
+		sd->txaw[ch][LW] = id[QSFP_DD_TX_LW_OFFSET] & cmsk;
+	} else {
+		sd->rxaw[ch][HA] = id[QSFP_DD_RX_HA_OFFSET] & cmsk;
+		sd->rxaw[ch][LA] = id[QSFP_DD_RX_LA_OFFSET] & cmsk;
+		sd->rxaw[ch][HW] = id[QSFP_DD_RX_HW_OFFSET] & cmsk;
+		sd->rxaw[ch][LW] = id[QSFP_DD_RX_LW_OFFSET] & cmsk;
+	}
+}
+
+/*
+ * 2-byte internal temperature conversions:
+ * First byte is a signed 8-bit integer, which is the temp decimal part
+ * Second byte are 1/256th of degree, which are added to the dec part.
+ */
+#define OFFSET_TO_TEMP(offset) ((__s16)OFFSET_TO_U16(offset))
+
+/**
+ * Get and parse relevant diagnostic information for the current module.
+ * These are stored, for every channel, in a qsfp_dd_diags structure.
+ */
+static void
+qsfp_dd_parse_diagnostics(const __u8 *id, struct qsfp_dd_diags *const sd)
+{
+	__u16 rx_power_offset;
+	__u16 tx_power_offset;
+	__u16 tx_bias_offset;
+	__u16 temp_offset;
+	__u16 volt_offset;
+	int i;
+
+	for (i = 0; i < QSFP_DD_MAX_CHANNELS; ++i) {
+		/*
+		 * Add Tx/Rx output/input optical power relevant information.
+		 * To access the info for the ith lane, we have to skip i * 2
+		 * bytes starting from the offset of the first lane for that
+		 * specific channel property.
+		 */
+		tx_bias_offset = QSFP_DD_TX_BIAS_START_OFFSET + (i << 1);
+		rx_power_offset = QSFP_DD_RX_PWR_START_OFFSET + (i << 1);
+		tx_power_offset = QSFP_DD_TX_PWR_START_OFFSET + (i << 1);
+
+		sd->scd[i].bias_cur = OFFSET_TO_U16(tx_bias_offset);
+		sd->scd[i].rx_power = OFFSET_TO_U16(rx_power_offset);
+		sd->scd[i].tx_power = OFFSET_TO_U16(tx_power_offset);
+
+		/* Add alarms/warnings related info */
+		qsfp_dd_read_aw_for_channel(id, i, QSFP_DD_READ_TX, sd);
+		qsfp_dd_read_aw_for_channel(id, i, QSFP_DD_READ_RX, sd);
+	}
+
+	/**
+	 * Gather Module-Level Monitor Thresholds and Lane-specific Monitor
+	 * Thresholds. These values are stored in two bytes (MSB, LSB) in
+	 * the following order: HA, LA, HW, LW, thus we only need the start
+	 * offset for each property.
+	 */
+	for (i = 0; i < 4; ++i) {
+		tx_power_offset = QSFP_DD_TXPW_THRS_START_OFFSET + (i << 1);
+		sd->tx_power[i] = OFFSET_TO_U16(tx_power_offset);
+
+		rx_power_offset = QSFP_DD_RXPW_THRS_START_OFFSET + (i << 1);
+		sd->rx_power[i] = OFFSET_TO_U16(rx_power_offset);
+
+		tx_bias_offset = QSFP_DD_TXBI_THRS_START_OFFSET + (i << 1);
+		sd->bias_cur[i] = OFFSET_TO_U16(tx_bias_offset);
+
+		temp_offset = QSFP_DD_TEMP_THRS_START_OFFSET + (i << 1);
+		sd->sfp_temp[i] = OFFSET_TO_TEMP(temp_offset);
+
+		volt_offset = QSFP_DD_VOLT_THRS_START_OFFSET + (i << 1);
+		sd->sfp_voltage[i] = OFFSET_TO_U16(volt_offset);
+	}
+}
+
+/**
+ * Print the Module-Level Monitor Thresholds and the Lane-specific
+ * Monitor Thresholds. This is the same function as the one in the
+ * sff-common.c file, but is using a struct qsfp_dd_diags as a pa-
+ * rameter.
+ */
+static void qsfp_dd_show_thresholds(const struct qsfp_dd_diags sd)
+{
+	PRINT_BIAS("Laser bias current high alarm threshold",
+		   sd.bias_cur[HA]);
+	PRINT_BIAS("Laser bias current low alarm threshold",
+		   sd.bias_cur[LA]);
+	PRINT_BIAS("Laser bias current high warning threshold",
+		   sd.bias_cur[HW]);
+	PRINT_BIAS("Laser bias current low warning threshold",
+		   sd.bias_cur[LW]);
+
+	PRINT_xX_PWR("Laser output power high alarm threshold",
+		     sd.tx_power[HA]);
+	PRINT_xX_PWR("Laser output power low alarm threshold",
+		     sd.tx_power[LA]);
+	PRINT_xX_PWR("Laser output power high warning threshold",
+		     sd.tx_power[HW]);
+	PRINT_xX_PWR("Laser output power low warning threshold",
+		     sd.tx_power[LW]);
+
+	PRINT_TEMP("Module temperature high alarm threshold",
+		   sd.sfp_temp[HA]);
+	PRINT_TEMP("Module temperature low alarm threshold",
+		   sd.sfp_temp[LA]);
+	PRINT_TEMP("Module temperature high warning threshold",
+		   sd.sfp_temp[HW]);
+	PRINT_TEMP("Module temperature low warning threshold",
+		   sd.sfp_temp[LW]);
+
+	PRINT_VCC("Module voltage high alarm threshold",
+		  sd.sfp_voltage[HA]);
+	PRINT_VCC("Module voltage low alarm threshold",
+		  sd.sfp_voltage[LA]);
+	PRINT_VCC("Module voltage high warning threshold",
+		  sd.sfp_voltage[HW]);
+	PRINT_VCC("Module voltage low warning threshold",
+		  sd.sfp_voltage[LW]);
+
+	PRINT_xX_PWR("Laser rx power high alarm threshold",
+		     sd.rx_power[HA]);
+	PRINT_xX_PWR("Laser rx power low alarm threshold",
+		     sd.rx_power[LA]);
+	PRINT_xX_PWR("Laser rx power high warning threshold",
+		     sd.rx_power[HW]);
+	PRINT_xX_PWR("Laser rx power low warning threshold",
+		     sd.rx_power[LW]);
+}
+
+/**
+ * Print relevant lane specific monitor information for each of
+ * the 8 available channels. Relevant documents:
+ * [1] CMIS Rev. 3:
+ * --> pag. 50, section 1.7.2.4, Table 22
+ * --> pag. 53, section 1.7.2.7, Table 26
+ * --> pag. 76, section 1.7.5.1, Table 50
+ * --> pag. 78, section 1.7.5.2, Table 51
+ * --> pag. 98, section 1.7.7.2, Table 67
+ *
+ * [2] CMIS Rev. 4:
+ * --> pag. 84, section 8.2.4, Table 8-6
+ * --> pag. 89, section 8.2.9, Table 8-12
+ * --> pag. 112, section 8.5.1/2, Table 8-41/42
+ * --> pag. 137, section 8.8.2, Table 8-60/61
+ * --> pag. 140, section 8.8.3, Table 8-62
+ */
+static void qsfp_dd_show_sig_optical_pwr(const __u8 *id, __u32 eeprom_len)
+{
+	static const char * const aw_strings[] = {
+		"%s power high alarm   (Channel %d)",
+		"%s power low alarm    (Channel %d)",
+		"%s power high warning (Channel %d)",
+		"%s power low warning  (Channel %d)"
+	};
+	__u8 module_type = id[QSFP_DD_MODULE_TYPE_OFFSET];
+	char field_desc[QSFP_DD_MAX_DESC_SIZE];
+	struct qsfp_dd_diags sd = { { 0 } };
+	const char *cs = "%s (Channel %d)";
+	int i, j;
+
+	/* Print current temperature & voltage */
+	PRINT_TEMP("Module temperature",
+		   OFFSET_TO_TEMP(QSFP_DD_CURR_TEMP_OFFSET));
+	PRINT_VCC("Module voltage",
+		  OFFSET_TO_U16(QSFP_DD_CURR_CURR_OFFSET));
+
+	/**
+	 * The thresholds and the high/low alarms/warnings are available
+	 * only if an optical interface (MMF/SMF) is present (if this is
+	 * the case, it means that 5 pages are available).
+	 */
+	if (module_type != QSFP_DD_MT_MMF &&
+	    module_type != QSFP_DD_MT_SMF &&
+	    eeprom_len != QSFP_DD_EEPROM_5PAG)
+		return;
+
+	/* Extract the diagnostic variables */
+	qsfp_dd_parse_diagnostics(id, &sd);
+
+	/* Print Tx bias current monitor values */
+	for (i = 0; i < QSFP_DD_MAX_CHANNELS; ++i) {
+		snprintf(field_desc, QSFP_DD_MAX_DESC_SIZE, cs,
+			 "Tx bias current monitor", i + 1);
+		PRINT_BIAS(field_desc, sd.scd[i].bias_cur);
+	}
+
+	/* Print Tx output optical power values */
+	for (i = 0; i < QSFP_DD_MAX_CHANNELS; ++i) {
+		snprintf(field_desc, QSFP_DD_MAX_DESC_SIZE, cs,
+			 "Tx output optical power", i + 1);
+		PRINT_xX_PWR(field_desc, sd.scd[i].tx_power);
+	}
+
+	/* Print Rx output optical power values */
+	for (i = 0; i < QSFP_DD_MAX_CHANNELS; ++i) {
+		snprintf(field_desc, QSFP_DD_MAX_DESC_SIZE, cs,
+			 "Rx input optical power", i + 1);
+		PRINT_xX_PWR(field_desc, sd.scd[i].rx_power);
+	}
+
+	/* Print the Rx alarms/warnings for each channel */
+	for (i = 0; i < QSFP_DD_MAX_CHANNELS; ++i) {
+		for (j = 0; j < 4; ++j) {
+			snprintf(field_desc, QSFP_DD_MAX_DESC_SIZE,
+				 aw_strings[j], "Rx", i + 1);
+			printf("\t%-41s : %s\n", field_desc,
+			       ONOFF(sd.rxaw[i][j]));
+		}
+	}
+
+	/* Print the Tx alarms/warnings for each channel */
+	for (i = 0; i < QSFP_DD_MAX_CHANNELS; ++i) {
+		for (j = 0; j < 4; ++j) {
+			snprintf(field_desc, QSFP_DD_MAX_DESC_SIZE,
+				 aw_strings[j], "Tx", i + 1);
+			printf("\t%-41s : %s\n", field_desc,
+			       ONOFF(sd.rxaw[i][j]));
+		}
+	}
+
+	qsfp_dd_show_thresholds(sd);
+}
+
+/**
+ * Print relevant info about the maximum supported fiber media length
+ * for each type of fiber media at the maximum module-supported bit rate.
+ * Relevant documents:
+ * [1] CMIS Rev. 3, page 64, section 1.7.4.2, Table 39
+ * [2] CMIS Rev. 4, page 99, section 8.4.2, Table 8-27
+ */
+static void qsfp_dd_show_link_len(const __u8 *id)
+{
+	qsfp_dd_print_smf_cbl_len(id);
+	sff_show_value_with_unit(id, QSFP_DD_OM5_LEN_OFFSET,
+				 "Length (OM5)", 2, "m");
+	sff_show_value_with_unit(id, QSFP_DD_OM4_LEN_OFFSET,
+				 "Length (OM4)", 2, "m");
+	sff_show_value_with_unit(id, QSFP_DD_OM3_LEN_OFFSET,
+				 "Length (OM3 50/125um)", 2, "m");
+	sff_show_value_with_unit(id, QSFP_DD_OM2_LEN_OFFSET,
+				 "Length (OM2 50/125um)", 1, "m");
+}
+
+/**
+ * Show relevant information about the vendor. Relevant documents:
+ * [1] CMIS Rev. 3, page 56, section 1.7.3, Table 27
+ * [2] CMIS Rev. 4, page 91, section 8.2, Table 8-15
+ */
+static void qsfp_dd_show_vendor_info(const __u8 *id)
+{
+	sff_show_ascii(id, QSFP_DD_VENDOR_NAME_START_OFFSET,
+		       QSFP_DD_VENDOR_NAME_END_OFFSET, "Vendor name");
+	qsfp_dd_show_oui(id);
+	sff_show_ascii(id, QSFP_DD_VENDOR_PN_START_OFFSET,
+		       QSFP_DD_VENDOR_PN_END_OFFSET, "Vendor PN");
+	sff_show_ascii(id, QSFP_DD_VENDOR_REV_START_OFFSET,
+		       QSFP_DD_VENDOR_REV_END_OFFSET, "Vendor rev");
+	sff_show_ascii(id, QSFP_DD_VENDOR_SN_START_OFFSET,
+		       QSFP_DD_VENDOR_SN_END_OFFSET, "Vendor SN");
+	sff_show_ascii(id, QSFP_DD_DATE_YEAR_OFFSET,
+		       QSFP_DD_DATE_VENDOR_LOT_OFFSET + 1, "Date code");
+
+	if (id[QSFP_DD_CLEI_PRESENT_BYTE] & QSFP_DD_CLEI_PRESENT_MASK)
+		sff_show_ascii(id, QSFP_DD_CLEI_START_OFFSET,
+			       QSFP_DD_CLEI_END_OFFSET, "CLEI code");
+}
+
+void qsfp_dd_show_all(const __u8 *id, __u32 eeprom_len)
+{
+	qsfp_dd_show_identifier(id);
+	qsfp_dd_show_power_info(id);
+	qsfp_dd_show_connector(id);
+	qsfp_dd_show_cbl_asm_len(id);
+	qsfp_dd_show_sig_integrity(id);
+	qsfp_dd_show_mit_compliance(id);
+	qsfp_dd_show_sig_optical_pwr(id, eeprom_len);
+	qsfp_dd_show_link_len(id);
+	qsfp_dd_show_vendor_info(id);
+	qsfp_dd_show_rev_compliance(id);
+}
diff --git a/qsfp-dd.h b/qsfp-dd.h
new file mode 100644
index 0000000..a530b2e
--- /dev/null
+++ b/qsfp-dd.h
@@ -0,0 +1,236 @@
+#ifndef QSFP_DD_H__
+#define QSFP_DD_H__
+
+#define QSFP_DD_PAG_SIZE			0x80
+#define QSFP_DD_EEPROM_5PAG			(0x80 * 6)
+#define QSFP_DD_MAX_CHANNELS			0x08
+#define QSFP_DD_MAX_DESC_SIZE			0x2A
+#define QSFP_DD_READ_TX				0x00
+#define QSFP_DD_READ_RX				0x01
+
+/* Struct for the current/power of a channel */
+struct qsfp_dd_channel_diags {
+	__u16 bias_cur;
+	__u16 rx_power;
+	__u16 tx_power;
+};
+
+struct qsfp_dd_diags {
+	/* Voltage in 0.1mV units; the first 4 elements represent
+	 * the high/low alarm, high/low warning and the last one
+	 * represent the current voltage of the module.
+	 */
+	__u16 sfp_voltage[4];
+
+	/**
+	 * Temperature in 16-bit signed 1/256 Celsius; the first 4
+	 * elements represent the high/low alarm, high/low warning
+	 * and the last one represent the current temp of the module.
+	 */
+	__s16 sfp_temp[4];
+
+	/* Tx bias current in 2uA units */
+	__u16 bias_cur[4];
+
+	/* Measured TX Power */
+	__u16 tx_power[4];
+
+	/* Measured RX Power */
+	__u16 rx_power[4];
+
+	/* Rx alarms and warnings */
+	bool rxaw[QSFP_DD_MAX_CHANNELS][4];
+
+	/* Tx alarms and warnings */
+	bool txaw[QSFP_DD_MAX_CHANNELS][4];
+
+	struct qsfp_dd_channel_diags scd[QSFP_DD_MAX_CHANNELS];
+};
+
+#define HA					0
+#define LA					1
+#define HW					2
+#define LW					3
+
+/* Identifier and revision compliance (Page 0) */
+#define	QSFP_DD_ID_OFFSET			0x00
+#define QSFP_DD_REV_COMPLIANCE_OFFSET		0x01
+
+#define QSFP_DD_MODULE_TYPE_OFFSET		0x55
+#define QSFP_DD_MT_MMF				0x01
+#define QSFP_DD_MT_SMF				0x02
+
+/* Module-Level Monitors (Page 0) */
+#define QSFP_DD_CURR_TEMP_OFFSET		0x0E
+#define QSFP_DD_CURR_CURR_OFFSET		0x10
+
+#define QSFP_DD_CTOR_OFFSET			0xCB
+
+/* Vendor related information (Page 0) */
+#define QSFP_DD_VENDOR_NAME_START_OFFSET	0x81
+#define QSFP_DD_VENDOR_NAME_END_OFFSET		0x90
+
+#define QSFP_DD_VENDOR_OUI_OFFSET		0x91
+
+#define QSFP_DD_VENDOR_PN_START_OFFSET		0x94
+#define QSFP_DD_VENDOR_PN_END_OFFSET		0xA3
+
+#define QSFP_DD_VENDOR_REV_START_OFFSET		0xA4
+#define QSFP_DD_VENDOR_REV_END_OFFSET		0xA5
+
+#define QSFP_DD_VENDOR_SN_START_OFFSET		0xA6
+#define QSFP_DD_VENDOR_SN_END_OFFSET		0xB5
+
+#define QSFP_DD_DATE_YEAR_OFFSET		0xB6
+#define QSFP_DD_DATE_VENDOR_LOT_OFFSET		0xBD
+
+/* CLEI Code (Page 0) */
+#define QSFP_DD_CLEI_PRESENT_BYTE		0x02
+#define QSFP_DD_CLEI_PRESENT_MASK		0x20
+#define QSFP_DD_CLEI_START_OFFSET		0xBE
+#define QSFP_DD_CLEI_END_OFFSET			0xC7
+
+/* Cable assembly length */
+#define QSFP_DD_CBL_ASM_LEN_OFFSET		0xCA
+#define QSFP_DD_6300M_MAX_LEN			0xFF
+
+/* Cable length with multiplier */
+#define QSFP_DD_MULTIPLIER_00			0x00
+#define QSFP_DD_MULTIPLIER_01			0x40
+#define QSFP_DD_MULTIPLIER_10			0x80
+#define QSFP_DD_MULTIPLIER_11			0xC0
+#define QSFP_DD_LEN_MUL_MASK			0xC0
+#define QSFP_DD_LEN_VAL_MASK			0x3F
+
+/* Module power characteristics */
+#define QSFP_DD_PWR_CLASS_OFFSET		0xC8
+#define QSFP_DD_PWR_MAX_POWER_OFFSET		0xC9
+#define QSFP_DD_PWR_CLASS_MASK			0xE0
+#define QSFP_DD_PWR_CLASS_1			0x00
+#define QSFP_DD_PWR_CLASS_2			0x01
+#define QSFP_DD_PWR_CLASS_3			0x02
+#define QSFP_DD_PWR_CLASS_4			0x03
+#define QSFP_DD_PWR_CLASS_5			0x04
+#define QSFP_DD_PWR_CLASS_6			0x05
+#define QSFP_DD_PWR_CLASS_7			0x06
+#define QSFP_DD_PWR_CLASS_8			0x07
+
+/* Copper cable attenuation */
+#define QSFP_DD_COPPER_ATT_5GHZ			0xCC
+#define QSFP_DD_COPPER_ATT_7GHZ			0xCD
+#define QSFP_DD_COPPER_ATT_12P9GHZ		0xCE
+#define QSFP_DD_COPPER_ATT_25P8GHZ		0xCF
+
+/* Cable assembly lane */
+#define QSFP_DD_CABLE_ASM_NEAR_END_OFFSET	0xD2
+#define QSFP_DD_CABLE_ASM_FAR_END_OFFSET	0xD3
+
+/* Media interface technology */
+#define QSFP_DD_MEDIA_INTF_TECH_OFFSET		0xD4
+#define QSFP_DD_850_VCSEL			0x00
+#define QSFP_DD_1310_VCSEL			0x01
+#define QSFP_DD_1550_VCSEL			0x02
+#define QSFP_DD_1310_FP				0x03
+#define QSFP_DD_1310_DFB			0x04
+#define QSFP_DD_1550_DFB			0x05
+#define QSFP_DD_1310_EML			0x06
+#define QSFP_DD_1550_EML			0x07
+#define QSFP_DD_OTHERS				0x08
+#define QSFP_DD_1490_DFB			0x09
+#define QSFP_DD_COPPER_UNEQUAL			0x0A
+#define QSFP_DD_COPPER_PASS_EQUAL		0x0B
+#define QSFP_DD_COPPER_NF_EQUAL			0x0C
+#define QSFP_DD_COPPER_F_EQUAL			0x0D
+#define QSFP_DD_COPPER_N_EQUAL			0x0E
+#define QSFP_DD_COPPER_LINEAR_EQUAL		0x0F
+
+/*-----------------------------------------------------------------------
+ * For optical connected cables (the eeprom length is equal to  640 bytes
+ * = QSFP_DD_EEPROM_WITH_OPTICAL), the memory has the following format:
+ * Bytes   0-127: page  0 (lower)
+ * Bytes 128-255: page  0 (higher)
+ * Bytes 256-383: page  1 (higher)
+ * Bytes 384-511: page  2 (higher)
+ * Bytes 512-639: page 16 (higher)
+ * Bytes 640-768: page 17 (higher)
+ *
+ * Since for pages with an index > 0 the lower part is missing from the memory,
+ * but the offset values are still in the [128, 255) range, the real offset in
+ * the eeprom memory must be calculated as following:
+ * RealOffset = PageIndex * 0x80 + LocalOffset
+
+ * The page index is the index of the page, starting from 0: page 0 has index
+ * 1, page 1 has index 1, page 2 has index 2, page 16 has index 3 and page 17
+ * has index 4.
+ */
+
+/*-----------------------------------------------------------------------
+ * Upper Memory Page 0x01: contains advertising fields that define properties
+ * that are unique to active modules and cable assemblies.
+ * RealOffset = 1 * 0x80 + LocalOffset
+ */
+#define PAG01H_OFFSET				(0x01 * 0x80)
+
+/* Supported Link Length (Page 1) */
+#define QSFP_DD_SMF_LEN_OFFSET			(PAG01H_OFFSET + 0x84)
+#define QSFP_DD_OM5_LEN_OFFSET			(PAG01H_OFFSET + 0x85)
+#define QSFP_DD_OM4_LEN_OFFSET			(PAG01H_OFFSET + 0x86)
+#define QSFP_DD_OM3_LEN_OFFSET			(PAG01H_OFFSET + 0x87)
+#define QSFP_DD_OM2_LEN_OFFSET			(PAG01H_OFFSET + 0x88)
+
+/* Wavelength (Page 1) */
+#define QSFP_DD_NOM_WAVELENGTH_MSB		(PAG01H_OFFSET + 0x8A)
+#define QSFP_DD_NOM_WAVELENGTH_LSB		(PAG01H_OFFSET + 0x8B)
+#define QSFP_DD_WAVELENGTH_TOL_MSB		(PAG01H_OFFSET + 0x8C)
+#define QSFP_DD_WAVELENGTH_TOL_LSB		(PAG01H_OFFSET + 0x8D)
+
+/* Signal integrity controls */
+#define QSFP_DD_SIG_INTEG_TX_OFFSET		(PAG01H_OFFSET + 0xA1)
+#define QSFP_DD_SIG_INTEG_RX_OFFSET		(PAG01H_OFFSET + 0xA2)
+
+/*-----------------------------------------------------------------------
+ * Upper Memory Page 0x02: contains module defined threshdolds and lane-
+ * specific monitors.
+ * RealOffset = 2 * 0x80 + LocalOffset
+ */
+#define PAG02H_OFFSET				(0x02 * 0x80)
+#define QSFP_DD_TEMP_THRS_START_OFFSET		(PAG02H_OFFSET + 0x80)
+#define QSFP_DD_VOLT_THRS_START_OFFSET		(PAG02H_OFFSET + 0x88)
+#define QSFP_DD_TXPW_THRS_START_OFFSET		(PAG02H_OFFSET + 0xB0)
+#define QSFP_DD_TXBI_THRS_START_OFFSET		(PAG02H_OFFSET + 0xB8)
+#define QSFP_DD_RXPW_THRS_START_OFFSET		(PAG02H_OFFSET + 0xC0)
+
+/*-----------------------------------------------------------------------
+ * Upper Memory Page 0x10: contains dynamic control bytes.
+ * RealOffset = 3 * 0x80 + LocalOffset
+ */
+#define PAG16H_OFFSET				(0x03 * 0x80)
+
+/*-----------------------------------------------------------------------
+ * Upper Memory Page 0x11: contains lane dynamic status bytes.
+ * RealOffset = 4 * 0x80 + LocalOffset
+ */
+#define PAG11H_OFFSET				(0x04 * 0x80)
+#define QSFP_DD_TX_PWR_START_OFFSET		(PAG11H_OFFSET + 0x9A)
+#define QSFP_DD_TX_BIAS_START_OFFSET		(PAG11H_OFFSET + 0xAA)
+#define QSFP_DD_RX_PWR_START_OFFSET		(PAG11H_OFFSET + 0xBA)
+
+/* HA = High Alarm; LA = Low Alarm
+ * HW = High Warning; LW = Low Warning
+ */
+#define QSFP_DD_TX_HA_OFFSET			(PAG11H_OFFSET + 0x8B)
+#define QSFP_DD_TX_LA_OFFSET			(PAG11H_OFFSET + 0x8C)
+#define QSFP_DD_TX_HW_OFFSET			(PAG11H_OFFSET + 0x8D)
+#define QSFP_DD_TX_LW_OFFSET			(PAG11H_OFFSET + 0x8E)
+
+#define QSFP_DD_RX_HA_OFFSET			(PAG11H_OFFSET + 0x95)
+#define QSFP_DD_RX_LA_OFFSET			(PAG11H_OFFSET + 0x96)
+#define QSFP_DD_RX_HW_OFFSET			(PAG11H_OFFSET + 0x97)
+#define QSFP_DD_RX_LW_OFFSET			(PAG11H_OFFSET + 0x98)
+
+#define YESNO(x) (((x) != 0) ? "Yes" : "No")
+#define ONOFF(x) (((x) != 0) ? "On" : "Off")
+
+void qsfp_dd_show_all(const __u8 *id, __u32 eeprom_len);
+
+#endif /* QSFP_DD_H__ */
diff --git a/qsfp.c b/qsfp.c
index d0774b0..f1be5ff 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -58,6 +58,7 @@
 #include "internal.h"
 #include "sff-common.h"
 #include "qsfp.h"
+#include "qsfp-dd.h"
 
 #define MAX_DESC_SIZE	42
 
@@ -478,9 +479,9 @@ static void sff8636_show_rate_identifier(const __u8 *id)
 			id[SFF8636_EXT_RS_OFFSET]);
 }
 
-static void sff8636_show_oui(const __u8 *id)
+static void sff8636_show_oui(const __u8 *id, int id_offset)
 {
-	sff8024_show_oui(id, SFF8636_VENDOR_OUI_OFFSET);
+	sff8024_show_oui(id, id_offset);
 }
 
 static void sff8636_show_wavelength_or_copper_compliance(const __u8 *id)
@@ -561,38 +562,7 @@ static void sff8636_show_wavelength_or_copper_compliance(const __u8 *id)
 
 static void sff8636_show_revision_compliance(const __u8 *id)
 {
-	static const char *pfx =
-		"\tRevision Compliance                       :";
-
-	switch (id[SFF8636_REV_COMPLIANCE_OFFSET]) {
-	case SFF8636_REV_UNSPECIFIED:
-		printf("%s Revision not specified\n", pfx);
-		break;
-	case SFF8636_REV_8436_48:
-		printf("%s SFF-8436 Rev 4.8 or earlier\n", pfx);
-		break;
-	case SFF8636_REV_8436_8636:
-		printf("%s SFF-8436 Rev 4.8 or earlier\n", pfx);
-		break;
-	case SFF8636_REV_8636_13:
-		printf("%s SFF-8636 Rev 1.3 or earlier\n", pfx);
-		break;
-	case SFF8636_REV_8636_14:
-		printf("%s SFF-8636 Rev 1.4\n", pfx);
-		break;
-	case SFF8636_REV_8636_15:
-		printf("%s SFF-8636 Rev 1.5\n", pfx);
-		break;
-	case SFF8636_REV_8636_20:
-		printf("%s SFF-8636 Rev 2.0\n", pfx);
-		break;
-	case SFF8636_REV_8636_27:
-		printf("%s SFF-8636 Rev 2.5/2.6/2.7\n", pfx);
-		break;
-	default:
-		printf("%s Unallocated\n", pfx);
-		break;
-	}
+	sff_show_revision_compliance(id, SFF8636_REV_COMPLIANCE_OFFSET);
 }
 
 /*
@@ -745,10 +715,15 @@ static void sff8636_show_dom(const __u8 *id, __u32 eeprom_len)
 
 		sff_show_thresholds(sd);
 	}
-
 }
+
 void sff8636_show_all(const __u8 *id, __u32 eeprom_len)
 {
+	if (id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP_DD) {
+		qsfp_dd_show_all(id, eeprom_len);
+		return;
+	}
+
 	sff8636_show_identifier(id);
 	if ((id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP) ||
 		(id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP_PLUS) ||
@@ -757,6 +732,7 @@ void sff8636_show_all(const __u8 *id, __u32 eeprom_len)
 		sff8636_show_connector(id);
 		sff8636_show_transceiver(id);
 		sff8636_show_encoding(id);
+
 		sff_show_value_with_unit(id, SFF8636_BR_NOMINAL_OFFSET,
 				"BR, Nominal", 100, "Mbps");
 		sff8636_show_rate_identifier(id);
@@ -771,17 +747,19 @@ void sff8636_show_all(const __u8 *id, __u32 eeprom_len)
 		sff_show_value_with_unit(id, SFF8636_CBL_LEN_OFFSET,
 			     "Length (Copper or Active cable)", 1, "m");
 		sff8636_show_wavelength_or_copper_compliance(id);
+
 		sff_show_ascii(id, SFF8636_VENDOR_NAME_START_OFFSET,
-			       SFF8636_VENDOR_NAME_END_OFFSET, "Vendor name");
-		sff8636_show_oui(id);
+				SFF8636_VENDOR_NAME_END_OFFSET, "Vendor name");
+		sff8636_show_oui(id, SFF8636_VENDOR_OUI_OFFSET);
 		sff_show_ascii(id, SFF8636_VENDOR_PN_START_OFFSET,
-			       SFF8636_VENDOR_PN_END_OFFSET, "Vendor PN");
+				SFF8636_VENDOR_PN_END_OFFSET, "Vendor PN");
 		sff_show_ascii(id, SFF8636_VENDOR_REV_START_OFFSET,
-			       SFF8636_VENDOR_REV_END_OFFSET, "Vendor rev");
+				SFF8636_VENDOR_REV_END_OFFSET, "Vendor rev");
 		sff_show_ascii(id, SFF8636_VENDOR_SN_START_OFFSET,
-			       SFF8636_VENDOR_SN_END_OFFSET, "Vendor SN");
+				SFF8636_VENDOR_SN_END_OFFSET, "Vendor SN");
 		sff_show_ascii(id, SFF8636_DATE_YEAR_OFFSET,
-			       SFF8636_DATE_VENDOR_LOT_OFFSET + 1, "Date code");
+				SFF8636_DATE_VENDOR_LOT_OFFSET + 1, "Date code");
+
 		sff8636_show_revision_compliance(id);
 		sff8636_show_dom(id, eeprom_len);
 	}
diff --git a/qsfp.h b/qsfp.h
index b623174..a2dfb63 100644
--- a/qsfp.h
+++ b/qsfp.h
@@ -31,14 +31,6 @@
 #define	SFF8636_ID_OFFSET	0x00
 
 #define	SFF8636_REV_COMPLIANCE_OFFSET	0x01
-#define	 SFF8636_REV_UNSPECIFIED		0x00
-#define	 SFF8636_REV_8436_48			0x01
-#define	 SFF8636_REV_8436_8636			0x02
-#define	 SFF8636_REV_8636_13			0x03
-#define	 SFF8636_REV_8636_14			0x04
-#define	 SFF8636_REV_8636_15			0x05
-#define	 SFF8636_REV_8636_20			0x06
-#define	 SFF8636_REV_8636_27			0x07
 
 #define	SFF8636_STATUS_2_OFFSET	0x02
 /* Flat Memory:0- Paging, 1- Page 0 only */
diff --git a/sff-common.c b/sff-common.c
index 7700cbe..5490b5f 100644
--- a/sff-common.c
+++ b/sff-common.c
@@ -46,6 +46,7 @@ void sff_show_ascii(const __u8 *id, unsigned int first_reg,
 	printf("\t%-41s : ", name);
 	while (first_reg <= last_reg && id[last_reg] == ' ')
 		last_reg--;
+
 	for (reg = first_reg; reg <= last_reg; reg++) {
 		val = id[reg];
 		putchar(((val >= 32) && (val <= 126)) ? val : '_');
@@ -136,6 +137,9 @@ void sff8024_show_identifier(const __u8 *id, int id_offset)
 	case SFF8024_ID_MICRO_QSFP:
 		printf(" (microQSFP)\n");
 		break;
+	case SFF8024_ID_QSFP_DD:
+		printf(" (QSFP-DD Double Density 8X Pluggable Transceiver (INF-8628))\n");
+		break;
 	default:
 		printf(" (reserved or unknown)\n");
 		break;
@@ -203,6 +207,18 @@ void sff8024_show_connector(const __u8 *id, int ctor_offset)
 	case SFF8024_CTOR_MXC_2x16:
 		printf(" (MXC 2x16)\n");
 		break;
+	case SFF8024_CTOR_CS_OPTICAL:
+		printf(" (CS optical connector)\n");
+		break;
+	case SFF8024_CTOR_CS_OPTICAL_MINI:
+		printf(" (Mini CS optical connector)\n");
+		break;
+	case SFF8024_CTOR_MPO_2X12:
+		printf(" (MPO 2x12)\n");
+		break;
+	case SFF8024_CTOR_MPO_1X16:
+		printf(" (MPO 1x16)\n");
+		break;
 	default:
 		printf(" (reserved or unknown)\n");
 		break;
@@ -302,3 +318,39 @@ void sff_show_thresholds(struct sff_diags sd)
 	PRINT_xX_PWR("Laser rx power low warning threshold",
 		     sd.rx_power[LWARN]);
 }
+
+void sff_show_revision_compliance(const __u8 *id, int rev_offset)
+{
+	static const char *pfx =
+		"\tRevision Compliance                       :";
+
+	switch (id[rev_offset]) {
+	case SFF8636_REV_UNSPECIFIED:
+		printf("%s Revision not specified\n", pfx);
+		break;
+	case SFF8636_REV_8436_48:
+		printf("%s SFF-8436 Rev 4.8 or earlier\n", pfx);
+		break;
+	case SFF8636_REV_8436_8636:
+		printf("%s SFF-8436 Rev 4.8 or earlier\n", pfx);
+		break;
+	case SFF8636_REV_8636_13:
+		printf("%s SFF-8636 Rev 1.3 or earlier\n", pfx);
+		break;
+	case SFF8636_REV_8636_14:
+		printf("%s SFF-8636 Rev 1.4\n", pfx);
+		break;
+	case SFF8636_REV_8636_15:
+		printf("%s SFF-8636 Rev 1.5\n", pfx);
+		break;
+	case SFF8636_REV_8636_20:
+		printf("%s SFF-8636 Rev 2.0\n", pfx);
+		break;
+	case SFF8636_REV_8636_27:
+		printf("%s SFF-8636 Rev 2.5/2.6/2.7\n", pfx);
+		break;
+	default:
+		printf("%s Unallocated\n", pfx);
+		break;
+	}
+}
diff --git a/sff-common.h b/sff-common.h
index 5562b4d..0d04851 100644
--- a/sff-common.h
+++ b/sff-common.h
@@ -26,7 +26,17 @@
 #include <stdio.h>
 #include "internal.h"
 
-#define SFF8024_ID_OFFSET				0x00
+/* Revision compliance */
+#define	 SFF8636_REV_UNSPECIFIED		0x00
+#define	 SFF8636_REV_8436_48			0x01
+#define	 SFF8636_REV_8436_8636			0x02
+#define	 SFF8636_REV_8636_13			0x03
+#define	 SFF8636_REV_8636_14			0x04
+#define	 SFF8636_REV_8636_15			0x05
+#define	 SFF8636_REV_8636_20			0x06
+#define	 SFF8636_REV_8636_27			0x07
+
+#define  SFF8024_ID_OFFSET				0x00
 #define  SFF8024_ID_UNKNOWN				0x00
 #define  SFF8024_ID_GBIC				0x01
 #define  SFF8024_ID_SOLDERED_MODULE		0x02
@@ -51,7 +61,8 @@
 #define  SFF8024_ID_HD8X_FANOUT			0x15
 #define  SFF8024_ID_CDFP_S3				0x16
 #define  SFF8024_ID_MICRO_QSFP			0x17
-#define  SFF8024_ID_LAST				SFF8024_ID_MICRO_QSFP
+#define  SFF8024_ID_QSFP_DD				0x18
+#define  SFF8024_ID_LAST				SFF8024_ID_QSFP_DD
 #define  SFF8024_ID_UNALLOCATED_LAST	0x7F
 #define  SFF8024_ID_VENDOR_START		0x80
 #define  SFF8024_ID_VENDOR_LAST			0xFF
@@ -76,8 +87,14 @@
 #define  SFF8024_CTOR_RJ45				0x22
 #define  SFF8024_CTOR_NO_SEPARABLE		0x23
 #define  SFF8024_CTOR_MXC_2x16			0x24
-#define  SFF8024_CTOR_LAST				SFF8024_CTOR_MXC_2x16
-#define  SFF8024_CTOR_UNALLOCATED_LAST	0x7F
+#define  SFF8024_CTOR_CS_OPTICAL		0x25
+#define  SFF8024_CTOR_CS_OPTICAL_MINI		0x26
+#define  SFF8024_CTOR_MPO_2X12		    	0x27
+#define  SFF8024_CTOR_MPO_1X16		    	0x28
+#define  SFF8024_CTOR_LAST			SFF8024_CTOR_MPO_1X16
+
+#define  SFF8024_CTOR_NO_SEP_QSFP_DD 		0x6F
+#define  SFF8024_CTOR_UNALLOCATED_LAST		0x7F
 #define  SFF8024_CTOR_VENDOR_START		0x80
 #define  SFF8024_CTOR_VENDOR_LAST		0xFF
 
@@ -185,5 +202,6 @@ void sff8024_show_oui(const __u8 *id, int id_offset);
 void sff8024_show_identifier(const __u8 *id, int id_offset);
 void sff8024_show_connector(const __u8 *id, int ctor_offset);
 void sff8024_show_encoding(const __u8 *id, int encoding_offset, int sff_type);
+void sff_show_revision_compliance(const __u8 *id, int rev_offset);
 
 #endif /* SFF_COMMON_H__ */
-- 
2.17.1

