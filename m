Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB3B309CB1
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 15:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhAaOPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 09:15:08 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:62644 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231873AbhAaN3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 08:29:08 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10VD6EKs022010;
        Sun, 31 Jan 2021 05:11:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=MUQcGNBPOoZDg43GJLnZ0eNzIEPN13Ow4cmnk2Tddls=;
 b=Afl9YmvDAbE2L826WVCAovvRbiF8UbYY4D/sE8VG252vMU6R7M3ToJa+MAJDSlyj7Q+8
 7iceFeDhkYDlKKdWrldHwBEslLBbLGoTPAC2Pq/S6PAHkuH04D++vS5jL2Du66BMNyAv
 O0/2xO0ZQYQ8+r/HIrKYQX2TYPSbd8Hq4uOBVetfY3MDjE5IERZxCpqkfZHEjiUTFj4M
 SOp+CynrBsQYyTrMg4ZpVd9dnsvHSeUy8daT/uxU2Z9FWRaU6EXlxoAkzVnNsgm8wt3q
 CAh7pp4+KmF2W7lcunxnVIyalocFBOIoOOrXRM00tB9xqSKze5Tu3fELhgk7+b+YI2Ug qg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36d5psss68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 05:11:30 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 05:11:29 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 31 Jan 2021 05:11:29 -0800
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id D4CDD3F703F;
        Sun, 31 Jan 2021 05:11:25 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [Patch v3 net-next 5/7] octeontx2-af: advertised link modes support on cgx
Date:   Sun, 31 Jan 2021 18:41:03 +0530
Message-ID: <1612098665-187767-6-git-send-email-hkelam@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612098665-187767-1-git-send-email-hkelam@marvell.com>
References: <1612098665-187767-1-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-31_04:2021-01-29,2021-01-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christina Jacob <cjacob@marvell.com>

CGX supports setting advertised link modes on physical link.
This patch adds support to derive cgx mode from ethtool
link mode and pass it to firmware to configure the same.

Signed-off-by: Christina Jacob <cjacob@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 114 ++++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/af/cgx_fw_if.h  |  32 +++++-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   3 +-
 3 files changed, 146 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 5b7d858..9c62129 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -14,6 +14,7 @@
 #include <linux/pci.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
+#include <linux/ethtool.h>
 #include <linux/phy.h>
 #include <linux/of.h>
 #include <linux/of_mdio.h>
@@ -646,6 +647,7 @@ static inline void cgx_link_usertable_init(void)
 	cgx_speed_mbps[CGX_LINK_25G] = 25000;
 	cgx_speed_mbps[CGX_LINK_40G] = 40000;
 	cgx_speed_mbps[CGX_LINK_50G] = 50000;
+	cgx_speed_mbps[CGX_LINK_80G] = 80000;
 	cgx_speed_mbps[CGX_LINK_100G] = 100000;
 
 	cgx_lmactype_string[LMAC_MODE_SGMII] = "SGMII";
@@ -693,6 +695,110 @@ static int cgx_link_usertable_index_map(int speed)
 	return CGX_LINK_NONE;
 }
 
