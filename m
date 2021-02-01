Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D24330AB39
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 16:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhBAP06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 10:26:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbhBAP0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 10:26:16 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB84EC061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 07:25:35 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1l6b54-0002Rc-DY; Mon, 01 Feb 2021 16:25:34 +0100
Date:   Mon, 1 Feb 2021 16:25:34 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Roi Dayan <roid@nvidia.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>
Subject: Re: [PATCH net 1/1] netfilter: conntrack: Check offload bit on table
 dump
Message-ID: <20210201152534.GJ12443@breakpoint.cc>
References: <20210128074052.777999-1-roid@nvidia.com>
 <20210130120114.GA7846@salvia>
 <3a29e9b5-7bf8-5c00-3ede-738f9b4725bf@nvidia.com>
 <997cbda4-acd1-a000-1408-269bc5c3abf3@nvidia.com>
 <20210201030853.GA19878@salvia>
 <1229b966-7772-44bd-6e91-fbde213ceb2d@nvidia.com>
 <20210201115036.GB12443@breakpoint.cc>
 <edb8da93-d859-e7ae-53dd-cae09dff2eba@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <edb8da93-d859-e7ae-53dd-cae09dff2eba@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Roi Dayan <roid@nvidia.com> wrote:
> > TCP initial timeout is one minute, UDP 30 seconds.
> > That should surely be enough to do flow_offload_add (which extends
> > the timeout)?
> 
> Yes, flow_offload_add() extends the timeout. but it needs to finish.
> 
> > 
> > Maybe something is doing flow_offload_add() for unconfirmed conntrack?
> > 
> > In unconfirmed conntrack case, ct->timeout is absolute timeout value, e.g. for
> > tcp it will be set to 60 * HZ.
> 
> When I hit the issue I printed jiffies and ct->timeout and saw they are
> the same or very close but not an absolute number.

Thats strange, for new flows they should not be close at all.
UDP sets a 30 second timeout, TCP sets a 60 second initial timeout.

Do you think rhashtable_insert_fast() in flow_offload_add() blocks for
dozens of seconds?

Thats about the only thing I can see between 'offload bit gets set'
and 'timeout is extended' in flow_offload_add() that could at least
spend *some* time.

> We hit this issue before more easily and pushed this fix
>
> 4203b19c2796 netfilter: flowtable: Set offload timeout when adding flow

This fix makes sense to me.
