Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223C441BEE4
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 07:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244307AbhI2GAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 02:00:32 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30248 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S243585AbhI2GAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 02:00:31 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T2tajB008783;
        Tue, 28 Sep 2021 22:58:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=yZkeQpWzS0pGWE2OLfVJrv90Q4vPo8p9vEdcBaY0Wkw=;
 b=Crth8jrT9O0TD4yhFF4ngwX8btpv314fRiG6zYm4J5UV1W56nXrkyzRS8LurJW4wqSYX
 lB+DBhMzevoB0kzdeUnqaur2yU60yTsP0hW7xX3J2GSLlhI6AjjFQai/SVlAL4quEUwT
 8wWK/DCD4u8/IrEzoNFlmweJO0d0ah5zQR1mspDOiSnZMXEUc7ZXzJE/D2BqZok8lMYu
 jSMCWT/qjyRjRtOFE3yb1jyjnwcXrC0Pn/Iw9VCS+WVtvN8G2w3CDDWvXR7GNy0Ky6x5
 0RAc/o5HQzovU88s9VYSWX/HBwabA/WpBPYkJ8smlNB9gOzv3AiJgai/339sanKNBdQI yA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bc7eyjedn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 22:58:49 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Sep
 2021 22:58:47 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 28 Sep 2021 22:58:47 -0700
Received: from localhost.localdomain (unknown [10.28.34.15])
        by maili.marvell.com (Postfix) with ESMTP id 67E7B3F7068;
        Tue, 28 Sep 2021 22:58:43 -0700 (PDT)
From:   <kirankumark@marvell.com>
To:     <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Kiran Kumar K <kirankumark@marvell.com>
Subject: [net-next PATCH] octeontx2-af: Adjust LA pointer for cpt parse header
Date:   Wed, 29 Sep 2021 11:28:31 +0530
Message-ID: <20210929055831.991726-1-kirankumark@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: O2r3x0mbhgXroCnj19mpijB32dJWnSq6
X-Proofpoint-ORIG-GUID: O2r3x0mbhgXroCnj19mpijB32dJWnSq6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-29_01,2021-09-28_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kiran Kumar K <kirankumark@marvell.com>

In case of ltype NPC_LT_LA_CPT_HDR, LA pointer is pointing to the
start of cpt parse header. Since cpt parse header has veriable
length padding, this will be a problem for DMAC extraction. Adding
KPU profile changes to adjust the LA pointer to start at ether header
in case of cpt parse header by
   - Adding ptr advance in pkind 58 to a fixed value 40
   - Adding variable length offset 7 and mask 7 (pad len in
     CPT_PARSE_HDR).
Also added the missing static declaration for npc_set_var_len_offset_pkind
function.

