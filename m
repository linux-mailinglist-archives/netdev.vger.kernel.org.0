Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1087D243E07
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 19:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgHMRIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 13:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgHMRIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 13:08:40 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B17C061757
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 10:08:39 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id x5so5310852wmi.2
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 10:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=EAOdy2pkXJXuG5UobETJJ/ztffQIpltKfIfZxdQc/ro=;
        b=o6HyEQNZLeBwZxYS0YtdQRRqUhiMBZvYxvhjEA81zOfkjBPdh+QXTbI1Selv23eBEk
         C3G0MnOMvvwe97lHVSt+WUUyftJ8/VvNfyAykU8f1hDdnCXpsaJ39DkLf4dFcF6wTuAj
         MgMdDxfBipcaHyi4rMgcf1gLprGqPyR/NgIyyYbbcBa9HbF0Km3BBAMOC3HSyo2uOV7v
         SgG/jhr208Uu4A3dOxYgBgtJXW4zyZtxrgdR9BRvjX9c6l3gP3edpSL1pzAX4K7RiST5
         rNrVJPIADfmpXNmYkEI9zXCcOhSNTXTp9hhnQs+djXQSgayP14LsRS7m83wMIg3bDasv
         TqhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=EAOdy2pkXJXuG5UobETJJ/ztffQIpltKfIfZxdQc/ro=;
        b=PeGS7ANEGutBDbOnCzJ1pKyvSQ6LGzQrCy06IL7ab43TyMacRuS0ajoGTXgX9C+ps4
         an2X9VP5vs7biuG4Ck0w/7cHTe1FlpwxQYXRk6ddTRYeujGm1UJ+G41fNFprvG7CcL14
         fKCWyeHaLF9rzqYxVTuFmnPB0pLM4eKawWae7mpv1zxvqwn45GnE28/SUOVHKo0QfJLt
         4GC0EquilwrPs/3dep477+Fo5fZLEUWDrBDXeasds/PceBuDtEWXvQm9Y4bhMFVTU00X
         bkHz99Wt7DZ9IDAEtnNlEWbUW8KwNmcmTnLyGLFUsTSxW/Cck1IeKr6OHbel6VxHno/M
         681Q==
X-Gm-Message-State: AOAM5322t4bTgJ/eGka8xq+Ky9+wRkFupMDu1SQzYD0dTyqOdoddy4/j
        ZkvHgdi6WnAEmbpT6idydnY=
X-Google-Smtp-Source: ABdhPJyIv2ndEVScBDDnLaDwRfbX6lDzMUaahfi2V7nTH/JIsyQiVHSsEtednbcCVhwE1LUSlTxOnQ==
X-Received: by 2002:a1c:39d4:: with SMTP id g203mr5369101wma.107.1597338517936;
        Thu, 13 Aug 2020 10:08:37 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.61])
        by smtp.googlemail.com with ESMTPSA id r21sm11396116wrc.2.2020.08.13.10.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2020 10:08:37 -0700 (PDT)
From:   Adrian Pop <popadrian1996@gmail.com>
Cc:     popadrian1996@gmail.com, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, andrew@lunn.ch, mlxsw@mellanox.com,
        idosch@mellanox.com, roopa@nvidia.com, paschmidt@nvidia.com,
        mkubecek@suse.cz
Subject: [PATCH ethtool v5] Add QSFP-DD support
Date:   Thu, 13 Aug 2020 18:08:26 +0300
Message-Id: <20200813150826.16680-1-popadrian1996@gmail.com>
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

Several functions from qsfp.c could be reused, so an additional parameter
was added to each and the functions were moved to sff-common.c.

Diff from v1:
* Report cable length in meters instead of kilometers
* Fix bad value for QSFP_DD_DATE_VENDOR_LOT_OFFSET
* Fix initialization for struct qsfp_dd_diags
* Remove unrelated whitespace cleanups in qsfp.c and Makefile.am

Diff from v2:
* Remove functions assuming the existance of page 0x10 and 0x11
* Remove structs and constants related to the page 0x10 and 0x11

Diff from v3:
* Added missing Signed-off-by and Tested-by tags

Diff from v4:
* Fix whitespace formatting problems

Signed-off-by: Adrian Pop <popadrian1996@gmail.com>
Tested-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 Makefile.am  |   2 +-
 qsfp-dd.c    | 333 +++++++++++++++++++++++++++++++++++++++++++++++++++
 qsfp-dd.h    | 125 +++++++++++++++++++
 qsfp.c       |  47 ++------
 qsfp.h       |   8 --
 sff-common.c |  51 ++++++++
 sff-common.h |  26 +++-
 7 files changed, 543 insertions(+), 49 deletions(-)
 create mode 100644 qsfp-dd.c
 create mode 100644 qsfp-dd.h

