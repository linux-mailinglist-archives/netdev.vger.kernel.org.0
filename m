Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3802327C11D
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 11:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgI2J2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 05:28:49 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:15428 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727746AbgI2J2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 05:28:47 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08T9OhaO010922;
        Tue, 29 Sep 2020 02:28:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=NXRIG6tV7IG3i8bcmbvxD4fsTt4ISWiQ8uIwm2TLCQM=;
 b=FbinMDkOwb1b+mmyjpguVLbyaU0sbvpUt6CW7pONWcSZnZkGpT8Ad98a8eu732qoxFhL
 wk7ruKCnGzGWKyo13Lh3dCmsC2ApzMGDjBpTbF5TxKh/oYE00E4z+5hr+ToPWtYOTaas
 FlvIj8eU7y4fRQqhJrL32kK4DNoan2wkQRtrq2u5lHl48f45el680f14BpP7iEwi0Ogd
 gWUNOPFeruCjK7O6sIPWRn+DyONhx0qjwA3MRw3s+ZfPgN1LiFUHre7VPmjVD5mQO06+
 FswXM718dnYB0dcyCmnjjtM3oOmaVWJtTNxYw6ZWD0QcLkH8Wx5W9ABmD7+bA+VXU+Zg WA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 33teemb7xq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 02:28:44 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Sep
 2020 02:28:43 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 29 Sep 2020 02:28:44 -0700
Received: from yoga.marvell.com (unknown [10.95.131.226])
        by maili.marvell.com (Postfix) with ESMTP id 07E003F703F;
        Tue, 29 Sep 2020 02:28:41 -0700 (PDT)
From:   Stanislaw Kardach <skardach@marvell.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
CC:     <kda@semihalf.com>, Hariprasad Kelam <hkelam@marvell.com>
Subject: [PATCH net-next 3/7] octeontx2-af: add parser support for Forward DSA
Date:   Tue, 29 Sep 2020 11:28:16 +0200
Message-ID: <20200929092820.22487-4-skardach@marvell.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200929092820.22487-1-skardach@marvell.com>
References: <20200929092820.22487-1-skardach@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_01:2020-09-29,2020-09-29 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hkelam@marvell.com>

Marvell Prestera switches supports distributed switch architecture
by inserting Forward DSA tag of 4 bytes right after ethernet SMAC.
This tag don't have a tpid field.

This patch provides parser and extraction support for the same.
Default ldata extraction profile added for FDSA such that Src_port
is extracted and placed inplace of vlanid field. Like extended DSA
and eDSA tags,a special PKIND of 62 is used for this tag.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Acked-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/npc.h   |   1 +
 .../marvell/octeontx2/af/npc_profile.h        | 144 ++++++++++++++++++
 2 files changed, 145 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 3b069f378b2a..e465da97598f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -49,6 +49,7 @@ enum npc_kpu_lb_ltype {
 	NPC_LT_LB_EDSA_VLAN,
 	NPC_LT_LB_EXDSA,
 	NPC_LT_LB_EXDSA_VLAN,
+	NPC_LT_LB_FDSA,
 	NPC_LT_LB_CUSTOM0 = 0xE,
 	NPC_LT_LB_CUSTOM1 = 0xF,
 };
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index a67e9ed718e7..adc94bab9cba 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -139,6 +139,7 @@
 
 #define NPC_DSA_EXTEND		0x1000
 #define NPC_DSA_EDSA		0x8000
+#define NPC_DSA_FDSA		0xc000
 
 #define NPC_KEXOF_DMAC	8
 #define MKEX_SIGN	0x19bbfdbd15f /* strtoull of "mkexprof" with base:36 */
