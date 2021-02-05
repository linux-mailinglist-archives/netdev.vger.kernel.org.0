Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5D33118F0
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbhBFCvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:51:15 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:3914 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231553AbhBFCk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:40:56 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 115MfPDs030581;
        Fri, 5 Feb 2021 14:51:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=yobN1eGAXTgbvUBUkjAJNfqjKYK3ankK6FyCoXPy178=;
 b=P/7uxOf4HfExgWxs4+04fy3Fab6JMtnPQskED6YWs9uA6I/VS368QAgo1hU3ZpLTJEM9
 E71jbNnj5bb1jk979JD6BKYWZU2JNztKujW+wuB8UqdjdINrEyxXy43hb+u6Bt+FeQLr
 magXhebwYsAy4y6dE1YeZ8eUp+SXX/V948PnhJ3ZtgEWpPIdaN2qm8lu7YUSTPIm1RFO
 GKR17ADeqxNWYXhcxWkgaUwMqk8AlH+/qJQEYTr9Lta8/Mj3Faurj4kkNn0Hrpu3gwVY
 wT8RLGZ5NyHBuMwPVj8jaX+PQTAE+0wO2uG50Tbt7m/3l0MRlYr89ADpq63UpURbnB6h /Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36fnr6ag2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 05 Feb 2021 14:51:52 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 5 Feb
 2021 14:51:51 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 5 Feb
 2021 14:51:50 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 5 Feb 2021 14:51:50 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 6E5A53F703F;
        Fri,  5 Feb 2021 14:51:46 -0800 (PST)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <jerinj@marvell.com>,
        <lcherian@marvell.com>, <bbrezillon@kernel.org>,
        <arno@natisbad.org>, <schalla@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Subject: [net-next v4 09/14] octeontx2-af: cn10k: Add support for programmable channels
Date:   Sat, 6 Feb 2021 04:20:08 +0530
Message-ID: <20210205225013.15961-10-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210205225013.15961-1-gakula@marvell.com>
References: <20210205225013.15961-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-05_13:2021-02-05,2021-02-05 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

NIX uses unique channel numbers to identify the packet sources/sinks
like CGX,LBK and SDP. The channel numbers assigned to each block are
hardwired in CN9xxx silicon.
The fixed channel numbers in CN9xxx are:

0x0 | a << 8 | b            - LBK(0..3)_CH(0..63)
0x0 | a << 8                - Reserved
0x700 | a                   - SDP_CH(0..255)
0x800 | a << 8 | b << 4 | c - CGX(0..7)_LMAC(0..3)_CH(0..15)

All the channels in the above fixed enumerator(with maximum
number of blocks) are not required since some chips
have less number of blocks.
For CN10K silicon the channel numbers need to be programmed by
software in each block with the base channel number and range of
channels. This patch calculates and assigns the channel numbers
to efficiently distribute the channel number range(0-4095) among
all the blocks. The assignment is made based on the actual number of
blocks present and also contiguously leaving no holes.
The channel numbers remaining after the math are used as new CPT
replay channels present in CN10K. Also since channel numbers are
not fixed the transmit channel link number needed by AF consumers
is calculated by AF and sent along with nix_lf_alloc mailbox response.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 MAINTAINERS                                        |   1 +
 drivers/net/ethernet/marvell/octeontx2/af/Makefile |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  14 ++
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |   2 +
 drivers/net/ethernet/marvell/octeontx2/af/common.h |   3 +
 drivers/net/ethernet/marvell/octeontx2/af/rpm.h    |   6 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   8 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  44 ++++
 .../net/ethernet/marvell/octeontx2/af/rvu_cn10k.c  | 261 +++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  16 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |   4 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |  16 ++
 12 files changed, 360 insertions(+), 17 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 0c39376..1a4f56d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10711,6 +10711,7 @@ M:	Linu Cherian <lcherian@marvell.com>
 M:	Geetha sowjanya <gakula@marvell.com>
 M:	Jerin Jacob <jerinj@marvell.com>
 M:	hariprasad <hkelam@marvell.com>
