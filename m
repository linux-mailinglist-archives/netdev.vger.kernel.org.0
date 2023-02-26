Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4DFE6A31A3
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 16:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbjBZPBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 10:01:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbjBZPAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 10:00:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6E512061;
        Sun, 26 Feb 2023 06:52:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 185B8B80C01;
        Sun, 26 Feb 2023 14:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83D2C433A1;
        Sun, 26 Feb 2023 14:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677423164;
        bh=oRiPa8n04oqI02/LEnJkkmeg9no7ncS6yvc8BZx1EhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wtrf85GRF7OT14hqS/gKneweNo9rkkVEybF1wSEA2aYrmmPXqFamQ4zRD+0Sjn8Ym
         amukr1gqVH2coCQ2HsBfyPgoroDvmzz2gED5LkHxX/jNxyw5XXAyKiHgZ7PCnZOv5E
         NP3Ggq7qiLFwNbuRnB2R1tcCGqZRIlXryvOPusd7sMX2UD2V0TuizmWj+8H1Sg3ZIL
         nt8vtbhER7Xdg2ErXyUlWqL+JMZnnP1aQxOOFudttLilgmznvmPxTtjBcDWGxmzT2z
         uEeIG9ziTIdGDSMTAJtrVvZaeGfivBt86PzWW7x7nabG7DmvKQgEryIzQhbh1sQfHO
         jOfk8k8kAgP5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, opendmb@gmail.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 10/13] net: bcmgenet: Add a check for oversized packets
Date:   Sun, 26 Feb 2023 09:52:12 -0500
Message-Id: <20230226145217.829485-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226145217.829485-1-sashal@kernel.org>
References: <20230226145217.829485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 5c0862c2c962052ed5055220a00ac1cefb92fbcd ]

Occasionnaly we may get oversized packets from the hardware which
exceed the nomimal 2KiB buffer size we allocate SKBs with. Add an early
check which drops the packet to avoid invoking skb_over_panic() and move
on to processing the next packet.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 96ef2dd46c78c..84bcb3ce00f73 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1825,6 +1825,14 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
 			  __func__, p_index, ring->c_index,
 			  ring->read_ptr, dma_length_status);
 
+		if (unlikely(len > RX_BUF_LENGTH)) {
+			netif_err(priv, rx_status, dev, "oversized packet\n");
+			dev->stats.rx_length_errors++;
+			dev->stats.rx_errors++;
+			dev_kfree_skb_any(skb);
+			goto next;
+		}
+
 		if (unlikely(!(dma_flag & DMA_EOP) || !(dma_flag & DMA_SOP))) {
 			netif_err(priv, rx_status, dev,
 				  "dropping fragmented packet!\n");
-- 
2.39.0

