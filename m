Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45AE2B305C
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 20:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgKNTxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 14:53:47 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45296 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726189AbgKNTxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 14:53:46 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AEJqCPp030550;
        Sat, 14 Nov 2020 11:53:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=k/EuBIHcR7UWHsj27WHbMbkYXY6eGx/hfRHfOggjtug=;
 b=Vj/O0QIVHvdIvLY5E1OUBo8aexwvYnBQbZjzovVxLBPKIzb78eMhwJO/YIK+I24Qbc4Q
 Y7t1ssO7Q5+OVTn2qk10WDpaHHx/ufL69gRuMu7SShFwaTtnYINOOemi9c09kR3z9CcT
 Mf+uSaDeG7ghU6kBFoAHHpTK6peacRCx7/wlxwGcImhmEDallEbXTCee38LwZF4qvVgy
 ZgRnQVYli8ITnUicSUmft4jEQz0klz3ebb3fZX6z+YA7gldYdQGzDhfjdJ0msMi00PDI
 T4l2bVzngmHuQc+4PbbQp3zvNUmtRUZeuoGZ6qwzSaa1KxYXVk+pfViSvFbUYbyoW1Oh kg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 34tdfts05f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 14 Nov 2020 11:53:43 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 14 Nov
 2020 11:53:42 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 14 Nov
 2020 11:53:41 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 14 Nov 2020 11:53:41 -0800
Received: from hyd1583.caveonetworks.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 18DEF3F703F;
        Sat, 14 Nov 2020 11:53:37 -0800 (PST)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <saeed@kernel.org>,
        <alexander.duyck@gmail.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [PATCH v4 net-next 08/13] octeontx2-af: Modify nix_vtag_cfg mailbox to support TX VTAG entries
Date:   Sun, 15 Nov 2020 01:22:58 +0530
Message-ID: <20201114195303.25967-9-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20201114195303.25967-1-naveenm@marvell.com>
References: <20201114195303.25967-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-14_07:2020-11-13,2020-11-14 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vamsi Attunuru <vattunuru@marvell.com>

This patch modifies the existing nix_vtag_config mailbox message
to allocate and free TX VTAG entries as requested by a NIX PF.
The TX VTAG entries are global resource that shared by all PFs
and each entry specifies the size of VTAG to insert and the VTAG
header data to insert. The mailbox response contains the entry
index which is used by mailbox requester in configuring the
NPC_TX_VTAG_ACTION for any MCAM entry.

