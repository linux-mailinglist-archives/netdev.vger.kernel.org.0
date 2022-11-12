Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E8C6266EE
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 05:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234648AbiKLEcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 23:32:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234522AbiKLEcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 23:32:19 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F1D5EFA0;
        Fri, 11 Nov 2022 20:32:12 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AC1FslV018944;
        Fri, 11 Nov 2022 20:32:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=KTMzrC1koVIxKxxPb0waus5v7F2HXLK5qZ3CQT8Kla0=;
 b=PRAM065MsAEvKEcfkYHkN4LG8Use6rmi3CdcIQRSe1F2x5zEJ9fNi15Ba31xR72R3+8+
 E3OsC1FjGG2kx/ccDxh7j9v9tLw88erck3tbwhopbswteiKIYim18iuEm8kV3dFxbetZ
 smSsq/yBcl84aU/cUkTPeAFmRNd59T65bYAceqO9cYNC3PLc8HgFgUW5Fj8acGHb1vmA
 Y2i7x94VTOsM0wO9V4OVl2CzDG2anFAIc0dIf2EteL95hjg8G2bGi2TwKk+EAmsqTsWZ
 EumfSVsSA5Cl2ebqBcfA3oE5LWxj7YxGdgYFjJSADzdcTvd1M5AljtQjPxbhB26Fw4so lg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3kt1nv0bee-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 20:32:04 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 11 Nov
 2022 20:32:02 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 11 Nov 2022 20:32:02 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id E90E23F7043;
        Fri, 11 Nov 2022 20:31:58 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>
Subject: [net-next PATCH 4/9] octeontx2-af: Show count of dropped packets by DMAC filters
Date:   Sat, 12 Nov 2022 10:01:36 +0530
Message-ID: <20221112043141.13291-5-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221112043141.13291-1-hkelam@marvell.com>
References: <20221112043141.13291-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: R2a65ela5Vbmcai38qUbuoO68pufSVpU
X-Proofpoint-GUID: R2a65ela5Vbmcai38qUbuoO68pufSVpU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-12_02,2022-11-11_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current mac_filter debugfs file only shows list of DMAC entries
added to CGX/RPM DMAC table, added count of packets dropped by CGX/RPM
due to DMAC filters.

Output of mac_filter file

PCI dev       RVUPF   BROADCAST  MULTICAST  FILTER-MODE
0002:03:00.0  PF2     ACCEPT     ACCEPT     UNICAST

DMAC-INDEX  ADDRESS
      0     6a:4e:f1:10:34:0f
      1     1a:1b:1c:1d:1e:1f

DMAC filter drop count: 4

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c  | 13 ++++++++++++-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h  |  2 ++
 .../ethernet/marvell/octeontx2/af/lmac_common.h  |  1 +
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c  | 16 ++++++++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/rpm.h  |  3 ++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h  |  1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c  | 15 +++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c  |  3 +++
 8 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index f6ab85f01ee7..942ad87905e9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -701,6 +701,16 @@ int cgx_get_tx_stats(void *cgxd, int lmac_id, int idx, u64 *tx_stat)
 	return 0;
 }
 
