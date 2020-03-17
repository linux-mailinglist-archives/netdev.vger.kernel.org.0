Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D970D1877FB
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 04:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgCQDGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 23:06:55 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35911 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbgCQDGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 23:06:55 -0400
Received: by mail-wr1-f67.google.com with SMTP id s5so23827573wrg.3;
        Mon, 16 Mar 2020 20:06:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cR/hhNkP8odwBbN5YNL0sAg8Mhq/bF3O0eciWPxcFR8=;
        b=b8c7J86pxGschSWZIXD3WA1Z9JYv7UgGKytr+L9ppH9f/3G+wszmisZzFuft7xLalp
         Xb5ybizmn0Ob8WYiWYm9pg1dxm8RJjdWQxA0LQiGVIWvCYe4n8czsR3cm2s8O06VzspZ
         7xIKVOWGE4ZMZjp9mvN7oYKtdtCcG4XI3jjnQBQHxmnddgXt2W9AdT8Te7TetZeYr1cV
         VTJ9L0bV1pLJiq4OKaRGiJEri4iu6utjSuAOxyv4KUop4rXeusSxjDJ5XDz5vMnaoX60
         U6aezcU4pqLwDHG5tn5xAK7sQlFpFN+Wz/Ewy1xySTkaSDov8novL00/lyTIryD0XOfR
         XO8g==
X-Gm-Message-State: ANhLgQ3Ip5zLGahQliTr/hug/sCkROhIJNmi+XsG/B4DA4+G916Ah/ND
        Yk+E29QybwjVkpwYHRjLRG8NunEB7cdHux5OCa9XuQxk
X-Google-Smtp-Source: ADFU+vthxuTXA4MYijhtCBA+mjbVaxncDtg0CUyfTESWUeEama/v0J+XX2euKfqonIgnaugPKQhfIyF0tJnHJW0Xxgk=
X-Received: by 2002:adf:df0b:: with SMTP id y11mr2624050wrl.388.1584414412910;
 Mon, 16 Mar 2020 20:06:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200312233648.1767-1-joe@wand.net.nz> <20200312233648.1767-4-joe@wand.net.nz>
 <20200316225729.kd4hmz3oco5l7vn4@kafai-mbp>
In-Reply-To: <20200316225729.kd4hmz3oco5l7vn4@kafai-mbp>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Mon, 16 Mar 2020 20:06:38 -0700
Message-ID: <CAOftzPgsVOqCLZatjytBXdQxH-DqJxiycXWN2d4C_-BjR5v1Kw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/7] bpf: Add socket assign support
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Joe Stringer <joe@wand.net.nz>, bpf@vger.kernel.org,
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

On Mon, Mar 16, 2020 at 3:58 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Mar 12, 2020 at 04:36:44PM -0700, Joe Stringer wrote:
> > Add support for TPROXY via a new bpf helper, bpf_sk_assign().
> >
> > This helper requires the BPF program to discover the socket via a call
> > to bpf_sk*_lookup_*(), then pass this socket to the new helper. The
> > helper takes its own reference to the socket in addition to any existing
> > reference that may or may not currently be obtained for the duration of
> > BPF processing. For the destination socket to receive the traffic, the
> > traffic must be routed towards that socket via local route, the socket
> I also missed where is the local route check in the patch.
> Is it implied by a sk can be found in bpf_sk*_lookup_*()?

This is a requirement for traffic redirection, it's not enforced by
the patch. If the operator does not configure routing for the relevant
traffic to ensure that the traffic is delivered locally, then after
the eBPF program terminates, it will pass up through ip_rcv() and
friends and be subject to the whims of the routing table. (or
alternatively if the BPF program redirects somewhere else then this
reference will be dropped).

Maybe there's a path to simplifying this configuration path in future
to loosen this requirement, but for now I've kept the series as
minimal as possible on that front.

> [ ... ]
>
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index cd0a532db4e7..bae0874289d8 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -5846,6 +5846,32 @@ static const struct bpf_func_proto bpf_tcp_gen_syncookie_proto = {
> >       .arg5_type      = ARG_CONST_SIZE,
> >  };
> >
> > +BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
> > +{
> > +     if (flags != 0)
> > +             return -EINVAL;
> > +     if (!skb_at_tc_ingress(skb))
> > +             return -EOPNOTSUPP;
> > +     if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
> > +             return -ENOENT;
> > +
> > +     skb_orphan(skb);
> > +     skb->sk = sk;
> sk is from the bpf_sk*_lookup_*() which does not consider
> the bpf_prog installed in SO_ATTACH_REUSEPORT_EBPF.
> However, the use-case is currently limited to sk inspection.
>
> It now supports selecting a particular sk to receive traffic.
> Any plan in supporting that?

I think this is a general bpf_sk*_lookup_*() question, previous
discussion[0] settled on avoiding that complexity before a use case
arises, for both TC and XDP versions of these helpers; I still don't
have a specific use case in mind for such functionality. If we were to
do it, I would presume that the socket lookup caller would need to
pass a dedicated flag (supported at TC and likely not at XDP) to
communicate that SO_ATTACH_REUSEPORT_EBPF progs should be respected
and used to select the reuseport socket.

> > diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> > index 7b089d0ac8cd..f7b42adca9d0 100644
> > --- a/net/ipv6/ip6_input.c
> > +++ b/net/ipv6/ip6_input.c
> > @@ -285,7 +285,10 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
> >       rcu_read_unlock();
> >
> >       /* Must drop socket now because of tproxy. */
> > -     skb_orphan(skb);
> > +     if (skb_dst_is_sk_prefetch(skb))
> > +             dst_sk_prefetch_fetch(skb);
> > +     else
> > +             skb_orphan(skb);
> If I understand it correctly, this new test is to skip
> the skb_orphan() call for locally routed skb.
> Others cases (forward?) still depend on skb_orphan() to be called here?

Roughly yes. 'locally routed skb' is a bit loose wording though, at
this point the BPF program only prefetched the socket to let the stack
know that it should deliver the skb to that socket, assuming that it
passes the upcoming routing check.

For more discussion on the other cases, there is the previous
thread[1] and in particular the child thread discussion with Florian,
Eric and Daniel.

[0] https://www.mail-archive.com/netdev@vger.kernel.org/msg253250.html
[1] https://www.spinics.net/lists/netdev/msg580058.html
