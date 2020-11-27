Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A4B2C6BA1
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 19:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbgK0SfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 13:35:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:50386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726342AbgK0SfF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 13:35:05 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7657A21534;
        Fri, 27 Nov 2020 18:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606502104;
        bh=poBC+GZdK3P6gKXnqt4pu1sVxHfq3GqeOyMiMVZh9r4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nakV/8/87D0+e3FpK1MQWzNDRv4gkYo2W6fGoGWh3gUYeH865noEWUGkHzAk/wvwR
         eCdwxxGBBmMAHH8584rjSBwGNW7zbAZaOH5wxAf2q5CFR5TYc63csAm/eDnHDbZ/MH
         iRHVghjkI0EsYFYBInw+701NMo5QYbmWn2JL2Gys=
Date:   Fri, 27 Nov 2020 10:35:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     George McCollister <george.mccollister@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201127103503.5cda7f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201126220500.av3clcxbbvogvde5@skbuf>
References: <20201125193740.36825-1-george.mccollister@gmail.com>
        <20201125193740.36825-3-george.mccollister@gmail.com>
        <20201125174214.0c9dd5a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAFSKS=OY_-Agd6JPoFgm3MS5HE6soexHnDHfq8g9WVrCc82_sA@mail.gmail.com>
        <20201126132418.zigx6c2iuc4kmlvy@skbuf>
        <20201126175607.bqmpwbdqbsahtjn2@skbuf>
        <CAFSKS=Ok1FZhKqourHh-ikaia6eNWtXh6VBOhOypsEJAhwu06g@mail.gmail.com>
        <20201126220500.av3clcxbbvogvde5@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020 00:05:00 +0200 Vladimir Oltean wrote:
