Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8FD217427
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 18:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgGGQhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 12:37:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728670AbgGGQhP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 12:37:15 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C21FD2064C;
        Tue,  7 Jul 2020 16:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594139835;
        bh=2ma2r9xR8lMh0MVGIkEhE0rL8TjtWIRPOKQRyn1ZOKI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CrSPBcz16wx139Uucr6nKlw9bV4kEhmm4kEj+HAJ0pFE6+gI57/xwBfugzAB/3KHS
         gCHJ0hqfkAvQjr3b+UMpq7H/4WAIZWD3BKGZ9g3CUWsKMb9eblbdoF10NzvfrARZ1k
         qHxgQLFF9MdtVD3sdQWGhMRZFfvLyBOxB6ldaW7Y=
Date:   Tue, 7 Jul 2020 09:37:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>,
        Ron Diskin <rondi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net 02/11] net/mlx5e: Fix multicast counter not up-to-date in
 "ip -s"
Message-ID: <20200707093707.03654eee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c1b6c9e627d83d47aaa43e44154b340e65880344.camel@mellanox.com>
References: <20200702221923.650779-1-saeedm@mellanox.com>
        <20200702221923.650779-3-saeedm@mellanox.com>
        <20200702184757.7d3b1216@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3b7c4d436e55787fff3d8d045478dd4c08ba1d19.camel@mellanox.com>
        <20200702212511.1fcbbb26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <763ba5f0a5ae07f4da736572f1a3e183420efcd0.camel@mellanox.com>
        <20200703105938.2b7b0b48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a8ef2aece592d352dd6bd978db2d430ce55826ed.camel@mellanox.com>
        <20200706125704.465b3a0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <f5ddd73d9fc5ccdf340de0c6c335888de51d98de.camel@mellanox.com>
        <20200706190755.688f6fa7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c1b6c9e627d83d47aaa43e44154b340e65880344.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Jul 2020 03:29:18 +0000 Saeed Mahameed wrote:
> On Mon, 2020-07-06 at 19:07 -0700, Jakub Kicinski wrote:
> > On Tue, 7 Jul 2020 01:51:21 +0000 Saeed Mahameed wrote:  
> > > > Also looks like you report the total number of mcast packets in
> > > > ethtool
> > > > -S, which should be identical to ip -s? If so please remove
> > > > that.    
> > > 
> > > why ? it is ok to report the same counter both in ehttool and
> > > netdev
> > > stats.  
> > 
> > I don't think it is, Stephen and I have been trying to catch this in
> > review for a while now. It's an entirely unnecessary code
> > duplication.  
> 
> Code duplication shouldn't be a factor. For example, in mlx5 we have a
> generic mechanism to define and report stats, for the netdev stats to
> be reported in ethtoool all we need to do is define the representing
> string and store those counters in the SW stats struct.

And sum them up in a loop. One day we'll have a better API for standard
stats and will will we still argue then that ethtool -S should
duplicate _everything_.

Drivers should put more focus on providing useful information in
standard statistics in the first place, then think about exposing more
details as needed.

> > We should steer towards proper APIs first if those exist.
> > 
> > Using ethtool -S stats gets very messy very quickly in production.  
> 
> I agree on ethtool getting messy very quickly, but i disagree on not
> reporting netdev stats, I don't think the 4 netdev stats are the reason
> for messy ethtool.
> 
> Ethtool -S is meant for verbosity and debug, and it is full of
> driver/HW specific counters, how are you planing to audit all of those
> ?

I don't understand how verbosity, debug, and being full of HW specific
counters has any relevance for this patch - which is reporting a pure
SW driver stat.

> We had an idea in the past to allow users to choose what stats groups
> to report to ethtool, we can follow up on this if this is something
> other drivers might be interested in.
> 
> example: 
> 
> ethtool -S eth0 --groups XDP,SW,PER_QUEUE,PCI,PORT,DRIVER_SPECIFIC
> Where non DRIVER_SPECIFC groups are standardize stats objects.. 

Attributes are useful but the primary problem is the fact that we,
driver developers, seem to be funneling all our creative passion into
coming up with new names for statistics.

Look for example how many names we have for etherStatsPkts256to511Octets
And nobody(!) thought it's a good idea to just name the counter what
it's called in the RFC.

Policing a free form string interface in review is just unworkable.

Anyway.. I'm sidetracking.
