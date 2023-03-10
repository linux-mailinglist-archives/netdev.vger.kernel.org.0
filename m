Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58FF76B3850
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 09:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjCJIPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 03:15:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbjCJIPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 03:15:05 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0744C527B
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 00:15:02 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PXzL154c3znWWD;
        Fri, 10 Mar 2023 16:12:09 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 10 Mar 2023 16:15:00 +0800
From:   Hao Lan <lanhao@huawei.com>
To:     <andrew@lunn.ch>, <davem@davemloft.net>, <kuba@kernel.org>,
        <alexander.duyck@gmail.com>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <shenjian15@huawei.com>,
        <netdev@vger.kernel.org>, <wangjie125@huawei.com>
Subject: [PATCH v3 net-next] net: hns3: support wake on lan configuration and query
Date:   Fri, 10 Mar 2023 16:14:04 +0800
Message-ID: <20230310081404.947-1-lanhao@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The HNS3 driver supports Wake-on-LAN, which can wake up
the server from power off state to power on state by magic
packet or magic security packet.

ChangeLog:
v1->v2:
Deleted the debugfs function that overlaps with the ethtool function
from suggestion of Andrew Lunn.

v2->v3:
Return the wol configuration stored in driver,
suggested by Alexander H Duyck.

Signed-off-by: Hao Lan <lanhao@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  12 ++
 .../hns3/hns3_common/hclge_comm_cmd.c         |   1 +
 .../hns3/hns3_common/hclge_comm_cmd.h         |   3 +
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    |   3 +
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  27 ++++
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |  12 ++
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 126 ++++++++++++++++++
 .../hisilicon/hns3/hns3pf/hclge_main.h        |   8 ++
 8 files changed, 192 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 40f4306449eb..9c9c72dc57e0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -100,6 +100,7 @@ enum HNAE3_DEV_CAP_BITS {
 	HNAE3_DEV_SUPPORT_CQ_B,
 	HNAE3_DEV_SUPPORT_FEC_STATS_B,
 	HNAE3_DEV_SUPPORT_LANE_NUM_B,
+	HNAE3_DEV_SUPPORT_WOL_B,
 };
 
 #define hnae3_ae_dev_fd_supported(ae_dev) \
