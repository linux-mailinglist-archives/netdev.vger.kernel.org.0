Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39D5718C678
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 05:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgCTE3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 00:29:16 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33714 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgCTE3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 00:29:16 -0400
Received: by mail-wm1-f66.google.com with SMTP id r7so6306667wmg.0;
        Thu, 19 Mar 2020 21:29:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aOnZYrbtwM/KacLVxpJ0erdvUD+ggrAoZ17IQn52GEw=;
        b=Y26Cx+Bf+jQ4z0IMy9KyRxznh/aJIHWZVPg8f8bIWRUjOFdcDG6deTSAGwEnorQ1u0
         1pTxLPbK2oqKluCmlwy4xC7JTR0vn/jxaqWq+giOHc6n0xkaF2agIuaOVOXSXCfBta4h
         fORQXHyeYuSnnQFXdvkQ7zZUOJxF2Q7wnuxrRdqeqOtgiftVfBDRz3GrT84sFbCtRP1e
         /TaItAqmV79Jl7/hMdHvqbqg5+fxBJrctOf6tSLrM8MHJHJNLdK8lrKMkVu2xVQCn2kV
         lTDllhZdffaHcNl6RNGE7JaLsPVBH3FmREfyLwbX/p7TadzxHOfzOJQacZfj8dtDIpcZ
         vx7A==
X-Gm-Message-State: ANhLgQ1K2CFRZpZV7ritwqQ4WOHQa9+Q52lT4V62SxJ8Yq5mrNSFA+rR
        03V5I4yJnCH7tO9t2MWXsuCBKOGYVtU0wbPi2J2xfRFw
X-Google-Smtp-Source: ADFU+vsYkoU26QknZoSAbMIqLQRQAvsxdxFDEVMw+cIJlN9xGuNED7sBUD3TBpjUSGOAtC9CPwl6/WMGgW1XENw9u7c=
X-Received: by 2002:a1c:acc8:: with SMTP id v191mr7971900wme.185.1584678552706;
 Thu, 19 Mar 2020 21:29:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200312233648.1767-1-joe@wand.net.nz> <20200312233648.1767-4-joe@wand.net.nz>
 <20200316225729.kd4hmz3oco5l7vn4@kafai-mbp> <CAOftzPgsVOqCLZatjytBXdQxH-DqJxiycXWN2d4C_-BjR5v1Kw@mail.gmail.com>
 <20200317062623.y5v2hejgtdbvexnz@kafai-mbp> <CAOftzPjXexvng-+77b-4Yw0pEBHXchsNVwrx+h9vV+5XBQzy-g@mail.gmail.com>
 <20200318184852.vwzuc4esqemsn7gx@kafai-mbp> <CAOftzPivg9nxsvvcza7v8Q-pgqZb3wy5gT9U19eGoBtzVzPPmA@mail.gmail.com>
 <20200320015438.t4qguub2jd5lfqch@kafai-mbp>
