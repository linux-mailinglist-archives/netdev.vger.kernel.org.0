Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F413E83B3
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 21:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbhHJT2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 15:28:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43454 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231527AbhHJT2b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 15:28:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YlJTSQ2irvzq596hfLSfFGSKIGg+QjdW+IPB+tJUDYo=; b=d5OBUptsnTqbO9mUY/YuHtjWaS
        xDn3H993fn5guCGdMw4dDj6QaSf2P36BNs7wO8/XFUmwfJ/xkPuyvDV2fkZmCVnC9aPMGWZ/J+9Db
        w5AUiAC8eBgmQrKZAWxHiKyPlqTVC6SeHvBVrTD5HPRKPT6yxKQfsFErBrPsrbGR2csQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mDXQ0-00Gxt4-4Y; Tue, 10 Aug 2021 21:28:08 +0200
Date:   Tue, 10 Aug 2021 21:28:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, mkubecek@suse.cz, pali@kernel.org,
        vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 2/8] ethtool: Add ability to reset
 transceiver modules
Message-ID: <YRLTSC90Lu/3IyJa@lunn.ch>
References: <20210809102152.719961-1-idosch@idosch.org>
 <20210809102152.719961-3-idosch@idosch.org>
 <YRF+a6C/wHa7+2Gs@lunn.ch>
 <YRJ5g/W11V0mjKHs@shredder>
 <20210810065423.076e3b0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRLCUc8NZnRZFUFs@shredder>
 <20210810120030.5092ec22@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810120030.5092ec22@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hm, flashing is harder than reset. We can't unbind the driver while
> it's in progress. I don't have any ready solution in mind, but I'd 
> like to make sure the locking is clear and hard to get wrong. Maybe 
> we could have a mix of ops, one called for "preparing" the flashing
> called under rtnl and another for "commit" with "unlocked" in the name.
> Drivers which don't want to deal with dropping rtnl lock can just do
> everything in the first stage? Perhaps Andrew has better ideas, I'm
> just spit-balling. Presumably there are already locks at play, locks
> we would have to take in the case where Linux manages the PHY. Maybe
> they dictate an architecture?

I don't think the way linux manages PHYs dictates the
architecture. PHY cable test requires that the link is
administratively up, so the PHY state machine is in play. It
transitions into a testing state when cable test is started, and when
the test is finished, it resets the PHY to put it back into running
state. If you down the interface while the cable test is running, it
aborts the cable test, and then downs the PHY.

Flashing firmware is a bit different. You need to ensure the interface
is down. And i guess that gets interesting with split modules. You
really should not abort an upgrade because the user wants to up the
interface. So -EBUSY to open() seems like the best option, based on
the state of the SFP state machine.

I suspect you are going to need a kernel thread to do the real
work. So your "prepare" netlink op would pass the name of the firmware
file. Some basic validation would be performed, that all the needed
interfaces are down etc, and then the netlink OP would return. The
thread then uses request_firmware() to get access to the firmware, and
program it. Once complete, or on error, it can async notify user space
that it is sorry, your module is toast, or firmware upgrade was
successful.

This is just throwing out ideas...

     Andrew
