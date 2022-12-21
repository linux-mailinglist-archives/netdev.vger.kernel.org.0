Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 081F9652A4F
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 01:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbiLUAMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 19:12:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiLUAM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 19:12:29 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E031EAFB;
        Tue, 20 Dec 2022 16:12:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GH9M5bV1VooJkjUWIga/hv2jQxEHFDZMjQbWm1O6tc8=; b=YulGIBLlt+uAz1B3XpSn3PEV2l
        JlPFmq6JYNmPnNsrPUTUWCQv1rTeNKwyMxxG8RqU1knVI4VYHeVZ0IboHTv33PVi7B2CsmxPiyH00
        t5APlVAPVzm1NTlEkuCzGpEYQKYCtPDAOUKwwtDLsojqRWFXbCL3dSTlJHcPhzRisrzI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p7miW-0008LK-86; Wed, 21 Dec 2022 01:12:16 +0100
Date:   Wed, 21 Dec 2022 01:12:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH v7 09/11] leds: trigger: netdev: add additional hardware
 only triggers
Message-ID: <Y6JPYBQhtpZLadry@lunn.ch>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
 <20221214235438.30271-10-ansuelsmth@gmail.com>
 <Y5ta87eCAQ8XsY8L@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5ta87eCAQ8XsY8L@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 15, 2022 at 05:35:47PM +0000, Russell King (Oracle) wrote:
> On Thu, Dec 15, 2022 at 12:54:36AM +0100, Christian Marangi wrote:
> > Add additional hardware only triggers commonly supported by switch LEDs.
> > 
> > Additional modes:
> > link_10: LED on with link up AND speed 10mbps
> > link_100: LED on with link up AND speed 100mbps
> > link_1000: LED on with link up AND speed 1000mbps
> > half_duplex: LED on with link up AND half_duplex mode
> > full_duplex: LED on with link up AND full duplex mode
> 
> Looking at Marvell 88e151x, I don't think this is usable there.
> We have the option of supporting link_1000 on one of the LEDs,
> link_100 on another, and link_10 on the other. It's rather rare
> for all three leds to be wired though.

The 88e151x will need to enumerate what it actually supports from the
above list, per LED. I also think we can carefully expand the list
above, adding a few more modes. We just need to ensure what is added
is reasonably generic, modes we expect multiple PHY to support. What
we need to avoid is adding every single mode a PHY supports, but no
other PHY has.

> This is also a PHY where "activity" mode is supported (illuminated
> or blinking if any traffic is transmitted or received) but may not
> support individual directional traffic in hardware. However, it
> does support forcing the LED on or off, so software mode can handle
> those until the user selects a combination of modes that are
> supported in the hardware.
> 
> > Additional blink interval modes:
> > blink_2hz: LED blink on any even at 2Hz (250ms)
> > blink_4hz: LED blink on any even at 4Hz (125ms)
> > blink_8hz: LED blink on any even at 8Hz (62ms)
> 
> This seems too restrictive. For example, Marvell 88e151x supports
> none of these, but does support 42, 84, 170, 340, 670ms.

I would actually drop this whole idea of being able to configure the
blink period. It seems like it is going to cause problems. I expect
most PHYs actual share the period across multiple LEDs, which you
cannot easily model here.

So i would have the driver hard coded to pick a frequency at thats' it.

   Andrew
