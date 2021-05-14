Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43647380277
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 05:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhEND0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 23:26:52 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3673 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbhEND0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 23:26:48 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FhDPB28mjz1BMPn;
        Fri, 14 May 2021 11:22:54 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Fri, 14 May 2021 11:25:27 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Jiaran Zhang <zhangjiaran@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 04/12] net: hns3: refactor dev capability and dev spec of debugfs
Date:   Fri, 14 May 2021 11:25:12 +0800
Message-ID: <1620962720-62216-5-git-send-email-tanhuazhong@huawei.com>
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

From: Jiaran Zhang <zhangjiaran@huawei.com>

Currently, the debugfs command for dev capability and dev spec
are implemented by "echo xxxx > cmd", and record the information
in dmesg. It's unnecessary and heavy. To improve it, create a
single file "dev_info" for them, and query them by command
"cat dev_info", return the result to userspace, rather than
record in dmesg.

The display style is below:
$cat dev_info
dev capability:
support FD: yes
support GRO: yes
support FEC: yes
support UDP GSO: no
support PTP: no
support INT QL: no
support HW TX csum: no
support UDP tunnel csum: no
support TX push: no
support imp-controlled PHY: no
support rxd advanced layout: no

dev spec:
MAC entry num: 0
MNG entry num: 0
MAX non tso bd num: 8
RSS ind tbl size: 512
RSS key size: 40
RSS size: 1
Allocated RSS size: 0
Task queue pairs numbers: 1
RX buffer length: 2048
Desc num per TX queue: 1024
Desc num per RX queue: 1024
Total number of enabled TCs: 1
MAX INT QL: 0
MAX INT GL: 8160
MAX TM RATE: 100000
MAX QSET number: 1024

Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 181 ++++++++++++++-------
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h |  10 ++
 3 files changed, 132 insertions(+), 60 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index eee9639..a5cf927 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -254,6 +254,7 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_TM_NODES,
 	HNAE3_DBG_CMD_TM_PRI,
 	HNAE3_DBG_CMD_TM_QSET,
+	HNAE3_DBG_CMD_DEV_INFO,
 	HNAE3_DBG_CMD_UNKNOWN,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 62a0595..e6c3175 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -45,6 +45,50 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.buf_len = HNS3_DBG_READ_LEN,
 		.init = hns3_dbg_common_file_init,
 	},
+	{
+		.name = "dev_info",
+		.cmd = HNAE3_DBG_CMD_DEV_INFO,
+		.dentry = HNS3_DBG_DENTRY_COMMON,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
+};
+
+static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
+	{
+		.name = "support FD",
+		.cap_bit = HNAE3_DEV_SUPPORT_FD_B,
+	}, {
+		.name = "support GRO",
+		.cap_bit = HNAE3_DEV_SUPPORT_GRO_B,
+	}, {
+		.name = "support FEC",
+		.cap_bit = HNAE3_DEV_SUPPORT_FEC_B,
+	}, {
+		.name = "support UDP GSO",
+		.cap_bit = HNAE3_DEV_SUPPORT_UDP_GSO_B,
+	}, {
+		.name = "support PTP",
+		.cap_bit = HNAE3_DEV_SUPPORT_PTP_B,
+	}, {
+		.name = "support INT QL",
+		.cap_bit = HNAE3_DEV_SUPPORT_INT_QL_B,
+	}, {
+		.name = "support HW TX csum",
+		.cap_bit = HNAE3_DEV_SUPPORT_HW_TX_CSUM_B,
+	}, {
+		.name = "support UDP tunnel csum",
+		.cap_bit = HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B,
+	}, {
+		.name = "support TX push",
+		.cap_bit = HNAE3_DEV_SUPPORT_TX_PUSH_B,
+	}, {
+		.name = "support imp-controlled PHY",
+		.cap_bit = HNAE3_DEV_SUPPORT_PHY_IMP_B,
+	}, {
+		.name = "support rxd advanced layout",
+		.cap_bit = HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B,
+	},
 };
 
 static int hns3_dbg_queue_info(struct hnae3_handle *h,
@@ -320,8 +364,6 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "queue info <number>\n");
 	dev_info(&h->pdev->dev, "queue map\n");
 	dev_info(&h->pdev->dev, "bd info <q_num> <bd index>\n");
-	dev_info(&h->pdev->dev, "dev capability\n");
-	dev_info(&h->pdev->dev, "dev spec\n");
 
 	if (!hns3_is_phys_func(h->pdev))
 		return;
@@ -363,68 +405,78 @@ static void hns3_dbg_help(struct hnae3_handle *h)
 	dev_info(&h->pdev->dev, "%s", printf_buf);
 }
 
