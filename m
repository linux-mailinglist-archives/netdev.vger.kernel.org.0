Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A2042D866
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 13:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhJNLqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 07:46:08 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:13739 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbhJNLqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 07:46:06 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HVSDr24fYzWgL0;
        Thu, 14 Oct 2021 19:42:20 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 14 Oct 2021 19:43:59 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 14 Oct 2021 19:43:57 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <mkubecek@suse.cz>,
        <andrew@lunn.ch>, <amitc@mellanox.com>, <idosch@idosch.org>,
        <danieller@nvidia.com>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <jdike@addtoit.com>,
        <richard@nod.at>, <anton.ivanov@cambridgegreys.com>,
        <netanel@amazon.com>, <akiyano@amazon.com>, <gtzalik@amazon.com>,
        <saeedb@amazon.com>, <chris.snook@gmail.com>,
        <ulli.kroll@googlemail.com>, <linus.walleij@linaro.org>,
        <jeroendb@google.com>, <csully@google.com>,
        <awogbemila@google.com>, <jdmason@kudzu.us>,
        <rain.1986.08.12@gmail.com>, <zyjzyj2000@gmail.com>,
        <kys@microsoft.com>, <haiyangz@microsoft.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <doshir@vmware.com>,
        <pv-drivers@vmware.com>, <jwi@linux.ibm.com>,
        <kgraul@linux.ibm.com>, <hca@linux.ibm.com>, <gor@linux.ibm.com>,
        <johannes@sipsolutions.net>
CC:     <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>, <huangguangbin2@huawei.com>,
        <linux-s390@vger.kernel.org>
Subject: [PATCH V4 net-next 2/6] net: hns3: add support to set/get tx copybreak buf size via ethtool for hns3 driver
Date:   Thu, 14 Oct 2021 19:39:39 +0800
Message-ID: <20211014113943.16231-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014113943.16231-1-huangguangbin2@huawei.com>
References: <20211014113943.16231-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

Tx copybreak buf size is used for tx copybreak feature, the feature is
used for small size packet or frag. It adds a queue based tx shared
bounce buffer to memcpy the small packet when the len of xmitted skb is
below tx_copybreak(value to distinguish small size and normal size),
and reduce the overhead of dma map and unmap when IOMMU is on.

Support setting it via ethtool --set-tunable parameter and getting
it via ethtool --get-tunable parameter.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  4 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |  2 +
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 56 +++++++++++++++++++
 3 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index fea1be4c02ed..0dd8987d1228 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -5517,8 +5517,8 @@ static int hns3_reset_notify_uninit_enet(struct hnae3_handle *handle)
 	return 0;
 }
 
-static int hns3_reset_notify(struct hnae3_handle *handle,
-			     enum hnae3_reset_notify_type type)
+int hns3_reset_notify(struct hnae3_handle *handle,
+		      enum hnae3_reset_notify_type type)
 {
 	int ret = 0;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 6162d9f88e37..eefdcef341d2 100644
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
index 5ebd96f6833d..3b74b4824f1d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1693,6 +1693,7 @@ static int hns3_get_tunable(struct net_device *netdev,
 			    void *data)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
+	struct hnae3_handle *h = priv->ae_handle;
 	int ret = 0;
 
 	switch (tuna->id) {
@@ -1703,6 +1704,9 @@ static int hns3_get_tunable(struct net_device *netdev,
 	case ETHTOOL_RX_COPYBREAK:
 		*(u32 *)data = priv->rx_copybreak;
 		break;
+	case ETHTOOL_TX_COPYBREAK_BUF_SIZE:
+		*(u32 *)data = h->kinfo.tx_spare_buf_size;
+		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;
@@ -1711,11 +1715,43 @@ static int hns3_get_tunable(struct net_device *netdev,
 	return ret;
 }
 
+static int hns3_set_tx_spare_buf_size(struct net_device *netdev,
+				      u32 data)
+{
+	struct hns3_nic_priv *priv = netdev_priv(netdev);
+	struct hnae3_handle *h = priv->ae_handle;
+	int ret;
+
+	if (hns3_nic_resetting(netdev))
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
+	u32 old_tx_spare_buf_size, new_tx_spare_buf_size;
 	struct hnae3_handle *h = priv->ae_handle;
 	int i, ret = 0;
 
@@ -1733,6 +1769,26 @@ static int hns3_set_tunable(struct net_device *netdev,
 		for (i = h->kinfo.num_tqps; i < h->kinfo.num_tqps * 2; i++)
 			priv->ring[i].rx_copybreak = priv->rx_copybreak;
 
+		break;
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
+			return ret;
+		}
 		break;
 	default:
 		ret = -EOPNOTSUPP;
-- 
2.33.0

