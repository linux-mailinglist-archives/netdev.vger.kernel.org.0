Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2645D41B55A
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 19:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242075AbhI1Rpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 13:45:42 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:64128 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241954AbhI1Rpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 13:45:40 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SHQT0k008662;
        Tue, 28 Sep 2021 10:43:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=kg9h7JVyVLJm3S9WmcBN562Ro5YVzfTgqKRrb2t6ags=;
 b=EWYsFMwtXNG2qW7VERv3cx2rwUVWGwXA2/EGntHfeaRwbnXTE2JGob65A0SVYSNzvpdD
 HMnHS8fNnwDkzslRdiU5Mv5EUo8uVB8rz7mw66oc9Y4nsRUiilRAI9OVndNE72SoYjiy
 M3B4Q6eGRJT8t4VzPejRfewaNgAD5r+w/oaRHErjBS1Xpcm7VMiQynhkp2jO/XDrqHXD
 3fewZQtR2XQ5XJGtuoqpeQDkTkja9jIAS+MvD7eaT0IHnJxkiBCN14RQ797rulfTR02H
 576fdkkbbMio7ZNCFxhVoAW5UVzBmjpRGtivUdYIU56VHK4Z8eeqnOrBPgJtTLk2kLbH mg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bc7eyg2f2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 10:43:59 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Sep
 2021 10:43:58 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 28 Sep 2021 10:43:58 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id BA59A3F707E;
        Tue, 28 Sep 2021 10:43:55 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        <naveenm@marvell.com>, <rsaladi2@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 2/2] octeontx2-nicvf: Add PTP hardware clock support to NIX VF
Date:   Tue, 28 Sep 2021 23:13:46 +0530
Message-ID: <1632851026-5415-3-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1632851026-5415-1-git-send-email-sbhatta@marvell.com>
References: <1632851026-5415-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: LvQy_WtmAkc29VBD_1JlNLGGedO0DRwj
X-Proofpoint-ORIG-GUID: LvQy_WtmAkc29VBD_1JlNLGGedO0DRwj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Naveen Mamindlapalli <naveenm@marvell.com>

This patch adds PTP PHC support to NIX VF interfaces. This enables
a VF to run PTP master/slave instance. PTP block being a shared
hardware resource it is recommended to avoid running multiple
PTP instances in the system which will impact the PTP clock
accuracy.

Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c       | 3 +++
 drivers/net/ethernet/marvell/octeontx2/nic/Makefile       | 2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h  | 3 +++
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 1 +
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c      | 6 ++++--
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c     | 5 +++++
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c      | 6 ++++++
 7 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 5bdbc77..c3842e45 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -730,6 +730,9 @@ static int rvu_cgx_ptp_rx_cfg(struct rvu *rvu, u16 pcifunc, bool enable)
 int rvu_mbox_handler_cgx_ptp_rx_enable(struct rvu *rvu, struct msg_req *req,
 				       struct msg_rsp *rsp)
 {
+	if (!is_pf_cgxmapped(rvu, rvu_get_pf(req->hdr.pcifunc)))
+		return -EPERM;
+
 	return rvu_cgx_ptp_rx_cfg(rvu, req->hdr.pcifunc, true);
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
index b92c267..aaf9acc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
@@ -9,6 +9,6 @@ obj-$(CONFIG_OCTEONTX2_VF) += rvu_nicvf.o
 rvu_nicpf-y := otx2_pf.o otx2_common.o otx2_txrx.o otx2_ethtool.o \
                otx2_ptp.o otx2_flows.o otx2_tc.o cn10k.o otx2_dmac_flt.o \
                otx2_devlink.o
-rvu_nicvf-y := otx2_vf.o otx2_devlink.o
+rvu_nicvf-y := otx2_vf.o otx2_devlink.o otx2_ptp.o
 
 ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 069d1b9..bf86a55 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -834,6 +834,9 @@ int otx2_open(struct net_device *netdev);
 int otx2_stop(struct net_device *netdev);
 int otx2_set_real_num_queues(struct net_device *netdev,
 			     int tx_queues, int rx_queues);
+int otx2_ioctl(struct net_device *netdev, struct ifreq *req, int cmd);
+int otx2_config_hwtstamp(struct net_device *netdev, struct ifreq *ifr);
+
 /* MCAM filter related APIs */
 int otx2_mcam_flow_init(struct otx2_nic *pf);
 int otx2vf_mcam_flow_init(struct otx2_nic *pfvf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 38e5924..b0f57bd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -1347,6 +1347,7 @@ static const struct ethtool_ops otx2vf_ethtool_ops = {
 	.get_pauseparam		= otx2_get_pauseparam,
 	.set_pauseparam		= otx2_set_pauseparam,
 	.get_link_ksettings     = otx2vf_get_link_ksettings,
+	.get_ts_info		= otx2_get_ts_info,
 };
 
 void otx2vf_set_ethtool_ops(struct net_device *netdev)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 53a3e8d..ab07964 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1975,7 +1975,7 @@ static int otx2_config_hw_tx_tstamp(struct otx2_nic *pfvf, bool enable)
 	return 0;
 }
 
-static int otx2_config_hwtstamp(struct net_device *netdev, struct ifreq *ifr)
+int otx2_config_hwtstamp(struct net_device *netdev, struct ifreq *ifr)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 	struct hwtstamp_config config;
@@ -2031,8 +2031,9 @@ static int otx2_config_hwtstamp(struct net_device *netdev, struct ifreq *ifr)
 	return copy_to_user(ifr->ifr_data, &config,
 			    sizeof(config)) ? -EFAULT : 0;
 }
