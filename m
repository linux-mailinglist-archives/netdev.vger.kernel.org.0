Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 527782731CF
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 20:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbgIUSVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 14:21:09 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35278 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726456AbgIUSVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 14:21:09 -0400
X-Greylist: delayed 1406 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2020 14:21:05 EDT
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08LHucJV007726;
        Mon, 21 Sep 2020 10:57:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=F711FPe7POe25p3N+iRLudItEi1SxW0XB64EfMSTX3E=;
 b=j8j1U4ZdfeKACxot5mdsEABXNoqLc+9zyIEeKvbz1nRjuqr1Jdaz4wWM1eAxrF0YB+QV
 md9J7GYhp1LHmp62oJmZPuvL0yzGQdWzL312NgyD0r4eBAAsp1DhdGFYPJRmrLsAgiRu
 Ijp4RrtIlmPEAlfQwXFk5rw/P9xRQTCeyZPFLOX1pliLFm1FXrP5SA4aCxPskl1fhtNh
 PK6CyWi4+ko5Db0YlCg0kwZ3bhGzOq/gnKQz/j84HlxIXjvWkSPnUMxlzLYqKS0KGX+d
 B6L/GtkYMV4PzmS/HcwE3mKfds2sCwDxGbELPFPPq520/txZdms3yL+0j7DdCPQioYts og== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 33nhgn6tqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 10:57:37 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 21 Sep
 2020 10:57:35 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 21 Sep
 2020 10:57:35 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 21 Sep 2020 10:57:35 -0700
Received: from yoga.marvell.com (unknown [10.95.131.144])
        by maili.marvell.com (Postfix) with ESMTP id 208B13F703F;
        Mon, 21 Sep 2020 10:57:32 -0700 (PDT)
From:   Stanislaw Kardach <skardach@marvell.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
CC:     <kda@semihalf.com>, Stanislaw Kardach <skardach@marvell.com>
Subject: [PATCH net-next v2 3/3] octeontx2-af: add support for custom KPU entries
Date:   Mon, 21 Sep 2020 19:54:42 +0200
Message-ID: <20200921175442.16789-4-skardach@marvell.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200921175442.16789-1-skardach@marvell.com>
References: <20200921175442.16789-1-skardach@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-21_06:2020-09-21,2020-09-21 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ability to load a set of custom KPU entries via firmware APIs. This
allows for flexible support for custom protocol parsing and CAM matching.

The firmware file name is specified by a module parameter (kpu_profile)
to allow re-using the same kernel and initramfs package on nodes in
different parts of the network where support for different protocols is
required.

AF driver will attempt to load the profile from the firmware file and
verify if it can fit hardware capabilities. If not, it will revert to
the built-in profile.

Next it will read the maximum first KPU_MAX_CST_LT (2) custom entries
from the firmware image. Those will be later programmed at the top of
each KPU after the built-in profile entries have been programmed.
The built-in profile is amended to always contain KPU_MAX_CSR_LT first
no-match entries and AF driver will disable those in the KPU unless
custom profile is loaded.

By convention the custom entries should only utilize NPC_LT_Lx_CUSTOMy
LTYPEs to maintain interoperability with netdev driver.

In relation to MKEX profile, the order of load priority is as follows:

1. Profile in loaded KPU profile.
2. Profile defined by mkex_profile parameter.
3. Built-in MKEX profile.

Firmware image contains also a list of default protocol overrides to
allow for custom protocols to be used there. This allows to apply some
packet alignment fixups for custom protocols at the cost of HW protocol
checks.

Change-Id: I5e25485c9ac40edce4bf342740c712688fb4f266
Signed-off-by: Stanislaw Kardach <skardach@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/npc.h   |  36 ++++
 .../marvell/octeontx2/af/npc_profile.h        |  90 +++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   6 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   5 +
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   | 198 +++++++++++++++---
 5 files changed, 300 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 3b069f378b2a..8aeef8715504 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -323,6 +323,15 @@ struct npc_mcam_kex {
 	u64 intf_ld_flags[NPC_MAX_INTF][NPC_MAX_LD][NPC_MAX_LFL];
 } __packed;
 
