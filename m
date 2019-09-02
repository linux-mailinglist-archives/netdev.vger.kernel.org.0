Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51B91A50B0
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 10:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730056AbfIBICS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 04:02:18 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:51320 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729675AbfIBICR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 04:02:17 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 77A6AC042B;
        Mon,  2 Sep 2019 08:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1567411337; bh=KCQxzNKdPciLpCzMYFXS00/1ZDMQ64xO5mQOdoiRlGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=HYdjMmlVNEx7t25t6pVED8QCg0+TQDguvdDqz0LGkr0e+OGsJS1KM6jXBTH1ozyIz
         qmLuh6wHWGOv2Uap6+PPZbkpXu+5L+jwCaeoATwOq82tRFrWan9qpiq1+Q659CwxaS
         jZtHlE8ekB7iare0mdQRydJJOtr0FUTm4ddzLjwuZpjdSJOL9TLzdoC+xHTX+adZRP
         HyBrBrTE57gvnDSZVyDpJOCAhVkH5AdSCFpi25Qx+0tum2GSFr/nuFxNWvVOYgDodk
         2tk2Ro96NIEhzHLqX47ATUWr3vMG3O7WIjkkpXmpsCUBg/4uVFk/nPCEhLnqGjuOUf
         9S2RJAdxE9gHA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 307C4A006C;
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
Subject: [PATCH net-next 03/13] net: stmmac: Do not return error code in TC Initialization
Date:   Mon,  2 Sep 2019 10:01:45 +0200
Message-Id: <04b637681f523e26fdc61c31e72d1a90d2b3a2b6.1567410970.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1567410970.git.joabreu@synopsys.com>
References: <cover.1567410970.git.joabreu@synopsys.com>
In-Reply-To: <cover.1567410970.git.joabreu@synopsys.com>
References: <cover.1567410970.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As we can still use the remaining TC callbacks, e.g. CBS. We should not
fail in the initialization only because RX Parser is not available.

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
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 6c305b6ecad0..8dbbbf181ada 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -243,8 +243,9 @@ static int tc_init(struct stmmac_priv *priv)
 	struct dma_features *dma_cap = &priv->dma_cap;
 	unsigned int count;
 
+	/* Fail silently as we can still use remaining features, e.g. CBS */
 	if (!dma_cap->frpsel)
-		return -EINVAL;
+		return 0;
 
 	switch (dma_cap->frpbs) {
 	case 0x0:
-- 
2.7.4

