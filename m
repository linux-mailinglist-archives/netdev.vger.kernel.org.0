Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04DD7701E4
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 16:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbfGVOHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 10:07:35 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:60354 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725989AbfGVOHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 10:07:35 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 3898AC0A8A;
        Mon, 22 Jul 2019 14:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1563804455; bh=BVlhWoqq+b4gRXVHPwK2xuuFu+7zzbfOmcgyb6hD5ZE=;
        h=From:To:Cc:Subject:Date:From;
        b=cQAe7pMXq0a4EkIE0Ckv3jsIe2JYiHGXRgR9ieE9Nk7ZgiWp21hyvh8cKGjZDiodl
         Y0fPYbcLuTDHviZZycurnrsUZUSR5TXD69qvZ1cj0XboiyiQJIR3vjp99+dGVMzdNQ
         oQ+HfXNtB0Jpdq0IupJcjtFDtLvZ1IdQOuB/t83zfoclaO7j53AQPHXW7PVV0GTwvn
         so9PJfGHt7hOwDxZo8yUT2vPChXAdmHuEoYKSfEXcBYJUEkaH/D9q/qdbKnYpDexnk
         w8z3fQNWaCDCX41+7l8hTMPzLw0f7VzuCTwSb6CF+RkwwA3K1fqlez2mgrKc8viSMO
         +gcerTiSg7sLQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id F1887A0057;
        Mon, 22 Jul 2019 14:07:31 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ondrej Jirman <megi@xff.cz>
Subject: [PATCH net] net: stmmac: Do not cut down 1G modes
Date:   Mon, 22 Jul 2019 16:07:21 +0200
Message-Id: <f9b8245ef4fbaca463a6084166c7f72793cb799b.1563804016.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some glue logic drivers support 1G without having GMAC/GMAC4/XGMAC.

Let's allow this speed by default.

Reported-by: Ondrej Jirman <megi@xff.cz>
Tested-by: Ondrej Jirman <megi@xff.cz>
Fixes: 5b0d7d7da64b ("net: stmmac: Add the missing speeds that XGMAC supports")
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
Cc: Ondrej Jirman <megi@xff.cz>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 207c3755bcc5..b0d5e5346597 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -814,20 +814,15 @@ static void stmmac_validate(struct phylink_config *config,
 	phylink_set(mac_supported, 10baseT_Full);
 	phylink_set(mac_supported, 100baseT_Half);
 	phylink_set(mac_supported, 100baseT_Full);
+	phylink_set(mac_supported, 1000baseT_Half);
+	phylink_set(mac_supported, 1000baseT_Full);
+	phylink_set(mac_supported, 1000baseKX_Full);
 
 	phylink_set(mac_supported, Autoneg);
 	phylink_set(mac_supported, Pause);
 	phylink_set(mac_supported, Asym_Pause);
 	phylink_set_port_modes(mac_supported);
 
-	if (priv->plat->has_gmac ||
-	    priv->plat->has_gmac4 ||
-	    priv->plat->has_xgmac) {
-		phylink_set(mac_supported, 1000baseT_Half);
-		phylink_set(mac_supported, 1000baseT_Full);
-		phylink_set(mac_supported, 1000baseKX_Full);
-	}
-
 	/* Cut down 1G if asked to */
 	if ((max_speed > 0) && (max_speed < 1000)) {
 		phylink_set(mask, 1000baseT_Full);
-- 
2.7.4

