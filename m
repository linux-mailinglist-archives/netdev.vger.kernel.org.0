Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890743A7D5E
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 13:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhFOLis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 07:38:48 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42198 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229909AbhFOLil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 07:38:41 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15FBUEsl022121;
        Tue, 15 Jun 2021 04:34:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=adu6TDM0FFGxZUyMQcK94amNpFTt0l95DAqWW/6EyeQ=;
 b=aM3As09ArAfD1f2jVdRA+rNI4tuj5Ko9YN/YIDG8I45gdWdNInwa5IuWWgkXwmUYWsC7
 YdTMi7vo47QiuOzPtTNs47hC59OeaRU2obJdATHvk6kIdiOOHPErkIkBHQldQtq73fzb
 XTQXC3IseIEi6MAu9McVT81Xp8imDR5MaYfvau2pW/e6Qm96lsm+K3mbkQggkMTTuinr
 aNfS1ecH28e4atBfxx1R9h3U9dG1Vk2ZkU3saeD89TunbAoAuLsClSKElB+hM/6yTc2d
 8erAfbPDTqOBwwlhT2OnvfppQeR1w3uCvd5jnQ+T96Iw88sUHBeRkFtEncEjTsGw44U6 RA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 396m0uj1wk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 15 Jun 2021 04:34:45 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 15 Jun
 2021 04:34:44 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 15 Jun 2021 04:34:44 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 11EBB3F70A6;
        Tue, 15 Jun 2021 04:34:41 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 1/5] octeontx2-af: cn10k: Bandwidth profiles config support
Date:   Tue, 15 Jun 2021 17:04:27 +0530
Message-ID: <1623756871-12524-2-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623756871-12524-1-git-send-email-sbhatta@marvell.com>
References: <1623756871-12524-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: eRMVh3h4GcDr8I6MpU8SyQEan-6iu6PF
X-Proofpoint-ORIG-GUID: eRMVh3h4GcDr8I6MpU8SyQEan-6iu6PF
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-15_04:2021-06-14,2021-06-15 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

CN10K silicons supports hierarchial ingress packet ratelimiting.
There are 3 levels of profilers supported leaf, mid and top.
Ratelimiting is done after packet forwarding decision is taken
and a NIXLF's RQ is identified to DMA the packet. RQ's context
points to a leaf bandwidth profile which can be configured
to achieve desired ratelimit.

This patch adds logic for management of these bandwidth profiles
ie profile alloc, free, context update etc.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  40 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  11 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 619 ++++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |   5 +
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |   8 +
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |  78 ++-
 6 files changed, 757 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index aee6a6f..7d7dfa8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -260,7 +260,11 @@ M(NIX_BP_DISABLE,	0x8017, nix_bp_disable, nix_bp_cfg_req, msg_rsp) \
 M(NIX_GET_MAC_ADDR, 0x8018, nix_get_mac_addr, msg_req, nix_get_mac_addr_rsp) \
 M(NIX_CN10K_AQ_ENQ,	0x8019, nix_cn10k_aq_enq, nix_cn10k_aq_enq_req, \
 				nix_cn10k_aq_enq_rsp)			\
-M(NIX_GET_HW_INFO,	0x801a, nix_get_hw_info, msg_req, nix_hw_info)
+M(NIX_GET_HW_INFO,	0x801c, nix_get_hw_info, msg_req, nix_hw_info)	\
+M(NIX_BANDPROF_ALLOC,	0x801d, nix_bandprof_alloc, nix_bandprof_alloc_req, \
+				nix_bandprof_alloc_rsp)			    \
+M(NIX_BANDPROF_FREE,	0x801e, nix_bandprof_free, nix_bandprof_free_req,   \
+				msg_rsp)
 
 /* Messages initiated by AF (range 0xC00 - 0xDFF) */
 #define MBOX_UP_CGX_MESSAGES						\
@@ -615,6 +619,9 @@ enum nix_af_status {
 	NIX_AF_ERR_PTP_CONFIG_FAIL  = -423,
 	NIX_AF_ERR_NPC_KEY_NOT_SUPP = -424,
 	NIX_AF_ERR_INVALID_NIXBLK   = -425,
+	NIX_AF_ERR_INVALID_BANDPROF = -426,
+	NIX_AF_ERR_IPOLICER_NOTSUPP = -427,
+	NIX_AF_ERR_BANDPROF_INVAL_REQ  = -428,
 };
 
 /* For NIX RX vtag action  */
@@ -683,6 +690,7 @@ struct nix_cn10k_aq_enq_req {
 		struct nix_cq_ctx_s cq;
 		struct nix_rsse_s   rss;
 		struct nix_rx_mce_s mce;
+		struct nix_bandprof_s prof;
 	};
 	union {
 		struct nix_cn10k_rq_ctx_s rq_mask;
@@ -690,6 +698,7 @@ struct nix_cn10k_aq_enq_req {
 		struct nix_cq_ctx_s cq_mask;
 		struct nix_rsse_s   rss_mask;
 		struct nix_rx_mce_s mce_mask;
+		struct nix_bandprof_s prof_mask;
 	};
 };
 
@@ -701,6 +710,7 @@ struct nix_cn10k_aq_enq_rsp {
 		struct nix_cq_ctx_s cq;
 		struct nix_rsse_s   rss;
 		struct nix_rx_mce_s mce;
+		struct nix_bandprof_s prof;
 	};
 };
 
@@ -716,6 +726,7 @@ struct nix_aq_enq_req {
 		struct nix_cq_ctx_s cq;
 		struct nix_rsse_s   rss;
 		struct nix_rx_mce_s mce;
+		u64 prof;
 	};
 	union {
 		struct nix_rq_ctx_s rq_mask;
@@ -723,6 +734,7 @@ struct nix_aq_enq_req {
 		struct nix_cq_ctx_s cq_mask;
 		struct nix_rsse_s   rss_mask;
 		struct nix_rx_mce_s mce_mask;
+		u64 prof_mask;
 	};
 };
 
