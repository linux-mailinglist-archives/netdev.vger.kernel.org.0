Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE1875E6453
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 15:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbiIVNzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 09:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbiIVNzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 09:55:17 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AC46BCDE;
        Thu, 22 Sep 2022 06:55:14 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MYGs42k08z14RgP;
        Thu, 22 Sep 2022 21:51:04 +0800 (CST)
Received: from dggpemm100009.china.huawei.com (7.185.36.113) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 21:55:10 +0800
Received: from huawei.com (10.175.113.32) by dggpemm100009.china.huawei.com
 (7.185.36.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 22 Sep
 2022 21:55:12 +0800
From:   Liu Shixin <liushixin2@huawei.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH] wifi: wil6210: debugfs: use DEFINE_SHOW_ATTRIBUTE to simplify fw_capabilities/fw_version
Date:   Thu, 22 Sep 2022 22:28:58 +0800
Message-ID: <20220922142858.3250469-1-liushixin2@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm100009.china.huawei.com (7.185.36.113)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use DEFINE_SHOW_ATTRIBUTE helper macro to simplify the code.
No functional change.

Signed-off-by: Liu Shixin <liushixin2@huawei.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 36 ++++------------------
 1 file changed, 6 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 04d1aa0e2d35..c021ebcddee7 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -2154,7 +2154,7 @@ static const struct file_operations fops_led_blink_time = {
 };
 
 /*---------FW capabilities------------*/
-static int wil_fw_capabilities_debugfs_show(struct seq_file *s, void *data)
+static int fw_capabilities_show(struct seq_file *s, void *data)
 {
 	struct wil6210_priv *wil = s->private;
 
@@ -2163,22 +2163,10 @@ static int wil_fw_capabilities_debugfs_show(struct seq_file *s, void *data)
 
 	return 0;
 }
-
-static int wil_fw_capabilities_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, wil_fw_capabilities_debugfs_show,
-			   inode->i_private);
-}
-
-static const struct file_operations fops_fw_capabilities = {
-	.open		= wil_fw_capabilities_seq_open,
-	.release	= single_release,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-};
+DEFINE_SHOW_ATTRIBUTE(fw_capabilities);
 
 /*---------FW version------------*/
-static int wil_fw_version_debugfs_show(struct seq_file *s, void *data)
+static int fw_version_show(struct seq_file *s, void *data)
 {
 	struct wil6210_priv *wil = s->private;
 
@@ -2189,19 +2177,7 @@ static int wil_fw_version_debugfs_show(struct seq_file *s, void *data)
 
 	return 0;
 }
-
-static int wil_fw_version_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, wil_fw_version_debugfs_show,
-			   inode->i_private);
-}
-
-static const struct file_operations fops_fw_version = {
-	.open		= wil_fw_version_seq_open,
-	.release	= single_release,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-};
+DEFINE_SHOW_ATTRIBUTE(fw_version);
 
 /*---------suspend_stats---------*/
 static ssize_t wil_write_suspend_stats(struct file *file,
@@ -2366,8 +2342,8 @@ static const struct {
 	{"recovery", 0644,		&fops_recovery},
 	{"led_cfg",	0644,		&fops_led_cfg},
 	{"led_blink_time",	0644,	&fops_led_blink_time},
-	{"fw_capabilities",	0444,	&fops_fw_capabilities},
-	{"fw_version",	0444,		&fops_fw_version},
+	{"fw_capabilities",	0444,	&fw_capabilities_fops},
+	{"fw_version",	0444,		&fw_version_fops},
 	{"suspend_stats",	0644,	&fops_suspend_stats},
 	{"compressed_rx_status", 0644,	&fops_compressed_rx_status},
 	{"srings",	0444,		&srings_fops},
-- 
2.25.1

