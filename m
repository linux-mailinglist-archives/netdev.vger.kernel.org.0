Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B124238B6
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 09:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237471AbhJFHVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 03:21:05 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:2336 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237419AbhJFHVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 03:21:00 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19620stG030285;
        Wed, 6 Oct 2021 00:19:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Um9s9/TLHNrNMcB2c9SFF6AaxMvdu82WG4m2JK9f+8k=;
 b=VrcajbmX/jKMX84LNBl0BNHgP3sUJciDONtZVgyHOGX5YynAlJpG+uFKsdRPHqr9DzQc
 wtcuqjsgqPS5RMURLSiqveIfO1bWZM7b5XqwoJF8m4+iekPAvwiQXo7+eK6sx68fLEHz
 0N6H5qMVkTe6UcMUthpFKeQX8w0TO/jh62z7VCnhzPcyQaQTPhWK8NBdvHTZ/k38gff6
 oNDlm7XmSiayA6m6c7K0oFMIF/a3zjDIIe7Z5P5o2xEzIrfhORpLV42oyb9QPi4/8QES
 DTkPhkxFCxTlXqh8U6hfh/lBrrH4WC2fCxZRCDT/eACDl5PDVcFEoTJAZyJpU9oPK+zH Ww== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bgr1qkj8j-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 00:19:06 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 6 Oct
 2021 00:19:05 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 6 Oct 2021 00:19:05 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 3283E3F7054;
        Wed,  6 Oct 2021 00:19:02 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH v2 3/3] octeontx2-pf: Add devlink param to vary rbuf size
Date:   Wed, 6 Oct 2021 12:48:46 +0530
Message-ID: <1633504726-30751-4-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1633504726-30751-1-git-send-email-sbhatta@marvell.com>
References: <1633504726-30751-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 4z5b_9Kc0B4epfjW-ZUM4jQpFAavb4SP
X-Proofpoint-GUID: 4z5b_9Kc0B4epfjW-ZUM4jQpFAavb4SP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-05_06,2021-10-04_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The size of receive buffers for receiving packets
is calculated based on the mtu of interface. This
patch adds devlink parameter to utilize user given
size for receive buffers instead. By changing CQE
descriptor size and receive buffer sizes the number
of buffer pointers used by hardware for a large packet
can be configured.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  1 +
 .../ethernet/marvell/octeontx2/nic/otx2_devlink.c  | 60 ++++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  7 +++
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |  5 ++
 4 files changed, 73 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 6e0d1ac..f885abe 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -178,6 +178,7 @@ struct otx2_hw {
 	u16			rqpool_cnt;
 	u16			sqpool_cnt;
 	u16			xqe_size;
+	u16			rbuf_fixed_size;
 
 	/* NPA */
 	u32			stack_pg_ptrs;  /* No of ptrs per stack page */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
index 98450e1..0fc7e32 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
@@ -64,6 +64,60 @@ static int otx2_dl_mcam_count_get(struct devlink *devlink, u32 id,
 	return 0;
 }
 
+static int otx2_dl_rbuf_size_validate(struct devlink *devlink, u32 id,
+				      union devlink_param_value val,
+				      struct netlink_ext_ack *extack)
+{
+	/* Hardware supports max size of 32k for a receive buffer
+	 * and 1536 is typical ethernet frame size.
+	 */
+	if (val.vu16 < 1536 || val.vu16 > 32768) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Receive buffer range is 1536 - 32768");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int otx2_dl_rbuf_size_set(struct devlink *devlink, u32 id,
+				 struct devlink_param_gset_ctx *ctx)
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
+	pfvf->hw.rbuf_fixed_size = ALIGN(ctx->val.vu16, OTX2_ALIGN) +
+				   OTX2_HEAD_ROOM;
+
+	if (if_up)
+		err = netdev->netdev_ops->ndo_open(netdev);
+
+	rtnl_unlock();
+
+	return err;
+}
+
+static int otx2_dl_rbuf_size_get(struct devlink *devlink, u32 id,
+				 struct devlink_param_gset_ctx *ctx)
+{
+	struct otx2_devlink *otx2_dl = devlink_priv(devlink);
+	struct otx2_nic *pfvf = otx2_dl->pfvf;
+
+	ctx->val.vu16 = pfvf->hw.rbuf_fixed_size;
+
+	return 0;
+}
+
 static int otx2_dl_cqe_size_validate(struct devlink *devlink, u32 id,
 				     union devlink_param_value val,
 				     struct netlink_ext_ack *extack)
@@ -118,6 +172,7 @@ enum otx2_dl_param_id {
 	OTX2_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
 	OTX2_DEVLINK_PARAM_ID_MCAM_COUNT,
 	OTX2_DEVLINK_PARAM_ID_CQE_SIZE,
+	OTX2_DEVLINK_PARAM_ID_RBUF_SIZE,
 };
 
 static const struct devlink_param otx2_dl_params[] = {
@@ -131,6 +186,11 @@ static const struct devlink_param otx2_dl_params[] = {
 			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
 			     otx2_dl_cqe_size_get, otx2_dl_cqe_size_set,
 			     otx2_dl_cqe_size_validate),
+	DEVLINK_PARAM_DRIVER(OTX2_DEVLINK_PARAM_ID_RBUF_SIZE,
+			     "receive_buffer_size", DEVLINK_PARAM_TYPE_U16,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     otx2_dl_rbuf_size_get, otx2_dl_rbuf_size_set,
+			     otx2_dl_rbuf_size_validate),
 };
 
 /* Devlink OPs */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 8618cf7..1be524d3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -65,6 +65,10 @@ static int otx2_change_mtu(struct net_device *netdev, int new_mtu)
 	netdev_info(netdev, "Changing MTU from %d to %d\n",
 		    netdev->mtu, new_mtu);
 	netdev->mtu = new_mtu;
+	/* Modify receive buffer size based on MTU and do not
+	 * use the fixed size set.
+	 */
+	pf->hw.rbuf_fixed_size = 0;
 
 	if (if_up)
 		err = otx2_open(netdev);
@@ -1306,6 +1310,9 @@ static int otx2_get_rbuf_size(struct otx2_nic *pf, int mtu)
 	int total_size;
 	int rbuf_size;
 
+	if (pf->hw.rbuf_fixed_size)
+		return pf->hw.rbuf_fixed_size;
+
 	/* The data transferred by NIX to memory consists of actual packet
 	 * plus additional data which has timestamp and/or EDSA/HIGIG2
 	 * headers if interface is configured in corresponding modes.
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 672be05..229d051 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -439,6 +439,7 @@ static void otx2vf_do_set_rx_mode(struct work_struct *work)
 
 static int otx2vf_change_mtu(struct net_device *netdev, int new_mtu)
 {
+	struct otx2_nic *vf = netdev_priv(netdev);
 	bool if_up = netif_running(netdev);
 	int err = 0;
 
@@ -448,6 +449,10 @@ static int otx2vf_change_mtu(struct net_device *netdev, int new_mtu)
 	netdev_info(netdev, "Changing MTU from %d to %d\n",
 		    netdev->mtu, new_mtu);
 	netdev->mtu = new_mtu;
+	/* Modify receive buffer size based on MTU and do not
+	 * use the fixed size set.
+	 */
+	vf->hw.rbuf_fixed_size = 0;
 
 	if (if_up)
 		err = otx2vf_open(netdev);
-- 
2.7.4