@@ -734,6 +746,7 @@ struct nix_aq_enq_rsp {
 		struct nix_cq_ctx_s cq;
 		struct nix_rsse_s   rss;
 		struct nix_rx_mce_s mce;
+		u64 prof;
 	};
 };
 
@@ -975,6 +988,31 @@ struct nix_hw_info {
 	u16 min_mtu;
 };
 
+struct nix_bandprof_alloc_req {
+	struct mbox_msghdr hdr;
+	/* Count of profiles needed per layer */
+	u16 prof_count[BAND_PROF_NUM_LAYERS];
+};
+
+struct nix_bandprof_alloc_rsp {
+	struct mbox_msghdr hdr;
+	u16 prof_count[BAND_PROF_NUM_LAYERS];
+
+	/* There is no need to allocate morethan 1 bandwidth profile
+	 * per RQ of a PF_FUNC's NIXLF. So limit the maximum
+	 * profiles to 64 per PF_FUNC.
+	 */
+#define MAX_BANDPROF_PER_PFFUNC	64
+	u16 prof_idx[BAND_PROF_NUM_LAYERS][MAX_BANDPROF_PER_PFFUNC];
+};
+
+struct nix_bandprof_free_req {
+	struct mbox_msghdr hdr;
+	u8 free_all;
+	u16 prof_count[BAND_PROF_NUM_LAYERS];
+	u16 prof_idx[BAND_PROF_NUM_LAYERS][MAX_BANDPROF_PER_PFFUNC];
+};
+
 /* NPC mbox message structs */
 
 #define NPC_MCAM_ENTRY_INVALID	0xFFFF
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index c88dab7..4d2a5ca 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -296,6 +296,13 @@ struct nix_txvlan {
 	struct mutex rsrc_lock; /* Serialize resource alloc/free */
 };
 
+struct nix_ipolicer {
+	struct rsrc_bmap band_prof;
+	u16 *pfvf_map;
+	u16 *match_id;
+	u16 *ref_count;
+};
+
 struct nix_hw {
 	int blkaddr;
 	struct rvu *rvu;
@@ -305,6 +312,7 @@ struct nix_hw {
 	struct nix_mark_format mark_format;
 	struct nix_lso lso;
 	struct nix_txvlan txvlan;
+	struct nix_ipolicer *ipolicer;
 };
 
 /* RVU block's capabilities or functionality,
@@ -322,6 +330,7 @@ struct hw_cap {
 	bool	nix_rx_multicast;	 /* Rx packet replication support */
 	bool	per_pf_mbox_regs; /* PF mbox specified in per PF registers ? */
 	bool	programmable_chans; /* Channels programmable ? */
+	bool	ipolicer;
 };
 
 struct rvu_hwinfo {
@@ -672,6 +681,8 @@ int rvu_get_next_nix_blkaddr(struct rvu *rvu, int blkaddr);
 void rvu_nix_reset_mac(struct rvu_pfvf *pfvf, int pcifunc);
 int nix_get_struct_ptrs(struct rvu *rvu, u16 pcifunc,
 			struct nix_hw **nix_hw, int *blkaddr);
+int rvu_nix_setup_ratelimit_aggr(struct rvu *rvu, u16 pcifunc,
+				 u16 rq_idx, u16 match_id);
 
 /* NPC APIs */
 int rvu_npc_init(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index d8cb665..ebd73a8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -23,6 +23,14 @@ static int rvu_nix_get_bpid(struct rvu *rvu, struct nix_bp_cfg_req *req,
 			    int type, int chan_id);
 static int nix_update_mce_rule(struct rvu *rvu, u16 pcifunc,
 			       int type, bool add);
+static int nix_setup_ipolicers(struct rvu *rvu,
+			       struct nix_hw *nix_hw, int blkaddr);
+static void nix_ipolicer_freemem(struct nix_hw *nix_hw);
+static int nix_verify_bandprof(struct nix_cn10k_aq_enq_req *req,
+			       struct nix_hw *nix_hw, u16 pcifunc);
+static int nix_free_all_bandprof(struct rvu *rvu, u16 pcifunc);
+static void nix_clear_ratelimit_aggr(struct rvu *rvu, struct nix_hw *nix_hw,
+				     u32 leaf_prof);
 
 enum mc_tbl_sz {
 	MC_TBL_SZ_256,
@@ -699,8 +707,11 @@ static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, struct nix_hw *nix_hw,
 	pfvf = rvu_get_pfvf(rvu, pcifunc);
 	nixlf = rvu_get_lf(rvu, block, pcifunc, 0);
 
-	/* Skip NIXLF check for broadcast MCE entry init */
-	if (!(!rsp && req->ctype == NIX_AQ_CTYPE_MCE)) {
+	/* Skip NIXLF check for broadcast MCE entry and bandwidth profile
+	 * operations done by AF itself.
+	 */
+	if (!((!rsp && req->ctype == NIX_AQ_CTYPE_MCE) ||
+	      (req->ctype == NIX_AQ_CTYPE_BANDPROF && !pcifunc))) {
 		if (!pfvf->nixlf || nixlf < 0)
 			return NIX_AF_ERR_AF_LF_INVALID;
 	}
@@ -740,6 +751,11 @@ static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, struct nix_hw *nix_hw,
 		if (rsp)
 			rc = NIX_AF_ERR_AQ_ENQUEUE;
 		break;
+	case NIX_AQ_CTYPE_BANDPROF:
+		if (nix_verify_bandprof((struct nix_cn10k_aq_enq_req *)req,
+					nix_hw, pcifunc))
+			rc = NIX_AF_ERR_INVALID_BANDPROF;
+		break;
 	default:
 		rc = NIX_AF_ERR_AQ_ENQUEUE;
 	}
@@ -796,6 +812,9 @@ static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, struct nix_hw *nix_hw,
 		else if (req->ctype == NIX_AQ_CTYPE_MCE)
 			memcpy(mask, &req->mce_mask,
 			       sizeof(struct nix_rx_mce_s));
+		else if (req->ctype == NIX_AQ_CTYPE_BANDPROF)
+			memcpy(mask, &req->prof_mask,
+			       sizeof(struct nix_bandprof_s));
 		fallthrough;
 	case NIX_AQ_INSTOP_INIT:
 		if (req->ctype == NIX_AQ_CTYPE_RQ)
@@ -808,6 +827,8 @@ static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, struct nix_hw *nix_hw,
 			memcpy(ctx, &req->rss, sizeof(struct nix_rsse_s));
 		else if (req->ctype == NIX_AQ_CTYPE_MCE)
 			memcpy(ctx, &req->mce, sizeof(struct nix_rx_mce_s));
+		else if (req->ctype == NIX_AQ_CTYPE_BANDPROF)
+			memcpy(ctx, &req->prof, sizeof(struct nix_bandprof_s));
 		break;
 	case NIX_AQ_INSTOP_NOP:
 	case NIX_AQ_INSTOP_READ:
@@ -885,6 +906,9 @@ static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, struct nix_hw *nix_hw,
 			else if (req->ctype == NIX_AQ_CTYPE_MCE)
 				memcpy(&rsp->mce, ctx,
 				       sizeof(struct nix_rx_mce_s));
+			else if (req->ctype == NIX_AQ_CTYPE_BANDPROF)
+				memcpy(&rsp->prof, ctx,
+				       sizeof(struct nix_bandprof_s));
 		}
 	}
 
@@ -3624,6 +3648,10 @@ static int rvu_nix_block_init(struct rvu *rvu, struct nix_hw *nix_hw)
 		if (err)
 			return err;
 
+		err = nix_setup_ipolicers(rvu, nix_hw, blkaddr);
+		if (err)
+			return err;
+
 		err = nix_af_mark_format_setup(rvu, nix_hw, blkaddr);
 		if (err)
 			return err;
@@ -3772,6 +3800,8 @@ static void rvu_nix_block_freemem(struct rvu *rvu, int blkaddr,
 			kfree(txsch->schq.bmap);
 		}
 
+		nix_ipolicer_freemem(nix_hw);
+
 		vlan = &nix_hw->txvlan;
 		kfree(vlan->rsrc.bmap);
 		mutex_destroy(&vlan->rsrc_lock);
@@ -3879,6 +3909,8 @@ void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int nixlf)
 	}
 
 	nix_ctx_free(rvu, pfvf);