+static void set_mod_args(struct cgx_set_link_mode_args *args,
+			 u32 speed, u8 duplex, u8 autoneg, u64 mode)
+{
+	/* Fill default values incase of user did not pass
+	 * valid parameters
+	 */
+	if (args->duplex == DUPLEX_UNKNOWN)
+		args->duplex = duplex;
+	if (args->speed == SPEED_UNKNOWN)
+		args->speed = speed;
+	if (args->an == AUTONEG_UNKNOWN)
+		args->an = autoneg;
+	args->mode = mode;
+	args->ports = 0;
+}
+
+static void otx2_map_ethtool_link_modes(u64 bitmask,
+					struct cgx_set_link_mode_args *args)
+{
+	switch (bitmask) {
+	case ETHTOOL_LINK_MODE_10baseT_Half_BIT:
+		set_mod_args(args, 10, 1, 1, BIT_ULL(CGX_MODE_SGMII));
+		break;
+	case  ETHTOOL_LINK_MODE_10baseT_Full_BIT:
+		set_mod_args(args, 10, 0, 1, BIT_ULL(CGX_MODE_SGMII));
+		break;
+	case  ETHTOOL_LINK_MODE_100baseT_Half_BIT:
+		set_mod_args(args, 100, 1, 1, BIT_ULL(CGX_MODE_SGMII));
+		break;
+	case  ETHTOOL_LINK_MODE_100baseT_Full_BIT:
+		set_mod_args(args, 100, 0, 1, BIT_ULL(CGX_MODE_SGMII));
+		break;
+	case  ETHTOOL_LINK_MODE_1000baseT_Half_BIT:
+		set_mod_args(args, 1000, 1, 1, BIT_ULL(CGX_MODE_SGMII));
+		break;
+	case  ETHTOOL_LINK_MODE_1000baseT_Full_BIT:
+		set_mod_args(args, 1000, 0, 1, BIT_ULL(CGX_MODE_SGMII));
+		break;
+	case  ETHTOOL_LINK_MODE_1000baseX_Full_BIT:
+		set_mod_args(args, 1000, 0, 0, BIT_ULL(CGX_MODE_1000_BASEX));
+		break;
+	case  ETHTOOL_LINK_MODE_10000baseT_Full_BIT:
+		set_mod_args(args, 1000, 0, 1, BIT_ULL(CGX_MODE_QSGMII));
+		break;
+	case  ETHTOOL_LINK_MODE_10000baseSR_Full_BIT:
+		set_mod_args(args, 10000, 0, 0, BIT_ULL(CGX_MODE_10G_C2C));
+		break;
+	case  ETHTOOL_LINK_MODE_10000baseLR_Full_BIT:
+		set_mod_args(args, 10000, 0, 0, BIT_ULL(CGX_MODE_10G_C2M));
+		break;
+	case  ETHTOOL_LINK_MODE_10000baseKR_Full_BIT:
+		set_mod_args(args, 10000, 0, 1, BIT_ULL(CGX_MODE_10G_KR));
+		break;
+	case  ETHTOOL_LINK_MODE_25000baseSR_Full_BIT:
+		set_mod_args(args, 25000, 0, 0, BIT_ULL(CGX_MODE_25G_C2C));
+		break;
+	case  ETHTOOL_LINK_MODE_25000baseCR_Full_BIT:
+		set_mod_args(args, 25000, 0, 1, BIT_ULL(CGX_MODE_25G_CR));
+		break;
+	case  ETHTOOL_LINK_MODE_25000baseKR_Full_BIT:
+		set_mod_args(args, 25000, 0, 1, BIT_ULL(CGX_MODE_25G_KR));
+		break;
+	case  ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT:
+		set_mod_args(args, 40000, 0, 0, BIT_ULL(CGX_MODE_40G_C2C));
+		break;
+	case  ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT:
+		set_mod_args(args, 40000, 0, 0, BIT_ULL(CGX_MODE_40G_C2M));
+		break;
+	case  ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT:
+		set_mod_args(args, 40000, 0, 1, BIT_ULL(CGX_MODE_40G_CR4));
+		break;
+	case  ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT:
+		set_mod_args(args, 40000, 0, 1, BIT_ULL(CGX_MODE_40G_KR4));
+		break;
+	case  ETHTOOL_LINK_MODE_50000baseSR_Full_BIT:
+		set_mod_args(args, 50000, 0, 0, BIT_ULL(CGX_MODE_50G_C2C));
+		break;
+	case  ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT:
+		set_mod_args(args, 50000, 0, 0, BIT_ULL(CGX_MODE_50G_C2M));
+		break;
+	case  ETHTOOL_LINK_MODE_50000baseCR_Full_BIT:
+		set_mod_args(args, 50000, 0, 1, BIT_ULL(CGX_MODE_50G_CR));
+		break;
+	case  ETHTOOL_LINK_MODE_50000baseKR_Full_BIT:
+		set_mod_args(args, 50000, 0, 1, BIT_ULL(CGX_MODE_50G_KR));
+		break;
+	case  ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT:
+		set_mod_args(args, 100000, 0, 0, BIT_ULL(CGX_MODE_100G_C2C));
+		break;
+	case  ETHTOOL_LINK_MODE_100000baseLR4_ER4_Full_BIT:
+		set_mod_args(args, 100000, 0, 0, BIT_ULL(CGX_MODE_100G_C2M));
+		break;
+	case  ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT:
+		set_mod_args(args, 100000, 0, 1, BIT_ULL(CGX_MODE_100G_CR4));
+		break;
+	case  ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT:
+		set_mod_args(args, 100000, 0, 1, BIT_ULL(CGX_MODE_100G_KR4));
+		break;
+	default:
+		set_mod_args(args, 0, 1, 0, BIT_ULL(CGX_MODE_MAX));
+		break;
+	}
+}
+
 static inline void link_status_user_format(u64 lstat,
 					   struct cgx_link_user_info *linfo,
 					   struct cgx *cgx, u8 lmac_id)