+M:	Subbaraya Sundeep <sbhatta@marvell.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/Makefile b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
index a6afbde..621cc5b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
@@ -10,4 +10,4 @@ obj-$(CONFIG_OCTEONTX2_AF) += octeontx2_af.o
 octeontx2_mbox-y := mbox.o rvu_trace.o
 octeontx2_af-y := cgx.o rvu.o rvu_cgx.o rvu_npa.o rvu_nix.o \
 		  rvu_reg.o rvu_npc.o rvu_debugfs.o ptp.o rvu_npc_fs.o \
-		  rvu_cpt.o rvu_devlink.o rpm.o
+		  rvu_cpt.o rvu_devlink.o rpm.o rvu_cn10k.o
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 29b3705c..e3f063e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -122,6 +122,20 @@ void *cgx_get_pdata(int cgx_id)
 	return NULL;
 }
 
+void cgx_lmac_write(int cgx_id, int lmac_id, u64 offset, u64 val)
+{
+	struct cgx *cgx_dev = cgx_get_pdata(cgx_id);
+
+	cgx_write(cgx_dev, lmac_id, offset, val);
+}
+
+u64 cgx_lmac_read(int cgx_id, int lmac_id, u64 offset)
+{
+	struct cgx *cgx_dev = cgx_get_pdata(cgx_id);
+
+	return cgx_read(cgx_dev, lmac_id, offset);
+}
+
 int cgx_get_cgxid(void *cgxd)
 {
 	struct cgx *cgx = cgxd;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index 7c76fd0..7589721 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -152,4 +152,6 @@ struct mac_ops *get_mac_ops(void *cgxd);
 int cgx_get_nr_lmacs(void *cgxd);
 u8 cgx_get_lmacid(void *cgxd, u8 lmac_index);
 unsigned long cgx_get_lmac_bmap(void *cgxd);
+void cgx_lmac_write(int cgx_id, int lmac_id, u64 offset, u64 val);
+u64 cgx_lmac_read(int cgx_id, int lmac_id, u64 offset);
 #endif /* CGX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
index 17f6f42..0100e70 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
@@ -191,6 +191,9 @@ enum nix_scheduler {
 #define NIX_LINK_LBK(a)			(12 + (a))
 #define NIX_CHAN_CGX_LMAC_CHX(a, b, c)	(0x800 + 0x100 * (a) + 0x10 * (b) + (c))
 #define NIX_CHAN_LBK_CHX(a, b)		(0 + 0x100 * (a) + (b))
+#define NIX_CHAN_SDP_CH_START		(0x700ull)
+
+#define SDP_CHANNELS			256
 
 /* NIX LSO format indices.
  * As of now TSO is the only one using, so statically assigning indices.
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
index 7f45c1c..1779e8b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
@@ -8,6 +8,8 @@
 #ifndef RPM_H
 #define RPM_H
 
+#include <linux/bits.h>
+
 /* PCI device IDs */
 #define PCI_DEVID_CN10K_RPM		0xA060
 
@@ -15,6 +17,10 @@
 #define RPMX_CMRX_SW_INT                0x180
 #define RPMX_CMRX_SW_INT_W1S            0x188
 #define RPMX_CMRX_SW_INT_ENA_W1S        0x198
+#define RPMX_CMRX_LINK_CFG		0x1070
+
+#define RPMX_CMRX_LINK_RANGE_MASK	GENMASK_ULL(19, 16)
+#define RPMX_CMRX_LINK_BASE_MASK	GENMASK_ULL(11, 0)
 
 #define RPM_LMAC_FWI			0xa
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 8c63299..9686395 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1006,6 +1006,10 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 		rvu_scan_block(rvu, block);
 	}
 
+	err = rvu_set_channels_base(rvu);
+	if (err)
+		goto msix_err;
+
 	err = rvu_npc_init(rvu);
 	if (err)
 		goto npc_err;
@@ -1025,6 +1029,8 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 	if (err)
 		goto nix_err;
 
+	rvu_program_channels(rvu);
+
 	return 0;
 
 nix_err:
@@ -2721,8 +2727,6 @@ static void rvu_enable_afvf_intr(struct rvu *rvu)
 	rvupf_write64(rvu, RVU_PF_VFME_INT_ENA_W1SX(1), INTR_MASK(vfs - 64));
 }
 
