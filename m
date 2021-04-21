Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D47B36742E
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 22:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243916AbhDUUe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 16:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243645AbhDUUez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 16:34:55 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27658C06174A
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 13:34:22 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 8B78E1F42674
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     netdev@vger.kernel.org, linux-rockchip@lists.infradead.org
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        David Wu <david.wu@rock-chips.com>,
        Ezequiel Garcia <ezequiel@collabora.com>, kernel@collabora.com
Subject: [PATCH v2 net-next 0/3] net: stmmac: RK3566
Date:   Wed, 21 Apr 2021 17:34:06 -0300
Message-Id: <20210421203409.40717-1-ezequiel@collabora.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that RK3568 SoC devicetree upstreaming is happening [1],
here's another round for the RK3566 dwmac. There wasn't any clear
consensus on how to implement the two interfaces present
on RK3568, so I decided to drop that and just submit RK3566 for now.

This has been tested on a Pine64 RK3566 Quartz64 Model B board,
DHCP and iperf are looking good.

For all the people testing, here's Quartz 64 Model B device tree
snippet:

        gmac1: ethernet@fe010000 {
                compatible = "rockchip,rk3566-gmac", "snps,dwmac-4.20a";
                reg = <0x0 0xfe010000 0x0 0x10000>;
                interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>,
                             <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>;
                interrupt-names = "macirq", "eth_wake_irq";
                rockchip,grf = <&grf>;
                clocks = <&cru SCLK_GMAC1>, <&cru SCLK_GMAC1_RX_TX>,
                         <&cru SCLK_GMAC1_RX_TX>, <&cru CLK_MAC1_REFOUT>,
                         <&cru ACLK_GMAC1>, <&cru PCLK_GMAC1>,
                         <&cru SCLK_GMAC1_RX_TX>, <&cru CLK_GMAC1_PTP_REF>;
                clock-names = "stmmaceth", "mac_clk_rx",
                              "mac_clk_tx", "clk_mac_refout",
                              "aclk_mac", "pclk_mac",
                              "clk_mac_speed", "ptp_ref";
                resets = <&cru SRST_A_GMAC1>;
                reset-names = "stmmaceth";

                snps,mixed-burst;
                snps,tso;

                snps,axi-config = <&gmac1_stmmac_axi_setup>;
                snps,mtl-rx-config = <&gmac1_mtl_rx_setup>;
                snps,mtl-tx-config = <&gmac1_mtl_tx_setup>;
                status = "disabled";

                mdio1: mdio {
                        compatible = "snps,dwmac-mdio";
                        #address-cells = <0x1>;
                        #size-cells = <0x0>;
                };

                gmac1_stmmac_axi_setup: stmmac-axi-config {
                        snps,wr_osr_lmt = <4>;
                        snps,rd_osr_lmt = <8>;
                        snps,blen = <0 0 0 0 16 8 4>;
                };

                gmac1_mtl_rx_setup: rx-queues-config {
                        snps,rx-queues-to-use = <1>;
                        queue0 {};
                };

                gmac1_mtl_tx_setup: tx-queues-config {
                        snps,tx-queues-to-use = <1>;
                        queue0 {};
                };
        };

While here, I'm adding a small patch from David Wu, for some
sanity checks for dwmac-rockchip-specific non-NULL ops.

Thanks!

[1] http://lore.kernel.org/r/20210421065921.23917-1-cl@rock-chips.com

David Wu (2):
  net: stmmac: dwmac-rk: Check platform-specific ops
  net: stmmac: Add RK3566 SoC support

Ezequiel Garcia (1):
  net: stmmac: Don't set has_gmac if has_gmac4 is set

 .../bindings/net/rockchip-dwmac.txt           |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 126 +++++++++++++++++-
 2 files changed, 124 insertions(+), 3 deletions(-)

-- 
2.30.0

