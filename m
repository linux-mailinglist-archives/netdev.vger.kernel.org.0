Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7B42B2CF8
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 13:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgKNL7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 06:59:12 -0500
Received: from correo.us.es ([193.147.175.20]:40964 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726356AbgKNL7L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 06:59:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BB0F5FFBA1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 12:59:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AE1CCDA78F
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 12:59:08 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A3329DA78B; Sat, 14 Nov 2020 12:59:08 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6EC7DDA704;
        Sat, 14 Nov 2020 12:59:06 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 14 Nov 2020 12:59:06 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5113642EFB80;
        Sat, 14 Nov 2020 12:59:06 +0100 (CET)
Date:   Sat, 14 Nov 2020 12:59:06 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, razor@blackwall.org, jeremy@azazel.net
Subject: Re: [PATCH net-next,v3 0/9] netfilter: flowtable bridge and vlan
 enhancements
Message-ID: <20201114115906.GA21025@salvia>
References: <20201111193737.1793-1-pablo@netfilter.org>
 <20201113175556.25e57856@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201113175556.25e57856@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 05:55:56PM -0800, Jakub Kicinski wrote:
> On Wed, 11 Nov 2020 20:37:28 +0100 Pablo Neira Ayuso wrote:
> > The following patchset augments the Netfilter flowtable fastpath [1] to
> > support for network topologies that combine IP forwarding, bridge and
> > VLAN devices.
> > 
> > A typical scenario that can benefit from this infrastructure is composed
> > of several VMs connected to bridge ports where the bridge master device
> > 'br0' has an IP address. A DHCP server is also assumed to be running to
> > provide connectivity to the VMs. The VMs reach the Internet through
> > 'br0' as default gateway, which makes the packet enter the IP forwarding
> > path. Then, netfilter is used to NAT the packets before they leave
> > through the wan device.
> > 
> > Something like this:
> > 
> >                        fast path
> >                 .------------------------.
> >                /                          \
> >                |           IP forwarding   |
> >                |          /             \  .
> >                |       br0               eth0
> >                .       / \
> >                -- veth1  veth2
> >                    .
> >                    .
> >                    .
> >                  eth0
> >            ab:cd:ef:ab:cd:ef
> >                   VM
> > 
> > The idea is to accelerate forwarding by building a fast path that takes
> > packets from the ingress path of the bridge port and place them in the
> > egress path of the wan device (and vice versa). Hence, skipping the
> > classic bridge and IP stack paths.
> 
> The problem that immediately comes to mind is that if there is any
> dynamic forwarding state the cache you're creating would need to be
> flushed when FDB changes. Are you expecting users would plug into the
> flowtable devices where they know things are fairly static?

If any of the flowtable device goes down / removed, the entries are
removed from the flowtable. This means packets of existing flows are
pushed up back to classic bridge / forwarding path to re-evaluate the
fast path.

For each new flow, the fast path that is selected freshly, so they use
the up-to-date FDB to select a new bridge port.

Existing flows still follow the old path. The same happens with FIB
currently.

It should be possible to explore purging entries in the flowtable that
are stale due to changes in the topology (either in FDB or FIB).

What scenario do you have specifically in mind? Something like VM
migrates from one bridge port to another?

Thank you.