-#define PCI_DEVID_OCTEONTX2_LBK 0xA061
-
 int rvu_get_num_lbk_chans(void)
 {
 	struct pci_dev *pdev;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index e9f6c0a..bedccff 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -19,9 +19,11 @@
 #include "common.h"
 #include "mbox.h"
 #include "npc.h"
+#include "rvu_reg.h"
 
 /* PCI device IDs */
 #define	PCI_DEVID_OCTEONTX2_RVU_AF		0xA065
+#define	PCI_DEVID_OCTEONTX2_LBK			0xA061
 
 /* Subsystem Device ID */
 #define PCI_SUBSYS_DEVID_96XX                  0xB200
@@ -305,6 +307,7 @@ struct hw_cap {
 	bool	nix_tx_link_bp;		 /* Can link backpressure TL queues ? */
 	bool	nix_rx_multicast;	 /* Rx packet replication support */
 	bool	per_pf_mbox_regs; /* PF mbox specified in per PF registers ? */
+	bool	programmable_chans; /* Channels programmable ? */
 };
 
 struct rvu_hwinfo {
@@ -313,9 +316,14 @@ struct rvu_hwinfo {
 	u16	max_vfs_per_pf; /* Max VFs that can be attached to a PF */
 	u8	cgx;
 	u8	lmac_per_cgx;
+	u16	cgx_chan_base;	/* CGX base channel number */
+	u16	lbk_chan_base;	/* LBK base channel number */
+	u16	sdp_chan_base;	/* SDP base channel number */
+	u16	cpt_chan_base;	/* CPT base channel number */
 	u8	cgx_links;
 	u8	lbk_links;
 	u8	sdp_links;
+	u8	cpt_links;	/* Number of CPT links */
 	u8	npc_kpus;          /* No of parser units */
 	u8	npc_pkinds;        /* No of port kinds */
 	u8	npc_intfs;         /* No of interfaces */
@@ -495,6 +503,38 @@ static inline bool is_rvu_otx2(struct rvu *rvu)
 		midr == PCI_REVISION_ID_95XXMM);
 }
 
+static inline u16 rvu_nix_chan_cgx(struct rvu *rvu, u8 cgxid,
+				   u8 lmacid, u8 chan)
+{
+	u64 nix_const = rvu_read64(rvu, BLKADDR_NIX0, NIX_AF_CONST);
+	u16 cgx_chans = nix_const & 0xFFULL;
+	struct rvu_hwinfo *hw = rvu->hw;
+
+	if (!hw->cap.programmable_chans)
+		return NIX_CHAN_CGX_LMAC_CHX(cgxid, lmacid, chan);
+
+	return rvu->hw->cgx_chan_base +
+		(cgxid * hw->lmac_per_cgx + lmacid) * cgx_chans + chan;
+}
+
+static inline u16 rvu_nix_chan_lbk(struct rvu *rvu, u8 lbkid,
+				   u8 chan)
+{
+	u64 nix_const = rvu_read64(rvu, BLKADDR_NIX0, NIX_AF_CONST);
+	u16 lbk_chans = (nix_const >> 16) & 0xFFULL;
+	struct rvu_hwinfo *hw = rvu->hw;
+
+	if (!hw->cap.programmable_chans)
+		return NIX_CHAN_LBK_CHX(lbkid, chan);
+
+	return rvu->hw->lbk_chan_base + lbkid * lbk_chans + chan;
+}
+
+static inline u16 rvu_nix_chan_cpt(struct rvu *rvu, u8 chan)
+{
+	return rvu->hw->cpt_chan_base + chan;
+}
+
 /* Function Prototypes
  * RVU
  */
@@ -636,6 +676,10 @@ bool is_mac_feature_supported(struct rvu *rvu, int pf, int feature);
 /* CPT APIs */
 int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int lf, int slot);
 
