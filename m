Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92DB9AED57
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 16:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732939AbfIJOlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 10:41:32 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:42912 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732151AbfIJOlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 10:41:32 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 4F3A3C2B4C;
        Tue, 10 Sep 2019 14:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1568126491; bh=jD5/QnctHRP+NVux4b3Zk2sS5ZQ6JFt6tnWPmqpUAs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=fl2D2N+ZTBjc9x5vxhUoTcY+vyudUpDGpwnwJlq8d70YYIO3gPpqQGUkNLu8P1Mj6
         hp/oPBG8aLVmht4sGqLV08TwynfzPG3c562SilJDjdvBliHPEVptdWbA63eXfw1Hfl
         AK5SjISB1HSHqpoGpdDrV9nbOs0d99mNVht1E0BJZ1tIozFvg/5hBpbk1sSrGZaJe4
         DYP0zdEOeUgYN2BlRasqVDq0JREOdjzOQ1h6mqO8VEh/TJ1781Nc/t4iSL4pesG8Fq
         ZtvQzO2RfLIZCh0uoVP23MuHT4WY8RKyM2s6QEDDESEVlbv9j49MwBoik/yQNR9w5f
         1GBgnVFyhNLUA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id C2C04A005D;
        Tue, 10 Sep 2019 14:41:29 +0000 (UTC)
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
Subject: [PATCH net-next 1/6] net: stmmac: Prevent divide-by-zero
Date:   Tue, 10 Sep 2019 16:41:22 +0200
Message-Id: <04b4d5cff05dc751029ff02e2dadfdb206bf3d11.1568126224.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1568126224.git.joabreu@synopsys.com>
References: <cover.1568126224.git.joabreu@synopsys.com>
In-Reply-To: <cover.1568126224.git.joabreu@synopsys.com>
References: <cover.1568126224.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When RX Coalesce settings are set to all zero (which is a valid setting)
we will currently get a divide-by-zero error. Fix it.

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
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 686b82068142..6e44013b20cc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3418,7 +3418,9 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 		stmmac_refill_desc3(priv, rx_q, p);
 
 		rx_q->rx_count_frames++;
-		rx_q->rx_count_frames %= priv->rx_coal_frames;
+		rx_q->rx_count_frames += priv->rx_coal_frames;
+		if (rx_q->rx_count_frames > priv->rx_coal_frames)
+			rx_q->rx_count_frames = 0;
 		use_rx_wd = priv->use_riwt && rx_q->rx_count_frames;
 
 		dma_wmb();
-- 
2.7.4

