Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04CD45F4C0
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 19:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242439AbhKZSkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 13:40:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40510 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243666AbhKZSiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 13:38:23 -0500
X-Greylist: delayed 4533 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Nov 2021 13:38:23 EST
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FFF16232B
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 18:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3810BC93056;
        Fri, 26 Nov 2021 18:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637951708;
        bh=yMnXqKWipRpVZmCbKH0Zk9lN+MJYcab3NmENznBTWtY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hZVVVrxd8xXIVYKOgB6l8b/EFp6ch2WIQinf9hMycIFxrgPPchRIvfXhJarq/vYN6
         5yCYWZ/NuDNMhFUxd86uvAA7K/Jbh6uNlO3qEk0F0eYZDCoTZJdAqHP9xbl3FuO3Lj
         Ut3V0GICggL9Wvpea0rApL7BErGC8dOVzoL1o9DoVWgozzBzD/MZyCY+ZIe1looohV
         jPk+aCXQiXG5uqlN12WyBAQM2eJvyixrPw9kmJaEX4QwOpKt091jf4k1AtG2qDgx2R
         /CvBsvxXu/iNKl40m0CRt+8s/AyovVWxJPL6ByjMR0C8AVHWYCrkajyBrHNLLVBB0A
         UnzCcj1PywNcw==
Date:   Fri, 26 Nov 2021 10:35:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Po Liu <po.liu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <atenart@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.B. Lu" <yangbo.lu@nxp.com>, Rui Sousa <rui.sousa@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>
Subject: Re: [PATCH net-next 0/4] Fix broken PTP over IP on Ocelot switches
Message-ID: <20211126103507.3bfe7a7b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211126095500.tkcctzfh5zp2nluc@skbuf>
References: <20211125232118.2644060-1-vladimir.oltean@nxp.com>
        <20211125234520.2h6vtwar4hkb2knd@skbuf>
        <20211125190101.63f1f0a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211126095500.tkcctzfh5zp2nluc@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Nov 2021 09:55:00 +0000 Vladimir Oltean wrote:
> On Thu, Nov 25, 2021 at 07:01:01PM -0800, Jakub Kicinski wrote:
> > On Thu, 25 Nov 2021 23:45:21 +0000 Vladimir Oltean wrote:  
> > > I don't know why I targeted these patches to "net-next". Habit I guess.
> > > Nonetheless, they apply equally well to "net", can they be considered
> > > for merging there without me resending?  
> >
> > Only patch 1 looks like a fix, tho? Patch 4 seems to fall into
> > the "this never worked and doesn't cause a crash" category.
> >
> > I'm hoping to send a PR tomorrow, so if you resend quickly it
> > will be in net-next soon.  
> 
> It's true that a lot of work went into ocelot_vcap.c in order to make it
> safely usable for traps outside of the tc-flower offload, and I
> understand that you need to draw the line somewhere. But on the other
> hand, this is fixing very real problems that are bothering real users.
> Patch 1, not so much, it popped up as a result of discussions and
> looking at code. None of the bugs fixed here cause a crash, it's just
> that things don't work as expected. Technically, a user could still set
> up the appropriate traps via tc-flower and PTP would work, but they'd
> have to know that they need to, in the first place. So I would still be
> very appreciative if all 4 patches would be considered for inclusion
> into "net". I'm not expecting them to be backported very far, of course,
> but as long as they reach at least v5.15 I'm happy.

Alright, but please expect more push back going forward. Linus was
pretty clear on what constitutes -rc material in the past, and we're
sending quite a lot of code in each week..