+/* CN10K RVU */
+int rvu_set_channels_base(struct rvu *rvu);
+void rvu_program_channels(struct rvu *rvu);
+
 #ifdef CONFIG_DEBUG_FS
 void rvu_dbg_init(struct rvu *rvu);
 void rvu_dbg_exit(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
new file mode 100644
index 0000000..7d9e71c
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
@@ -0,0 +1,261 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  Marvell RPM CN10K driver
+ *
+ * Copyright (C) 2020 Marvell.
+ */
+
+#include <linux/bitfield.h>
+#include <linux/pci.h>
+#include "rvu.h"
+#include "cgx.h"
+#include "rvu_reg.h"
+
+int rvu_set_channels_base(struct rvu *rvu)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	u16 cpt_chan_base;
+	u64 nix_const;
+	int blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	nix_const = rvu_read64(rvu, blkaddr, NIX_AF_CONST);
+
+	hw->cgx = (nix_const >> 12) & 0xFULL;
+	hw->lmac_per_cgx = (nix_const >> 8) & 0xFULL;
+	hw->cgx_links = hw->cgx * hw->lmac_per_cgx;
+	hw->lbk_links = (nix_const >> 24) & 0xFULL;
+	hw->cpt_links = (nix_const >> 44) & 0xFULL;
+	hw->sdp_links = 1;
+
+	hw->cgx_chan_base = NIX_CHAN_CGX_LMAC_CHX(0, 0, 0);
+	hw->lbk_chan_base = NIX_CHAN_LBK_CHX(0, 0);
+	hw->sdp_chan_base = NIX_CHAN_SDP_CH_START;
+
+	/* No Programmable channels */
+	if (!(nix_const & BIT_ULL(60)))
+		return 0;
+
+	hw->cap.programmable_chans = true;
+
+	/* If programmable channels are present then configure
+	 * channels such that all channel numbers are contiguous
+	 * leaving no holes. This way the new CPT channels can be
+	 * accomodated. The order of channel numbers assigned is
+	 * LBK, SDP, CGX and CPT.
+	 */
+	hw->sdp_chan_base = hw->lbk_chan_base + hw->lbk_links *
+				((nix_const >> 16) & 0xFFULL);
+	hw->cgx_chan_base = hw->sdp_chan_base + hw->sdp_links * SDP_CHANNELS;
+
+	cpt_chan_base = hw->cgx_chan_base + hw->cgx_links *
+				(nix_const & 0xFFULL);
+
+	/* Out of 4096 channels start CPT from 2048 so
+	 * that MSB for CPT channels is always set
+	 */
+	if (cpt_chan_base <= 0x800) {
+		hw->cpt_chan_base = 0x800;
+	} else {
+		dev_err(rvu->dev,
+			"CPT channels could not fit in the range 2048-4095\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+#define LBK_CONNECT_NIXX(a)		(0x0 + (a))
+
+static void __rvu_lbk_set_chans(struct rvu *rvu, void __iomem *base,
+				u64 offset, int lbkid, u16 chans)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	u64 cfg;
+
+	cfg = readq(base + offset);
+	cfg &= ~(LBK_LINK_CFG_RANGE_MASK |
+		 LBK_LINK_CFG_ID_MASK | LBK_LINK_CFG_BASE_MASK);
+	cfg |=	FIELD_PREP(LBK_LINK_CFG_RANGE_MASK, ilog2(chans));
+	cfg |=	FIELD_PREP(LBK_LINK_CFG_ID_MASK, lbkid);
+	cfg |=	FIELD_PREP(LBK_LINK_CFG_BASE_MASK, hw->lbk_chan_base);
+
+	writeq(cfg, base + offset);
+}
+
+static void rvu_lbk_set_channels(struct rvu *rvu)
+{
+	struct pci_dev *pdev = NULL;
+	void __iomem *base;
+	u64 lbk_const;
+	u8 src, dst;
+	u16 chans;
+
+	/* To loopback packets between multiple NIX blocks
+	 * mutliple LBK blocks are needed. With two NIX blocks,
+	 * four LBK blocks are needed and each LBK block
+	 * source and destination are as follows:
+	 * LBK0 - source NIX0 and destination NIX1
+	 * LBK1 - source NIX0 and destination NIX1
+	 * LBK2 - source NIX1 and destination NIX0
+	 * LBK3 - source NIX1 and destination NIX1
+	 * As per the HRM channel numbers should be programmed as:
+	 * P2X and X2P of LBK0 as same
+	 * P2X and X2P of LBK3 as same
+	 * P2X of LBK1 and X2P of LBK2 as same
+	 * P2X of LBK2 and X2P of LBK1 as same
+	 */
+	while (true) {
+		pdev = pci_get_device(PCI_VENDOR_ID_CAVIUM,
+				      PCI_DEVID_OCTEONTX2_LBK, pdev);
+		if (!pdev)
+			return;
+
+		base = pci_ioremap_bar(pdev, 0);
+		if (!base)
+			goto err_put;
+
+		lbk_const = readq(base + LBK_CONST);
+		chans = FIELD_GET(LBK_CONST_CHANS, lbk_const);
+		dst = FIELD_GET(LBK_CONST_DST, lbk_const);
+		src = FIELD_GET(LBK_CONST_SRC, lbk_const);
+
+		if (src == dst) {
+			if (src == LBK_CONNECT_NIXX(0)) { /* LBK0 */
+				__rvu_lbk_set_chans(rvu, base, LBK_LINK_CFG_X2P,
+						    0, chans);
+				__rvu_lbk_set_chans(rvu, base, LBK_LINK_CFG_P2X,
+						    0, chans);
+			} else if (src == LBK_CONNECT_NIXX(1)) { /* LBK3 */
+				__rvu_lbk_set_chans(rvu, base, LBK_LINK_CFG_X2P,
+						    1, chans);
+				__rvu_lbk_set_chans(rvu, base, LBK_LINK_CFG_P2X,
+						    1, chans);
+			}
+		} else {
+			if (src == LBK_CONNECT_NIXX(0)) { /* LBK1 */
+				__rvu_lbk_set_chans(rvu, base, LBK_LINK_CFG_X2P,
+						    0, chans);
+				__rvu_lbk_set_chans(rvu, base, LBK_LINK_CFG_P2X,
+						    1, chans);
+			} else if (src == LBK_CONNECT_NIXX(1)) { /* LBK2 */
+				__rvu_lbk_set_chans(rvu, base, LBK_LINK_CFG_X2P,
+						    1, chans);
+				__rvu_lbk_set_chans(rvu, base, LBK_LINK_CFG_P2X,
+						    0, chans);
+			}
+		}
+		iounmap(base);
+	}
+err_put:
+	pci_dev_put(pdev);
+}
+
+static void __rvu_nix_set_channels(struct rvu *rvu, int blkaddr)
+{
+	u64 nix_const = rvu_read64(rvu, blkaddr, NIX_AF_CONST);
+	u16 cgx_chans, lbk_chans, sdp_chans, cpt_chans;
+	struct rvu_hwinfo *hw = rvu->hw;
+	int link, nix_link = 0;
+	u16 start;
+	u64 cfg;
+
+	cgx_chans = nix_const & 0xFFULL;
+	lbk_chans = (nix_const >> 16) & 0xFFULL;
+	sdp_chans = SDP_CHANNELS;
+	cpt_chans = (nix_const >> 32) & 0xFFFULL;
+
+	start = hw->cgx_chan_base;
+	for (link = 0; link < hw->cgx_links; link++, nix_link++) {
+		cfg = rvu_read64(rvu, blkaddr, NIX_AF_LINKX_CFG(nix_link));
+		cfg &= ~(NIX_AF_LINKX_BASE_MASK | NIX_AF_LINKX_RANGE_MASK);
+		cfg |=	FIELD_PREP(NIX_AF_LINKX_RANGE_MASK, ilog2(cgx_chans));
+		cfg |=	FIELD_PREP(NIX_AF_LINKX_BASE_MASK, start);
+		rvu_write64(rvu, blkaddr, NIX_AF_LINKX_CFG(nix_link), cfg);
+		start += cgx_chans;
+	}
+
+	start = hw->lbk_chan_base;
+	for (link = 0; link < hw->lbk_links; link++, nix_link++) {
+		cfg = rvu_read64(rvu, blkaddr, NIX_AF_LINKX_CFG(nix_link));
+		cfg &= ~(NIX_AF_LINKX_BASE_MASK | NIX_AF_LINKX_RANGE_MASK);
+		cfg |=	FIELD_PREP(NIX_AF_LINKX_RANGE_MASK, ilog2(lbk_chans));
+		cfg |=	FIELD_PREP(NIX_AF_LINKX_BASE_MASK, start);
+		rvu_write64(rvu, blkaddr, NIX_AF_LINKX_CFG(nix_link), cfg);
+		start += lbk_chans;
+	}
+
+	start = hw->sdp_chan_base;
+	for (link = 0; link < hw->sdp_links; link++, nix_link++) {
+		cfg = rvu_read64(rvu, blkaddr, NIX_AF_LINKX_CFG(nix_link));
+		cfg &= ~(NIX_AF_LINKX_BASE_MASK | NIX_AF_LINKX_RANGE_MASK);
+		cfg |=	FIELD_PREP(NIX_AF_LINKX_RANGE_MASK, ilog2(sdp_chans));
+		cfg |=	FIELD_PREP(NIX_AF_LINKX_BASE_MASK, start);
+		rvu_write64(rvu, blkaddr, NIX_AF_LINKX_CFG(nix_link), cfg);
+		start += sdp_chans;
+	}
+
+	start = hw->cpt_chan_base;
+	for (link = 0; link < hw->cpt_links; link++, nix_link++) {
+		cfg = rvu_read64(rvu, blkaddr, NIX_AF_LINKX_CFG(nix_link));
+		cfg &= ~(NIX_AF_LINKX_BASE_MASK | NIX_AF_LINKX_RANGE_MASK);
+		cfg |=	FIELD_PREP(NIX_AF_LINKX_RANGE_MASK, ilog2(cpt_chans));
+		cfg |=	FIELD_PREP(NIX_AF_LINKX_BASE_MASK, start);
+		rvu_write64(rvu, blkaddr, NIX_AF_LINKX_CFG(nix_link), cfg);
+		start += cpt_chans;
+	}
+}
+
+static void rvu_nix_set_channels(struct rvu *rvu)
+{
+	int blkaddr = 0;
+
+	blkaddr = rvu_get_next_nix_blkaddr(rvu, blkaddr);
+	while (blkaddr) {
+		__rvu_nix_set_channels(rvu, blkaddr);
+		blkaddr = rvu_get_next_nix_blkaddr(rvu, blkaddr);
+	}
+}
+
+static void __rvu_rpm_set_channels(int cgxid, int lmacid, u16 base)
+{
+	u64 cfg;
+
+	cfg = cgx_lmac_read(cgxid, lmacid, RPMX_CMRX_LINK_CFG);
+	cfg &= ~(RPMX_CMRX_LINK_BASE_MASK | RPMX_CMRX_LINK_RANGE_MASK);
+
+	/* There is no read-only constant register to read
+	 * the number of channels for LMAC and it is always 16.
+	 */
+	cfg |=	FIELD_PREP(RPMX_CMRX_LINK_RANGE_MASK, ilog2(16));
+	cfg |=	FIELD_PREP(RPMX_CMRX_LINK_BASE_MASK, base);
+	cgx_lmac_write(cgxid, lmacid, RPMX_CMRX_LINK_CFG, cfg);
+}
+
+static void rvu_rpm_set_channels(struct rvu *rvu)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	u16 base = hw->cgx_chan_base;
+	int cgx, lmac;
+
+	for (cgx = 0; cgx < rvu->cgx_cnt_max; cgx++) {
+		for (lmac = 0; lmac < hw->lmac_per_cgx; lmac++) {
+			__rvu_rpm_set_channels(cgx, lmac, base);
+			base += 16;
+		}
+	}
+}
+
+void rvu_program_channels(struct rvu *rvu)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+
+	if (!hw->cap.programmable_chans)
+		return;
+
+	rvu_nix_set_channels(rvu);
+	rvu_lbk_set_channels(rvu);
+	rvu_rpm_set_channels(rvu);
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 0c9b1c3..cf9e88c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -233,7 +233,7 @@ static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf)
 				"PF_Func 0x%x: Invalid pkind\n", pcifunc);
 			return -EINVAL;
 		}
