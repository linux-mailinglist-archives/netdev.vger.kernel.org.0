Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA0F389B54
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 04:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhETCX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 22:23:28 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4756 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbhETCXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 22:23:18 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Flth14clWzpfLC;
        Thu, 20 May 2021 10:18:25 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
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
        <linuxarm@huawei.com>, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 02/15] net: hns3: refactor dump reg dcb info of debugfs
Date:   Thu, 20 May 2021 10:21:31 +0800
Message-ID: <1621477304-4495-3-git-send-email-tanhuazhong@huawei.com>
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

From: Yufeng Mo <moyufeng@huawei.com>

Currently, the debugfs command for reg dcb info is implemented by
"echo xxxx > cmd", and record the information in dmesg. It's
unnecessary and heavy. To improve it, create a single file
"dcb" for it, and query it by command "cat dcb",
return the result to userspace, rather than record in dmesg.

The display style is below:
$ cat dcb
qset_id  roce_qset_mask  nic_qset_mask  qset_shaping_pass  qset_bp_status
0000           0x1            0x1             0x1               0x0
0001           0x1            0x1             0x1               0x0
0002           0x1            0x1             0x1               0x0
0003           0x1            0x1             0x1               0x0
0004           0x1            0x1             0x1               0x0
0005           0x1            0x1             0x1               0x0
0006           0x1            0x1             0x1               0x0
0007           0x1            0x1             0x1               0x0
pri_id  pri_mask  pri_cshaping_pass  pri_pshaping_pass
000       0x1           0x0                0x1
001       0x1           0x0                0x0
002       0x1           0x0                0x0
003       0x1           0x0                0x0
004       0x1           0x0                0x0
005       0x1           0x0                0x0
006       0x1           0x0                0x0
007       0x1           0x0                0x0
pg_id  pg_mask  pg_cshaping_pass  pg_pshaping_pass
000      0x1           0x0               0x1

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |  18 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 296 ++++++++++++++-------
 3 files changed, 215 insertions(+), 100 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 9ef4132..65fd333 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -275,6 +275,7 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_REG_RCB,
 	HNAE3_DBG_CMD_REG_TQP,
 	HNAE3_DBG_CMD_REG_MAC,
+	HNAE3_DBG_CMD_REG_DCB,
 	HNAE3_DBG_CMD_UNKNOWN,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index af0751e..9add389 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -205,6 +205,13 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.buf_len = HNS3_DBG_READ_LEN,
 		.init = hns3_dbg_common_file_init,
 	},
+	{
+		.name = "dcb",
+		.cmd = HNAE3_DBG_CMD_REG_DCB,
+		.dentry = HNS3_DBG_DENTRY_REG,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
 };
 
 static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
@@ -581,10 +588,6 @@ static int hns3_dbg_tx_bd_info(struct hns3_dbg_data *d, char *buf, int len)
 
 static void hns3_dbg_help(struct hnae3_handle *h)
 {
-#define HNS3_DBG_BUF_LEN 256
-
-	char printf_buf[HNS3_DBG_BUF_LEN];
-
 	dev_info(&h->pdev->dev, "available commands\n");
 	dev_info(&h->pdev->dev, "queue info <number>\n");
 	dev_info(&h->pdev->dev, "queue map\n");
@@ -601,13 +604,6 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "dump qos buf cfg\n");
 	dev_info(&h->pdev->dev, "dump mac tnl status\n");
 	dev_info(&h->pdev->dev, "dump qs shaper [qs id]\n");
-
-	memset(printf_buf, 0, HNS3_DBG_BUF_LEN);
-	strncat(printf_buf, "dump reg dcb <port_id> <pri_id> <pg_id>",
-		HNS3_DBG_BUF_LEN - 1);
-	strncat(printf_buf + strlen(printf_buf), " <rq_id> <nq_id> <qset_id>\n",
-		HNS3_DBG_BUF_LEN - strlen(printf_buf) - 1);
-	dev_info(&h->pdev->dev, "%s", printf_buf);
 }
 
 static void
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 2f666289..1ad7bff 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -388,120 +388,237 @@ static int hclge_dbg_dump_mac(struct hclge_dev *hdev, char *buf, int len)
 	return hclge_dbg_dump_mac_speed_duplex(hdev, buf, len, &pos);
 }
 
