Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7956A507844
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 20:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356902AbiDSSYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 14:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357341AbiDSSXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 14:23:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884C33EF03;
        Tue, 19 Apr 2022 11:15:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E028861426;
        Tue, 19 Apr 2022 18:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC2AC385A7;
        Tue, 19 Apr 2022 18:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392153;
        bh=+Io3hLHcIRjPNqlAsc4Dro7jHI0gIfKz6QljcJbbR9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Skufuqq6M3QhB8HovGk4CTwr528/0CrUOGE1IqnV1edXN/ymAZfnrvkERcp0EG7JP
         rfifYX+4gQQBqqc70lVIMBe3hmqwD4Y1Z4Ne7oLEvyh9sER/UHIlWDIy9wzbIEoJaq
         PvtQE/IVh9TO+K4wuPzdJO7Mk68i1zhoprgxR/+AOurp+qElybM9iFtudgDSO0Oqlj
         YxAKV/cjd/IWAelNtHf2D7iWcPwtQJh+OXGr9DjfRwJ1G3dtiaoKVDr1Ok+g7vUqX9
         //afhZ2az9sdZK5ayzvaFsyi1eUyjA9GMNK3ZmPeBJ7Xa4N6GCOXHDr8eJgQFyhdmJ
         v2bNKKoCYHTyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomas Melin <tomas.melin@vaisala.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, nicolas.ferre@microchip.com,
        davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 11/12] net: macb: Restart tx only if queue pointer is lagging
Date:   Tue, 19 Apr 2022 14:15:24 -0400
Message-Id: <20220419181525.486166-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181525.486166-1-sashal@kernel.org>
References: <20220419181525.486166-1-sashal@kernel.org>
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
index 460bb81acf2b..d8e4842af055 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1364,6 +1364,7 @@ static void macb_tx_restart(struct macb_queue *queue)
 	unsigned int head = queue->tx_head;
 	unsigned int tail = queue->tx_tail;
 	struct macb *bp = queue->bp;
+	unsigned int head_idx, tbqp;
 
 	if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
 		queue_writel(queue, ISR, MACB_BIT(TXUBR));
@@ -1371,6 +1372,13 @@ static void macb_tx_restart(struct macb_queue *queue)
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

