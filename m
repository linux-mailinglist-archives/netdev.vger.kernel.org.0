Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC63240722C
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 21:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbhIJT5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 15:57:04 -0400
Received: from smtp2.axis.com ([195.60.68.18]:58336 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230489AbhIJT5E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 15:57:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1631303753;
  x=1662839753;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RxHsFDpgPb8WljFHoMd0jVOTaLKbxwOshUbSMEYRLiE=;
  b=aUdh8gYDg1z9HLxVzjuZfPHk7QRGtAZVH6tzgrn+bt3icfcIpklWOThM
   abLetnVkMnaikdNa2WBC0oDybvdbSFDFxqTe/VRggwZsPGg2MWK3SNZD9
   Qa9+tXycJHWgv9GPGo7mzLP1aQhsuvfjn3iEvhFqoKAlfe7MTcTw8Z1U0
   Y9q0YiFOFM35uYmn+Cua0FcWu4Mp9n4Jn0vJIzICCZuIsdslyWENTE5ZM
   gpYyWjE2nB7bHsVEBVK1cGNySO8EOag8k+1AdSqRbx3HoAwYJS/6uJyfn
   8f2j4WEFoBjt23lykILb0fV5sqIRKy+3K42I5Z79mDwmDbDy1cZYVbECR
   g==;
From:   Jesper Nilsson <jesper.nilsson@axis.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     <kernel@axis.com>, Jesper Nilsson <jesper.nilsson@axis.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: stmmac: allow CSR clock of 300MHz
Date:   Fri, 10 Sep 2021 21:55:34 +0200
Message-ID: <20210910195535.12533-1-jesper.nilsson@axis.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Synopsys Ethernet IP uses the CSR clock as a base clock for MDC.
The divisor used is set in the MAC_MDIO_Address register field CR
(Clock Rate)

The divisor is there to change the CSR clock into a clock that falls
below the IEEE 802.3 specified max frequency of 2.5MHz.

If the CSR clock is 300MHz, the code falls back to using the reset
value in the MAC_MDIO_Address register, as described in the comment
above this code.

However, 300MHz is actually an allowed value and the proper divider
can be estimated quite easily (it's just 1Hz difference!)

A CSR frequency of 300MHz with the maximum clock rate value of 0x5
(STMMAC_CSR_250_300M, a divisor of 124) gives somewhere around
~2.42MHz which is below the IEEE 802.3 specified maximum.

For the ARTPEC-8 SoC, the CSR clock is this problematic 300MHz,
and unfortunately, the reset-value of the MAC_MDIO_Address CR field
is 0x0.

This leads to a clock rate of zero and a divisor of 42, and gives an
MDC frequency of ~7.14MHz.

Allow CSR clock of 300MHz by making the comparison inclusive.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index ece02b35a6ce..6560d9f24715 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -309,7 +309,7 @@ static void stmmac_clk_csr_set(struct stmmac_priv *priv)
 			priv->clk_csr = STMMAC_CSR_100_150M;
 		else if ((clk_rate >= CSR_F_150M) && (clk_rate < CSR_F_250M))
 			priv->clk_csr = STMMAC_CSR_150_250M;
-		else if ((clk_rate >= CSR_F_250M) && (clk_rate < CSR_F_300M))
+		else if ((clk_rate >= CSR_F_250M) && (clk_rate <= CSR_F_300M))
 			priv->clk_csr = STMMAC_CSR_250_300M;
 	}
 
-- 
2.20.1

