Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 126714E8021
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 09:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbiCZI6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 04:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbiCZI6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 04:58:16 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B888D133670
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 01:56:38 -0700 (PDT)
Received: from kwepemi100001.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KQXnv1jL6zCrGF;
        Sat, 26 Mar 2022 16:54:27 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi100001.china.huawei.com (7.221.188.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 26 Mar 2022 16:56:36 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 26 Mar 2022 16:56:36 +0800
From:   Jie Wang <wangjie125@huawei.com>
To:     <mkubecek@suse.cz>, <davem@davemloft.net>, <kuba@kernel.org>,
        <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <huangguangbin2@huawei.com>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <moyufeng@huawei.com>, <linyunsheng@huawei.com>,
        <salil.mehta@huawei.com>, <chenhao288@hisilicon.com>
Subject: [RFCv2 PATCH net-next 2/2] net-next: hn3: add tx push support in hns3 ring param process
Date:   Sat, 26 Mar 2022 16:51:02 +0800
Message-ID: <20220326085102.14111-3-wangjie125@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220326085102.14111-1-wangjie125@huawei.com>
References: <20220326085102.14111-1-wangjie125@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds tx push param to hns3 ring param and adapts the set and get
API of ring params. So users can set it by cmd ethtool -G and get it by cmd
ethtool -g.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 6469238ae090..845a56b93075 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -664,6 +664,8 @@ static void hns3_get_ringparam(struct net_device *netdev,
 	param->tx_pending = priv->ring[0].desc_num;
 	param->rx_pending = priv->ring[rx_queue_index].desc_num;
 	kernel_param->rx_buf_len = priv->ring[rx_queue_index].buf_size;
+	kernel_param->tx_push = test_bit(HNS3_NIC_STATE_TX_PUSH_ENABLE,
+					 &priv->state);
 }
 
 static void hns3_get_pauseparam(struct net_device *netdev,
@@ -1114,6 +1116,30 @@ static int hns3_change_rx_buf_len(struct net_device *ndev, u32 rx_buf_len)
 	return 0;
 }
 
+static int hns3_set_tx_push(struct net_device *netdev, u32 tx_push)
+{
+	struct hns3_nic_priv *priv = netdev_priv(netdev);
+	struct hnae3_handle *h = hns3_get_handle(netdev);
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
+	u32 old_state = test_bit(HNS3_NIC_STATE_TX_PUSH_ENABLE, &priv->state);
+
+	if (!test_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, ae_dev->caps) && tx_push)
+		return -EOPNOTSUPP;
+
+	if (tx_push == old_state)
+		return 0;
+
+	netdev_info(netdev, "Changing tx push from %s to %s\n",
+		    old_state ? "on" : "off", tx_push ? "on" : "off");
+
+	if (tx_push)
+		set_bit(HNS3_NIC_STATE_TX_PUSH_ENABLE, &priv->state);
+	else
+		clear_bit(HNS3_NIC_STATE_TX_PUSH_ENABLE, &priv->state);
+
+	return 0;
+}
+
 static int hns3_set_ringparam(struct net_device *ndev,
 			      struct ethtool_ringparam *param,
 			      struct kernel_ethtool_ringparam *kernel_param,
@@ -1133,6 +1159,10 @@ static int hns3_set_ringparam(struct net_device *ndev,
 	if (ret)
 		return ret;
 
+	ret = hns3_set_tx_push(ndev, kernel_param->tx_push);
+	if (ret)
+		return ret;
+
 	/* Hardware requires that its descriptors must be multiple of eight */
 	new_tx_desc_num = ALIGN(param->tx_pending, HNS3_RING_BD_MULTIPLE);
 	new_rx_desc_num = ALIGN(param->rx_pending, HNS3_RING_BD_MULTIPLE);
-- 
2.33.0

