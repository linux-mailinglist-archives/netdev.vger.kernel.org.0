Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7AA122C3D
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 13:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbfLQMrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 07:47:06 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:38906 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728018AbfLQMqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 07:46:20 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 50DCEC00A9;
        Tue, 17 Dec 2019 12:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576586780; bh=oGPE8wrRsfHISR9CI0Bv0lr4i1NXDcyW4ra2BlaWLbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=am8+gZ6K3x6Z0dVp4OPjuM1rwORFFnw4GAq0wnwKUcePl1A5WUcVBisbJLy4FBM2E
         Km0tZkKO4O8l5rvcqa9PjMEav2MURloKhv/c1ahw5a/bUKWG3YQBcdJ42H8mKW30Ul
         iwW5qXj7wamAXjJmLEUbGsZC4d+S3L0YOSP7eGrUUlqxmFE8fJYFVElIOcxiE3F7h6
         dEr5lGU3aAWyoF9Ue1LYxwgwIekTyMw/lnI20A3wObKvRAgZPdxYgmIRLmJ6oEPyiW
         /AlCMKH1gk8T1Bp7ZdbJm2P5loAy8gfs6fP5jF2NG7v1shd3bOQ4yjb/nAOwT4oddk
         D+SFlqKI9iXRA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id D2C93A0091;
        Tue, 17 Dec 2019 12:46:17 +0000 (UTC)
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
Subject: [PATCH net-next v2 4/7] net: stmmac: Always use TX coalesce timer value when rescheduling
Date:   Tue, 17 Dec 2019 13:46:08 +0100
Message-Id: <00aa75ac0de29b966f3962fe716122feeb460a81.1576586602.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1576586602.git.Jose.Abreu@synopsys.com>
References: <cover.1576586602.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1576586602.git.Jose.Abreu@synopsys.com>
References: <cover.1576586602.git.Jose.Abreu@synopsys.com>
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
index 80575243820b..b3c6c5e29404 100644
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

