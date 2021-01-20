Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5712FC6D2
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 02:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbhATBaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 20:30:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:47302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730769AbhATB30 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 20:29:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB04123433;
        Wed, 20 Jan 2021 01:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106075;
        bh=0oC4UvFQ7gr34BsUtHy/rcWoiAez/qEhFP6ph1HMd3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pHXFPN4Rcr0c8iwY69HudjE/QLNwsQW1h+CWYxjYEMYQiKJDyGTO/p/m0kiyFViDJ
         r5evtFDroWwjFU8vEcUVaVd1UC841fgWi9ICWyt2cZg/AIQ6vHjBO9FdLJ/vvFZO1T
         tE1Ad0wGrft1Iy7nowt7dbMhvTuS0sr7cgT1XOFYKK9T+W6tEsHz8KOa6XjP0n83NH
         oDH7zzQ7iaAl0lZO5gzdGhe57jpapEfj/aEQBBZl4cIPYXyE6CXTuYn6MRln8ePw3U
         iTvyN91tkdO33JqFwnswa4pRB0IYhEJYmJtuNXV6V75GpEdfOSMo99lbwYWDsJHQe0
         PeOxV2uK5uf7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Wu <david.wu@rock-chips.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 10/15] net: stmmac: Fixed mtu channged by cache aligned
Date:   Tue, 19 Jan 2021 20:27:35 -0500
Message-Id: <20210120012740.770354-10-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012740.770354-1-sashal@kernel.org>
References: <20210120012740.770354-1-sashal@kernel.org>
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
index 4ac507b4d1019..76d4b8e6ac3e8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3596,6 +3596,7 @@ static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int txfifosz = priv->plat->tx_fifo_size;
+	const int mtu = new_mtu;
 
 	if (txfifosz == 0)
 		txfifosz = priv->dma_cap.tx_fifo_size;
@@ -3613,7 +3614,7 @@ static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
 	if ((txfifosz < new_mtu) || (new_mtu > BUF_SIZE_16KiB))
 		return -EINVAL;
 
-	dev->mtu = new_mtu;
+	dev->mtu = mtu;
 
 	netdev_update_features(dev);
 
-- 
2.27.0

