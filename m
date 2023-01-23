Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 359AB6786D1
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 20:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjAWTuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 14:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbjAWTt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 14:49:57 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D982CC6C
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 11:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=l5GkxvoNgMTviY3DMYB3NVNHMUpz20nZxWIM9uCJjos=; b=dGI6W9wVHt+Z9ZvUhacXSiqbh8
        Q64PXiBkdzpfTnOESpM3WlofZI3qOrpA5Ph8oHm466eQZS8vwVAjxRSFMpU5Q8wX5gGPn2K/iNwC/
        zLftxJ+yeErIEGkpP0jGcMxWyCsa7sQs90I83vdan7EbSaVf+vfnhPWsm0VOCYIqpqMA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pK2ot-002wg1-6d; Mon, 23 Jan 2023 20:49:31 +0100
Date:   Mon, 23 Jan 2023 20:49:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "Sverdlin, Alexander" <alexander.sverdlin@siemens.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Freihofer, Adrian" <adrian.freihofer@siemens.com>
Subject: Re: dsa: phy started on dsa_register_switch()
Message-ID: <Y87ky0q3HWJhxfca@lunn.ch>
References: <f95cdab0940043167ddf69a4b21292ee63fc9054.camel@siemens.com>
 <6b63fe0f-a435-1fdf-bc56-10622b832419@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b63fe0f-a435-1fdf-bc56-10622b832419@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 10:57:10AM -0800, Florian Fainelli wrote:
> On 1/23/23 10:35, Sverdlin, Alexander wrote:
> > Dear DSA maintainers,
> > 
> > I've been puzzled by the fact ports of the DSA switches are enabled on
> > bootup by default (PHYs configured, LEDs ON, etc) in contrast to the
> > normal Ethernet ports.
> > 
> > Some people tend to think this is a security issue that port is "open"
> > even though no configuration has been performed on the port, so I
> > looked into the differences between Ethernet drivers and DSA
> > infrastructure.
> 
> If you are concerned about security with a switch, then clearly the switch
> should have an EEPROM which configures it to isolate all of the ports from
> one another, and possibly do additional configuration to prevent any packets
> from leaking.

It depends on the switch vendor, but Marvell Switches have a NO_CPU
strapping. If strapped this way, they power up in dumb switch mode,
all ports active, one big bridge. If NO_CPU is not strapped, depending
on the generation of device, the PHYs may come up, but the switch core
keeps the ports isolated, so no traffic will flow. So if security is a
design consideration, check if the switch you are using has such a
strapping. And do consider an EEPROM to explicitly shut everything
down. Also, watch out for the bootloader. Some switches have basic
support in u-boot, and barebox, enough to get the switch into a state
your can tftpboot over one of its ports.

> > Traditionally phylink_of_phy_connect() and phylink_connect_phy() are
> > being called from _open() callbacks of the Ethernet drivers so
> > as long as the Ethernet ports are !IFF_UP PHYs are not running,
> > LEDs are OFF, etc.
> 
> This is what is advised for Ethernet controller drivers to do, but is not
> strictly enforced or true throughout the entire tree, that is, it depends
> largely upon whether people writing/maintaining those drivers are sensitive
> to that behavior.

There are a number of MACs which do the connect in the probe. Both are
considered correct, and doing it in probe has advantages, such as
being able to return -EPROBE_DEFER because the PHY has not appeared
yet.

It should also be noted that phylib will not explicitly down a PHY
during the PHYs probe. So if the PHY is strapped to come up on power
up, or something else like the bootloader to brought it up, it will
remain up.

> I am sensitive to the power management aspect that getting the PHY and
> Ethernet link negotiated and then (re)negotiated several times through a
> products' boot cycle is a waste of energy and too many times do we break and
> make the link. The security aspect, I am less sensitive since the PHY is not
> how it should be enforced.

There are also people who as sensitive to the time it takes to
establish link. Auto-neg takes around 1.5 seconds. In some embedded
uses cases, that can be a long time, they want to avoid waiting for
that by strapping the PHY to start autoneg on power on, so it might be
ready to go by the time userspace ifup's the interface.

In general, PHY LEDs are a wild west in Linux, no well defined
behaviour. So i expect there are traditional NICs whos LEDs are on
when the link is admin down.

     Andrew