Signed-off-by: Kiran Kumar K <kirankumark@marvell.com>
---
 .../marvell/octeontx2/af/npc_profile.h        | 173 ++++++++----------
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   |   2 +-
 2 files changed, 80 insertions(+), 95 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index 65280a8c4ac3..1a8c5376297c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -187,6 +187,8 @@ enum npc_kpu_parser_state {
 	NPC_S_KPU2_PREHEADER,
 	NPC_S_KPU2_EXDSA,
 	NPC_S_KPU2_NGIO,
+	NPC_S_KPU2_CPT_CTAG,
+	NPC_S_KPU2_CPT_QINQ,
 	NPC_S_KPU3_CTAG,
 	NPC_S_KPU3_STAG,
 	NPC_S_KPU3_QINQ,
@@ -1004,11 +1006,11 @@ static struct npc_kpu_profile_action ikpu_action_entries[] = {
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		40, 54, 58, 0, 0,
-		NPC_S_KPU1_CPT_HDR, 0, 0,
+		12, 16, 20, 0, 0,
+		NPC_S_KPU1_CPT_HDR, 40, 0,
 		NPC_LID_LA, NPC_LT_NA,
 		0,
-		0, 0, 0, 0,
+		7, 7, 0, 0,
 
 	},
 	{
@@ -1846,80 +1848,35 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 	},
 	{
 		NPC_S_KPU1_CPT_HDR, 0xff,
-		0x0000,
-		0xffff,
 		NPC_ETYPE_IP,
 		0xffff,
 		0x0000,
 		0x0000,
-	},
-	{
-		NPC_S_KPU1_CPT_HDR, 0xff,
-		0x0000,
-		0xffff,
-		NPC_ETYPE_IP6,
-		0xffff,
 		0x0000,
 		0x0000,
 	},
 	{
 		NPC_S_KPU1_CPT_HDR, 0xff,
-		0x0000,
-		0xffff,
-		NPC_ETYPE_CTAG,
-		0xffff,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_CPT_HDR, 0xff,
-		0x0000,
-		0xffff,
-		NPC_ETYPE_QINQ,
+		NPC_ETYPE_IP6,
 		0xffff,
 		0x0000,
 		0x0000,
-	},
-	{
-		NPC_S_KPU1_CPT_HDR, 0xff,
-		0x0000,
-		0xffff,
 		0x0000,
 		0x0000,
-		NPC_ETYPE_IP,
-		0xffff,
 	},
 	{
 		NPC_S_KPU1_CPT_HDR, 0xff,
-		0x0000,
+		NPC_ETYPE_CTAG,
 		0xffff,
 		0x0000,
 		0x0000,
-		NPC_ETYPE_IP6,
-		0xffff,
-	},
-	{
-		NPC_S_KPU1_CPT_HDR, 0xff,
-		0x0000,
-		0xffff,
 		0x0000,
 		0x0000,
-		NPC_ETYPE_CTAG,
-		0xffff,
 	},
 	{
 		NPC_S_KPU1_CPT_HDR, 0xff,
-		0x0000,
-		0xffff,
-		0x0000,
-		0x0000,
 		NPC_ETYPE_QINQ,
 		0xffff,
-	},
-	{
-		NPC_S_KPU1_CPT_HDR, 0xff,
-		0x0000,
-		0x0000,
 		0x0000,
 		0x0000,
 		0x0000,
@@ -2929,6 +2886,42 @@ static struct npc_kpu_profile_cam kpu2_cam_entries[] = {
 		0x0000,
 		0x0000,
 	},
+	{
+		NPC_S_KPU2_CPT_CTAG, 0xff,
+		NPC_ETYPE_IP,
+		0xffff,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+	},
+	{
+		NPC_S_KPU2_CPT_CTAG, 0xff,
+		NPC_ETYPE_IP6,
+		0xffff,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+	},
+	{
+		NPC_S_KPU2_CPT_QINQ, 0xff,
+		NPC_ETYPE_CTAG,
+		0xffff,
+		NPC_ETYPE_IP,
+		0xffff,
+		0x0000,
+		0x0000,
+	},
+	{
+		NPC_S_KPU2_CPT_QINQ, 0xff,
+		NPC_ETYPE_CTAG,
+		0xffff,
+		NPC_ETYPE_IP6,
+		0xffff,
+		0x0000,
+		0x0000,
+	},
 	{
 		NPC_S_NA, 0X00,
 		0x0000,
@@ -9167,39 +9160,7 @@ static struct npc_kpu_profile_action kpu1_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 3, 0,
-		NPC_S_KPU5_CPT_IP, 56, 1,
-		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		6, 0, 0, 3, 0,
-		NPC_S_KPU5_CPT_IP6, 56, 1,
-		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		4, 8, 0, 0, 0,
-		NPC_S_KPU2_CTAG, 54, 1,
-		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
-		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		4, 8, 0, 0, 0,
-		NPC_S_KPU2_QINQ, 54, 1,
-		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
-		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		8, 0, 6, 3, 0,
-		NPC_S_KPU5_CPT_IP, 60, 1,
+		NPC_S_KPU5_CPT_IP, 14, 1,
 		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
 		0,
 		0, 0, 0, 0,
@@ -9207,7 +9168,7 @@ static struct npc_kpu_profile_action kpu1_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		6, 0, 0, 3, 0,
-		NPC_S_KPU5_CPT_IP6, 60, 1,
+		NPC_S_KPU5_CPT_IP6, 14, 1,
 		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
 		0,
 		0, 0, 0, 0,
@@ -9215,7 +9176,7 @@ static struct npc_kpu_profile_action kpu1_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		4, 8, 0, 0, 0,
-		NPC_S_KPU2_CTAG, 58, 1,
+		NPC_S_KPU2_CPT_CTAG, 12, 1,
 		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
 		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
 		0, 0, 0, 0,
@@ -9223,19 +9184,11 @@ static struct npc_kpu_profile_action kpu1_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		4, 8, 0, 0, 0,
-		NPC_S_KPU2_QINQ, 58, 1,
+		NPC_S_KPU2_CPT_QINQ, 12, 1,
 		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
 		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
 		0, 0, 0, 0,
 	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 0, 1,
-		NPC_S_NA, 0, 1,
-		NPC_LID_LA, NPC_LT_LA_CPT_HDR,
-		NPC_F_LA_L_UNK_ETYPE,
-		0, 0, 0, 0,
-	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		12, 0, 0, 1, 0,
@@ -10129,6 +10082,38 @@ static struct npc_kpu_profile_action kpu2_action_entries[] = {
 		0,
 		0, 0, 0, 0,
 	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		8, 0, 6, 2, 0,
+		NPC_S_KPU5_CPT_IP, 6, 1,
+		NPC_LID_LB, NPC_LT_LB_CTAG,
+		0,
+		0, 0, 0, 0,
+	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		6, 0, 0, 2, 0,
+		NPC_S_KPU5_CPT_IP6, 6, 1,
+		NPC_LID_LB, NPC_LT_LB_CTAG,
+		0,
+		0, 0, 0, 0,
+	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		8, 0, 6, 2, 0,
+		NPC_S_KPU5_CPT_IP, 10, 1,
+		NPC_LID_LB, NPC_LT_LB_STAG_QINQ,
+		NPC_F_LB_U_MORE_TAG | NPC_F_LB_L_WITH_CTAG,
+		0, 0, 0, 0,
+	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		6, 0, 0, 2, 0,
+		NPC_S_KPU5_CPT_IP6, 10, 1,
+		NPC_LID_LB, NPC_LT_LB_STAG_QINQ,
+		NPC_F_LB_U_MORE_TAG | NPC_F_LB_L_WITH_CTAG,
+		0, 0, 0, 0,
+	},
 	{
 		NPC_ERRLEV_LB, NPC_EC_L2_K3,
 		0, 0, 0, 0, 1,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 2881ccc56b28..bb6b42bbefa4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -3167,7 +3167,7 @@ int rvu_mbox_handler_npc_get_kex_cfg(struct rvu *rvu, struct msg_req *req,
 	return 0;
 }
 
-int
+static int
 npc_set_var_len_offset_pkind(struct rvu *rvu, u16 pcifunc, u64 pkind,
 			     u8 var_len_off, u8 var_len_off_mask, u8 shift_dir)
 {
-- 
2.25.1

