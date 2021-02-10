Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B61317319
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 23:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbhBJWPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 17:15:44 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:35476 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbhBJWPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 17:15:40 -0500
Date:   Thu, 11 Feb 2021 01:14:55 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
CC:     Serge Semin <fancer.lancer@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Joao Pinto <jpinto@synopsys.com>,
        Lars Persson <larper@axis.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 16/24] net: stmmac: Use optional reset control API to
 work with stmmaceth
Message-ID: <20210210221455.jo22rq6eey3ujqmt@mobilestation>
References: <20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru>
 <20210208135609.7685-17-Sergey.Semin@baikalelectronics.ru>
 <20210210144924.6b8e7a11@xhacker.debian>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210210144924.6b8e7a11@xhacker.debian>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 02:49:24PM +0800, Jisheng Zhang wrote:
> Hi,
> 
> On Mon, 8 Feb 2021 16:56:00 +0300 Serge Semin wrote:
> 
> 
> > 
> > Since commit bb3222f71b57 ("net: stmmac: platform: use optional clk/reset
> > get APIs") a manual implementation of the optional device reset control
> > functionality has been replaced with using the
> > devm_reset_control_get_optional() method. But for some reason the optional
> > reset control handler usage hasn't been fixed and preserved the
> > NULL-checking statements. There is no need in that in order to perform the
> > reset control assertion/deassertion because the passed NULL will be
> > considered by the reset framework as absent optional reset control handler
> > anyway.
> > 
> > Fixes: bb3222f71b57 ("net: stmmac: platform: use optional clk/reset get APIs")
> 

> The patch itself looks good, but the Fix tag isn't necessary since the
> patch is a clean up rather than a bug fix. Can you please drop it in next
> version?

Ok. I'll remove it.

-Sergey

> 
> Thanks
> 
> > Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> > ---
> >  .../net/ethernet/stmicro/stmmac/stmmac_main.c | 19 ++++++++-----------
> >  1 file changed, 8 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > index 4f1bf8f6538b..a8dec219c295 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > @@ -4935,15 +4935,13 @@ int stmmac_dvr_probe(struct device *device,
> >         if ((phyaddr >= 0) && (phyaddr <= 31))
> >                 priv->plat->phy_addr = phyaddr;
> > 
> > -       if (priv->plat->stmmac_rst) {
> > -               ret = reset_control_assert(priv->plat->stmmac_rst);
> > -               reset_control_deassert(priv->plat->stmmac_rst);
> > -               /* Some reset controllers have only reset callback instead of
> > -                * assert + deassert callbacks pair.
> > -                */
> > -               if (ret == -ENOTSUPP)
> > -                       reset_control_reset(priv->plat->stmmac_rst);
> > -       }
> > +       ret = reset_control_assert(priv->plat->stmmac_rst);
> > +       reset_control_deassert(priv->plat->stmmac_rst);
> > +       /* Some reset controllers have only reset callback instead of
> > +        * assert + deassert callbacks pair.
> > +        */
> > +       if (ret == -ENOTSUPP)
> > +               reset_control_reset(priv->plat->stmmac_rst);
> > 
> >         /* Init MAC and get the capabilities */
> >         ret = stmmac_hw_init(priv);
> > @@ -5155,8 +5153,7 @@ int stmmac_dvr_remove(struct device *dev)
> >         stmmac_exit_fs(ndev);
> >  #endif
> >         phylink_destroy(priv->phylink);
> > -       if (priv->plat->stmmac_rst)
> > -               reset_control_assert(priv->plat->stmmac_rst);
> > +       reset_control_assert(priv->plat->stmmac_rst);
> >         if (priv->hw->pcs != STMMAC_PCS_TBI &&
> >             priv->hw->pcs != STMMAC_PCS_RTBI)
> >                 stmmac_mdio_unregister(ndev);
> > --
> > 2.29.2
> > 
> 
