Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3DF660F9F
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 15:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbjAGOvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 09:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbjAGOvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 09:51:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C98B3D5F0
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 06:51:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28ABE60C28
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 14:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BBCAC433EF;
        Sat,  7 Jan 2023 14:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673103099;
        bh=wnYkSDcAfPv2sCUy/poGWGWDYvZ1IVymWkFhcUr26+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i52kOtyxTXFukEM4LTqmxNMhoxcNakzWDJgjPS0V6B4S5UMKcAVlu5iC+Z0DcA55T
         9tzQQsJNBo/KgGF3s69n8UDEQMM+1UC19ZfiaBIa+owXm3k8gwrZ/WYfu+6JE8VtD/
         cVHDLceKFwVbBZNZ2qQf2ScinCk6Z25CkTTCLjKdfF8mcFAIFjgys/96g2Vz9HkTSI
         NxqcD0UJ5+1tqVM2W6bu4ILyYYd9SqTzlY8DpZaJjzRGqOO2lv+/BqQM/7U4FVcWIi
         Y0P2wTLf+X1iQaFNXXDIYStH+jNhEalzJmacsMvvbAAZKruO7FaXsEB/1ofiUSxi/7
         tovLJjYie7NTg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com, daniel@makrotopia.org, leon@kernel.org
Subject: [PATCH v3 net-next 5/5] net: ethernet: mtk_wed: add reset/reset_complete callbacks
Date:   Sat,  7 Jan 2023 15:50:54 +0100
Message-Id: <c77e5e97296ab6433b0995f6773a250762dcab67.1673102767.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1673102767.git.lorenzo@kernel.org>
References: <cover.1673102767.git.lorenzo@kernel.org>
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
 drivers/net/ethernet/mediatek/mtk_eth_soc.c |  7 ++++
 drivers/net/ethernet/mediatek/mtk_wed.c     | 40 +++++++++++++++++++++
 drivers/net/ethernet/mediatek/mtk_wed.h     |  8 +++++
 include/linux/soc/mediatek/mtk_wed.h        |  2 ++
 4 files changed, 57 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index f38a2f5a7d1e..6f10887b6ff5 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3923,6 +3923,11 @@ static void mtk_pending_work(struct work_struct *work)
 	set_bit(MTK_RESETTING, &eth->state);
 
 	mtk_prepare_for_reset(eth);
+	mtk_wed_fe_reset();
+	/* Run again reset preliminary configuration in order to avoid any
+	 * possible race during FE reset since it can run releasing RTNL lock.
+	 */
+	mtk_prepare_for_reset(eth);
 
 	/* stop all devices to make sure that dma is properly shut down */
 	for (i = 0; i < MTK_MAC_COUNT; i++) {
@@ -3960,6 +3965,8 @@ static void mtk_pending_work(struct work_struct *work)
 
 	clear_bit(MTK_RESETTING, &eth->state);
 
+	mtk_wed_fe_reset_complete();
+
 	rtnl_unlock();
 }
 
diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index a6271449617f..4854993f2941 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -206,6 +206,46 @@ mtk_wed_wo_reset(struct mtk_wed_device *dev)
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
+
+		if (!dev || !dev->wlan.reset)
+			continue;
+
+		/* reset callback blocks until WLAN reset is completed */
+		if (dev->wlan.reset(dev))
+			dev_err(dev->dev, "wlan reset failed\n");
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
index e012b8a82133..6108a7e69a80 100644
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
@@ -146,6 +148,12 @@ static inline int mtk_wed_flow_add(int index)
 static inline void mtk_wed_flow_remove(int index)
 {
 }
+static inline void mtk_wed_fe_reset(void)
+{
+}
+static inline void mtk_wed_fe_reset_complete(void)
+{
+}
 
 #endif
 
diff --git a/include/linux/soc/mediatek/mtk_wed.h b/include/linux/soc/mediatek/mtk_wed.h
index db637a13888d..ddff54fc9717 100644
--- a/include/linux/soc/mediatek/mtk_wed.h
+++ b/include/linux/soc/mediatek/mtk_wed.h
@@ -150,6 +150,8 @@ struct mtk_wed_device {
 		void (*release_rx_buf)(struct mtk_wed_device *wed);
 		void (*update_wo_rx_stats)(struct mtk_wed_device *wed,
 					   struct mtk_wed_wo_rx_stats *stats);
+		int (*reset)(struct mtk_wed_device *wed);
+		int (*reset_complete)(struct mtk_wed_device *wed);
 	} wlan;
 #endif
 };
-- 
2.39.0

