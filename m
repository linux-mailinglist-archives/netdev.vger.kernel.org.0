Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E4824F368
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 09:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgHXHzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 03:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbgHXHzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 03:55:37 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02715C061573
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 00:55:37 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id k18so4394672pfp.7
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 00:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5MSreQ5RH/n+3IYKzNVgKNE4pWaBKqFbe5MIB1Wf5eM=;
        b=GrsL9tJRAEU2XtRnpOEmk0Va3Ya5mqq9+kN2VCfe3zCZ7n1U6dqdyk39XjBvfhuNZr
         OsWMwoxJyGce1lM3wUhW1zktdAuUFgkeCXf4VzEQ7xj8yum5J8aX0tZdiMlfMI5QQfWW
         zCNQuHLtWDuqMmHm5sefjtHSj77Lmqt4ArjTMd4r13bGU+zdf4WhdgZthKK8+2ddNHYI
         B9cpH9cCqmDiH3Kgj/og+SDmWmDehtwMeUK9we69VB8K4MyYgDHbhBARRi6JnuhlY+eI
         zf5soz6zzUyomnEcfTtf5vyCIAgqYYwCG98QYDO/nftL9gKp7h/EsPE8FIKL3OcqvkFh
         Tf5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5MSreQ5RH/n+3IYKzNVgKNE4pWaBKqFbe5MIB1Wf5eM=;
        b=YpaPokxISzXkyzrQVGJ6eO0Js2L0VCXBR37J0PJDtaLm2acbCW/iFFV4BuuVmj69Cl
         aUotjEe/cG21vEZ+/Trl8fenwnEK0Qplf54DU6swaOJunBbwtQB21f6b9HlanH6B6jwp
         68u8omh2RzFw7WAgDreXpoi2mYHe8vfd7liPRVdUmd19Slkb+9LRv+/Jq8l6hxnCId56
         DJZlIRBcHox4XjzMNtyhfiAhV0PpB6NFVETCqxjcWgDknLQDceAUR8qyZV0WNGkZOAhF
         3HDuR686IfIsUPnIxb2eKz53rKMFIwXyB2KbJEHTR9A7C4QooNYqPsszFXh1Cd/UtrJT
         izoQ==
X-Gm-Message-State: AOAM530QrCmgsjjOB6Alk7Zdi57Q8UiWzn2RKLoQ+TKMJ+wIA357tBVb
        Xe+IYRfO9VG3Pp7YR90DDXA=
X-Google-Smtp-Source: ABdhPJw6yiN0kd9SYewdw+ki9E0JQ50uJ5OSiG9fl8CPooS0IlHofi991YIfT+GzsjBQYkb12QWWjA==
X-Received: by 2002:a65:5a8d:: with SMTP id c13mr2813609pgt.268.1598255736450;
        Mon, 24 Aug 2020 00:55:36 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id z25sm10441722pfn.159.2020.08.24.00.55.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Aug 2020 00:55:35 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com,
        netdev@vger.kernel.org, sgoutham@marvell.com
Cc:     Zyta Szpak <zyta@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [PATCH v7 net-next 1/3] octeontx2-af: Support to enable/disable HW timestamping
Date:   Mon, 24 Aug 2020 13:25:15 +0530
Message-Id: <1598255717-32316-2-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598255717-32316-1-git-send-email-sundeep.lkml@gmail.com>
References: <1598255717-32316-1-git-send-email-sundeep.lkml@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zyta Szpak <zyta@marvell.com>

Four new mbox messages ids and handler are added in order to
enable or disable timestamping procedure on tx and rx side.
Additionally when PTP is enabled, the packet parser must skip
over 8 bytes and start analyzing packet data there. To make NPC
profiles work seemlesly PTR_ADVANCE of IKPU is set so that
parsing can be done as before when all data pointers
are shifted by 8 bytes automatically.