-static void hns3_dbg_dev_caps(struct hnae3_handle *h)
+static void
+hns3_dbg_dev_caps(struct hnae3_handle *h, char *buf, int len, int *pos)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
-	unsigned long *caps;
-
-	caps = ae_dev->caps;
-
-	dev_info(&h->pdev->dev, "support FD: %s\n",
-		 test_bit(HNAE3_DEV_SUPPORT_FD_B, caps) ? "yes" : "no");
-	dev_info(&h->pdev->dev, "support GRO: %s\n",
-		 test_bit(HNAE3_DEV_SUPPORT_GRO_B, caps) ? "yes" : "no");
-	dev_info(&h->pdev->dev, "support FEC: %s\n",
-		 test_bit(HNAE3_DEV_SUPPORT_FEC_B, caps) ? "yes" : "no");
-	dev_info(&h->pdev->dev, "support UDP GSO: %s\n",
-		 test_bit(HNAE3_DEV_SUPPORT_UDP_GSO_B, caps) ? "yes" : "no");
-	dev_info(&h->pdev->dev, "support PTP: %s\n",
-		 test_bit(HNAE3_DEV_SUPPORT_PTP_B, caps) ? "yes" : "no");
-	dev_info(&h->pdev->dev, "support INT QL: %s\n",
-		 test_bit(HNAE3_DEV_SUPPORT_INT_QL_B, caps) ? "yes" : "no");
-	dev_info(&h->pdev->dev, "support HW TX csum: %s\n",
-		 test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, caps) ? "yes" : "no");
-	dev_info(&h->pdev->dev, "support UDP tunnel csum: %s\n",
-		 test_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, caps) ?
-		 "yes" : "no");
-	dev_info(&h->pdev->dev, "support PAUSE: %s\n",
-		 test_bit(HNAE3_DEV_SUPPORT_PAUSE_B, ae_dev->caps) ?
-		 "yes" : "no");
-	dev_info(&h->pdev->dev, "support imp-controlled PHY: %s\n",
-		 test_bit(HNAE3_DEV_SUPPORT_PHY_IMP_B, caps) ? "yes" : "no");
-	dev_info(&h->pdev->dev, "support rxd advanced layout: %s\n",
-		 test_bit(HNAE3_DEV_SUPPORT_RXD_ADV_LAYOUT_B, caps) ?
-		 "yes" : "no");
+	static const char * const str[] = {"no", "yes"};
+	unsigned long *caps = ae_dev->caps;
+	u32 i, state;
+
+	*pos += scnprintf(buf + *pos, len - *pos, "dev capability:\n");
+
+	for (i = 0; i < ARRAY_SIZE(hns3_dbg_cap); i++) {
+		state = test_bit(hns3_dbg_cap[i].cap_bit, caps);
+		*pos += scnprintf(buf + *pos, len - *pos, "%s: %s\n",
+				  hns3_dbg_cap[i].name, str[state]);
+	}
+
+	*pos += scnprintf(buf + *pos, len - *pos, "\n");
 }
 
-static void hns3_dbg_dev_specs(struct hnae3_handle *h)
+static void
+hns3_dbg_dev_specs(struct hnae3_handle *h, char *buf, int len, int *pos)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
 	struct hnae3_dev_specs *dev_specs = &ae_dev->dev_specs;
 	struct hnae3_knic_private_info *kinfo = &h->kinfo;
