Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426353F6FC0
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 08:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239116AbhHYGpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 02:45:38 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14413 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238483AbhHYGpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 02:45:33 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Gvbw83FwVzbdLH;
        Wed, 25 Aug 2021 14:40:56 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 25 Aug 2021 14:44:46 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 25 Aug 2021 14:44:46 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <mkubecek@suse.cz>,
        <andrew@lunn.ch>, <amitc@mellanox.com>, <idosch@idosch.org>,
        <danieller@nvidia.com>
CC:     <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 2/5] net: hns3: add support to set/get tx spare buf via ethtool for hns3 driver
Date:   Wed, 25 Aug 2021 14:40:52 +0800
Message-ID: <1629873655-51539-3-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1629873655-51539-1-git-send-email-huangguangbin2@huawei.com>
References: <1629873655-51539-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

Tx spare buf size is used for tx copybreak feature, the feature is
used for small size packet or frag. It adds a queue based tx shared
bounce buffer to memcpy the small packet when the len of xmitted skb is
below tx_copybreak(value to distinguish small size and normal size),
and reduce the overhead of dma map and unmap when IOMMU is on.

Support setting it via ethtool --set-tunable parameter and getting
it via ethtool --get-tunable parameter.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  4 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 56 ++++++++++++++++++++++
 3 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 39d01ca026da..c945fa4b3c9c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -5533,8 +5533,8 @@ static int hns3_reset_notify_uninit_enet(struct hnae3_handle *handle)
 	return 0;
 }
 
-static int hns3_reset_notify(struct hnae3_handle *handle,
-			     enum hnae3_reset_notify_type type)
+int hns3_reset_notify(struct hnae3_handle *handle,
+		      enum hnae3_reset_notify_type type)
 {
 	int ret = 0;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index dfad9060c284..3287d846d7e0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -705,6 +705,8 @@ void hns3_set_vector_coalesce_tx_ql(struct hns3_enet_tqp_vector *tqp_vector,
 				    u32 ql_value);
 
 void hns3_request_update_promisc_mode(struct hnae3_handle *handle);
+int hns3_reset_notify(struct hnae3_handle *handle,
+		      enum hnae3_reset_notify_type type);
 
 #ifdef CONFIG_HNS3_DCB
 void hns3_dcbnl_setup(struct hnae3_handle *handle);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index b8d9851aefc5..5a21b9eb9820 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1664,6 +1664,7 @@ static int hns3_get_tunable(struct net_device *netdev,
 			    void *data)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
+	struct hnae3_handle *h = priv->ae_handle;
 	int ret = 0;
 
 	switch (tuna->id) {
@@ -1674,6 +1675,9 @@ static int hns3_get_tunable(struct net_device *netdev,
 	case ETHTOOL_RX_COPYBREAK:
 		*(u32 *)data = priv->rx_copybreak;
 		break;
+	case ETHTOOL_TX_COPYBREAK_BUF_SIZE:
+		*(u32 *)data = h->kinfo.tx_spare_buf_size;
+		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;
@@ -1682,12 +1686,44 @@ static int hns3_get_tunable(struct net_device *netdev,
 	return ret;
 }
 
+static int hns3_set_tx_spare_buf_size(struct net_device *netdev,
+				      u32 data)
+{
+	struct hns3_nic_priv *priv = netdev_priv(netdev);
+	struct hnae3_handle *h = priv->ae_handle;
+	int ret;
+
+	if (test_bit(HNS3_NIC_STATE_RESETTING, &priv->state))
+		return -EBUSY;
+
+	h->kinfo.tx_spare_buf_size = data;
+
+	ret = hns3_reset_notify(h, HNAE3_DOWN_CLIENT);
+	if (ret)
+		return ret;
+
+	ret = hns3_reset_notify(h, HNAE3_UNINIT_CLIENT);
+	if (ret)
+		return ret;
+
+	ret = hns3_reset_notify(h, HNAE3_INIT_CLIENT);
+	if (ret)
+		return ret;
+
+	ret = hns3_reset_notify(h, HNAE3_UP_CLIENT);
+	if (ret)
+		hns3_reset_notify(h, HNAE3_UNINIT_CLIENT);
+
+	return ret;
+}
+
 static int hns3_set_tunable(struct net_device *netdev,
 			    const struct ethtool_tunable *tuna,
 			    const void *data)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hnae3_handle *h = priv->ae_handle;
+	u32 old_tx_spare_buf_size, new_tx_spare_buf_size;
 	int i, ret = 0;
 
 	switch (tuna->id) {
@@ -1705,6 +1741,26 @@ static int hns3_set_tunable(struct net_device *netdev,
 			priv->ring[i].rx_copybreak = priv->rx_copybreak;
 
 		break;
+	case ETHTOOL_TX_COPYBREAK_BUF_SIZE:
+		old_tx_spare_buf_size = h->kinfo.tx_spare_buf_size;
+		new_tx_spare_buf_size = *(u32 *)data;
+		ret = hns3_set_tx_spare_buf_size(netdev, new_tx_spare_buf_size);
+		if (ret) {
+			int ret1;
+
+			netdev_warn(netdev,
+				    "change tx spare buf size fail, revert to old value\n");
+			ret1 = hns3_set_tx_spare_buf_size(netdev,
+							  old_tx_spare_buf_size);
+			if (ret1) {
+				netdev_err(netdev,
+					   "revert to old tx spare buf size fail\n");
+				return ret1;
+			}
+
+		return ret;
+		}
+		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;
-- 
2.8.1

