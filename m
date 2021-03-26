Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCCB349EC8
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 02:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhCZBg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 21:36:57 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14608 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhCZBgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 21:36:24 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F64JX0CMzz19JFZ;
        Fri, 26 Mar 2021 09:34:20 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Fri, 26 Mar 2021 09:36:11 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/9] net: hns3: remove unused code of vmdq
Date:   Fri, 26 Mar 2021 09:36:20 +0800
Message-ID: <1616722588-58967-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1616722588-58967-1-git-send-email-tanhuazhong@huawei.com>
References: <1616722588-58967-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Vmdq is not supported yet, the num_vmdq_vport is always 0,
it's a bit confusing when using the num_vport, so remove
these unused codes of vmdq.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   2 -
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 240 +++++++++------------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   2 -
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |   1 -
 4 files changed, 96 insertions(+), 149 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 565c5aa..7feab84 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -506,8 +506,6 @@ struct hclge_pf_res_cmd {
 #define HCLGE_CFG_RD_LEN_BYTES	16
 #define HCLGE_CFG_RD_LEN_UNIT	4
 
-#define HCLGE_CFG_VMDQ_S	0
-#define HCLGE_CFG_VMDQ_M	GENMASK(7, 0)
 #define HCLGE_CFG_TC_NUM_S	8
 #define HCLGE_CFG_TC_NUM_M	GENMASK(15, 8)
 #define HCLGE_CFG_TQP_DESC_N_S	16
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 058317c..4967e72 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1292,9 +1292,6 @@ static void hclge_parse_cfg(struct hclge_cfg *cfg, struct hclge_desc *desc)
 	req = (struct hclge_cfg_param_cmd *)desc[0].data;
 
 	/* get the configuration */
-	cfg->vmdq_vport_num = hnae3_get_field(__le32_to_cpu(req->param[0]),
-					      HCLGE_CFG_VMDQ_M,
-					      HCLGE_CFG_VMDQ_S);
 	cfg->tc_num = hnae3_get_field(__le32_to_cpu(req->param[0]),
 				      HCLGE_CFG_TC_NUM_M, HCLGE_CFG_TC_NUM_S);
 	cfg->tqp_desc_num = hnae3_get_field(__le32_to_cpu(req->param[0]),
@@ -1511,7 +1508,7 @@ static void hclge_init_kdump_kernel_config(struct hclge_dev *hdev)
 		 "Running kdump kernel. Using minimal resources\n");
 
 	/* minimal queue pairs equals to the number of vports */
-	hdev->num_tqps = hdev->num_vmdq_vport + hdev->num_req_vfs + 1;
+	hdev->num_tqps = hdev->num_req_vfs + 1;
 	hdev->num_tx_desc = HCLGE_MIN_TX_DESC;
 	hdev->num_rx_desc = HCLGE_MIN_RX_DESC;
 }
@@ -1526,7 +1523,6 @@ static int hclge_configure(struct hclge_dev *hdev)
 	if (ret)
 		return ret;
 
-	hdev->num_vmdq_vport = cfg.vmdq_vport_num;
 	hdev->base_tqp_pid = 0;
 	hdev->vf_rss_size_max = cfg.vf_rss_size_max;
 	hdev->pf_rss_size_max = cfg.pf_rss_size_max;
@@ -1777,7 +1773,7 @@ static int hclge_map_tqp(struct hclge_dev *hdev)
 	struct hclge_vport *vport = hdev->vport;
 	u16 i, num_vport;
 
