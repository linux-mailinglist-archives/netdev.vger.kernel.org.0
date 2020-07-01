Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09FD210770
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 11:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbgGAJGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 05:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbgGAJGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 05:06:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182CBC061755
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 02:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tSP9r2YD+sw/XJ3d30snTRWvcBmchQVVbxQfZKRVN/o=; b=eVUMFAmXU9h2HIr2xQQlSrMN1
        xFQF/Bc0NpWD6KYnqg6aTlnyFRGLal1k6KMc1Dt57+mx3IA/yJYb7VGomyLXI9LBxgu/ip+9+UfnO
        NkaX7lCjfPFz9hMXZFanJwMlUszxFFjz3dFKHLSerFOUIBtr1cuhM8vNl1utlThZRfPHVYIPDMiDZ
        qSjS3ZtSWl1YemUitXxCqL0ax/exG+mJx8n/GhHcq/Ny5g84AgQ6G7FU03156Hig4T7IwIe//4s/q
        HiD5lrbNXm1MTzSlM/Qj7gYGPNCYDdxb9nxClQZmFlRLOjZF2MFmVaeP4pm1jci1pWMCg4gWhjLUl
        ozge/mKiw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33908)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jqYgy-0001SV-Ja; Wed, 01 Jul 2020 10:06:08 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jqYgx-0000e1-Ag; Wed, 01 Jul 2020 10:06:07 +0100
Date:   Wed, 1 Jul 2020 10:06:07 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Shmuel Hazan <sh@tkos.co.il>
Subject: Re: [PATCH v2] net: phy: marvell10g: support XFI rate matching mode
Message-ID: <20200701090607.GI1551@shell.armlinux.org.uk>
References: <76ee08645fd35182911fd2bac2546e455c4b662c.1593327891.git.baruch@tkos.co.il>
 <20200629092224.GS1551@shell.armlinux.org.uk>
 <87v9j7em1r.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v9j7em1r.fsf@tarshish>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 01, 2020 at 10:23:12AM +0300, Baruch Siach wrote:
> Hi Russell,
> 
> On Mon, Jun 29 2020, Russell King - ARM Linux admin wrote:
> > Then there's the whole question of what phydev->speed etc should be set
> > to - the media speed or the host side link speed with the PHY, and then
> > how the host side should configure itself.  At least the 88E6390x
> > switch will force itself to the media side speed using that while in
> > XAUI mode, resulting in a non-functioning speed.  So should the host
> > side force itself to 10G whenever in something like XAUI mode?
> 
> How does the switch discover the media side speed? Is there some sort of
> in-band information exchange?

The media-side results are passed via phydev->speed and phydev->duplex,
and therefore will be passed through phylink. mvpp2 will ignore them
for 10GBASE-R as it has separate MACs - XLG and GMAC, but 88E6390x, it's
just one.  Consequently, it's possible that the port mode is in XAUI,
but you can force the speed to (e.g.) 100M.

What I know from what I can do with this media-side broken 88X3310, is
that it will pass data if the 88E6390x is forced to 10G, but not if it's
forced to 100M.

We're moving from a situation where MAC drivers can expect (with either
phylib or phylink):

	interface = <some 10G interface>
	speed is always 10G
	duplex is always full

to:

	interface = <some 10G interface>
	speed is 10, 100, 1G or 10G
	duplex is half or full

So, adding rate-matching brings with it a non-obvious change in the API
of phylib and phylink:

* what do the phydev->{speed,duplex,pause,asym_pause} represent - the
  media side parameters or the PHY to MAC parameters?
* what do the "speed, duplex, pause" passed into mac_link_up() refer to,
  the media side, or the link side?
  
Both of those need to be properly documented and explained.

The next two points, I haven't re-read the 3310 datasheet.

We also need to consider a situation which is less obvious: if the PHY
is operating in rate matching mode, doesn't generate pause frames
itself as its rate matching buffers fill, but the media side negotiated
for pause frames.  Should we be advertising no support for pause frames
in this case?  Will the PHY pass pause frames through as a priority?
Consider that in a 16k outbound buffer, there could be up to 10 full
sized frames queued, so if the link partner is asking us to stop
sending, it could take up to 10 frames before we actually stop.

What are the requirements for half duplex in rate matching mode - is
that handled internally by the PHY, or do we need to disable all half
duplex advertisements in the PHY. When rate matching, the PHY can no
longer signal the MAC when a collision occurs, as it would normally
do without rate matching.

I think I've covered everything, but may have missed something. I do
think we need documentation updated before we should accept this patch
so that we have the phylib and phylink behaviour in this case clearly
defined from the outset.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