In-Reply-To: <20200320015438.t4qguub2jd5lfqch@kafai-mbp>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Thu, 19 Mar 2020 21:28:49 -0700
Message-ID: <CAOftzPg+uZVNvpBHhBKcL3Dh7+PbezE2YPhYrNV5+2f8cf=oYw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/7] bpf: Add socket assign support
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Joe Stringer <joe@wand.net.nz>, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 6:55 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, Mar 18, 2020 at 11:24:11PM -0700, Joe Stringer wrote:
> > On Wed, Mar 18, 2020 at 11:49 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > On Tue, Mar 17, 2020 at 05:46:58PM -0700, Joe Stringer wrote:
> > > > On Mon, Mar 16, 2020 at 11:27 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > >
> > > > > On Mon, Mar 16, 2020 at 08:06:38PM -0700, Joe Stringer wrote:
> > > > > > On Mon, Mar 16, 2020 at 3:58 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > > > >
> > > > > > > On Thu, Mar 12, 2020 at 04:36:44PM -0700, Joe Stringer wrote:
> > > > > > > > Add support for TPROXY via a new bpf helper, bpf_sk_assign().
> > > > > > > >
> > > > > > > > This helper requires the BPF program to discover the socket via a call
> > > > > > > > to bpf_sk*_lookup_*(), then pass this socket to the new helper. The
> > > > > > > > helper takes its own reference to the socket in addition to any existing
> > > > > > > > reference that may or may not currently be obtained for the duration of
> > > > > > > > BPF processing. For the destination socket to receive the traffic, the
> > > > > > > > traffic must be routed towards that socket via local route, the socket
> > > > > > > I also missed where is the local route check in the patch.
> > > > > > > Is it implied by a sk can be found in bpf_sk*_lookup_*()?
> > > > > >
> > > > > > This is a requirement for traffic redirection, it's not enforced by
> > > > > > the patch. If the operator does not configure routing for the relevant
> > > > > > traffic to ensure that the traffic is delivered locally, then after
> > > > > > the eBPF program terminates, it will pass up through ip_rcv() and
> > > > > > friends and be subject to the whims of the routing table. (or
> > > > > > alternatively if the BPF program redirects somewhere else then this
> > > > > > reference will be dropped).
> > > > > >
> > > > > > Maybe there's a path to simplifying this configuration path in future
> > > > > > to loosen this requirement, but for now I've kept the series as
> > > > > > minimal as possible on that front.
> > > > > >
> > > > > > > [ ... ]
> > > > > > >
> > > > > > > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > > > > > > index cd0a532db4e7..bae0874289d8 100644
> > > > > > > > --- a/net/core/filter.c
> > > > > > > > +++ b/net/core/filter.c
> > > > > > > > @@ -5846,6 +5846,32 @@ static const struct bpf_func_proto bpf_tcp_gen_syncookie_proto = {
> > > > > > > >       .arg5_type      = ARG_CONST_SIZE,
> > > > > > > >  };
> > > > > > > >
> > > > > > > > +BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
> > > > > > > > +{
> > > > > > > > +     if (flags != 0)
> > > > > > > > +             return -EINVAL;
> > > > > > > > +     if (!skb_at_tc_ingress(skb))
> > > > > > > > +             return -EOPNOTSUPP;
> > > > > > > > +     if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
> > > > > > > > +             return -ENOENT;
> > > > > > > > +
> > > > > > > > +     skb_orphan(skb);
> > > > > > > > +     skb->sk = sk;
> > > > > > > sk is from the bpf_sk*_lookup_*() which does not consider
> > > > > > > the bpf_prog installed in SO_ATTACH_REUSEPORT_EBPF.
> > > > > > > However, the use-case is currently limited to sk inspection.
> > > > > > >
> > > > > > > It now supports selecting a particular sk to receive traffic.
> > > > > > > Any plan in supporting that?
> > > > > >
> > > > > > I think this is a general bpf_sk*_lookup_*() question, previous
> > > > > > discussion[0] settled on avoiding that complexity before a use case
> > > > > > arises, for both TC and XDP versions of these helpers; I still don't
> > > > > > have a specific use case in mind for such functionality. If we were to
> > > > > > do it, I would presume that the socket lookup caller would need to
> > > > > > pass a dedicated flag (supported at TC and likely not at XDP) to
> > > > > > communicate that SO_ATTACH_REUSEPORT_EBPF progs should be respected
> > > > > > and used to select the reuseport socket.
> > > > > It is more about the expectation on the existing SO_ATTACH_REUSEPORT_EBPF
> > > > > usecase.  It has been fine because SO_ATTACH_REUSEPORT_EBPF's bpf prog
> > > > > will still be run later (e.g. from tcp_v4_rcv) to decide which sk to
> > > > > recieve the skb.
> > > > >
> > > > > If the bpf@tc assigns a TCP_LISTEN sk in bpf_sk_assign(),
> > > > > will the SO_ATTACH_REUSEPORT_EBPF's bpf still be run later
> > > > > to make the final sk decision?
> > > >
> > > > I don't believe so, no:
> > > >
> > > > ip_local_deliver()
> > > > -> ...
> > > > -> ip_protocol_deliver_rcu()
> > > > -> tcp_v4_rcv()
> > > > -> __inet_lookup_skb()
> > > > -> skb_steal_sock(skb)
> > > >
> > > > But this will only affect you if you are running both the bpf@tc
> > > > program with sk_assign() and the reuseport BPF sock programs at the
> > > > same time.
> > > I don't think it is the right answer to ask the user to be careful and
> > > only use either bpf_sk_assign()@tc or bpf_prog@so_reuseport.
> >
> > Applying a restriction on reuseport sockets until we sort this out per
> > my other email should resolve this concern.
> >
> > > > This is why I link it back to the bpf_sk*_lookup_*()
> > > > functions: If the socket lookup in the initial step respects reuseport
> > > > BPF prog logic and returns the socket using the same logic, then the
> > > > packet will be directed to the socket you expect. Just like how
> > > > non-BPF reuseport would work with this series today.
> > > Changing bpf_sk*_lookup_*() is a way to solve it but I don't know what it
> > > may run into when recurring bpf_prog, i.e. running bpf@so-reuseport inside
> > > bpf@tc. That may need a closer look.
> >
> > Right, that's my initial concern as well.
> >
> > One alternative might be something like: in the helper implementation,
> > store some bit somewhere to say "we need to resolve the reuseport
> > later" and then when the TC BPF program returns, check this bit and if
> > reuseport is necessary, trigger the BPF program for it and fix up the
> > socket after-the-fact.
> skb_dst_is_sk_prefetch() could be that bit.  One major thing
> is that bpf@so_reuseport is currently run at the transport layer
> and expecting skb->data pointing to udp/tcp hdr.  The ideal
> place is to run it there.

My initial thought above was much simpler - just holding it long
enough to exit the current BPF program so we know that the tc@bpf
program terminates, then preparing & running the so_reuseport program.

> However, the skb_dst_is_sk_prefetch() bit
> is currently lost at ip[6]_rcv_core.

Yeah, I think this is tricky. Here's three paths I'm tracking right now:
* Loopback destination is already assigned to skb, so we wrap that
with the dst_sk_prefetch in sk_assign. We unwrap it again currently in
ip[6]_rcv_core, but if we retained it, we'd need to convince
ip[6]_rcv_finish_core() to respect the metadata dst, then convince
ip[6]_rcv_finish() to call the right receive destination function.
* In the connected case of patch #4 in this series, we wrap the
rx_dst. Needs similar treatment.
* In the regular initial packet case for non-loopback destination, we
don't actually have a destination yet so the routing check would need
to track this bit and ensure it's propagated through that routing
check and again back out to ip[6]_rcv_finish() and call the right
destination receive.

Even if we get through all of that and we get up to the transport
layer, one of the main points of this feature is to guide the packet
to a socket that may be associated with a different tuple, so AFAIK we
end up needing another path even up at the transport layer to check
this bit and jump straight to the reuseport_select_sock() call.
Looking at __udp4_lib_rcv() path I'm eyeing the conditional branch
after stealing the socket, in there we'd need more special casing for
the new call to select the reuseport socket.

Following that rabbit-hole, it seems less invasive to either get the
exact right reuseport socket in the first place or something closer to
the simpler approach above.

> > A bit uglier though, also not sure how socket
> > refcounting would work there; maybe we can avoid the refcount in the
> > socket lookup and then fix it up in the later execution.
> That should not be an issue if refcnt is not taken for
> SOCK_RCU_FREE (e.g. TCP_LISTEN) in the first place.

This is likely the part that I was missing---I assumed that all bets
were off when we rcu_read_unlock(). But it sounds like you're saying
it's actually the RCU grace period, and that won't happen before we
enqueue the skb at the socket?

> >
> > > [...]
> > > It is another question that I have.  The TCP_LISTEN sk will suffer
> > > from this extra refcnt, e.g. SYNFLOOD.  Can something smarter
> > > be done in skb->destructor?
> >
> > Can you elaborate a bit more on the idea you have here?
> I am thinking can skb->destructor do something like bpf_sk_release()?
> This patch reuses tcp sock_edemux which currently only lookups the
> established sk.

I can try it out.

> >
> > Looking at the BPF API, it seems like the writer of the program can
> > use bpf_tcp_gen_syncookie() / bpf_tcp_check_syncookie() to generate
> > and check syn cookies to mitigate this kind of attack. This at least
> > provides an option beyond what existing tproxy implementations
> > provide.
> When the SYNACK comes back, it will still be served by a TCP_LISTEN sk.
> I know refcnt sucks on synflood test.  I don't know what the effect
> may be on serving those valid synack since there is no need
> to measure after SOCK_RCU_FREE is in ;)
>
> UDP is also in SOCK_RCU_FREE.  I think only early_demux, which
> seems to be for connected only,  takes a refnct.
> btw, it may be a good idea to add a udp test.

UDP was next on my list, in my local testing I needed a new
skc_lookup_udp() to find the right sockets. That patch series is more
straightforward than this one so I thought it'd be better to get the
feedback on this socket assign approach first then follow up with UDP
support.

> I am fine to push them to optimize/support later bucket
> It is still good to explore a little more such that we don't
> regret later.

I'll dig around a bit.

Thanks for the feedback,
Joe