@@ -168,6 +169,9 @@ enum HNAE3_DEV_CAP_BITS {
 #define hnae3_ae_dev_lane_num_supported(ae_dev) \
 	test_bit(HNAE3_DEV_SUPPORT_LANE_NUM_B, (ae_dev)->caps)
 
+#define hnae3_ae_dev_wol_supported(ae_dev) \
+	test_bit(HNAE3_DEV_SUPPORT_WOL_B, (ae_dev)->caps)
+
 enum HNAE3_PF_CAP_BITS {
 	HNAE3_PF_SUPPORT_VLAN_FLTR_MDF_B = 0,
 };
@@ -561,6 +565,10 @@ struct hnae3_ae_dev {
  *   Get phc info
  * clean_vf_config
  *   Clean residual vf info after disable sriov
+ * get_wol
+ *   Get wake on lan info
+ * set_wol
+ *   Config wake on lan
  */
 struct hnae3_ae_ops {
 	int (*init_ae_dev)(struct hnae3_ae_dev *ae_dev);
@@ -760,6 +768,10 @@ struct hnae3_ae_ops {
 	void (*clean_vf_config)(struct hnae3_ae_dev *ae_dev, int num_vfs);
 	int (*get_dscp_prio)(struct hnae3_handle *handle, u8 dscp,
 			     u8 *tc_map_mode, u8 *priority);
+	void (*get_wol)(struct hnae3_handle *handle,
+			struct ethtool_wolinfo *wol);
+	int (*set_wol)(struct hnae3_handle *handle,
+		       struct ethtool_wolinfo *wol);
 };
 
 struct hnae3_dcb_ops {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
index f671a63cecde..cbbab5b2b402 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
@@ -155,6 +155,7 @@ static const struct hclge_comm_caps_bit_map hclge_pf_cmd_caps[] = {
 	{HCLGE_COMM_CAP_FD_B, HNAE3_DEV_SUPPORT_FD_B},
 	{HCLGE_COMM_CAP_FEC_STATS_B, HNAE3_DEV_SUPPORT_FEC_STATS_B},
 	{HCLGE_COMM_CAP_LANE_NUM_B, HNAE3_DEV_SUPPORT_LANE_NUM_B},
+	{HCLGE_COMM_CAP_WOL_B, HNAE3_DEV_SUPPORT_WOL_B},
 };
 
 static const struct hclge_comm_caps_bit_map hclge_vf_cmd_caps[] = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
index b1f9383b418f..de72ecbfd5ad 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
@@ -294,6 +294,8 @@ enum hclge_opcode_type {
 	HCLGE_PPP_CMD0_INT_CMD		= 0x2100,
 	HCLGE_PPP_CMD1_INT_CMD		= 0x2101,
 	HCLGE_MAC_ETHERTYPE_IDX_RD      = 0x2105,
+	HCLGE_OPC_WOL_GET_SUPPORTED_MODE	= 0x2201,
+	HCLGE_OPC_WOL_CFG		= 0x2202,
 	HCLGE_NCSI_INT_EN		= 0x2401,
 
 	/* ROH MAC commands */
@@ -345,6 +347,7 @@ enum HCLGE_COMM_CAP_BITS {
 	HCLGE_COMM_CAP_FD_B = 21,
 	HCLGE_COMM_CAP_FEC_STATS_B = 25,
 	HCLGE_COMM_CAP_LANE_NUM_B = 27,
+	HCLGE_COMM_CAP_WOL_B = 28,
 };
 
 enum HCLGE_COMM_API_CAP_BITS {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 66feb23f7b7b..4c3e90a1c4d0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -408,6 +408,9 @@ static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
 	}, {
 		.name = "support lane num",
 		.cap_bit = HNAE3_DEV_SUPPORT_LANE_NUM_B,
+	}, {
+		.name = "support wake on lan",
+		.cap_bit = HNAE3_DEV_SUPPORT_WOL_B,
 	}
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 55306fe8a540..10de2b4c401b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -2063,6 +2063,31 @@ static int hns3_get_link_ext_state(struct net_device *netdev,
 	return -ENODATA;
 }
 
+static void hns3_get_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
+{
+	struct hnae3_handle *handle = hns3_get_handle(netdev);
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
+	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+
+	if (!hnae3_ae_dev_wol_supported(ae_dev))
+		return;
+
+	ops->get_wol(handle, wol);
+}
+
+static int hns3_set_wol(struct net_device *netdev,
+			struct ethtool_wolinfo *wol)
+{
+	struct hnae3_handle *handle = hns3_get_handle(netdev);
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
+	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+
+	if (!hnae3_ae_dev_wol_supported(ae_dev))
+		return -EOPNOTSUPP;
+
+	return ops->set_wol(handle, wol);
+}
+
 static const struct ethtool_ops hns3vf_ethtool_ops = {
 	.supported_coalesce_params = HNS3_ETHTOOL_COALESCE,
 	.supported_ring_params = HNS3_ETHTOOL_RING,
@@ -2139,6 +2164,8 @@ static const struct ethtool_ops hns3_ethtool_ops = {
 	.set_tunable = hns3_set_tunable,
 	.reset = hns3_set_reset,
 	.get_link_ext_state = hns3_get_link_ext_state,
+	.get_wol = hns3_get_wol,
+	.set_wol = hns3_set_wol,
 };
 
 void hns3_ethtool_set_ops(struct net_device *netdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 43cada51d8cb..91c173f40701 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -872,6 +872,18 @@ struct hclge_phy_reg_cmd {
 	u8 rsv1[18];
 };
 
+struct hclge_wol_cfg_cmd {
+	__le32 wake_on_lan_mode;
+	u8 sopass[SOPASS_MAX];
+	u8 sopass_size;
+	u8 rsv[13];
+};
+
+struct hclge_query_wol_supported_cmd {
+	__le32 supported_wake_mode;
+	u8 rsv[20];
+};
+
 struct hclge_hw;
 int hclge_cmd_send(struct hclge_hw *hw, struct hclge_desc *desc, int num);
 enum hclge_comm_cmd_status hclge_cmd_mdio_write(struct hclge_hw *hw,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 1853f499cd94..71500844a23b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11533,6 +11533,120 @@ static void hclge_uninit_rxd_adv_layout(struct hclge_dev *hdev)
 		hclge_write_dev(&hdev->hw, HCLGE_RXD_ADV_LAYOUT_EN_REG, 0);
 }
 
+static int hclge_get_wol_supported_mode(struct hclge_dev *hdev,
+					u32 *wol_supported)
+{
+	struct hclge_query_wol_supported_cmd *wol_supported_cmd;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_WOL_GET_SUPPORTED_MODE,
+				   true);
+	wol_supported_cmd = (struct hclge_query_wol_supported_cmd *)desc.data;
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to query wol supported, ret = %d\n", ret);
+		return ret;
+	}
+
+	*wol_supported = le32_to_cpu(wol_supported_cmd->supported_wake_mode);
+
+	return 0;
+}
+
+static int hclge_set_wol_cfg(struct hclge_dev *hdev,
+			     struct hclge_wol_info *wol_info)
+{
+	struct hclge_wol_cfg_cmd *wol_cfg_cmd;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_WOL_CFG, false);
+	wol_cfg_cmd = (struct hclge_wol_cfg_cmd *)desc.data;
+	wol_cfg_cmd->wake_on_lan_mode = cpu_to_le32(wol_info->wol_current_mode);
+	wol_cfg_cmd->sopass_size = wol_info->wol_sopass_size;
+	memcpy(wol_cfg_cmd->sopass, wol_info->wol_sopass, SOPASS_MAX);
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"failed to set wol config, ret = %d\n", ret);
+
+	return ret;
+}
+
+static int hclge_update_wol(struct hclge_dev *hdev)
+{
+	struct hclge_wol_info *wol_info = &hdev->hw.mac.wol;
+
+	if (!hnae3_ae_dev_wol_supported(hdev->ae_dev))
+		return 0;
+
+	return hclge_set_wol_cfg(hdev, wol_info);
+}
+
+static int hclge_init_wol(struct hclge_dev *hdev)
+{
+	struct hclge_wol_info *wol_info = &hdev->hw.mac.wol;
+	int ret;
+
+	if (!hnae3_ae_dev_wol_supported(hdev->ae_dev))
+		return 0;
+
+	memset(wol_info, 0, sizeof(struct hclge_wol_info));
+	ret = hclge_get_wol_supported_mode(hdev,
+					   &wol_info->wol_support_mode);
+	if (ret) {
+		wol_info->wol_support_mode = 0;
+		return ret;
+	}
+
+	return hclge_update_wol(hdev);
+}
+
+static void hclge_get_wol(struct hnae3_handle *handle,
+			  struct ethtool_wolinfo *wol)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+	struct hclge_wol_info *wol_info = &hdev->hw.mac.wol;
+
+	wol->supported = wol_info->wol_support_mode;
+	wol->wolopts = wol_info->wol_current_mode;
+	if (wol_info->wol_current_mode & WAKE_MAGICSECURE)
+		memcpy(wol->sopass, wol_info->wol_sopass, SOPASS_MAX);
+}
+
+static int hclge_set_wol(struct hnae3_handle *handle,
+			 struct ethtool_wolinfo *wol)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+	struct hclge_wol_info *wol_info = &hdev->hw.mac.wol;
+	u32 wol_mode;
+	int ret;
+
+	wol_mode = wol->wolopts;
+	if (wol_mode & ~wol_info->wol_support_mode)
+		return -EINVAL;
+
+	wol_info->wol_current_mode = wol_mode;
+	if (wol_mode & WAKE_MAGICSECURE) {
+		memcpy(wol_info->wol_sopass, wol->sopass, SOPASS_MAX);
+		wol_info->wol_sopass_size = SOPASS_MAX;
+	} else {
+		wol_info->wol_sopass_size = 0;
+	}
+
+	ret = hclge_set_wol_cfg(hdev, wol_info);
+	if (ret)
+		wol_info->wol_current_mode = 0;
+
+	return ret;
+}
+
 static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 {
 	struct pci_dev *pdev = ae_dev->pdev;
@@ -11729,6 +11843,11 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	/* Enable MISC vector(vector0) */
 	hclge_enable_vector(&hdev->misc_vector, true);
 
+	ret = hclge_init_wol(hdev);
+	if (ret)
+		dev_warn(&pdev->dev,
+			 "failed to wake on lan init, ret = %d\n", ret);
+
 	hclge_state_init(hdev);
 	hdev->last_reset_time = jiffies;
 
@@ -12108,6 +12227,11 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev)
 
 	hclge_init_rxd_adv_layout(hdev);
 
+	ret = hclge_update_wol(hdev);
+	if (ret)
+		dev_err(&pdev->dev,
+			"failed to update wol config, ret = %d\n", ret);
+
 	dev_info(&pdev->dev, "Reset done, %s driver initialization finished.\n",
 		 HCLGE_DRIVER_NAME);
 
@@ -13154,6 +13278,8 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.get_link_diagnosis_info = hclge_get_link_diagnosis_info,
 	.clean_vf_config = hclge_clean_vport_config,
 	.get_dscp_prio = hclge_get_dscp_prio,
+	.get_wol = hclge_get_wol,
+	.set_wol = hclge_set_wol,
 };
 
 static struct hnae3_ae_algo ae_algo = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 13f23d606e77..81aa6b0facf5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -249,6 +249,13 @@ enum HCLGE_MAC_DUPLEX {
 #define QUERY_SFP_SPEED		0
 #define QUERY_ACTIVE_SPEED	1
 
+struct hclge_wol_info {
+	u32 wol_support_mode; /* store the wake on lan info */
+	u32 wol_current_mode;
+	u8 wol_sopass[SOPASS_MAX];
+	u8 wol_sopass_size;
+};
+
 struct hclge_mac {
 	u8 mac_id;
 	u8 phy_addr;
@@ -268,6 +275,7 @@ struct hclge_mac {
 	u32 user_fec_mode;
 	u32 fec_ability;
 	int link;	/* store the link status of mac & phy (if phy exists) */
+	struct hclge_wol_info wol;
 	struct phy_device *phydev;
 	struct mii_bus *mdio_bus;
 	phy_interface_t phy_if;
-- 
2.30.0

