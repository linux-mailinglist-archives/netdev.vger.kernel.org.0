Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B7F392B06
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 11:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236004AbhE0JqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 05:46:25 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46968 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235964AbhE0JqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 05:46:24 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14R9eEHv024940;
        Thu, 27 May 2021 02:44:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=zVlxlE5oWM/O7hI3n75Pk0yCsyYnfxT46HEjtUpw0qU=;
 b=jhzTtoEbW7aJQoEd6YJ7MthNJYNK5L7rdiFYNBCGemsep8XXdEhZaPxYiXfN+lTrYWOB
 13G8/75D7a0vxTyFEUU5WWrDEWiKjWHIA2ONyvXmUgLfa3hW/RpMrhBTuqjIcVUXjWK/
 q4zSRAlaQNN3/GMnKGc0v8Jgp3nHDh79b41HfeDHX/ObEA6G96kYNQ9Z6ICVpIZzHhEP
 W2lmaNwH9xU/mPd6kHABTsXG1SvyMzT/r6ixemMuW62d5kZrTcrOfHAh4yWQ5q1hzLtN
 rl49HqESa5+8iIYReBsef2GziunP+HoFHLfULpb24jeCJSl1wAQY32zrBvkcytt+CUc/ +Q== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 38sxpma6eh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 27 May 2021 02:44:47 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 27 May
 2021 02:44:44 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 27 May 2021 02:44:44 -0700
Received: from hyd1584.marvell.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id 00D523F703F;
        Thu, 27 May 2021 02:44:42 -0700 (PDT)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <gcherian@marvell.com>,
        <sgoutham@marvell.com>
Subject: [net-next PATCHv3 1/5] octeontx2-af: add support for custom KPU entries
Date:   Thu, 27 May 2021 15:14:35 +0530
Message-ID: <20210527094439.1910013-2-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210527094439.1910013-1-george.cherian@marvell.com>
References: <20210527094439.1910013-1-george.cherian@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: LtCEwgfd_RtJBTCRQ_HA3zvMCJjPij2t
X-Proofpoint-GUID: LtCEwgfd_RtJBTCRQ_HA3zvMCJjPij2t
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-27_04:2021-05-26,2021-05-27 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stanislaw Kardach <skardach@marvell.com>

Add ability to load a set of custom KPU entries. This
allows for flexible support for custom protocol parsing.

AF driver will attempt to load the profile and verify if it can fit
hardware capabilities. If not, it will revert to the built-in profile.

Next it will replace the first KPU_MAX_CST_LT (2) entries in each KPU
in default profile with entries read from the profile image.
The built-in profile should always contain KPU_MAX_CSR_LT first no-match
entries and AF driver will disable those in the KPU unless custom
profile is loaded.

Profile file contains also a list of default protocol overrides to
allow for custom protocols to be used there.

Signed-off-by: Stanislaw Kardach <skardach@marvell.com>
Signed-off-by: George Cherian <george.cherian@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/npc.h   |  44 ++++-
 .../marvell/octeontx2/af/npc_profile.h        | 156 ++++++++++++++----
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   6 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   4 +
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   | 116 ++++++++++++-
 5 files changed, 286 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 1e012e787260..6579ad19f684 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -213,7 +213,7 @@ struct npc_kpu_profile_cam {
 	u16 dp1_mask;
 	u16 dp2;
 	u16 dp2_mask;
-};
+} __packed;
 
 struct npc_kpu_profile_action {
 	u8 errlev;
@@ -233,13 +233,13 @@ struct npc_kpu_profile_action {
 	u8 mask;
 	u8 right;
 	u8 shift;
-};
+} __packed;
 
 struct npc_kpu_profile {
 	int cam_entries;
 	int action_entries;
-	const struct npc_kpu_profile_cam *cam;
-	const struct npc_kpu_profile_action *action;
+	struct npc_kpu_profile_cam *cam;
+	struct npc_kpu_profile_action *action;
 };
 
 /* NPC KPU register formats */
@@ -445,6 +445,15 @@ struct npc_mcam_kex {
 	u64 intf_ld_flags[NPC_MAX_INTF][NPC_MAX_LD][NPC_MAX_LFL];
 } __packed;
 
