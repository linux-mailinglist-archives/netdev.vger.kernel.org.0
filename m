Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2536ED829
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 00:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbjDXWxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 18:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbjDXWxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 18:53:08 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEC776BA
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 15:53:06 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-505035e3368so8739004a12.0
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 15:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1682376785; x=1684968785;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Lb9V5qEz8uwYJMRGS2n+7cwxt++F8Vl5cfnWbWpg2NA=;
        b=oqBZV0kBPqtAYvC/4m7in4/HJVjt2Cq2tq+xjPyWe6vOXlUcae6M/NmBFzDz/FPGrX
         AG2o8U04UdF21KwSmuhBGZ1q2DHETDwPFLMrgZrFyDGnBs4S312y0jexltI499BS+Nbf
         U4J9A0MQ8UK8x7eGinOq2eMOG1HC++DT1KCug=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682376785; x=1684968785;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lb9V5qEz8uwYJMRGS2n+7cwxt++F8Vl5cfnWbWpg2NA=;
        b=H/gyTrFmng+7tP+PcCVN80SYnvMC3GwzXUl7oSKvpkmJpCnj44GS/rlp+U7+Kj0yZo
         hH78AWeAmJD+e5mq17/LdzFGZX8OqgUHNoPVilFPFw+oDtUUogSY5KbPBqNmTnDnobI1
         ALqbb9RKJaKWQ2tF08ZRdc6Ex3dYNF/KVk42CwZZRenL6n6ho2J4ytyW2nb/HBgqOzVj
         uBluT0ybXP46DXEZBiZnqh+hyvVuA5To+QSHh0lxUeZKksF7HmHx6OwolyA1E7vmQouF
         FddSKajbtmuaPUESG9BEA/rvKIPWiXa6TWnhGaa4oDxKuq6kQoiOGue00KrQBQjzMMy8
         NLAQ==
X-Gm-Message-State: AAQBX9ez1i0lGuvd1HR+0owedxaOG9910h0A2Bpr4m+EMgbx1jFojYsb
        t9Hbh8ytgqoSaeK7IbYcjE8e6jzaMPEOxA0hOL4YuA==
X-Google-Smtp-Source: AKy350bV1SaUES6IvRlxAiUCsXAqw751wdGR/d9hfAt2fNVjRZuydHYBPeewsR9bUeFBdElZDsrQXIucfmuElG1ioTY=
X-Received: by 2002:aa7:d490:0:b0:508:422b:a61 with SMTP id
 b16-20020aa7d490000000b00508422b0a61mr14430531edr.4.1682376785287; Mon, 24
 Apr 2023 15:53:05 -0700 (PDT)
MIME-Version: 1.0
References: <20230423075335.92597-1-kal.conley@dectris.com> <6446d34f9568_338f220872@john.notmuch>
In-Reply-To: <6446d34f9568_338f220872@john.notmuch>
From:   Kal Cutter Conley <kal.conley@dectris.com>
Date:   Tue, 25 Apr 2023 00:52:53 +0200
Message-ID: <CAHApi-=Vr4VARgoDNB1T906gfDNB5L5_U24zE=ZHQi+qd__e8w@mail.gmail.com>
Subject: Re: [PATCH] xsk: Use pool->dma_pages to check for DMA
To:     John Fastabend <john.fastabend@gmail.com>
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
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Compare pool->dma_pages instead of pool->dma_pages_cnt to check for an
> > active DMA mapping. pool->dma_pages needs to be read anyway to access
> > the map so this compiles to more efficient code.
>
> Was it noticable in some sort of performance test?

This patch is part of the patchset found at
https://lore.kernel.org/all/20230412162114.19389-3-kal.conley@dectris.com/
which is being actively discussed and needs to be resubmitted anyway
because of a conflict. While the discussion continues, I am submitting
this patch by itself because I think it's an improvement on its own
(regardless of what happens with the rest of the linked patchset). On
one system, I measured a performance regression of 2-3% with xdpsock
and the linked changes without the current patch. With the current
patch, the performance regression was no longer observed.

> > diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> > index d318c769b445..a8d7b8a3688a 100644
> > --- a/include/net/xsk_buff_pool.h
> > +++ b/include/net/xsk_buff_pool.h
> > @@ -180,7 +180,7 @@ static inline bool xp_desc_crosses_non_contig_pg(struct xsk_buff_pool *pool,
> >       if (likely(!cross_pg))
> >               return false;
> >
> > -     return pool->dma_pages_cnt &&
> > +     return pool->dma_pages &&
> >              !(pool->dma_pages[addr >> PAGE_SHIFT] & XSK_NEXT_PG_CONTIG_MASK);
> >  }

I would consider the above code part of the "fast path". It may be
executed approximately once per frame in unaligned mode.

> This seems to be used in the setup/tear-down paths so your optimizing
> a control side. Is there a fast path with this code? I walked the
> ice driver. If its just setup code we should do whatever is more
> readable.

It is not only used in setup/tear-down paths (see above).
Additionally, I believe the code is also _more_ readable with this
patch applied. In particular, this patch reduces cognitive complexity
since people (and compilers) reading the code don't need to
additionally think about pool->dma_pages_cnt.

> Both the _alloc_ cases read neighboring free_heads_cnt so your saving a load I guess?
> This is so deep into micro-optimizing I'm curious if you could measure it?

It is saving a load which also reduces code size. This will affect
other decisions such as what to inline. Also in the linked patchset,
dma_pages and dma_pages_cnt do not share a cache line (on x86_64).

>
> >               } else {
> >                       xskb = &pool->heads[xp_aligned_extract_idx(pool, addr)];
>
> I'm not actually against optimizing but maybe another idea. Why do we have to
> check at all? Seems if the DMA has been disabled/unmapped the driver shouldn't
> be trying to call xsk_buff_alloc_batch? Then you can just drop the 'if' check.
>
> It feels to me the drivers shouldn't even be calling this after unmapping
> the dma. WDYT?

Many of these code paths are used both for ZC and copy modes. You
might be right that this particular case is only used with DMA.
