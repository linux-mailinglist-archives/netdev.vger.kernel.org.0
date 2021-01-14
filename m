Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49FA82F662B
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 17:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbhANQpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 11:45:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:50944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbhANQpT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 11:45:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64F7723B18;
        Thu, 14 Jan 2021 16:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610642676;
        bh=PS1dhuKrAt2v8OEyvqgU7BzXS3gCX7ZqPqnjXyY11sw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fXk6ePTt+W9O2cwzEB6JQdD6LcpKPeOYvc88TdarZTS2pBc6Fd5yP3C1f+Zv9SCDX
         WPAFM5GpN/JKnA3+xOs/B4nMHQtc33nLdyK7I+0UZVCDpKWpzoTIVtv7SlSlvs5yXS
         2u84v/R3VyZUi3TjqoVOuGHYD4rK3wehXN8o/YZoF+QTyNKRIycHvLpveCfeUAwxPh
         wLcUPcNyjCw8ClFczV65B8ugyoIiMTcbQGCkZRfumXaLF35QZsKGUkmDlUpnfubuKZ
         TznSiry8+OgETDi4wv3vQfcQBNCXtdW63Y37Uj+ZLY5bbfRzlbSZODGEOkipDIsZhp
         Oz5AvAP0p0/qQ==
Date:   Thu, 14 Jan 2021 08:44:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v3 net-next 08/10] net: mscc: ocelot: register devlink
 ports
Message-ID: <20210114084435.094c260a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210114103405.yizjfsk4idzgnpot@skbuf>
References: <20210108175950.484854-1-olteanv@gmail.com>
        <20210108175950.484854-9-olteanv@gmail.com>
        <20210109174439.404713f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210111171344.j6chsp5djr5t5ykk@skbuf>
        <20210111111909.4cf0174f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210114103405.yizjfsk4idzgnpot@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 12:34:05 +0200 Vladimir Oltean wrote:
> On Mon, Jan 11, 2021 at 11:19:09AM -0800, Jakub Kicinski wrote:
> > > > devlink_port_attrs_set() should be called before netdev is registered,
> > > > and devlink_port_type_eth_set() after. So this sequence makes me a tad
> > > > suspicious.
> > > >
> > > > In particular IIRC devlink's .ndo_get_phys_port_name depends on it,
> > > > because udev event needs to carry the right info for interface renaming
> > > > to work reliably. No?  
> > >
> > > If I change the driver's Kconfig from tristate to bool, all is fine,
> > > isn't it?  
> >
> > How does Kconfig change the order of registration of objects to
> > subsystems _within_ the driver?  
> 
> The registration order within the driver is not what matters. What
> matters is that the devlink_port and net_device are both registered
> _before_ udev is up.

I see.

> > Can you unbind and bind the driver back and see if phys_port_name
> > always gets the correct value? (replay/udevadm test is not sufficient)  
> 
> Yes, and that udev renaming test failed miserably still.
> 
> I have dhcpcd in my system, and it races with my udev script by
> auto-upping the interfaces when they probe. Then, dev_change_name()
> returns -EBUSY because the interfaces are up but its priv_flags do not
> declare IFF_LIVE_RENAME_OK.
> 
> How is that one solved?

Yeah, that's one of those perennial problems we never found a strong
answer to. IIRC IFF_LIVE_RENAME_OK was more of a dirty hack than a
serious answer. I think we should allow renaming interfaces while
they're up, and see if anything breaks. We'd just need to add the right
netlink notifications to dev_change_name(), maybe?
