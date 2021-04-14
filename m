Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D8235F92E
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 18:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346777AbhDNQpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 12:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233976AbhDNQpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 12:45:12 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401A2C061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 09:44:48 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 38F711F42831
Message-ID: <e66104ed9bd0600bcd21d4ed2de20a4fbca12e82.camel@collabora.com>
Subject: Re: [PATCH net-next 3/3] net: stmmac: Add RK3566/RK3568 SoC support
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Chen-Yu Tsai <wens213@gmail.com>
Cc:     Peter Geis <pgwipeout@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Wu <david.wu@rock-chips.com>, kernel@collabora.com
Date:   Wed, 14 Apr 2021 13:44:35 -0300
In-Reply-To: <11053800.MucGe3eQFb@diego>
References: <CAMdYzYpv0dvz4X2JE4J6Qg-5D9mnkqe5RpiRC845wQpZhDKDPA@mail.gmail.com>
         <16102d157576bfa7be341ed7508e70d930e40bab.camel@collabora.com>
         <CAGb2v67ZBR=XDFPeXQc429HNu_dbY__-KN50tvBW44fXMs78_w@mail.gmail.com>
         <11053800.MucGe3eQFb@diego>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-04-14 at 18:35 +0200, Heiko Stübner wrote:
> Am Mittwoch, 14. April 2021, 18:33:12 CEST schrieb Chen-Yu Tsai:
> > On Thu, Apr 15, 2021 at 12:14 AM Ezequiel Garcia <ezequiel@collabora.com> wrote:
> > > 
> > > Hi Peter, Heiko,
> > > 
> > > On Wed, 2021-04-14 at 13:15 +0200, Heiko Stübner wrote:
> > > > Am Mittwoch, 14. April 2021, 13:03:25 CEST schrieb Peter Geis:
> > > > > On Tue, Apr 13, 2021 at 7:37 PM Ezequiel Garcia <ezequiel@collabora.com> wrote:
> > > > > > > > +static void rk3566_set_to_rmii(struct rk_priv_data *bsp_priv)
> > > > > > > > +{
> > > > > > > > +       struct device *dev = &bsp_priv->pdev->dev;
> > > > > > > > +
> > > > > > > > +       if (IS_ERR(bsp_priv->grf)) {
> > > > > > > > +               dev_err(dev, "%s: Missing rockchip,grf property\n", __func__);
> > > > > > > > +               return;
> > > > > > > > +       }
> > > > > > > > +
> > > > > > > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON1,
> > > > > > > > +                    RK3568_GMAC_PHY_INTF_SEL_RMII);
> > > > > > > > +}
> > > > > > > > +
> > > > > > > > +static void rk3568_set_to_rgmii(struct rk_priv_data *bsp_priv,
> > > > > > > > +                               int tx_delay, int rx_delay)
> > > > > > > > +{
> > > > > > > > +       struct device *dev = &bsp_priv->pdev->dev;
> > > > > > > > +
> > > > > > > > +       if (IS_ERR(bsp_priv->grf)) {
> > > > > > > > +               dev_err(dev, "Missing rockchip,grf property\n");
> > > > > > > > +               return;
> > > > > > > > +       }
> > > > > > > > +
> > > > > > > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC0_CON1,
> > > > > > > > +                    RK3568_GMAC_PHY_INTF_SEL_RGMII |
> > > > > > > > +                    RK3568_GMAC_RXCLK_DLY_ENABLE |
> > > > > > > > +                    RK3568_GMAC_TXCLK_DLY_ENABLE);
> > > > > > > > +
> > > > > > > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC0_CON0,
> > > > > > > > +                    RK3568_GMAC_CLK_RX_DL_CFG(rx_delay) |
> > > > > > > > +                    RK3568_GMAC_CLK_TX_DL_CFG(tx_delay));
> > > > > > > > +
> > > > > > > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON1,
> > > > > > > > +                    RK3568_GMAC_PHY_INTF_SEL_RGMII |
> > > > > > > > +                    RK3568_GMAC_RXCLK_DLY_ENABLE |
> > > > > > > > +                    RK3568_GMAC_TXCLK_DLY_ENABLE);
> > > > > > > > +
> > > > > > > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON0,
> > > > > > > > +                    RK3568_GMAC_CLK_RX_DL_CFG(rx_delay) |
> > > > > > > > +                    RK3568_GMAC_CLK_TX_DL_CFG(tx_delay));
> > > > > > > 
> > > > > > > Since there are two GMACs on the rk3568, and either, or, or both may
> > > > > > > be enabled in various configurations, we should only configure the
> > > > > > > controller we are currently operating.
> > > > > 
> > > > > Perhaps we should have match data (such as reg = <0>, or against the
> > > > > address) to identify the individual controllers.
> > > > 
> > > > Hmm, "reg" will be used by the actual mmio address of the controller,
> > > > so matching against that should be the way I guess.
> > > > 
> > > > We're already doing something similar for dsi:
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c#n1170
> > > > 
> > > 
> > > I have to admit, I'm not a fan of hardcoding the registers in the kernel.
> > > 
> > > David Wu solved this in the downstream kernel by using bus_id,
> > > which parses the devicetree "ethernet@0" node, i.e.:
> > > 
> > >   plat->bus_id = of_alias_get_id(np, "ethernet");
> > 
> > What happens when one adds another ethernet controller (USB or PCIe) to
> > the board and wants to change the numbering order?
> > 
> > Or maybe only the second ethernet controller is routed on some board
> > and the submitter / vendor wants that one to be ethernet0, because
> > it's the only usable controller?
> 
> Which matches a discussion I had with Arnd about the mmc numbering.
> I.e. there the first mmc device is supposed to be mmc0 and so on,
> without gaps - for probably the same reasons.
> 
> 

Well, given each controller has its own register space, maybe
just model it with a new reg cell or a DT property that is able
to directly encode the base address?

Looking at the vendor kernel, XPCS will have another set of registers,
separate for each MAC.

Thanks,
Ezequiel

> > 
> > This seems even more fragile than hardcoding the registers.
> > 
> > Regards
> > ChenYu
> > 
> 
> 
> 
> 


