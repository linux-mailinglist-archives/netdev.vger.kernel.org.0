Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAE63FBB5C
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 20:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238388AbhH3SCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 14:02:00 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64612 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238268AbhH3SB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 14:01:59 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17UAl3nD024479;
        Mon, 30 Aug 2021 11:01:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=bqyHHLLO85qdYip1w/xlOE08dNQXV71fC/p4NBCBOPY=;
 b=en6UfongvAJG0X7EYCNU1xTPLV0ZNqFMyUN+WPf4XBeyO77gJQ+ynJ+jYabpxRI7a67C
 wwvIBP2yLo7BNam3BSWHG44a67OSdVDzb2OU98ak+6W9LjAiYrpluC5L/Ud6ZtlqjvsH
 XbaAUzS0AzfQ67eMsubYDsQCxE+9Cu25lNrqVGL6m0jkz2aMVYoWgohuDdGg6lEwfyZp
 JcHUBpImtVph52qXKgqofCDhlR0o8GX0KJVxBpZIttmpRqufLIdJn+A0JKTzO6Csnj4J
 sdaIZvvMK8slzpf8OoIJNH4Q+GIQ6qxvnDnVWGjMMgiSm8gUiNm3OlYm8RLPIc5WoL1z 5Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3arj9m3cr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 30 Aug 2021 11:01:02 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 30 Aug
 2021 11:01:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 30 Aug 2021 11:01:00 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 218753F7078;
        Mon, 30 Aug 2021 11:00:57 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 2/4] octeontx2-af: Fix mailbox errors in nix_rss_flowkey_cfg
Date:   Mon, 30 Aug 2021 23:30:44 +0530
Message-ID: <1630346446-21609-3-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1630346446-21609-1-git-send-email-sbhatta@marvell.com>
References: <1630346446-21609-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: HqSq0wmSnGGb8Y8Bahlr1665XS1-N0KD
X-Proofpoint-ORIG-GUID: HqSq0wmSnGGb8Y8Bahlr1665XS1-N0KD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-30_06,2021-08-30_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In npc_update_vf_flow_entry function the loop cursor
'index' is being changed inside the loop causing
the loop to spin forever. This in turn hogs the kworker
thread forever and no other mbox message is processed
by AF driver after that. Fix this by using
another variable in the loop.

Fixes: 55307fcb9258 ("octeontx2-af: Add mbox messages to install and delete MCAM rules")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 6389ee7..9aeecb8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -915,7 +915,7 @@ void rvu_npc_enable_allmulti_entry(struct rvu *rvu, u16 pcifunc, int nixlf,
 static void npc_update_vf_flow_entry(struct rvu *rvu, struct npc_mcam *mcam,
 				     int blkaddr, u16 pcifunc, u64 rx_action)
 {
-	int actindex, index, bank;
+	int actindex, index, bank, entry;
 	bool enable;
 
 	if (!(pcifunc & RVU_PFVF_FUNC_MASK))
@@ -926,7 +926,7 @@ static void npc_update_vf_flow_entry(struct rvu *rvu, struct npc_mcam *mcam,
 		if (mcam->entry2target_pffunc[index] == pcifunc) {
 			bank = npc_get_bank(mcam, index);
 			actindex = index;
-			index &= (mcam->banksize - 1);
+			entry = index & (mcam->banksize - 1);
 
 			/* read vf flow entry enable status */
 			enable = is_mcam_entry_enabled(rvu, mcam, blkaddr,
@@ -936,7 +936,7 @@ static void npc_update_vf_flow_entry(struct rvu *rvu, struct npc_mcam *mcam,
 					      false);
 			/* update 'action' */
 			rvu_write64(rvu, blkaddr,
-				    NPC_AF_MCAMEX_BANKX_ACTION(index, bank),
+				    NPC_AF_MCAMEX_BANKX_ACTION(entry, bank),
 				    rx_action);
 			if (enable)
 				npc_enable_mcam_entry(rvu, mcam, blkaddr,
-- 
2.7.4

