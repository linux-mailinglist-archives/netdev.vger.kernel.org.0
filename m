Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB96453E23
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 03:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhKQCDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 21:03:16 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:14757 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbhKQCDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 21:03:14 -0500
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hv5fl5q5ZzZd74;
        Wed, 17 Nov 2021 09:57:51 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 17 Nov 2021 10:00:04 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 17 Nov 2021 10:00:03 +0800
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
Subject: [RESEND PATCH V6 net-next 5/6] net: hns3: add support to set/get rx buf len via ethtool for hns3 driver
Date:   Wed, 17 Nov 2021 09:55:25 +0800
Message-ID: <20211117015526.27593-6-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211117015526.27593-1-huangguangbin2@huawei.com>
References: <20211117015526.27593-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

Rx buf len is for rx BD buffer size, support setting it via ethtool -G
parameter and getting it via ethtool -g parameter.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 52 ++++++++++++++++---
 1 file changed, 44 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index e35a2661b45d..6b49ecb4a6f3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -649,7 +649,7 @@ static void hns3_get_ringparam(struct net_device *netdev,
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hnae3_handle *h = priv->ae_handle;
-	int queue_num = h->kinfo.num_tqps;
+	int rx_queue_index = h->kinfo.num_tqps;
 
 	if (hns3_nic_resetting(netdev)) {
 		netdev_err(netdev, "dev resetting!");
@@ -660,7 +660,8 @@ static void hns3_get_ringparam(struct net_device *netdev,
 	param->rx_max_pending = HNS3_RING_MAX_PENDING;
 
 	param->tx_pending = priv->ring[0].desc_num;
-	param->rx_pending = priv->ring[queue_num].desc_num;
+	param->rx_pending = priv->ring[rx_queue_index].desc_num;
+	kernel_param->rx_buf_len = priv->ring[rx_queue_index].buf_size;
 }
 
 static void hns3_get_pauseparam(struct net_device *netdev,
@@ -1062,14 +1063,23 @@ static struct hns3_enet_ring *hns3_backup_ringparam(struct hns3_nic_priv *priv)
 }
 
 static int hns3_check_ringparam(struct net_device *ndev,
-				struct ethtool_ringparam *param)
+				struct ethtool_ringparam *param,
+				struct kernel_ethtool_ringparam *kernel_param)
 {
+#define RX_BUF_LEN_2K 2048
+#define RX_BUF_LEN_4K 4096
 	if (hns3_nic_resetting(ndev))
 		return -EBUSY;
 
 	if (param->rx_mini_pending || param->rx_jumbo_pending)
 		return -EINVAL;
 
+	if (kernel_param->rx_buf_len != RX_BUF_LEN_2K &&
+	    kernel_param->rx_buf_len != RX_BUF_LEN_4K) {
+		netdev_err(ndev, "Rx buf len only support 2048 and 4096\n");
+		return -EINVAL;
+	}
+
 	if (param->tx_pending > HNS3_RING_MAX_PENDING ||
 	    param->tx_pending < HNS3_RING_MIN_PENDING ||
 	    param->rx_pending > HNS3_RING_MAX_PENDING ||
@@ -1082,6 +1092,22 @@ static int hns3_check_ringparam(struct net_device *ndev,
 	return 0;
 }
 
+static int hns3_change_rx_buf_len(struct net_device *ndev, u32 rx_buf_len)
+{
+	struct hns3_nic_priv *priv = netdev_priv(ndev);
+	struct hnae3_handle *h = priv->ae_handle;
+	int i;
+
+	h->kinfo.rx_buf_len = rx_buf_len;
+
+	for (i = 0; i < h->kinfo.num_tqps; i++) {
+		h->kinfo.tqp[i]->buf_size = rx_buf_len;
+		priv->ring[i + h->kinfo.num_tqps].buf_size = rx_buf_len;
+	}
+
+	return 0;
+}
+
 static int hns3_set_ringparam(struct net_device *ndev,
 			      struct ethtool_ringparam *param,
 			      struct kernel_ethtool_ringparam *kernel_param,
@@ -1094,9 +1120,10 @@ static int hns3_set_ringparam(struct net_device *ndev,
 	u32 old_tx_desc_num, new_tx_desc_num;
 	u32 old_rx_desc_num, new_rx_desc_num;
 	u16 queue_num = h->kinfo.num_tqps;
+	u32 old_rx_buf_len;
 	int ret, i;
 
-	ret = hns3_check_ringparam(ndev, param);
+	ret = hns3_check_ringparam(ndev, param, kernel_param);
 	if (ret)
 		return ret;
 
@@ -1105,8 +1132,10 @@ static int hns3_set_ringparam(struct net_device *ndev,
 	new_rx_desc_num = ALIGN(param->rx_pending, HNS3_RING_BD_MULTIPLE);
 	old_tx_desc_num = priv->ring[0].desc_num;
 	old_rx_desc_num = priv->ring[queue_num].desc_num;
+	old_rx_buf_len = priv->ring[queue_num].buf_size;
 	if (old_tx_desc_num == new_tx_desc_num &&
-	    old_rx_desc_num == new_rx_desc_num)
+	    old_rx_desc_num == new_rx_desc_num &&
+	    kernel_param->rx_buf_len == old_rx_buf_len)
 		return 0;
 
 	tmp_rings = hns3_backup_ringparam(priv);
@@ -1117,19 +1146,22 @@ static int hns3_set_ringparam(struct net_device *ndev,
 	}
 
 	netdev_info(ndev,
-		    "Changing Tx/Rx ring depth from %u/%u to %u/%u\n",
+		    "Changing Tx/Rx ring depth from %u/%u to %u/%u, Changing rx buffer len from %d to %d\n",
 		    old_tx_desc_num, old_rx_desc_num,
-		    new_tx_desc_num, new_rx_desc_num);
+		    new_tx_desc_num, new_rx_desc_num,
+		    old_rx_buf_len, kernel_param->rx_buf_len);
 
 	if (if_running)
 		ndev->netdev_ops->ndo_stop(ndev);
 
 	hns3_change_all_ring_bd_num(priv, new_tx_desc_num, new_rx_desc_num);
+	hns3_change_rx_buf_len(ndev, kernel_param->rx_buf_len);
 	ret = hns3_init_all_ring(priv);
 	if (ret) {
-		netdev_err(ndev, "Change bd num fail, revert to old value(%d)\n",
+		netdev_err(ndev, "set ringparam fail, revert to old value(%d)\n",
 			   ret);
 
+		hns3_change_rx_buf_len(ndev, old_rx_buf_len);
 		hns3_change_all_ring_bd_num(priv, old_tx_desc_num,
 					    old_rx_desc_num);
 		for (i = 0; i < h->kinfo.num_tqps * 2; i++)
@@ -1811,6 +1843,8 @@ static int hns3_set_tunable(struct net_device *netdev,
 				 ETHTOOL_COALESCE_MAX_FRAMES |		\
 				 ETHTOOL_COALESCE_USE_CQE)
 
+#define HNS3_ETHTOOL_RING	ETHTOOL_RING_USE_RX_BUF_LEN
+
 static int hns3_get_ts_info(struct net_device *netdev,
 			    struct ethtool_ts_info *info)
 {
@@ -1889,6 +1923,7 @@ static int hns3_get_link_ext_state(struct net_device *netdev,
 
 static const struct ethtool_ops hns3vf_ethtool_ops = {
 	.supported_coalesce_params = HNS3_ETHTOOL_COALESCE,
+	.supported_ring_params = HNS3_ETHTOOL_RING,
 	.get_drvinfo = hns3_get_drvinfo,
 	.get_ringparam = hns3_get_ringparam,
 	.set_ringparam = hns3_set_ringparam,
@@ -1920,6 +1955,7 @@ static const struct ethtool_ops hns3vf_ethtool_ops = {
 
 static const struct ethtool_ops hns3_ethtool_ops = {
 	.supported_coalesce_params = HNS3_ETHTOOL_COALESCE,
+	.supported_ring_params = HNS3_ETHTOOL_RING,
 	.self_test = hns3_self_test,
 	.get_drvinfo = hns3_get_drvinfo,
 	.get_link = hns3_get_link,
-- 
2.33.0

