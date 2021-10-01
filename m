Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1CCA41EAB2
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 12:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353419AbhJAKLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 06:11:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230073AbhJAKLm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 06:11:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 038A061A71;
        Fri,  1 Oct 2021 10:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633082998;
        bh=yGcc2/IH57GL8/dGeCk7gJu5M47+x3PqFv2lP+zivkM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dnWdZ29jm8d83BjZYRBo+9sBMR0C5HVnqcfgBHpWDxNCfovNNXImE85uV/uSaOPWy
         +aRma9NA3iC8jXwF4rkuWrHnKU03jow/7QB7r41B7kGt5YLYulWQdHFuC9koXvGUBF
         2gUBNDU0vNVaswBU/2ZKbj4OgtzahHeOp5Ct+Yqm2kdkLJMKs9TxBRulGFoHSw3M2P
         tC5g7XLezFqLFYGWCC8VAkO2p8wQXtWldKUS2uGJfh225quUeknBogL7xhFgEHgprD
         AGrxVEBjvHy90anYKNZiTBAociTEBvNQQproS/D8GlLtx/LpgspbtKfWI62XTiwZqZ
         IdA+77qv781Mw==
Date:   Fri, 1 Oct 2021 12:09:52 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Frieder Schrempf <frieder.schrempf@kontron.de>,
        linux-leds@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Frieder Schrempf <frieder@fris.de>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: Re: [PATCH 1/3] net: phy: mscc: Add possibilty to disable combined
 LED mode
Message-ID: <20211001120952.6be6bb36@thinkpad>
In-Reply-To: <18de5e10-f41f-0790-89c8-3a70d48539be@kontron.de>
References: <20210930125747.2511954-1-frieder@fris.de>
        <YVZQuIr2poOfWvcO@lunn.ch>
        <18de5e10-f41f-0790-89c8-3a70d48539be@kontron.de>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 1 Oct 2021 11:20:36 +0200
Frieder Schrempf <frieder.schrempf@kontron.de> wrote:

> On 01.10.21 02:05, Andrew Lunn wrote:
> > On Thu, Sep 30, 2021 at 02:57:43PM +0200, Frieder Schrempf wrote:  
> >> From: Frieder Schrempf <frieder.schrempf@kontron.de>
> >>
> >> By default the LED modes offer to combine two indicators like speed/link
> >> and activity in one LED. In order to use a LED only for the first of the
> >> two modes, the combined feature needs to be disabled.
> >>
> >> In order to do this we introduce a boolean devicetree property
> >> 'vsc8531,led-[N]-combine-disable' and wire it up to the matching
> >> bits in the LED behavior register.  
> > 
> > Sorry, but no DT property. Each PHY has its own magic combination of
> > DT properties, nothing shared, nothing common. This does not scale.
> > 
> > Please look at the work being done to control PHY LEDs using the Linux
> > LED infrastructure. That should give us one uniform interface for all
> > PHY LEDs.  
> 
> +Cc: Marek
> 
> I guess you are referring to this: [1]?
> 
> If so, the last version I could find is a year old now. Is anyone still
> working on this?

Yes, I am still working on this.

Anyway the last version is not one year old, the last version to add
this support is 4 months old:
https://lore.kernel.org/netdev/20210602144439.4d20b295@dellmb/T/

This version does not add the code for ethernet PHYs, instead it just
tries to touch only the LED subsystem by adding the API for offloading
LED triggers and an example implementation for Turris Omnia LED
controller.

I will probably send another version this weekend. Sorry this takes
this long.


> I understand, that the generic approach is the one we want to have, but
> does this really mean adding PHY led configuration via DT to existing
> drivers (that already use DT properties for LED modes) is not accepted
> anymore, even if the new API is not yet in place?

I don't know about Rob, but I would be against it.

But if you need to have your PHY LED configured with via devicetree
ASAP, instead of proposing the vendor specific property, you can
propose LED subnodes and properties that will be generic and compatible
with the LED subsystem API, i.e. something like:

  ethernet-phy@1 {
    .... eth phy properties;

    leds {
      led@0 {
        reg = <0>;
        color = <LED_COLOR_ID_GREEN>;
        /* this LED should indicate link/speed */
        function = LED_FUNCTION_LINK; 
      };
    };
  }

Then make your PHY driver parse this, and make it so that if
function is LED_FUNCTION_LINK or LED_FUNCTION_ACTIVITY, the driver will
disable combined mode.

Afterwards, when LED subsystem has support for trigger offloading, you
can update mscc driver so that instead of just disabling combined mode,
it will register the LEDs via LED subsystem...

Marek