-		pfvf->rx_chan_base = NIX_CHAN_CGX_LMAC_CHX(cgx_id, lmac_id, 0);
+		pfvf->rx_chan_base = rvu_nix_chan_cgx(rvu, cgx_id, lmac_id, 0);
 		pfvf->tx_chan_base = pfvf->rx_chan_base;
 		pfvf->rx_chan_cnt = 1;
 		pfvf->tx_chan_cnt = 1;
@@ -262,10 +262,10 @@ static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf)
 		 * loopback channels.Therefore if odd number of AF VFs are
 		 * enabled then the last VF remains with no pair.
 		 */
-		pfvf->rx_chan_base = NIX_CHAN_LBK_CHX(lbkid, vf);
+		pfvf->rx_chan_base = rvu_nix_chan_lbk(rvu, lbkid, vf);
 		pfvf->tx_chan_base = vf & 0x1 ?
-					NIX_CHAN_LBK_CHX(lbkid, vf - 1) :
-					NIX_CHAN_LBK_CHX(lbkid, vf + 1);
+					rvu_nix_chan_lbk(rvu, lbkid, vf - 1) :
+					rvu_nix_chan_lbk(rvu, lbkid, vf + 1);
 		pfvf->rx_chan_cnt = 1;
 		pfvf->tx_chan_cnt = 1;
 		rvu_npc_install_promisc_entry(rvu, pcifunc, nixlf,
@@ -3389,14 +3389,6 @@ static int rvu_nix_block_init(struct rvu *rvu, struct nix_hw *nix_hw)
 	if (err)
 		return err;
 
-	/* Set num of links of each type */
-	cfg = rvu_read64(rvu, blkaddr, NIX_AF_CONST);
-	hw->cgx = (cfg >> 12) & 0xF;
-	hw->lmac_per_cgx = (cfg >> 8) & 0xF;
-	hw->cgx_links = hw->cgx * hw->lmac_per_cgx;
-	hw->lbk_links = (cfg >> 24) & 0xF;
-	hw->sdp_links = 1;
-
 	/* Initialize admin queue */
 	err = nix_aq_init(rvu, block);
 	if (err)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 5cf9b7a..04bb080 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -102,9 +102,9 @@ int npc_mcam_verify_channel(struct rvu *rvu, u16 pcifunc, u8 intf, u16 channel)
 			return -EINVAL;
 	} else {
 		rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
-		base = NIX_CHAN_CGX_LMAC_CHX(cgx_id, lmac_id, 0x0);
+		base = rvu_nix_chan_cgx(rvu, cgx_id, lmac_id, 0x0);
 		/* CGX mapped functions has maximum of 16 channels */
-		end = NIX_CHAN_CGX_LMAC_CHX(cgx_id, lmac_id, 0xF);
+		end = rvu_nix_chan_cgx(rvu, cgx_id, lmac_id, 0xF);
 	}
 
 	if (channel < base || channel > end)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 78395c7..2460d71 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -406,12 +406,16 @@
 #define NIX_AF_RX_NPC_MIRROR_RCV	(0x4720)
 #define NIX_AF_RX_NPC_MIRROR_DROP	(0x4730)
 #define NIX_AF_RX_ACTIVE_CYCLES_PCX(a)	(0x4800 | (a) << 16)
