Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4DB82CF917
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 03:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgLECxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 21:53:30 -0500
Received: from static.214.254.202.116.clients.your-server.de ([116.202.254.214]:35080
        "EHLO ciao.gmane.io" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgLECxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 21:53:30 -0500
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <gl-netdev-2@m.gmane-mx.org>)
        id 1klNgm-0007Fz-98
        for netdev@vger.kernel.org; Sat, 05 Dec 2020 03:52:48 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     netdev@vger.kernel.org
From:   Grant Edwards <grant.b.edwards@gmail.com>
Subject: Re: net: macb: fail when there's no PHY
Date:   Sat, 5 Dec 2020 02:52:44 -0000 (UTC)
Message-ID: <rqeslr$qo6$1@ciao.gmane.io>
References: <20170921195905.GA29873@grante>
 <66c0a032-4d20-69f1-deb4-6c65af6ec740@gmail.com>
 <CAK=1mW6Gti0QpUjirB6PfMCiQvnDjkbb56pVKkQmpCSkRU6wtA@mail.gmail.com>
 <6a9c1d4a-ed73-3074-f9fa-158c697c7bfe@gmail.com> <X8fb4zGoxcS6gFsc@grante>
 <20201202183531.GJ2324545@lunn.ch> <rq8p74$2l0$1@ciao.gmane.io>
 <20201202211134.GM2324545@lunn.ch> <rq9ki2$uqk$1@ciao.gmane.io>
 <57728908-1ae3-cbe9-8721-81f06ab688b8@gmail.com>
 <rq9nih$egv$1@ciao.gmane.io>
 <b842bb79-85c8-3da7-ec89-01dbbab447f5@gmail.com>
User-Agent: slrn/1.0.3 (Linux)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-04, Florian Fainelli <f.fainelli@gmail.com> wrote:
> On 12/2/2020 7:54 PM, Grant Edwards wrote:
>> On 2020-12-03, Florian Fainelli <f.fainelli@gmail.com> wrote:
>> 
>>> You would have to have a local hack that intercepts the macb_ioctl()
>>> and instead of calling phylink_mii_ioctl() it would have to
>>> implement a custom ioctl() that does what
>>> drivers/net/phy/phy.c::phy_mii_ioctl does except the mdiobus should
>>> be pointed to the MACB MDIO bus instance and not be derived from the
>>> phy_device instance (because that one points to the fixed PHY).
>> 
>> So I can avoid my local hack to macb_main.c by doing a doing a local
>> hack to macb_main.c?
>
> There is value in having the macb driver support the scheme that was
> just described which is to support a fixed PHY as far as the MAC link
> parameters go, and also support registering the MACB internal MDIO bus
> to interface with other devices. People using DSA would typically fall
> under that category.

My hack does support both a fixed PHY as far as the MAC link
parameters go and allows interfacing with other devices via the mdio
bus, so I assume you're saying that there's value in doing that in the
"standard" way instead of the way I invented 10 years ago.

That would certainly be true if we were talking about something to be
incorporated "upstream", but like you said: it would be a local
hack. I see no intrinsic value in changing to the "standard" DSA
scheme. Switching to a different API would actually create additional
cost above and beyond the cost of writing and testing the new local
hack, since all of the applications which need to access the mdio bus
would also have to change.

If I could avoid the local hack completely by using a standard,
existing feature and API, then I could make an arguement for modifying
the applications. But proposing the writing of a new, more comlex
local hack and modifying the applications just so that we can feel
good about using a standard API would be laughed at.

> [...]
>
> I don't have a dog in the fight, but dealing myself with cute little
> hacks in our downstream Linux kernel, the better it fits with useful
> functionality to other people, the better.

I don't see why it makes any difference how well suited a local hack
is to people who will never see it or use it. It would seem to me that
the the most important attribute of a local hack would be simplicity
and ease of understanding.  My hack is 7 lines of code and one line of
a static structure declaration and initializer, all
enabled/disabled/controlled by a single preprocessor symbol.

--
Grant

