Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90E40586B3B
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 14:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbiHAMsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 08:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234740AbiHAMro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 08:47:44 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C818250181;
        Mon,  1 Aug 2022 05:38:51 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 271A12YR031410;
        Mon, 1 Aug 2022 05:38:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=AH3eQitAxYvhy4/RzAP+//HGTXu655O4Xsd9zGjJRZU=;
 b=HVFdXMKhCP7o4jUKI4O5FY1YtlHTXb/eAqu2ZnTZLDgauPEwfY14AHiYOu6yMrUAR1gq
 Ugz576RlMScn9iq+An/HTgHdTJ+2ULstYL52gHVTqpyQivJYYyxptyOjC0bkV7qbP2yS
 fr8whjxWoxKplVvRM+OUY7MZ28chUIHIgp+Rlm16e7h92XhFWEYTz5+bPi/Lx+sLbYVu
 Xs0HzMnPohm1ubsdh9P0DN5rWR8olE5+dw+34qUTeOp4YVebTSGgV7ewO4w50MXrUQF1
 qMR2xhGTJ+ov23tNJ2oULw2cqyZWeSfHjlhtdm3cJ83ZsIfH1lp2WnYaMu0eL76jnmUG hw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3hn45m6j2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 01 Aug 2022 05:38:39 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 1 Aug
 2022 05:38:37 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 1 Aug 2022 05:38:37 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id EF6173F70A1;
        Mon,  1 Aug 2022 05:38:34 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>
CC:     Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [net PATCH v2] octeontx2-pf: Fix NIX_AF_TL3_TL2X_LINKX_CFG register configuration
Date:   Mon, 1 Aug 2022 18:08:31 +0530
Message-ID: <20220801123831.9370-1-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 0hIy8DYg4P1hoWGWyO0HKR9NYw6czMHh
X-Proofpoint-ORIG-GUID: 0hIy8DYg4P1hoWGWyO0HKR9NYw6czMHh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_07,2022-08-01_01,2022-06-22_01
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

Fixes: 5d9b976d4480 ("octeontx2-af: Support fixed transmit scheduler topology")
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
v2:
  - Added more details about the fix in commit message.
  - Added fixes Tag.

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

