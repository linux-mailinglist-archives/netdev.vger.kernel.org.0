Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3879542258E
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 13:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234532AbhJELrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 07:47:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:61521 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234437AbhJELrD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 07:47:03 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10127"; a="223132356"
X-IronPort-AV: E=Sophos;i="5.85,348,1624345200"; 
   d="scan'208";a="223132356"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2021 04:45:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,348,1624345200"; 
   d="scan'208";a="477646437"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga007.jf.intel.com with ESMTP; 05 Oct 2021 04:44:59 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.69])
        by linux.intel.com (Postfix) with ESMTP id 8D65A5809EB;
        Tue,  5 Oct 2021 04:44:56 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Wong Vee Khee <veekhee@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net 2/2] net: stmmac: trigger PCS EEE to turn off on link down
Date:   Tue,  5 Oct 2021 19:51:00 +0800
Message-Id: <20211005115100.1648170-3-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211005115100.1648170-1-vee.khee.wong@linux.intel.com>
References: <20211005115100.1648170-1-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current implementation enable PCS EEE feature in the event of link
up, but PCS EEE feature is not disabled on link down.

This patch makes sure PCE EEE feature is disabled on link down.

Fixes: 656ed8b015f1 ("net: stmmac: fix EEE init issue when paired with EEE capable PHYs")
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 981ccf47dcea..eb3b7bf771d7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -477,6 +477,10 @@ bool stmmac_eee_init(struct stmmac_priv *priv)
 			stmmac_lpi_entry_timer_config(priv, 0);
 			del_timer_sync(&priv->eee_ctrl_timer);
 			stmmac_set_eee_timer(priv, priv->hw, 0, eee_tw_timer);
+			if (priv->hw->xpcs)
+				xpcs_config_eee(priv->hw->xpcs,
+						priv->plat->mult_fact_100ns,
+						false);
 		}
 		mutex_unlock(&priv->lock);
 		return false;
@@ -1038,7 +1042,7 @@ static void stmmac_mac_link_down(struct phylink_config *config,
 	stmmac_mac_set(priv, priv->ioaddr, false);
 	priv->eee_active = false;
 	priv->tx_lpi_enabled = false;
-	stmmac_eee_init(priv);
+	priv->eee_enabled = stmmac_eee_init(priv);
 	stmmac_set_eee_pls(priv, priv->hw, false);
 
 	if (priv->dma_cap.fpesel)
-- 
2.25.1

