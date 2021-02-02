Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAE030B793
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 07:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhBBGC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:02:59 -0500
Received: from [1.6.215.26] ([1.6.215.26]:41058 "EHLO hyd1soter2"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S231941AbhBBGCv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 01:02:51 -0500
Received: from hyd1soter2.caveonetworks.com (localhost [127.0.0.1])
        by hyd1soter2 (8.15.2/8.15.2/Debian-3) with ESMTP id 11261LwV027434;
        Tue, 2 Feb 2021 11:31:21 +0530
Received: (from geetha@localhost)
        by hyd1soter2.caveonetworks.com (8.15.2/8.15.2/Submit) id 11261KCM027433;
        Tue, 2 Feb 2021 11:31:20 +0530
From:   Geetha sowjanya <gakula@marvell.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     sgoutham@marvell.com, davem@davemloft.net, kuba@kernel.org,
        sbhatta@marvell.com, hkelam@marvell.com, jerinj@marvell.com,
        lcherian@marvell.com, Geetha sowjanya <gakula@marvell.com>
Subject: [net-next v2 10/14] octeontx2-af: cn10K: Add MTU configuration
Date:   Tue,  2 Feb 2021 11:31:18 +0530
Message-Id: <1612245678-27393-1-git-send-email-gakula@marvell.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hkelam@marvell.com>

OcteonTx3 CN10K silicon supports bigger MTU when compared
to 9216 MTU supported by OcteonTx2 silicon variants. Lookback
interface supports upto 64K and RPM LMAC interfaces support
upto 16K.

This patch does the necessary configuration and adds support
for PF/VF drivers to retrieve max packet size supported via mbox

This patch also configures tx link credit by considering supported
fifo size and max packet length for Octeontx3 silicon.

This patch also removes platform specific name from the driver name.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/Makefile |  8 +--
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 10 +++
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  1 +
 drivers/net/ethernet/marvell/octeontx2/af/common.h |  2 +
 .../ethernet/marvell/octeontx2/af/lmac_common.h    |  1 +
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  9 ++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    | 29 ++++++++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 13 ++++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 74 ++++++++++++++++++++--
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |  1 +
 11 files changed, 138 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/Makefile b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
index 621cc5b..1a34556 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
@@ -4,10 +4,10 @@
 #
 
 ccflags-y += -I$(src)
-obj-$(CONFIG_OCTEONTX2_MBOX) += octeontx2_mbox.o
-obj-$(CONFIG_OCTEONTX2_AF) += octeontx2_af.o
+obj-$(CONFIG_OCTEONTX2_MBOX) += rvu_mbox.o
+obj-$(CONFIG_OCTEONTX2_AF) += rvu_af.o
 
-octeontx2_mbox-y := mbox.o rvu_trace.o
-octeontx2_af-y := cgx.o rvu.o rvu_cgx.o rvu_npa.o rvu_nix.o \
+rvu_mbox-y := mbox.o rvu_trace.o
+rvu_af-y := cgx.o rvu.o rvu_cgx.o rvu_npa.o rvu_nix.o \
 		  rvu_reg.o rvu_npc.o rvu_debugfs.o ptp.o rvu_npc_fs.o \
 		  rvu_cpt.o rvu_devlink.o rpm.o rvu_cn10k.o
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index e3f063e..86f519f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -895,6 +895,14 @@ int cgx_lmac_linkup_start(void *cgxd)
 	return 0;
 }
 
