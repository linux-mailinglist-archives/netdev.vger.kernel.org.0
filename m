Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DACDC64A40D
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 16:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbiLLPX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 10:23:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiLLPX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 10:23:26 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C092DEC6;
        Mon, 12 Dec 2022 07:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=d438kEu4qOLcbFU0URbQJriH5Y4n1xPR4eyQliRbNVg=; b=s74zTubE3Doqlg41fuRrBNF/o1
        JP/4EJXdvCTx2Omjp//leDXooDFHx4iKbMNAy6UjIt6OULjw8OVYLeNQdMg42MP9yNsmtbyJLkEua
        k7ucGTq5RCmeeS4yosZJCD6kq+OuEgZ99PwhWMe+vqNe19XtIFmTmjqswt1wn71mcOnE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p4kdn-00562d-DZ; Mon, 12 Dec 2022 16:22:51 +0100
Date:   Mon, 12 Dec 2022 16:22:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v6 net-next 3/5] drivers/net/phy: add connection between
 ethtool and phylib for PLCA
Message-ID: <Y5dHS8jJkxS+aS/Q@lunn.ch>
References: <cover.1670712151.git.piergiorgio.beruto@gmail.com>
 <75cb0eab15e62fc350e86ba9e5b0af72ea45b484.1670712151.git.piergiorgio.beruto@gmail.com>
 <Y5XL2fqXSRmDgkUQ@shell.armlinux.org.uk>
 <Y5Ypc5fDP3Cbi+RZ@gvm01>
 <Y5Y+xu4Rk6ptCERg@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5Y+xu4Rk6ptCERg@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 11, 2022 at 08:34:14PM +0000, Russell King (Oracle) wrote:
> On Sun, Dec 11, 2022 at 08:03:15PM +0100, Piergiorgio Beruto wrote:
> > On Sun, Dec 11, 2022 at 12:23:53PM +0000, Russell King (Oracle) wrote:
> > > On Sat, Dec 10, 2022 at 11:46:39PM +0100, Piergiorgio Beruto wrote:
> > > > This patch adds the required connection between netlink ethtool and
> > > > phylib to resolve PLCA get/set config and get status messages.
> > > > 
> > > > Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> > > > ---
> > > >  drivers/net/phy/phy.c        | 175 +++++++++++++++++++++++++++++++++++
> > > >  drivers/net/phy/phy_device.c |   3 +
> > > >  include/linux/phy.h          |   7 ++
> > > >  3 files changed, 185 insertions(+)
> > > > 
> > > > diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> > > > index e5b6cb1a77f9..40d90ed2f0fb 100644
> > > > --- a/drivers/net/phy/phy.c
> > > > +++ b/drivers/net/phy/phy.c
> > > > @@ -543,6 +543,181 @@ int phy_ethtool_get_stats(struct phy_device *phydev,
> > > >  }
> > > >  EXPORT_SYMBOL(phy_ethtool_get_stats);
> > > >  
> > > > +/**
> > > > + * phy_ethtool_get_plca_cfg - Get PLCA RS configuration
> > > > + *
> > > 
> > > You shouldn't have an empty line in the comment here
> > I was trying to follow the style of this file. All other functions start
> > like this, including an empty line. Do you want me to:
> > a) follow your indication and leave all other functions as they are?
> > b) Change all functions docs to follow your suggestion?
> > c) leave it as-is?
> > 
> > Please, advise.
> 
> Please see Documentation/doc-guide/kernel-doc.rst
> 
> "Function parameters
> ~~~~~~~~~~~~~~~~~~~
> 
> Each function argument should be described in order, immediately following
> the short function description.  Do not leave a blank line between the
> function description and the arguments, nor between the arguments."
> 
> Note the last sentence - there should _not_ be a blank line, so please
> follow this for new submissions. I don't think we care enough to fix
> what's already there though.
> 
> > 
> > > 
> > > > + * @phydev: the phy_device struct
> > > > + * @plca_cfg: where to store the retrieved configuration
> > > 
> > > Maybe have an empty line, followed by a bit of text describing what this
> > > function does and the return codes it generates?
> > Again, I was trying to follow the style of the docs in this file.
> > Do you still want me to add a description here?
> 
> Convention is a blank line - as illustrated by the general format
> in the documentation file I refer to above.
> 
> > 
> > > 
> > > > + */
> > > > +int phy_ethtool_get_plca_cfg(struct phy_device *phydev,
> > > > +			     struct phy_plca_cfg *plca_cfg)
> > > > +{
> > > > +	int ret;
> > > > +
> > > > +	if (!phydev->drv) {
> > > > +		ret = -EIO;
> > > > +		goto out;
> > > > +	}
> > > > +
> > > > +	if (!phydev->drv->get_plca_cfg) {
> > > > +		ret = -EOPNOTSUPP;
> > Once more, all other functions in this file take the mutex -after-
> > checking for phydev->drv and checking the specific function. Therefore,
> > I assumed that was a safe thing to do. If not, should we fix all of
> > these functions in this file?
> 
> This is a review comment I've made already, but you seem to have ignored
> it. Please ensure that new contributions are safe. Yes, existing code
> may not be, and that's something we should fix, but your contribution
> should at least be safer than the existing code.

I have a patch ready for fixing the cable test examples of performing
the test before taking the lock. I was going to post it to net-next in
a couple of weeks time. Or do you think it should be to net?

	Andrew
