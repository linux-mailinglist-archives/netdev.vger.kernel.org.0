Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7C835E8A00
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 10:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233644AbiIXISK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 04:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233783AbiIXIRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 04:17:44 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7AFC8404
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 01:15:31 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id b24so2322533ljk.6
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 01:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=nQomz4ut+7sjfQrrU1jIFAnyWatFfjECi53D3yczEIE=;
        b=KI9bvqb1+pvOBd4LUHBVRiy4ZY0slRCTRZZlpbG/wkf5BfzAwgC4tzlqpiFF6oyV8H
         D7v79qgnbhBTO6d2uDyYHRhhdOOhBfa6EEXzsR1OAGK0jLsPlfD7cA9BCk+dEYTkPA3D
         wWtwWaAoPO0/uTRDdef7+H6/fPQ584Q/+VF22lUeYetTvqY4NLRzWkfcrMuUKAwvI8Ur
         HORX0nTGI2VWAa2VLCpjSTjWJtDJGVfm/4NoDwUwRQY3sCzLDgDtibX9udsLmyhZz/Ab
         UsteBe0vnTvVHno/YLL9xbDupvnLo0yMlhWvaVPU8HJaxwp4Vvg2Oz/Cql9apCVP7xpg
         yn0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=nQomz4ut+7sjfQrrU1jIFAnyWatFfjECi53D3yczEIE=;
        b=wsCVUkgoQVkvUE0Z7OCRS/9dbdS+c9Tiwt+AFEYWdd7lsyQTG6gW2/VirVei0MTpoZ
         pQDFkPW+U3I5iC4F1sJXFUhcfBVUjMVwH9015DZ4uwxFNc7PhLYtyh3YutKwvoCJ8uO7
         Fpr+0EmCmYjZxrDgdrQqRRv8itgSZ6Tift3mCsDdkDhuoIJ+HHuZgU6VQcHoYsbijSor
         lAL+t+NvmkQ2Zx0V2CofVNb+VpC/1qvbdYH/H5Y7gOteIRzqwgAQwdKlCkwA3hQzqOv9
         jY0QBWEavSbOOkcKhAt1Xz3wSfxigDRdYDH97rY7Ep7zm0p1xDhCkP7jq62TzchVRycW
         qmSQ==
X-Gm-Message-State: ACrzQf2sTHYtXLwyYyAtoyJKBxNnE3Pp7S/ReA7cZpG57ZK/8L1lvuAC
        4VXNGHy1EQOOqTUn2bev0KHk7iS88qjx3Io4nglHOA==
X-Google-Smtp-Source: AMsMyM51jSACu0ueivCRHFSALnMRIGDYekDLNBr6hGK18mYNepOD+DBZDwtrPTKiiVk4AIl/66dQQBc8ZJ/gjsu15yk=
X-Received: by 2002:a2e:be8d:0:b0:26c:f4b:47a0 with SMTP id
 a13-20020a2ebe8d000000b0026c0f4b47a0mr4030821ljr.92.1664007329396; Sat, 24
 Sep 2022 01:15:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220923202822.2667581-1-keescook@chromium.org> <20220923202822.2667581-15-keescook@chromium.org>
In-Reply-To: <20220923202822.2667581-15-keescook@chromium.org>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sat, 24 Sep 2022 10:15:18 +0200
Message-ID: <CACT4Y+bg=j9VdteQwrJTNFF_t4EE5uDTMLj07+uMJ9-NcooXGQ@mail.gmail.com>
Subject: Re: [PATCH v2 14/16] kasan: Remove ksize()-related tests
To:     Kees Cook <keescook@chromium.org>
Cc:     Vlastimil Babka <vbabka@suse.cz>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        kasan-dev@googlegroups.com, linux-mm@kvack.org,
        "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, dev@openvswitch.org,
        x86@kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
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

On Fri, 23 Sept 2022 at 22:28, Kees Cook <keescook@chromium.org> wrote:
>
> In preparation for no longer unpoisoning in ksize(), remove the behavioral
> self-tests for ksize().
>
> Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Andrey Konovalov <andreyknvl@gmail.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: kasan-dev@googlegroups.com
> Cc: linux-mm@kvack.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  lib/test_kasan.c  | 42 ------------------------------------------
>  mm/kasan/shadow.c |  4 +---
>  2 files changed, 1 insertion(+), 45 deletions(-)
>
> diff --git a/lib/test_kasan.c b/lib/test_kasan.c
> index 58c1b01ccfe2..bdd0ced8f8d7 100644
> --- a/lib/test_kasan.c
> +++ b/lib/test_kasan.c
> @@ -753,46 +753,6 @@ static void kasan_global_oob_left(struct kunit *test)
>         KUNIT_EXPECT_KASAN_FAIL(test, *(volatile char *)p);
>  }
>
> -/* Check that ksize() makes the whole object accessible. */
> -static void ksize_unpoisons_memory(struct kunit *test)
> -{
> -       char *ptr;
> -       size_t size = 123, real_size;
> -
> -       ptr = kmalloc(size, GFP_KERNEL);
> -       KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
> -       real_size = ksize(ptr);
> -
> -       OPTIMIZER_HIDE_VAR(ptr);
> -
> -       /* This access shouldn't trigger a KASAN report. */
 > -       ptr[size] = 'x';

I would rather keep the tests and update to the new behavior. We had
bugs in ksize, we need test coverage.
I assume ptr[size] access must now produce an error even after ksize.


> -       /* This one must. */
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[real_size]);
> -
> -       kfree(ptr);
> -}
> -
> -/*
> - * Check that a use-after-free is detected by ksize() and via normal accesses
> - * after it.
> - */
> -static void ksize_uaf(struct kunit *test)
> -{
> -       char *ptr;
> -       int size = 128 - KASAN_GRANULE_SIZE;
> -
> -       ptr = kmalloc(size, GFP_KERNEL);
> -       KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
> -       kfree(ptr);
> -
> -       OPTIMIZER_HIDE_VAR(ptr);
> -       KUNIT_EXPECT_KASAN_FAIL(test, ksize(ptr));

This is still a bug that should be detected, right? Calling ksize on a
freed pointer is a bug.

> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[size]);
> -}
> -
>  static void kasan_stack_oob(struct kunit *test)
>  {
>         char stack_array[10];
> @@ -1392,8 +1352,6 @@ static struct kunit_case kasan_kunit_test_cases[] = {
>         KUNIT_CASE(kasan_stack_oob),
>         KUNIT_CASE(kasan_alloca_oob_left),
>         KUNIT_CASE(kasan_alloca_oob_right),
> -       KUNIT_CASE(ksize_unpoisons_memory),
> -       KUNIT_CASE(ksize_uaf),
>         KUNIT_CASE(kmem_cache_double_free),
>         KUNIT_CASE(kmem_cache_invalid_free),
>         KUNIT_CASE(kmem_cache_double_destroy),
> diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
> index 0e3648b603a6..0895c73e9b69 100644
> --- a/mm/kasan/shadow.c
> +++ b/mm/kasan/shadow.c
> @@ -124,9 +124,7 @@ void kasan_unpoison(const void *addr, size_t size, bool init)
>         addr = kasan_reset_tag(addr);
>
>         /*
> -        * Skip KFENCE memory if called explicitly outside of sl*b. Also note
> -        * that calls to ksize(), where size is not a multiple of machine-word
> -        * size, would otherwise poison the invalid portion of the word.
> +        * Skip KFENCE memory if called explicitly outside of sl*b.
>          */
>         if (is_kfence_address(addr))
>                 return;
> --
> 2.34.1
