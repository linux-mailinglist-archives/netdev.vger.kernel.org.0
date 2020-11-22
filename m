Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047C52BC562
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 12:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbgKVLdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 06:33:25 -0500
Received: from correo.us.es ([193.147.175.20]:59186 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727373AbgKVLdZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Nov 2020 06:33:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B5F5953D26E
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 12:33:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A40B9DA4D4
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 12:33:23 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 99939DA4C8; Sun, 22 Nov 2020 12:33:23 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 64EC6DA73F;
        Sun, 22 Nov 2020 12:33:21 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 22 Nov 2020 12:33:21 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4860F4265A5A;
        Sun, 22 Nov 2020 12:33:21 +0100 (CET)
Date:   Sun, 22 Nov 2020 12:33:20 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, razor@blackwall.org, jeremy@azazel.net
Subject: Re: [PATCH net-next,v3 0/9] netfilter: flowtable bridge and vlan
 enhancements
Message-ID: <20201122113320.GC26512@salvia>
References: <20201114090347.2e7c1457@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116221815.GA6682@salvia>
 <20201116142844.7c492fb6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116223615.GA6967@salvia>
 <20201116144521.771da0c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116225658.GA7247@salvia>
 <20201121123138.GA21560@salvia>
 <20201121101551.3264c5fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201121185621.GA23017@salvia>
 <20201121112348.0e25afa3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201121112348.0e25afa3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Sat, Nov 21, 2020 at 11:23:48AM -0800, Jakub Kicinski wrote:
> On Sat, 21 Nov 2020 19:56:21 +0100 Pablo Neira Ayuso wrote:
> > > Please gather some review tags from senior netdev developers. I don't
> > > feel confident enough to apply this as 100% my own decision.  
> > 
> > Fair enough.
> > 
> > This requirement for very specific Netfilter infrastructure which does
> > not affect any other Networking subsystem sounds new to me.
> 
> You mean me asking for reviews from other senior folks when I don't
> feel good about some code? I've asked others the same thing in the
> past, e.g. Paolo for his RPS thing.

No, I'm perfectly fine with peer review.

Note that I am sending this to net-next as a patchset (not as a PR)
_only_ because this is adding a new .ndo_fill_forward_path to
netdev_ops.

That's the only thing that is relevant to the Netdev core
infrastructure IMO, and this new .ndo that is private, not exposed to
userspace.

Let's have a look at the diffstats again:

 include/linux/netdevice.h                     |  35 +++
 include/net/netfilter/nf_flow_table.h         |  43 +++-
 net/8021q/vlan_dev.c                          |  15 ++
 net/bridge/br_device.c                        |  27 +++
 net/core/dev.c                                |  46 ++++
 net/netfilter/nf_flow_table_core.c            |  51 +++--
 net/netfilter/nf_flow_table_ip.c              | 200 ++++++++++++++----
 net/netfilter/nft_flow_offload.c              | 159 +++++++++++++-
 .../selftests/netfilter/nft_flowtable.sh      |  82 +++++++
 9 files changed, 598 insertions(+), 60 deletions(-)

So this is adding _minimal_ changes to the NetDev infrastructure. Most
of the code is an extension to the flowtable Netfilter infrastructure.
And the flowtable is a cache since its conception.

I am adding the .ndo indirection to avoid the dependencies with
Netfilter modules, e.g. Netfilter could use direct reference to bridge
function, but that would pull in bridge modules.

> > What senior developers specifically you would like I should poke to
> > get an acknowledgement on this to get this accepted of your
> > preference?
> 
> I don't want to make a list. Maybe netconf attendees are a safe bet?

I have no idea who to ask to, traditionally it's the NetDev maintainer
(AFAIK it's only you at this stage) that have the last word on
something to get this merged.

I consider all developers that have reviewed this patchset to be
senior developers.
