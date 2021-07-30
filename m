Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1F03DB80B
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 13:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238736AbhG3Ltg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 07:49:36 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9272 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238616AbhG3Ltd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 07:49:33 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16UBksN3025859;
        Fri, 30 Jul 2021 04:49:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=vGBFje1cAQBIRATwqBJdz/4kjbpQxAL+Q7SsKEDNQss=;
 b=ckIXhIOx/+emJ4qOPZ6jkdqnxFL8+/uyPFcV5BBwGeU7KcNqQs/fYDIEUlVT/+g3VlrP
 sykpNz6WxVd8knLxo7dz84wtflVMLFg+GHKCQz4CYLvhTl+mO4OIxulra35piVgalOpv
 OUratt5PmDA46xVj1bCF2PariNkAXJ47hm5iR2b2xDF01ZrxAzDkDVSDwrgox3O3t597
 icfPbrsp70yklUUcwxGFfPqZ/VkN7FAi977qmn0zBkGRgQJ/dbu190WlJ53Qn6FRweKj
 xoG7PVxsR7sGJ9Y63dVsYbXbUvfr7/lpBgKfEAICxZ4XHuoN6Ng1+bAKM826CDGJ8x/w DQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3a4866sv41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 30 Jul 2021 04:49:25 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 30 Jul
 2021 04:49:23 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 30 Jul 2021 04:49:23 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id 222EB3F7050;
        Fri, 30 Jul 2021 04:49:21 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Sunil Goutham <sgoutham@marvell.com>
Subject: [net-next PATCH 1/2] octeontx2-af: cn10k: DWRR MTU configuration
Date:   Fri, 30 Jul 2021 17:19:13 +0530
Message-ID: <1627645754-18131-2-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1627645754-18131-1-git-send-email-sgoutham@marvell.com>
References: <1627645754-18131-1-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 43ja_DtCwJaPz9DC0_jsWxtp7js_rGf2
X-Proofpoint-ORIG-GUID: 43ja_DtCwJaPz9DC0_jsWxtp7js_rGf2
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-30_05:2021-07-30,2021-07-30 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On OcteonTx2 DWRR quantum is directly configured into each of
the transmit scheduler queues. And PF/VF drivers were free to
config any value upto 2^24.

On CN10K, HW is modified, the quantum configuration at scheduler
queues is in terms of weight. And SW needs to setup a base DWRR MTU
at NIX_AF_DWRR_RPM_MTU / NIX_AF_DWRR_SDP_MTU. HW will do
'DWRR MTU * weight' to get the quantum. For LBK traffic, value
programmed into NIX_AF_DWRR_RPM_MTU register is considered as
DWRR MTU.

This patch programs a default DWRR MTU of 8192 into HW and also
provides a way to change this via devlink params.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/common.h |   1 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   3 +
 .../ethernet/marvell/octeontx2/af/rvu_devlink.c    | 110 ++++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  88 ++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |   2 +
 5 files changed, 201 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
index 47f5ed0..e9a52b1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
@@ -150,6 +150,7 @@ enum nix_scheduler {
 #define DFLT_RR_WEIGHT			71
 #define DFLT_RR_QTM	((DFLT_RR_WEIGHT * TXSCH_RR_QTM_MAX) \
 			 / MAX_SCHED_WEIGHT)
