Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10B34125746
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 23:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfLRWzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 17:55:11 -0500
Received: from sv2-smtprelay2.synopsys.com ([149.117.73.133]:46736 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726518AbfLRWzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 17:55:10 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 24FFE404CE;
        Wed, 18 Dec 2019 22:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576709710; bh=NmmAeVmnmq3Fk3aycE9gni+itLeoZyRuQ/a6zLOcV60=;
        h=From:To:Cc:Subject:Date:From;
        b=Wvu0gldDwPpxJWUQXxfo2aRX/YGR+qOXDA2VVvDJ8+Vts8IjZvT57pEk78sSboFLx
         6Hem0NrYrW39UYOyTbYNkbyLkl1D6zFaMHnG182kS2r4PN3/UHS9HV7npOXXZWTUuA
         bn77A0Pm8uCQ/fceXsvabo2pgyJzreB3EzjDlW+nPrSgHfGr4kdPV4ICm/ePZLUIVb
         6QmUAS4y3I46NwUMAZCIljYcrnG6nRp+D2wbnx3QxNEVnEpW6J0x1Wx1nRInIRaSZY
         VuMsmlO1cnOqRSev+2JAVlqoq2y9jH+eIjX+WKF2OGir2O5al8XMgrx+RUNfw+Upso
         luGV7g1tnmsTg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id B5A83A0060;
        Wed, 18 Dec 2019 22:55:05 +0000 (UTC)
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
Subject: [PATCH net-next] net: stmmac: tc: Fix TAPRIO division operation
Date:   Wed, 18 Dec 2019 23:55:01 +0100
Message-Id: <b8ffd4685fac31a39ef5ba91485e685b21ead753.1576709577.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For ARCHs that don't support 64 bits division we need to use the
helpers.

Fixes: b60189e0392f ("net: stmmac: Integrate EST with TAPRIO scheduler API")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Completely untested as my setup is offline due to power-outrage. Carefull
review needed.
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
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 8ff8f9b9bb22..6c4686b77516 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -599,6 +599,7 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 	struct timespec64 time;
 	bool fpe = false;
 	int i, ret = 0;
+	u64 ctr;
 
 	if (!priv->dma_cap.estsel)
 		return -EOPNOTSUPP;
@@ -694,8 +695,9 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 	priv->plat->est->btr[0] = (u32)time.tv_nsec;
 	priv->plat->est->btr[1] = (u32)time.tv_sec;
 
-	priv->plat->est->ctr[0] = (u32)(qopt->cycle_time % NSEC_PER_SEC);
-	priv->plat->est->ctr[1] = (u32)(qopt->cycle_time / NSEC_PER_SEC);
+	ctr = qopt->cycle_time;
+	priv->plat->est->ctr[0] = do_div(ctr, NSEC_PER_SEC);
+	priv->plat->est->ctr[1] = (u32)ctr;
 
 	if (fpe && !priv->dma_cap.fpesel)
 		return -EOPNOTSUPP;
-- 
2.7.4

