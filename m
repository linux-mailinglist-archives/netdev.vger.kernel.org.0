Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 656376A6CC1
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 14:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjCANDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 08:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjCANDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 08:03:11 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0EB513DD7;
        Wed,  1 Mar 2023 05:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LurPeUM/DsgzZU53OWxGyoBXqqBYvv+Z9jh0hFkmRkY=; b=mUiawe2SZYE4t1t0EF7GDfh0m6
        2IljaQirtS2k5zSTJstMPvgryFOVZ7YLU5KoVAdyiv5Jab3qgbsTS2C4nJHk1FJ0pUCTyyx3C5HXK
        RIQnuzN5RPTcrIDE1JapoZnZVwG7TcK8ESbDm7tywwoSZENy83Wt+hxI2YKcqzJQ7jig=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pXM6Q-006Etq-8I; Wed, 01 Mar 2023 14:02:38 +0100
Date:   Wed, 1 Mar 2023 14:02:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ken Sloat <ken.s@variscite.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] net: phy: adin: Add flags to disable enhanced link
 detection
Message-ID: <Y/9M7nPZk8qMt0ZO@lunn.ch>
References: <20230228144056.2246114-1-ken.s@variscite.com>
 <Y/4VV6MwM9xA/3KD@lunn.ch>
 <DU0PR08MB900305C9B7DD4460ED29F5FBECAC9@DU0PR08MB9003.eurprd08.prod.outlook.com>
 <Y/4ba4s37NayCIwW@lunn.ch>
 <20230228193105.0f378a9d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228193105.0f378a9d@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 07:31:05PM -0800, Jakub Kicinski wrote:
> On Tue, 28 Feb 2023 16:19:07 +0100 Andrew Lunn wrote:
> > The Marvell PHYs also support a fast link down mode, so i think using
> > fast link down everywhere, in the code and the commit message would be
> > good. How about adin_fast_down_disable().
> 
> Noob question - does this "break the IEEE standard" from the MAC<>PHY
> perspective or the media perspective? I'm guessing it's the former
> and the setting will depend on the MAC, given configuration via the DT?

IEEE 802.3 says something like you need to wait 1 second before
declaring the link down. For applications like MetroLAN, 1 second is
too long, they want to know within something like 50ms so they can
swap to a hot standby.

Marvell PHYs have something similar, there is a register you can poke
to shorten the time it waits until it declares the link down. I'm sure
others PHYs have it too.

Ah, we already have a PHY tunable for it,
ETHTOOL_PHY_FAST_LINK_DOWN. I had forgotten about that. The Marvell
PHY supports its.

So i have two questions i guess:

1) Since it is not compliant with 802.3 by default, do we actually
want it disabled by default? But is that going to cause regressions?
Or there devices actually making use of this feature of this PHY?

2) Rather than a vendor specific DT bool to disable it, should we add
a generic DT property listing the actual delay in milliseconds, which
basically does what the PHY tunable does.

I think the answer to the second question should be Yes. It is a bit
more effort for this change, but is a generic solution.

I was pondering the first question while reviewing and decided to say
nothing. There is a danger of regressions. But as this case shows, it
can also cause problems.

	  Andrew
