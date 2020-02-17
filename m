Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB1A2161A65
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 19:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730146AbgBQSra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 13:47:30 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40716 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728463AbgBQSrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 13:47:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=PEbncHS+AnPBBIQlAnhVcVbOoHuWu9zHjb/jLxwT+dA=; b=Pi2R+UlrHLLQmotVF+73gOtYv
        XGfVs8bQtFm+sQ3jAz8jLT/tT+8oumWH4xWKXG0q5Ha/uaDIdrjRl6OX7YJDoJcgml6Jt6NYipAxx
        Jg780IP2SWGMN30EmJTirgg9+wBaEkhJVYXAPtDFpXfsaBklR5TNuYDcwms/teakTQUDz8w+Y83/d
        IPZHTUfRtSmQHQNNdiQ6FLvg3+D1maA/yZn5IxibPSHv46a+beJ56qOBpH9/ceFraOqD/iqbNpjwB
        370NLnH6k/ySQz6+z5F92u1t41XvLYL9eCz62XINxjOGGXYTJlhZqXjKC6PS81NfNhm8jRwIdZ1w2
        N9oMAoPiQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:41632)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j3lQI-0002WD-K0; Mon, 17 Feb 2020 18:47:14 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j3lQF-0006XL-Nb; Mon, 17 Feb 2020 18:47:11 +0000
Date:   Mon, 17 Feb 2020 18:47:11 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net] net: macb: Properly handle phylink on at91rm9200
Message-ID: <20200217184711.GA25745@shell.armlinux.org.uk>
References: <20200217104348.43164-1-alexandre.belloni@bootlin.com>
 <20200217165644.GX25745@shell.armlinux.org.uk>
 <20200217174244.GD3316@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217174244.GD3316@piout.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 06:42:44PM +0100, Alexandre Belloni wrote:
> On 17/02/2020 16:56:44+0000, Russell King - ARM Linux admin wrote:
> > On Mon, Feb 17, 2020 at 11:43:48AM +0100, Alexandre Belloni wrote:
> > > at91ether_init was handling the phy mode and speed but since the switch to
> > > phylink, the NCFGR register got overwritten by macb_mac_config().
> > 
> > I don't think this actually explains anything - or at least I can't
> > make sense of it with respect to your patch.
> > 
> > You claim that the NCFGR register gets overwritten in macb_mac_config(),
> > but I see that the NCFGR register is read-modify-write in there,
> > whereas your new implementation below doesn't bother reading the
> > present value.
> > 
> > I think the issue you're referring to is the clearing of the PAE bit,
> > which is also the RM9200_RMII for at91rm9200?
> > 
> 
> This is the issue, I'll rework the commit message.

Thanks.

> > Next, there's some duplication of code introduced here - it seems
> > that the tail end of macb_mac_link_down() and at91ether_mac_link_down()
> > are identical, as are the tail end of macb_mac_link_up() and
> > at91ether_mac_link_up().
> > 
> 
> I was split between having a new phylink_mac_ops instance or
> differentiating in the various callbacks. If your preference is the
> latter, I'm fine with that.

I haven't thought too much about what the code would look like after
the phylink changes - I spent quite some time working out what the
differences were between what is already in mainline and what your
patch was adding back.

As far as I'm concerned, however, any of the MAC drivers I've converted
that I don't have the hardware for (which includes this driver) are
merely illustrative patches that show the kind of thing I'm after
there - and only become "real" patches once they're tested.

> > > Add new phylink callbacks to handle emac and at91rm9200 properly.
> > > 
> > > Fixes: 7897b071ac3b ("net: macb: convert to phylink")
> > > Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> > > ---
> > 
> > I posted a heads-up message last week about updates to phylink that
> > I'll be submitting soon (most of the prerequisits have now been sent
> > for review) which touch every phylink_mac_ops-using piece of code in
> > the tree.  Unfortunately, this patch introduces a new instance that
> > likely isn't going to get my attention, so it's going to create a
> > subtle merge conflict between net-next and net trees unless we work
> > out some way to deal with it.
> > 
> > I'm just mentioning that so that some thought can be applied now
> > rather than when it actually happens - especially as I've no way to
> > test the changes that will be necessary for this driver.
> > 
> 
> Does that help if I change the callbacks instead of adding a new
> phylink_mac_ops instance? I can also wait for your work and rebase on
> top of that but that would mean that the fix will not get backported.

Obviously, the phylink conversion for this driver caused a regression
that should be fixed, so I think it's right to fix it in whatever way
you think would be most suitable.  We just need to consider how to
deal with the conflicts that are going to occur between net and
net-next.

One option would be to let davem know about the impending conflict,
and with your patch merged into net, if he can then merge the net
tree into net-next before applying my series - with an updated macb
conversion patch from you (tested would be good!) - then everything
should work out fine.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
