Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67D83594DF
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 07:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233342AbhDIFms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 01:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233296AbhDIFms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 01:42:48 -0400
X-Greylist: delayed 31788 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 08 Apr 2021 22:42:35 PDT
Received: from polaris.svanheule.net (polaris.svanheule.net [IPv6:2a00:c98:2060:a004:1::200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C75C061760
        for <netdev@vger.kernel.org>; Thu,  8 Apr 2021 22:42:35 -0700 (PDT)
Received: from [IPv6:2a02:a03f:eaff:9f01:d655:559e:db93:11ac] (unknown [IPv6:2a02:a03f:eaff:9f01:d655:559e:db93:11ac])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: sander@svanheule.net)
        by polaris.svanheule.net (Postfix) with ESMTPSA id D7DA51ED083;
        Fri,  9 Apr 2021 07:42:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svanheule.net;
        s=mail1707; t=1617946954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6H1fBx+Q041v69ku9nTDNJB1L4reFirfk9JrDv8gQ5U=;
        b=O5I0n81KleKChxtNGM8oIzXHHxlZMsMB+cvt+zkmMfyFTdwK5ILkGtbozctyXLpD5AgwXw
        JiVUqqKh4++HY6Ms/PftF9hy8GyqzdVRWkCWTXR0Qj5UUkutBDOc4qeL4P0CDgrTrg2dai
        lSrLsbIeAsZz2e/ylL5i1YtzOb0iksQoyDspp9j13Q3mgBvl4b9T16VRiTKWn9lU519ZIT
        L9Zr8Kz3lBEukjj0ArhXDKwAdQdHUbZWCeRirlUnEoYE4lkB77nDrQX0Lh06wCH/FePJsY
        jJjrPC1K9XSNn9RbMvY0TMyYEGbqxtH0Q0/RAUsLHlMlWeQHbq4YFPmszJlakQ==
Message-ID: <d73a44809c96abd0397474c63219a41e28f78235.camel@svanheule.net>
Subject: Re: [RFC PATCH 0/2] MIIM regmap and RTL8231 GPIO expander support
From:   Sander Vanheule <sander@svanheule.net>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>, bert@biot.com
Date:   Fri, 09 Apr 2021 07:42:32 +0200
In-Reply-To: <YG+BObnBEOZnoJ1K@lunn.ch>
References: <cover.1617914861.git.sander@svanheule.net>
         <YG+BObnBEOZnoJ1K@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thank you for the feedback. You can find a (leaked) datasheet at:
https://github.com/libc0607/Realtek_switch_hacking/blob/files/RTL8231_Datasheet_1.2.pdf

On Fri, 2021-04-09 at 00:18 +0200, Andrew Lunn wrote:
> > - Providing no compatible for an MDIO child node is considered to
> > be equivalent
> >   to a c22 ethernet phy, so one must be provided. However, this
> > node is then
> >   not automatically probed.
> 
> It cannot be automatically probed, since register 2 and 3 do not
> contain an ID, which PHYs do. So you need to explicitly list in on
> the
> MDIO bus, and when the of_mdiobus_register() is called, the device
> will be instantiated.
> 
> Is it okay to provide a binding without a driver?
> >   If some code is required, where should this be put?
> >   Current devicetree structure:
> >     mdio-bus {
> >         compatible = "vendor,mdio";
> >         ...
> > 
> >         expander0: expander@0 {
> >             /*
> >              * Provide compatible for working registration of mdio
> > device.
> >              * Device probing happens in gpio1 node.
> >              */
> >             compatible = "realtek,rtl8231-expander";
> >             reg = <0>;
> >         };
> > 
> >     };
> >     gpio1 : ext_gpio {
> >         compatible = "realtek,rtl8231-mdio";
> >         gpio-controller;
> >         ...
> >     };
> 
> I don't understand this split. Why not
> 
>      mdio-bus {
>          compatible = "vendor,mdio";
>          ...
>  
>          expander0: expander@0 {
>              /*
>               * Provide compatible for working registration of mdio
> device.
>               * Device probing happens in gpio1 node.
>               */
>              compatible = "realtek,rtl8231-expander";
>              reg = <0>;
>              gpio-controller;
>          };
>      };
> 
> You can list whatever properties you need in the node. Ethernet
> switches have interrupt-controller, embedded MDIO busses with PHYs on
> them etc.

This is what I tried initially, but it doesn't seem to work. The node
is probably still added as an MDIO device, but rtl8231_gpio_probe()
doesn't appear to get called at all. I do agree it would be preferable
over the split specification.

Having another look, I see mdio_device_id is used for ethernet phys,
but like you said this requires and ID in registers 2 & 3. These
registers contain pin configuration on the RTL8231, so this can't be
used.
Registering as a phy_driver appears to have the same issue, although it
looks like I could use a custom match_phy_device(). I do feel like this
would be stretching the meaning of what a PHY is.


> > - MFD driver:
> >   The RTL8231 is not just a GPIO expander, but also a pin
> > controller and LED
> >   matrix controller. Regmap initialisation could probably be moved
> > to a parent
> >   MFD, with gpio, led, and pinctrl cells. Is this a hard
> > requirement if only a
> >   GPIO controller is provided?
> 
> You need to think about forward/backwards compatibility. You are
> defining a binding now, which you need to keep. Do you see how an MFD
> could be added without breaking backwards compatibility?

There are pin-/gpio-controllers that have the gpio and pinctrl nodes in
the device's root node. So I think adding pinctrl later shouldn't be an
issue. The LED matrix description would probably need a dedicated sub-
node. I'll see if I can write some preliminary bindings later today or
this weekend.

Best,
Sander