+#define NIX_AF_LINKX_CFG(a)		(0x4010 | (a) << 17)
 
 #define NIX_PRIV_AF_INT_CFG		(0x8000000)
 #define NIX_PRIV_LFX_CFG		(0x8000010)
 #define NIX_PRIV_LFX_INT_CFG		(0x8000020)
 #define NIX_AF_RVU_LF_CFG_DEBUG		(0x8000030)
 
+#define NIX_AF_LINKX_BASE_MASK		GENMASK_ULL(11, 0)
+#define NIX_AF_LINKX_RANGE_MASK		GENMASK_ULL(19, 16)
+
 /* SSO */
 #define SSO_AF_CONST			(0x1000)
 #define SSO_AF_CONST1			(0x1008)
@@ -644,4 +648,16 @@
 		(0x00F00 | (a) << 5 | (b) << 4)
 #define NDC_AF_BANKX_HIT_PC(a)		(0x01000 | (a) << 3)
 #define NDC_AF_BANKX_MISS_PC(a)		(0x01100 | (a) << 3)
+
+/* LBK */
+#define LBK_CONST			(0x10ull)
+#define LBK_LINK_CFG_P2X		(0x400ull)
+#define LBK_LINK_CFG_X2P		(0x408ull)
+#define LBK_CONST_CHANS			GENMASK_ULL(47, 32)
+#define LBK_CONST_DST			GENMASK_ULL(31, 28)
+#define LBK_CONST_SRC			GENMASK_ULL(27, 24)
+#define LBK_LINK_CFG_RANGE_MASK		GENMASK_ULL(19, 16)
+#define LBK_LINK_CFG_ID_MASK		GENMASK_ULL(11, 6)
+#define LBK_LINK_CFG_BASE_MASK		GENMASK_ULL(5, 0)
+
 #endif /* RVU_REG_H */
-- 
2.7.4

