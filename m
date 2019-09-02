Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8D3A50B2
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 10:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730034AbfIBICS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 04:02:18 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:51390 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729926AbfIBICR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 04:02:17 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id DD8DCC043B;
        Mon,  2 Sep 2019 08:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1567411337; bh=793MRHdv4DLwQdQr3WJdmtfxyUuhU0fectEqf0N0Y5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=a3B8ZYzxCH17QfUXa0xm+zzycE9iJFrOLWrcPD0A5LuaAgNMupDyl3dAAzO+eu+KB
         duDPedszgqvuEzVdA6wv4ZTHY7aCPWvBH8+apX9VH9iivflTOOa6c4mXvql48hqq42
         f5OXVfAm57L+nrt7SV0KR35+oJ7LNpi8D7oEsO9T8oPYgOZcGGh48Qg7kda8tVbI7C
         5plzqF1gJ5cPqJj9pDgnO1P1Vc1XSSQ5V/Pu19ctjEn+hEijXs6DzadN1NL35YYLDK
         94s6TC35GL54mcbwS1wtEQZjJg4esAuS9YHuunKfIsAWj5Tyw9Jj0L5+umDHLYcchS
         ZEnQtLBlutEqA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id A38C0A007C;
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
Subject: [PATCH net-next 09/13] net: stmmac: ethtool: Let user configure TX coalesce without RIWT
Date:   Mon,  2 Sep 2019 10:01:51 +0200
Message-Id: <851a16ddd28878dbaf932cc05f0dab627189be40.1567410970.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1567410970.git.joabreu@synopsys.com>
References: <cover.1567410970.git.joabreu@synopsys.com>
In-Reply-To: <cover.1567410970.git.joabreu@synopsys.com>
References: <cover.1567410970.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When RX Watchdog is disabled its currently not possible to configure TX
coalesce settings. Let user configure it anyway.

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
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c    | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 1c450105e5a6..1a768837ca72 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -746,8 +746,15 @@ static int stmmac_set_coalesce(struct net_device *dev,
 	    (ec->tx_max_coalesced_frames_high) || (ec->rate_sample_interval))
 		return -EOPNOTSUPP;
 
-	if (ec->rx_coalesce_usecs == 0)
-		return -EINVAL;
+	if (priv->use_riwt && (ec->rx_coalesce_usecs > 0)) {
+		rx_riwt = stmmac_usec2riwt(ec->rx_coalesce_usecs, priv);
+
+		if ((rx_riwt > MAX_DMA_RIWT) || (rx_riwt < MIN_DMA_RIWT))
+			return -EINVAL;
+
+		priv->rx_riwt = rx_riwt;
+		stmmac_rx_watchdog(priv, priv->ioaddr, priv->rx_riwt, rx_cnt);
+	}
 
 	if ((ec->tx_coalesce_usecs == 0) &&
 	    (ec->tx_max_coalesced_frames == 0))
@@ -757,20 +764,10 @@ static int stmmac_set_coalesce(struct net_device *dev,
 	    (ec->tx_max_coalesced_frames > STMMAC_TX_MAX_FRAMES))
 		return -EINVAL;
 
-	rx_riwt = stmmac_usec2riwt(ec->rx_coalesce_usecs, priv);
-
-	if ((rx_riwt > MAX_DMA_RIWT) || (rx_riwt < MIN_DMA_RIWT))
-		return -EINVAL;
-	else if (!priv->use_riwt)
-		return -EOPNOTSUPP;
-
 	/* Only copy relevant parameters, ignore all others. */
 	priv->tx_coal_frames = ec->tx_max_coalesced_frames;
 	priv->tx_coal_timer = ec->tx_coalesce_usecs;
 	priv->rx_coal_frames = ec->rx_max_coalesced_frames;
-	priv->rx_riwt = rx_riwt;
-	stmmac_rx_watchdog(priv, priv->ioaddr, priv->rx_riwt, rx_cnt);
-
 	return 0;
 }
 
-- 
2.7.4

