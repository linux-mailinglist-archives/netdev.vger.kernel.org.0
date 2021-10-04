Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D12E42152D
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 19:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234715AbhJDRaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 13:30:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47952 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234612AbhJDRaN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 13:30:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fBQQnjUYlNCeKO7JTfO5K7VB/ceVUGDzh7Do/3hwY1U=; b=UXjBkkLhygo6vRs86pDAFxoBnT
        MWBRl5HHutT+Y0Xf0M+fXE6txx5VEoHBeLlB2kkxsh7bjLzuhwsrmmamOcNlJPftzsp4nteffr0hl
        KcaoSa3Go05EBsopcZCPlgvWdNYtwkUz20SYpT8A/edEmYGb3BsK6eEV+E3B0TxzIEzE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mXRlD-009ZrX-PL; Mon, 04 Oct 2021 19:28:19 +0200
Date:   Mon, 4 Oct 2021 19:28:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: lets settle the LED `function` property regarding the netdev
 trigger
Message-ID: <YVs5sxd/dEBwBShm@lunn.ch>
References: <20211001143601.5f57eb1a@thinkpad>
 <YVn815h7JBtVSfwZ@lunn.ch>
 <20211003212654.30fa43f5@thinkpad>
 <YVsUodiPoiIESrEE@lunn.ch>
 <20211004170847.3f92ef48@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004170847.3f92ef48@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > There are two different ways this can be implemented. There can be two
> > independent LEDs within the same package. So you can generate three
> > colours. Or there can be two cross connected LEDs within the
> > package. Apply +ve you get one colour, apply -ve you get a different
> > colour. Since you cannot apply both -ve and +ve at the same time, you
> > cannot get both colours at once.
> > 
> > If you have two independent LEDs, I would define two LEDs in DT.
> 
> No, we have multicolor LED API which is meant for exactly this
> situation: a multicolor LED.
> (I am talking about something like the KJ2518D-262 from
>  http://www.rego.com.tw/product_detail.php?prdt_id=258
>  which has Green/Orange on left and Yellow on right side.
>  The left Green/Orange LED has 3 pins, and so it can mix the colors into
>  yellow.)

But here you are talking about the LED, not the controller in the
PHY. The controller might control it as two independent LEDs. It has
no idea it can get a third colour by enabling two LEDs at the same
time. Or maybe the controller does know it can combine colours.

So you need to know about both the controller and the LED. And the
same controller can be used either way. Plus you need to think about
the non DT case, when you have no idea about the LED connected to the
controller.

> I think the best solution here would be a subclass "enumcolor" (or
> different name), where you can choose between several pre-defined colors.
> In sysfs you could then do
>   echo 1 >brightness
>   echo green >color
>   echo yellow >color

I'm not sure it is as simple as that. In the general case, you have no
idea what the colours actually are. You only know the colours if you
have DT and DT lists the colours. And you only know if LEDs are
combined if you have DT. You need a basic sysfs API based on knowing
the PHY can control X LEDs. You can then extend that API if you have
additional information via DT, like colour and if LEDs are combined,
that only LEDs numbered 2 and 3 are used, etc.

	   Andrew
