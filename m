Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5536645C0D
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbiLGOIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbiLGOGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:06:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72A018B31
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 06:05:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DC15B81B90
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 14:05:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3ABC433C1;
        Wed,  7 Dec 2022 14:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670421938;
        bh=sRaak4KLeCok7dS29659RMJxhIRUiWs94IOmcA+/uIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CqQ7bQNh5/D/kXndvbEeFCOeu36ZFkIWH3EF5Tj8kSR8+zqgDsz2RX004OgTgOZ7E
         6n7yvTBECDl3wGu1SH28FQJEC1IlZXOSGHasY3hLSzHI1aSHPFScQuAuu6LUI7gEw4
         KT/9Gm4WkxGAtTCMCm0TT/ZTDLft7UUJpZG79L+qX5i3HSUQLrpcaqmCA7cWPj1mt0
         yM4ce/VtFomWtZg5oO/QDPo5p6vsinnHHGrAqYCia8AuHG4GQkdhST1O23em/tXiXg
         1OU+mSv2ORwiV01Hj5N8zlppIPnLjG+pXYUi9CS+8SgBDuihtng30dakx1siWpwL5h
         iUqFVcdVmnGHQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        leon@kernel.org, sujuan.chen@mediatek.com
Subject: [PATCH v3 net-next 2/2] net: ethernet: mtk_wed: fix possible deadlock if mtk_wed_wo_init fails
Date:   Wed,  7 Dec 2022 15:04:55 +0100
Message-Id: <b28b55a639002a56b77c0651a4122ebede041936.1670421354.git.lorenzo@kernel.org>
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

Introduce __mtk_wed_detach() in order to avoid a deadlock in
mtk_wed_attach routine if mtk_wed_wo_init fails since both
mtk_wed_attach and mtk_wed_detach run holding hw_lock mutex.

Fixes: 4c5de09eb0d0 ("net: ethernet: mtk_wed: add configure wed wo support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 4ef23eadd69e..a6271449617f 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -577,12 +577,10 @@ mtk_wed_deinit(struct mtk_wed_device *dev)
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
@@ -615,6 +613,13 @@ mtk_wed_detach(struct mtk_wed_device *dev)
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
 
@@ -1497,8 +1502,10 @@ mtk_wed_attach(struct mtk_wed_device *dev)
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
 
-- 
2.38.1

