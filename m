Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19EEF3A88A1
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 20:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbhFOSdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 14:33:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38404 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229613AbhFOSdP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 14:33:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=yIkDKcAiuUGTNDzOd0+ynNUGACa6fo1Rn0W0JLTlqSI=; b=nypU3yGojFccGLSdVs/5UrPF0p
        s3sJVNZjwl7wD+aInNte6WH3rKFApTG7WV5JcLe4FfJht1Nq79mJqUdjUI3iL6FcF/5vmpIIgbdd0
        BvmnTuHNwz/YHvmSmkifocTvJIrWTS8H46CrPomfdzxyjbq7NixSUxIkdbt9DCp0C++U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltDq6-009ZCb-9m; Tue, 15 Jun 2021 20:31:06 +0200
Date:   Tue, 15 Jun 2021 20:31:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        calvin.johnson@oss.nxp.com, hkallweit1@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next] mdio: mdiobus: setup of_node for the MDIO device
Message-ID: <YMjx6iBD88+xdODZ@lunn.ch>
References: <20210615154401.1274322-1-ciorneiioana@gmail.com>
 <20210615171330.GW22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615171330.GW22278@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 06:13:31PM +0100, Russell King (Oracle) wrote:
> On Tue, Jun 15, 2021 at 06:44:01PM +0300, Ioana Ciornei wrote:
> > From: Ioana Ciornei <ioana.ciornei@nxp.com>
> > 
> > By mistake, the of_node of the MDIO device was not setup in the patch
> > linked below. As a consequence, any PHY driver that depends on the
> > of_node in its probe callback was not be able to successfully finish its
> > probe on a PHY, thus the Generic PHY driver was used instead.
> > 
> > Fix this by actually setting up the of_node.
> > 
> > Fixes: bc1bee3b87ee ("net: mdiobus: Introduce fwnode_mdiobus_register_phy()")
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > ---
> >  drivers/net/mdio/fwnode_mdio.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
> > index e96766da8de4..283ddb1185bd 100644
> > --- a/drivers/net/mdio/fwnode_mdio.c
> > +++ b/drivers/net/mdio/fwnode_mdio.c
> > @@ -65,6 +65,7 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
> >  	 * can be looked up later
> >  	 */
> >  	fwnode_handle_get(child);
> > +	phy->mdio.dev.of_node = to_of_node(child);
> >  	phy->mdio.dev.fwnode = child;
> 
> Yes, this is something that was missed, but let's first look at what
> other places to when setting up a device:
> 
>         pdev->dev.fwnode = pdevinfo->fwnode;
>         pdev->dev.of_node = of_node_get(to_of_node(pdev->dev.fwnode));
>         pdev->dev.of_node_reused = pdevinfo->of_node_reused;
> 
>         dev->dev.of_node = of_node_get(np);
>         dev->dev.fwnode = &np->fwnode;
> 
>         dev->dev.of_node = of_node_get(node);
>         dev->dev.fwnode = &node->fwnode;
> 
> That seems to be pretty clear that an of_node_get() is also needed.

I think it also shows we have very little consistency, and the recent
patchset needs a bit of cleanup. Maybe yet another helper which when
passed a struct device * and a node pointer, it sets both values?

	 Andrew
