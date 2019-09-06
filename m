Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFC4BAC1A0
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 22:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389419AbfIFUvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 16:51:14 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:44317 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732135AbfIFUvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 16:51:14 -0400
Received: by mail-io1-f66.google.com with SMTP id j4so15797533iog.11
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 13:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Utwdy7xas2aZWwfR15BOIsdyxyWMOZzkH136a2J27I=;
        b=tj/Nq7IF2W2XrzT4/aiS0ZOqL7Tc/fZv+HCwUrhAulBflMQVqPFdmdVDx6C84jLqVc
         4rSuQS7wRM47Cx0e+tJUYnM4AdTYkdOan9w7Z+wagPFv4Lt8liOYLUmC2P5YP8apVgmo
         jINN1LWyIIks6aj0lP4PcNupelOVTAt7zb9McOV4ulVJw9zVZQPpE4XDXXO3k+qjLNUL
         N+3OvPIeIPatSBpammpoO0D5zIhxWwaeN5yZoksJJ6g4xfiM+GGvfn3FzzTAKI8qv8RH
         Yd1mgTuT2fgmULejD9VGwHMP0VRVtfaHaH16xd+hIj5/YxdkmkRvwWjXMeXEp60zq263
         1XDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Utwdy7xas2aZWwfR15BOIsdyxyWMOZzkH136a2J27I=;
        b=VR3BjUC6JuGyz7LbUcmUaY7QxMU0qM4+3NHqXGUmwtIDI82y49Up/+U8TbU/uXPOLZ
         0m7Agy3QSs6nvF0rUgStKk6qLgembc/jOyvzUcGTusMVSVyA4BKHNiwM/zFLxNtEfeSL
         ws5TxsvwC1TgxYAbhQFE5BMSBtABFr3Z5h7rI69fDMD74e0WqggFBfUQItNXOVck8RqV
         Z4o6Pk6ov9ZDm7ORq8JD2JM2eva2jMf8abS+mYAnEcKHdLuJZYbJpM54j9KwVPB1etXX
         UYc6lV4XsQEt5UXgddKWSNQ/Yw1CEQ7xK+eo2FCFGy5nbx1x0EQc+rv3i0P3eFFDivbm
         +BHw==
X-Gm-Message-State: APjAAAVi/B7aPazn2iQqfOKMVDyoJJRvCaj5yo4Oh+O4DbXV8XJLBJXU
        BQ3EFzrzsy3bKud/mUxjq/Udm3aGuciQq3RppFLksw==
X-Google-Smtp-Source: APXvYqx/VdX9YqCQEyiW4XnEisCFHzQYBqw32KTYGAM0TImTSh77qOuv1DWEAamEZmfxmO9fg+dUSXIQ5gniOfallrs=
X-Received: by 2002:a5d:8908:: with SMTP id b8mr12792305ion.237.1567803073198;
 Fri, 06 Sep 2019 13:51:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190906092350.13929-1-shmulik.ladkani@gmail.com> <CAF=yD-LX-XemD8QpU-=Hn5bdX8jPP6nWS1YgpDxcrBu7sdBxRg@mail.gmail.com>
In-Reply-To: <CAF=yD-LX-XemD8QpU-=Hn5bdX8jPP6nWS1YgpDxcrBu7sdBxRg@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 6 Sep 2019 13:51:01 -0700
Message-ID: <CAKgT0UdH1MkZ--F-sG-L-yu63-nX_YYRZ2eum9aNg1dTY6Fmyg@mail.gmail.com>
Subject: Re: [PATCH v2 net] net: gso: Fix skb_segment splat when splitting
 gso_size mangled skb having linear-headed frag_list
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Shmulik Ladkani <shmulik@metanetworks.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>, eyal@metanetworks.com,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 6, 2019 at 1:15 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Fri, Sep 6, 2019 at 5:23 AM Shmulik Ladkani <shmulik@metanetworks.com> wrote:
> >
> > Historically, support for frag_list packets entering skb_segment() was
> > limited to frag_list members terminating on exact same gso_size
> > boundaries. This is verified with a BUG_ON since commit 89319d3801d1
> > ("net: Add frag_list support to skb_segment"), quote:
> >
> >     As such we require all frag_list members terminate on exact MSS
> >     boundaries.  This is checked using BUG_ON.
> >     As there should only be one producer in the kernel of such packets,
> >     namely GRO, this requirement should not be difficult to maintain.
> >
> > However, since commit 6578171a7ff0 ("bpf: add bpf_skb_change_proto helper"),
> > the "exact MSS boundaries" assumption no longer holds:
> > An eBPF program using bpf_skb_change_proto() DOES modify 'gso_size', but
> > leaves the frag_list members as originally merged by GRO with the
> > original 'gso_size'. Example of such programs are bpf-based NAT46 or
> > NAT64.
> >
> > This lead to a kernel BUG_ON for flows involving:
> >  - GRO generating a frag_list skb
> >  - bpf program performing bpf_skb_change_proto() or bpf_skb_adjust_room()
> >  - skb_segment() of the skb
> >
> > See example BUG_ON reports in [0].
> >
> > In commit 13acc94eff12 ("net: permit skb_segment on head_frag frag_list skb"),
> > skb_segment() was modified to support the "gso_size mangling" case of
> > a frag_list GRO'ed skb, but *only* for frag_list members having
> > head_frag==true (having a page-fragment head).
> >
> > Alas, GRO packets having frag_list members with a linear kmalloced head
> > (head_frag==false) still hit the BUG_ON.
> >
> > This commit adds support to skb_segment() for a 'head_skb' packet having
> > a frag_list whose members are *non* head_frag, with gso_size mangled, by
> > disabling SG and thus falling-back to copying the data from the given
> > 'head_skb' into the generated segmented skbs - as suggested by Willem de
> > Bruijn [1].
> >
> > Since this approach involves the penalty of skb_copy_and_csum_bits()
> > when building the segments, care was taken in order to enable this
> > solution only when required:
> >  - untrusted gso_size, by testing SKB_GSO_DODGY is set
> >    (SKB_GSO_DODGY is set by any gso_size mangling functions in
> >     net/core/filter.c)
> >  - the frag_list is non empty, its item is a non head_frag, *and* the
> >    headlen of the given 'head_skb' does not match the gso_size.
> >
> > [0]
> > https://lore.kernel.org/netdev/20190826170724.25ff616f@pixies/
> > https://lore.kernel.org/netdev/9265b93f-253d-6b8c-f2b8-4b54eff1835c@fb.com/
> >
> > [1]
> > https://lore.kernel.org/netdev/CA+FuTSfVsgNDi7c=GUU8nMg2hWxF2SjCNLXetHeVPdnxAW5K-w@mail.gmail.com/
> >
> > Fixes: 6578171a7ff0 ("bpf: add bpf_skb_change_proto helper")
> > Suggested-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Eric Dumazet <eric.dumazet@gmail.com>
> > Cc: Alexander Duyck <alexander.duyck@gmail.com>
> > Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
>
> Reviewed-by: Willem de Bruijn <willemb@google.com>

Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
