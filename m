Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43A60D7B49
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 18:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388011AbfJOQXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 12:23:34 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:54831 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387920AbfJOQXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 12:23:34 -0400
Received: from [167.98.27.226] (helo=rainbowdash.codethink.co.uk)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1iKPbW-0008HM-QE; Tue, 15 Oct 2019 17:23:22 +0100
Received: from ben by rainbowdash.codethink.co.uk with local (Exim 4.92.2)
        (envelope-from <ben@rainbowdash.codethink.co.uk>)
        id 1iKPbW-0003a6-FT; Tue, 15 Oct 2019 17:23:22 +0100
From:   "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
To:     linux-kernel@lists.codethink.co.uk
Cc:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: stmmac: fix argument to stmmac_pcs_ctrl_ane()
Date:   Tue, 15 Oct 2019 17:23:21 +0100
Message-Id: <20191015162321.13723-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The stmmac_pcs_ctrl_ane() expects a register address as
argument 1, but for some reason the mac_device_info is
being passed.

Fix the warning (and possible bug) from sparse:

drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:2613:17: warning: incorrect type in argument 1 (different address spaces)
drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:2613:17:    expected void [noderef] <asn:2> *ioaddr
drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:2613:17:    got struct mac_device_info *hw

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
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
index c76a1336a451..3947c95121c6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2610,7 +2610,7 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 	}
 
 	if (priv->hw->pcs)
-		stmmac_pcs_ctrl_ane(priv, priv->hw, 1, priv->hw->ps, 0);
+		stmmac_pcs_ctrl_ane(priv, priv->ioaddr, 1, priv->hw->ps, 0);
 
 	/* set TX and RX rings length */
 	stmmac_set_rings_length(priv);
-- 
2.23.0

