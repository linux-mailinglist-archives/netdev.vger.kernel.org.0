Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F82A63BEFC
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 12:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbiK2Laf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 06:30:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbiK2La2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 06:30:28 -0500
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AB745A2F
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 03:30:22 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-3704852322fso135392047b3.8
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 03:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=beRs3v7jTtffV0p/FLvTaPLQgJBDm8Bmos1QSc2OnQg=;
        b=sBhEiwr/0pfQsvYuZsg5OancpgGGQ/F1TyOgQbGZv0Qeo2dU7FUlQzA1I3J3+8uaxm
         FzfZ33IB42llF5M+fHanqtHmSZxJa3oAVFqz6OfBwh8eFtW3b8bPvmCjN5o+ASGKFXlL
         RA5dRJwa7hRNfTNTHvsaEtNiKITa++5nw4ao1l6PrCW8lTQjhXvgvq8E0FY4qwXBtxRF
         RuoskltTLQw/P+EGdujwgZTxPCJoB5nXOkWmOPs2q8HxH9FXj15gCQoUJRwhPbKbX7iL
         HzHCXo2qKPkQ9qW78owhG0r1apI7caB02euudvJdBzqZ4lAUEBWMnFgazqQ2ACb8HJOZ
         xDGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=beRs3v7jTtffV0p/FLvTaPLQgJBDm8Bmos1QSc2OnQg=;
        b=BBeW33yECuGiWHoSrLM868Gm5Gryk/BRzbT4oJW+zgG6shd6nfhjayK2wrdXkVz8oG
         FG7Jy9XAFySLAXs1ao6He/xgyxoZwAhYgzeFdQjWis/rI6UDw+3oqL2xku95RQBLMANO
         6dOWarxZZCYjojpJGeuVvnRGZWe47tz0++lppfeQ3ogZGRENbacPCELbpTcOIemDLnTy
         KGkQ6CRqkVyKerTLk6aP5Qo5cc5ItHUxXtS9YCt4ZyZW/BNl6iCdhQSS2BlxHGP6lyqs
         i+CPfaq/iklJNHjyyExSzhQ/mouMkg1mxFSo/ewIa/U2tKr+ZaJYnaDyvI3ZHhW6X7y9
         1YrQ==
X-Gm-Message-State: ANoB5plmds+vN3EKudi6Ib5KG9UgZeXY1O8TbtTthpZjCxHhHoskJynw
        3oinXFgxx/EMDcHNJEPKMA1xEwgi0uxUxpJlvhEKeA==
X-Google-Smtp-Source: AA0mqf4FPbjmScXINxiPquQ7p1fJukJpm7Yxb/BNHLi1oiCdnj0uMDp8SiPz12tCFe9VSuwnDsiSLiFIhXlUbG223SU=
X-Received: by 2002:a81:1915:0:b0:3bf:9e45:1139 with SMTP id
 21-20020a811915000000b003bf9e451139mr14791411ywz.267.1669721421365; Tue, 29
 Nov 2022 03:30:21 -0800 (PST)
MIME-Version: 1.0
References: <4c341c5609ed09ad6d52f937eeec28d142ff1f46.1669489329.git.andreyknvl@google.com>
In-Reply-To: <4c341c5609ed09ad6d52f937eeec28d142ff1f46.1669489329.git.andreyknvl@google.com>
From:   Marco Elver <elver@google.com>
Date:   Tue, 29 Nov 2022 12:29:45 +0100
Message-ID: <CANpmjNODh5mjyPDGpkLyj1MZWHr1eimRSDpX=WYFQRG_sn5JRA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] kasan: allow sampling page_alloc allocations for HW_TAGS
To:     andrey.konovalov@linux.dev
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        kasan-dev@googlegroups.com, Peter Collingbourne <pcc@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Florian Mayer <fmayer@google.com>,
        Jann Horn <jannh@google.com>,
        Mark Brand <markbrand@google.com>, netdev@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrey Konovalov <andreyknvl@google.com>
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

On Sat, 26 Nov 2022 at 20:12, <andrey.konovalov@linux.dev> wrote:
>
> From: Andrey Konovalov <andreyknvl@google.com>
>
> Add a new boot parameter called kasan.page_alloc.sample, which makes
> Hardware Tag-Based KASAN tag only every Nth page_alloc allocation for
> allocations marked with __GFP_KASAN_SAMPLE.

