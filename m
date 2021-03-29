Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6490934C25F
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 06:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbhC2D7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 23:59:14 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14509 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbhC2D60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 23:58:26 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F7zK16TVXzrc0b;
        Mon, 29 Mar 2021 11:56:21 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Mon, 29 Mar 2021 11:58:14 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 5/9] net: hns3: optimize the process of queue reset
Date:   Mon, 29 Mar 2021 11:57:49 +0800
Message-ID: <1616990273-46426-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1616990273-46426-1-git-send-email-tanhuazhong@huawei.com>
References: <1616990273-46426-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Currently, the queue reset process needs to be performed one by
one, which is inefficient. However, the queue reset of the same
function is always performed at the same time. Therefore, according
to the UM, command HCLGE_OPC_CFG_RST_TRIGGER can be used to reset
all queues of the same function at a time, in order to optimize
the queue reset process.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   8 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   8 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 185 ++++++++++++---------
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   3 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  26 ++-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  59 +++++--
 7 files changed, 182 insertions(+), 109 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 01d6bfc..a234116 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -579,7 +579,7 @@ struct hnae3_ae_ops {
 				      int vector_num,
 				      struct hnae3_ring_chain_node *vr_chain);
 
-	int (*reset_queue)(struct hnae3_handle *handle, u16 queue_id);
+	int (*reset_queue)(struct hnae3_handle *handle);
 	u32 (*get_fw_version)(struct hnae3_handle *handle);
 	void (*get_mdix_mode)(struct hnae3_handle *handle,
 			      u8 *tp_mdix_ctrl, u8 *tp_mdix);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index c73de36..3848009 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4455,11 +4455,11 @@ int hns3_nic_reset_all_ring(struct hnae3_handle *h)
 	int i, j;
 	int ret;
 