@@ -172,6 +173,7 @@ enum npc_kpu_parser_state {
 	NPC_S_KPU3_DSA,
 	NPC_S_KPU4_MPLS,
 	NPC_S_KPU4_NSH,
+	NPC_S_KPU4_FDSA,
 	NPC_S_KPU5_IP,
 	NPC_S_KPU5_IP6,
 	NPC_S_KPU5_ARP,
@@ -277,6 +279,7 @@ enum npc_kpu_lb_lflag {
 	NPC_F_LB_L_EDSA_VLAN,
 	NPC_F_LB_L_EXDSA,
 	NPC_F_LB_L_EXDSA_VLAN,
+	NPC_F_LB_L_FDSA,
 };
 
 enum npc_kpu_lc_uflag {
@@ -1364,6 +1367,15 @@ static const struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 		0x0000,
 	},
+	{
+		NPC_S_KPU1_EXDSA, 0xff,
+		NPC_DSA_FDSA,
+		NPC_DSA_FDSA,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+	},
 	{
 		NPC_S_KPU1_EXDSA, 0xff,
 		0x0000,
@@ -4001,6 +4013,68 @@ static const struct npc_kpu_profile_cam kpu4_cam_entries[] = {
 		0x0000,
 		0x0000,
 	},
+	{
+		NPC_S_KPU4_FDSA, 0xff,
+		NPC_ETYPE_IP,
+		0xffff,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+	},
+	{
+		NPC_S_KPU4_FDSA, 0xff,
+		NPC_ETYPE_IP6,
+		0xffff,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+	},
+	{
+		NPC_S_KPU4_FDSA, 0xff,
+		NPC_ETYPE_ARP,
+		0xffff,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+	},
+	{
+		NPC_S_KPU4_FDSA, 0xff,
+		NPC_ETYPE_RARP,
+		0xffff,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+	},
+	{
+		NPC_S_KPU4_FDSA, 0xff,
+		NPC_ETYPE_PTP,
+		0xffff,
+		0x0000,
+		0x0000,
+		0x0000,
+	},
+	{
+		NPC_S_KPU4_FDSA, 0xff,
+		NPC_ETYPE_FCOE,
+		0xffff,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+	},
+	{
+		NPC_S_KPU4_FDSA, 0xff,
+		0x0000,
+		NPC_DSA_FDSA,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+	},
 	{
 		NPC_S_NA, 0X00,
 		0x0000,
@@ -7678,6 +7752,14 @@ static const struct npc_kpu_profile_action kpu1_action_entries[] = {
 		0,
 		0, 0, 0, 0,
 	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		4, 8, 16, 2, 0,
+		NPC_S_KPU4_FDSA, 12, 1,
+		NPC_LID_LA, NPC_LT_LA_ETHER,
+		0,
+		0, 0, 0, 0,
+	},
 	{
 		NPC_ERRLEV_LA, NPC_EC_EDSA_UNK,
 		0, 0, 0, 0, 1,
@@ -10039,6 +10121,62 @@ static const struct npc_kpu_profile_action kpu4_action_entries[] = {
 		0,
 		0, 0, 0, 0,
 	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		8, 0, 6, 0, 0,
+		NPC_S_KPU5_IP, 6, 1,
+		NPC_LID_LB, NPC_LT_LB_FDSA,
+		NPC_F_LB_L_FDSA,
+		0, 0, 0, 0,
+	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		6, 0, 0, 0, 0,
+		NPC_S_KPU5_IP6, 6, 1,
+		NPC_LID_LB, NPC_LT_LB_FDSA,
+		NPC_F_LB_L_FDSA,
+		0, 0, 0, 0,
+	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		0, 0, 0, 0, 0,
+		NPC_S_KPU5_ARP, 6, 1,
+		NPC_LID_LB, NPC_LT_LB_FDSA,
+		NPC_F_LB_L_FDSA,
+		0, 0, 0, 0,
+	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		8, 0, 6, 0, 0,
+		NPC_S_KPU5_RARP, 6, 1,
+		NPC_LID_LB, NPC_LT_LB_FDSA,
+		NPC_F_LB_L_FDSA,
+		0, 0, 0, 0,
+	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		6, 0, 0, 0, 0,
+		NPC_S_KPU5_PTP, 6, 1,
+		NPC_LID_LB, NPC_LT_LB_FDSA,
+		NPC_F_LB_L_FDSA,
+		0, 0, 0, 0,
+	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		0, 0, 0, 0, 0,
+		NPC_S_KPU5_FCOE, 6, 1,
+		NPC_LID_LB, NPC_LT_LB_FDSA,
+		NPC_F_LB_L_FDSA,
+		0, 0, 0, 0,
+	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		0, 0, 0, 0, 1,
+		NPC_S_NA, 0, 1,
+		NPC_LID_LB, NPC_LT_LB_FDSA,
+		NPC_F_LB_U_UNK_ETYPE | NPC_F_LB_L_FDSA,
+		0, 0, 0, 0,
+	},
 	{
 		NPC_ERRLEV_LB, NPC_EC_L2_K4,
 		0, 0, 0, 0, 1,
@@ -13238,6 +13376,12 @@ static const struct npc_mcam_kex npc_mkex_default = {
 				/* CTAG VLAN[2..3] + Ethertype, 4 bytes, KW0[63:32] */
 				KEX_LD_CFG(0x03, 0x4, 0x1, 0x0, 0x4),
 			},
+			[NPC_LT_LB_FDSA] = {
+				/* SWITCH PORT: 1 byte, KW0[63:48] */
+				KEX_LD_CFG(0x0, 0x1, 0x1, 0x0, 0x6),
+				/* Ethertype: 2 bytes, KW0[47:32] */
+				KEX_LD_CFG(0x01, 0x4, 0x1, 0x0, 0x4),
+			},
 		},
 		[NPC_LID_LC] = {
 			/* Layer C: IPv4 */
-- 
2.20.1

