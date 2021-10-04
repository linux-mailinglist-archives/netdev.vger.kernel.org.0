Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9330B421258
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 17:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235574AbhJDPKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 11:10:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233728AbhJDPKl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 11:10:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D13B06124B;
        Mon,  4 Oct 2021 15:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633360132;
        bh=YyiPjnhA/C8Zq0nFVh6TXVal9ej329r9Ds4u6daTnVk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n1HsymbdjNPn9mx1ESEllSEhWpOzCtdS9tXBzU6Eo1OIDZRdmCDqYLHR9NLOndqPb
         P7q7R5aU1P/e73e5APA+uvFMljrWS/osBdqpDkhsBZzTCqlutSc5ilr6MVMTAiOyu7
         2YtLGTavEYae49XfogZORP+Xh0On3TtUC96j4BuWqJpnyOVb/opw1SCiFnSU5TOFSX
         I+gE352cCJyz0biR2azy85dM4+7PbedLyrc3dZetDpUifJsULhrJKhu4b8isU9/FBv
         Fw+YcARed6YPl0Ww5LXtS9FcN9S/T4Aui9xiQGanne0xL3TjxZ5eD/D2cs49ByACrj
         LqNEn3txQLIow==
Date:   Mon, 4 Oct 2021 17:08:47 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Rob Herring <robh+dt@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: lets settle the LED `function` property regarding the netdev
 trigger
Message-ID: <20211004170847.3f92ef48@thinkpad>
In-Reply-To: <YVsUodiPoiIESrEE@lunn.ch>
References: <20211001143601.5f57eb1a@thinkpad>
        <YVn815h7JBtVSfwZ@lunn.ch>
        <20211003212654.30fa43f5@thinkpad>
        <YVsUodiPoiIESrEE@lunn.ch>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 Oct 2021 16:50:09 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > Hello Andrew,
> > 
> > I am aware of this, and in fact am working on a proposal for an
> > extension of netdev LED extension, to support the different link
> > modes. (And also to support for multi-color LEDs.)
> > 
> > But I am not entirely sure whether these different link modes should be
> > also definable via device-tree. Are there devices with ethernet LEDs
> > dedicated for a specific speed? (i.e. the manufacturer says in the
> > documentation of the device, or perhaps on the device's case, that this
> > LED shows 100M/1000M link, and that other LED is shows 10M link?)
> > If so, that this should be specified in the devicetree, IMO. But are
> > such devices common?  
> 
> I have a dumb 5 port switch next to me. One port is running at 1G. Its
> left green LED is on and blinks with traffic. Another port of the
> switch is running at 100Mbps and its right orange LED is on, blinks
> for traffic. And there is text on the case saying 10/100 orange, 1G
> green.
> 
> I think this is pretty common. You generally do want to know if 10/100
> is being used, it can indicate problems. Same for a 10G port running
> at 1G, etc.

OK then. I will work no a proposal for device tree bindings for this.

> > And what about multi-color LEDs? There are ethernet ports where one LED
> > is red-green, and so can generate red, green, and yellow color. Should
> > device tree also define which color indicates which mode?  
> 
> There are two different ways this can be implemented. There can be two
> independent LEDs within the same package. So you can generate three
> colours. Or there can be two cross connected LEDs within the
> package. Apply +ve you get one colour, apply -ve you get a different
> colour. Since you cannot apply both -ve and +ve at the same time, you
> cannot get both colours at once.
> 
> If you have two independent LEDs, I would define two LEDs in DT.

No, we have multicolor LED API which is meant for exactly this
situation: a multicolor LED.
(I am talking about something like the KJ2518D-262 from
 http://www.rego.com.tw/product_detail.php?prdt_id=258
 which has Green/Orange on left and Yellow on right side.
 The left Green/Orange LED has 3 pins, and so it can mix the colors into
 yellow.)

> Things get tricky for the two dependency LEDs. Does the LED core have
> support for such LEDs?

Unfortunately not yet. The multicolor API supports LEDs where the
sub-leds are independent.

> This is where we need to strike a balance between too simple and too
> complex. Implement most of the common features, but don't support
> exotic stuff, like two dependency LEDs?

I think the best solution here would be a subclass "enumcolor" (or
different name), where you can choose between several pre-defined colors.
In sysfs you could then do
  echo 1 >brightness
  echo green >color
  echo yellow >color

There already are other people who need to register such LEDs.

Marek
