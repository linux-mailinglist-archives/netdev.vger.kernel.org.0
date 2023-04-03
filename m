Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B206D4448
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 14:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbjDCMX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 08:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbjDCMX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 08:23:26 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427F311643;
        Mon,  3 Apr 2023 05:23:21 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id j7so34508999ybg.4;
        Mon, 03 Apr 2023 05:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680524600;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CV4hHC1sA+rpldeBpV1/b7vAGylUfHwT+E3ZkcI7AzQ=;
        b=XeY0WrqhUZ/g4ek0FdjnYgmHtmbG3qzJaYZhjQVJ+o4apLcLXmBZIgDwVfoD9nsCcR
         W9eqXIWeT0u/Ju66kuEfhNKS5YuYZ6gTBUoWdf1tda8Aohjhs3tMB1MX23u+Glj/6HIA
         nntCLT+9O5By/sSUimOneh0Yi+cPcWi/mMArl44T61hPh3hugZa4QwammMMwkGtBAShY
         5fyJU4xFw2F/Jwr3qQg10NHA3UyAsS3h7z+HH4MWN+Np/6laneGn5JcnBK8x4wRJQduc
         QbuAv+mm5RHdwkoPewL7wlEMTfJceKqukF6qvVs84j9YFSpo8KNA5ImkRkB+p7IgH+fF
         adXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680524600;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CV4hHC1sA+rpldeBpV1/b7vAGylUfHwT+E3ZkcI7AzQ=;
        b=JBNy0zr1uv9+tA0lv+ww/RoBlLjWhJVcalDs9prU+Gsbg8tjHGi9OzbPgu6STI2umG
         idl95Agho6NhfO/J3MBlC945cfKBAz1RTLRedxOYTJkLsiyjjiSyrDhunI3hX3PYCW2a
         EBm254XtOfrzHwe4+dB4c3u5odM0GGagMXwjkyYO+JmdwQIhv9Zk48DjbpEyo3QKbIv7
         JtylNNylD7iVkFQnsMocE7KAlueIzcd3aLqQDHRwWG+ezWsWI4q1hCm/amPe6ICHgKQH
         fbtit1r1gqRZSj0dXHJYgDVEn+PQTUjZj9rs4366Rtite75dAJeW9Q/nvoaNLmzxoRTv
         8m7A==
X-Gm-Message-State: AAQBX9f1thS8SEP5cEfbUlb5SpypOlDIYE8Bx2w9si/auN/x+c7n5yKL
        74QJB4Jfe98CWAkqmd7iaX1Ibn6w/NiZMLG9ALE=
X-Google-Smtp-Source: AKy350ZR8wMNk5BPNSKULI1BOgMr9PfQo/lOb8oFr5/gsE836uLouUYLoDYaRgjlrDPjkrz5SCNytqcHsm4bIec2wlM=
X-Received: by 2002:a05:6902:154a:b0:b3c:637f:ad00 with SMTP id
 r10-20020a056902154a00b00b3c637fad00mr23972399ybu.5.1680524600282; Mon, 03
 Apr 2023 05:23:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230329180502.1884307-1-kal.conley@dectris.com> <20230329180502.1884307-7-kal.conley@dectris.com>
In-Reply-To: <20230329180502.1884307-7-kal.conley@dectris.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 3 Apr 2023 14:23:09 +0200
Message-ID: <CAJ8uoz0a3gJgWDxP0zPLsiWzUZHmGqRbrumdRq2Gv1HdVm4ObQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 06/10] xsk: Add check for unaligned
 descriptors that overrun UMEM
To:     Kal Conley <kal.conley@dectris.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 at 20:11, Kal Conley <kal.conley@dectris.com> wrote:
>
> Make sure unaligned descriptors that straddle the end of the UMEM are
> considered invalid. This check needs to happen before the page boundary
> and contiguity checks in xp_desc_crosses_non_contig_pg(). Check this in
> xp_unaligned_validate_desc() instead like xp_check_unaligned() already
> does.
>
> Fixes: 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API")
> Signed-off-by: Kal Conley <kal.conley@dectris.com>
> ---
>  include/net/xsk_buff_pool.h | 9 ++-------
>  net/xdp/xsk_queue.h         | 1 +
>  2 files changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> index 3e952e569418..d318c769b445 100644
> --- a/include/net/xsk_buff_pool.h
> +++ b/include/net/xsk_buff_pool.h
> @@ -180,13 +180,8 @@ static inline bool xp_desc_crosses_non_contig_pg(struct xsk_buff_pool *pool,
>         if (likely(!cross_pg))
>                 return false;
>
> -       if (pool->dma_pages_cnt) {
> -               return !(pool->dma_pages[addr >> PAGE_SHIFT] &
> -                        XSK_NEXT_PG_CONTIG_MASK);
> -       }
> -
> -       /* skb path */
> -       return addr + len > pool->addrs_cnt;
> +       return pool->dma_pages_cnt &&
> +              !(pool->dma_pages[addr >> PAGE_SHIFT] & XSK_NEXT_PG_CONTIG_MASK);
>  }
>
>  static inline u64 xp_aligned_extract_addr(struct xsk_buff_pool *pool, u64 addr)
> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index bfb2a7e50c26..66c6f57c9c44 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -162,6 +162,7 @@ static inline bool xp_unaligned_validate_desc(struct xsk_buff_pool *pool,
>                 return false;
>
>         if (base_addr >= pool->addrs_cnt || addr >= pool->addrs_cnt ||
> +           addr + desc->len > pool->addrs_cnt ||
>             xp_desc_crosses_non_contig_pg(pool, addr, desc->len))
>                 return false;
>

Let me just check that I understand the conditions under which this
occurs. When selecting unaligned mode, there is no check that the size
is divisible by the chunk_size as is the case in aligned mode. So we
can register a umem that is for example 15 4K pages plus 100 bytes and
in this case the second to last page will be marked as contiguous
(with the CONTIG_MASK) and a packet of length 300 starting at 15*4K -
100 will be marked as valid even though it extends 100 bytes outside
the umem which ends at 15*4K + 100. Did I get this correctly? If so,
some more color in the commit message would be highly appreciated.

The best way around this would have been if we made sure that the umem
size was always divisible by PAGE_SIZE, but as there are users out
there that might have an unaligned umem of an slightly odd size, we
cannot risk breaking their program. PAGE_SIZE is also architecture
dependent and even configurable within some. So I think your solution
here is the right one.

This one should be considered a bug fix to and go to bpf. Good catch
if I understood the problem correctly above.



> --
> 2.39.2
>
