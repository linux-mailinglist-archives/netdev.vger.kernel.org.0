Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184BC5078B2
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 20:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356640AbiDSSTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 14:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356727AbiDSSTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 14:19:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047803F88D;
        Tue, 19 Apr 2022 11:13:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4E047CE18A1;
        Tue, 19 Apr 2022 18:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88619C385AC;
        Tue, 19 Apr 2022 18:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392009;
        bh=dzVjioPkyw1/WFLU5VKNi3YYW0V1cEYT1JMw1y3d9TI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IXzxbHhgr50U/rnvYxHdLE5GQCIwqBobf5uluGuGVlcAH1PkICS4ei3PzhwlCYrCJ
         0vwowbzstp+VVALI9V9KiCHRUMdH7yIJYA0cslyPt3PGd9HHWsz/5EoEp1EJqjtLBT
         LmX+XLVS2uBRfxdrNdf2//M6j7Ywfs4aROfStaqW7p6E6KO5U6vZOWzTNFCfTCkjKS
         xeXwEu11F79m3eBTG/ZByUnJyyRKfMV+o9lmgnSIZWE0HSGEaTnzlxtLu55NTNqRuI
         dmlxtXY3GOn12q52DbQGHp27wTln8OGkB3z7LaeeY7Q53a4GRZAVDfBcdziHoP/L9D
         VhTvws8DD7YyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomas Melin <tomas.melin@vaisala.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, nicolas.ferre@microchip.com,
        davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 16/27] net: macb: Restart tx only if queue pointer is lagging
Date:   Tue, 19 Apr 2022 14:12:31 -0400
Message-Id: <20220419181242.485308-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181242.485308-1-sashal@kernel.org>
References: <20220419181242.485308-1-sashal@kernel.org>
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
index 9705c49655ad..217c1a0f8940 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1689,6 +1689,7 @@ static void macb_tx_restart(struct macb_queue *queue)
 	unsigned int head = queue->tx_head;
 	unsigned int tail = queue->tx_tail;
 	struct macb *bp = queue->bp;
+	unsigned int head_idx, tbqp;
 
 	if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
 		queue_writel(queue, ISR, MACB_BIT(TXUBR));
@@ -1696,6 +1697,13 @@ static void macb_tx_restart(struct macb_queue *queue)
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

