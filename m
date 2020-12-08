Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81F42D36C5
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 00:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731653AbgLHXNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 18:13:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:52332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731300AbgLHXNs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 18:13:48 -0500
Date:   Tue, 8 Dec 2020 15:13:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607469188;
        bh=SSjYgzjvqBuVRProPbpN4uTwWvMV5QlAAtGfYXjS/Bk=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=F6OQehZ7W5mVgi+gS/AY9iiprqitncpv4u/iXBEOCI0JTRKICJUBeRX0J5a6mHeja
         QOhDagvnEM8SbttqMiwK7761dSMQLoY4fHCipQRbcwV9Z3S77N4vQlYas686BOQcII
         4eyoI3pBaWghZsooudrK4x66WSxi1imKq2303yWh1lYjG7AOVAkeG8Ahza1ppTJj+F
         Wx8ScWrfZDLs3kHRkGQXTCXGFW2Hhii3MPP1NQoHgBkY9+WiXgaZ5FOQKwnQvVh+9R
         Z2LJccRQaGwf+zxoFY6bY0WUJrfKHu4L2aCtQBEzPL68r96VpeGyLz/buV+Msg0AXg
         FxOf3H9zJ39Zw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v1 2/2] lan743x: boost performance: limit PCIe
 bandwidth requirement
Message-ID: <20201208151306.23461636@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <CAGngYiVSHRGC+eOCeF3Kyj_wOVqxJHvoc9fXRk-w+sVRjeSpcw@mail.gmail.com>
References: <20201206034408.31492-1-TheSven73@gmail.com>
        <20201206034408.31492-2-TheSven73@gmail.com>
        <20201208114314.743ee6ec@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <CAGngYiVSHRGC+eOCeF3Kyj_wOVqxJHvoc9fXRk-w+sVRjeSpcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Dec 2020 16:54:33 -0500 Sven Van Asbroeck wrote:
> > > Tested with iperf3 on a freescale imx6 + lan7430, both sides
> > > set to mtu 1500 bytes.
> > >
> > > Before:
> > > [ ID] Interval           Transfer     Bandwidth       Retr
> > > [  4]   0.00-20.00  sec   483 MBytes   203 Mbits/sec    0
> > > After:
> > > [ ID] Interval           Transfer     Bandwidth       Retr
> > > [  4]   0.00-20.00  sec  1.15 GBytes   496 Mbits/sec    0
> > >
> > > And with both sides set to MTU 9000 bytes:
> > > Before:
> > > [ ID] Interval           Transfer     Bandwidth       Retr
> > > [  4]   0.00-20.00  sec  1.87 GBytes   803 Mbits/sec   27
> > > After:
> > > [ ID] Interval           Transfer     Bandwidth       Retr
> > > [  4]   0.00-20.00  sec  1.98 GBytes   849 Mbits/sec    0
> > >
> > > Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # lan7430
> > > Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>  
> >
> > This is a performance improvement, not a fix, it really needs to target
> > net-next.  
> 
> I thought it'd be cool if 'historic' kernels could benefit from this performance
> improvement too, but yeah if it's against policy it should go into net-next.
> 
> What about the other patch in the patchset (ping-pong). Should it go into
> net-next as well?

The jury is out on that one. Using ring size for netif_napi_add() 
and updating RX_TAIL at the end of NAPI is pretty broken. So that
one can qualify as a fix IMHO.

> > > @@ -2632,9 +2633,13 @@ static int lan743x_netdev_change_mtu(struct net_device *netdev, int new_mtu)
> > >       struct lan743x_adapter *adapter = netdev_priv(netdev);
> > >       int ret = 0;
> > >
> > > +     if (netif_running(netdev))
> > > +             return -EBUSY;  
> >
> > That may cause a regression to users of the driver who expect to be
> > able to set the MTU when the device is running. You need to disable
> > the NAPI, pause the device, swap the buffers for smaller / bigger ones
> > and restart the device.  
> 
> That's what I tried first, but I quickly ran into a spot of trouble:
> restarting the device may fail (unlikely but possible). So when the user tries
> to change the mtu and that errors out, they might end up with a stopped device.
> Is that acceptable behaviour? If so, I'll add it to the patch.

Fail because of memory allocation failures?

The best way to work around that is to allocate all the memory for new
configuration before you free the old memory. This also makes the
change a lot less disturbing to the traffic because you can do all the
allocations before the device is disabled, do the swap, start the
device, and then free the old set.
