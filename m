Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7876D1FCC28
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 13:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgFQLV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 07:21:59 -0400
Received: from mail.intenta.de ([178.249.25.132]:42895 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgFQLV6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 07:21:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=fMj+rxRoQetuNQLrf/xuaRctE+S79uoQja9i6d5hznI=;
        b=OYwsva40BBclxE9twZZr9EjpDYzj6P0j9O2emYLldjN/j1Kq3ROTcv4DvJZZ/hoFf9+3VA1KM10Mtcfwrmrk0rpp59RT8llH+Oj5+ipIoCZ0DruJEHMUKwwKOqlulmAf2SwptXCTKjbMNUwglOxYrjGYBlrB4gCbnotfTY6yCVgpG5FBW/DfNPNG9ffk+HS0zO9gVZMDDPHyMweQZj0YQBFp8zGikc70luDbage7G4zKrc8wi29y1s59SZnOqApIiAK1h16/Thti4ee3V8C8Dcz5ve6UkqzHawHQS8HVbFrtLFrs8jK9XBJxTYLxTdUWqNG9jiQdjUNyHOOEABbQ1g==;
Date:   Wed, 17 Jun 2020 13:21:53 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: macb: reject unsupported rgmii delays
Message-ID: <20200617112153.GB28783@laureti-dev>
References: <20200616074955.GA9092@laureti-dev>
 <20200617105518.GO1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200617105518.GO1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 12:55:18PM +0200, Russell King - ARM Linux admin wrote:
> The individual RGMII delay modes are more about what the PHY itself is
> asked to do with respect to inserting delays, so I don't think your
> patch makes sense.

This seems to be the same aspect that Vladimir Oltean remarked. I agree
that the relevant hunk should be dropped.

> > --- a/drivers/net/ethernet/cadence/macb_main.c
> > +++ b/drivers/net/ethernet/cadence/macb_main.c
> > @@ -514,7 +514,7 @@ static void macb_validate(struct phylink_config *config,
> >  	    state->interface != PHY_INTERFACE_MODE_RMII &&
> >  	    state->interface != PHY_INTERFACE_MODE_GMII &&
> >  	    state->interface != PHY_INTERFACE_MODE_SGMII &&
> > -	    !phy_interface_mode_is_rgmii(state->interface)) {
> > +	    state->interface != PHY_INTERFACE_MODE_RGMII_ID) {
> 
> Here you reject everything except PHY_INTERFACE_MODE_RGMII_ID.
> 
> >  		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> >  		return;
> >  	}
> > @@ -694,6 +694,13 @@ static int macb_phylink_connect(struct macb *bp)
> >  	struct phy_device *phydev;
> >  	int ret;
> >  
> > +	if (of_phy_is_fixed_link(dn) &&
> > +	    phy_interface_mode_is_rgmii(bp->phy_interface) &&
> > +	    bp->phy_interface != PHY_INTERFACE_MODE_RGMII) {
> 
> but here you reject everything except PHY_INTERFACE_MODE_RGMII.  These
> can't both be right.  If you start with PHY_INTERFACE_MODE_RGMII, and
> have a fixed link, you'll have PHY_INTERFACE_MODE_RGMII passed into
> the validate function, which will then fail.

For a fixed-link, the validation function is never called. Therefore, it
cannot reject PHY_INTERFACE_MODE_RGMII. It works in practice.

However, the consensus is to not reject that mode in the validation
function.

Helmut
