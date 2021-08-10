Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DB33E835B
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 21:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbhHJTAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 15:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229788AbhHJTAy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 15:00:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE20660F13;
        Tue, 10 Aug 2021 19:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628622032;
        bh=57JDdL1myosYs8tgP3x4clh4ophC/zCFbvfMVhZYoEU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Up3WSgzxHuMPDUhIespmluf6d+GOUi3ov5UTU3Ok44nY1zy1ul/vh/V5m39jmjB2x
         06zdGtcAyCgTZ1XGQTFUbdQbvBf92aAH1gJ7rweAAtxTulI8XRgGzQdcpF9VRT8fDk
         qkIwhM/+qcEh3uxEca8gKJuLqcyLiTFhNkGrb/toMDDGrIbzzjt12R1PeS+uWSurJd
         g6g63wj/AZLSaeiVjANHRXfbrSmctCCvq99TW8mE7lD9gqeZL/bI68uLVOv8P8ivvw
         7KH6JLs4LPIO4gERHFXnVh7UmVKjWmfJizMuO0Qx8HIqwe2MO94h01YJu/Nmz08zFg
         SM+77PKX5ZZwQ==
Date:   Tue, 10 Aug 2021 12:00:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, mkubecek@suse.cz, pali@kernel.org,
        vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 2/8] ethtool: Add ability to reset
 transceiver modules
Message-ID: <20210810120030.5092ec22@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YRLCUc8NZnRZFUFs@shredder>
References: <20210809102152.719961-1-idosch@idosch.org>
        <20210809102152.719961-3-idosch@idosch.org>
        <YRF+a6C/wHa7+2Gs@lunn.ch>
        <YRJ5g/W11V0mjKHs@shredder>
        <20210810065423.076e3b0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YRLCUc8NZnRZFUFs@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Aug 2021 21:15:45 +0300 Ido Schimmel wrote:
> On Tue, Aug 10, 2021 at 06:54:23AM -0700, Jakub Kicinski wrote:
> > On Tue, 10 Aug 2021 16:05:07 +0300 Ido Schimmel wrote:  
> > > Takes about 1.5ms to get an ACK on the reset request and another few
> > > seconds to ensure module is in a valid operational state (will remove
> > > RTNL in next version).  
> > 
> > Hm. RTNL-lock-less ethtool ops are a little concerning. The devlink
> > locking was much complicated by the unclear locking rules. Can we keep
> > ethtool simple and put this functionality in a different API or make
> > the reset async?  
> 
> I thought there are already RTNL-lock-less ethtool ops, but maybe I
> imagined it. Given that we also want to support firmware update on
> modules and that user space might want to update several modules
> simultaneously, do you have a suggestion on how to handle it from
> locking perspective?

Hm, flashing is harder than reset. We can't unbind the driver while
it's in progress. I don't have any ready solution in mind, but I'd 
like to make sure the locking is clear and hard to get wrong. Maybe 
we could have a mix of ops, one called for "preparing" the flashing
called under rtnl and another for "commit" with "unlocked" in the name.
Drivers which don't want to deal with dropping rtnl lock can just do
everything in the first stage? Perhaps Andrew has better ideas, I'm
just spit-balling. Presumably there are already locks at play, locks
we would have to take in the case where Linux manages the PHY. Maybe
they dictate an architecture?

> The ethtool netlink backend has parallel ops, but
> RTNL is a problem. Firmware flashing is currently synchronous in both
> ethtool and devlink, but the latter does not hold RTNL.

Yeah, drivers dropping rtnl_lock mid way thru the ethtool flashing op
was one of my main motivations for moving it into devlink.

> > > We can have multiple ports (split) using the same module and in CMIS
> > > each data path is controlled by a different state machine. Given the
> > > complexity of these modules and possible faults, it is possible to
> > > imagine a situation in which a few ports are fine and the rest are
> > > unable to obtain a carrier.
> > > 
> > > Resetting the module on ifup of swp1s0 is not intuitive and it shouldn't
> > > affect other split ports (e.g., swp1s1). With the dedicated reset
> > > command we have the ability to enforce all the required restrictions
> > > from the start instead of changing the behavior of existing commands.  
> > 
> > Sounds similar to what ethtool --reset was trying to address (upper
> > 16 bits). Could we reuse that? Whether its a SFP or other part of the
> > port being reset may not be entirely important to the user, so perhaps
> > it's not a bad idea to abstract that away and stick to "reset levels"?  
> 
> Wasn't aware of this API. Looks like it is only implemented by a few
> drivers, but man page says "phy    Transceiver/PHY", so I think we can
> reuse it.
> 
> What do you mean by "reset levels"? The split between shared /
> dedicated?

Indeed.

> Just to make sure I understand, you suggest the following semantics?
> 
> # ethtool --reset swp1s0 phy
> Error since module is used by several ports (split)
> 
> # ethtool --reset swp1s0 phy-shared
> OK
> 
> # ethtool --reset swp1 phy
> OK (no split)
> 
> # ethtool --reset swp1 phy-shared
> OK

Exactly.
