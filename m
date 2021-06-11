Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E483A3F45
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 11:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbhFKJo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 05:44:27 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61690 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230405AbhFKJo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 05:44:26 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15B9fF63022658;
        Fri, 11 Jun 2021 02:42:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=MlcTGOnBkNNZVq/USSahPxGVm+w/m+pqq4P/Q9HRkiw=;
 b=kSf3WKHPtRB32bWLUwIAIiErqG0yT/iY8eiWqHvwUdgQ0IXE2928osVirtARfjeqTcgA
 HELfHDHtjo2FBVyxQhJpEIfY4BCqJcA6Fm5ey+fQciFiLTRyApFLSF9jXk6Zsf876wwL
 XgcpZ2U3ym9WzbztfI6XwgA5M2xo1ml5KQ4c9tyWdlIRrDh6Xw+h45WkY/vtnsYgtBC/
 3Je1CQ0/M1mdmFuQaLutDvtjfLzXboy8ZcG2soYzQFexFQGaElmOfiVqQYPuPn/1sBuj
 /yRTG6WA2bnE4fwxQ8qkeS3f+lBOJhC2azx0+jihZcJCEuOmqSZq1B/NSAcDlM4OC6iS zg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 39417n8vav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 02:42:24 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Jun
 2021 02:42:22 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 11 Jun 2021 02:42:22 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id BBCE63F7074;
        Fri, 11 Jun 2021 02:42:19 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <lcherian@marvell.com>, <gakula@marvell.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>,
        Sunil Kovvuri Goutham <Sunil.Goutham@marvell.com>
Subject: [PATCH net-next 1/4] octeontx2-af: add support for multicast/promisc packet replication feature
Date:   Fri, 11 Jun 2021 15:12:02 +0530
Message-ID: <20210611094205.28230-2-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20210611094205.28230-1-naveenm@marvell.com>
References: <20210611094205.28230-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: ocbHoRi32UmwbOk_9SVSOGHWvkZY-KIM
X-Proofpoint-ORIG-GUID: ocbHoRi32UmwbOk_9SVSOGHWvkZY-KIM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_03:2021-06-11,2021-06-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, multicast packet filtering is accomplished by installing
MCAM rule that matches all-multicast MAC address and has its
NPC_RX_ACTION set to unicast to PF. Similarly promisc feature is
achieved by installing MCAM rule that matches all the traffic received
by the channel and unicast the packets to PF. This approach only applies
to PF and is not scalable across VFs.

This patch adds support for PF/VF multicast and promisc feature by
reserving NIX_RX_MCE_S entries from the global MCE list allocated
during NIX block initialization. The NIX_RX_MCE_S entries create a
linked list with a flag indicating the end of the list, and each entry
points to a PF_FUNC (either PF or VF). When a packet NPC_RX_ACTION is
set to MCAST, the corresponding NIX_RX_MCE_S list is traversed and the
packet is queued to each PF_FUNC available on the list.

The PF or VF driver adds the multicast/promisc packet match entry and
updates the MCE list with correspondng PF_FUNC. When a PF or VF interface
is disabled, the corresponding NIX_RX_MCE_S entry is removed from the
MCE list and the MCAM entry will be disabled if the list is empty.

Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <Sunil.Goutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/common.h |   5 +
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   5 +-
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |   3 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  49 +++-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |   5 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 254 +++++++++++++----
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 308 ++++++++++++++-------
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |   7 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   4 +-
 9 files changed, 482 insertions(+), 158 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
