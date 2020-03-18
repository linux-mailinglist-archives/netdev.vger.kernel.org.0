Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B326E18934B
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 01:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgCRArN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 17 Mar 2020 20:47:13 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35835 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbgCRArN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 20:47:13 -0400
Received: by mail-wm1-f67.google.com with SMTP id m3so1419035wmi.0;
        Tue, 17 Mar 2020 17:47:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9/exMKIZ8ieEohQ+Fb4Z3Q8IHb8NhRUPovwuH0tpsik=;
        b=jRZ3TId5A4WIiVjoF/T8T4aw4j3pcv7oPRT5scPn87ce1H8A4jsd5VSPEE2tYJCxAy
         57309nWx243AW0iS9teOKlRdRdCRv1DuOKHC/DSbjjuRtlN0xITTccquvpFmDnWEIaC2
         Jy1VKsndVBK/9Lq8Npfx5mQZsb+k2RoPriTR+cuJt+nGN8foKdu2O4QOc6mc3824jMX/
         8swxOtmJY49berUf0oRj57nlX+pN8RdPvX6ZF5/72w8odg3mKU2y89Oe8RI/UwTkb5mV
         xpnhf2EuSio51/Lrz25Er0TDA7hwxyrWyN/CByo26NObSC/B8r7xobR0sAQ0cVFb8nxP
         syLQ==
X-Gm-Message-State: ANhLgQ3Gb03Zq8CowqLKBU/X3FR382SKoMDbYx4I98p0aF7VnBh1M7He
        TZuuvtj80VQzohGr5qNWrptdzDUmGYTN+XkIl7s=
X-Google-Smtp-Source: ADFU+vu2pcHM7a3Azn6XWazMw8W9fGOK6UBmTzaGV9EiuxuFwcnObroHWgjAoT7RXhB8mFi0h0HRRrH9tevtw1piddE=
X-Received: by 2002:a7b:c208:: with SMTP id x8mr1698076wmi.136.1584492430512;
 Tue, 17 Mar 2020 17:47:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200312233648.1767-1-joe@wand.net.nz> <20200312233648.1767-4-joe@wand.net.nz>
 <20200316225729.kd4hmz3oco5l7vn4@kafai-mbp> <CAOftzPgsVOqCLZatjytBXdQxH-DqJxiycXWN2d4C_-BjR5v1Kw@mail.gmail.com>
 <20200317062623.y5v2hejgtdbvexnz@kafai-mbp>
