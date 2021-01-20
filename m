Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392A02FC7A1
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 03:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727424AbhATCR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 21:17:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:48236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730845AbhATB3o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 20:29:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03C9A23602;
        Wed, 20 Jan 2021 01:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106091;
        bh=N8kZanpn/GiXqno4kNSqiehgnZB79d0jgWhD+24tOA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LBWMYvYuAXdnRlWgiv6v1v9mt/5fCzERnAe6HKwOXisZKUSyQvYdk1MIq80j3HxzP
         ZDGvUqGfFQBRFEtMGNTmxS5fIO0mg1j3UlB04ibfJKJlst+Jbsk9KKK8OQTGIfrbw0
         mIV7pUW44PyI3fUsPmCy0h2aMeEgUX7p+iureCpmr6NeAkSn+p+rb/3UrduIuzKCE4
         WmkB4Cz1CQdicADE6noKleoXuUq6dI5IP2AxOyHzYu9t/O7c8/UcR8vCf+E1tl8092
         la7EFq8DdLP/2wR56eOtt5Q6n70N6aaJE0JdYSy7iihL5M6iSJ62z+wBePzvodZ6T1
         Z6lw93UGTTE3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Wu <david.wu@rock-chips.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 6/9] net: stmmac: Fixed mtu channged by cache aligned
Date:   Tue, 19 Jan 2021 20:27:59 -0500
Message-Id: <20210120012802.770525-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012802.770525-1-sashal@kernel.org>
References: <20210120012802.770525-1-sashal@kernel.org>
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
index d5ebaf62d12fe..a7b30f0605362 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3613,6 +3613,7 @@ static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int txfifosz = priv->plat->tx_fifo_size;
+	const int mtu = new_mtu;
 
 	if (txfifosz == 0)
 		txfifosz = priv->dma_cap.tx_fifo_size;
@@ -3630,7 +3631,7 @@ static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
 	if ((txfifosz < new_mtu) || (new_mtu > BUF_SIZE_16KiB))
 		return -EINVAL;
 
-	dev->mtu = new_mtu;
+	dev->mtu = mtu;
 
 	netdev_update_features(dev);
 
-- 
2.27.0