-	for (i = 0; i < h->kinfo.num_tqps; i++) {
-		ret = h->ae_algo->ops->reset_queue(h, i);
-		if (ret)
-			return ret;
+	ret = h->ae_algo->ops->reset_queue(h);
+	if (ret)
+		return ret;
 
+	for (i = 0; i < h->kinfo.num_tqps; i++) {
 		hns3_init_ring_hw(&priv->ring[i]);
 
 		/* We need to clear tx ring here because self test will
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 7feab84..c6fc22e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -948,10 +948,16 @@ struct hclge_reset_tqp_queue_cmd {
 
 #define HCLGE_CFG_RESET_MAC_B		3
 #define HCLGE_CFG_RESET_FUNC_B		7
+#define HCLGE_CFG_RESET_RCB_B		1
 struct hclge_reset_cmd {
 	u8 mac_func_reset;
 	u8 fun_reset_vfid;
-	u8 rsv[22];
+	u8 fun_reset_rcb;
+	u8 rsv;
+	__le16 fun_reset_rcb_vqid_start;
+	__le16 fun_reset_rcb_vqid_num;
+	u8 fun_reset_rcb_return_status;
+	u8 rsv1[15];
 };
 
 #define HCLGE_PF_RESET_DONE_BIT		BIT(0)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 5ec4be7..8edae94 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7797,13 +7797,12 @@ static int hclge_set_phy_loopback(struct hclge_dev *hdev, bool en)
 	return ret;
 }
 
-static int hclge_tqp_enable(struct hclge_dev *hdev, unsigned int tqp_id,
-			    int stream_id, bool enable)
+static int hclge_tqp_enable_cmd_send(struct hclge_dev *hdev, u16 tqp_id,
+				     u16 stream_id, bool enable)
 {
 	struct hclge_desc desc;
 	struct hclge_cfg_com_tqp_queue_cmd *req =
 		(struct hclge_cfg_com_tqp_queue_cmd *)desc.data;
-	int ret;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_CFG_COM_TQP_QUEUE, false);
 	req->tqp_id = cpu_to_le16(tqp_id);
@@ -7811,20 +7810,30 @@ static int hclge_tqp_enable(struct hclge_dev *hdev, unsigned int tqp_id,
 	if (enable)
 		req->enable |= 1U << HCLGE_TQP_ENABLE_B;
 
-	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
-		dev_err(&hdev->pdev->dev,
-			"Tqp enable fail, status =%d.\n", ret);
-	return ret;
+	return hclge_cmd_send(&hdev->hw, &desc, 1);
+}
+
+static int hclge_tqp_enable(struct hnae3_handle *handle, bool enable)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+	int ret;
+	u16 i;
+
+	for (i = 0; i < handle->kinfo.num_tqps; i++) {
+		ret = hclge_tqp_enable_cmd_send(hdev, i, 0, enable);
+		if (ret)
+			return ret;
+	}
+	return 0;
 }
 
 static int hclge_set_loopback(struct hnae3_handle *handle,
 			      enum hnae3_loop loop_mode, bool en)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
-	struct hnae3_knic_private_info *kinfo;
 	struct hclge_dev *hdev = vport->back;
-	int i, ret;
+	int ret;
 
 	/* Loopback can be enabled in three places: SSU, MAC, and serdes. By
 	 * default, SSU loopback is enabled, so if the SMAC and the DMAC are
@@ -7861,14 +7870,12 @@ static int hclge_set_loopback(struct hnae3_handle *handle,
 	if (ret)
 		return ret;
 
-	kinfo = &vport->nic.kinfo;
-	for (i = 0; i < kinfo->num_tqps; i++) {
-		ret = hclge_tqp_enable(hdev, i, 0, en);
-		if (ret)
-			return ret;
-	}
+	ret = hclge_tqp_enable(handle, en);
+	if (ret)
+		dev_err(&hdev->pdev->dev, "failed to %s tqp in loopback, ret = %d\n",
+			en ? "enable" : "disable", ret);
 
-	return 0;
+	return ret;
 }
 
 static int hclge_set_default_loopback(struct hclge_dev *hdev)
@@ -7955,7 +7962,6 @@ static void hclge_ae_stop(struct hnae3_handle *handle)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
-	int i;
 
 	set_bit(HCLGE_STATE_DOWN, &hdev->state);
 	spin_lock_bh(&hdev->fd_rule_lock);
@@ -7972,8 +7978,7 @@ static void hclge_ae_stop(struct hnae3_handle *handle)
 		return;
 	}
 
-	for (i = 0; i < handle->kinfo.num_tqps; i++)
-		hclge_reset_tqp(handle, i);
+	hclge_reset_tqp(handle);
 
 	hclge_config_mac_tnl_int(hdev, false);
 
@@ -10347,7 +10352,7 @@ int hclge_set_vport_mtu(struct hclge_vport *vport, int new_mtu)
 	return ret;
 }
 
-static int hclge_send_reset_tqp_cmd(struct hclge_dev *hdev, u16 queue_id,
+static int hclge_reset_tqp_cmd_send(struct hclge_dev *hdev, u16 queue_id,
 				    bool enable)
 {
 	struct hclge_reset_tqp_queue_cmd *req;
@@ -10403,94 +10408,114 @@ u16 hclge_covert_handle_qid_global(struct hnae3_handle *handle, u16 queue_id)
 	return tqp->index;
 }
 
-int hclge_reset_tqp(struct hnae3_handle *handle, u16 queue_id)
+static int hclge_reset_tqp_cmd(struct hnae3_handle *handle)
 {
 	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
-	int reset_try_times = 0;
+	u16 reset_try_times = 0;
 	int reset_status;
 	u16 queue_gid;
 	int ret;
+	u16 i;
 
-	queue_gid = hclge_covert_handle_qid_global(handle, queue_id);
-
-	ret = hclge_tqp_enable(hdev, queue_id, 0, false);
-	if (ret) {
-		dev_err(&hdev->pdev->dev, "Disable tqp fail, ret = %d\n", ret);
-		return ret;
-	}
+	for (i = 0; i < handle->kinfo.num_tqps; i++) {
+		queue_gid = hclge_covert_handle_qid_global(handle, i);
+		ret = hclge_reset_tqp_cmd_send(hdev, queue_gid, true);
+		if (ret) {
+			dev_err(&hdev->pdev->dev,
+				"failed to send reset tqp cmd, ret = %d\n",
+				ret);
+			return ret;
+		}
 
-	ret = hclge_send_reset_tqp_cmd(hdev, queue_gid, true);
-	if (ret) {
-		dev_err(&hdev->pdev->dev,
-			"Send reset tqp cmd fail, ret = %d\n", ret);
-		return ret;
-	}
+		while (reset_try_times++ < HCLGE_TQP_RESET_TRY_TIMES) {
+			reset_status = hclge_get_reset_status(hdev, queue_gid);
+			if (reset_status)
+				break;
 
-	while (reset_try_times++ < HCLGE_TQP_RESET_TRY_TIMES) {
-		reset_status = hclge_get_reset_status(hdev, queue_gid);
-		if (reset_status)
-			break;
+			/* Wait for tqp hw reset */
+			usleep_range(1000, 1200);
+		}
 
-		/* Wait for tqp hw reset */
-		usleep_range(1000, 1200);
-	}
+		if (reset_try_times >= HCLGE_TQP_RESET_TRY_TIMES) {
+			dev_err(&hdev->pdev->dev,
+				"wait for tqp hw reset timeout\n");
+			return -ETIME;
+		}
 
