Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 894BF124477
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 11:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfLRKYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 05:24:52 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:37412 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726360AbfLRKYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 05:24:52 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 4C2DCC0D6D;
        Wed, 18 Dec 2019 10:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576664691; bh=n3XfXSTqrBIgJ9C3cTxiIkAqHlPFFDIqON8t4hOiKtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Sw5uTCHXM2iL2X0IWNX/a0JhMtuqPlMDaaA5S57bZJoyAmNU4AwarWBSw+xOp0cp2
         y16hvOdbEmDVcjKJqg0Vgx3Rls7rQncLpWajR/5N+O+aDfT9JIu/mjKgwLHrwGSjIA
         b2HLZo+8S4wP0VRGUj8zR0Jx9aN2rv9I8ReefEqsQIj1G9Of+4D+21V8gz591/RX8H
         8C4QEan1RDa9B/kPSaVOtJ5z83pga7wGsix7CIUNTTryQZ/TH4rgW1JlknIIR7R1sH
         N+bEPddMWXswTUtxehL7YZVMCFwlkB2Ep4B1aqlg72SiZDvZcqUkJ3zTpom4ZPH+AY
         wpvq1nsfQs/hA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id F38EFA008E;
        Wed, 18 Dec 2019 10:24:49 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 3/3] net: stmmac: Always use TX coalesce timer value when rescheduling
Date:   Wed, 18 Dec 2019 11:24:45 +0100
Message-Id: <e82066e0161edd50ee0542a9d464fd3c937bdfb0.1576664538.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1576664538.git.Jose.Abreu@synopsys.com>
References: <cover.1576664538.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1576664538.git.Jose.Abreu@synopsys.com>
References: <cover.1576664538.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we have pending packets we re-arm the TX timer with a magic value.

This changes the re-arm of the timer from 10us to the user-defined
coalesce value. As we support different speeds, having a magic value of
10us can be either too short or to large depending on the speed so we
let user configure it. The default value of the timer is 1ms but it can
be reconfigured by ethtool.

Changes from v1:
- Reword commit message (Jakub)

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
index d1a22c4fe67b..ecb89c609fb2 100644
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

