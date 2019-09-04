Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC04CA8458
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 15:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730596AbfIDNSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 09:18:08 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:33556 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730391AbfIDNRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 09:17:15 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 18BF0C574A;
        Wed,  4 Sep 2019 13:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1567603034; bh=TnBhj8gYd15Wdya0NUlz/4/WhOGI/iqFaYmz/7sZMCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=TGh46PBLQiIG6yA7Shai76M28/O5u55y33zvay3P8GmYoCMeqNUEliTeR1W9tLwvy
         EHViKx+y543zMuUHj+XvtXVRLzIx423Ff+e95OuSWpiEmTz8z5k6iZhLEFygw1SwQk
         femOQujM+YbH1a08c+79GjAtiM/YuGdy/ik0hLo93S1jM5nT0OXmtR8FAEcJp23daJ
         5dGy3VrBasZK8slIutZ9auxTMTYAH87lC+RrBuUVvCsVd3QgFGemxliatk1/ETKWrd
         RC4mRve3tKqBEtg66+4ezhzCIlGqOmjHc8NMz/DWRDdW+iJpSqKLZRGrk8TDxnBaxq
         ++Jyk7jPkzPIw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id C7ECDA0084;
        Wed,  4 Sep 2019 13:17:12 +0000 (UTC)
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
Subject: [PATCH v2 net-next 12/13] net: stmmac: xgmac: Enable RX Jumbo frame support
Date:   Wed,  4 Sep 2019 15:17:04 +0200
Message-Id: <70dc0542979992e509040f7f7bcd1a6cea3a2be7.1567602868.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1567602867.git.joabreu@synopsys.com>
References: <cover.1567602867.git.joabreu@synopsys.com>
In-Reply-To: <cover.1567602867.git.joabreu@synopsys.com>
References: <cover.1567602867.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are already doing it by default in the TX path so we can also enable
Jumbo Frame support in the RX path independently of MTU value.

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
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h      |  3 ++-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c | 11 -----------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index f942ac975c29..5923ca62d793 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -44,7 +44,8 @@
 #define XGMAC_CONFIG_CST		BIT(2)
 #define XGMAC_CONFIG_ACS		BIT(1)
 #define XGMAC_CONFIG_RE			BIT(0)
-#define XGMAC_CORE_INIT_RX		0
+#define XGMAC_CORE_INIT_RX		(XGMAC_CONFIG_GPSLCE | XGMAC_CONFIG_WD | \
+					 (XGMAC_JUMBO_LEN << XGMAC_CONFIG_GPSL_SHIFT))
 #define XGMAC_PACKET_FILTER		0x00000008
 #define XGMAC_FILTER_RA			BIT(31)
 #define XGMAC_FILTER_IPFE		BIT(20)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 36262ef8b70a..78ac659da279 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -15,7 +15,6 @@ static void dwxgmac2_core_init(struct mac_device_info *hw,
 			       struct net_device *dev)
 {
 	void __iomem *ioaddr = hw->pcsr;
-	int mtu = dev->mtu;
 	u32 tx, rx;
 
 	tx = readl(ioaddr + XGMAC_TX_CONFIG);
@@ -24,16 +23,6 @@ static void dwxgmac2_core_init(struct mac_device_info *hw,
 	tx |= XGMAC_CORE_INIT_TX;
 	rx |= XGMAC_CORE_INIT_RX;
 
-	if (mtu >= 9000) {
-		rx |= XGMAC_CONFIG_GPSLCE;
-		rx |= XGMAC_JUMBO_LEN << XGMAC_CONFIG_GPSL_SHIFT;
-		rx |= XGMAC_CONFIG_WD;
-	} else if (mtu > 2000) {
-		rx |= XGMAC_CONFIG_JE;
-	} else if (mtu > 1500) {
-		rx |= XGMAC_CONFIG_S2KP;
-	}
-
 	if (hw->ps) {
 		tx |= XGMAC_CONFIG_TE;
 		tx &= ~hw->link.speed_mask;
-- 
2.7.4

