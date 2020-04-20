Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C381AFFD5
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 04:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgDTCSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 22:18:49 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2798 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726337AbgDTCSs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 22:18:48 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 42707F03D6D1ADFF1E80;
        Mon, 20 Apr 2020 10:18:45 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Mon, 20 Apr 2020 10:18:36 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 09/10] net: hns3: add support for dumping MAC reg in debugfs
Date:   Mon, 20 Apr 2020 10:17:34 +0800
Message-ID: <1587349055-4403-10-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587349055-4403-1-git-send-email-tanhuazhong@huawei.com>
References: <1587349055-4403-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

This patch adds support for dumping MAC reg in debugfs,
which will be helpful for debugging.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 113 +++++++++++++++++++++
 2 files changed, 114 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index e1d8809..c934f32 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -270,7 +270,7 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 		" [igu egu <port_id>] [rpu <tc_queue_num>]",
 		HNS3_DBG_BUF_LEN - strlen(printf_buf) - 1);
 	strncat(printf_buf + strlen(printf_buf),
-		" [rtc] [ppp] [rcb] [tqp <queue_num>]]\n",
+		" [rtc] [ppp] [rcb] [tqp <queue_num>] [mac]]\n",
 		HNS3_DBG_BUF_LEN - strlen(printf_buf) - 1);
 	dev_info(&h->pdev->dev, "%s", printf_buf);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index cfc9300..66c1ad3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -173,6 +173,114 @@ static void hclge_dbg_dump_reg_common(struct hclge_dev *hdev,
 	kfree(desc_src);
 }
 
