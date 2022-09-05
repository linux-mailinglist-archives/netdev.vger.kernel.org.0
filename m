Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4F65ACD94
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 10:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236674AbiIEISz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 04:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237310AbiIEISV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 04:18:21 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0A731DFD;
        Mon,  5 Sep 2022 01:18:18 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MLhBb01m9z1P6gq;
        Mon,  5 Sep 2022 16:14:31 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 5 Sep 2022 16:18:16 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 5 Sep 2022 16:18:14 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <lipeng321@huawei.com>,
        <lanhao@huawei.com>
Subject: [PATCH net-next 4/5] net: hns3: add querying fec statistics
Date:   Mon, 5 Sep 2022 16:15:38 +0800
Message-ID: <20220905081539.62131-5-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220905081539.62131-1-huangguangbin2@huawei.com>
References: <20220905081539.62131-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Lan <lanhao@huawei.com>

FEC statistics can be used to check the transmission quality of links.
This patch implements the get_fec_stats callback of ethtool_ops to support
querying FEC statistics by command "ethtool -I --show-fec eth0".

Signed-off-by: Hao Lan <lanhao@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |   6 +
 .../hns3/hns3_common/hclge_comm_cmd.c         |   1 +
 .../hns3/hns3_common/hclge_comm_cmd.h         |   2 +
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    |   3 +
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  14 ++
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |  14 ++
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 156 ++++++++++++++++++
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  22 +++
 8 files changed, 218 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 9ae094189d3a..74f7395a36a6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -97,6 +97,7 @@ enum HNAE3_DEV_CAP_BITS {
 	HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B,
 	HNAE3_DEV_SUPPORT_MC_MAC_MNG_B,
 	HNAE3_DEV_SUPPORT_CQ_B,
+	HNAE3_DEV_SUPPORT_FEC_STATS_B,
 };
 
 #define hnae3_ae_dev_fd_supported(ae_dev) \
