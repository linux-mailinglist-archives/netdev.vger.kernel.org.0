Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1F114EC5FD
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 15:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346441AbiC3Nwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 09:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346454AbiC3Nw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 09:52:28 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25F1117C93;
        Wed, 30 Mar 2022 06:50:40 -0700 (PDT)
Received: from kwepemi100017.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KT7570HdGzBrgl;
        Wed, 30 Mar 2022 21:46:35 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100017.china.huawei.com (7.221.188.163) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 30 Mar 2022 21:50:38 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 30 Mar 2022 21:50:38 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 1/2] net: hns3: fix the concurrency between functions reading debugfs
Date:   Wed, 30 Mar 2022 21:45:05 +0800
Message-ID: <20220330134506.36635-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220330134506.36635-1-huangguangbin2@huawei.com>
References: <20220330134506.36635-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

Currently, the debugfs mechanism is that all functions share a
global variable to save the pointer for obtaining data. When
different functions concurrently access the same file node,
repeated release exceptions occur. Therefore, the granularity
of the pointer for storing the obtained data is adjusted to be
private for each function.

Fixes: 5e69ea7ee2a6 ("net: hns3: refactor the debugfs process")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h       |  1 +
 .../net/ethernet/hisilicon/hns3/hns3_debugfs.c    | 15 +++++++++++----
 .../net/ethernet/hisilicon/hns3/hns3_debugfs.h    |  1 -
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index d44dd7091fa1..79c64f4e67d2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -845,6 +845,7 @@ struct hnae3_handle {
 	struct dentry *hnae3_dbgfs;
 	/* protects concurrent contention between debugfs commands */
 	struct mutex dbgfs_lock;
+	char **dbgfs_buf;
 
 	/* Network interface message level enabled bits */
 	u32 msg_enable;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index f726a5b70f9e..44d9b560b337 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -1227,7 +1227,7 @@ static ssize_t hns3_dbg_read(struct file *filp, char __user *buffer,
 		return ret;
 
 	mutex_lock(&handle->dbgfs_lock);
-	save_buf = &hns3_dbg_cmd[index].buf;
+	save_buf = &handle->dbgfs_buf[index];
 
 	if (!test_bit(HNS3_NIC_STATE_INITED, &priv->state) ||
 	    test_bit(HNS3_NIC_STATE_RESETTING, &priv->state)) {
@@ -1332,6 +1332,13 @@ int hns3_dbg_init(struct hnae3_handle *handle)
 	int ret;
 	u32 i;
 
+	handle->dbgfs_buf = devm_kcalloc(&handle->pdev->dev,
+					 ARRAY_SIZE(hns3_dbg_cmd),
+					 sizeof(*handle->dbgfs_buf),
+					 GFP_KERNEL);
+	if (!handle->dbgfs_buf)
+		return -ENOMEM;
+
 	hns3_dbg_dentry[HNS3_DBG_DENTRY_COMMON].dentry =
 				debugfs_create_dir(name, hns3_dbgfs_root);
 	handle->hnae3_dbgfs = hns3_dbg_dentry[HNS3_DBG_DENTRY_COMMON].dentry;
@@ -1380,9 +1387,9 @@ void hns3_dbg_uninit(struct hnae3_handle *handle)
 	u32 i;
 
 	for (i = 0; i < ARRAY_SIZE(hns3_dbg_cmd); i++)
-		if (hns3_dbg_cmd[i].buf) {
-			kvfree(hns3_dbg_cmd[i].buf);
-			hns3_dbg_cmd[i].buf = NULL;
+		if (handle->dbgfs_buf[i]) {
+			kvfree(handle->dbgfs_buf[i]);
+			handle->dbgfs_buf[i] = NULL;
 		}
 
 	mutex_destroy(&handle->dbgfs_lock);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
index 83aa1450ab9f..97578eabb7d8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
@@ -49,7 +49,6 @@ struct hns3_dbg_cmd_info {
 	enum hnae3_dbg_cmd cmd;
 	enum hns3_dbg_dentry_type dentry;
 	u32 buf_len;
-	char *buf;
 	int (*init)(struct hnae3_handle *handle, unsigned int cmd);
 };
 
-- 
2.33.0

