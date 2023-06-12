Return-Path: <netdev+bounces-9965-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F17C72B7E1
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:05:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7DC52810EC
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 06:05:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01FAE20F1;
	Mon, 12 Jun 2023 06:04:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09DB2593
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 06:04:49 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2B7E7A;
	Sun, 11 Jun 2023 23:04:47 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35C0ZnTd020393;
	Sun, 11 Jun 2023 23:04:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=HbVRV4Eka9k+9jsIsXWnvSEOP11pzvjVR0eASnJySkk=;
 b=J+ybiu8+oPcPd41HQ6+njPlQ3VYB+m4ZAaRSz2dL0QUYFXiZlQVFRrHOdc0n4a0Ek4Z9
 8xI8+kzFdNeH8w5RiOjThTM3HrJj3W4i9E8xS4xieLYCz4POfsFBh6DtdUdFEo/hl2Us
 9XyPPSjvUcvJnbQHtV0XJ6HRiSIL9pwcyrOZcnOVRUn+XZE1LbGz9BLfJFuB/hSwC2eX
 qfgigmqOWMpiv1PnSNkY5dktf+ahV06cIsJrUc+5Ws4lyAc71ASFe92rw69ccsQSxDQ7
 rdbeNVM3YOQGyD2bCXI7LBjpdRA4XZzhNCvJqhEsDcAnWoZaXBT43qf8IxLa9XZ6ItE9 Hg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3r4rpkbenq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Sun, 11 Jun 2023 23:04:40 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 11 Jun
 2023 23:04:38 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sun, 11 Jun 2023 23:04:38 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
	by maili.marvell.com (Postfix) with ESMTP id E39985B6942;
	Sun, 11 Jun 2023 23:04:35 -0700 (PDT)
From: Naveen Mamindlapalli <naveenm@marvell.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>
CC: Geetha sowjanya <gakula@marvell.com>,
        Naveen Mamindlapalli
	<naveenm@marvell.com>
Subject: [net-next PATCH v2 3/6] octeontx2-af: cn10k: Set NIX DWRR MTU for CN10KB silicon
Date: Mon, 12 Jun 2023 11:34:21 +0530
Message-ID: <20230612060424.1427-4-naveenm@marvell.com>
X-Mailer: git-send-email 2.39.0.198.ga38d39a4c5
In-Reply-To: <20230612060424.1427-1-naveenm@marvell.com>
References: <20230612060424.1427-1-naveenm@marvell.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: sUFcPp4IA8mBKimYs4W5uNDxIy2Hp9cZ
X-Proofpoint-GUID: sUFcPp4IA8mBKimYs4W5uNDxIy2Hp9cZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-12_03,2023-06-09_01,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Sunil Goutham <sgoutham@marvell.com>

The DWRR MTU config added for SDP and RPM/LBK links on CN10K
silicon is further extended on CK10KB silicon variant and made
it configurable. Now there are 4 DWRR MTU config to choose while
setting transmit scheduler's RR_WEIGHT.

Here we are reserving one config for each of RPM, SDP and LBK.
NIXX_AF_DWRR_MTUX(0) ---> RPM
NIXX_AF_DWRR_MTUX(1) ---> SDP
NIXX_AF_DWRR_MTUX(2) ---> LBK

PF/VF drivers can choose the DWRR_MTU to be used by setting
SMQX_CFG[pkt_link_type] to one of above. TLx_SCHEDULE[RR_WEIGHT]
is to be as configured 'quantum / 2^DWRR_MTUX[MTU]'. DWRR_MTU
of each link is exposed to PF/VF drivers via mailbox for
RR_WEIGHT calculation.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 .../ethernet/marvell/octeontx2/af/common.h    |  7 +++
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  4 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |  2 +
 .../marvell/octeontx2/af/rvu_devlink.c        |  6 ++-
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 44 ++++++++++++++++---
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |  3 +-
 .../marvell/octeontx2/nic/otx2_common.c       | 18 +++++++-
 .../marvell/octeontx2/nic/otx2_common.h       |  1 +
 8 files changed, 73 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
