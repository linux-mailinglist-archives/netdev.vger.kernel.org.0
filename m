Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931CB3D834B
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 00:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbhG0Wnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 18:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbhG0Wnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 18:43:41 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F965C061760
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 15:43:40 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id h2so247387lfu.4
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 15:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+SboYQvLEoV+Q5oWgHDYhiCn7Tx7IEj91yehwnQAbvM=;
        b=oPdc+CQOm8sqXyP7XoKBSgtFpkhKc5cVZX213KU9f4Da2FEPu6aF69LfwwjClKWNVJ
         ng7j8yDgO8HI42dHLauya6am2azxxCJCaFF0anEjeHwgReEs16hSqD+oIFo6BZv6LpJS
         ACmvJNRbwJRkxWuoPoNy6dRBIO6yHHlR2M++9sqSSkVpJNRx+YghTE2f5UEGqnLMKX0y
         L9JtEjP+k5Rg4eykCaF7tDDJDWOi5kTiQCm0vlBFpWYapxXmiwTYE1eqKmNSFX0xs0VL
         uH1WcfCABl1xCeDKnknA3HXWng9Y37zixBYLKsXyfi388/m+I1GilxgqhZGurEEKTpA1
         AJfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+SboYQvLEoV+Q5oWgHDYhiCn7Tx7IEj91yehwnQAbvM=;
        b=OR2KEeGH8nwx6LddJmEndWlmpX7zZZBF2bO9nFUROJ7yM3Vj/aOCNjK3gjgt/Ezgxq
         W4yVnyX8vwlsdllzJQ6H4XUm+6MKn5oLZVmTJ5hdhrLws7XwtV1cp053b/GKFxx/+ZGP
         idycFCII0/1jcR3x365OPX/3lnJ/DPjMKO6j5ASWPzib6hhhYzJIfWvh4RjpdL7/6dlu
         s9SbMucMQJUBrhvKwY1NKd84bpfaTHWnbbnqA9Z4mpviIXqAmYb5I9ABb8fqRl2h9ray
         g9jFk/NNb1SBVaAcmFe+wLYq0WLCOzKU3vMMVPz9S3P8ADNW7EWAy4nvClW/zgomZRhV
         77Ww==
X-Gm-Message-State: AOAM530xZJCaiwL1vZyxaVtMfHjjSZJ0ZT/AzH/RFCJ4qu9yj/ULhpFj
        Bb9G3d9HnC0knZl1J6wVTM7+qy4rbXoEkU4lQaTI7Q==
X-Google-Smtp-Source: ABdhPJxnTYGuinYeYdLqLqV+o8/XLcsFPV+/cmsQ8aq8v4uISWTPunqaNAJh2445rOdl0O13jTOR3bXB56B9K3i3ZVk=
X-Received: by 2002:ac2:596a:: with SMTP id h10mr11005339lfp.374.1627425818438;
 Tue, 27 Jul 2021 15:43:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210727205855.411487-1-keescook@chromium.org> <20210727205855.411487-35-keescook@chromium.org>
In-Reply-To: <20210727205855.411487-35-keescook@chromium.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 27 Jul 2021 15:43:27 -0700
Message-ID: <CAKwvOdknit8DtWaFvLupmNEebjbwVa6R3xiGc2D4AqB_6+i52g@mail.gmail.com>
Subject: Re: [PATCH 34/64] fortify: Detect struct member overflows in memcpy()
 at compile-time
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 2:17 PM Kees Cook <keescook@chromium.org> wrote:
>
> To accelerate the review of potential run-time false positives, it's
> also worth noting that it is possible to partially automate checking
> by examining memcpy() buffer argument fields to see if they have
> a neighboring. It is reasonable to expect that the vast majority of

a neighboring...field?

