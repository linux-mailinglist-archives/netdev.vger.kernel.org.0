Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739902B5453
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 23:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729969AbgKPW2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 17:28:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:60776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727261AbgKPW2q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 17:28:46 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6247820E65;
        Mon, 16 Nov 2020 22:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605565725;
        bh=wgVD5Rr+OIUS1btMkuVPVWwVO6TnsdHQGmCoBrZ3Rmk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2EgzxiDAXoKy6HvwRadOB9eXZPBm/IGt3jChEC0xvZ08oT17lASlJ8f8xHLQxkFi3
         uTud170siLORhiw9fAOmpWLqpojHejRipk7XGOJvcLs4leffcHMcaLPucAllE+THVb
         pMxInDeJFWR4l9pUn1W/qpXcVC2FlPF+93WnQTyI=
Date:   Mon, 16 Nov 2020 14:28:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, razor@blackwall.org, jeremy@azazel.net
Subject: Re: [PATCH net-next,v3 0/9] netfilter: flowtable bridge and vlan
 enhancements
Message-ID: <20201116142844.7c492fb6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201116221815.GA6682@salvia>
References: <20201111193737.1793-1-pablo@netfilter.org>
        <20201113175556.25e57856@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201114115906.GA21025@salvia>
        <87sg9cjaxo.fsf@waldekranz.com>
        <20201114090347.2e7c1457@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201116221815.GA6682@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 23:18:15 +0100 Pablo Neira Ayuso wrote:
> On Sat, Nov 14, 2020 at 09:03:47AM -0800, Jakub Kicinski wrote:
> > On Sat, 14 Nov 2020 15:00:03 +0100 Tobias Waldekranz wrote:  
> > > On Sat, Nov 14, 2020 at 12:59, Pablo Neira Ayuso <pablo@netfilter.org> wrote:  
> > > > If any of the flowtable device goes down / removed, the entries are
> > > > removed from the flowtable. This means packets of existing flows are
> > > > pushed up back to classic bridge / forwarding path to re-evaluate the
> > > > fast path.
> > > >
> > > > For each new flow, the fast path that is selected freshly, so they use
> > > > the up-to-date FDB to select a new bridge port.
> > > >
> > > > Existing flows still follow the old path. The same happens with FIB
> > > > currently.
> > > >
> > > > It should be possible to explore purging entries in the flowtable that
> > > > are stale due to changes in the topology (either in FDB or FIB).
> > > >
> > > > What scenario do you have specifically in mind? Something like VM
> > > > migrates from one bridge port to another?    
> > 
> > Indeed, 2 VMs A and B, talking to each other, A is _outside_ the
> > system (reachable via eth0), B is inside (veth1). When A moves inside
> > and gets its veth. Neither B's veth1 not eth0 will change state, so
> > cache wouldn't get flushed, right?  
> 
> The flow tuple includes the input interface as part of the hash key,
> so packets will not match the existing entries in the flowtable after
> the topology update. 

To be clear - the input interface for B -> A traffic remains B.
So if B was talking to A before A moved it will keep hitting 
the cached entry.

Are you saying A -> B traffic won't match so it will update the cache,
since conntrack flows are bi-directional?

> The stale flow entries are removed after 30 seconds
> if no matching packets are seen. New flow entries will be created for
> the new topology, a few packets have to go through the classic
> forwarding path so the new flow entries that represent the flow in the
> new topology are created.