+void cgx_lmac_get_fifolen(struct cgx *cgx)
+{
+	u64 cfg;
+
+	cfg = cgx_read(cgx, 0, CGX_CONST);
+	cgx->mac_ops->fifo_len = FIELD_GET(CGX_CONST_RXFIFO_SIZE, cfg);
+}
+
 static int cgx_configure_interrupt(struct cgx *cgx, struct lmac *lmac,
 				   int cnt, bool req_free)
 {
@@ -949,6 +957,8 @@ static int cgx_lmac_init(struct cgx *cgx)
 	u64 lmac_list;
 	int i, err;
 
+	cgx_lmac_get_fifolen(cgx);
+
 	cgx->lmac_count = cgx->mac_ops->get_nr_lmacs(cgx);
 	/* lmac_list specifies which lmacs are enabled
 	 * when bit n is set to 1, LMAC[n] is enabled
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index 7589721..f2c77e0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -56,6 +56,7 @@
 #define CGXX_SCRATCH0_REG		0x1050
 #define CGXX_SCRATCH1_REG		0x1058
 #define CGX_CONST			0x2000
+#define CGX_CONST_RXFIFO_SIZE	        GENMASK_ULL(23, 0)
 #define CGXX_SPUX_CONTROL1		0x10000
 #define CGXX_SPUX_CONTROL1_LBK		BIT_ULL(14)
 #define CGXX_GMP_PCS_MRX_CTL		0x30000
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
index 0100e70..e661093 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
@@ -155,6 +155,8 @@ enum nix_scheduler {
 #define	NIC_HW_MIN_FRS			40
 #define	NIC_HW_MAX_FRS			9212
 #define	SDP_HW_MAX_FRS			65535
+#define CN10K_LMAC_LINK_MAX_FRS		16380 /* 16k - FCS */
+#define CN10K_LBK_LINK_MAX_FRS		65535 /* 64k */
 
 /* NIX RX action operation*/
 #define NIX_RX_ACTIONOP_DROP		(0x0ull)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
index ac36e15..9c5a9c5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
@@ -61,6 +61,7 @@ struct mac_ops {
 	u8			irq_offset;
 	u8			int_ena_bit;
 	u8			lmac_fwi;
+	u32			fifo_len;
 	bool			non_contiguous_serdes_lane;
 	/* Incase of RPM get number of lmacs from RPMX_CMR_RX_LMACS[LMAC_EXIST]
 	 * number of setbits in lmac_exist tells number of lmacs
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 38692c8..e6a515a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -244,7 +244,8 @@ M(NIX_BP_ENABLE,	0x8016, nix_bp_enable, nix_bp_cfg_req,	\
 M(NIX_BP_DISABLE,	0x8017, nix_bp_disable, nix_bp_cfg_req, msg_rsp) \
 M(NIX_GET_MAC_ADDR, 0x8018, nix_get_mac_addr, msg_req, nix_get_mac_addr_rsp) \
 M(NIX_CN10K_AQ_ENQ,	0x8019, nix_cn10k_aq_enq, nix_cn10k_aq_enq_req, \
-				nix_cn10k_aq_enq_rsp)
+				nix_cn10k_aq_enq_rsp)			\
+M(NIX_GET_HW_INFO,	0x801a, nix_get_hw_info, msg_req, nix_hw_info)
 
 /* Messages initiated by AF (range 0xC00 - 0xDFF) */
 #define MBOX_UP_CGX_MESSAGES						\
@@ -861,6 +862,12 @@ struct nix_bp_cfg_rsp {
 	u8	chan_cnt; /* Number of channel for which bpids are assigned */
 };
 
+struct nix_hw_info {
+	struct mbox_msghdr hdr;
+	u16 max_mtu;
+	u16 min_mtu;
+};
+
 /* NPC mbox message structs */
 
 #define NPC_MCAM_ENTRY_INVALID	0xFFFF
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 778a285..7903f48 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -22,7 +22,7 @@
 
 #include "rvu_trace.h"
 
-#define DRV_NAME	"octeontx2-af"
+#define DRV_NAME	"rvu_af"
 #define DRV_STRING      "Marvell OcteonTX2 RVU Admin Function Driver"
 
 static int rvu_get_hwvf(struct rvu *rvu, int pcifunc);
@@ -855,6 +855,31 @@ static int rvu_setup_cpt_hw_resource(struct rvu *rvu, int blkaddr)
 	return rvu_alloc_bitmap(&block->lf);
 }
 
+static void rvu_get_lbk_bufsize(struct rvu *rvu)
+{
+	struct pci_dev *pdev = NULL;
+	void __iomem *base;
+	u64 lbk_const;
+
+	pdev = pci_get_device(PCI_VENDOR_ID_CAVIUM,
+			      PCI_DEVID_OCTEONTX2_LBK, pdev);
+	if (!pdev)
+		return;
+
+	base = pci_ioremap_bar(pdev, 0);
+	if (!base)
+		goto err_put;
+
+	lbk_const = readq(base + LBK_CONST);
+
+	/* cache fifo size */
+	rvu->hw->lbk_bufsize = FIELD_GET(LBK_CONST_BUF_SIZE, lbk_const);
+
+	iounmap(base);
+err_put:
+	pci_dev_put(pdev);
+}
+
 static int rvu_setup_hw_resources(struct rvu *rvu)
 {
 	struct rvu_hwinfo *hw = rvu->hw;
@@ -1025,6 +1050,8 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 	if (err)
 		goto npa_err;
 
+	rvu_get_lbk_bufsize(rvu);
+
 	err = rvu_nix_init(rvu);
 	if (err)
 		goto nix_err;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 033bfdc..8b81c81b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -322,6 +322,7 @@ struct rvu_hwinfo {
 	u8	npc_intfs;         /* No of interfaces */
 	u8	npc_kpu_entries;   /* No of KPU entries */
 	u16	npc_counters;	   /* No of match stats counters */
+	u32	lbk_bufsize;	   /* FIFO size supported by LBK */
 	bool	npc_ext_set;	   /* Extended register set */
 
 	struct hw_cap    cap;
@@ -665,6 +666,7 @@ void npc_read_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 			 int blkaddr, u16 src, struct mcam_entry *entry,
 			 u8 *intf, u8 *ena);
 bool is_mac_feature_supported(struct rvu *rvu, int pf, int feature);
+u32  rvu_cgx_get_fifolen(struct rvu *rvu);
 
 /* CN10K RVU */
 int rvu_set_channels_base(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 8ec9b04..5e514f2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -14,6 +14,7 @@
 
 #include "rvu.h"
 #include "cgx.h"
+#include "lmac_common.h"
 #include "rvu_reg.h"
 #include "rvu_trace.h"
 
@@ -669,6 +670,18 @@ int rvu_mbox_handler_cgx_features_get(struct rvu *rvu,
 	return 0;
 }
 
+u32 rvu_cgx_get_fifolen(struct rvu *rvu)
+{
+	struct mac_ops *mac_ops;
+	int rvu_def_cgx_id = 0;
+	u32 fifo_len;
+
+	mac_ops = get_mac_ops(rvu_cgx_pdata(rvu_def_cgx_id, rvu));
+	fifo_len = mac_ops ? mac_ops->fifo_len : 0;
+
+	return fifo_len;
+}
+
 static int rvu_cgx_config_intlbk(struct rvu *rvu, u16 pcifunc, bool en)
 {
 	int pf = rvu_get_pf(pcifunc);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index cf9e88c..ee27ddd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2543,6 +2543,43 @@ static int nix_af_mark_format_setup(struct rvu *rvu, struct nix_hw *nix_hw,
 	return 0;
 }
 
+static void rvu_get_lbk_link_max_frs(struct rvu *rvu,  u16 *max_mtu)
+{
+	/* CN10K supports LBK FIFO size 72 KB */
+	if (rvu->hw->lbk_bufsize == 0x12000)
+		*max_mtu = CN10K_LBK_LINK_MAX_FRS;
+	else
+		*max_mtu = NIC_HW_MAX_FRS;
+}
+
+static void rvu_get_lmac_link_max_frs(struct rvu *rvu, u16 *max_mtu)
+{
+	/* RPM supports FIFO len 128 KB */
+	if (rvu_cgx_get_fifolen(rvu) == 0x20000)
+		*max_mtu = CN10K_LMAC_LINK_MAX_FRS;
+	else
+		*max_mtu = NIC_HW_MAX_FRS;
+}
+
+int rvu_mbox_handler_nix_get_hw_info(struct rvu *rvu, struct msg_req *req,
+				     struct nix_hw_info *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	int blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
+	if (blkaddr < 0)
+		return NIX_AF_ERR_AF_LF_INVALID;
+
+	if (is_afvf(pcifunc))
+		rvu_get_lbk_link_max_frs(rvu, &rsp->max_mtu);
+	else
+		rvu_get_lmac_link_max_frs(rvu, &rsp->max_mtu);
+
+	rsp->min_mtu = NIC_HW_MIN_FRS;
+	return 0;
+}
+
 int rvu_mbox_handler_nix_stats_rst(struct rvu *rvu, struct msg_req *req,
 				   struct msg_rsp *rsp)
 {
@@ -3107,6 +3144,7 @@ int rvu_mbox_handler_nix_set_hw_frs(struct rvu *rvu, struct nix_frs_cfg *req,
 	u64 cfg, lmac_fifo_len;
 	struct nix_hw *nix_hw;
 	u8 cgx = 0, lmac = 0;
+	u16 max_mtu;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
 	if (blkaddr < 0)
@@ -3116,7 +3154,12 @@ int rvu_mbox_handler_nix_set_hw_frs(struct rvu *rvu, struct nix_frs_cfg *req,
 	if (!nix_hw)
 		return -EINVAL;
 
-	if (!req->sdp_link && req->maxlen > NIC_HW_MAX_FRS)
+	if (is_afvf(pcifunc))
+		rvu_get_lbk_link_max_frs(rvu, &max_mtu);
+	else
+		rvu_get_lmac_link_max_frs(rvu, &max_mtu);
+
+	if (!req->sdp_link && req->maxlen > max_mtu)
 		return NIX_AF_ERR_FRS_INVALID;
 
 	if (req->update_minlen && req->minlen < NIC_HW_MIN_FRS)
@@ -3176,7 +3219,8 @@ int rvu_mbox_handler_nix_set_hw_frs(struct rvu *rvu, struct nix_frs_cfg *req,
 
 	/* Update transmit credits for CGX links */
 	lmac_fifo_len =
-		CGX_FIFO_LEN / cgx_get_lmac_cnt(rvu_cgx_pdata(cgx, rvu));
+		rvu_cgx_get_fifolen(rvu) /
+		cgx_get_lmac_cnt(rvu_cgx_pdata(cgx, rvu));
 	cfg = rvu_read64(rvu, blkaddr, NIX_AF_TX_LINKX_NORM_CREDIT(link));
 	cfg &= ~(0xFFFFFULL << 12);
 	cfg |=  ((lmac_fifo_len - req->maxlen) / 16) << 12;
@@ -3216,23 +3260,40 @@ int rvu_mbox_handler_nix_set_rx_cfg(struct rvu *rvu, struct nix_rx_cfg *req,
 	return 0;
 }
 
+static u64 rvu_get_lbk_link_credits(struct rvu *rvu, u16 lbk_max_frs)
+{
+	/* CN10k supports 72KB FIFO size and max packet size of 64k */
+	if (rvu->hw->lbk_bufsize == 0x12000)
+		return (rvu->hw->lbk_bufsize - lbk_max_frs) / 16;
+
+	return 1600; /* 16 * max LBK datarate = 16 * 100Gbps */
+}
+
 static void nix_link_config(struct rvu *rvu, int blkaddr)
 {
 	struct rvu_hwinfo *hw = rvu->hw;
 	int cgx, lmac_cnt, slink, link;
+	u16 lbk_max_frs, lmac_max_frs;
 	u64 tx_credits;
 
+	rvu_get_lbk_link_max_frs(rvu, &lbk_max_frs);
+	rvu_get_lmac_link_max_frs(rvu, &lmac_max_frs);
+
 	/* Set default min/max packet lengths allowed on NIX Rx links.
 	 *
 	 * With HW reset minlen value of 60byte, HW will treat ARP pkts
 	 * as undersize and report them to SW as error pkts, hence
 	 * setting it to 40 bytes.
 	 */
-	for (link = 0; link < (hw->cgx_links + hw->lbk_links); link++) {
+	for (link = 0; link < hw->cgx_links; link++) {
 		rvu_write64(rvu, blkaddr, NIX_AF_RX_LINKX_CFG(link),
-			    NIC_HW_MAX_FRS << 16 | NIC_HW_MIN_FRS);
+				((u64)lmac_max_frs << 16) | NIC_HW_MIN_FRS);
 	}
 
+	for (link = hw->cgx_links; link < hw->lbk_links; link++) {
+		rvu_write64(rvu, blkaddr, NIX_AF_RX_LINKX_CFG(link),
+			    ((u64)lbk_max_frs << 16) | NIC_HW_MIN_FRS);
+	}
 	if (hw->sdp_links) {
 		link = hw->cgx_links + hw->lbk_links;
 		rvu_write64(rvu, blkaddr, NIX_AF_RX_LINKX_CFG(link),
@@ -3244,7 +3305,8 @@ static void nix_link_config(struct rvu *rvu, int blkaddr)
 	 */
 	for (cgx = 0; cgx < hw->cgx; cgx++) {
 		lmac_cnt = cgx_get_lmac_cnt(rvu_cgx_pdata(cgx, rvu));
-		tx_credits = ((CGX_FIFO_LEN / lmac_cnt) - NIC_HW_MAX_FRS) / 16;
+		tx_credits = ((rvu_cgx_get_fifolen(rvu) / lmac_cnt) -
+			       lmac_max_frs) / 16;
 		/* Enable credits and set credit pkt count to max allowed */
 		tx_credits =  (tx_credits << 12) | (0x1FF << 2) | BIT_ULL(1);
 		slink = cgx * hw->lmac_per_cgx;
@@ -3258,7 +3320,7 @@ static void nix_link_config(struct rvu *rvu, int blkaddr)
 	/* Set Tx credits for LBK link */
 	slink = hw->cgx_links;
 	for (link = slink; link < (slink + hw->lbk_links); link++) {
-		tx_credits = 1000; /* 10 * max LBK datarate = 10 * 100Gbps */
+		tx_credits = rvu_get_lbk_link_credits(rvu, lbk_max_frs);
 		/* Enable credits and set credit pkt count to max allowed */
 		tx_credits =  (tx_credits << 12) | (0x1FF << 2) | BIT_ULL(1);
 		rvu_write64(rvu, blkaddr,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index a9b47c2..1e72adb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -648,6 +648,7 @@
 #define LBK_CONST_CHANS			GENMASK_ULL(47, 32)
 #define LBK_CONST_DST			GENMASK_ULL(31, 28)
 #define LBK_CONST_SRC			GENMASK_ULL(27, 24)
+#define LBK_CONST_BUF_SIZE		GENMASK_ULL(23, 0)
 #define LBK_LINK_CFG_RANGE_MASK		GENMASK_ULL(19, 16)
 #define LBK_LINK_CFG_ID_MASK		GENMASK_ULL(11, 6)
 #define LBK_LINK_CFG_BASE_MASK		GENMASK_ULL(5, 0)
-- 
2.7.4

