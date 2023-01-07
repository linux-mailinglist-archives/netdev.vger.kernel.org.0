Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFB3660FBE
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 16:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbjAGPBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 10:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbjAGPBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 10:01:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D5F41657;
        Sat,  7 Jan 2023 07:01:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5ECBC60C23;
        Sat,  7 Jan 2023 15:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC3BC433EF;
        Sat,  7 Jan 2023 15:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673103675;
        bh=jOq3HAgMjaj1SFCSBHKjYOyCtvfDE2riyu3cWxH+X7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h36/BbOexF8lH31I6phb+fEO8vmXUX0AkHvP+tgSJQo6226yJPnfW3hfY4S8qdX73
         wdGg/0l89MLnn1+ubafmNfvn/f4/zpN3kF5ka4vj7bE77jZAL4mcWTiKVzmxoVSjGP
         NNvLifN6mblwB8URCc5hni1eAqBJP2Mlu6blYN3RPki0JbFHYcdTUPzmSA1oPD5ROk
         pXQUr1tJRERoT0MQ/c2KvydxAdc9oMQdHcxYGq4xFA45dghm5RsakzANNnbt9yOru2
         k62CMyr1jhcsnNsuLbp1sepp9/90fnS0eWZNxhD/jZqx9XPHdt6ZfpidH9PuJVkEzr
         NpZPsJ9qQQFZw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com, nbd@nbd.name,
        sujuan.chen@mediatek.com, daniel@makrotopia.org, leon@kernel.org
Subject: [PATCH 2/4] wifi: mt76: dma: reset wed queues in mt76_dma_rx_reset
Date:   Sat,  7 Jan 2023 16:00:37 +0100
Message-Id: <780d576a44c7f241886aaf8b3dd5eb51a879dfcd.1673103214.git.lorenzo@kernel.org>
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

From: Sujuan Chen <sujuan.chen@mediatek.com>

This is a preliminary patch to introduce proper wed reset support.

Tested-by: Daniel Golle <daniel@makrotopia.org>
Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 5629b949fac0..93c42082f1c2 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -766,8 +766,13 @@ mt76_dma_rx_reset(struct mt76_dev *dev, enum mt76_rxq_id qid)
 		q->desc[i].ctrl = cpu_to_le32(MT_DMA_CTL_DMA_DONE);
 
 	mt76_dma_rx_cleanup(dev, q);
-	mt76_dma_sync_idx(dev, q);
-	mt76_dma_rx_fill(dev, q, false);
+
+	/* reset WED rx queues */
+	mt76_dma_wed_setup(dev, q, true);
+	if (q->flags != MT_WED_Q_TXFREE) {
+		mt76_dma_sync_idx(dev, q);
+		mt76_dma_rx_fill(dev, q, false);
+	}
 }
 
 static void
-- 
2.39.0