+struct npc_kpu_fwdata {
+	int	entries;
+	/* What follows is:
+	 * struct npc_kpu_profile_cam[entries];
+	 * struct npc_kpu_profile_action[entries];
+	 */
+	u8	data[0];
+};
+
 struct npc_lt_def {
 	u8	ltype_mask;
 	u8	ltype_match;
@@ -356,4 +365,31 @@ struct npc_lt_def_cfg {
 	struct npc_lt_def	pck_iip4;
 };
 
+/* Loadable KPU profile firmware data */
+struct npc_kpu_profile_fwdata {
+/* strtoull of "kpuprof" with base:36 */
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
+	/* Default MKEX profile to be used with this KPU profile. Format is same as for the MKEX
+	 * profile to streamline processing.
+	 */
+	struct npc_mcam_kex	mkex;
+	/* LTYPE values for specific HW offloaded protocols. */
+	struct npc_lt_def_cfg	lt_def;
+	/* Dynamically sized data:
+	 *  Custom KPU CAM and ACTION configuration entries.
+	 * struct npc_kpu_fwdata kpu[kpus];
+	 */
+	u8	data[0];
+};
+
 #endif /* NPC_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index a67e9ed718e7..32720838122d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -11,7 +11,10 @@
 #ifndef NPC_PROFILE_H
 #define NPC_PROFILE_H
 
-#define NPC_KPU_PROFILE_VER    0x0000000100050000
+#define NPC_KPU_PROFILE_VER	0x0000000100050000
+#define NPC_KPU_VER_MAJ(ver)	(u16)(((ver) >> 32) & 0xFFFF)
+#define NPC_KPU_VER_MIN(ver)	(u16)(((ver) >> 16) & 0xFFFF)
+#define NPC_KPU_VER_PATCH(ver)	(u16)((ver) & 0xFFFF)
 
 #define NPC_IH_W		0x8000
 #define NPC_IH_UTAG		0x2000
@@ -424,6 +427,27 @@ enum NPC_ERRLEV_E {
 	NPC_ERRLEV_ENUM_LAST = 16,
 };
 
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
 static const struct npc_kpu_profile_action ikpu_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
@@ -1004,6 +1028,8 @@ static const struct npc_kpu_profile_action ikpu_action_entries[] = {
 };
 
 static const struct npc_kpu_profile_cam kpu1_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU1_ETHER, 0xff,
 		NPC_ETYPE_IP,
@@ -1673,6 +1699,8 @@ static const struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 };
 
 static const struct npc_kpu_profile_cam kpu2_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU2_CTAG, 0xff,
 		NPC_ETYPE_IP,
@@ -2801,6 +2829,8 @@ static const struct npc_kpu_profile_cam kpu2_cam_entries[] = {
 };
 
 static const struct npc_kpu_profile_cam kpu3_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU3_CTAG, 0xff,
 		NPC_ETYPE_IP,
@@ -3920,6 +3950,8 @@ static const struct npc_kpu_profile_cam kpu3_cam_entries[] = {
 };
 
 static const struct npc_kpu_profile_cam kpu4_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU4_MPLS, 0xff,
 		NPC_MPLS_S,
@@ -4013,6 +4045,8 @@ static const struct npc_kpu_profile_cam kpu4_cam_entries[] = {
 };
 
 static const struct npc_kpu_profile_cam kpu5_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU5_IP, 0xff,
 		0x0000,
@@ -4583,6 +4617,8 @@ static const struct npc_kpu_profile_cam kpu5_cam_entries[] = {
 };
 
 static const struct npc_kpu_profile_cam kpu6_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU6_IP6_EXT, 0xff,
 		0x0000,