Signed-off-by: Vamsi Attunuru <vattunuru@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  60 +++++--
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   8 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 195 ++++++++++++++++++++-
 3 files changed, 250 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index ac3118d2d126..4f230a7272ce 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -204,7 +204,8 @@ M(NIX_TXSCH_ALLOC,	0x8004, nix_txsch_alloc,			\
 M(NIX_TXSCH_FREE,	0x8005, nix_txsch_free, nix_txsch_free_req, msg_rsp) \
 M(NIX_TXSCHQ_CFG,	0x8006, nix_txschq_cfg, nix_txschq_config, msg_rsp)  \
 M(NIX_STATS_RST,	0x8007, nix_stats_rst, msg_req, msg_rsp)	\
-M(NIX_VTAG_CFG,		0x8008, nix_vtag_cfg, nix_vtag_config, msg_rsp)	\
+M(NIX_VTAG_CFG,		0x8008, nix_vtag_cfg, nix_vtag_config,		\
+				 nix_vtag_config_rsp)			\
 M(NIX_RSS_FLOWKEY_CFG,  0x8009, nix_rss_flowkey_cfg,			\
 				 nix_rss_flowkey_cfg,			\
 				 nix_rss_flowkey_cfg_rsp)		\
@@ -477,6 +478,7 @@ enum nix_af_status {
 	NIX_AF_ERR_LSO_CFG_FAIL     = -418,
 	NIX_AF_INVAL_NPA_PF_FUNC    = -419,
 	NIX_AF_INVAL_SSO_PF_FUNC    = -420,
+	NIX_AF_ERR_TX_VTAG_NOSPC    = -421,
 };
 
 /* For NIX LF context alloc and init */
@@ -516,7 +518,8 @@ struct nix_lf_alloc_rsp {
 
 struct nix_lf_free_req {
 	struct mbox_msghdr hdr;
-#define NIX_LF_DISABLE_FLOWS           BIT_ULL(0)
+#define NIX_LF_DISABLE_FLOWS		BIT_ULL(0)
+#define NIX_LF_DONT_FREE_TX_VTAG	BIT_ULL(1)
 	u64 flags;
 };
 
@@ -610,14 +613,40 @@ struct nix_vtag_config {
 	union {
 		/* valid when cfg_type is '0' */
 		struct {
-			/* tx vlan0 tag(C-VLAN) */
-			u64 vlan0;
-			/* tx vlan1 tag(S-VLAN) */
-			u64 vlan1;
-			/* insert tx vlan tag */
-			u8 insert_vlan :1;
-			/* insert tx double vlan tag */
-			u8 double_vlan :1;
+			u64 vtag0;
+			u64 vtag1;
+
+			/* cfg_vtag0 & cfg_vtag1 fields are valid
+			 * when free_vtag0 & free_vtag1 are '0's.
+			 */
+			/* cfg_vtag0 = 1 to configure vtag0 */
+			u8 cfg_vtag0 :1;
+			/* cfg_vtag1 = 1 to configure vtag1 */
+			u8 cfg_vtag1 :1;
+
+			/* vtag0_idx & vtag1_idx are only valid when
+			 * both cfg_vtag0 & cfg_vtag1 are '0's,
+			 * these fields are used along with free_vtag0
+			 * & free_vtag1 to free the nix lf's tx_vlan
+			 * configuration.
+			 *
+			 * Denotes the indices of tx_vtag def registers
+			 * that needs to be cleared and freed.
+			 */
+			int vtag0_idx;
+			int vtag1_idx;
+
+			/* free_vtag0 & free_vtag1 fields are valid
+			 * when cfg_vtag0 & cfg_vtag1 are '0's.
+			 */
+			/* free_vtag0 = 1 clears vtag0 configuration
+			 * vtag0_idx denotes the index to be cleared.
+			 */
+			u8 free_vtag0 :1;
+			/* free_vtag1 = 1 clears vtag1 configuration
+			 * vtag1_idx denotes the index to be cleared.
+			 */
+			u8 free_vtag1 :1;
 		} tx;
 
 		/* valid when cfg_type is '1' */
@@ -632,6 +661,17 @@ struct nix_vtag_config {
 	};
 };
 
+struct nix_vtag_config_rsp {
+	struct mbox_msghdr hdr;
+	int vtag0_idx;
+	int vtag1_idx;
+	/* Indices of tx_vtag def registers used to configure
+	 * tx vtag0 & vtag1 headers, these indices are valid
+	 * when nix_vtag_config mbox requested for vtag0 and/
+	 * or vtag1 configuration.
+	 */
+};
+
 struct nix_rss_flowkey_cfg {
 	struct mbox_msghdr hdr;
 	int	mcam_index;  /* MCAM entry index to modify */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 4c99bed369ae..11d2e47c5405 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -264,6 +264,13 @@ struct nix_lso {
 	u8 in_use;
 };
 
+struct nix_txvlan {
+#define NIX_TX_VTAG_DEF_MAX 0x400
+	struct rsrc_bmap rsrc;
+	u16 *entry2pfvf_map;
+	struct mutex rsrc_lock; /* Serialize resource alloc/free */
+};
+
 struct nix_hw {
 	int blkaddr;
 	struct rvu *rvu;
@@ -272,6 +279,7 @@ struct nix_hw {
 	struct nix_flowkey flowkey;
 	struct nix_mark_format mark_format;
 	struct nix_lso lso;
+	struct nix_txvlan txvlan;
 };
 
 /* RVU block's capabilities or functionality,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 9f60f4370d49..bf844df30464 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -17,6 +17,7 @@
 #include "npc.h"
 #include "cgx.h"
 
+static void nix_free_tx_vtag_entries(struct rvu *rvu, u16 pcifunc);
 static int rvu_nix_get_bpid(struct rvu *rvu, struct nix_bp_cfg_req *req,
 			    int type, int chan_id);
 
@@ -1251,6 +1252,10 @@ int rvu_mbox_handler_nix_lf_free(struct rvu *rvu, struct nix_lf_free_req *req,
 	else
 		rvu_npc_free_mcam_entries(rvu, pcifunc, nixlf);
 
+	/* Free any tx vtag def entries used by this NIX LF */
+	if (!(req->flags & NIX_LF_DONT_FREE_TX_VTAG))
+		nix_free_tx_vtag_entries(rvu, pcifunc);
+
 	nix_interface_deinit(rvu, pcifunc, nixlf);
 
 	/* Reset this NIX LF */
@@ -1992,9 +1997,149 @@ static int nix_rx_vtag_cfg(struct rvu *rvu, int nixlf, int blkaddr,
 	return 0;
 }
 
+static int nix_tx_vtag_free(struct rvu *rvu, int blkaddr,
+			    u16 pcifunc, int index)
+{
+	struct nix_hw *nix_hw = get_nix_hw(rvu->hw, blkaddr);
+	struct nix_txvlan *vlan = &nix_hw->txvlan;
+
+	if (vlan->entry2pfvf_map[index] != pcifunc)
+		return NIX_AF_ERR_PARAM;
+
+	rvu_write64(rvu, blkaddr,
+		    NIX_AF_TX_VTAG_DEFX_DATA(index), 0x0ull);
+	rvu_write64(rvu, blkaddr,
+		    NIX_AF_TX_VTAG_DEFX_CTL(index), 0x0ull);
+
+	vlan->entry2pfvf_map[index] = 0;
+	rvu_free_rsrc(&vlan->rsrc, index);
+
+	return 0;
+}
+
+static void nix_free_tx_vtag_entries(struct rvu *rvu, u16 pcifunc)
+{
+	struct nix_txvlan *vlan;
+	struct nix_hw *nix_hw;
+	int index, blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
+	if (blkaddr < 0)
+		return;
+
+	nix_hw = get_nix_hw(rvu->hw, blkaddr);
+	vlan = &nix_hw->txvlan;
+
+	mutex_lock(&vlan->rsrc_lock);
+	/* Scan all the entries and free the ones mapped to 'pcifunc' */
+	for (index = 0; index < vlan->rsrc.max; index++) {
+		if (vlan->entry2pfvf_map[index] == pcifunc)
+			nix_tx_vtag_free(rvu, blkaddr, pcifunc, index);
+	}
+	mutex_unlock(&vlan->rsrc_lock);
+}
+
+static int nix_tx_vtag_alloc(struct rvu *rvu, int blkaddr,
+			     u64 vtag, u8 size)
+{
+	struct nix_hw *nix_hw = get_nix_hw(rvu->hw, blkaddr);
+	struct nix_txvlan *vlan = &nix_hw->txvlan;
+	u64 regval;
+	int index;
+
+	mutex_lock(&vlan->rsrc_lock);
+
+	index = rvu_alloc_rsrc(&vlan->rsrc);
+	if (index < 0) {
+		mutex_unlock(&vlan->rsrc_lock);
+		return index;
+	}
+
+	mutex_unlock(&vlan->rsrc_lock);
+
+	regval = size ? vtag : vtag << 32;
+
+	rvu_write64(rvu, blkaddr,
+		    NIX_AF_TX_VTAG_DEFX_DATA(index), regval);
+	rvu_write64(rvu, blkaddr,
+		    NIX_AF_TX_VTAG_DEFX_CTL(index), size);
+
+	return index;
+}
+
+static int nix_tx_vtag_decfg(struct rvu *rvu, int blkaddr,
+			     struct nix_vtag_config *req)
+{
+	struct nix_hw *nix_hw = get_nix_hw(rvu->hw, blkaddr);
+	struct nix_txvlan *vlan = &nix_hw->txvlan;
+	u16 pcifunc = req->hdr.pcifunc;
+	int idx0 = req->tx.vtag0_idx;
+	int idx1 = req->tx.vtag1_idx;
+	int err;
+
+	if (req->tx.free_vtag0 && req->tx.free_vtag1)
+		if (vlan->entry2pfvf_map[idx0] != pcifunc ||
+		    vlan->entry2pfvf_map[idx1] != pcifunc)
+			return NIX_AF_ERR_PARAM;
+
+	mutex_lock(&vlan->rsrc_lock);
+
+	if (req->tx.free_vtag0) {
+		err = nix_tx_vtag_free(rvu, blkaddr, pcifunc, idx0);
+		if (err)
+			goto exit;
+	}
+
+	if (req->tx.free_vtag1)
+		err = nix_tx_vtag_free(rvu, blkaddr, pcifunc, idx1);
+
+exit:
+	mutex_unlock(&vlan->rsrc_lock);
+	return err;
+}
+
+static int nix_tx_vtag_cfg(struct rvu *rvu, int blkaddr,
+			   struct nix_vtag_config *req,
+			   struct nix_vtag_config_rsp *rsp)
+{
+	struct nix_hw *nix_hw = get_nix_hw(rvu->hw, blkaddr);
+	struct nix_txvlan *vlan = &nix_hw->txvlan;
+	u16 pcifunc = req->hdr.pcifunc;
+
+	if (req->tx.cfg_vtag0) {
+		rsp->vtag0_idx =
+			nix_tx_vtag_alloc(rvu, blkaddr,
+					  req->tx.vtag0, req->vtag_size);
+
+		if (rsp->vtag0_idx < 0)
+			return NIX_AF_ERR_TX_VTAG_NOSPC;
+
+		vlan->entry2pfvf_map[rsp->vtag0_idx] = pcifunc;
+	}
+
+	if (req->tx.cfg_vtag1) {
+		rsp->vtag1_idx =
+			nix_tx_vtag_alloc(rvu, blkaddr,
+					  req->tx.vtag1, req->vtag_size);
+
+		if (rsp->vtag1_idx < 0)
+			goto err_free;
+
+		vlan->entry2pfvf_map[rsp->vtag1_idx] = pcifunc;
+	}
+
+	return 0;
+
+err_free:
+	if (req->tx.cfg_vtag0)
+		nix_tx_vtag_free(rvu, blkaddr, pcifunc, rsp->vtag0_idx);
+
+	return NIX_AF_ERR_TX_VTAG_NOSPC;
+}
+
 int rvu_mbox_handler_nix_vtag_cfg(struct rvu *rvu,
 				  struct nix_vtag_config *req,
-				  struct msg_rsp *rsp)
+				  struct nix_vtag_config_rsp *rsp)
 {
 	u16 pcifunc = req->hdr.pcifunc;
 	int blkaddr, nixlf, err;
@@ -2004,12 +2149,21 @@ int rvu_mbox_handler_nix_vtag_cfg(struct rvu *rvu,
 		return err;
 
 	if (req->cfg_type) {
+		/* rx vtag configuration */
 		err = nix_rx_vtag_cfg(rvu, nixlf, blkaddr, req);
 		if (err)
 			return NIX_AF_ERR_PARAM;
 	} else {
-		/* TODO: handle tx vtag configuration */
-		return 0;
+		/* tx vtag configuration */
+		if ((req->tx.cfg_vtag0 || req->tx.cfg_vtag1) &&
+		    (req->tx.free_vtag0 || req->tx.free_vtag1))
+			return NIX_AF_ERR_PARAM;
+
+		if (req->tx.cfg_vtag0 || req->tx.cfg_vtag1)
+			return nix_tx_vtag_cfg(rvu, blkaddr, req, rsp);
+
+		if (req->tx.free_vtag0 || req->tx.free_vtag1)
+			return nix_tx_vtag_decfg(rvu, blkaddr, req);
 	}
 
 	return 0;
@@ -2247,6 +2401,31 @@ static int nix_setup_mcast(struct rvu *rvu, struct nix_hw *nix_hw, int blkaddr)
 	return nix_setup_bcast_tables(rvu, nix_hw);
 }
 
+static int nix_setup_txvlan(struct rvu *rvu, struct nix_hw *nix_hw)
+{
+	struct nix_txvlan *vlan = &nix_hw->txvlan;
+	int err;
+
+	/* Allocate resource bimap for tx vtag def registers*/
+	vlan->rsrc.max = NIX_TX_VTAG_DEF_MAX;
+	err = rvu_alloc_bitmap(&vlan->rsrc);
+	if (err)
+		return -ENOMEM;
+
+	/* Alloc memory for saving entry to RVU PFFUNC allocation mapping */
+	vlan->entry2pfvf_map = devm_kcalloc(rvu->dev, vlan->rsrc.max,
+					    sizeof(u16), GFP_KERNEL);
+	if (!vlan->entry2pfvf_map)
+		goto free_mem;
+
+	mutex_init(&vlan->rsrc_lock);
+	return 0;
+
+free_mem:
+	kfree(vlan->rsrc.bmap);
+	return -ENOMEM;
+}
+
 static int nix_setup_txschq(struct rvu *rvu, struct nix_hw *nix_hw, int blkaddr)
 {
 	struct nix_txsch *txsch;
@@ -3241,6 +3420,10 @@ static int rvu_nix_block_init(struct rvu *rvu, struct nix_hw *nix_hw)
 		if (err)
 			return err;
 
+		err = nix_setup_txvlan(rvu, nix_hw);
+		if (err)
+			return err;
+
 		/* Configure segmentation offload formats */
 		nix_setup_lso(rvu, nix_hw, blkaddr);
 
@@ -3327,6 +3510,7 @@ static void rvu_nix_block_freemem(struct rvu *rvu, int blkaddr,
 {
 	struct nix_txsch *txsch;
 	struct nix_mcast *mcast;
+	struct nix_txvlan *vlan;
 	struct nix_hw *nix_hw;
 	int lvl;
 
@@ -3342,6 +3526,11 @@ static void rvu_nix_block_freemem(struct rvu *rvu, int blkaddr,
 			kfree(txsch->schq.bmap);
 		}
 
+		vlan = &nix_hw->txvlan;
+		kfree(vlan->rsrc.bmap);
+		mutex_destroy(&vlan->rsrc_lock);
+		devm_kfree(rvu->dev, vlan->entry2pfvf_map);
+
 		mcast = &nix_hw->mcast;
 		qmem_free(rvu->dev, mcast->mce_ctx);
 		qmem_free(rvu->dev, mcast->mcast_buf);
-- 
2.16.5