-	if (reset_try_times >= HCLGE_TQP_RESET_TRY_TIMES) {
-		dev_err(&hdev->pdev->dev, "Reset TQP fail\n");
-		return ret;
+		ret = hclge_reset_tqp_cmd_send(hdev, queue_gid, false);
+		if (ret) {
+			dev_err(&hdev->pdev->dev,
+				"failed to deassert soft reset, ret = %d\n",
+				ret);
+			return ret;
+		}
+		reset_try_times = 0;
 	}
-
-	ret = hclge_send_reset_tqp_cmd(hdev, queue_gid, false);
-	if (ret)
-		dev_err(&hdev->pdev->dev,
-			"Deassert the soft reset fail, ret = %d\n", ret);
-
-	return ret;
+	return 0;
 }
 
-void hclge_reset_vf_queue(struct hclge_vport *vport, u16 queue_id)
+static int hclge_reset_rcb(struct hnae3_handle *handle)
 {
-	struct hnae3_handle *handle = &vport->nic;
+#define HCLGE_RESET_RCB_NOT_SUPPORT	0U
+#define HCLGE_RESET_RCB_SUCCESS		1U
+
+	struct hclge_vport *vport = hclge_get_vport(handle);
 	struct hclge_dev *hdev = vport->back;
-	int reset_try_times = 0;
-	int reset_status;
+	struct hclge_reset_cmd *req;
+	struct hclge_desc desc;
+	u8 return_status;
 	u16 queue_gid;
 	int ret;
 
-	if (queue_id >= handle->kinfo.num_tqps) {
-		dev_warn(&hdev->pdev->dev, "Invalid vf queue id(%u)\n",
-			 queue_id);
-		return;
-	}
+	queue_gid = hclge_covert_handle_qid_global(handle, 0);
 
-	queue_gid = hclge_covert_handle_qid_global(&vport->nic, queue_id);
+	req = (struct hclge_reset_cmd *)desc.data;
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_CFG_RST_TRIGGER, false);
+	hnae3_set_bit(req->fun_reset_rcb, HCLGE_CFG_RESET_RCB_B, 1);
+	req->fun_reset_rcb_vqid_start = cpu_to_le16(queue_gid);
+	req->fun_reset_rcb_vqid_num = cpu_to_le16(handle->kinfo.num_tqps);
 
-	ret = hclge_send_reset_tqp_cmd(hdev, queue_gid, true);
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret) {
-		dev_warn(&hdev->pdev->dev,
-			 "Send reset tqp cmd fail, ret = %d\n", ret);
-		return;
+		dev_err(&hdev->pdev->dev,
+			"failed to send rcb reset cmd, ret = %d\n", ret);
+		return ret;
 	}
 
