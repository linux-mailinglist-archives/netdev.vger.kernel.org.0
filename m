Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A41BEFFAA9
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 17:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfKQQOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 11:14:53 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45455 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfKQQOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 11:14:53 -0500
Received: by mail-pg1-f194.google.com with SMTP id k1so7068136pgg.12
        for <netdev@vger.kernel.org>; Sun, 17 Nov 2019 08:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CmluEfEdxNM7IjzcbWcI5Mx4MRamjAdYqojfkib/sVg=;
        b=cEffH+5CAhqNX00UJwTOONT5usVipWUL0MWWv36KJKqkz55FwuBIJShz1F6Evtnn+Q
         aP+rR68AdYaCs8h2A6F6nE8MAmdi1P+o4oM2ikkGoO3/pSBK8LvWC2UTpVmSg9jpYhjx
         VE3iLLh6RscZX7idi3FsddDJSnEGHLiTqKwdDNtJTcMiiWqO9A4EuJHhVH1NLAZFCaUj
         QoxNPAiZ59+GuVkXLntXB1JxewuCVhDEnq4dMdl99V193SVZYSicvGsbmNZqR5RrIIAL
         LjhYVwqjYxacSg/y3jSqAhDK3f7djsuEhxtJrFmZufNFSeFOOkFey+ELwg7ucpsabZcM
         DXdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CmluEfEdxNM7IjzcbWcI5Mx4MRamjAdYqojfkib/sVg=;
        b=t3hs4GmOx9f+LglwBpznSwwiSqTP00wOLzplaX5DVwGYK2VNxdF758uYuM0R928MCC
         R4blU9dTAYwzXbL7lwZm10X0G8Pdu4e/tlmohbNbbJpOyOoOEXisjCcbmCcptig9tYwv
         T4wf5llaxhZ6AROuw4xVrpaHzzSyKiT8eK4e3F+LTmqUnL8CkMMsPc/aaLCdFqeW44aD
         JCGp791O0mgC6P2bDohpfOJgmlqQPnX5t06rQL2oBsUzynQQJj3CnYgKvCo3dvG5/MUr
         yWJZm6nrdF2E0xkDJ53LvBJG03LZasDgx/c7mwkFsnIv5KPpJZTDHM6IG7hs2s6RFsvm
         +GVQ==
X-Gm-Message-State: APjAAAVv4r9DUum+zk7lyju7AkQuv7o3tKKQJftL9o1fHO+XCnYgxCC2
        XeAeNeFxQQW3anR5pHhT/Sps/GAlrzM=
X-Google-Smtp-Source: APXvYqykjE4HKym7itzQU3FT9l/OSEIbwev6r2R6pwa6RGH0zRFihk57hIbZz0m3v3pIXiFIu829Dw==
X-Received: by 2002:a63:588:: with SMTP id 130mr28539114pgf.148.1574007291661;
        Sun, 17 Nov 2019 08:14:51 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id v2sm2675231pgi.79.2019.11.17.08.14.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 17 Nov 2019 08:14:51 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 01/15] octeontx2-af: Interface backpressure configuration support
Date:   Sun, 17 Nov 2019 21:44:12 +0530
Message-Id: <1574007266-17123-2-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

Enables backpressure and assigns BPID for CGX and LBK channels.
96xx support upto 512 BPIDs, these BPIDs are statically divided
across CGX/LBK/SDP interfaces as follows.
BPIDs   0 - 191 are mapped to LMAC channels.
BPIDs 192 - 255 are mapped to LBK channels.
BPIDs 256 - 511 are mapped to SDP channels.