This is new - why was it decided that this is a better design?

This means we have to go around introducing the GFP_KASAN_SAMPLE flag
everywhere where we think it might cause a performance degradation.

This depends on accurate benchmarks. Yet, not everyone's usecases will
be the same. I fear we might end up with marking nearly all frequent
and large page-alloc allocations with GFP_KASAN_SAMPLE.

Is it somehow possible to make the sampling decision more automatic?

E.g. kasan.page_alloc.sample_order -> only sample page-alloc
allocations with order greater or equal to sample_order.

> As Hardware Tag-Based KASAN is intended to be used in production, its
> performance impact is crucial. As page_alloc allocations tend to be big,
> tagging and checking all such allocations can introduce a significant
> slowdown. The new flag allows to alleviate that slowdown for chosen
> allocations.
>
> The exact performance improvement caused by using __GFP_KASAN_SAMPLE and
> kasan.page_alloc.sample depends on how often the marked allocations happen
> and how large the are. See the next patch for the details about marking and
> sampling skb allocations.
>
> Enabling page_alloc sampling has a downside: KASAN will miss bad accesses
> to a page_alloc allocation that has not been tagged.
>
> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
>
> ---
>
> Changes v1->v2:
> - Only sample allocations when __GFP_KASAN_SAMPLE is provided to
>   alloc_pages().
> - Fix build when KASAN is disabled.
> - Add more information about the flag to documentation.
> - Use optimized preemption-safe approach for sampling suggested by Marco.
> ---
>  Documentation/dev-tools/kasan.rst |  8 ++++++
>  include/linux/gfp_types.h         | 10 +++++--
>  include/linux/kasan.h             | 18 ++++++++-----
>  include/trace/events/mmflags.h    |  3 ++-
>  mm/kasan/common.c                 | 10 +++++--
>  mm/kasan/hw_tags.c                | 26 ++++++++++++++++++
>  mm/kasan/kasan.h                  | 19 +++++++++++++
>  mm/mempool.c                      |  2 +-
>  mm/page_alloc.c                   | 44 +++++++++++++++++++++----------
>  9 files changed, 114 insertions(+), 26 deletions(-)
>
> diff --git a/Documentation/dev-tools/kasan.rst b/Documentation/dev-tools/kasan.rst
> index 5c93ab915049..bd6d064c7419 100644
> --- a/Documentation/dev-tools/kasan.rst
> +++ b/Documentation/dev-tools/kasan.rst
> @@ -140,6 +140,14 @@ disabling KASAN altogether or controlling its features:
>  - ``kasan.vmalloc=off`` or ``=on`` disables or enables tagging of vmalloc
>    allocations (default: ``on``).
>
> +- ``kasan.page_alloc.sample=<sampling interval>`` makes KASAN tag only every
> +  Nth page_alloc allocation for allocations marked with __GFP_KASAN_SAMPLE,
> +  where N is the value of the parameter (default: ``1``).
> +  This parameter is intended to mitigate the performance overhead.
> +  Note that enabling this parameter makes Hardware Tag-Based KASAN skip checks
> +  of allocations chosen by sampling and thus miss bad accesses to these
> +  allocations. Use the default value for accurate bug detection.
> +
>  Error reports
>  ~~~~~~~~~~~~~
>
> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
> index d88c46ca82e1..c322cd159445 100644
> --- a/include/linux/gfp_types.h
> +++ b/include/linux/gfp_types.h
> @@ -50,13 +50,15 @@ typedef unsigned int __bitwise gfp_t;
>  #define ___GFP_SKIP_ZERO               0x1000000u
>  #define ___GFP_SKIP_KASAN_UNPOISON     0x2000000u
>  #define ___GFP_SKIP_KASAN_POISON       0x4000000u
> +#define ___GFP_KASAN_SAMPLE            0x8000000u
>  #else
>  #define ___GFP_SKIP_ZERO               0
>  #define ___GFP_SKIP_KASAN_UNPOISON     0
>  #define ___GFP_SKIP_KASAN_POISON       0
> +#define ___GFP_KASAN_SAMPLE            0
>  #endif
>  #ifdef CONFIG_LOCKDEP
> -#define ___GFP_NOLOCKDEP       0x8000000u
> +#define ___GFP_NOLOCKDEP       0x10000000u
>  #else
>  #define ___GFP_NOLOCKDEP       0
>  #endif
> @@ -243,6 +245,9 @@ typedef unsigned int __bitwise gfp_t;
>   *
>   * %__GFP_SKIP_KASAN_POISON makes KASAN skip poisoning on page deallocation.
>   * Typically, used for userspace pages. Only effective in HW_TAGS mode.
> + *
> + * %__GFP_KASAN_SAMPLE makes KASAN use sampling to skip poisoning and
> + * unpoisoning of page allocations. Only effective in HW_TAGS mode.
>   */
>  #define __GFP_NOWARN   ((__force gfp_t)___GFP_NOWARN)
>  #define __GFP_COMP     ((__force gfp_t)___GFP_COMP)
> @@ -251,12 +256,13 @@ typedef unsigned int __bitwise gfp_t;
>  #define __GFP_SKIP_ZERO ((__force gfp_t)___GFP_SKIP_ZERO)
>  #define __GFP_SKIP_KASAN_UNPOISON ((__force gfp_t)___GFP_SKIP_KASAN_UNPOISON)
>  #define __GFP_SKIP_KASAN_POISON   ((__force gfp_t)___GFP_SKIP_KASAN_POISON)
> +#define __GFP_KASAN_SAMPLE        ((__force gfp_t)___GFP_KASAN_SAMPLE)
>
>  /* Disable lockdep for GFP context tracking */
>  #define __GFP_NOLOCKDEP ((__force gfp_t)___GFP_NOLOCKDEP)
>
>  /* Room for N __GFP_FOO bits */
> -#define __GFP_BITS_SHIFT (27 + IS_ENABLED(CONFIG_LOCKDEP))
> +#define __GFP_BITS_SHIFT (28 + IS_ENABLED(CONFIG_LOCKDEP))
>  #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
>
>  /**
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index d811b3d7d2a1..4cc946b8cbc8 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -120,12 +120,15 @@ static __always_inline void kasan_poison_pages(struct page *page,
>                 __kasan_poison_pages(page, order, init);
>  }
>
> -void __kasan_unpoison_pages(struct page *page, unsigned int order, bool init);
> -static __always_inline void kasan_unpoison_pages(struct page *page,
> -                                                unsigned int order, bool init)
> +bool __kasan_unpoison_pages(struct page *page, unsigned int order,
> +                           bool init, bool sample);
> +static __always_inline bool kasan_unpoison_pages(struct page *page,
> +                                                unsigned int order,
> +                                                bool init, bool sample)
>  {
>         if (kasan_enabled())
> -               __kasan_unpoison_pages(page, order, init);
> +               return __kasan_unpoison_pages(page, order, init, sample);
> +       return false;
>  }
>
>  void __kasan_cache_create_kmalloc(struct kmem_cache *cache);
> @@ -249,8 +252,11 @@ static __always_inline bool kasan_check_byte(const void *addr)
>  static inline void kasan_unpoison_range(const void *address, size_t size) {}
>  static inline void kasan_poison_pages(struct page *page, unsigned int order,
>                                       bool init) {}
> -static inline void kasan_unpoison_pages(struct page *page, unsigned int order,
> -                                       bool init) {}
> +static inline bool kasan_unpoison_pages(struct page *page, unsigned int order,
> +                                       bool init, bool sample)
> +{
> +       return false;
> +}
>  static inline void kasan_cache_create_kmalloc(struct kmem_cache *cache) {}
>  static inline void kasan_poison_slab(struct slab *slab) {}
>  static inline void kasan_unpoison_object_data(struct kmem_cache *cache,
> diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
> index e87cb2b80ed3..bcaecf859d1f 100644
> --- a/include/trace/events/mmflags.h
> +++ b/include/trace/events/mmflags.h
> @@ -57,7 +57,8 @@
>  #define __def_gfpflag_names_kasan ,                    \
>         gfpflag_string(__GFP_SKIP_ZERO),                \
>         gfpflag_string(__GFP_SKIP_KASAN_POISON),        \
> -       gfpflag_string(__GFP_SKIP_KASAN_UNPOISON)
> +       gfpflag_string(__GFP_SKIP_KASAN_UNPOISON),      \
> +       gfpflag_string(__GFP_KASAN_SAMPLE)
>  #else
>  #define __def_gfpflag_names_kasan
>  #endif
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index 833bf2cfd2a3..05d799ada873 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -95,19 +95,25 @@ asmlinkage void kasan_unpoison_task_stack_below(const void *watermark)
>  }
>  #endif /* CONFIG_KASAN_STACK */
>
> -void __kasan_unpoison_pages(struct page *page, unsigned int order, bool init)
> +bool __kasan_unpoison_pages(struct page *page, unsigned int order,
> +                           bool init, bool sample)
>  {
>         u8 tag;
>         unsigned long i;
>
>         if (unlikely(PageHighMem(page)))
> -               return;
> +               return false;
> +
> +       if (sample && !kasan_sample_page_alloc())
> +               return false;
>
>         tag = kasan_random_tag();
>         kasan_unpoison(set_tag(page_address(page), tag),
>                        PAGE_SIZE << order, init);
>         for (i = 0; i < (1 << order); i++)
>                 page_kasan_tag_set(page + i, tag);
> +
> +       return true;
>  }
>
>  void __kasan_poison_pages(struct page *page, unsigned int order, bool init)
> diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
> index b22c4f461cb0..5e6571820a3f 100644
> --- a/mm/kasan/hw_tags.c
> +++ b/mm/kasan/hw_tags.c
> @@ -59,6 +59,11 @@ EXPORT_SYMBOL_GPL(kasan_mode);
>  /* Whether to enable vmalloc tagging. */
>  DEFINE_STATIC_KEY_TRUE(kasan_flag_vmalloc);
>
> +/* Sampling interval of page_alloc allocation (un)poisoning. */
> +unsigned long kasan_page_alloc_sample = 1;
> +
> +DEFINE_PER_CPU(long, kasan_page_alloc_skip);
> +
>  /* kasan=off/on */
>  static int __init early_kasan_flag(char *arg)
>  {
> @@ -122,6 +127,27 @@ static inline const char *kasan_mode_info(void)
>                 return "sync";
>  }
>
> +/* kasan.page_alloc.sample=<sampling interval> */
> +static int __init early_kasan_flag_page_alloc_sample(char *arg)
> +{
> +       int rv;
> +
> +       if (!arg)
> +               return -EINVAL;
> +
> +       rv = kstrtoul(arg, 0, &kasan_page_alloc_sample);
> +       if (rv)
> +               return rv;
> +
> +       if (!kasan_page_alloc_sample || kasan_page_alloc_sample > LONG_MAX) {
> +               kasan_page_alloc_sample = 1;
> +               return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +early_param("kasan.page_alloc.sample", early_kasan_flag_page_alloc_sample);
> +
>  /*
>   * kasan_init_hw_tags_cpu() is called for each CPU.
>   * Not marked as __init as a CPU can be hot-plugged after boot.
> diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
> index abbcc1b0eec5..ce0b30889587 100644
> --- a/mm/kasan/kasan.h
> +++ b/mm/kasan/kasan.h
> @@ -42,6 +42,9 @@ enum kasan_mode {
>
>  extern enum kasan_mode kasan_mode __ro_after_init;
>
> +extern unsigned long kasan_page_alloc_sample;
> +DECLARE_PER_CPU(long, kasan_page_alloc_skip);
> +
>  static inline bool kasan_vmalloc_enabled(void)
>  {
>         return static_branch_likely(&kasan_flag_vmalloc);
> @@ -57,6 +60,17 @@ static inline bool kasan_sync_fault_possible(void)
>         return kasan_mode == KASAN_MODE_SYNC || kasan_mode == KASAN_MODE_ASYMM;
>  }
>
> +static inline bool kasan_sample_page_alloc(void)
> +{
> +       if (this_cpu_dec_return(kasan_page_alloc_skip) < 0) {
> +               this_cpu_write(kasan_page_alloc_skip,
> +                              kasan_page_alloc_sample - 1);
> +               return true;
> +       }
> +
> +       return false;
> +}
> +
>  #else /* CONFIG_KASAN_HW_TAGS */
>
>  static inline bool kasan_async_fault_possible(void)
> @@ -69,6 +83,11 @@ static inline bool kasan_sync_fault_possible(void)
>         return true;
>  }
>
> +static inline bool kasan_sample_page_alloc(void)
> +{
> +       return true;
> +}
> +
>  #endif /* CONFIG_KASAN_HW_TAGS */
>
>  #ifdef CONFIG_KASAN_GENERIC
> diff --git a/mm/mempool.c b/mm/mempool.c
> index 96488b13a1ef..d3b3702e5191 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -115,7 +115,7 @@ static void kasan_unpoison_element(mempool_t *pool, void *element)
>                 kasan_unpoison_range(element, __ksize(element));
>         else if (pool->alloc == mempool_alloc_pages)
>                 kasan_unpoison_pages(element, (unsigned long)pool->pool_data,
> -                                    false);
> +                                    false, false);
>  }
>
>  static __always_inline void add_element(mempool_t *pool, void *element)
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 6e60657875d3..969b0e4f0046 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1367,6 +1367,8 @@ static int free_tail_pages_check(struct page *head_page, struct page *page)
>   *    see the comment next to it.
>   * 3. Skipping poisoning is requested via __GFP_SKIP_KASAN_POISON,
>   *    see the comment next to it.
> + * 4. The allocation is excluded from being checked due to sampling,
> + *    see the call to kasan_unpoison_pages.
>   *
>   * Poisoning pages during deferred memory init will greatly lengthen the
>   * process and cause problem in large memory systems as the deferred pages
> @@ -2476,7 +2478,8 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
>  {
>         bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
>                         !should_skip_init(gfp_flags);
> -       bool init_tags = init && (gfp_flags & __GFP_ZEROTAGS);
> +       bool zero_tags = init && (gfp_flags & __GFP_ZEROTAGS);
> +       bool reset_tags = !zero_tags;
>         int i;
>
>         set_page_private(page, 0);
> @@ -2499,30 +2502,43 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
>          */
>
>         /*
> -        * If memory tags should be zeroed (which happens only when memory
> -        * should be initialized as well).
> +        * If memory tags should be zeroed
> +        * (which happens only when memory should be initialized as well).
>          */
> -       if (init_tags) {
> +       if (zero_tags) {
>                 /* Initialize both memory and tags. */
>                 for (i = 0; i != 1 << order; ++i)
>                         tag_clear_highpage(page + i);
>
> -               /* Note that memory is already initialized by the loop above. */
> +               /* Take note that memory was initialized by the loop above. */
>                 init = false;
>         }
>         if (!should_skip_kasan_unpoison(gfp_flags)) {
> -               /* Unpoison shadow memory or set memory tags. */
> -               kasan_unpoison_pages(page, order, init);
> -
> -               /* Note that memory is already initialized by KASAN. */
> -               if (kasan_has_integrated_init())
> -                       init = false;
> -       } else {
> -               /* Ensure page_address() dereferencing does not fault. */
> +               /* Try unpoisoning (or setting tags) and initializing memory. */
> +               if (kasan_unpoison_pages(page, order, init,
> +                                        gfp_flags & __GFP_KASAN_SAMPLE)) {
> +                       /* Take note that memory was initialized by KASAN. */
> +                       if (kasan_has_integrated_init())
> +                               init = false;
> +                       /* Take note that memory tags were set by KASAN. */
> +                       reset_tags = false;
> +               } else {
> +                       /*
> +                        * KASAN decided to exclude this allocation from being
> +                        * poisoned due to sampling. Skip poisoning as well.
> +                        */
> +                       SetPageSkipKASanPoison(page);
> +               }
> +       }
> +       /*
> +        * If memory tags have not been set, reset the page tags to ensure
> +        * page_address() dereferencing does not fault.
> +        */
> +       if (reset_tags) {
>                 for (i = 0; i != 1 << order; ++i)
>                         page_kasan_tag_reset(page + i);
>         }
> -       /* If memory is still not initialized, do it now. */
> +       /* If memory is still not initialized, initialize it now. */
>         if (init)
>                 kernel_init_pages(page, 1 << order);
>         /* Propagate __GFP_SKIP_KASAN_POISON to page flags. */
> --
> 2.25.1
>