+static void hclge_dbg_dump_mac_enable_status(struct hclge_dev *hdev)
+{
+	struct hclge_config_mac_mode_cmd *req;
+	struct hclge_desc desc;
+	u32 loop_en;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_CONFIG_MAC_MODE, true);
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to dump mac enable status, ret = %d\n", ret);
+		return;
+	}
+
+	req = (struct hclge_config_mac_mode_cmd *)desc.data;
+	loop_en = le32_to_cpu(req->txrx_pad_fcs_loop_en);
+
+	dev_info(&hdev->pdev->dev, "config_mac_trans_en: %#x\n",
+		 hnae3_get_bit(loop_en, HCLGE_MAC_TX_EN_B));
+	dev_info(&hdev->pdev->dev, "config_mac_rcv_en: %#x\n",
+		 hnae3_get_bit(loop_en, HCLGE_MAC_RX_EN_B));
+	dev_info(&hdev->pdev->dev, "config_pad_trans_en: %#x\n",
+		 hnae3_get_bit(loop_en, HCLGE_MAC_PAD_TX_B));
+	dev_info(&hdev->pdev->dev, "config_pad_rcv_en: %#x\n",
+		 hnae3_get_bit(loop_en, HCLGE_MAC_PAD_RX_B));
+	dev_info(&hdev->pdev->dev, "config_1588_trans_en: %#x\n",
+		 hnae3_get_bit(loop_en, HCLGE_MAC_1588_TX_B));
+	dev_info(&hdev->pdev->dev, "config_1588_rcv_en: %#x\n",
+		 hnae3_get_bit(loop_en, HCLGE_MAC_1588_RX_B));
+	dev_info(&hdev->pdev->dev, "config_mac_app_loop_en: %#x\n",
+		 hnae3_get_bit(loop_en, HCLGE_MAC_APP_LP_B));
+	dev_info(&hdev->pdev->dev, "config_mac_line_loop_en: %#x\n",
+		 hnae3_get_bit(loop_en, HCLGE_MAC_LINE_LP_B));
+	dev_info(&hdev->pdev->dev, "config_mac_fcs_tx_en: %#x\n",
+		 hnae3_get_bit(loop_en, HCLGE_MAC_FCS_TX_B));
+	dev_info(&hdev->pdev->dev, "config_mac_rx_oversize_truncate_en: %#x\n",
+		 hnae3_get_bit(loop_en, HCLGE_MAC_RX_OVERSIZE_TRUNCATE_B));
+	dev_info(&hdev->pdev->dev, "config_mac_rx_fcs_strip_en: %#x\n",
+		 hnae3_get_bit(loop_en, HCLGE_MAC_RX_FCS_STRIP_B));
+	dev_info(&hdev->pdev->dev, "config_mac_rx_fcs_en: %#x\n",
+		 hnae3_get_bit(loop_en, HCLGE_MAC_RX_FCS_B));
+	dev_info(&hdev->pdev->dev, "config_mac_tx_under_min_err_en: %#x\n",
+		 hnae3_get_bit(loop_en, HCLGE_MAC_TX_UNDER_MIN_ERR_B));
+	dev_info(&hdev->pdev->dev, "config_mac_tx_oversize_truncate_en: %#x\n",
+		 hnae3_get_bit(loop_en, HCLGE_MAC_TX_OVERSIZE_TRUNCATE_B));
+}
+
+static void hclge_dbg_dump_mac_frame_size(struct hclge_dev *hdev)
+{
+	struct hclge_config_max_frm_size_cmd *req;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_CONFIG_MAX_FRM_SIZE, true);
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to dump mac frame size, ret = %d\n", ret);
+		return;
+	}
+
+	req = (struct hclge_config_max_frm_size_cmd *)desc.data;
+
+	dev_info(&hdev->pdev->dev, "max_frame_size: %u\n",
+		 le16_to_cpu(req->max_frm_size));
+	dev_info(&hdev->pdev->dev, "min_frame_size: %u\n", req->min_frm_size);
+}
+
+static void hclge_dbg_dump_mac_speed_duplex(struct hclge_dev *hdev)
+{
+#define HCLGE_MAC_SPEED_SHIFT	0
+#define HCLGE_MAC_SPEED_MASK	GENMASK(5, 0)
+#define HCLGE_MAC_DUPLEX_SHIFT	7
+
+	struct hclge_config_mac_speed_dup_cmd *req;
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_CONFIG_SPEED_DUP, true);
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	if (ret) {
+		dev_err(&hdev->pdev->dev,
+			"failed to dump mac speed duplex, ret = %d\n", ret);
+		return;
+	}
+
+	req = (struct hclge_config_mac_speed_dup_cmd *)desc.data;
+
+	dev_info(&hdev->pdev->dev, "speed: %#lx\n",
+		 hnae3_get_field(req->speed_dup, HCLGE_MAC_SPEED_MASK,
+				 HCLGE_MAC_SPEED_SHIFT));
+	dev_info(&hdev->pdev->dev, "duplex: %#x\n",
+		 hnae3_get_bit(req->speed_dup, HCLGE_MAC_DUPLEX_SHIFT));
+}
+
+static void hclge_dbg_dump_mac(struct hclge_dev *hdev)
+{
+	hclge_dbg_dump_mac_enable_status(hdev);
+
+	hclge_dbg_dump_mac_frame_size(hdev);
+
+	hclge_dbg_dump_mac_speed_duplex(hdev);
+}
+
 static void hclge_dbg_dump_dcb(struct hclge_dev *hdev, const char *cmd_buf)
 {
 	struct device *dev = &hdev->pdev->dev;
@@ -304,6 +412,11 @@ static void hclge_dbg_dump_reg_cmd(struct hclge_dev *hdev, const char *cmd_buf)
 		}
 	}
 
+	if (strncmp(cmd_buf, "mac", strlen("mac")) == 0) {
+		hclge_dbg_dump_mac(hdev);
+		has_dump = true;
+	}
+
 	if (strncmp(cmd_buf, "dcb", 3) == 0) {
 		hclge_dbg_dump_dcb(hdev, &cmd_buf[sizeof("dcb")]);
 		has_dump = true;
-- 
2.7.4

