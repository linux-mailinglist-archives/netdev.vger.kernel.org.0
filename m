Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A002329F5F6
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 21:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgJ2UQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 16:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgJ2UQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 16:16:15 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FC6C0613CF;
        Thu, 29 Oct 2020 13:16:15 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id 67so3233351ybt.6;
        Thu, 29 Oct 2020 13:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UXsl9bQpXcF7K7v4cdbgLf4h8xLzYJsNQHUjicy4A60=;
        b=bPcwa0ysJlIGJYf1scyyYHje68zwHXR5Te+w0R0UuyqJivrqkyA0TcMf0dT48CROS3
         F+XeR48XXtMglzj2lzsRQx38MCAMRnXybfPmsX3K7WIhn8OH3Q+X1BdzR9TEg6p5BspW
         R+B7cUedURK2v18Xl6onC5xPlqHqu7ydJXx1IjP3NTfD6Goy5s1RE5mo6H+9E2uYGrJp
         wF37NHswSjrQulQQziqZu6KLONLFpF/U9dT4evuMSGfM6tVDhTv+Ff0qFZrAAUQUAsQc
         izm0cyB1A2RVkQmPJMOVZPZzqj9LtnJvunycz6l3Vm4eLw7OY5B6VA/2WR6YqEqNsYRo
         HaYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UXsl9bQpXcF7K7v4cdbgLf4h8xLzYJsNQHUjicy4A60=;
        b=WP6UqgncBb0m7NDvBlP/MiGNOLDmMYuK6A6IDSyBayIwJ+WMsZMetU/1r+ckzxPk5Z
         DQ5xItQDrRc/3C8ts+fB+jz/62m7IthCZnPdiPRjypwmHjBiMuJWyv4bITBuJI3T9/5W
         glsqQ5Q7xce8cNT0YRc2uPAuOgbhLWub4HyU+xzyd3sNUVpD3m0Y30z7z4NS0iGYni++
         JWcAX34vTMG0HAbHHc/kXmp9iLGPM0iaSmqnmxMf6B7QmyYp1hbl9Pwz6rwYkCwHzggy
         Q+cHWtx9IKQNkY5f8fnkwm+qv8R+ZP6cWsF8LfkAF081LzOfDxta2bncMjKBdykhQ2rW
         xoGQ==
X-Gm-Message-State: AOAM532s4FPnBOAbQa9lx8oKoTA40/NzjaffRG0ZrerNfJN+972S+3xX
        e0Wd9TzHZolS2Cu0gvKwZJvKa2/LG1zrX0SdRcA=
X-Google-Smtp-Source: ABdhPJw8ekdgD4QdOyfCCLIZg9Z24SU4y3qDBdQFfPNB//ELn5AI6MtZuTnFUNJGIKN5sciSbqCgwDdpToNc3t+I61M=
X-Received: by 2002:a25:25c2:: with SMTP id l185mr7758431ybl.230.1604002574839;
 Thu, 29 Oct 2020 13:16:14 -0700 (PDT)
MIME-Version: 1.0
References: <20201029160938.154084-1-irogers@google.com>
In-Reply-To: <20201029160938.154084-1-irogers@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 29 Oct 2020 13:16:03 -0700
Message-ID: <CAEf4BzZGUmtrATZnExcUY-BaiCmUKBDo4QOb6PjfumhYG_3c5w@mail.gmail.com>
Subject: Re: [PATCH] libbpf hashmap: Fix undefined behavior in hash_bits
To:     Ian Rogers <irogers@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 9:11 AM Ian Rogers <irogers@google.com> wrote:
>
> If bits is 0, the case when the map is empty, then the >> is the size of
> the register which is undefined behavior - on x86 it is the same as a
> shift by 0. Fix by handling the 0 case explicitly when running with
> address sanitizer.
>
> A variant of this patch was posted previously as:
> https://lore.kernel.org/lkml/20200508063954.256593-1-irogers@google.com/
>
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/lib/bpf/hashmap.h | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
> index d9b385fe808c..27d0556527d3 100644
> --- a/tools/lib/bpf/hashmap.h
> +++ b/tools/lib/bpf/hashmap.h
> @@ -12,9 +12,23 @@
>  #include <stddef.h>
>  #include <limits.h>
>
> +#ifdef __has_feature
> +#define HAVE_FEATURE(f) __has_feature(f)
> +#else
> +#define HAVE_FEATURE(f) 0
> +#endif
> +
>  static inline size_t hash_bits(size_t h, int bits)
>  {
>         /* shuffle bits and return requested number of upper bits */
> +#if defined(ADDRESS_SANITIZER) || HAVE_FEATURE(address_sanitizer)
> +       /*
> +        * If the requested bits == 0 avoid undefined behavior from a
> +        * greater-than bit width shift right (aka invalid-shift-exponent).
> +        */
> +       if (bits == 0)
> +               return -1;
> +#endif

Oh, just too much # magic here :(... If we want to prevent hash_bits()
from being called with bits == 0 (despite the result never used),
let's just adjust hashmap__for_each_key_entry and
hashmap__for_each_key_entry_safe macros:

diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
index d9b385fe808c..488e0ef236cb 100644
--- a/tools/lib/bpf/hashmap.h
+++ b/tools/lib/bpf/hashmap.h
@@ -174,9 +174,9 @@ bool hashmap__find(const struct hashmap *map,
const void *key, void **value);
  * @key: key to iterate entries for
  */
 #define hashmap__for_each_key_entry(map, cur, _key)                        \
-       for (cur = ({ size_t bkt = hash_bits(map->hash_fn((_key), map->ctx),\
-                                            map->cap_bits);                \
-                    map->buckets ? map->buckets[bkt] : NULL; });           \
+       for (cur = map->buckets                                             \
+                  ? map->buckets[hash_bits(map->hash_fn((_key),
map->ctx), map->cap_bits)] \
+                  : NULL;                                                  \
             cur;                                                           \
             cur = cur->next)                                               \
                if (map->equal_fn(cur->key, (_key), map->ctx))

Either way it's a bit ugly and long, but at least we don't have extra
#-driven ugliness.


>  #if (__SIZEOF_SIZE_T__ == __SIZEOF_LONG_LONG__)
>         /* LP64 case */
>         return (h * 11400714819323198485llu) >> (__SIZEOF_LONG_LONG__ * 8 - bits);
> --
> 2.29.1.341.ge80a0c044ae-goog
>
