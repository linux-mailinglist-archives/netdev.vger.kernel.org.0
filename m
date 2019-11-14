Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D53E4FBFA5
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 06:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbfKNF17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 00:27:59 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33099 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfKNF17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 00:27:59 -0500
Received: by mail-pf1-f193.google.com with SMTP id c184so3362115pfb.0
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 21:27:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aARroydboMq4+JpLjAqlLIqLs3vO/vb5LD5PFxMpjvk=;
        b=pM+jr2ydo0AUdsKZZV1fNcSQzkY9eH8PeuwS1AYhKbQE/OwyUTDposIF1Bf0DoWUfJ
         JaQNOIyVB72OOaQWahF3opnWaJKlQ8JsVLmIO0u/cpols1qI3kbvQAX1/efrdBN8MYzM
         9qTnBqsP1aA8aO3trZ6j+/aqLCNB6Wg3q/Dhbndrb3vWbEsoYTbrYL8zYSyot9kpV+bt
         iHelg8B2qqwN2IWOK7WHlDSIi6JIDAPYnS1Zmc+E/fzHSG0cMhPenatFY8yz5c8CxUgW
         tkksNKPKX3zdXy6w33YUA1l35XjW8y4vXd9Cgi6DuLqqXCLFOjHSzOGUlwi/qnhQRsCa
         eBDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aARroydboMq4+JpLjAqlLIqLs3vO/vb5LD5PFxMpjvk=;
        b=FzLnEv2PryRKF+o2gk0Jr3Mf++REgcrLiTqP/8R7ArKtRr69JzTP0/vIQo1g073UsZ
         rvT+tpozgCY2U8AQ2igsAGyS0uodYJOqI4MN8eUChkfpHyLgnEv8+oQ7yeVMPCfP9G4D
         Xpo0QBLU/30i075nFC2cQPsbi1jUVxhhCmdHlCEM8u1itflDgOaFY+LCa7Jn48s8T0Z7
         fe/v8ywC8s2DiUuDL0yVfkBsFLZj8MbU3LL2W+8+jCjarSiN0N0KvWKUCyZoIbXIh1MX
         kIpKL4TMc8GaXeOhb3/n7By8wIMiKxE1cKOultEqCUbUDou1lX0YCfEYNlTRfWawOhxX
         2FiQ==
X-Gm-Message-State: APjAAAW/t7h5GNA/F7BeOHsMtdLGV75/RM13fWvyDiySyDWuHzkEzOGZ
        wfb8mtqWGuBRvxtbLlT6mwgxtRq5bIo=
X-Google-Smtp-Source: APXvYqz5uxveRncJUyY1CjULblTBDhiPTKPIYMtwn/LsnLhc9+ISMG8vpUXQCKjkYBo6gS24QnfpNw==
X-Received: by 2002:a63:d1a:: with SMTP id c26mr7927157pgl.24.1573709275794;
        Wed, 13 Nov 2019 21:27:55 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id a6sm4913261pja.30.2019.11.13.21.27.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 13 Nov 2019 21:27:55 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 14/18] octeontx2-af: Support fixed transmit scheduler topology
Date:   Thu, 14 Nov 2019 10:56:29 +0530
Message-Id: <1573709193-15446-15-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

CN96xx initial silicon doesn't support all features pertaining to
NIX transmit scheduling and shaping.
- It supports a fixed topology of 1:1 mapped transmit
  limiters at all levels.
- Supports DWRR only at SMQ/MDQ and TL1.
- Doesn't support shaping and coloring.

This patch adds HW capability structure by which each variant
and skew of silicon can be differentiated by their supported
features. And adds support for A0 silicon's transmit scheduler
capabilities or rather limitations.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  50 ++
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |   7 +
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  10 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  35 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  33 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  18 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 612 ++++++++++++---------
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |   6 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |   1 +
 9 files changed, 513 insertions(+), 259 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index d94e682..5ca7886 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -291,6 +291,35 @@ void cgx_lmac_promisc_config(int cgx_id, int lmac_id, bool enable)
 }
 EXPORT_SYMBOL(cgx_lmac_promisc_config);
 
+/* Enable or disable forwarding received pause frames to Tx block */
+void cgx_lmac_enadis_rx_pause_fwding(void *cgxd, int lmac_id, bool enable)
+{
+	struct cgx *cgx = cgxd;
+	u64 cfg;
+
+	if (!cgx)
+		return;
+
+	if (enable) {
+		cfg = cgx_read(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL);
+		cfg |= CGX_GMP_GMI_RXX_FRM_CTL_CTL_BCK;
+		cgx_write(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL, cfg);
+
+		cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL);
+		cfg |= CGX_SMUX_RX_FRM_CTL_CTL_BCK;
+		cgx_write(cgx, lmac_id,	CGXX_SMUX_RX_FRM_CTL, cfg);
+	} else {
+		cfg = cgx_read(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL);
+		cfg &= ~CGX_GMP_GMI_RXX_FRM_CTL_CTL_BCK;
+		cgx_write(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL, cfg);
+
+		cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL);
+		cfg &= ~CGX_SMUX_RX_FRM_CTL_CTL_BCK;
+		cgx_write(cgx, lmac_id,	CGXX_SMUX_RX_FRM_CTL, cfg);
+	}
+}
+EXPORT_SYMBOL(cgx_lmac_enadis_rx_pause_fwding);
+
 int cgx_get_rx_stats(void *cgxd, int lmac_id, int idx, u64 *rx_stat)
 {
 	struct cgx *cgx = cgxd;
@@ -331,6 +360,27 @@ int cgx_lmac_rx_tx_enable(void *cgxd, int lmac_id, bool enable)
 }
 EXPORT_SYMBOL(cgx_lmac_rx_tx_enable);
 
