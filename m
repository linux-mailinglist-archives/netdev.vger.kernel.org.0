Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1CEF3EE5D1
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 06:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238011AbhHQEqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 00:46:22 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42834 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233861AbhHQEqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 00:46:03 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17H2m19F006952;
        Mon, 16 Aug 2021 21:45:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=W6NuEk1QJu3fotzes0/rOLmBBSOLAzp1Gnq3+ndFWdw=;
 b=BjezXbMMWdeF2LOB2GsYe/BTW39Mzs2H8EIBW+RbC726OBPBp8cYeLAWj/yMWcQC49Ku
 xxuP53xLT2kSKtuiHNhuvZB5xqMONB4u2ttsnQBc+e1bjXGXEYTxkVyIGtmLQIGdqbUa
 CIP8CUcypTjg+96uqg43xeuPk9lGVLUHuRT22XABjdlwGNkQhP0ZWCLEF/0KhJ2DA1wg
 uTwgTpuhdQWV4KLn0CDRyrXlqtCgjjb1t7Wbo9ubtC3sHRVblSUGH34sWr26FRsaOUWH
 tY/9vSwq7iTFvy0We+2GX3NBC8+fuMK3ac0fej8/Zdq95DItn6rMfdEgD73iYJZadFh6 eg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3ag4n0ra5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 21:45:28 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 16 Aug
 2021 21:45:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 16 Aug 2021 21:45:26 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 8112F3F70AE;
        Mon, 16 Aug 2021 21:45:24 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 10/11] octeontx2-af: cn10K: Get NPC counters value
Date:   Tue, 17 Aug 2021 10:14:52 +0530
Message-ID: <1629175493-4895-11-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629175493-4895-1-git-send-email-sbhatta@marvell.com>
References: <1629175493-4895-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: NObZL2N5jRZfeZuewX3e2daZnTBsglrc
X-Proofpoint-ORIG-GUID: NObZL2N5jRZfeZuewX3e2daZnTBsglrc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-17_01,2021-08-16_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hkelam@marvell.com>

The way SW can identify the number NPC counters supported by silicon
has changed for CN10K. This patch addresses this reading appropriate
registers to find out number of counters available.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 27 +++++++++++++++-------
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 95591e7..d88f595 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -356,6 +356,7 @@ struct rvu_hwinfo {
 	u16	npc_counters;	   /* No of match stats counters */
 	u32	lbk_bufsize;	   /* FIFO size supported by LBK */
 	bool	npc_ext_set;	   /* Extended register set */
+	u64     npc_stat_ena;      /* Match stats enable bit */
 
 	struct hw_cap    cap;
 	struct rvu_block block[BLK_COUNT]; /* Block info */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 20a562c..504dfa5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -1898,9 +1898,22 @@ static void rvu_npc_hw_init(struct rvu *rvu, int blkaddr)
 
 	mcam->banks = (npc_const >> 44) & 0xFULL;
 	mcam->banksize = (npc_const >> 28) & 0xFFFFULL;
+	hw->npc_stat_ena = BIT_ULL(9);
 	/* Extended set */
 	if (npc_const2) {
 		hw->npc_ext_set = true;
+		/* 96xx supports only match_stats and npc_counters
+		 * reflected in NPC_AF_CONST reg.
+		 * STAT_SEL and ENA are at [0:8] and 9 bit positions.
+		 * 98xx has both match_stat and ext and npc_counter
+		 * reflected in NPC_AF_CONST2
+		 * STAT_SEL_EXT added at [12:14] bit position.
+		 * cn10k supports only ext and hence npc_counters in
+		 * NPC_AF_CONST is 0 and npc_counters reflected in NPC_AF_CONST2.
+		 * STAT_SEL bitpos incremented from [0:8] to [0:11] and ENA bit moved to 63
+		 */
+		if (!hw->npc_counters)
+			hw->npc_stat_ena = BIT_ULL(63);
 		hw->npc_counters = (npc_const2 >> 16) & 0xFFFFULL;
 		mcam->banksize = npc_const2 & 0xFFFFULL;
 	}
@@ -1955,7 +1968,7 @@ static void rvu_npc_setup_interfaces(struct rvu *rvu, int blkaddr)
 		rvu_write64(rvu, blkaddr,
 			    NPC_AF_INTFX_MISS_STAT_ACT(intf),
 			    ((mcam->rx_miss_act_cntr >> 9) << 12) |
-			    BIT_ULL(9) | mcam->rx_miss_act_cntr);
+			    hw->npc_stat_ena | mcam->rx_miss_act_cntr);
 	}
 
 	/* Configure TX interfaces */
@@ -2147,18 +2160,16 @@ static void npc_map_mcam_entry_and_cntr(struct rvu *rvu, struct npc_mcam *mcam,
 					int blkaddr, u16 entry, u16 cntr)
 {
 	u16 index = entry & (mcam->banksize - 1);
-	u16 bank = npc_get_bank(mcam, entry);
+	u32 bank = npc_get_bank(mcam, entry);
+	struct rvu_hwinfo *hw = rvu->hw;
 
 	/* Set mapping and increment counter's refcnt */
 	mcam->entry2cntr_map[entry] = cntr;
 	mcam->cntr_refcnt[cntr]++;
-	/* Enable stats
-	 * NPC_AF_MCAMEX_BANKX_STAT_ACT[14:12] - counter[11:9]
-	 * NPC_AF_MCAMEX_BANKX_STAT_ACT[8:0] - counter[8:0]
-	 */
+	/* Enable stats */
 	rvu_write64(rvu, blkaddr,
 		    NPC_AF_MCAMEX_BANKX_STAT_ACT(index, bank),
-		    ((cntr >> 9) << 12) | BIT_ULL(9) | cntr);
+		    ((cntr >> 9) << 12) | hw->npc_stat_ena | cntr);
 }
 
 static void npc_unmap_mcam_entry_and_cntr(struct rvu *rvu,
@@ -3264,7 +3275,7 @@ int rvu_mbox_handler_npc_mcam_entry_stats(struct rvu *rvu,
 	/* read MCAM entry STAT_ACT register */
 	regval = rvu_read64(rvu, blkaddr, NPC_AF_MCAMEX_BANKX_STAT_ACT(index, bank));
 
-	if (!(regval & BIT_ULL(9))) {
+	if (!(regval & rvu->hw->npc_stat_ena)) {
 		rsp->stat_ena = 0;
 		mutex_unlock(&mcam->lock);
 		return 0;
-- 
2.7.4

