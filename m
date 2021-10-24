Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64FE5438808
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 11:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbhJXJsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 05:48:00 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:26114 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbhJXJr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 05:47:58 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HcY7M0QZGz1DG8m;
        Sun, 24 Oct 2021 17:43:43 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sun, 24 Oct 2021 17:45:34 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sun, 24 Oct 2021 17:45:34 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 1/8] net: hns3: add debugfs support for interrupt coalesce
Date:   Sun, 24 Oct 2021 17:41:08 +0800
Message-ID: <20211024094115.42158-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211024094115.42158-1-huangguangbin2@huawei.com>
References: <20211024094115.42158-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

Since user may need to check the current configuration of the
interrupt coalesce, so add debugfs support for query this info.

Create a single file "coalesce_info" for it, and query it by
"cat coalesce_info", return the result to userspace.

For device whose version is above V3(include V3), the GL's register
contains usecs and 1us unit configuration. When get the usecs
configuration from this register, it will include the confusing unit
configuration, so add a GL mask to get the correct value, and add
a QL mask for the frames configuration as well.

The display style is below:
$ cat coalesce_info
tx interrupt coalesce info:
VEC_ID  ALGO_STATE  PROFILE_ID  CQE_MODE  TUNE_STATE  STEPS_LEFT...
0       IN_PROG     4           EQE       ON_TOP      0...
1       START       3           EQE       LEFT        1...

rx interrupt coalesce info:
VEC_ID  ALGO_STATE  PROFILE_ID  CQE_MODE  TUNE_STATE  STEPS_LEFT...
0       IN_PROG     3           EQE       LEFT        1...
1       IN_PROG     0           EQE       ON_TOP      0...

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |   1 +
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    | 119 ++++++++++++++++++
 .../net/ethernet/hisilicon/hns3/hns3_enet.h   |   3 +-
 3 files changed, 122 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 30a3954b78e0..07c83af36831 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -299,6 +299,7 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_SERV_INFO,
 	HNAE3_DBG_CMD_UMV_INFO,
 	HNAE3_DBG_CMD_PAGE_POOL_INFO,
+	HNAE3_DBG_CMD_COAL_INFO,
 	HNAE3_DBG_CMD_UNKNOWN,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index b26d43c9c088..578d693b23c2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -343,6 +343,13 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.buf_len = HNS3_DBG_READ_LEN,
 		.init = hns3_dbg_common_file_init,
 	},
+	{
+		.name = "coalesce_info",
+		.cmd = HNAE3_DBG_CMD_COAL_INFO,
+		.dentry = HNS3_DBG_DENTRY_COMMON,
+		.buf_len = HNS3_DBG_READ_LEN_1MB,
+		.init = hns3_dbg_common_file_init,
+	},
 };
 
 static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
@@ -391,6 +398,26 @@ static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
 	}
 };
 
+static const struct hns3_dbg_item coal_info_items[] = {
+	{ "VEC_ID", 2 },
+	{ "ALGO_STATE", 2 },
+	{ "PROFILE_ID", 2 },
+	{ "CQE_MODE", 2 },
+	{ "TUNE_STATE", 2 },
+	{ "STEPS_LEFT", 2 },
+	{ "STEPS_RIGHT", 2 },
+	{ "TIRED", 2 },
+	{ "SW_GL", 2 },
+	{ "SW_QL", 2 },
+	{ "HW_GL", 2 },
+	{ "HW_QL", 2 },
+};
+
+static const char * const dim_cqe_mode_str[] = { "EQE", "CQE" };
+static const char * const dim_state_str[] = { "START", "IN_PROG", "APPLY" };
+static const char * const
+dim_tune_stat_str[] = { "ON_TOP", "TIRED", "RIGHT", "LEFT" };
+
 static void hns3_dbg_fill_content(char *content, u16 len,
 				  const struct hns3_dbg_item *items,
 				  const char **result, u16 size)
@@ -412,6 +439,94 @@ static void hns3_dbg_fill_content(char *content, u16 len,
 	*pos++ = '\0';
 }
 
