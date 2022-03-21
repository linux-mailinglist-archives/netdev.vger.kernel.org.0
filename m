Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF08D4E324F
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 22:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiCUVZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 17:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiCUVY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 17:24:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38922EF0E1
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 14:23:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 55227CE1B68
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 21:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033E7C340E8;
        Mon, 21 Mar 2022 21:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647897778;
        bh=rwKDQ3q0RfkRD4U9y/jIsiWONle2rjZrYK6J2q0rlZA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y8E6zpZd3/b0NEjET5xGpN+IjYdzUQLBmfJxSWdjX5QmVXUBO91ZwforyuAiVVby4
         iYeIN+A/PYKb26tCjKSpSY/CTy8An2ojiR/+g89ConbKCJyBOj2nwjZwZtHhSKcM3e
         4bzCF0ACiDv/KPot+n8/rvdM7L/y4gdH9B37tN9H3lO53xP/cnJWxft0EeDfMAG14Q
         Yfa+pfQsvcq9wBs6Rf7viR468aqEiE5xSW4L9LDimgwwUHv599irdhBvAgB8XYIOX+
         mRrnuz1HaMT+jGqPeauAm/Y2fuh9z1STh0e3l3XiAFpT2jeqK1ceRZVlXLZi5ZOySU
         +aPm8jg863SbQ==
Date:   Mon, 21 Mar 2022 14:22:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [RFC PATCH net-next] net: create a NETDEV_ETH_IOCTL notifier
 for DSA to reject PTP on DSA master
Message-ID: <20220321142256.6546528d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220321204832.dyz3telactx6jhqj@skbuf>
References: <20220317225035.3475538-1-vladimir.oltean@nxp.com>
        <20220321132829.71fe30d5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220321204832.dyz3telactx6jhqj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Mar 2022 22:48:32 +0200 Vladimir Oltean wrote:
> On Mon, Mar 21, 2022 at 01:28:29PM -0700, Jakub Kicinski wrote:
> > On Fri, 18 Mar 2022 00:50:35 +0200 Vladimir Oltean wrote:  
> > > The fact that PTP 2-step TX timestamping is deeply broken on DSA
> > > switches if the master also timestamps the same packets is well
> > > documented by commit f685e609a301 ("net: dsa: Deny PTP on master if
> > > switch supports it"). We attempt to help the users avoid shooting
> > > themselves in the foot by making DSA reject the timestamping ioctls on
> > > an interface that is a DSA master, and the switch tree beneath it
> > > contains switches which are aware of PTP.
> > > 
> > > The only problem is that there isn't an established way of intercepting
> > > ndo_eth_ioctl calls, so DSA creates avoidable burden upon the network
> > > stack by creating a struct dsa_netdevice_ops with overlaid function
> > > pointers that are manually checked from the relevant call sites. There
> > > used to be 2 such dsa_netdevice_ops, but now, ndo_eth_ioctl is the only
> > > one left.  
> > 
> > Remind me - are the DSA CPU-side interfaces linked as lower devices 
> > of the ports?  
> 
> DSA CPU-side interfaces have no representation towards user space.
> We overlay some port counters through the ethtool_ops of the host
> controller, such that when the user runs "ethtool -S eth0" they see the
> counters of the switch port and of the host port back to back, and
> that's about it. The ioctl for which we have a special case, and which
> I'm now trying to remove, is just to enforce a restriction.

Sorry, I was trying to avoid saying "master". I meant the "master"
/ host MAC interface that's often a random driver.

> > > In fact, the underlying reason which is prompting me to make this change
> > > is that I'd like to hide as many DSA data structures from public API as
> > > I can. But struct net_device :: dsa_ptr is a struct dsa_port (which is a
> > > huge structure), and I'd like to create a smaller structure. I'd like
> > > struct dsa_netdevice_ops to not be a part of this, so this is how the
> > > need to delete it arose.  
> > 
> > Isn't it enough to move the implementation to a C source instead 
> > of having it be a static inline?  
> 
> Assuming you mean to make that C source part of dsa_core.o:
> 
> obj-$(CONFIG_NET_DSA) += dsa_core.o
> 
> CONFIG_NET_DSA can be module, so it couldn't be called from built-in code.
> 
> Or do you mean adding something like:
> 
> obj-y := dsa_extra.o
> 
> which only contains dsa_master_ioctl(), basically?

Yup, we can create a "y" object even if most of DSA is m. Like:

ifneq ($(CONFIG_NET_DSA),)
obj-y += dsa_something_something.o
endif

> > > The established way for unrelated modules to react on a net device event
> > > is via netdevice notifiers. These have the advantage of loose coupling,
> > > i.e. they work even when DSA is built as module, without resorting to
> > > static inline functions (which cannot offer the desired data structure
> > > encapsulation).
> > > 
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > ---
> > > I'd mostly like to take this opportunity to raise a discussion about how
> > > to handle this. It's clear that calling the notifier chain is less
> > > efficient than having some dev->dsa_ptr checks, but I'm not sure if the
> > > ndo_eth_ioctl can tolerate the extra performance hit at the expense of
> > > some code cleanliness.
> > > 
> > > Of course, what would be great is if we didn't have the limitation to
> > > begin with, but the effort to add UAPI for multiple TX timestamps per
> > > packet isn't proportional to the stated goal here, which is to hide some
> > > DSA data structures.  
> > 
> > Was there a reason we haven't converted the timestamping to ndos?
> > Just a matter of finding someone with enough cycles to go thru all 
> > the drivers?  
> 
> So you're saying that if SIOCSHWTSTAMP and SIOCGHWTSTAMP had their own
> ndo, a netdev notifier would be easier to swallow?

Yes, having a "IOCTL" notifier really isn't great. At the very least
the notifier should be more narrow.

But TBH adding an NDO is one of my "I wish I had the time to clean this
up" tasks, so I thought I'd bring it up in case you have extra context.

> Maybe, I haven't explored that avenue, but on the other hand,
> ndo_eth_ioctl seems to only be used for PTP, plus PHY user-space access
> (SIOCGMIIPHY, SIOCGMIIREG, SIOCSMIIREG). There isn't an active desire
> from PHY maintainers to keep that UAPI in the best shape, to my
> knowledge, since it is feared that if it works too well, vendors might
> end up with user space PHY drivers for their SDKs. Those ioctls are
> currently a best-effort debugging tool.

Right, would be pretty great to keep the "useful" stuff out of
ndo_eth_ioctl, then we can keep an eye out for new drivers trying 
to use it more easily. Or even add a patchwork check.