In-Reply-To: <20200317062623.y5v2hejgtdbvexnz@kafai-mbp>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Tue, 17 Mar 2020 17:46:58 -0700
Message-ID: <CAOftzPjXexvng-+77b-4Yw0pEBHXchsNVwrx+h9vV+5XBQzy-g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/7] bpf: Add socket assign support
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Joe Stringer <joe@wand.net.nz>, bpf@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 11:27 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Mon, Mar 16, 2020 at 08:06:38PM -0700, Joe Stringer wrote:
> > On Mon, Mar 16, 2020 at 3:58 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > On Thu, Mar 12, 2020 at 04:36:44PM -0700, Joe Stringer wrote:
> > > > Add support for TPROXY via a new bpf helper, bpf_sk_assign().
> > > >
> > > > This helper requires the BPF program to discover the socket via a call
> > > > to bpf_sk*_lookup_*(), then pass this socket to the new helper. The
> > > > helper takes its own reference to the socket in addition to any existing
> > > > reference that may or may not currently be obtained for the duration of
> > > > BPF processing. For the destination socket to receive the traffic, the
> > > > traffic must be routed towards that socket via local route, the socket
> > > I also missed where is the local route check in the patch.
> > > Is it implied by a sk can be found in bpf_sk*_lookup_*()?
> >
> > This is a requirement for traffic redirection, it's not enforced by
> > the patch. If the operator does not configure routing for the relevant
> > traffic to ensure that the traffic is delivered locally, then after
> > the eBPF program terminates, it will pass up through ip_rcv() and
> > friends and be subject to the whims of the routing table. (or
> > alternatively if the BPF program redirects somewhere else then this
> > reference will be dropped).
> >
> > Maybe there's a path to simplifying this configuration path in future
> > to loosen this requirement, but for now I've kept the series as
> > minimal as possible on that front.
> >
> > > [ ... ]
> > >
> > > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > > index cd0a532db4e7..bae0874289d8 100644
> > > > --- a/net/core/filter.c
> > > > +++ b/net/core/filter.c
> > > > @@ -5846,6 +5846,32 @@ static const struct bpf_func_proto bpf_tcp_gen_syncookie_proto = {
> > > >       .arg5_type      = ARG_CONST_SIZE,
> > > >  };
> > > >
> > > > +BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
> > > > +{
> > > > +     if (flags != 0)
> > > > +             return -EINVAL;
> > > > +     if (!skb_at_tc_ingress(skb))
> > > > +             return -EOPNOTSUPP;
> > > > +     if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
> > > > +             return -ENOENT;
> > > > +
> > > > +     skb_orphan(skb);
> > > > +     skb->sk = sk;
> > > sk is from the bpf_sk*_lookup_*() which does not consider
> > > the bpf_prog installed in SO_ATTACH_REUSEPORT_EBPF.
> > > However, the use-case is currently limited to sk inspection.
> > >
> > > It now supports selecting a particular sk to receive traffic.
> > > Any plan in supporting that?
> >
> > I think this is a general bpf_sk*_lookup_*() question, previous
> > discussion[0] settled on avoiding that complexity before a use case
> > arises, for both TC and XDP versions of these helpers; I still don't
> > have a specific use case in mind for such functionality. If we were to
> > do it, I would presume that the socket lookup caller would need to
> > pass a dedicated flag (supported at TC and likely not at XDP) to
> > communicate that SO_ATTACH_REUSEPORT_EBPF progs should be respected
> > and used to select the reuseport socket.
> It is more about the expectation on the existing SO_ATTACH_REUSEPORT_EBPF
> usecase.  It has been fine because SO_ATTACH_REUSEPORT_EBPF's bpf prog
> will still be run later (e.g. from tcp_v4_rcv) to decide which sk to
> recieve the skb.
>
> If the bpf@tc assigns a TCP_LISTEN sk in bpf_sk_assign(),
> will the SO_ATTACH_REUSEPORT_EBPF's bpf still be run later
> to make the final sk decision?

I don't believe so, no:

ip_local_deliver()
-> ...
-> ip_protocol_deliver_rcu()
-> tcp_v4_rcv()
-> __inet_lookup_skb()
-> skb_steal_sock(skb)

But this will only affect you if you are running both the bpf@tc
program with sk_assign() and the reuseport BPF sock programs at the
same time. This is why I link it back to the bpf_sk*_lookup_*()
functions: If the socket lookup in the initial step respects reuseport
BPF prog logic and returns the socket using the same logic, then the
packet will be directed to the socket you expect. Just like how
non-BPF reuseport would work with this series today.

> >
> > > > diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> > > > index 7b089d0ac8cd..f7b42adca9d0 100644
> > > > --- a/net/ipv6/ip6_input.c
> > > > +++ b/net/ipv6/ip6_input.c
> > > > @@ -285,7 +285,10 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
> > > >       rcu_read_unlock();
> > > >
> > > >       /* Must drop socket now because of tproxy. */
> > > > -     skb_orphan(skb);
> > > > +     if (skb_dst_is_sk_prefetch(skb))
> > > > +             dst_sk_prefetch_fetch(skb);
> > > > +     else
> > > > +             skb_orphan(skb);
> > > If I understand it correctly, this new test is to skip
> > > the skb_orphan() call for locally routed skb.
> > > Others cases (forward?) still depend on skb_orphan() to be called here?
> >
> > Roughly yes. 'locally routed skb' is a bit loose wording though, at
> > this point the BPF program only prefetched the socket to let the stack
> > know that it should deliver the skb to that socket, assuming that it
> > passes the upcoming routing check.
> Which upcoming routing check?  I think it is the part I am missing.
>
> In patch 4, let say the dst_check() returns NULL (may be due to a route
> change).  Later in the upper stack, it does a route lookup
> (ip_route_input_noref() or ip6_route_input()).  Could it return
> a forward route? and I assume missing a skb_orphan() call
> here will still be fine?

Yes it could return a forward route, in that case:

ip_forward()
-> if (unlikely(skb->sk)) goto drop;

Note that you'd have to get a socket reference to get to this point in
the first place. I see two options:
* BPF program operator didn't set up the routes correctly for local
socket destination
* BPF program looks up socket in another netns and tries to assign it.

For the latter case I could introduce a netns validation check to
ensure it matches the netns of the device.

> >
> > For more discussion on the other cases, there is the previous
> > thread[1] and in particular the child thread discussion with Florian,
> > Eric and Daniel.
> >
> > [0] https://urldefense.proofpoint.com/v2/url?u=https-3A__www.mail-2Darchive.com_netdev-40vger.kernel.org_msg253250.html&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=VQnoQ7LvghIj0gVEaiQSUw&m=mX45GxyUJ_HfsBIJTVMZY9ztD5rVViDuOIQ0pXtyJcM&s=z5lZSVTonmhT5OeyxsefzUC2fMqDEwFvlEV1qkyrULg&e=
> > [1] https://urldefense.proofpoint.com/v2/url?u=https-3A__www.spinics.net_lists_netdev_msg580058.html&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=VQnoQ7LvghIj0gVEaiQSUw&m=mX45GxyUJ_HfsBIJTVMZY9ztD5rVViDuOIQ0pXtyJcM&s=oFYt8cTKQEc-wEfY5YSsjfVN3QqBlFGfrrT7DTKw1rc&e=
