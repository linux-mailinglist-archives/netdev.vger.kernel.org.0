Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821334232FB
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 23:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236719AbhJEVpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 17:45:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231167AbhJEVph (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 17:45:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA53B6115B;
        Tue,  5 Oct 2021 21:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633470226;
        bh=WSHqCxwflqcKiT4irCE8NVjFBqw/353tC8L3Y9Ud/TI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ScmUt3fswhW0wl194TQi6oZyg8Vnh1ZvtfHQ9IWUNX/pReP6oohtj8AgjDUSbtZEz
         zVL/iYigoegiTcipiIhaJICnIckaUQZGL8vie8YySTZe+r+texQfzMQU5Hp+8xUH9I
         Uu5t/397vlJONtqayAAqVrNpkes3cGbJuBTYiG8lTh5n0vuSFqVJdRvgxRVx+8JvVl
         36Q1zw+SmY5BjYBQJOU2nOMzjOY/gpQ7T0Bo/vU3h2cWPv+D2I/BZHh9n2QGHEVEEz
         LSYUCFNH3+oIg5AvyTFfaGZKb7Vnp9fg/YJh8Io6+P3W4hbaP2cq4rINjyxNijkKOi
         yYcOO1wb3E9Tw==
Date:   Tue, 5 Oct 2021 23:43:42 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: lets settle the LED `function` property regarding the netdev
 trigger
Message-ID: <20211005234342.7334061b@thinkpad>
In-Reply-To: <YVy9Ho47XeVON+lB@lunn.ch>
References: <20211001143601.5f57eb1a@thinkpad>
        <YVn815h7JBtVSfwZ@lunn.ch>
        <20211003212654.30fa43f5@thinkpad>
        <YVsUodiPoiIESrEE@lunn.ch>
        <20211004170847.3f92ef48@thinkpad>
        <0b1bc2d7-6e62-5adb-5aed-48b99770d80d@gmail.com>
        <20211005222657.7d1b2a19@thinkpad>
        <YVy9Ho47XeVON+lB@lunn.ch>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Oct 2021 23:01:18 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > In the discussed case (ethernet PHY LEDs) - it is sometimes possible to
> > have multiple brightness levels per color channel. For example some
> > Marvell PHYs allow to set 8 levels of brightness for Dual Mode LEDs.
> > Dual Mode is what Marvell calls when the PHY allows to pair two
> > LED pins to control one dual-color LED (green-red, for example) into
> > one.
> > 
> > Moreover for this Dual Mode case they also allow for HW control of
> > this dual LED, which, when enabled, does something like this, in HW:
> >   1g link	green
> >   100m link	yellow
> >   10m link	red
> >   no link	off
> > 
> > Note that actual colors depend on the LEDs themselves. The PHY
> > documentation does not talk about the color, only about which pin is
> > on/off. The thing is that if we want to somehow set this mode for the
> > LED, it should be represented as one LED class device.
> > 
> > I want to extend the netdev trigger to support such configuration,
> > so that when you have multicolor LED, you will be able to say which
> > color should be set for which link mode.  
> 
> This is getting into the exotic level i don't think we need to
> support. How many PHYs have you seen that support something like this?

This isn't about whether there are PHYs which support this in HW.
The extension to netdev trigger will be able to do this in SW.

For example the Turris Omnia has 12 RGB LEDs on the front panel, of
which 6 are dedicated to ethernet ports (and there are no LEDs on
ethernet ports themselves). It would make sense to be able to have
netdev trigger (or it's extension) show link mode by color (for example
green on 1g, yellow on 100g, orange on 10g).

Anyway when you have a green-yellow LED on an ethernet port wired in
such a way than it can only be off, green or yellow, but not both green
and yellow, I don't think we should register these as 2 LED class
devices.

> I suggest we start with simple independent LEDs. That gives enough to
> support the majority of use cases people actually need. And is enough
> to unblock people who i keep NACKing patches and tell them to wait for
> this work to get merged.

Of course, and I plan to do so. Those netdev trigger extensions and
multi-color function definitions are for later :)

We got side tracked in this discussion, sorry about that.

In this thread I just wanted to settle the LED function property for
LEDs indicating network ports.

So would you, Andrew, agree with:
- extending function property to be array of strings instead of only
  one string, so that we can do
    function = "link", "activity";
- having separate functions for different link modes
    function = "link1000", "link100";
  or should this insted be in another property
    function = "link";
    link-modes = <1000 100>;
  ?

Marek
