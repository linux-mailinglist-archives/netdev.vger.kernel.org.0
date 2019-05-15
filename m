Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27BAA1F62B
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 16:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbfEOOCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 10:02:21 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:46847 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfEOOCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 10:02:20 -0400
Received: from bootlin.com (aaubervilliers-681-1-43-46.w90-88.abo.wanadoo.fr [90.88.161.46])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 2B3EA240034;
        Wed, 15 May 2019 14:02:13 +0000 (UTC)
Date:   Wed, 15 May 2019 16:02:14 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: dsa: using multi-gbps speeds on CPU port
Message-ID: <20190515160214.1aa5c7d9@bootlin.com>
In-Reply-To: <20190515132701.GD23276@lunn.ch>
References: <20190515143936.524acd4e@bootlin.com>
        <20190515132701.GD23276@lunn.ch>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Wed, 15 May 2019 15:27:01 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

>I think you are getting your terminology wrong. 'master' is eth0 in
>the example you gave above. CPU and DSA ports don't have netdev
>structures, and so any PHY used with them is not corrected to a
>netdev.

Ah yes sorry, I'm still in the process of getting familiar with the
internals of DSA :/

>> I'll be happy to help on that, but before prototyping anything, I wanted
>> to have your thougts on this, and see if you had any plans.  
>
>There are two different issues here.
>
>1) Is using a fixed-link on a CPU or DSA port the right way to do this?
>2) Making fixed-link support > 1G.
>
>The reason i decided to use fixed-link on CPU and DSA ports is that we
>already have all the code needed to configure a port, and an API to do
>it, the adjust_link() callback. Things have moved on since then, and
>we now have an additional API, .phylink_mac_config(). It might be
>better to directly use that. If there is a max-speed property, create
>a phylink_link_state structure, which has no reference to a netdev,
>and pass it to .phylink_mac_config().
>
>It is just an idea, but maybe you could investigate if that would
>work.

Ok I see what you mean, this would allow us to get rid of the phydev
built from the fixed-link, and the .adjust_link call. I'll prototype
that, thanks for the hint.

>On the master interface, the armada 8040, eth0, you still need
>something. However, if you look at phylink_parse_fixedlink(), it puts
>the speed etc into a phylink_link_state. It never instantiates a
>fixed-phy. So i think that could be expanded to support higher speeds
>without too much trouble. The interesting part is the IOCTL handler.

Yes I'm not too worried about that part, unless I missed something this
shouldn't be too problematic.

Once again, thanks for your help,

Maxime

