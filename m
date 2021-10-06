Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52C7A4238B5
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 09:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237441AbhJFHVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 03:21:00 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57316 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236829AbhJFHU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 03:20:58 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19620stE030285;
        Wed, 6 Oct 2021 00:19:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=lsTPQJbq1BoWC63f6Z/OJhplQKO6S+lgfgJHE06Md1E=;
 b=XIxObnTuSfKmZSSDRYMPuW0Lz5dNznVJHKTbBkExZbU9U4u9mjXtpgsK/HjAhfucxwbV
 2ypEdo43/XOcwIauRK1FBC5lKC2L+cFCEF6jin0GoOoCAAeJxDl/xmRpPgyxZrpUh4o8
 x7ny/5+Sba7mpzZVgFXIRo/b2vq8DBBiDfvmCgWFeXLfbiFQ/zVx0R4ZIZuO/LtwkPYJ
 u1v5m1bIy1LdFDMkc4mxSuxA7j2nUcFvGT4n29zx7TCuEhuWEH/hnF+h4MNe7MXM6GnN
 SMpbmnmAkjwXWzyzi43GvrQMahbBJQnh2DVjrtmo2J1Y1wOjOjvhLmGD66dUPzpgHaHp 4w== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bgr1qkj8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 00:19:04 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 6 Oct
 2021 00:19:02 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 6 Oct 2021 00:19:02 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 8B6BC3F704C;
        Wed,  6 Oct 2021 00:19:00 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH v2 2/3] octeontx2-pf: Add devlink param to vary cqe size
