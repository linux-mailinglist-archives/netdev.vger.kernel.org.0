Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD6A389B5C
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 04:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbhETCXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 22:23:44 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4758 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbhETCXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 22:23:22 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Flth04ZQWzpdfY;
        Thu, 20 May 2021 10:18:24 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:21:54 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:21:54 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Hao Chen <chenhao288@hisilicon.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 04/15] net: hns3: refactor queue info of debugfs
Date:   Thu, 20 May 2021 10:21:33 +0800
Message-ID: <1621477304-4495-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621477304-4495-1-git-send-email-tanhuazhong@huawei.com>
References: <1621477304-4495-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

Currently, the debugfs command for queue info is implemented by
"echo xxxx > cmd", and record the information in dmesg. It's
unnecessary and heavy. To improve it, create two files
"rx_queue_info" and "tx_queue_info" for it, and query it
by command "cat rx_queue_info" and "cat tx_queue_info",
return the result to userspace, rather than record in dmesg.

The display style is below:
$ cat rx_queue_info
QUEUE_ID  BD_NUM  BD_LEN  TAIL  HEAD  FBDNUM  PKTNUM   ...
0           0       0     0     0       0       0      ...
1           0       0     0     0       0       0      ...
2           0       0     0     0       0       0      ...

$ cat tx_queue_info
QUEUE_ID  BD_NUM  TC  TAIL  HEAD  FBDNUM  OFFSET  PKTNUM  ...
0           0     0     0     0       0       0        0  ...
1           0     0     0     0       0       0        0  ...
2           0     0     0     0       0       0        0  ...

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 294 ++++++++++++++-------
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h |   1 +
 3 files changed, 196 insertions(+), 101 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index f844eb2..f4c8796 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -277,6 +277,8 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_REG_MAC,
 	HNAE3_DBG_CMD_REG_DCB,
 	HNAE3_DBG_CMD_QUEUE_MAP,
+	HNAE3_DBG_CMD_RX_QUEUE_INFO,
+	HNAE3_DBG_CMD_TX_QUEUE_INFO,
 	HNAE3_DBG_CMD_UNKNOWN,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index fc4e17b..93455c7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -222,6 +222,20 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.buf_len = HNS3_DBG_READ_LEN,
 		.init = hns3_dbg_common_file_init,
 	},
+	{
+		.name = "rx_queue_info",
+		.cmd = HNAE3_DBG_CMD_RX_QUEUE_INFO,
+		.dentry = HNS3_DBG_DENTRY_QUEUE,
+		.buf_len = HNS3_DBG_READ_LEN_1MB,
+		.init = hns3_dbg_common_file_init,
+	},
+	{
+		.name = "tx_queue_info",
+		.cmd = HNAE3_DBG_CMD_TX_QUEUE_INFO,
+		.dentry = HNS3_DBG_DENTRY_QUEUE,
+		.buf_len = HNS3_DBG_READ_LEN_1MB,
+		.init = hns3_dbg_common_file_init,
+	},
 };
 
 static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
@@ -282,39 +296,86 @@ static void hns3_dbg_fill_content(char *content, u16 len,
 	*pos++ = '\0';
 }
 
