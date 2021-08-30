Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEF23FBB5E
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 20:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238423AbhH3SCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 14:02:10 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32794 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238391AbhH3SCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 14:02:07 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17UA1mM9011121;
        Mon, 30 Aug 2021 11:01:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=8VJZ0wDdavMUHz93iKIo6YJNJswdY/FMv2j47kFb4m8=;
 b=TX/sDIZY0q0l67hFgy9GCmV0VGDLGP55AswO5eckpjmh2yAR1XRf4cfv82IvjHtZrRyB
 I+AfoCbR7WAdtlbBj36Dm8zxqF9geFvNPJh4KRmGaYayyuY90w2KAi6RWwUm4BV5s15Y
 UkqT3xCozgOX/b41bbKDatNVLPKE46cNDqqbPBqcA/Py+eTjG+xYvD5PiSj/xCDSJvvo
 Wv5ppIGfNpc0VWxTYvW3KVlZh1hs5gx6EVrosackY6MDtkUgik+2ukLawpr6d1d2V+ax
 jW+7LMSpGCAWubdzkottEBpTLDWef8bj34XDhSsR40rOX/CJj7CFIb8/dxY3D+tp1kHS Vg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3arj9m3crr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 30 Aug 2021 11:01:10 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 30 Aug
 2021 11:01:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 30 Aug 2021 11:01:08 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id A7E573F707E;
        Mon, 30 Aug 2021 11:01:05 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 4/4] octeontx2-af: Set proper errorcode for IPv4 checksum errors
Date:   Mon, 30 Aug 2021 23:30:46 +0530
Message-ID: <1630346446-21609-5-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1630346446-21609-1-git-send-email-sbhatta@marvell.com>
References: <1630346446-21609-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: n2bj-wtmGHG_2JVJXCgsJ2moRCrBxIlT
X-Proofpoint-ORIG-GUID: n2bj-wtmGHG_2JVJXCgsJ2moRCrBxIlT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-30_06,2021-08-30_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

With current config, for packets with IPv4 checksum errors,
errorcode is being set to UNKNOWN. Hence added a separate
errorcodes for outer and inner IPv4 checksum and changed
NPC configuration accordingly.

Also turn on L2 multicast address check in NPC protocol check block.

Fixes: 6b3321bacc5a ("octeontx2-af: Enable packet length and csum validation")
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 4d94bd0..5efb417 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -2020,14 +2020,15 @@ int rvu_npc_init(struct rvu *rvu)
 
 	/* Enable below for Rx pkts.
 	 * - Outer IPv4 header checksum validation.
-	 * - Detect outer L2 broadcast address and set NPC_RESULT_S[L2M].
+	 * - Detect outer L2 broadcast address and set NPC_RESULT_S[L2B].
+	 * - Detect outer L2 multicast address and set NPC_RESULT_S[L2M].
 	 * - Inner IPv4 header checksum validation.
 	 * - Set non zero checksum error code value
 	 */
 	rvu_write64(rvu, blkaddr, NPC_AF_PCK_CFG,
 		    rvu_read64(rvu, blkaddr, NPC_AF_PCK_CFG) |
-		    BIT_ULL(32) | BIT_ULL(24) | BIT_ULL(6) |
-		    BIT_ULL(2) | BIT_ULL(1));
+		    ((u64)NPC_EC_OIP4_CSUM << 32) | (NPC_EC_IIP4_CSUM << 24) |
+		    BIT_ULL(7) | BIT_ULL(6) | BIT_ULL(2) | BIT_ULL(1));
 
 	rvu_npc_setup_interfaces(rvu, blkaddr);
 
-- 
2.7.4