+#define CN10K_MAX_DWRR_WEIGHT          16384 /* Weight is 14bit on CN10K */
 
 /* Min/Max packet sizes, excluding FCS */
 #define	NIC_HW_MIN_FRS			40
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 91503fb..95591e7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -329,6 +329,7 @@ struct hw_cap {
 	bool	nix_shaping;		 /* Is shaping and coloring supported */
 	bool	nix_tx_link_bp;		 /* Can link backpressure TL queues ? */
 	bool	nix_rx_multicast;	 /* Rx packet replication support */
+	bool	nix_common_dwrr_mtu;	 /* Common DWRR MTU for quantum config */
 	bool	per_pf_mbox_regs; /* PF mbox specified in per PF registers ? */
 	bool	programmable_chans; /* Channels programmable ? */
 	bool	ipolicer;
@@ -706,6 +707,8 @@ int nix_aq_context_read(struct rvu *rvu, struct nix_hw *nix_hw,
 			struct nix_cn10k_aq_enq_rsp *aq_rsp,
 			u16 pcifunc, u8 ctype, u32 qidx);
 int rvu_get_nix_blkaddr(struct rvu *rvu, u16 pcifunc);
+u32 convert_dwrr_mtu_to_bytes(u8 dwrr_mtu);
+u32 convert_bytes_to_dwrr_mtu(u32 bytes);
 
 /* NPC APIs */
 int rvu_npc_init(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index 2688186..f95573a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -1364,6 +1364,89 @@ static void rvu_health_reporters_destroy(struct rvu *rvu)
 	rvu_nix_health_reporters_destroy(rvu_dl);
 }
 
+/* Devlink Params APIs */
+static int rvu_af_dl_dwrr_mtu_validate(struct devlink *devlink, u32 id,
+				       union devlink_param_value val,
+				       struct netlink_ext_ack *extack)
+{
+	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
+	struct rvu *rvu = rvu_dl->rvu;
+	int dwrr_mtu = val.vu32;
+	struct nix_txsch *txsch;
+	struct nix_hw *nix_hw;
+
+	if (!rvu->hw->cap.nix_common_dwrr_mtu) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Setting DWRR_MTU is not supported on this silicon");
+		return -EOPNOTSUPP;
+	}
+
+	if ((dwrr_mtu > 65536 || !is_power_of_2(dwrr_mtu)) &&
+	    (dwrr_mtu != 9728 && dwrr_mtu != 10240)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Invalid, supported MTUs are 0,2,4,8.16,32,64....4K,8K,32K,64K and 9728, 10240");
+		return -EINVAL;
+	}
+
+	nix_hw = get_nix_hw(rvu->hw, BLKADDR_NIX0);
+	if (!nix_hw)
+		return -ENODEV;
+
+	txsch = &nix_hw->txsch[NIX_TXSCH_LVL_SMQ];
+	if (rvu_rsrc_free_count(&txsch->schq) != txsch->schq.max) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Changing DWRR MTU is not supported when there are active NIXLFs");
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Makesure none of the PF/VF interfaces are initialized and retry");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int rvu_af_dl_dwrr_mtu_set(struct devlink *devlink, u32 id,
+				  struct devlink_param_gset_ctx *ctx)
+{
+	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
+	struct rvu *rvu = rvu_dl->rvu;
+	u64 dwrr_mtu;
+
+	dwrr_mtu = convert_bytes_to_dwrr_mtu(ctx->val.vu32);
+	rvu_write64(rvu, BLKADDR_NIX0, NIX_AF_DWRR_RPM_MTU, dwrr_mtu);
+
+	return 0;
+}
+
+static int rvu_af_dl_dwrr_mtu_get(struct devlink *devlink, u32 id,
+				  struct devlink_param_gset_ctx *ctx)
+{
+	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
+	struct rvu *rvu = rvu_dl->rvu;
+	u64 dwrr_mtu;
+
+	if (!rvu->hw->cap.nix_common_dwrr_mtu)
+		return -EOPNOTSUPP;
+
+	dwrr_mtu = rvu_read64(rvu, BLKADDR_NIX0, NIX_AF_DWRR_RPM_MTU);
+	ctx->val.vu32 = convert_dwrr_mtu_to_bytes(dwrr_mtu);
+
+	return 0;
+}
+
+enum rvu_af_dl_param_id {
+	RVU_AF_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	RVU_AF_DEVLINK_PARAM_ID_DWRR_MTU,
+};
+
+static const struct devlink_param rvu_af_dl_params[] = {
+	DEVLINK_PARAM_DRIVER(RVU_AF_DEVLINK_PARAM_ID_DWRR_MTU,
+			     "dwrr_mtu", DEVLINK_PARAM_TYPE_U32,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     rvu_af_dl_dwrr_mtu_get, rvu_af_dl_dwrr_mtu_set,
+			     rvu_af_dl_dwrr_mtu_validate),
+};
+
+/* Devlink switch mode */
 static int rvu_devlink_eswitch_mode_get(struct devlink *devlink, u16 *mode)
 {
 	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
@@ -1438,7 +1521,30 @@ int rvu_register_dl(struct rvu *rvu)
 	rvu_dl->rvu = rvu;
 	rvu->rvu_dl = rvu_dl;
 
-	return rvu_health_reporters_create(rvu);
+	err = rvu_health_reporters_create(rvu);
+	if (err) {
+		dev_err(rvu->dev,
+			"devlink health reporter creation failed with error %d\n", err);
+		goto err_dl_health;
+	}
+
+	err = devlink_params_register(dl, rvu_af_dl_params,
+				      ARRAY_SIZE(rvu_af_dl_params));
+	if (err) {
+		dev_err(rvu->dev,
+			"devlink params register failed with error %d", err);
+		goto err_dl_health;
+	}
+
+	devlink_params_publish(dl);
+
+	return 0;
+
+err_dl_health:
+	rvu_health_reporters_destroy(rvu);
+	devlink_unregister(dl);
+	devlink_free(dl);
+	return err;
 }
 
 void rvu_unregister_dl(struct rvu *rvu)
