Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFF744A149
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239365AbhKIBJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:09:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:59938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239608AbhKIBGu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:06:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DF2361A09;
        Tue,  9 Nov 2021 01:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419771;
        bh=HOgw2nna1IcTt56k1yWLpiLuN2uFcgNZ3Lwy++j4nXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eP2nN49CKhdYmuYz1cuOy4TfiirVBU4PQbdo1rbL3FXrq4OVH8Cpq7O/ciwKfzta5
         45fSCjBq5X1l2bsHbwyW7PkCkrAfQ1gDXtXxSf/5GaUooYbTSrL9//rYqtRqpnOSvn
         cvMacQl+VgD2EbMNBbq6mSoJSWM9g/r2Ed5V4xzr1NELXTOk9Y6HNHsjao3Uqk9Gl5
         cAlp84vxPblz70aRKN4KJaPGxpZAwP+uRPMQ5euo04kpZKnEvl4PkxoYu/m25VnXFn
         3bL03TyHWxTzpqH3c/vAg7RqKzMjOQ2N4/hy6HC/ZfC5MTRd0O2womNRGnjRQGfUTJ
         v6mQYaRMY1/og==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rakesh Babu <rsaladi2@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, gakula@marvell.com,
        hkelam@marvell.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 034/138] octeontx2-pf: Enable promisc/allmulti match MCAM entries.
Date:   Mon,  8 Nov 2021 12:45:00 -0500
Message-Id: <20211108174644.1187889-34-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174644.1187889-1-sashal@kernel.org>
References: <20211108174644.1187889-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rakesh Babu <rsaladi2@marvell.com>

[ Upstream commit ffd2f89ad05cd620d822112a07b0c5669fa9e333 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  | 78 ++++++++++---------
 1 file changed, 43 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 2c24944a4dba2..105b32221d91b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1496,6 +1496,44 @@ static void otx2_free_hw_resources(struct otx2_nic *pf)
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
@@ -1657,6 +1695,8 @@ int otx2_open(struct net_device *netdev)
 	if (err)
 		goto err_tx_stop_queues;
 
+	otx2_do_set_rx_mode(pf);
+
 	return 0;
 
 err_tx_stop_queues:
@@ -1809,43 +1849,11 @@ static void otx2_set_rx_mode(struct net_device *netdev)
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
@@ -2345,7 +2353,7 @@ static int otx2_wq_init(struct otx2_nic *pf)
 	if (!pf->otx2_wq)
 		return -ENOMEM;
 
-	INIT_WORK(&pf->rx_mode_work, otx2_do_set_rx_mode);
+	INIT_WORK(&pf->rx_mode_work, otx2_rx_mode_wrk_handler);
 	INIT_WORK(&pf->reset_task, otx2_reset_task);
 	return 0;
 }
-- 
2.33.0