Co-developed-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Zyta Szpak <zyta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 29 +++++++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  4 ++
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  4 ++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 39 ++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 43 ++++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 31 ++++++++++++++++
 7 files changed, 151 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index a4e65da..8f17e26 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -468,6 +468,35 @@ static void cgx_lmac_pause_frm_config(struct cgx *cgx, int lmac_id, bool enable)
 	}
 }
 
+void cgx_lmac_ptp_config(void *cgxd, int lmac_id, bool enable)
+{
+	struct cgx *cgx = cgxd;
+	u64 cfg;
+
+	if (!cgx)
+		return;
+
+	if (enable) {
+		/* Enable inbound PTP timestamping */
+		cfg = cgx_read(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL);
+		cfg |= CGX_GMP_GMI_RXX_FRM_CTL_PTP_MODE;
+		cgx_write(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL, cfg);
+
+		cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL);
+		cfg |= CGX_SMUX_RX_FRM_CTL_PTP_MODE;
+		cgx_write(cgx, lmac_id,	CGXX_SMUX_RX_FRM_CTL, cfg);
+	} else {
+		/* Disable inbound PTP stamping */
+		cfg = cgx_read(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL);
+		cfg &= ~CGX_GMP_GMI_RXX_FRM_CTL_PTP_MODE;
+		cgx_write(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL, cfg);
+
+		cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL);
+		cfg &= ~CGX_SMUX_RX_FRM_CTL_PTP_MODE;
+		cgx_write(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL, cfg);
+	}
+}
+
 /* CGX Firmware interface low level support */
 static int cgx_fwi_cmd_send(u64 req, u64 *resp, struct lmac *lmac)
 {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index 394f965..27ca329 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -58,8 +58,10 @@
 
 #define CGXX_SMUX_RX_FRM_CTL		0x20020
 #define CGX_SMUX_RX_FRM_CTL_CTL_BCK	BIT_ULL(3)
+#define CGX_SMUX_RX_FRM_CTL_PTP_MODE	BIT_ULL(12)
 #define CGXX_GMP_GMI_RXX_FRM_CTL	0x38028
 #define CGX_GMP_GMI_RXX_FRM_CTL_CTL_BCK	BIT_ULL(3)
+#define CGX_GMP_GMI_RXX_FRM_CTL_PTP_MODE BIT_ULL(12)
 #define CGXX_SMUX_TX_CTL		0x20178
 #define CGXX_SMUX_TX_PAUSE_PKT_TIME	0x20110
 #define CGXX_SMUX_TX_PAUSE_PKT_INTERVAL	0x20120
@@ -139,4 +141,6 @@ int cgx_lmac_get_pause_frm(void *cgxd, int lmac_id,
 			   u8 *tx_pause, u8 *rx_pause);
 int cgx_lmac_set_pause_frm(void *cgxd, int lmac_id,
 			   u8 tx_pause, u8 rx_pause);
+void cgx_lmac_ptp_config(void *cgxd, int lmac_id, bool enable);
+
 #endif /* CGX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 6dfd0f9..c89b098 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -143,6 +143,8 @@ M(CGX_STOP_LINKEVENTS,	0x208, cgx_stop_linkevents, msg_req, msg_rsp)	\
 M(CGX_GET_LINKINFO,	0x209, cgx_get_linkinfo, msg_req, cgx_link_info_msg) \
 M(CGX_INTLBK_ENABLE,	0x20A, cgx_intlbk_enable, msg_req, msg_rsp)	\
 M(CGX_INTLBK_DISABLE,	0x20B, cgx_intlbk_disable, msg_req, msg_rsp)	\
+M(CGX_PTP_RX_ENABLE,	0x20C, cgx_ptp_rx_enable, msg_req, msg_rsp)	\
+M(CGX_PTP_RX_DISABLE,	0x20D, cgx_ptp_rx_disable, msg_req, msg_rsp)	\
 M(CGX_CFG_PAUSE_FRM,	0x20E, cgx_cfg_pause_frm, cgx_pause_frm_cfg,	\
 			       cgx_pause_frm_cfg)			\
 /* NPA mbox IDs (range 0x400 - 0x5FF) */				\
@@ -213,6 +215,8 @@ M(NIX_LSO_FORMAT_CFG,	0x8011, nix_lso_format_cfg,			\
 				 nix_lso_format_cfg,			\
 				 nix_lso_format_cfg_rsp)		\
 M(NIX_RXVLAN_ALLOC,	0x8012, nix_rxvlan_alloc, msg_req, msg_rsp)	\
+M(NIX_LF_PTP_TX_ENABLE, 0x8013, nix_lf_ptp_tx_enable, msg_req, msg_rsp)	\
+M(NIX_LF_PTP_TX_DISABLE, 0x8014, nix_lf_ptp_tx_disable, msg_req, msg_rsp) \
 M(NIX_BP_ENABLE,	0x8016, nix_bp_enable, nix_bp_cfg_req,	\
 				nix_bp_cfg_rsp)	\
 M(NIX_BP_DISABLE,	0x8017, nix_bp_disable, nix_bp_cfg_req, msg_rsp) \
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index dcf25a0..62c3ed2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -469,6 +469,7 @@ int rvu_npc_init(struct rvu *rvu);
 void rvu_npc_freemem(struct rvu *rvu);
 int rvu_npc_get_pkind(struct rvu *rvu, u16 pf);
 void rvu_npc_set_pkind(struct rvu *rvu, int pkind, struct rvu_pfvf *pfvf);
+int npc_config_ts_kpuaction(struct rvu *rvu, int pf, u16 pcifunc, bool en);
 void rvu_npc_install_ucast_entry(struct rvu *rvu, u16 pcifunc,
 				 int nixlf, u64 chan, u8 *mac_addr);
 void rvu_npc_install_promisc_entry(struct rvu *rvu, u16 pcifunc,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index f3c82e4..fe3389c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -509,6 +509,45 @@ int rvu_mbox_handler_cgx_promisc_disable(struct rvu *rvu, struct msg_req *req,
 	return 0;
 }
 
+static int rvu_cgx_ptp_rx_cfg(struct rvu *rvu, u16 pcifunc, bool enable)
+{
+	int pf = rvu_get_pf(pcifunc);
+	u8 cgx_id, lmac_id;
+	void *cgxd;
+
+	/* This msg is expected only from PFs that are mapped to CGX LMACs,
+	 * if received from other PF/VF simply ACK, nothing to do.
+	 */
+	if ((pcifunc & RVU_PFVF_FUNC_MASK) ||
+	    !is_pf_cgxmapped(rvu, pf))
+		return -ENODEV;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	cgxd = rvu_cgx_pdata(cgx_id, rvu);
+
+	cgx_lmac_ptp_config(cgxd, lmac_id, enable);
+	/* If PTP is enabled then inform NPC that packets to be
+	 * parsed by this PF will have their data shifted by 8 bytes
+	 * and if PTP is disabled then no shift is required
+	 */
+	if (npc_config_ts_kpuaction(rvu, pf, pcifunc, enable))
+		return -EINVAL;
+
+	return 0;
+}
+
+int rvu_mbox_handler_cgx_ptp_rx_enable(struct rvu *rvu, struct msg_req *req,
+				       struct msg_rsp *rsp)
+{
+	return rvu_cgx_ptp_rx_cfg(rvu, req->hdr.pcifunc, true);
+}
+
+int rvu_mbox_handler_cgx_ptp_rx_disable(struct rvu *rvu, struct msg_req *req,
+					struct msg_rsp *rsp)
+{
+	return rvu_cgx_ptp_rx_cfg(rvu, req->hdr.pcifunc, false);
+}
+
 static int rvu_cgx_config_linkevents(struct rvu *rvu, u16 pcifunc, bool en)
 {
 	int pf = rvu_get_pf(pcifunc);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 36953d4..bb8c607 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3319,6 +3319,49 @@ void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int nixlf)
 	nix_ctx_free(rvu, pfvf);
 }
 
+#define NIX_AF_LFX_TX_CFG_PTP_EN	BIT_ULL(32)
+
+static int rvu_nix_lf_ptp_tx_cfg(struct rvu *rvu, u16 pcifunc, bool enable)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	struct rvu_block *block;
+	int blkaddr;
+	int nixlf;
+	u64 cfg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
+	if (blkaddr < 0)
+		return NIX_AF_ERR_AF_LF_INVALID;
+
+	block = &hw->block[blkaddr];
+	nixlf = rvu_get_lf(rvu, block, pcifunc, 0);
+	if (nixlf < 0)
+		return NIX_AF_ERR_AF_LF_INVALID;
+
+	cfg = rvu_read64(rvu, blkaddr, NIX_AF_LFX_TX_CFG(nixlf));
+
+	if (enable)
+		cfg |= NIX_AF_LFX_TX_CFG_PTP_EN;
+	else
+		cfg &= ~NIX_AF_LFX_TX_CFG_PTP_EN;
+
+	rvu_write64(rvu, blkaddr, NIX_AF_LFX_TX_CFG(nixlf), cfg);
+
+	return 0;
+}
+
+int rvu_mbox_handler_nix_lf_ptp_tx_enable(struct rvu *rvu, struct msg_req *req,
+					  struct msg_rsp *rsp)
+{
+	return rvu_nix_lf_ptp_tx_cfg(rvu, req->hdr.pcifunc, true);
+}
+
+int rvu_mbox_handler_nix_lf_ptp_tx_disable(struct rvu *rvu, struct msg_req *req,
+					   struct msg_rsp *rsp)
+{
+	return rvu_nix_lf_ptp_tx_cfg(rvu, req->hdr.pcifunc, false);
+}
+
 int rvu_mbox_handler_nix_lso_format_cfg(struct rvu *rvu,
 					struct nix_lso_format_cfg *req,
 					struct nix_lso_format_cfg_rsp *rsp)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 0a21408..e2e585d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -27,6 +27,7 @@
 #define NIXLF_PROMISC_ENTRY	2
 
 #define NPC_PARSE_RESULT_DMAC_OFFSET	8