@@ -4928,6 +4964,8 @@ static const struct npc_kpu_profile_cam kpu6_cam_entries[] = {
 };
 
 static const struct npc_kpu_profile_cam kpu7_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU7_IP6_EXT, 0xff,
 		0x0000,
@@ -5147,6 +5185,8 @@ static const struct npc_kpu_profile_cam kpu7_cam_entries[] = {
 };
 
 static const struct npc_kpu_profile_cam kpu8_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU8_TCP, 0xff,
 		0x0000,
@@ -5879,6 +5919,8 @@ static const struct npc_kpu_profile_cam kpu8_cam_entries[] = {
 };
 
 static const struct npc_kpu_profile_cam kpu9_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU9_TU_MPLS_IN_GRE, 0xff,
 		NPC_MPLS_S,
@@ -6341,6 +6383,8 @@ static const struct npc_kpu_profile_cam kpu9_cam_entries[] = {
 };
 
 static const struct npc_kpu_profile_cam kpu10_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU10_TU_MPLS, 0xff,
 		NPC_MPLS_S,
@@ -6506,6 +6550,8 @@ static const struct npc_kpu_profile_cam kpu10_cam_entries[] = {
 };
 
 static const struct npc_kpu_profile_cam kpu11_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU11_TU_ETHER, 0xff,
 		NPC_ETYPE_IP,
@@ -6815,6 +6861,8 @@ static const struct npc_kpu_profile_cam kpu11_cam_entries[] = {
 };
 
 static const struct npc_kpu_profile_cam kpu12_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU12_TU_IP, 0xff,
 		NPC_IPNH_TCP,
@@ -7070,6 +7118,8 @@ static const struct npc_kpu_profile_cam kpu12_cam_entries[] = {
 };
 
 static const struct npc_kpu_profile_cam kpu13_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU13_TU_IP6_EXT, 0xff,
 		0x0000,
@@ -7082,6 +7132,8 @@ static const struct npc_kpu_profile_cam kpu13_cam_entries[] = {
 };
 
 static const struct npc_kpu_profile_cam kpu14_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU14_TU_IP6_EXT, 0xff,
 		0x0000,
@@ -7094,6 +7146,8 @@ static const struct npc_kpu_profile_cam kpu14_cam_entries[] = {
 };
 
 static const struct npc_kpu_profile_cam kpu15_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU15_TU_TCP, 0xff,
 		0x0000,
@@ -7295,6 +7349,8 @@ static const struct npc_kpu_profile_cam kpu15_cam_entries[] = {
 };
 
 static const struct npc_kpu_profile_cam kpu16_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU16_TCP_DATA, 0xff,
 		0x0000,
@@ -7352,6 +7408,8 @@ static const struct npc_kpu_profile_cam kpu16_cam_entries[] = {
 };
 
 static const struct npc_kpu_profile_action kpu1_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 3, 0,
@@ -7969,6 +8027,8 @@ static const struct npc_kpu_profile_action kpu1_action_entries[] = {
 };
 
 static const struct npc_kpu_profile_action kpu2_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 2, 0,
@@ -8972,6 +9032,8 @@ static const struct npc_kpu_profile_action kpu2_action_entries[] = {
 };
 
 static const struct npc_kpu_profile_action kpu3_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 1, 0,
@@ -9967,6 +10029,8 @@ static const struct npc_kpu_profile_action kpu3_action_entries[] = {
 };
 
 static const struct npc_kpu_profile_action kpu4_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 0,
@@ -10050,6 +10114,8 @@ static const struct npc_kpu_profile_action kpu4_action_entries[] = {
 };
 
 static const struct npc_kpu_profile_action kpu5_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_LC, NPC_EC_IP_TTL_0,
 		0, 0, 0, 0, 1,
