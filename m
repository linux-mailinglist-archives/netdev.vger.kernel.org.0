Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543D13A3F44
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 11:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbhFKJo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 05:44:26 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:15948 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230212AbhFKJoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 05:44:25 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15B9fNnE001006;
        Fri, 11 Jun 2021 02:42:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=0vXyiaFkhZWC0lZM4GLi6QeYLt7//LEoZfyqz1TDZU0=;
 b=IiU/l2loGO8gGX7yjhmsQfxM5WEwF/Np295UMeGseWK7k9GTQsueFODjDezrcA0nR2Ju
 Kd9rAJLO+gm0ly0puDPJSO/0S5oB5WwkClf8RXkxrNAhEnSQE330eh7mj2pkIUrnJgFI
 ljKQgHGegfNvcEDAHA9FLdru7j0Ub0Pp8Wj82Ji5kgXyzhKXuvJQhZq+jhoiAZbsBiwc
 WFurpx5+02bhNk5YxE38emp3dY/EDz/nC3qZ2GWRypQ+ybZIq8GGqXg4+gTKUFwcMLrf
 5uzfrI8qIgfVSKzifO6om7uGZ8ESi6xlIfla+NYgV4SeZFS8PoZHQaR1lWpeiQTtiYTN MQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 393x92hgn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 02:42:27 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Jun
 2021 02:42:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 11 Jun 2021 02:42:26 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 61B5A3F7075;
        Fri, 11 Jun 2021 02:42:23 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <lcherian@marvell.com>, <gakula@marvell.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>,
        Sunil Kovvuri Goutham <Sunil.Goutham@marvell.com>
Subject: [PATCH net-next 2/4] octeontx2-nicvf: add ndo_set_rx_mode support for multicast & promisc
Date:   Fri, 11 Jun 2021 15:12:03 +0530
Message-ID: <20210611094205.28230-3-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20210611094205.28230-1-naveenm@marvell.com>
References: <20210611094205.28230-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: PyCJ_knvTM8mT3BjkZ_JOxc8wS3hcg3C
X-Proofpoint-GUID: PyCJ_knvTM8mT3BjkZ_JOxc8wS3hcg3C
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_03:2021-06-11,2021-06-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ndo_set_rx_mode callback handler to configure promisc, multicast and
allmulti options for VF driver. Also, modified PF driver ndo_set_rx_mode
handler to support multicast and promisc mode independently.

Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <Sunil.Goutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   | 58 +++++++++++++++++++++-
 1 file changed, 56 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 085be90a03eb..13a908f75ba0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -395,6 +395,42 @@ static netdev_tx_t otx2vf_xmit(struct sk_buff *skb, struct net_device *netdev)
 	return NETDEV_TX_OK;
 }
 
+static void otx2vf_set_rx_mode(struct net_device *netdev)
+{
+	struct otx2_nic *vf = netdev_priv(netdev);
+
+	queue_work(vf->otx2_wq, &vf->rx_mode_work);
+}
+
+static void otx2vf_do_set_rx_mode(struct work_struct *work)
+{
+	struct otx2_nic *vf = container_of(work, struct otx2_nic, rx_mode_work);
+	struct net_device *netdev = vf->netdev;
+	unsigned int flags = netdev->flags;
+	struct nix_rx_mode *req;
+
+	mutex_lock(&vf->mbox.lock);
+
+	req = otx2_mbox_alloc_msg_nix_set_rx_mode(&vf->mbox);
+	if (!req) {
+		mutex_unlock(&vf->mbox.lock);
+		return;
+	}
+
+	req->mode = NIX_RX_MODE_UCAST;
+
+	if (flags & IFF_PROMISC)
+		req->mode |= NIX_RX_MODE_PROMISC;
+	if (flags & (IFF_ALLMULTI | IFF_MULTICAST))
+		req->mode |= NIX_RX_MODE_ALLMULTI;
+
+	req->mode |= NIX_RX_MODE_USE_MCE;
+
+	otx2_sync_mbox_msg(&vf->mbox);
+
+	mutex_unlock(&vf->mbox.lock);
+}
+
 static int otx2vf_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	bool if_up = netif_running(netdev);
@@ -432,12 +468,24 @@ static const struct net_device_ops otx2vf_netdev_ops = {
 	.ndo_open = otx2vf_open,
 	.ndo_stop = otx2vf_stop,
 	.ndo_start_xmit = otx2vf_xmit,
+	.ndo_set_rx_mode = otx2vf_set_rx_mode,
 	.ndo_set_mac_address = otx2_set_mac_address,
 	.ndo_change_mtu = otx2vf_change_mtu,
 	.ndo_get_stats64 = otx2_get_stats64,
 	.ndo_tx_timeout = otx2_tx_timeout,
 };
 
+static int otx2_wq_init(struct otx2_nic *vf)
+{
+	vf->otx2_wq = create_singlethread_workqueue("otx2vf_wq");
+	if (!vf->otx2_wq)
+		return -ENOMEM;
+
+	INIT_WORK(&vf->rx_mode_work, otx2vf_do_set_rx_mode);
+	INIT_WORK(&vf->reset_task, otx2vf_reset_task);
+	return 0;
+}
+
 static int otx2vf_realloc_msix_vectors(struct otx2_nic *vf)
 {
 	struct otx2_hw *hw = &vf->hw;
@@ -588,8 +636,6 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	netdev->min_mtu = OTX2_MIN_MTU;
 	netdev->max_mtu = otx2_get_max_mtu(vf);
 
-	INIT_WORK(&vf->reset_task, otx2vf_reset_task);
-
 	/* To distinguish, for LBK VFs set netdev name explicitly */
 	if (is_otx2_lbkvf(vf->pdev)) {
 		int n;
@@ -606,6 +652,10 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_detach_rsrc;
 	}
 
+	err = otx2_wq_init(vf);
+	if (err)
+		goto err_unreg_netdev;
+
 	otx2vf_set_ethtool_ops(netdev);
 
 	/* Enable pause frames by default */
@@ -614,6 +664,8 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	return 0;
 
+err_unreg_netdev:
+	unregister_netdev(netdev);
 err_detach_rsrc:
 	if (hw->lmt_base)
 		iounmap(hw->lmt_base);
@@ -644,6 +696,8 @@ static void otx2vf_remove(struct pci_dev *pdev)
 
 	cancel_work_sync(&vf->reset_task);
 	unregister_netdev(netdev);
+	if (vf->otx2_wq)
+		destroy_workqueue(vf->otx2_wq);
 	otx2vf_disable_mbox_intr(vf);
 	otx2_detach_resources(&vf->mbox);
 
-- 
2.16.5

