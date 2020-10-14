Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2374028E127
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 15:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388410AbgJNNUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 09:20:06 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:35672 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388358AbgJNNUF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 09:20:05 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 6B0A3412D0;
        Wed, 14 Oct 2020 13:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-transfer-encoding:mime-version:user-agent:content-type
        :content-type:organization:references:in-reply-to:date:date:from
        :from:subject:subject:message-id:received:received:received; s=
        mta-01; t=1602681599; x=1604496000; bh=1lgZHuX3krJKu7YHjDu7Ldjeb
        Om4rKtxnE0OhMoc3x4=; b=W7EoTmJ+mH4FzLN/ZfcPAXQa/vF1Kubvh/b8sknH4
        YGgOL0uiJ2Ks1TggQfyQ9kQngJtYtGE/a6uFzgFsJlkEQATuZOA7N8Eza8P76x26
        9mt5U2Dxw/qTrVVqTol8Q+ghfrVKePlqQPf3zy2ynvrXaufhZ89Cu1QoNRJiBZ63
        To=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id M_K4M6XKhlYk; Wed, 14 Oct 2020 16:19:59 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id E539C412CA;
        Wed, 14 Oct 2020 16:19:57 +0300 (MSK)
Received: from localhost.localdomain (10.199.3.118) by
 T-EXCH-04.corp.yadro.com (172.17.100.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 14 Oct 2020 16:19:57 +0300
Message-ID: <b10f8b366e0971f8809ecfb3d80e00aa42aa4387.camel@yadro.com>
Subject: Re: [PATCH 1/1] net: ftgmac100: add handling of mdio/phy nodes for
 ast2400/2500
From:   Ivan Mikhaylov <i.mikhaylov@yadro.com>
To:     Joel Stanley <joel@jms.id.au>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        <netdev@vger.kernel.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Date:   Wed, 14 Oct 2020 16:24:09 +0300
In-Reply-To: <CACPK8Xd_gCVjVm13O85+mnZ4VbhQorG4qiy+mVevrvyCbPg9XQ@mail.gmail.com>
References: <20201013124014.2989-1-i.mikhaylov@yadro.com>
         <20201013124014.2989-2-i.mikhaylov@yadro.com>
         <CACPK8Xd_gCVjVm13O85+mnZ4VbhQorG4qiy+mVevrvyCbPg9XQ@mail.gmail.com>
Organization: YADRO
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.199.3.118]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-10-14 at 05:23 +0000, Joel Stanley wrote:
> Hi Ivan,
> 
> On Tue, 13 Oct 2020 at 12:38, Ivan Mikhaylov <i.mikhaylov@yadro.com> wrote:
> > phy-handle can't be handled well for ast2400/2500 which has an embedded
> > MDIO controller. Add ftgmac100_mdio_setup for ast2400/2500 and initialize
> > PHYs from mdio child node with of_mdiobus_register.
> 
> Good idea. The driver has become a mess of different ways to connect
> the phy and it needs to be cleaned up. I have a patch that fixes
> rmmod, which is currently broken.
> 
> 
> 
> > Signed-off-by: Ivan Mikhaylov <i.mikhaylov@yadro.com>
> > ---
> >  drivers/net/ethernet/faraday/ftgmac100.c | 114 ++++++++++++++---------
> >  1 file changed, 69 insertions(+), 45 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/faraday/ftgmac100.c
> > b/drivers/net/ethernet/faraday/ftgmac100.c
> > index 87236206366f..e32066519ec1 100644
> > --- a/drivers/net/ethernet/faraday/ftgmac100.c
> > +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> > @@ -1044,11 +1044,47 @@ static void ftgmac100_adjust_link(struct net_device
> > *netdev)
> >         schedule_work(&priv->reset_task);
> >  }
> > 
> > -static int ftgmac100_mii_probe(struct ftgmac100 *priv, phy_interface_t
> > intf)
> > +static int ftgmac100_mii_probe(struct net_device *netdev)
> >  {
> > -       struct net_device *netdev = priv->netdev;
> > +       struct ftgmac100 *priv = netdev_priv(netdev);
> > +       struct platform_device *pdev = to_platform_device(priv->dev);
> > +       struct device_node *np = pdev->dev.of_node;
> > +       phy_interface_t phy_intf = PHY_INTERFACE_MODE_RGMII;
> >         struct phy_device *phydev;
> > 
> > +       /* Get PHY mode from device-tree */
> > +       if (np) {
> > +               /* Default to RGMII. It's a gigabit part after all */
> > +               phy_intf = of_get_phy_mode(np, &phy_intf);
> > +               if (phy_intf < 0)
> > +                       phy_intf = PHY_INTERFACE_MODE_RGMII;
> > +
> > +               /* Aspeed only supports these. I don't know about other IP
> > +                * block vendors so I'm going to just let them through for
> > +                * now. Note that this is only a warning if for some obscure
> > +                * reason the DT really means to lie about it or it's a
> > newer
> > +                * part we don't know about.
> > +                *
> > +                * On the Aspeed SoC there are additionally straps and SCU
> > +                * control bits that could tell us what the interface is
> > +                * (or allow us to configure it while the IP block is held
> > +                * in reset). For now I chose to keep this driver away from
> > +                * those SoC specific bits and assume the device-tree is
> > +                * right and the SCU has been configured properly by pinmux
> > +                * or the firmware.
> > +                */
> > +               if (priv->is_aspeed &&
> > +                   phy_intf != PHY_INTERFACE_MODE_RMII &&
> > +                   phy_intf != PHY_INTERFACE_MODE_RGMII &&
> > +                   phy_intf != PHY_INTERFACE_MODE_RGMII_ID &&
> > +                   phy_intf != PHY_INTERFACE_MODE_RGMII_RXID &&
> > +                   phy_intf != PHY_INTERFACE_MODE_RGMII_TXID) {
> > +                       netdev_warn(netdev,
> > +                                   "Unsupported PHY mode %s !\n",
> > +                                   phy_modes(phy_intf));
> > +               }
> 
> Why do we move this?

I've tried to detach PHY connect from ftgmac100_setup_mdio register function.
Tried to decouple MDIO and PHY levels.

> 
> > +       }
> > +
> >         phydev = phy_find_first(priv->mii_bus);
> >         if (!phydev) {
> >                 netdev_info(netdev, "%s: no PHY found\n", netdev->name);
> > @@ -1056,7 +1092,7 @@ static int ftgmac100_mii_probe(struct ftgmac100 *priv,
> > phy_interface_t intf)
> >         }
> > 
> >         phydev = phy_connect(netdev, phydev_name(phydev),
> > -                            &ftgmac100_adjust_link, intf);
> > +                            &ftgmac100_adjust_link, phy_intf);
> > 
> >         if (IS_ERR(phydev)) {
> >                 netdev_err(netdev, "%s: Could not attach to PHY\n", netdev-
> > >name);
> > @@ -1601,8 +1637,8 @@ static int ftgmac100_setup_mdio(struct net_device
> > *netdev)
> >  {
> >         struct ftgmac100 *priv = netdev_priv(netdev);
> >         struct platform_device *pdev = to_platform_device(priv->dev);
> > -       phy_interface_t phy_intf = PHY_INTERFACE_MODE_RGMII;
> >         struct device_node *np = pdev->dev.of_node;
> > +       struct device_node *mdio_np;
> >         int i, err = 0;
> >         u32 reg;
> > 
> > @@ -1623,39 +1659,6 @@ static int ftgmac100_setup_mdio(struct net_device
> > *netdev)
> >                 iowrite32(reg, priv->base + FTGMAC100_OFFSET_REVR);
> >         }
> > 
> > -       /* Get PHY mode from device-tree */
> > -       if (np) {
> > -               /* Default to RGMII. It's a gigabit part after all */
> > -               err = of_get_phy_mode(np, &phy_intf);
> > -               if (err)
> > -                       phy_intf = PHY_INTERFACE_MODE_RGMII;
> > -
> > -               /* Aspeed only supports these. I don't know about other IP
> > -                * block vendors so I'm going to just let them through for
> > -                * now. Note that this is only a warning if for some obscure
> > -                * reason the DT really means to lie about it or it's a
> > newer
> > -                * part we don't know about.
> > -                *
> > -                * On the Aspeed SoC there are additionally straps and SCU
> > -                * control bits that could tell us what the interface is
> > -                * (or allow us to configure it while the IP block is held
> > -                * in reset). For now I chose to keep this driver away from
> > -                * those SoC specific bits and assume the device-tree is
> > -                * right and the SCU has been configured properly by pinmux
> > -                * or the firmware.
> > -                */
> > -               if (priv->is_aspeed &&
> > -                   phy_intf != PHY_INTERFACE_MODE_RMII &&
> > -                   phy_intf != PHY_INTERFACE_MODE_RGMII &&
> > -                   phy_intf != PHY_INTERFACE_MODE_RGMII_ID &&
> > -                   phy_intf != PHY_INTERFACE_MODE_RGMII_RXID &&
> > -                   phy_intf != PHY_INTERFACE_MODE_RGMII_TXID) {
> > -                       netdev_warn(netdev,
> > -                                  "Unsupported PHY mode %s !\n",
> > -                                  phy_modes(phy_intf));
> > -               }
> > -       }
> > -
> >         priv->mii_bus->name = "ftgmac100_mdio";
> >         snprintf(priv->mii_bus->id, MII_BUS_ID_SIZE, "%s-%d",
> >                  pdev->name, pdev->id);
> > @@ -1667,22 +1670,22 @@ static int ftgmac100_setup_mdio(struct net_device
> > *netdev)
> >         for (i = 0; i < PHY_MAX_ADDR; i++)
> >                 priv->mii_bus->irq[i] = PHY_POLL;
> > 
> > -       err = mdiobus_register(priv->mii_bus);
> > +       mdio_np = of_get_child_by_name(np, "mdio");
> > +       if (mdio_np)
> > +               err = of_mdiobus_register(priv->mii_bus, mdio_np);
> > +       else
> > +               err = mdiobus_register(priv->mii_bus);
> > +
> >         if (err) {
> >                 dev_err(priv->dev, "Cannot register MDIO bus!\n");
> >                 goto err_register_mdiobus;
> >         }
> > 
> > -       err = ftgmac100_mii_probe(priv, phy_intf);
> > -       if (err) {
> > -               dev_err(priv->dev, "MII Probe failed!\n");
> > -               goto err_mii_probe;
> > -       }
> > +       if (mdio_np)
> > +               of_node_put(mdio_np);
> 
> By the time I get down here I'm lost. Do you think you could split the
> change up into a few smaller patches?
> 
> If not, try to explain what the various hunks of your change are trying to do.
> 

Yes, you're right, I see two patches for now from your comments:
1. phy connect detach from ftgmac100_setup_mdio
2. add ast2400/2500 phy-handle support

Thanks.