+int cgx_lmac_tx_enable(void *cgxd, int lmac_id, bool enable)
+{
+	struct cgx *cgx = cgxd;
+	u64 cfg, last;
+
+	if (!cgx || lmac_id >= cgx->lmac_count)
+		return -ENODEV;
+
+	cfg = cgx_read(cgx, lmac_id, CGXX_CMRX_CFG);
+	last = cfg;
+	if (enable)
+		cfg |= DATA_PKT_TX_EN;
+	else
+		cfg &= ~DATA_PKT_TX_EN;
+
+	if (cfg != last)
+		cgx_write(cgx, lmac_id, CGXX_CMRX_CFG, cfg);
+	return !!(last & DATA_PKT_TX_EN);
+}
+EXPORT_SYMBOL(cgx_lmac_tx_enable);
+
 /* CGX Firmware interface low level support */
 static int cgx_fwi_cmd_send(u64 req, u64 *resp, struct lmac *lmac)
 {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index c0306b2..096a04a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -56,6 +56,11 @@
 #define CGXX_GMP_PCS_MRX_CTL		0x30000
 #define CGXX_GMP_PCS_MRX_CTL_LBK	BIT_ULL(14)
 
+#define CGXX_SMUX_RX_FRM_CTL		0x20020
+#define CGX_SMUX_RX_FRM_CTL_CTL_BCK	BIT_ULL(3)
+#define CGXX_GMP_GMI_RXX_FRM_CTL	0x38028
+#define CGX_GMP_GMI_RXX_FRM_CTL_CTL_BCK	BIT_ULL(3)
+
 #define CGX_COMMAND_REG			CGXX_SCRATCH1_REG
 #define CGX_EVENT_REG			CGXX_SCRATCH0_REG
 #define CGX_CMD_TIMEOUT			2200 /* msecs */
@@ -110,9 +115,11 @@ int cgx_lmac_evh_unregister(void *cgxd, int lmac_id);
 int cgx_get_tx_stats(void *cgxd, int lmac_id, int idx, u64 *tx_stat);
 int cgx_get_rx_stats(void *cgxd, int lmac_id, int idx, u64 *rx_stat);
 int cgx_lmac_rx_tx_enable(void *cgxd, int lmac_id, bool enable);
+int cgx_lmac_tx_enable(void *cgxd, int lmac_id, bool enable);
 int cgx_lmac_addr_set(u8 cgx_id, u8 lmac_id, u8 *mac_addr);
 u64 cgx_lmac_addr_get(u8 cgx_id, u8 lmac_id);
 void cgx_lmac_promisc_config(int cgx_id, int lmac_id, bool enable);
+void cgx_lmac_enadis_rx_pause_fwding(void *cgxd, int lmac_id, bool enable);
 int cgx_lmac_internal_loopback(void *cgxd, int lmac_id, bool enable);
 int cgx_get_link_info(void *cgxd, int lmac_id,
 		      struct cgx_link_user_info *linfo);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index de3fe25..fc9c731 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -127,6 +127,7 @@ M(ATTACH_RESOURCES,	0x002, attach_resources, rsrc_attach, msg_rsp)	\
 M(DETACH_RESOURCES,	0x003, detach_resources, rsrc_detach, msg_rsp)	\
 M(MSIX_OFFSET,		0x004, msix_offset, msg_req, msix_offset_rsp)	\
 M(VF_FLR,		0x006, vf_flr, msg_req, msg_rsp)		\
+M(GET_HW_CAP,		0x008, get_hw_cap, msg_req, get_hw_cap_rsp)	\
 /* CGX mbox IDs (range 0x200 - 0x3FF) */				\
 M(CGX_START_RXTX,	0x200, cgx_start_rxtx, msg_req, msg_rsp)	\
 M(CGX_STOP_RXTX,	0x201, cgx_stop_rxtx, msg_req, msg_rsp)		\
@@ -302,6 +303,12 @@ struct msix_offset_rsp {
 	u16  cptlf_msixoff[MAX_RVU_BLKLF_CNT];
 };
 
+struct get_hw_cap_rsp {
+	struct mbox_msghdr hdr;
+	u8 nix_fixed_txschq_mapping; /* Schq mapping fixed or flexible */
+	u8 nix_shaping;		     /* Is shaping and coloring supported */
+};
+
 /* CGX mbox message formats */
 
 struct cgx_stats_rsp {
@@ -514,6 +521,9 @@ struct nix_txsch_alloc_rsp {
 	/* Scheduler queue list allocated at each level */
 	u16 schq_contig_list[NIX_TXSCH_LVL_CNT][MAX_TXSCHQ_PER_FUNC];
 	u16 schq_list[NIX_TXSCH_LVL_CNT][MAX_TXSCHQ_PER_FUNC];
+	u8  aggr_level; /* Traffic aggregation scheduler level */
+	u8  aggr_lvl_rr_prio; /* Aggregation lvl's RR_PRIO config */
+	u8  link_cfg_lvl; /* LINKX_CFG CSRs mapped to TL3 or TL2's index ? */
 };
 
 struct nix_txsch_free_req {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 49e48b6d..bf9272f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -56,12 +56,31 @@ static char *mkex_profile; /* MKEX profile name */
 module_param(mkex_profile, charp, 0000);
 MODULE_PARM_DESC(mkex_profile, "MKEX profile name string");
 
+static void rvu_setup_hw_capabilities(struct rvu *rvu)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+
+	hw->cap.nix_tx_aggr_lvl = NIX_TXSCH_LVL_TL1;
+	hw->cap.nix_fixed_txschq_mapping = false;
+	hw->cap.nix_shaping = true;
+	hw->cap.nix_tx_link_bp = true;
+
+	if (is_rvu_96xx_B0(rvu)) {
+		hw->cap.nix_fixed_txschq_mapping = true;
+		hw->cap.nix_txsch_per_cgx_lmac = 4;
+		hw->cap.nix_txsch_per_lbk_lmac = 132;
+		hw->cap.nix_txsch_per_sdp_lmac = 76;
+		hw->cap.nix_shaping = false;
+		hw->cap.nix_tx_link_bp = false;
+	}
+}
+
 /* Poll a RVU block's register 'offset', for a 'zero'
  * or 'nonzero' at bits specified by 'mask'
  */
 int rvu_poll_reg(struct rvu *rvu, u64 block, u64 offset, u64 mask, bool zero)
 {
-	unsigned long timeout = jiffies + usecs_to_jiffies(100);
+	unsigned long timeout = jiffies + usecs_to_jiffies(10000);
 	void __iomem *reg;
 	u64 reg_val;
 
@@ -73,7 +92,6 @@ int rvu_poll_reg(struct rvu *rvu, u64 block, u64 offset, u64 mask, bool zero)
 		if (!zero && (reg_val & mask))
 			return 0;
 		usleep_range(1, 5);
-		timeout--;
 	}
 	return -EBUSY;
 }
@@ -1363,6 +1381,17 @@ int rvu_mbox_handler_vf_flr(struct rvu *rvu, struct msg_req *req,
 	return 0;
 }
 
+int rvu_mbox_handler_get_hw_cap(struct rvu *rvu, struct msg_req *req,
+				struct get_hw_cap_rsp *rsp)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+
+	rsp->nix_fixed_txschq_mapping = hw->cap.nix_fixed_txschq_mapping;
+	rsp->nix_shaping = hw->cap.nix_shaping;
+
+	return 0;
+}
+
 static int rvu_process_mbox_msg(struct otx2_mbox *mbox, int devid,
 				struct mbox_msghdr *req)
 {
@@ -2448,6 +2477,8 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	rvu_reset_all_blocks(rvu);
 
+	rvu_setup_hw_capabilities(rvu);
+
 	err = rvu_setup_hw_resources(rvu);
 	if (err)
 		goto err_release_regions;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 7e990bb..000d02b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -184,10 +184,12 @@ struct rvu_pfvf {
 struct nix_txsch {
 	struct rsrc_bmap schq;
 	u8   lvl;
-#define NIX_TXSCHQ_TL1_CFG_DONE       BIT_ULL(0)
+#define NIX_TXSCHQ_FREE		      BIT_ULL(1)
+#define NIX_TXSCHQ_CFG_DONE	      BIT_ULL(0)
 #define TXSCH_MAP_FUNC(__pfvf_map)    ((__pfvf_map) & 0xFFFF)
 #define TXSCH_MAP_FLAGS(__pfvf_map)   ((__pfvf_map) >> 16)
 #define TXSCH_MAP(__func, __flags)    (((__func) & 0xFFFF) | ((__flags) << 16))
+#define TXSCH_SET_FLAG(__pfvf_map, flag)    ((__pfvf_map) | ((flag) << 16))
 	u32  *pfvf_map;
 };
 
@@ -221,6 +223,20 @@ struct nix_hw {
 	struct nix_lso lso;
 };
 
+/* RVU block's capabilities or functionality,
+ * which vary by silicon version/skew.
+ */
+struct hw_cap {
+	/* Transmit side supported functionality */
+	u8	nix_tx_aggr_lvl; /* Tx link's traffic aggregation level */
+	u16	nix_txsch_per_cgx_lmac; /* Max Q's transmitting to CGX LMAC */
+	u16	nix_txsch_per_lbk_lmac; /* Max Q's transmitting to LBK LMAC */
+	u16	nix_txsch_per_sdp_lmac; /* Max Q's transmitting to SDP LMAC */
+	bool	nix_fixed_txschq_mapping; /* Schq mapping fixed or flexible */
+	bool	nix_shaping;		 /* Is shaping and coloring supported */
+	bool	nix_tx_link_bp;		 /* Can link backpressure TL queues ? */
+};
+
 struct rvu_hwinfo {
 	u8	total_pfs;   /* MAX RVU PFs HW supports */
 	u16	total_vfs;   /* Max RVU VFs HW supports */
@@ -232,7 +248,7 @@ struct rvu_hwinfo {
 	u8	sdp_links;
 	u8	npc_kpus;          /* No of parser units */
 
-
+	struct hw_cap    cap;
 	struct rvu_block block[BLK_COUNT]; /* Block info */
 	struct nix_hw    *nix0;
 	struct npc_pkind pkind;
@@ -317,7 +333,8 @@ static inline u64 rvupf_read64(struct rvu *rvu, u64 offset)
 	return readq(rvu->pfreg_base + offset);
 }
 
-static inline bool is_rvu_9xxx_A0(struct rvu *rvu)
+/* Silicon revisions */
+static inline bool is_rvu_96xx_A0(struct rvu *rvu)
 {
 	struct pci_dev *pdev = rvu->pdev;
 
@@ -325,6 +342,14 @@ static inline bool is_rvu_9xxx_A0(struct rvu *rvu)
 		(pdev->subsystem_device == PCI_SUBSYS_DEVID_96XX);
 }
 
+static inline bool is_rvu_96xx_B0(struct rvu *rvu)
+{
+	struct pci_dev *pdev = rvu->pdev;
+
+	return ((pdev->revision == 0x00) || (pdev->revision == 0x01)) &&
+		(pdev->subsystem_device == PCI_SUBSYS_DEVID_96XX);
+}
+
 /* Function Prototypes
  * RVU
  */
@@ -383,6 +408,7 @@ int rvu_cgx_init(struct rvu *rvu);
 int rvu_cgx_exit(struct rvu *rvu);
 void *rvu_cgx_pdata(u8 cgx_id, struct rvu *rvu);
 int rvu_cgx_config_rxtx(struct rvu *rvu, u16 pcifunc, bool start);
+void rvu_cgx_enadis_rx_bp(struct rvu *rvu, int pf, bool enable);
 int rvu_cgx_nix_cuml_stats(struct rvu *rvu, void *cgxd, int lmac_id, int index,
 			   int rxtxflag, u64 *stat);
 /* NPA APIs */
@@ -400,6 +426,7 @@ int rvu_nix_reserve_mark_format(struct rvu *rvu, struct nix_hw *nix_hw,
 void rvu_nix_freemem(struct rvu *rvu);
 int rvu_get_nixlf_count(struct rvu *rvu);
 void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int npalf);
+int nix_get_nixlf(struct rvu *rvu, u16 pcifunc, int *nixlf);
 
 /* NPC APIs */
 int rvu_npc_init(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 65d01e5..7e110b7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -348,6 +348,24 @@ int rvu_cgx_exit(struct rvu *rvu)
 	return 0;
 }
 
+void rvu_cgx_enadis_rx_bp(struct rvu *rvu, int pf, bool enable)
+{
+	u8 cgx_id, lmac_id;
+	void *cgxd;
+
+	if (!is_pf_cgxmapped(rvu, pf))
+		return;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	cgxd = rvu_cgx_pdata(cgx_id, rvu);
+
+	/* Set / clear CTL_BCK to control pause frame forwarding to NIX */
+	if (enable)
+		cgx_lmac_enadis_rx_pause_fwding(cgxd, lmac_id, true);
+	else
+		cgx_lmac_enadis_rx_pause_fwding(cgxd, lmac_id, false);
+}
+
 int rvu_cgx_config_rxtx(struct rvu *rvu, u16 pcifunc, bool start)
 {
 	int pf = rvu_get_pf(pcifunc);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 994ed71..3b32e91 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -127,17 +127,12 @@ static void nix_rx_sync(struct rvu *rvu, int blkaddr)
 	err = rvu_poll_reg(rvu, blkaddr, NIX_AF_RX_SW_SYNC, BIT_ULL(0), true);
 	if (err)
 		dev_err(rvu->dev, "NIX RX software sync failed\n");
-
-	/* As per a HW errata in 9xxx A0 silicon, HW may clear SW_SYNC[ENA]
-	 * bit too early. Hence wait for 50us more.
-	 */
-	if (is_rvu_9xxx_A0(rvu))
-		usleep_range(50, 60);
 }
 
 static bool is_valid_txschq(struct rvu *rvu, int blkaddr,
 			    int lvl, u16 pcifunc, u16 schq)
 {
+	struct rvu_hwinfo *hw = rvu->hw;
 	struct nix_txsch *txsch;
 	struct nix_hw *nix_hw;
 	u16 map_func;
@@ -155,13 +150,15 @@ static bool is_valid_txschq(struct rvu *rvu, int blkaddr,
 	map_func = TXSCH_MAP_FUNC(txsch->pfvf_map[schq]);
 	mutex_unlock(&rvu->rsrc_lock);
 
-	/* For TL1 schq, sharing across VF's of same PF is ok */
-	if (lvl == NIX_TXSCH_LVL_TL1 &&
-	    rvu_get_pf(map_func) != rvu_get_pf(pcifunc))
-		return false;
+	/* TLs aggegating traffic are shared across PF and VFs */
+	if (lvl >= hw->cap.nix_tx_aggr_lvl) {
+		if (rvu_get_pf(map_func) != rvu_get_pf(pcifunc))
+			return false;
+		else
+			return true;
+	}
 
-	if (lvl != NIX_TXSCH_LVL_TL1 &&
-	    map_func != pcifunc)
+	if (map_func != pcifunc)
 		return false;
 
 	return true;
@@ -1048,6 +1045,9 @@ static void nix_reset_tx_linkcfg(struct rvu *rvu, int blkaddr,
 	struct rvu_hwinfo *hw = rvu->hw;
 	int link;
 
+	if (lvl >= hw->cap.nix_tx_aggr_lvl)
+		return;
+
 	/* Reset TL4's SDP link config */
 	if (lvl == NIX_TXSCH_LVL_TL4)
 		rvu_write64(rvu, blkaddr, NIX_AF_TL4X_SDP_LINK_CFG(schq), 0x00);
@@ -1061,83 +1061,185 @@ static void nix_reset_tx_linkcfg(struct rvu *rvu, int blkaddr,
 			    NIX_AF_TL3_TL2X_LINKX_CFG(schq, link), 0x00);
 }
 
-static int
-rvu_get_tl1_schqs(struct rvu *rvu, int blkaddr, u16 pcifunc,
-		  u16 *schq_list, u16 *schq_cnt)
+static int nix_get_tx_link(struct rvu *rvu, u16 pcifunc)
 {
-	struct nix_txsch *txsch;
-	struct nix_hw *nix_hw;
-	struct rvu_pfvf *pfvf;
-	u8 cgx_id, lmac_id;
-	u16 schq_base;
-	u32 *pfvf_map;
-	int pf, intf;
+	struct rvu_hwinfo *hw = rvu->hw;
+	int pf = rvu_get_pf(pcifunc);
+	u8 cgx_id = 0, lmac_id = 0;
 
-	nix_hw = get_nix_hw(rvu->hw, blkaddr);
-	if (!nix_hw)
-		return -ENODEV;
+	if (is_afvf(pcifunc)) {/* LBK links */
+		return hw->cgx_links;
+	} else if (is_pf_cgxmapped(rvu, pf)) {
+		rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+		return (cgx_id * hw->lmac_per_cgx) + lmac_id;
+	}
 
-	pfvf = rvu_get_pfvf(rvu, pcifunc);
-	txsch = &nix_hw->txsch[NIX_TXSCH_LVL_TL1];
-	pfvf_map = txsch->pfvf_map;
-	pf = rvu_get_pf(pcifunc);
+	/* SDP link */
+	return hw->cgx_links + hw->lbk_links;
+}
 
-	/* static allocation as two TL1's per link */
-	intf = is_afvf(pcifunc) ? NIX_INTF_TYPE_LBK : NIX_INTF_TYPE_CGX;
+static void nix_get_txschq_range(struct rvu *rvu, u16 pcifunc,
+				 int link, int *start, int *end)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	int pf = rvu_get_pf(pcifunc);
 
-	switch (intf) {
-	case NIX_INTF_TYPE_CGX:
-		rvu_get_cgx_lmac_id(pfvf->cgx_lmac, &cgx_id, &lmac_id);
-		schq_base = (cgx_id * MAX_LMAC_PER_CGX + lmac_id) * 2;
-		break;
-	case NIX_INTF_TYPE_LBK:
-		schq_base = rvu->cgx_cnt_max * MAX_LMAC_PER_CGX * 2;
-		break;
-	default:
-		return -ENODEV;
+	if (is_afvf(pcifunc)) { /* LBK links */
+		*start = hw->cap.nix_txsch_per_cgx_lmac * link;
+		*end = *start + hw->cap.nix_txsch_per_lbk_lmac;
+	} else if (is_pf_cgxmapped(rvu, pf)) { /* CGX links */
+		*start = hw->cap.nix_txsch_per_cgx_lmac * link;
+		*end = *start + hw->cap.nix_txsch_per_cgx_lmac;
+	} else { /* SDP link */
+		*start = (hw->cap.nix_txsch_per_cgx_lmac * hw->cgx_links) +
+			(hw->cap.nix_txsch_per_lbk_lmac * hw->lbk_links);
+		*end = *start + hw->cap.nix_txsch_per_sdp_lmac;
 	}
+}
 
-	if (schq_base + 1 > txsch->schq.max)
-		return -ENODEV;
+static int nix_check_txschq_alloc_req(struct rvu *rvu, int lvl, u16 pcifunc,
+				      struct nix_hw *nix_hw,
+				      struct nix_txsch_alloc_req *req)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	int schq, req_schq, free_cnt;
+	struct nix_txsch *txsch;
+	int link, start, end;
+
+	txsch = &nix_hw->txsch[lvl];
+	req_schq = req->schq_contig[lvl] + req->schq[lvl];
 
-	/* init pfvf_map as we store flags */
-	if (pfvf_map[schq_base] == U32_MAX) {
-		pfvf_map[schq_base] =
-			TXSCH_MAP((pf << RVU_PFVF_PF_SHIFT), 0);
-		pfvf_map[schq_base + 1] =
-			TXSCH_MAP((pf << RVU_PFVF_PF_SHIFT), 0);
+	if (!req_schq)
+		return 0;
 
-		/* Onetime reset for TL1 */
-		nix_reset_tx_linkcfg(rvu, blkaddr,
-				     NIX_TXSCH_LVL_TL1, schq_base);
-		nix_reset_tx_shaping(rvu, blkaddr,
-				     NIX_TXSCH_LVL_TL1, schq_base);
+	link = nix_get_tx_link(rvu, pcifunc);
 
-		nix_reset_tx_linkcfg(rvu, blkaddr,
-				     NIX_TXSCH_LVL_TL1, schq_base + 1);
-		nix_reset_tx_shaping(rvu, blkaddr,
-				     NIX_TXSCH_LVL_TL1, schq_base + 1);
+	/* For traffic aggregating scheduler level, one queue is enough */
+	if (lvl >= hw->cap.nix_tx_aggr_lvl) {
+		if (req_schq != 1)
+			return NIX_AF_ERR_TLX_ALLOC_FAIL;
+		return 0;
 	}
 
-	if (schq_list && schq_cnt) {
-		schq_list[0] = schq_base;
-		schq_list[1] = schq_base + 1;
-		*schq_cnt = 2;
+	/* Get free SCHQ count and check if request can be accomodated */
+	if (hw->cap.nix_fixed_txschq_mapping) {
+		nix_get_txschq_range(rvu, pcifunc, link, &start, &end);
+		schq = start + (pcifunc & RVU_PFVF_FUNC_MASK);
+		if (end <= txsch->schq.max && schq < end &&
+		    !test_bit(schq, txsch->schq.bmap))
+			free_cnt = 1;
+		else
+			free_cnt = 0;
+	} else {
+		free_cnt = rvu_rsrc_free_count(&txsch->schq);
 	}
 
+	if (free_cnt < req_schq || req_schq > MAX_TXSCHQ_PER_FUNC)
+		return NIX_AF_ERR_TLX_ALLOC_FAIL;
+
+	/* If contiguous queues are needed, check for availability */
+	if (!hw->cap.nix_fixed_txschq_mapping && req->schq_contig[lvl] &&
+	    !rvu_rsrc_check_contig(&txsch->schq, req->schq_contig[lvl]))
+		return NIX_AF_ERR_TLX_ALLOC_FAIL;
+
 	return 0;
 }
 
+static void nix_txsch_alloc(struct rvu *rvu, struct nix_txsch *txsch,
+			    struct nix_txsch_alloc_rsp *rsp,
+			    int lvl, int start, int end)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	u16 pcifunc = rsp->hdr.pcifunc;
+	int idx, schq;
+
+	/* For traffic aggregating levels, queue alloc is based
+	 * on transmit link to which PF_FUNC is mapped to.
+	 */
+	if (lvl >= hw->cap.nix_tx_aggr_lvl) {
+		/* A single TL queue is allocated */
+		if (rsp->schq_contig[lvl]) {
+			rsp->schq_contig[lvl] = 1;
+			rsp->schq_contig_list[lvl][0] = start;
+		}
+
+		/* Both contig and non-contig reqs doesn't make sense here */
+		if (rsp->schq_contig[lvl])
+			rsp->schq[lvl] = 0;
+
+		if (rsp->schq[lvl]) {
+			rsp->schq[lvl] = 1;
+			rsp->schq_list[lvl][0] = start;
+		}
+		return;
+	}
+
+	/* Adjust the queue request count if HW supports
+	 * only one queue per level configuration.
+	 */
+	if (hw->cap.nix_fixed_txschq_mapping) {
+		idx = pcifunc & RVU_PFVF_FUNC_MASK;
+		schq = start + idx;
+		if (idx >= (end - start) || test_bit(schq, txsch->schq.bmap)) {
+			rsp->schq_contig[lvl] = 0;
+			rsp->schq[lvl] = 0;
+			return;
+		}
+
+		if (rsp->schq_contig[lvl]) {
+			rsp->schq_contig[lvl] = 1;
+			set_bit(schq, txsch->schq.bmap);
+			rsp->schq_contig_list[lvl][0] = schq;
+			rsp->schq[lvl] = 0;
+		} else if (rsp->schq[lvl]) {
+			rsp->schq[lvl] = 1;
+			set_bit(schq, txsch->schq.bmap);
+			rsp->schq_list[lvl][0] = schq;
+		}
+		return;
+	}
+
+	/* Allocate contiguous queue indices requesty first */
+	if (rsp->schq_contig[lvl]) {
+		schq = bitmap_find_next_zero_area(txsch->schq.bmap,
+						  txsch->schq.max, start,
+						  rsp->schq_contig[lvl], 0);
+		if (schq >= end)
+			rsp->schq_contig[lvl] = 0;
+		for (idx = 0; idx < rsp->schq_contig[lvl]; idx++) {
+			set_bit(schq, txsch->schq.bmap);
+			rsp->schq_contig_list[lvl][idx] = schq;
+			schq++;
+		}
+	}
+
+	/* Allocate non-contiguous queue indices */
+	if (rsp->schq[lvl]) {
+		idx = 0;
+		for (schq = start; schq < end; schq++) {
+			if (!test_bit(schq, txsch->schq.bmap)) {
+				set_bit(schq, txsch->schq.bmap);
+				rsp->schq_list[lvl][idx++] = schq;
+			}
+			if (idx == rsp->schq[lvl])
+				break;
+		}
+		/* Update how many were allocated */
+		rsp->schq[lvl] = idx;
+	}
+}
+
 int rvu_mbox_handler_nix_txsch_alloc(struct rvu *rvu,
 				     struct nix_txsch_alloc_req *req,
 				     struct nix_txsch_alloc_rsp *rsp)
 {
+	struct rvu_hwinfo *hw = rvu->hw;
 	u16 pcifunc = req->hdr.pcifunc;
+	int link, blkaddr, rc = 0;
+	int lvl, idx, start, end;
 	struct nix_txsch *txsch;
-	int lvl, idx, req_schq;
 	struct rvu_pfvf *pfvf;
 	struct nix_hw *nix_hw;
-	int blkaddr, rc = 0;
 	u32 *pfvf_map;
 	u16 schq;
 
@@ -1151,83 +1253,66 @@ int rvu_mbox_handler_nix_txsch_alloc(struct rvu *rvu,
 		return -EINVAL;
 
 	mutex_lock(&rvu->rsrc_lock);
-	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
-		txsch = &nix_hw->txsch[lvl];
-		req_schq = req->schq_contig[lvl] + req->schq[lvl];
-		pfvf_map = txsch->pfvf_map;
-
-		if (!req_schq)
-			continue;
 
-		/* There are only 28 TL1s */
-		if (lvl == NIX_TXSCH_LVL_TL1) {
-			if (req->schq_contig[lvl] ||
-			    req->schq[lvl] > 2 ||
-			    rvu_get_tl1_schqs(rvu, blkaddr,
-					      pcifunc, NULL, NULL))
-				goto err;
-			continue;
-		}
-
-		/* Check if request is valid */
-		if (req_schq > MAX_TXSCHQ_PER_FUNC)
-			goto err;
-
-		/* If contiguous queues are needed, check for availability */
-		if (req->schq_contig[lvl] &&
-		    !rvu_rsrc_check_contig(&txsch->schq, req->schq_contig[lvl]))
-			goto err;
-
-		/* Check if full request can be accommodated */
-		if (req_schq >= rvu_rsrc_free_count(&txsch->schq))
+	/* Check if request is valid as per HW capabilities
+	 * and can be accomodated.
+	 */
+	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
+		rc = nix_check_txschq_alloc_req(rvu, lvl, pcifunc, nix_hw, req);
+		if (rc)
 			goto err;
 	}
 
+	/* Allocate requested Tx scheduler queues */
 	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
 		txsch = &nix_hw->txsch[lvl];
-		rsp->schq_contig[lvl] = req->schq_contig[lvl];
 		pfvf_map = txsch->pfvf_map;
-		rsp->schq[lvl] = req->schq[lvl];
 
 		if (!req->schq[lvl] && !req->schq_contig[lvl])
 			continue;
 
-		/* Handle TL1 specially as it is
-		 * allocation is restricted to 2 TL1's
-		 * per link
-		 */
+		rsp->schq[lvl] = req->schq[lvl];
+		rsp->schq_contig[lvl] = req->schq_contig[lvl];
 
-		if (lvl == NIX_TXSCH_LVL_TL1) {
-			rsp->schq_contig[lvl] = 0;
-			rvu_get_tl1_schqs(rvu, blkaddr, pcifunc,
-					  &rsp->schq_list[lvl][0],
-					  &rsp->schq[lvl]);
-			continue;
+		link = nix_get_tx_link(rvu, pcifunc);
+
+		if (lvl >= hw->cap.nix_tx_aggr_lvl) {
+			start = link;
+			end = link;
+		} else if (hw->cap.nix_fixed_txschq_mapping) {
+			nix_get_txschq_range(rvu, pcifunc, link, &start, &end);
+		} else {
+			start = 0;
+			end = txsch->schq.max;
 		}
 
-		/* Alloc contiguous queues first */
-		if (req->schq_contig[lvl]) {
-			schq = rvu_alloc_rsrc_contig(&txsch->schq,
-						     req->schq_contig[lvl]);
+		nix_txsch_alloc(rvu, txsch, rsp, lvl, start, end);
 
-			for (idx = 0; idx < req->schq_contig[lvl]; idx++) {
+		/* Reset queue config */
+		for (idx = 0; idx < req->schq_contig[lvl]; idx++) {
+			schq = rsp->schq_contig_list[lvl][idx];
+			if (!(TXSCH_MAP_FLAGS(pfvf_map[schq]) &
+			    NIX_TXSCHQ_CFG_DONE))
 				pfvf_map[schq] = TXSCH_MAP(pcifunc, 0);
-				nix_reset_tx_linkcfg(rvu, blkaddr, lvl, schq);
-				nix_reset_tx_shaping(rvu, blkaddr, lvl, schq);
-				rsp->schq_contig_list[lvl][idx] = schq;
-				schq++;
-			}
+			nix_reset_tx_linkcfg(rvu, blkaddr, lvl, schq);
+			nix_reset_tx_shaping(rvu, blkaddr, lvl, schq);
 		}
 
-		/* Alloc non-contiguous queues */
 		for (idx = 0; idx < req->schq[lvl]; idx++) {
-			schq = rvu_alloc_rsrc(&txsch->schq);
-			pfvf_map[schq] = TXSCH_MAP(pcifunc, 0);
+			schq = rsp->schq_list[lvl][idx];
+			if (!(TXSCH_MAP_FLAGS(pfvf_map[schq]) &
+			    NIX_TXSCHQ_CFG_DONE))
+				pfvf_map[schq] = TXSCH_MAP(pcifunc, 0);
 			nix_reset_tx_linkcfg(rvu, blkaddr, lvl, schq);
 			nix_reset_tx_shaping(rvu, blkaddr, lvl, schq);
-			rsp->schq_list[lvl][idx] = schq;
 		}
 	}
+
+	rsp->aggr_level = hw->cap.nix_tx_aggr_lvl;
+	rsp->aggr_lvl_rr_prio = TXSCH_TL1_DFLT_RR_PRIO;
+	rsp->link_cfg_lvl = rvu_read64(rvu, blkaddr,
+				       NIX_AF_PSE_CHANNEL_LEVEL) & 0x01 ?
+				       NIX_TXSCH_LVL_TL3 : NIX_TXSCH_LVL_TL2;
 	goto exit;
 err:
 	rc = NIX_AF_ERR_TLX_ALLOC_FAIL;
@@ -1236,13 +1321,50 @@ int rvu_mbox_handler_nix_txsch_alloc(struct rvu *rvu,
 	return rc;
 }
 
+static void nix_smq_flush(struct rvu *rvu, int blkaddr,
+			  int smq, u16 pcifunc, int nixlf)
+{
+	int pf = rvu_get_pf(pcifunc);
+	u8 cgx_id = 0, lmac_id = 0;
+	int err, restore_tx_en = 0;
+	u64 cfg;
+
+	/* enable cgx tx if disabled */
+	if (is_pf_cgxmapped(rvu, pf)) {
+		rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+		restore_tx_en = !cgx_lmac_tx_enable(rvu_cgx_pdata(cgx_id, rvu),
+						    lmac_id, true);
+	}
+
+	cfg = rvu_read64(rvu, blkaddr, NIX_AF_SMQX_CFG(smq));
+	/* Do SMQ flush and set enqueue xoff */
+	cfg |= BIT_ULL(50) | BIT_ULL(49);
+	rvu_write64(rvu, blkaddr, NIX_AF_SMQX_CFG(smq), cfg);
+
+	/* Disable backpressure from physical link,
+	 * otherwise SMQ flush may stall.
+	 */
+	rvu_cgx_enadis_rx_bp(rvu, pf, false);
+
+	/* Wait for flush to complete */
+	err = rvu_poll_reg(rvu, blkaddr,
+			   NIX_AF_SMQX_CFG(smq), BIT_ULL(49), true);
+	if (err)
+		dev_err(rvu->dev,
+			"NIXLF%d: SMQ%d flush failed\n", nixlf, smq);
+
+	rvu_cgx_enadis_rx_bp(rvu, pf, true);
+	/* restore cgx tx state */
+	if (restore_tx_en)
+		cgx_lmac_tx_enable(rvu_cgx_pdata(cgx_id, rvu), lmac_id, false);
+}
+
 static int nix_txschq_free(struct rvu *rvu, u16 pcifunc)
 {
 	int blkaddr, nixlf, lvl, schq, err;
 	struct rvu_hwinfo *hw = rvu->hw;
 	struct nix_txsch *txsch;
 	struct nix_hw *nix_hw;
-	u64 cfg;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
 	if (blkaddr < 0)
@@ -1275,26 +1397,15 @@ static int nix_txschq_free(struct rvu *rvu, u16 pcifunc)
 	for (schq = 0; schq < txsch->schq.max; schq++) {
 		if (TXSCH_MAP_FUNC(txsch->pfvf_map[schq]) != pcifunc)
 			continue;
-		cfg = rvu_read64(rvu, blkaddr, NIX_AF_SMQX_CFG(schq));
-		/* Do SMQ flush and set enqueue xoff */
-		cfg |= BIT_ULL(50) | BIT_ULL(49);
-		rvu_write64(rvu, blkaddr, NIX_AF_SMQX_CFG(schq), cfg);
-
-		/* Wait for flush to complete */
-		err = rvu_poll_reg(rvu, blkaddr,
-				   NIX_AF_SMQX_CFG(schq), BIT_ULL(49), true);
-		if (err) {
-			dev_err(rvu->dev,
-				"NIXLF%d: SMQ%d flush failed\n", nixlf, schq);
-		}
+		nix_smq_flush(rvu, blkaddr, schq, pcifunc, nixlf);
 	}
 
 	/* Now free scheduler queues to free pool */
 	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
-		/* Free all SCHQ's except TL1 as
-		 * TL1 is shared across all VF's for a RVU PF
-		 */
-		if (lvl == NIX_TXSCH_LVL_TL1)
+		 /* TLs above aggregation level are shared across all PF
+		  * and it's VFs, hence skip freeing them.
+		  */
+		if (lvl >= hw->cap.nix_tx_aggr_lvl)
 			continue;
 
 		txsch = &nix_hw->txsch[lvl];
@@ -1302,7 +1413,7 @@ static int nix_txschq_free(struct rvu *rvu, u16 pcifunc)
 			if (TXSCH_MAP_FUNC(txsch->pfvf_map[schq]) != pcifunc)
 				continue;
 			rvu_free_rsrc(&txsch->schq, schq);
-			txsch->pfvf_map[schq] = 0;
+			txsch->pfvf_map[schq] = TXSCH_MAP(0, NIX_TXSCHQ_FREE);
 		}
 	}
 	mutex_unlock(&rvu->rsrc_lock);
@@ -1319,13 +1430,12 @@ static int nix_txschq_free(struct rvu *rvu, u16 pcifunc)
 static int nix_txschq_free_one(struct rvu *rvu,
 			       struct nix_txsch_free_req *req)
 {
-	int lvl, schq, nixlf, blkaddr, rc;
 	struct rvu_hwinfo *hw = rvu->hw;
 	u16 pcifunc = req->hdr.pcifunc;
+	int lvl, schq, nixlf, blkaddr;
 	struct nix_txsch *txsch;
 	struct nix_hw *nix_hw;
 	u32 *pfvf_map;
-	u64 cfg;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
 	if (blkaddr < 0)
@@ -1343,10 +1453,8 @@ static int nix_txschq_free_one(struct rvu *rvu,
 	schq = req->schq;
 	txsch = &nix_hw->txsch[lvl];
 
-	/* Don't allow freeing TL1 */
-	if (lvl > NIX_TXSCH_LVL_TL2 ||
-	    schq >= txsch->schq.max)
-		goto err;
+	if (lvl >= hw->cap.nix_tx_aggr_lvl || schq >= txsch->schq.max)
+		return 0;
 
 	pfvf_map = txsch->pfvf_map;
 	mutex_lock(&rvu->rsrc_lock);
@@ -1359,24 +1467,12 @@ static int nix_txschq_free_one(struct rvu *rvu,
 	/* Flush if it is a SMQ. Onus of disabling
 	 * TL2/3 queue links before SMQ flush is on user
 	 */
-	if (lvl == NIX_TXSCH_LVL_SMQ) {
-		cfg = rvu_read64(rvu, blkaddr, NIX_AF_SMQX_CFG(schq));
-		/* Do SMQ flush and set enqueue xoff */
-		cfg |= BIT_ULL(50) | BIT_ULL(49);
-		rvu_write64(rvu, blkaddr, NIX_AF_SMQX_CFG(schq), cfg);
-
-		/* Wait for flush to complete */
-		rc = rvu_poll_reg(rvu, blkaddr,
-				  NIX_AF_SMQX_CFG(schq), BIT_ULL(49), true);
-		if (rc) {
-			dev_err(rvu->dev,
-				"NIXLF%d: SMQ%d flush failed\n", nixlf, schq);
-		}
-	}
+	if (lvl == NIX_TXSCH_LVL_SMQ)
+		nix_smq_flush(rvu, blkaddr, schq, pcifunc, nixlf);
 
 	/* Free the resource */
 	rvu_free_rsrc(&txsch->schq, schq);
-	txsch->pfvf_map[schq] = 0;
+	txsch->pfvf_map[schq] = TXSCH_MAP(0, NIX_TXSCHQ_FREE);
 	mutex_unlock(&rvu->rsrc_lock);
 	return 0;
 err:
@@ -1393,8 +1489,8 @@ int rvu_mbox_handler_nix_txsch_free(struct rvu *rvu,
 		return nix_txschq_free_one(rvu, req);
 }
 
-static bool is_txschq_config_valid(struct rvu *rvu, u16 pcifunc, int blkaddr,
-				   int lvl, u64 reg, u64 regval)
+static bool is_txschq_hierarchy_valid(struct rvu *rvu, u16 pcifunc, int blkaddr,
+				      int lvl, u64 reg, u64 regval)
 {
 	u64 regbase = reg & 0xFFFF;
 	u16 schq, parent;
@@ -1431,79 +1527,82 @@ static bool is_txschq_config_valid(struct rvu *rvu, u16 pcifunc, int blkaddr,
 	return true;
 }
 
-static int
-nix_tl1_default_cfg(struct rvu *rvu, u16 pcifunc)
+static bool is_txschq_shaping_valid(struct rvu_hwinfo *hw, int lvl, u64 reg)
 {
-	u16 schq_list[2], schq_cnt, schq;
-	int blkaddr, idx, err = 0;
-	u16 map_func, map_flags;
-	struct nix_hw *nix_hw;
-	u64 reg, regval;
-	u32 *pfvf_map;
-
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
-	if (blkaddr < 0)
-		return NIX_AF_ERR_AF_LF_INVALID;
-
-	nix_hw = get_nix_hw(rvu->hw, blkaddr);
-	if (!nix_hw)
-		return -EINVAL;
+	u64 regbase;
 
-	pfvf_map = nix_hw->txsch[NIX_TXSCH_LVL_TL1].pfvf_map;
-
-	mutex_lock(&rvu->rsrc_lock);
+	if (hw->cap.nix_shaping)
+		return true;
 
-	err = rvu_get_tl1_schqs(rvu, blkaddr,
-				pcifunc, schq_list, &schq_cnt);
-	if (err)
-		goto unlock;
-
-	for (idx = 0; idx < schq_cnt; idx++) {
-		schq = schq_list[idx];
-		map_func = TXSCH_MAP_FUNC(pfvf_map[schq]);
-		map_flags = TXSCH_MAP_FLAGS(pfvf_map[schq]);
+	/* If shaping and coloring is not supported, then
+	 * *_CIR and *_PIR registers should not be configured.
+	 */
+	regbase = reg & 0xFFFF;
 
-		/* check if config is already done or this is pf */
-		if (map_flags & NIX_TXSCHQ_TL1_CFG_DONE)
-			continue;
+	switch (lvl) {
+	case NIX_TXSCH_LVL_TL1:
+		if (regbase == NIX_AF_TL1X_CIR(0))
+			return false;
+		break;
+	case NIX_TXSCH_LVL_TL2:
+		if (regbase == NIX_AF_TL2X_CIR(0) ||
+		    regbase == NIX_AF_TL2X_PIR(0))
+			return false;
+		break;
+	case NIX_TXSCH_LVL_TL3:
+		if (regbase == NIX_AF_TL3X_CIR(0) ||
+		    regbase == NIX_AF_TL3X_PIR(0))
+			return false;
+		break;
+	case NIX_TXSCH_LVL_TL4:
+		if (regbase == NIX_AF_TL4X_CIR(0) ||
+		    regbase == NIX_AF_TL4X_PIR(0))
+			return false;
+		break;
+	}
+	return true;
+}
 
-		/* default configuration */
-		reg = NIX_AF_TL1X_TOPOLOGY(schq);
-		regval = (TXSCH_TL1_DFLT_RR_PRIO << 1);
-		rvu_write64(rvu, blkaddr, reg, regval);
-		reg = NIX_AF_TL1X_SCHEDULE(schq);
-		regval = TXSCH_TL1_DFLT_RR_QTM;
-		rvu_write64(rvu, blkaddr, reg, regval);
-		reg = NIX_AF_TL1X_CIR(schq);
-		regval = 0;
-		rvu_write64(rvu, blkaddr, reg, regval);
+static void nix_tl1_default_cfg(struct rvu *rvu, struct nix_hw *nix_hw,
+				u16 pcifunc, int blkaddr)
+{
+	u32 *pfvf_map;
+	int schq;
 
-		map_flags |= NIX_TXSCHQ_TL1_CFG_DONE;
-		pfvf_map[schq] = TXSCH_MAP(map_func, map_flags);
-	}
-unlock:
-	mutex_unlock(&rvu->rsrc_lock);
-	return err;
+	schq = nix_get_tx_link(rvu, pcifunc);
+	pfvf_map = nix_hw->txsch[NIX_TXSCH_LVL_TL1].pfvf_map;
+	/* Skip if PF has already done the config */
+	if (TXSCH_MAP_FLAGS(pfvf_map[schq]) & NIX_TXSCHQ_CFG_DONE)
+		return;
+	rvu_write64(rvu, blkaddr, NIX_AF_TL1X_TOPOLOGY(schq),
+		    (TXSCH_TL1_DFLT_RR_PRIO << 1));
+	rvu_write64(rvu, blkaddr, NIX_AF_TL1X_SCHEDULE(schq),
+		    TXSCH_TL1_DFLT_RR_QTM);
+	rvu_write64(rvu, blkaddr, NIX_AF_TL1X_CIR(schq), 0x00);
+	pfvf_map[schq] = TXSCH_SET_FLAG(pfvf_map[schq], NIX_TXSCHQ_CFG_DONE);
 }
 
 int rvu_mbox_handler_nix_txschq_cfg(struct rvu *rvu,
 				    struct nix_txschq_config *req,
 				    struct msg_rsp *rsp)
 {
-	u16 schq, pcifunc = req->hdr.pcifunc;
 	struct rvu_hwinfo *hw = rvu->hw;
+	u16 pcifunc = req->hdr.pcifunc;
 	u64 reg, regval, schq_regbase;
 	struct nix_txsch *txsch;
-	u16 map_func, map_flags;
 	struct nix_hw *nix_hw;
 	int blkaddr, idx, err;
+	int nixlf, schq;
 	u32 *pfvf_map;
-	int nixlf;
 
 	if (req->lvl >= NIX_TXSCH_LVL_CNT ||
 	    req->num_regs > MAX_REGS_PER_MBOX_MSG)
 		return NIX_AF_INVAL_TXSCHQ_CFG;
 
+	err = nix_get_nixlf(rvu, pcifunc, &nixlf);
+	if (err)
+		return NIX_AF_ERR_AF_LF_INVALID;
+
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
 	if (blkaddr < 0)
 		return NIX_AF_ERR_AF_LF_INVALID;
@@ -1512,19 +1611,16 @@ int rvu_mbox_handler_nix_txschq_cfg(struct rvu *rvu,
 	if (!nix_hw)
 		return -EINVAL;
 
-	nixlf = rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, 0);
-	if (nixlf < 0)
-		return NIX_AF_ERR_AF_LF_INVALID;
-
 	txsch = &nix_hw->txsch[req->lvl];
 	pfvf_map = txsch->pfvf_map;
 
-	/* VF is only allowed to trigger
-	 * setting default cfg on TL1
-	 */
-	if (pcifunc & RVU_PFVF_FUNC_MASK &&
-	    req->lvl == NIX_TXSCH_LVL_TL1) {
-		return nix_tl1_default_cfg(rvu, pcifunc);
+	if (req->lvl >= hw->cap.nix_tx_aggr_lvl &&
+	    pcifunc & RVU_PFVF_FUNC_MASK) {
+		mutex_lock(&rvu->rsrc_lock);
+		if (req->lvl == NIX_TXSCH_LVL_TL1)
+			nix_tl1_default_cfg(rvu, nix_hw, pcifunc, blkaddr);
+		mutex_unlock(&rvu->rsrc_lock);
+		return 0;
 	}
 
 	for (idx = 0; idx < req->num_regs; idx++) {
@@ -1532,10 +1628,14 @@ int rvu_mbox_handler_nix_txschq_cfg(struct rvu *rvu,
 		regval = req->regval[idx];
 		schq_regbase = reg & 0xFFFF;
 
-		if (!is_txschq_config_valid(rvu, pcifunc, blkaddr,
-					    txsch->lvl, reg, regval))
+		if (!is_txschq_hierarchy_valid(rvu, pcifunc, blkaddr,
+					       txsch->lvl, reg, regval))
 			return NIX_AF_INVAL_TXSCHQ_CFG;
 
+		/* Check if shaping and coloring is supported */
+		if (!is_txschq_shaping_valid(hw, req->lvl, reg))
+			continue;
+
 		/* Replace PF/VF visible NIXLF slot with HW NIXLF id */
 		if (schq_regbase == NIX_AF_SMQX_CFG(0)) {
 			nixlf = rvu_get_lf(rvu, &hw->block[blkaddr],
@@ -1544,32 +1644,36 @@ int rvu_mbox_handler_nix_txschq_cfg(struct rvu *rvu,
 			regval |= ((u64)nixlf << 24);
 		}
 
+		/* Clear 'BP_ENA' config, if it's not allowed */
+		if (!hw->cap.nix_tx_link_bp) {
+			if (schq_regbase == NIX_AF_TL4X_SDP_LINK_CFG(0) ||
+			    (schq_regbase & 0xFF00) ==
+			    NIX_AF_TL3_TL2X_LINKX_CFG(0, 0))
+				regval &= ~BIT_ULL(13);
+		}
+
 		/* Mark config as done for TL1 by PF */
 		if (schq_regbase >= NIX_AF_TL1X_SCHEDULE(0) &&
 		    schq_regbase <= NIX_AF_TL1X_GREEN_BYTES(0)) {
 			schq = TXSCHQ_IDX(reg, TXSCHQ_IDX_SHIFT);
-
 			mutex_lock(&rvu->rsrc_lock);
-
-			map_func = TXSCH_MAP_FUNC(pfvf_map[schq]);
-			map_flags = TXSCH_MAP_FLAGS(pfvf_map[schq]);
-
-			map_flags |= NIX_TXSCHQ_TL1_CFG_DONE;
-			pfvf_map[schq] = TXSCH_MAP(map_func, map_flags);
+			pfvf_map[schq] = TXSCH_SET_FLAG(pfvf_map[schq],
+							NIX_TXSCHQ_CFG_DONE);
 			mutex_unlock(&rvu->rsrc_lock);
 		}
 
-		rvu_write64(rvu, blkaddr, reg, regval);
-
-		/* Check for SMQ flush, if so, poll for its completion */
+		/* SMQ flush is special hence split register writes such
+		 * that flush first and write rest of the bits later.
+		 */
 		if (schq_regbase == NIX_AF_SMQX_CFG(0) &&
 		    (regval & BIT_ULL(49))) {
-			err = rvu_poll_reg(rvu, blkaddr,
-					   reg, BIT_ULL(49), true);
-			if (err)
-				return NIX_AF_SMQ_FLUSH_FAILED;
+			schq = TXSCHQ_IDX(reg, TXSCHQ_IDX_SHIFT);
+			nix_smq_flush(rvu, blkaddr, schq, pcifunc, nixlf);
+			regval &= ~BIT_ULL(49);
 		}
+		rvu_write64(rvu, blkaddr, reg, regval);
 	}
+
 	return 0;
 }
 
@@ -1849,8 +1953,8 @@ static int nix_setup_mcast(struct rvu *rvu, struct nix_hw *nix_hw, int blkaddr)
 static int nix_setup_txschq(struct rvu *rvu, struct nix_hw *nix_hw, int blkaddr)
 {
 	struct nix_txsch *txsch;
+	int err, lvl, schq;
 	u64 cfg, reg;
-	int err, lvl;
 
 	/* Get scheduler queue count of each type and alloc
 	 * bitmap for each for alloc/free/attach operations.
@@ -1888,7 +1992,8 @@ static int nix_setup_txschq(struct rvu *rvu, struct nix_hw *nix_hw, int blkaddr)
 					       sizeof(u32), GFP_KERNEL);
 		if (!txsch->pfvf_map)
 			return -ENOMEM;
-		memset(txsch->pfvf_map, U8_MAX, txsch->schq.max * sizeof(u32));
+		for (schq = 0; schq < txsch->schq.max; schq++)
+			txsch->pfvf_map[schq] = TXSCH_MAP(0, NIX_TXSCHQ_FREE);
 	}
 	return 0;
 }
@@ -2540,8 +2645,6 @@ int rvu_mbox_handler_nix_set_hw_frs(struct rvu *rvu, struct nix_frs_cfg *req,
 	cfg &= ~(0xFFFFFULL << 12);
 	cfg |=  ((lmac_fifo_len - req->maxlen) / 16) << 12;
 	rvu_write64(rvu, blkaddr, NIX_AF_TX_LINKX_NORM_CREDIT(link), cfg);
-	rvu_write64(rvu, blkaddr, NIX_AF_TX_LINKX_EXPR_CREDIT(link), cfg);
-
 	return 0;
 }
 
@@ -2682,9 +2785,6 @@ static void nix_link_config(struct rvu *rvu, int blkaddr)
 			rvu_write64(rvu, blkaddr,
 				    NIX_AF_TX_LINKX_NORM_CREDIT(link),
 				    tx_credits);
-			rvu_write64(rvu, blkaddr,
-				    NIX_AF_TX_LINKX_EXPR_CREDIT(link),
-				    tx_credits);
 		}
 	}
 
@@ -2696,8 +2796,6 @@ static void nix_link_config(struct rvu *rvu, int blkaddr)
 		tx_credits =  (tx_credits << 12) | (0x1FF << 2) | BIT_ULL(1);
 		rvu_write64(rvu, blkaddr,
 			    NIX_AF_TX_LINKX_NORM_CREDIT(link), tx_credits);
-		rvu_write64(rvu, blkaddr,
-			    NIX_AF_TX_LINKX_EXPR_CREDIT(link), tx_credits);
 	}
 }
 
@@ -2795,13 +2893,25 @@ int rvu_nix_init(struct rvu *rvu)
 		return 0;
 	block = &hw->block[blkaddr];
 
-	/* As per a HW errata in 9xxx A0 silicon, NIX may corrupt
-	 * internal state when conditional clocks are turned off.
-	 * Hence enable them.
-	 */
-	if (is_rvu_9xxx_A0(rvu))
+	if (is_rvu_96xx_B0(rvu)) {
+		/* As per a HW errata in 96xx A0/B0 silicon, NIX may corrupt
+		 * internal state when conditional clocks are turned off.
+		 * Hence enable them.
+		 */
 		rvu_write64(rvu, blkaddr, NIX_AF_CFG,
-			    rvu_read64(rvu, blkaddr, NIX_AF_CFG) | 0x5EULL);
+			    rvu_read64(rvu, blkaddr, NIX_AF_CFG) | 0x40ULL);
+
+		/* Set chan/link to backpressure TL3 instead of TL2 */
+		rvu_write64(rvu, blkaddr, NIX_AF_PSE_CHANNEL_LEVEL, 0x01);
+
+		/* Disable SQ manager's sticky mode operation (set TM6 = 0)
+		 * This sticky mode is known to cause SQ stalls when multiple
+		 * SQs are mapped to same SMQ and transmitting pkts at a time.
+		 */
+		cfg = rvu_read64(rvu, blkaddr, NIX_AF_SQM_DBG_CTL_STATUS);
+		cfg &= ~BIT_ULL(15);
+		rvu_write64(rvu, blkaddr, NIX_AF_SQM_DBG_CTL_STATUS, cfg);
+	}
 
 	/* Calibrate X2P bus to check if CGX/LBK links are fine */
 	err = nix_calibrate_x2p(rvu, blkaddr);
@@ -2916,7 +3026,7 @@ void rvu_nix_freemem(struct rvu *rvu)
 	}
 }
 
-static int nix_get_nixlf(struct rvu *rvu, u16 pcifunc, int *nixlf)
+int nix_get_nixlf(struct rvu *rvu, u16 pcifunc, int *nixlf)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
 	struct rvu_hwinfo *hw = rvu->hw;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index a3b4315..f0363d0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -834,11 +834,11 @@ static void npc_load_mkex_profile(struct rvu *rvu, int blkaddr)
 		/* Compare with mkex mod_param name string */
 		if (mcam_kex->mkex_sign == MKEX_SIGN &&
 		    !strncmp(mcam_kex->name, mkex_profile, MKEX_NAME_LEN)) {
-			/* Due to an errata (35786) in A0 pass silicon,
+			/* Due to an errata (35786) in A0/B0 pass silicon,
 			 * parse nibble enable configuration has to be
 			 * identical for both Rx and Tx interfaces.
 			 */
-			if (is_rvu_9xxx_A0(rvu) &&
+			if (is_rvu_96xx_B0(rvu) &&
 			    mcam_kex->keyx_cfg[NIX_INTF_RX] !=
 			    mcam_kex->keyx_cfg[NIX_INTF_TX])
 				goto load_default;
@@ -1201,7 +1201,7 @@ int rvu_npc_init(struct rvu *rvu)
 	/* Due to an errata (35786) in A0 pass silicon, parse nibble enable
 	 * configuration has to be identical for both Rx and Tx interfaces.
 	 */
-	if (!is_rvu_9xxx_A0(rvu))
+	if (!is_rvu_96xx_B0(rvu))
 		nibble_ena = (1ULL << 19) - 1;
 	rvu_write64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_TX),
 			((keyz & 0x3) << 32) | nibble_ena);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 3d7b293c..be758c1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -246,6 +246,7 @@
 
 #define NIX_AF_DEBUG_NPC_RESP_DATAX(a)          (0x680 | (a) << 3)
 #define NIX_AF_SMQX_CFG(a)                      (0x700 | (a) << 16)
+#define NIX_AF_SQM_DBG_CTL_STATUS               (0x750)
 #define NIX_AF_PSE_CHANNEL_LEVEL                (0x800)
 #define NIX_AF_PSE_SHAPER_CFG                   (0x810)
 #define NIX_AF_TX_EXPR_CREDIT			(0x830)
-- 
2.7.4