index e66109367487..47f5ed006a93 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
@@ -197,6 +197,11 @@ enum nix_scheduler {
 
 #define SDP_CHANNELS			256
 
+/* The mask is to extract lower 10-bits of channel number
+ * which CPT will pass to X2P.
+ */
+#define NIX_CHAN_CPT_X2P_MASK          (0x3ffull)
+
 /* NIX LSO format indices.
  * As of now TSO is the only one using, so statically assigning indices.
  */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index cedb2616c509..ed0bc9d3d5dd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -611,7 +611,9 @@ enum nix_af_status {
 	NIX_AF_INVAL_SSO_PF_FUNC    = -420,
 	NIX_AF_ERR_TX_VTAG_NOSPC    = -421,
 	NIX_AF_ERR_RX_VTAG_INUSE    = -422,
-	NIX_AF_ERR_NPC_KEY_NOT_SUPP = -423,
+	NIX_AF_ERR_PTP_CONFIG_FAIL  = -423,
+	NIX_AF_ERR_NPC_KEY_NOT_SUPP = -424,
+	NIX_AF_ERR_INVALID_NIXBLK   = -425,
 };
 
 /* For NIX RX vtag action  */
@@ -913,6 +915,7 @@ struct nix_rx_mode {
 #define NIX_RX_MODE_UCAST	BIT(0)
 #define NIX_RX_MODE_PROMISC	BIT(1)
 #define NIX_RX_MODE_ALLMULTI	BIT(2)
+#define NIX_RX_MODE_USE_MCE	BIT(3)
 	u16	mode;
 };
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index fe19704173a1..19bad9a59c8f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -438,7 +438,8 @@ struct nix_tx_action {
 /* NPC MCAM reserved entry index per nixlf */
 #define NIXLF_UCAST_ENTRY	0
 #define NIXLF_BCAST_ENTRY	1
-#define NIXLF_PROMISC_ENTRY	2
+#define NIXLF_ALLMULTI_ENTRY	2
+#define NIXLF_PROMISC_ENTRY	3
 
 struct npc_coalesced_kpu_prfl {
 #define NPC_SIGN	0x00666f727063706e
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 74ed929f101b..29bc9a6792d3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -227,9 +227,14 @@ struct rvu_pfvf {
 	u8		mac_addr[ETH_ALEN]; /* MAC address of this PF/VF */
 	u8		default_mac[ETH_ALEN]; /* MAC address from FWdata */
 
-	/* Broadcast pkt replication info */
+	/* Broadcast/Multicast/Promisc pkt replication info */
 	u16			bcast_mce_idx;
+	u16			mcast_mce_idx;
+	u16			promisc_mce_idx;
 	struct nix_mce_list	bcast_mce_list;
+	struct nix_mce_list	mcast_mce_list;
+	struct nix_mce_list	promisc_mce_list;
+	bool			use_mce_list;
 
 	struct rvu_npc_mcam_rule *def_ucast_rule;
 
@@ -239,6 +244,11 @@ struct rvu_pfvf {
 	u8	nix_blkaddr; /* BLKADDR_NIX0/1 assigned to this PF */
 	u8	nix_rx_intf; /* NIX0_RX/NIX1_RX interface to NPC */
 	u8	nix_tx_intf; /* NIX0_TX/NIX1_TX interface to NPC */
+	unsigned long flags;
+};
+
+enum rvu_pfvf_flags {
+	NIXLF_INITIALIZED = 0,
 };
 
 struct nix_txsch {
@@ -548,11 +558,16 @@ static inline u16 rvu_nix_chan_cpt(struct rvu *rvu, u8 chan)
 /* Function Prototypes
  * RVU
  */
-static inline int is_afvf(u16 pcifunc)
+static inline bool is_afvf(u16 pcifunc)
 {
 	return !(pcifunc & ~RVU_PFVF_FUNC_MASK);
 }
 
+static inline bool is_vf(u16 pcifunc)
+{
+	return !!(pcifunc & RVU_PFVF_FUNC_MASK);
+}
+
 /* check if PF_FUNC is AF */
 static inline bool is_pffunc_af(u16 pcifunc)
 {
@@ -608,6 +623,12 @@ static inline void rvu_get_cgx_lmac_id(u8 map, u8 *cgx_id, u8 *lmac_id)
 	*lmac_id = (map & 0xF);
 }
 
+static inline bool is_cgx_vf(struct rvu *rvu, u16 pcifunc)
+{
+	return ((pcifunc & RVU_PFVF_FUNC_MASK) &&
+		is_pf_cgxmapped(rvu, rvu_get_pf(pcifunc)));
+}
+
 #define M(_name, _id, fn_name, req, rsp)				\
 int rvu_mbox_handler_ ## fn_name(struct rvu *, struct req *, struct rsp *);
 MBOX_MESSAGES
@@ -637,10 +658,16 @@ void rvu_nix_freemem(struct rvu *rvu);
 int rvu_get_nixlf_count(struct rvu *rvu);
 void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int npalf);
 int nix_get_nixlf(struct rvu *rvu, u16 pcifunc, int *nixlf, int *nix_blkaddr);
-int nix_update_bcast_mce_list(struct rvu *rvu, u16 pcifunc, bool add);
+int nix_update_mce_list(struct rvu *rvu, u16 pcifunc,
+			struct nix_mce_list *mce_list,
+			int mce_idx, int mcam_index, bool add);
+void nix_get_mce_list(struct rvu *rvu, u16 pcifunc, int type,
+		      struct nix_mce_list **mce_list, int *mce_idx);
 struct nix_hw *get_nix_hw(struct rvu_hwinfo *hw, int blkaddr);
 int rvu_get_next_nix_blkaddr(struct rvu *rvu, int blkaddr);
 void rvu_nix_reset_mac(struct rvu_pfvf *pfvf, int pcifunc);
+int nix_get_struct_ptrs(struct rvu *rvu, u16 pcifunc,
+			struct nix_hw **nix_hw, int *blkaddr);
 
 /* NPC APIs */
 int rvu_npc_init(struct rvu *rvu);
@@ -651,13 +678,19 @@ int npc_config_ts_kpuaction(struct rvu *rvu, int pf, u16 pcifunc, bool en);
 void rvu_npc_install_ucast_entry(struct rvu *rvu, u16 pcifunc,
 				 int nixlf, u64 chan, u8 *mac_addr);
 void rvu_npc_install_promisc_entry(struct rvu *rvu, u16 pcifunc,
-				   int nixlf, u64 chan, u8 chan_cnt,
-				   bool allmulti);
-void rvu_npc_disable_promisc_entry(struct rvu *rvu, u16 pcifunc, int nixlf);
-void rvu_npc_enable_promisc_entry(struct rvu *rvu, u16 pcifunc, int nixlf);
+				   int nixlf, u64 chan, u8 chan_cnt);
+void rvu_npc_enable_promisc_entry(struct rvu *rvu, u16 pcifunc, int nixlf,
+				  bool enable);
 void rvu_npc_install_bcast_match_entry(struct rvu *rvu, u16 pcifunc,
 				       int nixlf, u64 chan);
-void rvu_npc_enable_bcast_entry(struct rvu *rvu, u16 pcifunc, bool enable);
+void rvu_npc_enable_bcast_entry(struct rvu *rvu, u16 pcifunc, int nixlf,
+				bool enable);
+void rvu_npc_install_allmulti_entry(struct rvu *rvu, u16 pcifunc, int nixlf,
+				    u64 chan);
+void rvu_npc_enable_allmulti_entry(struct rvu *rvu, u16 pcifunc, int nixlf,
+				   bool enable);
+void npc_enadis_default_mce_entry(struct rvu *rvu, u16 pcifunc,
+				  int nixlf, int type, bool enable);
 void rvu_npc_disable_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_free_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
 void rvu_npc_disable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 9bf8eaabf9ab..7103f8216ad1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -2132,6 +2132,7 @@ static int rvu_dbg_npc_mcam_show_rules(struct seq_file *s, void *unused)
 	struct rvu *rvu = s->private;
 	struct npc_mcam *mcam;
 	int pf, vf = -1;
+	bool enabled;
 	int blkaddr;
 	u16 target;
 	u64 hits;
@@ -2173,7 +2174,9 @@ static int rvu_dbg_npc_mcam_show_rules(struct seq_file *s, void *unused)
 		}
 
 		rvu_dbg_npc_mcam_show_action(s, iter);
-		seq_printf(s, "\tenabled: %s\n", iter->enable ? "yes" : "no");
+
+		enabled = is_mcam_entry_enabled(rvu, mcam, blkaddr, iter->entry);
+		seq_printf(s, "\tenabled: %s\n", enabled ? "yes" : "no");
 
 		if (!iter->has_cntr)
 			continue;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 174ef09f9069..8c8d739755cd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -21,6 +21,8 @@
 static void nix_free_tx_vtag_entries(struct rvu *rvu, u16 pcifunc);
 static int rvu_nix_get_bpid(struct rvu *rvu, struct nix_bp_cfg_req *req,
 			    int type, int chan_id);
+static int nix_update_mce_rule(struct rvu *rvu, u16 pcifunc,
+			       int type, bool add);
 
 enum mc_tbl_sz {
 	MC_TBL_SZ_256,
@@ -132,6 +134,22 @@ int nix_get_nixlf(struct rvu *rvu, u16 pcifunc, int *nixlf, int *nix_blkaddr)
 	return 0;
 }
 
+int nix_get_struct_ptrs(struct rvu *rvu, u16 pcifunc,
+			struct nix_hw **nix_hw, int *blkaddr)
+{
+	struct rvu_pfvf *pfvf;
+
+	pfvf = rvu_get_pfvf(rvu, pcifunc);
+	*blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
+	if (!pfvf->nixlf || *blkaddr < 0)
+		return NIX_AF_ERR_AF_LF_INVALID;
+
+	*nix_hw = get_nix_hw(rvu->hw, *blkaddr);
+	if (!*nix_hw)
+		return NIX_AF_ERR_INVALID_NIXBLK;
+	return 0;
+}
+
 static void nix_mce_list_init(struct nix_mce_list *list, int max)
 {
 	INIT_HLIST_HEAD(&list->head);
@@ -274,7 +292,7 @@ static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf)
 		pfvf->tx_chan_cnt = 1;
 		rvu_npc_install_promisc_entry(rvu, pcifunc, nixlf,
 					      pfvf->rx_chan_base,
-					      pfvf->rx_chan_cnt, false);
+					      pfvf->rx_chan_cnt);
 		break;
 	}
 
@@ -285,16 +303,17 @@ static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf)
 				    pfvf->rx_chan_base, pfvf->mac_addr);
 
 	/* Add this PF_FUNC to bcast pkt replication list */
