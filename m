Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0452CC2EC
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 18:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728661AbgLBQ75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 11:59:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:60906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726003AbgLBQ74 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 11:59:56 -0500
Date:   Wed, 2 Dec 2020 08:59:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606928355;
        bh=tpJRqTqRwE7xvMkLBAJttSlaeM9g3GiHw4qRQ7UNLSA=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=MEnz+uvplzzHLgGG9VVllQjG2n6ej6qci42+m0+snnrAwNHtTEu6vnqfr0JG7gTWQ
         S6/MljntihZiLS5B1/YKcDpK2ZY/iLINacqalYzmEmdX5FBr7s3QgRWjtMY6U5PoAy
         ahYQK/GOoY04dkgQ0MJR57n+N9w5G8TIJGtWQTNc=
From:   Jakub Kicinski <kuba@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@idosch.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Shannon Nelson <snelson@pensando.io>
Subject: Re: [PATCH net-next] net: sfp: add debugfs support
Message-ID: <20201202085913.1eda0bba@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202130318.GD1551@shell.armlinux.org.uk>
References: <E1khJyS-0003UU-9O@rmk-PC.armlinux.org.uk>
        <20201124001431.GA2031446@lunn.ch>
        <20201124084151.GA722671@shredder.lan>
        <20201124094916.GD1551@shell.armlinux.org.uk>
        <20201124104640.GA738122@shredder.lan>
        <20201202130318.GD1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Dec 2020 13:03:18 +0000 Russell King - ARM Linux admin wrote:
> Jakub,
> 
> What's your opinion on this patch? It seems to have stalled...

Sorry, I think I expected someone to do the obvious questioning..

> On Tue, Nov 24, 2020 at 12:46:40PM +0200, Ido Schimmel wrote:
> > On Tue, Nov 24, 2020 at 09:49:16AM +0000, Russell King - ARM Linux admin wrote:  
> > > On Tue, Nov 24, 2020 at 10:41:51AM +0200, Ido Schimmel wrote:  
> > > > On Tue, Nov 24, 2020 at 01:14:31AM +0100, Andrew Lunn wrote:  
> > > > > On Mon, Nov 23, 2020 at 10:06:16PM +0000, Russell King wrote:  
> > > > > > Add debugfs support to SFP so that the internal state of the SFP state
> > > > > > machines and hardware signal state can be viewed from userspace, rather
> > > > > > than having to compile a debug kernel to view state state transitions
> > > > > > in the kernel log.  The 'state' output looks like:
> > > > > > 
> > > > > > Module state: empty
> > > > > > Module probe attempts: 0 0
> > > > > > Device state: up
> > > > > > Main state: down
> > > > > > Fault recovery remaining retries: 5
> > > > > > PHY probe remaining retries: 12

Perfectly reasonable, no objections.

> > > > > > moddef0: 0
> > > > > > rx_los: 1
> > > > > > tx_fault: 1
> > > > > > tx_disable: 1

These, tho, are standard SFP signals, right? Maybe we should put them
in struct ethtool_link_ext_state_info? I remember that various "vendor
tools" report those, maybe it'd be nice to have a standard way of
exposing those signals tru ethtool APIs?

Opinions welcome (let me CC more NIC people)!

> > > > > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>  
> > > > > 
> > > > > Hi Russell
> > > > > 
> > > > > This looks useful. I always seem to end up recompiling the kernel,
> > > > > which as you said, this should avoid.  
> > > > 
> > > > FWIW, another option is to use drgn [1]. Especially when the state is
> > > > queried from the kernel and not hardware. We are using that in mlxsw
> > > > [2][3].  
> > > 
> > > Presumably that requires /proc/kcore support, which 32-bit ARM doesn't
> > > have.  
> > 
> > Yes, it does seem to be required for live debugging. I mostly work with
> > x86 systems, I guess it's completely different for Andrew and you.
