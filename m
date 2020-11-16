Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0772B5466
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 23:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730282AbgKPWbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 17:31:20 -0500
Received: from correo.us.es ([193.147.175.20]:50950 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730140AbgKPWbS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 17:31:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2C94DDED2A
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 23:31:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1998ADA72F
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 23:31:17 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0F065DA73F; Mon, 16 Nov 2020 23:31:17 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D12E3DA72F;
        Mon, 16 Nov 2020 23:31:14 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 16 Nov 2020 23:31:14 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B3FE14265A5A;
        Mon, 16 Nov 2020 23:31:14 +0100 (CET)
Date:   Mon, 16 Nov 2020 23:31:14 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, razor@blackwall.org,
        jeremy@azazel.net
Subject: Re: [PATCH net-next,v3 0/9] netfilter: flowtable bridge and vlan
 enhancements
Message-ID: <20201116223114.GA6905@salvia>
References: <20201111193737.1793-1-pablo@netfilter.org>
 <20201113175556.25e57856@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201114115906.GA21025@salvia>
 <87sg9cjaxo.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87sg9cjaxo.fsf@waldekranz.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 14, 2020 at 03:00:03PM +0100, Tobias Waldekranz wrote:
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
> 
> This should work in the case when the bridge ports are normal NICs or
> switchdev ports, right?

Yes.

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

Yes, watching the FDB should allow to clean up stale flows immediately.
