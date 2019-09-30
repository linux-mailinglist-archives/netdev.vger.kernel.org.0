Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBEFC1CED
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 10:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730147AbfI3ITy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 04:19:54 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:46082 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730027AbfI3IT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 04:19:27 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2C859C037C;
        Mon, 30 Sep 2019 08:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1569831566; bh=VsdVW+VCuIfZ9PxVxUbdgy4kpT/QeuAHKi9XUjOtZD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Kzw3waQETCU/A0RcuxbLrk/MUiGKZ7IhDthDyr/vWbsCHXayfKVcOpeintm6YM2Q7
         l6xkUCr006LClfeEx9HEX4LaO5Nwz8l0zCIETOPhsypUxOFxxMQgoebMCd1JhFiuRv
         fOwuNYl8hNa0/99nNybQFdqF4a4avPDtSGnxQ+4WovB/nLpU9+0TcYiN7HFgnjT4kt
         frOSOaZRcbRdDVFBTDgTwu3RWOtglEWEy29X+0N5fJwgdNWkV4Mti2uM6ATkpl0LXR
         LyyiUnpdQKQggIrPIJ7NzXHb8GmHGBVuwNOGMaGGVWu+n45nxm1UABNeKDSyEuQS+Q
         1CFp/9yjmtVtQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id AA895A0091;
        Mon, 30 Sep 2019 08:19:23 +0000 (UTC)
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
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 net 9/9] net: stmmac: xgmac: Fix RSS writing wrong keys
Date:   Mon, 30 Sep 2019 10:19:13 +0200
Message-Id: <8879f74a8cc5dffdb14d553c321d64c63ea9fe2d.1569831229.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1569831228.git.Jose.Abreu@synopsys.com>
References: <cover.1569831228.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1569831228.git.Jose.Abreu@synopsys.com>
References: <cover.1569831228.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit b6b6cc9acd7b, changed the call to dwxgmac2_rss_write_reg()
passing it the variable cfg->key[i].

As key is an u8 but we write 32 bits at a time we need to cast it into
an u32 so that the correct key values are written. Notice that the for
loop already takes this into account so we don't try to write past the
keys size.

Fixes: b6b6cc9acd7b ("net: stmmac: selftest: avoid large stack usage")
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
Cc: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 4a1f52474dbc..5031398e612c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -523,8 +523,8 @@ static int dwxgmac2_rss_configure(struct mac_device_info *hw,
 				  struct stmmac_rss *cfg, u32 num_rxq)
 {
 	void __iomem *ioaddr = hw->pcsr;
+	u32 value, *key;
 	int i, ret;
-	u32 value;
 
 	value = readl(ioaddr + XGMAC_RSS_CTRL);
 	if (!cfg || !cfg->enable) {
@@ -533,8 +533,9 @@ static int dwxgmac2_rss_configure(struct mac_device_info *hw,
 		return 0;
 	}
 
+	key = (u32 *)cfg->key;
 	for (i = 0; i < (ARRAY_SIZE(cfg->key) / sizeof(u32)); i++) {
-		ret = dwxgmac2_rss_write_reg(ioaddr, true, i, cfg->key[i]);
+		ret = dwxgmac2_rss_write_reg(ioaddr, true, i, key[i]);
 		if (ret)
 			return ret;
 	}
-- 
2.7.4