> diff --git a/include/linux/fortify-string.h b/include/linux/fortify-string.h
> index 7e67d02764db..5e79e626172b 100644
> --- a/include/linux/fortify-string.h
> +++ b/include/linux/fortify-string.h
> @@ -2,13 +2,17 @@
>  #ifndef _LINUX_FORTIFY_STRING_H_
>  #define _LINUX_FORTIFY_STRING_H_
>
> +#include <linux/bug.h>

What are you using from linux/bug.h here?

> +
>  #define __FORTIFY_INLINE extern __always_inline __attribute__((gnu_inline))
>  #define __RENAME(x) __asm__(#x)
>
>  void fortify_panic(const char *name) __noreturn __cold;
>  void __read_overflow(void) __compiletime_error("detected read beyond size of object (1st parameter)");
>  void __read_overflow2(void) __compiletime_error("detected read beyond size of object (2nd parameter)");
> +void __read_overflow2_field(void) __compiletime_warning("detected read beyond size of field (2nd parameter); maybe use struct_group()?");
>  void __write_overflow(void) __compiletime_error("detected write beyond size of object (1st parameter)");
> +void __write_overflow_field(void) __compiletime_warning("detected write beyond size of field (1st parameter); maybe use struct_group()?");
>
>  #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
>  extern void *__underlying_memchr(const void *p, int c, __kernel_size_t size) __RENAME(memchr);
> @@ -182,22 +186,105 @@ __FORTIFY_INLINE void *memset(void *p, int c, __kernel_size_t size)
>         return __underlying_memset(p, c, size);
>  }
>
> -__FORTIFY_INLINE void *memcpy(void *p, const void *q, __kernel_size_t size)
> +/*
> + * To make sure the compiler can enforce protection against buffer overflows,
> + * memcpy(), memmove(), and memset() must not be used beyond individual
> + * struct members. If you need to copy across multiple members, please use
> + * struct_group() to create a named mirror of an anonymous struct union.
> + * (e.g. see struct sk_buff.)
> + *
> + * Mitigation coverage
> + *                                     Bounds checking at:
> + *                                     +-------+-------+-------+-------+
> + *                                     | Compile time  | Run time      |
> + * memcpy() argument sizes:            | write | read  | write | read  |
> + *                                     +-------+-------+-------+-------+
> + * memcpy(known,   known,   constant)  |   y   |   y   |  n/a  |  n/a  |
> + * memcpy(unknown, known,   constant)  |   n   |   y   |   V   |  n/a  |
> + * memcpy(known,   unknown, constant)  |   y   |   n   |  n/a  |   V   |
> + * memcpy(unknown, unknown, constant)  |   n   |   n   |   V   |   V   |
> + * memcpy(known,   known,   dynamic)   |   n   |   n   |   b   |   B   |
> + * memcpy(unknown, known,   dynamic)   |   n   |   n   |   V   |   B   |
> + * memcpy(known,   unknown, dynamic)   |   n   |   n   |   b   |   V   |
> + * memcpy(unknown, unknown, dynamic)   |   n   |   n   |   V   |   V   |
> + *                                     +-------+-------+-------+-------+
> + *
> + * y = deterministic compile-time bounds checking
> + * n = cannot do deterministic compile-time bounds checking
> + * n/a = no run-time bounds checking needed since compile-time deterministic
> + * b = perform run-time bounds checking
> + * B = can perform run-time bounds checking, but current unenforced
> + * V = vulnerable to run-time overflow
> + *
> + */
> +__FORTIFY_INLINE void fortify_memcpy_chk(__kernel_size_t size,
> +                                        const size_t p_size,
> +                                        const size_t q_size,
> +                                        const size_t p_size_field,
> +                                        const size_t q_size_field,
> +                                        const char *func)
>  {
> -       size_t p_size = __builtin_object_size(p, 0);
> -       size_t q_size = __builtin_object_size(q, 0);
> -
>         if (__builtin_constant_p(size)) {
> -               if (p_size < size)
> +               /*
> +                * Length argument is a constant expression, so we
> +                * can perform compile-time bounds checking where
> +                * buffer sizes are known.
> +                */
> +
> +               /* Error when size is larger than enclosing struct. */
> +               if (p_size > p_size_field && p_size < size)
>                         __write_overflow();
> -               if (q_size < size)
> +               if (q_size > q_size_field && q_size < size)
>                         __read_overflow2();
> +
> +               /* Warn when write size argument larger than dest field. */
> +               if (p_size_field < size)
> +                       __write_overflow_field();
> +               /*
> +                * Warn for source field over-read when building with W=1
> +                * or when an over-write happened, so both can be fixed at
> +                * the same time.
> +                */
> +               if ((IS_ENABLED(KBUILD_EXTRA_WARN1) || p_size_field < size) &&
> +                   q_size_field < size)
> +                       __read_overflow2_field();
>         }
> -       if (p_size < size || q_size < size)
> -               fortify_panic(__func__);
> -       return __underlying_memcpy(p, q, size);
> +       /*
> +        * At this point, length argument may not be a constant expression,
> +        * so run-time bounds checking can be done where buffer sizes are
> +        * known. (This is not an "else" because the above checks may only
> +        * be compile-time warnings, and we want to still warn for run-time
> +        * overflows.)
> +        */
> +
> +       /*
> +        * Always stop accesses beyond the struct that contains the
> +        * field, when the buffer's remaining size is known.
> +        * (The -1 test is to optimize away checks where the buffer
> +        * lengths are unknown.)
> +        */
> +       if ((p_size != (size_t)(-1) && p_size < size) ||
> +           (q_size != (size_t)(-1) && q_size < size))
> +               fortify_panic(func);
>  }
>
> +#define __fortify_memcpy_chk(p, q, size, p_size, q_size,               \
> +                            p_size_field, q_size_field, op) ({         \
> +       size_t __fortify_size = (size_t)(size);                         \
> +       fortify_memcpy_chk(__fortify_size, p_size, q_size,              \
> +                          p_size_field, q_size_field, #op);            \
> +       __underlying_##op(p, q, __fortify_size);                        \
> +})

Are there other macro expansion sites for `__fortify_memcpy_chk`,
perhaps later in this series? I don't understand why `memcpy` is
passed as `func` to `fortify_panic()` rather than continuing to use
`__func__`?

> +
> +/*
> + * __builtin_object_size() must be captured here to avoid evaluating argument
> + * side-effects further into the macro layers.
> + */
> +#define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                 \
> +               __builtin_object_size(p, 0), __builtin_object_size(q, 0), \
> +               __builtin_object_size(p, 1), __builtin_object_size(q, 1), \
> +               memcpy)
> +
>  __FORTIFY_INLINE void *memmove(void *p, const void *q, __kernel_size_t size)
>  {
>         size_t p_size = __builtin_object_size(p, 0);
> @@ -277,27 +364,27 @@ __FORTIFY_INLINE void *kmemdup(const void *p, size_t size, gfp_t gfp)
>         return __real_kmemdup(p, size, gfp);
>  }
>
> -/* defined after fortified strlen and memcpy to reuse them */
> +/* Defined after fortified strlen to reuse it. */
>  __FORTIFY_INLINE char *strcpy(char *p, const char *q)
>  {
>         size_t p_size = __builtin_object_size(p, 1);
>         size_t q_size = __builtin_object_size(q, 1);
>         size_t size;
>
> +       /* If neither buffer size is known, immediately give up. */
>         if (p_size == (size_t)-1 && q_size == (size_t)-1)
>                 return __underlying_strcpy(p, q);
>         size = strlen(q) + 1;
>         /* test here to use the more stringent object size */
>         if (p_size < size)
>                 fortify_panic(__func__);
> -       memcpy(p, q, size);
> +       __underlying_memcpy(p, q, size);
>         return p;
>  }
>
>  /* Don't use these outside the FORITFY_SOURCE implementation */
>  #undef __underlying_memchr
>  #undef __underlying_memcmp
> -#undef __underlying_memcpy
>  #undef __underlying_memmove
>  #undef __underlying_memset
>  #undef __underlying_strcat
> diff --git a/include/linux/string.h b/include/linux/string.h
> index 9473f81b9db2..cbe889e404e2 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -261,8 +261,9 @@ static inline const char *kbasename(const char *path)
>   * @count: The number of bytes to copy
>   * @pad: Character to use for padding if space is left in destination.
>   */
> -static inline void memcpy_and_pad(void *dest, size_t dest_len,
> -                                 const void *src, size_t count, int pad)
> +static __always_inline void memcpy_and_pad(void *dest, size_t dest_len,
> +                                          const void *src, size_t count,
> +                                          int pad)

