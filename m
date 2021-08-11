Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032A33E99B2
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 22:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbhHKUad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 16:30:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230413AbhHKUac (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 16:30:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9F6160FC3;
        Wed, 11 Aug 2021 20:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628713808;
        bh=RnxR/tsyy9sZpQxzPXDmPfxKFIZ7gjJ36joS9apMwWw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ax+FyCXBOPsv3hTAmAD6j+v6wZmeJ++7IO417t8BNCpopkdUq2MnvlA0xvW+B9jQQ
         Lzvj/o9o8vHa3rJaau2QTHjG08zazN3ctcy4KrsB2I6znsZ1/50U8FlNUuD6Abcg2m
         77CyBOGhmIG3ESxRu+N/KVi/nITcusv5Z71Z6kBBJAIfevfQoWd80hP3+7qKe60Dgr
         Zgm2loDv2ul4hBl6bO1Ck0pikrMrNRftTwmWrwkmuOCf1HFC5lV6KJqORDF4y941hN
         FCUAEqeZg20EZzaCV9K7WkZtOG71pj2jGX68sAu7Ndx5Woh6eFihhH/Gc6B+ackG7k
         vTfA4MadBuSoQ==
Date:   Wed, 11 Aug 2021 13:30:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz,
        pali@kernel.org, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 1/8] ethtool: Add ability to control
 transceiver modules' low power mode
Message-ID: <20210811133006.1c9aa6db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YRQnEWeQSE22woIr@shredder>
References: <20210809102152.719961-2-idosch@idosch.org>
        <YRE7kNndxlGQr+Hw@lunn.ch>
        <YRIqOZrrjS0HOppg@shredder>
        <YRKElHYChti9EeHo@lunn.ch>
        <20210810065954.68036568@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YRLlpCutXmthqtOg@shredder>
        <20210810150544.3fec5086@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YRO1ck4HYWTH+74S@shredder>
        <20210811060343.014724e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YRPgXWKZ2e88J1sn@lunn.ch>
        <YRQnEWeQSE22woIr@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Aug 2021 22:37:53 +0300 Ido Schimmel wrote:
> On Wed, Aug 11, 2021 at 04:36:13PM +0200, Andrew Lunn wrote:
> > On Wed, Aug 11, 2021 at 06:03:43AM -0700, Jakub Kicinski wrote:  
> > > Oh, so if we set low-power true the carrier will never show up?
> > > I thought Andrew suggested the setting is only taken into account 
> > > when netdev is down.  
> > 
> > Yes, that was my intention. If this low power mode also applies when
> > the interface is admin up, it sounds like a foot gun. ip link show
> > gives you no idea why the carrier is down, and people will assume the
> > cable or peer is broken. We at least need a new flag, LOWER_DISABLED
> > or similar to give the poor user some chance to figure out what is
> > going on.  
> 
> The canonical way to report such errors is via LINKSTATE_GET and I will
> add an extended sub-state describing the problem.
>  
> > To me, this setting should only apply when the link is admin down.  
> 
> I don't want to bake such an assumption into the kernel, but I have a
> suggestion that resolves the issue.
> 
> We currently have a single attribute that encodes the desired state on
> SET messages and the operational state on GET_REPLY messages
> (ETHTOOL_A_MODULE_LOW_POWER_ENABLED):
> 
> $ ethtool --show-module swp11
> Module parameters for swp11:
> low-power true
> 
> It is not defined very well when a module is not connected despite being
> a very interesting use case. We really need to have two attributes. The
> first one describing the power mode policy and the second one describing
> the operational power mode which is only reported when a module is
> plugged in.
> 
> For the policy we can have these values:
> 
> 1. low: Always transition the module to low power mode
> 2. high: Always transition the module to high power mode
> 3. high-on-up: Transition the module to high power mode when a port
> using it is administratively up. Otherwise, low
> 
> A different policy for up/down seems like an overkill for me.
> 
> See example usage below.
> 
> No module connected:
> 
> $ ethtool --show-module swp11
> Module parameters for swp11:
> power-mode-policy high
> 
> Like I mentioned before, this is the default on Mellanox systems so this
> new attribute allows user space to query the default policy.
> 
> Change to a different policy:
> 
> # ethtool --set-module swp11 power-mode-policy high-on-up
> 
> $ ethtool --show-module swp11
> Module parameters for swp11:
> power-mode-policy high-on-up
> 
> After a module was connected:
> 
> $ ethtool --show-module swp11
> Module parameters for swp11:
> power-mode-policy high-on-up
> power-mode low
> 
> # ip link set dev swp11 up
> 
> $ ethtool --show-module swp11
> Module parameters for swp11:
> power-mode-policy high-on-up
> low-power high
> 
> # ip link set dev swp11 down
> 
> # ethtool --set-module swp11 power-mode-policy low
> 
> # ip link set dev swp11 up
> 
> $ ethtool swp11
> ...
> Link detected: no (Cable issue, Module is in low power mode)
> 
> I'm quite happy with the above. Might change a few things as I implement
> it, but you get the gist. WDYT?

Isn't the "low-power" attr just duplicating the relevant bits from -m?
