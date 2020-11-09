Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16DCD2AAFDE
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 04:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbgKIDWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 22:22:30 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:7427 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729316AbgKIDW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 22:22:29 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CTxBN3bsSz74SM;
        Mon,  9 Nov 2020 11:22:20 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Mon, 9 Nov 2020 11:22:17 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 07/11] net: hns3: add hns3_state_init() to do state initialization
Date:   Mon, 9 Nov 2020 11:22:35 +0800
Message-ID: <1604892159-19990-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604892159-19990-1-git-send-email-tanhuazhong@huawei.com>
References: <1604892159-19990-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To improve the readability and maintainability, add hns3_state_init()
to initialize the state.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index a567557..f686723 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4144,6 +4144,16 @@ static void hns3_info_show(struct hns3_nic_priv *priv)
 	dev_info(priv->dev, "Max mtu size: %u\n", priv->netdev->max_mtu);
 }
 
+static void hns3_state_init(struct hnae3_handle *handle)
+{
+	struct net_device *netdev = handle->kinfo.netdev;
+	struct hns3_nic_priv *priv = netdev_priv(netdev);
+
+	set_bit(HNS3_NIC_STATE_INITED, &priv->state);
+	set_bit(HNS3_NIC_STATE_DIM_ENABLE, &priv->state);
+	handle->priv_flags |= BIT(HNAE3_PFLAG_DIM_ENABLE);
+}
+
 static int hns3_client_init(struct hnae3_handle *handle)
 {
 	struct pci_dev *pdev = handle->pdev;
@@ -4244,9 +4254,7 @@ static int hns3_client_init(struct hnae3_handle *handle)
 	/* MTU range: (ETH_MIN_MTU(kernel default) - 9702) */
 	netdev->max_mtu = HNS3_MAX_MTU;
 
-	set_bit(HNS3_NIC_STATE_INITED, &priv->state);
-	set_bit(HNS3_NIC_STATE_DIM_ENABLE, &priv->state);
-	handle->priv_flags |= BIT(HNAE3_PFLAG_DIM_ENABLE);
+	hns3_state_init(handle);
 
 	if (netif_msg_drv(handle))
 		hns3_info_show(priv);
-- 
2.7.4

