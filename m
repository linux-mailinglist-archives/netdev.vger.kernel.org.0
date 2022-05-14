Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A510526F5E
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 09:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiENCx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 22:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiENCx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 22:53:28 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FCE835B1F7;
        Fri, 13 May 2022 17:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qyZsoJknrWOVDvtpNszTIIAof3pgi3xfB+EMxclimb4=; b=YUKlqPWGIDZvhXATbELAlppcVk
        92/7Q/rIwsA0xahE9uRHrV3gPbUEYEv1caC2w8u4thxI4DZV33oa7K1SUXBsSPdiaPrKdyPix/5QH
        oYl1lWBxbSzo2oFcsrRYadLQzEMPbCWhroO2ghC15gjxxUxR5c16PCzSrzvjpeagk87c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1npfZX-002hd6-UG; Sat, 14 May 2022 02:23:51 +0200
Date:   Sat, 14 May 2022 02:23:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        John Stultz <jstultz@google.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC PATCH net 0/2] Make phylink and DSA wait for PHY driver
 that defers probe
Message-ID: <Yn72l3O6yI7YstMf@lunn.ch>
References: <20220513233640.2518337-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513233640.2518337-1-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 14, 2022 at 02:36:38AM +0300, Vladimir Oltean wrote:
> This patch set completes the picture described by
> '[RFC,devicetree] of: property: mark "interrupts" as optional for fw_devlink'
> https://patchwork.kernel.org/project/netdevbpf/patch/20220513201243.2381133-1-vladimir.oltean@nxp.com/
> 
> I've CCed non-networking maintainers just in case they want to gain a
> better understanding. If not, apologies and please ignore the rest.
> 
> 
> 
> My use case is to migrate a PHY driver from poll mode to interrupt mode
> without breaking compatibility between new device trees and old kernels
> which did not have a driver for that IRQ parent, and therefore (for
> things to work) did not even have that interrupt listed in the "vintage
> correct" DT blobs. Note that current kernels as of today are also
> "old kernels" in this description.
> 
> Creating some degree of compatibility has multiple components.
> 
> 1. A PHY driver must eventually give up waiting for an IRQ provider,
>    since the dependency is optional and it can fall back to poll mode.
>    This is currently supported thanks to commit 74befa447e68 ("net:
>    mdio: don't defer probe forever if PHY IRQ provider is missing").
> 
> 2. Before it finally gives up, the PHY driver has a transient phase of
>    returning -EPROBE_DEFER. That transient phase causes some breakage
>    which is handled by this patch set, details below.
> 
> 3. PHY device probing and Ethernet controller finding it and connecting
>    to it are async events. When both happen during probing, the problem
>    is that finding the PHY fails if the PHY defers probe, which results
>    in a missing PHY rather than waiting for it. Unfortunately there is
>    no universal way to address this problem, because the majority of
>    Ethernet drivers do not connect to the PHY during probe. So the
>    problem is fixed only for the driver that is of interest to me in
>    this context, DSA, and with special API exported by phylink
>    specifically for this purpose, to limit the impact on other drivers.

There is a very different approach, which might be simpler.

We know polling will always work. And it should be possible to
transition between polling and interrupt at any point, so long as the
phylock is held. So if you get -EPROBE_DEFFER during probe, mark some
state in phydev that there should be an irq, but it is not around yet.
When the phy is started, and phylib starts polling, look for the state
and try getting the IRQ again. If successful, swap to interrupts, if
not, keep polling. Maybe after 60 seconds of polling and trying, give
up trying to find the irq and stick with polling.

     Andrew
