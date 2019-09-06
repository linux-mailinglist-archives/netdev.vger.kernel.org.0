Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73D80AC149
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 22:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394384AbfIFUPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 16:15:41 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43557 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388396AbfIFUPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 16:15:41 -0400
Received: by mail-ed1-f67.google.com with SMTP id c19so7524120edy.10
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 13:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sNr2E2rOD4k5+mGvALgoBr3zKiqIKD7V5pEQwaip4xQ=;
        b=rUxv3Eq3TJHxbI9+iu+BgITvOfxiF/KLlRCicrnqfkVMJUCHIVO1vXsnUl8J8Bf8ZS
         JP96s40CTb5cwdpAbNvNKl14OEZKJAQcrH2YcVLYJhks2USFE1nf/Df+meUwyQ7CgWmY
         S6KbkNhHYCJkcJzhDpoP6hJbQkVOexwHjpcF5o8IJUmuI7t4rxOl7g4UL+gGqm3jIXm0
         l+TAp7EXBYgprZZegfeNxiYXZiPTPBAKX96cTojms5vWS/RuaPIz3fw5y3zHORbw++Zb
         dJ2djJ/f6uvAN7kfAoLytCNik4Rt49i8Tqji2u7qCpXd5Ka0cOZMfYuEw0kPEKe1VG6R
         8jzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sNr2E2rOD4k5+mGvALgoBr3zKiqIKD7V5pEQwaip4xQ=;
        b=EZueSQnhPidhVOeGUDYDjt1dhM3w75706t9b/Tmk03tCdBUNn/djjfcopRYnJd8Cwx
         UPf85UaPcVmFpYxLnGVGKVSIyEmevCNAyKljFgA6oKHHAQ2FD51imnndjaWQgsiMICLD
         oIV5bP18U1Bv/qCkMtml3B0xnFML1MQz4fdbRB86TANpTLuN0RT/uQfhnMjABg2EjiVD
         sQhlAqzQ0VJntJmJgPeRaqz5MY85AbmclYfS02ofDLen8lb2+EcDQ6kcseW+VSyPcSQa
         haseHvvMGlhw0+Y9zdyrxrH06JudHptp5EX9Y5FOAlcRQfVeoSSZqShc64UgUfZLcw/H
         CzbQ==
X-Gm-Message-State: APjAAAXD50RrPQGbIGTOF6AlpeYZmpsEJtuF2cP+SAyJE3chZbFBChE+
        so5iNCTZADsfeICkS2C1XreD0M9Ga5UIuvPyR9If4Q==
X-Google-Smtp-Source: APXvYqwSl1Z/gnW1K0Dk9Tc0j7Q2jSxeLrZeDe7xziMgkMXAHhax4fAXxzLGDJtAkVSJcmC91kqEN+4VTeeVl0aJkbU=
X-Received: by 2002:a17:906:1995:: with SMTP id g21mr9030201ejd.226.1567800939748;
 Fri, 06 Sep 2019 13:15:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190906092350.13929-1-shmulik.ladkani@gmail.com>
In-Reply-To: <20190906092350.13929-1-shmulik.ladkani@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 6 Sep 2019 16:15:03 -0400
Message-ID: <CAF=yD-LX-XemD8QpU-=Hn5bdX8jPP6nWS1YgpDxcrBu7sdBxRg@mail.gmail.com>
Subject: Re: [PATCH v2 net] net: gso: Fix skb_segment splat when splitting
 gso_size mangled skb having linear-headed frag_list
To:     Shmulik Ladkani <shmulik@metanetworks.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>, eyal@metanetworks.com,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 6, 2019 at 5:23 AM Shmulik Ladkani <shmulik@metanetworks.com> wrote:
>
> Historically, support for frag_list packets entering skb_segment() was
> limited to frag_list members terminating on exact same gso_size
> boundaries. This is verified with a BUG_ON since commit 89319d3801d1
> ("net: Add frag_list support to skb_segment"), quote:
>
>     As such we require all frag_list members terminate on exact MSS
>     boundaries.  This is checked using BUG_ON.
>     As there should only be one producer in the kernel of such packets,
>     namely GRO, this requirement should not be difficult to maintain.
>
> However, since commit 6578171a7ff0 ("bpf: add bpf_skb_change_proto helper"),
> the "exact MSS boundaries" assumption no longer holds:
> An eBPF program using bpf_skb_change_proto() DOES modify 'gso_size', but
> leaves the frag_list members as originally merged by GRO with the
> original 'gso_size'. Example of such programs are bpf-based NAT46 or
> NAT64.
>
> This lead to a kernel BUG_ON for flows involving:
>  - GRO generating a frag_list skb
>  - bpf program performing bpf_skb_change_proto() or bpf_skb_adjust_room()
>  - skb_segment() of the skb
>
> See example BUG_ON reports in [0].
>
> In commit 13acc94eff12 ("net: permit skb_segment on head_frag frag_list skb"),
> skb_segment() was modified to support the "gso_size mangling" case of
> a frag_list GRO'ed skb, but *only* for frag_list members having
> head_frag==true (having a page-fragment head).
>
> Alas, GRO packets having frag_list members with a linear kmalloced head
> (head_frag==false) still hit the BUG_ON.
>
> This commit adds support to skb_segment() for a 'head_skb' packet having
> a frag_list whose members are *non* head_frag, with gso_size mangled, by
> disabling SG and thus falling-back to copying the data from the given
> 'head_skb' into the generated segmented skbs - as suggested by Willem de
> Bruijn [1].
>
> Since this approach involves the penalty of skb_copy_and_csum_bits()
> when building the segments, care was taken in order to enable this
> solution only when required:
>  - untrusted gso_size, by testing SKB_GSO_DODGY is set
>    (SKB_GSO_DODGY is set by any gso_size mangling functions in
>     net/core/filter.c)
>  - the frag_list is non empty, its item is a non head_frag, *and* the
>    headlen of the given 'head_skb' does not match the gso_size.
>
> [0]
> https://lore.kernel.org/netdev/20190826170724.25ff616f@pixies/
> https://lore.kernel.org/netdev/9265b93f-253d-6b8c-f2b8-4b54eff1835c@fb.com/
>
> [1]
> https://lore.kernel.org/netdev/CA+FuTSfVsgNDi7c=GUU8nMg2hWxF2SjCNLXetHeVPdnxAW5K-w@mail.gmail.com/
>
> Fixes: 6578171a7ff0 ("bpf: add bpf_skb_change_proto helper")
> Suggested-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Alexander Duyck <alexander.duyck@gmail.com>
> Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>
