Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A814E31BE
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 21:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343615AbiCUU37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 16:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbiCUU36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 16:29:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E133433A2C
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 13:28:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8711E611A1
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 20:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7461EC340E8;
        Mon, 21 Mar 2022 20:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647894511;
        bh=9j4X2Ou2UhTylkzJ0zMR4erYwjNFbL2hKER7VqwOqyw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=exOzOhYEr2iAWMvz0tj7Qi/0pCrCmGmO+MnFYVPAehC2pReiMCRLFQupKVdWj12E2
         H2wOCGGiX4DsKAXUKU5rNdud1/E0XcGpDO+0YWVGToEb7oGp9Kg6ju3HFIiQPhvN2G
         sHHP0wEpBkPvug6R+A7uHoTiuEyf0ktD3wBeVp1k1xY4F86MPsZOb8x801PNRJq7qe
         anJvH73WwzpukYeg7LnKOkpStOOa0hz+jwS5N3lqkeluPBIQLI1hqmm2lYXJDrHvkf
         bnw8cDL48/irQNNj6Fkf9qBDvlQf0mknYgNVxaIKq85xIE+EV4spqf8hS5urZYWl8h
         jhiroU7XlheFA==
Date:   Mon, 21 Mar 2022 13:28:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [RFC PATCH net-next] net: create a NETDEV_ETH_IOCTL notifier
 for DSA to reject PTP on DSA master
Message-ID: <20220321132829.71fe30d5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220317225035.3475538-1-vladimir.oltean@nxp.com>
References: <20220317225035.3475538-1-vladimir.oltean@nxp.com>
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

On Fri, 18 Mar 2022 00:50:35 +0200 Vladimir Oltean wrote:
> The fact that PTP 2-step TX timestamping is deeply broken on DSA
> switches if the master also timestamps the same packets is well
> documented by commit f685e609a301 ("net: dsa: Deny PTP on master if
> switch supports it"). We attempt to help the users avoid shooting
> themselves in the foot by making DSA reject the timestamping ioctls on
> an interface that is a DSA master, and the switch tree beneath it
> contains switches which are aware of PTP.
> 
> The only problem is that there isn't an established way of intercepting
> ndo_eth_ioctl calls, so DSA creates avoidable burden upon the network
> stack by creating a struct dsa_netdevice_ops with overlaid function
> pointers that are manually checked from the relevant call sites. There
> used to be 2 such dsa_netdevice_ops, but now, ndo_eth_ioctl is the only
> one left.

Remind me - are the DSA CPU-side interfaces linked as lower devices 
of the ports?

> In fact, the underlying reason which is prompting me to make this change
> is that I'd like to hide as many DSA data structures from public API as
> I can. But struct net_device :: dsa_ptr is a struct dsa_port (which is a
> huge structure), and I'd like to create a smaller structure. I'd like
> struct dsa_netdevice_ops to not be a part of this, so this is how the
> need to delete it arose.

Isn't it enough to move the implementation to a C source instead 
of having it be a static inline?

> The established way for unrelated modules to react on a net device event
> is via netdevice notifiers. These have the advantage of loose coupling,
> i.e. they work even when DSA is built as module, without resorting to
> static inline functions (which cannot offer the desired data structure
> encapsulation).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> I'd mostly like to take this opportunity to raise a discussion about how
> to handle this. It's clear that calling the notifier chain is less
> efficient than having some dev->dsa_ptr checks, but I'm not sure if the
> ndo_eth_ioctl can tolerate the extra performance hit at the expense of
> some code cleanliness.
> 
> Of course, what would be great is if we didn't have the limitation to
> begin with, but the effort to add UAPI for multiple TX timestamps per
> packet isn't proportional to the stated goal here, which is to hide some
> DSA data structures.

Was there a reason we haven't converted the timestamping to ndos?
Just a matter of finding someone with enough cycles to go thru all 
the drivers?
