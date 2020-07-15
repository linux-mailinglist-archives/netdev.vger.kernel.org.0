Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5A9B2205C3
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 09:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgGOHDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 03:03:50 -0400
Received: from mail.intenta.de ([178.249.25.132]:39950 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726212AbgGOHDt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 03:03:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=ecvwun5iGdLoy5H6QJatU1u1WtuL4e1YyfLzb2c6fJQ=;
        b=RG18ZcOxX1gVe5c3kThWOfAJLGtzAX9AA3BMdpuAq5HrdZKUDP+8+8tDa6+PqElBb4oJgUjfEXTekI5lcDZRYCsJotCNlUsyMbRIqCbe6CXEg2DutHRcgPpZL9j3t7qYorBXhPq+U3+jarQ02ZalUpxdBb71J3ysK6bQ34a6wSwdUxOuFjTLmJ04aNnyvO0eSUXZIgnmOfKODRpBV7abQMtndmEzK2Qqe7+uOm4QaHYuJOjHgSGvZiWwtl4+VWY/WtRibpJmHW9rommsciUJt9bOHUrcrUHwpr0FQITDmRhvDC3a7lsql3nch4sLxzEj8RAvmD4cJEWhaqxgZWoB3g==;
Date:   Wed, 15 Jul 2020 09:03:45 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     David Miller <davem@davemloft.net>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "woojung.huh@microchip.com" <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>
Subject: Re: [PATCH] net: phy: phy_remove_link_mode should not advertise new
 modes
Message-ID: <20200715070345.GA3452@laureti-dev>
References: <20200714082540.GA31028@laureti-dev>
 <20200714.140710.213288407914809619.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200714.140710.213288407914809619.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 11:07:10PM +0200, David Miller wrote:
> From: Helmut Grohne <helmut.grohne@intenta.de>
> Date: Tue, 14 Jul 2020 10:25:42 +0200
> 
> > When doing "ip link set dev ... up" for a ksz9477 backed link,
> > ksz9477_phy_setup is called and it calls phy_remove_link_mode to remove
> > 1000baseT HDX. During phy_remove_link_mode, phy_advertise_supported is
> > called.
> > 
> > If one wants to advertise fewer modes than the supported ones, one
> > usually reduces the advertised link modes before upping the link (e.g.
> > by passing an appropriate .link file to udev).  However upping
> > overrwrites the advertised link modes due to the call to
> > phy_advertise_supported reverting to the supported link modes.
> > 
> > It seems unintentional to have phy_remove_link_mode enable advertising
> > bits and it does not match its description in any way. Instead of
> > calling phy_advertise_supported, we should simply clear the link mode to
> > be removed from both supported and advertising.
> 
> The problem is that we can't allow the advertised setting to exceed
> what is in the supported list.
> 
> That's why this helper is coded this way from day one.

Would you mind going into a little more detail here?

I think you have essentially two possible cases with respect to that
assertion.

Case A: advertised does not exceed supported before the call to
        phy_remove_link_mode.

    In this case, the relevant link mode is removed from both supported
    and advertised after my patch and therefore the requested invariant
    is still ok.

Case B: advertised exceeds supported prior to the call to
        phy_remove_link_mode.

    You said that we cannot allow this to happen. So it would seem to be
    a bug somewhere else. Do you see phy_remove_link_mode as a tool to
    fix up a violated invariant?

It also is not true that the current code ensures your assertion.
Specifically, phy_advertise_supported copies the pause bits from the old
advertised to the new one regardless of whether they're set in
supported. I believe this is expected, but it means that your invariant
needs to be:

    We cannot allow advertised to exceed the supported list for
    non-pause bits.

In any case, having a helper called "phy_remove_link_mode" enable bits
in the advertised bit field is fairly unexpected. Do you disagree with
this being a bug?

Helmut
