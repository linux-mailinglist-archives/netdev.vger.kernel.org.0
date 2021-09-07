Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856F8402C1A
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 17:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345460AbhIGPpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 11:45:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235162AbhIGPpi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 11:45:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 434B861052;
        Tue,  7 Sep 2021 15:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631029472;
        bh=5CJSM7F1/+gkcK1cG/KQEz6Jd8XoO80TPdtP+wMVTEg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EqTlUi5HNilEUHlLRJW3ijlQ3z26548J4lkWT3bw2IOuMUt+DoBPiUEiiAcqCaIeK
         XU0do6Ipywp9GFdQ2pj9c1OC8mUYhTYTdU5pqUlqjJCxaDOeiSxPV8jPjjER3yj6u/
         aT93DuiT+ycU3zzuc0oIIdaqFuF/yXg24quxQ9+OvQd2ji+RC4fX8f1SLNJ1qfwJns
         om84lQ5P6BcvCblx6spqJfFn/BCq5gm9EXioqUd/vPm96B6ALpXbi2aOhqF2dcoQ72
         Wbtxh8qTpV6nwt1MQyP4vdrU1eJHhZyEdQ1K2A2WUtHtDHZsoTd+AA7d/zlDmysaKe
         KFKxPqssgM13Q==
Date:   Tue, 7 Sep 2021 08:44:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net] net: dsa: tear down devlink port regions when
 tearing down the devlink port on error
Message-ID: <20210907084431.563ee411@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210905110735.asgsyjygsrxti6jk@skbuf>
References: <20210902231738.1903476-1-vladimir.oltean@nxp.com>
        <YTRswWukNB0zDRIc@unreal>
        <20210905084518.emlagw76qmo44rpw@skbuf>
        <YTSa/3XHe9qVz9t7@unreal>
        <20210905103125.2ulxt2l65frw7bwu@skbuf>
        <YTSgVw7BNK1e4YWY@unreal>
        <20210905110735.asgsyjygsrxti6jk@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 5 Sep 2021 14:07:35 +0300 Vladimir Oltean wrote:
> Again, fallback but not during devlink port register. The devlink port
> was registered just fine, but our plans changed midway. If you want to
> create a net device with an associated devlink port, first you need to
> create the devlink port and then the net device, then you need to link
> the two using devlink_port_type_eth_set, at least according to my
> understanding.
> 
> So the failure is during the creation of the **net device**, we now have a
> devlink port which was originally intended to be of the Ethernet type
> and have a physical flavour, but it will not be backed by any net device,
> because the creation of that just failed. So the question is simply what
> to do with that devlink port.

Is the failure you're referring to discovered inside the
register_netdevice() call?

> The only thing I said about the devlink API in the commit description is
> that it would have been nice to just flip the type and flavour of a
> devlink port, post registration. That would avoid a lot of complications
> in DSA. But that is obviously not possible, and my patch does not even
> attempt to do it. What DSA does today, and will still do after the patch
> we are discussing on, is to unregister that initial devlink port, and
> create another one with the unused flavour, and register that one.
> 
> The reason why we even bother to re-register a devlink port a second
> time for a port that failed to create and initialize its net_device is
> basically for consistency with the ports that are statically disabled in
> the device tree. Since devlink is a mechanism through which we gain
> insight into the hardware, and disabled ports are still physically
> present, just, you know, disabled and not used, their devlink ports
> still exist and can be used for things like dumping port regions.
> We treat ports that fail to find their PHY during probing as
> 'dynamically disabled', and the expectation is for them to behave just
> the same as ports that were statically disabled through the device tree.
> 
> My change is entirely about how to properly structure the code such that
> we unregister the port regions that a devlink port might have, before
> unregistering the devlink port itself, and how to re-register those port
> regions then, after the new devlink port was registered.

