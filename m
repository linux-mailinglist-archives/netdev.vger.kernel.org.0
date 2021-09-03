Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF2F400048
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 15:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348597AbhICNMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 09:12:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55008 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235200AbhICNMm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 09:12:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PJ/ewpbCSl1NSA3Yn6XvcdncESaIItROwt2bUJqbbI4=; b=GNfytfWq7iRp2Qkw9F4WTgeYvX
        kBLZCbDCY2EIPdVslR0hKpj7LODZuJgnk3UBafcmQ0NEpuH0HfXtnCtbpsvmYTWs2Jjr6iu5xWO8S
        kZV1dX6f+TvRO5kSszlETeO0Bb6aQfe1WjcEfIk0CEMTl6nAkS9YnAbmliTEvFfJcVYk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mM8ym-0058JY-LQ; Fri, 03 Sep 2021 15:11:36 +0200
Date:   Fri, 3 Sep 2021 15:11:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: dpaa2-mac: add support for more ethtool
 10G link modes
Message-ID: <YTIfCCzYK6RK1gYj@lunn.ch>
References: <E1m5mVT-00032g-Km@rmk-PC.armlinux.org.uk>
 <YPbU59Kmpk0NvlQH@lunn.ch>
 <20210720141134.GT22278@shell.armlinux.org.uk>
 <20210816144752.vxliq642uipdsmdd@skbuf>
 <20210903103358.GU22278@shell.armlinux.org.uk>
 <20210903110916.bjjm6x3h4l4raf27@skbuf>
 <20210903113434.GV22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903113434.GV22278@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 12:34:34PM +0100, Russell King (Oracle) wrote:
> On Fri, Sep 03, 2021 at 02:09:16PM +0300, Ioana Ciornei wrote:
> > On Fri, Sep 03, 2021 at 11:33:58AM +0100, Russell King (Oracle) wrote:
> > > On Mon, Aug 16, 2021 at 05:47:52PM +0300, Ioana Ciornei wrote:
> > > > On Tue, Jul 20, 2021 at 03:11:34PM +0100, Russell King (Oracle) wrote:
> > > > > On Tue, Jul 20, 2021 at 03:51:35PM +0200, Andrew Lunn wrote:
> > > > > > On Tue, Jul 20, 2021 at 10:57:43AM +0100, Russell King wrote:
> > > > > > > Phylink documentation says:
> > > > > > >   Note that the PHY may be able to transform from one connection
> > > > > > >   technology to another, so, eg, don't clear 1000BaseX just
> > > > > > >   because the MAC is unable to BaseX mode. This is more about
> > > > > > >   clearing unsupported speeds and duplex settings. The port modes
> > > > > > >   should not be cleared; phylink_set_port_modes() will help with this.
> > > > > > > 
> > > > > > > So add the missing 10G modes.
> > > > > > 
> > > > > > Hi Russell
> > > > > > 
> > > > > > Would a phylink_set_10g(mask) helper make sense? As you say, it is
> > > > > > about the speed, not the individual modes.
> > > > > 
> > > > > Yes, good point, and that will probably help avoid this in the future.
> > > > > We can't do that for things like e.g. SGMII though, because 1000/half
> > > > > isn't universally supported.
> > > > > 
> > > > > Shall we get this patch merged anyway and then clean it up - as such
> > > > > a change will need to cover multiple drivers anyway?
> > > > > 
> > > > 
> > > > This didn't get merged unfortunately.
> > > > 
> > > > Could you please resend it? Alternatively, I can take a look into adding
> > > > that phylink_set_10g() helper if that is what's keeping it from being
> > > > merged.
> > > 
> > > It looks like the original patch didn't appear in patchwork for some
> > > reason - at least google can find it in lore's netdev archives, but
> > > not in patchwork. I can only put this down to some kernel.org
> > > unreliability - we've seen this unreliability in the past with netdev,
> > > and it seems to be an ongoing issue.
> > > 
> > 
> > Yes, it cannot be found though google but the patch appears in
> > patchwork, it was tagged with 'Changes requested'.
> > https://patchwork.kernel.org/project/netdevbpf/patch/E1m5mVT-00032g-Km@rmk-PC.armlinux.org.uk/
> 
> Thanks. I wonder why searching for it via google and also via patchworks
> search facility didn't find it.
> 
> So, it got incorrectly tagged by netdev maintainers, presumably because
> they're too quick to classify a patch while discussion on the patch was
> still ongoing - and there's no way for those discussing that to ever
> know without finding it in patchwork. Which is pretty much impossible
> unless you know the patchwork URL format and message ID, and are
> prepared to regularly poll the patchwork website.
> 
> The netdev process, as a patch submitter or reviewer, is really very
> unfriendly.

H Russell, Ioana

It sounds like at LPC there is going to be a time slot to talk about
netdev processes. I would like to find out and discuss the new policy
for the time it takes to merge patches. Patchwork issues, and the lack
of integration with email workflows could be another interesting topic
to discuss.

	Andrew
