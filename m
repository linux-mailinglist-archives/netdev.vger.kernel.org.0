Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4691E630E
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 15:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390848AbgE1N4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 09:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390608AbgE1N4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 09:56:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030C7C05BD1E;
        Thu, 28 May 2020 06:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LfH3r9N8U+TjGPBioh17onUUMfVvWre6aYcRNgDb7ws=; b=qedCwa8YVz2K2bc4roQiaxT8Q
        aKMHmLuOEPN/h8C1D7ze+xGNS9BiCcLD0UPucvnYTZrSd71pmrJ0BRTFmIj401XJz/oDvNoybFR0g
        VxgPH4TCu0YJptMZlr25PywPvoEovCDGuo/dYpZDscQOqLR30Yu/slnMNwyDQhdogPbwFpPVXCWYf
        iMHvTMxCaIX30+jpShBhq6hFxN5gzqobOCE6Iy8MnluQSs8zP7vhGkyW7NpxsUmtdNba0k/BMoLko
        7UcDIkN5E/F0lU3dssz2BL86pAJRNO9JXChmrEzIk/HNadK0oD9cEtm/tz4U/peb0Kqhw7t7+MXDF
        tYU2Y0Z5g==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:46202)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jeJ0z-0005Uk-5C; Thu, 28 May 2020 14:56:09 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jeJ0y-0007Wh-4c; Thu, 28 May 2020 14:56:08 +0100
Date:   Thu, 28 May 2020 14:56:08 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mvpp2: Enable autoneg bypass for
 1000BaseX/2500BaseX ports
Message-ID: <20200528135608.GU1551@shell.armlinux.org.uk>
References: <20200528121121.125189-1-tbogendoerfer@suse.de>
 <20200528130738.GT1551@shell.armlinux.org.uk>
 <20200528151733.f1bc2fcdcb312b19b2919be9@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528151733.f1bc2fcdcb312b19b2919be9@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 03:17:33PM +0200, Thomas Bogendoerfer wrote:
> On Thu, 28 May 2020 14:07:38 +0100
> Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> 
> > On Thu, May 28, 2020 at 02:11:21PM +0200, Thomas Bogendoerfer wrote:
> > > Commit d14e078f23cc ("net: marvell: mvpp2: only reprogram what is necessary
> > >  on mac_config") disabled auto negotiation bypass completely, which breaks
> > > platforms enabling bypass via firmware (not the best option, but it worked).
> > > Since 1000BaseX/2500BaseX ports neither negotiate speed nor duplex mode
> > > we could enable auto negotiation bypass to get back information about link
> > > state.
> > 
> > Thanks, but your commit is missing some useful information.
> > 
> > Which platforms have broken?
> 
> it's an Ambedded MARS-400
>  
> > Can you describe the situation where you require this bit to be set?
> 
> as I have no exact design details I'm just talking about what I can see
> on that platform. It looks like the switch connecting the internal nodes
> doesn't run autoneg on the internal links. So the link to the internal
> nodes will never come up. These links are running 2500BaseX so speed/duplex
> is clean and by enabling bypass I'll get a proper link state, too.
> 
> > We should not be enabling bypass mode as a matter of course, it exists
> > to work around broken setups which do not send the control word.
> 
> if you call it a broken setup I'm fine, but this doesn't solve the problem,
> which exists now. What would be your solution ?

What I was after was additional information about the problem, so
that we can start thinking about how to deal with the AN bypass bit
in a sensible way.

How is the connection between the switch and network interface
described?  I don't think I see a .dts file in mainline for this
platform.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
