Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64319594F5
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 09:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfF1H30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 03:29:26 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:47996 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726472AbfF1H3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 03:29:25 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 41332C0BF3;
        Fri, 28 Jun 2019 07:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561706965; bh=JljP4Ux5d1crd/1T+kZ+zYlp3zQcsd4krS3WGWr9nMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=lU3jHS04bg+SoSklQvlWP3WPvryRWD9+fSvCnmLmtromPI5pQlkwOjF9juvPCrqr0
         M4FD49+cc8GWNRJ6fwu1DtPbgOxuhKX4kTY/dX2rJDS277stiGtLRzWjYA2FnDc+wB
         R+v8vcJwVtYDqh58PIKPyLwjOXYKfFRhDOyyRAfah3duXM48Uz3bEmBR1v6FWGDs2S
         p3q/DWm6DFqARpwO5+yR4uHC/0iII5MDPARiB1TGL2JdR8wV0QGcuQNc0T1UvvOqQ/
         LRZnPQXeBfdGRz45SwP9LPDJ9chu6oKHTCRF7ng8cDxXa+UBN8U0hlmSGhw9wsuPw+
         ig7NohV850j6Q==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 03161A023D;
        Fri, 28 Jun 2019 07:29:24 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id E864C3E96A;
        Fri, 28 Jun 2019 09:29:23 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next v2 09/10] net: stmmac: Only disable interrupts if NAPI is scheduled
Date:   Fri, 28 Jun 2019 09:29:20 +0200
Message-Id: <71814f54df40ef5e1b51536955e06f10bcaf77fe.1561706801.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1561706800.git.joabreu@synopsys.com>
References: <cover.1561706800.git.joabreu@synopsys.com>
In-Reply-To: <cover.1561706800.git.joabreu@synopsys.com>
References: <cover.1561706800.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only disable the interrupts if RX NAPI gets to be scheduled. Also,
schedule the TX NAPI only when the interrupts are disabled.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a629b3144a0d..3425d4dda03d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2053,12 +2053,12 @@ static int stmmac_napi_check(struct stmmac_priv *priv, u32 chan)
 						 &priv->xstats, chan);
 	struct stmmac_channel *ch = &priv->channel[chan];
 
-	if (status)
-		status |= handle_rx | handle_tx;
-
 	if ((status & handle_rx) && (chan < priv->plat->rx_queues_to_use)) {
-		stmmac_disable_dma_irq(priv, priv->ioaddr, chan);
-		napi_schedule_irqoff(&ch->rx_napi);
+		if (napi_schedule_prep(&ch->rx_napi)) {
+			stmmac_disable_dma_irq(priv, priv->ioaddr, chan);
+			__napi_schedule_irqoff(&ch->rx_napi);
+			status |= handle_tx;
+		}
 	}
 
 	if ((status & handle_tx) && (chan < priv->plat->tx_queues_to_use))
-- 
2.7.4

