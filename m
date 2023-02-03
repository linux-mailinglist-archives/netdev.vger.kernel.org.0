Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4D66891CD
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 09:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbjBCISQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 03:18:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232029AbjBCISO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 03:18:14 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE41A113DD
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 00:18:08 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-4ff1fa82bbbso58770847b3.10
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 00:18:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=I3trujD/SyQFMKUWY/3A1+Sekbs2a0F3H4j9MYS+kXs=;
        b=RP2V+MAilQ03WOXuyLBnWXhJTGBXpUqnovi9Cp2IKm2hhwEEur49lmDMaiSZJACA6C
         I+8pXYlbq1hYKueeOd1GSgdQJBb11HwaCTGtTQOEtxCfD31vPkXx/dPID1k3ZABfDzkR
         scVaF3qOMQ46KlyDI9OS0XW40zpAELANw6IMb4tVPXX5XG/miIU4B203RFR7NNjT3M1F
         npWFuDp96WDeqkJq1fDzoSdOjp8JPSorZ6AqUaipaeFhgNJCVuJNXziiZDT+7WFsN0B7
         dcEO1PiUD8vJ1gReSCy/NA4WGKE6nBRhe9JpVXARk06FWeM2VzZKSuZw2TDZTzTDdoXD
         BSkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I3trujD/SyQFMKUWY/3A1+Sekbs2a0F3H4j9MYS+kXs=;
        b=QhzUZwK9XyPq4XNe7vkRFPRBafzRNJz10pCbJ2ETYGucaFJgX5PTFnSy7v5Fnyo5d9
         rCrvrFl/bbsCJD/1lE12C9jja6R6wvX6mpinux+QDJcFn0nY3eyG9vtjRssux7zwy34r
         88l2Pr2Y2Ssru4JfAu2R2aFib8yygvr9smb6soU8WEBEQjfG5XJ2uLTP0lNI8y36zfdH
         apIb1axE6NITrKDaD+EQvat2V3ez199k9hLMjSA5BFN6r3eJBFM9ewNllTyGiP2CMG9d
         80MuY9yZ7QTHxipZ+6O7RiC5zOZLAX9Kom+iLd6g0K1z9lvreYsWCPuGhTEK+UrkGzJ0
         e7Tw==
X-Gm-Message-State: AO0yUKV1SOlYWU0bprIY91AKusObmyUibSmPUJITf/iaYof9ZgtY7mVu
        QhHVgp9C+WggPsCFSRQkKuZ4mDyJN8omsXB59rqUSQ==
X-Google-Smtp-Source: AK7set+IudFmIqG53UnZVYZ2zXaLFCJNXRnxEhGlTID7CSheQ6cYfoNm/xzJ3PXAynNz5LwJE9eBlVWrK286Nr89hxc=
X-Received: by 2002:a81:ae0d:0:b0:4e0:8133:2a5a with SMTP id
 m13-20020a81ae0d000000b004e081332a5amr1095900ywh.187.1675412287455; Fri, 03
 Feb 2023 00:18:07 -0800 (PST)
MIME-Version: 1.0
References: <20230202185801.4179599-1-edumazet@google.com> <20230202185801.4179599-5-edumazet@google.com>
 <db71bb74eb61fa09226ef5f2071747f35d67df82.camel@redhat.com>
In-Reply-To: <db71bb74eb61fa09226ef5f2071747f35d67df82.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 3 Feb 2023 09:17:55 +0100
Message-ID: <CANn89iLj8hC7jgb5jDNi01nKqikGbgKMtFvbZDxWi4Qoi1y8fw@mail.gmail.com>
Subject: Re: [PATCH net-next 4/4] net: add dedicated kmem_cache for
 typical/small skb->head
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Alexander Duyck <alexanderduyck@fb.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 3, 2023 at 8:59 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Thu, 2023-02-02 at 18:58 +0000, Eric Dumazet wrote:
> > Note: after Kees Cook patches and this one, we might
> > be able to revert commit
> > dbae2b062824 ("net: skb: introduce and use a single page frag cache")
> > because GRO_MAX_HEAD is also small.
>
> I guess I'll need some time to do the relevant benchmarks, but I'm not
> able to schedule them very soon.

No worries, this can be done later.
Note the results might depend on SLUB/SLAB choice.

>
> > @@ -486,6 +499,21 @@ static void *kmalloc_reserve(unsigned int *size, gfp_t flags, int node,
> >       void *obj;
> >
> >       obj_size = SKB_HEAD_ALIGN(*size);
> > +     if (obj_size <= SKB_SMALL_HEAD_CACHE_SIZE &&
> > +         !(flags & KMALLOC_NOT_NORMAL_BITS)) {
> > +
> > +             /* skb_small_head_cache has non power of two size,
> > +              * likely forcing SLUB to use order-3 pages.
> > +              * We deliberately attempt a NOMEMALLOC allocation only.
> > +              */
> > +             obj = kmem_cache_alloc_node(skb_small_head_cache,
> > +                             flags | __GFP_NOMEMALLOC | __GFP_NOWARN,
> > +                             node);
> > +             if (obj) {
> > +                     *size = SKB_SMALL_HEAD_CACHE_SIZE;
> > +                     goto out;
> > +             }
>
> In case kmem allocation failure, should we try to skip the 2nd
> __GFP_NOMEMALLOC attempt below?

We could, but my reasoning was that we might find an object in the
other kmem_cache freelist.

kmalloc-1 objects tend to use smaller page orders, so are more likely
to succeed if
there is no order-3 page available in the buddy allocator.(I mentioned
this in the comment)


>
> I *think* non power of two size is also required to avoid an issue
> plain (no GFP_DMA nor __GFP_ACCOUNT) allocations in case of fallback to
> kmalloc(), to prevent skb_kfree_head() mis-interpreting skb->head as
> kmem_cache allocated.

Indeed there are multiple cases explaining why SKB_SMALL_HEAD_CACHE_SIZE
needs to be a non power of two.
