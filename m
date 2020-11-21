Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93AB42BC1A3
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 19:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgKUS41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 13:56:27 -0500
Received: from correo.us.es ([193.147.175.20]:60056 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726305AbgKUS41 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 13:56:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B13B8160A2E
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 19:56:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A3164DA73F
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 19:56:24 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 899B5DA792; Sat, 21 Nov 2020 19:56:24 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3EDB6DA78B;
        Sat, 21 Nov 2020 19:56:22 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 21 Nov 2020 19:56:22 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1902E4265A5A;
        Sat, 21 Nov 2020 19:56:22 +0100 (CET)
Date:   Sat, 21 Nov 2020 19:56:21 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, razor@blackwall.org, jeremy@azazel.net
Subject: Re: [PATCH net-next,v3 0/9] netfilter: flowtable bridge and vlan
 enhancements
Message-ID: <20201121185621.GA23017@salvia>
References: <20201114115906.GA21025@salvia>
 <87sg9cjaxo.fsf@waldekranz.com>
 <20201114090347.2e7c1457@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116221815.GA6682@salvia>
 <20201116142844.7c492fb6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116223615.GA6967@salvia>
 <20201116144521.771da0c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116225658.GA7247@salvia>
 <20201121123138.GA21560@salvia>
 <20201121101551.3264c5fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201121101551.3264c5fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 21, 2020 at 10:15:51AM -0800, Jakub Kicinski wrote:
> On Sat, 21 Nov 2020 13:31:38 +0100 Pablo Neira Ayuso wrote:
> > On Mon, Nov 16, 2020 at 11:56:58PM +0100, Pablo Neira Ayuso wrote:
> > > On Mon, Nov 16, 2020 at 02:45:21PM -0800, Jakub Kicinski wrote:  
> > > > On Mon, 16 Nov 2020 23:36:15 +0100 Pablo Neira Ayuso wrote:  
[...]
> > I have been discussing the topology update by tracking fdb updates
> > with the bridge maintainer, I'll be exploring extensions to the
> > existing fdb_notify() infrastructure to deal with this scenario you
> > describe. On my side this topology update scenario is not a priority
> > to be supported in this patchset, but it's feasible to support it
> > later on.
> 
> My concern is that invalidation is _the_ hard part of creating caches.
> And I feel like merging this as is would be setting our standards pretty
> low. 

Interesting, let's summarize a bit to make sure we're on the same
page:

- This "cache" is optional, you enable it on demand through ruleset.
- This "cache" is configurable, you can specify through ruleset policy
  what policies get into the cache and _when_ they are placed in the
  cache.
- This is not affecting any existing default configuration, neither
  Linux networking not even classic path Netfilter configurations,
  it's a rather new thing.
- This is showing performance improvement of ~50% with a very simple
  testbed. With pktgen, back few years ago I was reaching x2.5
  performance boost in software in a pktgen testbed.
- This is adding minimal changes to netdev_ops, just a single
  callback.

For the live VM migration you describe, connections might time out,
but there are many use-cases where this is still valid, some of them
has been described already here.

> Please gather some review tags from senior netdev developers. I don't
> feel confident enough to apply this as 100% my own decision.

Fair enough.

This requirement for very specific Netfilter infrastructure which does
not affect any other Networking subsystem sounds new to me.

What senior developers specifically you would like I should poke to
get an acknowledgement on this to get this accepted of your
preference?

Thank you.
