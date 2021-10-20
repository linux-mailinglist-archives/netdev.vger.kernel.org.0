Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B49434B88
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 14:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbhJTMsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 08:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbhJTMsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 08:48:14 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71144C06177C;
        Wed, 20 Oct 2021 05:45:14 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mdAxl-0002e4-9A; Wed, 20 Oct 2021 14:44:57 +0200
Date:   Wed, 20 Oct 2021 14:44:57 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Toke =?iso-8859-15?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Brendan Jackman <jackmanb@google.com>,
        Florent Revest <revest@chromium.org>,
        Joe Stringer <joe@cilium.io>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH bpf-next 07/10] bpf: Add helpers to query conntrack info
Message-ID: <20211020124457.GA7604@breakpoint.cc>
References: <20211019144655.3483197-1-maximmi@nvidia.com>
 <20211019144655.3483197-8-maximmi@nvidia.com>
 <20211020035622.lgrxnrwfeak2e75a@apollo.localdomain>
 <20211020092844.GI28644@breakpoint.cc>
 <87h7dcf2n4.fsf@toke.dk>
 <20211020095815.GJ28644@breakpoint.cc>
 <875ytrga3p.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <875ytrga3p.fsf@toke.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> > Lookups should be fine.  Insertions are the problem.
> >
> > NAT hooks are expected to execute before the insertion into the
> > conntrack table.
> >
> > If you insert before, NAT hooks won't execute, i.e.
> > rules that use dnat/redirect/masquerade have no effect.
> 
> Well yes, if you insert the wrong state into the conntrack table, you're
> going to get wrong behaviour. That's sorta expected, there are lots of
> things XDP can do to disrupt the packet flow (like just dropping the
> packets :)).

Sure, but I'm not sure I understand the use case.

Insertion at XDP layer turns off netfilters NAT capability, so its
incompatible with the classic forwarding path.

If thats fine, why do you need to insert into the conntrack table to
begin with?  The entire infrastructure its designed for is disabled...

> > I don't think there is anything that stands in the way of replicating
> > this via XDP.
> 
> What I want to be able to do is write an XDP program that does the following:
> 
> 1. Parse the packet header and determine if it's a packet type we know
>    how to handle. If not, just return XDP_PASS and let the stack deal
>    with corner cases.
> 
> 2. If we know how to handle the packet (say, it's TCP or UDP), do a
>    lookup into conntrack to figure out if there's state for it and we
>    need to do things like NAT.
> 
> 3. If we need to NAT, rewrite the packet based on the information we got
>    back from conntrack.

You could already do that by storing that info in bpf maps
The ctnetlink event generated on conntrack insertion contains the NAT
mapping information, so you could have a userspace daemon that
intercepts those to update the map.

> 4. Update the conntrack state to be consistent with the packet, and then
>    redirect it out the destination interface.
> 
> I.e., in the common case the packet doesn't go through the stack at all;
> but we need to make conntrack aware that we processed the packet so the
> entry doesn't expire (and any state related to the flow gets updated).

In the HW offload case, conntrack is bypassed completely. There is an
IPS_(HW)_OFFLOAD_BIT that prevents the flow from expiring.

> Ideally we should also be able to create new state for a flow we haven't
> seen before.

The way HW offload was intended to work is to allow users to express
what flows should be offloaded via 'flow add' expression in nftables, so
they can e.g. use byte counters or rate estimators etc. to make such
a decision.  So initial packet always passes via normal stack.

This is also needed to consider e.g. XFRM -- nft_flow_offload.c won't
offload if the packet has a secpath attached (i.e., will get encrypted
later).

I suspect we'd want a way to notify/call an ebpf program instead so we
can avoid the ctnetlink -> userspace -> update dance and do the XDP
'flow bypass information update' from inside the kernel and ebpf/XDP
reimplementation of the nf flow table (it uses the netfilter ingress
hook on the configured devices; everyhing it does should be doable
from XDP).

> This requires updating of state, but I see no reason why this shouldn't
> be possible?

Updating ct->status is problematic, there would have to be extra checks
that prevent non-atomic writes and toggling of special bits such as
CONFIRMED, TEMPLATE or DYING.  Adding a helper to toggle something
specific, e.g. the offload state bit, should be okay.