> On Thu, Nov 26, 2020 at 01:07:12PM -0600, George McCollister wrote:
> > On Thu, Nov 26, 2020 at 11:56 AM Vladimir Oltean <olteanv@gmail.com> wrote:  
> > > On Thu, Nov 26, 2020 at 03:24:18PM +0200, Vladimir Oltean wrote:  
> > > > On Wed, Nov 25, 2020 at 08:25:11PM -0600, George McCollister wrote:  
> > > > > > > +     {XRS_RX_UNDERSIZE_L, "rx_undersize"},
> > > > > > > +     {XRS_RX_FRAGMENTS_L, "rx_fragments"},
> > > > > > > +     {XRS_RX_OVERSIZE_L, "rx_oversize"},
> > > > > > > +     {XRS_RX_JABBER_L, "rx_jabber"},
> > > > > > > +     {XRS_RX_ERR_L, "rx_err"},
> > > > > > > +     {XRS_RX_CRC_L, "rx_crc"},  
> > > > > >
> > > > > > As Vladimir already mentioned to you the statistics which have
> > > > > > corresponding entries in struct rtnl_link_stats64 should be reported
> > > > > > the standard way. The infra for DSA may not be in place yet, so best
> > > > > > if you just drop those for now.  
> > > > >
> > > > > Okay, that clears it up a bit. Just drop these 6? I'll read through
> > > > > that thread again and try to make sense of it.  
> > > >
> > > > I feel that I should ask. Do you want me to look into exposing RMON
> > > > interface counters through rtnetlink (I've never done anything like that
> > > > before either, but there's a beginning for everything), or are you going
> > > > to?  
> > >
> > > So I started to add .ndo_get_stats64 based on the hardware counters, but
> > > I already hit the first roadblock, as described by the wise words of
> > > Documentation/networking/statistics.rst:
> > >
> > > | The `.ndo_get_stats64` callback can not sleep because of accesses
> > > | via `/proc/net/dev`. If driver may sleep when retrieving the statistics
> > > | from the device it should do so periodically asynchronously and only return
> > > | a recent copy from `.ndo_get_stats64`. Ethtool interrupt coalescing interface
> > > | allows setting the frequency of refreshing statistics, if needed.

I should have probably also mentioned here that unlike most NDOs
.ndo_get_stats64 is called without rtnl lock held at all.

> > > Unfortunately, I feel this is almost unacceptable for a DSA driver that
> > > more often than not needs to retrieve these counters from a slow and
> > > bottlenecked bus (SPI, I2C, MDIO etc). Periodic readouts are not an
> > > option, because the only periodic interval that would not put absurdly
> > > high pressure on the limited SPI bandwidth would be a readout interval
> > > that gives you very old counters.  

What's a high interval? It's not uncommon to refresh the stats once a
second even in high performance NICs.

> > Indeed it seems ndo_get_stats64() usually gets data over something
> > like a local or PCIe bus or from software. I had a brief look to see
> > if I could find another driver that was getting the stats over a slow
> > bus and didn't notice anything. If you haven't already you might do a
> > quick grep and see if anything pops out to you.
> >  
> > >
> > > What exactly is it that incurs the atomic context? I cannot seem to
> > > figure out from this stack trace:  
> >
> > I think something in fs/seq_file.c is taking an rcu lock.  
> 
> Not quite. It _is_ the RCU read-side lock that's taken, but it's taken
> locally from dev_seq_start in net/core/net-procfs.c. The reason is that
> /proc/net/dev iterates through all interfaces from the current netns,
> and it is precisely that that creates atomic context. You used to need
> to hold the rwlock_t dev_base_lock, but now you can also "get away" with
> the RCU read-side lock. Either way, both are atomic context, so it
> doesn't help.
> 
> commit c6d14c84566d6b70ad9dc1618db0dec87cca9300
> Author: Eric Dumazet <eric.dumazet@gmail.com>
> Date:   Wed Nov 4 05:43:23 2009 -0800
> 
>     net: Introduce for_each_netdev_rcu() iterator
> 
>     Adds RCU management to the list of netdevices.
> 
>     Convert some for_each_netdev() users to RCU version, if
>     it can avoid read_lock-ing dev_base_lock
> 
>     Ie:
>             read_lock(&dev_base_loack);
>             for_each_netdev(net, dev)
>                     some_action();
>             read_unlock(&dev_base_lock);
> 
>     becomes :
> 
>             rcu_read_lock();
>             for_each_netdev_rcu(net, dev)
>                     some_action();
>             rcu_read_unlock();
> 
> 
>     Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> So... yeah. As long as this kernel interface exists, it needs to run in
> atomic context, by construction. Great.
>
> > I suppose it doesn't really matter though since the documentation says
> > we can't sleep.  
> 
> You're talking, I suppose, about these words of wisdom in
> Documentation/filesystems/seq_file.rst?
> 
> | However, the seq_file code (by design) will not sleep between the calls
> | to start() and stop(), so holding a lock during that time is a
> | reasonable thing to do. The seq_file code will also avoid taking any
> | other locks while the iterator is active.
> 
> It _doesn't_ say that you can't sleep between start() and stop(), right?
> It just says that if you want to keep the seq_file iterator atomic, the
> seq_file code is not sabotaging you by sleeping. But you still could
> sleep if you wanted to.
> 
> Back to the statistics counters.
> 
> How accurate do the counters in /proc/net/dev need to be? What programs
> consume those? Could they be more out of date than the ones retrieved
> through rtnetlink?

ifconfig does for sure.

> I'm thinking that maybe we could introduce another ndo, something like
> .ndo_get_stats64_blocking, that could be called from all places except
> from net/core/net-procfs.c. That one could still call the non-blocking
> variant. Then, depending on the answer to the question "how inaccurate
> could we reasonably leave /proc/net/dev", we could:
> - just return zeroes there
> - return the counters cached from the last blocking call

I'd rather not introduce divergent behavior like that.

Is the periodic refresh really that awful? We're mostly talking error
counters here so every second or every few seconds should be perfectly
fine.

> > It does seem to me that this is something that needs to be sorted out
> > at the subsystem level and that this driver has been "caught in the
> > crossfire". Any guidance on how we could proceed with this driver and
> > revisit this when we have answers to these questions at the subsystem
> > level would be appreciated if substantial time will be required to
> > work this out.  
> 
> Now seriously, who isn't caught in the crossfire here? Let's do some
> brainstorming and it will be quick and painless.

