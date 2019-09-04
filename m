Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72449A8442
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 15:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730384AbfIDNRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 09:17:15 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:33438 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727417AbfIDNRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 09:17:14 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id D1938C5746;
        Wed,  4 Sep 2019 13:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1567603034; bh=i9xcnzMF9fbzhtXBItSqt+iaoB57JVPuXM/inApdYsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=lF5BSf3ognWDbpb9rKbbvRKeABBqUR96yy347YohPDD0+KqST2zyX3ykA2QjaN8Ig
         QRSb32FvBbAiee+WmG+Bp9IsUfs70rR5e/zxEKn93b9o2dWq80MB6DDOYAHAe32NQ0
         ZnhvlpvpFjvGtWaVesiOQzvc5uMlel7QzRHMft48nuzTQ2dUdvCRcQlH1US0du0We8
         7j5TkaaXuWO2JdOIpXD3Lc45sAHigBAMbgiA+PapLSq1gUjXT52p4lrk0nUxdWwMPl
         m9lx8Gg1CxVMQlOIkZYBWSLOEtYRrmOgxgt4Ij72eXx2hbBN5fFBeICzBChRbRmunH
         I7Vc3JyckIPsg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 9B4BFA0078;
        Wed,  4 Sep 2019 13:17:12 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 08/13] net: stmmac: Only consider RX error when HW Timestamping is not enabled
Date:   Wed,  4 Sep 2019 15:17:00 +0200
Message-Id: <2364def93b9712962bcd65569edbdae342f87bd2.1567602868.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1567602867.git.joabreu@synopsys.com>
References: <cover.1567602867.git.joabreu@synopsys.com>
In-Reply-To: <cover.1567602867.git.joabreu@synopsys.com>
References: <cover.1567602867.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only consider that we have an error when HW Timestamping is not enabled
as this can give false positives due to the fact the RX Timestamping in
XGMAC and GMAC cores comes from context descriptors.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c59c232aca64..5271c6129f0e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3511,9 +3511,10 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 					&priv->xstats, rx_q->dma_erx + entry);
 		if (unlikely(status == discard_frame)) {
 			page_pool_recycle_direct(rx_q->page_pool, buf->page);
-			priv->dev->stats.rx_errors++;
 			buf->page = NULL;
 			error = 1;
+			if (!priv->hwts_rx_en)
+				priv->dev->stats.rx_errors++;
 		}
 
 		if (unlikely(error && (status & rx_not_ls)))
-- 
2.7.4

