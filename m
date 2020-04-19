Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360641AFE36
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 22:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbgDSUr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 16:47:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48972 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbgDSUr3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 16:47:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jD2QzIrQ6+TG/Ei7J9MBbue1FrR0ppdPvqfjsICNjXo=; b=MAIgBrwnc0MSQlQ9NNFrVP9gys
        P7mp5xTswA1OlN3O8Ugp6KlkCyRXpU/6/Vegfl4MkqW0+IfGsXOC1Uu7jVBBdnOzJOIENNotfQ4V2
        9vvgb86tBW4lNCk1D66pYeB8I2A3T77gCjl43VO1yWjjpXjJSxkduFi0/kzNFp8YpIyg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQGqY-003h4g-AH; Sun, 19 Apr 2020 22:47:22 +0200
Date:   Sun, 19 Apr 2020 22:47:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Healy <cphealy@gmail.com>
Cc:     Andy Duan <fugang.duan@nxp.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [EXT] [PATCH net-next v2 1/3] net: ethernet: fec: Replace
 interrupt driven MDIO with polled IO
Message-ID: <20200419204722.GQ836632@lunn.ch>
References: <20200418000355.804617-1-andrew@lunn.ch>
 <20200418000355.804617-2-andrew@lunn.ch>
 <HE1PR0402MB27450B207DFFB1B86DCF287DFFD60@HE1PR0402MB2745.eurprd04.prod.outlook.com>
 <CAFXsbZpVSiMYpUaOR=+UEGBgx5kSTzGcftbPe=PPkj_xWhy=bA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFXsbZpVSiMYpUaOR=+UEGBgx5kSTzGcftbPe=PPkj_xWhy=bA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 18, 2020 at 03:39:17PM -0700, Chris Healy wrote:
> I did some profiling using an oscilloscope with my NXP Vybrid based
> platform to see what different "sleep_us" values resulted in for start
> of MDIO to start of MDIO transaction times.  Here's what I found:
> 
> 0  - ~38us to ~40us
> 1  - ~48us to ~64us
> 2  - ~48us to ~64us
> 3  - ~48us to ~64us
> 4  - ~48us to ~64us
> 4  - ~48us to ~64us
> 5  - ~48us to ~64us
> 6  - ~48us to ~64us
> 7  - ~48us to ~64us
> 8  - ~48us to ~64us
> 9  - ~56us to ~88us
> 10 - ~56us to ~112us
> 
> Basically, with the "sleep_us" value set to 0, I would get the
> shortest inter transaction times with a very low variance.  Once I
> went to a non-zero value, the inter transaction time went up, as well
> as the variance, which I suppose makes sense....

Hi All

I dug into this, adding some instrumentation. I've been testing on a
Vybrid platform. During boot it does over 6500 transactions in order
to configure 3 switches and one PHY.

With a delay of 0, it polls an average of 62 times, and it needs 29us
to exit the loop. This means one poll takes 0.5uS.

With a delay of 1uS, it polls on average 2 times, and takes on average
45uS to exit the loop. Which suggests the delay takes around 22uS,
despite the request for only 1uS. Looking at the code, it is actually
performing a usleep_range(1, 1). So i'm assuming sleeping is very
expensive, maybe it is using a timer? So we end up with just as much
interrupt work as waiting for the MDIO interrupt?

By swapping to readl_poll_timeout_atomic() i got much better
behaviour. This uses udelay(). Using a delay of 2uS, it loops polling
the completion bit an average of 10 times. It takes 29uS to exist the
loop. This suggests that udelay(2) is pretty accurate.

This seems like a reasonable compromise. The bus load has been reduced
from 62 to 10 poll loops, without increasing the time it takes to exit
the loop by much. And 10 polls allows for significantly faster
completions when using a faster bus clock and preamble suppression.

So i plan to resubmit using readl_poll_timeout_atomic().

   Andrew
