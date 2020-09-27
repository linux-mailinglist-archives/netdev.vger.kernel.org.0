Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFC5279F37
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 09:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730518AbgI0HQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 03:16:06 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14241 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730330AbgI0HPp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Sep 2020 03:15:45 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5AEE064110748998A066;
        Sun, 27 Sep 2020 15:15:41 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Sun, 27 Sep 2020 15:15:32 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 01/10] net: hns3: add device version to replace pci revision
Date:   Sun, 27 Sep 2020 15:12:39 +0800
Message-ID: <1601190768-50075-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1601190768-50075-1-git-send-email-tanhuazhong@huawei.com>
References: <1601190768-50075-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

To better identify the device version, struct hnae3_handle adds a
member dev_version to replace pci revision. The dev_version consists
of hardware version and PCI revision. The hardware version is queried
from firmware by an existing firmware version query command.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  8 +++++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 10 +++++--
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 21 +++++++++----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c | 30 ++++++++++---------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  3 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 11 +++----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 34 ++++++++++++----------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   | 32 ++++++++++----------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |  3 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 17 +++++------
 10 files changed, 100 insertions(+), 69 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index ad7257e..e5835ee 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -34,6 +34,13 @@
 
 #define HNAE3_MIN_VECTOR_NUM	2 /* first one for misc, another for IO */
 
+/* Device version */
+#define HNAE3_DEVICE_VERSION_V1   0x00020
+#define HNAE3_DEVICE_VERSION_V2   0x00021
+#define HNAE3_DEVICE_VERSION_V3   0x00030
+
+#define HNAE3_PCI_REVISION_BIT_SIZE		8
+
 /* Device IDs */
 #define HNAE3_DEV_ID_GE				0xA220
 #define HNAE3_DEV_ID_25GE			0xA221