+
+	nix_free_all_bandprof(rvu, pcifunc);
 }
 
 #define NIX_AF_LFX_TX_CFG_PTP_EN	BIT_ULL(32)
@@ -3987,3 +4019,586 @@ void rvu_nix_reset_mac(struct rvu_pfvf *pfvf, int pcifunc)
 	if (from_vf)
 		ether_addr_copy(pfvf->mac_addr, pfvf->default_mac);
 }
+
+/* NIX ingress policers or bandwidth profiles APIs */
+static void nix_config_rx_pkt_policer_precolor(struct rvu *rvu, int blkaddr)
+{
+	struct npc_lt_def_cfg defs, *ltdefs;
+
+	ltdefs = &defs;
+	memcpy(ltdefs, rvu->kpu.lt_def, sizeof(struct npc_lt_def_cfg));
+
+	/* Extract PCP and DEI fields from outer VLAN from byte offset
+	 * 2 from the start of LB_PTR (ie TAG).
+	 * VLAN0 is Outer VLAN and VLAN1 is Inner VLAN. Inner VLAN
+	 * fields are considered when 'Tunnel enable' is set in profile.
+	 */
+	rvu_write64(rvu, blkaddr, NIX_AF_RX_DEF_VLAN0_PCP_DEI,
+		    (2UL << 12) | (ltdefs->ovlan.lid << 8) |
+		    (ltdefs->ovlan.ltype_match << 4) |
+		    ltdefs->ovlan.ltype_mask);
+	rvu_write64(rvu, blkaddr, NIX_AF_RX_DEF_VLAN1_PCP_DEI,
+		    (2UL << 12) | (ltdefs->ivlan.lid << 8) |
+		    (ltdefs->ivlan.ltype_match << 4) |
+		    ltdefs->ivlan.ltype_mask);
+
+	/* DSCP field in outer and tunneled IPv4 packets */
+	rvu_write64(rvu, blkaddr, NIX_AF_RX_DEF_OIP4_DSCP,
+		    (1UL << 12) | (ltdefs->rx_oip4.lid << 8) |
+		    (ltdefs->rx_oip4.ltype_match << 4) |
+		    ltdefs->rx_oip4.ltype_mask);
+	rvu_write64(rvu, blkaddr, NIX_AF_RX_DEF_IIP4_DSCP,
+		    (1UL << 12) | (ltdefs->rx_iip4.lid << 8) |
+		    (ltdefs->rx_iip4.ltype_match << 4) |
+		    ltdefs->rx_iip4.ltype_mask);
+
+	/* DSCP field (traffic class) in outer and tunneled IPv6 packets */
+	rvu_write64(rvu, blkaddr, NIX_AF_RX_DEF_OIP6_DSCP,
+		    (1UL << 11) | (ltdefs->rx_oip6.lid << 8) |
+		    (ltdefs->rx_oip6.ltype_match << 4) |
+		    ltdefs->rx_oip6.ltype_mask);
+	rvu_write64(rvu, blkaddr, NIX_AF_RX_DEF_IIP6_DSCP,
+		    (1UL << 11) | (ltdefs->rx_iip6.lid << 8) |
+		    (ltdefs->rx_iip6.ltype_match << 4) |
+		    ltdefs->rx_iip6.ltype_mask);
+}
+
+static int nix_init_policer_context(struct rvu *rvu, struct nix_hw *nix_hw,
+				    int layer, int prof_idx)
+{
+	struct nix_cn10k_aq_enq_req aq_req;
+	int rc;
+
+	memset(&aq_req, 0, sizeof(struct nix_cn10k_aq_enq_req));
+
+	aq_req.qidx = (prof_idx & 0x3FFF) | (layer << 14);
+	aq_req.ctype = NIX_AQ_CTYPE_BANDPROF;
+	aq_req.op = NIX_AQ_INSTOP_INIT;
+
+	/* Context is all zeros, submit to AQ */
+	rc = rvu_nix_blk_aq_enq_inst(rvu, nix_hw,
+				     (struct nix_aq_enq_req *)&aq_req, NULL);
+	if (rc)
+		dev_err(rvu->dev, "Failed to INIT bandwidth profile layer %d profile %d\n",
+			layer, prof_idx);
+	return rc;
+}
+
+static int nix_setup_ipolicers(struct rvu *rvu,
+			       struct nix_hw *nix_hw, int blkaddr)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	struct nix_ipolicer *ipolicer;
+	int err, layer, prof_idx;
+	u64 cfg;
+
+	cfg = rvu_read64(rvu, blkaddr, NIX_AF_CONST);
+	if (!(cfg & BIT_ULL(61))) {
+		hw->cap.ipolicer = false;
+		return 0;
+	}
+
+	hw->cap.ipolicer = true;
+	nix_hw->ipolicer = devm_kcalloc(rvu->dev, BAND_PROF_NUM_LAYERS,
+					sizeof(*ipolicer), GFP_KERNEL);
+	if (!nix_hw->ipolicer)
+		return -ENOMEM;
+
+	cfg = rvu_read64(rvu, blkaddr, NIX_AF_PL_CONST);
+
+	for (layer = 0; layer < BAND_PROF_NUM_LAYERS; layer++) {
+		ipolicer = &nix_hw->ipolicer[layer];
+		switch (layer) {
+		case BAND_PROF_LEAF_LAYER:
+			ipolicer->band_prof.max = cfg & 0XFFFF;
+			break;
+		case BAND_PROF_MID_LAYER:
+			ipolicer->band_prof.max = (cfg >> 16) & 0XFFFF;
+			break;
+		case BAND_PROF_TOP_LAYER:
+			ipolicer->band_prof.max = (cfg >> 32) & 0XFFFF;
+			break;
+		}
+
+		if (!ipolicer->band_prof.max)
+			continue;
+
+		err = rvu_alloc_bitmap(&ipolicer->band_prof);
+		if (err)
+			return err;
+
+		ipolicer->pfvf_map = devm_kcalloc(rvu->dev,
+						  ipolicer->band_prof.max,
+						  sizeof(u16), GFP_KERNEL);
+		if (!ipolicer->pfvf_map)
+			return -ENOMEM;
+
+		ipolicer->match_id = devm_kcalloc(rvu->dev,
+						  ipolicer->band_prof.max,
+						  sizeof(u16), GFP_KERNEL);
+		if (!ipolicer->match_id)
+			return -ENOMEM;
+
+		for (prof_idx = 0;
+		     prof_idx < ipolicer->band_prof.max; prof_idx++) {
+			/* Set AF as current owner for INIT ops to succeed */
+			ipolicer->pfvf_map[prof_idx] = 0x00;
+
+			/* There is no enable bit in the profile context,
+			 * so no context disable. So let's INIT them here
+			 * so that PF/VF later on have to just do WRITE to
+			 * setup policer rates and config.
+			 */
+			err = nix_init_policer_context(rvu, nix_hw,
+						       layer, prof_idx);
+			if (err)
+				return err;
+		}
+
+		/* Allocate memory for maintaining ref_counts for MID level
+		 * profiles, this will be needed for leaf layer profiles'
+		 * aggregation.
+		 */
+		if (layer != BAND_PROF_MID_LAYER)
+			continue;
+
+		ipolicer->ref_count = devm_kcalloc(rvu->dev,
+						   ipolicer->band_prof.max,
+						   sizeof(u16), GFP_KERNEL);
+	}
+
+	/* Set policer timeunit to 2us ie  (19 + 1) * 100 nsec = 2us */
+	rvu_write64(rvu, blkaddr, NIX_AF_PL_TS, 19);
+
+	nix_config_rx_pkt_policer_precolor(rvu, blkaddr);
+
+	return 0;
+}
+
+static void nix_ipolicer_freemem(struct nix_hw *nix_hw)
+{
+	struct nix_ipolicer *ipolicer;
+	int layer;
+
+	for (layer = 0; layer < BAND_PROF_NUM_LAYERS; layer++) {
+		ipolicer = &nix_hw->ipolicer[layer];
+
+		if (!ipolicer->band_prof.max)
+			continue;
+
+		kfree(ipolicer->band_prof.bmap);
+	}
+}
+
+static int nix_verify_bandprof(struct nix_cn10k_aq_enq_req *req,
+			       struct nix_hw *nix_hw, u16 pcifunc)
+{
+	struct nix_ipolicer *ipolicer;
+	int layer, hi_layer, prof_idx;
+
+	/* Bits [15:14] in profile index represent layer */
+	layer = (req->qidx >> 14) & 0x03;
+	prof_idx = req->qidx & 0x3FFF;
+
+	ipolicer = &nix_hw->ipolicer[layer];
+	if (prof_idx >= ipolicer->band_prof.max)
+		return -EINVAL;
+
+	/* Check if the profile is allocated to the requesting PCIFUNC or not
+	 * with the exception of AF. AF is allowed to read and update contexts.
+	 */
+	if (pcifunc && ipolicer->pfvf_map[prof_idx] != pcifunc)
+		return -EINVAL;
+
+	/* If this profile is linked to higher layer profile then check
+	 * if that profile is also allocated to the requesting PCIFUNC
+	 * or not.
+	 */
+	if (!req->prof.hl_en)
+		return 0;
+
+	/* Leaf layer profile can link only to mid layer and
+	 * mid layer to top layer.
+	 */
+	if (layer == BAND_PROF_LEAF_LAYER)
+		hi_layer = BAND_PROF_MID_LAYER;
+	else if (layer == BAND_PROF_MID_LAYER)
+		hi_layer = BAND_PROF_TOP_LAYER;
+	else
+		return -EINVAL;
+
+	ipolicer = &nix_hw->ipolicer[hi_layer];
+	prof_idx = req->prof.band_prof_id;
+	if (prof_idx >= ipolicer->band_prof.max ||
+	    ipolicer->pfvf_map[prof_idx] != pcifunc)
+		return -EINVAL;
+
+	return 0;
+}
+
+int rvu_mbox_handler_nix_bandprof_alloc(struct rvu *rvu,
+					struct nix_bandprof_alloc_req *req,
+					struct nix_bandprof_alloc_rsp *rsp)
+{
+	int blkaddr, layer, prof, idx, err;
+	u16 pcifunc = req->hdr.pcifunc;
+	struct nix_ipolicer *ipolicer;
+	struct nix_hw *nix_hw;
+
+	if (!rvu->hw->cap.ipolicer)
+		return NIX_AF_ERR_IPOLICER_NOTSUPP;
+
+	err = nix_get_struct_ptrs(rvu, pcifunc, &nix_hw, &blkaddr);
+	if (err)
+		return err;
+
+	mutex_lock(&rvu->rsrc_lock);
+	for (layer = 0; layer < BAND_PROF_NUM_LAYERS; layer++) {
+		if (layer == BAND_PROF_INVAL_LAYER)
+			continue;
+		if (!req->prof_count[layer])
+			continue;
+
+		ipolicer = &nix_hw->ipolicer[layer];
+		for (idx = 0; idx < req->prof_count[layer]; idx++) {
+			/* Allocate a max of 'MAX_BANDPROF_PER_PFFUNC' profiles */
+			if (idx == MAX_BANDPROF_PER_PFFUNC)
+				break;
+
+			prof = rvu_alloc_rsrc(&ipolicer->band_prof);
+			if (prof < 0)
+				break;
+			rsp->prof_count[layer]++;
+			rsp->prof_idx[layer][idx] = prof;
+			ipolicer->pfvf_map[prof] = pcifunc;
+		}
+	}
+	mutex_unlock(&rvu->rsrc_lock);
+	return 0;
+}
+
+static int nix_free_all_bandprof(struct rvu *rvu, u16 pcifunc)
+{
+	int blkaddr, layer, prof_idx, err;
+	struct nix_ipolicer *ipolicer;
+	struct nix_hw *nix_hw;
+
+	if (!rvu->hw->cap.ipolicer)
+		return NIX_AF_ERR_IPOLICER_NOTSUPP;
+
+	err = nix_get_struct_ptrs(rvu, pcifunc, &nix_hw, &blkaddr);
+	if (err)
+		return err;
+
+	mutex_lock(&rvu->rsrc_lock);
+	/* Free all the profiles allocated to the PCIFUNC */
+	for (layer = 0; layer < BAND_PROF_NUM_LAYERS; layer++) {
+		if (layer == BAND_PROF_INVAL_LAYER)
+			continue;
+		ipolicer = &nix_hw->ipolicer[layer];
+
+		for (prof_idx = 0; prof_idx < ipolicer->band_prof.max; prof_idx++) {
+			if (ipolicer->pfvf_map[prof_idx] != pcifunc)
+				continue;
+
+			/* Clear ratelimit aggregation, if any */
+			if (layer == BAND_PROF_LEAF_LAYER &&
+			    ipolicer->match_id[prof_idx])
+				nix_clear_ratelimit_aggr(rvu, nix_hw, prof_idx);
+
+			ipolicer->pfvf_map[prof_idx] = 0x00;
+			ipolicer->match_id[prof_idx] = 0;
+			rvu_free_rsrc(&ipolicer->band_prof, prof_idx);
+		}
+	}
+	mutex_unlock(&rvu->rsrc_lock);
+	return 0;
+}
+
+int rvu_mbox_handler_nix_bandprof_free(struct rvu *rvu,
+				       struct nix_bandprof_free_req *req,
+				       struct msg_rsp *rsp)
+{
+	int blkaddr, layer, prof_idx, idx, err;
+	u16 pcifunc = req->hdr.pcifunc;
+	struct nix_ipolicer *ipolicer;
+	struct nix_hw *nix_hw;
+
+	if (req->free_all)
+		return nix_free_all_bandprof(rvu, pcifunc);
+
+	if (!rvu->hw->cap.ipolicer)
+		return NIX_AF_ERR_IPOLICER_NOTSUPP;
+
+	err = nix_get_struct_ptrs(rvu, pcifunc, &nix_hw, &blkaddr);
+	if (err)
+		return err;
+
+	mutex_lock(&rvu->rsrc_lock);
+	/* Free the requested profile indices */
+	for (layer = 0; layer < BAND_PROF_NUM_LAYERS; layer++) {
+		if (layer == BAND_PROF_INVAL_LAYER)
+			continue;
+		if (!req->prof_count[layer])
+			continue;
+
+		ipolicer = &nix_hw->ipolicer[layer];
+		for (idx = 0; idx < req->prof_count[layer]; idx++) {
+			prof_idx = req->prof_idx[layer][idx];
+			if (prof_idx >= ipolicer->band_prof.max ||
+			    ipolicer->pfvf_map[prof_idx] != pcifunc)
+				continue;
+
+			/* Clear ratelimit aggregation, if any */
+			if (layer == BAND_PROF_LEAF_LAYER &&
+			    ipolicer->match_id[prof_idx])
+				nix_clear_ratelimit_aggr(rvu, nix_hw, prof_idx);
+
+			ipolicer->pfvf_map[prof_idx] = 0x00;
+			ipolicer->match_id[prof_idx] = 0;
+			rvu_free_rsrc(&ipolicer->band_prof, prof_idx);
+			if (idx == MAX_BANDPROF_PER_PFFUNC)
+				break;
+		}
+	}
+	mutex_unlock(&rvu->rsrc_lock);
+	return 0;
+}
+
+static int nix_aq_context_read(struct rvu *rvu, struct nix_hw *nix_hw,
+			       struct nix_cn10k_aq_enq_req *aq_req,
+			       struct nix_cn10k_aq_enq_rsp *aq_rsp,
+			       u16 pcifunc, u8 ctype, u32 qidx)
+{
+	memset(aq_req, 0, sizeof(struct nix_cn10k_aq_enq_req));
+	aq_req->hdr.pcifunc = pcifunc;
+	aq_req->ctype = ctype;
+	aq_req->op = NIX_AQ_INSTOP_READ;
+	aq_req->qidx = qidx;
+
+	return rvu_nix_blk_aq_enq_inst(rvu, nix_hw,
+				       (struct nix_aq_enq_req *)aq_req,
+				       (struct nix_aq_enq_rsp *)aq_rsp);
+}
+
+static int nix_ipolicer_map_leaf_midprofs(struct rvu *rvu,
+					  struct nix_hw *nix_hw,
+					  struct nix_cn10k_aq_enq_req *aq_req,
+					  struct nix_cn10k_aq_enq_rsp *aq_rsp,
+					  u32 leaf_prof, u16 mid_prof)
+{
+	memset(aq_req, 0, sizeof(struct nix_cn10k_aq_enq_req));
+	aq_req->hdr.pcifunc = 0x00;
+	aq_req->ctype = NIX_AQ_CTYPE_BANDPROF;
+	aq_req->op = NIX_AQ_INSTOP_WRITE;
+	aq_req->qidx = leaf_prof;
+
+	aq_req->prof.band_prof_id = mid_prof;
+	aq_req->prof_mask.band_prof_id = GENMASK(6, 0);
+	aq_req->prof.hl_en = 1;
+	aq_req->prof_mask.hl_en = 1;
+
+	return rvu_nix_blk_aq_enq_inst(rvu, nix_hw,
+				       (struct nix_aq_enq_req *)aq_req,
+				       (struct nix_aq_enq_rsp *)aq_rsp);
+}
+
+int rvu_nix_setup_ratelimit_aggr(struct rvu *rvu, u16 pcifunc,
+				 u16 rq_idx, u16 match_id)
+{
+	int leaf_prof, mid_prof, leaf_match;
+	struct nix_cn10k_aq_enq_req aq_req;
+	struct nix_cn10k_aq_enq_rsp aq_rsp;
+	struct nix_ipolicer *ipolicer;
+	struct nix_hw *nix_hw;
+	int blkaddr, idx, rc;
+
+	if (!rvu->hw->cap.ipolicer)
+		return 0;
+
+	rc = nix_get_struct_ptrs(rvu, pcifunc, &nix_hw, &blkaddr);
+	if (rc)
+		return rc;
+
+	/* Fetch the RQ's context to see if policing is enabled */
+	rc = nix_aq_context_read(rvu, nix_hw, &aq_req, &aq_rsp, pcifunc,
+				 NIX_AQ_CTYPE_RQ, rq_idx);
+	if (rc) {
+		dev_err(rvu->dev,
+			"%s: Failed to fetch RQ%d context of PFFUNC 0x%x\n",
+			__func__, rq_idx, pcifunc);
+		return rc;
+	}
+
+	if (!aq_rsp.rq.policer_ena)
+		return 0;
+
+	/* Get the bandwidth profile ID mapped to this RQ */
+	leaf_prof = aq_rsp.rq.band_prof_id;
+
+	ipolicer = &nix_hw->ipolicer[BAND_PROF_LEAF_LAYER];
+	ipolicer->match_id[leaf_prof] = match_id;
+
+	/* Check if any other leaf profile is marked with same match_id */
+	for (idx = 0; idx < ipolicer->band_prof.max; idx++) {
+		if (idx == leaf_prof)
+			continue;
+		if (ipolicer->match_id[idx] != match_id)
+			continue;
+
+		leaf_match = idx;
+		break;
+	}
+
+	if (idx == ipolicer->band_prof.max)
+		return 0;
+
+	/* Fetch the matching profile's context to check if it's already
+	 * mapped to a mid level profile.
+	 */
+	rc = nix_aq_context_read(rvu, nix_hw, &aq_req, &aq_rsp, 0x00,
+				 NIX_AQ_CTYPE_BANDPROF, leaf_match);
+	if (rc) {
+		dev_err(rvu->dev,
+			"%s: Failed to fetch context of leaf profile %d\n",
+			__func__, leaf_match);
+		return rc;
+	}
+
+	ipolicer = &nix_hw->ipolicer[BAND_PROF_MID_LAYER];
+	if (aq_rsp.prof.hl_en) {
+		/* Get Mid layer prof index and map leaf_prof index
+		 * also such that flows that are being steered
+		 * to different RQs and marked with same match_id
+		 * are rate limited in a aggregate fashion
+		 */
+		mid_prof = aq_rsp.prof.band_prof_id;
+		rc = nix_ipolicer_map_leaf_midprofs(rvu, nix_hw,
+						    &aq_req, &aq_rsp,
+						    leaf_prof, mid_prof);
+		if (rc) {
+			dev_err(rvu->dev,
+				"%s: Failed to map leaf(%d) and mid(%d) profiles\n",
+				__func__, leaf_prof, mid_prof);
+			goto exit;
+		}
+
+		mutex_lock(&rvu->rsrc_lock);
+		ipolicer->ref_count[mid_prof]++;
+		mutex_unlock(&rvu->rsrc_lock);
+		goto exit;
+	}
+
+	/* Allocate a mid layer profile and
+	 * map both 'leaf_prof' and 'leaf_match' profiles to it.
+	 */
+	mutex_lock(&rvu->rsrc_lock);
+	mid_prof = rvu_alloc_rsrc(&ipolicer->band_prof);
+	if (mid_prof < 0) {
+		dev_err(rvu->dev,
+			"%s: Unable to allocate mid layer profile\n", __func__);
+		mutex_unlock(&rvu->rsrc_lock);
+		goto exit;
+	}
+	mutex_unlock(&rvu->rsrc_lock);
+	ipolicer->pfvf_map[mid_prof] = 0x00;
+	ipolicer->ref_count[mid_prof] = 0;
+
+	/* Initialize mid layer profile same as 'leaf_prof' */
+	rc = nix_aq_context_read(rvu, nix_hw, &aq_req, &aq_rsp, 0x00,
+				 NIX_AQ_CTYPE_BANDPROF, leaf_prof);
+	if (rc) {
+		dev_err(rvu->dev,
+			"%s: Failed to fetch context of leaf profile %d\n",
+			__func__, leaf_prof);
+		goto exit;
+	}
+
+	memset(&aq_req, 0, sizeof(struct nix_cn10k_aq_enq_req));
+	aq_req.hdr.pcifunc = 0x00;
+	aq_req.qidx = (mid_prof & 0x3FFF) | (BAND_PROF_MID_LAYER << 14);
+	aq_req.ctype = NIX_AQ_CTYPE_BANDPROF;
+	aq_req.op = NIX_AQ_INSTOP_WRITE;
+	memcpy(&aq_req.prof, &aq_rsp.prof, sizeof(struct nix_bandprof_s));
+	/* Clear higher layer enable bit in the mid profile, just in case */
+	aq_req.prof.hl_en = 0;
+	aq_req.prof_mask.hl_en = 1;
+
+	rc = rvu_nix_blk_aq_enq_inst(rvu, nix_hw,
+				     (struct nix_aq_enq_req *)&aq_req, NULL);
+	if (rc) {
+		dev_err(rvu->dev,
+			"%s: Failed to INIT context of mid layer profile %d\n",
+			__func__, mid_prof);
+		goto exit;
+	}
+
+	/* Map both leaf profiles to this mid layer profile */
+	rc = nix_ipolicer_map_leaf_midprofs(rvu, nix_hw,
+					    &aq_req, &aq_rsp,
+					    leaf_prof, mid_prof);
+	if (rc) {
+		dev_err(rvu->dev,
+			"%s: Failed to map leaf(%d) and mid(%d) profiles\n",
+			__func__, leaf_prof, mid_prof);
+		goto exit;
+	}
+
+	mutex_lock(&rvu->rsrc_lock);
+	ipolicer->ref_count[mid_prof]++;
+	mutex_unlock(&rvu->rsrc_lock);
+
+	rc = nix_ipolicer_map_leaf_midprofs(rvu, nix_hw,
+					    &aq_req, &aq_rsp,
+					    leaf_match, mid_prof);
+	if (rc) {
+		dev_err(rvu->dev,
+			"%s: Failed to map leaf(%d) and mid(%d) profiles\n",
+			__func__, leaf_match, mid_prof);
+		ipolicer->ref_count[mid_prof]--;
+		goto exit;
+	}
+
+	mutex_lock(&rvu->rsrc_lock);
+	ipolicer->ref_count[mid_prof]++;
+	mutex_unlock(&rvu->rsrc_lock);
+
+exit:
+	return rc;
+}
+
+/* Called with mutex rsrc_lock */
+static void nix_clear_ratelimit_aggr(struct rvu *rvu, struct nix_hw *nix_hw,
+				     u32 leaf_prof)
+{
+	struct nix_cn10k_aq_enq_req aq_req;
+	struct nix_cn10k_aq_enq_rsp aq_rsp;
+	struct nix_ipolicer *ipolicer;
+	u16 mid_prof;
+	int rc;
+
+	mutex_unlock(&rvu->rsrc_lock);
+
+	rc = nix_aq_context_read(rvu, nix_hw, &aq_req, &aq_rsp, 0x00,
+				 NIX_AQ_CTYPE_BANDPROF, leaf_prof);
+
+	mutex_lock(&rvu->rsrc_lock);
+	if (rc) {
+		dev_err(rvu->dev,
+			"%s: Failed to fetch context of leaf profile %d\n",
+			__func__, leaf_prof);
+		return;
+	}
+
+	if (!aq_rsp.prof.hl_en)
+		return;
+
+	mid_prof = aq_rsp.prof.band_prof_id;
+	ipolicer = &nix_hw->ipolicer[BAND_PROF_MID_LAYER];
+	ipolicer->ref_count[mid_prof]--;
+	/* If ref_count is zero, free mid layer profile */
+	if (!ipolicer->ref_count[mid_prof]) {
+		ipolicer->pfvf_map[mid_prof] = 0x00;
+		rvu_free_rsrc(&ipolicer->band_prof, mid_prof);
+	}
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 6ba6a83..87d7c6a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -1110,6 +1110,11 @@ static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
 	    req->vtag0_type == NIX_AF_LFX_RX_VTAG_TYPE7)
 		rule->vfvlan_cfg = true;
 
