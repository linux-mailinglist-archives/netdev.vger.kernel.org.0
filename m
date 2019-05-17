Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A15B4219AB
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 16:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbfEQOPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 10:15:52 -0400
Received: from mail-oi1-f171.google.com ([209.85.167.171]:43143 "EHLO
        mail-oi1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728611AbfEQOPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 10:15:52 -0400
Received: by mail-oi1-f171.google.com with SMTP id t187so5238240oie.10
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 07:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qEdqQ0TVwMnwono/AVNH0gD3Yp9fek4Cvk4YPyWSv98=;
        b=peazptBPmA9W8okD7apzXztwROK1+YjIH4KzQYYcIPkBRrd4FqTW8uOamkDT3wAKjz
         tN4O7PIuIlApxXb2oBifv9r+jeRQFKnSrWz9+DxQb3fZ3rymdHE5VbvGwDcIW3i5HSx6
         4WMJdDSWa6QVIuGccYqE00BKD7OGYAnbCmq/8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qEdqQ0TVwMnwono/AVNH0gD3Yp9fek4Cvk4YPyWSv98=;
        b=SyknINBz4qgtTjJWKvceHkpDtV0IsZw9BlMQ19ROOb7bUL/RevkZ3GYhSF1+3BWHfv
         hMJO9f2OvyN6ie92RK9kynJ8MjO/JuD6ll2U8yTlVUPuDHtFo0RLxgolQYquPX6m9O3v
         RXW2PCjQMOZLXP/192gGdLEUKosbAJM4T9d+9vI0XIaGbEFT8FyyApN9LWYKYokfrXbO
         x0btVXxsWnhumaE4MECXGKCN1pccBqYV3R9v+fkXUZUnsmEWDFBRGOD5dZLoCdSsXBS9
         F8zIZ+49dSr2Sl5iQH8axWBQzMBBWqmnDn7Y46+w5yZ0qemQlO4LJa6ywyGyp0tfTM6J
         2cyQ==
X-Gm-Message-State: APjAAAWI0b6YRyEyKujFljiTDSYGyUAjbfXmt8VAhlLGRaxE2Ko2GBPc
        LhObRqSWVV9LipNiF61a+bUsO6Qm4cbqY2Qtnhjy0w==
X-Google-Smtp-Source: APXvYqyiJdxfY4j12zpzWuhY9zRT1KkusvtBkF6eOWCx7oS7ACpD3n5A2kswFpst4qD4QMYv3k2UmwtX9xLWw8fwWlA=
X-Received: by 2002:aca:43d5:: with SMTP id q204mr14890216oia.13.1558102551024;
 Fri, 17 May 2019 07:15:51 -0700 (PDT)
MIME-Version: 1.0
References: <CACAyw98+qycmpQzKupquhkxbvWK4OFyDuuLMBNROnfWMZxUWeA@mail.gmail.com>
 <CADa=RyyuAOupK7LOydQiNi6tx2ELOgD+bdu+DHh3xF0dDxw_gw@mail.gmail.com>
 <CACAyw9_EGRob4VG0-G4PN9QS_xB5GoDMBB6mPXR-WcPnrFCuLg@mail.gmail.com> <20190516203325.uhg7c5sr45od7lzm@ast-mbp>
In-Reply-To: <20190516203325.uhg7c5sr45od7lzm@ast-mbp>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Fri, 17 May 2019 15:15:39 +0100
Message-ID: <CACAyw9_yq_xVjh0_2QhAg-2vOLHUCMce4Jhy466N+F4zH7dPmw@mail.gmail.com>
Subject: Re: RFC: Fixing SK_REUSEPORT from sk_lookup_* helpers
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Joe Stringer <joe@isovalent.com>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Martin Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, edumazet@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 May 2019 at 21:33, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, May 16, 2019 at 09:41:34AM +0100, Lorenz Bauer wrote:
> > On Wed, 15 May 2019 at 18:16, Joe Stringer <joe@isovalent.com> wrote:
> > >
> > > On Wed, May 15, 2019 at 8:11 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > > >
> > > > In the BPF-based TPROXY session with Joe Stringer [1], I mentioned
> > > > that the sk_lookup_* helpers currently return inconsistent results if
> > > > SK_REUSEPORT programs are in play.
> > > >
> > > > SK_REUSEPORT programs are a hook point in inet_lookup. They get access
> > > > to the full packet
> > > > that triggered the look up. To support this, inet_lookup gained a new
> > > > skb argument to provide such context. If skb is NULL, the SK_REUSEPORT
> > > > program is skipped and instead the socket is selected by its hash.
> > > >
> > > > The first problem is that not all callers to inet_lookup from BPF have
> > > > an skb, e.g. XDP. This means that a look up from XDP gives an
> > > > incorrect result. For now that is not a huge problem. However, once we
> > > > get sk_assign as proposed by Joe, we can end up circumventing
> > > > SK_REUSEPORT.
> > >
> > > To clarify a bit, the reason this is a problem is that a
> > > straightforward implementation may just consider passing the skb
> > > context into the sk_lookup_*() and through to the inet_lookup() so
> > > that it would run the SK_REUSEPORT BPF program for socket selection on
> > > the skb when the packet-path BPF program performs the socket lookup.
> > > However, as this paragraph describes, the skb context is not always
> > > available.
> > >
> > > > At the conference, someone suggested using a similar approach to the
> > > > work done on the flow dissector by Stanislav: create a dedicated
> > > > context sk_reuseport which can either take an skb or a plain pointer.
> > > > Patch up load_bytes to deal with both. Pass the context to
> > > > inet_lookup.
> > > >
> > > > This is when we hit the second problem: using the skb or XDP context
> > > > directly is incorrect, because it assumes that the relevant protocol
> > > > headers are at the start of the buffer. In our use case, the correct
> > > > headers are at an offset since we're inspecting encapsulated packets.
> > > >
> > > > The best solution I've come up with is to steal 17 bits from the flags
> > > > argument to sk_lookup_*, 1 bit for BPF_F_HEADERS_AT_OFFSET, 16bit for
> > > > the offset itself.
> > >
> > > FYI there's also the upper 32 bits of the netns_id parameter, another
> > > option would be to steal 16 bits from there.
> >
> > Or len, which is only 16 bits realistically. The offset doesn't really fit into
> > either of them very well, using flags seemed the cleanest to me.
> > Is there some best practice around this?
> >
> > >
> > > > Thoughts?
> > >
> > > Internally with skbs, we use `skb_pull()` to manage header offsets,
> > > could we do something similar with `bpf_xdp_adjust_head()` prior to
> > > the call to `bpf_sk_lookup_*()`?
> >
> > That would only work if it retained the contents of the skipped
> > buffer, and if there
> > was a way to undo the adjustment later. We're doing the sk_lookup to
> > decide whether to
> > accept or forward the packet, so at the point of the call we might still need
> > that data. Is that feasible with skb / XDP ctx?
>
> While discussing the solution for reuseport I propose to use
> progs/test_select_reuseport_kern.c as an example of realistic program.
> It reads tcp/udp header directly via ctx->data or via bpf_skb_load_bytes()
> including payload after the header.
> It also uses bpf_skb_load_bytes_relative() to fetch IP.
> I think if we're fixing the sk_lookup from XDP the above program
> would need to work.

Agreed.

> And I think we can make it work by adding new requirement that
> 'struct bpf_sock_tuple *' argument to bpf_sk_lookup_* must be
> a pointer to the packet and not a pointer to bpf program stack.

This would break existing users, no? The sk_assign use case Joe Stringer
is working on would also break, because its impossible to look up a tuple
that hasn't come from the network.

It occurs to me that it's impossible to reconcile this use case with
SK_REUSEPORT in general. It would be great if we could return an
error in such case.

> Then helper can construct a fake skb and assign
> fake_skb->data = &bpf_sock_tuple_arg.sport

That isn't valid if the packet contains IP options or extension headers, because
the offset of sport is variable.

> It can check that struct bpf_sock_tuple * pointer is within 100-ish bytes
> from xdp->data and within xdp->data_end

Why the 100-byte limitation?

> This way the reuseport program's assumption that ctx->data points to tcp/udp
> will be preserved and it can access it all including payload.

How about the following:

    sk_lookup(ctx, &saddr, len, netns, BPF_F_IPV4 |
BPF_F_OFFSET(offsetof(sport))

SK_REUSEPORT can then access from saddr+offsetof(sport) to saddr+len.
The helper uses
offsetof(sport) to retrieve the tuple.

- Works with stack, map, packet pointers
- The verifier does bounds checking on the buffer for us due to ARG_CONST_SIZE
- If no BPF_F_IPV? is present, we fall back to current behaviour

>
> This approach doesn't need to mess with xdp_adjust_head and adjust uapi to pass length.
> Existing progs/test_sk_lookup_kern.c will magically start working with XDP
> even when reuseport prog is attached.
> Thoughts?
>


-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
