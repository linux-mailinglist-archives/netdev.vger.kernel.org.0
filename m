Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD49309715
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 18:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232242AbhA3RIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 12:08:10 -0500
Received: from [1.6.215.26] ([1.6.215.26]:38272 "EHLO hyd1soter2"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S231899AbhA3RHf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 12:07:35 -0500
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Jan 2021 12:02:22 EST
Received: from hyd1soter2.caveonetworks.com (localhost [127.0.0.1])
        by hyd1soter2 (8.15.2/8.15.2/Debian-3) with ESMTP id 10UGsu2R092409;
        Sat, 30 Jan 2021 22:24:56 +0530
Received: (from geetha@localhost)
        by hyd1soter2.caveonetworks.com (8.15.2/8.15.2/Submit) id 10UGsukJ092408;
        Sat, 30 Jan 2021 22:24:56 +0530
From:   Geetha sowjanya <gakula@marvell.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     sgoutham@marvell.com, davem@davemloft.net, kuba@kernel.org,
        Hariprasad Kelam <hkelam@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Subject: [net-next 13/14] octeontx2-af: cn10k: Add RPM Rx/Tx stats support
Date:   Sat, 30 Jan 2021 22:24:54 +0530
Message-Id: <1612025694-92359-1-git-send-email-gakula@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hkelam@marvell.com>

RPM supports below list of counters as an extension to existing counters
 *  class based flow control pause frames
 *  vlan/jabber/fragmented packets
 *  fcs/alignment/oversized error packets

This patch adds support to display supported RPM counters via debugfs
and define new mbox rpm_stats to read all support counters.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  10 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |   4 +-
 .../ethernet/marvell/octeontx2/af/lmac_common.h    |  16 ++-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  13 ++-
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c    |  57 ++++++++++-
 drivers/net/ethernet/marvell/octeontx2/af/rpm.h    |   9 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  37 +++++--
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    | 108 +++++++++++++++++++--
 8 files changed, 227 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 9a343fd..cf2358b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -330,10 +330,8 @@ void cgx_lmac_enadis_rx_pause_fwding(void *cgxd, int lmac_id, bool enable)
 
 int cgx_get_rx_stats(void *cgxd, int lmac_id, int idx, u64 *rx_stat)
 {
-	struct mac_ops *mac_ops;
 	struct cgx *cgx = cgxd;
 
-	mac_ops = cgx->mac_ops;
 	if (!is_lmac_valid(cgx, lmac_id))
 		return -ENODEV;
 	*rx_stat =  cgx_read(cgx, lmac_id, CGXX_CMRX_RX_STAT0 + (idx * 8));
@@ -342,10 +340,8 @@ int cgx_get_rx_stats(void *cgxd, int lmac_id, int idx, u64 *rx_stat)
 
 int cgx_get_tx_stats(void *cgxd, int lmac_id, int idx, u64 *tx_stat)
 {
-	struct mac_ops *mac_ops;
 	struct cgx *cgx = cgxd;
 
-	mac_ops = cgx->mac_ops;
 	if (!is_lmac_valid(cgx, lmac_id))
 		return -ENODEV;
 	*tx_stat = cgx_read(cgx, lmac_id, CGXX_CMRX_TX_STAT0 + (idx * 8));
@@ -1047,7 +1043,11 @@ struct mac_ops	cgx_mac_ops    = {
 	.int_ena_bit    =       FW_CGX_INT,
 	.lmac_fwi	=	CGX_LMAC_FWI,
 	.non_contiguous_serdes_lane = false,
+	.rx_stats_cnt   =       9,
+	.tx_stats_cnt   =       18,
 	.get_nr_lmacs	=	cgx_get_nr_lmacs,
+	.mac_get_rx_stats  =	cgx_get_rx_stats,
+	.mac_get_tx_stats  =	cgx_get_tx_stats,
 	.mac_enadis_rx_pause_fwding =	cgx_lmac_enadis_rx_pause_fwding,
 	.mac_get_pause_frm_status =	cgx_lmac_get_pause_frm_status,
 	.mac_enadis_pause_frm =		cgx_lmac_enadis_pause_frm,
@@ -1120,6 +1120,8 @@ static int cgx_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	cgx_populate_features(cgx);
 
+	mutex_init(&cgx->lock);
+
 	err = cgx_lmac_init(cgx);
 	if (err)
 		goto err_release_lmac;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index f2c77e0..bb0087e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -41,7 +41,7 @@
 #define FW_CGX_INT			BIT_ULL(1)
 #define CGXX_CMRX_INT_ENA_W1S		0x058
 #define CGXX_CMRX_RX_ID_MAP		0x060
-#define CGXX_CMRX_RX_STAT0		(0x070 + mac_ops->csr_offset)
+#define CGXX_CMRX_RX_STAT0		0x070
 #define CGXX_CMRX_RX_LMACS		0x128
 #define CGXX_CMRX_RX_DMAC_CTL0		(0x1F8 + mac_ops->csr_offset)
 #define CGX_DMAC_CTL0_CAM_ENABLE	BIT_ULL(3)
@@ -52,7 +52,7 @@
 #define CGX_DMAC_CAM_ADDR_ENABLE	BIT_ULL(48)
 #define CGXX_CMRX_RX_DMAC_CAM1		0x400
 #define CGX_RX_DMAC_ADR_MASK		GENMASK_ULL(47, 0)
-#define CGXX_CMRX_TX_STAT0		(0x700 + mac_ops->csr_offset)
+#define CGXX_CMRX_TX_STAT0		0x700
 #define CGXX_SCRATCH0_REG		0x1050
 #define CGXX_SCRATCH1_REG		0x1058
 #define CGX_CONST			0x2000
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
index f6f9915..7116322 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
@@ -61,15 +61,25 @@ struct mac_ops {
 	u8			lmac_fwi;
 	u32			fifo_len;
 	bool			non_contiguous_serdes_lane;
+	/* RPM & CGX differs in number of Receive/transmit stats */
+	u8			rx_stats_cnt;
+	u8			tx_stats_cnt;
 	/* Incase of RPM get number of lmacs from RPMX_CMR_RX_LMACS[LMAC_EXIST]
 	 * number of setbits in lmac_exist tells number of lmacs
 	 */
 	int			(*get_nr_lmacs)(void *cgx);
 
+	/* Register Stats related functions */
+	int			(*mac_get_rx_stats)(void *cgx, int lmac_id,
+						    int idx, u64 *rx_stat);
+	int			(*mac_get_tx_stats)(void *cgx, int lmac_id,
+						    int idx, u64 *tx_stat);
+
 	/* Enable LMAC Pause Frame Configuration */
 	void			(*mac_enadis_rx_pause_fwding)(void *cgxd,
 							      int lmac_id,
 							      bool enable);
+
 	int			(*mac_get_pause_frm_status)(void *cgxd,
 							    int lmac_id,
 							    u8 *tx_pause,
@@ -79,10 +89,10 @@ struct mac_ops {
 							int lmac_id,
 							u8 tx_pause,
 							u8 rx_pause);
+
 	void			(*mac_pause_frm_config)(void  *cgxd,
 							int lmac_id,
 							bool enable);
-
 };
 
 struct cgx {
@@ -97,6 +107,10 @@ struct cgx {
 	u64			hw_features;
 	struct mac_ops		*mac_ops;
 	unsigned long		lmac_bmap; /* bitmap of enabled lmacs */
+	/* Lock to serialize read/write of global csrs like
+	 * RPMX_MTI_STAT_DATA_HI_CDC etc
+	 */
+	struct mutex		lock;
 };
 
 typedef struct cgx rpm_t;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index e6a515a..89a83f3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -155,6 +155,7 @@ M(CGX_CFG_PAUSE_FRM,	0x20E, cgx_cfg_pause_frm, cgx_pause_frm_cfg,	\
 			       cgx_pause_frm_cfg)			\
 M(CGX_FEATURES_GET,	0x20F, cgx_features_get, msg_req,		\
 			       cgx_features_info_msg)			\
+M(RPM_STATS,		0x21C, rpm_stats, msg_req, rpm_stats_rsp)	\
 /* NPA mbox IDs (range 0x400 - 0x5FF) */				\
 M(NPA_LF_ALLOC,		0x400, npa_lf_alloc,				\
 				npa_lf_alloc_req, npa_lf_alloc_rsp)	\
@@ -403,14 +404,22 @@ struct cgx_pause_frm_cfg {
 #define RVU_LMAC_FEAT_FC		BIT_ULL(0) /* pause frames */
 #define RVU_LMAC_FEAT_PTP		BIT_ULL(1) /* precison time protocol */
 #define RVU_MAC_VERSION			BIT_ULL(2)
-#define RVU_MAC_CGX			0
-#define RVU_MAC_RPM			1
+#define RVU_MAC_CGX			BIT_ULL(3)
+#define RVU_MAC_RPM			BIT_ULL(4)
 
 struct cgx_features_info_msg {
 	struct mbox_msghdr hdr;
 	u64    lmac_features;
 };
 
+struct rpm_stats_rsp {
+	struct mbox_msghdr hdr;
+#define RPM_RX_STATS_COUNT		43
+#define RPM_TX_STATS_COUNT		34
+	u64 rx_stats[RPM_RX_STATS_COUNT];
+	u64 tx_stats[RPM_TX_STATS_COUNT];
+};
+
 /* NPA mbox message formats */
 
 /* NPA mailbox error codes
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index 8a4241a..3870cd4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -18,7 +18,11 @@ static struct mac_ops	rpm_mac_ops   = {
 	.int_ena_bit    =       BIT_ULL(0),
 	.lmac_fwi	=	RPM_LMAC_FWI,
 	.non_contiguous_serdes_lane = true,
+	.rx_stats_cnt   =       43,
+	.tx_stats_cnt   =       34,
 	.get_nr_lmacs	=	rpm_get_nr_lmacs,
+	.mac_get_rx_stats  =	rpm_get_rx_stats,
+	.mac_get_tx_stats  =	rpm_get_tx_stats,
 	.mac_enadis_rx_pause_fwding =	rpm_lmac_enadis_rx_pause_fwding,
 	.mac_get_pause_frm_status =	rpm_lmac_get_pause_frm_status,
 	.mac_enadis_pause_frm =		rpm_lmac_enadis_pause_frm,
@@ -49,7 +53,7 @@ int rpm_get_nr_lmacs(void *rpmd)
 
 void rpm_lmac_enadis_rx_pause_fwding(void *rpmd, int lmac_id, bool enable)
 {
-	struct cgx *rpm = rpmd;
+	rpm_t *rpm = rpmd;
 	u64 cfg;
 
 	if (!rpm)
@@ -171,3 +175,54 @@ void rpm_lmac_pause_frm_config(void *rpmd, int lmac_id, bool enable)
 		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
 	}
 }
+
+int rpm_get_rx_stats(void *rpmd, int lmac_id, int idx, u64 *rx_stat)
+{
+	rpm_t *rpm = rpmd;
+	u64 val_lo, val_hi;
+
+	if (!rpm || lmac_id >= rpm->lmac_count)
+		return -ENODEV;
+
+	mutex_lock(&rpm->lock);
+
+	/* Update idx to point per lmac Rx statistics page */
+	idx += lmac_id * rpm->mac_ops->rx_stats_cnt;
+
+	/* Read lower 32 bits of counter */
+	val_lo = rpm_read(rpm, 0, RPMX_MTI_STAT_RX_STAT_PAGES_COUNTERX +
+			  (idx * 8));
+
+	/* upon read of lower 32 bits, higher 32 bits are written
+	 * to RPMX_MTI_STAT_DATA_HI_CDC
+	 */
+	val_hi = rpm_read(rpm, 0, RPMX_MTI_STAT_DATA_HI_CDC);
+
+	*rx_stat = (val_hi << 32 | val_lo);
+
+	mutex_unlock(&rpm->lock);
+	return 0;
+}
+
+int rpm_get_tx_stats(void *rpmd, int lmac_id, int idx, u64 *tx_stat)
+{
+	rpm_t *rpm = rpmd;
+	u64 val_lo, val_hi;
+
+	if (!rpm || lmac_id >= rpm->lmac_count)
+		return -ENODEV;
+
+	mutex_lock(&rpm->lock);
+
+	/* Update idx to point per lmac Tx statistics page */
+	idx += lmac_id * rpm->mac_ops->tx_stats_cnt;
+
+	val_lo = rpm_read(rpm, 0, RPMX_MTI_STAT_TX_STAT_PAGES_COUNTERX +
+			    (idx * 8));
+	val_hi = rpm_read(rpm, 0, RPMX_MTI_STAT_DATA_HI_CDC);
+
+	*tx_stat = (val_hi << 32 | val_lo);
+
+	mutex_unlock(&rpm->lock);
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
index 0e8b456..c939302 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
@@ -18,6 +18,7 @@
 #define RPMX_CMRX_SW_INT_W1S            0x188
 #define RPMX_CMRX_SW_INT_ENA_W1S        0x198
 #define RPMX_CMRX_LINK_CFG		0x1070
+#define RPMX_MTI_LPCSX_CONTROL(id)     (0x30000 | ((id) * 0x100))
 
 #define RPMX_CMRX_LINK_RANGE_MASK	GENMASK_ULL(19, 16)
 #define RPMX_CMRX_LINK_BASE_MASK	GENMASK_ULL(11, 0)
@@ -32,14 +33,20 @@
 #define RPMX_CMR_RX_OVR_BP		0x4120
 #define RPMX_CMR_RX_OVR_BP_EN(x)	BIT_ULL((x) + 8)
 #define RPMX_CMR_RX_OVR_BP_BP(x)	BIT_ULL((x) + 4)
+#define RPMX_MTI_STAT_RX_STAT_PAGES_COUNTERX 0x12000
+#define RPMX_MTI_STAT_TX_STAT_PAGES_COUNTERX 0x13000
+#define RPMX_MTI_STAT_DATA_HI_CDC            0x10038
+
 #define RPM_LMAC_FWI			0xa
 
 /* Function Declarations */
+int rpm_get_nr_lmacs(void *rpmd);
 void rpm_lmac_enadis_rx_pause_fwding(void *rpmd, int lmac_id, bool enable);
 int rpm_lmac_get_pause_frm_status(void *cgxd, int lmac_id, u8 *tx_pause,
 				  u8 *rx_pause);
 void rpm_lmac_pause_frm_config(void *rpmd, int lmac_id, bool enable);
 int rpm_lmac_enadis_pause_frm(void *rpmd, int lmac_id, u8 tx_pause,
 			      u8 rx_pause);
-int rpm_get_nr_lmacs(void *cgxd);
+int rpm_get_tx_stats(void *rpmd, int lmac_id, int idx, u64 *tx_stat);
+int rpm_get_rx_stats(void *rpmd, int lmac_id, int idx, u64 *rx_stat);
 #endif /* RPM_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 10876ee..28af2d3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -453,10 +453,11 @@ int rvu_mbox_handler_cgx_stop_rxtx(struct rvu *rvu, struct msg_req *req,
 	return 0;
 }
 
-int rvu_mbox_handler_cgx_stats(struct rvu *rvu, struct msg_req *req,
-			       struct cgx_stats_rsp *rsp)
+static int rvu_lmac_get_stats(struct rvu *rvu, struct msg_req *req,
+			      void *rsp)
 {
 	int pf = rvu_get_pf(req->hdr.pcifunc);
+	struct mac_ops *mac_ops;
 	int stat = 0, err = 0;
 	u64 tx_stat, rx_stat;
 	u8 cgx_idx, lmac;
@@ -467,28 +468,46 @@ int rvu_mbox_handler_cgx_stats(struct rvu *rvu, struct msg_req *req,
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_idx, &lmac);
 	cgxd = rvu_cgx_pdata(cgx_idx, rvu);
+	mac_ops = get_mac_ops(cgxd);
 
 	/* Rx stats */
-	while (stat < CGX_RX_STATS_COUNT) {
-		err = cgx_get_rx_stats(cgxd, lmac, stat, &rx_stat);
+	while (stat < mac_ops->rx_stats_cnt) {
+		err = mac_ops->mac_get_rx_stats(cgxd, lmac, stat, &rx_stat);
 		if (err)
 			return err;
-		rsp->rx_stats[stat] = rx_stat;
+		if (mac_ops->rx_stats_cnt == RPM_RX_STATS_COUNT)
+			((struct rpm_stats_rsp *)rsp)->rx_stats[stat] = rx_stat;
+		else
+			((struct cgx_stats_rsp *)rsp)->rx_stats[stat] = rx_stat;
 		stat++;
 	}
 
 	/* Tx stats */
-	stat = 0;
-	while (stat < CGX_TX_STATS_COUNT) {
-		err = cgx_get_tx_stats(cgxd, lmac, stat, &tx_stat);
+	while (stat < mac_ops->tx_stats_cnt) {
+		err = mac_ops->mac_get_tx_stats(cgxd, lmac, stat, &tx_stat);
 		if (err)
 			return err;
-		rsp->tx_stats[stat] = tx_stat;
+		if (mac_ops->tx_stats_cnt == RPM_TX_STATS_COUNT)
+			((struct rpm_stats_rsp *)rsp)->tx_stats[stat] = tx_stat;
+		else
+			((struct cgx_stats_rsp *)rsp)->tx_stats[stat] = tx_stat;
 		stat++;
 	}
 	return 0;
 }
 
+int rvu_mbox_handler_cgx_stats(struct rvu *rvu, struct msg_req *req,
+			       struct cgx_stats_rsp *rsp)
+{
+	return rvu_lmac_get_stats(rvu, req, (void *)rsp);
+}
+
+int rvu_mbox_handler_rpm_stats(struct rvu *rvu, struct msg_req *req,
+			       struct rpm_stats_rsp *rsp)
+{
+	return rvu_lmac_get_stats(rvu, req, (void *)rsp);
+}
+
 int rvu_mbox_handler_cgx_mac_addr_set(struct rvu *rvu,
 				      struct cgx_mac_addr_set_or_get *req,
 				      struct cgx_mac_addr_set_or_get *rsp)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index bc155b4..30732b2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -110,6 +110,89 @@ static char *cgx_tx_stats_fields[] = {
 	[CGX_STAT17]	= "Control/PAUSE packets sent",
 };
 
+static char *rpm_rx_stats_fields[] = {
+	"Octets of received packets",
+	"Octets of received packets with out error",
+	"Received packets with alignment errors",
+	"Control/PAUSE packets received",
+	"Packets received with Frame too long Errors",
+	"Packets received with a1nrange length Errors",
+	"Received packets",
+	"Packets received with FrameCheckSequenceErrors",
+	"Packets received with VLAN header",
+	"Error packets",
+	"Packets recievd with unicast DMAC",
+	"Packets received with multicast DMAC",
+	"Packets received with broadcast DMAC",
+	"Dropped packets",
+	"Total frames received on interface",
+	"Packets received with an octet count < 64",
+	"Packets received with an octet count == 64",
+	"Packets received with an octet count of 65â127",
+	"Packets received with an octet count of 128-255",
+	"Packets received with an octet count of 256-511",
+	"Packets received with an octet count of 512-1023",
+	"Packets received with an octet count of 1024-1518",
+	"Packets received with an octet count of > 1518",
+	"Oversized Packets",
+	"Jabber Packets",
+	"Fragmented Packets",
+	"CBFC(class based flow control) pause frames received for class 0",
+	"CBFC pause frames received for class 1",
+	"CBFC pause frames received for class 2",
+	"CBFC pause frames received for class 3",
+	"CBFC pause frames received for class 4",
+	"CBFC pause frames received for class 5",
+	"CBFC pause frames received for class 6",
+	"CBFC pause frames received for class 7",
+	"CBFC pause frames received for class 8",
+	"CBFC pause frames received for class 9",
+	"CBFC pause frames received for class 10",
+	"CBFC pause frames received for class 11",
+	"CBFC pause frames received for class 12",
+	"CBFC pause frames received for class 13",
+	"CBFC pause frames received for class 14",
+	"CBFC pause frames received for class 15",
+	"MAC control packets received",
+};
+
+static char *rpm_tx_stats_fields[] = {
+	"Total octets sent on the interface",
+	"Total octets transmitted OK",
+	"Control/Pause frames sent",
+	"Total frames transmitted OK",
+	"Total frames sent with VLAN header",
+	"Error Packets",
+	"Packets sent to unicast DMAC",
+	"Packets sent to the multicast DMAC",
+	"Packets sent to a broadcast DMAC",
+	"Packets sent with an octet count == 64",
+	"Packets sent with an octet count of 65â127",
+	"Packets sent with an octet count of 128-255",
+	"Packets sent with an octet count of 256-511",
+	"Packets sent with an octet count of 512-1023",
+	"Packets sent with an octet count of 1024-1518",
+	"Packets sent with an octet count of > 1518",
+	"CBFC(class based flow control) pause frames transmitted for class 0",
+	"CBFC pause frames transmitted for class 1",
+	"CBFC pause frames transmitted for class 2",
+	"CBFC pause frames transmitted for class 3",
+	"CBFC pause frames transmitted for class 4",
+	"CBFC pause frames transmitted for class 5",
+	"CBFC pause frames transmitted for class 6",
+	"CBFC pause frames transmitted for class 7",
+	"CBFC pause frames transmitted for class 8",
+	"CBFC pause frames transmitted for class 9",
+	"CBFC pause frames transmitted for class 10",
+	"CBFC pause frames transmitted for class 11",
+	"CBFC pause frames transmitted for class 12",
+	"CBFC pause frames transmitted for class 13",
+	"CBFC pause frames transmitted for class 14",
+	"CBFC pause frames transmitted for class 15",
+	"MAC control packets sent",
+	"Total frames sent on the interface"
+};
+
 enum cpt_eng_type {
 	CPT_AE_TYPE = 1,
 	CPT_SE_TYPE = 2,
@@ -1676,23 +1759,34 @@ static int cgx_print_stats(struct seq_file *s, int lmac_id)
 
 	/* Rx stats */
 	seq_printf(s, "\n=======%s RX_STATS======\n\n", mac_ops->name);
-	while (stat < CGX_RX_STATS_COUNT) {
-		err = cgx_get_rx_stats(cgxd, lmac_id, stat, &rx_stat);
+	while (stat < mac_ops->rx_stats_cnt) {
+		err = mac_ops->mac_get_rx_stats(cgxd, lmac_id, stat, &rx_stat);
 		if (err)
 			return err;
-		seq_printf(s, "%s: %llu\n", cgx_rx_stats_fields[stat], rx_stat);
+		if (is_rvu_otx2(rvu))
+			seq_printf(s, "%s: %llu\n", cgx_rx_stats_fields[stat],
+				   rx_stat);
+		else
+			seq_printf(s, "%s: %llu\n", rpm_rx_stats_fields[stat],
+				   rx_stat);
 		stat++;
 	}
 
 	/* Tx stats */
 	stat = 0;
 	seq_printf(s, "\n=======%s TX_STATS======\n\n", mac_ops->name);
-	while (stat < CGX_TX_STATS_COUNT) {
-		err = cgx_get_tx_stats(cgxd, lmac_id, stat, &tx_stat);
+	while (stat < mac_ops->tx_stats_cnt) {
+		err = mac_ops->mac_get_tx_stats(cgxd, lmac_id, stat, &tx_stat);
 		if (err)
 			return err;
-		seq_printf(s, "%s: %llu\n", cgx_tx_stats_fields[stat], tx_stat);
-		stat++;
+
+	if (is_rvu_otx2(rvu))
+		seq_printf(s, "%s: %llu\n", cgx_tx_stats_fields[stat],
+			   tx_stat);
+	else
+		seq_printf(s, "%s: %llu\n", rpm_tx_stats_fields[stat],
+			   tx_stat);
+	stat++;
 	}
 
 	return err;
-- 
2.7.4