+	if (is_npc_intf_rx(req->intf) && req->match_id &&
+	    (req->op == NIX_RX_ACTIONOP_UCAST || req->op == NIX_RX_ACTIONOP_RSS))
+		return rvu_nix_setup_ratelimit_aggr(rvu, req->hdr.pcifunc,
+					     req->index, req->match_id);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index ce365ae..76837d5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -171,6 +171,7 @@
 #define NIX_AF_SQ_CONST			(0x0040)
 #define NIX_AF_CQ_CONST			(0x0048)
 #define NIX_AF_RQ_CONST			(0x0050)
+#define NIX_AF_PL_CONST			(0x0058)
 #define NIX_AF_PSE_CONST		(0x0060)
 #define NIX_AF_TL1_CONST		(0x0070)
 #define NIX_AF_TL2_CONST		(0x0078)
@@ -181,6 +182,7 @@
 #define NIX_AF_LSO_CFG			(0x00A8)
 #define NIX_AF_BLK_RST			(0x00B0)
 #define NIX_AF_TX_TSTMP_CFG		(0x00C0)
+#define NIX_AF_PL_TS			(0x00C8)
 #define NIX_AF_RX_CFG			(0x00D0)
 #define NIX_AF_AVG_DELAY		(0x00E0)
 #define NIX_AF_CINT_DELAY		(0x00F0)