index f5bf719a6ccf..2436c1ff9ba4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
@@ -145,6 +145,13 @@ enum nix_scheduler {
 #define TXSCH_TL1_DFLT_RR_PRIO		(0x7ull)
 #define CN10K_MAX_DWRR_WEIGHT          16384 /* Weight is 14bit on CN10K */
 
+/* Don't change the order as on CN10K (except CN10KB)
+ * SMQX_CFG[SDP] value should be 1 for SDP flows.
+ */
+#define SMQ_LINK_TYPE_RPM		0
+#define SMQ_LINK_TYPE_SDP		1
+#define SMQ_LINK_TYPE_LBK		2
+
 /* Min/Max packet sizes, excluding FCS */
 #define	NIC_HW_MIN_FRS			40
 #define	NIC_HW_MAX_FRS			9212
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 671fcf86ed87..1794ef0f9ae0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1245,7 +1245,9 @@ struct nix_hw_info {
 	u16 min_mtu;
 	u32 rpm_dwrr_mtu;
 	u32 sdp_dwrr_mtu;
-	u64 rsvd[16]; /* Add reserved fields for future expansion */
+	u32 lbk_dwrr_mtu;
+	u32 rsvd32[1];
+	u64 rsvd[15]; /* Add reserved fields for future expansion */
 };
 
 struct nix_bandprof_alloc_req {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index d655bf04a483..12e644bc239a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -346,6 +346,7 @@ struct hw_cap {
 	bool	per_pf_mbox_regs; /* PF mbox specified in per PF registers ? */
 	bool	programmable_chans; /* Channels programmable ? */
 	bool	ipolicer;
+	bool	nix_multiple_dwrr_mtu;   /* Multiple DWRR_MTU to choose from */
 	bool	npc_hash_extract; /* Hash extract enabled ? */
 	bool	npc_exact_match_enabled; /* Exact match supported ? */
 };
@@ -802,6 +803,7 @@ int nix_aq_context_read(struct rvu *rvu, struct nix_hw *nix_hw,
 			struct nix_cn10k_aq_enq_rsp *aq_rsp,
 			u16 pcifunc, u8 ctype, u32 qidx);
 int rvu_get_nix_blkaddr(struct rvu *rvu, u16 pcifunc);
+int nix_get_dwrr_mtu_reg(struct rvu_hwinfo *hw, int smq_link_type);
 u32 convert_dwrr_mtu_to_bytes(u8 dwrr_mtu);
 u32 convert_bytes_to_dwrr_mtu(u32 bytes);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index 548549604c49..41df5ac23f92 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -1413,7 +1413,8 @@ static int rvu_af_dl_dwrr_mtu_set(struct devlink *devlink, u32 id,
 	u64 dwrr_mtu;
 
 	dwrr_mtu = convert_bytes_to_dwrr_mtu(ctx->val.vu32);
-	rvu_write64(rvu, BLKADDR_NIX0, NIX_AF_DWRR_RPM_MTU, dwrr_mtu);
+	rvu_write64(rvu, BLKADDR_NIX0,
+		    nix_get_dwrr_mtu_reg(rvu->hw, SMQ_LINK_TYPE_RPM), dwrr_mtu);
 
 	return 0;
 }
@@ -1428,7 +1429,8 @@ static int rvu_af_dl_dwrr_mtu_get(struct devlink *devlink, u32 id,
 	if (!rvu->hw->cap.nix_common_dwrr_mtu)
 		return -EOPNOTSUPP;
 
-	dwrr_mtu = rvu_read64(rvu, BLKADDR_NIX0, NIX_AF_DWRR_RPM_MTU);
+	dwrr_mtu = rvu_read64(rvu, BLKADDR_NIX0,
+			      nix_get_dwrr_mtu_reg(rvu->hw, SMQ_LINK_TYPE_RPM));
 	ctx->val.vu32 = convert_dwrr_mtu_to_bytes(dwrr_mtu);
 
 	return 0;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index ee52b86c061f..f069d13dcb54 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -191,6 +191,18 @@ struct nix_hw *get_nix_hw(struct rvu_hwinfo *hw, int blkaddr)
 	return NULL;
 }
 
+int nix_get_dwrr_mtu_reg(struct rvu_hwinfo *hw, int smq_link_type)
+{
+	if (hw->cap.nix_multiple_dwrr_mtu)
+		return NIX_AF_DWRR_MTUX(smq_link_type);
+
+	if (smq_link_type == SMQ_LINK_TYPE_SDP)
+		return NIX_AF_DWRR_SDP_MTU;
+
+	/* Here it's same reg for RPM and LBK */
+	return NIX_AF_DWRR_RPM_MTU;
+}
+
 u32 convert_dwrr_mtu_to_bytes(u8 dwrr_mtu)
 {
 	dwrr_mtu &= 0x1FULL;
@@ -3191,10 +3203,16 @@ static int nix_setup_txschq(struct rvu *rvu, struct nix_hw *nix_hw, int blkaddr)
 	}
 
 	/* Setup a default value of 8192 as DWRR MTU */
-	if (rvu->hw->cap.nix_common_dwrr_mtu) {
-		rvu_write64(rvu, blkaddr, NIX_AF_DWRR_RPM_MTU,
+	if (rvu->hw->cap.nix_common_dwrr_mtu ||
+	    rvu->hw->cap.nix_multiple_dwrr_mtu) {
+		rvu_write64(rvu, blkaddr,
+			    nix_get_dwrr_mtu_reg(rvu->hw, SMQ_LINK_TYPE_RPM),
 			    convert_bytes_to_dwrr_mtu(8192));
-		rvu_write64(rvu, blkaddr, NIX_AF_DWRR_SDP_MTU,
+		rvu_write64(rvu, blkaddr,
+			    nix_get_dwrr_mtu_reg(rvu->hw, SMQ_LINK_TYPE_LBK),
+			    convert_bytes_to_dwrr_mtu(8192));
+		rvu_write64(rvu, blkaddr,
+			    nix_get_dwrr_mtu_reg(rvu->hw, SMQ_LINK_TYPE_SDP),
 			    convert_bytes_to_dwrr_mtu(8192));
 	}
 
@@ -3292,19 +3310,28 @@ int rvu_mbox_handler_nix_get_hw_info(struct rvu *rvu, struct msg_req *req,
 
 	rsp->min_mtu = NIC_HW_MIN_FRS;
 
-	if (!rvu->hw->cap.nix_common_dwrr_mtu) {
+	if (!rvu->hw->cap.nix_common_dwrr_mtu &&
+	    !rvu->hw->cap.nix_multiple_dwrr_mtu) {
 		/* Return '1' on OTx2 */
 		rsp->rpm_dwrr_mtu = 1;
 		rsp->sdp_dwrr_mtu = 1;
+		rsp->lbk_dwrr_mtu = 1;
 		return 0;
 	}
 
-	dwrr_mtu = rvu_read64(rvu, BLKADDR_NIX0, NIX_AF_DWRR_RPM_MTU);
+	/* Return DWRR_MTU for TLx_SCHEDULE[RR_WEIGHT] config */
+	dwrr_mtu = rvu_read64(rvu, blkaddr,
+			      nix_get_dwrr_mtu_reg(rvu->hw, SMQ_LINK_TYPE_RPM));
 	rsp->rpm_dwrr_mtu = convert_dwrr_mtu_to_bytes(dwrr_mtu);
 
-	dwrr_mtu = rvu_read64(rvu, BLKADDR_NIX0, NIX_AF_DWRR_SDP_MTU);
+	dwrr_mtu = rvu_read64(rvu, blkaddr,
+			      nix_get_dwrr_mtu_reg(rvu->hw, SMQ_LINK_TYPE_SDP));
 	rsp->sdp_dwrr_mtu = convert_dwrr_mtu_to_bytes(dwrr_mtu);
 
+	dwrr_mtu = rvu_read64(rvu, blkaddr,
+			      nix_get_dwrr_mtu_reg(rvu->hw, SMQ_LINK_TYPE_LBK));
+	rsp->lbk_dwrr_mtu = convert_dwrr_mtu_to_bytes(dwrr_mtu);
+
 	return 0;
 }
 
@@ -4371,8 +4398,11 @@ static void rvu_nix_setup_capabilities(struct rvu *rvu, int blkaddr)
 	 * Check if HW uses a common MTU for all DWRR quantum configs.
 	 * On OcteonTx2 this register field is '0'.
 	 */
-	if (((hw_const >> 56) & 0x10) == 0x10)
+	if ((((hw_const >> 56) & 0x10) == 0x10) && !(hw_const & BIT_ULL(61)))
 		hw->cap.nix_common_dwrr_mtu = true;
+
+	if (hw_const & BIT_ULL(61))
+		hw->cap.nix_multiple_dwrr_mtu = true;
 }
 
 static int rvu_nix_block_init(struct rvu *rvu, struct nix_hw *nix_hw)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 7007f0b8e659..b42e631e52d0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -272,7 +272,8 @@
 #define NIX_AF_DEBUG_NPC_RESP_DATAX(a)          (0x680 | (a) << 3)
 #define NIX_AF_SMQX_CFG(a)                      (0x700 | (a) << 16)
 #define NIX_AF_SQM_DBG_CTL_STATUS               (0x750)
-#define NIX_AF_DWRR_SDP_MTU                     (0x790)
+#define NIX_AF_DWRR_SDP_MTU                     (0x790) /* All CN10K except CN10KB */
+#define NIX_AF_DWRR_MTUX(a)			(0x790 | (a) << 16) /* Only for CN10KB */
 #define NIX_AF_DWRR_RPM_MTU                     (0x7A0)
 #define NIX_AF_PSE_CHANNEL_LEVEL                (0x800)
 #define NIX_AF_PSE_SHAPER_CFG                   (0x810)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index a79cb680bb23..77c8f650f7ac 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -8,6 +8,7 @@
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <net/tso.h>
+#include <linux/bitfield.h>
 
 #include "otx2_reg.h"
 #include "otx2_common.h"
@@ -642,6 +643,10 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl, int prio, bool txschq_for
 		req->regval[0] = ((u64)pfvf->tx_max_pktlen << 8) | OTX2_MIN_MTU;
 		req->regval[0] |= (0x20ULL << 51) | (0x80ULL << 39) |
 				  (0x2ULL << 36);
+		/* Set link type for DWRR MTU selection on CN10K silicons */
+		if (!is_dev_otx2(pfvf->pdev))
+			req->regval[0] |= FIELD_PREP(GENMASK_ULL(58, 57),
+						(u64)hw->smq_link_type);
 		req->num_regs++;
 		/* MDQ config */
 		parent = schq_list[NIX_TXSCH_LVL_TL4][prio];
@@ -1824,6 +1829,17 @@ void otx2_set_cints_affinity(struct otx2_nic *pfvf)
 	}
 }
 
+static u32 get_dwrr_mtu(struct otx2_nic *pfvf, struct nix_hw_info *hw)
+{
+	if (is_otx2_lbkvf(pfvf->pdev)) {
+		pfvf->hw.smq_link_type = SMQ_LINK_TYPE_LBK;
+		return hw->lbk_dwrr_mtu;
+	}
+
+	pfvf->hw.smq_link_type = SMQ_LINK_TYPE_RPM;
+	return hw->rpm_dwrr_mtu;
+}
+
 u16 otx2_get_max_mtu(struct otx2_nic *pfvf)
 {
 	struct nix_hw_info *rsp;
@@ -1853,7 +1869,7 @@ u16 otx2_get_max_mtu(struct otx2_nic *pfvf)
 		max_mtu = rsp->max_mtu - 8 - OTX2_ETH_HLEN;
 
 		/* Also save DWRR MTU, needed for DWRR weight calculation */
-		pfvf->hw.dwrr_mtu = rsp->rpm_dwrr_mtu;
+		pfvf->hw.dwrr_mtu = get_dwrr_mtu(pfvf, rsp);
 		if (!pfvf->hw.dwrr_mtu)
 			pfvf->hw.dwrr_mtu = 1;
 	}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index a9ed15d1793a..ba8091131ec0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -227,6 +227,7 @@ struct otx2_hw {
 	u16			txschq_list[NIX_TXSCH_LVL_CNT][MAX_TXSCHQ_PER_FUNC];
 	u16			matchall_ipolicer;
 	u32			dwrr_mtu;
+	u8			smq_link_type;
 
 	/* HW settings, coalescing etc */
 	u16			rx_chan_base;
-- 
2.39.0.198.ga38d39a4c5


