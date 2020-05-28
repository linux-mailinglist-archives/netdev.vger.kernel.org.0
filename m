Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C274F1E602D
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389663AbgE1MIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 08:08:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388776AbgE1L4g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 07:56:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49C75212CC;
        Thu, 28 May 2020 11:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590666995;
        bh=O5JZywhz7iAfb7m4Z4WcOq4q0ejSwcFYHqTjUmqM/h8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4YoPlj55F+YcfFnDMJ3o8f+l4TNk36tCQ/z6wbRbVvSd3P5KkZjmaCXj5l0Ochvu
         d15byqVHLsm3F8YTtIpyodTGMhLOuTMtWfe2CMkBl3zq47VPikn5uN2APDZ+Je57xJ
         XbScbusjhZOQwtPzZVQufevPwqyFod5g8J7mZA3Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan McDowell <noodles@earth.li>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 31/47] net: ethernet: stmmac: Enable interface clocks on probe for IPQ806x
Date:   Thu, 28 May 2020 07:55:44 -0400
Message-Id: <20200528115600.1405808-31-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115600.1405808-1-sashal@kernel.org>
References: <20200528115600.1405808-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan McDowell <noodles@earth.li>

[ Upstream commit a96ac8a0045e3cbe3e5af6d1b3c78c6c2065dec5 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

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
-- 
2.25.1