@@ -212,7 +214,9 @@
 #define NIX_AF_RX_DEF_OL2		(0x0200)
 #define NIX_AF_RX_DEF_OIP4		(0x0210)
 #define NIX_AF_RX_DEF_IIP4		(0x0220)
+#define NIX_AF_RX_DEF_VLAN0_PCP_DEI	(0x0228)
 #define NIX_AF_RX_DEF_OIP6		(0x0230)
+#define NIX_AF_RX_DEF_VLAN1_PCP_DEI	(0x0238)
 #define NIX_AF_RX_DEF_IIP6		(0x0240)
 #define NIX_AF_RX_DEF_OTCP		(0x0250)
 #define NIX_AF_RX_DEF_ITCP		(0x0260)
@@ -223,6 +227,10 @@
 #define NIX_AF_RX_DEF_ISCTP		(0x02A0)
 #define NIX_AF_RX_DEF_IPSECX		(0x02B0)
 #define NIX_AF_RX_DEF_CST_APAD1		(0x02A8)
+#define NIX_AF_RX_DEF_IIP4_DSCP		(0x02E0)
+#define NIX_AF_RX_DEF_OIP4_DSCP		(0x02E8)
+#define NIX_AF_RX_DEF_IIP6_DSCP		(0x02F0)
+#define NIX_AF_RX_DEF_OIP6_DSCP		(0x02F8)
 #define NIX_AF_RX_IPSEC_GEN_CFG		(0x0300)
 #define NIX_AF_RX_CPTX_INST_ADDR	(0x0310)
 #define NIX_AF_NDC_TX_SYNC		(0x03F0)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index 5e5f45c..8fb002d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
