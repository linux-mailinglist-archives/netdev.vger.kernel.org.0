Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1D1423336
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 00:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236834AbhJEWIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 18:08:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50894 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236816AbhJEWIx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 18:08:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Lluhp1JzYl1MdgCun+Ng6rRe2JKMoYgDlOFY52JZHkI=; b=A9JRMZYv+g00Zd38Un+SBqSPMW
        WRoUi7KZcYTflWhKIy9rp3/T+85FFyO2Q8hmcAU6pe8YXa7hP3Ot3lM4+Zcy515RTSJQZ2yaoY7Y8
        tY2k/5Owv1IJbAtwbmdZzCV29K0VRoM6elseDsj54xkO1rRNJPiKHhw4Hvx0G6rAM8Z8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mXsaQ-009kjn-UP; Wed, 06 Oct 2021 00:06:58 +0200
Date:   Wed, 6 Oct 2021 00:06:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: lets settle the LED `function` property regarding the netdev
 trigger
Message-ID: <YVzMghbt1+ZSILpQ@lunn.ch>
References: <20211001143601.5f57eb1a@thinkpad>
 <YVn815h7JBtVSfwZ@lunn.ch>
 <20211003212654.30fa43f5@thinkpad>
 <YVsUodiPoiIESrEE@lunn.ch>
 <20211004170847.3f92ef48@thinkpad>
 <0b1bc2d7-6e62-5adb-5aed-48b99770d80d@gmail.com>
 <20211005222657.7d1b2a19@thinkpad>
 <YVy9Ho47XeVON+lB@lunn.ch>
 <20211005234342.7334061b@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005234342.7334061b@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I suggest we start with simple independent LEDs. That gives enough to
> > support the majority of use cases people actually need. And is enough
> > to unblock people who i keep NACKing patches and tell them to wait for
> > this work to get merged.
> 
> Of course, and I plan to do so. Those netdev trigger extensions and
> multi-color function definitions are for later :)

Great.
 
> We got side tracked in this discussion, sorry about that.
> 
> In this thread I just wanted to settle the LED function property for
> LEDs indicating network ports.
> 
> So would you, Andrew, agree with:
> - extending function property to be array of strings instead of only
>   one string, so that we can do
>     function = "link", "activity";

I agree with having a list, and we use the combination. If the
combination is not possible by the hardware, then -EINVAL, or
-EOPNOTSUPP.

> - having separate functions for different link modes
>     function = "link1000", "link100";

I would suggest this, so you can use 

function = "link1000", "link100", "activity"

What could be interesting is how you do this in sysfs?  How do you
enumerate what the hardware can do? How do you select what you want?

Do you need to do

echo "link1000 link100 activity" > /sys/class/net/eth0/phy/led/function

And we can have something like

cat /sys/class/net/eth0/phy/led/function
activity
link10 activity
link100 activity
link1000 activity
[link100 link1000 activity]
link10
link100
link1000

each line being a combination the hardware supports, and the line in
[] is the currently select function.

   Andrew




