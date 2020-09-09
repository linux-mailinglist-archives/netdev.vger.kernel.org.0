Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843472638C8
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 23:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbgIIV60 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 9 Sep 2020 17:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgIIV6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 17:58:24 -0400
X-Greylist: delayed 3047 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Sep 2020 14:58:22 PDT
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF0CC061573;
        Wed,  9 Sep 2020 14:58:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 61832140A26;
        Wed,  9 Sep 2020 23:58:19 +0200 (CEST)
Date:   Wed, 9 Sep 2020 23:58:19 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Rob Herring <robh@kernel.org>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?B?T25kxZllag==?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next + leds v2 1/7] dt-bindings: leds: document
 binding for HW controlled LEDs
Message-ID: <20200909235819.0b0fe7ce@nic.cz>
In-Reply-To: <20200909211552.GA3066273@bogus>
References: <20200909162552.11032-1-marek.behun@nic.cz>
        <20200909162552.11032-2-marek.behun@nic.cz>
        <20200909211552.GA3066273@bogus>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Sep 2020 15:15:52 -0600
Rob Herring <robh@kernel.org> wrote:

> On Wed, Sep 09, 2020 at 06:25:46PM +0200, Marek Behún wrote:
> > Document binding for LEDs connected to and controlled by various chips
> > (such as ethernet PHY chips).  
> 
> If they are h/w controlled, then why are they in DT?

The idea is that by default these LEDs are in some specific HW control
mode (the chip default), but the chip supports various HW control
modes, and also supports SW control.
For example on Marvell PHYs there is a 4-bit register for each LED, so
16 values, and some of them are:
  0000: On - Receive
        Off - No receive
  0001: On - Link
        Blink - Activity
        Off - No Link
  ...
  0101: On - 100Mbps or Fiber Link
        Off - Else
  ...
  1000: Force Off
  1001: Force On
  ...
  1011: Force Blink

So writing 0x8 disables the LED, 0x9 enabled it (SW control via
/sys/class/leds/<LED>/brightness), other values change the HW control
mode (in this proposal /sys/class/leds/<LED>/hw_mode when trigger is
set to dev-hw-mode).

> > 
> > Signed-off-by: Marek Behún <marek.behun@nic.cz>
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Cc: devicetree@vger.kernel.org
> > ---
> >  .../leds/linux,hw-controlled-leds.yaml        | 99 +++++++++++++++++++
> >  1 file changed, 99 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.yaml
> > 
> > diff --git a/Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.yaml b/Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.yaml
> > new file mode 100644
> > index 0000000000000..eaf6e5d80c5f5
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.yaml
> > @@ -0,0 +1,99 @@
> > +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/leds/linux,hw-controlled-leds.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: LEDs that can be controlled by hardware (eg. by an ethernet PHY chip)
> > +
> > +maintainers:
> > +  - Marek Behún <marek.behun@nic.cz>
> > +
> > +description:
> > +  Many an ethernet PHY (and other chips) supports various HW control modes
> > +  for LEDs connected directly to them. With this binding such LEDs can be
> > +  described.
> > +
> > +properties:
> > +  compatible:
> > +    const: linux,hw-controlled-leds  
> 
> What makes this linux specific?
> 
> Unless you're going to make this h/w specific, then it probably should 
> just be dropped. 
> 

Will do, thanks.

> The phy schema will need:
> 
> leds:
>   type: object
>   $ref: /schemas/leds/hw-controlled-leds.yaml#
> 
> > +
> > +  "#address-cells":
> > +    const: 1
> > +
> > +  "#size-cells":
> > +    const: 0
> > +
> > +patternProperties:
> > +  "^led@[0-9a-f]+$":
> > +    type: object
> > +    allOf:
> > +      - $ref: common.yaml#
> > +    description:
> > +      This node represents a LED device connected to a chip that can control
> > +      the LED in various HW controlled modes.
> > +
> > +    properties:
> > +      reg:
> > +        maxItems: 1
> > +        description:
> > +          This property identifies the LED to the chip the LED is connected to
> > +          (eg. an ethernet PHY chip can have multiple LEDs connected to it).
> > +
> > +      enable-active-high:
> > +        description:
> > +          Polarity of LED is active high. If missing, assumed default is active
> > +          low.
> > +        type: boolean
> > +
> > +      led-tristate:
> > +        description:
> > +          LED pin is tristate type. If missing, assumed false.
> > +        type: boolean
> > +
> > +      linux,default-hw-mode:  
> 
> How is this linux specific? It sounds device specific. Your choice is 
> make this a device specific property with device specific values or come 
> up with generic modes.

I was inspired by `linux,default-trigger` and `linux,keycode`
properties...
 
> Perhaps 'function' should be expanded.

The thing is that `function` is now used for creating LED device name.
I was not aware that `linux,default-trigger` is deprecated
Perhaps this should be discussed with Pavel as well.
But of course from the perspective that DT should be independent from
Linux, you are right.
I fear this will be quite a pain to resolve...

> > +        description:
> > +          This parameter, if present, specifies the default HW triggering mode
> > +          of the LED when LED trigger is set to `dev-hw-mode`.
> > +          Available values are specific per device the LED is connected to and
> > +          per LED itself.
> > +        $ref: /schemas/types.yaml#definitions/string
> > +
> > +    required:
> > +      - reg
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +
> > +    #include <dt-bindings/leds/common.h>
> > +
> > +    ethernet-phy@0 {
> > +        compatible = "ethernet-phy-ieee802.3-c45";
> > +        reg = <0>;
> > +
> > +        leds {
> > +            compatible = "linux,hw-controlled-leds";
> > +            #address-cells = <1>;
> > +            #size-cells = <0>;
> > +
> > +            led@0 {
> > +                reg = <0>;
> > +                color = <LED_COLOR_ID_GREEN>;
> > +                function = <LED_FUNCTION_STATUS>;  
> 
> Reading the description of LED_FUNCTION_STATUS doesn't align with how 
> you are using it. Think of it as user alert/notification.
> 
> > +                linux,default-trigger = "dev-hw-mode";  
> 
> This is deprecated in favor of 'function'.

As written above, this is not how the LED subsystem currently works.
Nor is the deprecation documented.

Currently `function` is used to create LED device name in the form
`device:color:function` or `device:color:function-N` if
`function-enumerator` is also set.

> 
> > +                linux,default-hw-mode = "1Gbps";
> > +            };
> > +
> > +            led@1 {
> > +                reg = <1>;
> > +                color = <LED_COLOR_ID_YELLOW>;
> > +                function = <LED_FUNCTION_ACTIVITY>;
> > +                linux,default-trigger = "dev-hw-mode";
> > +                linux,default-hw-mode = "activity";
> > +            };
> > +        };
> > +    };
> > +
> > +...
> > -- 
> > 2.26.2
> >   

