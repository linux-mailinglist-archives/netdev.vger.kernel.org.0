Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB9B32A356
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382110AbhCBIz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:55:58 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:13409 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835942AbhCBG3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 01:29:05 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DqRwL0y9jzjTLY;
        Tue,  2 Mar 2021 14:26:10 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 2 Mar 2021 14:27:24 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [RFC net-next 9/9] net: hns3: add queue bonding mode support for VF
Date:   Tue, 2 Mar 2021 14:27:55 +0800
Message-ID: <1614666475-13059-10-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1614666475-13059-1-git-send-email-tanhuazhong@huawei.com>
References: <1614666475-13059-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

For device version V3, the hardware supports queue bonding
mode. VF can not enable queue bond mode unless PF enables it.
So VF needs to query whether PF support queue bonding mode
when initializing, and query whether PF enables queue bonding
mode periodically. For the resource limited, to avoid a VF
occupy to many FD rule space, only trust VF is allowed to enable
queue bonding mode.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |  8 +++
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 46 +++++++++++++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  2 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |  2 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 74 ++++++++++++++++++++++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |  7 ++
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   | 16 +++++
 7 files changed, 154 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
index 33defa4..797adc9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -46,6 +46,8 @@ enum HCLGE_MBX_OPCODE {
 	HCLGE_MBX_PUSH_PROMISC_INFO,	/* (PF -> VF) push vf promisc info */
 	HCLGE_MBX_VF_UNINIT,            /* (VF -> PF) vf is unintializing */
 	HCLGE_MBX_HANDLE_VF_TBL,	/* (VF -> PF) store/clear hw table */
+	HCLGE_MBX_SET_QB = 0x28,	/* (VF -> PF) set queue bonding */
+	HCLGE_MBX_PUSH_QB_STATE,	/* (PF -> VF) push qb state */
 
 	HCLGE_MBX_GET_VF_FLR_STATUS = 200, /* (M7 -> PF) get vf flr status */
 	HCLGE_MBX_PUSH_LINK_STATUS,	/* (M7 -> PF) get port link status */
@@ -75,6 +77,12 @@ enum hclge_mbx_tbl_cfg_subcode {
 	HCLGE_MBX_VPORT_LIST_CLEAR,
 };
 
+enum hclge_mbx_qb_cfg_subcode {
+	HCLGE_MBX_QB_CHECK_CAPS = 0,	/* query whether support qb */
+	HCLGE_MBX_QB_ENABLE,		/* request pf enable qb */
+	HCLGE_MBX_QB_GET_STATE		/* query whether qb enabled */
+};
+
 #define HCLGE_MBX_MAX_MSG_SIZE	14
 #define HCLGE_MBX_MAX_RESP_DATA_SIZE	8U
 #define HCLGE_MBX_MAX_RING_CHAIN_PARAM_NUM	4
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index ee5881d..8852f2f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4170,10 +4170,33 @@ static int hclge_sync_pf_qb_mode(struct hclge_dev *hdev)
 	return ret;
 }
 
+static int hclge_sync_vf_qb_mode(struct hclge_vport *vport)
+{
+	struct hclge_dev *hdev = vport->back;
+	bool request_enable = false;
+	int ret;
+
+	if (!test_and_clear_bit(HCLGE_VPORT_STATE_QB_CHANGE, &vport->state))
+		return 0;
+
+	if (vport->vf_info.trusted && vport->vf_info.request_qb_en &&
+	    test_bit(HCLGE_STATE_HW_QB_ENABLE, &hdev->state))
+		request_enable = true;
+
+	ret = hclge_set_fd_qb(hdev, vport->vport_id, request_enable);
+	if (ret)
+		set_bit(HCLGE_VPORT_STATE_QB_CHANGE, &vport->state);
+	vport->vf_info.qb_en = request_enable ? 1 : 0;
+
+	return ret;
+}
+
 static int hclge_disable_fd_qb_mode(struct hclge_dev *hdev)
 {
 	struct hnae3_ae_dev *ae_dev = hdev->ae_dev;
+	struct hclge_vport *vport;
 	int ret;
+	u16 i;
 
 	if (!test_bit(HNAE3_DEV_SUPPORT_QB_B, ae_dev->caps) ||
 	    !test_bit(HCLGE_STATE_HW_QB_ENABLE, &hdev->state))
@@ -4185,17 +4208,35 @@ static int hclge_disable_fd_qb_mode(struct hclge_dev *hdev)
 
 	clear_bit(HCLGE_STATE_HW_QB_ENABLE, &hdev->state);
 
+	for (i = 1; i < hdev->num_alloc_vport; i++) {
+		vport = &hdev->vport[i];
+		set_bit(HCLGE_VPORT_STATE_QB_CHANGE, &vport->state);
+	}
+
 	return 0;
 }
 
 static void hclge_sync_fd_qb_mode(struct hclge_dev *hdev)
 {
 	struct hnae3_ae_dev *ae_dev = hdev->ae_dev;
+	struct hclge_vport *vport;
+	int ret;
+	u16 i;
 
 	if (!test_bit(HNAE3_DEV_SUPPORT_QB_B, ae_dev->caps))
 		return;
 
-	hclge_sync_pf_qb_mode(hdev);
+	ret = hclge_sync_pf_qb_mode(hdev);
+	if (ret)
+		return;
+
+	for (i = 1; i < hdev->num_alloc_vport; i++) {
+		vport = &hdev->vport[i];
+
+		ret = hclge_sync_vf_qb_mode(vport);
+		if (ret)
+			return;
+	}
 }
 
 static void hclge_periodic_service_task(struct hclge_dev *hdev)
