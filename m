Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B90030A18B
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 06:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbhBAFoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 00:44:13 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:27420 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231516AbhBAFZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 00:25:59 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1115L9sq004730;
        Sun, 31 Jan 2021 21:25:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=gxObuIN20IA5RmhAXnvBwpenURL0+QKOpjEzjaAAeUA=;
 b=ksw8iw3D4r/W3qVlXZPiFDF2VTyaieY+P3M36k1Xs237JzvUrpFE25fo18mwEXxPiKpt
 U8lsROt324e3l88oPOWSkW3SOAPSHSldlWj5fT1jvVpqMn6clGkZlSh27Du9VuWtDyGN
 swdEPXA0mFiu/Y7qsZch8z6h3Ko75IigCsD18CWNc9xA1Hy+Si3WY6YNlvu7n3pPnaba
 A8/Sefluj/rjEmHyFiwTrnpvD6vNGwJkNuoRPGHe78WlieTz0W4QWKM5Edz9jbGn7kjT
 cs642ueYfjcnoqjxLgica5wFEXGnjKa4GvjIdAfQYM5K2G8mMBogn5LI3kBriKmrdOeu nw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36d7uq2s4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 21:25:03 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 21:25:01 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 21:25:01 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 31 Jan 2021 21:25:01 -0800
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id B38693F703F;
        Sun, 31 Jan 2021 21:24:57 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [Patch v3 net-next 3/7] octeontx2-pf: ethtool fec mode support
Date:   Mon, 1 Feb 2021 10:54:40 +0530
Message-ID: <1612157084-101715-4-git-send-email-hkelam@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612157084-101715-1-git-send-email-hkelam@marvell.com>
References: <1612157084-101715-1-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-01_02:2021-01-29,2021-02-01 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christina Jacob <cjacob@marvell.com>

Add ethtool support to configure fec modes baser/rs and
support to fecth FEC stats from CGX as well PHY.

Configure fec mode
	- ethtool --set-fec eth0 encoding rs/baser/off/auto
Query fec mode
	- ethtool --show-fec eth0

Signed-off-by: Christina Jacob <cjacob@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  20 +++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   6 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 181 ++++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   3 +
 4 files changed, 208 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 5ddedc3..1e67072 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -60,6 +60,19 @@ void otx2_update_lmac_stats(struct otx2_nic *pfvf)
 	mutex_unlock(&pfvf->mbox.lock);
 }
 
