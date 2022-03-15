Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715CE4D930A
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 04:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344657AbiCOD2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 23:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344720AbiCOD1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 23:27:53 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30949488A6
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 20:26:40 -0700 (PDT)
Received: from kwepemi500011.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KHf1355rczfYxd;
        Tue, 15 Mar 2022 11:25:11 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi500011.china.huawei.com (7.221.188.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 11:26:38 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 11:26:37 +0800
From:   Jie Wang <wangjie125@huawei.com>
To:     <mkubecek@suse.cz>, <davem@davemloft.net>, <kuba@kernel.org>,
        <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <huangguangbin2@huawei.com>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <moyufeng@huawei.com>, <linyunsheng@huawei.com>,
        <tanhuazhong@huawei.com>, <salil.mehta@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [RFC net-next 2/2] net: hns3: add ethtool set/get device features support for hns3 driver
Date:   Tue, 15 Mar 2022 11:21:08 +0800
Message-ID: <20220315032108.57228-3-wangjie125@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220315032108.57228-1-wangjie125@huawei.com>
References: <20220315032108.57228-1-wangjie125@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

This patch implements hns3 set_devfeatures/get_devfeatures hooks defined
in struct ethtool_ops.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  1 +
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 77 +++++++++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 9298fbecb31a..9ae5b3318dc4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -817,6 +817,7 @@ struct hnae3_roce_private_info {
 
 enum hnae3_pflag {
 	HNAE3_PFLAG_LIMIT_PROMISC,
+	HNAE3_PFLAG_PUSH_ENABLE,
 	HNAE3_PFLAG_MAX
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index c06c39ece80d..7ad141aed3aa 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1925,6 +1925,79 @@ static int hns3_get_link_ext_state(struct net_device *netdev,
 	return -ENODATA;
 }
 
+static int hns3_set_tx_push(struct net_device *netdev,
+			    struct ethtool_dev_features *dev_feat)
+{
+	struct hns3_nic_priv *priv = netdev_priv(netdev);
+	struct hnae3_handle *h = hns3_get_handle(netdev);
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
+
+	if (!test_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, ae_dev->caps))
+		return -EOPNOTSUPP;
+
+	if (dev_feat->data)
+		set_bit(HNAE3_PFLAG_PUSH_ENABLE, &priv->state);
+	else
+		clear_bit(HNAE3_PFLAG_PUSH_ENABLE, &priv->state);
+
+	return 0;
+}
+
+static int hns3_set_devfeatures(struct net_device *netdev,
+				struct ethtool_dev_features *dev_feat)
+{
+	struct set_proto {
+		u64 type;
+		int (*set_func)(struct net_device *dev,
+				struct ethtool_dev_features *feat);
+	} set_arr[] = {
+		{ ETHTOOL_DEV_TX_PUSH, hns3_set_tx_push },
+	};
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(set_arr); ++i) {
+		if (set_arr[i].type == dev_feat->type && set_arr[i].set_func)
+			return set_arr[i].set_func(netdev, dev_feat);
+	}
+
+	return -EINVAL;
+}
+
+static int hns3_get_tx_push(struct net_device *netdev,
+			    struct ethtool_dev_features *dev_feat)
+{
+	struct hns3_nic_priv *priv = netdev_priv(netdev);
+	struct hnae3_handle *h = hns3_get_handle(netdev);
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
+
+	if (!test_bit(HNAE3_DEV_SUPPORT_TX_PUSH_B, ae_dev->caps))
+		return -EOPNOTSUPP;
+
+	dev_feat->data = test_bit(HNAE3_PFLAG_PUSH_ENABLE, &priv->state);
+
+	return 0;
+}
+
+static int hns3_get_devfeatures(struct net_device *netdev,
+				struct ethtool_dev_features *dev_feat)
+{
+	struct get_proto {
+		u32 type;
+		int (*get_func)(struct net_device *netdev,
+				struct ethtool_dev_features *feat);
+	} get_arr[] = {
+		{ ETHTOOL_DEV_TX_PUSH, hns3_get_tx_push },
+	};
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(get_arr); ++i) {
+		if (get_arr[i].type == dev_feat->type && get_arr[i].get_func)
+			return get_arr[i].get_func(netdev, dev_feat);
+	}
+
+	return -EINVAL;
+}
+
 static const struct ethtool_ops hns3vf_ethtool_ops = {
 	.supported_coalesce_params = HNS3_ETHTOOL_COALESCE,
 	.supported_ring_params = HNS3_ETHTOOL_RING,
@@ -1955,6 +2028,8 @@ static const struct ethtool_ops hns3vf_ethtool_ops = {
 	.get_tunable = hns3_get_tunable,
 	.set_tunable = hns3_set_tunable,
 	.reset = hns3_set_reset,
+	.get_devfeatures = hns3_get_devfeatures,
+	.set_devfeatures = hns3_set_devfeatures,
 };
 
 static const struct ethtool_ops hns3_ethtool_ops = {
@@ -1999,6 +2074,8 @@ static const struct ethtool_ops hns3_ethtool_ops = {
 	.set_tunable = hns3_set_tunable,
 	.reset = hns3_set_reset,
 	.get_link_ext_state = hns3_get_link_ext_state,
+	.get_devfeatures = hns3_get_devfeatures,
+	.set_devfeatures = hns3_set_devfeatures,
 };
 
 void hns3_ethtool_set_ops(struct net_device *netdev)
-- 
2.33.0

