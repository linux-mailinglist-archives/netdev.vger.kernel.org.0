Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE7A56A527
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 16:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235734AbiGGONG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 10:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235720AbiGGONF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 10:13:05 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8132ED5B;
        Thu,  7 Jul 2022 07:13:01 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id y141so19631578pfb.7;
        Thu, 07 Jul 2022 07:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FCyVXYq1xdDQVMoQArRZsE8B3vqMor88n/6u0SE9eE0=;
        b=g2X5CX7BTukkrE2RBmcSCFU1w2BHJIhhYvVMdalj2riqhOup1DHITVFdNll0Wv4RYc
         FnlCH+vjH6CzpNDOg20RLObpy98yqzTnvAIKbY4L3wSc1spx+b7E0nwgvI8evX+29j6+
         BFcKkxRvA9ARMMbLZM9NwyfIOhkPy3+byur05dvzyAyiSP98mP02GeAtkU67WhUy9g2u
         bv1MSESkuIAyRpSKTWaY7CocBR7Qc5gBN8Bf9CE3Kom3uYEdlicRPfqQm26A81Onla7y
         tR9tBpcXExh9EC0c991ZlR22i4voAKoJwXtBQjXHfheow8ULk+vKJK4R5DyfguajX28/
         PWZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FCyVXYq1xdDQVMoQArRZsE8B3vqMor88n/6u0SE9eE0=;
        b=MSLwLrtkpm4kJ8skgktR8CEjhstbtPXsEVMTAnDhS2R/XPT1cNnriqbe7+S14xzoAl
         MDUSjlq1nOSqU8iIdBL7ZQ17UY48CGXHlQI/EiGHpEiopu/pJKIhKZd9RVSvbvCYo3+P
         3HUFVb5oQDSjTwGb4SSCsoLv6no8WegsNkkTSTODUx7gLURTFfVJnOOmC3h2IBWM4Ljb
         W9o3ch/1Gj87kcFdDGQ4R65W6592KbCamo+sq7bocITBbC6YCZv0bB8gtGjw9QPHYsQE
         RQXI2Bs8Hy1McCSHoGCf0qYbI60K2kzxNcVFCRs7/TGRTNz+yLB7g2ADvmpluaEMGtpA
         oFuA==
X-Gm-Message-State: AJIora/dOrurzLhEkA9vPW4fU1f6VI6l77V3zdueperBoTVVG/JU+ASV
        7FH7nlfFeexLcw7YTMZT9Ss=
X-Google-Smtp-Source: AGRyM1u9xaQuiTFEYOzWDQDEXyLHiJYNlYML/aThQ9Oovo+1VlwROYrTIfWJ0ZkXVRWyNACfvJz+qg==
X-Received: by 2002:a17:902:ce05:b0:16c:2a1:c335 with SMTP id k5-20020a170902ce0500b0016c02a1c335mr9263405plg.5.1657203180777;
        Thu, 07 Jul 2022 07:13:00 -0700 (PDT)
Received: from DESKTOP-8REGVGF.localdomain ([60.51.50.62])
        by smtp.gmail.com with ESMTPSA id h7-20020a170902680700b0016bfbd99f64sm4447911plk.118.2022.07.07.07.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 07:13:00 -0700 (PDT)
From:   Sieng-Piaw Liew <liew.s.piaw@gmail.com>
To:     chris.snook@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Sieng-Piaw Liew <liew.s.piaw@gmail.com>
Subject: [PATCH net-next v2] net: ag71xx: switch to napi_build_skb() to reuse skbuff_heads
Date:   Thu,  7 Jul 2022 22:10:56 +0800
Message-Id: <20220707141056.2644-1-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220706195213.6b751af8@kernel.org>
References: <20220706195213.6b751af8@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

napi_build_skb() reuses NAPI skbuff_head cache in order to save some
cycles on freeing/allocating skbuff_heads on every new Rx or completed
Tx.
Use napi_consume_skb() to feed the cache with skbuff_heads of completed
Tx, so it's never empty. The budget parameter is added to indicate NAPI
context, as a value of zero can be passed in the case of netpoll.

Signed-off-by: Sieng-Piaw Liew <liew.s.piaw@gmail.com>
---
 drivers/net/ethernet/atheros/ag71xx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 1c6ea6766aa1..e461f4764066 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -786,7 +786,7 @@ static bool ag71xx_check_dma_stuck(struct ag71xx *ag)
 	return false;
 }
 
-static int ag71xx_tx_packets(struct ag71xx *ag, bool flush)
+static int ag71xx_tx_packets(struct ag71xx *ag, bool flush, int budget)
 {
 	struct ag71xx_ring *ring = &ag->tx_ring;
 	int sent = 0, bytes_compl = 0, n = 0;
@@ -825,7 +825,7 @@ static int ag71xx_tx_packets(struct ag71xx *ag, bool flush)
 		if (!skb)
 			continue;
 
-		dev_kfree_skb_any(skb);
+		napi_consume_skb(skb, budget);
 		ring->buf[i].tx.skb = NULL;
 
 		bytes_compl += ring->buf[i].tx.len;
@@ -970,7 +970,7 @@ static void ag71xx_fast_reset(struct ag71xx *ag)
 	mii_reg = ag71xx_rr(ag, AG71XX_REG_MII_CFG);
 	rx_ds = ag71xx_rr(ag, AG71XX_REG_RX_DESC);
 
-	ag71xx_tx_packets(ag, true);
+	ag71xx_tx_packets(ag, true, 0);
 
 	reset_control_assert(ag->mac_reset);
 	usleep_range(10, 20);
@@ -1657,7 +1657,7 @@ static int ag71xx_rx_packets(struct ag71xx *ag, int limit)
 		ndev->stats.rx_packets++;
 		ndev->stats.rx_bytes += pktlen;
 
-		skb = build_skb(ring->buf[i].rx.rx_buf, ag71xx_buffer_size(ag));
+		skb = napi_build_skb(ring->buf[i].rx.rx_buf, ag71xx_buffer_size(ag));
 		if (!skb) {
 			skb_free_frag(ring->buf[i].rx.rx_buf);
 			goto next;
@@ -1703,7 +1703,7 @@ static int ag71xx_poll(struct napi_struct *napi, int limit)
 	int tx_done, rx_done;
 	u32 status;
 
-	tx_done = ag71xx_tx_packets(ag, false);
+	tx_done = ag71xx_tx_packets(ag, false, limit);
 
 	netif_dbg(ag, rx_status, ndev, "processing RX ring\n");
 	rx_done = ag71xx_rx_packets(ag, limit);
-- 
2.17.1

