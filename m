Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB930380276
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 05:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbhEND0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 23:26:51 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3669 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbhEND0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 23:26:48 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FhDPB3Kylz1BMPQ;
        Fri, 14 May 2021 11:22:54 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Fri, 14 May 2021 11:25:28 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 05/12] net: hns3: refactor dump bd info of debugfs
Date:   Fri, 14 May 2021 11:25:13 +0800
Message-ID: <1620962720-62216-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1620962720-62216-1-git-send-email-tanhuazhong@huawei.com>
References: <1620962720-62216-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the debugfs command for bd info is implemented
by "echo xxxx > cmd", and record the information in dmesg.
It's unnecessary and heavy.

To improve it, add two debugfs directories "tx_bd_info" and
"rx_bd_info", and create a file for each queue under these
two directories, and query the bd info of specific queue by
"cat tx_bd_info/tx_bd_queue*" or "cat rx_bd_info/rx_bd_queue*",
return the result to userspace, rather than record in dmesg.

The display style is below:
$ cat rx_bd_info/rx_bd_queue0
Queue 0 rx bd info:
BD_IDX   L234_INFO  PKT_LEN   SIZE...
0        0x0             60     60...
1        0x0           1512   1512...

$ cat tx_bd_info/tx_bd_queue0
Queue 0 tx bd info:
BD_IDX     ADDRESS  VLAN_TAG  SIZE...
0          0x0          0        0...
1          0x0          0        0...

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 340 +++++++++++++++------
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h |  19 ++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   1 +
 5 files changed, 263 insertions(+), 101 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index a5cf927..6ec504a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -255,6 +255,8 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_TM_PRI,
 	HNAE3_DBG_CMD_TM_QSET,
 	HNAE3_DBG_CMD_DEV_INFO,
+	HNAE3_DBG_CMD_TX_BD,
+	HNAE3_DBG_CMD_RX_BD,
 	HNAE3_DBG_CMD_UNKNOWN,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index e6c3175..fb3c2d4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -14,12 +14,19 @@ static struct hns3_dbg_dentry_info hns3_dbg_dentry[] = {
 	{
 		.name = "tm"
 	},
+	{
+		.name = "tx_bd_info"
+	},
+	{
+		.name = "rx_bd_info"
+	},
 	/* keep common at the bottom and add new directory above */
 	{
 		.name = "common"
 	},
 };
 
+static int hns3_dbg_bd_file_init(struct hnae3_handle *handle, unsigned int cmd);
 static int hns3_dbg_common_file_init(struct hnae3_handle *handle,
 				     unsigned int cmd);
 
@@ -52,6 +59,20 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.buf_len = HNS3_DBG_READ_LEN,
 		.init = hns3_dbg_common_file_init,
 	},
+	{
+		.name = "tx_bd_queue",
+		.cmd = HNAE3_DBG_CMD_TX_BD,
+		.dentry = HNS3_DBG_DENTRY_TX_BD,
+		.buf_len = HNS3_DBG_READ_LEN_4MB,
+		.init = hns3_dbg_bd_file_init,
+	},
+	{
+		.name = "rx_bd_queue",
+		.cmd = HNAE3_DBG_CMD_RX_BD,
+		.dentry = HNS3_DBG_DENTRY_RX_BD,
+		.buf_len = HNS3_DBG_READ_LEN_4MB,
+		.init = hns3_dbg_bd_file_init,
+	},
 };
 
 static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
@@ -91,6 +112,27 @@ static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
 	},
 };
 
+static void hns3_dbg_fill_content(char *content, u16 len,
+				  const struct hns3_dbg_item *items,
+				  const char **result, u16 size)
+{
+	char *pos = content;
+	u16 i;
+
+	memset(content, ' ', len);
+	for (i = 0; i < size; i++) {
+		if (result)
+			strncpy(pos, result[i], strlen(result[i]));
+		else
+			strncpy(pos, items[i].name, strlen(items[i].name));
+
+		pos += strlen(items[i].name) + items[i].interval;
+	}
+
+	*pos++ = '\n';
+	*pos++ = '\0';
+}
+
 static int hns3_dbg_queue_info(struct hnae3_handle *h,
 			       const char *cmd_buf)
 {
@@ -248,108 +290,159 @@ static int hns3_dbg_queue_map(struct hnae3_handle *h)
 	return 0;
 }
 