@@ -286,7 +286,7 @@ enum nix_aq_ctype {
 	NIX_AQ_CTYPE_MCE  = 0x3,
 	NIX_AQ_CTYPE_RSS  = 0x4,
 	NIX_AQ_CTYPE_DYNO = 0x5,
-	NIX_AQ_CTYPE_BAND_PROF = 0x6,
+	NIX_AQ_CTYPE_BANDPROF = 0x6,
 };
 
 /* NIX admin queue instruction opcodes */
@@ -665,6 +665,82 @@ struct nix_rx_mce_s {
 	uint64_t next       : 16;
 };
 
+enum nix_band_prof_layers {
+	BAND_PROF_LEAF_LAYER = 0,
+	BAND_PROF_INVAL_LAYER = 1,
+	BAND_PROF_MID_LAYER = 2,
+	BAND_PROF_TOP_LAYER = 3,
+	BAND_PROF_NUM_LAYERS = 4,
+};
+
+enum NIX_RX_BAND_PROF_ACTIONRESULT_E {
+	NIX_RX_BAND_PROF_ACTIONRESULT_PASS = 0x0,
+	NIX_RX_BAND_PROF_ACTIONRESULT_DROP = 0x1,
+	NIX_RX_BAND_PROF_ACTIONRESULT_RED = 0x2,
+};
+
+/* NIX ingress policer bandwidth profile structure */
+struct nix_bandprof_s {
+	uint64_t pc_mode                     :  2; /* W0 */
+	uint64_t icolor                      :  2;
+	uint64_t tnl_ena                     :  1;
+	uint64_t reserved_5_7                :  3;
+	uint64_t peir_exponent               :  5;
+	uint64_t reserved_13_15              :  3;
+	uint64_t pebs_exponent               :  5;
+	uint64_t reserved_21_23              :  3;
+	uint64_t cir_exponent                :  5;
+	uint64_t reserved_29_31              :  3;
+	uint64_t cbs_exponent                :  5;
+	uint64_t reserved_37_39              :  3;
+	uint64_t peir_mantissa               :  8;
+	uint64_t pebs_mantissa               :  8;
+	uint64_t cir_mantissa                :  8;
+	uint64_t cbs_mantissa                :  8; /* W1 */
+	uint64_t lmode                       :  1;
+	uint64_t l_sellect                   :  3;
+	uint64_t rdiv                        :  4;
+	uint64_t adjust_exponent             :  5;
+	uint64_t reserved_85_86              :  2;
+	uint64_t adjust_mantissa             :  9;
+	uint64_t gc_action                   :  2;
+	uint64_t yc_action                   :  2;
+	uint64_t rc_action                   :  2;
+	uint64_t meter_algo                  :  2;
+	uint64_t band_prof_id                :  7;
+	uint64_t reserved_111_118            :  8;
+	uint64_t hl_en                       :  1;
+	uint64_t reserved_120_127            :  8;
+	uint64_t ts                          : 48; /* W2 */
+	uint64_t reserved_176_191            : 16;
+	uint64_t pe_accum                    : 32; /* W3 */
+	uint64_t c_accum                     : 32;
+	uint64_t green_pkt_pass              : 48; /* W4 */
+	uint64_t reserved_304_319            : 16;
+	uint64_t yellow_pkt_pass             : 48; /* W5 */
+	uint64_t reserved_368_383            : 16;
+	uint64_t red_pkt_pass                : 48; /* W6 */
+	uint64_t reserved_432_447            : 16;
+	uint64_t green_octs_pass             : 48; /* W7 */
+	uint64_t reserved_496_511            : 16;
+	uint64_t yellow_octs_pass            : 48; /* W8 */
+	uint64_t reserved_560_575            : 16;
+	uint64_t red_octs_pass               : 48; /* W9 */
+	uint64_t reserved_624_639            : 16;
+	uint64_t green_pkt_drop              : 48; /* W10 */
+	uint64_t reserved_688_703            : 16;
+	uint64_t yellow_pkt_drop             : 48; /* W11 */
+	uint64_t reserved_752_767            : 16;
+	uint64_t red_pkt_drop                : 48; /* W12 */
+	uint64_t reserved_816_831            : 16;
+	uint64_t green_octs_drop             : 48; /* W13 */
+	uint64_t reserved_880_895            : 16;
+	uint64_t yellow_octs_drop            : 48; /* W14 */
+	uint64_t reserved_944_959            : 16;
+	uint64_t red_octs_drop               : 48; /* W15 */
+	uint64_t reserved_1008_1023          : 16;
+};
+
 enum nix_lsoalg {
 	NIX_LSOALG_NOP,
 	NIX_LSOALG_ADD_SEGNUM,
-- 
2.7.4

