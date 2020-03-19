Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5397218ACB9
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 07:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgCSGYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 02:24:37 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33602 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgCSGYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 02:24:36 -0400
Received: by mail-wr1-f65.google.com with SMTP id a25so1259779wrd.0;
        Wed, 18 Mar 2020 23:24:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u4MhDONVs1654GZx6eTeBiopwL8V0fEf3b5yMxssjt8=;
        b=YhIoKTCQtLw1N8pG+TNrFg5y6tEQuL8DxALJHyH9y9/ARkHPt5MEpTmgNAqUKjklWa
         DVm9/9vRMvlwNyCb0nZ3oZH182dsIfJ0ps1jXuMOTSY7F3YkmbFDxim1UBbdgVpacGdf
         qDpx8tTRuRWgOgMMzBi5AMw0rYXD9L2H/RlOuNeoUbyDrfpg7Vuz2tn1iSGNReQ20OnK
         5xBDcCkTXp/+zgEowHCRoR3YDIWyni3+keySc/I7lXrkGjSmPxSWIiWziZ7fcGHlJHQW
         q/qgV/Cq56IKoGrIv1Fh20u5GHkPxdMyMkZ/WqiOY8QsPgZt0OlmzFyPZbMJc6vGaDQE
         3ZJw==
X-Gm-Message-State: ANhLgQ3Ze1mi83z3CWd9BNElN83A3rr+qaqxpnbAASZb78XurILGo2Uz
        VV5bUA1l6Ug4Y2LevCLp+tdJoWL1KkGggj3DgPw=
X-Google-Smtp-Source: ADFU+vs0A5Flc/MWchwK4fe3/p6blnghAtG1BPwkO9wDkSixJwWDKeL89RBMtpRAA+5Mb1c3VaeF9n3GGKLYjBGOgL4=
X-Received: by 2002:adf:ce8e:: with SMTP id r14mr2010964wrn.415.1584599072918;
 Wed, 18 Mar 2020 23:24:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200312233648.1767-1-joe@wand.net.nz> <20200312233648.1767-4-joe@wand.net.nz>
 <20200316225729.kd4hmz3oco5l7vn4@kafai-mbp> <CAOftzPgsVOqCLZatjytBXdQxH-DqJxiycXWN2d4C_-BjR5v1Kw@mail.gmail.com>
 <20200317062623.y5v2hejgtdbvexnz@kafai-mbp> <CAOftzPjXexvng-+77b-4Yw0pEBHXchsNVwrx+h9vV+5XBQzy-g@mail.gmail.com>
 <20200318184852.vwzuc4esqemsn7gx@kafai-mbp>
In-Reply-To: <20200318184852.vwzuc4esqemsn7gx@kafai-mbp>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Wed, 18 Mar 2020 23:24:11 -0700
Message-ID: <CAOftzPivg9nxsvvcza7v8Q-pgqZb3wy5gT9U19eGoBtzVzPPmA@mail.gmail.com>
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

