Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 566601370DB
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 16:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbgAJPNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 10:13:47 -0500
Received: from sv2-smtprelay2.synopsys.com ([149.117.73.133]:55700 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728141AbgAJPNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 10:13:40 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 237B44060C;
        Fri, 10 Jan 2020 15:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578669220; bh=NQsm6egfjz1AjvbIX8szBOLKNIQdQ/x4a9hjA8nOve4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=l5WMTDg7sZKfVE7G7JOjv+aQ/zsGskTwAhmdpOjl9O55pgyQKD4XmqEPKBLuXrlzG
         wE8xFdFBTFmbC3S+n1c/yrQVqzr9hWPfcCFccZXcNGDFme6KxdHBz+KfUukJJADxOH
         Kvd+X106bBks+ZMvTiBbB/XLk0I9znsW8wN/YE4SIlVj2pdQoDmYyZL/+te6o7ZtnM
         QWmUkVKf1AJ9uTJGtnLFpCOUAsFXhuyP4fDHXeF4EkOTHhuLn+/MO8fV+ZLQG7sRLV
         LHaOH9U9Xe8ZZ6wOq/pmfqr1ureRTiTH9rVUfJndt3/fUPHe/jHbbnMsN5m92MCYma
         xbNBnuMiOORcg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id A9D36A0067;
        Fri, 10 Jan 2020 15:13:38 +0000 (UTC)
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
Subject: [PATCH net-next 2/2] net: stmmac: gmac5+: Fix missing return
Date:   Fri, 10 Jan 2020 16:13:35 +0100
Message-Id: <1f4783ff9f89fc3fc207d72a69152a44cfd5ba30.1578669088.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1578669088.git.Jose.Abreu@synopsys.com>
References: <cover.1578669088.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1578669088.git.Jose.Abreu@synopsys.com>
References: <cover.1578669088.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If FPE is supposed to be disabled we need to return after disabling it.

Fixes: 7c7282746883 ("net: stmmac: gmac5+: Add support for Frame Preemption")
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
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
index 5d4a3c2458ea..494c859b4ade 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
@@ -657,6 +657,7 @@ void dwmac5_fpe_configure(void __iomem *ioaddr, u32 num_txq, u32 num_rxq,
 		value &= ~EFPE;
 
 		writel(value, ioaddr + MAC_FPE_CTRL_STS);
+		return;
 	}
 
 	value = readl(ioaddr + GMAC_RXQ_CTRL1);
-- 
2.7.4