@@ -235,6 +242,7 @@ struct hnae3_ae_dev {
 	struct list_head node;
 	u32 flag;
 	unsigned long hw_err_reset_req;
+	u32 dev_version;
 	void *priv;
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 00e4002..c44a685 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -629,9 +629,11 @@ void hns3_enable_vlan_filter(struct net_device *netdev, bool enable)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hnae3_handle *h = priv->ae_handle;
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
 	bool last_state;
 
-	if (h->pdev->revision >= 0x21 && h->ae_algo->ops->enable_vlan_filter) {
+	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2 &&
+	    h->ae_algo->ops->enable_vlan_filter) {
 		last_state = h->netdev_flags & HNAE3_VLAN_FLTR ? true : false;
 		if (enable != last_state) {
 			netdev_info(netdev,
@@ -2265,6 +2267,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 	struct pci_dev *pdev = h->pdev;
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(pdev);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
@@ -2302,7 +2305,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 		NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_SCTP_CRC |
 		NETIF_F_FRAGLIST;
 
-	if (pdev->revision >= 0x21) {
+	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
 		netdev->hw_features |= NETIF_F_GRO_HW;
 		netdev->features |= NETIF_F_GRO_HW;
 
@@ -2801,8 +2804,9 @@ static bool hns3_parse_vlan_tag(struct hns3_enet_ring *ring,
 {
 	struct hnae3_handle *handle = ring->tqp->handle;
 	struct pci_dev *pdev = ring->tqp->handle->pdev;
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(pdev);
 
-	if (pdev->revision == 0x20) {
+	if (unlikely(ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2)) {
 		*vlan_tag = le16_to_cpu(desc->rx.ot_vlan_tag);
 		if (!(*vlan_tag & VLAN_VID_MASK))
 			*vlan_tag = le16_to_cpu(desc->rx.vlan_tag);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 52c7804..df28811 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -77,6 +77,7 @@ static const struct hns3_stats hns3_rxq_stats[] = {
 static int hns3_lp_setup(struct net_device *ndev, enum hnae3_loop loop, bool en)
 {
 	struct hnae3_handle *h = hns3_get_handle(ndev);
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
 	bool vlan_filter_enable;
 	int ret;
 
@@ -96,7 +97,7 @@ static int hns3_lp_setup(struct net_device *ndev, enum hnae3_loop loop, bool en)
 		break;
 	}
 
-	if (ret || h->pdev->revision >= 0x21)
+	if (ret || ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2)
 		return ret;
 
 	if (en) {
@@ -147,6 +148,7 @@ static void hns3_lp_setup_skb(struct sk_buff *skb)
 
 	struct net_device *ndev = skb->dev;
 	struct hnae3_handle *handle;
+	struct hnae3_ae_dev *ae_dev;
 	unsigned char *packet;
 	struct ethhdr *ethh;
 	unsigned int i;
@@ -163,7 +165,8 @@ static void hns3_lp_setup_skb(struct sk_buff *skb)
 	 * the purpose of mac or serdes selftest.
 	 */
 	handle = hns3_get_handle(ndev);
-	if (handle->pdev->revision == 0x20)
+	ae_dev = pci_get_drvdata(handle->pdev);
+	if (ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2)
 		ethh->h_dest[5] += HNS3_NIC_LB_DST_MAC_ADDR;
 	eth_zero_addr(ethh->h_source);
 	ethh->h_proto = htons(ETH_P_ARP);
@@ -761,6 +764,7 @@ static int hns3_set_link_ksettings(struct net_device *netdev,
 				   const struct ethtool_link_ksettings *cmd)
 {
 	struct hnae3_handle *handle = hns3_get_handle(netdev);
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
 	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
 	int ret;
 
@@ -782,7 +786,7 @@ static int hns3_set_link_ksettings(struct net_device *netdev,
 		return phy_ethtool_ksettings_set(netdev->phydev, cmd);
 	}
 
-	if (handle->pdev->revision == 0x20)
+	if (ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2)
 		return -EOPNOTSUPP;
 
 	ret = hns3_check_ksettings_param(netdev, cmd);
@@ -846,11 +850,12 @@ static int hns3_set_rss(struct net_device *netdev, const u32 *indir,
 			const u8 *key, const u8 hfunc)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
 
 	if (!h->ae_algo->ops->set_rss)
 		return -EOPNOTSUPP;
 
-	if ((h->pdev->revision == 0x20 &&
+	if ((ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2 &&
 	     hfunc != ETH_RSS_HASH_TOP) || (hfunc != ETH_RSS_HASH_NO_CHANGE &&
 	     hfunc != ETH_RSS_HASH_TOP && hfunc != ETH_RSS_HASH_XOR)) {
 		netdev_err(netdev, "hash func not supported\n");
@@ -1404,11 +1409,13 @@ static int hns3_get_module_info(struct net_device *netdev,
 #define HNS3_SFF_8636_V1_3 0x03
 
 	struct hnae3_handle *handle = hns3_get_handle(netdev);
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
 	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
 	struct hns3_sfp_type sfp_type;
 	int ret;
 
-	if (handle->pdev->revision == 0x20 || !ops->get_module_eeprom)
+	if (ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2 ||
+	    !ops->get_module_eeprom)
 		return -EOPNOTSUPP;
 
 	memset(&sfp_type, 0, sizeof(sfp_type));
@@ -1452,9 +1459,11 @@ static int hns3_get_module_eeprom(struct net_device *netdev,
 				  struct ethtool_eeprom *ee, u8 *data)
 {
 	struct hnae3_handle *handle = hns3_get_handle(netdev);
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
 	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
 
-	if (handle->pdev->revision == 0x20 || !ops->get_module_eeprom)
+	if (ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2 ||
+	    !ops->get_module_eeprom)
 		return -EOPNOTSUPP;
 
 	if (!ee->len)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 81aa67b..03b7a96 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -330,9 +330,9 @@ int hclge_cmd_send(struct hclge_hw *hw, struct hclge_desc *desc, int num)
 	return retval;
 }
 
-static enum hclge_cmd_status hclge_cmd_query_firmware_version(
-		struct hclge_hw *hw, u32 *version)
+static enum hclge_cmd_status hclge_cmd_query_version(struct hclge_dev *hdev)
 {
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
 	struct hclge_query_version_cmd *resp;
 	struct hclge_desc desc;
 	int ret;
@@ -340,9 +340,15 @@ static enum hclge_cmd_status hclge_cmd_query_firmware_version(
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_QUERY_FW_VER, 1);
 	resp = (struct hclge_query_version_cmd *)desc.data;
 
-	ret = hclge_cmd_send(hw, &desc, 1);
-	if (!ret)
-		*version = le32_to_cpu(resp->firmware);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret)
+		return ret;
+
+	hdev->fw_version = le32_to_cpu(resp->firmware);
+
+	ae_dev->dev_version = le32_to_cpu(resp->hardware) <<
+					 HNAE3_PCI_REVISION_BIT_SIZE;
+	ae_dev->dev_version |= hdev->pdev->revision;
 
 	return ret;
 }
@@ -402,7 +408,6 @@ static int hclge_firmware_compat_config(struct hclge_dev *hdev)
 
 int hclge_cmd_init(struct hclge_dev *hdev)
 {
-	u32 version;
 	int ret;
 
 	spin_lock_bh(&hdev->hw.cmq.csq.lock);
@@ -431,22 +436,21 @@ int hclge_cmd_init(struct hclge_dev *hdev)
 		goto err_cmd_init;
 	}
 
-	ret = hclge_cmd_query_firmware_version(&hdev->hw, &version);
+	ret = hclge_cmd_query_version(hdev);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
-			"firmware version query failed %d\n", ret);
+			"failed to query version ret=%d\n", ret);
 		goto err_cmd_init;
 	}
-	hdev->fw_version = version;
 
 	dev_info(&hdev->pdev->dev, "The firmware version is %lu.%lu.%lu.%lu\n",
-		 hnae3_get_field(version, HNAE3_FW_VERSION_BYTE3_MASK,
+		 hnae3_get_field(hdev->fw_version, HNAE3_FW_VERSION_BYTE3_MASK,
 				 HNAE3_FW_VERSION_BYTE3_SHIFT),
-		 hnae3_get_field(version, HNAE3_FW_VERSION_BYTE2_MASK,
+		 hnae3_get_field(hdev->fw_version, HNAE3_FW_VERSION_BYTE2_MASK,
 				 HNAE3_FW_VERSION_BYTE2_SHIFT),
-		 hnae3_get_field(version, HNAE3_FW_VERSION_BYTE1_MASK,
+		 hnae3_get_field(hdev->fw_version, HNAE3_FW_VERSION_BYTE1_MASK,
 				 HNAE3_FW_VERSION_BYTE1_SHIFT),
-		 hnae3_get_field(version, HNAE3_FW_VERSION_BYTE0_MASK,
+		 hnae3_get_field(hdev->fw_version, HNAE3_FW_VERSION_BYTE0_MASK,
 				 HNAE3_FW_VERSION_BYTE0_SHIFT));
 
 	/* ask the firmware to enable some features, driver can work without
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 30983f0..de73463 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -364,7 +364,8 @@ struct hclge_rx_priv_buff_cmd {
 
 struct hclge_query_version_cmd {
 	__le32 firmware;
-	__le32 firmware_rsv[5];
+	__le32 hardware;
+	__le32 rsv[4];
 };
 
 #define HCLGE_RX_PRIV_EN_B	15
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 39b7f71..5d80efd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -729,7 +729,7 @@ static int hclge_config_ncsi_hw_err_int(struct hclge_dev *hdev, bool en)
 	struct hclge_desc desc;
 	int ret;
 
-	if (hdev->pdev->revision < 0x21)
+	if (hdev->ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2)
 		return 0;
 
 	/* configure NCSI error interrupts */
@@ -808,7 +808,7 @@ static int hclge_config_ppp_error_interrupt(struct hclge_dev *hdev, u32 cmd,
 			cpu_to_le32(HCLGE_PPP_MPF_ECC_ERR_INT0_EN_MASK);
 		desc[1].data[1] =
 			cpu_to_le32(HCLGE_PPP_MPF_ECC_ERR_INT1_EN_MASK);
-		if (hdev->pdev->revision >= 0x21)
+		if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2)
 			desc[1].data[2] =
 				cpu_to_le32(HCLGE_PPP_PF_ERR_INT_EN_MASK);
 	} else if (cmd == HCLGE_PPP_CMD1_INT_CMD) {
@@ -1041,7 +1041,7 @@ static int hclge_config_ssu_hw_err_int(struct hclge_dev *hdev, bool en)
 	hclge_cmd_setup_basic_desc(&desc[1], HCLGE_SSU_COMMON_INT_CMD, false);
 
 	if (en) {
-		if (hdev->pdev->revision >= 0x21)
+		if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2)
 			desc[0].data[0] =
 				cpu_to_le32(HCLGE_SSU_COMMON_INT_EN);
 		else
@@ -1550,7 +1550,8 @@ int hclge_config_rocee_ras_interrupt(struct hclge_dev *hdev, bool en)
 	struct hclge_desc desc;
 	int ret;
 
-	if (hdev->pdev->revision < 0x21 || !hnae3_dev_roce_supported(hdev))
+	if (hdev->ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2 ||
+	    !hnae3_dev_roce_supported(hdev))
 		return 0;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_CONFIG_ROCEE_RAS_INT_EN, false);
@@ -1663,7 +1664,7 @@ pci_ers_result_t hclge_handle_hw_ras_error(struct hnae3_ae_dev *ae_dev)
 	}
 
 	/* Handling Non-fatal Rocee RAS errors */
-	if (hdev->pdev->revision >= 0x21 &&
+	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2 &&
 	    status & HCLGE_RAS_REG_ROCEE_ERR_MASK) {
 		dev_err(dev, "ROCEE Non-Fatal RAS error identified\n");
 		hclge_handle_rocee_ras_error(ae_dev);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 9bdad64..cc6d347 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -740,7 +740,7 @@ static int hclge_get_sset_count(struct hnae3_handle *handle, int stringset)
 	if (stringset == ETH_SS_TEST) {
 		/* clear loopback bit flags at first */
 		handle->flags = (handle->flags & (~HCLGE_LOOPBACK_TEST_FLAGS));
-		if (hdev->pdev->revision >= 0x21 ||
+		if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2 ||
 		    hdev->hw.mac.speed == HCLGE_MAC_SPEED_10M ||
 		    hdev->hw.mac.speed == HCLGE_MAC_SPEED_100M ||
 		    hdev->hw.mac.speed == HCLGE_MAC_SPEED_1G) {
@@ -2892,7 +2892,7 @@ static int hclge_update_port_info(struct hclge_dev *hdev)
 	if (!hdev->support_sfp_query)
 		return 0;
 
-	if (hdev->pdev->revision >= 0x21)
+	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2)
 		ret = hclge_get_sfp_info(hdev, mac);
 	else
 		ret = hclge_get_sfp_speed(hdev, &speed);
@@ -2904,7 +2904,7 @@ static int hclge_update_port_info(struct hclge_dev *hdev)
 		return ret;
 	}
 
-	if (hdev->pdev->revision >= 0x21) {
+	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
 		if (mac->speed_type == QUERY_ACTIVE_SPEED) {
 			hclge_update_port_capability(mac);
 			return 0;
@@ -3569,7 +3569,7 @@ static void hclge_clear_reset_cause(struct hclge_dev *hdev)
 	/* For revision 0x20, the reset interrupt source
 	 * can only be cleared after hardware reset done
 	 */
-	if (hdev->pdev->revision == 0x20)
+	if (hdev->ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2)
 		hclge_write_dev(&hdev->hw, HCLGE_MISC_RESET_STS_REG,
 				clearval);
 
@@ -4576,7 +4576,7 @@ static void hclge_rss_init_cfg(struct hclge_dev *hdev)
 	int i, rss_algo = HCLGE_RSS_HASH_ALGO_TOEPLITZ;
 	struct hclge_vport *vport = hdev->vport;
 
-	if (hdev->pdev->revision >= 0x21)
+	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2)
 		rss_algo = HCLGE_RSS_HASH_ALGO_SIMPLE;
 
 	for (i = 0; i < hdev->num_vmdq_vport + 1; i++) {
@@ -4776,13 +4776,14 @@ static int hclge_set_promisc_mode(struct hnae3_handle *handle, bool en_uc_pmc,
 				  bool en_mc_pmc)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
 	bool en_bc_pmc = true;
 
-	/* For revision 0x20, if broadcast promisc enabled, vlan filter is
-	 * always bypassed. So broadcast promisc should be disabled until
-	 * user enable promisc mode
+	/* For device whose version below V2, if broadcast promisc enabled,
+	 * vlan filter is always bypassed. So broadcast promisc should be
+	 * disabled until user enable promisc mode
 	 */
-	if (handle->pdev->revision == 0x20)
+	if (hdev->ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2)
 		en_bc_pmc = handle->netdev_flags & HNAE3_BPE ? true : false;
 
 	return hclge_set_vport_promisc_mode(vport, en_uc_pmc, en_mc_pmc,
@@ -6797,7 +6798,7 @@ static int hclge_set_loopback(struct hnae3_handle *handle,
 	 * the same, the packets are looped back in the SSU. If SSU loopback
 	 * is disabled, packets can reach MAC even if SMAC is the same as DMAC.
 	 */
-	if (hdev->pdev->revision >= 0x21) {
+	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
 		u8 switch_param = en ? 0 : BIT(HCLGE_SWITCH_ALW_LPBK_B);
 
 		ret = hclge_config_switch_param(hdev, PF_VPORT_ID, switch_param,
@@ -8299,7 +8300,7 @@ static void hclge_enable_vlan_filter(struct hnae3_handle *handle, bool enable)
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 
-	if (hdev->pdev->revision >= 0x21) {
+	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
 		hclge_set_vlan_filter_ctrl(hdev, HCLGE_FILTER_TYPE_VF,
 					   HCLGE_FILTER_FE_EGRESS, enable, 0);
 		hclge_set_vlan_filter_ctrl(hdev, HCLGE_FILTER_TYPE_PORT,
@@ -8659,7 +8660,7 @@ static int hclge_init_vlan_config(struct hclge_dev *hdev)
 	int ret;
 	int i;
 
-	if (hdev->pdev->revision >= 0x21) {
+	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
 		/* for revision 0x21, vf vlan filter is per function */
 		for (i = 0; i < hdev->num_alloc_vport; i++) {
 			vport = &hdev->vport[i];
@@ -9014,7 +9015,7 @@ static int hclge_set_vf_vlan_filter(struct hnae3_handle *handle, int vfid,
 	u16 state;
 	int ret;
 
-	if (hdev->pdev->revision == 0x20)
+	if (hdev->ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2)
 		return -EOPNOTSUPP;
 
 	vport = hclge_get_vf_vport(hdev, vfid);
@@ -10186,7 +10187,7 @@ static int hclge_set_vf_spoofchk(struct hnae3_handle *handle, int vf,
 	u32 new_spoofchk = enable ? 1 : 0;
 	int ret;
 
-	if (hdev->pdev->revision == 0x20)
+	if (hdev->ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2)
 		return -EOPNOTSUPP;
 
 	vport = hclge_get_vf_vport(hdev, vf);
@@ -10219,7 +10220,7 @@ static int hclge_reset_vport_spoofchk(struct hclge_dev *hdev)
 	int ret;
 	int i;
 
-	if (hdev->pdev->revision == 0x20)
+	if (hdev->ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2)
 		return 0;
 
 	/* resume the vf spoof check state after reset */
@@ -10239,6 +10240,7 @@ static int hclge_set_vf_trust(struct hnae3_handle *handle, int vf, bool enable)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
+	struct hnae3_ae_dev *ae_dev = hdev->ae_dev;
 	u32 new_trusted = enable ? 1 : 0;
 	bool en_bc_pmc;
 	int ret;
@@ -10252,7 +10254,7 @@ static int hclge_set_vf_trust(struct hnae3_handle *handle, int vf, bool enable)
 
 	/* Disable promisc mode for VF if it is not trusted any more. */
 	if (!enable && vport->vf_info.promisc_enable) {
-		en_bc_pmc = hdev->pdev->revision != 0x20;
+		en_bc_pmc = ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2;
 		ret = hclge_set_vport_promisc_mode(vport, false, false,
 						   en_bc_pmc);
 		if (ret)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index fec65239..b323756 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -313,9 +313,9 @@ int hclgevf_cmd_send(struct hclgevf_hw *hw, struct hclgevf_desc *desc, int num)
 	return status;
 }
 
-static int  hclgevf_cmd_query_firmware_version(struct hclgevf_hw *hw,
-					       u32 *version)
+static int hclgevf_cmd_query_version(struct hclgevf_dev *hdev)
 {
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
 	struct hclgevf_query_version_cmd *resp;
 	struct hclgevf_desc desc;
 	int status;
@@ -323,9 +323,15 @@ static int  hclgevf_cmd_query_firmware_version(struct hclgevf_hw *hw,
 	resp = (struct hclgevf_query_version_cmd *)desc.data;
 
 	hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_QUERY_FW_VER, 1);
-	status = hclgevf_cmd_send(hw, &desc, 1);
-	if (!status)
-		*version = le32_to_cpu(resp->firmware);
+	status = hclgevf_cmd_send(&hdev->hw, &desc, 1);
+	if (status)
+		return status;
+
+	hdev->fw_version = le32_to_cpu(resp->firmware);
+
+	ae_dev->dev_version = le32_to_cpu(resp->hardware) <<
+				 HNAE3_PCI_REVISION_BIT_SIZE;
+	ae_dev->dev_version |= hdev->pdev->revision;
 
 	return status;
 }
@@ -364,7 +370,6 @@ int hclgevf_cmd_queue_init(struct hclgevf_dev *hdev)
 
 int hclgevf_cmd_init(struct hclgevf_dev *hdev)
 {
-	u32 version;
 	int ret;
 
 	spin_lock_bh(&hdev->hw.cmq.csq.lock);
@@ -395,23 +400,20 @@ int hclgevf_cmd_init(struct hclgevf_dev *hdev)
 		goto err_cmd_init;
 	}
 
-	/* get firmware version */
-	ret = hclgevf_cmd_query_firmware_version(&hdev->hw, &version);
+	ret = hclgevf_cmd_query_version(hdev);
 	if (ret) {
-		dev_err(&hdev->pdev->dev,
-			"failed(%d) to query firmware version\n", ret);
+		dev_err(&hdev->pdev->dev, "failed(%d) to query version\n", ret);
 		goto err_cmd_init;
 	}
-	hdev->fw_version = version;
 
 	dev_info(&hdev->pdev->dev, "The firmware version is %lu.%lu.%lu.%lu\n",
-		 hnae3_get_field(version, HNAE3_FW_VERSION_BYTE3_MASK,
+		 hnae3_get_field(hdev->fw_version, HNAE3_FW_VERSION_BYTE3_MASK,
 				 HNAE3_FW_VERSION_BYTE3_SHIFT),
-		 hnae3_get_field(version, HNAE3_FW_VERSION_BYTE2_MASK,
+		 hnae3_get_field(hdev->fw_version, HNAE3_FW_VERSION_BYTE2_MASK,
 				 HNAE3_FW_VERSION_BYTE2_SHIFT),
-		 hnae3_get_field(version, HNAE3_FW_VERSION_BYTE1_MASK,
+		 hnae3_get_field(hdev->fw_version, HNAE3_FW_VERSION_BYTE1_MASK,
 				 HNAE3_FW_VERSION_BYTE1_SHIFT),
-		 hnae3_get_field(version, HNAE3_FW_VERSION_BYTE0_MASK,
+		 hnae3_get_field(hdev->fw_version, HNAE3_FW_VERSION_BYTE0_MASK,
 				 HNAE3_FW_VERSION_BYTE0_SHIFT));
 
 	return 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index 40d6e602..0601df6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -143,7 +143,8 @@ struct hclgevf_ctrl_vector_chain {
 
 struct hclgevf_query_version_cmd {
 	__le32 firmware;
-	__le32 firmware_rsv[5];
+	__le32 hardware;
+	__le32 rsv[4];
 };
 
 #define HCLGEVF_MSIX_OFT_ROCEE_S       0
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 307b18c..9a6f355 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -746,7 +746,7 @@ static int hclgevf_get_rss(struct hnae3_handle *handle, u32 *indir, u8 *key,
 	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
 	int i, ret;
 
-	if (handle->pdev->revision >= 0x21) {
+	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
 		/* Get hash algorithm */
 		if (hfunc) {
 			switch (rss_cfg->hash_algo) {
@@ -792,7 +792,7 @@ static int hclgevf_set_rss(struct hnae3_handle *handle, const u32 *indir,
 	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
 	int ret, i;
 
-	if (handle->pdev->revision >= 0x21) {
+	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
 		/* Set the RSS Hash Key if specififed by the user */
 		if (key) {
 			switch (hfunc) {
@@ -864,7 +864,7 @@ static int hclgevf_set_rss_tuple(struct hnae3_handle *handle,
 	u8 tuple_sets;
 	int ret;
 
-	if (handle->pdev->revision == 0x20)
+	if (hdev->ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2)
 		return -EOPNOTSUPP;
 
 	if (nfc->data &
@@ -942,7 +942,7 @@ static int hclgevf_get_rss_tuple(struct hnae3_handle *handle,
 	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
 	u8 tuple_sets;
 
-	if (handle->pdev->revision == 0x20)
+	if (hdev->ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2)
 		return -EOPNOTSUPP;
 
 	nfc->data = 0;
@@ -1155,10 +1155,9 @@ static int hclgevf_set_promisc_mode(struct hnae3_handle *handle, bool en_uc_pmc,
 				    bool en_mc_pmc)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
-	struct pci_dev *pdev = hdev->pdev;
 	bool en_bc_pmc;
 
-	en_bc_pmc = pdev->revision != 0x20;
+	en_bc_pmc = hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2;
 
 	return hclgevf_cmd_set_promisc_mode(hdev, en_uc_pmc, en_mc_pmc,
 					    en_bc_pmc);
@@ -2288,7 +2287,7 @@ static enum hclgevf_evt_cause hclgevf_check_evt_cause(struct hclgevf_dev *hdev,
 		 * register, so we should just write 0 to the bit we are
 		 * handling, and keep other bits as cmdq_stat_reg.
 		 */
-		if (hdev->pdev->revision >= 0x21)
+		if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2)
 			*clearval = ~(1U << HCLGEVF_VECTOR0_RX_CMDQ_INT_B);
 		else
 			*clearval = cmdq_stat_reg &
@@ -2431,7 +2430,7 @@ static void hclgevf_rss_init_cfg(struct hclgevf_dev *hdev)
 	rss_cfg->hash_algo = HCLGEVF_RSS_HASH_ALGO_TOEPLITZ;
 	rss_cfg->rss_size = hdev->nic.kinfo.rss_size;
 	tuple_sets = &rss_cfg->rss_tuple_sets;
-	if (hdev->pdev->revision >= 0x21) {
+	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
 		rss_cfg->hash_algo = HCLGEVF_RSS_HASH_ALGO_SIMPLE;
 		memcpy(rss_cfg->rss_hash_key, hclgevf_hash_key,
 		       HCLGEVF_RSS_KEY_SIZE);
@@ -2456,7 +2455,7 @@ static int hclgevf_rss_init_hw(struct hclgevf_dev *hdev)
 	struct hclgevf_rss_cfg *rss_cfg = &hdev->rss_cfg;
 	int ret;
 
-	if (hdev->pdev->revision >= 0x21) {
+	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
 		ret = hclgevf_set_rss_algo_key(hdev, rss_cfg->hash_algo,
 					       rss_cfg->rss_hash_key);
 		if (ret)
-- 
2.7.4

