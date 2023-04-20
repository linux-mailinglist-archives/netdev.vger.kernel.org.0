Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1B16E9571
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 15:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbjDTNLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 09:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbjDTNL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 09:11:29 -0400
Received: from hust.edu.cn (mail.hust.edu.cn [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D56072A4;
        Thu, 20 Apr 2023 06:11:28 -0700 (PDT)
Received: from wjk.. ([10.12.190.56])
        (user=wangjikai@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 33KD9Q5X018747-33KD9Q5Y018747
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 20 Apr 2023 21:09:32 +0800
From:   Wang Jikai <wangjikai@hust.edu.cn>
To:     Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     hust-os-kernel-patches@googlegroups.com,
        Wang Jikai <wangjikai@hust.edu.cn>,
        Jakub Kicinski <kubakici@wp.pl>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 2/2] wifi: mt7601u: remove debugfs directory on disconnect
Date:   Thu, 20 Apr 2023 13:09:24 +0000
Message-Id: <20230420130924.8702-1-wangjikai@hust.edu.cn>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-FEAS-AUTH-USER: wangjikai@hust.edu.cn
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Debugfs is created during device init but not removed.
Add a function mt7601u_remove_debugfs to remove debugfs
when the device disconnects.

Fixes: c869f77d6abb ("add mt7601u driver")
Signed-off-by: Wang Jikai <wangjikai@hust.edu.cn>
---
The issue is found by static analysis and remains untested.
---
 drivers/net/wireless/mediatek/mt7601u/debugfs.c | 5 +++++
 drivers/net/wireless/mediatek/mt7601u/mt7601u.h | 1 +
 drivers/net/wireless/mediatek/mt7601u/usb.c     | 1 +
 3 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt7601u/debugfs.c b/drivers/net/wireless/mediatek/mt7601u/debugfs.c
index dbddf256921b..1b87a4854e0e 100644
--- a/drivers/net/wireless/mediatek/mt7601u/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt7601u/debugfs.c
@@ -136,3 +136,8 @@ void mt7601u_init_debugfs(struct mt7601u_dev *dev)
 	debugfs_create_file("ampdu_stat", 0400, dir, dev, &mt7601u_ampdu_stat_fops);
 	debugfs_create_file("eeprom_param", 0400, dir, dev, &mt7601u_eeprom_param_fops);
 }
+
+void mt7601u_remove_debugfs(struct mt7601u_dev *dev)
+{
+	debugfs_lookup_and_remove("mt7601u", dev->hw->wiphy->debugfsdir);
+}
diff --git a/drivers/net/wireless/mediatek/mt7601u/mt7601u.h b/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
index 118d43707853..0216ace4b8e9 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
+++ b/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
@@ -279,6 +279,7 @@ struct mt7601u_rxwi;
 extern const struct ieee80211_ops mt7601u_ops;
 
 void mt7601u_init_debugfs(struct mt7601u_dev *dev);
+void mt7601u_remove_debugfs(struct mt7601u_dev *dev);
 
 u32 mt7601u_rr(struct mt7601u_dev *dev, u32 offset);
 void mt7601u_wr(struct mt7601u_dev *dev, u32 offset, u32 val);
diff --git a/drivers/net/wireless/mediatek/mt7601u/usb.c b/drivers/net/wireless/mediatek/mt7601u/usb.c
index cc772045d526..d9a93d05f1cf 100644
--- a/drivers/net/wireless/mediatek/mt7601u/usb.c
+++ b/drivers/net/wireless/mediatek/mt7601u/usb.c
@@ -332,6 +332,7 @@ static void mt7601u_disconnect(struct usb_interface *usb_intf)
 
 	ieee80211_unregister_hw(dev->hw);
 	mt7601u_cleanup(dev);
+	mt7601u_remove_debugfs(dev);
 
 	usb_set_intfdata(usb_intf, NULL);
 	usb_put_dev(interface_to_usbdev(usb_intf));
-- 
2.34.1

