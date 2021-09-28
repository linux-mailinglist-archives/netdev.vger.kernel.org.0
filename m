Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD52141B559
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 19:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242066AbhI1Rpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 13:45:39 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:25478 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241966AbhI1Rph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 13:45:37 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18SHQu3H008900;
        Tue, 28 Sep 2021 10:43:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=UZ5SwWR2UTqlsYKRRPIWSy7sFjGOn09twZnJpVZ9kF4=;
 b=LRwNSncIxqjUQaTsC+7l7zvExrjnivGwdHRfpLBIfIBHrEv+ukqVkQXA36toEZCF2OLc
 aIumIGxV2SqjPfdSTH0Iex0FbNmV3+NTLyKJC+IB5iFMTfbMsZJUujMtMZ19Zs+YlJMd
 VquyudEXfTo4hHY2kGrDbS6IyDZrNWeZ7yDLKh9/5eoLQRAYy1zbfD6YVcDTXPYg8Uhl
 Mt7De+/DBo/D8q/ZdOlQZ2JwQ10hnnAnbPARqRwrdqMmcVmWYPfQguffUAVazowzSd5i
 j1dp8UIfIcoW3Z9+x/OkTN1B27fuzVDJWjYDndGwXNPFSzwEgy93rMc/hWfI3DitKrLT Yw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bc7eyg2ew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 28 Sep 2021 10:43:56 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Sep
 2021 10:43:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 28 Sep 2021 10:43:55 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 773F33F707D;
        Tue, 28 Sep 2021 10:43:52 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        <naveenm@marvell.com>, <rsaladi2@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 1/2] octeontx2-pf: Enable promisc/allmulti match MCAM entries.
Date:   Tue, 28 Sep 2021 23:13:45 +0530
Message-ID: <1632851026-5415-2-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1632851026-5415-1-git-send-email-sbhatta@marvell.com>
References: <1632851026-5415-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: mtDf3SXQJr4gSlfdLHDaVjkHNUyMpRQ8
X-Proofpoint-ORIG-GUID: mtDf3SXQJr4gSlfdLHDaVjkHNUyMpRQ8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-28_05,2021-09-28_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rakesh Babu <rsaladi2@marvell.com>

Whenever the interface is brought up/down then set_rx_mode
function is called by the stack which enables promisc/allmulti
MCAM entries. But there are cases when driver brings
interface down and then up such as while changing number
of channels. In these cases promisc/allmulti MCAM entries
are left disabled as set_rx_mode callback is not called.
This patch enables these MCAM entries in all such cases.

Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 78 ++++++++++++----------
 1 file changed, 43 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 53df7ff..53a3e8d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1493,6 +1493,44 @@ static void otx2_free_hw_resources(struct otx2_nic *pf)
 	mutex_unlock(&mbox->lock);
 }
 
+static void otx2_do_set_rx_mode(struct otx2_nic *pf)
+{
+	struct net_device *netdev = pf->netdev;
+	struct nix_rx_mode *req;
+	bool promisc = false;
+
+	if (!(netdev->flags & IFF_UP))
+		return;
+
+	if ((netdev->flags & IFF_PROMISC) ||
+	    (netdev_uc_count(netdev) > OTX2_MAX_UNICAST_FLOWS)) {
+		promisc = true;
+	}
+
+	/* Write unicast address to mcam entries or del from mcam */
+	if (!promisc && netdev->priv_flags & IFF_UNICAST_FLT)
+		__dev_uc_sync(netdev, otx2_add_macfilter, otx2_del_macfilter);
+
+	mutex_lock(&pf->mbox.lock);
+	req = otx2_mbox_alloc_msg_nix_set_rx_mode(&pf->mbox);
+	if (!req) {
+		mutex_unlock(&pf->mbox.lock);
+		return;
+	}
+
+	req->mode = NIX_RX_MODE_UCAST;
+
+	if (promisc)
+		req->mode |= NIX_RX_MODE_PROMISC;
+	if (netdev->flags & (IFF_ALLMULTI | IFF_MULTICAST))
+		req->mode |= NIX_RX_MODE_ALLMULTI;
+
+	req->mode |= NIX_RX_MODE_USE_MCE;
+
+	otx2_sync_mbox_msg(&pf->mbox);
+	mutex_unlock(&pf->mbox.lock);
+}
+
 int otx2_open(struct net_device *netdev)
 {
 	struct otx2_nic *pf = netdev_priv(netdev);
@@ -1646,6 +1684,8 @@ int otx2_open(struct net_device *netdev)
 	if (err)
 		goto err_tx_stop_queues;
 
+	otx2_do_set_rx_mode(pf);
+
 	return 0;
 
 err_tx_stop_queues:
@@ -1791,43 +1831,11 @@ static void otx2_set_rx_mode(struct net_device *netdev)
 	queue_work(pf->otx2_wq, &pf->rx_mode_work);
 }
 
-static void otx2_do_set_rx_mode(struct work_struct *work)
+static void otx2_rx_mode_wrk_handler(struct work_struct *work)
 {
 	struct otx2_nic *pf = container_of(work, struct otx2_nic, rx_mode_work);
-	struct net_device *netdev = pf->netdev;
-	struct nix_rx_mode *req;
-	bool promisc = false;
-
-	if (!(netdev->flags & IFF_UP))
-		return;
-
-	if ((netdev->flags & IFF_PROMISC) ||
-	    (netdev_uc_count(netdev) > OTX2_MAX_UNICAST_FLOWS)) {
-		promisc = true;
-	}
 
-	/* Write unicast address to mcam entries or del from mcam */
-	if (!promisc && netdev->priv_flags & IFF_UNICAST_FLT)
-		__dev_uc_sync(netdev, otx2_add_macfilter, otx2_del_macfilter);
-
-	mutex_lock(&pf->mbox.lock);
-	req = otx2_mbox_alloc_msg_nix_set_rx_mode(&pf->mbox);
-	if (!req) {
-		mutex_unlock(&pf->mbox.lock);
-		return;
-	}
-
-	req->mode = NIX_RX_MODE_UCAST;
-
-	if (promisc)
-		req->mode |= NIX_RX_MODE_PROMISC;
-	if (netdev->flags & (IFF_ALLMULTI | IFF_MULTICAST))
-		req->mode |= NIX_RX_MODE_ALLMULTI;
-
-	req->mode |= NIX_RX_MODE_USE_MCE;
-
-	otx2_sync_mbox_msg(&pf->mbox);
-	mutex_unlock(&pf->mbox.lock);
+	otx2_do_set_rx_mode(pf);
 }
 
 static int otx2_set_features(struct net_device *netdev,
@@ -2358,7 +2366,7 @@ static int otx2_wq_init(struct otx2_nic *pf)
 	if (!pf->otx2_wq)
 		return -ENOMEM;
 
-	INIT_WORK(&pf->rx_mode_work, otx2_do_set_rx_mode);
+	INIT_WORK(&pf->rx_mode_work, otx2_rx_mode_wrk_handler);
 	INIT_WORK(&pf->reset_task, otx2_reset_task);
 	return 0;
 }
-- 
2.7.4

