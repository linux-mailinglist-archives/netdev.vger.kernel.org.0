Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE6C1AAE1B
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 23:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391092AbfIEVv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 17:51:59 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41529 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391065AbfIEVv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 17:51:59 -0400
Received: by mail-ed1-f67.google.com with SMTP id z9so4308400edq.8
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 14:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AgDu877b01o+mGa77cQeIrrOtnstLddy5pnIthWNK8w=;
        b=dbZLcpEjCpKL98HkxTp9cdBldfZkJrJnyUIUAq4zSDGZ+B/FclAFkwWCaGx5sbtgRu
         Ri0ECB3u9uNJJ2n8Cy6bAlz0VNBEKJsG5HshagS7JFb6fWlrE/XaQPSGedEggm8NfhNC
         DZYB5oSI8VVLN5ib/FTkk0hNWl2nFJ2fQvpgUjM9JSWB4vOZybUCMjWcOMDdHargWWlK
         6+Wqe/DamlR9fAfKY/dr1n6gYt4rwv12Fs3U9cVNWTbylD/F9jnsqTFnyKNsBKavuQuj
         ikOWTsI+entfgwnbJFZ+RVdbY+uNhI80NU+WbBGDbTEP6OsHIq8MSN6t8hcx8k+pey/8
         Npmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AgDu877b01o+mGa77cQeIrrOtnstLddy5pnIthWNK8w=;
        b=HgLtQ8f8DmZWB7BlXl4dLMhcfu2LGJaQbc42pEi8A3LSuO9VgK6QFGgR+kHDLNb9bX
         6xO6L97ofc6ts0dO1gsuUkRpSSHMqw9cpKqPaUa+vlN3hEQb/llQGXW8U2sSYy9ZN/uz
         XgNhgQTMV1aO2lYH6ERcd1hfQyV437zpeAWoVISvpYJZlRN+cMjQmw3HqnvZIfDqySoA
         Ag8ZTjvSVNngzB4cLKSZUYdcImUNs6p2v5iMhxaGQZmBdMcH9hFvN0qkP8BbZtr0eOFR
         rGfFgDLPjAH+aLFqvSDBuKP27YpDa3gJ5BlBK98w5tqnYDHu/Si6wX84Q8U1GX2Z6EOP
         C5UA==
X-Gm-Message-State: APjAAAXfrTH01GraPce8xc2Wbxf0kwmxKrVvoZRqvihCBs7MllFj9Q5t
        EepNoHZOCSmVcibEkVcPCqL3bwb80DawjSCE+cc=
X-Google-Smtp-Source: APXvYqxXDnc947a9q+BiPUyTBRuaRL8kbqlA1LcA5febz3gPHDG2cbVCZTZ/B/KfXuXmra9WUnoioEMdK6AASbSNXhY=
X-Received: by 2002:a17:906:cf85:: with SMTP id um5mr4646722ejb.186.1567720316915;
 Thu, 05 Sep 2019 14:51:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190905183633.8144-1-shmulik.ladkani@gmail.com>
In-Reply-To: <20190905183633.8144-1-shmulik.ladkani@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 5 Sep 2019 17:51:20 -0400
Message-ID: <CAF=yD-J9Ax9f7BsGBFAaG=QU6CPVw6sSzBkZJOHRW-m6o49oyw@mail.gmail.com>
Subject: Re: [PATCH net] net: gso: Fix skb_segment splat when splitting
 gso_size mangled skb having linear-headed frag_list
To:     Shmulik Ladkani <shmulik@metanetworks.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, eyal@metanetworks.com,
        netdev <netdev@vger.kernel.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 5, 2019 at 2:36 PM Shmulik Ladkani <shmulik@metanetworks.com> wrote:
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

I thought the idea was to check skb_headlen(list_skb), as that is the
cause of the problem. Is skb_headlen(head_skb) a good predictor of
that? I can certainly imagine that it is, just not sure.

Thanks for preparing the patch, and explaining the problem and
solution clearly in the commit message. I'm pretty sure I'll have
forgotten the finer details next time we have to look at this
function again.