@@ -10557,6 +10623,8 @@ static const struct npc_kpu_profile_action kpu5_action_entries[] = {
 };
 
 static const struct npc_kpu_profile_action kpu6_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 1,
@@ -10864,6 +10932,8 @@ static const struct npc_kpu_profile_action kpu6_action_entries[] = {
 };
 
 static const struct npc_kpu_profile_action kpu7_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 1,
@@ -11059,6 +11129,8 @@ static const struct npc_kpu_profile_action kpu7_action_entries[] = {
 };
 
 static const struct npc_kpu_profile_action kpu8_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_LD, NPC_EC_TCP_FLAGS_FIN_ONLY,
 		0, 0, 0, 0, 1,
@@ -11710,6 +11782,8 @@ static const struct npc_kpu_profile_action kpu8_action_entries[] = {
 };
 
 static const struct npc_kpu_profile_action kpu9_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 0,
@@ -12121,6 +12195,8 @@ static const struct npc_kpu_profile_action kpu9_action_entries[] = {
 };
 
 static const struct npc_kpu_profile_action kpu10_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 1, 0,
@@ -12268,6 +12344,8 @@ static const struct npc_kpu_profile_action kpu10_action_entries[] = {
 };
 
 static const struct npc_kpu_profile_action kpu11_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 0, 0,
@@ -12543,6 +12621,8 @@ static const struct npc_kpu_profile_action kpu11_action_entries[] = {
 };
 
 static const struct npc_kpu_profile_action kpu12_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		2, 12, 0, 2, 0,
@@ -12770,6 +12850,8 @@ static const struct npc_kpu_profile_action kpu12_action_entries[] = {
 };
 
 static const struct npc_kpu_profile_action kpu13_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 1,
@@ -12781,6 +12863,8 @@ static const struct npc_kpu_profile_action kpu13_action_entries[] = {
 };
 
 static const struct npc_kpu_profile_action kpu14_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 1,
@@ -12792,6 +12876,8 @@ static const struct npc_kpu_profile_action kpu14_action_entries[] = {
 };
 
 static const struct npc_kpu_profile_action kpu15_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_LG, NPC_EC_TCP_FLAGS_FIN_ONLY,
 		0, 0, 0, 0, 1,
@@ -12971,6 +13057,8 @@ static const struct npc_kpu_profile_action kpu15_action_entries[] = {
 };
 
 static const struct npc_kpu_profile_action kpu16_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 1,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index c3ef73ae782c..a737f61662dd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -55,6 +55,10 @@ static char *mkex_profile; /* MKEX profile name */
 module_param(mkex_profile, charp, 0000);
 MODULE_PARM_DESC(mkex_profile, "MKEX profile name string");
 
+static char *kpu_profile; /* KPU profile name */
+module_param(kpu_profile, charp, 0000);
+MODULE_PARM_DESC(kpu_profile, "KPU profile name string");
+
 static void rvu_setup_hw_capabilities(struct rvu *rvu)
 {
 	struct rvu_hwinfo *hw = rvu->hw;
@@ -2524,6 +2528,8 @@ static void rvu_update_module_params(struct rvu *rvu)
 
 	strscpy(rvu->mkex_pfl_name,
 		mkex_profile ? mkex_profile : default_pfl_name, MKEX_NAME_LEN);
+	strscpy(rvu->kpu_pfl_name,
+		kpu_profile ? kpu_profile : default_pfl_name, KPU_NAME_LEN);
 }
 
 static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 80adf0d2bd1c..95e3b5131c0e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -15,6 +15,7 @@
 #include "rvu_struct.h"
 #include "common.h"
 #include "mbox.h"
+#include "npc.h"
 
 /* PCI device IDs */
 #define	PCI_DEVID_OCTEONTX2_RVU_AF		0xA065