-	num_vport = hdev->num_vmdq_vport + hdev->num_req_vfs + 1;
+	num_vport = hdev->num_req_vfs + 1;
 	for (i = 0; i < num_vport; i++)	{
 		int ret;
 
@@ -1819,7 +1815,7 @@ static int hclge_alloc_vport(struct hclge_dev *hdev)
 	int ret;
 
 	/* We need to alloc a vport for main NIC of PF */
-	num_vport = hdev->num_vmdq_vport + hdev->num_req_vfs + 1;
+	num_vport = hdev->num_req_vfs + 1;
 
 	if (hdev->num_tqps < num_vport) {
 		dev_err(&hdev->pdev->dev, "tqps(%u) is less than vports(%d)",
@@ -2889,13 +2885,12 @@ static int hclge_get_mac_phy_link(struct hclge_dev *hdev, int *link_status)
 
 static void hclge_update_link_status(struct hclge_dev *hdev)
 {
+	struct hnae3_handle *rhandle = &hdev->vport[0].roce;
+	struct hnae3_handle *handle = &hdev->vport[0].nic;
 	struct hnae3_client *rclient = hdev->roce_client;
 	struct hnae3_client *client = hdev->nic_client;
-	struct hnae3_handle *rhandle;
-	struct hnae3_handle *handle;
 	int state;
 	int ret;
-	int i;
 
 	if (!client)
 		return;
@@ -2910,15 +2905,11 @@ static void hclge_update_link_status(struct hclge_dev *hdev)
 	}
 
 	if (state != hdev->hw.mac.link) {
-		for (i = 0; i < hdev->num_vmdq_vport + 1; i++) {
-			handle = &hdev->vport[i].nic;
-			client->ops->link_status_change(handle, state);
-			hclge_config_mac_tnl_int(hdev, state);
-			rhandle = &hdev->vport[i].roce;
-			if (rclient && rclient->ops->link_status_change)
-				rclient->ops->link_status_change(rhandle,
-								 state);
-		}
+		client->ops->link_status_change(handle, state);
+		hclge_config_mac_tnl_int(hdev, state);
+		if (rclient && rclient->ops->link_status_change)
+			rclient->ops->link_status_change(rhandle, state);
+
 		hdev->hw.mac.link = state;
 	}
 
@@ -3498,8 +3489,9 @@ static void hclge_misc_irq_uninit(struct hclge_dev *hdev)
 int hclge_notify_client(struct hclge_dev *hdev,
 			enum hnae3_reset_notify_type type)
 {
+	struct hnae3_handle *handle = &hdev->vport[0].nic;
 	struct hnae3_client *client = hdev->nic_client;
-	u16 i;
+	int ret;
 
 	if (!test_bit(HCLGE_STATE_NIC_REGISTERED, &hdev->state) || !client)
 		return 0;
@@ -3507,27 +3499,20 @@ int hclge_notify_client(struct hclge_dev *hdev,
 	if (!client->ops->reset_notify)
 		return -EOPNOTSUPP;
 
-	for (i = 0; i < hdev->num_vmdq_vport + 1; i++) {
-		struct hnae3_handle *handle = &hdev->vport[i].nic;
-		int ret;
-
-		ret = client->ops->reset_notify(handle, type);
-		if (ret) {
-			dev_err(&hdev->pdev->dev,
-				"notify nic client failed %d(%d)\n", type, ret);
-			return ret;
-		}
-	}
+	ret = client->ops->reset_notify(handle, type);
+	if (ret)
+		dev_err(&hdev->pdev->dev, "notify nic client failed %d(%d)\n",
+			type, ret);
 
-	return 0;
+	return ret;
 }
 
 static int hclge_notify_roce_client(struct hclge_dev *hdev,
 				    enum hnae3_reset_notify_type type)
 {
+	struct hnae3_handle *handle = &hdev->vport[0].roce;
 	struct hnae3_client *client = hdev->roce_client;
 	int ret;
-	u16 i;
 
 	if (!test_bit(HCLGE_STATE_ROCE_REGISTERED, &hdev->state) || !client)
 		return 0;
@@ -3535,17 +3520,10 @@ static int hclge_notify_roce_client(struct hclge_dev *hdev,
 	if (!client->ops->reset_notify)
 		return -EOPNOTSUPP;
 
-	for (i = 0; i < hdev->num_vmdq_vport + 1; i++) {
-		struct hnae3_handle *handle = &hdev->vport[i].roce;
-
-		ret = client->ops->reset_notify(handle, type);
-		if (ret) {
-			dev_err(&hdev->pdev->dev,
-				"notify roce client failed %d(%d)",
-				type, ret);
-			return ret;
-		}
-	}
+	ret = client->ops->reset_notify(handle, type);
+	if (ret)
+		dev_err(&hdev->pdev->dev, "notify roce client failed %d(%d)",
+			type, ret);
 
 	return ret;
 }
@@ -3613,7 +3591,7 @@ static int hclge_set_all_vf_rst(struct hclge_dev *hdev, bool reset)
 {
 	int i;
 
-	for (i = hdev->num_vmdq_vport + 1; i < hdev->num_alloc_vport; i++) {
+	for (i = HCLGE_VF_VPORT_START_NUM; i < hdev->num_alloc_vport; i++) {
 		struct hclge_vport *vport = &hdev->vport[i];
 		int ret;
 
@@ -3694,14 +3672,12 @@ void hclge_report_hw_error(struct hclge_dev *hdev,
 			   enum hnae3_hw_error_type type)
 {
 	struct hnae3_client *client = hdev->nic_client;
-	u16 i;
 
 	if (!client || !client->ops->process_hw_error ||
 	    !test_bit(HCLGE_STATE_NIC_REGISTERED, &hdev->state))
 		return;
 
-	for (i = 0; i < hdev->num_vmdq_vport + 1; i++)
-		client->ops->process_hw_error(&hdev->vport[i].nic, type);
+	client->ops->process_hw_error(&hdev->vport[0].nic, type);
 }
 
 static void hclge_handle_imp_error(struct hclge_dev *hdev)
@@ -4913,58 +4889,44 @@ int hclge_rss_init_hw(struct hclge_dev *hdev)
 
 void hclge_rss_indir_init_cfg(struct hclge_dev *hdev)
 {
-	struct hclge_vport *vport = hdev->vport;
-	int i, j;
+	struct hclge_vport *vport = &hdev->vport[0];
+	int i;
 
-	for (j = 0; j < hdev->num_vmdq_vport + 1; j++) {
-		for (i = 0; i < hdev->ae_dev->dev_specs.rss_ind_tbl_size; i++)
-			vport[j].rss_indirection_tbl[i] =
-				i % vport[j].alloc_rss_size;
-	}
+	for (i = 0; i < hdev->ae_dev->dev_specs.rss_ind_tbl_size; i++)
+		vport->rss_indirection_tbl[i] = i % vport->alloc_rss_size;
 }
 
 static int hclge_rss_init_cfg(struct hclge_dev *hdev)
 {
 	u16 rss_ind_tbl_size = hdev->ae_dev->dev_specs.rss_ind_tbl_size;
-	int i, rss_algo = HCLGE_RSS_HASH_ALGO_TOEPLITZ;
-	struct hclge_vport *vport = hdev->vport;
+	int rss_algo = HCLGE_RSS_HASH_ALGO_TOEPLITZ;
+	struct hclge_vport *vport = &hdev->vport[0];
+	u16 *rss_ind_tbl;
 
 	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2)
 		rss_algo = HCLGE_RSS_HASH_ALGO_SIMPLE;
 
-	for (i = 0; i < hdev->num_vmdq_vport + 1; i++) {
-		u16 *rss_ind_tbl;
-
-		vport[i].rss_tuple_sets.ipv4_tcp_en =
-			HCLGE_RSS_INPUT_TUPLE_OTHER;
-		vport[i].rss_tuple_sets.ipv4_udp_en =
-			HCLGE_RSS_INPUT_TUPLE_OTHER;
-		vport[i].rss_tuple_sets.ipv4_sctp_en =
-			HCLGE_RSS_INPUT_TUPLE_SCTP;
-		vport[i].rss_tuple_sets.ipv4_fragment_en =
-			HCLGE_RSS_INPUT_TUPLE_OTHER;
-		vport[i].rss_tuple_sets.ipv6_tcp_en =
-			HCLGE_RSS_INPUT_TUPLE_OTHER;
-		vport[i].rss_tuple_sets.ipv6_udp_en =
-			HCLGE_RSS_INPUT_TUPLE_OTHER;
-		vport[i].rss_tuple_sets.ipv6_sctp_en =
-			hdev->ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2 ?
-			HCLGE_RSS_INPUT_TUPLE_SCTP_NO_PORT :
-			HCLGE_RSS_INPUT_TUPLE_SCTP;
-		vport[i].rss_tuple_sets.ipv6_fragment_en =
-			HCLGE_RSS_INPUT_TUPLE_OTHER;
-
-		vport[i].rss_algo = rss_algo;
-
-		rss_ind_tbl = devm_kcalloc(&hdev->pdev->dev, rss_ind_tbl_size,
-					   sizeof(*rss_ind_tbl), GFP_KERNEL);
-		if (!rss_ind_tbl)
-			return -ENOMEM;
+	vport->rss_tuple_sets.ipv4_tcp_en = HCLGE_RSS_INPUT_TUPLE_OTHER;
+	vport->rss_tuple_sets.ipv4_udp_en = HCLGE_RSS_INPUT_TUPLE_OTHER;
+	vport->rss_tuple_sets.ipv4_sctp_en = HCLGE_RSS_INPUT_TUPLE_SCTP;
+	vport->rss_tuple_sets.ipv4_fragment_en = HCLGE_RSS_INPUT_TUPLE_OTHER;
+	vport->rss_tuple_sets.ipv6_tcp_en = HCLGE_RSS_INPUT_TUPLE_OTHER;
+	vport->rss_tuple_sets.ipv6_udp_en = HCLGE_RSS_INPUT_TUPLE_OTHER;
+	vport->rss_tuple_sets.ipv6_sctp_en =
+		hdev->ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2 ?
+		HCLGE_RSS_INPUT_TUPLE_SCTP_NO_PORT :
+		HCLGE_RSS_INPUT_TUPLE_SCTP;
+	vport->rss_tuple_sets.ipv6_fragment_en = HCLGE_RSS_INPUT_TUPLE_OTHER;
+
+	vport->rss_algo = rss_algo;
+
+	rss_ind_tbl = devm_kcalloc(&hdev->pdev->dev, rss_ind_tbl_size,
+				   sizeof(*rss_ind_tbl), GFP_KERNEL);
+	if (!rss_ind_tbl)
+		return -ENOMEM;
 
-		vport[i].rss_indirection_tbl = rss_ind_tbl;
-		memcpy(vport[i].rss_hash_key, hclge_hash_key,
-		       HCLGE_RSS_KEY_SIZE);
-	}
+	vport->rss_indirection_tbl = rss_ind_tbl;
+	memcpy(vport->rss_hash_key, hclge_hash_key, HCLGE_RSS_KEY_SIZE);
 
 	hclge_rss_indir_init_cfg(hdev);
 
@@ -9130,7 +9092,7 @@ static bool hclge_check_vf_mac_exist(struct hclge_vport *vport, int vf_idx,
 		return true;
 
 	vf_idx += HCLGE_VF_VPORT_START_NUM;
-	for (i = hdev->num_vmdq_vport + 1; i < hdev->num_alloc_vport; i++)
+	for (i = HCLGE_VF_VPORT_START_NUM; i < hdev->num_alloc_vport; i++)
 		if (i != vf_idx &&
 		    ether_addr_equal(mac_addr, hdev->vport[i].vf_info.mac))
 			return true;
@@ -10771,7 +10733,6 @@ static void hclge_info_show(struct hclge_dev *hdev)
 	dev_info(dev, "Desc num per TX queue: %u\n", hdev->num_tx_desc);
 	dev_info(dev, "Desc num per RX queue: %u\n", hdev->num_rx_desc);
 	dev_info(dev, "Numbers of vports: %u\n", hdev->num_alloc_vport);
-	dev_info(dev, "Numbers of vmdp vports: %u\n", hdev->num_vmdq_vport);
 	dev_info(dev, "Numbers of VF for this PF: %u\n", hdev->num_req_vfs);
 	dev_info(dev, "HW tc map: 0x%x\n", hdev->hw_tc_map);
 	dev_info(dev, "Total buffer size for TX/RX: %u\n", hdev->pkt_buf_size);
@@ -10886,39 +10847,35 @@ static int hclge_init_client_instance(struct hnae3_client *client,
 				      struct hnae3_ae_dev *ae_dev)
 {
 	struct hclge_dev *hdev = ae_dev->priv;
-	struct hclge_vport *vport;
-	int i, ret;
-
-	for (i = 0; i <  hdev->num_vmdq_vport + 1; i++) {
-		vport = &hdev->vport[i];
+	struct hclge_vport *vport = &hdev->vport[0];
+	int ret;
 
-		switch (client->type) {
-		case HNAE3_CLIENT_KNIC:
-			hdev->nic_client = client;
-			vport->nic.client = client;
-			ret = hclge_init_nic_client_instance(ae_dev, vport);
-			if (ret)
-				goto clear_nic;
+	switch (client->type) {
+	case HNAE3_CLIENT_KNIC:
+		hdev->nic_client = client;
+		vport->nic.client = client;
+		ret = hclge_init_nic_client_instance(ae_dev, vport);
+		if (ret)
+			goto clear_nic;
 
-			ret = hclge_init_roce_client_instance(ae_dev, vport);
-			if (ret)
-				goto clear_roce;
+		ret = hclge_init_roce_client_instance(ae_dev, vport);
+		if (ret)
+			goto clear_roce;
 
-			break;
-		case HNAE3_CLIENT_ROCE:
-			if (hnae3_dev_roce_supported(hdev)) {
-				hdev->roce_client = client;
-				vport->roce.client = client;
-			}
+		break;
+	case HNAE3_CLIENT_ROCE:
+		if (hnae3_dev_roce_supported(hdev)) {
+			hdev->roce_client = client;
+			vport->roce.client = client;
+		}
 
-			ret = hclge_init_roce_client_instance(ae_dev, vport);
-			if (ret)
-				goto clear_roce;
+		ret = hclge_init_roce_client_instance(ae_dev, vport);
+		if (ret)
+			goto clear_roce;
 
-			break;
-		default:
-			return -EINVAL;
-		}
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	return 0;
@@ -10937,32 +10894,27 @@ static void hclge_uninit_client_instance(struct hnae3_client *client,
 					 struct hnae3_ae_dev *ae_dev)
 {
 	struct hclge_dev *hdev = ae_dev->priv;
-	struct hclge_vport *vport;
-	int i;
+	struct hclge_vport *vport = &hdev->vport[0];
 
-	for (i = 0; i < hdev->num_vmdq_vport + 1; i++) {
-		vport = &hdev->vport[i];
-		if (hdev->roce_client) {
-			clear_bit(HCLGE_STATE_ROCE_REGISTERED, &hdev->state);
-			while (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state))
-				msleep(HCLGE_WAIT_RESET_DONE);
-
-			hdev->roce_client->ops->uninit_instance(&vport->roce,
-								0);
-			hdev->roce_client = NULL;
-			vport->roce.client = NULL;
-		}
-		if (client->type == HNAE3_CLIENT_ROCE)
-			return;
-		if (hdev->nic_client && client->ops->uninit_instance) {
-			clear_bit(HCLGE_STATE_NIC_REGISTERED, &hdev->state);
-			while (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state))
-				msleep(HCLGE_WAIT_RESET_DONE);
-
-			client->ops->uninit_instance(&vport->nic, 0);
-			hdev->nic_client = NULL;
-			vport->nic.client = NULL;
-		}
+	if (hdev->roce_client) {
+		clear_bit(HCLGE_STATE_ROCE_REGISTERED, &hdev->state);
+		while (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state))
+			msleep(HCLGE_WAIT_RESET_DONE);
+
+		hdev->roce_client->ops->uninit_instance(&vport->roce, 0);
+		hdev->roce_client = NULL;
+		vport->roce.client = NULL;
+	}
+	if (client->type == HNAE3_CLIENT_ROCE)
+		return;
+	if (hdev->nic_client && client->ops->uninit_instance) {
+		clear_bit(HCLGE_STATE_NIC_REGISTERED, &hdev->state);
+		while (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state))
+			msleep(HCLGE_WAIT_RESET_DONE);
+
+		client->ops->uninit_instance(&vport->nic, 0);
+		hdev->nic_client = NULL;
+		vport->nic.client = NULL;
 	}
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 97e77e2..dc3d29d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -348,7 +348,6 @@ struct hclge_tc_info {
 };
 
 struct hclge_cfg {
-	u8 vmdq_vport_num;
 	u8 tc_num;
 	u16 tqp_desc_num;
 	u16 rx_buf_len;
@@ -811,7 +810,6 @@ struct hclge_dev {
 	struct hclge_rst_stats rst_stats;
 	struct semaphore reset_sem;	/* protect reset process */
 	u32 fw_version;
-	u16 num_vmdq_vport;		/* Num vmdq vport this PF has set up */
 	u16 num_tqps;			/* Num task queue pairs of this PF */
 	u16 num_req_vfs;		/* Num VFs requested for this PF */
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 8c27ecd..ade6e7f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -192,7 +192,6 @@ struct hclgevf_tqp {
 };
 
 struct hclgevf_cfg {
-	u8 vmdq_vport_num;
 	u8 tc_num;
 	u16 tqp_desc_num;
 	u16 rx_buf_len;
-- 
2.7.4

