Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02834498C7
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 16:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239221AbhKHP5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 10:57:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:53094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239202AbhKHP5g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 10:57:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3864261186;
        Mon,  8 Nov 2021 15:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636386891;
        bh=9X8r3jqw0ZTe39v+PUxIOYcuShAZDQmvLMPn7jbJ02c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HehssfTnKSI+G9VRy34d0drzJPsDtq+tIe44xT+ryor1Z809l8sTHKfmHAm2ZF1uS
         gvU6sQBVbR/Jxn50xRZn3LHR6K+44AHY4j2bu39hLDF117bg3zz/You6JeEiA6SZJn
         nnjCtOgigIGWKheRQMW3X3OaB5/VS419J/RIup59m0GTiWy36rEooq0P5k/Hgi6pbh
         sJwEbmiLQeqP3zFSyWKMxkTUKx81nyPpzkBA1TRcQcvFkB7RYI2lUY8T5Rl/17y3AT
         rWffVqBTfvXJ3skEBjMCA1mwB+5B31YNO/WSRgjYJWGcAxgl15mB6kPQ/MkcunYwTc
         5dNzJOK0Hi3rQ==
Date:   Mon, 8 Nov 2021 07:54:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     sundeep subbaraya <sundeep.lkml@gmail.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Rakesh Babu Saladi <rsaladi2@marvell.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Lunn <andrew@lunn.ch>, argeorge@cisco.com
Subject: Re: [EXT] Re: [net-next PATCH 1/2] octeontx2-pf: Add devlink param
 to init and de-init serdes
Message-ID: <20211108075450.1dbdedc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YYeajTs6d4j39rJ2@shredder>
References: <20211027083808.27f39cb0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR18MB4671C22DB7C8E5C46647860FA1859@PH0PR18MB4671.namprd18.prod.outlook.com>
        <CALHRZurNzkkma7HGg2xNLz3ECbwT2Hv=QXMeWr7AXCEegHOciw@mail.gmail.com>
        <20211027100857.4d25544c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YXmWb2PZJQhpMfrR@shredder>
        <BY3PR18MB473794E01049EC94156E2858C6859@BY3PR18MB4737.namprd18.prod.outlook.com>
        <YXnRup1EJaF5Gwua@shredder>
        <CALHRZuqpaqvunTga+8OK4GSa3oRao-CBxit6UzRvN3a1-T0dhA@mail.gmail.com>
        <YXqq19HxleZd6V9W@shredder>
        <CALHRZuoOWu0sEWjuanrYxyAVEUaO4-wea5+mET9UjPyoOrX5NQ@mail.gmail.com>
        <YYeajTs6d4j39rJ2@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 7 Nov 2021 11:21:17 +0200 Ido Schimmel wrote:
> > This looks good. Please note that we need the behavior such that after changing
> > the flag a subsequent ifconfig command is not needed by the user.
> > 
> > auto : in ndo_open, ndo_close check the physical link flag is auto and
> > send command
> >           to firmware for bringing physical link up/down.
> > up: send command to firmware instantaneously for physical link UP
> > down: send command to firmware instantaneously for physical link DOWN  
> 
> TBH, I'm not that happy with my ethtool suggestion. It is not very clear
> which hardware entities the attribute controls.

Last week I heard a request to also be able to model NC-SI disruption.
Control if the NIC should be reset and newly flashed FW activated when
host is rebooted (vs full server power cycle).

That adds another dimension to the problem, even though that particular
use case may be better answered thru the devlink flashing/reset APIs.

Trying to organize the requirements we have 3 entities which may hold
the link up:
 - SFP power policy
 - NC-SI / BMC
 - SR-IOV (legacy)

I'd think auto/up as possible options still make sense, although in
case of NC-SI many NICs may not allow overriding the "up". And the
policy may change without notification if BMC selects / activates 
a port - it may go from auto to up with no notification.

Presumably we want to track "who's holding the link up" per consumer.
Just a bitset with 1s for every consumer holding "up"? 

Or do we expect there will be "more to it" and should create bespoke
nests?

> Maybe it's better to
> implement it as a rtnetlink attribute that controls the carrier (e.g.,
> "carrier_policy")? Note that we already have ndo_change_carrier(), but
> the kdoc comment explicitly mentions that it shouldn't be used by
> physical devices:
>
>  * int (*ndo_change_carrier)(struct net_device *dev, bool new_carrier);
>  *	Called to change device carrier. Soft-devices (like dummy, team, etc)
>  *	which do not represent real hardware may define this to allow their
>  *	userspace components to manage their virtual carrier state. Devices
>  *	that determine carrier state from physical hardware properties (eg
>  *	network cables) or protocol-dependent mechanisms (eg
>  *	USB_CDC_NOTIFY_NETWORK_CONNECTION) should NOT implement this function.

New NDO seems reasonable. 

What are your thoughts on the SFP policy? We can still reshuffle it.
