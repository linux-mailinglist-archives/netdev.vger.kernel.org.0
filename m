Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21E5C50AD96
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 04:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377622AbiDVCFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 22:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbiDVCFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 22:05:07 -0400
X-Greylist: delayed 1988 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 21 Apr 2022 19:02:15 PDT
Received: from m15111.mail.126.com (m15111.mail.126.com [220.181.15.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 171DE4A92D;
        Thu, 21 Apr 2022 19:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=b328s
        Yp84i/CvToFx9BMqGedw/IAbOAcUjUC3unR+0k=; b=go+2Bo+2qK87t7eB6c+oo
        Atu+RHLiaYM/OoANhqq6GbeDToLyMNrYUptCdn7qpK9oLrgDIFezVn6kjgtMFVcv
        CcYuKed7tcGSJoPhT3CHMieau6v5R+W6ICcVWTUlGTtf6ThywAY9KI3FpT5B3k26
        FzpSgMdJUiKtg2teYzWIIU=
Received: from ubuntu.localdomain (unknown [58.213.83.157])
        by smtp1 (Coremail) with SMTP id C8mowABHTzfABGJiO8MNBA--.8225S4;
        Fri, 22 Apr 2022 09:28:34 +0800 (CST)
From:   Bernard Zhao <zhaojunkui2008@126.com>
To:     Jakub Kicinski <kubakici@wp.pl>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     bernard@vivo.com, Bernard Zhao <zhaojunkui2008@126.com>
Subject: [PATCH] net/wireless: add debugfs exit function
Date:   Thu, 21 Apr 2022 18:28:30 -0700
Message-Id: <20220422012830.342993-1-zhaojunkui2008@126.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8mowABHTzfABGJiO8MNBA--.8225S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxWryDur13Jw1kJr4rGr15Jwb_yoW5Gw1xpa
        yUKa4Ykw18Zr1DJ3y8AF4UAFyrG3Zagry7GF90v34ru348Ar1Fq3W0qFW7Aa40qFWUCa45
        tF4UtFnrGryIvFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zizBT7UUUUU=
X-Originating-IP: [58.213.83.157]
X-CM-SenderInfo: p2kd0y5xqn3xasqqmqqrswhudrp/1tbiYAPqqlpEG-QfMQAAs8
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add exit debugfs function to mt7601u.
Debugfs need to be cleanup when module is unloaded or load fail.

Signed-off-by: Bernard Zhao <zhaojunkui2008@126.com>
---
 drivers/net/wireless/mediatek/mt7601u/debugfs.c | 9 +++++++--
 drivers/net/wireless/mediatek/mt7601u/init.c    | 1 +
 drivers/net/wireless/mediatek/mt7601u/mt7601u.h | 1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/debugfs.c b/drivers/net/wireless/mediatek/mt7601u/debugfs.c
index 20669eacb66e..5ae27aae685b 100644
--- a/drivers/net/wireless/mediatek/mt7601u/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt7601u/debugfs.c
@@ -9,6 +9,8 @@
 #include "mt7601u.h"
 #include "eeprom.h"
 
+static struct dentry *dir;
+
 static int
 mt76_reg_set(void *data, u64 val)
 {
@@ -124,8 +126,6 @@ DEFINE_SHOW_ATTRIBUTE(mt7601u_eeprom_param);
 
 void mt7601u_init_debugfs(struct mt7601u_dev *dev)
 {
-	struct dentry *dir;
-
 	dir = debugfs_create_dir("mt7601u", dev->hw->wiphy->debugfsdir);
 	if (!dir)
 		return;
@@ -138,3 +138,8 @@ void mt7601u_init_debugfs(struct mt7601u_dev *dev)
 	debugfs_create_file("ampdu_stat", 0400, dir, dev, &mt7601u_ampdu_stat_fops);
 	debugfs_create_file("eeprom_param", 0400, dir, dev, &mt7601u_eeprom_param_fops);
 }
+
+void mt7601u_exit_debugfs(struct mt7601u_dev *dev)
+{
+	debugfs_remove(dir);
+}
diff --git a/drivers/net/wireless/mediatek/mt7601u/init.c b/drivers/net/wireless/mediatek/mt7601u/init.c
index 5d9e952b2966..eacdd5785fa6 100644
--- a/drivers/net/wireless/mediatek/mt7601u/init.c
+++ b/drivers/net/wireless/mediatek/mt7601u/init.c
@@ -427,6 +427,7 @@ void mt7601u_cleanup(struct mt7601u_dev *dev)
 	mt7601u_stop_hardware(dev);
 	mt7601u_dma_cleanup(dev);
 	mt7601u_mcu_cmd_deinit(dev);
+	mt7601u_exit_debugfs(dev);
 }
 
 struct mt7601u_dev *mt7601u_alloc_device(struct device *pdev)
diff --git a/drivers/net/wireless/mediatek/mt7601u/mt7601u.h b/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
index a122f1dd38f6..a77bfef0d39f 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
+++ b/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
@@ -279,6 +279,7 @@ struct mt7601u_rxwi;
 extern const struct ieee80211_ops mt7601u_ops;
 
 void mt7601u_init_debugfs(struct mt7601u_dev *dev);
+void mt7601u_exit_debugfs(struct mt7601u_dev *dev);
 
 u32 mt7601u_rr(struct mt7601u_dev *dev, u32 offset);
 void mt7601u_wr(struct mt7601u_dev *dev, u32 offset, u32 val);
-- 
2.33.1

