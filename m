Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA323FB358
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 16:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbfKMPMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 10:12:41 -0500
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:51276 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727963AbfKMPMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 10:12:22 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 14855C0E7E;
        Wed, 13 Nov 2019 15:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1573657941; bh=bC1EJ9q8JnRvKNdotK/gUKSiGbh6PxTGJKtWEmLuQnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=En1R7OfCoMrVc0nyh8WSV6KoyZFdJpV5Q2OTTxQuq1JvOZET4r7uHtnbgjP/DMHC3
         WIwx0d1DupAXUU0fODpo60UySk+F+7TxCC840eMTvsXDzybu8COGJHQyWZG/twgl9U
         UkeWFi+zd+BxDETlfOyw19Pm4xR0xkDkb39jFJc0jfHJpLmqgRMu8f0G7BSO94LW0Q
         gMpQ5kL+bJQG1Mh+VXnQP/yiH4ouyi/x0XIDLMrxmUcw/5b35BOOckLzq8946XGd1t
         NjhvkWBINok7QLDAw6kJpTsvO+Nz0j8mRmi/lAqBadQpI8UMjvG6XVfoqp5DMUoCFg
         R/bXq5k7DRuXg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 7957BA007F;
        Wed, 13 Nov 2019 15:12:19 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/7] net: stmmac: Do not set RX IC bit if RX Coalesce is zero
Date:   Wed, 13 Nov 2019 16:12:02 +0100
Message-Id: <51b9d21bebde8f9694a2a9883733c7a16425cd72.1573657592.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1573657592.git.Jose.Abreu@synopsys.com>
References: <cover.1573657592.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1573657592.git.Jose.Abreu@synopsys.com>
References: <cover.1573657592.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We may only want to use the RX Watchdog so lets check if RX Coalesce
settings are non-zero and only set the RX Interrupt on Completion bit if
its not.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

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
index 39b4efd521f9..e3677883ea30 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3440,7 +3440,8 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 		rx_q->rx_count_frames += priv->rx_coal_frames;
 		if (rx_q->rx_count_frames > priv->rx_coal_frames)
 			rx_q->rx_count_frames = 0;
-		use_rx_wd = priv->use_riwt && rx_q->rx_count_frames;
+		use_rx_wd = !priv->rx_coal_frames;
+		use_rx_wd |= priv->use_riwt && rx_q->rx_count_frames;
 
 		dma_wmb();
 		stmmac_set_rx_owner(priv, p, use_rx_wd);
-- 
2.7.4

