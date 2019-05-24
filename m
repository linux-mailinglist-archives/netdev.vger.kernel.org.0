Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66C48292CF
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 10:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389537AbfEXIUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 04:20:40 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:35564 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389493AbfEXIUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 04:20:39 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 4F73DC0130;
        Fri, 24 May 2019 08:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558686046; bh=uTHC7HW05fXW680blqEJrzIbPmSTo0MD/lwCtSi5WtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=UZSJzWDziYEAwBvxYW3aYw8abS+FBt4PKQfFVz6BHVKxuP0Ap7WbCDWGqra4Vp4y5
         ifh85FVKZ1aXHXKJxPHZhCN1WtDmk81OQJ7BcqsbFgthEvljvGHzzX+Obv83+cY03J
         h1YbwrDqFvRFVftVhdwpgfklwn1uPDQAzJy9hEiMOg5dPuhWmPHBcChQbJMvXYuSgW
         u385SZAoMOCwe6SHGWex7RaMPrLmhGBcW24E5zGC9zHBLEV+JIdrpz0ubZ996DT0x2
         9ApFprhb0mOYw1ZtuEpDAnqLYTz41CsIrW9d7hn2PUujl57fTFNmgbW8onbIedC3EU
         cTy9Duyc+7rHg==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 923A0A0258;
        Fri, 24 May 2019 08:20:38 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id A8B143FB29;
        Fri, 24 May 2019 10:20:36 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next v2 18/18] net: stmmac: Prevent missing interrupts when running NAPI
Date:   Fri, 24 May 2019 10:20:26 +0200
Message-Id: <e66362fde1dac9bb814646c8264c8dc3c4dbeeea.1558685828.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1558685827.git.joabreu@synopsys.com>
References: <cover.1558685827.git.joabreu@synopsys.com>
In-Reply-To: <cover.1558685827.git.joabreu@synopsys.com>
References: <cover.1558685827.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we trigger NAPI we are disabling interrupts but in case we receive
or send a packet in the meantime, as interrupts are disabled, we will
miss this event.

Trigger both NAPI instances (RX and TX) when at least one event happens
so that we don't miss any interrupts.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index ce77a9a2eb56..a87ec70b19f1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2058,6 +2058,9 @@ static int stmmac_napi_check(struct stmmac_priv *priv, u32 chan)
 						 &priv->xstats, chan);
 	struct stmmac_channel *ch = &priv->channel[chan];
 
+	if (status)
+		status |= handle_rx | handle_tx;
+
 	if ((status & handle_rx) && (chan < priv->plat->rx_queues_to_use)) {
 		stmmac_disable_dma_irq(priv, priv->ioaddr, chan);
 		napi_schedule_irqoff(&ch->rx_napi);
-- 
2.7.4