+struct npc_kpu_fwdata {
+	int	entries;
+	/* What follows is:
+	 * struct npc_kpu_profile_cam[entries];
+	 * struct npc_kpu_profile_action[entries];
+	 */
+	u8	data[0];
+} __packed;
+
 struct npc_lt_def {
 	u8	ltype_mask;
 	u8	ltype_match;
@@ -478,6 +487,33 @@ struct npc_lt_def_cfg {
 	struct npc_lt_def	pck_iip4;
 };
 
+/* Loadable KPU profile firmware data */
+struct npc_kpu_profile_fwdata {
+#define KPU_SIGN	0x00666f727075706b
+#define KPU_NAME_LEN	32
+/** Maximum number of custom KPU entries supported by the built-in profile. */
+#define KPU_MAX_CST_ENT	2
+	/* KPU Profle Header */
+	__le64	signature; /* "kpuprof\0" (8 bytes/ASCII characters) */
+	u8	name[KPU_NAME_LEN]; /* KPU Profile name */
+	__le64	version; /* KPU profile version */
+	u8	kpus;
+	u8	reserved[7];
+
+	/* Default MKEX profile to be used with this KPU profile. May be
+	 * overridden with mkex_profile module parameter. Format is same as for
+	 * the MKEX profile to streamline processing.
+	 */
+	struct npc_mcam_kex	mkex;
+	/* LTYPE values for specific HW offloaded protocols. */
+	struct npc_lt_def_cfg	lt_def;
+	/* Dynamically sized data:
+	 *  Custom KPU CAM and ACTION configuration entries.
+	 * struct npc_kpu_fwdata kpu[kpus];
+	 */
+	u8	data[0];
+} __packed;
+
 struct rvu_npc_mcam_rule {
 	struct flow_msg packet;
 	struct flow_msg mask;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index 5c372d2c24a1..de3a60c12392 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -11,7 +11,10 @@
 #ifndef NPC_PROFILE_H
 #define NPC_PROFILE_H
 
-#define NPC_KPU_PROFILE_VER    0x0000000100050000
+#define NPC_KPU_PROFILE_VER	0x0000000100050000
+#define NPC_KPU_VER_MAJ(ver)	((u16)(((ver) >> 32) & 0xFFFF))
+#define NPC_KPU_VER_MIN(ver)	((u16)(((ver) >> 16) & 0xFFFF))
+#define NPC_KPU_VER_PATCH(ver)	((u16)((ver) & 0xFFFF))
 
 #define NPC_IH_W		0x8000
 #define NPC_IH_UTAG		0x2000
@@ -442,7 +445,28 @@ enum NPC_ERRLEV_E {
 	NPC_ERRLEV_ENUM_LAST = 16,
 };
 
-static const struct npc_kpu_profile_action ikpu_action_entries[] = {
+#define NPC_KPU_NOP_CAM		\
+	{			\
+		NPC_S_NA, 0xff,	\
+		0x0000,		\
+		0x0000,		\
+		0x0000,		\
+		0x0000,		\
+		0x0000,		\
+		0x0000,		\
+	}
+
+#define NPC_KPU_NOP_ACTION			\
+	{					\
+		NPC_ERRLEV_RE, NPC_EC_NOERR,	\
+		0, 0, 0, 0, 0,			\
+		NPC_S_NA, 0, 0,			\
+		NPC_LID_LA, NPC_LT_NA,		\
+		0,				\
+		0, 0, 0, 0,			\
+	}
+
+static struct npc_kpu_profile_action ikpu_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		12, 16, 20, 0, 0,
@@ -1021,7 +1045,9 @@ static const struct npc_kpu_profile_action ikpu_action_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_cam kpu1_cam_entries[] = {
+static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU1_ETHER, 0xff,
 		NPC_ETYPE_IP,
@@ -1699,7 +1725,9 @@ static const struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_cam kpu2_cam_entries[] = {
+static struct npc_kpu_profile_cam kpu2_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU2_CTAG, 0xff,
 		NPC_ETYPE_IP,
@@ -2827,7 +2855,9 @@ static const struct npc_kpu_profile_cam kpu2_cam_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_cam kpu3_cam_entries[] = {
+static struct npc_kpu_profile_cam kpu3_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU3_CTAG, 0xff,
 		NPC_ETYPE_IP,
@@ -3946,7 +3976,9 @@ static const struct npc_kpu_profile_cam kpu3_cam_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_cam kpu4_cam_entries[] = {
+static struct npc_kpu_profile_cam kpu4_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU4_MPLS, 0xff,
 		NPC_MPLS_S,
@@ -4102,7 +4134,9 @@ static const struct npc_kpu_profile_cam kpu4_cam_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_cam kpu5_cam_entries[] = {
+static struct npc_kpu_profile_cam kpu5_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU5_IP, 0xff,
 		0x0000,
@@ -4672,7 +4706,9 @@ static const struct npc_kpu_profile_cam kpu5_cam_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_cam kpu6_cam_entries[] = {
+static struct npc_kpu_profile_cam kpu6_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU6_IP6_EXT, 0xff,
 		0x0000,
@@ -5017,7 +5053,9 @@ static const struct npc_kpu_profile_cam kpu6_cam_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_cam kpu7_cam_entries[] = {
+static struct npc_kpu_profile_cam kpu7_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU7_IP6_EXT, 0xff,
 		0x0000,
@@ -5236,7 +5274,9 @@ static const struct npc_kpu_profile_cam kpu7_cam_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_cam kpu8_cam_entries[] = {
+static struct npc_kpu_profile_cam kpu8_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU8_TCP, 0xff,
 		0x0000,
@@ -5977,7 +6017,9 @@ static const struct npc_kpu_profile_cam kpu8_cam_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_cam kpu9_cam_entries[] = {
+static struct npc_kpu_profile_cam kpu9_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU9_TU_MPLS_IN_GRE, 0xff,
 		NPC_MPLS_S,
@@ -6448,7 +6490,9 @@ static const struct npc_kpu_profile_cam kpu9_cam_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_cam kpu10_cam_entries[] = {
+static struct npc_kpu_profile_cam kpu10_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU10_TU_MPLS, 0xff,
 		NPC_MPLS_S,
@@ -6613,7 +6657,9 @@ static const struct npc_kpu_profile_cam kpu10_cam_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_cam kpu11_cam_entries[] = {
+static struct npc_kpu_profile_cam kpu11_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU11_TU_ETHER, 0xff,
 		NPC_ETYPE_IP,
@@ -6922,7 +6968,9 @@ static const struct npc_kpu_profile_cam kpu11_cam_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_cam kpu12_cam_entries[] = {
+static struct npc_kpu_profile_cam kpu12_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU12_TU_IP, 0xff,
 		NPC_IPNH_TCP,
@@ -7177,7 +7225,9 @@ static const struct npc_kpu_profile_cam kpu12_cam_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_cam kpu13_cam_entries[] = {
+static struct npc_kpu_profile_cam kpu13_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU13_TU_IP6_EXT, 0xff,
 		0x0000,
@@ -7189,7 +7239,9 @@ static const struct npc_kpu_profile_cam kpu13_cam_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_cam kpu14_cam_entries[] = {
+static struct npc_kpu_profile_cam kpu14_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU14_TU_IP6_EXT, 0xff,
 		0x0000,
@@ -7201,7 +7253,9 @@ static const struct npc_kpu_profile_cam kpu14_cam_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_cam kpu15_cam_entries[] = {
+static struct npc_kpu_profile_cam kpu15_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU15_TU_TCP, 0xff,
 		0x0000,
@@ -7402,7 +7456,9 @@ static const struct npc_kpu_profile_cam kpu15_cam_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_cam kpu16_cam_entries[] = {
+static struct npc_kpu_profile_cam kpu16_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU16_TCP_DATA, 0xff,
 		0x0000,
@@ -7459,7 +7515,9 @@ static const struct npc_kpu_profile_cam kpu16_cam_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_action kpu1_action_entries[] = {
+static struct npc_kpu_profile_action kpu1_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 3, 0,
@@ -8084,7 +8142,9 @@ static const struct npc_kpu_profile_action kpu1_action_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_action kpu2_action_entries[] = {
+static struct npc_kpu_profile_action kpu2_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 2, 0,
@@ -9087,7 +9147,9 @@ static const struct npc_kpu_profile_action kpu2_action_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_action kpu3_action_entries[] = {
+static struct npc_kpu_profile_action kpu3_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 1, 0,
@@ -10082,7 +10144,9 @@ static const struct npc_kpu_profile_action kpu3_action_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_action kpu4_action_entries[] = {
+static struct npc_kpu_profile_action kpu4_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 0,
@@ -10221,7 +10285,9 @@ static const struct npc_kpu_profile_action kpu4_action_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_action kpu5_action_entries[] = {
+static struct npc_kpu_profile_action kpu5_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_LC, NPC_EC_IP_TTL_0,
 		0, 0, 0, 0, 1,
@@ -10728,7 +10794,9 @@ static const struct npc_kpu_profile_action kpu5_action_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_action kpu6_action_entries[] = {
+static struct npc_kpu_profile_action kpu6_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 1,
@@ -11035,7 +11103,9 @@ static const struct npc_kpu_profile_action kpu6_action_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_action kpu7_action_entries[] = {
+static struct npc_kpu_profile_action kpu7_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 1,
@@ -11230,7 +11300,9 @@ static const struct npc_kpu_profile_action kpu7_action_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_action kpu8_action_entries[] = {
+static struct npc_kpu_profile_action kpu8_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_LD, NPC_EC_TCP_FLAGS_FIN_ONLY,
 		0, 0, 0, 0, 1,
@@ -11889,7 +11961,9 @@ static const struct npc_kpu_profile_action kpu8_action_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_action kpu9_action_entries[] = {
+static struct npc_kpu_profile_action kpu9_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 0,
@@ -12308,7 +12382,9 @@ static const struct npc_kpu_profile_action kpu9_action_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_action kpu10_action_entries[] = {
+static struct npc_kpu_profile_action kpu10_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 1, 0,
@@ -12455,7 +12531,9 @@ static const struct npc_kpu_profile_action kpu10_action_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_action kpu11_action_entries[] = {
+static struct npc_kpu_profile_action kpu11_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 0, 0,
@@ -12730,7 +12808,9 @@ static const struct npc_kpu_profile_action kpu11_action_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_action kpu12_action_entries[] = {
+static struct npc_kpu_profile_action kpu12_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		2, 12, 0, 2, 0,
@@ -12957,7 +13037,9 @@ static const struct npc_kpu_profile_action kpu12_action_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_action kpu13_action_entries[] = {
+static struct npc_kpu_profile_action kpu13_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 1,
@@ -12968,7 +13050,9 @@ static const struct npc_kpu_profile_action kpu13_action_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_action kpu14_action_entries[] = {
+static struct npc_kpu_profile_action kpu14_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 1,
@@ -12979,7 +13063,9 @@ static const struct npc_kpu_profile_action kpu14_action_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_action kpu15_action_entries[] = {
+static struct npc_kpu_profile_action kpu15_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_LG, NPC_EC_TCP_FLAGS_FIN_ONLY,
 		0, 0, 0, 0, 1,
@@ -13158,7 +13244,9 @@ static const struct npc_kpu_profile_action kpu15_action_entries[] = {
 	},
 };
 
-static const struct npc_kpu_profile_action kpu16_action_entries[] = {
+static struct npc_kpu_profile_action kpu16_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 1,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index ab24a5e8ee8a..bc71a9c462de 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -57,6 +57,10 @@ static char *mkex_profile; /* MKEX profile name */
 module_param(mkex_profile, charp, 0000);
 MODULE_PARM_DESC(mkex_profile, "MKEX profile name string");
 
+static char *kpu_profile; /* KPU profile name */
+module_param(kpu_profile, charp, 0000);
+MODULE_PARM_DESC(kpu_profile, "KPU profile name string");
+
 static void rvu_setup_hw_capabilities(struct rvu *rvu)
 {
 	struct rvu_hwinfo *hw = rvu->hw;
@@ -2842,6 +2846,8 @@ static void rvu_update_module_params(struct rvu *rvu)
 
 	strscpy(rvu->mkex_pfl_name,
 		mkex_profile ? mkex_profile : default_pfl_name, MKEX_NAME_LEN);
+	strscpy(rvu->kpu_pfl_name,
+		kpu_profile ? kpu_profile : default_pfl_name, KPU_NAME_LEN);
 }
 
 static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index c2cc4806d13c..fb142520e309 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -386,6 +386,7 @@ struct npc_kpu_profile_adapter {
 	const struct npc_kpu_profile_action	*ikpu; /* array[pkinds] */
 	const struct npc_kpu_profile	*kpu; /* array[kpus] */
 	struct npc_mcam_kex		*mkex;
+	bool				custom;
 	size_t				pkinds;
 	size_t				kpus;
 };
@@ -435,9 +436,12 @@ struct rvu {
 	struct mutex		cgx_cfg_lock; /* serialize cgx configuration */
 
 	char mkex_pfl_name[MKEX_NAME_LEN]; /* Configured MKEX profile name */
+	char kpu_pfl_name[KPU_NAME_LEN]; /* Configured KPU profile name */
 
 	/* Firmware data */
 	struct rvu_fwdata	*fwdata;
+	void			*kpu_fwdata;
+	size_t			kpu_fwdata_sz;
 
 	/* NPC KPU data */
 	struct npc_kpu_profile_adapter kpu;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 0bc4529691ec..254b768155cd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -1145,7 +1145,8 @@ static void npc_load_mkex_profile(struct rvu *rvu, int blkaddr,
 	u64 prfl_addr, prfl_sz;
 
 	/* If user not selected mkex profile */
-	if (!strncmp(mkex_profile, def_pfl_name, MKEX_NAME_LEN))
+	if (rvu->kpu_fwdata_sz ||
+	    !strncmp(mkex_profile, def_pfl_name, MKEX_NAME_LEN))
 		goto program_mkex;
 
 	if (!rvu->fwdata)
@@ -1263,6 +1264,7 @@ static void npc_program_kpu_profile(struct rvu *rvu, int blkaddr, int kpu,
 				    const struct npc_kpu_profile *profile)
 {
 	int entry, num_entries, max_entries;
+	u64 entry_mask;
 
 	if (profile->cam_entries != profile->action_entries) {
 		dev_err(rvu->dev,
@@ -1286,8 +1288,12 @@ static void npc_program_kpu_profile(struct rvu *rvu, int blkaddr, int kpu,
 
 	/* Enable all programmed entries */
 	num_entries = min_t(int, profile->action_entries, profile->cam_entries);
+	entry_mask = enable_mask(num_entries);
+	/* Disable first KPU_MAX_CST_ENT entries for built-in profile */
+	if (!rvu->kpu.custom)
+		entry_mask |= GENMASK_ULL(KPU_MAX_CST_ENT - 1, 0);
 	rvu_write64(rvu, blkaddr,
-		    NPC_AF_KPUX_ENTRY_DISX(kpu, 0), enable_mask(num_entries));
+		    NPC_AF_KPUX_ENTRY_DISX(kpu, 0), entry_mask);
 	if (num_entries > 64) {
 		rvu_write64(rvu, blkaddr,
 			    NPC_AF_KPUX_ENTRY_DISX(kpu, 1),
@@ -1300,6 +1306,7 @@ static void npc_program_kpu_profile(struct rvu *rvu, int blkaddr, int kpu,
 
 static int npc_prepare_default_kpu(struct npc_kpu_profile_adapter *profile)
 {
+	profile->custom = 0;
 	profile->name = def_pfl_name;
 	profile->version = NPC_KPU_PROFILE_VER;
 	profile->ikpu = ikpu_action_entries;
@@ -1312,10 +1319,114 @@ static int npc_prepare_default_kpu(struct npc_kpu_profile_adapter *profile)
 	return 0;
 }
 
+static int npc_apply_custom_kpu(struct rvu *rvu,
+				struct npc_kpu_profile_adapter *profile)
+{
+	size_t hdr_sz = sizeof(struct npc_kpu_profile_fwdata), offset = 0;
+	struct npc_kpu_profile_fwdata *fw = rvu->kpu_fwdata;
+	struct npc_kpu_profile_action *action;
+	struct npc_kpu_profile_cam *cam;
+	struct npc_kpu_fwdata *fw_kpu;
+	int entries;
+	u16 kpu, entry;
+
+	if (rvu->kpu_fwdata_sz < hdr_sz) {
+		dev_warn(rvu->dev, "Invalid KPU profile size\n");
+		return -EINVAL;
+	}
+	if (le64_to_cpu(fw->signature) != KPU_SIGN) {
+		dev_warn(rvu->dev, "Invalid KPU profile signature %llx\n",
+			 fw->signature);
+		return -EINVAL;
+	}
+	/* Verify if the using known profile structure */
+	if (NPC_KPU_VER_MAJ(profile->version) >
+	    NPC_KPU_VER_MAJ(NPC_KPU_PROFILE_VER)) {
+		dev_warn(rvu->dev, "Not supported Major version: %d > %d\n",
+			 NPC_KPU_VER_MAJ(profile->version),
+			 NPC_KPU_VER_MAJ(NPC_KPU_PROFILE_VER));
+		return -EINVAL;
+	}
+	/* Verify if profile fits the HW */
+	if (fw->kpus > profile->kpus) {
+		dev_warn(rvu->dev, "Not enough KPUs: %d > %ld\n", fw->kpus,
+			 profile->kpus);
+		return -EINVAL;
+	}
+
+	profile->custom = 1;
+	profile->name = fw->name;
+	profile->version = le64_to_cpu(fw->version);
+	profile->mkex = &fw->mkex;
+	profile->lt_def = &fw->lt_def;
+
+	for (kpu = 0; kpu < fw->kpus; kpu++) {
+		fw_kpu = (struct npc_kpu_fwdata *)(fw->data + offset);
+		if (fw_kpu->entries > KPU_MAX_CST_ENT)
+			dev_warn(rvu->dev,
+				 "Too many custom entries on KPU%d: %d > %d\n",
+				 kpu, fw_kpu->entries, KPU_MAX_CST_ENT);
+		entries = min(fw_kpu->entries, KPU_MAX_CST_ENT);
+		cam = (struct npc_kpu_profile_cam *)fw_kpu->data;
+		offset += sizeof(*fw_kpu) + fw_kpu->entries * sizeof(*cam);
+		action = (struct npc_kpu_profile_action *)(fw->data + offset);
+		offset += fw_kpu->entries * sizeof(*action);
+		if (rvu->kpu_fwdata_sz < hdr_sz + offset) {
+			dev_warn(rvu->dev,
+				 "Profile size mismatch on KPU%i parsing.\n",
+				 kpu + 1);
+			return -EINVAL;
+		}
+		for (entry = 0; entry < entries; entry++) {
+			profile->kpu[kpu].cam[entry] = cam[entry];
+			profile->kpu[kpu].action[entry] = action[entry];
+		}
+	}
+
+	return 0;
+}
+
 static void npc_load_kpu_profile(struct rvu *rvu)
 {
 	struct npc_kpu_profile_adapter *profile = &rvu->kpu;
+	const char *kpu_profile = rvu->kpu_pfl_name;
+	const struct firmware *fw = NULL;
+
+	/* If user not specified profile customization */
+	if (!strncmp(kpu_profile, def_pfl_name, KPU_NAME_LEN))
+		goto revert_to_default;
+	/* First prepare default KPU, then we'll customize top entries. */
+	npc_prepare_default_kpu(profile);
+
+	dev_info(rvu->dev, "Loading KPU profile from firmware: %s\n",
+		 kpu_profile);
+	if (!request_firmware(&fw, kpu_profile, rvu->dev)) {
+		rvu->kpu_fwdata = kzalloc(fw->size, GFP_KERNEL);
+		if (rvu->kpu_fwdata) {
+			memcpy(rvu->kpu_fwdata, fw->data, fw->size);
+			rvu->kpu_fwdata_sz = fw->size;
+		}
+		release_firmware(fw);
+	}
+
+	/* Apply profile customization if firmware was loaded. */
+	if (!rvu->kpu_fwdata_sz || npc_apply_custom_kpu(rvu, profile)) {
+		dev_warn(rvu->dev,
+			 "Can't load KPU profile %s. Using default.\n",
+			 kpu_profile);
+		kfree(rvu->kpu_fwdata);
+		rvu->kpu_fwdata = NULL;
+		goto revert_to_default;
+	}
+
+	dev_info(rvu->dev, "Using custom profile '%s', version %d.%d.%d\n",
+		 profile->name, NPC_KPU_VER_MAJ(profile->version),
+		 NPC_KPU_VER_MIN(profile->version),
+		 NPC_KPU_VER_PATCH(profile->version));
+
+	return;
 
+revert_to_default:
 	npc_prepare_default_kpu(profile);
 }
 
@@ -1654,6 +1765,7 @@ void rvu_npc_freemem(struct rvu *rvu)
 
 	kfree(pkind->rsrc.bmap);
 	kfree(mcam->counters.bmap);
+	kfree(rvu->kpu_fwdata);
 	mutex_destroy(&mcam->lock);
 }
 
-- 
2.25.1

