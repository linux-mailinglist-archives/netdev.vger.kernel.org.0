Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A3328CB95
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 12:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730666AbgJMK1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 06:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729395AbgJMK06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 06:26:58 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966A8C0613D0
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 03:26:58 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 10so6928322pfp.5
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 03:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qn30rlJCQWAzuD13V1Frt1qikyDUWGoHwqYSiquTR3Y=;
        b=CpfbSEghBExw0IfeaMYDMeKvqXwIxGgL8DYE3u280pSbXY54ZK8ux0f1h9EmGRpscm
         O+/hy0053NI3WS3pdKyG9OxWTVwLiSsObXy3+4P0dJztSbvqj/uEEBlhDfxP7XkCGz2P
         fss9Qi5zfsRguInT/X5dBALzeiZ7eyU/tjdTyw2s0lJ071yb0Iuop0TytARmGiBqYVjO
         fpfwgDV/ozi5xVa6ZTYs861J08ClW3BaSef+N6PdPXfCFzH0egW/WQ6bhvah20WHnAo5
         Wh3ys7PJyq5EhIkpcn1sqc82yprkSolpY7GC/ZbtUTvEjd5WZEk0h19i0fCbu5MZoo9B
         kD0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qn30rlJCQWAzuD13V1Frt1qikyDUWGoHwqYSiquTR3Y=;
        b=t6dZm7yKS42TxKBSe1YRPk+ssrGWVlHsHko49WsvpLeb2Zq2RdBGpN6pelzsDfgYc5
         vf4yh+eDhRyZRyGh8rFGVtd/BHMbiIP9fndeeYvVdCTE2+WjhjsznfedjJ7IMjWLLEaf
         PopK57eU16v8E9IGtLiuukkUj1aWXJPPKCJ3kOfx/bPkrUolJ/N8cJOcVPWzoej3zeyh
         xeaP5V/kbp/DaEgqpvbhPYKkHWNqpkpjBK3YCeMShdMDshvVS96cuSt8yxRKg7RY0Agc
         bhI+FiEzmKArE7El+i1a9UA9XXwtdR9zJpNmicyec7EEsxM8bkNz0mjRXcpIuy7fZVVo
         CoQg==
X-Gm-Message-State: AOAM533T0nwwM0eF4LQYiJ73aNovDqzMjE8CiRvydlSAOAOuWlV7uSj8
        IegMHe6rlnJy09XAzvjdZBc=
X-Google-Smtp-Source: ABdhPJxZgd1GtH0GQOiTf3/kXC3mVWmZ4aIUwuUH0o2wa87K4WC2rjs/Sp5D5uT0oCJTUs7FGXydtA==
X-Received: by 2002:a63:a546:: with SMTP id r6mr16698997pgu.160.1602584818134;
        Tue, 13 Oct 2020 03:26:58 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([1.6.215.26])
        by smtp.googlemail.com with ESMTPSA id g4sm22034444pgj.15.2020.10.13.03.26.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Oct 2020 03:26:57 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     rsaladi2@marvell.com, sgoutham@marvell.com,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 04/10] octeontx2-af: Map NIX block from CGX connection
Date:   Tue, 13 Oct 2020 15:56:26 +0530
Message-Id: <1602584792-22274-5-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1602584792-22274-1-git-send-email-sundeep.lkml@gmail.com>
References: <1602584792-22274-1-git-send-email-sundeep.lkml@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

Firmware configures NIX block mapping for all CGXs
to achieve maximum throughput. This patch reads
the configuration and create mapping between RVU
PF and NIX blocks. And for LBK VFs assign NIX0 for
even numbered VFs and NIX1 for odd numbered VFs.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 13 ++++-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  5 ++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    | 61 ++++++++++++++++++++--
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 15 ++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 21 ++++++--
 6 files changed, 107 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 8f17e26..7d0f962 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -145,6 +145,16 @@ int cgx_get_cgxid(void *cgxd)
 	return cgx->cgx_id;
 }
 
+u8 cgx_lmac_get_p2x(int cgx_id, int lmac_id)
+{
+	struct cgx *cgx_dev = cgx_get_pdata(cgx_id);
+	u64 cfg;
+
+	cfg = cgx_read(cgx_dev, lmac_id, CGXX_CMRX_CFG);
+
+	return (cfg & CMR_P2X_SEL_MASK) >> CMR_P2X_SEL_SHIFT;
+}
+
 /* Ensure the required lock for event queue(where asynchronous events are
  * posted) is acquired before calling this API. Else an asynchronous event(with
  * latest link status) can reach the destination before this function returns
@@ -814,8 +824,7 @@ static int cgx_lmac_verify_fwi_version(struct cgx *cgx)
 	minor_ver = FIELD_GET(RESP_MINOR_VER, resp);
 	dev_dbg(dev, "Firmware command interface version = %d.%d\n",
 		major_ver, minor_ver);
-	if (major_ver != CGX_FIRMWARE_MAJOR_VER ||
-	    minor_ver != CGX_FIRMWARE_MINOR_VER)
+	if (major_ver != CGX_FIRMWARE_MAJOR_VER)
 		return -EIO;
 	else
 		return 0;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index 27ca329..bcfc3e5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -27,6 +27,10 @@
 
 /* Registers */
 #define CGXX_CMRX_CFG			0x00
