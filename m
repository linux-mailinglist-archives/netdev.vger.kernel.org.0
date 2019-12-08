Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3959116310
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 17:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfLHQm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Dec 2019 11:42:59 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:47736 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbfLHQm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Dec 2019 11:42:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Lg4pyxgsh3NGp2HVgi/qt21D2DbYf859Z8BTeto/GhA=; b=zkHUqmHgVNxMdPVyLW2kziT9M
        1aGefYb4Jwn2h+8tXNTSlcJAuXBfR0JJM6zXi/osymRriUcXTabUhceY3DWprjw1o7QfybT1ql2+7
        qWT12zrwex3rEMdMNxmgg+zJ3qHSgWlAd16nMYRJVje+sueOPnGkzDCTsjeaK7K7Xpie994klDWy/
        v4mRBlmPcBuvKubNXGoEkHDRiage5H4cIqgY/WWQs7QCOwfJkYJTEfOqTngYS0fneot9Pr0vOl1D2
        vLfFaotDigsbez3neA4NLupTRc1RA44dvC8e0VNa3SNEObBPrQnID7gHawePEkLeOfvzXnBXiBkT8
        WRg1wCW/w==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:38574)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1idzdp-0005uX-5G; Sun, 08 Dec 2019 16:42:41 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1idzdk-0002mt-1z; Sun, 08 Dec 2019 16:42:36 +0000
Date:   Sun, 8 Dec 2019 16:42:36 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     Willy Tarreau <w@1wt.eu>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        maxime.chevallier@bootlin.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mvpp2: fix condition for setting up link
 interrupt
Message-ID: <20191208164235.GT1344@shell.armlinux.org.uk>
References: <20190124131803.14038-1-tbogendoerfer@suse.de>
 <20190124155137.GD482@lunn.ch>
 <20190124160741.jady3r2e4dme7c4m@e5254000004ec.dyn.armlinux.org.uk>
 <20190125083720.GK3662@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190125083720.GK3662@kwain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 25, 2019 at 09:37:20AM +0100, Antoine Tenart wrote:
> Hi,
> 
> On Thu, Jan 24, 2019 at 04:07:41PM +0000, Russell King - ARM Linux admin wrote:
> > On Thu, Jan 24, 2019 at 04:51:37PM +0100, Andrew Lunn wrote:
> > > On Thu, Jan 24, 2019 at 02:18:03PM +0100, Thomas Bogendoerfer wrote:
> > > > 
> > > > Fixes: 4bb043262878 ("net: mvpp2: phylink support")
> > > > Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> > > > ---
> > > >  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > > index 16066c2d5b3a..0fbfe1945a69 100644
> > > > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > > @@ -3405,7 +3405,7 @@ static int mvpp2_open(struct net_device *dev)
> > > >  		valid = true;
> > > >  	}
> > > >  
> > > > -	if (priv->hw_version == MVPP22 && port->link_irq && !port->phylink) {
> > > > +	if (priv->hw_version == MVPP22 && port->link_irq && port->phylink) {
> > > >  		err = request_irq(port->link_irq, mvpp2_link_status_isr, 0,
> > > >  				  dev->name, port);
> > > >  		if (err) {
> > 
> > This still looks fishy to me.  mvpp2_link_status_isr() has handling in
> > it that is safe to be called for non-phylink cases, so presumably the
> > right fix is to drop the "&& !port->phylink" completely?
> 
> That's right, mvpp2_link_status_isr() is safe to be called with or
> without phylink being used. This IRQ is reporting the link status, and
> is used when using in-band status or when phylink isn't used.
> 
> We do have a similar fix locally, which looks like:
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index 2bcbf9caaf0d..6bab1824a1e4 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -3406,7 +3406,8 @@ static int mvpp2_open(struct net_device *dev)
>                 valid = true;
>         }
> 
> -       if (priv->hw_version == MVPP22 && port->link_irq && !port->phylink) {
> +       if (priv->hw_version == MVPP22 && port->link_irq &&
> +           (!port->phylink || !port->has_phy)) {
>                 err = request_irq(port->link_irq, mvpp2_link_status_isr, 0,
>                                   dev->name, port);
>                 if (err) {
> 
> We haven't submitted it yet, as we saw several issues when a port has no
> PHY and is using the XLG MAC (so, not on the mcbin). We currently are
> working on them.
> 
> I don't like to ask this, as you submitted the fix first, but I do think
> we should hold back a bit while we figure out proper solutions. If you
> need in-band status to be working properly, we could share out current
> local branch so you can test and validate it do solve your issue.

Hi Antoine,

Today, I received an email from Willy Tarreau about this issue which
persists to this day with mainline kernels.

Willy reminded me that I've been carrying a fix for this, but because
of your concerns as stated above, I haven't bothered submitting it
through fear of causing regressions (which you seem to know about):

   http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=mvpp2&id=67ef3bff255b26cc0d6def8ca99c4e8ae9937727

Just like Thomas' case, the current code is broken for phylink when
in-band negotiation is being used - such as with the 1G/2.5G SFP
slot on the Macchiatobin.

It seems that resolving the issue has stalled.  Can I merge my patch,
or could you state exactly what the problems are with it so that
someone else can look into the issues please?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
