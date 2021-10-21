Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F347435BD3
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 09:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhJUHjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 03:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbhJUHjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 03:39:08 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5860BC06161C;
        Thu, 21 Oct 2021 00:36:53 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mdScj-0007At-Jb; Thu, 21 Oct 2021 09:36:25 +0200
Date:   Thu, 21 Oct 2021 09:36:25 +0200
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
Message-ID: <20211021073625.GE7604@breakpoint.cc>
References: <20211019144655.3483197-1-maximmi@nvidia.com>
 <20211019144655.3483197-8-maximmi@nvidia.com>
 <20211020035622.lgrxnrwfeak2e75a@apollo.localdomain>
 <20211020092844.GI28644@breakpoint.cc>
 <87h7dcf2n4.fsf@toke.dk>
 <20211020095815.GJ28644@breakpoint.cc>
 <875ytrga3p.fsf@toke.dk>
 <20211020124457.GA7604@breakpoint.cc>
 <87r1cfe7sx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87r1cfe7sx.fsf@toke.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> Florian Westphal <fw@strlen.de> writes:
> 
> > Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> >> > Lookups should be fine.  Insertions are the problem.
> >> >
> >> > NAT hooks are expected to execute before the insertion into the
> >> > conntrack table.
> >> >
> >> > If you insert before, NAT hooks won't execute, i.e.
> >> > rules that use dnat/redirect/masquerade have no effect.
> >> 
> >> Well yes, if you insert the wrong state into the conntrack table, you're
> >> going to get wrong behaviour. That's sorta expected, there are lots of
> >> things XDP can do to disrupt the packet flow (like just dropping the
> >> packets :)).
> >
> > Sure, but I'm not sure I understand the use case.
> >
> > Insertion at XDP layer turns off netfilters NAT capability, so its
> > incompatible with the classic forwarding path.
> >
> > If thats fine, why do you need to insert into the conntrack table to
> > begin with?  The entire infrastructure its designed for is disabled...
> 
> One of the major selling points of XDP is that you can reuse the
> existing kernel infrastructure instead of having to roll your own. So
> sure, one could implement their own conntrack using BPF maps (as indeed,
> e.g., Cilium has done), but why do that when you can take advantage of
> the existing one in the kernel? Same reason we have the bpf_fib_lookup()
> helper...

Insertion to conntrack via ebpf seems to be bad to me precisely because it
bypasses the existing infra.

In the bypass scenario you're envisioning, who is responsible for
fastpath-or-not decision?

> > In the HW offload case, conntrack is bypassed completely. There is an
> > IPS_(HW)_OFFLOAD_BIT that prevents the flow from expiring.
> 
> That's comparable in execution semantics (stack is bypassed entirely),
> but not in control plane semantics (we lookup from XDP instead of
> pushing flows down to an offload).

I'm not following.  As soon as you do insertion via XDP existing
control plane (*tables ruleset, xfrm and so on) becomes irrelevant.

Say e.g. user has a iptables ruleset that disables conntrack for udp dport
53 to avoid conntrack overhead for local resolver cache.

No longer relevant, ebpf overrides or whatever generates the epbf prog
needs to emulate existing config.

> > I suspect we'd want a way to notify/call an ebpf program instead so we
> > can avoid the ctnetlink -> userspace -> update dance and do the XDP
> > 'flow bypass information update' from inside the kernel and ebpf/XDP
> > reimplementation of the nf flow table (it uses the netfilter ingress
> > hook on the configured devices; everyhing it does should be doable
> > from XDP).
> 
> But the point is exactly that we don't have to duplicate the state into
> BPF, we can make XDP look it up directly.

Normally for fast bypass I'd expect that the bypass infra would want to
access all info in one lookup, but conntrack only gives you the NAT
transformation, so you'll also need a sk lookup and possibly a FIB
lookup later to get the route.
Also maybe an xfrm lookup as well if your bypass infra needs to support
ipsec.

So I neither understand the need for conntrack lookup (*for fast bypass use
case*) nor the need for insert IFF the control plane we have is to be
respected.
