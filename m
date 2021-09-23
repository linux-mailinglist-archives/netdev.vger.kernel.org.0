Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCA44156EB
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 05:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239457AbhIWDoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 23:44:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239807AbhIWDma (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 23:42:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 286116103C;
        Thu, 23 Sep 2021 03:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368430;
        bh=UOqMe7rrPxZxMYaRL4dCzAkja5xQ22ZRQL4zq4VgJKE=;
        h=From:To:Cc:Subject:Date:From;
        b=s1O2TbhaDIizgBbTOdKOU0HzUW0ZAmMusbVeJbaWhn0QW/NiAR63zuMTyZdyelFTm
         oiaOahr89I5kGOogV1kv2caxb9L+I4XEI9ALcKBd4mC7kpuJcGXHC9TFmcK03Vlayd
         aWR341u+5HCwJr1GczuSODFN/XqH4OvU8WG3O2lNpaaFV8bThNiABQffxZy+imeLrS
         KFeEZrRhD33gL67nKZYPKPZONXJ6HIVyLnRgajRJRYlA+wRYDP46yc4f4MIKhPKV8a
         TEmCd1rQpOTfdg7O8W85qWtSNr77ezlkm9WJ897Bh3idJk3ZJOR6ngU58uh74Z13Ur
         tmeP1/q406n6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jesper Nilsson <jesper.nilsson@axis.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        kuba@kernel.org, mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 01/11] net: stmmac: allow CSR clock of 300MHz
Date:   Wed, 22 Sep 2021 23:40:17 -0400
Message-Id: <20210923034028.1421876-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Nilsson <jesper.nilsson@axis.com>

[ Upstream commit 08dad2f4d541fcfe5e7bfda72cc6314bbfd2802f ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index dbd56fefa2f3..0a7ff854d1c3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -178,7 +178,7 @@ static void stmmac_clk_csr_set(struct stmmac_priv *priv)
 			priv->clk_csr = STMMAC_CSR_100_150M;
 		else if ((clk_rate >= CSR_F_150M) && (clk_rate < CSR_F_250M))
 			priv->clk_csr = STMMAC_CSR_150_250M;
-		else if ((clk_rate >= CSR_F_250M) && (clk_rate < CSR_F_300M))
+		else if ((clk_rate >= CSR_F_250M) && (clk_rate <= CSR_F_300M))
 			priv->clk_csr = STMMAC_CSR_250_300M;
 	}
 }
-- 
2.30.2

