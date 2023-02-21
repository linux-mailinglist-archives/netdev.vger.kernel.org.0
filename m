Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249FF69E006
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 13:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbjBUMPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 07:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbjBUMPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 07:15:04 -0500
X-Greylist: delayed 1247 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 21 Feb 2023 04:14:35 PST
Received: from isilmar-4.linta.de (isilmar-4.linta.de [136.243.71.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7DFE265A8;
        Tue, 21 Feb 2023 04:14:33 -0800 (PST)
Received: from isilmar-4.linta.de (isilmar.linta [10.0.0.1])
        by isilmar-4.linta.de (Postfix) with ESMTP id 41B8F2014EC;
        Tue, 21 Feb 2023 11:37:28 +0000 (UTC)
Date:   Tue, 21 Feb 2023 12:37:08 +0100
From:   Helmut Grohne <helmut@subdivi.de>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        linux-wireless@vger.kernel.org,
        Stuart Hayhurst <stuart.a.hayhurst@gmail.com>
Cc:     Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Deren Wu <deren.wu@mediatek.com>, netdev@vger.kernel.org,
        1029116@bugs.debian.org
Subject: [PATCH] wifi: mt76: mt7921: correctly handle removal in the absence
 of firmware
Message-ID: <Y/Ss5LYSYG2M7jSq@alf.mars>
Mail-Followup-To: Helmut Grohne <helmut@subdivi.de>,
        Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>, linux-wireless@vger.kernel.org,
        Stuart Hayhurst <stuart.a.hayhurst@gmail.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Deren Wu <deren.wu@mediatek.com>, netdev@vger.kernel.org,
        1029116@bugs.debian.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Trying to probe a mt7921e pci card without firmware results in a
successful probe where ieee80211_register_hw hasn't been called. When
removing the driver, ieee802111_unregister_hw is called unconditionally
leading to a kernel NULL pointer dereference among other things.

As with other drivers that delay registration after probe, we track the
registration state in a flag variable and conidtionalize deregistration.

Link: https://bugs.debian.org/1029116
Link: https://bugs.kali.org/view.php?id=8140
Reported-by: Stuart Hayhurst <stuart.a.hayhurst@gmail.com>
Fixes: 1c71e03afe4b ("mt76: mt7921: move mt7921_init_hw in a dedicated work")
Signed-off-by: Helmut Grohne <helmut@freexian.com>
Cc: stable@vger.kernel.org
Sponsored-by: Freexian and Offensive Security
---
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   | 1 +
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h | 1 +
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt7921/sdio.c   | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c    | 3 ++-
 5 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index 542dfd425129..d5438212d5ff 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -315,6 +315,7 @@ static void mt7921_init_work(struct work_struct *work)
 		dev_err(dev->mt76.dev, "register device failed\n");
 		return;
 	}
+	dev->hw_registered = true;
 
 	ret = mt7921_init_debugfs(dev);
 	if (ret) {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index 15d6b7fe1c6c..e3b5d8ebf243 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -288,6 +288,7 @@ struct mt7921_dev {
 	bool hw_full_reset:1;
 	bool hw_init_done:1;
 	bool fw_assert:1;
+	bool hw_registered:1;
 
 	struct list_head sta_poll_list;
 	spinlock_t sta_poll_lock;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index cb72ded37256..1841eb7345dc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -110,7 +110,8 @@ static void mt7921e_unregister_device(struct mt7921_dev *dev)
 	struct mt76_connac_pm *pm = &dev->pm;
 
 	cancel_work_sync(&dev->init_work);
-	mt76_unregister_device(&dev->mt76);
+	if (dev->hw_registered)
+		mt76_unregister_device(&dev->mt76);
 	mt76_for_each_q_rx(&dev->mt76, i)
 		napi_disable(&dev->mt76.napi[i]);
 	cancel_delayed_work_sync(&pm->ps_work);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c b/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
index 8ce4252b8ae7..23a9dd3c6450 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
@@ -43,7 +43,8 @@ static void mt7921s_unregister_device(struct mt7921_dev *dev)
 	struct mt76_connac_pm *pm = &dev->pm;
 
 	cancel_work_sync(&dev->init_work);
-	mt76_unregister_device(&dev->mt76);
+	if (dev->hw_registered)
+		mt76_unregister_device(&dev->mt76);
 	cancel_delayed_work_sync(&pm->ps_work);
 	cancel_work_sync(&pm->wake_work);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
index 5321d20dcdcb..e55e1b50f760 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
@@ -301,7 +301,8 @@ static void mt7921u_disconnect(struct usb_interface *usb_intf)
 	if (!test_bit(MT76_STATE_INITIALIZED, &dev->mphy.state))
 		return;
 
-	mt76_unregister_device(&dev->mt76);
+	if (dev->hw_registered)
+		mt76_unregister_device(&dev->mt76);
 	mt7921u_cleanup(dev);
 
 	usb_set_intfdata(usb_intf, NULL);
-- 
2.39.0


