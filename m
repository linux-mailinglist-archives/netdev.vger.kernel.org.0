Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDABC2AFF32
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgKLFcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:32:52 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7485 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728302AbgKLDfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 22:35:15 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CWnHN4bXnzhjlw;
        Thu, 12 Nov 2020 11:33:04 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Thu, 12 Nov 2020 11:33:03 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V3 net-next 10/10] net: hns3: add ethtool priv-flag for EQ/CQ
Date:   Thu, 12 Nov 2020 11:33:18 +0800
Message-ID: <1605151998-12633-11-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605151998-12633-1-git-send-email-tanhuazhong@huawei.com>
References: <1605151998-12633-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a control private flag in ethtool for switching EQ/CQ mode.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  2 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 19 +++++++++++++++--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  2 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 24 ++++++++++++++++++++++
 4 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 345e8a4..a452874 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -719,6 +719,8 @@ struct hnae3_roce_private_info {
 
 enum hnae3_pflag {
 	HNAE3_PFLAG_DIM_ENABLE,
+	HNAE3_PFLAG_TX_CQE_MODE,
+	HNAE3_PFLAG_RX_CQE_MODE,
 	HNAE3_PFLAG_MAX
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index d1243ea..93f7731 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4144,6 +4144,7 @@ static void hns3_info_show(struct hns3_nic_priv *priv)
 
 static void hns3_state_init(struct hnae3_handle *handle)
 {
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
 	struct net_device *netdev = handle->kinfo.netdev;
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 
@@ -4151,10 +4152,24 @@ static void hns3_state_init(struct hnae3_handle *handle)
 	set_bit(HNS3_NIC_STATE_DIM_ENABLE, &priv->state);
 	handle->priv_flags |= BIT(HNAE3_PFLAG_DIM_ENABLE);
 	set_bit(HNAE3_PFLAG_DIM_ENABLE, &handle->supported_pflags);
+
+	/* device version above V3(include V3), GL can switch CQ/EQ period
+	 * mode.
+	 */
+	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3) {
+		set_bit(HNAE3_PFLAG_TX_CQE_MODE, &handle->supported_pflags);
+		set_bit(HNAE3_PFLAG_RX_CQE_MODE, &handle->supported_pflags);
+	}
+
+	if (priv->tx_cqe_mode == DIM_CQ_PERIOD_MODE_START_FROM_CQE)
+		handle->priv_flags |= BIT(HNAE3_PFLAG_TX_CQE_MODE);
+
+	if (priv->rx_cqe_mode == DIM_CQ_PERIOD_MODE_START_FROM_CQE)
+		handle->priv_flags |= BIT(HNAE3_PFLAG_RX_CQE_MODE);
 }
 
-static void hns3_set_cq_period_mode(struct hns3_nic_priv *priv,
-				    enum dim_cq_period_mode mode, bool is_tx)
+void hns3_set_cq_period_mode(struct hns3_nic_priv *priv,
+			     enum dim_cq_period_mode mode, bool is_tx)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(priv->ae_handle->pdev);
 	struct hnae3_handle *handle = priv->ae_handle;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index c6c082a..ecdb544 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -635,4 +635,6 @@ void hns3_dbg_uninit(struct hnae3_handle *handle);
 void hns3_dbg_register_debugfs(const char *debugfs_dir_name);
 void hns3_dbg_unregister_debugfs(void);
 void hns3_shinfo_pack(struct skb_shared_info *shinfo, __u32 *size);
+void hns3_set_cq_period_mode(struct hns3_nic_priv *priv,
+			     enum dim_cq_period_mode mode, bool is_tx);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 7462d43..ba9c0fe 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -417,8 +417,32 @@ static void hns3_update_dim_state(struct net_device *netdev, bool enable)
 	hns3_update_state(netdev, HNS3_NIC_STATE_DIM_ENABLE, enable);
 }
 
+static void hns3_update_cqe_mode(struct net_device *netdev, bool enable,
+				 bool is_tx)
+{
+	struct hns3_nic_priv *priv = netdev_priv(netdev);
+	enum dim_cq_period_mode mode;
+
+	mode = enable ? DIM_CQ_PERIOD_MODE_START_FROM_CQE :
+		DIM_CQ_PERIOD_MODE_START_FROM_EQE;
+
+	hns3_set_cq_period_mode(priv, mode, is_tx);
+}
+
+static void hns3_update_tx_cqe_mode(struct net_device *netdev, bool enable)
+{
+	hns3_update_cqe_mode(netdev, enable, true);
+}
+
+static void hns3_update_rx_cqe_mode(struct net_device *netdev, bool enable)
+{
+	hns3_update_cqe_mode(netdev, enable, false);
+}
+
 static const struct hns3_pflag_desc hns3_priv_flags[HNAE3_PFLAG_MAX] = {
 	{ "dim_enable",		hns3_update_dim_state },
+	{ "tx_cqe_mode",	hns3_update_tx_cqe_mode },
+	{ "rx_cqe_mode",	hns3_update_rx_cqe_mode },
 };
 
 static int hns3_get_sset_count(struct net_device *netdev, int stringset)
-- 
2.7.4

