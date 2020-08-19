Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2C5249372
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 05:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgHSDfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 23:35:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbgHSDfE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 23:35:04 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A7732063A;
        Wed, 19 Aug 2020 03:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597808104;
        bh=mmrvdR2w9EFoKEMGiESbciUGkScOXrtaAb5zhLENcHc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AzP69lSjbxgrAOzExzvRDEMJ4o+O4MslnhH+we/XEUUMTXLGFzoWAm9ct1KoMCXu1
         Cf02oXHbyJ/ykqSS6rTHVYYImvsougfjq1fskb/Xk8jF7czUe+kXy6yH316Zk69Ged
         IzntVZZP59qU7tv1uJucx+6qhIIBY0I/nj3Pe6Vw=
Date:   Tue, 18 Aug 2020 20:35:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@nvidia.com, amcohen@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com, roopa@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        tariqt@nvidia.com, ayal@nvidia.com, mkubecek@suse.cz,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/6] devlink: Add device metric support
Message-ID: <20200818203501.5c51e61a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <58a0356d-3e15-f805-ae52-dc44f265661d@gmail.com>
References: <20200817125059.193242-1-idosch@idosch.org>
        <20200818172419.5b86801b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <58a0356d-3e15-f805-ae52-dc44f265661d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Aug 2020 20:43:11 -0600 David Ahern wrote:
> On 8/18/20 6:24 PM, Jakub Kicinski wrote:
> > On Mon, 17 Aug 2020 15:50:53 +0300 Ido Schimmel wrote:  
> >> From: Ido Schimmel <idosch@nvidia.com>
> >>
> >> This patch set extends devlink to allow device drivers to expose device
> >> metrics to user space in a standard and extensible fashion, as opposed
> >> to the driver-specific debugfs approach.  
> > 
> > I feel like all those loose hardware interfaces are a huge maintenance
> > burden. I don't know what the solution is, but the status quo is not
> > great.  
> 
> I don't agree with the 'loose' characterization.

Loose as in not bound by any standard or best practices.

> Ido and team are pushing what is arguably a modern version of
> `ethtool -S`, so it provides a better API for retrieving data.

ethtool -S is absolutely terrible. Everybody comes up with their own
names for IEEE stats, and dumps stats which clearly have corresponding
fields in rtnl_link_stats64 there. We don't need a modern ethtool -S,
we need to get away from that mess.

> > I spend way too much time patrolling ethtool -S outputs already.
> 
> But that's the nature of detailed stats which are often essential to
> ensuring the system is operating as expected or debugging some problem.
> Commonality is certainly desired in names when relevant to be able to
> build tooling around the stats.

There are stats which are clearly detailed and device specific, 
but what ends up happening is that people expose very much not
implementation specific stats through the free form interfaces, 
because it's the easiest. 

And users are left picking up the pieces, having to ask vendors what
each stat means, and trying to create abstractions in their user space
glue.

> As an example, per-queue stats have been
> essential to me for recent investigations. ethq has been really helpful
> in crossing NIC vendors and viewing those stats as it handles the
> per-vendor naming differences, but it requires changes to show anything
> else - errors per queue, xdp stats, drops, etc. This part could be simpler.

Sounds like you're agreeing with me?

> As for this set, I believe the metrics exposed here are more unique to
> switch ASICs.

This is the list from patch 6:

   * - ``nve_vxlan_encap``
   * - ``nve_vxlan_decap``
   * - ``nve_vxlan_decap_errors``
   * - ``nve_vxlan_decap_discards``

What's so unique?

> At least one company I know of has built a business model
> around exposing detailed telemetry of switch ASICs, so clearly some find
> them quite valuable.

It's a question of interface, not the value of exposed data.

If I have to download vendor documentation and tooling, or adapt my own
scripts for every new vendor, I could have as well downloaded an SDK.