@@ -887,13 +993,19 @@ int cgx_set_link_mode(void *cgxd, struct cgx_set_link_mode_args args,
 	if (!cgx)
 		return -ENODEV;
 
+	if (args.mode)
+		otx2_map_ethtool_link_modes(args.mode, &args);
+	if (!args.speed && args.duplex && !args.an)
+		return -EINVAL;
+
 	req = FIELD_SET(CMDREG_ID, CGX_CMD_MODE_CHANGE, req);
 	req = FIELD_SET(CMDMODECHANGE_SPEED,
 			cgx_link_usertable_index_map(args.speed), req);
 	req = FIELD_SET(CMDMODECHANGE_DUPLEX, args.duplex, req);
 	req = FIELD_SET(CMDMODECHANGE_AN, args.an, req);
 	req = FIELD_SET(CMDMODECHANGE_PORT, args.ports, req);
-	req = FIELD_SET(CMDMODECHANGE_FLAGS, args.flags, req);
+	req = FIELD_SET(CMDMODECHANGE_FLAGS, args.mode, req);
+
 	return cgx_fwi_cmd_generic(req, &resp, cgx, lmac_id);
 }
 int cgx_set_fec(u64 fec, int cgx_id, int lmac_id)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
index 70610e7..dde2bd0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
@@ -70,6 +70,36 @@ enum cgx_link_speed {
 	CGX_LINK_SPEED_MAX,
 };
 
+enum CGX_MODE_ {
+	CGX_MODE_SGMII,
+	CGX_MODE_1000_BASEX,
+	CGX_MODE_QSGMII,
+	CGX_MODE_10G_C2C,
+	CGX_MODE_10G_C2M,
+	CGX_MODE_10G_KR,
+	CGX_MODE_20G_C2C,
+	CGX_MODE_25G_C2C,
+	CGX_MODE_25G_C2M,
+	CGX_MODE_25G_2_C2C,
+	CGX_MODE_25G_CR,
+	CGX_MODE_25G_KR,
+	CGX_MODE_40G_C2C,
+	CGX_MODE_40G_C2M,
+	CGX_MODE_40G_CR4,
+	CGX_MODE_40G_KR4,
+	CGX_MODE_40GAUI_C2C,
+	CGX_MODE_50G_C2C,
+	CGX_MODE_50G_C2M,
+	CGX_MODE_50G_4_C2C,
+	CGX_MODE_50G_CR,
+	CGX_MODE_50G_KR,
+	CGX_MODE_80GAUI_C2C,
+	CGX_MODE_100G_C2C,
+	CGX_MODE_100G_C2M,
+	CGX_MODE_100G_CR4,
+	CGX_MODE_100G_KR4,
+	CGX_MODE_MAX /* = 29 */
+};
 /* REQUEST ID types. Input to firmware */
 enum cgx_cmd_id {
 	CGX_CMD_NONE,
@@ -231,6 +261,6 @@ struct cgx_lnk_sts {
 #define CMDMODECHANGE_DUPLEX		GENMASK_ULL(12, 12)
 #define CMDMODECHANGE_AN		GENMASK_ULL(13, 13)
 #define CMDMODECHANGE_PORT		GENMASK_ULL(21, 14)
-#define CMDMODECHANGE_FLAGS		GENMASK_ULL(29, 22)
+#define CMDMODECHANGE_FLAGS		GENMASK_ULL(63, 22)
 
 #endif /* __CGX_FW_INTF_H__ */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index a050902..05a6da2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -462,10 +462,11 @@ struct cgx_set_link_mode_args {
 	u8 duplex;
 	u8 an;
 	u8 ports;
-	u8 flags;
+	u64 mode;
 };
 
 struct cgx_set_link_mode_req {
+#define AUTONEG_UNKNOWN		0xff
 	struct mbox_msghdr hdr;
 	struct cgx_set_link_mode_args args;
 };
-- 
2.7.4

