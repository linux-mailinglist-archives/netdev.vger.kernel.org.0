Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C51134B5EB
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 11:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbhC0KBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 06:01:14 -0400
Received: from m12-12.163.com ([220.181.12.12]:54957 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231468AbhC0KBE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Mar 2021 06:01:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=/BhxQ
        Uwk2txft5OcNY5/+TGgju86XAdEU+w3D9UUn18=; b=Tb5KMjFkEX9ortqdiNHNb
        b+atZuiYgbU184k3bQ3N58oP9f5jI5ymermN9LK1b4nAlW0JMPGoC5Ri1bO6tfv3
        dQZC0uC8USyKxFVR8LCvkFGjNHBrfME0QOKXJ19G37yd28uLSA6PzBZtDlhJp80y
        gHMWr5txVmF2O8wd2JCCNc=
Received: from yangjunlin.ccdomain.com (unknown [218.17.89.92])
        by smtp8 (Coremail) with SMTP id DMCowABnb48EAl9gqMu5Wg--.45769S2;
        Sat, 27 Mar 2021 17:59:34 +0800 (CST)
From:   angkery <angkery@163.com>
To:     nbd@nbd.name, lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, shayne.chen@mediatek.com,
        yiwei.chung@mediatek.com, ap420073@gmail.com,
        sean.wang@mediatek.com, Soul.Huang@mediatek.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Junlin Yang <yangjunlin@yulong.com>
Subject: [PATCH] mt76: Convert to DEFINE_SHOW_ATTRIBUTE
Date:   Sat, 27 Mar 2021 17:56:17 +0800
Message-Id: <20210327095617.1222-1-angkery@163.com>
X-Mailer: git-send-email 2.24.0.windows.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMCowABnb48EAl9gqMu5Wg--.45769S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAr43tr17ury8Zr18Cr1UGFg_yoWrKw1xpa
        95uayUAr48Jr1kKFWkAFWUZa4Skanaq347Zr92934ruF1ktrnYyF4UKFWSvrW0k3y8Cw1U
        Xa1Yyry7GrWYvr7anT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jLWrXUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5dqjyvlu16il2tof0z/xtbBRgZiI13l-C9qnQAAsd
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Junlin Yang <yangjunlin@yulong.com>

Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

Signed-off-by: Junlin Yang <yangjunlin@yulong.com>
---
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    | 36 ++++------------------
 .../net/wireless/mediatek/mt76/mt7921/debugfs.c    | 18 ++---------
 2 files changed, 9 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
index 77dcd71..7bef36f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
@@ -192,7 +192,7 @@ static int mt7915_ser_trigger_set(void *data, u64 val)
 }
 
 static int
-mt7915_tx_stats_read(struct seq_file *file, void *data)
+mt7915_tx_stats_show(struct seq_file *file, void *data)
 {
 	struct mt7915_dev *dev = file->private;
 	int stat[8], i, n;
@@ -222,19 +222,7 @@ static int mt7915_ser_trigger_set(void *data, u64 val)
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
@@ -379,7 +367,7 @@ int mt7915_init_debugfs(struct mt7915_dev *dev)
 				    mt7915_queues_read);
 	debugfs_create_devm_seqfile(dev->mt76.dev, "acq", dir,
 				    mt7915_queues_acq);
-	debugfs_create_file("tx_stats", 0400, dir, dev, &fops_tx_stats);
+	debugfs_create_file("tx_stats", 0400, dir, dev, &mt7915_tx_stats_fops);
 	debugfs_create_file("fw_debug", 0600, dir, dev, &fops_fw_debug);
 	debugfs_create_file("implicit_txbf", 0600, dir, dev,
 			    &fops_implicit_txbf);
@@ -412,7 +400,7 @@ static int mt7915_sta_fixed_rate_set(void *data, u64 rate)
 			 mt7915_sta_fixed_rate_set, "%llx\n");
 
 static int
-mt7915_sta_stats_read(struct seq_file *s, void *data)
+mt7915_sta_stats_show(struct seq_file *s, void *data)
 {
 	struct ieee80211_sta *sta = s->private;
 	struct mt7915_sta *msta = (struct mt7915_sta *)sta->drv_priv;
@@ -455,24 +443,12 @@ static int mt7915_sta_fixed_rate_set(void *data, u64 rate)
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
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
index 0dc8e25..c1a64ff 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
@@ -62,7 +62,7 @@
 }
 
 static int
-mt7921_tx_stats_read(struct seq_file *file, void *data)
+mt7921_tx_stats_show(struct seq_file *file, void *data)
 {
 	struct mt7921_dev *dev = file->private;
 	int stat[8], i, n;
@@ -88,19 +88,7 @@
 	return 0;
 }
 
-static int
-mt7921_tx_stats_open(struct inode *inode, struct file *f)
-{
-	return single_open(f, mt7921_tx_stats_read, inode->i_private);
-}
-
-static const struct file_operations fops_tx_stats = {
-	.open = mt7921_tx_stats_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
+DEFINE_SHOW_ATTRIBUTE(mt7921_tx_stats);
 
 static int
 mt7921_queues_acq(struct seq_file *s, void *data)
@@ -239,7 +227,7 @@ int mt7921_init_debugfs(struct mt7921_dev *dev)
 				    mt7921_queues_read);
 	debugfs_create_devm_seqfile(dev->mt76.dev, "acq", dir,
 				    mt7921_queues_acq);
-	debugfs_create_file("tx_stats", 0400, dir, dev, &fops_tx_stats);
+	debugfs_create_file("tx_stats", 0400, dir, dev, &mt7921_tx_stats_fops);
 	debugfs_create_file("fw_debug", 0600, dir, dev, &fops_fw_debug);
 	debugfs_create_file("runtime-pm", 0600, dir, dev, &fops_pm);
 	debugfs_create_file("idle-timeout", 0600, dir, dev,
-- 
1.9.1