@@ -300,6 +301,7 @@ struct npc_kpu_profile_adapter {
 	const struct npc_lt_def_cfg	*lt_def;
 	const struct npc_kpu_profile_action	*ikpu; /* array[pkinds] */
 	const struct npc_kpu_profile	*kpu; /* array[kpus] */
+	struct npc_kpu_profile		*cst_kpu; /* array[kpus] */
 	const struct npc_mcam_kex	*mkex;
 	size_t				pkinds;
 	size_t				kpus;
@@ -349,9 +351,12 @@ struct rvu {
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
index 0abe5fd12131..1ee390991846 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -11,6 +11,8 @@
 #include <linux/bitfield.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/firmware.h>
+#include <linux/stddef.h>
 
 #include "rvu_struct.h"
 #include "rvu_reg.h"
@@ -723,12 +725,22 @@ void rvu_npc_disable_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 static void npc_program_mkex_profile(struct rvu *rvu, int blkaddr,
 				     const struct npc_mcam_kex *mkex)
 {
+	u64 nibble_ena, rx_kex, tx_kex;
 	int lid, lt, ld, fl;
 
-	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_RX),
-		    mkex->keyx_cfg[NIX_INTF_RX]);
-	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_TX),
-		    mkex->keyx_cfg[NIX_INTF_TX]);
+	rx_kex = mkex->keyx_cfg[NIX_INTF_RX];
+	tx_kex = mkex->keyx_cfg[NIX_INTF_TX];
+	nibble_ena = FIELD_GET(NPC_PARSE_NIBBLE, rx_kex);
+	/* Due to an errata (35786) in A0/B0 pass silicon, parse nibble enable
+	 * configuration has to be identical for both Rx and Tx interfaces.
+	 */
+	if (is_rvu_96xx_B0(rvu)) {
+		tx_kex &= ~NPC_PARSE_NIBBLE;
+		tx_kex |= FIELD_PREP(NPC_PARSE_NIBBLE, nibble_ena);
+	}
+
+	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_RX), rx_kex);
+	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_TX), tx_kex);
 
 	for (ld = 0; ld < NPC_MAX_LD; ld++)
 		rvu_write64(rvu, blkaddr, NPC_AF_KEX_LDATAX_FLAGS_CFG(ld),
@@ -771,8 +783,14 @@ static void npc_load_mkex_profile(struct rvu *rvu, int blkaddr,
 	void *mkex_prfl_addr = NULL;
 	u64 prfl_addr, prfl_sz;
 
+	/* Order of precedence (high to low):
+	 * 1. Embedded in custom KPU profile firmware via kpu_profile param.
+	 * 2. Via mkex_profile, loaded from ATF if KPU profile wasn't loaded.
+	 * 3. Built-in KEX profile from npc_mkex_default.
+	 */
 	/* If user not selected mkex profile */
-	if (!strncmp(mkex_profile, def_pfl_name, MKEX_NAME_LEN))
+	if (rvu->kpu_fwdata_sz ||
+	    !strncmp(mkex_profile, def_pfl_name, MKEX_NAME_LEN))
 		goto program_mkex;
 
 	if (!rvu->fwdata)
@@ -793,13 +811,7 @@ static void npc_load_mkex_profile(struct rvu *rvu, int blkaddr,
 		/* Compare with mkex mod_param name string */
 		if (mcam_kex->mkex_sign == MKEX_SIGN &&
 		    !strncmp(mcam_kex->name, mkex_profile, MKEX_NAME_LEN)) {
-			/* Due to an errata (35786) in A0/B0 pass silicon,
-			 * parse nibble enable configuration has to be
-			 * identical for both Rx and Tx interfaces.
-			 */
-			if (!is_rvu_96xx_B0(rvu) ||
-			    mcam_kex->keyx_cfg[NIX_INTF_RX] == mcam_kex->keyx_cfg[NIX_INTF_TX])
-				rvu->kpu.mkex = mcam_kex;
+			rvu->kpu.mkex = mcam_kex;
 			goto program_mkex;
 		}
 
@@ -910,11 +922,21 @@ static void npc_program_kpu_profile(struct rvu *rvu, int blkaddr, int kpu,
 	for (entry = 0; entry < num_entries; entry++)
 		npc_config_kpuaction(rvu, blkaddr, &profile->action[entry],
 				     kpu, entry, false);
+}
+
+static void npc_enable_kpu_profile(struct rvu *rvu, int blkaddr, int kpu,
+				   const struct npc_kpu_profile *profile)
+{
+	int num_entries;
+	u64 entry_mask;
 
-	/* Enable all programmed entries */
 	num_entries = min_t(int, profile->action_entries, profile->cam_entries);
+	entry_mask = enable_mask(num_entries);
+	/* Disable first KPU_MAX_CST_ENT entries for built-in profile */
+	if (!rvu->kpu.cst_kpu)
+		entry_mask |= GENMASK_ULL(KPU_MAX_CST_ENT - 1, 0);
 	rvu_write64(rvu, blkaddr,
-		    NPC_AF_KPUX_ENTRY_DISX(kpu, 0), enable_mask(num_entries));
+		    NPC_AF_KPUX_ENTRY_DISX(kpu, 0), entry_mask);
 	if (num_entries > 64) {
 		rvu_write64(rvu, blkaddr,
 			    NPC_AF_KPUX_ENTRY_DISX(kpu, 1),
@@ -927,6 +949,7 @@ static void npc_program_kpu_profile(struct rvu *rvu, int blkaddr, int kpu,
 
 static int npc_prepare_default_kpu(struct npc_kpu_profile_adapter *profile)
 {
+	profile->cst_kpu = NULL;
 	profile->name = def_pfl_name;
 	profile->version = NPC_KPU_PROFILE_VER;
 	profile->ikpu = ikpu_action_entries;
@@ -939,10 +962,126 @@ static int npc_prepare_default_kpu(struct npc_kpu_profile_adapter *profile)
 	return 0;
 }
 
+static int npc_apply_custom_kpu(struct rvu *rvu, struct npc_kpu_profile_adapter *profile)
+{
+	size_t hdr_sz = sizeof(struct npc_kpu_profile_fwdata), offset = 0;
+	struct npc_kpu_profile_fwdata *fw = rvu->kpu_fwdata;
+	struct npc_kpu_profile_action *action;
+	struct npc_kpu_profile_cam *cam;
+	struct npc_kpu_fwdata *fw_kpu;
+	u16 kpu, entry;
+	int entries;
+
+	if (rvu->kpu_fwdata_sz < hdr_sz) {
+		dev_warn(rvu->dev, "Invalid KPU profile size\n");
+		return -EINVAL;
+	}
+	if (le64_to_cpu(fw->signature) != KPU_SIGN) {
+		dev_warn(rvu->dev, "Invalid KPU profile signature %llx\n",
+			 le64_to_cpu(fw->signature));
+		return -EINVAL;
+	}
+	profile->name = fw->name;
+	profile->version = le64_to_cpu(fw->version);
+	profile->mkex = &fw->mkex;
+
+	/* Verify if the using known profile structure */
+	if (NPC_KPU_VER_MAJ(profile->version) >
+	    NPC_KPU_VER_MAJ(NPC_KPU_PROFILE_VER)) {
+		dev_warn(rvu->dev, "Not supported Major version: %d > %d\n",
+			 NPC_KPU_VER_MAJ(profile->version), NPC_KPU_VER_MAJ(NPC_KPU_PROFILE_VER));
+		return -EINVAL;
+	}
+	/* Verify if profile fits the HW */
+	if (fw->kpus > profile->kpus) {
+		dev_warn(rvu->dev, "Not enough KPUs: %d > %ld\n", fw->kpus, profile->kpus);
+		return -EINVAL;
+	}
+	/* Update adapter structure and ensure endianness where needed. */
+	profile->lt_def = &fw->lt_def;
+
+	for (kpu = 0; kpu < fw->kpus; kpu++) {
+		if (rvu->kpu_fwdata_sz < hdr_sz + offset) {
+			dev_warn(rvu->dev, "Profile size mismatch on KPU%i parsing.\n", kpu + 1);
+			return -EINVAL;
+		}
+		fw_kpu = (struct npc_kpu_fwdata *)(fw->data + offset);
+		if (fw_kpu->entries > KPU_MAX_CST_ENT)
+			dev_warn(rvu->dev, "Too many custom entries on KPU%d: %d > %d\n", kpu,
+				 fw_kpu->entries, KPU_MAX_CST_ENT);
+		entries = min(fw_kpu->entries, KPU_MAX_CST_ENT);
+		cam = (struct npc_kpu_profile_cam *)fw_kpu->data;
+		offset += sizeof(*fw_kpu) + fw_kpu->entries * sizeof(*cam);
+		action = (struct npc_kpu_profile_action *)(fw->data + offset);
+		offset += fw_kpu->entries * sizeof(*action);
+		/* Fix endianness */
+		for (entry = 0; entry < entries; entry++) {
+			cam[entry].dp0 = le16_to_cpu((__force __le16)cam[entry].dp0);
+			cam[entry].dp0_mask = le16_to_cpu((__force __le16)cam[entry].dp0_mask);
+			cam[entry].dp1 = le16_to_cpu((__force __le16)cam[entry].dp1);
+			cam[entry].dp1_mask = le16_to_cpu((__force __le16)cam[entry].dp1_mask);
+			cam[entry].dp2 = le16_to_cpu((__force __le16)cam[entry].dp2);
+			cam[entry].dp2_mask = le16_to_cpu((__force __le16)cam[entry].dp2_mask);
+		}
+	}
+
+	profile->cst_kpu = kcalloc(fw->kpus, sizeof(struct npc_kpu_profile), GFP_KERNEL);
+	if (!profile->cst_kpu)
+		return -ENOMEM;
+	/* Update the adapter after all data is validated and ready */
+	for (kpu = 0; kpu < fw->kpus; kpu++) {
+		fw_kpu = (struct npc_kpu_fwdata *)(fw->data + offset);
+		entries = min(fw_kpu->entries, KPU_MAX_CST_ENT);
+		cam = (struct npc_kpu_profile_cam *)fw_kpu->data;
+		offset += sizeof(*fw_kpu) + fw_kpu->entries * sizeof(*cam);
+		action = (struct npc_kpu_profile_action *)(fw->data + offset);
+		offset += fw_kpu->entries * sizeof(*action);
+		profile->cst_kpu[kpu].cam_entries = entries;
+		profile->cst_kpu[kpu].action_entries = entries;
+		profile->cst_kpu[kpu].cam = cam;
+		profile->cst_kpu[kpu].action = action;
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
+	dev_info(rvu->dev, "Loading KPU profile from firmware: %s\n", kpu_profile);
+	if (!request_firmware(&fw, kpu_profile, rvu->dev)) {
+		rvu->kpu_fwdata = kzalloc(fw->size, GFP_KERNEL);
+		if (rvu->kpu_fwdata) {
+			memcpy(rvu->kpu_fwdata, fw->data, fw->size);
+			rvu->kpu_fwdata_sz = fw->size;
+		}
+	}
+	release_firmware(fw);
+
+	/* Apply profile customization if firmware was loaded. */
+	if (!rvu->kpu_fwdata_sz || npc_apply_custom_kpu(rvu, profile)) {
+		dev_warn(rvu->dev, "Can't load KPU profile %s. Using default.\n", kpu_profile);
+		kfree(rvu->kpu_fwdata);
+		rvu->kpu_fwdata = NULL;
+		goto revert_to_default;
+	}
+
+	dev_info(rvu->dev, "Using custom profile '%s', version %d.%d.%d\n", profile->name,
+		 NPC_KPU_VER_MAJ(profile->version), NPC_KPU_VER_MIN(profile->version),
+		 NPC_KPU_VER_PATCH(profile->version));
 
+	return;
+
+revert_to_default:
 	npc_prepare_default_kpu(profile);
 }
 
@@ -982,8 +1121,12 @@ static void npc_parser_profile_init(struct rvu *rvu, int blkaddr)
 	num_kpus = rvu->kpu.kpus;
 	num_kpus = min_t(int, hw->npc_kpus, num_kpus);
 
-	for (idx = 0; idx < num_kpus; idx++)
+	for (idx = 0; idx < num_kpus; idx++) {
 		npc_program_kpu_profile(rvu, blkaddr, idx, &rvu->kpu.kpu[idx]);
+		if (rvu->kpu.cst_kpu)
+			npc_program_kpu_profile(rvu, blkaddr, idx, &rvu->kpu.cst_kpu[idx]);
+		npc_enable_kpu_profile(rvu, blkaddr, idx, &rvu->kpu.kpu[idx]);
+	}
 }
 
 static int npc_mcam_rsrcs_init(struct rvu *rvu, int blkaddr)
@@ -1111,8 +1254,8 @@ int rvu_npc_init(struct rvu *rvu)
 	struct npc_kpu_profile_adapter *kpu = &rvu->kpu;
 	struct npc_pkind *pkind = &rvu->hw->pkind;
 	struct npc_mcam *mcam = &rvu->hw->mcam;
-	u64 cfg, nibble_ena, rx_kex, tx_kex;
 	int blkaddr, entry, bank, err;
+	u64 cfg;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
 	if (blkaddr < 0) {
@@ -1168,29 +1311,14 @@ int rvu_npc_init(struct rvu *rvu)
 		    BIT_ULL(32) | BIT_ULL(24) | BIT_ULL(6) |
 		    BIT_ULL(2) | BIT_ULL(1));
 
-	/* Set RX and TX side MCAM search key size.
-	 * LA..LD (ltype only) + Channel
-	 */
-	rx_kex = npc_mkex_default.keyx_cfg[NIX_INTF_RX];
-	tx_kex = npc_mkex_default.keyx_cfg[NIX_INTF_TX];
-	nibble_ena = FIELD_GET(NPC_PARSE_NIBBLE, rx_kex);
-	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_RX), rx_kex);
-	/* Due to an errata (35786) in A0 pass silicon, parse nibble enable
-	 * configuration has to be identical for both Rx and Tx interfaces.
-	 */
-	if (is_rvu_96xx_B0(rvu)) {
-		tx_kex &= ~NPC_PARSE_NIBBLE;
-		tx_kex |= FIELD_PREP(NPC_PARSE_NIBBLE, nibble_ena);
-	}
-	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_TX), tx_kex);
+	/* Configure MKEX profile */
+	npc_load_mkex_profile(rvu, blkaddr, rvu->mkex_pfl_name);
 
+	/* Setup MCAM based on MKEX configuration. */
 	err = npc_mcam_rsrcs_init(rvu, blkaddr);
 	if (err)
 		return err;
 
-	/* Configure MKEX profile */
-	npc_load_mkex_profile(rvu, blkaddr, rvu->mkex_pfl_name);
-
 	/* Set TX miss action to UCAST_DEFAULT i.e
 	 * transmit the packet on NIX LF SQ's default channel.
 	 */
@@ -1215,6 +1343,8 @@ void rvu_npc_freemem(struct rvu *rvu)
 
 	kfree(pkind->rsrc.bmap);
 	kfree(mcam->counters.bmap);
+	kfree(rvu->kpu.cst_kpu);
+	kfree(rvu->kpu_fwdata);
 	mutex_destroy(&mcam->lock);
 }
 
-- 
2.20.1

