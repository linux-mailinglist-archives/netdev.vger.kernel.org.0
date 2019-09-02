Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50AADA50B7
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 10:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730073AbfIBICT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 04:02:19 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:51378 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729910AbfIBICR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 04:02:17 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id D5EB1C0439;
        Mon,  2 Sep 2019 08:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1567411337; bh=i9xcnzMF9fbzhtXBItSqt+iaoB57JVPuXM/inApdYsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=WJdpqBgWOqiWE5WWvElUPMX1sjW9Zy0JyMNN0QOH9RqfMIjD716hcYN2a/juJqeRO
         zSgNUWoG7WhFYGYs3P3yRETpDOmZPW4m5GVP1sTzFpwCQJW1zXhouiS9OeNM9E9zNv
         2t7Mf6yPVPa4keZZhFwOW1u1Ivt59d6IGkO5Pj5x9A0frxNEFGr4wLCRfzHCGUBuul
         +nlX36XjEqZjcibwakI1SfsZ7wRvVe54F33FXKUxqhLW9D3lPR5NODk7nbfVF6kqiW
         rZBfuj+ogakt2TDQwZGRs5hsqPGvzKLK1PioTyAFztaRqQfcSFqrfGi7sMaMi91UlX
         5n28aOAWfM1Dw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 7BB78A0079;
        Mon,  2 Sep 2019 08:02:15 +0000 (UTC)
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
Subject: [PATCH net-next 08/13] net: stmmac: Only consider RX error when HW Timestamping is not enabled
Date:   Mon,  2 Sep 2019 10:01:50 +0200
Message-Id: <294057d4ce5713f4f4d389d26e846d42d6fb9d99.1567410970.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1567410970.git.joabreu@synopsys.com>
References: <cover.1567410970.git.joabreu@synopsys.com>
In-Reply-To: <cover.1567410970.git.joabreu@synopsys.com>
References: <cover.1567410970.git.joabreu@synopsys.com>
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

