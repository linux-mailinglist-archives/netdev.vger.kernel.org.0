Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD06F423208
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 22:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbhJEUcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 16:32:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230019AbhJEUcJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 16:32:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E7FA60F44;
        Tue,  5 Oct 2021 20:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633465818;
        bh=gbIXNRW5Wq4ehAfiyk/kQqqaMrxPz+mtMrf130bf9ws=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VjJ5c5XiBc3GJlXt/eQ9FQXEUIJnTCkKvmvqABBmmAOmc9KdXI7hdqZho1rptJ9uu
         EzAmvw7Ns2KK0qgz6zKdf53DMIyZtO5jTXcYEdqouK4XCOapcVKg+Fjoo9LsoHYJUZ
         1zSY/AQSjzI8aGmz7G9KFunqazrwt+D0SwJ037GqEU7jRljEEccAZxw8OjgvNWbGJ2
         6op7FZcz0tXKLlpio7y1CJ42vRuPPMivlbDdwZy7D3DbI8hdueQtBHgQ6vLlcaiwKs
         zp+rIKuUalKmA0fEfAMEHazs3YHUfZ5LaHrzQQU0TAk/Z4MquijSjEhL2yCGN9Lg2N
         4mQ5c+3jBpRbg==
Date:   Tue, 5 Oct 2021 22:30:14 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Rob Herring <robh+dt@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: lets settle the LED `function` property regarding the netdev
 trigger
Message-ID: <20211005223014.3891f041@thinkpad>
In-Reply-To: <YVs5sxd/dEBwBShm@lunn.ch>
References: <20211001143601.5f57eb1a@thinkpad>
        <YVn815h7JBtVSfwZ@lunn.ch>
        <20211003212654.30fa43f5@thinkpad>
        <YVsUodiPoiIESrEE@lunn.ch>
        <20211004170847.3f92ef48@thinkpad>
        <YVs5sxd/dEBwBShm@lunn.ch>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 Oct 2021 19:28:19 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > > There are two different ways this can be implemented. There can be two
> > > independent LEDs within the same package. So you can generate three
> > > colours. Or there can be two cross connected LEDs within the
> > > package. Apply +ve you get one colour, apply -ve you get a different
> > > colour. Since you cannot apply both -ve and +ve at the same time, you
> > > cannot get both colours at once.
> > > 
> > > If you have two independent LEDs, I would define two LEDs in DT.  
> > 
> > No, we have multicolor LED API which is meant for exactly this
> > situation: a multicolor LED.
> > (I am talking about something like the KJ2518D-262 from
> >  http://www.rego.com.tw/product_detail.php?prdt_id=258
> >  which has Green/Orange on left and Yellow on right side.
> >  The left Green/Orange LED has 3 pins, and so it can mix the colors into
> >  yellow.)  
> 
> But here you are talking about the LED, not the controller in the
> PHY. The controller might control it as two independent LEDs. It has
> no idea it can get a third colour by enabling two LEDs at the same
> time. Or maybe the controller does know it can combine colours.
> 
> So you need to know about both the controller and the LED. And the
> same controller can be used either way. Plus you need to think about
> the non DT case, when you have no idea about the LED connected to the
> controller.
> 
> > I think the best solution here would be a subclass "enumcolor" (or
> > different name), where you can choose between several pre-defined colors.
> > In sysfs you could then do
> >   echo 1 >brightness
> >   echo green >color
> >   echo yellow >color  
> 
> I'm not sure it is as simple as that. In the general case, you have no
> idea what the colours actually are. You only know the colours if you
> have DT and DT lists the colours. And you only know if LEDs are
> combined if you have DT. You need a basic sysfs API based on knowing
> the PHY can control X LEDs. You can then extend that API if you have
> additional information via DT, like colour and if LEDs are combined,
> that only LEDs numbered 2 and 3 are used, etc.
> 
> 	   Andrew

I really don't think we should be registering any LEDs in the PHY driver
if the driver does not know whether there are LEDs connected to the PHY.

If this information is not available (via device-tree or some other
method, for example USB vendor/device table), then we can't register a
LED and let user control it.

What if the pin is used for something different on a board?

Marek