+void otx2_update_lmac_fec_stats(struct otx2_nic *pfvf)
+{
+	struct msg_req *req;
+
+	if (!netif_running(pfvf->netdev))
+		return;
+	mutex_lock(&pfvf->mbox.lock);
+	req = otx2_mbox_alloc_msg_cgx_fec_stats(&pfvf->mbox);
+	if (req)
+		otx2_sync_mbox_msg(&pfvf->mbox);
+	mutex_unlock(&pfvf->mbox.lock);
+}
+
 int otx2_update_rq_stats(struct otx2_nic *pfvf, int qidx)
 {
 	struct otx2_rcv_queue *rq = &pfvf->qset.rq[qidx];
@@ -1492,6 +1505,13 @@ void mbox_handler_cgx_stats(struct otx2_nic *pfvf,
 		pfvf->hw.cgx_tx_stats[id] = rsp->tx_stats[id];
 }
 
+void mbox_handler_cgx_fec_stats(struct otx2_nic *pfvf,
+				struct cgx_fec_stats_rsp *rsp)
+{
+	pfvf->hw.cgx_fec_corr_blks += rsp->fec_corr_blks;
+	pfvf->hw.cgx_fec_uncorr_blks += rsp->fec_uncorr_blks;
+}
+
 void mbox_handler_nix_txsch_alloc(struct otx2_nic *pf,
 				  struct nix_txsch_alloc_rsp *rsp)
 {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 143ae04..b3f3de9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -204,6 +204,8 @@ struct otx2_hw {
 	struct otx2_drv_stats	drv_stats;
 	u64			cgx_rx_stats[CGX_RX_STATS_COUNT];
 	u64			cgx_tx_stats[CGX_TX_STATS_COUNT];
+	u64			cgx_fec_corr_blks;
+	u64			cgx_fec_uncorr_blks;
 	u8			cgx_links;  /* No. of CGX links present in HW */
 	u8			lbk_links;  /* No. of LBK links present in HW */
 };
@@ -660,6 +662,9 @@ void mbox_handler_nix_txsch_alloc(struct otx2_nic *pf,
 				  struct nix_txsch_alloc_rsp *rsp);
 void mbox_handler_cgx_stats(struct otx2_nic *pfvf,
 			    struct cgx_stats_rsp *rsp);
+void mbox_handler_cgx_fec_stats(struct otx2_nic *pfvf,
+				struct cgx_fec_stats_rsp *rsp);
+void otx2_set_fec_stats_count(struct otx2_nic *pfvf);
 void mbox_handler_nix_bp_enable(struct otx2_nic *pfvf,
 				struct nix_bp_cfg_rsp *rsp);
 
@@ -668,6 +673,7 @@ void otx2_get_dev_stats(struct otx2_nic *pfvf);
 void otx2_get_stats64(struct net_device *netdev,
 		      struct rtnl_link_stats64 *stats);
 void otx2_update_lmac_stats(struct otx2_nic *pfvf);
+void otx2_update_lmac_fec_stats(struct otx2_nic *pfvf);
 int otx2_update_rq_stats(struct otx2_nic *pfvf, int qidx);
 int otx2_update_sq_stats(struct otx2_nic *pfvf, int qidx);
 void otx2_set_ethtool_ops(struct net_device *netdev);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index e0199f0..e5b1a57 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -66,6 +66,8 @@ static const unsigned int otx2_n_dev_stats = ARRAY_SIZE(otx2_dev_stats);
 static const unsigned int otx2_n_drv_stats = ARRAY_SIZE(otx2_drv_stats);
 static const unsigned int otx2_n_queue_stats = ARRAY_SIZE(otx2_queue_stats);
 
+static struct cgx_fw_data *otx2_get_fwdata(struct otx2_nic *pfvf);
+
 static void otx2_get_drvinfo(struct net_device *netdev,
 			     struct ethtool_drvinfo *info)
 {
@@ -128,6 +130,12 @@ static void otx2_get_strings(struct net_device *netdev, u32 sset, u8 *data)
 
 	strcpy(data, "reset_count");
 	data += ETH_GSTRING_LEN;
+	if (pfvf->linfo.fec) {
+		sprintf(data, "Fec Corrected Errors: ");
+		data += ETH_GSTRING_LEN;
+		sprintf(data, "Fec Uncorrected Errors: ");
+		data += ETH_GSTRING_LEN;
+	}
 }
 
 static void otx2_get_qset_stats(struct otx2_nic *pfvf,
@@ -160,11 +168,30 @@ static void otx2_get_qset_stats(struct otx2_nic *pfvf,
 	}
 }
 
+static int otx2_get_phy_fec_stats(struct otx2_nic *pfvf)
+{
+	struct msg_req *req;
+	int rc = -ENOMEM;
+
+	mutex_lock(&pfvf->mbox.lock);
+	req = otx2_mbox_alloc_msg_cgx_get_phy_fec_stats(&pfvf->mbox);
+	if (!req)
+		goto end;
+
+	if (!otx2_sync_mbox_msg(&pfvf->mbox))
+		rc = 0;
+end:
+	mutex_unlock(&pfvf->mbox.lock);
+	return rc;
+}
+
 /* Get device and per queue statistics */
 static void otx2_get_ethtool_stats(struct net_device *netdev,
 				   struct ethtool_stats *stats, u64 *data)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
+	u64 fec_corr_blks, fec_uncorr_blks;
+	struct cgx_fw_data *rsp;
 	int stat;
 
 	otx2_get_dev_stats(pfvf);
@@ -183,12 +210,43 @@ static void otx2_get_ethtool_stats(struct net_device *netdev,
 	for (stat = 0; stat < CGX_TX_STATS_COUNT; stat++)
 		*(data++) = pfvf->hw.cgx_tx_stats[stat];
 	*(data++) = pfvf->reset_count;
+
+	/* Do not request fec stats if interface fec mode is none */
+	if (pfvf->linfo.fec == OTX2_FEC_NONE)
+		return;
+
+	fec_corr_blks = pfvf->hw.cgx_fec_corr_blks;
+	fec_uncorr_blks = pfvf->hw.cgx_fec_uncorr_blks;
+
+	rsp = otx2_get_fwdata(pfvf);
+	if (!IS_ERR(rsp) && rsp->fwdata.phy.misc.has_fec_stats &&
+	    !otx2_get_phy_fec_stats(pfvf)) {
+		/* Fetch fwdata again because it's been recently populated with
+		 * latest PHY FEC stats.
+		 */
+		rsp = otx2_get_fwdata(pfvf);
+		if (!IS_ERR(rsp)) {
+			struct fec_stats_s *p = &rsp->fwdata.phy.fec_stats;
+
+			if (pfvf->linfo.fec == OTX2_FEC_BASER) {
+				fec_corr_blks   = p->brfec_corr_blks;
+				fec_uncorr_blks = p->brfec_uncorr_blks;
+			} else {
+				fec_corr_blks   = p->rsfec_corr_cws;
+				fec_uncorr_blks = p->rsfec_uncorr_cws;
+			}
+		}
+	}
+
+	*(data++) = fec_corr_blks;
+	*(data++) = fec_uncorr_blks;
 }
 
 static int otx2_get_sset_count(struct net_device *netdev, int sset)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
-	int qstats_count;
+	int qstats_count, fec_stats_count = 0;
+	bool if_up = netif_running(netdev);
 
 	if (sset != ETH_SS_STATS)
 		return -EINVAL;
@@ -196,8 +254,16 @@ static int otx2_get_sset_count(struct net_device *netdev, int sset)
 	qstats_count = otx2_n_queue_stats *
 		       (pfvf->hw.rx_queues + pfvf->hw.tx_queues);
 
+	/* Do not show fec stats if interface fec mode is none */
+	if (!if_up || !pfvf->linfo.fec)
+		return otx2_n_dev_stats + otx2_n_drv_stats + qstats_count +
+			CGX_RX_STATS_COUNT + CGX_TX_STATS_COUNT + 1;
+
+	fec_stats_count = 2;
+	otx2_update_lmac_fec_stats(pfvf);
+
 	return otx2_n_dev_stats + otx2_n_drv_stats + qstats_count +
-		CGX_RX_STATS_COUNT + CGX_TX_STATS_COUNT + 1;
+	       CGX_RX_STATS_COUNT + CGX_TX_STATS_COUNT + 1 + fec_stats_count;
 }
 
 /* Get no of queues device supports and current queue count */
@@ -859,6 +925,115 @@ static int otx2_get_ts_info(struct net_device *netdev,
 	return 0;
 }
 
+static struct cgx_fw_data *otx2_get_fwdata(struct otx2_nic *pfvf)
+{
+	struct cgx_fw_data *rsp = NULL;
+	struct msg_req *req;
+	int err = 0;
+
+	mutex_lock(&pfvf->mbox.lock);
+	req = otx2_mbox_alloc_msg_cgx_get_aux_link_info(&pfvf->mbox);
+	if (!req) {
+		mutex_unlock(&pfvf->mbox.lock);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (!err) {
+		rsp = (struct cgx_fw_data *)
+			otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
+	} else {
+		rsp = ERR_PTR(err);
+	}
+
+	mutex_unlock(&pfvf->mbox.lock);
+	return rsp;
+}
+
+static int otx2_get_fecparam(struct net_device *netdev,
+			     struct ethtool_fecparam *fecparam)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	struct cgx_fw_data *rsp;
+	const int fec[] = {
+		ETHTOOL_FEC_OFF,
+		ETHTOOL_FEC_BASER,
+		ETHTOOL_FEC_RS,
+		ETHTOOL_FEC_BASER | ETHTOOL_FEC_RS};
+#define FEC_MAX_INDEX 3
+	if (pfvf->linfo.fec < FEC_MAX_INDEX)
+		fecparam->active_fec = fec[pfvf->linfo.fec];
+
+	rsp = otx2_get_fwdata(pfvf);
+	if (IS_ERR(rsp))
+		return PTR_ERR(rsp);
+
+	if (rsp->fwdata.supported_fec <= FEC_MAX_INDEX) {
+		if (!rsp->fwdata.supported_fec)
+			fecparam->fec = ETHTOOL_FEC_NONE;
+		else
+			fecparam->fec = fec[rsp->fwdata.supported_fec];
+	}
+	return 0;
+}
+
+static int otx2_set_fecparam(struct net_device *netdev,
+			     struct ethtool_fecparam *fecparam)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	struct mbox *mbox = &pfvf->mbox;
+	struct fec_mode *req, *rsp;
+	int err = 0, fec = 0;
+
+	switch (fecparam->fec) {
+	/* Firmware does not support AUTO mode consider it as FEC_NONE */
+	case ETHTOOL_FEC_OFF:
+	case ETHTOOL_FEC_AUTO:
+	case ETHTOOL_FEC_NONE:
+		fec = OTX2_FEC_NONE;
+		break;
+	case ETHTOOL_FEC_RS:
+		fec = OTX2_FEC_RS;
+		break;
+	case ETHTOOL_FEC_BASER:
+		fec = OTX2_FEC_BASER;
+		break;
+	default:
+		netdev_warn(pfvf->netdev, "Unsupported FEC mode: %d",
+			    fecparam->fec);
+		return -EINVAL;
+	}
+
+	if (fec == pfvf->linfo.fec)
+		return 0;
+
+	mutex_lock(&mbox->lock);
+	req = otx2_mbox_alloc_msg_cgx_set_fec_param(&pfvf->mbox);
+	if (!req) {
+		err = -ENOMEM;
+		goto end;
+	}
+	req->fec = fec;
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (err)
+		goto end;
+
+	rsp = (struct fec_mode *)otx2_mbox_get_rsp(&pfvf->mbox.mbox,
+						   0, &req->hdr);
+	if (rsp->fec >= 0) {
+		pfvf->linfo.fec = rsp->fec;
+		/* clear stale counters */
+		pfvf->hw.cgx_fec_corr_blks = 0;
+		pfvf->hw.cgx_fec_uncorr_blks = 0;
+	} else {
+		err = rsp->fec;
+	}
+
+end:
+	mutex_unlock(&mbox->lock);
+	return err;
+}
+
 static const struct ethtool_ops otx2_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES,
@@ -886,6 +1061,8 @@ static const struct ethtool_ops otx2_ethtool_ops = {
 	.get_pauseparam		= otx2_get_pauseparam,
 	.set_pauseparam		= otx2_set_pauseparam,
 	.get_ts_info		= otx2_get_ts_info,
+	.get_fecparam		= otx2_get_fecparam,
+	.set_fecparam		= otx2_set_fecparam,
 };
 
 void otx2_set_ethtool_ops(struct net_device *netdev)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 07ec85a..d024dac 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -779,6 +779,9 @@ static void otx2_process_pfaf_mbox_msg(struct otx2_nic *pf,
 	case MBOX_MSG_CGX_STATS:
 		mbox_handler_cgx_stats(pf, (struct cgx_stats_rsp *)msg);
 		break;
+	case MBOX_MSG_CGX_FEC_STATS:
+		mbox_handler_cgx_fec_stats(pf, (struct cgx_fec_stats_rsp *)msg);
+		break;
 	default:
 		if (msg->rc)
 			dev_err(pf->dev,
-- 
2.7.4

