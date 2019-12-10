Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD78C11912C
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 20:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbfLJTzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 14:55:25 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:45198 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726687AbfLJTzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 14:55:01 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A6479C0BAE;
        Tue, 10 Dec 2019 19:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576007700; bh=hNPVGvX287G7j1Ei3yz/c7/UqEe5MnMoip2YipLhq5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=U9hq47q1iMdEyMX+3VnklyHCIXlIgvWug9GktDJSFvNJNsC+qQ0wR2CqAfhF81A2/
         kjMvMSZ3hOasUNBQWU7rCM5FVag4ZonIFq8gB6A+0yostVFV/0DymsnRDptvaQhpOe
         ea/zXLgrAvTg3nizaJQv+LzIz8Qk4xkN/+nM7aG1aG5ooE4iPWLkA1nfyUinOkk+tO
         151YiC1ft2NygPLCtjc0sjGKw/+MH7S0DHtsqiM5qojzv1POlbyv3XohxXbSEOWrPx
         iX3GYjdTIKt2z3+wTnOOJ/gXCH7SVfwfZOVRm66+WXnfq4zcE3vAvO2OPC/BV6DPV8
         GC4ANFcVGBaxQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 518D4A00A4;
        Tue, 10 Dec 2019 19:54:58 +0000 (UTC)
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
Subject: [PATCH net-next 4/4] net: stmmac: Always use TX coalesce timer value when rescheduling
Date:   Tue, 10 Dec 2019 20:54:44 +0100
Message-Id: <23c0ff1feddcc690ee66adebefdc3b10031afe1b.1576007149.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1576007149.git.Jose.Abreu@synopsys.com>
References: <cover.1576007149.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1576007149.git.Jose.Abreu@synopsys.com>
References: <cover.1576007149.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we have pending packets we re-arm the TX timer with a magic value.
Change this from the hardcoded value to the pre-defined TX coalesce
timer value.

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
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index f61780ae30ac..726a17d9cc35 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1975,7 +1975,7 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 
 	/* We still have pending packets, let's call for a new scheduling */
 	if (tx_q->dirty_tx != tx_q->cur_tx)
-		mod_timer(&tx_q->txtimer, STMMAC_COAL_TIMER(10));
+		mod_timer(&tx_q->txtimer, STMMAC_COAL_TIMER(priv->tx_coal_timer));
 
 	__netif_tx_unlock_bh(netdev_get_tx_queue(priv->dev, queue));
 
-- 
2.7.4

