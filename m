Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55ED1FCCA6
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 13:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgFQLke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 07:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgFQLke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 07:40:34 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F44C061573
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 04:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RQChsn5dbxF8uQdv6uUAs1LjUAuefigV93vqEhqbEWE=; b=boOn9u2F/xXNt7jaBLo9/PQUm
        AiPaSlk5jydP+RRbBQOQ9FzXW63iA+IB+pRJWVeC+FdOVVxmuZ0bBVo1FSS5R19I8fLaulWe33Jrr
        LAZksEBuMwPRb0J4ks9+wjfbcU9F5VZLA4+lYSho3v+VLLKNdOlSAjNZCSGUZ4TFS13+zHmLWTasC
        jDLF5GSbJPGf0WpNWGreUmKdmZiaeDmMRdNRyF5rr+VIuHibpMdz1fLGlbfPeazci4q9hiI8Bg66q
        Zm5FHxi7PHVyf3BsWVEYbQRuqxRBKP3SAy5Ov3aLudE5Oc9ZLHnS7UeEQfLRGlY+7Mut5Mhie3odd
        Qmq83Tehg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58464)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jlWQd-0003hH-LP; Wed, 17 Jun 2020 12:40:27 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jlWQb-0003ho-My; Wed, 17 Jun 2020 12:40:25 +0100
Date:   Wed, 17 Jun 2020 12:40:25 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Helmut Grohne <helmut.grohne@intenta.de>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: macb: reject unsupported rgmii delays
Message-ID: <20200617114025.GQ1551@shell.armlinux.org.uk>
References: <20200616074955.GA9092@laureti-dev>
 <20200617105518.GO1551@shell.armlinux.org.uk>
 <20200617112153.GB28783@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617112153.GB28783@laureti-dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 01:21:53PM +0200, Helmut Grohne wrote:
> On Wed, Jun 17, 2020 at 12:55:18PM +0200, Russell King - ARM Linux admin wrote:
> > The individual RGMII delay modes are more about what the PHY itself is
> > asked to do with respect to inserting delays, so I don't think your
> > patch makes sense.
> 
> This seems to be the same aspect that Vladimir Oltean remarked. I agree
> that the relevant hunk should be dropped.
> 
> > > --- a/drivers/net/ethernet/cadence/macb_main.c
> > > +++ b/drivers/net/ethernet/cadence/macb_main.c
> > > @@ -514,7 +514,7 @@ static void macb_validate(struct phylink_config *config,
> > >  	    state->interface != PHY_INTERFACE_MODE_RMII &&
> > >  	    state->interface != PHY_INTERFACE_MODE_GMII &&
> > >  	    state->interface != PHY_INTERFACE_MODE_SGMII &&
> > > -	    !phy_interface_mode_is_rgmii(state->interface)) {
> > > +	    state->interface != PHY_INTERFACE_MODE_RGMII_ID) {
> > 
> > Here you reject everything except PHY_INTERFACE_MODE_RGMII_ID.
> > 
> > >  		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> > >  		return;
> > >  	}
> > > @@ -694,6 +694,13 @@ static int macb_phylink_connect(struct macb *bp)
> > >  	struct phy_device *phydev;
> > >  	int ret;
> > >  
> > > +	if (of_phy_is_fixed_link(dn) &&
> > > +	    phy_interface_mode_is_rgmii(bp->phy_interface) &&
> > > +	    bp->phy_interface != PHY_INTERFACE_MODE_RGMII) {
> > 
> > but here you reject everything except PHY_INTERFACE_MODE_RGMII.  These
> > can't both be right.  If you start with PHY_INTERFACE_MODE_RGMII, and
> > have a fixed link, you'll have PHY_INTERFACE_MODE_RGMII passed into
> > the validate function, which will then fail.
> 
> For a fixed-link, the validation function is never called. Therefore, it
> cannot reject PHY_INTERFACE_MODE_RGMII. It works in practice.

Hmm, I'm not so sure, but then I don't know exactly what code you're
using.  Looking at mainline, even for a fixed link, you call
phylink_create().  phylink_create() will spot the fixed link, and
parse the description, calling the validation function.  If that
fails, it will generate a warning at that point:

  "fixed link %s duplex %dMbps not recognised"

It doesn't cause an operational failure, but it means that you end up
with a zero supported mask, which is likely not expected.

This is not an expected situation, so I'll modify your claim to "it
works but issues a warning" which still means that it's not correct.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
