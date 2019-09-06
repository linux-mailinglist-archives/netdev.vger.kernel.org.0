Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 589C4AB35F
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 09:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404591AbfIFHlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 03:41:32 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:33356 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392554AbfIFHl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 03:41:29 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2AE33C0E3C;
        Fri,  6 Sep 2019 07:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1567755688; bh=jZCMlvgCMuP7tUeAHLlMp4idCMgk/I/cK3F4CsQd+PQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=ishy2uzL4O1BH/uU/Pa3nyGxn/4goiVJhORDkg31zNiVDoAlF5mzhMnrO4K//S78l
         M5w8LClhcaOfomTJJyC1Y8t0/MB3Bn4HQHGpbXPwx5s28vTGAiodYmdU3CNr96Yqpn
         Z9Fsn3Sn7ctltDHFBal6vHhGBXc7PcwaOM2A8FTRtBWNFAklk/WeAQOZEcUuFeIxNy
         dGiWO6o+WCI0WQZFzVazqZZtSJADj89mmVvkzoQZmV10bklpFZFT3/sLK2MnU8sH4o
         RiUARgV7YIBtTQt8Qy9isheuBEat0Tvbv7Ge3QBO+jYeXEd9Kl+jDigztFruV5U9fp
         dxI6hQxF0VEYA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id B9DA5A0062;
        Fri,  6 Sep 2019 07:41:26 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/5] net: stmmac: selftests: Set RX tail pointer in Flow Control test
Date:   Fri,  6 Sep 2019 09:41:14 +0200
Message-Id: <9e6d4447eeefa45d7e61e6bb9e4f602981c85c23.1567755423.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1567755423.git.joabreu@synopsys.com>
References: <cover.1567755423.git.joabreu@synopsys.com>
In-Reply-To: <cover.1567755423.git.joabreu@synopsys.com>
References: <cover.1567755423.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to set the RX tail pointer so that RX engine starts working
again after finishing the Flow Control test.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index dce34c081a1e..2943943bec43 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -722,8 +722,14 @@ static int stmmac_test_flowctrl(struct stmmac_priv *priv)
 
 	for (i = 0; i < rx_cnt; i++) {
 		struct stmmac_channel *ch = &priv->channel[i];
+		u32 tail;
 
+		tail = priv->rx_queue[i].dma_rx_phy +
+			(DMA_RX_SIZE * sizeof(struct dma_desc));
+
+		stmmac_set_rx_tail_ptr(priv, priv->ioaddr, tail, i);
 		stmmac_start_rx(priv, priv->ioaddr, i);
+
 		local_bh_disable();
 		napi_reschedule(&ch->rx_napi);
 		local_bh_enable();
-- 
2.7.4

