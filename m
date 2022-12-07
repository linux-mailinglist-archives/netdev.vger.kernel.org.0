Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07D0A645C0E
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiLGOID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:08:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbiLGOGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:06:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDCB1741D
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 06:05:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9412FB81DF4
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 14:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9474C433D6;
        Wed,  7 Dec 2022 14:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670421934;
        bh=GG5jENoOtjfN3+1Bxj75xWFl4pB98t0IjO9qNgxLUdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lC9RGV8CzR9tP8WeOQLkLN+OtIk5nBlx5BjRS3fkuPJG+6ghtZ0KNDDpUZwSr3Yc2
         zABKA+xrkYbjRnETXL68H7dxeNbEq7zSF+iobRnJhorayC/wYtJirs3I74DdiUcqv4
         7geJeDyeAhmpI8zikb8UGv075lyUgZtIB9hknb9S1u4YXmKv2hBq5km/q9/3bBOW+j
         X5jhXkhPKD4oQpylZxs1SNgbbMO7Fv28dd2OBZJFj4BC+9iy1qNdQ3kXdbFXGTn8m5
         SV4l3Euw6G1UL4kSLWi3OfqNTW8Z/rlBag+AxOKbMngUW4F2/4uEJDeKZeet4ZwvMT
         1USXXRMiMZexQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        leon@kernel.org, sujuan.chen@mediatek.com
Subject: [PATCH v3 net-next 1/2] net: ethernet: mtk_wed: fix some possible NULL pointer dereferences
Date:   Wed,  7 Dec 2022 15:04:54 +0100
Message-Id: <44cba2491b6dd1a64d0e8099efbab836e6758490.1670421354.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670421354.git.lorenzo@kernel.org>
References: <cover.1670421354.git.lorenzo@kernel.org>
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

Fix possible NULL pointer dereference in mtk_wed_detach routine checking
wo pointer is properly allocated before running mtk_wed_wo_reset() and
mtk_wed_wo_deinit().
Even if it is just a theoretical issue at the moment check wo pointer is
not NULL in mtk_wed_mcu_msg_update.
Moreover, honor mtk_wed_mcu_send_msg return value in mtk_wed_wo_reset()

Fixes: 799684448e3e ("net: ethernet: mtk_wed: introduce wed wo support")
Fixes: 4c5de09eb0d0 ("net: ethernet: mtk_wed: add configure wed wo support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c     | 13 ++++++++-----
 drivers/net/ethernet/mediatek/mtk_wed_mcu.c |  3 +++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 06b6cc53fa02..4ef23eadd69e 100644
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
@@ -590,9 +591,11 @@ mtk_wed_detach(struct mtk_wed_device *dev)
 	mtk_wed_free_tx_rings(dev);
 
 	if (mtk_wed_get_rx_capa(dev)) {
-		mtk_wed_wo_reset(dev);
+		if (hw->wed_wo)
+			mtk_wed_wo_reset(dev);
 		mtk_wed_free_rx_rings(dev);
-		mtk_wed_wo_deinit(hw);
+		if (hw->wed_wo)
+			mtk_wed_wo_deinit(hw);
 	}
 
 	if (dev->wlan.bus_type == MTK_WED_BUS_PCIE) {
diff --git a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
index f9539e6233c9..6bad0d262f28 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
@@ -207,6 +207,9 @@ int mtk_wed_mcu_msg_update(struct mtk_wed_device *dev, int id, void *data,
 	if (dev->hw->version == 1)
 		return 0;
 
+	if (WARN_ON(!wo))
+		return -ENODEV;
+
 	return mtk_wed_mcu_send_msg(wo, MTK_WED_MODULE_ID_WO, id, data, len,
 				    true);
 }
-- 
2.38.1