Why __always_inline here?

>  {
>         if (dest_len > count) {
>                 memcpy(dest, src, count);
> diff --git a/lib/Makefile b/lib/Makefile
> index 083a19336e20..74523fd394bd 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -370,7 +370,8 @@ TEST_FORTIFY_LOG = test_fortify.log
>  quiet_cmd_test_fortify = TEST    $@
>        cmd_test_fortify = $(CONFIG_SHELL) $(srctree)/scripts/test_fortify.sh \
>                         $< $@ "$(NM)" $(CC) $(c_flags) \
> -                       $(call cc-disable-warning,fortify-source)
> +                       $(call cc-disable-warning,fortify-source) \
> +                       -DKBUILD_EXTRA_WARN1
>
>  targets += $(TEST_FORTIFY_LOGS)
>  clean-files += $(TEST_FORTIFY_LOGS)
> diff --git a/lib/string_helpers.c b/lib/string_helpers.c
> index faa9d8e4e2c5..4d205bf5993c 100644
> --- a/lib/string_helpers.c
> +++ b/lib/string_helpers.c
> @@ -884,6 +884,12 @@ char *strreplace(char *s, char old, char new)
>  EXPORT_SYMBOL(strreplace);
>
>  #ifdef CONFIG_FORTIFY_SOURCE
> +/* These are placeholders for fortify compile-time warnings. */
> +void __read_overflow2_field(void) { }
> +EXPORT_SYMBOL(__read_overflow2_field);
> +void __write_overflow_field(void) { }
> +EXPORT_SYMBOL(__write_overflow_field);
> +

Don't we rely on these being undefined for Clang to produce a linkage
failure (until https://reviews.llvm.org/D106030 has landed)?  By
providing a symbol definition we can link against, I don't think
__compiletime_{warning|error} will warn at all with Clang?

>  void fortify_panic(const char *name)
>  {
>         pr_emerg("detected buffer overflow in %s\n", name);
> diff --git a/lib/test_fortify/read_overflow2_field-memcpy.c b/lib/test_fortify/read_overflow2_field-memcpy.c
> new file mode 100644
> index 000000000000..de9569266223
> --- /dev/null
> +++ b/lib/test_fortify/read_overflow2_field-memcpy.c
> @@ -0,0 +1,5 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#define TEST   \
> +       memcpy(large, instance.buf, sizeof(instance.buf) + 1)
> +
> +#include "test_fortify.h"
> diff --git a/lib/test_fortify/write_overflow_field-memcpy.c b/lib/test_fortify/write_overflow_field-memcpy.c
> new file mode 100644
> index 000000000000..28cc81058dd3
> --- /dev/null
> +++ b/lib/test_fortify/write_overflow_field-memcpy.c
> @@ -0,0 +1,5 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#define TEST   \
> +       memcpy(instance.buf, large, sizeof(instance.buf) + 1)
> +
> +#include "test_fortify.h"
> --

I haven't read the whole series yet, but I assume test_fortify.h was
provided earlier in the series?
-- 
Thanks,
~Nick Desaulniers
