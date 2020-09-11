Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34804266289
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 17:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgIKPw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 11:52:26 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:46892 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726522AbgIKPwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:52:08 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08BDJhIp027643;
        Fri, 11 Sep 2020 06:21:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=x1nxVOoE3iWdnI+JTQRO30iYjrDWnhIfX7f5usvKTSU=;
 b=B+qsJlV+Xqts675ngZG+R5PgOkk2zO+hzBZDKt2phcNimNa0tGr8hH1hDqWvzdQ5sSm2
 pay7aSWc4B+WmW7z40FCVT6cf1o7ERlgzAXDXTiBOZ63SLHmqcz9kjDWTDugG7gxUsna
 alcEHqCrCU3qgsngA7LjMYjDSrlEDmdn26hFqNZqMgCsJZFu4DojKqw9SJknWDabxenY
 X3MLaGJapOLMbA3K4NTW7Hsw6mpWWYDI79DsEZSryHdz1e6EjZzL56TFk5iwuemsXqjS
 4bOsLMWqUSm5JdPYb1GD8E8iNQT+sfDfmOIi9s4EGI52WIE8JNR1eiifP+W6f69wt8ie Zw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 33c81q9awf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 11 Sep 2020 06:21:41 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Sep
 2020 06:21:40 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Sep
 2020 06:21:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 11 Sep 2020 06:21:39 -0700
Received: from yoga.marvell.com (unknown [10.95.131.64])
        by maili.marvell.com (Postfix) with ESMTP id C8DCF3F7045;
        Fri, 11 Sep 2020 06:21:37 -0700 (PDT)
From:   <skardach@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
CC:     Stanislaw Kardach <skardach@marvell.com>
Subject: [PATCH net-next 3/3] octeontx2-af: add support for custom KPU entries
Date:   Fri, 11 Sep 2020 15:21:24 +0200
Message-ID: <20200911132124.7420-4-skardach@marvell.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200911132124.7420-1-skardach@marvell.com>
References: <20200911132124.7420-1-skardach@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-11_04:2020-09-10,2020-09-11 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stanislaw Kardach <skardach@marvell.com>

Add ability to load a set of custom KPU entries via firmware APIs. This
allows for flexible support for custom protocol parsing and CAM matching.

AF driver will attempt to load the profile from the firmware file and
verify if it can fit hardware capabilities. If not, it will revert to
the built-in profile.

Next it will replace the first KPU_MAX_CST_LT (2) entries in each KPU
in default profile with entries read from the firmware image.
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

Signed-off-by: Stanislaw Kardach <skardach@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/npc.h   |  40 ++++-
 .../marvell/octeontx2/af/npc_profile.h        |  90 +++++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   6 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   4 +
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   | 170 ++++++++++++++----
 5 files changed, 275 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 6bfb9a9d3003..fe164b85adfb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -148,7 +148,7 @@ struct npc_kpu_profile_cam {
 	u16 dp1_mask;
 	u16 dp2;
 	u16 dp2_mask;
-};
+} __packed;
 
 struct npc_kpu_profile_action {
 	u8 errlev;
@@ -168,7 +168,7 @@ struct npc_kpu_profile_action {
 	u8 mask;
 	u8 right;
 	u8 shift;
-};
+} __packed;
 
 struct npc_kpu_profile {
 	int cam_entries;
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
+} __packed;
+
 struct npc_lt_def {
 	u8	ltype_mask;
 	u8	ltype_match;
@@ -356,4 +365,31 @@ struct npc_lt_def_cfg {
 	struct npc_lt_def	pck_iip4;
 } __packed;
 
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
+} __packed;
+
 #endif /* NPC_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index 695c3b5c103e..6ba8be2e1d09 100644
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
 static struct npc_kpu_profile_action ikpu_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
@@ -1004,6 +1028,8 @@ static struct npc_kpu_profile_action ikpu_action_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU1_ETHER, 0xff,
 		NPC_ETYPE_IP,
@@ -1673,6 +1699,8 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu2_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU2_CTAG, 0xff,
 		NPC_ETYPE_IP,
@@ -2801,6 +2829,8 @@ static struct npc_kpu_profile_cam kpu2_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu3_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU3_CTAG, 0xff,
 		NPC_ETYPE_IP,
@@ -3920,6 +3950,8 @@ static struct npc_kpu_profile_cam kpu3_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu4_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU4_MPLS, 0xff,
 		NPC_MPLS_S,
@@ -4013,6 +4045,8 @@ static struct npc_kpu_profile_cam kpu4_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu5_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU5_IP, 0xff,
 		0x0000,
