Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370C150359E
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 11:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiDPJWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 05:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiDPJV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 05:21:59 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6418C49C8B;
        Sat, 16 Apr 2022 02:19:27 -0700 (PDT)
Received: from kwepemi500023.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KgSG03BGJzCr2Y;
        Sat, 16 Apr 2022 17:15:04 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500023.china.huawei.com (7.221.188.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 16 Apr 2022 17:19:25 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 16 Apr 2022 17:19:25 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 1/9] net: hns3: add ethtool parameter check for CQE/EQE mode
Date:   Sat, 16 Apr 2022 17:13:35 +0800
Message-ID: <20220416091343.35817-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220416091343.35817-1-huangguangbin2@huawei.com>
References: <20220416091343.35817-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

For DEVICE_VERSION_V2, the hardware does not support the CQE mode.
So add capability bit for coalesce CQE mode and add parameter check
for it in ethtool.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  4 +++
 .../hns3/hns3_common/hclge_comm_cmd.c         |  2 ++
 .../hns3/hns3_common/hclge_comm_cmd.h         |  1 +
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  5 +---
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 28 +++++++++++++++++--
 5 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 79c64f4e67d2..8a3a446219f7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -96,6 +96,7 @@ enum HNAE3_DEV_CAP_BITS {
 	HNAE3_DEV_SUPPORT_PORT_VLAN_BYPASS_B,
 	HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B,
 	HNAE3_DEV_SUPPORT_MC_MAC_MNG_B,
+	HNAE3_DEV_SUPPORT_CQ_B,
 };
 
 #define hnae3_dev_fd_supported(hdev) \
@@ -155,6 +156,9 @@ enum HNAE3_DEV_CAP_BITS {
 #define hnae3_ae_dev_mc_mac_mng_supported(ae_dev) \
 	test_bit(HNAE3_DEV_SUPPORT_MC_MAC_MNG_B, (ae_dev)->caps)
 
+#define hnae3_ae_dev_cq_supported(ae_dev) \
+	test_bit(HNAE3_DEV_SUPPORT_CQ_B, (ae_dev)->caps)
+
 enum HNAE3_PF_CAP_BITS {
 	HNAE3_PF_SUPPORT_VLAN_FLTR_MDF_B = 0,
 };
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
index c15ca710dabb..c8b151d29f53 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
@@ -149,6 +149,7 @@ static const struct hclge_comm_caps_bit_map hclge_pf_cmd_caps[] = {
 	{HCLGE_COMM_CAP_PORT_VLAN_BYPASS_B,
 	 HNAE3_DEV_SUPPORT_PORT_VLAN_BYPASS_B},
 	{HCLGE_COMM_CAP_PORT_VLAN_BYPASS_B, HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B},
+	{HCLGE_COMM_CAP_CQ_B, HNAE3_DEV_SUPPORT_CQ_B},
 };
 
 static const struct hclge_comm_caps_bit_map hclge_vf_cmd_caps[] = {
@@ -160,6 +161,7 @@ static const struct hclge_comm_caps_bit_map hclge_vf_cmd_caps[] = {
 	{HCLGE_COMM_CAP_QB_B, HNAE3_DEV_SUPPORT_QB_B},
 	{HCLGE_COMM_CAP_TX_PUSH_B, HNAE3_DEV_SUPPORT_TX_PUSH_B},
 	{HCLGE_COMM_CAP_RXD_ADV_LAYOUT_B, HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B},
+	{HCLGE_COMM_CAP_CQ_B, HNAE3_DEV_SUPPORT_CQ_B},
 };
 
 static void
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
index 876650eddac4..7a7d4cf9bf35 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
@@ -338,6 +338,7 @@ enum HCLGE_COMM_CAP_BITS {
 	HCLGE_COMM_CAP_PAUSE_B = 14,
 	HCLGE_COMM_CAP_RXD_ADV_LAYOUT_B = 15,
 	HCLGE_COMM_CAP_PORT_VLAN_BYPASS_B = 17,
+	HCLGE_COMM_CAP_CQ_B = 18,
 };
 
 enum HCLGE_COMM_API_CAP_BITS {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 14dc12c2155d..7e9f9da2f392 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -5159,10 +5159,7 @@ static void hns3_set_cq_period_mode(struct hns3_nic_priv *priv,
 			priv->tqp_vector[i].rx_group.dim.mode = mode;
 	}
 
-	/* only device version above V3(include V3), GL can switch CQ/EQ
-	 * period mode.
-	 */
-	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3) {
+	if (hnae3_ae_dev_cq_supported(ae_dev)) {
 		u32 new_mode;
 		u64 reg;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index f4da77452126..372b4c258df1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1385,11 +1385,33 @@ static int hns3_check_ql_coalesce_param(struct net_device *netdev,
 	return 0;
 }
 
-static int hns3_check_coalesce_para(struct net_device *netdev,
-				    struct ethtool_coalesce *cmd)
+static int
+hns3_check_cqe_coalesce_param(struct net_device *netdev,
+			      struct kernel_ethtool_coalesce *kernel_coal)
+{
+	struct hnae3_handle *handle = hns3_get_handle(netdev);
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
+
+	if ((kernel_coal->use_cqe_mode_tx || kernel_coal->use_cqe_mode_rx) &&
+	    !hnae3_ae_dev_cq_supported(ae_dev)) {
+		netdev_err(netdev, "coalesced cqe mode is not supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int
+hns3_check_coalesce_para(struct net_device *netdev,
+			 struct ethtool_coalesce *cmd,
+			 struct kernel_ethtool_coalesce *kernel_coal)
 {
 	int ret;
 
+	ret = hns3_check_cqe_coalesce_param(netdev, kernel_coal);
+	if (ret)
+		return ret;
+
 	ret = hns3_check_gl_coalesce_para(netdev, cmd);
 	if (ret) {
 		netdev_err(netdev,
@@ -1464,7 +1486,7 @@ static int hns3_set_coalesce(struct net_device *netdev,
 	if (hns3_nic_resetting(netdev))
 		return -EBUSY;
 
-	ret = hns3_check_coalesce_para(netdev, cmd);
+	ret = hns3_check_coalesce_para(netdev, cmd, kernel_coal);
 	if (ret)
 		return ret;
 
-- 
2.33.0