Date:   Wed, 6 Oct 2021 12:48:45 +0530
Message-ID: <1633504726-30751-3-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1633504726-30751-1-git-send-email-sbhatta@marvell.com>
References: <1633504726-30751-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: SYh-PMQHljueHYNjaU4dTSFHtn80f_VU
X-Proofpoint-GUID: SYh-PMQHljueHYNjaU4dTSFHtn80f_VU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-05_06,2021-10-04_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Completion Queue Entry(CQE) is a descriptor written
by hardware to notify software about the send and
receive completion status. The CQE can be of size
128 or 512 bytes. A 512 bytes CQE can hold more receive
fragments pointers compared to 128 bytes CQE. This
patch adds devlink param to change CQE descriptor
size.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 10 +++-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  1 +
 .../ethernet/marvell/octeontx2/nic/otx2_devlink.c  | 56 ++++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  2 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |  2 +
 5 files changed, 69 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 66da31f..3777f41 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -222,8 +222,11 @@ EXPORT_SYMBOL(otx2_set_mac_address);
 int otx2_hw_set_mtu(struct otx2_nic *pfvf, int mtu)
 {
 	struct nix_frs_cfg *req;
+	u16 maxlen;
 	int err;
 
+	maxlen = otx2_get_max_mtu(pfvf) + OTX2_ETH_HLEN + OTX2_HW_TIMESTAMP_LEN;
+
 	mutex_lock(&pfvf->mbox.lock);
 	req = otx2_mbox_alloc_msg_nix_set_hw_frs(&pfvf->mbox);
 	if (!req) {
@@ -233,6 +236,9 @@ int otx2_hw_set_mtu(struct otx2_nic *pfvf, int mtu)
 
 	req->maxlen = pfvf->netdev->mtu + OTX2_ETH_HLEN + OTX2_HW_TIMESTAMP_LEN;
 
+	if (is_otx2_lbkvf(pfvf->pdev))
+		req->maxlen = maxlen;
+
 	err = otx2_sync_mbox_msg(&pfvf->mbox);
 	mutex_unlock(&pfvf->mbox.lock);
 	return err;
@@ -1036,7 +1042,7 @@ int otx2_config_nix(struct otx2_nic *pfvf)
 	struct nix_lf_alloc_rsp *rsp;
 	int err;
 
-	pfvf->qset.xqe_size = NIX_XQESZ_W16 ? 128 : 512;
+	pfvf->qset.xqe_size = pfvf->hw.xqe_size;
 
 	/* Get memory to put this msg */
 	nixlf = otx2_mbox_alloc_msg_nix_lf_alloc(&pfvf->mbox);
@@ -1049,7 +1055,7 @@ int otx2_config_nix(struct otx2_nic *pfvf)
 	nixlf->cq_cnt = pfvf->qset.cq_cnt;
 	nixlf->rss_sz = MAX_RSS_INDIR_TBL_SIZE;
 	nixlf->rss_grps = MAX_RSS_GROUPS;
-	nixlf->xqe_sz = NIX_XQESZ_W16;
+	nixlf->xqe_sz = pfvf->hw.xqe_size == 128 ? NIX_XQESZ_W16 : NIX_XQESZ_W64;
 	/* We don't know absolute NPA LF idx attached.
 	 * AF will replace 'RVU_DEFAULT_PF_FUNC' with
 	 * NPA LF attached to this RVU PF/VF.
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 61e5281..6e0d1ac 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -177,6 +177,7 @@ struct otx2_hw {
 	u16			pool_cnt;
 	u16			rqpool_cnt;
 	u16			sqpool_cnt;
+	u16			xqe_size;
 
 	/* NPA */
 	u32			stack_pg_ptrs;  /* No of ptrs per stack page */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
index 777a270..98450e1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
@@ -64,9 +64,60 @@ static int otx2_dl_mcam_count_get(struct devlink *devlink, u32 id,
 	return 0;
 }
 
+static int otx2_dl_cqe_size_validate(struct devlink *devlink, u32 id,
+				     union devlink_param_value val,
+				     struct netlink_ext_ack *extack)
+{
+	if (val.vu16 != 128 && val.vu16 != 512) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Only 128 or 512 byte descriptor allowed");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int otx2_dl_cqe_size_set(struct devlink *devlink, u32 id,
+				struct devlink_param_gset_ctx *ctx)
+{
+	struct otx2_devlink *otx2_dl = devlink_priv(devlink);
+	struct otx2_nic *pfvf = otx2_dl->pfvf;
+	struct net_device *netdev;
+	int err = 0;
+	bool if_up;
+
+	rtnl_lock();
+
+	netdev = pfvf->netdev;
+	if_up = netif_running(netdev);
+	if (if_up)
+		netdev->netdev_ops->ndo_stop(netdev);
+
+	pfvf->hw.xqe_size = ctx->val.vu16;
+
+	if (if_up)
+		err = netdev->netdev_ops->ndo_open(netdev);
+
+	rtnl_unlock();
+
+	return err;
+}
+
+static int otx2_dl_cqe_size_get(struct devlink *devlink, u32 id,
+				struct devlink_param_gset_ctx *ctx)
+{
+	struct otx2_devlink *otx2_dl = devlink_priv(devlink);
+	struct otx2_nic *pfvf = otx2_dl->pfvf;
+
+	ctx->val.vu16 = pfvf->hw.xqe_size;
+
+	return 0;
+}
+
 enum otx2_dl_param_id {
 	OTX2_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
 	OTX2_DEVLINK_PARAM_ID_MCAM_COUNT,
+	OTX2_DEVLINK_PARAM_ID_CQE_SIZE,
 };
 
 static const struct devlink_param otx2_dl_params[] = {
@@ -75,6 +126,11 @@ static const struct devlink_param otx2_dl_params[] = {
 			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
 			     otx2_dl_mcam_count_get, otx2_dl_mcam_count_set,
 			     otx2_dl_mcam_count_validate),
+	DEVLINK_PARAM_DRIVER(OTX2_DEVLINK_PARAM_ID_CQE_SIZE,
+			     "completion_descriptor_size", DEVLINK_PARAM_TYPE_U16,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     otx2_dl_cqe_size_get, otx2_dl_cqe_size_set,
+			     otx2_dl_cqe_size_validate),
 };
 
 /* Devlink OPs */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 1e0d0c9c..8618cf7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2624,6 +2624,8 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	hw->tx_queues = qcount;
 	hw->tot_tx_queues = qcount;
 	hw->max_queues = qcount;
+	/* Use CQE of 128 byte descriptor size by default */
+	hw->xqe_size = 128;
 
 	num_vec = pci_msix_vec_count(pdev);
 	hw->irq_name = devm_kmalloc_array(&hw->pdev->dev, num_vec, NAME_SIZE,
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 980219a..672be05 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -587,6 +587,8 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	hw->tx_queues = qcount;
 	hw->max_queues = qcount;
 	hw->tot_tx_queues = qcount;
+	/* Use CQE of 128 byte descriptor size by default */
+	hw->xqe_size = 128;
 
 	hw->irq_name = devm_kmalloc_array(&hw->pdev->dev, num_vec, NAME_SIZE,
 					  GFP_KERNEL);
-- 
2.7.4