+static void hns3_get_coal_info(struct hns3_enet_tqp_vector *tqp_vector,
+			       char **result, int i, bool is_tx)
+{
+	unsigned int gl_offset, ql_offset;
+	struct hns3_enet_coalesce *coal;
+	unsigned int reg_val;
+	unsigned int j = 0;
+	struct dim *dim;
+	bool ql_enable;
+
+	if (is_tx) {
+		coal = &tqp_vector->tx_group.coal;
+		dim = &tqp_vector->tx_group.dim;
+		gl_offset = HNS3_VECTOR_GL1_OFFSET;
+		ql_offset = HNS3_VECTOR_TX_QL_OFFSET;
+		ql_enable = tqp_vector->tx_group.coal.ql_enable;
+	} else {
+		coal = &tqp_vector->rx_group.coal;
+		dim = &tqp_vector->rx_group.dim;
+		gl_offset = HNS3_VECTOR_GL0_OFFSET;
+		ql_offset = HNS3_VECTOR_RX_QL_OFFSET;
+		ql_enable = tqp_vector->rx_group.coal.ql_enable;
+	}
+
+	sprintf(result[j++], "%d", i);
+	sprintf(result[j++], "%s", dim_state_str[dim->state]);
+	sprintf(result[j++], "%u", dim->profile_ix);
+	sprintf(result[j++], "%s", dim_cqe_mode_str[dim->mode]);
+	sprintf(result[j++], "%s",
+		dim_tune_stat_str[dim->tune_state]);
+	sprintf(result[j++], "%u", dim->steps_left);
+	sprintf(result[j++], "%u", dim->steps_right);
+	sprintf(result[j++], "%u", dim->tired);
+	sprintf(result[j++], "%u", coal->int_gl);
+	sprintf(result[j++], "%u", coal->int_ql);
+	reg_val = readl(tqp_vector->mask_addr + gl_offset) &
+		  HNS3_VECTOR_GL_MASK;
+	sprintf(result[j++], "%u", reg_val);
+	if (ql_enable) {
+		reg_val = readl(tqp_vector->mask_addr + ql_offset) &
+			  HNS3_VECTOR_QL_MASK;
+		sprintf(result[j++], "%u", reg_val);
+	} else {
+		sprintf(result[j++], "NA");
+	}
+}
+
+static void hns3_dump_coal_info(struct hnae3_handle *h, char *buf, int len,
+				int *pos, bool is_tx)
+{
+	char data_str[ARRAY_SIZE(coal_info_items)][HNS3_DBG_DATA_STR_LEN];
+	char *result[ARRAY_SIZE(coal_info_items)];
+	struct hns3_enet_tqp_vector *tqp_vector;
+	struct hns3_nic_priv *priv = h->priv;
+	char content[HNS3_DBG_INFO_LEN];
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(coal_info_items); i++)
+		result[i] = &data_str[i][0];
+
+	*pos += scnprintf(buf + *pos, len - *pos,
+			  "%s interrupt coalesce info:\n",
+			  is_tx ? "tx" : "rx");
+	hns3_dbg_fill_content(content, sizeof(content), coal_info_items,
+			      NULL, ARRAY_SIZE(coal_info_items));
+	*pos += scnprintf(buf + *pos, len - *pos, "%s", content);
+
+	for (i = 0; i < priv->vector_num; i++) {
+		tqp_vector = &priv->tqp_vector[i];
+		hns3_get_coal_info(tqp_vector, result, i, is_tx);
+		hns3_dbg_fill_content(content, sizeof(content), coal_info_items,
+				      (const char **)result,
+				      ARRAY_SIZE(coal_info_items));
+		*pos += scnprintf(buf + *pos, len - *pos, "%s", content);
+	}
+}
+
+static int hns3_dbg_coal_info(struct hnae3_handle *h, char *buf, int len)
+{
+	int pos = 0;
+
+	hns3_dump_coal_info(h, buf, len, &pos, true);
+	pos += scnprintf(buf + pos, len - pos, "\n");
+	hns3_dump_coal_info(h, buf, len, &pos, false);
+
+	return 0;
+}
+
 static const struct hns3_dbg_item tx_spare_info_items[] = {
 	{ "QUEUE_ID", 2 },
 	{ "COPYBREAK", 2 },
@@ -1056,6 +1171,10 @@ static const struct hns3_dbg_func hns3_dbg_cmd_func[] = {
 		.cmd = HNAE3_DBG_CMD_PAGE_POOL_INFO,
 		.dbg_dump = hns3_dbg_page_pool_info,
 	},
+	{
+		.cmd = HNAE3_DBG_CMD_COAL_INFO,
+		.dbg_dump = hns3_dbg_coal_info,
+	},
 };
 
 static int hns3_dbg_read_cmd(struct hns3_dbg_data *dbg_data,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index f09a61d9c626..1715c98d906d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -189,12 +189,13 @@ enum hns3_nic_state {
 #define HNS3_MAX_TSO_SIZE			1048576U
 #define HNS3_MAX_NON_TSO_SIZE			9728U
 
-
+#define HNS3_VECTOR_GL_MASK			GENMASK(11, 0)
 #define HNS3_VECTOR_GL0_OFFSET			0x100
 #define HNS3_VECTOR_GL1_OFFSET			0x200
 #define HNS3_VECTOR_GL2_OFFSET			0x300
 #define HNS3_VECTOR_RL_OFFSET			0x900
 #define HNS3_VECTOR_RL_EN_B			6
+#define HNS3_VECTOR_QL_MASK			GENMASK(9, 0)
 #define HNS3_VECTOR_TX_QL_OFFSET		0xe00
 #define HNS3_VECTOR_RX_QL_OFFSET		0xf00
 
-- 
2.33.0

