Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21EB836E72
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 10:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbfFFIWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 04:22:54 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:18091 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727291AbfFFIWv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 04:22:51 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 954F6B90252155F5525F;
        Thu,  6 Jun 2019 16:22:48 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Thu, 6 Jun 2019 16:22:37 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yufeng Mo <moyufeng@huawei.com>,
        Weihang Li <liweihang@hisilicon.com>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 11/12] net: hns3: some modifications to simplify and optimize code
Date:   Thu, 6 Jun 2019 16:21:06 +0800
Message-ID: <1559809267-53805-12-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559809267-53805-1-git-send-email-tanhuazhong@huawei.com>
References: <1559809267-53805-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

This patch deletes some redundant code and refactors some bloated
functions.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  32 +++----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 102 ++++++++++++++-------
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  99 ++++++++++----------
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  25 ++---
 5 files changed, 151 insertions(+), 109 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 22526ba..49b4072 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -436,7 +436,7 @@ static void hns3_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 	switch (stringset) {
 	case ETH_SS_STATS:
 		buff = hns3_get_strings_tqps(h, buff);
-		h->ae_algo->ops->get_strings(h, stringset, (u8 *)buff);
+		ops->get_strings(h, stringset, (u8 *)buff);
 		break;
 	case ETH_SS_TEST:
 		ops->get_strings(h, stringset, data);
@@ -511,6 +511,11 @@ static void hns3_get_drvinfo(struct net_device *netdev,
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hnae3_handle *h = priv->ae_handle;
 
+	if (!h->ae_algo->ops->get_fw_version) {
+		netdev_err(netdev, "could not get fw version!\n");
+		return;
+	}
+
 	strncpy(drvinfo->version, hns3_driver_version,
 		sizeof(drvinfo->version));
 	drvinfo->version[sizeof(drvinfo->version) - 1] = '\0';
@@ -531,7 +536,7 @@ static u32 hns3_get_link(struct net_device *netdev)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 
-	if (h->ae_algo && h->ae_algo->ops && h->ae_algo->ops->get_status)
+	if (h->ae_algo->ops->get_status)
 		return h->ae_algo->ops->get_status(h);
 	else
 		return 0;
@@ -561,7 +566,7 @@ static void hns3_get_pauseparam(struct net_device *netdev,
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 
-	if (h->ae_algo && h->ae_algo->ops && h->ae_algo->ops->get_pauseparam)
+	if (h->ae_algo->ops->get_pauseparam)
 		h->ae_algo->ops->get_pauseparam(h, &param->autoneg,
 			&param->rx_pause, &param->tx_pause);
 }
@@ -611,9 +616,6 @@ static int hns3_get_link_ksettings(struct net_device *netdev,
 	u8 media_type;
 	u8 link_stat;
 
-	if (!h->ae_algo || !h->ae_algo->ops)
-		return -EOPNOTSUPP;
-
 	ops = h->ae_algo->ops;
 	if (ops->get_media_type)
 		ops->get_media_type(h, &media_type, &module_type);
@@ -741,8 +743,7 @@ static u32 hns3_get_rss_key_size(struct net_device *netdev)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 
-	if (!h->ae_algo || !h->ae_algo->ops ||
-	    !h->ae_algo->ops->get_rss_key_size)
+	if (!h->ae_algo->ops->get_rss_key_size)
 		return 0;
 
 	return h->ae_algo->ops->get_rss_key_size(h);
@@ -752,8 +753,7 @@ static u32 hns3_get_rss_indir_size(struct net_device *netdev)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 
-	if (!h->ae_algo || !h->ae_algo->ops ||
-	    !h->ae_algo->ops->get_rss_indir_size)
+	if (!h->ae_algo->ops->get_rss_indir_size)
 		return 0;
 
 	return h->ae_algo->ops->get_rss_indir_size(h);
@@ -764,7 +764,7 @@ static int hns3_get_rss(struct net_device *netdev, u32 *indir, u8 *key,
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 
-	if (!h->ae_algo || !h->ae_algo->ops || !h->ae_algo->ops->get_rss)
+	if (!h->ae_algo->ops->get_rss)
 		return -EOPNOTSUPP;
 
 	return h->ae_algo->ops->get_rss(h, indir, key, hfunc);
@@ -775,7 +775,7 @@ static int hns3_set_rss(struct net_device *netdev, const u32 *indir,
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 
-	if (!h->ae_algo || !h->ae_algo->ops || !h->ae_algo->ops->set_rss)
+	if (!h->ae_algo->ops->set_rss)
 		return -EOPNOTSUPP;
 
 	if ((h->pdev->revision == 0x20 &&
@@ -800,9 +800,6 @@ static int hns3_get_rxnfc(struct net_device *netdev,
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 
-	if (!h->ae_algo || !h->ae_algo->ops)
-		return -EOPNOTSUPP;
-
 	switch (cmd->cmd) {
 	case ETHTOOL_GRXRINGS:
 		cmd->data = h->kinfo.num_tqps;
@@ -916,9 +913,6 @@ static int hns3_set_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 
-	if (!h->ae_algo || !h->ae_algo->ops)
-		return -EOPNOTSUPP;
-
 	switch (cmd->cmd) {
 	case ETHTOOL_SRXFH:
 		if (h->ae_algo->ops->set_rss_tuple)
@@ -1194,7 +1188,7 @@ static int hns3_set_phys_id(struct net_device *netdev,
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 
-	if (!h->ae_algo || !h->ae_algo->ops || !h->ae_algo->ops->set_led_id)
+	if (!h->ae_algo->ops->set_led_id)
 		return -EOPNOTSUPP;
 
 	return h->ae_algo->ops->set_led_id(h, state);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index e1f4ba1..b47f701 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -31,6 +31,8 @@
 #define HCLGE_BUF_MUL_BY	2
 #define HCLGE_BUF_DIV_BY	2
 
+#define HCLGE_RESET_MAX_FAIL_CNT	5
+
 static int hclge_set_mac_mtu(struct hclge_dev *hdev, int new_mps);
 static int hclge_init_vlan_config(struct hclge_dev *hdev);
 static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev);
@@ -2169,7 +2171,8 @@ static int hclge_cfg_mac_speed_dup_hw(struct hclge_dev *hdev, int speed,
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_CONFIG_SPEED_DUP, false);
 
-	hnae3_set_bit(req->speed_dup, HCLGE_CFG_DUPLEX_B, !!duplex);
+	if (duplex)
+		hnae3_set_bit(req->speed_dup, HCLGE_CFG_DUPLEX_B, 1);
 
 	switch (speed) {
 	case HCLGE_MAC_SPEED_10M:
@@ -2531,7 +2534,7 @@ static void hclge_update_port_capability(struct hclge_mac *mac)
 
 static int hclge_get_sfp_speed(struct hclge_dev *hdev, u32 *speed)
 {
-	struct hclge_sfp_info_cmd *resp = NULL;
+	struct hclge_sfp_info_cmd *resp;
 	struct hclge_desc desc;
 	int ret;
 
@@ -3271,6 +3274,25 @@ static int hclge_reset_prepare_up(struct hclge_dev *hdev)
 	return ret;
 }
 
+static int hclge_reset_stack(struct hclge_dev *hdev)
+{
+	int ret;
+
+	ret = hclge_notify_client(hdev, HNAE3_UNINIT_CLIENT);
+	if (ret)
+		return ret;
+
+	ret = hclge_reset_ae_dev(hdev->ae_dev);
+	if (ret)
+		return ret;
+
+	ret = hclge_notify_client(hdev, HNAE3_INIT_CLIENT);
+	if (ret)
+		return ret;
+
+	return hclge_notify_client(hdev, HNAE3_RESTORE_CLIENT);
+}
+
 static void hclge_reset(struct hclge_dev *hdev)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
@@ -3314,27 +3336,31 @@ static void hclge_reset(struct hclge_dev *hdev)
 		goto err_reset;
 
 	rtnl_lock();
-	ret = hclge_notify_client(hdev, HNAE3_UNINIT_CLIENT);
-	if (ret)
-		goto err_reset_lock;
 
-	ret = hclge_reset_ae_dev(hdev->ae_dev);
+	ret = hclge_reset_stack(hdev);
 	if (ret)
 		goto err_reset_lock;
 
-	ret = hclge_notify_client(hdev, HNAE3_INIT_CLIENT);
-	if (ret)
-		goto err_reset_lock;
+	hclge_clear_reset_cause(hdev);
 
-	ret = hclge_notify_client(hdev, HNAE3_RESTORE_CLIENT);
+	ret = hclge_reset_prepare_up(hdev);
 	if (ret)
 		goto err_reset_lock;
 
-	hclge_clear_reset_cause(hdev);
+	rtnl_unlock();
 
-	ret = hclge_reset_prepare_up(hdev);
+	ret = hclge_notify_roce_client(hdev, HNAE3_INIT_CLIENT);
 	if (ret)
-		goto err_reset_lock;
+		goto err_reset;
+
+	ret = hclge_notify_roce_client(hdev, HNAE3_INIT_CLIENT);
+	/* ignore RoCE notify error if it fails HCLGE_RESET_MAX_FAIL_CNT - 1
+	 * times
+	 */
+	if (ret && hdev->reset_fail_cnt < HCLGE_RESET_MAX_FAIL_CNT - 1)
+		goto err_reset;
+
+	rtnl_lock();
 
 	ret = hclge_notify_client(hdev, HNAE3_UP_CLIENT);
 	if (ret)
@@ -3342,10 +3368,6 @@ static void hclge_reset(struct hclge_dev *hdev)
 
 	rtnl_unlock();
 
-	ret = hclge_notify_roce_client(hdev, HNAE3_INIT_CLIENT);
-	if (ret)
-		goto err_reset;
-
 	ret = hclge_notify_roce_client(hdev, HNAE3_UP_CLIENT);
 	if (ret)
 		goto err_reset;
@@ -6439,7 +6461,9 @@ static int hclge_set_umv_space(struct hclge_dev *hdev, u16 space_size,
 
 	req = (struct hclge_umv_spc_alc_cmd *)desc.data;
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_MAC_VLAN_ALLOCATE, false);
-	hnae3_set_bit(req->allocate, HCLGE_UMV_SPC_ALC_B, !is_alloc);
+	if (!is_alloc)
+		hnae3_set_bit(req->allocate, HCLGE_UMV_SPC_ALC_B, 1);
+
 	req->space_size = cpu_to_le32(space_size);
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
@@ -6639,18 +6663,16 @@ int hclge_add_mc_addr_common(struct hclge_vport *vport,
 	hnae3_set_bit(req.entry_type, HCLGE_MAC_VLAN_BIT0_EN_B, 0);
 	hclge_prepare_mac_addr(&req, addr, true);
 	status = hclge_lookup_mac_vlan_tbl(vport, &req, desc, true);
-	if (!status) {
-		/* This mac addr exist, update VFID for it */
-		hclge_update_desc_vfid(desc, vport->vport_id, false);
-		status = hclge_add_mac_vlan_tbl(vport, &req, desc);
-	} else {
+	if (status) {
 		/* This mac addr do not exist, add new entry for it */
 		memset(desc[0].data, 0, sizeof(desc[0].data));
 		memset(desc[1].data, 0, sizeof(desc[0].data));
 		memset(desc[2].data, 0, sizeof(desc[0].data));
-		hclge_update_desc_vfid(desc, vport->vport_id, false);
-		status = hclge_add_mac_vlan_tbl(vport, &req, desc);
 	}
+	status = hclge_update_desc_vfid(desc, vport->vport_id, false);
+	if (status)
+		return status;
+	status = hclge_add_mac_vlan_tbl(vport, &req, desc);
 
 	if (status == -ENOSPC)
 		dev_err(&hdev->pdev->dev, "mc mac vlan table is full\n");
@@ -6688,7 +6710,9 @@ int hclge_rm_mc_addr_common(struct hclge_vport *vport,
 	status = hclge_lookup_mac_vlan_tbl(vport, &req, desc, true);
 	if (!status) {
 		/* This mac addr exist, remove this handle's VFID for it */
-		hclge_update_desc_vfid(desc, vport->vport_id, true);
+		status = hclge_update_desc_vfid(desc, vport->vport_id, true);
+		if (status)
+			return status;
 
 		if (hclge_is_all_function_id_zero(desc))
 			/* All the vfid is zero, so need to delete this entry */
@@ -7761,7 +7785,7 @@ static int hclge_set_mtu(struct hnae3_handle *handle, int new_mtu)
 int hclge_set_vport_mtu(struct hclge_vport *vport, int new_mtu)
 {
 	struct hclge_dev *hdev = vport->back;
-	int i, max_frm_size, ret = 0;
+	int i, max_frm_size, ret;
 
 	max_frm_size = new_mtu + ETH_HLEN + ETH_FCS_LEN + 2 * VLAN_HLEN;
 	if (max_frm_size < HCLGE_MAC_MIN_FRAME ||
@@ -7872,7 +7896,7 @@ int hclge_reset_tqp(struct hnae3_handle *handle, u16 queue_id)
 	int reset_try_times = 0;
 	int reset_status;
 	u16 queue_gid;
-	int ret = 0;
+	int ret;
 
 	queue_gid = hclge_covert_handle_qid_global(handle, queue_id);
 
@@ -7889,7 +7913,6 @@ int hclge_reset_tqp(struct hnae3_handle *handle, u16 queue_id)
 		return ret;
 	}
 
-	reset_try_times = 0;
 	while (reset_try_times++ < HCLGE_TQP_RESET_TRY_TIMES) {
 		/* Wait for tqp hw reset */
 		msleep(20);
@@ -7928,7 +7951,6 @@ void hclge_reset_vf_queue(struct hclge_vport *vport, u16 queue_id)
 		return;
 	}
 
-	reset_try_times = 0;
 	while (reset_try_times++ < HCLGE_TQP_RESET_TRY_TIMES) {
 		/* Wait for tqp hw reset */
 		msleep(20);
@@ -7998,7 +8020,7 @@ int hclge_cfg_flowctrl(struct hclge_dev *hdev)
 {
 	struct phy_device *phydev = hdev->hw.mac.phydev;
 	u16 remote_advertising = 0;
-	u16 local_advertising = 0;
+	u16 local_advertising;
 	u32 rx_pause, tx_pause;
 	u8 flowctl;
 
@@ -8445,6 +8467,23 @@ static void hclge_flr_done(struct hnae3_ae_dev *ae_dev)
 	set_bit(HNAE3_FLR_DONE, &hdev->flr_state);
 }
 
+static void hclge_clear_resetting_state(struct hclge_dev *hdev)
+{
+	u16 i;
+
+	for (i = 0; i < hdev->num_alloc_vport; i++) {
+		struct hclge_vport *vport = &hdev->vport[i];
+		int ret;
+
+		 /* Send cmd to clear VF's FUNC_RST_ING */
+		ret = hclge_set_vf_rst(hdev, vport->vport_id, false);
+		if (ret)
+			dev_warn(&hdev->pdev->dev,
+				 "clear vf(%d) rst failed %d!\n",
+				 vport->vport_id, ret);
+	}
+}
+
 static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 {
 	struct pci_dev *pdev = ae_dev->pdev;
@@ -8605,6 +8644,7 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	INIT_WORK(&hdev->mbx_service_task, hclge_mailbox_service_task);
 
 	hclge_clear_all_event_cause(hdev);
+	hclge_clear_resetting_state(hdev);
 
 	/* Enable MISC vector(vector0) */
 	hclge_enable_vector(&hdev->misc_vector, true);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 2003817..64578e9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -369,7 +369,7 @@ static int hclge_get_vf_tcinfo(struct hclge_vport *vport,
 		vf_tc_map |= BIT(i);
 
 	ret = hclge_gen_resp_to_vf(vport, mbx_req, 0, &vf_tc_map,
-				   sizeof(u8));
+				   sizeof(vf_tc_map));
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index d427ec0e..5577e80 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -123,14 +123,13 @@ static int hclge_pfc_stats_get(struct hclge_dev *hdev,
 	      opcode == HCLGE_OPC_QUERY_PFC_TX_PKT_CNT))
 		return -EINVAL;
 
-	for (i = 0; i < HCLGE_TM_PFC_PKT_GET_CMD_NUM; i++) {
+	for (i = 0; i < HCLGE_TM_PFC_PKT_GET_CMD_NUM - 1; i++) {
 		hclge_cmd_setup_basic_desc(&desc[i], opcode, true);
-		if (i != (HCLGE_TM_PFC_PKT_GET_CMD_NUM - 1))
-			desc[i].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
-		else
-			desc[i].flag &= ~cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
+		desc[i].flag |= cpu_to_le16(HCLGE_CMD_FLAG_NEXT);
 	}
 
+	hclge_cmd_setup_basic_desc(&desc[i], opcode, true);
+
 	ret = hclge_cmd_send(&hdev->hw, desc, HCLGE_TM_PFC_PKT_GET_CMD_NUM);
 	if (ret)
 		return ret;
@@ -365,14 +364,27 @@ static int hclge_tm_qs_weight_cfg(struct hclge_dev *hdev, u16 qs_id,
 	return hclge_cmd_send(&hdev->hw, &desc, 1);
 }
 
+static u32 hclge_tm_get_shapping_para(u8 ir_b, u8 ir_u, u8 ir_s,
+				      u8 bs_b, u8 bs_s)
+{
+	u32 shapping_para = 0;
+
+	hclge_tm_set_field(shapping_para, IR_B, ir_b);
+	hclge_tm_set_field(shapping_para, IR_U, ir_u);
+	hclge_tm_set_field(shapping_para, IR_S, ir_s);
+	hclge_tm_set_field(shapping_para, BS_B, bs_b);
+	hclge_tm_set_field(shapping_para, BS_S, bs_s);
+
+	return shapping_para;
+}
+
 static int hclge_tm_pg_shapping_cfg(struct hclge_dev *hdev,
 				    enum hclge_shap_bucket bucket, u8 pg_id,
-				    u8 ir_b, u8 ir_u, u8 ir_s, u8 bs_b, u8 bs_s)
+				    u32 shapping_para)
 {
 	struct hclge_pg_shapping_cmd *shap_cfg_cmd;
 	enum hclge_opcode_type opcode;
 	struct hclge_desc desc;
-	u32 shapping_para = 0;
 
 	opcode = bucket ? HCLGE_OPC_TM_PG_P_SHAPPING :
 		HCLGE_OPC_TM_PG_C_SHAPPING;
@@ -382,12 +394,6 @@ static int hclge_tm_pg_shapping_cfg(struct hclge_dev *hdev,
 
 	shap_cfg_cmd->pg_id = pg_id;
 
-	hclge_tm_set_field(shapping_para, IR_B, ir_b);
-	hclge_tm_set_field(shapping_para, IR_U, ir_u);
-	hclge_tm_set_field(shapping_para, IR_S, ir_s);
-	hclge_tm_set_field(shapping_para, BS_B, bs_b);
-	hclge_tm_set_field(shapping_para, BS_S, bs_s);
-
 	shap_cfg_cmd->pg_shapping_para = cpu_to_le32(shapping_para);
 
 	return hclge_cmd_send(&hdev->hw, &desc, 1);
@@ -410,11 +416,9 @@ static int hclge_tm_port_shaper_cfg(struct hclge_dev *hdev)
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_TM_PORT_SHAPPING, false);
 	shap_cfg_cmd = (struct hclge_port_shapping_cmd *)desc.data;
 
-	hclge_tm_set_field(shapping_para, IR_B, ir_b);
-	hclge_tm_set_field(shapping_para, IR_U, ir_u);
-	hclge_tm_set_field(shapping_para, IR_S, ir_s);
-	hclge_tm_set_field(shapping_para, BS_B, HCLGE_SHAPER_BS_U_DEF);
-	hclge_tm_set_field(shapping_para, BS_S, HCLGE_SHAPER_BS_S_DEF);
+	shapping_para = hclge_tm_get_shapping_para(ir_b, ir_u, ir_s,
+						   HCLGE_SHAPER_BS_U_DEF,
+						   HCLGE_SHAPER_BS_S_DEF);
 
 	shap_cfg_cmd->port_shapping_para = cpu_to_le32(shapping_para);
 
@@ -423,13 +427,11 @@ static int hclge_tm_port_shaper_cfg(struct hclge_dev *hdev)
 
 static int hclge_tm_pri_shapping_cfg(struct hclge_dev *hdev,
 				     enum hclge_shap_bucket bucket, u8 pri_id,
-				     u8 ir_b, u8 ir_u, u8 ir_s,
-				     u8 bs_b, u8 bs_s)
+				     u32 shapping_para)
 {
 	struct hclge_pri_shapping_cmd *shap_cfg_cmd;
 	enum hclge_opcode_type opcode;
 	struct hclge_desc desc;
-	u32 shapping_para = 0;
 
 	opcode = bucket ? HCLGE_OPC_TM_PRI_P_SHAPPING :
 		HCLGE_OPC_TM_PRI_C_SHAPPING;
@@ -440,12 +442,6 @@ static int hclge_tm_pri_shapping_cfg(struct hclge_dev *hdev,
 
 	shap_cfg_cmd->pri_id = pri_id;
 
-	hclge_tm_set_field(shapping_para, IR_B, ir_b);
-	hclge_tm_set_field(shapping_para, IR_U, ir_u);
-	hclge_tm_set_field(shapping_para, IR_S, ir_s);
-	hclge_tm_set_field(shapping_para, BS_B, bs_b);
-	hclge_tm_set_field(shapping_para, BS_S, bs_s);
-
 	shap_cfg_cmd->pri_shapping_para = cpu_to_le32(shapping_para);
 
 	return hclge_cmd_send(&hdev->hw, &desc, 1);
@@ -687,6 +683,7 @@ static int hclge_tm_pg_to_pri_map(struct hclge_dev *hdev)
 static int hclge_tm_pg_shaper_cfg(struct hclge_dev *hdev)
 {
 	u8 ir_u, ir_b, ir_s;
+	u32 shaper_para;
 	int ret;
 	u32 i;
 
@@ -704,18 +701,21 @@ static int hclge_tm_pg_shaper_cfg(struct hclge_dev *hdev)
 		if (ret)
 			return ret;
 
+		shaper_para = hclge_tm_get_shapping_para(0, 0, 0,
+							 HCLGE_SHAPER_BS_U_DEF,
+							 HCLGE_SHAPER_BS_S_DEF);
 		ret = hclge_tm_pg_shapping_cfg(hdev,
 					       HCLGE_TM_SHAP_C_BUCKET, i,
-					       0, 0, 0, HCLGE_SHAPER_BS_U_DEF,
-					       HCLGE_SHAPER_BS_S_DEF);
+					       shaper_para);
 		if (ret)
 			return ret;
 
+		shaper_para = hclge_tm_get_shapping_para(ir_b, ir_u, ir_s,
+							 HCLGE_SHAPER_BS_U_DEF,
+							 HCLGE_SHAPER_BS_S_DEF);
 		ret = hclge_tm_pg_shapping_cfg(hdev,
 					       HCLGE_TM_SHAP_P_BUCKET, i,
-					       ir_b, ir_u, ir_s,
-					       HCLGE_SHAPER_BS_U_DEF,
-					       HCLGE_SHAPER_BS_S_DEF);
+					       shaper_para);
 		if (ret)
 			return ret;
 	}
@@ -816,6 +816,7 @@ static int hclge_tm_pri_q_qs_cfg(struct hclge_dev *hdev)
 static int hclge_tm_pri_tc_base_shaper_cfg(struct hclge_dev *hdev)
 {
 	u8 ir_u, ir_b, ir_s;
+	u32 shaper_para;
 	int ret;
 	u32 i;
 
@@ -827,17 +828,19 @@ static int hclge_tm_pri_tc_base_shaper_cfg(struct hclge_dev *hdev)
 		if (ret)
 			return ret;
 
-		ret = hclge_tm_pri_shapping_cfg(
-			hdev, HCLGE_TM_SHAP_C_BUCKET, i,
-			0, 0, 0, HCLGE_SHAPER_BS_U_DEF,
-			HCLGE_SHAPER_BS_S_DEF);
+		shaper_para = hclge_tm_get_shapping_para(0, 0, 0,
+							 HCLGE_SHAPER_BS_U_DEF,
+							 HCLGE_SHAPER_BS_S_DEF);
+		ret = hclge_tm_pri_shapping_cfg(hdev, HCLGE_TM_SHAP_C_BUCKET, i,
+						shaper_para);
 		if (ret)
 			return ret;
 
-		ret = hclge_tm_pri_shapping_cfg(
-			hdev, HCLGE_TM_SHAP_P_BUCKET, i,
-			ir_b, ir_u, ir_s, HCLGE_SHAPER_BS_U_DEF,
-			HCLGE_SHAPER_BS_S_DEF);
+		shaper_para = hclge_tm_get_shapping_para(ir_b, ir_u, ir_s,
+							 HCLGE_SHAPER_BS_U_DEF,
+							 HCLGE_SHAPER_BS_S_DEF);
+		ret = hclge_tm_pri_shapping_cfg(hdev, HCLGE_TM_SHAP_P_BUCKET, i,
+						shaper_para);
 		if (ret)
 			return ret;
 	}
@@ -849,6 +852,7 @@ static int hclge_tm_pri_vnet_base_shaper_pri_cfg(struct hclge_vport *vport)
 {
 	struct hclge_dev *hdev = vport->back;
 	u8 ir_u, ir_b, ir_s;
+	u32 shaper_para;
 	int ret;
 
 	ret = hclge_shaper_para_calc(vport->bw_limit, HCLGE_SHAPER_LVL_VF,
@@ -856,18 +860,19 @@ static int hclge_tm_pri_vnet_base_shaper_pri_cfg(struct hclge_vport *vport)
 	if (ret)
 		return ret;
 
+	shaper_para = hclge_tm_get_shapping_para(0, 0, 0,
+						 HCLGE_SHAPER_BS_U_DEF,
+						 HCLGE_SHAPER_BS_S_DEF);
 	ret = hclge_tm_pri_shapping_cfg(hdev, HCLGE_TM_SHAP_C_BUCKET,
-					vport->vport_id,
-					0, 0, 0, HCLGE_SHAPER_BS_U_DEF,
-					HCLGE_SHAPER_BS_S_DEF);
+					vport->vport_id, shaper_para);
 	if (ret)
 		return ret;
 
+	shaper_para = hclge_tm_get_shapping_para(ir_b, ir_u, ir_s,
+						 HCLGE_SHAPER_BS_U_DEF,
+						 HCLGE_SHAPER_BS_S_DEF);
 	ret = hclge_tm_pri_shapping_cfg(hdev, HCLGE_TM_SHAP_P_BUCKET,
-					vport->vport_id,
-					ir_b, ir_u, ir_s,
-					HCLGE_SHAPER_BS_U_DEF,
-					HCLGE_SHAPER_BS_S_DEF);
+					vport->vport_id, shaper_para);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 8aa7167..139fb6a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -232,7 +232,7 @@ static int hclgevf_get_tc_info(struct hclgevf_dev *hdev)
 	int status;
 
 	status = hclgevf_send_mbx_msg(hdev, HCLGE_MBX_GET_TCINFO, 0, NULL, 0,
-				      true, &resp_msg, sizeof(u8));
+				      true, &resp_msg, sizeof(resp_msg));
 	if (status) {
 		dev_err(&hdev->pdev->dev,
 			"VF request to get TC info from PF failed %d",
@@ -321,7 +321,8 @@ static u16 hclgevf_get_qid_global(struct hnae3_handle *handle, u16 queue_id)
 	memcpy(&msg_data[0], &queue_id, sizeof(queue_id));
 
 	ret = hclgevf_send_mbx_msg(hdev, HCLGE_MBX_GET_QID_IN_PF, 0, msg_data,
-				   2, true, resp_data, 2);
+				   sizeof(msg_data), true, resp_data,
+				   sizeof(resp_data));
 	if (!ret)
 		qid_in_pf = *(u16 *)resp_data;
 
@@ -418,7 +419,7 @@ static void hclgevf_request_link_info(struct hclgevf_dev *hdev)
 	u8 resp_msg;
 
 	status = hclgevf_send_mbx_msg(hdev, HCLGE_MBX_GET_LINK_STATUS, 0, NULL,
-				      0, false, &resp_msg, sizeof(u8));
+				      0, false, &resp_msg, sizeof(resp_msg));
 	if (status)
 		dev_err(&hdev->pdev->dev,
 			"VF failed to fetch link status(%d) from PF", status);
@@ -453,11 +454,13 @@ static void hclgevf_update_link_mode(struct hclgevf_dev *hdev)
 	u8 resp_msg;
 
 	send_msg = HCLGEVF_ADVERTISING;
-	hclgevf_send_mbx_msg(hdev, HCLGE_MBX_GET_LINK_MODE, 0, &send_msg,
-			     sizeof(u8), false, &resp_msg, sizeof(u8));
+	hclgevf_send_mbx_msg(hdev, HCLGE_MBX_GET_LINK_MODE, 0,
+			     &send_msg, sizeof(send_msg), false,
+			     &resp_msg, sizeof(resp_msg));
 	send_msg = HCLGEVF_SUPPORTED;
-	hclgevf_send_mbx_msg(hdev, HCLGE_MBX_GET_LINK_MODE, 0, &send_msg,
-			     sizeof(u8), false, &resp_msg, sizeof(u8));
+	hclgevf_send_mbx_msg(hdev, HCLGE_MBX_GET_LINK_MODE, 0,
+			     &send_msg, sizeof(send_msg), false,
+			     &resp_msg, sizeof(resp_msg));
 }
 
 static int hclgevf_set_handle_info(struct hclgevf_dev *hdev)
@@ -1186,7 +1189,7 @@ static int hclgevf_set_mac_addr(struct hnae3_handle *handle, void *p,
 			HCLGE_MBX_MAC_VLAN_UC_MODIFY;
 
 	status = hclgevf_send_mbx_msg(hdev, HCLGE_MBX_SET_UNICAST,
-				      subcode, msg_data, ETH_ALEN * 2,
+				      subcode, msg_data, sizeof(msg_data),
 				      true, NULL, 0);
 	if (!status)
 		ether_addr_copy(hdev->hw.mac.mac_addr, new_mac_addr);
@@ -1273,7 +1276,7 @@ static int hclgevf_reset_tqp(struct hnae3_handle *handle, u16 queue_id)
 	u8 msg_data[2];
 	int ret;
 
-	memcpy(&msg_data[0], &queue_id, sizeof(queue_id));
+	memcpy(msg_data, &queue_id, sizeof(queue_id));
 
 	/* disable vf queue before send queue reset msg to PF */
 	ret = hclgevf_tqp_enable(hdev, queue_id, 0, false);
@@ -1281,7 +1284,7 @@ static int hclgevf_reset_tqp(struct hnae3_handle *handle, u16 queue_id)
 		return ret;
 
 	return hclgevf_send_mbx_msg(hdev, HCLGE_MBX_QUEUE_RESET, 0, msg_data,
-				    2, true, NULL, 0);
+				    sizeof(msg_data), true, NULL, 0);
 }
 
 static int hclgevf_set_mtu(struct hnae3_handle *handle, int new_mtu)
@@ -1768,7 +1771,7 @@ static void hclgevf_keep_alive_task(struct work_struct *work)
 		return;
 
 	ret = hclgevf_send_mbx_msg(hdev, HCLGE_MBX_KEEP_ALIVE, 0, NULL,
-				   0, false, &respmsg, sizeof(u8));
+				   0, false, &respmsg, sizeof(respmsg));
 	if (ret)
 		dev_err(&hdev->pdev->dev,
 			"VF sends keep alive cmd failed(=%d)\n", ret);
-- 
2.7.4

