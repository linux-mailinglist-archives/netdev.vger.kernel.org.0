Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D683CD594
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 15:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237143AbhGSMfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 08:35:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33770 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236855AbhGSMfD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 08:35:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=ZxFr9/ao0Li9H3Be14QUDxm2dKJ1ZcwVygP6Pez+tR0=; b=Ij
        Zcz8rRYoUFAsBoFWEB7EyZ+jvzOMASbGxcoriKpNTx3IBw7TFbAfSCOh+JRpd72lFz/R2y7hgAtCv
        7PBkCJU8ZzhH/MV7OgeD0ICd//cLFiD3GLmxAl8EZpD9JJ/ov2GPD+R19KpdSdweR+2iW/TywLj8P
        TrLOg9Kj5t88YMw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m5T7Q-00Dtwm-Pp; Mon, 19 Jul 2021 15:15:36 +0200
Date:   Mon, 19 Jul 2021 15:15:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <YPV6+PQq1fvH8aSy@lunn.ch>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
 <20210716212427.821834-6-anthony.l.nguyen@intel.com>
 <YPIAnq6r3KgQ5ivI@lunn.ch>
 <87y2a2hm6m.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87y2a2hm6m.fsf@kurt>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 08:06:41AM +0200, Kurt Kanzenbach wrote:
> Hi Andrew,
> 
> On Fri Jul 16 2021, Andrew Lunn wrote:
> > On Fri, Jul 16, 2021 at 02:24:27PM -0700, Tony Nguyen wrote:
> >> From: Kurt Kanzenbach <kurt@linutronix.de>
> >> 
> >> Each i225 has three LEDs. Export them via the LED class framework.
> >> 
> >> Each LED is controllable via sysfs. Example:
> >> 
> >> $ cd /sys/class/leds/igc_led0
> >> $ cat brightness      # Current Mode
> >> $ cat max_brightness  # 15
> >> $ echo 0 > brightness # Mode 0
> >> $ echo 1 > brightness # Mode 1
> >> 
> >> The brightness field here reflects the different LED modes ranging
> >> from 0 to 15.
> >
> > What do you mean by mode? Do you mean blink mode? Like On means 1G
> > link, and it blinks for packet TX?
> 
> There are different modes such as ON, OFF, LINK established, LINK
> activity, PAUSED ... Blinking is controlled by a different register.
> 
> Are there better ways to export this?

As i said in another email, using LED triggers. For simple link speed
indication, take a look at CONFIG_LED_TRIGGER_PHY. This is purely
software, and probably not what you want. The more complex offload of
to LED control to hardware in the PHY subsystem it still going around
and around. The basic idea is agreed, just not the implementation.
However, most of the implementation is of no help to you, since Intel
drivers ignore the kernel PHY drivers and do their own. But the basic
idea and style of user space API should be kept the same. So take a
look at the work Marek Behún has been doing, e.g.

https://lwn.net/Articles/830947/

and a more recent version

https://lore.kernel.org/netdev/20210602144439.4d20b295@dellmb/T/#m4e97c9016597fb40849c104c7c0e3bc10d5c1ff5

Looking at the basic idea of using LED triggers and offloading
them. Please also try to make us of generic names for these triggers,
so the PHY subsystem might also use the same or similar names when it
eventually gets something merged.

Please also Cc: The LED maintainers and LED list. Doing that from the
start would of avoided this revert, since you would of get earlier
feedback about this.

	 Andrew
