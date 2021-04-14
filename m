Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13EF635F20B
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 13:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348030AbhDNLQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 07:16:19 -0400
Received: from gloria.sntech.de ([185.11.138.130]:33974 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232027AbhDNLQT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 07:16:19 -0400
Received: from ip5f5aa64a.dynamic.kabel-deutschland.de ([95.90.166.74] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1lWdUu-0004eF-2u; Wed, 14 Apr 2021 13:15:52 +0200
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     Ezequiel Garcia <ezequiel@collabora.com>,
        Peter Geis <pgwipeout@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Wu <david.wu@rock-chips.com>, kernel@collabora.com
Subject: Re: [PATCH net-next 3/3] net: stmmac: Add RK3566/RK3568 SoC support
Date:   Wed, 14 Apr 2021 13:15:51 +0200
Message-ID: <2596687.TLnPLrj5Ze@diego>
In-Reply-To: <CAMdYzYpyD1bTN+3Zaf4nGnN-O-c0u0koiCK45fLucL0T2+69+w@mail.gmail.com>
References: <CAMdYzYpv0dvz4X2JE4J6Qg-5D9mnkqe5RpiRC845wQpZhDKDPA@mail.gmail.com> <1412-60762b80-423-d9eaa5@27901112> <CAMdYzYpyD1bTN+3Zaf4nGnN-O-c0u0koiCK45fLucL0T2+69+w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Mittwoch, 14. April 2021, 13:03:25 CEST schrieb Peter Geis:
> On Tue, Apr 13, 2021 at 7:37 PM Ezequiel Garcia <ezequiel@collabora.com> wrote:
> > > > +static void rk3566_set_to_rmii(struct rk_priv_data *bsp_priv)
> > > > +{
> > > > +       struct device *dev = &bsp_priv->pdev->dev;
> > > > +
> > > > +       if (IS_ERR(bsp_priv->grf)) {
> > > > +               dev_err(dev, "%s: Missing rockchip,grf property\n", __func__);
> > > > +               return;
> > > > +       }
> > > > +
> > > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON1,
> > > > +                    RK3568_GMAC_PHY_INTF_SEL_RMII);
> > > > +}
> > > > +
> > > > +static void rk3568_set_to_rgmii(struct rk_priv_data *bsp_priv,
> > > > +                               int tx_delay, int rx_delay)
> > > > +{
> > > > +       struct device *dev = &bsp_priv->pdev->dev;
> > > > +
> > > > +       if (IS_ERR(bsp_priv->grf)) {
> > > > +               dev_err(dev, "Missing rockchip,grf property\n");
> > > > +               return;
> > > > +       }
> > > > +
> > > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC0_CON1,
> > > > +                    RK3568_GMAC_PHY_INTF_SEL_RGMII |
> > > > +                    RK3568_GMAC_RXCLK_DLY_ENABLE |
> > > > +                    RK3568_GMAC_TXCLK_DLY_ENABLE);
> > > > +
> > > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC0_CON0,
> > > > +                    RK3568_GMAC_CLK_RX_DL_CFG(rx_delay) |
> > > > +                    RK3568_GMAC_CLK_TX_DL_CFG(tx_delay));
> > > > +
> > > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON1,
> > > > +                    RK3568_GMAC_PHY_INTF_SEL_RGMII |
> > > > +                    RK3568_GMAC_RXCLK_DLY_ENABLE |
> > > > +                    RK3568_GMAC_TXCLK_DLY_ENABLE);
> > > > +
> > > > +       regmap_write(bsp_priv->grf, RK3568_GRF_GMAC1_CON0,
> > > > +                    RK3568_GMAC_CLK_RX_DL_CFG(rx_delay) |
> > > > +                    RK3568_GMAC_CLK_TX_DL_CFG(tx_delay));
> > >
> > > Since there are two GMACs on the rk3568, and either, or, or both may
> > > be enabled in various configurations, we should only configure the
> > > controller we are currently operating.
> 
> Perhaps we should have match data (such as reg = <0>, or against the
> address) to identify the individual controllers.

Hmm, "reg" will be used by the actual mmio address of the controller,
so matching against that should be the way I guess.

We're already doing something similar for dsi:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c#n1170


Heiko





