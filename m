Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A181F1973
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 16:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732119AbfKFPDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 10:03:47 -0500
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:43142 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731950AbfKFPDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 10:03:13 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2E7CAC0F52;
        Wed,  6 Nov 2019 15:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1573052592; bh=D0GsWGpmp4rSag1Ntw7umeYHLG+m0Prqvd4CjMTCUoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=YMxbEJC8a6gRN46LLDwM6iEK4FeFL8dVlkhwmDVINPtljAGlYCBr3X1Y5yx4zW9lW
         7HZy76Ln9WF9ocW9HWUgzttCpo1bGcKsKkqaDcnUKAUYoIKoSDG+DZ9s63G7RXaMmk
         l8sdNhz1pGwi0lt5bnkfvKNiL70lLRMYr6MPaZJXc8CLZrGFH1/Mro9WYCwh13cKLX
         Peu0dsRbZjEVDJc0gRryAHOagA6KriQnW1f68HcHCsA8dtpUNF8ne+42iAVR4r1z3F
         Fa0SZ/BojSC+VxEp1iyNaxTVHgyJ0ZvT3ahVl43hIJW5NoiEhm3i1UajarlVcNxqPc
         4vDODBR0CtT9w==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id E6A24A0081;
        Wed,  6 Nov 2019 15:03:10 +0000 (UTC)
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
Subject: [PATCH net 09/11] net: stmmac: Fix the packet count in stmmac_rx()
Date:   Wed,  6 Nov 2019 16:03:03 +0100
Message-Id: <82bec6022a4e2650f9eeb8682bac2b705e3eae9a.1573052379.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1573052378.git.Jose.Abreu@synopsys.com>
References: <cover.1573052378.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1573052378.git.Jose.Abreu@synopsys.com>
References: <cover.1573052378.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, stmmac_rx() is counting the number of descriptors but it
should count the number of packets as specified by the NAPI limit.

Fix this.

Fixes: ec222003bd94 ("net: stmmac: Prepare to add Split Header support")
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
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4e9c848c67cc..1ab1eea1556a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3506,8 +3506,6 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		if (unlikely(status & dma_own))
 			break;
 
-		count++;
-
 		rx_q->cur_rx = STMMAC_GET_ENTRY(rx_q->cur_rx, DMA_RX_SIZE);
 		next_entry = rx_q->cur_rx;
 
@@ -3534,6 +3532,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			goto read_again;
 		if (unlikely(error)) {
 			dev_kfree_skb(skb);
+			count++;
 			continue;
 		}
 
@@ -3573,6 +3572,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			skb = napi_alloc_skb(&ch->rx_napi, len);
 			if (!skb) {
 				priv->dev->stats.rx_dropped++;
+				count++;
 				continue;
 			}
 
@@ -3638,6 +3638,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 
 		priv->dev->stats.rx_packets++;
 		priv->dev->stats.rx_bytes += len;
+		count++;
 	}
 
 	if (status & rx_not_ls) {
-- 
2.7.4

