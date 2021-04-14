Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3042535F586
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 16:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347911AbhDNNsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 09:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347607AbhDNNsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 09:48:52 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D0FC061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 06:48:30 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 4F3851F423DC
Message-ID: <16102d157576bfa7be341ed7508e70d930e40bab.camel@collabora.com>
Subject: Re: [PATCH net-next 3/3] net: stmmac: Add RK3566/RK3568 SoC support
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Peter Geis <pgwipeout@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Wu <david.wu@rock-chips.com>, kernel@collabora.com
Date:   Wed, 14 Apr 2021 10:48:19 -0300
In-Reply-To: <2596687.TLnPLrj5Ze@diego>
References: <CAMdYzYpv0dvz4X2JE4J6Qg-5D9mnkqe5RpiRC845wQpZhDKDPA@mail.gmail.com>
         <1412-60762b80-423-d9eaa5@27901112>
         <CAMdYzYpyD1bTN+3Zaf4nGnN-O-c0u0koiCK45fLucL0T2+69+w@mail.gmail.com>
         <2596687.TLnPLrj5Ze@diego>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Peter, Heiko,

On Wed, 2021-04-14 at 13:15 +0200, Heiko Stübner wrote:
> Am Mittwoch, 14. April 2021, 13:03:25 CEST schrieb Peter Geis:
> > On Tue, Apr 13, 2021 at 7:37 PM Ezequiel Garcia <ezequiel@collabora.com> wrote:
> > > > > +static void rk3566_set_to_rmii(struct rk_priv_data *bsp_priv)
> > > > > +{
> > > > > +       struct device *dev = &bsp_priv->pdev->dev;
> > > > > +
> > > > > +       if (IS_ERR(bsp_priv->grf)) {
> > > > > +               dev_err(dev, "%s: Missing rockchip,grf property\n", __func__);
> > > > > +               return;
> > > > > +       }
> > > > > +
> > > > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON1,
> > > > > +                    RK3568_GMAC_PHY_INTF_SEL_RMII);
> > > > > +}
> > > > > +
> > > > > +static void rk3568_set_to_rgmii(struct rk_priv_data *bsp_priv,
> > > > > +                               int tx_delay, int rx_delay)
> > > > > +{
> > > > > +       struct device *dev = &bsp_priv->pdev->dev;
> > > > > +
> > > > > +       if (IS_ERR(bsp_priv->grf)) {
> > > > > +               dev_err(dev, "Missing rockchip,grf property\n");
> > > > > +               return;
> > > > > +       }
> > > > > +
> > > > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC0_CON1,
> > > > > +                    RK3568_GMAC_PHY_INTF_SEL_RGMII |
> > > > > +                    RK3568_GMAC_RXCLK_DLY_ENABLE |
> > > > > +                    RK3568_GMAC_TXCLK_DLY_ENABLE);
> > > > > +
> > > > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC0_CON0,
> > > > > +                    RK3568_GMAC_CLK_RX_DL_CFG(rx_delay) |
> > > > > +                    RK3568_GMAC_CLK_TX_DL_CFG(tx_delay));
> > > > > +
> > > > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON1,
> > > > > +                    RK3568_GMAC_PHY_INTF_SEL_RGMII |
> > > > > +                    RK3568_GMAC_RXCLK_DLY_ENABLE |
> > > > > +                    RK3568_GMAC_TXCLK_DLY_ENABLE);
> > > > > +
> > > > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON0,
> > > > > +                    RK3568_GMAC_CLK_RX_DL_CFG(rx_delay) |
> > > > > +                    RK3568_GMAC_CLK_TX_DL_CFG(tx_delay));
> > > > 
> > > > Since there are two GMACs on the rk3568, and either, or, or both may
> > > > be enabled in various configurations, we should only configure the
> > > > controller we are currently operating.
> > 
> > Perhaps we should have match data (such as reg = <0>, or against the
> > address) to identify the individual controllers.
> 
> Hmm, "reg" will be used by the actual mmio address of the controller,
> so matching against that should be the way I guess.
> 
> We're already doing something similar for dsi:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c#n1170
> 

I have to admit, I'm not a fan of hardcoding the registers in the kernel.

David Wu solved this in the downstream kernel by using bus_id,
which parses the devicetree "ethernet@0" node, i.e.:

  plat->bus_id = of_alias_get_id(np, "ethernet");

I'm inclined for this solution. Maybe Jose can suggest how to approach it?

Thanks!
Ezequiel