+#define CMR_P2X_SEL_MASK		GENMASK_ULL(61, 59)
+#define CMR_P2X_SEL_SHIFT		59ULL
+#define CMR_P2X_SEL_NIX0		1ULL
+#define CMR_P2X_SEL_NIX1		2ULL
 #define CMR_EN				BIT_ULL(55)
 #define DATA_PKT_TX_EN			BIT_ULL(53)
 #define DATA_PKT_RX_EN			BIT_ULL(54)
@@ -142,5 +146,6 @@ int cgx_lmac_get_pause_frm(void *cgxd, int lmac_id,
 int cgx_lmac_set_pause_frm(void *cgxd, int lmac_id,
 			   u8 tx_pause, u8 rx_pause);
 void cgx_lmac_ptp_config(void *cgxd, int lmac_id, bool enable);
+u8 cgx_lmac_get_p2x(int cgx_id, int lmac_id);
 
 #endif /* CGX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 79b9553..f2dbc9ae 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1252,6 +1252,58 @@ int rvu_mbox_handler_detach_resources(struct rvu *rvu,
 	return rvu_detach_rsrcs(rvu, detach, detach->hdr.pcifunc);
 }
 
+static int rvu_get_nix_blkaddr(struct rvu *rvu, u16 pcifunc)
+{
+	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
+	int blkaddr = BLKADDR_NIX0, vf;
+	struct rvu_pfvf *pf;
+
+	/* All CGX mapped PFs are set with assigned NIX block during init */
+	if (is_pf_cgxmapped(rvu, rvu_get_pf(pcifunc))) {
+		pf = rvu_get_pfvf(rvu, pcifunc & ~RVU_PFVF_FUNC_MASK);
+		blkaddr = pf->nix_blkaddr;
+	} else if (is_afvf(pcifunc)) {
+		vf = pcifunc - 1;
+		/* Assign NIX based on VF number. All even numbered VFs get
+		 * NIX0 and odd numbered gets NIX1
+		 */
+		blkaddr = (vf & 1) ? BLKADDR_NIX1 : BLKADDR_NIX0;
+		/* NIX1 is not present on all silicons */
+		if (!is_block_implemented(rvu->hw, BLKADDR_NIX1))
+			blkaddr = BLKADDR_NIX0;
+	}
+
+	switch (blkaddr) {
+	case BLKADDR_NIX1:
+		pfvf->nix_blkaddr = BLKADDR_NIX1;
+		break;
+	case BLKADDR_NIX0:
+	default:
+		pfvf->nix_blkaddr = BLKADDR_NIX0;
+		break;
+	}
+
+	return pfvf->nix_blkaddr;
+}
+
+static int rvu_get_attach_blkaddr(struct rvu *rvu, int blktype, u16 pcifunc)
+{
+	int blkaddr;
+
+	switch (blktype) {
+	case BLKTYPE_NIX:
+		blkaddr = rvu_get_nix_blkaddr(rvu, pcifunc);
+		break;
+	default:
+		return rvu_get_blkaddr(rvu, blktype, 0);
+	};
+
+	if (is_block_implemented(rvu->hw, blkaddr))
+		return blkaddr;
+
+	return -ENODEV;
+}
+
 static void rvu_attach_block(struct rvu *rvu, int pcifunc,
 			     int blktype, int num_lfs)
 {
@@ -1265,7 +1317,7 @@ static void rvu_attach_block(struct rvu *rvu, int pcifunc,
 	if (!num_lfs)
 		return;
 
-	blkaddr = rvu_get_blkaddr(rvu, blktype, 0);
+	blkaddr = rvu_get_attach_blkaddr(rvu, blktype, pcifunc);
 	if (blkaddr < 0)
 		return;
 
@@ -1294,9 +1346,9 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 				       struct rsrc_attach *req, u16 pcifunc)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
+	int free_lfs, mappedlfs, blkaddr;
 	struct rvu_hwinfo *hw = rvu->hw;
 	struct rvu_block *block;
-	int free_lfs, mappedlfs;
 
 	/* Only one NPA LF can be attached */
 	if (req->npalf && !is_blktype_attached(pfvf, BLKTYPE_NPA)) {
@@ -1313,7 +1365,10 @@ static int rvu_check_rsrc_availability(struct rvu *rvu,
 
 	/* Only one NIX LF can be attached */
 	if (req->nixlf && !is_blktype_attached(pfvf, BLKTYPE_NIX)) {
-		block = &hw->block[BLKADDR_NIX0];
+		blkaddr = rvu_get_attach_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
+		if (blkaddr < 0)
+			return blkaddr;
+		block = &hw->block[blkaddr];
 		free_lfs = rvu_rsrc_free_count(&block->lf);
 		if (!free_lfs)
 			goto fail;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index a419075..5d0815b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -184,6 +184,8 @@ struct rvu_pfvf {
 
 	bool	cgx_in_use; /* this PF/VF using CGX? */
 	int	cgx_users;  /* number of cgx users - used only by PFs */
+
+	u8	nix_blkaddr; /* BLKADDR_NIX0/1 assigned to this PF */
 };
 
 struct nix_txsch {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index fa9152f..d298b93 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -74,6 +74,20 @@ void *rvu_cgx_pdata(u8 cgx_id, struct rvu *rvu)
 	return rvu->cgx_idmap[cgx_id];
 }
 
+/* Based on P2X connectivity find mapped NIX block for a PF */
+static void rvu_map_cgx_nix_block(struct rvu *rvu, int pf,
+				  int cgx_id, int lmac_id)
+{
+	struct rvu_pfvf *pfvf = &rvu->pf[pf];
+	u8 p2x;
+
+	p2x = cgx_lmac_get_p2x(cgx_id, lmac_id);
+	/* Firmware sets P2X_SELECT as either NIX0 or NIX1 */
+	pfvf->nix_blkaddr = BLKADDR_NIX0;
+	if (p2x == CMR_P2X_SEL_NIX1)
+		pfvf->nix_blkaddr = BLKADDR_NIX1;
+}
+
 static int rvu_map_cgx_lmac_pf(struct rvu *rvu)
 {
 	struct npc_pkind *pkind = &rvu->hw->pkind;
@@ -117,6 +131,7 @@ static int rvu_map_cgx_lmac_pf(struct rvu *rvu)
 			rvu->cgxlmac2pf_map[CGX_OFFSET(cgx) + lmac] = 1 << pf;
 			free_pkind = rvu_alloc_rsrc(&pkind->rsrc);
 			pkind->pfchan_map[free_pkind] = ((pf) & 0x3F) << 16;
+			rvu_map_cgx_nix_block(rvu, pf, cgx, lmac);
 			rvu->cgx_mapped_pfs++;
 		}
 	}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 096c2e0..6b8c964 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -213,8 +213,8 @@ static bool is_valid_txschq(struct rvu *rvu, int blkaddr,
 static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
+	int pkind, pf, vf, lbkid;
 	u8 cgx_id, lmac_id;
-	int pkind, pf, vf;
 	int err;
 
 	pf = rvu_get_pf(pcifunc);
@@ -247,13 +247,24 @@ static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf)
 	case NIX_INTF_TYPE_LBK:
 		vf = (pcifunc & RVU_PFVF_FUNC_MASK) - 1;
 
+		/* If NIX1 block is present on the silicon then NIXes are
+		 * assigned alternatively for lbk interfaces. NIX0 should
+		 * send packets on lbk link 1 channels and NIX1 should send
+		 * on lbk link 0 channels for the communication between
+		 * NIX0 and NIX1.
+		 */
+		lbkid = 0;
+		if (rvu->hw->lbk_links > 1)
+			lbkid = vf & 0x1 ? 0 : 1;
+
 		/* Note that AF's VFs work in pairs and talk over consecutive
 		 * loopback channels.Therefore if odd number of AF VFs are
 		 * enabled then the last VF remains with no pair.
 		 */
-		pfvf->rx_chan_base = NIX_CHAN_LBK_CHX(0, vf);
-		pfvf->tx_chan_base = vf & 0x1 ? NIX_CHAN_LBK_CHX(0, vf - 1) :
-						NIX_CHAN_LBK_CHX(0, vf + 1);
+		pfvf->rx_chan_base = NIX_CHAN_LBK_CHX(lbkid, vf);
+		pfvf->tx_chan_base = vf & 0x1 ?
+					NIX_CHAN_LBK_CHX(lbkid, vf - 1) :
+					NIX_CHAN_LBK_CHX(lbkid, vf + 1);
 		pfvf->rx_chan_cnt = 1;
 		pfvf->tx_chan_cnt = 1;
 		rvu_npc_install_promisc_entry(rvu, pcifunc, nixlf,
@@ -3183,7 +3194,7 @@ static int rvu_nix_block_init(struct rvu *rvu, struct nix_hw *nix_hw)
 	hw->cgx = (cfg >> 12) & 0xF;
 	hw->lmac_per_cgx = (cfg >> 8) & 0xF;
 	hw->cgx_links = hw->cgx * hw->lmac_per_cgx;
-	hw->lbk_links = 1;
+	hw->lbk_links = (cfg >> 24) & 0xF;
 	hw->sdp_links = 1;
 
 	/* Initialize admin queue */
-- 
2.7.4