@@ -11485,6 +11526,9 @@ static int hclge_set_vf_trust(struct hnae3_handle *handle, int vf, bool enable)
 
 	vport->vf_info.trusted = new_trusted;
 
+	set_bit(HCLGE_VPORT_STATE_QB_CHANGE, &vport->state);
+	hclge_task_schedule(hdev, 0);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 9b3907a..9dfefcf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -975,6 +975,8 @@ struct hclge_vf_info {
 	u32 max_tx_rate;
 	u32 trusted;
 	u16 promisc_enable;
+	u8 request_qb_en;
+	u8 qb_en;
 };
 
 struct hclge_vport {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index 46700c4..dbfd31a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -360,6 +360,8 @@ static void hclgevf_parse_capability(struct hclgevf_dev *hdev,
 		set_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps);
 	if (hnae3_get_bit(caps, HCLGEVF_CAP_UDP_TUNNEL_CSUM_B))
 		set_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps);
+	if (hnae3_get_bit(caps, HCLGEVF_CAP_QB_B))
+		set_bit(HNAE3_DEV_SUPPORT_QB_B, ae_dev->caps);
 }
 
 static __le32 hclgevf_build_api_caps(void)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 700e068..25a874b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -470,6 +470,74 @@ static int hclgevf_knic_setup(struct hclgevf_dev *hdev)
 	return 0;
 }
 
+static void hclgevf_update_fd_qb_state(struct hclgevf_dev *hdev)
+{
+	struct hnae3_handle *handle = &hdev->nic;
+	struct hclge_vf_to_pf_msg send_msg;
+	int ret;
+
+	if (!hdev->qb_cfg.pf_support_qb ||
+	    !test_bit(HNAE3_PFLAG_FD_QB_ENABLE, &handle->priv_flags))
+		return;
+
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_QB,
+			       HCLGE_MBX_QB_GET_STATE);
+	ret = hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
+	if (ret)
+		dev_err(&hdev->pdev->dev, "failed to get qb state, ret = %d",
+			ret);
+}
+
+static void hclgevf_get_pf_qb_caps(struct hclgevf_dev *hdev)
+{
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
+	struct hclge_vf_to_pf_msg send_msg;
+	u8 resp_msg;
+	int ret;
+
+	if (!test_bit(HNAE3_DEV_SUPPORT_QB_B, ae_dev->caps))
+		return;
+
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_QB,
+			       HCLGE_MBX_QB_CHECK_CAPS);
+	ret = hclgevf_send_mbx_msg(hdev, &send_msg, true, &resp_msg,
+				   sizeof(resp_msg));
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to get qb caps from PF, ret = %d", ret);
+		return;
+	}
+
+	hdev->qb_cfg.pf_support_qb = resp_msg > 0;
+}
+
+static void hclgevf_set_fd_qb(struct hnae3_handle *handle)
+{
+#define HCLGEVF_QB_MBX_STATE_OFFSET	0
+
+	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
+	struct hclge_vf_to_pf_msg send_msg;
+	u8 resp_msg;
+	int ret;
+
+	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_SET_QB,
+			       HCLGE_MBX_QB_ENABLE);
+	send_msg.data[HCLGEVF_QB_MBX_STATE_OFFSET] =
+		test_bit(HNAE3_PFLAG_FD_QB_ENABLE, &handle->priv_flags) ? 1 : 0;
+	ret = hclgevf_send_mbx_msg(hdev, &send_msg, true, &resp_msg,
+				   sizeof(resp_msg));
+	if (ret)
+		dev_err(&hdev->pdev->dev, "failed to set qb state, ret = %d",
+			ret);
+}
+
+bool hclgevf_query_fd_qb_state(struct hnae3_handle *handle)
+{
+	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
+
+	return hdev->qb_cfg.hw_qb_en;
+}
+
 static void hclgevf_request_link_info(struct hclgevf_dev *hdev)
 {
 	struct hclge_vf_to_pf_msg send_msg;
@@ -2320,6 +2388,8 @@ static void hclgevf_periodic_service_task(struct hclgevf_dev *hdev)
 
 	hclgevf_sync_promisc_mode(hdev);
 
+	hclgevf_update_fd_qb_state(hdev);
+
 	hdev->last_serv_processed = jiffies;
 
 out:
@@ -3348,6 +3418,8 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 		goto err_config;
 	}
 
