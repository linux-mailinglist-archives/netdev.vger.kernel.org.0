Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86ACE66ACC9
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 18:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjANRCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 12:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbjANRCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 12:02:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7405A5E9
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 09:02:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 509D8B80A08
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 17:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768A4C43398;
        Sat, 14 Jan 2023 17:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673715718;
        bh=A12fmAkynm8mYZXaVJfdQDYz63GTBX01zHiZRV30ORA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=em0pkWolClwP4Htgd+zsljhyP+moaJaKgcoU7uYLIuxAGq3EjpKxWm0f+3h1TpN+M
         5sQkSOZ8s5SwGujV7HprFMqTfXdEK7HADi60l97VB2RfTBY5wPC+gsWvIqWQJg2J+C
         pgAcdjrEMuOY8n5IedK9gYS+JDMt+mVbEaUUL9sahCjSQPKMYCeyIrzTKA1uTPaNNv
         BtKso1C1MmY6mJzJo0r/cOhz37/NGKtCWreBuC9NZDQuk7K1JK2UUd88z29KGSoEgj
         KN9ntpBVlarj1NWTtdJEu7ggLuxaLgNSeI3cGqu0Uvh5WxhXYpgJz08Qj6b+Fu07Ru
         GKjq6QgKHVOyw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com, daniel@makrotopia.org, leon@kernel.org,
        alexander.duyck@gmail.com
Subject: [PATCH v6 net-next 5/5] net: ethernet: mtk_wed: add reset/reset_complete callbacks
Date:   Sat, 14 Jan 2023 18:01:32 +0100
Message-Id: <db70e7117c34ff2f91f937f015371d455bfe8b2d.1673715298.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1673715298.git.lorenzo@kernel.org>
References: <cover.1673715298.git.lorenzo@kernel.org>
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

Introduce reset and reset_complete wlan callback to schedule WLAN driver
reset when ethernet/wed driver is resetting.

Tested-by: Daniel Golle <daniel@makrotopia.org>
Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
reset and reset_complete callbacks are implemented in the following
mt76 wireless driver series:
https://lore.kernel.org/linux-wireless/cover.1673103214.git.lorenzo@kernel.org/T/#md34b4ffcb07056794378fa4e8079458ecca69109
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c |  7 ++++
 drivers/net/ethernet/mediatek/mtk_wed.c     | 42 +++++++++++++++++++++
 drivers/net/ethernet/mediatek/mtk_wed.h     |  9 +++++
 include/linux/soc/mediatek/mtk_wed.h        |  2 +
 4 files changed, 60 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 5d398595ead0..75bbb1e7766c 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3970,6 +3970,11 @@ static void mtk_pending_work(struct work_struct *work)
 	set_bit(MTK_RESETTING, &eth->state);
 
 	mtk_prepare_for_reset(eth);
+	mtk_wed_fe_reset();
+	/* Run again reset preliminary configuration in order to avoid any
+	 * possible race during FE reset since it can run releasing RTNL lock.
+	 */
+	mtk_prepare_for_reset(eth);
 
 	/* stop all devices to make sure that dma is properly shut down */
 	for (i = 0; i < MTK_MAC_COUNT; i++) {
@@ -4007,6 +4012,8 @@ static void mtk_pending_work(struct work_struct *work)
 
 	clear_bit(MTK_RESETTING, &eth->state);
 
+	mtk_wed_fe_reset_complete();
+
 	rtnl_unlock();
 }
 
diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index a6271449617f..95ac4f71d2b2 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -206,6 +206,48 @@ mtk_wed_wo_reset(struct mtk_wed_device *dev)
 	iounmap(reg);
 }
 
+void mtk_wed_fe_reset(void)
+{
+	int i;
+
+	mutex_lock(&hw_lock);
+
+	for (i = 0; i < ARRAY_SIZE(hw_list); i++) {
+		struct mtk_wed_hw *hw = hw_list[i];
+		struct mtk_wed_device *dev = hw->wed_dev;
+		int err;
+
+		if (!dev || !dev->wlan.reset)
+			continue;
+
+		/* reset callback blocks until WLAN reset is completed */
+		err = dev->wlan.reset(dev);
+		if (err)
+			dev_err(dev->dev, "wlan reset failed: %d\n", err);
+	}
+
+	mutex_unlock(&hw_lock);
+}
+
+void mtk_wed_fe_reset_complete(void)
+{
+	int i;
+
+	mutex_lock(&hw_lock);
+
+	for (i = 0; i < ARRAY_SIZE(hw_list); i++) {
+		struct mtk_wed_hw *hw = hw_list[i];
+		struct mtk_wed_device *dev = hw->wed_dev;
+
+		if (!dev || !dev->wlan.reset_complete)
+			continue;
+
+		dev->wlan.reset_complete(dev);
+	}
+
+	mutex_unlock(&hw_lock);
+}
+
 static struct mtk_wed_hw *
 mtk_wed_assign(struct mtk_wed_device *dev)
 {
diff --git a/drivers/net/ethernet/mediatek/mtk_wed.h b/drivers/net/ethernet/mediatek/mtk_wed.h
index e012b8a82133..43ab77eaf683 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.h
+++ b/drivers/net/ethernet/mediatek/mtk_wed.h
@@ -128,6 +128,8 @@ void mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
 void mtk_wed_exit(void);
 int mtk_wed_flow_add(int index);
 void mtk_wed_flow_remove(int index);
+void mtk_wed_fe_reset(void);
+void mtk_wed_fe_reset_complete(void);
 #else
 static inline void
 mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
@@ -147,6 +149,13 @@ static inline void mtk_wed_flow_remove(int index)
 {
 }
 
+static inline void mtk_wed_fe_reset(void)
+{
+}
+
+static inline void mtk_wed_fe_reset_complete(void)
+{
+}
 #endif
 
 #ifdef CONFIG_DEBUG_FS
diff --git a/include/linux/soc/mediatek/mtk_wed.h b/include/linux/soc/mediatek/mtk_wed.h
index db637a13888d..fd0b0605cf90 100644
--- a/include/linux/soc/mediatek/mtk_wed.h
+++ b/include/linux/soc/mediatek/mtk_wed.h
@@ -150,6 +150,8 @@ struct mtk_wed_device {
 		void (*release_rx_buf)(struct mtk_wed_device *wed);
 		void (*update_wo_rx_stats)(struct mtk_wed_device *wed,
 					   struct mtk_wed_wo_rx_stats *stats);
+		int (*reset)(struct mtk_wed_device *wed);
+		void (*reset_complete)(struct mtk_wed_device *wed);
 	} wlan;
 #endif
 };
-- 
2.39.0