-static int hns3_dbg_queue_info(struct hnae3_handle *h,
-			       const char *cmd_buf)
+static const struct hns3_dbg_item rx_queue_info_items[] = {
+	{ "QUEUE_ID", 2 },
+	{ "BD_NUM", 2 },
+	{ "BD_LEN", 2 },
+	{ "TAIL", 2 },
+	{ "HEAD", 2 },
+	{ "FBDNUM", 2 },
+	{ "PKTNUM", 2 },
+	{ "RING_EN", 2 },
+	{ "RX_RING_EN", 2 },
+	{ "BASE_ADDR", 10 },
+};
+
+static void hns3_dump_rx_queue_info(struct hns3_enet_ring *ring,
+				    struct hnae3_ae_dev *ae_dev, char **result,
+				    u32 index)
 {
+	u32 base_add_l, base_add_h;
+	u32 j = 0;
+
+	sprintf(result[j++], "%8u", index);
+
+	sprintf(result[j++], "%6u", readl_relaxed(ring->tqp->io_base +
+		HNS3_RING_RX_RING_BD_NUM_REG));
+
+	sprintf(result[j++], "%6u", readl_relaxed(ring->tqp->io_base +
+		HNS3_RING_RX_RING_BD_LEN_REG));
+
+	sprintf(result[j++], "%4u", readl_relaxed(ring->tqp->io_base +
+		HNS3_RING_RX_RING_TAIL_REG));
+
+	sprintf(result[j++], "%4u", readl_relaxed(ring->tqp->io_base +
+		HNS3_RING_RX_RING_HEAD_REG));
+
+	sprintf(result[j++], "%6u", readl_relaxed(ring->tqp->io_base +
+		HNS3_RING_RX_RING_FBDNUM_REG));
+
+	sprintf(result[j++], "%6u", readl_relaxed(ring->tqp->io_base +
+		HNS3_RING_RX_RING_PKTNUM_RECORD_REG));
+
+	sprintf(result[j++], "%7s", readl_relaxed(ring->tqp->io_base +
+		HNS3_RING_EN_REG) ? "on" : "off");
+
+	if (hnae3_ae_dev_tqp_txrx_indep_supported(ae_dev))
+		sprintf(result[j++], "%10s", readl_relaxed(ring->tqp->io_base +
+			HNS3_RING_RX_EN_REG) ? "on" : "off");
+	else
+		sprintf(result[j++], "%10s", "NA");
+
+	base_add_h = readl_relaxed(ring->tqp->io_base +
+					HNS3_RING_RX_RING_BASEADDR_H_REG);
+	base_add_l = readl_relaxed(ring->tqp->io_base +
+					HNS3_RING_RX_RING_BASEADDR_L_REG);
+	sprintf(result[j++], "0x%08x%08x", base_add_h, base_add_l);
+}
+
+static int hns3_dbg_rx_queue_info(struct hnae3_handle *h,
+				  char *buf, int len)
+{
+	char data_str[ARRAY_SIZE(rx_queue_info_items)][HNS3_DBG_DATA_STR_LEN];
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
+	char *result[ARRAY_SIZE(rx_queue_info_items)];
 	struct hns3_nic_priv *priv = h->priv;
+	char content[HNS3_DBG_INFO_LEN];
 	struct hns3_enet_ring *ring;
-	u32 base_add_l, base_add_h;
-	u32 queue_num, queue_max;
-	u32 value, i;
-	int cnt;
+	int pos = 0;
+	u32 i;
 
 	if (!priv->ring) {
 		dev_err(&h->pdev->dev, "priv->ring is NULL\n");
 		return -EFAULT;
 	}
 
-	queue_max = h->kinfo.num_tqps;
-	cnt = kstrtouint(&cmd_buf[11], 0, &queue_num);
-	if (cnt)
-		queue_num = 0;
-	else
-		queue_max = queue_num + 1;
-
-	dev_info(&h->pdev->dev, "queue info\n");
-
-	if (queue_num >= h->kinfo.num_tqps) {
-		dev_err(&h->pdev->dev,
-			"Queue number(%u) is out of range(0-%u)\n", queue_num,
-			h->kinfo.num_tqps - 1);
-		return -EINVAL;
-	}
+	for (i = 0; i < ARRAY_SIZE(rx_queue_info_items); i++)
+		result[i] = &data_str[i][0];
 
-	for (i = queue_num; i < queue_max; i++) {
+	hns3_dbg_fill_content(content, sizeof(content), rx_queue_info_items,
+			      NULL, ARRAY_SIZE(rx_queue_info_items));
+	pos += scnprintf(buf + pos, len - pos, "%s", content);
+	for (i = 0; i < h->kinfo.num_tqps; i++) {
 		/* Each cycle needs to determine whether the instance is reset,
 		 * to prevent reference to invalid memory. And need to ensure
 		 * that the following code is executed within 100ms.
@@ -324,90 +385,116 @@ static int hns3_dbg_queue_info(struct hnae3_handle *h,
 			return -EPERM;
 
 		ring = &priv->ring[(u32)(i + h->kinfo.num_tqps)];
-		base_add_h = readl_relaxed(ring->tqp->io_base +
-					   HNS3_RING_RX_RING_BASEADDR_H_REG);
-		base_add_l = readl_relaxed(ring->tqp->io_base +
-					   HNS3_RING_RX_RING_BASEADDR_L_REG);
-		dev_info(&h->pdev->dev, "RX(%u) BASE ADD: 0x%08x%08x\n", i,
-			 base_add_h, base_add_l);
+		hns3_dump_rx_queue_info(ring, ae_dev, result, i);
+		hns3_dbg_fill_content(content, sizeof(content),
+				      rx_queue_info_items,
+				      (const char **)result,
+				      ARRAY_SIZE(rx_queue_info_items));
+		pos += scnprintf(buf + pos, len - pos, "%s", content);
+	}
+
+	return 0;
+}
+
+static const struct hns3_dbg_item tx_queue_info_items[] = {
+	{ "QUEUE_ID", 2 },
+	{ "BD_NUM", 2 },
+	{ "TC", 2 },
+	{ "TAIL", 2 },
+	{ "HEAD", 2 },
+	{ "FBDNUM", 2 },
+	{ "OFFSET", 2 },
+	{ "PKTNUM", 2 },
+	{ "RING_EN", 2 },
+	{ "TX_RING_EN", 2 },
+	{ "BASE_ADDR", 10 },
+};
+
+static void hns3_dump_tx_queue_info(struct hns3_enet_ring *ring,
+				    struct hnae3_ae_dev *ae_dev, char **result,
+				    u32 index)
+{
+	u32 base_add_l, base_add_h;
+	u32 j = 0;
 
-		value = readl_relaxed(ring->tqp->io_base +
-				      HNS3_RING_RX_RING_BD_NUM_REG);
-		dev_info(&h->pdev->dev, "RX(%u) RING BD NUM: %u\n", i, value);
+	sprintf(result[j++], "%8u", index);
+	sprintf(result[j++], "%6u", readl_relaxed(ring->tqp->io_base +
+		HNS3_RING_TX_RING_BD_NUM_REG));
 
-		value = readl_relaxed(ring->tqp->io_base +
-				      HNS3_RING_RX_RING_BD_LEN_REG);
-		dev_info(&h->pdev->dev, "RX(%u) RING BD LEN: %u\n", i, value);
+	sprintf(result[j++], "%2u", readl_relaxed(ring->tqp->io_base +
+		HNS3_RING_TX_RING_TC_REG));
 
-		value = readl_relaxed(ring->tqp->io_base +
-				      HNS3_RING_RX_RING_TAIL_REG);
-		dev_info(&h->pdev->dev, "RX(%u) RING TAIL: %u\n", i, value);
+	sprintf(result[j++], "%4u", readl_relaxed(ring->tqp->io_base +
+		HNS3_RING_TX_RING_TAIL_REG));
 
-		value = readl_relaxed(ring->tqp->io_base +
-				      HNS3_RING_RX_RING_HEAD_REG);
-		dev_info(&h->pdev->dev, "RX(%u) RING HEAD: %u\n", i, value);
+	sprintf(result[j++], "%4u", readl_relaxed(ring->tqp->io_base +
+		HNS3_RING_TX_RING_HEAD_REG));
 
-		value = readl_relaxed(ring->tqp->io_base +
-				      HNS3_RING_RX_RING_FBDNUM_REG);
-		dev_info(&h->pdev->dev, "RX(%u) RING FBDNUM: %u\n", i, value);
+	sprintf(result[j++], "%6u", readl_relaxed(ring->tqp->io_base +
+		HNS3_RING_TX_RING_FBDNUM_REG));
 
-		value = readl_relaxed(ring->tqp->io_base +
-				      HNS3_RING_RX_RING_PKTNUM_RECORD_REG);
-		dev_info(&h->pdev->dev, "RX(%u) RING PKTNUM: %u\n", i, value);
+	sprintf(result[j++], "%6u", readl_relaxed(ring->tqp->io_base +
+		HNS3_RING_TX_RING_OFFSET_REG));
 
-		ring = &priv->ring[i];
-		base_add_h = readl_relaxed(ring->tqp->io_base +
-					   HNS3_RING_TX_RING_BASEADDR_H_REG);
-		base_add_l = readl_relaxed(ring->tqp->io_base +
-					   HNS3_RING_TX_RING_BASEADDR_L_REG);
-		dev_info(&h->pdev->dev, "TX(%u) BASE ADD: 0x%08x%08x\n", i,
-			 base_add_h, base_add_l);
-
-		value = readl_relaxed(ring->tqp->io_base +
-				      HNS3_RING_TX_RING_BD_NUM_REG);
-		dev_info(&h->pdev->dev, "TX(%u) RING BD NUM: %u\n", i, value);
-
-		value = readl_relaxed(ring->tqp->io_base +
-				      HNS3_RING_TX_RING_TC_REG);
-		dev_info(&h->pdev->dev, "TX(%u) RING TC: %u\n", i, value);
-
-		value = readl_relaxed(ring->tqp->io_base +
-				      HNS3_RING_TX_RING_TAIL_REG);
-		dev_info(&h->pdev->dev, "TX(%u) RING TAIL: %u\n", i, value);
-
-		value = readl_relaxed(ring->tqp->io_base +
-				      HNS3_RING_TX_RING_HEAD_REG);
-		dev_info(&h->pdev->dev, "TX(%u) RING HEAD: %u\n", i, value);
-
-		value = readl_relaxed(ring->tqp->io_base +
-				      HNS3_RING_TX_RING_FBDNUM_REG);
-		dev_info(&h->pdev->dev, "TX(%u) RING FBDNUM: %u\n", i, value);
-
-		value = readl_relaxed(ring->tqp->io_base +
-				      HNS3_RING_TX_RING_OFFSET_REG);
-		dev_info(&h->pdev->dev, "TX(%u) RING OFFSET: %u\n", i, value);
-
-		value = readl_relaxed(ring->tqp->io_base +
-				      HNS3_RING_TX_RING_PKTNUM_RECORD_REG);
-		dev_info(&h->pdev->dev, "TX(%u) RING PKTNUM: %u\n", i, value);
-
-		value = readl_relaxed(ring->tqp->io_base + HNS3_RING_EN_REG);
-		dev_info(&h->pdev->dev, "TX/RX(%u) RING EN: %s\n", i,
-			 value ? "enable" : "disable");
-
-		if (hnae3_ae_dev_tqp_txrx_indep_supported(ae_dev)) {
-			value = readl_relaxed(ring->tqp->io_base +
-					      HNS3_RING_TX_EN_REG);
-			dev_info(&h->pdev->dev, "TX(%u) RING EN: %s\n", i,
-				 value ? "enable" : "disable");
-
-			value = readl_relaxed(ring->tqp->io_base +
-					      HNS3_RING_RX_EN_REG);
-			dev_info(&h->pdev->dev, "RX(%u) RING EN: %s\n", i,
-				 value ? "enable" : "disable");
-		}
+	sprintf(result[j++], "%6u", readl_relaxed(ring->tqp->io_base +
+		HNS3_RING_TX_RING_PKTNUM_RECORD_REG));
 
-		dev_info(&h->pdev->dev, "\n");
+	sprintf(result[j++], "%7s", readl_relaxed(ring->tqp->io_base +
+		HNS3_RING_EN_REG) ? "on" : "off");
+
+	if (hnae3_ae_dev_tqp_txrx_indep_supported(ae_dev))
+		sprintf(result[j++], "%10s", readl_relaxed(ring->tqp->io_base +
+			HNS3_RING_TX_EN_REG) ? "on" : "off");
+	else
+		sprintf(result[j++], "%10s", "NA");
+
+	base_add_h = readl_relaxed(ring->tqp->io_base +
+					HNS3_RING_TX_RING_BASEADDR_H_REG);
+	base_add_l = readl_relaxed(ring->tqp->io_base +
+					HNS3_RING_TX_RING_BASEADDR_L_REG);
+	sprintf(result[j++], "0x%08x%08x", base_add_h, base_add_l);
+}
+
+static int hns3_dbg_tx_queue_info(struct hnae3_handle *h,
+				  char *buf, int len)
+{
+	char data_str[ARRAY_SIZE(tx_queue_info_items)][HNS3_DBG_DATA_STR_LEN];
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
+	char *result[ARRAY_SIZE(tx_queue_info_items)];
+	struct hns3_nic_priv *priv = h->priv;
+	char content[HNS3_DBG_INFO_LEN];
+	struct hns3_enet_ring *ring;
+	int pos = 0;
+	u32 i;
+
+	if (!priv->ring) {
+		dev_err(&h->pdev->dev, "priv->ring is NULL\n");
+		return -EFAULT;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(tx_queue_info_items); i++)
+		result[i] = &data_str[i][0];
+
+	hns3_dbg_fill_content(content, sizeof(content), tx_queue_info_items,
+			      NULL, ARRAY_SIZE(tx_queue_info_items));
+	pos += scnprintf(buf + pos, len - pos, "%s", content);
+
+	for (i = 0; i < h->kinfo.num_tqps; i++) {
+		/* Each cycle needs to determine whether the instance is reset,
+		 * to prevent reference to invalid memory. And need to ensure
+		 * that the following code is executed within 100ms.
+		 */
+		if (!test_bit(HNS3_NIC_STATE_INITED, &priv->state) ||
+		    test_bit(HNS3_NIC_STATE_RESETTING, &priv->state))
+			return -EPERM;
+
+		ring = &priv->ring[i];
+		hns3_dump_tx_queue_info(ring, ae_dev, result, i);
+		hns3_dbg_fill_content(content, sizeof(content),
+				      tx_queue_info_items,
+				      (const char **)result,
+				      ARRAY_SIZE(tx_queue_info_items));
+		pos += scnprintf(buf + pos, len - pos, "%s", content);
 	}
 
 	return 0;
@@ -616,7 +703,6 @@ static int hns3_dbg_tx_bd_info(struct hns3_dbg_data *d, char *buf, int len)
 static void hns3_dbg_help(struct hnae3_handle *h)
 {
 	dev_info(&h->pdev->dev, "available commands\n");
-	dev_info(&h->pdev->dev, "queue info <number>\n");
 
 	if (!hns3_is_phys_func(h->pdev))
 		return;
@@ -741,8 +827,6 @@ static int hns3_dbg_check_cmd(struct hnae3_handle *handle, char *cmd_buf)
 
 	if (strncmp(cmd_buf, "help", 4) == 0)
 		hns3_dbg_help(handle);
-	else if (strncmp(cmd_buf, "queue info", 10) == 0)
-		ret = hns3_dbg_queue_info(handle, cmd_buf);
 	else if (handle->ae_algo->ops->dbg_run_cmd)
 		ret = handle->ae_algo->ops->dbg_run_cmd(handle, cmd_buf);
 	else
@@ -833,6 +917,14 @@ static const struct hns3_dbg_func hns3_dbg_cmd_func[] = {
 		.cmd = HNAE3_DBG_CMD_RX_BD,
 		.dbg_dump_bd = hns3_dbg_rx_bd_info,
 	},
+	{
+		.cmd = HNAE3_DBG_CMD_RX_QUEUE_INFO,
+		.dbg_dump = hns3_dbg_rx_queue_info,
+	},
+	{
+		.cmd = HNAE3_DBG_CMD_TX_QUEUE_INFO,
+		.dbg_dump = hns3_dbg_tx_queue_info,
+	},
 };
 
 static int hns3_dbg_read_cmd(struct hns3_dbg_data *dbg_data,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
index 4cab37a..0e109b0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
@@ -6,6 +6,7 @@
 
 #define HNS3_DBG_READ_LEN	65536
 #define HNS3_DBG_READ_LEN_128KB	0x20000
+#define HNS3_DBG_READ_LEN_1MB	0x100000
 #define HNS3_DBG_READ_LEN_4MB	0x400000
 #define HNS3_DBG_WRITE_LEN	1024
 
-- 
2.7.4