-static void hclge_dbg_dump_dcb(struct hclge_dev *hdev, const char *cmd_buf)
+static int hclge_dbg_dump_dcb_qset(struct hclge_dev *hdev, char *buf, int len,
+				   int *pos)
 {
-	struct device *dev = &hdev->pdev->dev;
 	struct hclge_dbg_bitmap_cmd *bitmap;
-	enum hclge_opcode_type cmd;
-	int rq_id, pri_id, qset_id;
-	int port_id, nq_id, pg_id;
-	struct hclge_desc desc[2];
+	struct hclge_desc desc;
+	u16 qset_id, qset_num;
+	int ret;
+
+	ret = hclge_tm_get_qset_num(hdev, &qset_num);
+	if (ret)
+		return ret;
 
-	int cnt, ret;
+	*pos += scnprintf(buf + *pos, len - *pos,
+			  "qset_id  roce_qset_mask  nic_qset_mask  qset_shaping_pass  qset_bp_status\n");
+	for (qset_id = 0; qset_id < qset_num; qset_id++) {
+		ret = hclge_dbg_cmd_send(hdev, &desc, qset_id, 1,
+					 HCLGE_OPC_QSET_DFX_STS);
+		if (ret)
+			return ret;
 
-	cnt = sscanf(cmd_buf, "%i %i %i %i %i %i",
-		     &port_id, &pri_id, &pg_id, &rq_id, &nq_id, &qset_id);
-	if (cnt != 6) {
-		dev_err(&hdev->pdev->dev,
-			"dump dcb: bad command parameter, cnt=%d\n", cnt);
-		return;
+		bitmap = (struct hclge_dbg_bitmap_cmd *)&desc.data[1];
+
+		*pos += scnprintf(buf + *pos, len - *pos,
+				  "%04u           %#x            %#x             %#x               %#x\n",
+				  qset_id, bitmap->bit0, bitmap->bit1,
+				  bitmap->bit2, bitmap->bit3);
 	}
 
-	cmd = HCLGE_OPC_QSET_DFX_STS;
-	ret = hclge_dbg_cmd_send(hdev, desc, qset_id, 1, cmd);
-	if (ret)
-		goto err_dcb_cmd_send;
+	return 0;
+}
 
-	bitmap = (struct hclge_dbg_bitmap_cmd *)&desc[0].data[1];
-	dev_info(dev, "roce_qset_mask: 0x%x\n", bitmap->bit0);
-	dev_info(dev, "nic_qs_mask: 0x%x\n", bitmap->bit1);
-	dev_info(dev, "qs_shaping_pass: 0x%x\n", bitmap->bit2);
-	dev_info(dev, "qs_bp_sts: 0x%x\n", bitmap->bit3);
+static int hclge_dbg_dump_dcb_pri(struct hclge_dev *hdev, char *buf, int len,
+				  int *pos)
+{
+	struct hclge_dbg_bitmap_cmd *bitmap;
+	struct hclge_desc desc;
+	u8 pri_id, pri_num;
+	int ret;
 
-	cmd = HCLGE_OPC_PRI_DFX_STS;
-	ret = hclge_dbg_cmd_send(hdev, desc, pri_id, 1, cmd);
+	ret = hclge_tm_get_pri_num(hdev, &pri_num);
 	if (ret)
-		goto err_dcb_cmd_send;
+		return ret;
 
-	bitmap = (struct hclge_dbg_bitmap_cmd *)&desc[0].data[1];
-	dev_info(dev, "pri_mask: 0x%x\n", bitmap->bit0);
-	dev_info(dev, "pri_cshaping_pass: 0x%x\n", bitmap->bit1);
-	dev_info(dev, "pri_pshaping_pass: 0x%x\n", bitmap->bit2);
+	*pos += scnprintf(buf + *pos, len - *pos,
+			  "pri_id  pri_mask  pri_cshaping_pass  pri_pshaping_pass\n");
+	for (pri_id = 0; pri_id < pri_num; pri_id++) {
+		ret = hclge_dbg_cmd_send(hdev, &desc, pri_id, 1,
+					 HCLGE_OPC_PRI_DFX_STS);
+		if (ret)
+			return ret;
 
-	cmd = HCLGE_OPC_PG_DFX_STS;
-	ret = hclge_dbg_cmd_send(hdev, desc, pg_id, 1, cmd);
-	if (ret)
-		goto err_dcb_cmd_send;
+		bitmap = (struct hclge_dbg_bitmap_cmd *)&desc.data[1];
+
+		*pos += scnprintf(buf + *pos, len - *pos,
+				  "%03u       %#x           %#x                %#x\n",
+				  pri_id, bitmap->bit0, bitmap->bit1,
+				  bitmap->bit2);
+	}
+
+	return 0;
+}
+
+static int hclge_dbg_dump_dcb_pg(struct hclge_dev *hdev, char *buf, int len,
+				 int *pos)
+{
+	struct hclge_dbg_bitmap_cmd *bitmap;
+	struct hclge_desc desc;
+	u8 pg_id;
+	int ret;
+
+	*pos += scnprintf(buf + *pos, len - *pos,
+			  "pg_id  pg_mask  pg_cshaping_pass  pg_pshaping_pass\n");
+	for (pg_id = 0; pg_id < hdev->tm_info.num_pg; pg_id++) {
+		ret = hclge_dbg_cmd_send(hdev, &desc, pg_id, 1,
+					 HCLGE_OPC_PG_DFX_STS);
+		if (ret)
+			return ret;
+
+		bitmap = (struct hclge_dbg_bitmap_cmd *)&desc.data[1];
+
+		*pos += scnprintf(buf + *pos, len - *pos,
+				  "%03u      %#x           %#x               %#x\n",
+				  pg_id, bitmap->bit0, bitmap->bit1,
+				  bitmap->bit2);
+	}
+
+	return 0;
+}
+
+static int hclge_dbg_dump_dcb_queue(struct hclge_dev *hdev, char *buf, int len,
+				    int *pos)
+{
+	struct hclge_desc desc;
+	u16 nq_id;
+	int ret;
+
+	*pos += scnprintf(buf + *pos, len - *pos,
+			  "nq_id  sch_nic_queue_cnt  sch_roce_queue_cnt\n");
+	for (nq_id = 0; nq_id < hdev->num_tqps; nq_id++) {
+		ret = hclge_dbg_cmd_send(hdev, &desc, nq_id, 1,
+					 HCLGE_OPC_SCH_NQ_CNT);
+		if (ret)
+			return ret;
+
+		*pos += scnprintf(buf + *pos, len - *pos, "%04u           %#x",
+				  nq_id, le32_to_cpu(desc.data[1]));
+
+		ret = hclge_dbg_cmd_send(hdev, &desc, nq_id, 1,
+					 HCLGE_OPC_SCH_RQ_CNT);
+		if (ret)
+			return ret;
+
+		*pos += scnprintf(buf + *pos, len - *pos,
+				  "               %#x\n",
+				  le32_to_cpu(desc.data[1]));
+	}
 
-	bitmap = (struct hclge_dbg_bitmap_cmd *)&desc[0].data[1];
-	dev_info(dev, "pg_mask: 0x%x\n", bitmap->bit0);
-	dev_info(dev, "pg_cshaping_pass: 0x%x\n", bitmap->bit1);
-	dev_info(dev, "pg_pshaping_pass: 0x%x\n", bitmap->bit2);
+	return 0;
+}
 
-	cmd = HCLGE_OPC_PORT_DFX_STS;
-	ret = hclge_dbg_cmd_send(hdev, desc, port_id, 1, cmd);
+static int hclge_dbg_dump_dcb_port(struct hclge_dev *hdev, char *buf, int len,
+				   int *pos)
+{
+	struct hclge_dbg_bitmap_cmd *bitmap;
+	struct hclge_desc desc;
+	u8 port_id = 0;
+	int ret;
+
+	ret = hclge_dbg_cmd_send(hdev, &desc, port_id, 1,
+				 HCLGE_OPC_PORT_DFX_STS);
 	if (ret)
-		goto err_dcb_cmd_send;
+		return ret;
 
-	bitmap = (struct hclge_dbg_bitmap_cmd *)&desc[0].data[1];
-	dev_info(dev, "port_mask: 0x%x\n", bitmap->bit0);
-	dev_info(dev, "port_shaping_pass: 0x%x\n", bitmap->bit1);
+	bitmap = (struct hclge_dbg_bitmap_cmd *)&desc.data[1];
 
-	cmd = HCLGE_OPC_SCH_NQ_CNT;
-	ret = hclge_dbg_cmd_send(hdev, desc, nq_id, 1, cmd);
+	*pos += scnprintf(buf + *pos, len - *pos, "port_mask: %#x\n",
+			 bitmap->bit0);
+	*pos += scnprintf(buf + *pos, len - *pos, "port_shaping_pass: %#x\n",
+			 bitmap->bit1);
+
+	return 0;
+}
+
+static int hclge_dbg_dump_dcb_tm(struct hclge_dev *hdev, char *buf, int len,
+				 int *pos)
+{
+	struct hclge_desc desc[2];
+	u8 port_id = 0;
+	int ret;
+
+	ret = hclge_dbg_cmd_send(hdev, desc, port_id, 1,
+				 HCLGE_OPC_TM_INTERNAL_CNT);
 	if (ret)
-		goto err_dcb_cmd_send;
+		return ret;
 
-	dev_info(dev, "sch_nq_cnt: 0x%x\n", le32_to_cpu(desc[0].data[1]));
+	*pos += scnprintf(buf + *pos, len - *pos, "SCH_NIC_NUM: %#x\n",
+			  le32_to_cpu(desc[0].data[1]));
+	*pos += scnprintf(buf + *pos, len - *pos, "SCH_ROCE_NUM: %#x\n",
+			  le32_to_cpu(desc[0].data[2]));
 
-	cmd = HCLGE_OPC_SCH_RQ_CNT;
-	ret = hclge_dbg_cmd_send(hdev, desc, nq_id, 1, cmd);
+	ret = hclge_dbg_cmd_send(hdev, desc, port_id, 2,
+				 HCLGE_OPC_TM_INTERNAL_STS);
 	if (ret)
-		goto err_dcb_cmd_send;
+		return ret;
 
-	dev_info(dev, "sch_rq_cnt: 0x%x\n", le32_to_cpu(desc[0].data[1]));
+	*pos += scnprintf(buf + *pos, len - *pos, "pri_bp: %#x\n",
+			  le32_to_cpu(desc[0].data[1]));
+	*pos += scnprintf(buf + *pos, len - *pos, "fifo_dfx_info: %#x\n",
+			  le32_to_cpu(desc[0].data[2]));
+	*pos += scnprintf(buf + *pos, len - *pos,
+			  "sch_roce_fifo_afull_gap: %#x\n",
+			  le32_to_cpu(desc[0].data[3]));
+	*pos += scnprintf(buf + *pos, len - *pos,
+			  "tx_private_waterline: %#x\n",
+			  le32_to_cpu(desc[0].data[4]));
+	*pos += scnprintf(buf + *pos, len - *pos, "tm_bypass_en: %#x\n",
+			  le32_to_cpu(desc[0].data[5]));
+	*pos += scnprintf(buf + *pos, len - *pos, "SSU_TM_BYPASS_EN: %#x\n",
+			  le32_to_cpu(desc[1].data[0]));
+	*pos += scnprintf(buf + *pos, len - *pos, "SSU_RESERVE_CFG: %#x\n",
+			  le32_to_cpu(desc[1].data[1]));
+
+	if (hdev->hw.mac.media_type == HNAE3_MEDIA_TYPE_COPPER)
+		return 0;
+
+	ret = hclge_dbg_cmd_send(hdev, desc, port_id, 1,
+				 HCLGE_OPC_TM_INTERNAL_STS_1);
+	if (ret)
+		return ret;
+
+	*pos += scnprintf(buf + *pos, len - *pos, "TC_MAP_SEL: %#x\n",
+			  le32_to_cpu(desc[0].data[1]));
+	*pos += scnprintf(buf + *pos, len - *pos, "IGU_PFC_PRI_EN: %#x\n",
+			  le32_to_cpu(desc[0].data[2]));
+	*pos += scnprintf(buf + *pos, len - *pos, "MAC_PFC_PRI_EN: %#x\n",
+			  le32_to_cpu(desc[0].data[3]));
+	*pos += scnprintf(buf + *pos, len - *pos, "IGU_PRI_MAP_TC_CFG: %#x\n",
+			  le32_to_cpu(desc[0].data[4]));
+	*pos += scnprintf(buf + *pos, len - *pos,
+			  "IGU_TX_PRI_MAP_TC_CFG: %#x\n",
+			  le32_to_cpu(desc[0].data[5]));
+
+	return 0;
+}
+
+static int hclge_dbg_dump_dcb(struct hclge_dev *hdev, char *buf, int len)
+{
+	int pos = 0;
+	int ret;
+
+	ret = hclge_dbg_dump_dcb_qset(hdev, buf, len, &pos);
+	if (ret)
+		return ret;
 
-	cmd = HCLGE_OPC_TM_INTERNAL_STS;
-	ret = hclge_dbg_cmd_send(hdev, desc, 0, 2, cmd);
+	ret = hclge_dbg_dump_dcb_pri(hdev, buf, len, &pos);
 	if (ret)
-		goto err_dcb_cmd_send;
-
-	dev_info(dev, "pri_bp: 0x%x\n", le32_to_cpu(desc[0].data[1]));
-	dev_info(dev, "fifo_dfx_info: 0x%x\n", le32_to_cpu(desc[0].data[2]));
-	dev_info(dev, "sch_roce_fifo_afull_gap: 0x%x\n",
-		 le32_to_cpu(desc[0].data[3]));
-	dev_info(dev, "tx_private_waterline: 0x%x\n",
-		 le32_to_cpu(desc[0].data[4]));
-	dev_info(dev, "tm_bypass_en: 0x%x\n", le32_to_cpu(desc[0].data[5]));
-	dev_info(dev, "SSU_TM_BYPASS_EN: 0x%x\n", le32_to_cpu(desc[1].data[0]));
-	dev_info(dev, "SSU_RESERVE_CFG: 0x%x\n", le32_to_cpu(desc[1].data[1]));
-
-	cmd = HCLGE_OPC_TM_INTERNAL_CNT;
-	ret = hclge_dbg_cmd_send(hdev, desc, port_id, 1, cmd);
+		return ret;
+
+	ret = hclge_dbg_dump_dcb_pg(hdev, buf, len, &pos);
 	if (ret)
-		goto err_dcb_cmd_send;
+		return ret;
 
-	dev_info(dev, "SCH_NIC_NUM: 0x%x\n", le32_to_cpu(desc[0].data[1]));
-	dev_info(dev, "SCH_ROCE_NUM: 0x%x\n", le32_to_cpu(desc[0].data[2]));
+	ret = hclge_dbg_dump_dcb_queue(hdev, buf, len, &pos);
+	if (ret)
+		return ret;
 
-	cmd = HCLGE_OPC_TM_INTERNAL_STS_1;
-	ret = hclge_dbg_cmd_send(hdev, desc, port_id, 1, cmd);
+	ret = hclge_dbg_dump_dcb_port(hdev, buf, len, &pos);
 	if (ret)
-		goto err_dcb_cmd_send;
-
-	dev_info(dev, "TC_MAP_SEL: 0x%x\n", le32_to_cpu(desc[0].data[1]));
-	dev_info(dev, "IGU_PFC_PRI_EN: 0x%x\n", le32_to_cpu(desc[0].data[2]));
-	dev_info(dev, "MAC_PFC_PRI_EN: 0x%x\n", le32_to_cpu(desc[0].data[3]));
-	dev_info(dev, "IGU_PRI_MAP_TC_CFG: 0x%x\n",
-		 le32_to_cpu(desc[0].data[4]));
-	dev_info(dev, "IGU_TX_PRI_MAP_TC_CFG: 0x%x\n",
-		 le32_to_cpu(desc[0].data[5]));
-	return;
+		return ret;
 
-err_dcb_cmd_send:
-	dev_err(&hdev->pdev->dev,
-		"failed to dump dcb dfx, cmd = %#x, ret = %d\n",
-		cmd, ret);
+	return hclge_dbg_dump_dcb_tm(hdev, buf, len, &pos);
 }
 
 static int hclge_dbg_dump_reg_cmd(struct hclge_dev *hdev,
@@ -1872,7 +1989,6 @@ static int hclge_dbg_dump_mac_mc(struct hclge_dev *hdev, char *buf, int len)
 
 int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 {
-#define DUMP_REG_DCB	"dump reg dcb"
 #define DUMP_TM_MAP	"dump tm map"
 
 	struct hclge_vport *vport = hclge_get_vport(handle);
@@ -1892,8 +2008,6 @@ int hclge_dbg_run_cmd(struct hnae3_handle *handle, const char *cmd_buf)
 		hclge_dbg_dump_qos_pri_map(hdev);
 	} else if (strncmp(cmd_buf, "dump qos buf cfg", 16) == 0) {
 		hclge_dbg_dump_qos_buf_cfg(hdev);
-	} else if (strncmp(cmd_buf, DUMP_REG_DCB, strlen(DUMP_REG_DCB)) == 0) {
-		hclge_dbg_dump_dcb(hdev, &cmd_buf[sizeof(DUMP_REG_DCB)]);
 	} else if (strncmp(cmd_buf, "dump serv info", 14) == 0) {
 		hclge_dbg_dump_serv_info(hdev);
 	} else if (strncmp(cmd_buf, "dump mac tnl status", 19) == 0) {
@@ -1994,6 +2108,10 @@ static const struct hclge_dbg_func hclge_dbg_cmd_func[] = {
 		.cmd = HNAE3_DBG_CMD_REG_MAC,
 		.dbg_dump = hclge_dbg_dump_mac,
 	},
+	{
+		.cmd = HNAE3_DBG_CMD_REG_DCB,
+		.dbg_dump = hclge_dbg_dump_dcb,
+	},
 };
 
 int hclge_dbg_read_cmd(struct hnae3_handle *handle, enum hnae3_dbg_cmd cmd,
-- 
2.7.4

