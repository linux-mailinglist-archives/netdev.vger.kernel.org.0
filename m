Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19CC518A63B
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgCRUya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:54:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbgCRUy3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:54:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9808B2098B;
        Wed, 18 Mar 2020 20:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564868;
        bh=CPQtHhru0LQFaw5HTaIZ2IC1hzuZCsiamkZyzzB0/vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G+IrRK8f2A0wYwU8QzMC0k+xrstON+enN6/aOQAf4IeLJuQy9jwIIi8kWEQcYQ2x4
         b72B9kwEvYlNxj2tdb2HCYh9un5JmLCLnAB8oWntNw4WzgDNbmzr4wqzElwYqRxglD
         KvzHPXL/LlfkLezkkv/c7fG8KPtEyFdYPC1lCFMI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Remi Pommarel <repk@triplefau.lt>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 40/73] net: stmmac: dwmac1000: Disable ACS if enhanced descs are not used
Date:   Wed, 18 Mar 2020 16:53:04 -0400
Message-Id: <20200318205337.16279-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Remi Pommarel <repk@triplefau.lt>

[ Upstream commit b723bd933980f4956dabc8a8d84b3e83be8d094c ]

ACS (auto PAD/FCS stripping) removes FCS off 802.3 packets (LLC) so that
there is no need to manually strip it for such packets. The enhanced DMA
descriptors allow to flag LLC packets so that the receiving callback can
use that to strip FCS manually or not. On the other hand, normal
descriptors do not support that.

Thus in order to not truncate LLC packet ACS should be disabled when
using normal DMA descriptors.

Fixes: 47dd7a540b8a0 ("net: add support for STMicroelectronics Ethernet controllers.")
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index 3d69da112625e..43a785f86c69d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -24,6 +24,7 @@
 static void dwmac1000_core_init(struct mac_device_info *hw,
 				struct net_device *dev)
 {
+	struct stmmac_priv *priv = netdev_priv(dev);
 	void __iomem *ioaddr = hw->pcsr;
 	u32 value = readl(ioaddr + GMAC_CONTROL);
 	int mtu = dev->mtu;
@@ -35,7 +36,7 @@ static void dwmac1000_core_init(struct mac_device_info *hw,
 	 * Broadcom tags can look like invalid LLC/SNAP packets and cause the
 	 * hardware to truncate packets on reception.
 	 */
-	if (netdev_uses_dsa(dev))
+	if (netdev_uses_dsa(dev) || !priv->plat->enh_desc)
 		value &= ~GMAC_CONTROL_ACS;
 
 	if (mtu > 1500)
-- 
2.20.1