-static int hns3_dbg_bd_info(struct hnae3_handle *h, const char *cmd_buf)
+static const struct hns3_dbg_item rx_bd_info_items[] = {
+	{ "BD_IDX", 3 },
+	{ "L234_INFO", 2 },
+	{ "PKT_LEN", 3 },
+	{ "SIZE", 4 },
+	{ "RSS_HASH", 4 },
+	{ "FD_ID", 2 },
+	{ "VLAN_TAG", 2 },
+	{ "O_DM_VLAN_ID_FB", 2 },
+	{ "OT_VLAN_TAG", 2 },
+	{ "BD_BASE_INFO", 2 },
+	{ "PTYPE", 2 },
+	{ "HW_CSUM", 2 },
+};
+
+static void hns3_dump_rx_bd_info(struct hns3_nic_priv *priv,
+				 struct hns3_desc *desc, char **result, int idx)
 {
-	struct hns3_nic_priv *priv = h->priv;
-	struct hns3_desc *rx_desc, *tx_desc;
-	struct device *dev = &h->pdev->dev;
+	unsigned int j = 0;
+
+	sprintf(result[j++], "%5d", idx);
+	sprintf(result[j++], "%#x", le32_to_cpu(desc->rx.l234_info));
+	sprintf(result[j++], "%7u", le16_to_cpu(desc->rx.pkt_len));
+	sprintf(result[j++], "%4u", le16_to_cpu(desc->rx.size));
+	sprintf(result[j++], "%#x", le32_to_cpu(desc->rx.rss_hash));
+	sprintf(result[j++], "%5u", le16_to_cpu(desc->rx.fd_id));
+	sprintf(result[j++], "%8u", le16_to_cpu(desc->rx.vlan_tag));
+	sprintf(result[j++], "%15u", le16_to_cpu(desc->rx.o_dm_vlan_id_fb));
+	sprintf(result[j++], "%11u", le16_to_cpu(desc->rx.ot_vlan_tag));
+	sprintf(result[j++], "%#x", le32_to_cpu(desc->rx.bd_base_info));
+	if (test_bit(HNS3_NIC_STATE_RXD_ADV_LAYOUT_ENABLE, &priv->state)) {
+		u32 ol_info = le32_to_cpu(desc->rx.ol_info);
+
+		sprintf(result[j++], "%5lu", hnae3_get_field(ol_info,
+							     HNS3_RXD_PTYPE_M,
+							     HNS3_RXD_PTYPE_S));
+		sprintf(result[j++], "%7u", le16_to_cpu(desc->csum));
+	} else {
+		sprintf(result[j++], "NA");
+		sprintf(result[j++], "NA");
+	}
+}
+
+static int hns3_dbg_rx_bd_info(struct hns3_dbg_data *d, char *buf, int len)
+{
+	char data_str[ARRAY_SIZE(rx_bd_info_items)][HNS3_DBG_DATA_STR_LEN];
+	struct hns3_nic_priv *priv = d->handle->priv;
+	char *result[ARRAY_SIZE(rx_bd_info_items)];
+	char content[HNS3_DBG_INFO_LEN];
 	struct hns3_enet_ring *ring;
-	u32 tx_index, rx_index;
-	u32 q_num, value;
-	dma_addr_t addr;
-	u16 mss_hw_csum;
-	u32 l234info;
-	int cnt;
+	struct hns3_desc *desc;
+	unsigned int i;
+	int pos = 0;
 
-	cnt = sscanf(&cmd_buf[8], "%u %u", &q_num, &tx_index);
-	if (cnt == 2) {
-		rx_index = tx_index;
-	} else if (cnt != 1) {
-		dev_err(dev, "bd info: bad command string, cnt=%d\n", cnt);
+	if (d->qid >= d->handle->kinfo.num_tqps) {
+		dev_err(&d->handle->pdev->dev,
+			"queue%u is not in use\n", d->qid);
 		return -EINVAL;
 	}
 
-	if (q_num >= h->kinfo.num_tqps) {
-		dev_err(dev, "Queue number(%u) is out of range(0-%u)\n", q_num,
-			h->kinfo.num_tqps - 1);
-		return -EINVAL;
+	for (i = 0; i < ARRAY_SIZE(rx_bd_info_items); i++)
+		result[i] = &data_str[i][0];
+
+	pos += scnprintf(buf + pos, len - pos,
+			  "Queue %u rx bd info:\n", d->qid);
+	hns3_dbg_fill_content(content, sizeof(content), rx_bd_info_items,
+			      NULL, ARRAY_SIZE(rx_bd_info_items));
+	pos += scnprintf(buf + pos, len - pos, "%s", content);
+
+	ring = &priv->ring[d->qid + d->handle->kinfo.num_tqps];
+	for (i = 0; i < ring->desc_num; i++) {
+		desc = &ring->desc[i];
+
+		hns3_dump_rx_bd_info(priv, desc, result, i);
+		hns3_dbg_fill_content(content, sizeof(content),
+				      rx_bd_info_items, (const char **)result,
+				      ARRAY_SIZE(rx_bd_info_items));
+		pos += scnprintf(buf + pos, len - pos, "%s", content);
 	}
 
-	ring = &priv->ring[q_num];
-	value = readl_relaxed(ring->tqp->io_base + HNS3_RING_TX_RING_TAIL_REG);
-	tx_index = (cnt == 1) ? value : tx_index;
+	return 0;
+}
+
+static const struct hns3_dbg_item tx_bd_info_items[] = {
+	{ "BD_IDX", 5 },
+	{ "ADDRESS", 2 },
+	{ "VLAN_TAG", 2 },
+	{ "SIZE", 2 },
+	{ "T_CS_VLAN_TSO", 2 },
+	{ "OT_VLAN_TAG", 3 },
+	{ "TV", 2 },
+	{ "OLT_VLAN_LEN", 2},
+	{ "PAYLEN_OL4CS", 2},
+	{ "BD_FE_SC_VLD", 2},
+	{ "MSS_HW_CSUM", 0},
+};
 
-	if (tx_index >= ring->desc_num) {
-		dev_err(dev, "bd index(%u) is out of range(0-%u)\n", tx_index,
-			ring->desc_num - 1);
+static void hns3_dump_tx_bd_info(struct hns3_nic_priv *priv,
+				 struct hns3_desc *desc, char **result, int idx)
+{
+	unsigned int j = 0;
+
+	sprintf(result[j++], "%6d", idx);
+	sprintf(result[j++], "%#llx", le64_to_cpu(desc->addr));
+	sprintf(result[j++], "%5u", le16_to_cpu(desc->tx.vlan_tag));
+	sprintf(result[j++], "%5u", le16_to_cpu(desc->tx.send_size));
+	sprintf(result[j++], "%#x",
+		le32_to_cpu(desc->tx.type_cs_vlan_tso_len));
+	sprintf(result[j++], "%5u", le16_to_cpu(desc->tx.outer_vlan_tag));
+	sprintf(result[j++], "%5u", le16_to_cpu(desc->tx.tv));
+	sprintf(result[j++], "%10u",
+		le32_to_cpu(desc->tx.ol_type_vlan_len_msec));
+	sprintf(result[j++], "%#x", le32_to_cpu(desc->tx.paylen_ol4cs));
+	sprintf(result[j++], "%#x", le16_to_cpu(desc->tx.bdtp_fe_sc_vld_ra_ri));
+	sprintf(result[j++], "%5u", le16_to_cpu(desc->tx.mss_hw_csum));
+}
+
+static int hns3_dbg_tx_bd_info(struct hns3_dbg_data *d, char *buf, int len)
+{
+	char data_str[ARRAY_SIZE(tx_bd_info_items)][HNS3_DBG_DATA_STR_LEN];
+	struct hns3_nic_priv *priv = d->handle->priv;
+	char *result[ARRAY_SIZE(tx_bd_info_items)];
+	char content[HNS3_DBG_INFO_LEN];
+	struct hns3_enet_ring *ring;
+	struct hns3_desc *desc;
+	unsigned int i;
+	int pos = 0;
+
+	if (d->qid >= d->handle->kinfo.num_tqps) {
+		dev_err(&d->handle->pdev->dev,
+			"queue%u is not in use\n", d->qid);
 		return -EINVAL;
 	}
 
-	tx_desc = &ring->desc[tx_index];
-	addr = le64_to_cpu(tx_desc->addr);
-	mss_hw_csum = le16_to_cpu(tx_desc->tx.mss_hw_csum);
-	dev_info(dev, "TX Queue Num: %u, BD Index: %u\n", q_num, tx_index);
-	dev_info(dev, "(TX)addr: %pad\n", &addr);
-	dev_info(dev, "(TX)vlan_tag: %u\n", le16_to_cpu(tx_desc->tx.vlan_tag));
-	dev_info(dev, "(TX)send_size: %u\n",
-		 le16_to_cpu(tx_desc->tx.send_size));
-
-	if (mss_hw_csum & BIT(HNS3_TXD_HW_CS_B)) {
-		u32 offset = le32_to_cpu(tx_desc->tx.ol_type_vlan_len_msec);
-		u32 start = le32_to_cpu(tx_desc->tx.type_cs_vlan_tso_len);
-
-		dev_info(dev, "(TX)csum start: %u\n",
-			 hnae3_get_field(start,
-					 HNS3_TXD_CSUM_START_M,
-					 HNS3_TXD_CSUM_START_S));
-		dev_info(dev, "(TX)csum offset: %u\n",
-			 hnae3_get_field(offset,
-					 HNS3_TXD_CSUM_OFFSET_M,
-					 HNS3_TXD_CSUM_OFFSET_S));
-	} else {
-		dev_info(dev, "(TX)vlan_tso: %u\n",
-			 tx_desc->tx.type_cs_vlan_tso);
-		dev_info(dev, "(TX)l2_len: %u\n", tx_desc->tx.l2_len);
-		dev_info(dev, "(TX)l3_len: %u\n", tx_desc->tx.l3_len);
-		dev_info(dev, "(TX)l4_len: %u\n", tx_desc->tx.l4_len);
-		dev_info(dev, "(TX)vlan_msec: %u\n",
-			 tx_desc->tx.ol_type_vlan_msec);
-		dev_info(dev, "(TX)ol2_len: %u\n", tx_desc->tx.ol2_len);
-		dev_info(dev, "(TX)ol3_len: %u\n", tx_desc->tx.ol3_len);
-		dev_info(dev, "(TX)ol4_len: %u\n", tx_desc->tx.ol4_len);
-	}
+	for (i = 0; i < ARRAY_SIZE(tx_bd_info_items); i++)
+		result[i] = &data_str[i][0];
+
+	pos += scnprintf(buf + pos, len - pos,
+			  "Queue %u tx bd info:\n", d->qid);
+	hns3_dbg_fill_content(content, sizeof(content), tx_bd_info_items,
+			      NULL, ARRAY_SIZE(tx_bd_info_items));
+	pos += scnprintf(buf + pos, len - pos, "%s", content);
 
-	dev_info(dev, "(TX)vlan_tag: %u\n",
-		 le16_to_cpu(tx_desc->tx.outer_vlan_tag));
-	dev_info(dev, "(TX)tv: %u\n", le16_to_cpu(tx_desc->tx.tv));
-	dev_info(dev, "(TX)paylen_ol4cs: %u\n",
-		 le32_to_cpu(tx_desc->tx.paylen_ol4cs));
-	dev_info(dev, "(TX)vld_ra_ri: %u\n",
-		 le16_to_cpu(tx_desc->tx.bdtp_fe_sc_vld_ra_ri));
-	dev_info(dev, "(TX)mss_hw_csum: %u\n", mss_hw_csum);
-
-	ring = &priv->ring[q_num + h->kinfo.num_tqps];
-	value = readl_relaxed(ring->tqp->io_base + HNS3_RING_RX_RING_TAIL_REG);
-	rx_index = (cnt == 1) ? value : tx_index;
-	rx_desc = &ring->desc[rx_index];
-
-	addr = le64_to_cpu(rx_desc->addr);
-	l234info = le32_to_cpu(rx_desc->rx.l234_info);
-	dev_info(dev, "RX Queue Num: %u, BD Index: %u\n", q_num, rx_index);
-	dev_info(dev, "(RX)addr: %pad\n", &addr);
-	dev_info(dev, "(RX)l234_info: %u\n", l234info);
-
-	dev_info(dev, "(RX)pkt_len: %u\n", le16_to_cpu(rx_desc->rx.pkt_len));
-	dev_info(dev, "(RX)size: %u\n", le16_to_cpu(rx_desc->rx.size));
-	dev_info(dev, "(RX)rss_hash: %u\n", le32_to_cpu(rx_desc->rx.rss_hash));
-	dev_info(dev, "(RX)fd_id: %u\n", le16_to_cpu(rx_desc->rx.fd_id));
-	dev_info(dev, "(RX)vlan_tag: %u\n", le16_to_cpu(rx_desc->rx.vlan_tag));
-	dev_info(dev, "(RX)o_dm_vlan_id_fb: %u\n",
-		 le16_to_cpu(rx_desc->rx.o_dm_vlan_id_fb));
-	dev_info(dev, "(RX)ot_vlan_tag: %u\n",
-		 le16_to_cpu(rx_desc->rx.ot_vlan_tag));
-	dev_info(dev, "(RX)bd_base_info: %u\n",
-		 le32_to_cpu(rx_desc->rx.bd_base_info));
+	ring = &priv->ring[d->qid];
+	for (i = 0; i < ring->desc_num; i++) {
+		desc = &ring->desc[i];
+
+		hns3_dump_tx_bd_info(priv, desc, result, i);
+		hns3_dbg_fill_content(content, sizeof(content),
+				      tx_bd_info_items, (const char **)result,
+				      ARRAY_SIZE(tx_bd_info_items));
+		pos += scnprintf(buf + pos, len - pos, "%s", content);
+	}
 
 	return 0;
 }
@@ -363,7 +456,6 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "available commands\n");
 	dev_info(&h->pdev->dev, "queue info <number>\n");
 	dev_info(&h->pdev->dev, "queue map\n");
-	dev_info(&h->pdev->dev, "bd info <q_num> <bd index>\n");
 
 	if (!hns3_is_phys_func(h->pdev))
 		return;
@@ -518,8 +610,6 @@ static int hns3_dbg_check_cmd(struct hnae3_handle *handle, char *cmd_buf)
 		ret = hns3_dbg_queue_info(handle, cmd_buf);
 	else if (strncmp(cmd_buf, "queue map", 9) == 0)
 		ret = hns3_dbg_queue_map(handle);
-	else if (strncmp(cmd_buf, "bd info", 7) == 0)
-		ret = hns3_dbg_bd_info(handle, cmd_buf);
 	else if (handle->ae_algo->ops->dbg_run_cmd)
 		ret = handle->ae_algo->ops->dbg_run_cmd(handle, cmd_buf);
 	else
@@ -598,29 +688,46 @@ static const struct hns3_dbg_func hns3_dbg_cmd_func[] = {
 		.cmd = HNAE3_DBG_CMD_DEV_INFO,
 		.dbg_dump = hns3_dbg_dev_info,
 	},
+	{
+		.cmd = HNAE3_DBG_CMD_TX_BD,
+		.dbg_dump_bd = hns3_dbg_tx_bd_info,
+	},
+	{
+		.cmd = HNAE3_DBG_CMD_RX_BD,
+		.dbg_dump_bd = hns3_dbg_rx_bd_info,
+	},
 };
 
-static int hns3_dbg_read_cmd(struct hnae3_handle *handle,
+static int hns3_dbg_read_cmd(struct hns3_dbg_data *dbg_data,
 			     enum hnae3_dbg_cmd cmd, char *buf, int len)
 {
-	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+	const struct hnae3_ae_ops *ops = dbg_data->handle->ae_algo->ops;
+	const struct hns3_dbg_func *cmd_func;
 	u32 i;
 
 	for (i = 0; i < ARRAY_SIZE(hns3_dbg_cmd_func); i++) {
-		if (cmd == hns3_dbg_cmd_func[i].cmd)
-			return hns3_dbg_cmd_func[i].dbg_dump(handle, buf, len);
+		if (cmd == hns3_dbg_cmd_func[i].cmd) {
+			cmd_func = &hns3_dbg_cmd_func[i];
+			if (cmd_func->dbg_dump)
+				return cmd_func->dbg_dump(dbg_data->handle, buf,
+							  len);
+			else
+				return cmd_func->dbg_dump_bd(dbg_data, buf,
+							     len);
+		}
 	}
 
 	if (!ops->dbg_read_cmd)
 		return -EOPNOTSUPP;
 
-	return ops->dbg_read_cmd(handle, cmd, buf, len);
+	return ops->dbg_read_cmd(dbg_data->handle, cmd, buf, len);
 }
 
 static ssize_t hns3_dbg_read(struct file *filp, char __user *buffer,
 			     size_t count, loff_t *ppos)
 {
-	struct hnae3_handle *handle = filp->private_data;
+	struct hns3_dbg_data *dbg_data = filp->private_data;
+	struct hnae3_handle *handle = dbg_data->handle;
 	struct hns3_nic_priv *priv = handle->priv;
 	ssize_t size = 0;
 	char **save_buf;
@@ -654,7 +761,7 @@ static ssize_t hns3_dbg_read(struct file *filp, char __user *buffer,
 
 	/* get data ready for the first time to read */
 	if (!*ppos) {
-		ret = hns3_dbg_read_cmd(handle, hns3_dbg_cmd[index].cmd,
+		ret = hns3_dbg_read_cmd(dbg_data, hns3_dbg_cmd[index].cmd,
 					read_buf, hns3_dbg_cmd[index].buf_len);
 		if (ret)
 			goto out;
@@ -688,14 +795,47 @@ static const struct file_operations hns3_dbg_fops = {
 	.read  = hns3_dbg_read,
 };
 
+static int hns3_dbg_bd_file_init(struct hnae3_handle *handle, u32 cmd)
+{
+	struct dentry *entry_dir;
+	struct hns3_dbg_data *data;
+	u16 max_queue_num;
+	unsigned int i;
+
+	entry_dir = hns3_dbg_dentry[hns3_dbg_cmd[cmd].dentry].dentry;
+	max_queue_num = hns3_get_max_available_channels(handle);
+	data = devm_kzalloc(&handle->pdev->dev, max_queue_num * sizeof(*data),
+			    GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	for (i = 0; i < max_queue_num; i++) {
+		char name[HNS3_DBG_FILE_NAME_LEN];
+
+		data[i].handle = handle;
+		data[i].qid = i;
+		sprintf(name, "%s%u", hns3_dbg_cmd[cmd].name, i);
+		debugfs_create_file(name, 0400, entry_dir, &data[i],
+				    &hns3_dbg_fops);
+	}
+
+	return 0;
+}
+
 static int
 hns3_dbg_common_file_init(struct hnae3_handle *handle, u32 cmd)
 {
+	struct hns3_dbg_data *data;
 	struct dentry *entry_dir;
 
+	data = devm_kzalloc(&handle->pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->handle = handle;
 	entry_dir = hns3_dbg_dentry[hns3_dbg_cmd[cmd].dentry].dentry;
 	debugfs_create_file(hns3_dbg_cmd[cmd].name, 0400, entry_dir,
-			    handle, &hns3_dbg_fops);
+			    data, &hns3_dbg_fops);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
index d16ec87..06868b6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
@@ -5,10 +5,28 @@
 #define __HNS3_DEBUGFS_H
 
 #define HNS3_DBG_READ_LEN	65536
+#define HNS3_DBG_READ_LEN_4MB	0x400000
 #define HNS3_DBG_WRITE_LEN	1024
 
+#define HNS3_DBG_DATA_STR_LEN	32
+#define HNS3_DBG_INFO_LEN	256
+#define HNS3_DBG_ITEM_NAME_LEN	32
+#define HNS3_DBG_FILE_NAME_LEN	16
+
+struct hns3_dbg_item {
+	char name[HNS3_DBG_ITEM_NAME_LEN];
+	u16 interval; /* blank numbers after the item */
+};
+
+struct hns3_dbg_data {
+	struct hnae3_handle *handle;
+	u16 qid;
+};
+
 enum hns3_dbg_dentry_type {
 	HNS3_DBG_DENTRY_TM,
+	HNS3_DBG_DENTRY_TX_BD,
+	HNS3_DBG_DENTRY_RX_BD,
 	HNS3_DBG_DENTRY_COMMON,
 };
 
@@ -29,6 +47,7 @@ struct hns3_dbg_cmd_info {
 struct hns3_dbg_func {
 	enum hnae3_dbg_cmd cmd;
 	int (*dbg_dump)(struct hnae3_handle *handle, char *buf, int len);
+	int (*dbg_dump_bd)(struct hns3_dbg_data *data, char *buf, int len);
 };
 
 struct hns3_dbg_cap_info {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 02ce7a3..de0e2d2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -634,7 +634,7 @@ static int hns3_nic_set_real_num_queue(struct net_device *netdev)
 	return 0;
 }
 
-static u16 hns3_get_max_available_channels(struct hnae3_handle *h)
+u16 hns3_get_max_available_channels(struct hnae3_handle *h)
 {
 	u16 alloc_tqps, max_rss_size, rss_size;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 5c72f41..79ff2fa 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -655,4 +655,5 @@ void hns3_dbg_uninit(struct hnae3_handle *handle);
 void hns3_dbg_register_debugfs(const char *debugfs_dir_name);
 void hns3_dbg_unregister_debugfs(void);
 void hns3_shinfo_pack(struct skb_shared_info *shinfo, __u32 *size);
+u16 hns3_get_max_available_channels(struct hnae3_handle *h);
 #endif
-- 
2.7.4