@@ -4583,6 +4617,8 @@ static struct npc_kpu_profile_cam kpu5_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu6_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU6_IP6_EXT, 0xff,
 		0x0000,
@@ -4928,6 +4964,8 @@ static struct npc_kpu_profile_cam kpu6_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu7_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU7_IP6_EXT, 0xff,
 		0x0000,
@@ -5147,6 +5185,8 @@ static struct npc_kpu_profile_cam kpu7_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu8_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU8_TCP, 0xff,
 		0x0000,
@@ -5879,6 +5919,8 @@ static struct npc_kpu_profile_cam kpu8_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu9_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU9_TU_MPLS_IN_GRE, 0xff,
 		NPC_MPLS_S,
@@ -6341,6 +6383,8 @@ static struct npc_kpu_profile_cam kpu9_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu10_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU10_TU_MPLS, 0xff,
 		NPC_MPLS_S,
@@ -6506,6 +6550,8 @@ static struct npc_kpu_profile_cam kpu10_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu11_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU11_TU_ETHER, 0xff,
 		NPC_ETYPE_IP,
@@ -6815,6 +6861,8 @@ static struct npc_kpu_profile_cam kpu11_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu12_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU12_TU_IP, 0xff,
 		NPC_IPNH_TCP,
@@ -7070,6 +7118,8 @@ static struct npc_kpu_profile_cam kpu12_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu13_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU13_TU_IP6_EXT, 0xff,
 		0x0000,
@@ -7082,6 +7132,8 @@ static struct npc_kpu_profile_cam kpu13_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu14_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU14_TU_IP6_EXT, 0xff,
 		0x0000,
@@ -7094,6 +7146,8 @@ static struct npc_kpu_profile_cam kpu14_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu15_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU15_TU_TCP, 0xff,
 		0x0000,
