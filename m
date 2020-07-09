Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052D721A0D0
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 15:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgGIN1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 09:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbgGIN1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 09:27:16 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3FBC08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 06:27:16 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id k4so823827pld.12
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 06:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FszxFu5zFTbaRpL3XmKj/M+n3ja5TWMTOPccnB7Wbi8=;
        b=SnFO7os2kXzGtHENHeziF2QQnCLT+mCB72A1Mk9WSu8cvwx8w9biz0lEFmqwi/aG4B
         oeSShU9BCNDH/vf2HiJysqsM7QaxSBWQ6hMGEtbI28VGqN0YB0cDktQ3Wq+WHC9dfv0f
         GsipF3Oj/eEyTrEd4j6CncAtZq25XwV+laetBlURz+hji5kCx8P9zNY7baxXEV+Nw43Z
         L/XGxCxr+8UeqS+x9madnjGIMd2OQQUxs8qvJZOMUtv7IMZwNHqc/3mn0Ltu+WqPjD17
         KK75WL2LUzzBcnCPCRt2L/5s7X8kxIZlIpdyvogYt2uDM6Ux4uA+7pkTOlcAbqglOVDV
         IasA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FszxFu5zFTbaRpL3XmKj/M+n3ja5TWMTOPccnB7Wbi8=;
        b=aSOxSDXzJkkkQ4NxllKF20Err3wrxo8NEw9Uvyzl1c9fl7FRBOIz/b0qQsMhcmTLg0
         lHBRv2TTeB13kiB3B7IFTD4yHrQE7mYmLtI0TKjzjBtXsP/KV0Z8VsRuaA2LJuc0J7hm
         AU6FCyPCnc6r5Gv+f7auw2xhXfquXr8AOAvlpzWgEsr3M83cEQhA277xI4PDLpzb+D3u
         7zK/I8BpZyimLbpLg25leL6ZsJhe01NkdPmItoOb73bGiyvsJNSXU9BCRHFTJGDq3fHf
         YHfCcnQuiXZADMdUaCWJxvQDNOxBNly+MnVqj5KKuh+lmVhc3Bpntv/1AmZrDU97xbtn
         6hXg==
X-Gm-Message-State: AOAM533BdaSh6CHWHMqPareRuYw8VjhHLmcocOfRrWorHTBt6Xa+daev
        gZ4yrIy+yHJu5nsO/nd3e30=
X-Google-Smtp-Source: ABdhPJwi1i1BU9VmAupT9n3kDg8m+KEePJfrKAorUaHaMETFkNYt3bZywwWpVLf+hKKbddL7uUWQXA==
X-Received: by 2002:a17:902:b48a:: with SMTP id y10mr51890307plr.97.1594301235809;
        Thu, 09 Jul 2020 06:27:15 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id w17sm2863911pge.10.2020.07.09.06.27.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Jul 2020 06:27:15 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com,
        netdev@vger.kernel.org
Cc:     sgoutham@marvell.com, sbhatta@marvell.com,
        Zyta Szpak <zyta@marvell.com>
Subject: [PATCH v3 net-next 1/3] octeontx2-af: Support to enable/disable HW timestamping
Date:   Thu,  9 Jul 2020 18:56:59 +0530
Message-Id: <1594301221-3731-2-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594301221-3731-1-git-send-email-sundeep.lkml@gmail.com>
References: <1594301221-3731-1-git-send-email-sundeep.lkml@gmail.com>
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

Signed-off-by: Zyta Szpak <zyta@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---

v3:
  No changes
v2:
  No changes

 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 29 ++++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  4 ++
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  4 ++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 54 ++++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 52 +++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 27 +++++++++++
 7 files changed, 171 insertions(+)

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
index f3c82e4..e751cbc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -509,6 +509,60 @@ int rvu_mbox_handler_cgx_promisc_disable(struct rvu *rvu, struct msg_req *req,
 	return 0;
 }
 
