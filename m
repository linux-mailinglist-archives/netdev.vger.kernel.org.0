Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A760850B110
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 09:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444636AbiDVHGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 03:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443752AbiDVHGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 03:06:50 -0400
Received: from m15114.mail.126.com (m15114.mail.126.com [220.181.15.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5FBE450E3D;
        Fri, 22 Apr 2022 00:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=IugEc
        7TCS4filMhSENNWMSdUhh7TomdXhWV1WOvsR7c=; b=ghSz560Mmgy+yQGBrvQmX
        uemRjhsrOTDFsr5kD/Vq21HvCzYfPxJBb72bDtlD+Ap1MPchlann49tqiMo057r7
        8ROCnB8J9E0IDcWhch1mzLZnGeqbdWcYLcLnHZhgntV+b5DO8/5Wz3EGLOHQKntM
        HBotY5E1t0Iqwo9ov0Iac4=
Received: from ubuntu.localdomain (unknown [58.213.83.157])
        by smtp7 (Coremail) with SMTP id DsmowACndf4+U2JieoI6Aw--.46022S4;
        Fri, 22 Apr 2022 15:03:28 +0800 (CST)
From:   Bernard Zhao <zhaojunkui2008@126.com>
To:     Jakub Kicinski <kubakici@wp.pl>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     bernard@vivo.com, Bernard Zhao <zhaojunkui2008@126.com>
Subject: [PATCH] mediatek/mt7601u: add debugfs exit function
Date:   Fri, 22 Apr 2022 00:03:25 -0700
Message-Id: <20220422070325.465918-1-zhaojunkui2008@126.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsmowACndf4+U2JieoI6Aw--.46022S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxCr1xZr43WF4UAFy8Cw48JFb_yoWrAryUpa
        yDKa4Ykw18Zr1UG3yxAF4UZryrG3s3Wr1xJF95Z345Z3y8Ar1Fq3WjqFy2vasxXFZ8A3WY
        qF45tF47CryI9FJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zi7DGrUUUUU=
X-Originating-IP: [58.213.83.157]
X-CM-SenderInfo: p2kd0y5xqn3xasqqmqqrswhudrp/1tbiqAHqqlpD9hmR1AAAsa
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When mt7601u loaded, there are two cases:
First when mt7601u is loaded, in function mt7601u_probe, if
function mt7601u_probe run into error lable err_hw,
mt7601u_cleanup didn`t cleanup the debugfs node.
Second when the module disconnect, in function mt7601u_disconnect,
mt7601u_cleanup didn`t cleanup the debugfs node.
This patch add debugfs exit function and try to cleanup debugfs
node when mt7601u loaded fail or unloaded.

Signed-off-by: Bernard Zhao <zhaojunkui2008@126.com>
---
 .../net/wireless/mediatek/mt7601u/debugfs.c   | 25 +++++++++++--------
 drivers/net/wireless/mediatek/mt7601u/init.c  |  5 ++++
 .../net/wireless/mediatek/mt7601u/mt7601u.h   |  4 +++
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/debugfs.c b/drivers/net/wireless/mediatek/mt7601u/debugfs.c
index 20669eacb66e..1ae3d75d3c9b 100644
--- a/drivers/net/wireless/mediatek/mt7601u/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt7601u/debugfs.c
@@ -124,17 +124,22 @@ DEFINE_SHOW_ATTRIBUTE(mt7601u_eeprom_param);
 
 void mt7601u_init_debugfs(struct mt7601u_dev *dev)
 {
-	struct dentry *dir;
-
-	dir = debugfs_create_dir("mt7601u", dev->hw->wiphy->debugfsdir);
-	if (!dir)
+	dev->root_dir = debugfs_create_dir("mt7601u", dev->hw->wiphy->debugfsdir);
+	if (!dev->root_dir)
 		return;
 
-	debugfs_create_u8("temperature", 0400, dir, &dev->raw_temp);
-	debugfs_create_u32("temp_mode", 0400, dir, &dev->temp_mode);
+	debugfs_create_u8("temperature", 0400, dev->root_dir, &dev->raw_temp);
+	debugfs_create_u32("temp_mode", 0400, dev->root_dir, &dev->temp_mode);
+
+	debugfs_create_u32("regidx", 0600, dev->root_dir, &dev->debugfs_reg);
+	debugfs_create_file("regval", 0600, dev->root_dir, dev, &fops_regval);
+	debugfs_create_file("ampdu_stat", 0400, dev->root_dir, dev, &mt7601u_ampdu_stat_fops);
+	debugfs_create_file("eeprom_param", 0400, dev->root_dir, dev, &mt7601u_eeprom_param_fops);
+}
 
-	debugfs_create_u32("regidx", 0600, dir, &dev->debugfs_reg);
-	debugfs_create_file("regval", 0600, dir, dev, &fops_regval);
-	debugfs_create_file("ampdu_stat", 0400, dir, dev, &mt7601u_ampdu_stat_fops);
-	debugfs_create_file("eeprom_param", 0400, dir, dev, &mt7601u_eeprom_param_fops);
+void mt7601u_exit_debugfs(struct mt7601u_dev *dev)
+{
+	if (!dev->root_dir)
+		return;
+	debugfs_remove(dev->root_dir);
 }
diff --git a/drivers/net/wireless/mediatek/mt7601u/init.c b/drivers/net/wireless/mediatek/mt7601u/init.c
index 5d9e952b2966..1e905ef2ed19 100644
--- a/drivers/net/wireless/mediatek/mt7601u/init.c
+++ b/drivers/net/wireless/mediatek/mt7601u/init.c
@@ -427,6 +427,9 @@ void mt7601u_cleanup(struct mt7601u_dev *dev)
 	mt7601u_stop_hardware(dev);
 	mt7601u_dma_cleanup(dev);
 	mt7601u_mcu_cmd_deinit(dev);
+#ifdef CONFIG_DEBUG_FS
+	mt7601u_exit_debugfs(dev);
+#endif
 }
 
 struct mt7601u_dev *mt7601u_alloc_device(struct device *pdev)
@@ -625,7 +628,9 @@ int mt7601u_register_device(struct mt7601u_dev *dev)
 	if (ret)
 		return ret;
 
+#ifdef CONFIG_DEBUG_FS
 	mt7601u_init_debugfs(dev);
+#endif
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt7601u/mt7601u.h b/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
index a122f1dd38f6..c5f06818bb35 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
+++ b/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
@@ -242,6 +242,9 @@ struct mt7601u_dev {
 	u32 rf_pa_mode[2];
 
 	struct mac_stats stats;
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *root_dir;
+#endif
 };
 
 struct mt7601u_tssi_params {
@@ -279,6 +282,7 @@ struct mt7601u_rxwi;
 extern const struct ieee80211_ops mt7601u_ops;
 
 void mt7601u_init_debugfs(struct mt7601u_dev *dev);
+void mt7601u_exit_debugfs(struct mt7601u_dev *dev);
 
 u32 mt7601u_rr(struct mt7601u_dev *dev, u32 offset);
 void mt7601u_wr(struct mt7601u_dev *dev, u32 offset, u32 val);
-- 
2.33.1

