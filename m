Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2783667A7
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 11:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237681AbhDUJJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 05:09:36 -0400
Received: from mga06.intel.com ([134.134.136.31]:48509 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235406AbhDUJJd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 05:09:33 -0400
IronPort-SDR: BtVKrBftMwfsbruhgIgMnOGqImM+2bTYqm78v97yaTXAOpmKC2GFaXj5VDMCsXHKBu50gwet9a
 4Jaa5+QlXfrg==
X-IronPort-AV: E=McAfee;i="6200,9189,9960"; a="256981039"
X-IronPort-AV: E=Sophos;i="5.82,238,1613462400"; 
   d="scan'208";a="256981039"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2021 02:09:00 -0700
IronPort-SDR: DN8SoSXKp7r6nZp8rCRIndx7m90PfocgTMR3O5IwKANU6meiFXTRRMXFLk1N6fR4xx8+8VFK4X
 JbBc86WAjgKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,238,1613462400"; 
   d="scan'208";a="463517768"
Received: from glass.png.intel.com ([10.158.65.59])
  by orsmga001.jf.intel.com with ESMTP; 21 Apr 2021 02:08:57 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net 1/1] net: stmmac: fix TSO and TBS feature enabling during driver open
Date:   Wed, 21 Apr 2021 17:11:49 +0800
Message-Id: <20210421091149.5035-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TSO and TBS cannot co-exist and current implementation requires two
fixes:

 1) stmmac_open() does not need to call stmmac_enable_tbs() because
    the MAC is reset in stmmac_init_dma_engine() anyway.
 2) Inside stmmac_hw_setup(), we should call stmmac_enable_tso() for
    TX Q that is _not_ configured for TBS.

Fixes: 579a25a854d4 ("net: stmmac: Initial support for TBS")
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4749bd0af160..c6f24abf6432 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2757,8 +2757,15 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 
 	/* Enable TSO */
 	if (priv->tso) {
-		for (chan = 0; chan < tx_cnt; chan++)
+		for (chan = 0; chan < tx_cnt; chan++) {
+			struct stmmac_tx_queue *tx_q = &priv->tx_queue[chan];
+
+			/* TSO and TBS cannot co-exist */
+			if (tx_q->tbs & STMMAC_TBS_AVAIL)
+				continue;
+
 			stmmac_enable_tso(priv, priv->ioaddr, 1, chan);
+		}
 	}
 
 	/* Enable Split Header */
@@ -2850,9 +2857,8 @@ static int stmmac_open(struct net_device *dev)
 		struct stmmac_tx_queue *tx_q = &priv->tx_queue[chan];
 		int tbs_en = priv->plat->tx_queues_cfg[chan].tbs_en;
 
+		/* Setup per-TXQ tbs flag before TX descriptor alloc */
 		tx_q->tbs |= tbs_en ? STMMAC_TBS_AVAIL : 0;
-		if (stmmac_enable_tbs(priv, priv->ioaddr, tbs_en, chan))
-			tx_q->tbs &= ~STMMAC_TBS_AVAIL;
 	}
 
 	ret = alloc_dma_desc_resources(priv);
-- 
2.25.1