+	hclgevf_get_pf_qb_caps(hdev);
+
 	hdev->last_reset_time = jiffies;
 	dev_info(&hdev->pdev->dev, "finished initializing %s driver\n",
 		 HCLGEVF_DRIVER_NAME);
@@ -3775,6 +3847,8 @@ static const struct hnae3_ae_ops hclgevf_ops = {
 	.set_promisc_mode = hclgevf_set_promisc_mode,
 	.request_update_promisc_mode = hclgevf_request_update_promisc_mode,
 	.get_cmdq_stat = hclgevf_get_cmdq_stat,
+	.request_flush_qb_config = hclgevf_set_fd_qb,
+	.query_fd_qb_state = hclgevf_query_fd_qb_state,
 };
 
 static struct hnae3_ae_algo ae_algovf = {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 8c27ecd..0e0c2fa 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -262,6 +262,11 @@ struct hclgevf_mac_table_cfg {
 	struct list_head mc_mac_list;
 };
 
+struct hclgevf_qb_cfg {
+	bool pf_support_qb;
+	bool hw_qb_en;
+};
+
 struct hclgevf_dev {
 	struct pci_dev *pdev;
 	struct hnae3_ae_dev *ae_dev;
@@ -328,6 +333,8 @@ struct hclgevf_dev {
 	u32 flag;
 	unsigned long serv_processed_cnt;
 	unsigned long last_serv_processed;
+
+	struct hclgevf_qb_cfg qb_cfg;
 };
 
 static inline bool hclgevf_is_reset_pending(struct hclgevf_dev *hdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
index 5b2dcd9..5f8ddde 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -268,6 +268,19 @@ static void hclgevf_parse_promisc_info(struct hclgevf_dev *hdev,
 			 "Promisc mode is closed by host for being untrusted.\n");
 }
 
+static void hclgevf_parse_qb_info(struct hclgevf_dev *hdev, u16 qb_state)
+{
+#define HCLGEVF_HW_QB_ON	1
+#define HCLGEVF_HW_QB_OFF	0
+
+	if (qb_state > HCLGEVF_HW_QB_ON) {
+		dev_warn(&hdev->pdev->dev, "Invalid state, ignored.\n");
+		return;
+	}
+
+	hdev->qb_cfg.hw_qb_en = qb_state > HCLGEVF_HW_QB_OFF;
+}
+
 void hclgevf_mbx_async_handler(struct hclgevf_dev *hdev)
 {
 	enum hnae3_reset_type reset_type;
@@ -336,6 +349,9 @@ void hclgevf_mbx_async_handler(struct hclgevf_dev *hdev)
 		case HCLGE_MBX_PUSH_PROMISC_INFO:
 			hclgevf_parse_promisc_info(hdev, msg_q[1]);
 			break;
+		case HCLGE_MBX_PUSH_QB_STATE:
+			hclgevf_parse_qb_info(hdev, msg_q[1]);
+			break;
 		default:
 			dev_err(&hdev->pdev->dev,
 				"fetched unsupported(%u) message from arq\n",
-- 
2.7.4

