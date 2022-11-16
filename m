Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAEA162CF41
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 00:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbiKPX7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 18:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbiKPX7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 18:59:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88CA5E3C8
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 15:59:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23D95B81F5C
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 23:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACBBC433C1;
        Wed, 16 Nov 2022 23:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668643145;
        bh=hThUd1GyWe3hYx90sSG2VxwSCyJ5SkWCRJMBTXNFq/Y=;
        h=From:To:Cc:Subject:Date:From;
        b=e6xkQZbpuz0K8xmGfuUkS+yOJmVNs3c54EgAYrL7G9CmskPijaLwGN9k19I39U0Ii
         9p82GSkm5axFdRTLOjUba/LbNwoB7Xpz3dvjy6+spc/oDJE5E4kjUx4sQ8Xh764XUL
         Zx9xMfTR0V/MiwjFI9izb8+esj4XN3sKzAcyil73bbVlo/6PhEzHkHUNvIYFBFjpjk
         JsNgWERT7dHKnCi7asm8/ng/hAV8sCDMH4ltcQjx4I4ImXEViBeTzT5d0D6UoIrO1R
         NlEUVvS9dT0IbFqv7DieN5KhZ5AbUn7J3HmRj2JLcinkdDGwx/j1bmGKMwnmZLLmjq
         1dJsbXAnLlyqA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com
Subject: [PATCH net-next] net: ethernet: mtk_eth_soc: remove cpu_relax in mtk_pending_work
Date:   Thu, 17 Nov 2022 00:58:46 +0100
Message-Id: <8374a9cdebb9d8056aaa41f218279d373cb69165.1668643071.git.lorenzo@kernel.org>
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

Get rid of cpu_relax in mtk_pending_work routine since MTK_RESETTING is
set only in mtk_pending_work() and it runs holding rtnl lock

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index f3a03d6f1a92..cdc0ff596196 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3546,11 +3546,8 @@ static void mtk_pending_work(struct work_struct *work)
 	rtnl_lock();
 
 	dev_dbg(eth->dev, "[%s][%d] reset\n", __func__, __LINE__);
+	set_bit(MTK_RESETTING, &eth->state);
 
-	while (test_and_set_bit_lock(MTK_RESETTING, &eth->state))
-		cpu_relax();
-
-	dev_dbg(eth->dev, "[%s][%d] mtk_stop starts\n", __func__, __LINE__);
 	/* stop all devices to make sure that dma is properly shut down */
 	for (i = 0; i < MTK_MAC_COUNT; i++) {
 		if (!eth->netdev[i])
@@ -3584,7 +3581,7 @@ static void mtk_pending_work(struct work_struct *work)
 
 	dev_dbg(eth->dev, "[%s][%d] reset done\n", __func__, __LINE__);
 
-	clear_bit_unlock(MTK_RESETTING, &eth->state);
+	clear_bit(MTK_RESETTING, &eth->state);
 
 	rtnl_unlock();
 }
-- 
2.38.1

