Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96F6A91A78
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 02:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbfHSAaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 20:30:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40290 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbfHSAaH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Aug 2019 20:30:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JhswlMGTzAxtUu2gpPdTP1QD3pZTZewNYaEA8O+81wU=; b=ZxHSxNkUZhK8JxTc+dbjCXc1+G
        wsjGmV9b3kqycDNgQVhm2lEVOdnj1Ifim0pbTW3yGAiPy+qkR45vQIb5Tsc9Y0pGunFQBIlPbeXhK
        BoTHadyMMGhJkSPrSxr/VVHuYeUMjfVGmFOmu1ZACXtY/9MXJDx2Cga8lnoS/K3CSgvg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hzVYV-0002OZ-64; Mon, 19 Aug 2019 02:29:51 +0200
Date:   Mon, 19 Aug 2019 02:29:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     Pavel Machek <pavel@ucw.cz>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v6 1/4] dt-bindings: net: phy: Add subnode for LED
 configuration
Message-ID: <20190819002951.GA8981@lunn.ch>
References: <20190813191147.19936-1-mka@chromium.org>
 <20190813191147.19936-2-mka@chromium.org>
 <20190816201338.GA1646@bug>
 <20190816220411.GX250418@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816220411.GX250418@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 16, 2019 at 03:04:11PM -0700, Matthias Kaehlcke wrote:
> On Fri, Aug 16, 2019 at 10:13:38PM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > Please Cc led mailing lists on led issues.
> 
> sorry for missing this
> 
> > On Tue 2019-08-13 12:11:44, Matthias Kaehlcke wrote:
> > > The LED behavior of some Ethernet PHYs is configurable. Add an
> > > optional 'leds' subnode with a child node for each LED to be
> > > configured. The binding aims to be compatible with the common
> > > LED binding (see devicetree/bindings/leds/common.txt).
> > > 
> > > A LED can be configured to be:
> > > 
> > > - 'on' when a link is active, some PHYs allow configuration for
> > >   certain link speeds
> > >   speeds
> > > - 'off'
> > > - blink on RX/TX activity, some PHYs allow configuration for
> > >   certain link speeds
> > > 
> > > For the configuration to be effective it needs to be supported by
> > > the hardware and the corresponding PHY driver.
> > > 
> > > Suggested-by: Andrew Lunn <andrew@lunn.ch>
> > > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > 
> > > @@ -173,5 +217,20 @@ examples:
> > >              reset-gpios = <&gpio1 4 1>;
> > >              reset-assert-us = <1000>;
> > >              reset-deassert-us = <2000>;
> > > +
> > > +            leds {
> > > +                #address-cells = <1>;
> > > +                #size-cells = <0>;
> > > +
> > > +                led@0 {
> > > +                    reg = <0>;
> > > +                    linux,default-trigger = "phy-link-1g";
> > > +                };
> > 
> > Because this affects us.
> > 
> > Is the LED software controllable?
> 
> it might be for certain PHYs, integration with the LED framework is
> not part of this series.
> 
> > Or can it do limited subset of triggers you listed?
> 
> it depends on the PHY. The one in this series (RTL8211E) only supports
> a limited subset of the listed triggers.

Hi Pavel

At the moment, there is no integration with the LED
subsystem. However, i would like to be prepared for it in the
future. It will also require some extensions to the LED subsystem.
These triggers are hardware triggers. We would need to add support for
LED trigger offload to the hardware, not have Linux blink the LED in
software. Plus we need per LED triggers, not only global triggers.
Most Ethernet PHYs also allow on/off state to be set, so they could be
software controllable, and support the generic triggers Linux has.

It has been on my mind to do this for a while, but i've never had the
time. It should also be applicable to other subsystems which have
hardware to blink LEDs. Some serial ports can control LEDs for Rx/Tx
and flow control. Maybe disk/RAID controllers are configuration how
they blink there LEDs?

      Andrew
