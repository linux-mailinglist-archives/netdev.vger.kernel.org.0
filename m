Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB582037EB
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgFVN0N convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 22 Jun 2020 09:26:13 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:59549 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727963AbgFVN0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 09:26:13 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 6D3141BF208;
        Mon, 22 Jun 2020 13:26:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200620154008.GO304147@lunn.ch>
References: <20200619122300.2510533-1-antoine.tenart@bootlin.com> <20200619122300.2510533-7-antoine.tenart@bootlin.com> <20200620154008.GO304147@lunn.ch>
Subject: Re: [PATCH net-next v3 6/8] net: phy: mscc: timestamping and PHC support
To:     Andrew Lunn <andrew@lunn.ch>
From:   Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        richardcochran@gmail.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com, foss@0leil.net
Message-ID: <159283236709.1456598.3715966711472439674@kwain>
Date:   Mon, 22 Jun 2020 15:26:07 +0200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Quoting Andrew Lunn (2020-06-20 17:40:08)
> On Fri, Jun 19, 2020 at 02:22:58PM +0200, Antoine Tenart wrote:
> > To get and set the PHC time, a GPIO has to be used and changes are only
> > retrieved or committed when on a rising edge. The same GPIO is shared by
> > all PHYs, so the granularity of the lock protecting it has to be
> > different from the ones protecting the 1588 registers (the VSC8584 PHY
> > has 2 1588 blocks, and a single load/save pin).
> 
> I guess you thought about this GPIO quite a bit.
> 
> It appears you have the mutex in the shared structure, but each PHY
> has its own gpio_desc, even though it should be for the same GPIO?

Yes, that's right. I had an early solution were I was sharing the GPIO
in the shared structure, allowing to have a single gpio_desc. (dt would
still needs to have one GPIO per PHY). That turned out to be a lot more
complex that the current solution, having to unregister and free the
GPIO desc manually when the driver of the last PHY was unregistered. I
had to add lots of logic (and not the nicely looking one) to the shared
PHY helpers in the core.

> The binding requires each PHY has the GPIO, even though it is the same
> GPIO. And there does not appear to be any checking that each PHY
> really does have the same GPIO.

Right. I don't see a clean and nice way to do this. Do you have an idea?
On another hand, this would only lead to not being able to set/get (a
correct) time from the PHC.

> Ideally there would be a section in DT for the package, and this GPIO
> would be there. But i don't see an good way to do this.

Yes, I agree. That wasn't the design chosen when PHY packages were
added. This PHY already has a shared description, duplicated for each
PHY of the same package (for the interrupt line). If we were to change
this one day, we probably would have to break dt compatibility anyway as
there's already a property that is shared.

> This does not feel right to me, but i've no good idea how it can be
> made better :-(

I think this kind of rework is out of this series scope; but I would be
happy to discuss a better solution for someday.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
