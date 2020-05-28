Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFDB1E5F21
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389321AbgE1L70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 07:59:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389211AbgE1L6T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 07:58:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A050B2193E;
        Thu, 28 May 2020 11:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590667098;
        bh=9FKigbwOpgAEiepoTIiMFDOnRzBmRyu809l/veBXigM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P8dYbvQytrG6RMcv/6ebsa01wkepG0dot3U2ge8L3XEG4ycktgVd5sEb/EN6HWGng
         c7XMggpV8DzQ4f/jRTy+kY3D2zcZFMutF70Zbe12zcUDX2HegwILzNV+B+uWvgMHmE
         xGeHaaEYMWC8orjy/iA0TSuqC9O0VQFIK6SRYAns=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan McDowell <noodles@earth.li>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 5/7] net: ethernet: stmmac: Enable interface clocks on probe for IPQ806x
Date:   Thu, 28 May 2020 07:58:09 -0400
Message-Id: <20200528115811.1406810-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115811.1406810-1-sashal@kernel.org>
References: <20200528115811.1406810-1-sashal@kernel.org>
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
index 1fc356c17750..15aabffd21a8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
@@ -328,6 +328,19 @@ static int ipq806x_gmac_probe(struct platform_device *pdev)
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

