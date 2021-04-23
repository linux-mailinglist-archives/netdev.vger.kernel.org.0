Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA01E369446
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 15:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhDWN6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 09:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhDWN6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 09:58:10 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD6BC061574
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 06:57:33 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 6646E1F43C7B
Message-ID: <08e97e0e291aecb218b9ebb8aaa37afead504e1c.camel@collabora.com>
Subject: Re: [PATCH v2 net-next 0/3] net: stmmac: RK3566
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     David Wu <david.wu@rock-chips.com>, netdev@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Kever Yang <kever.yang@rock-chips.com>, kernel@collabora.com
Date:   Fri, 23 Apr 2021 10:57:24 -0300
In-Reply-To: <ae524a70-7886-27a0-1289-0c3a1c7371bb@rock-chips.com>
References: <20210421203409.40717-1-ezequiel@collabora.com>
         <ae524a70-7886-27a0-1289-0c3a1c7371bb@rock-chips.com>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Thanks a lot for reviewing.

On Fri, 2021-04-23 at 17:24 +0800, David Wu wrote:
> Hi Ezequiel,
> 
> 在 2021/4/22 上午4:34, Ezequiel Garcia 写道:
> > Now that RK3568 SoC devicetree upstreaming is happening [1],
> > here's another round for the RK3566 dwmac. There wasn't any clear
> > consensus on how to implement the two interfaces present
> > on RK3568, so I decided to drop that and just submit RK3566 for now.
> > 
> > This has been tested on a Pine64 RK3566 Quartz64 Model B board,
> > DHCP and iperf are looking good.
> > 
> > For all the people testing, here's Quartz 64 Model B device tree
> > snippet:
> > 
> >          gmac1: ethernet@fe010000 {
> >                  compatible = "rockchip,rk3566-gmac", "snps,dwmac-4.20a";
> 
> It is better to use "rockchip,rk3568-gmac" here, "rockchip,rk3566-gmac" 
> is not compatible, 3568 has two gmacs, which are compatible with 3566.
> 
> If there is no better way, using bus_id from alias is good, it is a 
> fixed id, and U-Boot also use the id to write MAC address into kernel DTB.
> 
> plat->bus_id = of_alias_get_id(np, "ethernet");
> 

This was discussed, see ChenYu's reply. I think the idea
is considered fragile:

https://lore.kernel.org/netdev/CAGb2v67ZBR=XDFPeXQc429HNu_dbY__-KN50tvBW44fXMs78_w@mail.gmail.com/

However, I agree with you about going back to just "rockchip,rk3568-gmac".
Adding rockchip,rk3566-gmac maybe wasn't a great idea :-)

The most accepted way forward seems Heiko's proposal of hardcoding the mmio
addresses to identify each block, as it's done in the DSI driver:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c#n1170

Would you agree with it?

Thanks!
Ezequiel
 
> >                  reg = <0x0 0xfe010000 0x0 0x10000>;
> >                  interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>,
> >                               <GIC_SPI 29 IRQ_TYPE_LEVEL_HIGH>;
> >                  interrupt-names = "macirq", "eth_wake_irq";
> >                  rockchip,grf = <&grf>;
> >                  clocks = <&cru SCLK_GMAC1>, <&cru SCLK_GMAC1_RX_TX>,
> >                           <&cru SCLK_GMAC1_RX_TX>, <&cru CLK_MAC1_REFOUT>,
> >                           <&cru ACLK_GMAC1>, <&cru PCLK_GMAC1>,
> >                           <&cru SCLK_GMAC1_RX_TX>, <&cru CLK_GMAC1_PTP_REF>;
> >                  clock-names = "stmmaceth", "mac_clk_rx",
> >                                "mac_clk_tx", "clk_mac_refout",
> >                                "aclk_mac", "pclk_mac",
> >                                "clk_mac_speed", "ptp_ref";
> >                  resets = <&cru SRST_A_GMAC1>;
> >                  reset-names = "stmmaceth";
> > 
> >                  snps,mixed-burst;
> >                  snps,tso;
> > 
> >                  snps,axi-config = <&gmac1_stmmac_axi_setup>;
> >                  snps,mtl-rx-config = <&gmac1_mtl_rx_setup>;
> >                  snps,mtl-tx-config = <&gmac1_mtl_tx_setup>;
> >                  status = "disabled";
> > 
> >                  mdio1: mdio {
> >                          compatible = "snps,dwmac-mdio";
> >                          #address-cells = <0x1>;
> >                          #size-cells = <0x0>;
> >                  };
> > 
> >                  gmac1_stmmac_axi_setup: stmmac-axi-config {
> >                          snps,wr_osr_lmt = <4>;
> >                          snps,rd_osr_lmt = <8>;
> >                          snps,blen = <0 0 0 0 16 8 4>;
> >                  };
> > 
> >                  gmac1_mtl_rx_setup: rx-queues-config {
> >                          snps,rx-queues-to-use = <1>;
> >                          queue0 {};
> >                  };
> > 
> >                  gmac1_mtl_tx_setup: tx-queues-config {
> >                          snps,tx-queues-to-use = <1>;
> >                          queue0 {};
> >                  };
> >          };
> > 
> > While here, I'm adding a small patch from David Wu, for some
> > sanity checks for dwmac-rockchip-specific non-NULL ops.
> > 
> > Thanks!
> > 
> > [1] http://lore.kernel.org/r/20210421065921.23917-1-cl@rock-chips.com
> > 
> > David Wu (2):
> >    net: stmmac: dwmac-rk: Check platform-specific ops
> >    net: stmmac: Add RK3566 SoC support
> > 
> > Ezequiel Garcia (1):
> >    net: stmmac: Don't set has_gmac if has_gmac4 is set
> > 
> >   .../bindings/net/rockchip-dwmac.txt           |   1 +
> >   .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 126 +++++++++++++++++-
> >   2 files changed, 124 insertions(+), 3 deletions(-)
> > 
> 
> 