@@ -159,6 +160,9 @@ enum HNAE3_DEV_CAP_BITS {
 #define hnae3_ae_dev_cq_supported(ae_dev) \
 	test_bit(HNAE3_DEV_SUPPORT_CQ_B, (ae_dev)->caps)
 
+#define hnae3_ae_dev_fec_stats_supported(ae_dev) \
+	test_bit(HNAE3_DEV_SUPPORT_FEC_STATS_B, (ae_dev)->caps)
+
 enum HNAE3_PF_CAP_BITS {
 	HNAE3_PF_SUPPORT_VLAN_FLTR_MDF_B = 0,
 };
@@ -576,6 +580,8 @@ struct hnae3_ae_ops {
 	void (*get_media_type)(struct hnae3_handle *handle, u8 *media_type,
 			       u8 *module_type);
 	int (*check_port_speed)(struct hnae3_handle *handle, u32 speed);
+	void (*get_fec_stats)(struct hnae3_handle *handle,
+			      struct ethtool_fec_stats *fec_stats);
 	void (*get_fec)(struct hnae3_handle *handle, u8 *fec_ability,
 			u8 *fec_mode);
 	int (*set_fec)(struct hnae3_handle *handle, u32 fec_mode);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
index f9bd3fc969c5..ca4efdd6e018 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
@@ -153,6 +153,7 @@ static const struct hclge_comm_caps_bit_map hclge_pf_cmd_caps[] = {
 	{HCLGE_COMM_CAP_CQ_B, HNAE3_DEV_SUPPORT_CQ_B},
 	{HCLGE_COMM_CAP_GRO_B, HNAE3_DEV_SUPPORT_GRO_B},
 	{HCLGE_COMM_CAP_FD_B, HNAE3_DEV_SUPPORT_FD_B},
+	{HCLGE_COMM_CAP_FEC_STATS_B, HNAE3_DEV_SUPPORT_FEC_STATS_B},
 };
 
 static const struct hclge_comm_caps_bit_map hclge_vf_cmd_caps[] = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
index 8aaa5fdfa2f6..5b66c7d8246d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
@@ -103,6 +103,7 @@ enum hclge_opcode_type {
 	HCLGE_OPC_MAC_TNL_INT_EN	= 0x0311,
 	HCLGE_OPC_CLEAR_MAC_TNL_INT	= 0x0312,
 	HCLGE_OPC_COMMON_LOOPBACK       = 0x0315,
+	HCLGE_OPC_QUERY_FEC_STATS	= 0x0316,
 	HCLGE_OPC_CONFIG_FEC_MODE	= 0x031A,
 	HCLGE_OPC_QUERY_ROH_TYPE_INFO	= 0x0389,
 
@@ -342,6 +343,7 @@ enum HCLGE_COMM_CAP_BITS {
 	HCLGE_COMM_CAP_CQ_B = 18,
 	HCLGE_COMM_CAP_GRO_B = 20,
 	HCLGE_COMM_CAP_FD_B = 21,
+	HCLGE_COMM_CAP_FEC_STATS_B = 25,
 };
 
 enum HCLGE_COMM_API_CAP_BITS {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 0f8f5c466871..a3d47724742b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -402,6 +402,9 @@ static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
 	}, {
 		.name = "support modify vlan filter state",
 		.cap_bit = HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B,
+	}, {
+		.name = "support FEC statistics",
+		.cap_bit = HNAE3_DEV_SUPPORT_FEC_STATS_B,
 	}
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 3ca9c2b67da4..31d181118be1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1612,6 +1612,19 @@ static void hns3_set_msglevel(struct net_device *netdev, u32 msg_level)
 	h->msg_enable = msg_level;
 }
 
+static void hns3_get_fec_stats(struct net_device *netdev,
+			       struct ethtool_fec_stats *fec_stats)
+{
+	struct hnae3_handle *handle = hns3_get_handle(netdev);
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(handle->pdev);
+	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+
+	if (!hnae3_ae_dev_fec_stats_supported(ae_dev) || !ops->get_fec_stats)
+		return;
+
+	ops->get_fec_stats(handle, fec_stats);
+}
+
 /* Translate local fec value into ethtool value. */
 static unsigned int loc_to_eth_fec(u8 loc_fec)
 {
@@ -2084,6 +2097,7 @@ static const struct ethtool_ops hns3_ethtool_ops = {
 	.set_msglevel = hns3_set_msglevel,
 	.get_fecparam = hns3_get_fecparam,
 	.set_fecparam = hns3_set_fecparam,
+	.get_fec_stats = hns3_get_fec_stats,
 	.get_module_info = hns3_get_module_info,
 	.get_module_eeprom = hns3_get_module_eeprom,
 	.get_priv_flags = hns3_get_priv_flags,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 489a87e9ecb4..7461b7ecf716 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -367,6 +367,20 @@ struct hclge_config_fec_cmd {
 	u8 rsv[22];
 };
 
+#define HCLGE_FEC_STATS_CMD_NUM 4
+
+struct hclge_query_fec_stats_cmd {
+	/* fec rs mode total stats */
+	__le32 rs_fec_corr_blocks;
+	__le32 rs_fec_uncorr_blocks;
+	__le32 rs_fec_error_blocks;
+	/* fec base-r mode per lanes stats */
+	u8 base_r_lane_num;
+	u8 rsv[3];
+	__le32 base_r_fec_corr_blocks;
+	__le32 base_r_fec_uncorr_blocks;
+};
+
 #define HCLGE_MAC_UPLINK_PORT		0x100
 
 struct hclge_config_max_frm_size_cmd {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index f43c7d392d1a..d107d3c9099b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -71,6 +71,7 @@ static void hclge_sync_mac_table(struct hclge_dev *hdev);
 static void hclge_restore_hw_table(struct hclge_dev *hdev);
 static void hclge_sync_promisc_mode(struct hclge_dev *hdev);
 static void hclge_sync_fd_table(struct hclge_dev *hdev);
+static void hclge_update_fec_stats(struct hclge_dev *hdev);
 
 static struct hnae3_ae_algo ae_algo;
 
@@ -679,6 +680,8 @@ static void hclge_update_stats_for_all(struct hclge_dev *hdev)
 		}
 	}
 
+	hclge_update_fec_stats(hdev);
+
 	status = hclge_mac_update_stats(hdev);
 	if (status)
 		dev_err(&hdev->pdev->dev,
@@ -2753,6 +2756,157 @@ static int hclge_halt_autoneg(struct hnae3_handle *handle, bool halt)
 	return 0;
 }
 
+static void hclge_parse_fec_stats_lanes(struct hclge_dev *hdev,
+					struct hclge_desc *desc, u32 desc_len)
+{
+	u32 lane_size = HCLGE_FEC_STATS_MAX_LANES * 2;
+	u32 desc_index = 0;
+	u32 data_index = 0;
+	u32 i;
+
+	for (i = 0; i < lane_size; i++) {
+		if (data_index >= HCLGE_DESC_DATA_LEN) {
+			desc_index++;
+			data_index = 0;
+		}
+
+		if (desc_index >= desc_len)
+			return;
+
+		hdev->fec_stats.per_lanes[i] +=
+			le32_to_cpu(desc[desc_index].data[data_index]);
+		data_index++;
+	}
+}
+
+static void hclge_parse_fec_stats(struct hclge_dev *hdev,
+				  struct hclge_desc *desc, u32 desc_len)
+{
+	struct hclge_query_fec_stats_cmd *req;
+
+	req = (struct hclge_query_fec_stats_cmd *)desc[0].data;
+
+	hdev->fec_stats.base_r_lane_num = req->base_r_lane_num;
+	hdev->fec_stats.rs_corr_blocks +=
+		le32_to_cpu(req->rs_fec_corr_blocks);
+	hdev->fec_stats.rs_uncorr_blocks +=
+		le32_to_cpu(req->rs_fec_uncorr_blocks);
+	hdev->fec_stats.rs_error_blocks +=
+		le32_to_cpu(req->rs_fec_error_blocks);
+	hdev->fec_stats.base_r_corr_blocks +=
+		le32_to_cpu(req->base_r_fec_corr_blocks);
+	hdev->fec_stats.base_r_uncorr_blocks +=
+		le32_to_cpu(req->base_r_fec_uncorr_blocks);
+
+	hclge_parse_fec_stats_lanes(hdev, &desc[1], desc_len - 1);
+}
+
+static int hclge_update_fec_stats_hw(struct hclge_dev *hdev)
+{
+	struct hclge_desc desc[HCLGE_FEC_STATS_CMD_NUM];
+	int ret;
+	u32 i;
+
+	for (i = 0; i < HCLGE_FEC_STATS_CMD_NUM; i++) {
+		hclge_cmd_setup_basic_desc(&desc[i], HCLGE_OPC_QUERY_FEC_STATS,
+					   true);
+		if (i != (HCLGE_FEC_STATS_CMD_NUM - 1))
+			desc[i].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
+	}
+
+	ret = hclge_cmd_send(&hdev->hw, desc, HCLGE_FEC_STATS_CMD_NUM);
+	if (ret)
+		return ret;
+
+	hclge_parse_fec_stats(hdev, desc, HCLGE_FEC_STATS_CMD_NUM);
+
+	return 0;
+}
+
+static void hclge_update_fec_stats(struct hclge_dev *hdev)
+{
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
+	int ret;
+
+	if (!hnae3_ae_dev_fec_stats_supported(ae_dev) ||
+	    test_and_set_bit(HCLGE_STATE_FEC_STATS_UPDATING, &hdev->state))
+		return;
+
+	ret = hclge_update_fec_stats_hw(hdev);
+	if (ret)
+		dev_err(&hdev->pdev->dev,
+			"failed to update fec stats, ret = %d\n", ret);
+
+	clear_bit(HCLGE_STATE_FEC_STATS_UPDATING, &hdev->state);
+}
+
+static void hclge_get_fec_stats_total(struct hclge_dev *hdev,
+				      struct ethtool_fec_stats *fec_stats)
+{
+	fec_stats->corrected_blocks.total = hdev->fec_stats.rs_corr_blocks;
+	fec_stats->uncorrectable_blocks.total =
+		hdev->fec_stats.rs_uncorr_blocks;
+}
+
+static void hclge_get_fec_stats_lanes(struct hclge_dev *hdev,
+				      struct ethtool_fec_stats *fec_stats)
+{
+	u32 i;
+
+	if (hdev->fec_stats.base_r_lane_num == 0 ||
+	    hdev->fec_stats.base_r_lane_num > HCLGE_FEC_STATS_MAX_LANES) {
+		dev_err(&hdev->pdev->dev,
+			"fec stats lane number(%llu) is invalid\n",
+			hdev->fec_stats.base_r_lane_num);
+		return;
+	}
+
+	for (i = 0; i < hdev->fec_stats.base_r_lane_num; i++) {
+		fec_stats->corrected_blocks.lanes[i] =
+			hdev->fec_stats.base_r_corr_per_lanes[i];
+		fec_stats->uncorrectable_blocks.lanes[i] =
+			hdev->fec_stats.base_r_uncorr_per_lanes[i];
+	}
+}
+
+static void hclge_comm_get_fec_stats(struct hclge_dev *hdev,
+				     struct ethtool_fec_stats *fec_stats)
+{
+	u32 fec_mode = hdev->hw.mac.fec_mode;
+
+	switch (fec_mode) {
+	case BIT(HNAE3_FEC_RS):
+	case BIT(HNAE3_FEC_LLRS):
+		hclge_get_fec_stats_total(hdev, fec_stats);
+		break;
+	case BIT(HNAE3_FEC_BASER):
+		hclge_get_fec_stats_lanes(hdev, fec_stats);
+		break;
+	default:
+		dev_err(&hdev->pdev->dev,
+			"fec stats is not supported by current fec mode(0x%x)\n",
+			fec_mode);
+		break;
+	}
+}
+
+static void hclge_get_fec_stats(struct hnae3_handle *handle,
+				struct ethtool_fec_stats *fec_stats)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+	u32 fec_mode = hdev->hw.mac.fec_mode;
+
+	if (fec_mode == BIT(HNAE3_FEC_NONE) ||
+	    fec_mode == BIT(HNAE3_FEC_AUTO) ||
+	    fec_mode == BIT(HNAE3_FEC_USER_DEF))
+		return;
+
+	hclge_update_fec_stats(hdev);
+
+	hclge_comm_get_fec_stats(hdev, fec_stats);
+}
+
 static int hclge_set_fec_hw(struct hclge_dev *hdev, u32 fec_mode)
 {
 	struct hclge_config_fec_cmd *req;
@@ -11552,6 +11706,7 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 static void hclge_stats_clear(struct hclge_dev *hdev)
 {
 	memset(&hdev->mac_stats, 0, sizeof(hdev->mac_stats));
+	memset(&hdev->fec_stats, 0, sizeof(hdev->fec_stats));
 }
 
 static int hclge_set_mac_spoofchk(struct hclge_dev *hdev, int vf, bool enable)
@@ -12828,6 +12983,7 @@ static const struct hnae3_ae_ops hclge_ops = {
 	.cfg_mac_speed_dup_h = hclge_cfg_mac_speed_dup_h,
 	.get_media_type = hclge_get_media_type,
 	.check_port_speed = hclge_check_port_speed,
+	.get_fec_stats = hclge_get_fec_stats,
 	.get_fec = hclge_get_fec,
 	.set_fec = hclge_set_fec,
 	.get_rss_key_size = hclge_comm_get_rss_key_size,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 8498cd8d36f9..ef0f67ed60c9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -216,6 +216,7 @@ enum HCLGE_DEV_STATE {
 	HCLGE_STATE_FD_USER_DEF_CHANGED,
 	HCLGE_STATE_PTP_EN,
 	HCLGE_STATE_PTP_TX_HANDLING,
+	HCLGE_STATE_FEC_STATS_UPDATING,
 	HCLGE_STATE_MAX
 };
 
@@ -492,6 +493,26 @@ struct hclge_mac_stats {
 
 #define HCLGE_STATS_TIMER_INTERVAL	300UL
 
+/* fec stats ,opcode id: 0x0316 */
+#define HCLGE_FEC_STATS_MAX_LANES	8
+struct hclge_fec_stats {
+	/* fec rs mode total stats */
+	u64 rs_corr_blocks;
+	u64 rs_uncorr_blocks;
+	u64 rs_error_blocks;
+	/* fec base-r mode per lanes stats */
+	u64 base_r_lane_num;
+	u64 base_r_corr_blocks;
+	u64 base_r_uncorr_blocks;
+	union {
+		struct {
+			u64 base_r_corr_per_lanes[HCLGE_FEC_STATS_MAX_LANES];
+			u64 base_r_uncorr_per_lanes[HCLGE_FEC_STATS_MAX_LANES];
+		};
+		u64 per_lanes[HCLGE_FEC_STATS_MAX_LANES * 2];
+	};
+};
+
 struct hclge_vlan_type_cfg {
 	u16 rx_ot_fst_vlan_type;
 	u16 rx_ot_sec_vlan_type;
@@ -830,6 +851,7 @@ struct hclge_dev {
 	struct hclge_hw hw;
 	struct hclge_misc_vector misc_vector;
 	struct hclge_mac_stats mac_stats;
+	struct hclge_fec_stats fec_stats;
 	unsigned long state;
 	unsigned long flr_state;
 	unsigned long last_reset_time;
-- 
2.33.0

