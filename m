Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7C5645B34
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 14:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiLGNp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 08:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiLGNpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 08:45:55 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350CA59147;
        Wed,  7 Dec 2022 05:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fM4Ue57KpFKFDSFH+YV7t40a1Sc6yCwSXiEZl7JSvBM=; b=NCARY8rDBeekeP9LTUhVaxU5Px
        WFYvdfPFuPTon9eE9yjGGy1YmSLHh/7OAB7a61INnw+fwmgv1Qc08Za6Y85AVBcUYDWv5DHeLb6gZ
        vjQnGARnVs8q5UeCLgBSZaYgd7aaZxt/j59RdZBzG/Oe9KRSvxjtqz0pGj5xVwcK+o3Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p2ujF-004elC-H7; Wed, 07 Dec 2022 14:44:53 +0100
Date:   Wed, 7 Dec 2022 14:44:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v4 net-next 5/5] drivers/net/phy: add driver for the
 onsemi NCN26000 10BASE-T1S PHY
Message-ID: <Y5CY1ZmY87dSJsto@lunn.ch>
References: <cover.1670329232.git.piergiorgio.beruto@gmail.com>
 <1816cb14213fc2050b1a7e97a68be7186340d994.1670329232.git.piergiorgio.beruto@gmail.com>
 <Y49IBR8ByMQH6oVt@lunn.ch>
 <Y49THkXZdLBR6Mxv@gvm01>
 <Y49yxcd6m7K3G3ZA@lunn.ch>
 <Y4+FqsZLBzDzadcC@gvm01>
 <Y4+UAmyS5hJ0+c66@lunn.ch>
 <Y4/fTVKJEbTYQxja@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4/fTVKJEbTYQxja@gvm01>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

What might also play a role here is the application these PHYs are
used in. Automotive. So the devices are generally 'appliances'. They
have one purpose, rather than being general purpose. So i expect the
network is very static.

DT is supposed to describe the hardware, not really configuration of
the hardware. But a lot of this is very hardware near so should be
O.K. in DT.

> Enable of enhanced-noise-immunity mode
> - This trades off CSMA/CD performance for noise immunity. It could be a
>   static setting, but the user may want to conditionally enable it
>   depending on application decisions. E.g. some people may want to
>   enable/disable this when using CSMA/CD as a fallback in case the PLCA
>   coordinator disappears. Of course, there are better ways of doing
>   this, but it is a possible use-case that some people want to use.

I would probably leave this one for the moment, until somebody really
needs it. It also sounds generic, not specific to this PHY.

> Tuning of internal impedance to match the line/MDI
> - This is really board dependent, so DT seems good to me

DT sounds good. It also sounds generic, not specific to this PHY.
 
> Tuning of PMA filters to optimize SNR
> - same as above?

Also sounds generic?
 
> Tuning of TX voltage levels
> - I am not 100% sure that is static (DT) but for the time being it could
>   be considered as such. It basically trades-off EMI (immunity) for EME
>   (emissions).

There has been general interest in this for a while, but nobody has
implemented it. Marvell PHYs allow you to change the amplitude for
example, which i've seen used to work around EMC issues. Part of the
problem here is keeping within the standard, and dealing with the
dynamic behaviour of the network. Somebody might reduce the voltage
and it works. And then the cable is swapped, to a longer cable, and it
stops working because the voltage is too low. So there was discussion
about on link down, the setting reverts back to default, to ensure it
works when the link comes back up again. A PHY tunable was suggested
for this. But it needs thinking about. For automotive/appliance
setting, maybe this can be simplified, since you don't expect the
cabling to change.

> Topology Discovery
> - This is a special mode to detect the physical distance among nodes on
>   the multi-drop cable. It is also being standardized in the OPEN
>   Alliance, but for the time being, it is proprietary. I think it will
>   require some kernel support as a protocol is also involved (but not
>   standardized, yet).

This might fall under cable test. It can already return cable length,
which normally means length along cable to fault, but it is a bit
ambiguous, so can also mean just length. Adding an extra attribute it
could easily mean length to node. Proprietary vs standard does not
matter, since cable testing in general is proprietary. You just need
to see how you can plug it into the current API.

> Multi-putrpose I/Os (LED, GPIO, SFD detect).
> - I know the kernel already has the infrastructure for those functions
>   (not sure about SFD) so I assume this could be some DT work and some
>   code to configure the MUX to achieve the specific function.

LEDs are a long long story, which has not yet reached its
conclusion. But they will end up as being Linux LEDs, which can be
accelerated using hardware. GPIOs are just linux GPIOs. You might have
some DT to indicate how the external pin is wired, pinmux. But pinmux
is also standardized within Linux. I should point out that many PHY
silicons support GPIOs, but nobody has ever used the capability in
Mainline Linux.

> Selection of link status triggers
> - This is what I was trying to achieve with the module parameter. i.e.,
>   the link status can be a simple on/off based on the link_control
>   setting (this is what it is for CSMA/CD as there is no link concept)
>   or it could be masked by PLCA status whrn PLCA is enabled. This is a
>   design choice of the user. In the former case, you don't get a link
>   down if the PHY automatically go back to CSMA/CD as a result of PLCA
>   status being 0. In the latter case you get a link down until PLCA is
>   up & running, preventing the application to send data before time.

This is an interesting one. I don't know of any other link technology
which operates like this. The link is either up, or down. There is
support for downshift, when a T4 phy discovers a broken pair and swaps
from 1G to 100Mbps using two of the working pairs. You get down/up
events when this happens, and you can see the actual speed as opposed
to the expected speed.

I'm not sure i would actually make this configurable. Some
applications might be happy with best effort, will others want to wait
for PLCA to be active. There is already a link state netlink message
which gets broadcast to userspace when ever some property of the link
changes. I would add PLCA status to it. Applications then just need to
listen for the message.

Also, you need real use cases. Linux is not a collection of SDKs
bolted together. Vendor crap SDKs tend to have an API for everything
the hardware can do, and 90% of it is never used. That just adds
maintenance burden. We push back on this in mainline. We only add
stuff when there is somebody who needs it. So having the vendor
provide the core driver is great, but it is better that a user of the
device added the needed bells and whistles, for their real use case.

      Andrew
