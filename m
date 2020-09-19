Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56E82709F5
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 04:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgISCMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 22:12:21 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13706 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726152AbgISCMV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 22:12:21 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BF1D77549CDC54B08854;
        Sat, 19 Sep 2020 10:12:17 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 10:12:10 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        "Kalle Valo" <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Qinglang Miao <miaoqinglang@huawei.com>
Subject: [PATCH -next v2] mt76: Convert to DEFINE_SHOW_ATTRIBUTE
Date:   Sat, 19 Sep 2020 10:12:42 +0800
Message-ID: <20200919021242.188703-1-miaoqinglang@huawei.com>
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
 .../wireless/mediatek/mt76/mt7603/debugfs.c   | 18 +++-------
 .../wireless/mediatek/mt76/mt7615/debugfs.c   | 17 ++--------
 .../wireless/mediatek/mt76/mt76x02_debugfs.c  | 34 ++++---------------
 3 files changed, 13 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7603/debugfs.c
index 8ce6880b2..f52165dff 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/debugfs.c
@@ -70,7 +70,7 @@ DEFINE_DEBUGFS_ATTRIBUTE(fops_edcca, mt7603_edcca_get,
 			 mt7603_edcca_set, "%lld\n");
 
 static int
-mt7603_ampdu_stat_read(struct seq_file *file, void *data)
+mt7603_ampdu_stat_show(struct seq_file *file, void *data)
 {
 	struct mt7603_dev *dev = file->private;
 	int bound[3], i, range;
@@ -91,18 +91,7 @@ mt7603_ampdu_stat_read(struct seq_file *file, void *data)
 	return 0;
 }
 
-static int
-mt7603_ampdu_stat_open(struct inode *inode, struct file *f)
-{
-	return single_open(f, mt7603_ampdu_stat_read, inode->i_private);
-}
-
-static const struct file_operations fops_ampdu_stat = {
-	.open = mt7603_ampdu_stat_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(mt7603_ampdu_stat);
 
 void mt7603_init_debugfs(struct mt7603_dev *dev)
 {
@@ -112,7 +101,8 @@ void mt7603_init_debugfs(struct mt7603_dev *dev)
 	if (!dir)
 		return;
 
-	debugfs_create_file("ampdu_stat", 0400, dir, dev, &fops_ampdu_stat);
+	debugfs_create_file("ampdu_stat", 0400, dir, dev,
+			     &mt7603_ampdu_stat_fops);
 	debugfs_create_devm_seqfile(dev->mt76.dev, "xmit-queues", dir,
 				    mt76_queues_read);
 	debugfs_create_file("edcca", 0600, dir, dev, &fops_edcca);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
index 88931658a..35f9ed574 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
@@ -221,7 +221,7 @@ mt7615_ampdu_stat_read_phy(struct mt7615_phy *phy,
 }
 
 static int
-mt7615_ampdu_stat_read(struct seq_file *file, void *data)
+mt7615_ampdu_stat_show(struct seq_file *file, void *data)
 {
 	struct mt7615_dev *dev = file->private;
 
@@ -235,18 +235,7 @@ mt7615_ampdu_stat_read(struct seq_file *file, void *data)
 	return 0;
 }
 
-static int
-mt7615_ampdu_stat_open(struct inode *inode, struct file *f)
-{
-	return single_open(f, mt7615_ampdu_stat_read, inode->i_private);
-}
-
-static const struct file_operations fops_ampdu_stat = {
-	.open = mt7615_ampdu_stat_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(mt7615_ampdu_stat);
 
 static void
 mt7615_radio_read_phy(struct mt7615_phy *phy, struct seq_file *s)
@@ -393,7 +382,7 @@ int mt7615_init_debugfs(struct mt7615_dev *dev)
 					    mt76_queues_read);
 	debugfs_create_devm_seqfile(dev->mt76.dev, "acq", dir,
 				    mt7615_queues_acq);
-	debugfs_create_file("ampdu_stat", 0400, dir, dev, &fops_ampdu_stat);
+	debugfs_create_file("ampdu_stat", 0400, dir, dev, &mt7615_ampdu_stat_fops);
 	debugfs_create_file("scs", 0600, dir, dev, &fops_scs);
 	debugfs_create_file("dbdc", 0600, dir, dev, &fops_dbdc);
 	debugfs_create_file("fw_debug", 0600, dir, dev, &fops_fw_debug);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x02_debugfs.c
index ff448a1ad..c4fe1c436 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_debugfs.c
@@ -7,7 +7,7 @@
 #include "mt76x02.h"
 
 static int
-mt76x02_ampdu_stat_read(struct seq_file *file, void *data)
+mt76x02_ampdu_stat_show(struct seq_file *file, void *data)
 {
 	struct mt76x02_dev *dev = file->private;
 	int i, j;
@@ -31,11 +31,7 @@ mt76x02_ampdu_stat_read(struct seq_file *file, void *data)
 	return 0;
 }
 
-static int
-mt76x02_ampdu_stat_open(struct inode *inode, struct file *f)
-{
-	return single_open(f, mt76x02_ampdu_stat_read, inode->i_private);
-}
+DEFINE_SHOW_ATTRIBUTE(mt76x02_ampdu_stat);
 
 static int read_txpower(struct seq_file *file, void *data)
 {
@@ -48,15 +44,8 @@ static int read_txpower(struct seq_file *file, void *data)
 	return 0;
 }
 
-static const struct file_operations fops_ampdu_stat = {
-	.open = mt76x02_ampdu_stat_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
 static int
-mt76x02_dfs_stat_read(struct seq_file *file, void *data)
+mt76x02_dfs_stat_show(struct seq_file *file, void *data)
 {
 	struct mt76x02_dev *dev = file->private;
 	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
@@ -81,18 +70,7 @@ mt76x02_dfs_stat_read(struct seq_file *file, void *data)
 	return 0;
 }
 
-static int
-mt76x02_dfs_stat_open(struct inode *inode, struct file *f)
-{
-	return single_open(f, mt76x02_dfs_stat_read, inode->i_private);
-}
-
-static const struct file_operations fops_dfs_stat = {
-	.open = mt76x02_dfs_stat_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(mt76x02_dfs_stat);
 
 static int read_agc(struct seq_file *file, void *data)
 {
@@ -150,8 +128,8 @@ void mt76x02_init_debugfs(struct mt76x02_dev *dev)
 	debugfs_create_bool("tpc", 0600, dir, &dev->enable_tpc);
 
 	debugfs_create_file("edcca", 0600, dir, dev, &fops_edcca);
-	debugfs_create_file("ampdu_stat", 0400, dir, dev, &fops_ampdu_stat);
-	debugfs_create_file("dfs_stats", 0400, dir, dev, &fops_dfs_stat);
+	debugfs_create_file("ampdu_stat", 0400, dir, dev, &mt76x02_ampdu_stat_fops);
+	debugfs_create_file("dfs_stats", 0400, dir, dev, &mt76x02_dfs_stat_fops);
 	debugfs_create_devm_seqfile(dev->mt76.dev, "txpower", dir,
 				    read_txpower);
 
-- 
2.23.0