diff --git a/Makefile.am b/Makefile.am
index 2abb274..38dde09 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -17,7 +17,7 @@ ethtool_SOURCES += \
 		  smsc911x.c at76c50x-usb.c sfc.c stmmac.c	\
 		  sff-common.c sff-common.h sfpid.c sfpdiag.c	\
 		  ixgbevf.c tse.c vmxnet3.c qsfp.c qsfp.h fjes.c lan78xx.c \
-		  igc.c
+		  igc.c qsfp-dd.c qsfp-dd.h
 endif
 
 if ENABLE_BASH_COMPLETION
diff --git a/qsfp-dd.c b/qsfp-dd.c
new file mode 100644
index 0000000..900bbb5
--- /dev/null
+++ b/qsfp-dd.c
@@ -0,0 +1,333 @@
+/**
+ * Description:
+ *
+ * This module adds QSFP-DD support to ethtool. The changes are similar to
+ * the ones already existing in qsfp.c, but customized to use the memory
+ * addresses and logic as defined in the specification's document.
+ *
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
+	printf("\t%-41s : %0.2fm\n", fn, val);
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
+/*
+ * 2-byte internal temperature conversions:
+ * First byte is a signed 8-bit integer, which is the temp decimal part
+ * Second byte is a multiple of 1/256th of a degree, which is added to
+ * the dec part.
+ */
+#define OFFSET_TO_TEMP(offset) ((__s16)OFFSET_TO_U16(offset))
+
+/**
+ * Print relevant module level monitoring values. Relevant documents:
+ * [1] CMIS Rev. 3:
+ * --> pag. 50, section 1.7.2.4, Table 22
+ *
+ * [2] CMIS Rev. 4:
+ * --> pag. 84, section 8.2.4, Table 8-6
+ */
+static void qsfp_dd_show_mod_lvl_monitors(const __u8 *id)
+{
+	PRINT_TEMP("Module temperature",
+		   OFFSET_TO_TEMP(QSFP_DD_CURR_TEMP_OFFSET));
+	PRINT_VCC("Module voltage",
+		  OFFSET_TO_U16(QSFP_DD_CURR_CURR_OFFSET));
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
+void qsfp_dd_show_all(const __u8 *id)
+{
+	qsfp_dd_show_identifier(id);
+	qsfp_dd_show_power_info(id);
+	qsfp_dd_show_connector(id);
+	qsfp_dd_show_cbl_asm_len(id);
+	qsfp_dd_show_sig_integrity(id);
+	qsfp_dd_show_mit_compliance(id);
+	qsfp_dd_show_mod_lvl_monitors(id);
+	qsfp_dd_show_link_len(id);
+	qsfp_dd_show_vendor_info(id);
+	qsfp_dd_show_rev_compliance(id);
+}
diff --git a/qsfp-dd.h b/qsfp-dd.h
new file mode 100644
index 0000000..f589c4e
--- /dev/null
+++ b/qsfp-dd.h
@@ -0,0 +1,125 @@
+#ifndef QSFP_DD_H__
+#define QSFP_DD_H__
+
+/* Identifier and revision compliance (Page 0) */
+#define QSFP_DD_ID_OFFSET			0x00
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
+#define QSFP_DD_DATE_VENDOR_LOT_OFFSET		0xBC
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
+ * Upper Memory Page 0x01: contains advertising fields that define properties
+ * that are unique to active modules and cable assemblies.
+ * RealOffset = 1 * 0x80 + LocalOffset
+ */
+#define PAG01H_UPPER_OFFSET			(0x01 * 0x80)
+
+/* Supported Link Length (Page 1) */
+#define QSFP_DD_SMF_LEN_OFFSET			(PAG01H_UPPER_OFFSET + 0x84)
+#define QSFP_DD_OM5_LEN_OFFSET			(PAG01H_UPPER_OFFSET + 0x85)
+#define QSFP_DD_OM4_LEN_OFFSET			(PAG01H_UPPER_OFFSET + 0x86)
+#define QSFP_DD_OM3_LEN_OFFSET			(PAG01H_UPPER_OFFSET + 0x87)
+#define QSFP_DD_OM2_LEN_OFFSET			(PAG01H_UPPER_OFFSET + 0x88)
+
+/* Wavelength (Page 1) */
+#define QSFP_DD_NOM_WAVELENGTH_MSB		(PAG01H_UPPER_OFFSET + 0x8A)
+#define QSFP_DD_NOM_WAVELENGTH_LSB		(PAG01H_UPPER_OFFSET + 0x8B)
+#define QSFP_DD_WAVELENGTH_TOL_MSB		(PAG01H_UPPER_OFFSET + 0x8C)
+#define QSFP_DD_WAVELENGTH_TOL_LSB		(PAG01H_UPPER_OFFSET + 0x8D)
+
+/* Signal integrity controls */
+#define QSFP_DD_SIG_INTEG_TX_OFFSET		(PAG01H_UPPER_OFFSET + 0xA1)
+#define QSFP_DD_SIG_INTEG_RX_OFFSET		(PAG01H_UPPER_OFFSET + 0xA2)
+
+#define YESNO(x) (((x) != 0) ? "Yes" : "No")
+#define ONOFF(x) (((x) != 0) ? "On" : "Off")
+
+void qsfp_dd_show_all(const __u8 *id);
+
+#endif /* QSFP_DD_H__ */
diff --git a/qsfp.c b/qsfp.c
index a8b69c9..3c1a300 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -58,6 +58,7 @@
 #include "internal.h"
 #include "sff-common.h"
 #include "qsfp.h"
+#include "qsfp-dd.h"
 
 #define MAX_DESC_SIZE	42
 
@@ -579,9 +580,9 @@ static void sff8636_show_rate_identifier(const __u8 *id)
 			id[SFF8636_EXT_RS_OFFSET]);
 }
 
