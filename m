Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D05ECFC597
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 12:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfKNLm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 06:42:56 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:56910 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726002AbfKNLm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 06:42:56 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C060BC04C8;
        Thu, 14 Nov 2019 11:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1573731775; bh=KKVx+oqQZP4dQlAUJA6wFUEq0IlyboPfcCFPWcHMXD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Ylx3rom1ImKxxxPU5n0Ds2lfjMwGcDxauvy1LIqQaO3jatIdNqtrmpSPzMjqrO4W8
         5tcNMN1BIU1UD3Gkp4H2r9p+OYId9kvKwOU7+PxdyQGO0s29iphD8JuLZO16SB6+C+
         BzaYGJ+Ko8vhALsRuf3LTopMp2l73dEmbLr76KiWC241xvqg8K0QeoLyKGxNLtNvm+
         ANq6YDcRFCQxOtnxExpEmvsNUgHBxjJYT7ivXjeziClKuZrbBlHgxtkbRLSPGWNVQz
         cvcFO9aeDoQVow6bFABX07semUmBPWDUxFIuYo6XtfUBUAs9E5ryfs9HW6LXI8UEBT
         ZNZ6zDyZ88S8A==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 4AECEA007F;
        Thu, 14 Nov 2019 11:42:53 +0000 (UTC)
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
Subject: [PATCH v2 net-next 1/7] net: stmmac: Do not set RX IC bit if RX Coalesce is zero
Date:   Thu, 14 Nov 2019 12:42:45 +0100
Message-Id: <eb2098f87994ad2c25563602c17179efd3529888.1573731453.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1573731453.git.Jose.Abreu@synopsys.com>
References: <cover.1573731453.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1573731453.git.Jose.Abreu@synopsys.com>
References: <cover.1573731453.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We may only want to use the RX Watchdog so lets check if RX Coalesce
settings are non-zero and only set the RX Interrupt on Completion bit if
its not.

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
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 39b4efd521f9..7939ef7e23b7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3440,7 +3440,11 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 		rx_q->rx_count_frames += priv->rx_coal_frames;
 		if (rx_q->rx_count_frames > priv->rx_coal_frames)
 			rx_q->rx_count_frames = 0;
-		use_rx_wd = priv->use_riwt && rx_q->rx_count_frames;
+
+		use_rx_wd = !priv->rx_coal_frames;
+		use_rx_wd |= rx_q->rx_count_frames > 0;
+		if (!priv->use_riwt)
+			use_rx_wd = false;
 
 		dma_wmb();
 		stmmac_set_rx_owner(priv, p, use_rx_wd);
-- 
2.7.4

