Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3253D4C9C
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 09:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhGYHTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 03:19:05 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:62896 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230187AbhGYHTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 03:19:01 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16P7rwod014665;
        Sun, 25 Jul 2021 00:59:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=Ci+lIxRPC7H9CPgLazplvOFfIEIOICUnlxM5dY9RJSg=;
 b=TeVLIQsko8qLKoxsYFRwwbpix0fpPUsYRbRsvNTXbVaeC6wUfnaEWkSEkdLo1m0/Wa4J
 ORJHv3r/DqKTPIB0qsH6+pHjrMW/B7e4KMnTVRj4a3ndzUfkdpZepGuC/4NR6UawTcEj
 KZRVZ7pRJR+xXXSwoVr94NS64ZY3OuZqoEvtBxMfNZRw3lV8mZaRMgDJslDDBPcjHHnn
 bdhZ479oCvlcYeWh59Xt2IM0e+j6zw1LgQH6tLWFiDHYLktoNoNWlLPusO5oAgqbPIwk
 AkjR8pWUkgLKgEJPVaNFdkA3gP9+X4UZzGWXSGKrnynLaHI822eMpnMu+1jwOBBEVInE FQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3a0g7r25t0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 25 Jul 2021 00:59:09 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 25 Jul
 2021 00:59:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 25 Jul 2021 00:59:07 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id BEA413F70A4;
        Sun, 25 Jul 2021 00:59:04 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <lcherian@marvell.com>, <tduszynski@marvell.com>,
        <kuba@kernel.org>, <davem@davemloft.net>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>
Subject: [net PATCH] octeontx2-pf: Fix interface down flag on error
Date:   Sun, 25 Jul 2021 13:29:03 +0530
Message-ID: <20210725075903.6426-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: ZkY9cC5441dovMzGh-Bl2WBxs7sUvyTQ
X-Proofpoint-ORIG-GUID: ZkY9cC5441dovMzGh-Bl2WBxs7sUvyTQ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-25_02:2021-07-23,2021-07-25 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the existing code while changing the number of TX/RX
queues using ethtool the PF/VF interface resources are
freed and reallocated (otx2_stop and otx2_open is called)
if the device is in running state. If any resource allocation
fails in otx2_open, driver free already allocated resources
and return. But again, when the number of queues changes
as the device state still running oxt2_stop is called.
In which we try to free already freed resources leading
to driver crash.
This patch fixes the issue by setting the INTF_DOWN flag on
error and free the resources in otx2_stop only if the flag is
not set.

Fixes: 50fe6c02e5ad ("octeontx2-pf: Register and handle link notifications")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <Sunil.Goutham@cavium.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 7 +++----
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c      | 5 +++++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 8df748e0677b..b906a0eb6e0d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -298,15 +298,14 @@ static int otx2_set_channels(struct net_device *dev,
 	err = otx2_set_real_num_queues(dev, channel->tx_count,
 				       channel->rx_count);
 	if (err)
-		goto fail;
+		return err;
 
 	pfvf->hw.rx_queues = channel->rx_count;
 	pfvf->hw.tx_queues = channel->tx_count;
 	pfvf->qset.cq_cnt = pfvf->hw.tx_queues +  pfvf->hw.rx_queues;
 
-fail:
 	if (if_up)
-		dev->netdev_ops->ndo_open(dev);
+		err = dev->netdev_ops->ndo_open(dev);
 
 	netdev_info(dev, "Setting num Tx rings to %d, Rx rings to %d success\n",
 		    pfvf->hw.tx_queues, pfvf->hw.rx_queues);
@@ -410,7 +409,7 @@ static int otx2_set_ringparam(struct net_device *netdev,
 	qs->rqe_cnt = rx_count;
 
 	if (if_up)
-		netdev->netdev_ops->ndo_open(netdev);
+		return netdev->netdev_ops->ndo_open(netdev);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index f300b807a85b..2c24944a4dba 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1662,6 +1662,7 @@ int otx2_open(struct net_device *netdev)
 err_tx_stop_queues:
 	netif_tx_stop_all_queues(netdev);
 	netif_carrier_off(netdev);
+	pf->flags |= OTX2_FLAG_INTF_DOWN;
 err_free_cints:
 	otx2_free_cints(pf, qidx);
 	vec = pci_irq_vector(pf->pdev,
@@ -1689,6 +1690,10 @@ int otx2_stop(struct net_device *netdev)
 	struct otx2_rss_info *rss;
 	int qidx, vec, wrk;
 
+	/* If the DOWN flag is set resources are already freed */
+	if (pf->flags & OTX2_FLAG_INTF_DOWN)
+		return 0;
+
 	netif_carrier_off(netdev);
 	netif_tx_stop_all_queues(netdev);
 
-- 
2.17.1