-	struct hns3_nic_priv *priv  = h->priv;
-
-	dev_info(priv->dev, "MAC entry num: %u\n", dev_specs->mac_entry_num);
-	dev_info(priv->dev, "MNG entry num: %u\n", dev_specs->mng_entry_num);
-	dev_info(priv->dev, "MAX non tso bd num: %u\n",
-		 dev_specs->max_non_tso_bd_num);
-	dev_info(priv->dev, "RSS ind tbl size: %u\n",
-		 dev_specs->rss_ind_tbl_size);
-	dev_info(priv->dev, "RSS key size: %u\n", dev_specs->rss_key_size);
-	dev_info(priv->dev, "RSS size: %u\n", kinfo->rss_size);
-	dev_info(priv->dev, "Allocated RSS size: %u\n", kinfo->req_rss_size);
-	dev_info(priv->dev, "Task queue pairs numbers: %u\n", kinfo->num_tqps);
-
-	dev_info(priv->dev, "RX buffer length: %u\n", kinfo->rx_buf_len);
-	dev_info(priv->dev, "Desc num per TX queue: %u\n", kinfo->num_tx_desc);
-	dev_info(priv->dev, "Desc num per RX queue: %u\n", kinfo->num_rx_desc);
-	dev_info(priv->dev, "Total number of enabled TCs: %u\n",
-		 kinfo->tc_info.num_tc);
-	dev_info(priv->dev, "MAX INT QL: %u\n", dev_specs->int_ql_max);
-	dev_info(priv->dev, "MAX INT GL: %u\n", dev_specs->max_int_gl);
-	dev_info(priv->dev, "MAX frame size: %u\n", dev_specs->max_frm_size);
-	dev_info(priv->dev, "MAX TM RATE: %uMbps\n", dev_specs->max_tm_rate);
-	dev_info(priv->dev, "MAX QSET number: %u\n", dev_specs->max_qset_num);
+
+	*pos += scnprintf(buf + *pos, len - *pos, "dev_spec:\n");
+	*pos += scnprintf(buf + *pos, len - *pos, "MAC entry num: %u\n",
+			  dev_specs->mac_entry_num);
+	*pos += scnprintf(buf + *pos, len - *pos, "MNG entry num: %u\n",
+			  dev_specs->mng_entry_num);
+	*pos += scnprintf(buf + *pos, len - *pos, "MAX non tso bd num: %u\n",
+			  dev_specs->max_non_tso_bd_num);
+	*pos += scnprintf(buf + *pos, len - *pos, "RSS ind tbl size: %u\n",
+			  dev_specs->rss_ind_tbl_size);
+	*pos += scnprintf(buf + *pos, len - *pos, "RSS key size: %u\n",
+			  dev_specs->rss_key_size);
+	*pos += scnprintf(buf + *pos, len - *pos, "RSS size: %u\n",
+			  kinfo->rss_size);
+	*pos += scnprintf(buf + *pos, len - *pos, "Allocated RSS size: %u\n",
+			  kinfo->req_rss_size);
+	*pos += scnprintf(buf + *pos, len - *pos,
+			  "Task queue pairs numbers: %u\n",
+			  kinfo->num_tqps);
+	*pos += scnprintf(buf + *pos, len - *pos, "RX buffer length: %u\n",
+			  kinfo->rx_buf_len);
+	*pos += scnprintf(buf + *pos, len - *pos, "Desc num per TX queue: %u\n",
+			  kinfo->num_tx_desc);
+	*pos += scnprintf(buf + *pos, len - *pos, "Desc num per RX queue: %u\n",
+			  kinfo->num_rx_desc);
+	*pos += scnprintf(buf + *pos, len - *pos,
+			  "Total number of enabled TCs: %u\n",
+			  kinfo->tc_info.num_tc);
+	*pos += scnprintf(buf + *pos, len - *pos, "MAX INT QL: %u\n",
+			  dev_specs->int_ql_max);
+	*pos += scnprintf(buf + *pos, len - *pos, "MAX INT GL: %u\n",
+			  dev_specs->max_int_gl);
+	*pos += scnprintf(buf + *pos, len - *pos, "MAX TM RATE: %u\n",
+			  dev_specs->max_tm_rate);
+	*pos += scnprintf(buf + *pos, len - *pos, "MAX QSET number: %u\n",
+			  dev_specs->max_qset_num);
+}
+
+static int hns3_dbg_dev_info(struct hnae3_handle *h, char *buf, int len)
+{
+	int pos = 0;
+
+	hns3_dbg_dev_caps(h, buf, len, &pos);
+
+	hns3_dbg_dev_specs(h, buf, len, &pos);
+
+	return 0;
 }
 
 static ssize_t hns3_dbg_cmd_read(struct file *filp, char __user *buffer,
@@ -468,10 +520,6 @@ static int hns3_dbg_check_cmd(struct hnae3_handle *handle, char *cmd_buf)
 		ret = hns3_dbg_queue_map(handle);
 	else if (strncmp(cmd_buf, "bd info", 7) == 0)
 		ret = hns3_dbg_bd_info(handle, cmd_buf);
-	else if (strncmp(cmd_buf, "dev capability", 14) == 0)
-		hns3_dbg_dev_caps(handle);
-	else if (strncmp(cmd_buf, "dev spec", 8) == 0)
-		hns3_dbg_dev_specs(handle);
 	else if (handle->ae_algo->ops->dbg_run_cmd)
 		ret = handle->ae_algo->ops->dbg_run_cmd(handle, cmd_buf);
 	else
@@ -545,10 +593,23 @@ static int hns3_dbg_get_cmd_index(struct hnae3_handle *handle,
 	return -EINVAL;
 }
 
+static const struct hns3_dbg_func hns3_dbg_cmd_func[] = {
+	{
+		.cmd = HNAE3_DBG_CMD_DEV_INFO,
+		.dbg_dump = hns3_dbg_dev_info,
+	},
+};
+
 static int hns3_dbg_read_cmd(struct hnae3_handle *handle,
 			     enum hnae3_dbg_cmd cmd, char *buf, int len)
 {
 	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+	u32 i;
+
+	for (i = 0; i < ARRAY_SIZE(hns3_dbg_cmd_func); i++) {
+		if (cmd == hns3_dbg_cmd_func[i].cmd)
+			return hns3_dbg_cmd_func[i].dbg_dump(handle, buf, len);
+	}
 
 	if (!ops->dbg_read_cmd)
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
index 1648f68..d16ec87 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
@@ -26,4 +26,14 @@ struct hns3_dbg_cmd_info {
 	int (*init)(struct hnae3_handle *handle, unsigned int cmd);
 };
 
+struct hns3_dbg_func {
+	enum hnae3_dbg_cmd cmd;
+	int (*dbg_dump)(struct hnae3_handle *handle, char *buf, int len);
+};
+
+struct hns3_dbg_cap_info {
+	const char *name;
+	enum HNAE3_DEV_CAP_BITS cap_bit;
+};
+
 #endif
-- 
2.7.4

