Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF762BC15D
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 19:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgKUSPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 13:15:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:40476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727235AbgKUSPx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 13:15:53 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BB9622201;
        Sat, 21 Nov 2020 18:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605982552;
        bh=1BqyxSS8z+G23mtVjHOtKSYckt8/VDf9fdA1rXsvQyg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ki/2KSubvEOQupmqMpT7UyanOWFuIJDxshClsUoexTiPxcqi3Co/CbMmgGIIhDD6a
         g5zNEqPys8y25HHPamJwpzQP4344zic7FXDxODJeEQOCujul6zO6gIrtxdVoGbaNBD
         gagf8cBTcBWsAI16EA61NgNBoH5ddLePeW8txbmc=
Date:   Sat, 21 Nov 2020 10:15:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, razor@blackwall.org, jeremy@azazel.net
Subject: Re: [PATCH net-next,v3 0/9] netfilter: flowtable bridge and vlan
 enhancements
Message-ID: <20201121101551.3264c5fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201121123138.GA21560@salvia>
References: <20201111193737.1793-1-pablo@netfilter.org>
        <20201113175556.25e57856@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201114115906.GA21025@salvia>
        <87sg9cjaxo.fsf@waldekranz.com>
        <20201114090347.2e7c1457@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201116221815.GA6682@salvia>
        <20201116142844.7c492fb6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201116223615.GA6967@salvia>
        <20201116144521.771da0c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201116225658.GA7247@salvia>
        <20201121123138.GA21560@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Nov 2020 13:31:38 +0100 Pablo Neira Ayuso wrote:
> On Mon, Nov 16, 2020 at 11:56:58PM +0100, Pablo Neira Ayuso wrote:
> > On Mon, Nov 16, 2020 at 02:45:21PM -0800, Jakub Kicinski wrote:  
> > > On Mon, 16 Nov 2020 23:36:15 +0100 Pablo Neira Ayuso wrote:  
> > > > > Are you saying A -> B traffic won't match so it will update the cache,
> > > > > since conntrack flows are bi-directional?    
> > > > 
> > > > Yes, Traffic for A -> B won't match the flowtable entry, this will
> > > > update the cache.  
> > > 
> > > That's assuming there will be A -> B traffic without B sending a
> > > request which reaches A, first.  
> > 
> > B might send packets to A but this will not get anywhere. Assuming
> > TCP, this will trigger retransmissions so B -> A will kick in to
> > refresh the entry.
> > 
> > Is this scenario that you describe a showstopper?  

Sorry I got distracted.
 
> I have been discussing the topology update by tracking fdb updates
> with the bridge maintainer, I'll be exploring extensions to the
> existing fdb_notify() infrastructure to deal with this scenario you
> describe. On my side this topology update scenario is not a priority
> to be supported in this patchset, but it's feasible to support it
> later on.

My concern is that invalidation is _the_ hard part of creating caches.
And I feel like merging this as is would be setting our standards pretty
low. 

Please gather some review tags from senior netdev developers. I don't
feel confident enough to apply this as 100% my own decision.
