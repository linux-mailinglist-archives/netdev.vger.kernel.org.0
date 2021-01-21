Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1FD2FE244
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 07:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbhAUGF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 01:05:57 -0500
Received: from m12-17.163.com ([220.181.12.17]:49474 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbhAUGFA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 01:05:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=KtEXc
        ox0mT+oOokFE25ZYZEgpVo5HBdz4Th5NXAN7i8=; b=RsZEw0g021xQbcMXHC2HD
        widS1/cS1RwEsPkOZe2yizrz0S3jAfcU/J1ESDGKqb/DvqaMLxOHwozPPfPTKegn
        l5gfoBlD9UlALmklWBa4leTIibCKH+n9P4pLYKrAF44IjCa5Qf1D9LTsrsOg4aRl
        +qpcVZE78CFLGxYwVqkA4I=
Received: from COOL-20201222LC.ccdomain.com (unknown [218.94.48.178])
        by smtp13 (Coremail) with SMTP id EcCowABXCkIwGQlgfh6Mgw--.52708S2;
        Thu, 21 Jan 2021 14:03:31 +0800 (CST)
From:   dingsenjie@163.com
To:     linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dingsenjie <dingsenjie@yulong.com>
Subject: [PATCH] mt7915: Convert to DEFINE_SHOW_ATTRIBUTE
Date:   Thu, 21 Jan 2021 14:03:24 +0800
Message-Id: <20210121060324.21124-1-dingsenjie@163.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EcCowABXCkIwGQlgfh6Mgw--.52708S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZrWrXw45Zw1rXw48AryftFb_yoW5ZF1fpa
        95uayjvr48Jr1kKrZ5JFWUZ3yrGanaq34UZr92934rCF4vqFn5tF4UGFWSvrW0y3y8Cr17
        X3W5Kry3J3yYvr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jZEfOUUUUU=
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 5glqw25hqmxvi6rwjhhfrp/xtbBRRMhyFPAJqObPgAAsM
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: dingsenjie <dingsenjie@yulong.com>

Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

Signed-off-by: dingsenjie <dingsenjie@yulong.com>
---
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    | 36 ++++------------------
 1 file changed, 6 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
index 7d810fb..fa5ce4e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
@@ -166,7 +166,7 @@ static int mt7915_ser_trigger_set(void *data, u64 val)
 }
 
 static int
-mt7915_tx_stats_read(struct seq_file *file, void *data)
+mt7915_tx_stats_show(struct seq_file *file, void *data)
 {
 	struct mt7915_dev *dev = file->private;
 	int stat[8], i, n;
@@ -196,19 +196,7 @@ static int mt7915_ser_trigger_set(void *data, u64 val)
 	return 0;
 }
 
-static int
-mt7915_tx_stats_open(struct inode *inode, struct file *f)
-{
-	return single_open(f, mt7915_tx_stats_read, inode->i_private);
-}
-
-static const struct file_operations fops_tx_stats = {
-	.open = mt7915_tx_stats_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_ATTRIBUTE(mt7915_tx_stats);
 
 static int mt7915_read_temperature(struct seq_file *s, void *data)
 {
@@ -353,7 +341,7 @@ int mt7915_init_debugfs(struct mt7915_dev *dev)
 				    mt7915_queues_read);
 	debugfs_create_devm_seqfile(dev->mt76.dev, "acq", dir,
 				    mt7915_queues_acq);
-	debugfs_create_file("tx_stats", 0400, dir, dev, &fops_tx_stats);
+	debugfs_create_file("tx_stats", 0400, dir, dev, &mt7915_tx_stats_fops);
 	debugfs_create_file("fw_debug", 0600, dir, dev, &fops_fw_debug);
 	debugfs_create_u32("dfs_hw_pattern", 0400, dir, &dev->hw_pattern);
 	/* test knobs */
@@ -384,7 +372,7 @@ static int mt7915_sta_fixed_rate_set(void *data, u64 rate)
 			 mt7915_sta_fixed_rate_set, "%llx\n");
 
 static int
-mt7915_sta_stats_read(struct seq_file *s, void *data)
+mt7915_sta_stats_show(struct seq_file *s, void *data)
 {
 	struct ieee80211_sta *sta = s->private;
 	struct mt7915_sta *msta = (struct mt7915_sta *)sta->drv_priv;
@@ -427,24 +415,12 @@ static int mt7915_sta_fixed_rate_set(void *data, u64 rate)
 	return 0;
 }
 
-static int
-mt7915_sta_stats_open(struct inode *inode, struct file *f)
-{
-	return single_open(f, mt7915_sta_stats_read, inode->i_private);
-}
-
-static const struct file_operations fops_sta_stats = {
-	.open = mt7915_sta_stats_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_ATTRIBUTE(mt7915_sta_stats);
 
 void mt7915_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta, struct dentry *dir)
 {
 	debugfs_create_file("fixed_rate", 0600, dir, sta, &fops_fixed_rate);
-	debugfs_create_file("stats", 0400, dir, sta, &fops_sta_stats);
+	debugfs_create_file("stats", 0400, dir, sta, &mt7915_sta_stats_fops);
 }
 #endif
-- 
1.9.1