+int rvu_mbox_handler_cgx_ptp_rx_enable(struct rvu *rvu, struct msg_req *req,
+				       struct msg_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	int pf = rvu_get_pf(pcifunc);
+	u8 cgx_id, lmac_id;
+	void *cgxd;
+
+	/* This msg is expected only from PFs that are mapped to CGX LMACs,
+	 * if received from other PF/VF simply ACK, nothing to do.
+	 */
+	if ((req->hdr.pcifunc & RVU_PFVF_FUNC_MASK) ||
+	    !is_pf_cgxmapped(rvu, pf))
+		return -ENODEV;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	cgxd = rvu_cgx_pdata(cgx_id, rvu);
+
+	cgx_lmac_ptp_config(cgxd, lmac_id, true);
+	/* Inform NPC that packets to be parsed by this PF
+	 * will have their data shifted by 8B
+	 */
+	if (npc_config_ts_kpuaction(rvu, pf, pcifunc, true))
+		return -EINVAL;
+
+	return 0;
+}
+
+int rvu_mbox_handler_cgx_ptp_rx_disable(struct rvu *rvu, struct msg_req *req,
+					struct msg_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	int pf = rvu_get_pf(pcifunc);
+	u8 cgx_id, lmac_id;
+	void *cgxd;
+
+	/* This msg is expected only from PFs that are mapped to CGX LMACs,
+	 * if received from other PF/VF simply ACK, nothing to do.
+	 */
+	if ((req->hdr.pcifunc & RVU_PFVF_FUNC_MASK) ||
+	    !is_pf_cgxmapped(rvu, pf))
+		return -ENODEV;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	cgxd = rvu_cgx_pdata(cgx_id, rvu);
+
+	cgx_lmac_ptp_config(cgxd, lmac_id, false);
+	/* Inform NPC that 8B shift is cancelled */
+	if (npc_config_ts_kpuaction(rvu, pf, pcifunc, false))
+		return -EINVAL;
+
+	return 0;
+}
+
 static int rvu_cgx_config_linkevents(struct rvu *rvu, u16 pcifunc, bool en)
 {
 	int pf = rvu_get_pf(pcifunc);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 36953d4..6c1abfb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3319,6 +3319,58 @@ void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int nixlf)
 	nix_ctx_free(rvu, pfvf);
 }
 
+int rvu_mbox_handler_nix_lf_ptp_tx_enable(struct rvu *rvu, struct msg_req *req,
+					  struct msg_rsp *rsp)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	u16 pcifunc = req->hdr.pcifunc;
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
+	cfg |= BIT_ULL(32);
+	rvu_write64(rvu, blkaddr, NIX_AF_LFX_TX_CFG(nixlf), cfg);
+
+	return 0;
+}
+
+int rvu_mbox_handler_nix_lf_ptp_tx_disable(struct rvu *rvu, struct msg_req *req,
+					   struct msg_rsp *rsp)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	u16 pcifunc = req->hdr.pcifunc;
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
+	cfg &= ~BIT_ULL(32);
+	rvu_write64(rvu, blkaddr, NIX_AF_LFX_TX_CFG(nixlf), cfg);
+
+	return 0;
+}
+
 int rvu_mbox_handler_nix_lso_format_cfg(struct rvu *rvu,
 					struct nix_lso_format_cfg *req,
 					struct nix_lso_format_cfg_rsp *rsp)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 0a21408..8179bbe 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -27,6 +27,7 @@
 #define NIXLF_PROMISC_ENTRY	2
 
 #define NPC_PARSE_RESULT_DMAC_OFFSET	8
+#define NPC_HW_TSTAMP_OFFSET		8
 
 static void npc_mcam_free_all_entries(struct rvu *rvu, struct npc_mcam *mcam,
 				      int blkaddr, u16 pcifunc);
@@ -61,6 +62,32 @@ int rvu_npc_get_pkind(struct rvu *rvu, u16 pf)
 	return -1;
 }
 
+int npc_config_ts_kpuaction(struct rvu *rvu, int pf, u16 pcifunc, bool en)
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
+	val = rvu_read64(rvu, blkaddr, NPC_AF_PKINDX_ACTION0(pkind));
+	val &= ~0xff00000ULL; /* Zero ptr advance field */
+	if (en)
+		/* Set to timestamp offset */
+		val |= (NPC_HW_TSTAMP_OFFSET << 20);
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

