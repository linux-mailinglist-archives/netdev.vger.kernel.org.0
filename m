Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3517640C46
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 18:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbiLBRgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 12:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234178AbiLBRgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 12:36:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36E7E802F
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 09:36:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C3876235C
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 17:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A982C433C1;
        Fri,  2 Dec 2022 17:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670002601;
        bh=z5uh3mVduXvQ/zp3qCGCz5kpqopsyvlxan0NUFQRRa0=;
        h=From:To:Cc:Subject:Date:From;
        b=U0X7JI7aU8zvtbQNpSMQAiuMd2dn9630cWISy8kwZVjYdQ6y5T/ymK85OmC0UNsR1
         aZ9iHUVcoVfEv3w+zzmtz2HrhRZ+dEYZKS6xWw//IvK1HGR86QGjyByEhbVUfESYPe
         pWxTBbPPSZxbnxmp82b3/z+If0W1/LQqZj+UzGJ+EacFlh/WLxvoj2NfEALBbdwuky
         nlk2+05pLYhHXlVcH9gECSoQXyMPXre+1jj9cflDL4z4YQvyPnDghb94Cm14T6ukGe
         KSgzV1AvXS0prLNQpYkJVeEV9m1AGSAJwESqzHdSiP+CCCZQ5mxh1dHK4Zf9W9vUnE
         kDL90ltajjirg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com
Subject: [PATCH net-next] net: ethernet: mtk_wed: fix possible deadlock if mtk_wed_wo_init fails
Date:   Fri,  2 Dec 2022 18:36:33 +0100
Message-Id: <a87f05e60ea1a94b571c9c87b69cc5b0e94943f2.1669999089.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
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

Introduce __mtk_wed_detach() in order to avoid a possible deadlock in
mtk_wed_attach routine if mtk_wed_wo_init fails.

Fixes: 4c5de09eb0d0 ("net: ethernet: mtk_wed: add configure wed wo support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c     | 24 ++++++++++++++-------
 drivers/net/ethernet/mediatek/mtk_wed_mcu.c | 10 ++++++---
 drivers/net/ethernet/mediatek/mtk_wed_wo.c  |  3 +++
 3 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index d041615b2bac..6352abd4157e 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -174,9 +174,10 @@ mtk_wed_wo_reset(struct mtk_wed_device *dev)
 	mtk_wdma_tx_reset(dev);
 	mtk_wed_reset(dev, MTK_WED_RESET_WED);
 
-	mtk_wed_mcu_send_msg(wo, MTK_WED_MODULE_ID_WO,
-			     MTK_WED_WO_CMD_CHANGE_STATE, &state,
-			     sizeof(state), false);
+	if (mtk_wed_mcu_send_msg(wo, MTK_WED_MODULE_ID_WO,
+				 MTK_WED_WO_CMD_CHANGE_STATE, &state,
+				 sizeof(state), false))
+		return;
 
 	if (readx_poll_timeout(mtk_wed_wo_read_status, dev, val,
 			       val == MTK_WED_WOIF_DISABLE_DONE,
@@ -576,12 +577,10 @@ mtk_wed_deinit(struct mtk_wed_device *dev)
 }
 
 static void
-mtk_wed_detach(struct mtk_wed_device *dev)
+__mtk_wed_detach(struct mtk_wed_device *dev)
 {
 	struct mtk_wed_hw *hw = dev->hw;
 
-	mutex_lock(&hw_lock);
-
 	mtk_wed_deinit(dev);
 
 	mtk_wdma_rx_reset(dev);
@@ -612,6 +611,13 @@ mtk_wed_detach(struct mtk_wed_device *dev)
 	module_put(THIS_MODULE);
 
 	hw->wed_dev = NULL;
+}
+
+static void
+mtk_wed_detach(struct mtk_wed_device *dev)
+{
+	mutex_lock(&hw_lock);
+	__mtk_wed_detach(dev);
 	mutex_unlock(&hw_lock);
 }
 
@@ -1490,8 +1496,10 @@ mtk_wed_attach(struct mtk_wed_device *dev)
 		ret = mtk_wed_wo_init(hw);
 	}
 out:
-	if (ret)
-		mtk_wed_detach(dev);
+	if (ret) {
+		dev_err(dev->hw->dev, "failed to attach wed device\n");
+		__mtk_wed_detach(dev);
+	}
 unlock:
 	mutex_unlock(&hw_lock);
 
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
index f9539e6233c9..b084009a32f9 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
@@ -176,6 +176,9 @@ int mtk_wed_mcu_send_msg(struct mtk_wed_wo *wo, int id, int cmd,
 	u16 seq;
 	int ret;
 
+	if (!wo)
+		return -ENODEV;
+
 	skb = mtk_wed_mcu_msg_alloc(data, len);
 	if (!skb)
 		return -ENOMEM;
@@ -202,13 +205,14 @@ int mtk_wed_mcu_send_msg(struct mtk_wed_wo *wo, int id, int cmd,
 int mtk_wed_mcu_msg_update(struct mtk_wed_device *dev, int id, void *data,
 			   int len)
 {
-	struct mtk_wed_wo *wo = dev->hw->wed_wo;
+	if (!dev->hw || !dev->hw->wed_wo)
+		return 0;
 
 	if (dev->hw->version == 1)
 		return 0;
 
-	return mtk_wed_mcu_send_msg(wo, MTK_WED_MODULE_ID_WO, id, data, len,
-				    true);
+	return mtk_wed_mcu_send_msg(dev->hw->wed_wo, MTK_WED_MODULE_ID_WO, id,
+				    data, len, true);
 }
 
 static int
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_wo.c b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
index a219da85f4db..92440d62e01c 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_wo.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
@@ -464,6 +464,9 @@ mtk_wed_wo_hardware_init(struct mtk_wed_wo *wo)
 static void
 mtk_wed_wo_hw_deinit(struct mtk_wed_wo *wo)
 {
+	if (!wo)
+		return;
+
 	/* disable interrupts */
 	mtk_wed_wo_set_isr(wo, 0);
 
-- 
2.38.1