BPIDs across CGX LMAC channels are divided as follows.
CGX(0)_LMAC(0)_CHAN(0 - 15) mapped to BPIDs(0 - 15)
CGX(0)_LMAC(1)_CHAN(0 - 15) mapped to BPIDs(16 - 31)
.......
CGX(1)_LMAC(0)_CHAN(0 - 15) mapped to BPIDs(64 - 79)
....

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  26 +++-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 152 ++++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npa.c    |  13 +-
 3 files changed, 184 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index f143d7b..eea174d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -125,7 +125,7 @@ static inline struct mbox_msghdr *otx2_mbox_alloc_msg(struct otx2_mbox *mbox,
 M(READY,		0x001, ready, msg_req, ready_msg_rsp)		\
 M(ATTACH_RESOURCES,	0x002, attach_resources, rsrc_attach, msg_rsp)	\
 M(DETACH_RESOURCES,	0x003, detach_resources, rsrc_detach, msg_rsp)	\
-M(MSIX_OFFSET,		0x004, msix_offset, msg_req, msix_offset_rsp)	\
+M(MSIX_OFFSET,		0x005, msix_offset, msg_req, msix_offset_rsp)	\
 M(VF_FLR,		0x006, vf_flr, msg_req, msg_rsp)		\
 M(GET_HW_CAP,		0x008, get_hw_cap, msg_req, get_hw_cap_rsp)	\
 /* CGX mbox IDs (range 0x200 - 0x3FF) */				\
@@ -210,7 +210,10 @@ M(NIX_SET_RX_CFG,	0x8010, nix_set_rx_cfg, nix_rx_cfg, msg_rsp)	\
 M(NIX_LSO_FORMAT_CFG,	0x8011, nix_lso_format_cfg,			\
 				 nix_lso_format_cfg,			\
 				 nix_lso_format_cfg_rsp)		\
-M(NIX_RXVLAN_ALLOC,	0x8012, nix_rxvlan_alloc, msg_req, msg_rsp)
+M(NIX_RXVLAN_ALLOC,	0x8012, nix_rxvlan_alloc, msg_req, msg_rsp)	\
+M(NIX_BP_ENABLE,	0x8016, nix_bp_enable, nix_bp_cfg_req,	\
+				nix_bp_cfg_rsp)	\
+M(NIX_BP_DISABLE,	0x8017, nix_bp_disable, nix_bp_cfg_req, msg_rsp) \
 
 /* Messages initiated by AF (range 0xC00 - 0xDFF) */
 #define MBOX_UP_CGX_MESSAGES						\
@@ -670,6 +673,25 @@ struct nix_lso_format_cfg_rsp {
 	u8 lso_format_idx;
 };
 
+struct nix_bp_cfg_req {
+	struct mbox_msghdr hdr;
+	u16	chan_base; /* Starting channel number */
+	u8	chan_cnt; /* Number of channels */
+	u8	bpid_per_chan;
+	/* bpid_per_chan = 0  assigns single bp id for range of channels */
+	/* bpid_per_chan = 1 assigns separate bp id for each channel */
+};
+
+/* PF can be mapped to either CGX or LBK interface,
+ * so maximum 64 channels are possible.
+ */
+#define NIX_MAX_BPID_CHAN	64
+struct nix_bp_cfg_rsp {
+	struct mbox_msghdr hdr;
+	u16	chan_bpid[NIX_MAX_BPID_CHAN]; /* Channel and bpid mapping */
+	u8	chan_cnt; /* Number of channel for which bpids are assigned */
+};
+
 /* NPC mbox message structs */
 
 #define NPC_MCAM_ENTRY_INVALID	0xFFFF
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 8a59f7d..cb1d653 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -18,6 +18,8 @@
 #include "cgx.h"
 
 static int nix_update_bcast_mce_list(struct rvu *rvu, u16 pcifunc, bool add);
+static int rvu_nix_get_bpid(struct rvu *rvu, struct nix_bp_cfg_req *req,
+			    int type, int chan_id);
 
 enum mc_tbl_sz {
 	MC_TBL_SZ_256,
@@ -253,6 +255,142 @@ static void nix_interface_deinit(struct rvu *rvu, u16 pcifunc, u8 nixlf)
 	rvu_npc_disable_mcam_entries(rvu, pcifunc, nixlf);
 }
 
+int rvu_mbox_handler_nix_bp_disable(struct rvu *rvu,
+				    struct nix_bp_cfg_req *req,
+				    struct msg_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	struct rvu_pfvf *pfvf;
+	int blkaddr, pf, type;
+	u16 chan_base, chan;
+	u64 cfg;
+
+	pf = rvu_get_pf(pcifunc);
+	type = is_afvf(pcifunc) ? NIX_INTF_TYPE_LBK : NIX_INTF_TYPE_CGX;
+	if (!is_pf_cgxmapped(rvu, pf) && type != NIX_INTF_TYPE_LBK)
+		return 0;
+
+	pfvf = rvu_get_pfvf(rvu, pcifunc);
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
+
+	chan_base = pfvf->rx_chan_base + req->chan_base;
+	for (chan = chan_base; chan < (chan_base + req->chan_cnt); chan++) {
+		cfg = rvu_read64(rvu, blkaddr, NIX_AF_RX_CHANX_CFG(chan));
+		rvu_write64(rvu, blkaddr, NIX_AF_RX_CHANX_CFG(chan),
+			    cfg & ~BIT_ULL(16));
+	}
+	return 0;
+}
+
+static int rvu_nix_get_bpid(struct rvu *rvu, struct nix_bp_cfg_req *req,
+			    int type, int chan_id)
+{
+	int bpid, blkaddr, lmac_chan_cnt;
+	struct rvu_hwinfo *hw = rvu->hw;
+	u16 cgx_bpid_cnt, lbk_bpid_cnt;
+	struct rvu_pfvf *pfvf;
+	u8 cgx_id, lmac_id;
+	u64 cfg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, req->hdr.pcifunc);
+	cfg = rvu_read64(rvu, blkaddr, NIX_AF_CONST);
+	lmac_chan_cnt = cfg & 0xFF;
+
+	cgx_bpid_cnt = hw->cgx_links * lmac_chan_cnt;
+	lbk_bpid_cnt = hw->lbk_links * ((cfg >> 16) & 0xFF);
+
+	pfvf = rvu_get_pfvf(rvu, req->hdr.pcifunc);
+
+	/* Backpressure IDs range division
+	 * CGX  channles are mapped to (0 - 191) BPIDs
+	 * LBK	channles are mapped to (192 - 255) BPIDs
+	 * SDP  channles are mapped to (256 - 511) BPIDs
+	 *
+	 * Lmac channles and bpids mapped as follows
+	 * cgx(0)_lmac(0)_chan(0 - 15) = bpid(0 - 15)
+	 * cgx(0)_lmac(1)_chan(0 - 15) = bpid(16 - 31) ....
+	 * cgx(1)_lmac(0)_chan(0 - 15) = bpid(64 - 79) ....
+	 */
+	switch (type) {
+	case NIX_INTF_TYPE_CGX:
+		if ((req->chan_base + req->chan_cnt) > 15)
+			return -EINVAL;
+		rvu_get_cgx_lmac_id(pfvf->cgx_lmac, &cgx_id, &lmac_id);
+		/* Assign bpid based on cgx, lmac and chan id */
+		bpid = (cgx_id * hw->lmac_per_cgx * lmac_chan_cnt) +
+			(lmac_id * lmac_chan_cnt) + req->chan_base;
+
+		if (req->bpid_per_chan)
+			bpid += chan_id;
+		if (bpid > cgx_bpid_cnt)
+			return -EINVAL;
+		break;
+
+	case NIX_INTF_TYPE_LBK:
+		if ((req->chan_base + req->chan_cnt) > 63)
+			return -EINVAL;
+		bpid = cgx_bpid_cnt + req->chan_base;
+		if (req->bpid_per_chan)
+			bpid += chan_id;
+		if (bpid > (cgx_bpid_cnt + lbk_bpid_cnt))
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return bpid;
+}
+
+int rvu_mbox_handler_nix_bp_enable(struct rvu *rvu,
+				   struct nix_bp_cfg_req *req,
+				   struct nix_bp_cfg_rsp *rsp)
+{
+	int blkaddr, pf, type, chan_id = 0;
+	u16 pcifunc = req->hdr.pcifunc;
+	struct rvu_pfvf *pfvf;
+	u16 chan_base, chan;
+	s16 bpid, bpid_base;
+	u64 cfg;
+
+	pf = rvu_get_pf(pcifunc);
+	type = is_afvf(pcifunc) ? NIX_INTF_TYPE_LBK : NIX_INTF_TYPE_CGX;
+
+	/* Enable backpressure only for CGX mapped PFs and LBK interface */
+	if (!is_pf_cgxmapped(rvu, pf) && type != NIX_INTF_TYPE_LBK)
+		return 0;
+
+	pfvf = rvu_get_pfvf(rvu, pcifunc);
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
+
+	bpid_base = rvu_nix_get_bpid(rvu, req, type, chan_id);
+	chan_base = pfvf->rx_chan_base + req->chan_base;
+	bpid = bpid_base;
+
+	for (chan = chan_base; chan < (chan_base + req->chan_cnt); chan++) {
+		if (bpid < 0) {
+			dev_warn(rvu->dev, "Fail to enable backpessure\n");
+			return -EINVAL;
+		}
+
+		cfg = rvu_read64(rvu, blkaddr, NIX_AF_RX_CHANX_CFG(chan));
+		rvu_write64(rvu, blkaddr, NIX_AF_RX_CHANX_CFG(chan),
+			    cfg | (bpid & 0xFF) | BIT_ULL(16));
+		chan_id++;
+		bpid = rvu_nix_get_bpid(rvu, req, type, chan_id);
+	}
+
+	for (chan = 0; chan < req->chan_cnt; chan++) {
+		/* Map channel and bpid assign to it */
+		rsp->chan_bpid[chan] = ((req->chan_base + chan) & 0x7F) << 10 |
+					(bpid_base & 0x3FF);
+		if (req->bpid_per_chan)
+			bpid_base++;
+	}
+	rsp->chan_cnt = req->chan_cnt;
+
+	return 0;
+}
+
 static void nix_setup_lso_tso_l3(struct rvu *rvu, int blkaddr,
 				 u64 format, bool v4, u64 *fidx)
 {
@@ -545,6 +683,11 @@ static int rvu_nix_aq_enq_inst(struct rvu *rvu, struct nix_aq_enq_req *req,
 	 */
 	inst.res_addr = (u64)aq->res->iova;
 
+	/* Hardware uses same aq->res->base for updating result of
+	 * previous instruction hence wait here till it is done.
+	 */
+	spin_lock(&aq->lock);
+
 	/* Clean result + context memory */
 	memset(aq->res->base, 0, aq->res->entry_sz);
 	/* Context needs to be written at RES_ADDR + 128 */
@@ -589,11 +732,10 @@ static int rvu_nix_aq_enq_inst(struct rvu *rvu, struct nix_aq_enq_req *req,
 		break;
 	default:
 		rc = NIX_AF_ERR_AQ_ENQUEUE;
+		spin_unlock(&aq->lock);
 		return rc;
 	}
 
-	spin_lock(&aq->lock);
-
 	/* Submit the instruction to AQ */
 	rc = nix_aq_enqueue_wait(rvu, block, &inst);
 	if (rc) {
@@ -698,6 +840,8 @@ static int nix_lf_hwctx_disable(struct rvu *rvu, struct hwctx_disable_req *req)
 	if (req->ctype == NIX_AQ_CTYPE_CQ) {
 		aq_req.cq.ena = 0;
 		aq_req.cq_mask.ena = 1;
+		aq_req.cq.bp_ena = 0;
+		aq_req.cq_mask.bp_ena = 1;
 		q_cnt = pfvf->cq_ctx->qsize;
 		bmap = pfvf->cq_bmap;
 	}
@@ -3060,6 +3204,10 @@ int rvu_nix_init(struct rvu *rvu)
 
 		/* Initialize CGX/LBK/SDP link credits, min/max pkt lengths */
 		nix_link_config(rvu, blkaddr);
+
+		/* Enable Channel backpressure */
+		rvu_write64(rvu, blkaddr, NIX_AF_RX_CFG, BIT_ULL(0));
+
 	}
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
index 6e7c7f4..67471cb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
@@ -94,6 +94,11 @@ int rvu_npa_aq_enq_inst(struct rvu *rvu, struct npa_aq_enq_req *req,
 	 */
 	inst.res_addr = (u64)aq->res->iova;
 
+	/* Hardware uses same aq->res->base for updating result of
+	 * previous instruction hence wait here till it is done.
+	 */
+	spin_lock(&aq->lock);
+
 	/* Clean result + context memory */
 	memset(aq->res->base, 0, aq->res->entry_sz);
 	/* Context needs to be written at RES_ADDR + 128 */
@@ -138,10 +143,10 @@ int rvu_npa_aq_enq_inst(struct rvu *rvu, struct npa_aq_enq_req *req,
 		break;
 	}
 
-	if (rc)
+	if (rc) {
+		spin_unlock(&aq->lock);
 		return rc;
-
-	spin_lock(&aq->lock);
+	}
 
 	/* Submit the instruction to AQ */
 	rc = npa_aq_enqueue_wait(rvu, block, &inst);
@@ -218,6 +223,8 @@ static int npa_lf_hwctx_disable(struct rvu *rvu, struct hwctx_disable_req *req)
 	} else if (req->ctype == NPA_AQ_CTYPE_AURA) {
 		aq_req.aura.ena = 0;
 		aq_req.aura_mask.ena = 1;
+		aq_req.aura.bp_ena = 0;
+		aq_req.aura_mask.bp_ena = 1;
 		cnt = pfvf->aura_ctx->qsize;
 		bmap = pfvf->aura_bmap;
 	}
-- 
2.7.4