-	while (reset_try_times++ < HCLGE_TQP_RESET_TRY_TIMES) {
-		reset_status = hclge_get_reset_status(hdev, queue_gid);
-		if (reset_status)
-			break;
+	return_status = req->fun_reset_rcb_return_status;
+	if (return_status == HCLGE_RESET_RCB_SUCCESS)
+		return 0;
 
-		/* Wait for tqp hw reset */
-		usleep_range(1000, 1200);
+	if (return_status != HCLGE_RESET_RCB_NOT_SUPPORT) {
+		dev_err(&hdev->pdev->dev, "failed to reset rcb, ret = %u\n",
+			return_status);
+		return -EIO;
 	}
 
-	if (reset_try_times >= HCLGE_TQP_RESET_TRY_TIMES) {
-		dev_warn(&hdev->pdev->dev, "Reset TQP fail\n");
-		return;
+	/* if reset rcb cmd is unsupported, we need to send reset tqp cmd
+	 * again to reset all tqps
+	 */
+	return hclge_reset_tqp_cmd(handle);
+}
+
+int hclge_reset_tqp(struct hnae3_handle *handle)
+{
+	struct hclge_vport *vport = hclge_get_vport(handle);
+	struct hclge_dev *hdev = vport->back;
+	int ret;
+
+	/* only need to disable PF's tqp */
+	if (!vport->vport_id) {
+		ret = hclge_tqp_enable(handle, false);
+		if (ret) {
+			dev_err(&hdev->pdev->dev,
+				"failed to disable tqp, ret = %d\n", ret);
+			return ret;
+		}
 	}
 
-	ret = hclge_send_reset_tqp_cmd(hdev, queue_gid, false);
-	if (ret)
-		dev_warn(&hdev->pdev->dev,
-			 "Deassert the soft reset fail, ret = %d\n", ret);
+	return hclge_reset_rcb(handle);
 }
 
 static u32 hclge_get_fw_version(struct hnae3_handle *handle)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index dc3d29d..c1aaf7c5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -1053,8 +1053,7 @@ int hclge_rss_init_hw(struct hclge_dev *hdev);
 void hclge_rss_indir_init_cfg(struct hclge_dev *hdev);
 
 void hclge_mbx_handler(struct hclge_dev *hdev);
-int hclge_reset_tqp(struct hnae3_handle *handle, u16 queue_id);
-void hclge_reset_vf_queue(struct hclge_vport *vport, u16 queue_id);
+int hclge_reset_tqp(struct hnae3_handle *handle);
 int hclge_cfg_flowctrl(struct hclge_dev *hdev);
 int hclge_func_reset_cmd(struct hclge_dev *hdev, int func_id);
 int hclge_vport_start(struct hclge_vport *vport);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 51a36e7..c88607b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -550,14 +550,32 @@ static void hclge_get_link_mode(struct hclge_vport *vport,
 			   HCLGE_MBX_LINK_STAT_MODE, dest_vfid);
 }
 
-static void hclge_mbx_reset_vf_queue(struct hclge_vport *vport,
-				     struct hclge_mbx_vf_to_pf_cmd *mbx_req)
+static int hclge_mbx_reset_vf_queue(struct hclge_vport *vport,
+				    struct hclge_mbx_vf_to_pf_cmd *mbx_req,
+				    struct hclge_respond_to_vf_msg *resp_msg)
 {
+#define HCLGE_RESET_ALL_QUEUE_DONE	1U
+	struct hnae3_handle *handle = &vport->nic;
+	struct hclge_dev *hdev = vport->back;
 	u16 queue_id;
+	int ret;
 
 	memcpy(&queue_id, mbx_req->msg.data, sizeof(queue_id));
+	resp_msg->data[0] = HCLGE_RESET_ALL_QUEUE_DONE;
+	resp_msg->len = sizeof(u8);
 
-	hclge_reset_vf_queue(vport, queue_id);
+	/* pf will reset vf's all queues at a time. So it is unnecessary
+	 * to reset queues if queue_id > 0, just return success.
+	 */
+	if (queue_id > 0)
+		return 0;
+
+	ret = hclge_reset_tqp(handle);
+	if (ret)
+		dev_err(&hdev->pdev->dev, "failed to reset vf %u queue, ret = %d\n",
+			vport->vport_id - HCLGE_VF_VPORT_START_NUM, ret);
+
+	return ret;
 }
 
 static int hclge_reset_vf(struct hclge_vport *vport)
@@ -783,7 +801,7 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 					ret);
 			break;
 		case HCLGE_MBX_QUEUE_RESET:
-			hclge_mbx_reset_vf_queue(vport, req);
+			ret = hclge_mbx_reset_vf_queue(vport, req, &resp_msg);
 			break;
 		case HCLGE_MBX_RESET:
 			ret = hclge_reset_vf(vport);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 5e512cd..ac3afac 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1240,12 +1240,11 @@ static void hclgevf_sync_promisc_mode(struct hclgevf_dev *hdev)
 	}
 }
 
