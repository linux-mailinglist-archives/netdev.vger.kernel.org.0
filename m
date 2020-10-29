Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8C929F87B
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 23:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgJ2WjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 18:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ2WjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 18:39:04 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30CC6C0613CF;
        Thu, 29 Oct 2020 15:39:04 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id h196so3535211ybg.4;
        Thu, 29 Oct 2020 15:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/MaLP07xFJ8iv1Xb81Acqx72k+fD7BmW8SPGFdk9cZ8=;
        b=OVKPu5Fqbd8SiBTCaJB9OByKpYOO+e/2HdZG+Hn1mSO7umi2wC/u2F2eYNrEECi/wi
         7nqvOPSUJqxTPQsXJUB+b0FYar7A65Z5QLw2Irejw3RKmT2hFurRG0ojoeVtGCmsqkVf
         qimjqxJZSoBOtlnkdLr+13pf9VufoRrPpJDNYQAmRl5NnDY6kieOqwUt0nRUy6qRDrkF
         hogVV9JecyAfoCIeT8aWZNUeDeEAUNL6O4QhoNuDxhCtZy4G/vd9YegHYrghXPgkzO4v
         nREJgM2N2JC+J881Xch9PoTD+UNMPw6TW9Ha3V5vGS7A4Gqc+06H7Ecz4vS5YEY4XQfz
         rIBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/MaLP07xFJ8iv1Xb81Acqx72k+fD7BmW8SPGFdk9cZ8=;
        b=Q9/mQanLiWLmuTv87z8dBMf+JA2HEPgUttXBcC2r8bYYpcahMTPAjXa9KxdpMu5Zys
         pJsI9FYDREvxJmJ+s1w3SI+OkYxSJx4/1ER+APMU3sUh8kRlvrktbuUKy0jjJmwBnidg
         yVGtMMdLq5Ox5jBhv2Pyum3wZWxFIQ1cHWrq0A9DsV3Yc5e1Ijk+tWI9qZnZmqq1R844
         6YHFxczh+yucurmwJe5NrEQq2SaC9lrxUNgD+Zq3SJhk5iD45pwD2ZcvqyiuOD4T5rQK
         v5cX24eUGUUMGVYCT0MlH2X2w1X0bT80MQHvirGEYAd2i0BLsp6RRSR8w9LWiYaxTwGG
         dxgg==
X-Gm-Message-State: AOAM531KrVa7dXiZYjfbB+tHLMFoFH3sFYIXTVMw0FVfCHyXlj6aJdCF
        1afWXuQvnyBwrvFOez/g0rC+oDLT5lkselDFA+8=
X-Google-Smtp-Source: ABdhPJz4CJdy0laCccT7A82uujDRUw/AweUj/fkjhzv5PSz/2cbXbxEvLMn/VMFAN6bZE7biGM8ShZuUUlsBjvH/yso=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr9502853ybe.403.1604011143478;
 Thu, 29 Oct 2020 15:39:03 -0700 (PDT)
MIME-Version: 1.0
References: <20201029223707.494059-1-irogers@google.com>
In-Reply-To: <20201029223707.494059-1-irogers@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 29 Oct 2020 15:38:52 -0700
Message-ID: <CAEf4BzaX4KT5tOn9gSR24OtrX8MT3yW2yfTq244ewnRouWDJdA@mail.gmail.com>
Subject: Re: [PATCH v2] libbpf hashmap: Fix undefined behavior in hash_bits
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

On Thu, Oct 29, 2020 at 3:38 PM Ian Rogers <irogers@google.com> wrote:
>
> If bits is 0, the case when the map is empty, then the >> is the size of
> the register which is undefined behavior - on x86 it is the same as a
> shift by 0. Fix by handling the 0 case explicitly and guarding calls to
> hash_bits for empty maps in hashmap__for_each_key_entry and
> hashmap__for_each_entry_safe.
>
> Suggested-by: Andrii Nakryiko <andriin@fb.com>,
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---

Looks good. Thanks and sorry for unnecessary iterations.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/lib/bpf/hashmap.h | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
> index d9b385fe808c..10a4c4cd13cf 100644
> --- a/tools/lib/bpf/hashmap.h
> +++ b/tools/lib/bpf/hashmap.h
> @@ -15,6 +15,9 @@
>  static inline size_t hash_bits(size_t h, int bits)
>  {
>         /* shuffle bits and return requested number of upper bits */
> +       if (bits == 0)
> +               return 0;
> +
>  #if (__SIZEOF_SIZE_T__ == __SIZEOF_LONG_LONG__)
>         /* LP64 case */
>         return (h * 11400714819323198485llu) >> (__SIZEOF_LONG_LONG__ * 8 - bits);
> @@ -174,17 +177,17 @@ bool hashmap__find(const struct hashmap *map, const void *key, void **value);
>   * @key: key to iterate entries for
>   */
>  #define hashmap__for_each_key_entry(map, cur, _key)                        \
> -       for (cur = ({ size_t bkt = hash_bits(map->hash_fn((_key), map->ctx),\
> -                                            map->cap_bits);                \
> -                    map->buckets ? map->buckets[bkt] : NULL; });           \
> +       for (cur = map->buckets                                             \
> +                    ? map->buckets[hash_bits(map->hash_fn((_key), map->ctx), map->cap_bits)] \
> +                    : NULL;                                                \
>              cur;                                                           \
>              cur = cur->next)                                               \
>                 if (map->equal_fn(cur->key, (_key), map->ctx))
>
>  #define hashmap__for_each_key_entry_safe(map, cur, tmp, _key)              \
> -       for (cur = ({ size_t bkt = hash_bits(map->hash_fn((_key), map->ctx),\
> -                                            map->cap_bits);                \
> -                    cur = map->buckets ? map->buckets[bkt] : NULL; });     \
> +       for (cur = map->buckets                                             \
> +                    ? map->buckets[hash_bits(map->hash_fn((_key), map->ctx), map->cap_bits)] \
> +                    : NULL;                                                \
>              cur && ({ tmp = cur->next; true; });                           \
>              cur = tmp)                                                     \
>                 if (map->equal_fn(cur->key, (_key), map->ctx))
> --
> 2.29.1.341.ge80a0c044ae-goog
>
