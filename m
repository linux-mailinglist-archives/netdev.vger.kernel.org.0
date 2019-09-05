Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61D71AAE04
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 23:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730454AbfIEVt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 17:49:57 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43047 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728769AbfIEVt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 17:49:57 -0400
Received: by mail-io1-f68.google.com with SMTP id u185so8164200iod.10
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 14:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2caBvcKHVMq32Jxk0H+/A3pTBK8PMMlG7a0kcmaGZZE=;
        b=oBjTKkYG+xqGujbBBfwdwHp9kgsw78wf6Y9tZMXaQLEKVfnUmslJem8kZWP3bQESOf
         Ww49Abh7kr4I/J/MIh+sQFWyXRVO3za6PyTgH6prjufPQu2YfjJtByjRP4XZNI1RDODy
         CHr7wbSSAMB3l88XxRCHbiHTJuPs/1JWmnz7WyVkKsASYBLCESXEt9V/HNV/N0IZJDyn
         P+Laf/bYo6ANC7VYzunVFfHywcSTg9Mgt/HVjZlEv49jUbzwZWLXPIkqNckeoFmpSZ/g
         Jnmkty6qftY83XaFodXpRl5W9gkMZtQk5T+k2Pl6QwpNlQwJ7aSjVC7FwUg7/ZXYM0FK
         Hzdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2caBvcKHVMq32Jxk0H+/A3pTBK8PMMlG7a0kcmaGZZE=;
        b=ecnmVezVVsC6F6npJVMxsei9ZRiB0AyE9SyXneCxAbbIAYdDZAiA7+usRW+B0XylkH
         nKtCttg5i4c+9tBiOEHEhQv5fqtagv/m4zGX4zxVhc1V1U1S4Z0PZnOJiABJeripxgcj
         zO9gZNwGZudE8/oRGMYlJyVjmJ10molZFVo7z4ekkVPy48nHM6K9XzGJZ4QWfZqS+sQs
         05giKcxe9jTZ9zVGQDbf9uZFPvb4ggi0Htjfd/7wVm7ixipaUaCuQ/euOupZGQfH1R7v
         OyccX6LuAEdXmAL669QRZ9w4N7YAdOr2H1wLXmdjQIrjPhIpbvugCXURxxrSmrFJEAgD
         OlWA==
X-Gm-Message-State: APjAAAUASMmKttVyuwdVTgK4yZdlzq7JJ8D6xnQjA/cnOAYtLbUe7IKQ
        9bonlJJZ/9cBi6MRLmweDhg5+1Vpspf41rcc+yY=
X-Google-Smtp-Source: APXvYqxnvT0XycGYyiZSAFGeVVd1/phIFE0qpExljVECVFXHdsK9i9+goSpKGmKxbx+627rQbvphR+vdNxkIAYgdaek=
X-Received: by 2002:a6b:fc02:: with SMTP id r2mr6228559ioh.15.1567720196055;
 Thu, 05 Sep 2019 14:49:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190905183633.8144-1-shmulik.ladkani@gmail.com>
In-Reply-To: <20190905183633.8144-1-shmulik.ladkani@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 5 Sep 2019 14:49:44 -0700
Message-ID: <CAKgT0Uf-OvKKycJz7aTZ93J=RdUuwd=SFS9C9pTngieDxe0uYQ@mail.gmail.com>
Subject: Re: [PATCH net] net: gso: Fix skb_segment splat when splitting
 gso_size mangled skb having linear-headed frag_list
To:     Shmulik Ladkani <shmulik@metanetworks.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        eyal@metanetworks.com, netdev <netdev@vger.kernel.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 5, 2019 at 11:36 AM Shmulik Ladkani
<shmulik@metanetworks.com> wrote:
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
> ---
>  net/core/skbuff.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index ea8e8d332d85..c4bd1881acff 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3678,6 +3678,24 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
>         sg = !!(features & NETIF_F_SG);
>         csum = !!can_checksum_protocol(features, proto);
>
> +       if (mss != GSO_BY_FRAGS &&
> +           (skb_shinfo(head_skb)->gso_type & SKB_GSO_DODGY)) {
> +               /* gso_size is untrusted.
> +                *
> +                * If head_skb has a frag_list with a linear non head_frag
> +                * item, and head_skb's headlen does not fit requested
> +                * gso_size, fall back to copying the skbs - by disabling sg.
> +                *
> +                * We assume checking the first frag suffices, i.e if either of
> +                * the frags have non head_frag data, then the first frag is
> +                * too.
> +                */
> +               if (list_skb && skb_headlen(list_skb) && !list_skb->head_frag &&
> +                   (mss != skb_headlen(head_skb) - doffset)) {
> +                       sg = false;
> +               }
> +       }
> +

I would change the order of the tests you use here so that we can
eliminate the possibility of needing to perform many tests for the
more common cases. You could probably swap "list_skb" and "mss !=
GSO_BY_FRAGS" since list_skb is more likely to be false for many of
the common cases such as a standard TSO send from a socket. You might
even consider moving the GSO_BY_FRAGS check toward the end of your
checks since SCTP is the only protocol that I believe uses it and the
likelihood of encountering it is much lower compared to other
protocols.

You could probably test for !list_skb->head_frag before seeing if
there is a headlen since many NICs would be generating frames using
head_frag, so in the GRO case you mentioned above it could probably
save you some effort on a number of NICs.

You might also consider moving this code up before we push the mac
header back on and instead of setting sg to false you could just clear
the NETIF_F_SG flag from features. It would save you from having to
then remove doffset in your last check.

>         if (sg && csum && (mss != GSO_BY_FRAGS))  {
>                 if (!(features & NETIF_F_GSO_PARTIAL)) {
>                         struct sk_buff *iter;
> --
> 2.19.1
>
