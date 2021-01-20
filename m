Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6422FC955
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730744AbhATC27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 21:28:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:46598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730049AbhATB2c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E26C4206F9;
        Wed, 20 Jan 2021 01:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611105999;
        bh=Q2T+Gg657rvxrNNOM9O3dL87n9iUIoz0iudYxSTxRKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CpZfwWdRWtppd3/gJkxkoJ1h66kJaIIpHEnQaBQpPSrfV6Lmp+ILjluamFCIVgCd6
         9ncX9+c3nH02vRcKJCW0HL9eWumA32lrc1bFQ8EncbbYvGPtmgWutDW4NqI7W8jFYq
         ypz/iB8vOphXJ36wDedbIWbTlO7e1iAWlN48e1WrQxK/VObBv9Cac18l1R9FJ40QE4
         X5sQalphfI+hi0YwV8E2gwKtpnmuk5uGiTAdfbQRW4T0TxyYyyTfr8VyWi0hqv+d+J
         c8PBaxISB9T3BVe8HX5I6LUeFxHebUUl6tSflgRuFFyBw0J9MdZemBUbTMComWLnEW
         jZfj19EQgcFrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Wu <david.wu@rock-chips.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 28/45] net: stmmac: Fixed mtu channged by cache aligned
Date:   Tue, 19 Jan 2021 20:25:45 -0500
Message-Id: <20210120012602.769683-28-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Wu <david.wu@rock-chips.com>

[ Upstream commit 5b55299eed78538cc4746e50ee97103a1643249c ]

Since the original mtu is not used when the mtu is updated,
the mtu is aligned with cache, this will get an incorrect.
For example, if you want to configure the mtu to be 1500,
but mtu 1536 is configured in fact.

Fixed: eaf4fac478077 ("net: stmmac: Do not accept invalid MTU values")
Signed-off-by: David Wu <david.wu@rock-chips.com>
Link: https://lore.kernel.org/r/20210113034109.27865-1-david.wu@rock-chips.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index cb39f6dbf72b8..b3d6d8e3f4de9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3996,6 +3996,7 @@ static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int txfifosz = priv->plat->tx_fifo_size;
+	const int mtu = new_mtu;
 
 	if (txfifosz == 0)
 		txfifosz = priv->dma_cap.tx_fifo_size;
@@ -4013,7 +4014,7 @@ static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
 	if ((txfifosz < new_mtu) || (new_mtu > BUF_SIZE_16KiB))
 		return -EINVAL;
 
-	dev->mtu = new_mtu;
+	dev->mtu = mtu;
 
 	netdev_update_features(dev);
 
-- 
2.27.0

