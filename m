Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8548A42928D
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 16:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238995AbhJKOwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 10:52:23 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:25121 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237236AbhJKOwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 10:52:23 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HShWK2szKz1DHV7;
        Mon, 11 Oct 2021 22:48:45 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 11 Oct 2021 22:50:20 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 11 Oct 2021 22:50:19 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next] net: hns3: debugfs add support dumping page pool info
Date:   Mon, 11 Oct 2021 22:46:08 +0800
Message-ID: <20211011144608.24512-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

Add a file node "page_pool_info" for debugfs, then cat this
file node to dump page pool info as below:

QUEUE_ID  ALLOCATE_CNT  FREE_CNT      POOL_SIZE(PAGE_NUM)  ORDER  NUMA_ID  MAX_LEN
0         512           0             512                  0      2        4K
1         512           0             512                  0      2        4K
2         512           0             512                  0      2        4K
3         512           0             512                  0      2        4K
4         512           0             512                  0      2        4K

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h   |  1 +
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    | 74 +++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 17872c50b63c..5d188573c433 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -298,6 +298,7 @@ enum hnae3_dbg_cmd {
 	HNAE3_DBG_CMD_MAC_TNL_STATUS,
 	HNAE3_DBG_CMD_SERV_INFO,
 	HNAE3_DBG_CMD_UMV_INFO,
+	HNAE3_DBG_CMD_PAGE_POOL_INFO,
 	HNAE3_DBG_CMD_UNKNOWN,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index a1555f074e06..e383033f3f76 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -336,6 +336,13 @@ static struct hns3_dbg_cmd_info hns3_dbg_cmd[] = {
 		.buf_len = HNS3_DBG_READ_LEN,
 		.init = hns3_dbg_common_file_init,
 	},
+	{
+		.name = "page_pool_info",
+		.cmd = HNAE3_DBG_CMD_PAGE_POOL_INFO,
+		.dentry = HNS3_DBG_DENTRY_COMMON,
+		.buf_len = HNS3_DBG_READ_LEN,
+		.init = hns3_dbg_common_file_init,
+	},
 };
 
 static struct hns3_dbg_cap_info hns3_dbg_cap[] = {
@@ -941,6 +948,69 @@ static int hns3_dbg_dev_info(struct hnae3_handle *h, char *buf, int len)
 	return 0;
 }
 
+static const struct hns3_dbg_item page_pool_info_items[] = {
+	{ "QUEUE_ID", 2 },
+	{ "ALLOCATE_CNT", 2 },
+	{ "FREE_CNT", 6 },
+	{ "POOL_SIZE(PAGE_NUM)", 2 },
+	{ "ORDER", 2 },
+	{ "NUMA_ID", 2 },
+	{ "MAX_LEN", 2 },
+};
+
+static void hns3_dump_page_pool_info(struct hns3_enet_ring *ring,
+				     char **result, u32 index)
+{
+	u32 j = 0;
+
+	sprintf(result[j++], "%u", index);
+	sprintf(result[j++], "%u", ring->page_pool->pages_state_hold_cnt);
+	sprintf(result[j++], "%u",
+		atomic_read(&ring->page_pool->pages_state_release_cnt));
+	sprintf(result[j++], "%u", ring->page_pool->p.pool_size);
+	sprintf(result[j++], "%u", ring->page_pool->p.order);
+	sprintf(result[j++], "%d", ring->page_pool->p.nid);
+	sprintf(result[j++], "%uK", ring->page_pool->p.max_len / 1024);
+}
+
+static int
+hns3_dbg_page_pool_info(struct hnae3_handle *h, char *buf, int len)
+{
+	char data_str[ARRAY_SIZE(page_pool_info_items)][HNS3_DBG_DATA_STR_LEN];
+	char *result[ARRAY_SIZE(page_pool_info_items)];
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
+	for (i = 0; i < ARRAY_SIZE(page_pool_info_items); i++)
+		result[i] = &data_str[i][0];
+
+	hns3_dbg_fill_content(content, sizeof(content), page_pool_info_items,
+			      NULL, ARRAY_SIZE(page_pool_info_items));
+	pos += scnprintf(buf + pos, len - pos, "%s", content);
+	for (i = 0; i < h->kinfo.num_tqps; i++) {
+		if (!test_bit(HNS3_NIC_STATE_INITED, &priv->state) ||
+		    test_bit(HNS3_NIC_STATE_RESETTING, &priv->state))
+			return -EPERM;
+		ring = &priv->ring[(u32)(i + h->kinfo.num_tqps)];
+		hns3_dump_page_pool_info(ring, result, i);
+		hns3_dbg_fill_content(content, sizeof(content),
+				      page_pool_info_items,
+				      (const char **)result,
+				      ARRAY_SIZE(page_pool_info_items));
+		pos += scnprintf(buf + pos, len - pos, "%s", content);
+	}
+
+	return 0;
+}
+
 static int hns3_dbg_get_cmd_index(struct hns3_dbg_data *dbg_data, u32 *index)
 {
 	u32 i;
@@ -982,6 +1052,10 @@ static const struct hns3_dbg_func hns3_dbg_cmd_func[] = {
 		.cmd = HNAE3_DBG_CMD_TX_QUEUE_INFO,
 		.dbg_dump = hns3_dbg_tx_queue_info,
 	},
+	{
+		.cmd = HNAE3_DBG_CMD_PAGE_POOL_INFO,
+		.dbg_dump = hns3_dbg_page_pool_info,
+	},
 };
 
 static int hns3_dbg_read_cmd(struct hns3_dbg_data *dbg_data,
-- 
2.33.0

