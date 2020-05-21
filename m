Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9B41DCCCF
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 14:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729345AbgEUMZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 08:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729304AbgEUMZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 08:25:20 -0400
X-Greylist: delayed 2140 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 21 May 2020 05:25:19 PDT
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE01C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 05:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pZRZ5ai+2OEtzq7iw7AMDtLjRGWBjulfH6RpHnKhK00=; b=r3GMoD4mo5KpZ3a33cPalZhIJ6
        NqskAuHX1uJmSveg1HMePMVCrybMUeAV+DoH/9HWxOhqbAOBilM3CUIAnePVHdyqaBJ1O9aJGs/Va
        I+5dUzHGR0BzAu4AKhkQa5780w/72ufkhS9MjcioIj1oijRp8GRO2GZKxk4erk8uNzZJkHyQa3qTA
        m6e7pG9hQ8gS6L8bl1qz3slRcRdLJDZbjIgpNcOCRYI/rWrs1016CCORlIcHnvvQGIsQTVZPZ0R2z
        tuNRZxYTWiaL5964qrZNzbCfTCWWN6aoP2X09/GBo6fQcQG6lP6WXhvwSHUNKuNgKKDQ9iDc/FPKY
        HOW6GVSA==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1jbjhe-0007rJ-UX; Thu, 21 May 2020 12:49:34 +0100
Date:   Thu, 21 May 2020 12:49:34 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Sergey Sergeev <adron@yapic.net>,
        Marcel Ziswiler <marcel@ziswiler.com>
Subject: [PATCH] net: ethernet: stmmac: Enable interface clocks on probe for
 IPQ806x
Message-ID: <20200521114934.GY311@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ipq806x_gmac_probe() function enables the PTP clock but not the
appropriate interface clocks. This means that if the bootloader hasn't
done so attempting to bring up the interface will fail with an error
like:

[   59.028131] ipq806x-gmac-dwmac 37600000.ethernet: Failed to reset the dma
[   59.028196] ipq806x-gmac-dwmac 37600000.ethernet eth1: stmmac_hw_setup: DMA engine initialization failed
[   59.034056] ipq806x-gmac-dwmac 37600000.ethernet eth1: stmmac_open: Hw setup failed

This patch, a slightly cleaned up version of one posted by Sergey
Sergeev in:

https://forum.openwrt.org/t/support-for-mikrotik-rb3011uias-rm/4064/257

correctly enables the clock; we have already configured the source just
before this.

Tested on a MikroTik RB3011.

Signed-off-by: Jonathan McDowell <noodles@earth.li>

---

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
index 6ae13dc19510..02102c781a8c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
@@ -319,6 +319,19 @@ static int ipq806x_gmac_probe(struct platform_device *pdev)
 	/* Enable PTP clock */
 	regmap_read(gmac->nss_common, NSS_COMMON_CLK_GATE, &val);
 	val |= NSS_COMMON_CLK_GATE_PTP_EN(gmac->id);
+	switch (gmac->phy_mode) {
+	case PHY_INTERFACE_MODE_RGMII:
+		val |= NSS_COMMON_CLK_GATE_RGMII_RX_EN(gmac->id) |
+			NSS_COMMON_CLK_GATE_RGMII_TX_EN(gmac->id);
+		break;
+	case PHY_INTERFACE_MODE_SGMII:
+		val |= NSS_COMMON_CLK_GATE_GMII_RX_EN(gmac->id) |
+				NSS_COMMON_CLK_GATE_GMII_TX_EN(gmac->id);
+		break;
+	default:
+		/* We don't get here; the switch above will have errored out */
+		unreachable();
+	}
 	regmap_write(gmac->nss_common, NSS_COMMON_CLK_GATE, val);
 
 	if (gmac->phy_mode == PHY_INTERFACE_MODE_SGMII) {