-static void sff8636_show_oui(const __u8 *id)
+static void sff8636_show_oui(const __u8 *id, int id_offset)
 {
-	sff8024_show_oui(id, SFF8636_VENDOR_OUI_OFFSET);
+	sff8024_show_oui(id, id_offset);
 }
 
 static void sff8636_show_wavelength_or_copper_compliance(const __u8 *id)
@@ -662,38 +663,7 @@ static void sff8636_show_wavelength_or_copper_compliance(const __u8 *id)
 
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
@@ -846,10 +816,15 @@ static void sff8636_show_dom(const __u8 *id, __u32 eeprom_len)
 
 		sff_show_thresholds(sd);
 	}
-
 }
+
 void sff8636_show_all(const __u8 *id, __u32 eeprom_len)
 {
+	if (id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP_DD) {
+		qsfp_dd_show_all(id);
+		return;
+	}
+
 	sff8636_show_identifier(id);
 	if ((id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP) ||
 		(id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP_PLUS) ||
@@ -874,7 +849,7 @@ void sff8636_show_all(const __u8 *id, __u32 eeprom_len)
 		sff8636_show_wavelength_or_copper_compliance(id);
 		sff_show_ascii(id, SFF8636_VENDOR_NAME_START_OFFSET,
 			       SFF8636_VENDOR_NAME_END_OFFSET, "Vendor name");
-		sff8636_show_oui(id);
+		sff8636_show_oui(id, SFF8636_VENDOR_OUI_OFFSET);
 		sff_show_ascii(id, SFF8636_VENDOR_PN_START_OFFSET,
 			       SFF8636_VENDOR_PN_END_OFFSET, "Vendor PN");
 		sff_show_ascii(id, SFF8636_VENDOR_REV_START_OFFSET,
diff --git a/qsfp.h b/qsfp.h
index 3215932..9636b0c 100644
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
index 7700cbe..5285645 100644
--- a/sff-common.c
+++ b/sff-common.c
@@ -136,6 +136,9 @@ void sff8024_show_identifier(const __u8 *id, int id_offset)
 	case SFF8024_ID_MICRO_QSFP:
 		printf(" (microQSFP)\n");
 		break;
+	case SFF8024_ID_QSFP_DD:
+		printf(" (QSFP-DD Double Density 8X Pluggable Transceiver (INF-8628))\n");
+		break;
 	default:
 		printf(" (reserved or unknown)\n");
 		break;
@@ -203,6 +206,18 @@ void sff8024_show_connector(const __u8 *id, int ctor_offset)
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
@@ -302,3 +317,39 @@ void sff_show_thresholds(struct sff_diags sd)
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
index 5562b4d..cfb5d0e 100644
--- a/sff-common.h
+++ b/sff-common.h
@@ -26,7 +26,17 @@
 #include <stdio.h>
 #include "internal.h"
 
-#define SFF8024_ID_OFFSET				0x00
+/* Revision compliance */
+#define  SFF8636_REV_UNSPECIFIED		0x00
+#define  SFF8636_REV_8436_48			0x01
+#define  SFF8636_REV_8436_8636			0x02
+#define  SFF8636_REV_8636_13			0x03
+#define  SFF8636_REV_8636_14			0x04
+#define  SFF8636_REV_8636_15			0x05
+#define  SFF8636_REV_8636_20			0x06
+#define  SFF8636_REV_8636_27			0x07
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
+#define  SFF8024_CTOR_MPO_2X12			0x27
+#define  SFF8024_CTOR_MPO_1X16			0x28
+#define  SFF8024_CTOR_LAST			SFF8024_CTOR_MPO_1X16
+
+#define  SFF8024_CTOR_NO_SEP_QSFP_DD		0x6F
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

