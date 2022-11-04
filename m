Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4F3B6197A3
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 14:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbiKDNWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 09:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbiKDNVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 09:21:55 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A592E6AB;
        Fri,  4 Nov 2022 06:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ePYx94fnw4VU1mG7pkgyjL4uKtELJLPQIsvnGRh+lK8=; b=ysrhVSB2jRWgg4JRPqbKAZV+aw
        ZvgrnNYYruU+ed3RVLW8ClKK9+GVHpr05Wlzzx5el1FKjO7upFTldmFZhOpEh5DXBIiHqIfx3vFY2
        9jp0oTHeJ4UWshwv5RnUsw4WBmqimdXpEPOdriG35+CkDpyiU7pKvO9zg6Sx1kbL3CZI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oqwd5-001QSa-7z; Fri, 04 Nov 2022 14:21:03 +0100
Date:   Fri, 4 Nov 2022 14:21:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 1/2] dt-bindings: dp83867: define ti,ledX-active-low
 properties
Message-ID: <Y2URvw9xtXFXOUNR@lunn.ch>
References: <20221103143118.2199316-1-linux@rasmusvillemoes.dk>
 <20221103143118.2199316-2-linux@rasmusvillemoes.dk>
 <Y2Q9+qqwRqEu5btz@lunn.ch>
 <893c83e7-8b11-0439-6f38-d522f4a1a368@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <893c83e7-8b11-0439-6f38-d522f4a1a368@rasmusvillemoes.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 08:17:44AM +0100, Rasmus Villemoes wrote:
> On 03/11/2022 23.17, Andrew Lunn wrote:
> > On Thu, Nov 03, 2022 at 03:31:17PM +0100, Rasmus Villemoes wrote:
> >> The dp83867 has three LED_X pins that can be used to drive LEDs. They
> >> are by default driven active high, but on some boards the reverse is
> >> needed. Add bindings to allow a board to specify that they should be
> >> active low.
> > 
> > Somebody really does need to finish the PHY LEDs via /sys/class/leds.
> > It looks like this would then be a reasonable standard property:
> > active-low, not a vendor property.
> > 
> > Please help out with the PHY LEDs patches.
> 
> So how do you imagine this to work in DT? Should the dp83867 phy node
> grow a subnode like this?
> 
>   leds {
>     #address-cells = <1>;
>     #size-cells = <0>;
> 
>     led@0 {
>       reg = <0>;
>       active-low;
>     };
>     led@2 {
>       reg = <2>;
>       active-low;
>     };
>   };

Yes, something like that. They should follow the DT binding for LEDs.
Documentation/devicetree/bindings/leds/common.yaml

> 
> Since the phy drives the leds automatically based on (by default)
> link/activity, there's not really any need for a separate LED driver nor
> do I see what would be gained by somehow listing the LEDs in
> /sys/class/leds. Please expand.

The PHY driver would be the LED driver, hopefully with some shared
code in phylib. You can then use the standard Linux LED way of
configuring what the LED means, using triggers. Those triggers get
offloaded to the hardware when possible, or done in software when not.
The DT binding would then follow the common LED binding.

What i want to get away from is that there is no consistent DT binding
for PHY leds. In fact, there are at least four different ways to
configure PHY leds, and you want to add a fifth.

	  Andrew
