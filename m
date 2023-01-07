Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB5A660FB8
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 16:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbjAGPBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 10:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbjAGPBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 10:01:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC6D41657;
        Sat,  7 Jan 2023 07:01:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAE6260C28;
        Sat,  7 Jan 2023 15:01:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C7FC433EF;
        Sat,  7 Jan 2023 15:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673103679;
        bh=f9+/OXo5OcBsnHlOPA59pfXVLMT8hpDm1N4YQ7dZ+PQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CmBonqqsqcwczIjtKbKo508rtlJMgqQvBR49PgOn13+UunH3H03g0uZo6wTHwgE2U
         BFbcsB62bZenFnBFPdWuFuTOVO508XHWzPwjq3BJvKzzXMMzJAHkhkkVPu0h9U4GE0
         S4aKUNcpRuase/OmdnysiFGtfgXH5ws1CyAITRKYZtEMljm6VEnoGcp6zC/On6Nixu
         x2StR8FEe+ZnppMqSapdaL9mTujMQ1kXRKIB54iscZWQIxINdcGikdObfJxt9ol4Os
         f27Q00YawWRDo5283rp1QOHZpDWDLztBQCtQrwQvB62yGN5dn3IuexqdTWO7mR19wl
         fg0G8dg1QqV7w==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com, nbd@nbd.name,
        sujuan.chen@mediatek.com, daniel@makrotopia.org, leon@kernel.org
Subject: [PATCH 3/4] wifi: mt76: mt7915: add mt7915 wed reset callbacks
Date:   Sat,  7 Jan 2023 16:00:38 +0100
Message-Id: <bfbf57f578567c414eec069a687dd7fd26e90390.1673103214.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1673103214.git.lorenzo@kernel.org>
References: <cover.1673103214.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce mt7915_mmio_wed_reset_complete and
mt7915_mmio_wed_reset_complete callbacks and the related wait
queues in order to wait for wed reset completion during wlan reset.

Tested-by: Daniel Golle <daniel@makrotopia.org>
Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c      |  2 +
 drivers/net/wireless/mediatek/mt76/mt76.h     |  3 ++
 .../net/wireless/mediatek/mt76/mt7915/dma.c   | 15 +++++++
 .../net/wireless/mediatek/mt76/mt7915/mmio.c  | 42 +++++++++++++++++++
 4 files changed, 62 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 93c42082f1c2..714becbbefea 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -922,6 +922,8 @@ mt76_dma_init(struct mt76_dev *dev,
 	snprintf(dev->napi_dev.name, sizeof(dev->napi_dev.name), "%s",
 		 wiphy_name(dev->hw->wiphy));
 	dev->napi_dev.threaded = 1;
+	init_completion(&dev->mmio.wed_reset);
+	init_completion(&dev->mmio.wed_reset_complete);
 
 	mt76_for_each_q_rx(dev, i) {
 		netif_napi_add(&dev->napi_dev, &dev->napi[i], poll);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 9037780f9e88..8abc6ecd7b68 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -413,6 +413,7 @@ enum {
 	MT76_STATE_SUSPEND,
 	MT76_STATE_ROC,
 	MT76_STATE_PM,
+	MT76_STATE_WED_RESET,
 };
 
 struct mt76_hw_cap {
@@ -591,6 +592,8 @@ struct mt76_mmio {
 	u32 irqmask;
 
 	struct mtk_wed_device wed;
+	struct completion wed_reset;
+	struct completion wed_reset_complete;
 };
 
 struct mt76_rx_status {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/dma.c b/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
index e3fa064918bf..a956e2a0be4f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
@@ -559,6 +559,20 @@ int mt7915_dma_init(struct mt7915_dev *dev, struct mt7915_phy *phy2)
 	return 0;
 }
 
+static void mt7915_dma_wed_reset(struct mt7915_dev *dev)
+{
+	struct mt76_dev *mdev = &dev->mt76;
+
+	if (!test_bit(MT76_STATE_WED_RESET, &dev->mphy.state))
+		return;
+
+	complete(&mdev->mmio.wed_reset);
+
+	if (!wait_for_completion_timeout(&dev->mt76.mmio.wed_reset_complete,
+					 3 * HZ))
+		dev_err(dev->mt76.dev, "wed reset complete timeout\n");
+}
+
 int mt7915_dma_reset(struct mt7915_dev *dev, bool force)
 {
 	struct mt76_phy *mphy_ext = dev->mt76.phys[MT_BAND1];
@@ -582,6 +596,7 @@ int mt7915_dma_reset(struct mt7915_dev *dev, bool force)
 		mt7915_wfsys_reset(dev);
 
 	mt7915_dma_disable(dev, force);
+	mt7915_dma_wed_reset(dev);
 
 	/* reset hw queues */
 	for (i = 0; i < __MT_TXQ_MAX; i++) {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
index 76de0ca22c2a..cf2f66eaf3db 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
@@ -4,10 +4,12 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/rtnetlink.h>
 #include <linux/pci.h>
 
 #include "mt7915.h"
 #include "mac.h"
+#include "mcu.h"
 #include "../trace.h"
 #include "../dma.h"
 
@@ -695,6 +697,44 @@ static void mt7915_mmio_wed_update_rx_stats(struct mtk_wed_device *wed,
 
 	rcu_read_unlock();
 }
+
+static int mt7915_mmio_wed_reset(struct mtk_wed_device *wed)
+{
+	struct mt76_dev *mdev = container_of(wed, struct mt76_dev, mmio.wed);
+	struct mt7915_dev *dev = container_of(mdev, struct mt7915_dev, mt76);
+	struct mt76_phy *mphy = &dev->mphy;
+	int ret;
+
+	ASSERT_RTNL();
+
+	if (test_and_set_bit(MT76_STATE_WED_RESET, &mphy->state))
+		return -EBUSY;
+
+	ret = mt7915_mcu_set_ser(dev, SER_RECOVER, SER_SET_RECOVER_L1,
+				 mphy->band_idx);
+	if (ret)
+		goto out;
+
+	rtnl_unlock();
+	if (!wait_for_completion_timeout(&mdev->mmio.wed_reset, 20 * HZ)) {
+		dev_err(mdev->dev, "wed reset timeout\n");
+		ret = -ETIMEDOUT;
+	}
+	rtnl_lock();
+out:
+	clear_bit(MT76_STATE_WED_RESET, &mphy->state);
+
+	return ret;
+}
+
+static int mt7915_mmio_wed_reset_complete(struct mtk_wed_device *wed)
+{
+	struct mt76_dev *dev = container_of(wed, struct mt76_dev, mmio.wed);
+
+	complete(&dev->mmio.wed_reset_complete);
+
+	return 0;
+}
 #endif
 
 int mt7915_mmio_wed_init(struct mt7915_dev *dev, void *pdev_ptr,
@@ -777,6 +817,8 @@ int mt7915_mmio_wed_init(struct mt7915_dev *dev, void *pdev_ptr,
 	wed->wlan.init_rx_buf = mt7915_mmio_wed_init_rx_buf;
 	wed->wlan.release_rx_buf = mt7915_mmio_wed_release_rx_buf;
 	wed->wlan.update_wo_rx_stats = mt7915_mmio_wed_update_rx_stats;
+	wed->wlan.reset = mt7915_mmio_wed_reset;
+	wed->wlan.reset_complete = mt7915_mmio_wed_reset_complete;
 
 	dev->mt76.rx_token_size = wed->wlan.rx_npkt;
 
-- 
2.39.0

