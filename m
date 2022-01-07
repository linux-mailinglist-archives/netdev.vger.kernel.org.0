Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12488487841
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 14:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347591AbiAGNcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 08:32:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55902 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347584AbiAGNcf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 08:32:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zuq22puCatF8YKbcxfFia/s++TKJb1IZ+z9NiVaSWzU=; b=09kVmdnHvMVYu+dp3guCi9uFwG
        CE7JP5QQV0zMS+Rpl8UoziuSO1V30lbg7jZJcOpcq+Fr/X88aS3XOw5R0VukhOIA+uvJzfMNr9KMT
        0Iei3NqTn0e7m/ZW/YQU4g60Pax4qE1HdtbzMWljerkiadqgZ1RKOZCmpWzR3D/zWeiI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n5pM1-000lCb-8O; Fri, 07 Jan 2022 14:32:25 +0100
Date:   Fri, 7 Jan 2022 14:32:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Oliver Neukum <oneukum@suse.com>,
        Aaron Ma <aaron.ma@canonical.com>, kuba@kernel.org,
        henning.schild@siemens.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
 address
Message-ID: <YdhA6QqOKQ19uKWG@lunn.ch>
References: <20220105151427.8373-1-aaron.ma@canonical.com>
 <YdXVoNFB/Asq6bc/@lunn.ch>
 <bb6d8bc4-abee-8536-ca5b-bac11d1ecd53@suse.com>
 <YdYbZne6pBZzxSxA@lunn.ch>
 <CAAd53p52uGFjbiuOWAA-1dN7mTqQ0KFe9PxWvPL+fjfQb9K5vQ@mail.gmail.com>
 <YdbuXbtc64+Knbhm@lunn.ch>
 <CAAd53p5YnQZ0fDiwwo-q3bNMVFTJSMLcdkUuH-7=OSaRrW954Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAd53p5YnQZ0fDiwwo-q3bNMVFTJSMLcdkUuH-7=OSaRrW954Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > You should be thinking of this in more general terms. You want to
> > design a system that will work for any vendors laptop and dock.
> >
> > You need to describe the two interfaces using some sort of bus
> > address, be it PCIe, USB, or a platform device address as used by
> > device tree etc.
> >
> > Let the kernel do whatever it wants with MAC addresses for these two
> > interfaces. The only requirement you have is that the laptop internal
> > interface gets the vendor allocated MAC address, and that the dock get
> > some sort of MAC address, even if it is random.
> 
> Those laptops and docks are designed to have duplicated MACs. I don't
> understand why but that's why Dell/HP/Lenovo did.

But it also sounds like the design is broken. So the question is, is
it possible to actually implement it correctly, without breaking
networking for others with sane laptop/docks/USB dongles.

> What if the kernel just abstract the hardware/firmware as intended, no
> matter how stupid it is, and let userspace to make the right policy?

Which is exactly what is being suggested here. The kernel gives the
laptop internal interface its MAC address from ACPI or where ever, and
the dock which has no MAC address gets a random MAC address. That is
the normal kernel abstract. Userspace, in the form of udev, can then
change the MAC addresses in whatever way it wants.

> But power users may also need to use corporate network to work as
> Aaron mentioned.
> Packets from unregistered MAC can be filtered under corporate network,
> and that's why MAC pass-through is a useful feature that many business
> laptops have.

Depends on the cooperate network, but power users generally know more
than the IT department, and will just make their machine work, copying
the 802.3x certificate where ever it needs to go, us ebtables to
mangle the MAC address, build their own little network with an RPi
acting as a gateway doing NAT and MAC address translation, etc.

       Andrew
