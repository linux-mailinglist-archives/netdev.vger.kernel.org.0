Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C332CF46C
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 19:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730418AbgLDSz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 13:55:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:51578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729003AbgLDSz7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 13:55:59 -0500
Date:   Fri, 4 Dec 2020 10:55:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607108118;
        bh=L32lsK0k5Rjaw7UQUuxNOFw9QqcV/o8CuuXQxXqvvQU=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=qe6A5eRueEIEiAupQRu6F5JV4TqBF/+1gvQZOYwTD7iDe5qqVaxHfLfbDwfK7+NFB
         8vKdKn8miUKCSFjZyiLmbJBsKK3s0aLDu4WixrVGQ0zsekGAo1wWiqSTSd5ybGPvrF
         SFZMf7VOrxgrhHTyYts/kR/5Inva2qldJgTwjEl8cVVToD+a/nDeeFkBnXfT+xFDcF
         qYHaTTpa+6VzZL5YuHU4DNKxj+zfXamv9ou/mHiNf/eBMy9cmDjGZA6W7WogKiR+uN
         1A5If6+FuKsSBWhUsnlYvCMAeF5h+jmM/cJkE+RoyEHnrFrbr+hNw5uiXBcZt/Rq08
         3B2w0hNw1Anow==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: Re: [PATCH v2 net] net: mscc: ocelot: install MAC addresses in
 .ndo_set_rx_mode from process context
Message-ID: <20201204105516.1237a690@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201204181250.t5d4hc7wis7pzqa2@skbuf>
References: <20201204175125.1444314-1-vladimir.oltean@nxp.com>
        <20201204100021.0b026725@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <20201204181250.t5d4hc7wis7pzqa2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Dec 2020 18:12:51 +0000 Vladimir Oltean wrote:
> On Fri, Dec 04, 2020 at 10:00:21AM -0800, Jakub Kicinski wrote:
> > On Fri,  4 Dec 2020 19:51:25 +0200 Vladimir Oltean wrote:  
> > > Currently ocelot_set_rx_mode calls ocelot_mact_learn directly, which has
> > > a very nice ocelot_mact_wait_for_completion at the end. Introduced in
> > > commit 639c1b2625af ("net: mscc: ocelot: Register poll timeout should be
> > > wall time not attempts"), this function uses readx_poll_timeout which
> > > triggers a lot of lockdep warnings and is also dangerous to use from
> > > atomic context, leading to lockups and panics.
> > >
> > > Steen Hegelund added a poll timeout of 100 ms for checking the MAC
> > > table, a duration which is clearly absurd to poll in atomic context.
> > > So we need to defer the MAC table access to process context, which we do
> > > via a dynamically allocated workqueue which contains all there is to
> > > know about the MAC table operation it has to do.
> > >
> > > Fixes: 639c1b2625af ("net: mscc: ocelot: Register poll timeout should be wall time not attempts")
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> > > ---
> > > Changes in v2:
> > > - Added Fixes tag (it won't backport that far, but anyway)
> > > - Using get_device and put_device to avoid racing with unbind  
> >
> > Does get_device really protect you from unbind? I thought it only
> > protects you from .release being called, IOW freeing struct device
> > memory..  
> 
> Possibly.
> I ran a bind && unbind loop for a while, and I couldn't trigger any
> concurrency.

You'd need to switch to a delayed work or add some other sleep for
testing, maybe?

> > More usual way of handling this would be allocating your own workqueue
> > and flushing that wq at the right point.  
> 
> Yeah, well I more or less deliberately lose track of the workqueue as
> soon as ocelot_enqueue_mact_action is over, and that is by design. There
> is potentially more than one address to offload to the hardware in progress
> at the same time, and any sort of serialization in .ndo_set_rx_mode (so
> I could add the workqueue to a list of items to cancel on unbind)
> would mean
> (a) more complicated code
> (b) more busy waiting

Are you sure you're not confusing workqueue with a work entry?

You can still put multiple work entries on the queue.

> > >  drivers/net/ethernet/mscc/ocelot_net.c | 83 +++++++++++++++++++++++++-
> > >  1 file changed, 80 insertions(+), 3 deletions(-)  
> >
> > This is a little large for a rc7 fix :S  
> 
> Fine, net-next it is then.

If this really is the fix we want, it's the fix we want, and it should
go into net. We'll just need to test it very well is all.

> > What's the expected poll time? maybe it's not that bad to busy wait?
> > Clearly nobody noticed the issue in 2 years (you mention lockdep so
> > not a "real" deadlock) which makes me think the wait can't be that long?  
> 
> Not too much, but the sleep is there.
> Also, all 3 of ocelot/felix/seville are memory-mapped devices. But I
> heard from Alex a while ago that he intends to add support for a switch
> managed over a slow bus like SPI, and to use the same regmap infrastructure.
> That would mean that this problem would need to be resolved anyway.

So it's MMIO but the other end is some firmware running on the device?

> > Also for a reference - there are drivers out there with busy poll
> > timeout of seconds :/  
> 
> Yeah, not sure if that tells me anything. I prefer avoiding that from
> atomic context, because our cyclictest numbers are not that great anyway,
> the last thing I want is to make them worse.

Fair.