+u64 cgx_get_dmacflt_dropped_pktcnt(void *cgxd, int lmac_id)
+{
+	struct cgx *cgx = cgxd;
+
+	if (!is_lmac_valid(cgx, lmac_id))
+		return 0;
+
+	return cgx_read(cgx, lmac_id, CGXX_CMRX_RX_STAT4);
+}
+
 u64 cgx_features_get(void *cgxd)
 {
 	return ((struct cgx *)cgxd)->hw_features;
@@ -1773,7 +1783,8 @@ static struct mac_ops	cgx_mac_ops    = {
 	.mac_tx_enable =		cgx_lmac_tx_enable,
 	.pfc_config =                   cgx_lmac_pfc_config,
 	.mac_get_pfc_frm_cfg   =        cgx_lmac_get_pfc_frm_cfg,
-	.mac_reset   =        cgx_lmac_reset,
+	.mac_reset                       =      cgx_lmac_reset,
+	.get_dmacflt_dropped_pktcnt      =      cgx_get_dmacflt_dropped_pktcnt,
 };
 
 static int cgx_probe(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index 9273b96f68d2..2bdf6de244c3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -36,6 +36,7 @@
 #define CGXX_CMRX_INT_ENA_W1S		0x058
 #define CGXX_CMRX_RX_ID_MAP		0x060
 #define CGXX_CMRX_RX_STAT0		0x070
+#define CGXX_CMRX_RX_STAT4		0x090
 #define CGXX_CMRX_RX_LOGL_XON		0x100
 #define CGXX_CMRX_RX_LMACS		0x128
 #define CGXX_CMRX_RX_DMAC_CTL0		(0x1F8 + mac_ops->csr_offset)
@@ -184,4 +185,5 @@ int cgx_lmac_get_pfc_frm_cfg(void *cgxd, int lmac_id, u8 *tx_pause,
 int verify_lmac_fc_cfg(void *cgxd, int lmac_id, u8 tx_pause, u8 rx_pause,
 		       int pfvf_idx);
 int cgx_lmac_reset(void *cgxd, int lmac_id);
+u64 cgx_get_dmacflt_dropped_pktcnt(void *cgx, int lmac_id);
 #endif /* CGX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
index 152c50bf6d1e..18b03940b34b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
@@ -126,6 +126,7 @@ struct mac_ops {
 	int                     (*mac_get_pfc_frm_cfg)(void *cgxd, int lmac_id,
 						       u8 *tx_pause, u8 *rx_pause);
 	int			(*mac_reset)(void *cgxd, int lmac_id);
+	u64			(*get_dmacflt_dropped_pktcnt)(void *cgxd, int lmac_id);
 
 };
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index d40aca0940bf..641d82000768 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -37,6 +37,7 @@ static struct mac_ops		rpm_mac_ops   = {
 	.pfc_config =                   rpm_lmac_pfc_config,
 	.mac_get_pfc_frm_cfg   =        rpm_lmac_get_pfc_frm_cfg,
 	.mac_reset             =        rpm_lmac_reset,
+	.get_dmacflt_dropped_pktcnt =   rpm_get_dmacflt_dropped_pktcnt,
 };
 
 static struct mac_ops		rpm2_mac_ops   = {
@@ -68,6 +69,7 @@ static struct mac_ops		rpm2_mac_ops   = {
 	.pfc_config =                   rpm_lmac_pfc_config,
 	.mac_get_pfc_frm_cfg   =        rpm_lmac_get_pfc_frm_cfg,
 	.mac_reset	       =        rpm_lmac_reset,
+	.get_dmacflt_dropped_pktcnt =   rpm_get_dmacflt_dropped_pktcnt,
 };
 
 bool is_dev_rpm2(void *rpmd)
@@ -434,6 +436,20 @@ int rpm_get_tx_stats(void *rpmd, int lmac_id, int idx, u64 *tx_stat)
 	return 0;
 }
 
+u64 rpm_get_dmacflt_dropped_pktcnt(void *rpmd, int lmac_id)
+{
+	rpm_t *rpm = rpmd;
+	u64 dmac_flt_stat;
+
+	if (!is_lmac_valid(rpm, lmac_id))
+		return 0;
+
+	dmac_flt_stat = is_dev_rpm2(rpm) ? RPM2_CMRX_RX_STAT2 :
+			RPMX_CMRX_RX_STAT2;
+
+	return rpm_read(rpm, lmac_id, dmac_flt_stat);
+}
+
 u8 rpm_get_lmac_type(void *rpmd, int lmac_id)
 {
 	rpm_t *rpm = rpmd;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
index 4b28b9879995..8ed2f9c9624b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
@@ -60,7 +60,7 @@
 #define RPMX_MTI_STAT_RX_STAT_PAGES_COUNTERX 0x12000
 #define RPMX_MTI_STAT_TX_STAT_PAGES_COUNTERX 0x13000
 #define RPMX_MTI_STAT_DATA_HI_CDC            0x10038
-
+#define RPMX_CMRX_RX_STAT2		     0x4010
 #define RPM_LMAC_FWI			0xa
 #define RPM_TX_EN			BIT_ULL(0)
 #define RPM_RX_EN			BIT_ULL(1)
@@ -111,6 +111,7 @@ int rpm_lmac_enadis_pause_frm(void *rpmd, int lmac_id, u8 tx_pause,
 			      u8 rx_pause);
 int rpm_get_tx_stats(void *rpmd, int lmac_id, int idx, u64 *tx_stat);
 int rpm_get_rx_stats(void *rpmd, int lmac_id, int idx, u64 *rx_stat);
+u64 rpm_get_dmacflt_dropped_pktcnt(void *rpmd, int lmac_id);
 void rpm_lmac_ptp_config(void *rpmd, int lmac_id, bool enable);
 int rpm_lmac_rx_tx_enable(void *rpmd, int lmac_id, bool enable);
 int rpm_lmac_tx_enable(void *rpmd, int lmac_id, bool enable);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 7423d50d99dd..7654c90f48df 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -848,6 +848,7 @@ int rvu_cgx_prio_flow_ctrl_cfg(struct rvu *rvu, u16 pcifunc, u8 tx_pause, u8 rx_
 			       u16 pfc_en);
 int rvu_cgx_cfg_pause_frm(struct rvu *rvu, u16 pcifunc, u8 tx_pause, u8 rx_pause);
 void rvu_mac_reset(struct rvu *rvu, u16 pcifunc);
+u64 rvu_cgx_get_dmacflt_dropped_pktcnt(void *cgxd, int lmac_id);
 u32 rvu_cgx_get_lmac_fifolen(struct rvu *rvu, int cgx, int lmac);
 int npc_get_nixlf_mcam_index(struct npc_mcam *mcam, u16 pcifunc, int nixlf,
 			     int type);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 3fa828feb6cd..3124aed1806f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -1264,3 +1264,18 @@ void rvu_mac_reset(struct rvu *rvu, u16 pcifunc)
 	if (mac_ops->mac_reset(cgxd, lmac))
 		dev_err(rvu->dev, "Failed to reset MAC\n");
 }
+
+u64 rvu_cgx_get_dmacflt_dropped_pktcnt(void *cgxd, int lmac_id)
+{
+	struct mac_ops *mac_ops;
+
+	if (!cgxd)
+		return 0;
+
+	mac_ops = get_mac_ops(cgxd);
+
+	if (!mac_ops->lmac_fifo_len)
+		return 0;
+
+	return mac_ops->get_dmacflt_dropped_pktcnt(cgxd, lmac_id);
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 4bd131ee9cc0..c5a0076b8082 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -2566,6 +2566,9 @@ static int cgx_print_dmac_flt(struct seq_file *s, int lmac_id)
 		}
 	}
 
+	seq_printf(s, "\nDMAC filter drop count: %lld\n",
+		   rvu_cgx_get_dmacflt_dropped_pktcnt(cgxd, lmac_id));
+
 	return 0;
 }
 
-- 
2.17.1