On Wed, Mar 18, 2020 at 11:49 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Mar 17, 2020 at 05:46:58PM -0700, Joe Stringer wrote:
> > On Mon, Mar 16, 2020 at 11:27 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > On Mon, Mar 16, 2020 at 08:06:38PM -0700, Joe Stringer wrote:
> > > > On Mon, Mar 16, 2020 at 3:58 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > >
> > > > > On Thu, Mar 12, 2020 at 04:36:44PM -0700, Joe Stringer wrote:
> > > > > > Add support for TPROXY via a new bpf helper, bpf_sk_assign().
> > > > > >
> > > > > > This helper requires the BPF program to discover the socket via a call
> > > > > > to bpf_sk*_lookup_*(), then pass this socket to the new helper. The
> > > > > > helper takes its own reference to the socket in addition to any existing
> > > > > > reference that may or may not currently be obtained for the duration of
> > > > > > BPF processing. For the destination socket to receive the traffic, the
> > > > > > traffic must be routed towards that socket via local route, the socket
> > > > > I also missed where is the local route check in the patch.
> > > > > Is it implied by a sk can be found in bpf_sk*_lookup_*()?
> > > >
> > > > This is a requirement for traffic redirection, it's not enforced by
> > > > the patch. If the operator does not configure routing for the relevant
> > > > traffic to ensure that the traffic is delivered locally, then after
> > > > the eBPF program terminates, it will pass up through ip_rcv() and
> > > > friends and be subject to the whims of the routing table. (or
> > > > alternatively if the BPF program redirects somewhere else then this
> > > > reference will be dropped).
> > > >
> > > > Maybe there's a path to simplifying this configuration path in future
> > > > to loosen this requirement, but for now I've kept the series as
> > > > minimal as possible on that front.
> > > >
> > > > > [ ... ]
> > > > >
> > > > > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > > > > index cd0a532db4e7..bae0874289d8 100644
> > > > > > --- a/net/core/filter.c
> > > > > > +++ b/net/core/filter.c
> > > > > > @@ -5846,6 +5846,32 @@ static const struct bpf_func_proto bpf_tcp_gen_syncookie_proto = {
> > > > > >       .arg5_type      = ARG_CONST_SIZE,
> > > > > >  };
> > > > > >
> > > > > > +BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
> > > > > > +{
> > > > > > +     if (flags != 0)
> > > > > > +             return -EINVAL;
> > > > > > +     if (!skb_at_tc_ingress(skb))
> > > > > > +             return -EOPNOTSUPP;
> > > > > > +     if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
> > > > > > +             return -ENOENT;
> > > > > > +
> > > > > > +     skb_orphan(skb);
> > > > > > +     skb->sk = sk;
> > > > > sk is from the bpf_sk*_lookup_*() which does not consider
> > > > > the bpf_prog installed in SO_ATTACH_REUSEPORT_EBPF.
> > > > > However, the use-case is currently limited to sk inspection.
> > > > >
> > > > > It now supports selecting a particular sk to receive traffic.
> > > > > Any plan in supporting that?
> > > >
> > > > I think this is a general bpf_sk*_lookup_*() question, previous
> > > > discussion[0] settled on avoiding that complexity before a use case
> > > > arises, for both TC and XDP versions of these helpers; I still don't
> > > > have a specific use case in mind for such functionality. If we were to
> > > > do it, I would presume that the socket lookup caller would need to
> > > > pass a dedicated flag (supported at TC and likely not at XDP) to
> > > > communicate that SO_ATTACH_REUSEPORT_EBPF progs should be respected
> > > > and used to select the reuseport socket.
> > > It is more about the expectation on the existing SO_ATTACH_REUSEPORT_EBPF
> > > usecase.  It has been fine because SO_ATTACH_REUSEPORT_EBPF's bpf prog
> > > will still be run later (e.g. from tcp_v4_rcv) to decide which sk to
> > > recieve the skb.
> > >
> > > If the bpf@tc assigns a TCP_LISTEN sk in bpf_sk_assign(),
> > > will the SO_ATTACH_REUSEPORT_EBPF's bpf still be run later
> > > to make the final sk decision?
> >
> > I don't believe so, no:
> >
> > ip_local_deliver()
> > -> ...
> > -> ip_protocol_deliver_rcu()
> > -> tcp_v4_rcv()
> > -> __inet_lookup_skb()
> > -> skb_steal_sock(skb)
> >
> > But this will only affect you if you are running both the bpf@tc
> > program with sk_assign() and the reuseport BPF sock programs at the
> > same time.
> I don't think it is the right answer to ask the user to be careful and
> only use either bpf_sk_assign()@tc or bpf_prog@so_reuseport.

Applying a restriction on reuseport sockets until we sort this out per
my other email should resolve this concern.

> > This is why I link it back to the bpf_sk*_lookup_*()
> > functions: If the socket lookup in the initial step respects reuseport
> > BPF prog logic and returns the socket using the same logic, then the
> > packet will be directed to the socket you expect. Just like how
> > non-BPF reuseport would work with this series today.
> Changing bpf_sk*_lookup_*() is a way to solve it but I don't know what it
> may run into when recurring bpf_prog, i.e. running bpf@so-reuseport inside
> bpf@tc. That may need a closer look.

Right, that's my initial concern as well.

One alternative might be something like: in the helper implementation,
store some bit somewhere to say "we need to resolve the reuseport
later" and then when the TC BPF program returns, check this bit and if
reuseport is necessary, trigger the BPF program for it and fix up the
socket after-the-fact. A bit uglier though, also not sure how socket
refcounting would work there; maybe we can avoid the refcount in the
socket lookup and then fix it up in the later execution.

> [...]
> It is another question that I have.  The TCP_LISTEN sk will suffer
> from this extra refcnt, e.g. SYNFLOOD.  Can something smarter
> be done in skb->destructor?

Can you elaborate a bit more on the idea you have here?

Looking at the BPF API, it seems like the writer of the program can
use bpf_tcp_gen_syncookie() / bpf_tcp_check_syncookie() to generate
and check syn cookies to mitigate this kind of attack. This at least
provides an option beyond what existing tproxy implementations
provide.

> In general, it took me a while to wrap my head around thinking
> how a skb->_skb_refdst is related to assigning a sk to skb->sk.
> My understanding is it is a way to tell when not to call
> skb_orphan() here.  Have you considered other options (e.g.
> using a bit in skb->sk)?   It will be useful to explain
> them in the commit message.

Good point, I did briefly explore that initially and it looked a lot
more invasive. With that approach, any time we do some kind of socket
handling (assign, release, steal, etc.) we have this extra bit we have to
deal with and decide whether we need to specially handle it.
skb->_skb_refdst already has this ugliness (see skb_dst() and friends)
so on a practical note it seemed less invasive to me to reuse that
infrastructure.

Conceptually I was looking at this as a metadata destination similar
to the referred patches in one of the earlier commit messages. We
associate this special socket destination initially, to tell ip_rcv()
that we really do need to retain this socket and not just orphan
it/continue with the regular destination selection logic.

I can roll this explanation into the series header and/or commit
messages as well.
