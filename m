Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 761282B5472
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 23:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbgKPWgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 17:36:21 -0500
Received: from correo.us.es ([193.147.175.20]:51784 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726306AbgKPWgU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 17:36:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B7326DED2A
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 23:36:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A4C6BDA850
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 23:36:18 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9A36FDA840; Mon, 16 Nov 2020 23:36:18 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 69D51DA704;
        Mon, 16 Nov 2020 23:36:16 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 16 Nov 2020 23:36:16 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4A4954265A5A;
        Mon, 16 Nov 2020 23:36:16 +0100 (CET)
Date:   Mon, 16 Nov 2020 23:36:15 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, razor@blackwall.org, jeremy@azazel.net
Subject: Re: [PATCH net-next,v3 0/9] netfilter: flowtable bridge and vlan
 enhancements
Message-ID: <20201116223615.GA6967@salvia>
References: <20201111193737.1793-1-pablo@netfilter.org>
 <20201113175556.25e57856@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201114115906.GA21025@salvia>
 <87sg9cjaxo.fsf@waldekranz.com>
 <20201114090347.2e7c1457@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116221815.GA6682@salvia>
 <20201116142844.7c492fb6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201116142844.7c492fb6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 02:28:44PM -0800, Jakub Kicinski wrote:
> On Mon, 16 Nov 2020 23:18:15 +0100 Pablo Neira Ayuso wrote:
> > On Sat, Nov 14, 2020 at 09:03:47AM -0800, Jakub Kicinski wrote:
> > > On Sat, 14 Nov 2020 15:00:03 +0100 Tobias Waldekranz wrote:  
> > > > On Sat, Nov 14, 2020 at 12:59, Pablo Neira Ayuso <pablo@netfilter.org> wrote:  
> > > > > If any of the flowtable device goes down / removed, the entries are
> > > > > removed from the flowtable. This means packets of existing flows are
> > > > > pushed up back to classic bridge / forwarding path to re-evaluate the
> > > > > fast path.
> > > > >
> > > > > For each new flow, the fast path that is selected freshly, so they use
> > > > > the up-to-date FDB to select a new bridge port.
> > > > >
> > > > > Existing flows still follow the old path. The same happens with FIB
> > > > > currently.
> > > > >
> > > > > It should be possible to explore purging entries in the flowtable that
> > > > > are stale due to changes in the topology (either in FDB or FIB).
> > > > >
> > > > > What scenario do you have specifically in mind? Something like VM
> > > > > migrates from one bridge port to another?    
> > > 
> > > Indeed, 2 VMs A and B, talking to each other, A is _outside_ the
> > > system (reachable via eth0), B is inside (veth1). When A moves inside
> > > and gets its veth. Neither B's veth1 not eth0 will change state, so
> > > cache wouldn't get flushed, right?  
> > 
> > The flow tuple includes the input interface as part of the hash key,
> > so packets will not match the existing entries in the flowtable after
> > the topology update. 
> 
> To be clear - the input interface for B -> A traffic remains B.
> So if B was talking to A before A moved it will keep hitting 
> the cached entry.

Yes, Traffic for B -> A still hits the cached entry.

> Are you saying A -> B traffic won't match so it will update the cache,
> since conntrack flows are bi-directional?

Yes, Traffic for A -> B won't match the flowtable entry, this will
update the cache.
