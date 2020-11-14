Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138D22B2EBA
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 18:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbgKNRDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 12:03:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:36110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbgKNRDv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 12:03:51 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7DAF223FD;
        Sat, 14 Nov 2020 17:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605373429;
        bh=pzU/753r2/Z0FkJrG7+Nvoa2z8DU/A2K1iWoWx955N0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bTA7AyOdTwek8wk1L1pvDTaS1swVG1Qk2sYRKirq8SjWhEW/Ke8n68NlEAmewJ41Y
         brLtzZ2wQf4MhFihaJClr21t4WhsKlkZQ6h08TZN3vu6Jf5r1DVEXrbuRC6Qi3TXnL
         3tRWOVVIWNOvnrm3j4/mB7FNjOrd6SrXSqRxGh6k=
Date:   Sat, 14 Nov 2020 09:03:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, razor@blackwall.org, jeremy@azazel.net
Subject: Re: [PATCH net-next,v3 0/9] netfilter: flowtable bridge and vlan
 enhancements
Message-ID: <20201114090347.2e7c1457@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87sg9cjaxo.fsf@waldekranz.com>
References: <20201111193737.1793-1-pablo@netfilter.org>
        <20201113175556.25e57856@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201114115906.GA21025@salvia>
        <87sg9cjaxo.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Nov 2020 15:00:03 +0100 Tobias Waldekranz wrote:
> On Sat, Nov 14, 2020 at 12:59, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > If any of the flowtable device goes down / removed, the entries are
> > removed from the flowtable. This means packets of existing flows are
> > pushed up back to classic bridge / forwarding path to re-evaluate the
> > fast path.
> >
> > For each new flow, the fast path that is selected freshly, so they use
> > the up-to-date FDB to select a new bridge port.
> >
> > Existing flows still follow the old path. The same happens with FIB
> > currently.
> >
> > It should be possible to explore purging entries in the flowtable that
> > are stale due to changes in the topology (either in FDB or FIB).
> >
> > What scenario do you have specifically in mind? Something like VM
> > migrates from one bridge port to another?  

Indeed, 2 VMs A and B, talking to each other, A is _outside_ the
system (reachable via eth0), B is inside (veth1). When A moves inside
and gets its veth. Neither B's veth1 not eth0 will change state, so
cache wouldn't get flushed, right?

> This should work in the case when the bridge ports are normal NICs or
> switchdev ports, right?
> 
> In that case, relying on link state is brittle as you can easily have a
> switch or a media converter between the bridge and the end-station:
> 
>         br0                  br0
>         / \                  / \
>     eth0   eth1          eth0   eth1
>      /      \      =>     /      \
>   [sw0]     [sw1]      [sw0]     [sw1]
>    /          \         /          \
>   A                                 A
> 
> In a scenario like this, A has clearly moved. But neither eth0 nor eth1
> has seen any changes in link state.
> 
> This particular example is a bit contrived. But this is essentially what
> happens in redundant topologies when reconfigurations occur (e.g. STP).
> 
> These protocols will typically signal reconfigurations to all bridges
> though, so as long as the affected flows are flushed at the same time as
> the FDB it should work.
> 
> Interesting stuff!

Agreed, could be interesting for all NAT/conntrack setups, not just VMs.
