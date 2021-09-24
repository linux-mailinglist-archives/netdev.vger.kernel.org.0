Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFDC416C80
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 09:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244301AbhIXHHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 03:07:33 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51964 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244307AbhIXHHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 03:07:32 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18NNedui007582;
        Thu, 23 Sep 2021 23:19:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=Ue1OR2pzsZswhudja/U2Obtr1franrC/BowfG2ZFyag=;
 b=Chcbwsu3IZcBejDvLgI6CEwgWZIUMJaFL6MPjVSd/EeLU/RpmisszktSKqfNSx8nB5Mp
 VE4r4f3NXfWpgnOAQw+t3OQI7gC9dYwF8h2HtLqmowr3G+620zGuVyzM3Q47cDBSj2IL
 JXXm6FkVKqoePB2sbUE6GXh0PDYR44UTBwWhV1IIaeB4R0oDFbyzI7LEaBcoPTKh+3iA
 p0CSMDY/2qbzWVwfrrCTiej5pks4Ut6I7IUubIYgm6MzGew8abpAy43IYVvBPGj61Va+
 JTVPm/bbSgol2WL/0Gq/0TQ2KEuO27DEe5/DmPtjTQ09JjRV8DZHAF2lj8B7RYFmDE04 jw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3b93f9910b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 23 Sep 2021 23:19:12 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Sep
 2021 23:19:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 23 Sep 2021 23:19:09 -0700
Received: from localhost.localdomain (unknown [10.28.34.15])
        by maili.marvell.com (Postfix) with ESMTP id AB5D93F7069;
        Thu, 23 Sep 2021 23:19:06 -0700 (PDT)
From:   <kirankumark@marvell.com>
To:     <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Kiran Kumar K <kirankumark@marvell.com>
Subject: [net-next 1/2] octeontx2-af: Limit KPU parsing for GTPU packets
Date:   Fri, 24 Sep 2021 11:48:50 +0530
Message-ID: <20210924061851.680922-2-kirankumark@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210924061851.680922-1-kirankumark@marvell.com>
References: <20210924061851.680922-1-kirankumark@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: A9BALGypeMUGwQJUGI1HjruV1c7b2C6u
X-Proofpoint-ORIG-GUID: A9BALGypeMUGwQJUGI1HjruV1c7b2C6u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-24_01,2021-09-23_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kiran Kumar K <kirankumark@marvell.com>

With current KPU profile, while parsing GTPU packets, GTPU payload
is also being parsed and GTPU PDU payload is being treated as IPV4
data, which is not correct. In case of GTPU packets, parsing should
be stopped after identifying the GTPU. Adding changes to limit KPU
profile parsing for GTPU payload.

Signed-off-by: Kiran Kumar K <kirankumark@marvell.com>
---
 .../marvell/octeontx2/af/npc_profile.h        | 21 ++-----------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index 588822a0cf21..d651cccdb27d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -7492,15 +7492,6 @@ static struct npc_kpu_profile_cam kpu9_cam_entries[] = {
 		0x0000,
 		0x0000,
 	},
-	{
-		NPC_S_KPU9_GTPU, 0xff,
-		0x0000,
-		0x0000,
-		NPC_GTP_PT_GTP | NPC_GTP_VER1 | NPC_GTP_MT_G_PDU,
-		NPC_GTP_PT_MASK | NPC_GTP_VER_MASK | NPC_GTP_MT_MASK,
-		0x0000,
-		0x0000,
-	},
 	{
 		NPC_S_KPU9_GTPU, 0xff,
 		0x0000,
@@ -14335,16 +14326,8 @@ static struct npc_kpu_profile_action kpu9_action_entries[] = {
 	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		8, 0, 6, 2, 0,
-		NPC_S_KPU12_TU_IP, 8, 1,
-		NPC_LID_LE, NPC_LT_LE_GTPU,
-		NPC_F_LE_L_GTPU_G_PDU,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		8, 0, 6, 2, 0,
-		NPC_S_KPU12_TU_IP, 8, 1,
+		8, 0, 6, 2, 1,
+		NPC_S_NA, 0, 1,
 		NPC_LID_LE, NPC_LT_LE_GTPU,
 		0,
 		0, 0, 0, 0,
-- 
2.25.1

