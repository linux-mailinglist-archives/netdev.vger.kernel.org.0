Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D34D92FC8DB
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732104AbhATCaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 21:30:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:47420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730677AbhATB3B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 20:29:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC64923405;
        Wed, 20 Jan 2021 01:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106046;
        bh=jmecdH5m1sZMM1i2nSpyh9TsmuTOVzBLpDjaKJ7LffY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3PnYBbcdaMCK4tZ0i+cSJmggBqQ9710r3B0en+UXK+nN09gRNNXHyCc/b9EzdMB3
         x9fCIhBEJWwtDFf5AKVc0qyfQANaq5KWE914bBnRen4WD2AHxZWYe3Vgz+PfhXXY5S
         vhCbk1hp8OSxhBgrlPsv2u1OWy4hajtDslSNbJWkrwqao3UVwjnKvlHG+qGJKRkiI9
         w0fT9jkJXOiyIx1rVldU9gpEA15ZTu4xsjWkNN37zrjtr/N+Llg8ZKOaBiTIWAPdfd
         +d7TrySXjOAPA+4fLrUlM8fjGtFvGfRAVmOqouEZ/EzGQOI5VQ9irTz7GP+keIM1VA
         U0HeEi2Q5YWHw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Wu <david.wu@rock-chips.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 16/26] net: stmmac: Fixed mtu channged by cache aligned
Date:   Tue, 19 Jan 2021 20:26:53 -0500
Message-Id: <20210120012704.770095-16-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012704.770095-1-sashal@kernel.org>
References: <20210120012704.770095-1-sashal@kernel.org>
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
index 18c5a9bb6759c..ce5d3e9e5dff4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3739,6 +3739,7 @@ static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int txfifosz = priv->plat->tx_fifo_size;
+	const int mtu = new_mtu;
 
 	if (txfifosz == 0)
 		txfifosz = priv->dma_cap.tx_fifo_size;
@@ -3756,7 +3757,7 @@ static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
 	if ((txfifosz < new_mtu) || (new_mtu > BUF_SIZE_16KiB))
 		return -EINVAL;
 
-	dev->mtu = new_mtu;
+	dev->mtu = mtu;
 
 	netdev_update_features(dev);
 
-- 
2.27.0