@@ -1449,6 +1555,8 @@ void rvu_unregister_dl(struct rvu *rvu)
 	if (!dl)
 		return;
 
+	devlink_params_unregister(dl, rvu_af_dl_params,
+				  ARRAY_SIZE(rvu_af_dl_params));
 	rvu_health_reporters_destroy(rvu);
 	devlink_unregister(dl);
 	devlink_free(dl);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 0933699..5c68367 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -192,6 +192,47 @@ struct nix_hw *get_nix_hw(struct rvu_hwinfo *hw, int blkaddr)
 	return NULL;
 }
 
+u32 convert_dwrr_mtu_to_bytes(u8 dwrr_mtu)
+{
+	dwrr_mtu &= 0x1FULL;
+
+	/* MTU used for DWRR calculation is in power of 2 up until 64K bytes.
+	 * Value of 4 is reserved for MTU value of 9728 bytes.
+	 * Value of 5 is reserved for MTU value of 10240 bytes.
+	 */
+	switch (dwrr_mtu) {
+	case 4:
+		return 9728;
+	case 5:
+		return 10240;
+	default:
+		return BIT_ULL(dwrr_mtu);
+	}
+
+	return 0;
+}
+
+u32 convert_bytes_to_dwrr_mtu(u32 bytes)
+{
+	/* MTU used for DWRR calculation is in power of 2 up until 64K bytes.
+	 * Value of 4 is reserved for MTU value of 9728 bytes.
+	 * Value of 5 is reserved for MTU value of 10240 bytes.
+	 */
+	if (bytes > BIT_ULL(16))
+		return 0;
+
+	switch (bytes) {
+	case 9728:
+		return 4;
+	case 10240:
+		return 5;
+	default:
+		return ilog2(bytes);
+	}
+
+	return 0;
+}
+
 static void nix_rx_sync(struct rvu *rvu, int blkaddr)
 {
 	int err;
@@ -1946,8 +1987,17 @@ static void nix_tl1_default_cfg(struct rvu *rvu, struct nix_hw *nix_hw,
 		return;
 	rvu_write64(rvu, blkaddr, NIX_AF_TL1X_TOPOLOGY(schq),
 		    (TXSCH_TL1_DFLT_RR_PRIO << 1));
-	rvu_write64(rvu, blkaddr, NIX_AF_TL1X_SCHEDULE(schq),
-		    TXSCH_TL1_DFLT_RR_QTM);
+
+	/* On OcteonTx2 the config was in bytes and newer silcons
+	 * it's changed to weight.
+	 */
+	if (!rvu->hw->cap.nix_common_dwrr_mtu)
+		rvu_write64(rvu, blkaddr, NIX_AF_TL1X_SCHEDULE(schq),
+			    TXSCH_TL1_DFLT_RR_QTM);
+	else
+		rvu_write64(rvu, blkaddr, NIX_AF_TL1X_SCHEDULE(schq),
+			    CN10K_MAX_DWRR_WEIGHT);
+
 	rvu_write64(rvu, blkaddr, NIX_AF_TL1X_CIR(schq), 0x00);
 	pfvf_map[schq] = TXSCH_SET_FLAG(pfvf_map[schq], NIX_TXSCHQ_CFG_DONE);
 }
@@ -2655,6 +2705,15 @@ static int nix_setup_txschq(struct rvu *rvu, struct nix_hw *nix_hw, int blkaddr)
 		for (schq = 0; schq < txsch->schq.max; schq++)
 			txsch->pfvf_map[schq] = TXSCH_MAP(0, NIX_TXSCHQ_FREE);
 	}
