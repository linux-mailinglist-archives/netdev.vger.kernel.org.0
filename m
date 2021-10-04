Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C814211FE
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 16:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235241AbhJDOwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 10:52:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47742 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234608AbhJDOwC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 10:52:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wOZTTETwQj+aeizjny2ZCg9H4PeRjV/em09E5T3i7eE=; b=Uk2eAfNzdCk2uC7qWfID3JcISm
        toY6VyR9oZSXNSBVujC/1L1b2mn2Dpzpe+df7kwFE4glcMeHhtIkyQy4KxpvgqfY/KshbsVE/uBUM
        NT4FapRTC2Q48JIfiRpsyubM5Gg6+mX30L+T6YEc5aJTGqfNWSLnatmcoSQ/LW61vvOU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mXPI9-009YcN-2b; Mon, 04 Oct 2021 16:50:09 +0200
Date:   Mon, 4 Oct 2021 16:50:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: lets settle the LED `function` property regarding the netdev
 trigger
Message-ID: <YVsUodiPoiIESrEE@lunn.ch>
References: <20211001143601.5f57eb1a@thinkpad>
 <YVn815h7JBtVSfwZ@lunn.ch>
 <20211003212654.30fa43f5@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211003212654.30fa43f5@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hello Andrew,
> 
> I am aware of this, and in fact am working on a proposal for an
> extension of netdev LED extension, to support the different link
> modes. (And also to support for multi-color LEDs.)
> 
> But I am not entirely sure whether these different link modes should be
> also definable via device-tree. Are there devices with ethernet LEDs
> dedicated for a specific speed? (i.e. the manufacturer says in the
> documentation of the device, or perhaps on the device's case, that this
> LED shows 100M/1000M link, and that other LED is shows 10M link?)
> If so, that this should be specified in the devicetree, IMO. But are
> such devices common?

I have a dumb 5 port switch next to me. One port is running at 1G. Its
left green LED is on and blinks with traffic. Another port of the
switch is running at 100Mbps and its right orange LED is on, blinks
for traffic. And there is text on the case saying 10/100 orange, 1G
green.

I think this is pretty common. You generally do want to know if 10/100
is being used, it can indicate problems. Same for a 10G port running
at 1G, etc.

> And what about multi-color LEDs? There are ethernet ports where one LED
> is red-green, and so can generate red, green, and yellow color. Should
> device tree also define which color indicates which mode?

There are two different ways this can be implemented. There can be two
independent LEDs within the same package. So you can generate three
colours. Or there can be two cross connected LEDs within the
package. Apply +ve you get one colour, apply -ve you get a different
colour. Since you cannot apply both -ve and +ve at the same time, you
cannot get both colours at once.

If you have two independent LEDs, I would define two LEDs in DT.

Things get tricky for the two dependency LEDs. Does the LED core have
support for such LEDs?

This is where we need to strike a balance between too simple and too
complex. Implement most of the common features, but don't support
exotic stuff, like two dependency LEDs?

       Andrew
