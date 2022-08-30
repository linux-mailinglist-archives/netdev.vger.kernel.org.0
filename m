Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55DB85A616D
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 13:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiH3LNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 07:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiH3LNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 07:13:49 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76CAD9EA1;
        Tue, 30 Aug 2022 04:13:47 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MH4NG42fBzlWcf;
        Tue, 30 Aug 2022 19:10:22 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 30 Aug 2022 19:13:45 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 30 Aug 2022 19:13:45 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <lanhao@huawei.com>
Subject: [PATCH net-next 1/4] net: hns3: add getting capabilities of gro offload and fd from firmware
Date:   Tue, 30 Aug 2022 19:11:14 +0800
Message-ID: <20220830111117.47865-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220830111117.47865-1-huangguangbin2@huawei.com>
References: <20220830111117.47865-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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

As some new devices may not support GRO offload and flow table director,
to support these devices, driver needs to querying capabilities of GRO
offload and flow table director from firmware. Whether the driver
supports these two features depends on capabilities.

For old device of version HNAE3_DEVICE_VERSION_V2, driver sets their
capabilities of these two features to fixed value.

Setting default features of netdev and debugfs also need to identify
whether support these two features.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  8 ++---
 .../hns3/hns3_common/hclge_comm_cmd.c         | 11 +++++--
 .../hns3/hns3_common/hclge_comm_cmd.h         |  2 ++
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  7 ++---
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c     |  5 ++-
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 31 ++++++++++++-------
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  2 +-
 7 files changed, 42 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 94f80e1c4020..91a28c22ad28 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -99,11 +99,11 @@ enum HNAE3_DEV_CAP_BITS {
 	HNAE3_DEV_SUPPORT_CQ_B,
 };
 
-#define hnae3_dev_fd_supported(hdev) \
-	test_bit(HNAE3_DEV_SUPPORT_FD_B, (hdev)->ae_dev->caps)
+#define hnae3_ae_dev_fd_supported(ae_dev) \
+		test_bit(HNAE3_DEV_SUPPORT_FD_B, (ae_dev)->caps)
 
-#define hnae3_dev_gro_supported(hdev) \
-	test_bit(HNAE3_DEV_SUPPORT_GRO_B, (hdev)->ae_dev->caps)
+#define hnae3_ae_dev_gro_supported(ae_dev) \
+		test_bit(HNAE3_DEV_SUPPORT_GRO_B, (ae_dev)->caps)
 
 #define hnae3_dev_fec_supported(hdev) \
 	test_bit(HNAE3_DEV_SUPPORT_FEC_B, (hdev)->ae_dev->caps)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