+
+	/* Setup a default value of 8192 as DWRR MTU */
+	if (rvu->hw->cap.nix_common_dwrr_mtu) {
+		rvu_write64(rvu, blkaddr, NIX_AF_DWRR_RPM_MTU,
+			    convert_bytes_to_dwrr_mtu(8192));
+		rvu_write64(rvu, blkaddr, NIX_AF_DWRR_SDP_MTU,
+			    convert_bytes_to_dwrr_mtu(8192));
+	}
+
 	return 0;
 }
 
@@ -3635,6 +3694,28 @@ static int nix_aq_init(struct rvu *rvu, struct rvu_block *block)
 	return 0;
 }
 
+static void rvu_nix_setup_capabilities(struct rvu *rvu, int blkaddr)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	u64 hw_const;
+
+	hw_const = rvu_read64(rvu, blkaddr, NIX_AF_CONST1);
+
+	/* On OcteonTx2 DWRR quantum is directly configured into each of
+	 * the transmit scheduler queues. And PF/VF drivers were free to
+	 * config any value upto 2^24.
+	 * On CN10K, HW is modified, the quantum configuration at scheduler
+	 * queues is in terms of weight. And SW needs to setup a base DWRR MTU
+	 * at NIX_AF_DWRR_RPM_MTU / NIX_AF_DWRR_SDP_MTU. HW will do
+	 * 'DWRR MTU * weight' to get the quantum.
+	 *
+	 * Check if HW uses a common MTU for all DWRR quantum configs.
+	 * On OcteonTx2 this register field is '0'.
+	 */
+	if (((hw_const >> 56) & 0x10) == 0x10)
+		hw->cap.nix_common_dwrr_mtu = true;
+}
+
 static int rvu_nix_block_init(struct rvu *rvu, struct nix_hw *nix_hw)
 {
 	const struct npc_lt_def_cfg *ltdefs;
@@ -3672,6 +3753,9 @@ static int rvu_nix_block_init(struct rvu *rvu, struct nix_hw *nix_hw)
 	if (err)
 		return err;
 
+	/* Setup capabilities of the NIX block */
+	rvu_nix_setup_capabilities(rvu, blkaddr);
+
 	/* Initialize admin queue */
 	err = nix_aq_init(rvu, block);
 	if (err)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 8b01ef6..6efcf3a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -269,6 +269,8 @@
 #define NIX_AF_DEBUG_NPC_RESP_DATAX(a)          (0x680 | (a) << 3)
 #define NIX_AF_SMQX_CFG(a)                      (0x700 | (a) << 16)
 #define NIX_AF_SQM_DBG_CTL_STATUS               (0x750)
+#define NIX_AF_DWRR_SDP_MTU                     (0x790)
+#define NIX_AF_DWRR_RPM_MTU                     (0x7A0)
 #define NIX_AF_PSE_CHANNEL_LEVEL                (0x800)
 #define NIX_AF_PSE_SHAPER_CFG                   (0x810)
 #define NIX_AF_TX_EXPR_CREDIT			(0x830)
-- 
2.7.4

