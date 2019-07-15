Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 200796962A
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388665AbfGOOJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:09:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388652AbfGOOJK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:09:10 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2DFB212F5;
        Mon, 15 Jul 2019 14:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199749;
        bh=oLHMVyDyR9D/eTUhXbuQSLHOw8Bnlk5PSTnPXqxZkc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pL5//F3DmfgfJ5Pfgtup0TfMdYtqC3iSfwQR4MFCAJrRantYyLFV9qLbsJr2flu3j
         O98+FS1NlxqKk9kcoY2yhnLZQszCo9RfP25x2JERRP28qRtBxYOzYsH2cPJGwk7pap
         8SBtJ2RQ9iI6NkQEQ5J4Ylowj+wUVjWhpclk8fnk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 094/219] net: hns3: delay ring buffer clearing during reset
Date:   Mon, 15 Jul 2019 10:01:35 -0400
Message-Id: <20190715140341.6443-94-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit 3a30964a2eef6aabd3ab18b979ea0eacf1147731 ]

The driver may not be able to disable the ring through firmware
when downing the netdev during reset process, which may cause
hardware accessing freed buffer problem.

This patch delays the ring buffer clearing to reset uninit
process because hardware will not access the ring buffer after
hardware reset is completed.

Fixes: bb6b94a896d4 ("net: hns3: Add reset interface implementation in client")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 6afdd376bc03..7e7c10513d2c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -28,7 +28,7 @@
 #define hns3_tx_bd_count(S)	DIV_ROUND_UP(S, HNS3_MAX_BD_SIZE)
 
 static void hns3_clear_all_ring(struct hnae3_handle *h);
-static void hns3_force_clear_all_rx_ring(struct hnae3_handle *h);
+static void hns3_force_clear_all_ring(struct hnae3_handle *h);
 static void hns3_remove_hw_addr(struct net_device *netdev);
 
 static const char hns3_driver_name[] = "hns3";
@@ -484,7 +484,12 @@ static void hns3_nic_net_down(struct net_device *netdev)
 	/* free irq resources */
 	hns3_nic_uninit_irq(priv);
 
-	hns3_clear_all_ring(priv->ae_handle);
+	/* delay ring buffer clearing to hns3_reset_notify_uninit_enet
+	 * during reset process, because driver may not be able
+	 * to disable the ring through firmware when downing the netdev.
+	 */
+	if (!hns3_nic_resetting(netdev))
+		hns3_clear_all_ring(priv->ae_handle);
 }
 
 static int hns3_nic_net_stop(struct net_device *netdev)
@@ -3737,7 +3742,7 @@ static void hns3_client_uninit(struct hnae3_handle *handle, bool reset)
 
 	hns3_del_all_fd_rules(netdev, true);
 
-	hns3_force_clear_all_rx_ring(handle);
+	hns3_force_clear_all_ring(handle);
 
 	hns3_uninit_phy(netdev);
 
@@ -3909,7 +3914,7 @@ static void hns3_force_clear_rx_ring(struct hns3_enet_ring *ring)
 	}
 }
 
-static void hns3_force_clear_all_rx_ring(struct hnae3_handle *h)
+static void hns3_force_clear_all_ring(struct hnae3_handle *h)
 {
 	struct net_device *ndev = h->kinfo.netdev;
 	struct hns3_nic_priv *priv = netdev_priv(ndev);
@@ -3917,6 +3922,9 @@ static void hns3_force_clear_all_rx_ring(struct hnae3_handle *h)
 	u32 i;
 
 	for (i = 0; i < h->kinfo.num_tqps; i++) {
+		ring = priv->ring_data[i].ring;
+		hns3_clear_tx_ring(ring);
+
 		ring = priv->ring_data[i + h->kinfo.num_tqps].ring;
 		hns3_force_clear_rx_ring(ring);
 	}
@@ -4145,7 +4153,8 @@ static int hns3_reset_notify_uninit_enet(struct hnae3_handle *handle)
 		return 0;
 	}
 
-	hns3_force_clear_all_rx_ring(handle);
+	hns3_clear_all_ring(handle);
+	hns3_force_clear_all_ring(handle);
 
 	hns3_nic_uninit_vector_data(priv);
 
-- 
2.20.1