@@ -7295,6 +7349,8 @@ static struct npc_kpu_profile_cam kpu15_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu16_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	{
 		NPC_S_KPU16_TCP_DATA, 0xff,
 		0x0000,
@@ -7352,6 +7408,8 @@ static struct npc_kpu_profile_cam kpu16_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu1_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 3, 0,
@@ -7969,6 +8027,8 @@ static struct npc_kpu_profile_action kpu1_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu2_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 2, 0,
@@ -8972,6 +9032,8 @@ static struct npc_kpu_profile_action kpu2_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu3_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 1, 0,
@@ -9967,6 +10029,8 @@ static struct npc_kpu_profile_action kpu3_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu4_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 0,
@@ -10050,6 +10114,8 @@ static struct npc_kpu_profile_action kpu4_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu5_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_LC, NPC_EC_IP_TTL_0,
 		0, 0, 0, 0, 1,
@@ -10557,6 +10623,8 @@ static struct npc_kpu_profile_action kpu5_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu6_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 1,
@@ -10864,6 +10932,8 @@ static struct npc_kpu_profile_action kpu6_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu7_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 1,
@@ -11059,6 +11129,8 @@ static struct npc_kpu_profile_action kpu7_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu8_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_LD, NPC_EC_TCP_FLAGS_FIN_ONLY,
 		0, 0, 0, 0, 1,
@@ -11710,6 +11782,8 @@ static struct npc_kpu_profile_action kpu8_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu9_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 0,
@@ -12121,6 +12195,8 @@ static struct npc_kpu_profile_action kpu9_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu10_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 1, 0,
@@ -12268,6 +12344,8 @@ static struct npc_kpu_profile_action kpu10_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu11_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 0, 0,
@@ -12543,6 +12621,8 @@ static struct npc_kpu_profile_action kpu11_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu12_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		2, 12, 0, 2, 0,
@@ -12770,6 +12850,8 @@ static struct npc_kpu_profile_action kpu12_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu13_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 1,
@@ -12781,6 +12863,8 @@ static struct npc_kpu_profile_action kpu13_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu14_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		0, 0, 0, 0, 1,
@@ -12792,6 +12876,8 @@ static struct npc_kpu_profile_action kpu14_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu15_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	{
 		NPC_ERRLEV_LG, NPC_EC_TCP_FLAGS_FIN_ONLY,
 		0, 0, 0, 0, 1,
@@ -12971,6 +13057,8 @@ static struct npc_kpu_profile_action kpu15_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu16_action_entries[] = {
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
index 021f51e2f2f2..10f42f904fa6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -15,6 +15,7 @@
 #include "rvu_struct.h"
 #include "common.h"
 #include "mbox.h"
+#include "npc.h"
 
 /* PCI device IDs */
 #define	PCI_DEVID_OCTEONTX2_RVU_AF		0xA065
@@ -350,9 +351,12 @@ struct rvu {
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
index 6245a69a882b..dadc02233c8b 100644
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
@@ -723,12 +725,23 @@ void rvu_npc_disable_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 static void npc_program_mkex_profile(struct rvu *rvu, int blkaddr,
 				     struct npc_mcam_kex *mkex)
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
+		mkex->keyx_cfg[NIX_INTF_TX] = tx_kex;
+	}
+
+	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_RX), rx_kex);
+	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_TX), tx_kex);
 
 	for (ld = 0; ld < NPC_MAX_LD; ld++)
 		rvu_write64(rvu, blkaddr, NPC_AF_KEX_LDATAX_FLAGS_CFG(ld),
@@ -771,8 +784,14 @@ static void npc_load_mkex_profile(struct rvu *rvu, int blkaddr,
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
@@ -793,13 +812,7 @@ static void npc_load_mkex_profile(struct rvu *rvu, int blkaddr,
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
 
@@ -890,6 +903,7 @@ static void npc_program_kpu_profile(struct rvu *rvu, int blkaddr, int kpu,
 				    struct npc_kpu_profile *profile)
 {
 	int entry, num_entries, max_entries;
+	u64 entry_mask;
 
 	if (profile->cam_entries != profile->action_entries) {
 		dev_err(rvu->dev,
@@ -913,8 +927,12 @@ static void npc_program_kpu_profile(struct rvu *rvu, int blkaddr, int kpu,
 
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
@@ -940,10 +958,112 @@ static int npc_prepare_default_kpu(struct npc_kpu_profile_adapter *profile)
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
+	profile->custom = 1;
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
+		fw_kpu = (struct npc_kpu_fwdata *)(fw->data + offset);
+		if (fw_kpu->entries > KPU_MAX_CST_ENT)
+			dev_warn(rvu->dev, "Too many custom entries on KPU%d: %d > %d\n", kpu,
+				 fw_kpu->entries, KPU_MAX_CST_ENT);
+		entries = min(fw_kpu->entries, KPU_MAX_CST_ENT);
+		cam = (struct npc_kpu_profile_cam *)fw_kpu->data;
+		offset += sizeof(*fw_kpu) + fw_kpu->entries * sizeof(*cam);
+		action = (struct npc_kpu_profile_action *)(fw->data + offset);
+		offset += fw_kpu->entries * sizeof(*action);
+		if (rvu->kpu_fwdata_sz < hdr_sz + offset) {
+			dev_warn(rvu->dev, "Profile size mismatch on KPU%i parsing.\n", kpu + 1);
+			return -EINVAL;
+		}
+		/* Fix endianness and update */
+		for (entry = 0; entry < entries; entry++) {
+			cam[entry].dp0 = le16_to_cpu((__force __le16)cam[entry].dp0);
+			cam[entry].dp0_mask = le16_to_cpu((__force __le16)cam[entry].dp0_mask);
+			cam[entry].dp1 = le16_to_cpu((__force __le16)cam[entry].dp1);
+			cam[entry].dp1_mask = le16_to_cpu((__force __le16)cam[entry].dp1_mask);
+			cam[entry].dp2 = le16_to_cpu((__force __le16)cam[entry].dp2);
+			cam[entry].dp2_mask = le16_to_cpu((__force __le16)cam[entry].dp2_mask);
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
+
+	return;
 
+revert_to_default:
 	npc_prepare_default_kpu(profile);
 }
 
@@ -1112,8 +1232,8 @@ int rvu_npc_init(struct rvu *rvu)
 	struct npc_kpu_profile_adapter *kpu = &rvu->kpu;
 	struct npc_pkind *pkind = &rvu->hw->pkind;
 	struct npc_mcam *mcam = &rvu->hw->mcam;
-	u64 cfg, nibble_ena, rx_kex, tx_kex;
 	int blkaddr, entry, bank, err;
+	u64 cfg;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
 	if (blkaddr < 0) {
@@ -1169,29 +1289,14 @@ int rvu_npc_init(struct rvu *rvu)
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
@@ -1216,6 +1321,7 @@ void rvu_npc_freemem(struct rvu *rvu)
 
 	kfree(pkind->rsrc.bmap);
 	kfree(mcam->counters.bmap);
+	kfree(rvu->kpu_fwdata);
 	mutex_destroy(&mcam->lock);
 }
 
-- 
2.20.1

