Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFC7221429
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 20:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbgGOSUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 14:20:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725861AbgGOSUe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 14:20:34 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D0982065F;
        Wed, 15 Jul 2020 18:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594837233;
        bh=3/Z3Mi8qumJrJ6bPUtIb0B3JTYDfBb5mkmzFb5NOrn0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Quoaf+E/YW++Z8JpGEAkALrI+aaGyIBB5jCPBc3XZ/9ye/jwE+N+Q+GFlsBC7HXIk
         gSuJPWxJNSpcc7448T58gcyUDGvPlWIKPAdgTfi7zPSNoOI8wYU/tqdf2dKXldkCB4
         i0tMHJKlu4padBJDwTc0iL7q5mR6UUUhRcS32yKM=
Date:   Wed, 15 Jul 2020 11:20:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Helmut Grohne <helmut.grohne@intenta.de>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "woojung.huh@microchip.com" <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>
Subject: Re: [PATCH] net: phy: phy_remove_link_mode should not advertise new
 modes
Message-ID: <20200715112031.24c2d8ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200715070345.GA3452@laureti-dev>
References: <20200714082540.GA31028@laureti-dev>
        <20200714.140710.213288407914809619.davem@davemloft.net>
        <20200715070345.GA3452@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 09:03:45 +0200 Helmut Grohne wrote:
> On Tue, Jul 14, 2020 at 11:07:10PM +0200, David Miller wrote:
> > From: Helmut Grohne <helmut.grohne@intenta.de>
> > Date: Tue, 14 Jul 2020 10:25:42 +0200
> >   
> > > When doing "ip link set dev ... up" for a ksz9477 backed link,
> > > ksz9477_phy_setup is called and it calls phy_remove_link_mode to remove
> > > 1000baseT HDX. During phy_remove_link_mode, phy_advertise_supported is
> > > called.
> > > 
> > > If one wants to advertise fewer modes than the supported ones, one
> > > usually reduces the advertised link modes before upping the link (e.g.
> > > by passing an appropriate .link file to udev).  However upping
> > > overrwrites the advertised link modes due to the call to
> > > phy_advertise_supported reverting to the supported link modes.
> > > 
> > > It seems unintentional to have phy_remove_link_mode enable advertising
> > > bits and it does not match its description in any way. Instead of
> > > calling phy_advertise_supported, we should simply clear the link mode to
> > > be removed from both supported and advertising.  
> > 
> > The problem is that we can't allow the advertised setting to exceed
> > what is in the supported list.
> > 
> > That's why this helper is coded this way from day one.  
> 
> Would you mind going into a little more detail here?
> 
> I think you have essentially two possible cases with respect to that
> assertion.
> 
> Case A: advertised does not exceed supported before the call to
>         phy_remove_link_mode.
> 
>     In this case, the relevant link mode is removed from both supported
>     and advertised after my patch and therefore the requested invariant
>     is still ok.
> 
> Case B: advertised exceeds supported prior to the call to
>         phy_remove_link_mode.
> 
>     You said that we cannot allow this to happen. So it would seem to be
>     a bug somewhere else. Do you see phy_remove_link_mode as a tool to
>     fix up a violated invariant?

Is 

Case C: driver does not initialize advertised at all and depends on
        phy_remove_link_mode() to do it

possible?

> It also is not true that the current code ensures your assertion.
> Specifically, phy_advertise_supported copies the pause bits from the old
> advertised to the new one regardless of whether they're set in
> supported. I believe this is expected, but it means that your invariant
> needs to be:
> 
>     We cannot allow advertised to exceed the supported list for
>     non-pause bits.
> 
> In any case, having a helper called "phy_remove_link_mode" enable bits
> in the advertised bit field is fairly unexpected. Do you disagree with
> this being a bug?

Hm. I think it's clear that the change may uncover other bugs, but
perhaps indeed those should be addressed elsewhere.

Andrew, WDYT?
