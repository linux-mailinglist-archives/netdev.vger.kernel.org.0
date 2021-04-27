Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79D136C5F2
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 14:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236039AbhD0MTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 08:19:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42960 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235410AbhD0MTn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 08:19:43 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lbMft-001MSc-73; Tue, 27 Apr 2021 14:18:45 +0200
Date:   Tue, 27 Apr 2021 14:18:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     "Jisheng.Zhang@synaptics.com" <Jisheng.Zhang@synaptics.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH V2 net] net: stmmac: fix MAC WoL unwork if PHY doesn't
 support WoL
Message-ID: <YIgBJQi1H+f2VGWf@lunn.ch>
References: <20210426090447.14323-1-qiangqing.zhang@nxp.com>
 <YIa6hnmYhOAOyZLY@lunn.ch>
 <DB8PR04MB6795A418BE733407FB4B7AF6E6419@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB6795A418BE733407FB4B7AF6E6419@DB8PR04MB6795.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> According to your comments, I did a quick draft, and have not test
> yet, could you please review the logic to see if I understand you
> correctly?


> 
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> @@ -647,18 +647,7 @@ static void stmmac_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
>  static int stmmac_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
>  {
>         struct stmmac_priv *priv = netdev_priv(dev);
> -       u32 support = WAKE_MAGIC | WAKE_UCAST;
> -
> -       if (!device_can_wakeup(priv->device))
> -               return -EOPNOTSUPP;
> -
> -       if (!priv->plat->pmt) {
> -               int ret = phylink_ethtool_set_wol(priv->phylink, wol);
> -
> -               if (!ret)
> -                       device_set_wakeup_enable(priv->device, !!wol->wolopts);
> -               return ret;
> -       }
> +       u32 support = WAKE_MAGIC | WAKE_UCAST | WAKE_MAGICSECURE |  WAKE_BCAST;
> 
>         /* By default almost all GMAC devices support the WoL via
>          * magic frame but we can disable it if the HW capability
> @@ -669,13 +658,24 @@ static int stmmac_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
>         if (wol->wolopts & ~support)
>                 return -EINVAL;
> 
> -       if (wol->wolopts) {
> -               pr_info("stmmac: wakeup enable\n");
> -               device_set_wakeup_enable(priv->device, 1);
> -               enable_irq_wake(priv->wol_irq);
> -       } else {
> +       if (!wol->wolopts) {
> +               device_set_wakeup_capable(priv->device, 0);
>                 device_set_wakeup_enable(priv->device, 0);
>                 disable_irq_wake(priv->wol_irq);
> +       } else {
> +               if (priv->plat->pmt && ((wol->wolopts & WAKE_MAGIC) || (wol->wolopts & WAKE_UCAST))) {
> +                       pr_info("stmmac: mac wakeup enable\n");
> +                       enable_irq_wake(priv->wol_irq);
> +               } else {
> +                       int ret = phylink_ethtool_set_wol(priv->phylink, wol);

You can have multiple wake up sources enabled at the same time. So the
if/else is wrong here. It could be, some are provided by the MAC and
some by the PHY.

If you are trying to save power, it is better if the PHY provides the
WoL sources. If the PHY can provide all the required WoL sources, you
can turn the MAC off and save more power. So give priority to the PHY.

    Andrew