-static int hclgevf_tqp_enable(struct hclgevf_dev *hdev, unsigned int tqp_id,
-			      int stream_id, bool enable)
+static int hclgevf_tqp_enable_cmd_send(struct hclgevf_dev *hdev, u16 tqp_id,
+				       u16 stream_id, bool enable)
 {
 	struct hclgevf_cfg_com_tqp_queue_cmd *req;
 	struct hclgevf_desc desc;
-	int status;
 
 	req = (struct hclgevf_cfg_com_tqp_queue_cmd *)desc.data;
 
@@ -1256,12 +1255,22 @@ static int hclgevf_tqp_enable(struct hclgevf_dev *hdev, unsigned int tqp_id,
 	if (enable)
 		req->enable |= 1U << HCLGEVF_TQP_ENABLE_B;
 
-	status = hclgevf_cmd_send(&hdev->hw, &desc, 1);
-	if (status)
-		dev_err(&hdev->pdev->dev,
-			"TQP enable fail, status =%d.\n", status);
+	return hclgevf_cmd_send(&hdev->hw, &desc, 1);
+}
 
-	return status;
+static int hclgevf_tqp_enable(struct hnae3_handle *handle, bool enable)
+{
+	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
+	int ret;
+	u16 i;
+
+	for (i = 0; i < handle->kinfo.num_tqps; i++) {
+		ret = hclgevf_tqp_enable_cmd_send(hdev, i, 0, enable);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 static void hclgevf_reset_tqp_stats(struct hnae3_handle *handle)
@@ -1710,20 +1719,39 @@ static int hclgevf_en_hw_strip_rxvtag(struct hnae3_handle *handle, bool enable)
 	return hclgevf_send_mbx_msg(hdev, &send_msg, false, NULL, 0);
 }
 
-static int hclgevf_reset_tqp(struct hnae3_handle *handle, u16 queue_id)
+static int hclgevf_reset_tqp(struct hnae3_handle *handle)
 {
+#define HCLGEVF_RESET_ALL_QUEUE_DONE	1U
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 	struct hclge_vf_to_pf_msg send_msg;
+	u8 return_status = 0;
 	int ret;
+	u16 i;
 
 	/* disable vf queue before send queue reset msg to PF */
-	ret = hclgevf_tqp_enable(hdev, queue_id, 0, false);
-	if (ret)
+	ret = hclgevf_tqp_enable(handle, false);
+	if (ret) {
+		dev_err(&hdev->pdev->dev, "failed to disable tqp, ret = %d\n",
+			ret);
 		return ret;
+	}
 
 	hclgevf_build_send_msg(&send_msg, HCLGE_MBX_QUEUE_RESET, 0);
-	memcpy(send_msg.data, &queue_id, sizeof(queue_id));
-	return hclgevf_send_mbx_msg(hdev, &send_msg, true, NULL, 0);
+
+	ret = hclgevf_send_mbx_msg(hdev, &send_msg, true, &return_status,
+				   sizeof(return_status));
+	if (ret || return_status == HCLGEVF_RESET_ALL_QUEUE_DONE)
+		return ret;
+
+	for (i = 1; i < handle->kinfo.num_tqps; i++) {
+		hclgevf_build_send_msg(&send_msg, HCLGE_MBX_QUEUE_RESET, 0);
+		memcpy(send_msg.data, &i, sizeof(i));
+		ret = hclgevf_send_mbx_msg(hdev, &send_msg, true, NULL, 0);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 static int hclgevf_set_mtu(struct hnae3_handle *handle, int new_mtu)
@@ -2636,14 +2664,11 @@ static int hclgevf_ae_start(struct hnae3_handle *handle)
 static void hclgevf_ae_stop(struct hnae3_handle *handle)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
-	int i;
 
 	set_bit(HCLGEVF_STATE_DOWN, &hdev->state);
 
 	if (hdev->reset_type != HNAE3_VF_RESET)
-		for (i = 0; i < handle->kinfo.num_tqps; i++)
-			if (hclgevf_reset_tqp(handle, i))
-				break;
+		hclgevf_reset_tqp(handle);
 
 	hclgevf_reset_tqp_stats(handle);
 	hclgevf_update_link_status(hdev, 0);
-- 
2.7.4

