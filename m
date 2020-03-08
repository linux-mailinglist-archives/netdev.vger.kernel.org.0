Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE98417D2D1
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 10:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbgCHJRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 05:17:22 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:46087 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbgCHJRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 05:17:22 -0400
Received: from localhost (unknown [37.167.192.10])
        (Authenticated sender: repk@triplefau.lt)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 0965D200006;
        Sun,  8 Mar 2020 09:17:17 +0000 (UTC)
From:   Remi Pommarel <repk@triplefau.lt>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-amlogic@lists.infradead.org,
        Remi Pommarel <repk@triplefau.lt>, stable@vger.kernel.org
Subject: [PATCH v2] net: stmmac: dwmac1000: Disable ACS if enhanced descs are not used
Date:   Sun,  8 Mar 2020 10:25:56 +0100
Message-Id: <20200308092556.23881-1-repk@triplefau.lt>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ACS (auto PAD/FCS stripping) removes FCS off 802.3 packets (LLC) so that
there is no need to manually strip it for such packets. The enhanced DMA
descriptors allow to flag LLC packets so that the receiving callback can
use that to strip FCS manually or not. On the other hand, normal
descriptors do not support that.

Thus in order to not truncate LLC packet ACS should be disabled when
using normal DMA descriptors.

Fixes: 47dd7a540b8a0 ("net: add support for STMicroelectronics Ethernet controllers.")
Cc: stable@vger.kernel.org
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
---
Changes since v1:
  - Use reverse christmas tree like declaration
  - Add Fixes tag
---
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index d0356fbd1e43..542784300620 100644
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
2.25.0

