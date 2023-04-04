Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83BB36D5A8C
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 10:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbjDDIPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 04:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234109AbjDDIPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 04:15:47 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9571FF5
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 01:15:42 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id eg48so127053370edb.13
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 01:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1680596141;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7ZWSy31nxZx1PXrJ/a/Nio7iVH3OxfiLHZKduoDBB98=;
        b=FteqBbAS9GU7d/CcIKLll4vLYKmpQvsOdqlvYAoJwULBBi/Y0on4cacwGnABacI2Fj
         L/UCNRzfGFcIV7VW99CVyvKbh72ec1sYa6CxTDURk/WHNWrbVN3ecXUuoEk0MEA+x8zC
         1ipN/kACbc0hZpVcsf0PRsxHAPm/WvoSbj2Lg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680596141;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7ZWSy31nxZx1PXrJ/a/Nio7iVH3OxfiLHZKduoDBB98=;
        b=5PcQ3NEOe325GuQOlogZFZUXZTCSC6tg8T8ue+7SxKljXQ9jndD8MPcmEb8isdLELc
         uZq7wMUBk0BLTsUyxHjklH6O4YN5j2771tS50dDsz0Gz3w8J6BiG43UvOpR81pPHy/gM
         gaFcHQUpeRM0OYk96fA2gbRCllF9b9/I/MLEUqN75OfhRFDHTe3nS7IPCvBY2nw3Kj8E
         /21C9ZVVUOnDvNTlujgdmtx7/+/YqkjU1y8p/fIilX1Nr2snuYr/YU4E0acgfO7ENwkb
         Pqr450PX1GpDk6m7bhO/UL3PTVZ/m2bTrfm/SDLti3oFAJi7dd75TIeDEQj3Uksyw5+P
         NiLw==
X-Gm-Message-State: AAQBX9eX1kJvtub19RgXXpyEJL0r1Q6eznEyjCIwAA5agfiigR4JOV5L
        f8KwsciQRd+jTawTvwqPra0LVH9Qo02K+3Ve757ikA==
X-Google-Smtp-Source: AKy350YlDyMLH1uHq6GEY6M6jNYluB2enrZLb7RkppafkVaCsKKheSOMENKLDrNGKHxMVxTkwwLxLF9mbkQ3ShK6sBk=
X-Received: by 2002:a17:906:c197:b0:947:54ef:374 with SMTP id
 g23-20020a170906c19700b0094754ef0374mr765759ejz.0.1680596140889; Tue, 04 Apr
 2023 01:15:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230329180502.1884307-1-kal.conley@dectris.com>
 <20230329180502.1884307-9-kal.conley@dectris.com> <CAJ8uoz330DWzHabpqd+HaeAxBi2gr+GOTtnS9WJFWrt=6DaeWQ@mail.gmail.com>
In-Reply-To: <CAJ8uoz330DWzHabpqd+HaeAxBi2gr+GOTtnS9WJFWrt=6DaeWQ@mail.gmail.com>
From:   Kal Cutter Conley <kal.conley@dectris.com>
Date:   Tue, 4 Apr 2023 10:20:21 +0200
Message-ID: <CAHApi-nfBM=i1WeZ-jtHN87AWPvURo0LygT9yYxF=cUeYthXBQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 08/10] xsk: Support UMEM chunk_size > PAGE_SIZE
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Is not the max 64K as you test against XDP_UMEM_MAX_CHUNK_SIZE in
> xdp_umem_reg()?

The absolute max is 64K. In the case of HPAGE_SIZE < 64K, then it
would be HPAGE_SIZE.

> > diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> > index e96a1151ec75..ed88880d4b68 100644
> > --- a/include/net/xdp_sock.h
> > +++ b/include/net/xdp_sock.h
> > @@ -28,6 +28,9 @@ struct xdp_umem {
> >         struct user_struct *user;
> >         refcount_t users;
> >         u8 flags;
> > +#ifdef CONFIG_HUGETLB_PAGE
>
> Sanity check: have you tried compiling your code without this config set?

Yes. The CI does this also on one of the platforms (hence some of the
bot errors in v1).

> >  static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
> >  {
> > +#ifdef CONFIG_HUGETLB_PAGE
>
> Let us try to get rid of most of these #ifdefs sprinkled around the
> code. How about hiding this inside xdp_umem_is_hugetlb() and get rid
> of these #ifdefs below? Since I believe it is quite uncommon not to
> have this config enabled, we could simplify things by always using the
> page_size in the pool, for example. And dito for the one in struct
> xdp_umem. What do you think?

I used #ifdef for `page_size` in the pool for maximum performance when
huge pages are disabled. We could also not worry about optimizing this
uncommon case though since the performance impact is very small.
However, I don't find the #ifdefs excessive either.

> > +static void xp_check_dma_contiguity(struct xsk_dma_map *dma_map, u32 page_size)
> >  {
> > -       u32 i;
> > +       u32 stride = page_size >> PAGE_SHIFT; /* in order-0 pages */
> > +       u32 i, j;
> >
> > -       for (i = 0; i < dma_map->dma_pages_cnt - 1; i++) {
> > -               if (dma_map->dma_pages[i] + PAGE_SIZE == dma_map->dma_pages[i + 1])
> > -                       dma_map->dma_pages[i] |= XSK_NEXT_PG_CONTIG_MASK;
> > -               else
> > -                       dma_map->dma_pages[i] &= ~XSK_NEXT_PG_CONTIG_MASK;
> > +       for (i = 0; i + stride < dma_map->dma_pages_cnt;) {
> > +               if (dma_map->dma_pages[i] + page_size == dma_map->dma_pages[i + stride]) {
> > +                       for (j = 0; j < stride; i++, j++)
> > +                               dma_map->dma_pages[i] |= XSK_NEXT_PG_CONTIG_MASK;
> > +               } else {
> > +                       for (j = 0; j < stride; i++, j++)
> > +                               dma_map->dma_pages[i] &= ~XSK_NEXT_PG_CONTIG_MASK;
> > +               }
>
> Still somewhat too conservative :-). If your page size is large you
> will waste a lot of the umem.  For the last page mark all the 4K
> "pages" that cannot cross the end of the umem due to the max size of a
> packet with the XSK_NEXT_PG_CONTIG_MASK bit. So you only need to add
> one more for-loop here to mark this, and then adjust the last for-loop
> below so it only marks the last bunch of 4K pages at the end of the
> umem as not contiguous.

I don't understand the issue. The XSK_NEXT_PG_CONTIG_MASK bit is only
looked at if the descriptor actually crosses a page boundary. I don't
think the current implementation wastes any UMEM.
