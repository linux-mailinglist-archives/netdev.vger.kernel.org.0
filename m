Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A735D31469A
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 03:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbhBICoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 21:44:00 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11710 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhBICnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 21:43:40 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DZRwT1w3JzlHtW;
        Tue,  9 Feb 2021 10:41:13 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Tue, 9 Feb 2021 10:42:48 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 08/11] net: hns3: remove redundant return value of hns3_uninit_all_ring()
Date:   Tue, 9 Feb 2021 10:41:58 +0800
Message-ID: <1612838521-59915-9-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612838521-59915-1-git-send-email-tanhuazhong@huawei.com>
References: <1612838521-59915-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since hns3_uninit_all_ring() only returns 0, so remove this
redundant return value and function declaration in hns3_enet.h.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 12 +++---------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h |  1 -
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 474b082..9565b79 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4084,7 +4084,7 @@ int hns3_init_all_ring(struct hns3_nic_priv *priv)
 	return -ENOMEM;
 }
 
-int hns3_uninit_all_ring(struct hns3_nic_priv *priv)
+static void hns3_uninit_all_ring(struct hns3_nic_priv *priv)
 {
 	struct hnae3_handle *h = priv->ae_handle;
 	int i;
@@ -4093,7 +4093,6 @@ int hns3_uninit_all_ring(struct hns3_nic_priv *priv)
 		hns3_fini_ring(&priv->ring[i]);
 		hns3_fini_ring(&priv->ring[i + h->kinfo.num_tqps]);
 	}
-	return 0;
 }
 
 /* Set mac addr if it is configured. or leave it to the AE driver */
@@ -4321,7 +4320,6 @@ static void hns3_client_uninit(struct hnae3_handle *handle, bool reset)
 {
 	struct net_device *netdev = handle->kinfo.netdev;
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
-	int ret;
 
 	if (netdev->reg_state != NETREG_UNINITIALIZED)
 		unregister_netdev(netdev);
@@ -4347,9 +4345,7 @@ static void hns3_client_uninit(struct hnae3_handle *handle, bool reset)
 
 	hns3_nic_dealloc_vector_data(priv);
 
-	ret = hns3_uninit_all_ring(priv);
-	if (ret)
-		netdev_err(netdev, "uninit ring error\n");
+	hns3_uninit_all_ring(priv);
 
 	hns3_put_ring_config(priv);
 
@@ -4662,9 +4658,7 @@ static int hns3_reset_notify_uninit_enet(struct hnae3_handle *handle)
 
 	hns3_nic_dealloc_vector_data(priv);
 
-	ret = hns3_uninit_all_ring(priv);
-	if (ret)
-		netdev_err(netdev, "uninit ring error\n");
+	hns3_uninit_all_ring(priv);
 
 	hns3_put_ring_config(priv);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 7435a83..d069b04 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -605,7 +605,6 @@ int hns3_set_channels(struct net_device *netdev,
 
 void hns3_clean_tx_ring(struct hns3_enet_ring *ring, int budget);
 int hns3_init_all_ring(struct hns3_nic_priv *priv);
-int hns3_uninit_all_ring(struct hns3_nic_priv *priv);
 int hns3_nic_reset_all_ring(struct hnae3_handle *h);
 void hns3_fini_ring(struct hns3_enet_ring *ring);
 netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev);
-- 
2.7.4

