Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5B43F970E
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 11:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244789AbhH0JdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 05:33:09 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14425 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244727AbhH0JdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 05:33:07 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GwvXT20nvzbcvZ;
        Fri, 27 Aug 2021 17:28:25 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 27 Aug 2021 17:32:16 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 27 Aug 2021 17:32:16 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 2/8] net: hns3: add hns3_state_init() to do state initialization
Date:   Fri, 27 Aug 2021 17:28:18 +0800
Message-ID: <1630056504-31725-3-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1630056504-31725-1-git-send-email-huangguangbin2@huawei.com>
References: <1630056504-31725-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

To improve the readability and maintainability, add hns3_state_init() to
initialize the state, and this new function will be used to add more state
initialization in the future.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 29 ++++++++++++++++---------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 39d01ca026da..ab14beb65aaf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -5063,6 +5063,24 @@ void hns3_cq_period_mode_init(struct hns3_nic_priv *priv,
 	hns3_set_cq_period_mode(priv, rx_mode, false);
 }
 
+static void hns3_state_init(struct hnae3_handle *handle)
+{
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
+	struct net_device *netdev = handle->kinfo.netdev;
+	struct hns3_nic_priv *priv = netdev_priv(netdev);
+
+	set_bit(HNS3_NIC_STATE_INITED, &priv->state);
+
+	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3)
+		set_bit(HNAE3_PFLAG_LIMIT_PROMISC, &handle->supported_pflags);
+
+	if (test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps))
+		set_bit(HNS3_NIC_STATE_HW_TX_CSUM_ENABLE, &priv->state);
+
+	if (hnae3_ae_dev_rxd_adv_layout_supported(ae_dev))
+		set_bit(HNS3_NIC_STATE_RXD_ADV_LAYOUT_ENABLE, &priv->state);
+}
+
 static int hns3_client_init(struct hnae3_handle *handle)
 {
 	struct pci_dev *pdev = handle->pdev;
@@ -5166,16 +5184,7 @@ static int hns3_client_init(struct hnae3_handle *handle)
 
 	netdev->max_mtu = HNS3_MAX_MTU(ae_dev->dev_specs.max_frm_size);
 
-	if (test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps))
-		set_bit(HNS3_NIC_STATE_HW_TX_CSUM_ENABLE, &priv->state);
-
-	if (hnae3_ae_dev_rxd_adv_layout_supported(ae_dev))
-		set_bit(HNS3_NIC_STATE_RXD_ADV_LAYOUT_ENABLE, &priv->state);
-
-	set_bit(HNS3_NIC_STATE_INITED, &priv->state);
-
-	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3)
-		set_bit(HNAE3_PFLAG_LIMIT_PROMISC, &handle->supported_pflags);
+	hns3_state_init(handle);
 
 	ret = register_netdev(netdev);
 	if (ret) {
-- 
2.8.1

