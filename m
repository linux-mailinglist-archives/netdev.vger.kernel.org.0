Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32CA22F3B2
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 17:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729363AbgG0PTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 11:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728297AbgG0PTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 11:19:37 -0400
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F75C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 08:19:37 -0700 (PDT)
Received: by mail-ua1-x943.google.com with SMTP id r63so5497832uar.9
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 08:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EDxI6+unuaO92kJtiTYraiotuz9XLYGTumhWQV0g77c=;
        b=R5lb6GQvXOIXEhZS+g6hBMlbkczsHjLt52+NSSdISJuIRbfBFYC6oyQIYdLvaDpo6+
         tUIirH3dPl6yfYQXrWmBgBsAb6q9kCFx2jnhIl/AJoKo85+udxr4t2iRy+m09UP5ZDGM
         NH4AoEvLgZl0GbFliqbOJwaVMpbjTAlo1Xu4B62vl4bVhV2QYqcHILe8dFvyIq9MHlkm
         UtN5cgE3KDQ68AXuOOeObwrN3ZbV9RyO6hTh4OcERHQlIMc4CwmnD/+Cj/Jb7wPD4rt4
         PsNfpCG+dfY0sb0EFXZU8C/lSDEaz4PASvmu/ef54b6ozgjIz5FG0jwzNxjM7x1vEtNJ
         cmFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EDxI6+unuaO92kJtiTYraiotuz9XLYGTumhWQV0g77c=;
        b=ZSmftNNIyuzOvMhJgL9AGh9Iq5o+HEWbAh0eOFqjDjle9edTwIKaOqnDzbxQMg+PYA
         oHbsjXuL62o5n2kMSlOFVNggq9SKwIm5DuxPtq7L0rxBN/zi0rDU7M0HJo3xvscpuY4m
         v+RVchThJeoaTJB82zUPrHgYTd9hHMNCBs9UfrPQPAi+mPS54LuGCRj84FDsLXpqHKtp
         VWHUfdhAxq7uALF8cF1UQlIDiIqgzleCwTBYC5Iue21T1Qfal7+Obic6fSkmguHXUxlb
         ECgWLv9GBsNTp3LIoQr5UFCoXwzkPZiA8WmAKKHb58S2NNgm6jdffjFeapOAJFfEj/z3
         p1Mw==
X-Gm-Message-State: AOAM531U0PfGs/ONcp9ZuBAaXXXYleIdamLNc/L/RH4V2kAatPF6+8ix
        BLCFR2C+P9Dh12KQ6RI8Jb3PcR/kiXieeYhy98m7IA==
X-Google-Smtp-Source: ABdhPJyo574sdke60BsqPHDu+Woo7YGwrO8bownFPxw+4y0ecWQolq+j36sHVlEA2mUIRgfeIwKsx9LQ36P98C4RQBo=
X-Received: by 2002:ab0:5e01:: with SMTP id z1mr17066020uag.118.1595863176058;
 Mon, 27 Jul 2020 08:19:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200727052846.4070247-1-jonathan.lemon@gmail.com> <20200727052846.4070247-14-jonathan.lemon@gmail.com>
In-Reply-To: <20200727052846.4070247-14-jonathan.lemon@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 27 Jul 2020 08:19:24 -0700
Message-ID: <CANn89i+nXhXzxC3C+UY0xAMFeUxZSSD8R5MP2mmttjZa+5-Hxg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 13/21] net/tcp: Pad TCP options out to a fixed size
 for netgpu
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        borisp@mellanox.com, david@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 12:51 AM Jonathan Lemon
<jonathan.lemon@gmail.com> wrote:
>
> From: Jonathan Lemon <bsd@fb.com>
>
> The "header splitting" feature used by netgpu doesn't actually parse
> the incoming packet header.  Instead, it splits the packet at a fixed
> offset.  In order for this to work, the sender needs to send packets
> with a fixed header size.
>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  net/ipv4/tcp_output.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index d8f16f6a9b02..e8a74d0f7ad2 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -438,6 +438,7 @@ struct tcp_out_options {
>         u8 ws;                  /* window scale, 0 to disable */
>         u8 num_sack_blocks;     /* number of SACK blocks to include */
>         u8 hash_size;           /* bytes in hash_location */
> +       u8 pad_size;            /* additional nops for padding */
>         __u8 *hash_location;    /* temporary pointer, overloaded */
>         __u32 tsval, tsecr;     /* need to include OPTION_TS */
>         struct tcp_fastopen_cookie *fastopen_cookie;    /* Fast open cookie */
> @@ -562,6 +563,17 @@ static void tcp_options_write(__be32 *ptr, struct tcp_sock *tp,
>         smc_options_write(ptr, &options);
>
>         mptcp_options_write(ptr, opts);
> +
> +#if IS_ENABLED(CONFIG_NETGPU)
> +       /* pad out options */
> +       if (opts->pad_size) {
> +               int len = opts->pad_size;
> +               u8 *p = (u8 *)ptr;
> +
> +               while (len--)
> +                       *p++ = TCPOPT_NOP;
> +       }
> +#endif
>  }
>
>  static void smc_set_option(const struct tcp_sock *tp,
> @@ -826,6 +838,14 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
>                         opts->num_sack_blocks * TCPOLEN_SACK_PERBLOCK;
>         }
>
> +#if IS_ENABLED(CONFIG_NETGPU)
> +       /* force padding */
> +       if (size < 20) {
> +               opts->pad_size = 20 - size;
> +               size += opts->pad_size;
> +       }
> +#endif
> +

This is obviously wrong, as any kernel compiled with CONFIG_NETGPU
will fail all packetdrill tests suite.

Also the fixed 20 value is not pretty.