index c8b151d29f53..701d6373020c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
@@ -52,9 +52,9 @@ void hclge_comm_cmd_reuse_desc(struct hclge_desc *desc, bool is_read)
 static void hclge_comm_set_default_capability(struct hnae3_ae_dev *ae_dev,
 					      bool is_pf)
 {
-	set_bit(HNAE3_DEV_SUPPORT_FD_B, ae_dev->caps);
 	set_bit(HNAE3_DEV_SUPPORT_GRO_B, ae_dev->caps);
-	if (is_pf && ae_dev->dev_version == HNAE3_DEVICE_VERSION_V2) {
+	if (is_pf) {
+		set_bit(HNAE3_DEV_SUPPORT_FD_B, ae_dev->caps);
 		set_bit(HNAE3_DEV_SUPPORT_FEC_B, ae_dev->caps);
 		set_bit(HNAE3_DEV_SUPPORT_PAUSE_B, ae_dev->caps);
 	}
@@ -150,6 +150,8 @@ static const struct hclge_comm_caps_bit_map hclge_pf_cmd_caps[] = {
 	 HNAE3_DEV_SUPPORT_PORT_VLAN_BYPASS_B},
 	{HCLGE_COMM_CAP_PORT_VLAN_BYPASS_B, HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B},
 	{HCLGE_COMM_CAP_CQ_B, HNAE3_DEV_SUPPORT_CQ_B},
+	{HCLGE_COMM_CAP_GRO_B, HNAE3_DEV_SUPPORT_GRO_B},
+	{HCLGE_COMM_CAP_FD_B, HNAE3_DEV_SUPPORT_FD_B},
 };
 
 static const struct hclge_comm_caps_bit_map hclge_vf_cmd_caps[] = {
@@ -162,6 +164,7 @@ static const struct hclge_comm_caps_bit_map hclge_vf_cmd_caps[] = {
 	{HCLGE_COMM_CAP_TX_PUSH_B, HNAE3_DEV_SUPPORT_TX_PUSH_B},
 	{HCLGE_COMM_CAP_RXD_ADV_LAYOUT_B, HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B},
 	{HCLGE_COMM_CAP_CQ_B, HNAE3_DEV_SUPPORT_CQ_B},
+	{HCLGE_COMM_CAP_GRO_B, HNAE3_DEV_SUPPORT_GRO_B},
 };
 
 static void
@@ -220,8 +223,10 @@ int hclge_comm_cmd_query_version_and_capability(struct hnae3_ae_dev *ae_dev,
 					 HNAE3_PCI_REVISION_BIT_SIZE;
 	ae_dev->dev_version |= ae_dev->pdev->revision;
 
-	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2)
+	if (ae_dev->dev_version == HNAE3_DEVICE_VERSION_V2) {
 		hclge_comm_set_default_capability(ae_dev, is_pf);
+		return 0;
+	}
 
 	hclge_comm_parse_capability(ae_dev, is_pf, resp);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
index 7a7d4cf9bf35..dec0b9b422b4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
@@ -339,6 +339,8 @@ enum HCLGE_COMM_CAP_BITS {
 	HCLGE_COMM_CAP_RXD_ADV_LAYOUT_B = 15,
 	HCLGE_COMM_CAP_PORT_VLAN_BYPASS_B = 17,
 	HCLGE_COMM_CAP_CQ_B = 18,
+	HCLGE_COMM_CAP_GRO_B = 20,
+	HCLGE_COMM_CAP_FD_B = 21,
 };
 
 enum HCLGE_COMM_API_CAP_BITS {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 35d70041b9e8..481a300819ad 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3271,12 +3271,11 @@ static void hns3_set_default_feature(struct net_device *netdev)
 		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
 		NETIF_F_SCTP_CRC | NETIF_F_FRAGLIST;
 
-	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
+	if (hnae3_ae_dev_gro_supported(ae_dev))
 		netdev->features |= NETIF_F_GRO_HW;
 
-		if (!(h->flags & HNAE3_SUPPORT_VF))
-			netdev->features |= NETIF_F_NTUPLE;
-	}
+	if (hnae3_ae_dev_fd_supported(ae_dev))
+		netdev->features |= NETIF_F_NTUPLE;
 
 	if (test_bit(HNAE3_DEV_SUPPORT_UDP_GSO_B, ae_dev->caps))
 		netdev->features |= NETIF_F_GSO_UDP_L4;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 9b870e79c290..59121767a853 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1517,7 +1517,7 @@ static int hclge_dbg_dump_fd_tcam(struct hclge_dev *hdev, char *buf, int len)
 	char *tcam_buf;
 	int pos = 0;
 
-	if (!hnae3_dev_fd_supported(hdev)) {
+	if (!hnae3_ae_dev_fd_supported(hdev->ae_dev)) {
 		dev_err(&hdev->pdev->dev,
 			"Only FD-supported dev supports dump fd tcam\n");
 		return -EOPNOTSUPP;
@@ -1585,6 +1585,9 @@ static int hclge_dbg_dump_fd_counter(struct hclge_dev *hdev, char *buf, int len)
 	u64 cnt;
 	u8 i;
 
+	if (!hnae3_ae_dev_fd_supported(hdev->ae_dev))
+		return -EOPNOTSUPP;
+
 	pos += scnprintf(buf + pos, len - pos,
 			 "func_id\thit_times\n");
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index fae79764dc44..92da11d510b0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1574,7 +1574,7 @@ static int hclge_configure(struct hclge_dev *hdev)
 	if (cfg.vlan_fliter_cap == HCLGE_VLAN_FLTR_CAN_MDF)
 		set_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps);
 
-	if (hnae3_dev_fd_supported(hdev)) {
+	if (hnae3_ae_dev_fd_supported(hdev->ae_dev)) {
 		hdev->fd_en = true;
 		hdev->fd_active_type = HCLGE_FD_RULE_NONE;
 	}
@@ -1617,7 +1617,7 @@ static int hclge_config_gro(struct hclge_dev *hdev)
 	struct hclge_desc desc;
 	int ret;
 
-	if (!hnae3_dev_gro_supported(hdev))
+	if (!hnae3_ae_dev_gro_supported(hdev->ae_dev))
 		return 0;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_GRO_GENERIC_CONFIG, false);
@@ -5334,7 +5334,7 @@ static int hclge_init_fd_config(struct hclge_dev *hdev)
 	struct hclge_fd_key_cfg *key_cfg;
 	int ret;
 
-	if (!hnae3_dev_fd_supported(hdev))
+	if (!hnae3_ae_dev_fd_supported(hdev->ae_dev))
 		return 0;
 
 	ret = hclge_get_fd_mode(hdev, &hdev->fd_cfg.fd_mode);
@@ -6339,7 +6339,7 @@ static int hclge_add_fd_entry(struct hnae3_handle *handle,
 	u8 action;
 	int ret;
 
-	if (!hnae3_dev_fd_supported(hdev)) {
+	if (!hnae3_ae_dev_fd_supported(hdev->ae_dev)) {
 		dev_err(&hdev->pdev->dev,
 			"flow table director is not supported\n");
 		return -EOPNOTSUPP;
@@ -6395,7 +6395,7 @@ static int hclge_del_fd_entry(struct hnae3_handle *handle,
 	struct ethtool_rx_flow_spec *fs;
 	int ret;
 
-	if (!hnae3_dev_fd_supported(hdev))
+	if (!hnae3_ae_dev_fd_supported(hdev->ae_dev))
 		return -EOPNOTSUPP;
 
 	fs = (struct ethtool_rx_flow_spec *)&cmd->fs;
@@ -6431,7 +6431,7 @@ static void hclge_clear_fd_rules_in_list(struct hclge_dev *hdev,
 	struct hlist_node *node;
 	u16 location;
 
-	if (!hnae3_dev_fd_supported(hdev))
+	if (!hnae3_ae_dev_fd_supported(hdev->ae_dev))
 		return;
 
 	spin_lock_bh(&hdev->fd_rule_lock);
@@ -6473,7 +6473,7 @@ static int hclge_restore_fd_entries(struct hnae3_handle *handle)
 	 * return value. If error is returned here, the reset process will
 	 * fail.
 	 */
-	if (!hnae3_dev_fd_supported(hdev))
+	if (!hnae3_ae_dev_fd_supported(hdev->ae_dev))
 		return 0;
 
 	/* if fd is disabled, should not restore it when reset */
@@ -6497,7 +6497,7 @@ static int hclge_get_fd_rule_cnt(struct hnae3_handle *handle,
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
 
-	if (!hnae3_dev_fd_supported(hdev) || hclge_is_cls_flower_active(handle))
+	if (!hnae3_ae_dev_fd_supported(hdev->ae_dev) || hclge_is_cls_flower_active(handle))
 		return -EOPNOTSUPP;
 
 	cmd->rule_cnt = hdev->hclge_fd_rule_num;
@@ -6715,7 +6715,7 @@ static int hclge_get_fd_rule_info(struct hnae3_handle *handle,
 	struct hclge_dev *hdev = vport->back;
 	struct ethtool_rx_flow_spec *fs;
 
-	if (!hnae3_dev_fd_supported(hdev))
+	if (!hnae3_ae_dev_fd_supported(hdev->ae_dev))
 		return -EOPNOTSUPP;
 
 	fs = (struct ethtool_rx_flow_spec *)&cmd->fs;
@@ -6778,7 +6778,7 @@ static int hclge_get_all_rules(struct hnae3_handle *handle,
 	struct hlist_node *node2;
 	int cnt = 0;
 
-	if (!hnae3_dev_fd_supported(hdev))
+	if (!hnae3_ae_dev_fd_supported(hdev->ae_dev))
 		return -EOPNOTSUPP;
 
 	cmd->data = hdev->fd_cfg.rule_num[HCLGE_FD_STAGE_1];
@@ -6878,7 +6878,7 @@ static int hclge_add_fd_entry_by_arfs(struct hnae3_handle *handle, u16 queue_id,
 	struct hclge_fd_rule *rule;
 	u16 bit_id;
 
-	if (!hnae3_dev_fd_supported(hdev))
+	if (!hnae3_ae_dev_fd_supported(hdev->ae_dev))
 		return -EOPNOTSUPP;
 
 	/* when there is already fd rule existed add by user,
@@ -7167,6 +7167,12 @@ static int hclge_add_cls_flower(struct hnae3_handle *handle,
 	struct hclge_fd_rule *rule;
 	int ret;
 
+	if (!hnae3_ae_dev_fd_supported(hdev->ae_dev)) {
+		dev_err(&hdev->pdev->dev,
+			"cls flower is not supported\n");
+		return -EOPNOTSUPP;
+	}
+
 	ret = hclge_check_cls_flower(hdev, cls_flower, tc);
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
@@ -7220,6 +7226,9 @@ static int hclge_del_cls_flower(struct hnae3_handle *handle,
 	struct hclge_fd_rule *rule;
 	int ret;
 
+	if (!hnae3_ae_dev_fd_supported(hdev->ae_dev))
+		return -EOPNOTSUPP;
+
 	spin_lock_bh(&hdev->fd_rule_lock);
 
 	rule = hclge_find_cls_flower(hdev, cls_flower->cookie);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 26f87330173e..14e338fbf1eb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2125,7 +2125,7 @@ static int hclgevf_config_gro(struct hclgevf_dev *hdev)
 	struct hclge_desc desc;
 	int ret;
 
-	if (!hnae3_dev_gro_supported(hdev))
+	if (!hnae3_ae_dev_gro_supported(hdev->ae_dev))
 		return 0;
 
 	hclgevf_cmd_setup_basic_desc(&desc, HCLGE_OPC_GRO_GENERIC_CONFIG,
-- 
2.33.0

