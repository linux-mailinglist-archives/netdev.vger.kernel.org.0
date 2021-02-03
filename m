Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B33630DA3D
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 13:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbhBCMxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 07:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbhBCMuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 07:50:54 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C744C061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 04:50:38 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1l7HcB-00046G-HP; Wed, 03 Feb 2021 13:50:35 +0100
Date:   Wed, 3 Feb 2021 13:50:35 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Roi Dayan <roid@nvidia.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>
Subject: Re: [PATCH net 1/1] netfilter: conntrack: Check offload bit on table
 dump
Message-ID: <20210203125035.GC16570@breakpoint.cc>
References: <20210128074052.777999-1-roid@nvidia.com>
 <20210130120114.GA7846@salvia>
 <3a29e9b5-7bf8-5c00-3ede-738f9b4725bf@nvidia.com>
 <997cbda4-acd1-a000-1408-269bc5c3abf3@nvidia.com>
 <20210201030853.GA19878@salvia>
 <1229b966-7772-44bd-6e91-fbde213ceb2d@nvidia.com>
 <20210201115036.GB12443@breakpoint.cc>
 <edb8da93-d859-e7ae-53dd-cae09dff2eba@nvidia.com>
 <20210201152534.GJ12443@breakpoint.cc>
 <a908ac8f-1fb4-1427-520d-3a702ecb7597@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a908ac8f-1fb4-1427-520d-3a702ecb7597@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Roi Dayan <roid@nvidia.com> wrote:
> > Do you think rhashtable_insert_fast() in flow_offload_add() blocks for
> > dozens of seconds?
> 
> I'm not sure. but its not only that but also the time to be in
> established state as only then we offload.

That makes it even more weird.  Timeout for established is even larger.
In case of TCP, its days... so I don't understand at all :/

> > Thats about the only thing I can see between 'offload bit gets set'
> > and 'timeout is extended' in flow_offload_add() that could at least
> > spend *some* time.
> > 
> > > We hit this issue before more easily and pushed this fix
> > > 
> > > 4203b19c2796 netfilter: flowtable: Set offload timeout when adding flow
> > 
> > This fix makes sense to me.
> 
> I just noted we didn't test correctly Pablo's suggestion instead of
> to check the bit and extend the timeout in ctnetlink_dump_table() and
> ct_seq_show() like GC does.

Ok.  Extending it there makes sense, but I still don't understand
why newly offloaded flows hit this problem.

Flow offload should never see a 'about to expire' ct entry.
The 'extend timeout from gc' is more to make sure GC doesn't reap
long-lived entries that have been offloaded aeons ago, not 'prevent
new flows from getting zapped...'