+#define NPC_HW_TSTAMP_OFFSET		8
 
 static void npc_mcam_free_all_entries(struct rvu *rvu, struct npc_mcam *mcam,
 				      int blkaddr, u16 pcifunc);
@@ -61,6 +62,36 @@ int rvu_npc_get_pkind(struct rvu *rvu, u16 pf)
 	return -1;
 }
 
+#define NPC_AF_ACTION0_PTR_ADVANCE	GENMASK_ULL(27, 20)
+
+int npc_config_ts_kpuaction(struct rvu *rvu, int pf, u16 pcifunc, bool enable)
+{
+	int pkind, blkaddr;
+	u64 val;
+
+	pkind = rvu_npc_get_pkind(rvu, pf);
+	if (pkind < 0) {
+		dev_err(rvu->dev, "%s: pkind not mapped\n", __func__);
+		return -EINVAL;
+	}
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, pcifunc);
+	if (blkaddr < 0) {
+		dev_err(rvu->dev, "%s: NPC block not implemented\n", __func__);
+		return -EINVAL;
+	}
+
+	val = rvu_read64(rvu, blkaddr, NPC_AF_PKINDX_ACTION0(pkind));
+	val &= ~NPC_AF_ACTION0_PTR_ADVANCE;
+	/* If timestamp is enabled then configure NPC to shift 8 bytes */
+	if (enable)
+		val |= FIELD_PREP(NPC_AF_ACTION0_PTR_ADVANCE,
+				  NPC_HW_TSTAMP_OFFSET);
+	rvu_write64(rvu, blkaddr, NPC_AF_PKINDX_ACTION0(pkind), val);
+
+	return 0;
+}
+
 static int npc_get_nixlf_mcam_index(struct npc_mcam *mcam,
 				    u16 pcifunc, int nixlf, int type)
 {
-- 
2.7.4

