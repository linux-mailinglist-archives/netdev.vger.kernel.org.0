Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643C6495A00
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 07:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378727AbiAUGfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 01:35:30 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:45130 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378725AbiAUGf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 01:35:28 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20L05s8g029343;
        Thu, 20 Jan 2022 22:35:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=HOKx4/jqW98EnimRMEfCWoPWqKhiM47ees0WogeddOQ=;
 b=iAog1DprqYt2PL1szOzokzVwbAgXrmDLPh6OOWC3q6DDjDM32eWEHGyHtUFGgiyNUJvS
 qLnblL5NruXGJ657Vg97GoWS16XpnvdLoc/f2Rp2YS2O8renzdyXB3sQzbir4CE1kY4E
 zrY3PuWmmwT9AGUiqkJXhrbwvDAq4S5wmmipW6fvsZeLvPFAtYEqr1UpwRv5tC07tG69
 cXuDVkrmT3IQzWOdtIz1UCtYNZts/AM/+DNEZnuVl6r5RVTeRhUFfaZ9TFtLI4eIANys
 6ETg5BrKBYzHcWgg6MQ8NKErXzr85hMnJ+FPKr7B4OWnwPITZKYz6KqUaX4JM9CPepP2 iw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dqj05gxyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 22:35:25 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 20 Jan
 2022 22:35:23 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 20 Jan 2022 22:35:23 -0800
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 6EC103F7060;
        Thu, 20 Jan 2022 22:35:20 -0800 (PST)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <sundeep.lkml@gmail.com>
CC:     <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>,
        "Kiran Kumar K" <kirankumark@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net PATCH 9/9] octeontx2-af: Add KPU changes to parse NGIO as separate layer
Date:   Fri, 21 Jan 2022 12:04:47 +0530
Message-ID: <1642746887-30924-10-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1642746887-30924-1-git-send-email-sbhatta@marvell.com>
References: <1642746887-30924-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: lUpM_ozyXQTIfCf_QB-1GfGt9a9jL3oM
X-Proofpoint-ORIG-GUID: lUpM_ozyXQTIfCf_QB-1GfGt9a9jL3oM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_02,2022-01-20_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kiran Kumar K <kirankumark@marvell.com>

With current KPU profile NGIO is being parsed along with CTAG as
a single layer. Because of this MCAM/ntuple rules installed with
ethertype as 0x8842 are not being hit. Adding KPU profile changes
to parse NGIO in separate ltype and CTAG in separate ltype.

Fixes: f9c49be90c05 ("octeontx2-af: Update the default KPU profile and fixes")
Signed-off-by: Kiran Kumar K <kirankumark@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/af/npc_profile.h    | 70 +++++++++++-----------
 1 file changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index 0fe7ad3..4180376 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -185,7 +185,6 @@ enum npc_kpu_parser_state {
 	NPC_S_KPU2_QINQ,
 	NPC_S_KPU2_ETAG,
 	NPC_S_KPU2_EXDSA,
-	NPC_S_KPU2_NGIO,
 	NPC_S_KPU2_CPT_CTAG,
 	NPC_S_KPU2_CPT_QINQ,
 	NPC_S_KPU3_CTAG,
@@ -212,6 +211,7 @@ enum npc_kpu_parser_state {
 	NPC_S_KPU5_NSH,
 	NPC_S_KPU5_CPT_IP,
 	NPC_S_KPU5_CPT_IP6,
+	NPC_S_KPU5_NGIO,
 	NPC_S_KPU6_IP6_EXT,
 	NPC_S_KPU6_IP6_HOP_DEST,
 	NPC_S_KPU6_IP6_ROUT,
@@ -1124,15 +1124,6 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		NPC_S_KPU1_ETHER, 0xff,
 		NPC_ETYPE_CTAG,
 		0xffff,
-		NPC_ETYPE_NGIO,
-		0xffff,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_ETHER, 0xff,
-		NPC_ETYPE_CTAG,
-		0xffff,
 		NPC_ETYPE_CTAG,
 		0xffff,
 		0x0000,
@@ -1968,6 +1959,15 @@ static struct npc_kpu_profile_cam kpu2_cam_entries[] = {
 	},
 	{
 		NPC_S_KPU2_CTAG, 0xff,
+		NPC_ETYPE_NGIO,
+		0xffff,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+	},
+	{
+		NPC_S_KPU2_CTAG, 0xff,
 		NPC_ETYPE_PPPOE,
 		0xffff,
 		0x0000,
@@ -2750,15 +2750,6 @@ static struct npc_kpu_profile_cam kpu2_cam_entries[] = {
 		0x0000,
 	},
 	{
-		NPC_S_KPU2_NGIO, 0xff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
 		NPC_S_KPU2_CPT_CTAG, 0xff,
 		NPC_ETYPE_IP,
 		0xffff,
@@ -5090,6 +5081,15 @@ static struct npc_kpu_profile_cam kpu5_cam_entries[] = {
 		0x0000,
 	},
 	{
+		NPC_S_KPU5_NGIO, 0xff,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+		0x0000,
+	},
+	{
 		NPC_S_NA, 0X00,
 		0x0000,
 		0x0000,
@@ -8425,14 +8425,6 @@ static struct npc_kpu_profile_action kpu1_action_entries[] = {
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 12, 0, 0, 0,
-		NPC_S_KPU2_NGIO, 12, 1,
-		NPC_LID_LA, NPC_LT_LA_ETHER,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		8, 12, 0, 0, 0,
 		NPC_S_KPU2_CTAG2, 12, 1,
 		NPC_LID_LA, NPC_LT_LA_ETHER,
 		NPC_F_LA_U_HAS_TAG | NPC_F_LA_L_WITH_VLAN,
@@ -9196,6 +9188,14 @@ static struct npc_kpu_profile_action kpu2_action_entries[] = {
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		0, 0, 0, 2, 0,
+		NPC_S_KPU5_NGIO, 6, 1,
+		NPC_LID_LB, NPC_LT_LB_CTAG,
+		0,
+		0, 0, 0, 0,
+	},
+	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 2, 0,
 		NPC_S_KPU5_IP, 14, 1,
 		NPC_LID_LB, NPC_LT_LB_PPPOE,
@@ -9892,14 +9892,6 @@ static struct npc_kpu_profile_action kpu2_action_entries[] = {
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 0, 1,
-		NPC_S_NA, 0, 1,
-		NPC_LID_LC, NPC_LT_LC_NGIO,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 2, 0,
 		NPC_S_KPU5_CPT_IP, 6, 1,
 		NPC_LID_LB, NPC_LT_LB_CTAG,
@@ -11974,6 +11966,14 @@ static struct npc_kpu_profile_action kpu5_action_entries[] = {
 		0, 0, 0, 0,
 	},
 	{
+		NPC_ERRLEV_RE, NPC_EC_NOERR,
+		0, 0, 0, 0, 1,
+		NPC_S_NA, 0, 1,
+		NPC_LID_LC, NPC_LT_LC_NGIO,
+		0,
+		0, 0, 0, 0,
+	},
+	{
 		NPC_ERRLEV_LC, NPC_EC_UNK,
 		0, 0, 0, 0, 1,
 		NPC_S_NA, 0, 0,
-- 
2.7.4

