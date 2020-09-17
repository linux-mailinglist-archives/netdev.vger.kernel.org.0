Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A2926DBE3
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 14:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgIQMow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 08:44:52 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:60704 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726861AbgIQMok (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 08:44:40 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9C27B4177A00CAD98421;
        Thu, 17 Sep 2020 20:44:38 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Thu, 17 Sep 2020 20:44:30 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Qinglang Miao <miaoqinglang@huawei.com>
Subject: [PATCH -next v2] net: hsr: Convert to DEFINE_SHOW_ATTRIBUTE
Date:   Thu, 17 Sep 2020 20:45:07 +0800
Message-ID: <20200917124507.102709-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
v2: based on linux-next(20200917), and can be applied to
    mainline cleanly now.

 net/hsr/hsr_debugfs.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/net/hsr/hsr_debugfs.c b/net/hsr/hsr_debugfs.c
index 7e11a6c35..4cfd9e829 100644
--- a/net/hsr/hsr_debugfs.c
+++ b/net/hsr/hsr_debugfs.c
@@ -60,17 +60,7 @@ hsr_node_table_show(struct seq_file *sfp, void *data)
 	return 0;
 }
 
-/* hsr_node_table_open - Open the node_table file
- *
- * Description:
- * This routine opens a debugfs file node_table of specific hsr
- * or prp device
- */
-static int
-hsr_node_table_open(struct inode *inode, struct file *filp)
-{
-	return single_open(filp, hsr_node_table_show, inode->i_private);
-}
+DEFINE_SHOW_ATTRIBUTE(hsr_node_table);
 
 void hsr_debugfs_rename(struct net_device *dev)
 {
@@ -85,13 +75,6 @@ void hsr_debugfs_rename(struct net_device *dev)
 		priv->node_tbl_root = d;
 }
 
-static const struct file_operations hsr_fops = {
-	.open	= hsr_node_table_open,
-	.read	= seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
 /* hsr_debugfs_init - create hsr node_table file for dumping
  * the node table
  *
@@ -113,7 +96,7 @@ void hsr_debugfs_init(struct hsr_priv *priv, struct net_device *hsr_dev)
 
 	de = debugfs_create_file("node_table", S_IFREG | 0444,
 				 priv->node_tbl_root, priv,
-				 &hsr_fops);
+				 &hsr_node_table_fops);
 	if (IS_ERR(de)) {
 		pr_err("Cannot create hsr node_table file\n");
 		debugfs_remove(priv->node_tbl_root);
-- 
2.23.0