-	err = nix_update_bcast_mce_list(rvu, pcifunc, true);
+	err = nix_update_mce_rule(rvu, pcifunc, NIXLF_BCAST_ENTRY, true);
 	if (err) {
 		dev_err(rvu->dev,
 			"Bcast list, failed to enable PF_FUNC 0x%x\n",
 			pcifunc);
 		return err;
 	}
-
+	/* Install MCAM rule matching Ethernet broadcast mac address */
 	rvu_npc_install_bcast_match_entry(rvu, pcifunc,
 					  nixlf, pfvf->rx_chan_base);
+
 	pfvf->maxlen = NIC_HW_MIN_FRS;
 	pfvf->minlen = NIC_HW_MIN_FRS;
 
@@ -310,7 +329,7 @@ static void nix_interface_deinit(struct rvu *rvu, u16 pcifunc, u8 nixlf)
 	pfvf->minlen = 0;
 
 	/* Remove this PF_FUNC from bcast pkt replication list */
-	err = nix_update_bcast_mce_list(rvu, pcifunc, false);
+	err = nix_update_mce_rule(rvu, pcifunc, NIXLF_BCAST_ENTRY, false);
 	if (err) {
 		dev_err(rvu->dev,
 			"Bcast list, failed to disable PF_FUNC 0x%x\n",
@@ -2203,8 +2222,8 @@ static int nix_blk_setup_mce(struct rvu *rvu, struct nix_hw *nix_hw,
 	aq_req.op = op;
 	aq_req.qidx = mce;
 
-	/* Forward bcast pkts to RQ0, RSS not needed */
-	aq_req.mce.op = 0;
+	/* Use RSS with RSS index 0 */
+	aq_req.mce.op = 1;
 	aq_req.mce.index = 0;
 	aq_req.mce.eol = eol;
 	aq_req.mce.pf_func = pcifunc;
@@ -2222,8 +2241,8 @@ static int nix_blk_setup_mce(struct rvu *rvu, struct nix_hw *nix_hw,
 	return 0;
 }
 
-static int nix_update_mce_list(struct nix_mce_list *mce_list,
-			       u16 pcifunc, bool add)
+static int nix_update_mce_list_entry(struct nix_mce_list *mce_list,
+				     u16 pcifunc, bool add)
 {
 	struct mce *mce, *tail = NULL;
 	bool delete = false;
@@ -2234,6 +2253,9 @@ static int nix_update_mce_list(struct nix_mce_list *mce_list,
 		if (mce->pcifunc == pcifunc && !add) {
 			delete = true;
 			break;
+		} else if (mce->pcifunc == pcifunc && add) {
+			/* entry already exists */
+			return 0;
 		}
 		tail = mce;
 	}
@@ -2261,36 +2283,23 @@ static int nix_update_mce_list(struct nix_mce_list *mce_list,
 	return 0;
 }
 
-int nix_update_bcast_mce_list(struct rvu *rvu, u16 pcifunc, bool add)
+int nix_update_mce_list(struct rvu *rvu, u16 pcifunc,
+			struct nix_mce_list *mce_list,
+			int mce_idx, int mcam_index, bool add)
 {
-	int err = 0, idx, next_idx, last_idx;
-	struct nix_mce_list *mce_list;
+	int err = 0, idx, next_idx, last_idx, blkaddr, npc_blkaddr;
+	struct npc_mcam *mcam = &rvu->hw->mcam;
 	struct nix_mcast *mcast;
 	struct nix_hw *nix_hw;
-	struct rvu_pfvf *pfvf;
 	struct mce *mce;
-	int blkaddr;
 
-	/* Broadcast pkt replication is not needed for AF's VFs, hence skip */
-	if (is_afvf(pcifunc))
-		return 0;
-
-	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
-	if (blkaddr < 0)
-		return 0;
-
-	nix_hw = get_nix_hw(rvu->hw, blkaddr);
-	if (!nix_hw)
-		return 0;
-
-	mcast = &nix_hw->mcast;
+	if (!mce_list)
+		return -EINVAL;
 
 	/* Get this PF/VF func's MCE index */
-	pfvf = rvu_get_pfvf(rvu, pcifunc & ~RVU_PFVF_FUNC_MASK);
-	idx = pfvf->bcast_mce_idx + (pcifunc & RVU_PFVF_FUNC_MASK);
+	idx = mce_idx + (pcifunc & RVU_PFVF_FUNC_MASK);
 
-	mce_list = &pfvf->bcast_mce_list;
-	if (idx > (pfvf->bcast_mce_idx + mce_list->max)) {
+	if (idx > (mce_idx + mce_list->max)) {
 		dev_err(rvu->dev,
 			"%s: Idx %d > max MCE idx %d, for PF%d bcast list\n",
 			__func__, idx, mce_list->max,
@@ -2298,20 +2307,26 @@ int nix_update_bcast_mce_list(struct rvu *rvu, u16 pcifunc, bool add)
 		return -EINVAL;
 	}
 
+	err = nix_get_struct_ptrs(rvu, pcifunc, &nix_hw, &blkaddr);
+	if (err)
+		return err;
+
+	mcast = &nix_hw->mcast;
 	mutex_lock(&mcast->mce_lock);
 
-	err = nix_update_mce_list(mce_list, pcifunc, add);
+	err = nix_update_mce_list_entry(mce_list, pcifunc, add);
 	if (err)
 		goto end;
 
 	/* Disable MCAM entry in NPC */
 	if (!mce_list->count) {
-		rvu_npc_enable_bcast_entry(rvu, pcifunc, false);
+		npc_blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+		npc_enable_mcam_entry(rvu, mcam, npc_blkaddr, mcam_index, false);
 		goto end;
 	}
 
 	/* Dump the updated list to HW */
-	idx = pfvf->bcast_mce_idx;
+	idx = mce_idx;
 	last_idx = idx + mce_list->count - 1;
 	hlist_for_each_entry(mce, &mce_list->head, node) {
 		if (idx > last_idx)
@@ -2332,7 +2347,71 @@ int nix_update_bcast_mce_list(struct rvu *rvu, u16 pcifunc, bool add)
 	return err;
 }
 
-static int nix_setup_bcast_tables(struct rvu *rvu, struct nix_hw *nix_hw)
+void nix_get_mce_list(struct rvu *rvu, u16 pcifunc, int type,
+		      struct nix_mce_list **mce_list, int *mce_idx)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	struct rvu_pfvf *pfvf;
+
+	if (!hw->cap.nix_rx_multicast ||
+	    !is_pf_cgxmapped(rvu, rvu_get_pf(pcifunc & ~RVU_PFVF_FUNC_MASK))) {
+		*mce_list = NULL;
+		*mce_idx = 0;
+		return;
+	}
+
+	/* Get this PF/VF func's MCE index */
+	pfvf = rvu_get_pfvf(rvu, pcifunc & ~RVU_PFVF_FUNC_MASK);
+
+	if (type == NIXLF_BCAST_ENTRY) {
+		*mce_list = &pfvf->bcast_mce_list;
+		*mce_idx = pfvf->bcast_mce_idx;
+	} else if (type == NIXLF_ALLMULTI_ENTRY) {
+		*mce_list = &pfvf->mcast_mce_list;
+		*mce_idx = pfvf->mcast_mce_idx;
+	} else if (type == NIXLF_PROMISC_ENTRY) {
+		*mce_list = &pfvf->promisc_mce_list;
+		*mce_idx = pfvf->promisc_mce_idx;
+	}  else {
+		*mce_list = NULL;
+		*mce_idx = 0;
+	}
+}
+
+static int nix_update_mce_rule(struct rvu *rvu, u16 pcifunc,
+			       int type, bool add)
+{
+	int err = 0, nixlf, blkaddr, mcam_index, mce_idx;
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	struct rvu_hwinfo *hw = rvu->hw;
+	struct nix_mce_list *mce_list;
+
+	/* skip multicast pkt replication for AF's VFs */
+	if (is_afvf(pcifunc))
+		return 0;
+
+	if (!hw->cap.nix_rx_multicast)
+		return 0;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
+	if (blkaddr < 0)
+		return -EINVAL;
+
+	nixlf = rvu_get_lf(rvu, &hw->block[blkaddr], pcifunc, 0);
+	if (nixlf < 0)
+		return -EINVAL;
+
+	nix_get_mce_list(rvu, pcifunc, type, &mce_list, &mce_idx);
+
+	mcam_index = npc_get_nixlf_mcam_index(mcam,
+					      pcifunc & ~RVU_PFVF_FUNC_MASK,
+					      nixlf, type);
+	err = nix_update_mce_list(rvu, pcifunc, mce_list,
+				  mce_idx, mcam_index, add);
+	return err;
+}
+
+static int nix_setup_mce_tables(struct rvu *rvu, struct nix_hw *nix_hw)
 {
 	struct nix_mcast *mcast = &nix_hw->mcast;
 	int err, pf, numvfs, idx;
@@ -2355,11 +2434,18 @@ static int nix_setup_bcast_tables(struct rvu *rvu, struct nix_hw *nix_hw)
 		if (pfvf->nix_blkaddr != nix_hw->blkaddr)
 			continue;
 
-		/* Save the start MCE */
+		/* save start idx of broadcast mce list */
 		pfvf->bcast_mce_idx = nix_alloc_mce_list(mcast, numvfs + 1);
-
 		nix_mce_list_init(&pfvf->bcast_mce_list, numvfs + 1);
 
+		/* save start idx of multicast mce list */
+		pfvf->mcast_mce_idx = nix_alloc_mce_list(mcast, numvfs + 1);
+		nix_mce_list_init(&pfvf->mcast_mce_list, numvfs + 1);
+
+		/* save the start idx of promisc mce list */
+		pfvf->promisc_mce_idx = nix_alloc_mce_list(mcast, numvfs + 1);
+		nix_mce_list_init(&pfvf->promisc_mce_list, numvfs + 1);
+
 		for (idx = 0; idx < (numvfs + 1); idx++) {
 			/* idx-0 is for PF, followed by VFs */
 			pcifunc = (pf << RVU_PFVF_PF_SHIFT);
@@ -2375,6 +2461,22 @@ static int nix_setup_bcast_tables(struct rvu *rvu, struct nix_hw *nix_hw)
 						pcifunc, 0, true);
 			if (err)
 				return err;
+
+			/* add dummy entries to multicast mce list */
+			err = nix_blk_setup_mce(rvu, nix_hw,
+						pfvf->mcast_mce_idx + idx,
+						NIX_AQ_INSTOP_INIT,
+						pcifunc, 0, true);
+			if (err)
+				return err;
+
+			/* add dummy entries to promisc mce list */
+			err = nix_blk_setup_mce(rvu, nix_hw,
+						pfvf->promisc_mce_idx + idx,
+						NIX_AQ_INSTOP_INIT,
+						pcifunc, 0, true);
+			if (err)
+				return err;
 		}
 	}
 	return 0;
@@ -2421,7 +2523,7 @@ static int nix_setup_mcast(struct rvu *rvu, struct nix_hw *nix_hw, int blkaddr)
 
 	mutex_init(&mcast->mce_lock);
 
-	return nix_setup_bcast_tables(rvu, nix_hw);
+	return nix_setup_mce_tables(rvu, nix_hw);
 }
 
 static int nix_setup_txvlan(struct rvu *rvu, struct nix_hw *nix_hw)
@@ -3067,30 +3169,70 @@ int rvu_mbox_handler_nix_get_mac_addr(struct rvu *rvu,
 int rvu_mbox_handler_nix_set_rx_mode(struct rvu *rvu, struct nix_rx_mode *req,
 				     struct msg_rsp *rsp)
 {
-	bool allmulti = false, disable_promisc = false;
+	bool allmulti, promisc, nix_rx_multicast;
 	u16 pcifunc = req->hdr.pcifunc;
-	int blkaddr, nixlf, err;
 	struct rvu_pfvf *pfvf;
+	int nixlf, err;
 
-	err = nix_get_nixlf(rvu, pcifunc, &nixlf, &blkaddr);
+	pfvf = rvu_get_pfvf(rvu, pcifunc);
+	promisc = req->mode & NIX_RX_MODE_PROMISC ? true : false;
+	allmulti = req->mode & NIX_RX_MODE_ALLMULTI ? true : false;
+	pfvf->use_mce_list = req->mode & NIX_RX_MODE_USE_MCE ? true : false;
+
+	nix_rx_multicast = rvu->hw->cap.nix_rx_multicast & pfvf->use_mce_list;
+
+	if (is_vf(pcifunc) && !nix_rx_multicast &&
+	    (promisc || allmulti)) {
+		dev_warn_ratelimited(rvu->dev,
+				     "VF promisc/multicast not supported\n");
+		return 0;
+	}
+
+	err = nix_get_nixlf(rvu, pcifunc, &nixlf, NULL);
 	if (err)
 		return err;
 
-	pfvf = rvu_get_pfvf(rvu, pcifunc);
+	if (nix_rx_multicast) {
+		/* add/del this PF_FUNC to/from mcast pkt replication list */
+		err = nix_update_mce_rule(rvu, pcifunc, NIXLF_ALLMULTI_ENTRY,
+					  allmulti);
+		if (err) {
+			dev_err(rvu->dev,
+				"Failed to update pcifunc 0x%x to multicast list\n",
+				pcifunc);
+			return err;
+		}
 
-	if (req->mode & NIX_RX_MODE_PROMISC)
-		allmulti = false;
-	else if (req->mode & NIX_RX_MODE_ALLMULTI)
-		allmulti = true;
-	else
-		disable_promisc = true;
+		/* add/del this PF_FUNC to/from promisc pkt replication list */
+		err = nix_update_mce_rule(rvu, pcifunc, NIXLF_PROMISC_ENTRY,
+					  promisc);
+		if (err) {
+			dev_err(rvu->dev,
+				"Failed to update pcifunc 0x%x to promisc list\n",
+				pcifunc);
+			return err;
+		}
+	}
 
-	if (disable_promisc)
-		rvu_npc_disable_promisc_entry(rvu, pcifunc, nixlf);
-	else
+	/* install/uninstall allmulti entry */
+	if (allmulti) {
+		rvu_npc_install_allmulti_entry(rvu, pcifunc, nixlf,
+					       pfvf->rx_chan_base);
+	} else {
+		if (!nix_rx_multicast)
+			rvu_npc_enable_allmulti_entry(rvu, pcifunc, nixlf, false);
+	}
+
+	/* install/uninstall promisc entry */
+	if (promisc) {
 		rvu_npc_install_promisc_entry(rvu, pcifunc, nixlf,
 					      pfvf->rx_chan_base,
-					      pfvf->rx_chan_cnt, allmulti);
+					      pfvf->rx_chan_cnt);
+	} else {
+		if (!nix_rx_multicast)
+			rvu_npc_enable_promisc_entry(rvu, pcifunc, nixlf, false);
+	}
+
 	return 0;
 }
 
@@ -3648,6 +3790,7 @@ int rvu_mbox_handler_nix_lf_start_rx(struct rvu *rvu, struct msg_req *req,
 				     struct msg_rsp *rsp)
 {
 	u16 pcifunc = req->hdr.pcifunc;
+	struct rvu_pfvf *pfvf;
 	int nixlf, err;
 
 	err = nix_get_nixlf(rvu, pcifunc, &nixlf, NULL);
@@ -3658,6 +3801,9 @@ int rvu_mbox_handler_nix_lf_start_rx(struct rvu *rvu, struct msg_req *req,
 
 	npc_mcam_enable_flows(rvu, pcifunc);
 
+	pfvf = rvu_get_pfvf(rvu, pcifunc);
+	set_bit(NIXLF_INITIALIZED, &pfvf->flags);
+
 	return rvu_cgx_start_stop_io(rvu, pcifunc, true);
 }
 
@@ -3665,6 +3811,7 @@ int rvu_mbox_handler_nix_lf_stop_rx(struct rvu *rvu, struct msg_req *req,
 				    struct msg_rsp *rsp)
 {
 	u16 pcifunc = req->hdr.pcifunc;
+	struct rvu_pfvf *pfvf;
 	int nixlf, err;
 
 	err = nix_get_nixlf(rvu, pcifunc, &nixlf, NULL);
@@ -3673,6 +3820,9 @@ int rvu_mbox_handler_nix_lf_stop_rx(struct rvu *rvu, struct msg_req *req,
 
 	rvu_npc_disable_mcam_entries(rvu, pcifunc, nixlf);
 
+	pfvf = rvu_get_pfvf(rvu, pcifunc);
+	clear_bit(NIXLF_INITIALIZED, &pfvf->flags);
+
 	return rvu_cgx_start_stop_io(rvu, pcifunc, false);
 }
 
@@ -3691,6 +3841,8 @@ void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int nixlf)
 	nix_rx_sync(rvu, blkaddr);
 	nix_txschq_free(rvu, pcifunc);
 
+	clear_bit(NIXLF_INITIALIZED, &pfvf->flags);
+
 	rvu_cgx_start_stop_io(rvu, pcifunc, false);
 
 	if (pfvf->sq_ctx) {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 053cc872d0cc..5c2bd4337170 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -19,7 +19,7 @@
 #include "cgx.h"
 #include "npc_profile.h"
 
-#define RSVD_MCAM_ENTRIES_PER_PF	2 /* Bcast & Promisc */
+#define RSVD_MCAM_ENTRIES_PER_PF	3 /* Broadcast, Promisc and AllMulticast */
 #define RSVD_MCAM_ENTRIES_PER_NIXLF	1 /* Ucast for LFs */
 
 #define NPC_PARSE_RESULT_DMAC_OFFSET	8
@@ -214,8 +214,10 @@ int npc_get_nixlf_mcam_index(struct npc_mcam *mcam,
 		 */
 		if (type == NIXLF_BCAST_ENTRY)
 			return index;
-		else if (type == NIXLF_PROMISC_ENTRY)
+		else if (type == NIXLF_ALLMULTI_ENTRY)
 			return index + 1;
+		else if (type == NIXLF_PROMISC_ENTRY)
+			return index + 2;
 	}
 
 	return npc_get_ucast_mcam_index(mcam, pcifunc, nixlf);
@@ -413,37 +415,49 @@ static void npc_fill_entryword(struct mcam_entry *entry, int idx,
 	}
 }
 
-static void npc_get_default_entry_action(struct rvu *rvu, struct npc_mcam *mcam,
-					 int blkaddr, int index,
-					 struct mcam_entry *entry)
+static u64 npc_get_default_entry_action(struct rvu *rvu, struct npc_mcam *mcam,
+					int blkaddr, u16 pf_func)
+{
+	int bank, nixlf, index;
+
+	/* get ucast entry rule entry index */
+	nix_get_nixlf(rvu, pf_func, &nixlf, NULL);
+	index = npc_get_nixlf_mcam_index(mcam, pf_func, nixlf,
+					 NIXLF_UCAST_ENTRY);
+	bank = npc_get_bank(mcam, index);
+	index &= (mcam->banksize - 1);
+
+	return rvu_read64(rvu, blkaddr,
+			  NPC_AF_MCAMEX_BANKX_ACTION(index, bank));
+}
+
+static void npc_fixup_vf_rule(struct rvu *rvu, struct npc_mcam *mcam,
+			      int blkaddr, int index, struct mcam_entry *entry,
+			      bool *enable)
 {
 	u16 owner, target_func;
 	struct rvu_pfvf *pfvf;
-	int bank, nixlf;
 	u64 rx_action;
 
 	owner = mcam->entry2pfvf_map[index];
 	target_func = (entry->action >> 4) & 0xffff;
-	/* return incase target is PF or LBK or rule owner is not PF */
+	/* do nothing when target is LBK/PF or owner is not PF */
 	if (is_afvf(target_func) || (owner & RVU_PFVF_FUNC_MASK) ||
 	    !(target_func & RVU_PFVF_FUNC_MASK))
 		return;
 
+	/* save entry2target_pffunc */
 	pfvf = rvu_get_pfvf(rvu, target_func);
 	mcam->entry2target_pffunc[index] = target_func;
-	/* return if nixlf is not attached or initialized */
-	if (!is_nixlf_attached(rvu, target_func) || !pfvf->def_ucast_rule)
-		return;
 
-	/* get VF ucast entry rule */
-	nix_get_nixlf(rvu, target_func, &nixlf, NULL);
-	index = npc_get_nixlf_mcam_index(mcam, target_func,
-					 nixlf, NIXLF_UCAST_ENTRY);
-	bank = npc_get_bank(mcam, index);
-	index &= (mcam->banksize - 1);
+	/* don't enable rule when nixlf not attached or initialized */
+	if (!(is_nixlf_attached(rvu, target_func) &&
+	      test_bit(NIXLF_INITIALIZED, &pfvf->flags)))
+		*enable = false;
 
-	rx_action = rvu_read64(rvu, blkaddr,
-			       NPC_AF_MCAMEX_BANKX_ACTION(index, bank));
+	/* copy VF default entry action to the VF mcam entry */
+	rx_action = npc_get_default_entry_action(rvu, mcam, blkaddr,
+						 target_func);
 	if (rx_action)
 		entry->action = rx_action;
 }
@@ -495,10 +509,9 @@ static void npc_config_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 			    NPC_AF_MCAMEX_BANKX_CAMX_W1(index, bank, 0), cam0);
 	}
 
-	/* copy VF default entry action to the VF mcam entry */
+	/* PF installing VF rule */
 	if (intf == NIX_INTF_RX && actindex < mcam->bmap_entries)
-		npc_get_default_entry_action(rvu, mcam, blkaddr, actindex,
-					     entry);
+		npc_fixup_vf_rule(rvu, mcam, blkaddr, index, entry, &enable);
 
 	/* Set 'action' */
 	rvu_write64(rvu, blkaddr,
@@ -649,30 +662,32 @@ void rvu_npc_install_ucast_entry(struct rvu *rvu, u16 pcifunc,
 }
 
 void rvu_npc_install_promisc_entry(struct rvu *rvu, u16 pcifunc,
-				   int nixlf, u64 chan, u8 chan_cnt,
-				   bool allmulti)
+				   int nixlf, u64 chan, u8 chan_cnt)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
 	struct npc_install_flow_req req = { 0 };
 	struct npc_install_flow_rsp rsp = { 0 };
 	struct npc_mcam *mcam = &rvu->hw->mcam;
+	struct rvu_hwinfo *hw = rvu->hw;
 	int blkaddr, ucast_idx, index;
-	u8 mac_addr[ETH_ALEN] = { 0 };
 	struct nix_rx_action action;
 	u64 relaxed_mask;
 
-	/* Only PF or AF VF can add a promiscuous entry */
-	if ((pcifunc & RVU_PFVF_FUNC_MASK) && !is_afvf(pcifunc))
+	if (!hw->cap.nix_rx_multicast && is_cgx_vf(rvu, pcifunc))
 		return;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
 	if (blkaddr < 0)
 		return;
 
-	*(u64 *)&action = 0x00;
 	index = npc_get_nixlf_mcam_index(mcam, pcifunc,
 					 nixlf, NIXLF_PROMISC_ENTRY);
 
+	if (is_cgx_vf(rvu, pcifunc))
+		index = npc_get_nixlf_mcam_index(mcam,
+						 pcifunc & ~RVU_PFVF_FUNC_MASK,
+						 nixlf, NIXLF_PROMISC_ENTRY);
+
 	/* If the corresponding PF's ucast action is RSS,
 	 * use the same action for promisc also
 	 */
@@ -680,19 +695,20 @@ void rvu_npc_install_promisc_entry(struct rvu *rvu, u16 pcifunc,
 					     nixlf, NIXLF_UCAST_ENTRY);
 	if (is_mcam_entry_enabled(rvu, mcam, blkaddr, ucast_idx))
 		*(u64 *)&action = npc_get_mcam_action(rvu, mcam,
-							blkaddr, ucast_idx);
+						      blkaddr, ucast_idx);
 
 	if (action.op != NIX_RX_ACTIONOP_RSS) {
 		*(u64 *)&action = 0x00;
 		action.op = NIX_RX_ACTIONOP_UCAST;
-		action.pf_func = pcifunc;
 	}
 
-	if (allmulti) {
-		mac_addr[0] = 0x01;	/* LSB bit of 1st byte in DMAC */
-		ether_addr_copy(req.packet.dmac, mac_addr);
-		ether_addr_copy(req.mask.dmac, mac_addr);
-		req.features = BIT_ULL(NPC_DMAC);
+	/* RX_ACTION set to MCAST for CGX PF's */
+	if (hw->cap.nix_rx_multicast && pfvf->use_mce_list &&
+	    is_pf_cgxmapped(rvu, rvu_get_pf(pcifunc))) {
+		*(u64 *)&action = 0x00;
+		action.op = NIX_RX_ACTIONOP_MCAST;
+		pfvf = rvu_get_pfvf(rvu, pcifunc & ~RVU_PFVF_FUNC_MASK);
+		action.index = pfvf->promisc_mce_idx;
 	}
 
 	req.chan_mask = 0xFFFU;
@@ -720,8 +736,8 @@ void rvu_npc_install_promisc_entry(struct rvu *rvu, u16 pcifunc,
 	rvu_mbox_handler_npc_install_flow(rvu, &req, &rsp);
 }
 
-static void npc_enadis_promisc_entry(struct rvu *rvu, u16 pcifunc,
-				     int nixlf, bool enable)
+void rvu_npc_enable_promisc_entry(struct rvu *rvu, u16 pcifunc,
+				  int nixlf, bool enable)
 {
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	int blkaddr, index;
@@ -730,25 +746,14 @@ static void npc_enadis_promisc_entry(struct rvu *rvu, u16 pcifunc,
 	if (blkaddr < 0)
 		return;
 
-	/* Only PF's have a promiscuous entry */
-	if (pcifunc & RVU_PFVF_FUNC_MASK)
-		return;
+	/* Get 'pcifunc' of PF device */
+	pcifunc = pcifunc & ~RVU_PFVF_FUNC_MASK;
 
 	index = npc_get_nixlf_mcam_index(mcam, pcifunc,
 					 nixlf, NIXLF_PROMISC_ENTRY);
 	npc_enable_mcam_entry(rvu, mcam, blkaddr, index, enable);
 }
 
-void rvu_npc_disable_promisc_entry(struct rvu *rvu, u16 pcifunc, int nixlf)
-{
-	npc_enadis_promisc_entry(rvu, pcifunc, nixlf, false);
-}
-
-void rvu_npc_enable_promisc_entry(struct rvu *rvu, u16 pcifunc, int nixlf)
-{
-	npc_enadis_promisc_entry(rvu, pcifunc, nixlf, true);
-}
-
 void rvu_npc_install_bcast_match_entry(struct rvu *rvu, u16 pcifunc,
 				       int nixlf, u64 chan)
 {
@@ -758,8 +763,6 @@ void rvu_npc_install_bcast_match_entry(struct rvu *rvu, u16 pcifunc,
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	struct rvu_hwinfo *hw = rvu->hw;
 	int blkaddr, index;
-	u32 req_index = 0;
-	u8 op;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
 	if (blkaddr < 0)
@@ -772,7 +775,7 @@ void rvu_npc_install_bcast_match_entry(struct rvu *rvu, u16 pcifunc,
 	/* If pkt replication is not supported,
 	 * then only PF is allowed to add a bcast match entry.
 	 */
-	if (!hw->cap.nix_rx_multicast && pcifunc & RVU_PFVF_FUNC_MASK)
+	if (!hw->cap.nix_rx_multicast && is_vf(pcifunc))
 		return;
 
 	/* Get 'pcifunc' of PF device */
@@ -786,10 +789,10 @@ void rvu_npc_install_bcast_match_entry(struct rvu *rvu, u16 pcifunc,
 		 * so install entry with UCAST action, so that PF
 		 * receives all broadcast packets.
 		 */
-		op = NIX_RX_ACTIONOP_UCAST;
+		req.op = NIX_RX_ACTIONOP_UCAST;
 	} else {
-		op = NIX_RX_ACTIONOP_MCAST;
-		req_index = pfvf->bcast_mce_idx;
+		req.op = NIX_RX_ACTIONOP_MCAST;
+		req.index = pfvf->bcast_mce_idx;
 	}
 
 	eth_broadcast_addr((u8 *)&req.packet.dmac);
@@ -798,15 +801,110 @@ void rvu_npc_install_bcast_match_entry(struct rvu *rvu, u16 pcifunc,
 	req.channel = chan;
 	req.intf = pfvf->nix_rx_intf;
 	req.entry = index;
-	req.op = op;
 	req.hdr.pcifunc = 0; /* AF is requester */
 	req.vf = pcifunc;
-	req.index = req_index;
 
 	rvu_mbox_handler_npc_install_flow(rvu, &req, &rsp);
 }
 
-void rvu_npc_enable_bcast_entry(struct rvu *rvu, u16 pcifunc, bool enable)
+void rvu_npc_enable_bcast_entry(struct rvu *rvu, u16 pcifunc, int nixlf,
+				bool enable)
+{
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	int blkaddr, index;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+	if (blkaddr < 0)
+		return;
+
+	/* Get 'pcifunc' of PF device */
+	pcifunc = pcifunc & ~RVU_PFVF_FUNC_MASK;
+
+	index = npc_get_nixlf_mcam_index(mcam, pcifunc, nixlf,
+					 NIXLF_BCAST_ENTRY);
+	npc_enable_mcam_entry(rvu, mcam, blkaddr, index, enable);
+}
+
+void rvu_npc_install_allmulti_entry(struct rvu *rvu, u16 pcifunc, int nixlf,
+				    u64 chan)
+{
+	struct npc_install_flow_req req = { 0 };
+	struct npc_install_flow_rsp rsp = { 0 };
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	struct rvu_hwinfo *hw = rvu->hw;
+	int blkaddr, ucast_idx, index;
+	u8 mac_addr[ETH_ALEN] = { 0 };
+	struct nix_rx_action action;
+	struct rvu_pfvf *pfvf;
+	u16 vf_func;
+
+	/* Only CGX PF/VF can add allmulticast entry */
+	if (is_afvf(pcifunc))
+		return;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+	if (blkaddr < 0)
+		return;
+
+	/* Get 'pcifunc' of PF device */
+	vf_func = pcifunc & RVU_PFVF_FUNC_MASK;
+	pcifunc = pcifunc & ~RVU_PFVF_FUNC_MASK;
+	pfvf = rvu_get_pfvf(rvu, pcifunc);
+	index = npc_get_nixlf_mcam_index(mcam, pcifunc,
+					 nixlf, NIXLF_ALLMULTI_ENTRY);
+
+	/* If the corresponding PF's ucast action is RSS,
+	 * use the same action for multicast entry also
+	 */
+	ucast_idx = npc_get_nixlf_mcam_index(mcam, pcifunc,
+					     nixlf, NIXLF_UCAST_ENTRY);
+	if (is_mcam_entry_enabled(rvu, mcam, blkaddr, ucast_idx))
+		*(u64 *)&action = npc_get_mcam_action(rvu, mcam,
+							blkaddr, ucast_idx);
+
+	if (action.op != NIX_RX_ACTIONOP_RSS) {
+		*(u64 *)&action = 0x00;
+		action.op = NIX_RX_ACTIONOP_UCAST;
+		action.pf_func = pcifunc;
+	}
+
+	/* RX_ACTION set to MCAST for CGX PF's */
+	if (hw->cap.nix_rx_multicast && pfvf->use_mce_list) {
+		*(u64 *)&action = 0x00;
+		action.op = NIX_RX_ACTIONOP_MCAST;
+		action.index = pfvf->mcast_mce_idx;
+	}
+
+	mac_addr[0] = 0x01;	/* LSB bit of 1st byte in DMAC */
+	ether_addr_copy(req.packet.dmac, mac_addr);
+	ether_addr_copy(req.mask.dmac, mac_addr);
+	req.features = BIT_ULL(NPC_DMAC);
+
+	/* For cn10k the upper two bits of the channel number are
+	 * cpt channel number. with masking out these bits in the
+	 * mcam entry, same entry used for NIX will allow packets
+	 * received from cpt for parsing.
+	 */
+	if (!is_rvu_otx2(rvu))
+		req.chan_mask = NIX_CHAN_CPT_X2P_MASK;
+	else
+		req.chan_mask = 0xFFFU;
+
+	req.channel = chan;
+	req.intf = pfvf->nix_rx_intf;
+	req.entry = index;
+	req.op = action.op;
+	req.hdr.pcifunc = 0; /* AF is requester */
+	req.vf = pcifunc | vf_func;
+	req.index = action.index;
+	req.match_id = action.match_id;
+	req.flow_key_alg = action.flow_key_alg;
+
+	rvu_mbox_handler_npc_install_flow(rvu, &req, &rsp);
+}
+
+void rvu_npc_enable_allmulti_entry(struct rvu *rvu, u16 pcifunc, int nixlf,
+				   bool enable)
 {
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	int blkaddr, index;
@@ -818,7 +916,8 @@ void rvu_npc_enable_bcast_entry(struct rvu *rvu, u16 pcifunc, bool enable)
 	/* Get 'pcifunc' of PF device */
 	pcifunc = pcifunc & ~RVU_PFVF_FUNC_MASK;
 
-	index = npc_get_nixlf_mcam_index(mcam, pcifunc, 0, NIXLF_BCAST_ENTRY);
+	index = npc_get_nixlf_mcam_index(mcam, pcifunc, nixlf,
+					 NIXLF_ALLMULTI_ENTRY);
 	npc_enable_mcam_entry(rvu, mcam, blkaddr, index, enable);
 }
 
@@ -860,6 +959,7 @@ void rvu_npc_update_flowkey_alg_idx(struct rvu *rvu, u16 pcifunc, int nixlf,
 				    int group, int alg_idx, int mcam_index)
 {
 	struct npc_mcam *mcam = &rvu->hw->mcam;
+	struct rvu_hwinfo *hw = rvu->hw;
 	struct nix_rx_action action;
 	int blkaddr, index, bank;
 	struct rvu_pfvf *pfvf;
@@ -915,7 +1015,8 @@ void rvu_npc_update_flowkey_alg_idx(struct rvu *rvu, u16 pcifunc, int nixlf,
 	/* If PF's promiscuous entry is enabled,
 	 * Set RSS action for that entry as well
 	 */
-	if (is_mcam_entry_enabled(rvu, mcam, blkaddr, index)) {
+	if ((!hw->cap.nix_rx_multicast || !pfvf->use_mce_list) &&
+	    is_mcam_entry_enabled(rvu, mcam, blkaddr, index)) {
 		bank = npc_get_bank(mcam, index);
 		index &= (mcam->banksize - 1);
 
@@ -925,12 +1026,47 @@ void rvu_npc_update_flowkey_alg_idx(struct rvu *rvu, u16 pcifunc, int nixlf,
 	}
 }
 
+void npc_enadis_default_mce_entry(struct rvu *rvu, u16 pcifunc,
+				  int nixlf, int type, bool enable)
+{
+	struct npc_mcam *mcam = &rvu->hw->mcam;
+	struct rvu_hwinfo *hw = rvu->hw;
+	struct nix_mce_list *mce_list;
+	int index, blkaddr, mce_idx;
+	struct rvu_pfvf *pfvf;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
+	if (blkaddr < 0)
+		return;
+
+	index = npc_get_nixlf_mcam_index(mcam, pcifunc & ~RVU_PFVF_FUNC_MASK,
+					 nixlf, type);
+
+	/* disable MCAM entry when packet replication is not supported by hw */
+	if (!hw->cap.nix_rx_multicast && !is_vf(pcifunc)) {
+		npc_enable_mcam_entry(rvu, mcam, blkaddr, index, enable);
+		return;
+	}
+
+	/* return incase mce list is not enabled */
+	pfvf = rvu_get_pfvf(rvu, pcifunc & ~RVU_PFVF_FUNC_MASK);
+	if (hw->cap.nix_rx_multicast && is_vf(pcifunc) &&
+	    type != NIXLF_BCAST_ENTRY && !pfvf->use_mce_list)
+		return;
+
+	nix_get_mce_list(rvu, pcifunc, type, &mce_list, &mce_idx);
+
+	nix_update_mce_list(rvu, pcifunc, mce_list,
+			    mce_idx, index, enable);
+	if (enable)
+		npc_enable_mcam_entry(rvu, mcam, blkaddr, index, enable);
+}
+
 static void npc_enadis_default_entries(struct rvu *rvu, u16 pcifunc,
 				       int nixlf, bool enable)
 {
 	struct npc_mcam *mcam = &rvu->hw->mcam;
-	struct nix_rx_action action;
-	int index, bank, blkaddr;
+	int index, blkaddr;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
 	if (blkaddr < 0)
@@ -941,48 +1077,33 @@ static void npc_enadis_default_entries(struct rvu *rvu, u16 pcifunc,
 					 nixlf, NIXLF_UCAST_ENTRY);
 	npc_enable_mcam_entry(rvu, mcam, blkaddr, index, enable);
 
-	/* For PF, ena/dis promisc and bcast MCAM match entries.
-	 * For VFs add/delete from bcast list when RX multicast
-	 * feature is present.
+	/* Nothing to do for VFs, on platforms where pkt replication
+	 * is not supported
 	 */
-	if (pcifunc & RVU_PFVF_FUNC_MASK && !rvu->hw->cap.nix_rx_multicast)
+	if ((pcifunc & RVU_PFVF_FUNC_MASK) && !rvu->hw->cap.nix_rx_multicast)
 		return;
 
-	/* For bcast, enable/disable only if it's action is not
-	 * packet replication, incase if action is replication
-	 * then this PF/VF's nixlf is removed from bcast replication
-	 * list.
-	 */
-	index = npc_get_nixlf_mcam_index(mcam, pcifunc & ~RVU_PFVF_FUNC_MASK,
-					 nixlf, NIXLF_BCAST_ENTRY);
-	bank = npc_get_bank(mcam, index);
-	*(u64 *)&action = rvu_read64(rvu, blkaddr,
-	     NPC_AF_MCAMEX_BANKX_ACTION(index & (mcam->banksize - 1), bank));
-
-	/* VFs will not have BCAST entry */
-	if (action.op != NIX_RX_ACTIONOP_MCAST &&
-	    !(pcifunc & RVU_PFVF_FUNC_MASK)) {
-		npc_enable_mcam_entry(rvu, mcam,
-				      blkaddr, index, enable);
-	} else {
-		nix_update_bcast_mce_list(rvu, pcifunc, enable);
-		/* Enable PF's BCAST entry for packet replication */
-		rvu_npc_enable_bcast_entry(rvu, pcifunc, enable);
-	}
-
-	if (enable)
-		rvu_npc_enable_promisc_entry(rvu, pcifunc, nixlf);
-	else
-		rvu_npc_disable_promisc_entry(rvu, pcifunc, nixlf);
+	/* add/delete pf_func to broadcast MCE list */
+	npc_enadis_default_mce_entry(rvu, pcifunc, nixlf,
+				     NIXLF_BCAST_ENTRY, enable);
 }
 
 void rvu_npc_disable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 {
 	npc_enadis_default_entries(rvu, pcifunc, nixlf, false);
+
+	/* Delete multicast and promisc MCAM entries */
+	npc_enadis_default_mce_entry(rvu, pcifunc, nixlf,
+				     NIXLF_ALLMULTI_ENTRY, false);
+	npc_enadis_default_mce_entry(rvu, pcifunc, nixlf,
+				     NIXLF_PROMISC_ENTRY, false);
 }
 
 void rvu_npc_enable_default_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 {
+	/* Enables only broadcast match entry. Promisc/Allmulti are enabled
+	 * in set_rx_mode mbox handler.
+	 */
 	npc_enadis_default_entries(rvu, pcifunc, nixlf, true);
 }
 
@@ -1002,7 +1123,8 @@ void rvu_npc_disable_mcam_entries(struct rvu *rvu, u16 pcifunc, int nixlf)
 	/* Disable MCAM entries directing traffic to this 'pcifunc' */
 	list_for_each_entry_safe(rule, tmp, &mcam->mcam_rules, list) {
 		if (is_npc_intf_rx(rule->intf) &&
-		    rule->rx_action.pf_func == pcifunc) {
+		    rule->rx_action.pf_func == pcifunc &&
+		    rule->rx_action.op != NIX_RX_ACTIONOP_MCAST) {
 			npc_enable_mcam_entry(rvu, mcam, blkaddr,
 					      rule->entry, false);
 			rule->enable = false;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 7f35b62eea13..bc37858c6a14 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -1177,9 +1177,12 @@ int rvu_mbox_handler_npc_install_flow(struct rvu *rvu,
 	}
 
 	err = nix_get_nixlf(rvu, target, &nixlf, NULL);
+	if (err)
+		return -EINVAL;
 
-	/* If interface is uninitialized then do not enable entry */
-	if (err || (!req->default_rule && !pfvf->def_ucast_rule))
+	/* don't enable rule when nixlf not attached or initialized */
+	if (!(is_nixlf_attached(rvu, target) &&
+	      test_bit(NIXLF_INITIALIZED, &pfvf->flags)))
 		enable = false;
 
 	/* Packets reaching NPC in Tx path implies that a
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 03004fdac0c6..dcc6b74471e3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1820,9 +1820,11 @@ static void otx2_do_set_rx_mode(struct work_struct *work)
 
 	if (promisc)
 		req->mode |= NIX_RX_MODE_PROMISC;
-	else if (netdev->flags & (IFF_ALLMULTI | IFF_MULTICAST))
+	if (netdev->flags & (IFF_ALLMULTI | IFF_MULTICAST))
 		req->mode |= NIX_RX_MODE_ALLMULTI;
 
+	req->mode |= NIX_RX_MODE_USE_MCE;
+
 	otx2_sync_mbox_msg(&pf->mbox);
 	mutex_unlock(&pf->mbox.lock);
 }
-- 
2.16.5

