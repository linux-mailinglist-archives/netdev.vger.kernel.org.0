Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E96507836
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 20:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356914AbiDSSYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 14:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357503AbiDSSX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 14:23:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56984443C7;
        Tue, 19 Apr 2022 11:16:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D373CB818EE;
        Tue, 19 Apr 2022 18:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B1CC385AB;
        Tue, 19 Apr 2022 18:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392180;
        bh=0ezynSW+qWhDxjKoqYRKJ3NXElJ577uMaunC0bZhw34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KFH+UGq7J+yTv2aIeE4QvwmHTXRWJpo771OuicinkHQ9AlYY0yC4d8LqG+BP0jq1h
         mf6bEWod2DvlGzqKnASuIVYRVKvs9AOOTuak6BTGVwyD4NMwcl0vtV1iv73xwBcrr4
         oXOu0QmGaMd86i7rYwng4XoWTDyXI2Utbm1I7mKvf4SEJn32tU0JPWCmdKnykhhXJr
         HGNpm32gzEASE81S3nv363BZBIE0maKXPXz+hxQTI433AWjXFQn4XkMOrjct8mUxw/
         ymVG0FG4cZ3VfEm27p68XMe3hJb9Q5XRHYJ2Cj06DOm0kUUr5OpkUGKHwZ2FY5FNp8
         QpJpF0G8HouDQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomas Melin <tomas.melin@vaisala.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, nicolas.ferre@microchip.com,
        davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 8/9] net: macb: Restart tx only if queue pointer is lagging
Date:   Tue, 19 Apr 2022 14:15:56 -0400
Message-Id: <20220419181557.486336-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181557.486336-1-sashal@kernel.org>
References: <20220419181557.486336-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tomas Melin <tomas.melin@vaisala.com>

[ Upstream commit 5ad7f18cd82cee8e773d40cc7a1465a526f2615c ]

commit 4298388574da ("net: macb: restart tx after tx used bit read")
added support for restarting transmission. Restarting tx does not work
in case controller asserts TXUBR interrupt and TQBP is already at the end
of the tx queue. In that situation, restarting tx will immediately cause
assertion of another TXUBR interrupt. The driver will end up in an infinite
interrupt loop which it cannot break out of.

For cases where TQBP is at the end of the tx queue, instead
only clear TX_USED interrupt. As more data gets pushed to the queue,
transmission will resume.

This issue was observed on a Xilinx Zynq-7000 based board.
During stress test of the network interface,
driver would get stuck on interrupt loop within seconds or minutes
causing CPU to stall.

Signed-off-by: Tomas Melin <tomas.melin@vaisala.com>
Tested-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220407161659.14532-1-tomas.melin@vaisala.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 045ab0ec5ca2..456d84cbcc6b 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1265,6 +1265,7 @@ static void macb_tx_restart(struct macb_queue *queue)
 	unsigned int head = queue->tx_head;
 	unsigned int tail = queue->tx_tail;
 	struct macb *bp = queue->bp;
+	unsigned int head_idx, tbqp;
 
 	if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
 		queue_writel(queue, ISR, MACB_BIT(TXUBR));
@@ -1272,6 +1273,13 @@ static void macb_tx_restart(struct macb_queue *queue)
 	if (head == tail)
 		return;
 
+	tbqp = queue_readl(queue, TBQP) / macb_dma_desc_get_size(bp);
+	tbqp = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, tbqp));
+	head_idx = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, head));
+
+	if (tbqp == head_idx)
+		return;
+
 	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
 }
 
-- 
2.35.1

