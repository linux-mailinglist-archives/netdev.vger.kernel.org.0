Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5E617C63A
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 20:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgCFTWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 14:22:21 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:36065 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgCFTWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 14:22:21 -0500
X-Originating-IP: 109.190.253.14
Received: from localhost (unknown [109.190.253.14])
        (Authenticated sender: repk@triplefau.lt)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id D557360006;
        Fri,  6 Mar 2020 19:22:16 +0000 (UTC)
From:   Remi Pommarel <repk@triplefau.lt>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-amlogic@lists.infradead.org,
        Remi Pommarel <repk@triplefau.lt>
Subject: [PATCH] net: stmmac: dwmac1000: Disable ACS if enhanced descs are not used
Date:   Fri,  6 Mar 2020 20:30:36 +0100
Message-Id: <20200306193036.18414-1-repk@triplefau.lt>
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

Signed-off-by: Remi Pommarel <repk@triplefau.lt>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index d0356fbd1e43..b468acf03b00 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -25,6 +25,7 @@ static void dwmac1000_core_init(struct mac_device_info *hw,
 				struct net_device *dev)
 {
 	void __iomem *ioaddr = hw->pcsr;
+	struct stmmac_priv *priv = netdev_priv(dev);
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

