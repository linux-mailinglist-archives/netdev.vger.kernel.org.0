Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C366A305501
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbhA0HuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:50:22 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:45014 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232103AbhA0Hre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 02:47:34 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10R7eDTU007641;
        Tue, 26 Jan 2021 23:46:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=YkzRsKw6QmOVwPaZobphLflXfUFz0e4K2CeKvZHqkOk=;
 b=iODS/RZsxV0zB54DGc72q/DLPkrRXUXaZb1dShM8I+OqbGHTyeLsubDGiqeIwDTkmwHL
 gdHuhdlKBDJuT1mU6oVMFV6qmhgKtl2ZRdMwqaCf44FQVW+YRTBRfzoN8k7fyp/xy/zW
 OycGVGnFGyPV/QshSfWrOi6+4ebcXgQv8dAzhK6hfB0rNSo8CuytgesbmtYaCqxza4nR
 YfsbURDXL3trfs5l5Zh1iJAivu1GPIcTJUNAYu4ToxFvYNqteKBS0KeVGeqwE8zjeG0R
 bs5Po+ZGkM5n9d9BrmWoToRWrCB5yweKSPsJWOIJleHmiyWfOG+/0wC4F7EOMSjsv1yF 7g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36b1xpg9pw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 26 Jan 2021 23:46:47 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 26 Jan
 2021 23:46:44 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 26 Jan 2021 23:46:44 -0800
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id F03233F7040;
        Tue, 26 Jan 2021 23:46:40 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, Christina Jacob <cjacob@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>
Subject: [Patch v2 net-next 5/7] octeontx2-af: advertised link modes support on cgx
Date:   Wed, 27 Jan 2021 13:15:50 +0530
Message-ID: <1611733552-150419-6-git-send-email-hkelam@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1611733552-150419-1-git-send-email-hkelam@marvell.com>
References: <1611733552-150419-1-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-27_03:2021-01-26,2021-01-27 signatures=0
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
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 113 ++++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/af/cgx_fw_if.h  |  32 +++++-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   3 +-
 3 files changed, 145 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 42ee67e..ff0e1db 100644
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
@@ -644,6 +645,7 @@ static inline void cgx_link_usertable_init(void)
 	cgx_speed_mbps[CGX_LINK_25G] = 25000;
 	cgx_speed_mbps[CGX_LINK_40G] = 40000;
 	cgx_speed_mbps[CGX_LINK_50G] = 50000;
+	cgx_speed_mbps[CGX_LINK_80G] = 80000;
 	cgx_speed_mbps[CGX_LINK_100G] = 100000;
 
 	cgx_lmactype_string[LMAC_MODE_SGMII] = "SGMII";
@@ -691,6 +693,110 @@ static inline int cgx_link_usertable_index_map(int speed)
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
+	case BIT_ULL(ETHTOOL_LINK_MODE_10baseT_Half_BIT):
+		set_mod_args(args, 10, 1, 1, BIT_ULL(CGX_MODE_SGMII));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_10baseT_Full_BIT):
+		set_mod_args(args, 10, 0, 1, BIT_ULL(CGX_MODE_SGMII));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_100baseT_Half_BIT):
+		set_mod_args(args, 100, 1, 1, BIT_ULL(CGX_MODE_SGMII));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_100baseT_Full_BIT):
+		set_mod_args(args, 100, 0, 1, BIT_ULL(CGX_MODE_SGMII));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_1000baseT_Half_BIT):
+		set_mod_args(args, 1000, 1, 1, BIT_ULL(CGX_MODE_SGMII));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_1000baseT_Full_BIT):
+		set_mod_args(args, 1000, 0, 1, BIT_ULL(CGX_MODE_SGMII));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_1000baseX_Full_BIT):
+		set_mod_args(args, 1000, 0, 0, BIT_ULL(CGX_MODE_1000_BASEX));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_10000baseT_Full_BIT):
+		set_mod_args(args, 1000, 0, 1, BIT_ULL(CGX_MODE_QSGMII));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_10000baseSR_Full_BIT):
+		set_mod_args(args, 10000, 0, 0, BIT_ULL(CGX_MODE_10G_C2C));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_10000baseLR_Full_BIT):
+		set_mod_args(args, 10000, 0, 0, BIT_ULL(CGX_MODE_10G_C2M));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT):
+		set_mod_args(args, 10000, 0, 1, BIT_ULL(CGX_MODE_10G_KR));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_25000baseSR_Full_BIT):
+		set_mod_args(args, 25000, 0, 0, BIT_ULL(CGX_MODE_25G_C2C));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_25000baseCR_Full_BIT):
+		set_mod_args(args, 25000, 0, 1, BIT_ULL(CGX_MODE_25G_CR));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_25000baseKR_Full_BIT):
+		set_mod_args(args, 25000, 0, 1, BIT_ULL(CGX_MODE_25G_KR));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT):
+		set_mod_args(args, 40000, 0, 0, BIT_ULL(CGX_MODE_40G_C2C));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT):
+		set_mod_args(args, 40000, 0, 0, BIT_ULL(CGX_MODE_40G_C2M));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT):
+		set_mod_args(args, 40000, 0, 1, BIT_ULL(CGX_MODE_40G_CR4));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT):
+		set_mod_args(args, 40000, 0, 1, BIT_ULL(CGX_MODE_40G_KR4));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_50000baseSR_Full_BIT):
+		set_mod_args(args, 50000, 0, 0, BIT_ULL(CGX_MODE_50G_C2C));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_50000baseLR_ER_FR_Full_BIT):
+		set_mod_args(args, 50000, 0, 0, BIT_ULL(CGX_MODE_50G_C2M));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_50000baseCR_Full_BIT):
+		set_mod_args(args, 50000, 0, 1, BIT_ULL(CGX_MODE_50G_CR));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_50000baseKR_Full_BIT):
+		set_mod_args(args, 50000, 0, 1, BIT_ULL(CGX_MODE_50G_KR));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT):
+		set_mod_args(args, 100000, 0, 0, BIT_ULL(CGX_MODE_100G_C2C));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_100000baseLR4_ER4_Full_BIT):
+		set_mod_args(args, 100000, 0, 0, BIT_ULL(CGX_MODE_100G_C2M));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT):
+		set_mod_args(args, 100000, 0, 1, BIT_ULL(CGX_MODE_100G_CR4));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT):
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
@@ -886,13 +992,18 @@ int cgx_set_link_mode(void *cgxd, struct cgx_set_link_mode_args args,
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
 	err = cgx_fwi_cmd_generic(req, &resp, cgx, lmac_id);
 	return err;
 }
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
index 4a1f51c..b7bb0b9 100644
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

