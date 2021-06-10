Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA553A2D45
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 15:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhFJNoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 09:44:07 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:5377 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbhFJNoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 09:44:06 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G14mj5JCcz6wFg;
        Thu, 10 Jun 2021 21:38:13 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 21:42:06 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 10 Jun 2021 21:42:06 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <richardcochran@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <tanhuazhong@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH V2 net-next 2/2] net: hns3: add debugfs support for ptp info
Date:   Thu, 10 Jun 2021 21:38:57 +0800
Message-ID: <1623332337-54480-3-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623332337-54480-1-git-send-email-huangguangbin2@huawei.com>
References: <1623332337-54480-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

Add a debugfs interface for dumping ptp information, which
is helpful for debugging.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 13 ++++-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 55 ++++++++++++++++++++++
 3 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index f6f524c2ab7b..ba883b0a19f0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -276,6 +276,7 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_MAC_MC,
 	HNAE3_DBG_CMD_MNG_TBL,
 	HNAE3_DBG_CMD_LOOPBACK,
+	HNAE3_DBG_CMD_PTP_INFO,
 	HNAE3_DBG_CMD_INTERRUPT_INFO,
 	HNAE3_DBG_CMD_RESET_INFO,
 	HNAE3_DBG_CMD_IMP_INFO,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index a0edca848392..c512a63c423b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -316,6 +316,13 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.buf_len = HNS3_DBG_READ_LEN,
 		.init = hns3_dbg_common_file_init,
 	},
+	{
+		.name = "ptp_info",
+		.cmd = HNAE3_DBG_CMD_PTP_INFO,
+		.dentry = HNS3_DBG_DENTRY_COMMON,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
 };
 
 static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
@@ -1059,8 +1066,10 @@ int hns3_dbg_init(struct hnae3_handle *handle)
 					   handle->hnae3_dbgfs);
 
 	for (i = 0; i < ARRAY_SIZE(hns3_dbg_cmd); i++) {
-		if (hns3_dbg_cmd[i].cmd == HNAE3_DBG_CMD_TM_NODES &&
-		    ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2)
+		if ((hns3_dbg_cmd[i].cmd == HNAE3_DBG_CMD_TM_NODES &&
+		     ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2) ||
+		    (hns3_dbg_cmd[i].cmd == HNAE3_DBG_CMD_PTP_INFO &&
+		     !test_bit(HNAE3_DEV_SUPPORT_PTP_B, ae_dev->caps)))
 			continue;
 
 		if (!hns3_dbg_cmd[i].init) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 0d433a5ff807..6fc50d09b9db 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -2173,6 +2173,57 @@ static int hclge_dbg_dump_vlan_config(struct hclge_dev *hdev, char *buf,
 	return hclge_dbg_dump_vlan_offload_config(hdev, buf, len, &pos);
 }
 
+static int hclge_dbg_dump_ptp_info(struct hclge_dev *hdev, char *buf, int len)
+{
+	struct hclge_ptp *ptp = hdev->ptp;
+	u32 sw_cfg = ptp->ptp_cfg;
+	unsigned int tx_start;
+	unsigned int last_rx;
+	int pos = 0;
+	u32 hw_cfg;
+	int ret;
+
+	pos += scnprintf(buf + pos, len - pos, "phc %s's debug info:\n",
+			 ptp->info.name);
+	pos += scnprintf(buf + pos, len - pos, "ptp enable: %s\n",
+			 test_bit(HCLGE_PTP_FLAG_EN, &ptp->flags) ?
+			 "yes" : "no");
+	pos += scnprintf(buf + pos, len - pos, "ptp tx enable: %s\n",
+			 test_bit(HCLGE_PTP_FLAG_TX_EN, &ptp->flags) ?
+			 "yes" : "no");
+	pos += scnprintf(buf + pos, len - pos, "ptp rx enable: %s\n",
+			 test_bit(HCLGE_PTP_FLAG_RX_EN, &ptp->flags) ?
+			 "yes" : "no");
+
+	last_rx = jiffies_to_msecs(ptp->last_rx);
+	pos += scnprintf(buf + pos, len - pos, "last rx time: %lu.%lu\n",
+			 last_rx / MSEC_PER_SEC, last_rx % MSEC_PER_SEC);
+	pos += scnprintf(buf + pos, len - pos, "rx count: %lu\n", ptp->rx_cnt);
+
+	tx_start = jiffies_to_msecs(ptp->tx_start);
+	pos += scnprintf(buf + pos, len - pos, "last tx start time: %lu.%lu\n",
+			 tx_start / MSEC_PER_SEC, tx_start % MSEC_PER_SEC);
+	pos += scnprintf(buf + pos, len - pos, "tx count: %lu\n", ptp->tx_cnt);
+	pos += scnprintf(buf + pos, len - pos, "tx skipped count: %lu\n",
+			 ptp->tx_skipped);
+	pos += scnprintf(buf + pos, len - pos, "tx timeout count: %lu\n",
+			 ptp->tx_timeout);
+	pos += scnprintf(buf + pos, len - pos, "last tx seqid: %u\n",
+			 ptp->last_tx_seqid);
+
+	ret = hclge_ptp_cfg_qry(hdev, &hw_cfg);
+	if (ret)
+		return ret;
+
+	pos += scnprintf(buf + pos, len - pos, "sw_cfg: %#x, hw_cfg: %#x\n",
+			 sw_cfg, hw_cfg);
+
+	pos += scnprintf(buf + pos, len - pos, "tx type: %d, rx filter: %d\n",
+			 ptp->ts_cfg.tx_type, ptp->ts_cfg.rx_filter);
+
+	return 0;
+}
+
 static int hclge_dbg_dump_mac_uc(struct hclge_dev *hdev, char *buf, int len)
 {
 	hclge_dbg_dump_mac_list(hdev, buf, len, true);
@@ -2245,6 +2296,10 @@ static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 		.dbg_dump = hclge_dbg_dump_loopback,
 	},
 	{
+		.cmd = HNAE3_DBG_CMD_PTP_INFO,
+		.dbg_dump = hclge_dbg_dump_ptp_info,
+	},
+	{
 		.cmd = HNAE3_DBG_CMD_INTERRUPT_INFO,
 		.dbg_dump = hclge_dbg_dump_interrupt,
 	},
-- 
2.8.1