+EXPORT_SYMBOL(otx2_config_hwtstamp);
 
-static int otx2_ioctl(struct net_device *netdev, struct ifreq *req, int cmd)
+int otx2_ioctl(struct net_device *netdev, struct ifreq *req, int cmd)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 	struct hwtstamp_config *cfg = &pfvf->tstamp;
@@ -2047,6 +2048,7 @@ static int otx2_ioctl(struct net_device *netdev, struct ifreq *req, int cmd)
 		return -EOPNOTSUPP;
 	}
 }
+EXPORT_SYMBOL(otx2_ioctl);
 
 static int otx2_do_set_vf_mac(struct otx2_nic *pf, int vf, const u8 *mac)
 {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
index 5e3056a..977a8a4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
@@ -223,6 +223,11 @@ int otx2_ptp_init(struct otx2_nic *pfvf)
 	struct ptp_req *req;
 	int err;
 
+	if (is_otx2_lbkvf(pfvf->pdev)) {
+		pfvf->ptp = NULL;
+		return 0;
+	}
+
 	mutex_lock(&pfvf->mbox.lock);
 	/* check if PTP block is available */
 	req = otx2_mbox_alloc_msg_ptp_op(&pfvf->mbox);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 03b4ec6..f1fddae 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -8,9 +8,11 @@
 #include <linux/etherdevice.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/net_tstamp.h>
 
 #include "otx2_common.h"
 #include "otx2_reg.h"
+#include "otx2_ptp.h"
 #include "cn10k.h"
 
 #define DRV_NAME	"rvu_nicvf"
@@ -500,6 +502,7 @@ static const struct net_device_ops otx2vf_netdev_ops = {
 	.ndo_set_features = otx2vf_set_features,
 	.ndo_get_stats64 = otx2_get_stats64,
 	.ndo_tx_timeout = otx2_tx_timeout,
+	.ndo_do_ioctl	= otx2_ioctl,
 };
 
 static int otx2_wq_init(struct otx2_nic *vf)
@@ -640,6 +643,9 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_detach_rsrc;
 
+	/* Don't check for error.  Proceed without ptp */
+	otx2_ptp_init(vf);
+
 	/* Assign default mac address */
 	otx2_get_mac_from_af(netdev);
 
-- 
2.7.4

