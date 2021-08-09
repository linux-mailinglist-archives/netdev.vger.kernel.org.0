Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62AC53E4804
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 16:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234237AbhHIOyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 10:54:50 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7813 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234275AbhHIOyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 10:54:47 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Gjzch36SKzYmc9;
        Mon,  9 Aug 2021 22:54:12 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 9 Aug 2021 22:54:25 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 9 Aug 2021 22:54:24 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 4/4] net: hns3: add support ethtool extended link state
Date:   Mon, 9 Aug 2021 22:50:42 +0800
Message-ID: <1628520642-30839-5-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1628520642-30839-1-git-send-email-huangguangbin2@huawei.com>
References: <1628520642-30839-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to know the reason of link up failure, add supporting ethtool
extended link state. Driver reads the link status code from firmware if
in link down state and converts it to ethtool extended link state.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 66 ++++++++++++++++++++++
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.h |  6 ++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |  3 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 27 +++++++++
 5 files changed, 104 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index e0b7c3c44e7b..848bed866193 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -718,6 +718,8 @@ struct hnae3_ae_ops {
 			    u32 nsec, u32 sec);
 	int (*get_ts_info)(struct hnae3_handle *handle,
 			   struct ethtool_ts_info *info);
+	int (*get_link_diagnosis_info)(struct hnae3_handle *handle,
+				       u32 *status_code);
 };
 
 struct hnae3_dcb_ops {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index b7ba5f780c5e..931168a33092 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1657,6 +1657,71 @@ static int hns3_get_ts_info(struct net_device *netdev,
 	return ethtool_op_get_ts_info(netdev, info);
 }
 
+static const struct hns3_ethtool_link_ext_state_mapping
+hns3_link_ext_state_map[] = {
+	{1, ETHTOOL_LINK_EXT_STATE_AUTONEG,
+		ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_HCD},
+	{2, ETHTOOL_LINK_EXT_STATE_AUTONEG,
+		ETHTOOL_LINK_EXT_SUBSTATE_AN_ACK_NOT_RECEIVED},
+
+	{256, ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE,
+		ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_LINK_INHIBIT_TIMEOUT},
+	{257, ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE,
+		ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_LINK_PARTNER_DID_NOT_SET_RECEIVER_READY},
+	{512, ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE,
+		ETHTOOL_LINK_EXT_SUBSTATE_LT_REMOTE_FAULT},
+
+	{513, ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH,
+		ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_BLOCK_LOCK},
+	{515, ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH,
+		ETHTOOL_LINK_EXT_SUBSTATE_LLM_FC_FEC_IS_NOT_LOCKED},
+	{516, ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH,
+		ETHTOOL_LINK_EXT_SUBSTATE_LLM_RS_FEC_IS_NOT_LOCKED},
+
+	{768, ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY,
+		ETHTOOL_LINK_EXT_SUBSTATE_BSI_LARGE_NUMBER_OF_PHYSICAL_ERRORS},
+	{769, ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY,
+		ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_REFERENCE_CLOCK_LOST},
+	{770, ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY,
+		ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_ALOS},
+
+	{1024, ETHTOOL_LINK_EXT_STATE_NO_CABLE, 0},
+	{1025, ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE,
+		ETHTOOL_LINK_EXT_SUBSTATE_CI_UNSUPPORTED_CABLE},
+
+	{1026, ETHTOOL_LINK_EXT_STATE_EEPROM_ISSUE, 0},
+};
+
+static int hns3_get_link_ext_state(struct net_device *netdev,
+				   struct ethtool_link_ext_state_info *info)
+{
+	const struct hns3_ethtool_link_ext_state_mapping *map;
+	struct hnae3_handle *h = hns3_get_handle(netdev);
+	u32 status_code, i;
+	int ret;
+
+	if (netif_carrier_ok(netdev))
+		return -ENODATA;
+
+	if (!h->ae_algo->ops->get_link_diagnosis_info)
+		return -EOPNOTSUP;
+
+	ret = h->ae_algo->ops->get_link_diagnosis_info(h, &status_code);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < ARRAY_SIZE(hns3_link_ext_state_map); i++) {
+		map = &hns3_link_ext_state_map[i];
+		if (map->status_code == status_code) {
+			info->link_ext_state = map->link_ext_state;
+			info->__link_ext_substate = map->link_ext_substate;
+			return 0;
+		}
+	}
+
+	return -ENODATA;
+}
+
 static const struct ethtool_ops hns3vf_ethtool_ops = {
 	.supported_coalesce_params = HNS3_ETHTOOL_COALESCE,
 	.get_drvinfo = hns3_get_drvinfo,
@@ -1726,6 +1791,7 @@ static const struct ethtool_ops hns3_ethtool_ops = {
 	.get_ts_info = hns3_get_ts_info,
 	.get_tunable = hns3_get_tunable,
 	.set_tunable = hns3_set_tunable,
+	.get_link_ext_state = hns3_get_link_ext_state,
 };
 
 void hns3_ethtool_set_ops(struct net_device *netdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.h b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.h
index 2f186607c6e0..822d6fcbc73b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.h
@@ -22,4 +22,10 @@ struct hns3_pflag_desc {
 	void (*handler)(struct net_device *netdev, bool enable);
 };
 
+struct hns3_ethtool_link_ext_state_mapping {
+	u32 status_code;
+	enum ethtool_link_ext_state link_ext_state;
+	u8 link_ext_substate;
+};
+
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 18bde77ef944..8e5be127909b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -316,6 +316,9 @@ enum hclge_opcode_type {
 	/* PHY command */
 	HCLGE_OPC_PHY_LINK_KSETTING	= 0x7025,
 	HCLGE_OPC_PHY_REG		= 0x7026,
+
+	/* Query link diagnosis info command */
+	HCLGE_OPC_QUERY_LINK_DIAGNOSIS	= 0x702A,
 };
 
 #define HCLGE_TQP_REG_OFFSET		0x80000
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index f15d76ec0068..70167ade234e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -12837,6 +12837,32 @@ static int hclge_get_module_eeprom(struct hnae3_handle *handle, u32 offset,
 	return 0;
 }
 
+static int hclge_get_link_diagnosis_info(struct hnae3_handle *handle,
+					 u32 *status_code)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+	struct hclge_desc desc;
+	int ret;
+
+	if (hdev->ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2) {
+		dev_err(&hdev->pdev->dev,
+			"unsupported to get link diagnosis info\n");
+		return -EOPNOTSUPP;
+	}
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_QUERY_LINK_DIAGNOSIS, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to query link diagnosis info, ret = %d\n", ret);
+		return ret;
+	}
+
+	*status_code = le32_to_cpu(desc.data[0]);
+	return 0;
+}
+
 static const struct hnae3_ae_ops hclge_ops = {
 	.init_ae_dev = hclge_init_ae_dev,
 	.uninit_ae_dev = hclge_uninit_ae_dev,
@@ -12937,6 +12963,7 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.set_tx_hwts_info = hclge_ptp_set_tx_info,
 	.get_rx_hwts = hclge_ptp_get_rx_hwts,
 	.get_ts_info = hclge_ptp_get_ts_info,
+	.get_link_diagnosis_info = hclge_get_link_diagnosis_info,
 };
 
 static struct hnae3_ae_algo ae_algo = {
-- 
2.8.1

