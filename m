Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53975587E1E
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 16:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237270AbiHBO2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 10:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234025AbiHBO2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 10:28:34 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB421A39E;
        Tue,  2 Aug 2022 07:28:33 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 272ECjtZ010827;
        Tue, 2 Aug 2022 07:28:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=Av3Lw2qWQZJ3UQI0fP1s8Pi+XIFhswND/BZSyfPFqGc=;
 b=SivqvrX0cBFONJraj4kI1by5Ur7pkKUQMQ73aM2kfTsbzo0zDbowyu2h68JrGsG6zXDb
 6JmCXYezOiyl/R7p5ArsIo+e10pQ8QxmJ9ENoBIn0Ha6yH7tSfII+SnK9y6nbbEUIGvJ
 VT5vM36fhSeFWoWTawKW35w+bNZuAOuX3mNMN9Efsq1XgfEUEcoeM00wqAkpeDfW5aae
 FTrHUp8diWa7/PCKlqas/eFlNKypGErO1UFNVO+k5xhc/frr3J2oCHdZX3+hh/qXGEb5
 OZGVgff8qKEC93Yexk68Dbo7t2065C3HwW5TDzrkCgTYYM1xMKeygcjacAOjiYyzHHET /A== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3hn45mc229-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 02 Aug 2022 07:28:20 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 2 Aug
 2022 07:28:18 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 2 Aug 2022 07:28:18 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 2DCFC3F70A4;
        Tue,  2 Aug 2022 07:28:14 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>
CC:     Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [net PATCH v3] octeontx2-pf: Fix NIX_AF_TL3_TL2X_LINKX_CFG register configuration
Date:   Tue, 2 Aug 2022 19:58:13 +0530
Message-ID: <20220802142813.25031-1-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: VVlxuW_AMdbGdwAsPgQv0pLVfwFCudLt
X-Proofpoint-ORIG-GUID: VVlxuW_AMdbGdwAsPgQv0pLVfwFCudLt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-02_07,2022-08-02_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For packets scheduled to RPM and LBK, NIX_AF_PSE_CHANNEL_LEVEL[BP_LEVEL]
selects the TL3 or TL2 scheduling level as the one used for link/channel
selection and backpressure. For each scheduling queue at the selected
level: Setting NIX_AF_TL3_TL2(0..255)_LINK(0..12)_CFG[ENA] = 1 allows
the TL3/TL2 queue to schedule packets to a specified RPM or LBK link
and channel.

There is an issue in the code where NIX_AF_PSE_CHANNEL_LEVEL[BP_LEVEL]
is set to TL3 where as the NIX_AF_TL3_TL2(0..255)_LINK(0..12)_CFG is
configured for TL2 queue in some cases. As a result packets will not
transmit on that link/channel. This patch fixes the issue by configuring
the NIX_AF_TL3_TL2(0..255)_LINK(0..12)_CFG register depending on the
NIX_AF_PSE_CHANNEL_LEVEL[BP_LEVEL] value.

Fixes: caa2da34fd25a ("octeontx2-pf: Initialize and config queues")
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
v3:
  - Added more details about the fix in commit message.
  - Added fixes Tag.

v2: none

---
 .../net/ethernet/marvell/octeontx2/nic/otx2_common.c  | 19 ++++++++++++++-----
 .../net/ethernet/marvell/octeontx2/nic/otx2_common.h  |  1 +
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index fb8db5888d2f..d686c7b6252f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -632,6 +632,12 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 		req->num_regs++;
 		req->reg[1] = NIX_AF_TL3X_SCHEDULE(schq);
 		req->regval[1] = dwrr_val;
+		if (lvl == hw->txschq_link_cfg_lvl) {
+			req->num_regs++;
+			req->reg[2] = NIX_AF_TL3_TL2X_LINKX_CFG(schq, hw->tx_link);
+			/* Enable this queue and backpressure */
+			req->regval[2] = BIT_ULL(13) | BIT_ULL(12);
+		}
 	} else if (lvl == NIX_TXSCH_LVL_TL2) {
 		parent =  hw->txschq_list[NIX_TXSCH_LVL_TL1][0];
 		req->reg[0] = NIX_AF_TL2X_PARENT(schq);
@@ -641,11 +647,12 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
 		req->reg[1] = NIX_AF_TL2X_SCHEDULE(schq);
 		req->regval[1] = TXSCH_TL1_DFLT_RR_PRIO << 24 | dwrr_val;
 
-		req->num_regs++;
-		req->reg[2] = NIX_AF_TL3_TL2X_LINKX_CFG(schq, hw->tx_link);
-		/* Enable this queue and backpressure */
-		req->regval[2] = BIT_ULL(13) | BIT_ULL(12);
-
+		if (lvl == hw->txschq_link_cfg_lvl) {
+			req->num_regs++;
+			req->reg[2] = NIX_AF_TL3_TL2X_LINKX_CFG(schq, hw->tx_link);
+			/* Enable this queue and backpressure */
+			req->regval[2] = BIT_ULL(13) | BIT_ULL(12);
+		}
 	} else if (lvl == NIX_TXSCH_LVL_TL1) {
 		/* Default config for TL1.
 		 * For VF this is always ignored.
@@ -1591,6 +1598,8 @@ void mbox_handler_nix_txsch_alloc(struct otx2_nic *pf,
 		for (schq = 0; schq < rsp->schq[lvl]; schq++)
 			pf->hw.txschq_list[lvl][schq] =
 				rsp->schq_list[lvl][schq];
+
+	pf->hw.txschq_link_cfg_lvl = rsp->link_cfg_lvl;
 }
 EXPORT_SYMBOL(mbox_handler_nix_txsch_alloc);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index ce2766317c0b..f9c0d2f08e87 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -195,6 +195,7 @@ struct otx2_hw {
 	u16			sqb_size;
 
 	/* NIX */
+	u8			txschq_link_cfg_lvl;
 	u16		txschq_list[NIX_TXSCH_LVL_CNT][MAX_TXSCHQ_PER_FUNC];
 	u16			matchall_ipolicer;
 	u32			dwrr_mtu;
-- 
2.16.5

