Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0E015478
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 21:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfEFTdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 15:33:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56155 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726190AbfEFTdR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 15:33:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RHdPpckqPDyvdI9hgd3ivdy7BwlPmrYeJYGbEjPzhIQ=; b=iq6UXkezK/7BH2CDHnWD3aQ5XX
        ss0J4xpEHOHbGyhUDCClE+O69DEIO63WhcoaAHzo85qoEaWdZfFn8sNfWzlnbquVGX/rNv8fbsAB6
        V0pfgR8+0A21ihKwa5Fe7wkrlUF5Dy8Osx1qln/qxYTJsNTATDIhcIylvwzAUVGX4Uv8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hNjMH-0000Xf-9I; Mon, 06 May 2019 21:33:05 +0200
Date:   Mon, 6 May 2019 21:33:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ruslan Babayev <ruslan@babayev.com>
Cc:     linux@armlinux.org.uk, f.fainelli@gmail.com, hkallweit1@gmail.com,
        mika.westerberg@linux.intel.com, wsa@the-dreams.de,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org, xe-linux-external@cisco.com
Subject: Re: [PATCH net-next 2/2] net: phy: sfp: enable i2c-bus detection on
 ACPI based systems
Message-ID: <20190506193305.GA25013@lunn.ch>
References: <20190505220524.37266-3-ruslan@babayev.com>
 <20190506125523.GA15291@lunn.ch>
 <87zhnztnby.fsf@babayev.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zhnztnby.fsf@babayev.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew,
> 
> I had the GPIOs and the "maximum-power" property in my ACPI snippet initially,
> but then decided to take it out thinking it was not relevant for the
> current patch. I can add the missing pieces back in V2.
> This is what it would like:
> 
> Device (SFP0)
> {
>     Name (_HID, "PRP0001")
>     Name (_CRS, ResourceTemplate()
>     {
>         GpioIo(Exclusive, PullDefault, 0, 0, IoRestrictionNone,
>                "\\_SB.PCI0.RP01.GPIO", 0, ResourceConsumer)
>             { 0, 1, 2, 3, 4 }
>     })
>     Name (_DSD, Package ()
>     {
>         ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>         Package () {
>             Package () { "compatible", "sff,sfp" },
>             Package () { "i2c-bus", \_SB.PCI0.RP01.I2C.MUX.CH0 },
>             Package () { "maximum-power-milliwatt", 1000 },
>             Package () { "tx-disable-gpios", Package () { ^SFP0, 0, 0, 1} },
>             Package () { "reset-gpio",       Package () { ^SFP0, 0, 1, 1} },
>             Package () { "mod-def0-gpios",   Package () { ^SFP0, 0, 2, 1} },
>             Package () { "tx-fault-gpios",   Package () { ^SFP0, 0, 3, 0} },
>             Package () { "los-gpios",        Package () { ^SFP0, 0, 4, 1} },
>         },
>     })
> }

Hi Ruslan

I know approximately 0 about ACPI. But that at least lists all the
properties we expect. Thanks.

> > Before accepting this patch, i would like to know more about the
> > complete solution.
> 
> I haven't gotten that far yet, but for the Phylink I was thinking something along the
> lines of:
> 
> Device (PHY0)
> {
>     Name (_HID, "PRP0001")
>     Name (_DSD, Package ()
>     {
>         ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>         Package () {
>             Package () { "compatible", "ethernet-phy-ieee802.3-c45" },
>             Package () { "sfp", \_SB.PCI0.RP01.SFP0 },
>         },
>     })
> }

You probably also need managed = "in-band-status" and
phy-mode = "sgmii";

armada-388-clearfog.dtsi is probably the best reference, much of the
development work for Phylink and SFPs was done on that board.

> I don't have a complete solution working yet. With these patches
> I was hoping to get some early feedback.

Please post your patches as "RFC" in the subject line, if you are
wanting early feedback.

Thanks
	Andrew
