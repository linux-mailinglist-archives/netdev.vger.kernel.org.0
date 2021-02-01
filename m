Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B38F30A6DE
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 12:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbhBALv2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 1 Feb 2021 06:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbhBALvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 06:51:19 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15AAC061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 03:50:38 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1l6Xj2-0001Fv-Vc; Mon, 01 Feb 2021 12:50:37 +0100
Date:   Mon, 1 Feb 2021 12:50:36 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Roi Dayan <roid@nvidia.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, netdev@vger.kernel.org,
        Paul Blakey <paulb@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        fw@strlen.de
Subject: Re: [PATCH net 1/1] netfilter: conntrack: Check offload bit on table
 dump
Message-ID: <20210201115036.GB12443@breakpoint.cc>
References: <20210128074052.777999-1-roid@nvidia.com>
 <20210130120114.GA7846@salvia>
 <3a29e9b5-7bf8-5c00-3ede-738f9b4725bf@nvidia.com>
 <997cbda4-acd1-a000-1408-269bc5c3abf3@nvidia.com>
 <20210201030853.GA19878@salvia>
 <1229b966-7772-44bd-6e91-fbde213ceb2d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1229b966-7772-44bd-6e91-fbde213ceb2d@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Roi Dayan <roid@nvidia.com> wrote:
> > > There is a 3rd caller nf_ct_gc_expired() which being called by 3
> > > other callers:
> > > ____nf_conntrack_find()
> > > nf_conntrack_tuple_taken()
> > > early_drop_list()
> > 
> > Hm. I'm not sure yet what path is triggering this bug.
> > 
> > Florian came up with the idea of setting a very large timeout for
> > offloaded flows (that are refreshed by the garbage collector) to avoid
> > the extra check from the packet path, so those 3 functions above never
> > hit the garbage collection path. This also applies for the ctnetlink
> > (conntrack -L) and the /proc/net/nf_conntrack sysctl paths that the
> > patch describes, those should not ever see an offloaded flow with a
> > small timeout.
> > 
> > nf_ct_offload_timeout() is called from:
> > 
> > #1 flow_offload_add() to set a very large timer.
> > #2 the garbage collector path, to refresh the timeout the very large
> >     offload timer.
> > 
> > Probably there is a race between setting the IPS_OFFLOAD and when
> > flow_offload_add() is called? Garbage collector gets in between and
> > zaps the connection. Is a newly offloaded connection that you observed
> > that is being removed?
> > 
> 
> yes. the flows being removed are newly offloaded connections.

If they are new, how can they be timed out already?

TCP initial timeout is one minute, UDP 30 seconds.
That should surely be enough to do flow_offload_add (which extends
the timeout)?

Maybe something is doing flow_offload_add() for unconfirmed conntrack?

In unconfirmed conntrack case, ct->timeout is absolute timeout value, e.g. for
tcp it will be set to 60 * HZ.

conntrack confirmation adds jiffies32 to it to make it relative
to current time (this is before insertion into the conntrack table,
so GC isn't supposed to happen before this).

In any case adding test for the offload bit seems to be papering over
invalid/broken ct->timeout value.
