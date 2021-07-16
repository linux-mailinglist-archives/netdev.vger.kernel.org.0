Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F94C3CBEFD
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 00:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237330AbhGPWIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 18:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbhGPWIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 18:08:51 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7507C06175F;
        Fri, 16 Jul 2021 15:05:54 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id g19so17171070ybe.11;
        Fri, 16 Jul 2021 15:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5LsAbpTyGpoMSPy6kuRB4pyfS/wxP9D1ajlZsdQwkJ8=;
        b=qqxNjdpW1LCG1+QjMqzatt42SvMUj+/is8XU7Fmr8H1GvmhPKNgeLeht2ozSeVXx2Y
         BB1Yd0mFrqNH6kY6dz4cSvmwE4g8a10n1h9b9hlJyPJnIV8ArwVKx0QWApfj3Q8b5KLG
         v+8a22vJY2TBF0XMitibR0gY6+Ni+tXRCRLafoiXpHKz8C8qQlDSeJA3ZXmI9iCuuIoG
         QR8xp5cE13WudGGYnzdnjEI9gGS582C0I375ui2Q4N2vFqwb4/S5iPJG+l8KIosPG8Xl
         8PAgNJW5RgHcDfZxkxu+HGxci3ILC2huZWHJUAEpOMRzCqU5tahv/kTHY09kIUcGylAm
         6SaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5LsAbpTyGpoMSPy6kuRB4pyfS/wxP9D1ajlZsdQwkJ8=;
        b=h9VwPXckTESDTkv6pEZ1aVmzPqh82Hy6XeXsHbRrY/GUPbbfZGVlxDkU0Y7ACGHzvs
         X6W/BjALQK08Mtu7aBUdwlc3PsUImVWk41QYI7EmLJiiYwbbyzedcAgnpCNYQpoPRa59
         MKdQxsGl38ipvrjsmmjQHfvFn8caT0tzYtAjNg1752UY1TIeYueDUGQxMrz9W3+wUPHR
         m8AHdhV2fqQ2Y4IdqKHdFYqgxDkSlv9+YiAZvqiCrz0iXb2UJkcKFWIgh6+hldcIbN3x
         pa7pIYCUv0OylGvECOv6dmyt30EkNpNKLb98HnijGUoQTe+5S4nloz/01Ppmu6tG9pqk
         KpaQ==
X-Gm-Message-State: AOAM533uMJ4G6nJODgTZT/XPtcE2zNTgQTuv4eX0hSJ9Agq1FXfBE9+7
        oB2kl2g/1K5H6ygQA9Hx6ixG25bxTAulhUwIkqo=
X-Google-Smtp-Source: ABdhPJwhAOJXYVol/4VpHOTxMz4Yo+C1dwcXuHEXp2ODMP+aX7JvlnVRMZxUy65rHCvmQ96LCWAZSVAsDE5KZGq4r8k=
X-Received: by 2002:a25:b203:: with SMTP id i3mr15658989ybj.260.1626473154041;
 Fri, 16 Jul 2021 15:05:54 -0700 (PDT)
MIME-Version: 1.0
References: <1626471813-17736-1-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1626471813-17736-1-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 16 Jul 2021 15:05:43 -0700
Message-ID: <CAEf4BzZ_2arevAp_qwetCvdMk-gigvPo7tKsb7d0xF-xnezL_w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: clarify/fix unaligned data issues for
 btf typed dump
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Bill Wendling <morbo@google.com>,
        Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 16, 2021 at 2:44 PM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> If data is packed, data structures can store it outside of usual
> boundaries.  For example a 4-byte int can be stored on a unaligned
> boundary in a case like this:
>
> struct s {
>         char f1;
>         int f2;
> } __attribute((packed));
>
> ...the int is stored at an offset of one byte.  Some platforms have
> problems dereferencing data that is not aligned with its size, and
> code exists to handle most cases of this for BTF typed data display.
> However pointer display was missed, and a simple macro to test if
> "data_is_unaligned(data, data_sz)" would help clarify this code.
>
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  tools/lib/bpf/btf_dump.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
> index 929cf93..9dfe9c1 100644
> --- a/tools/lib/bpf/btf_dump.c
> +++ b/tools/lib/bpf/btf_dump.c
> @@ -1654,6 +1654,8 @@ static int btf_dump_base_type_check_zero(struct btf_dump *d,
>         return 0;
>  }
>
> +#define data_is_unaligned(data, data_sz)       (((uintptr_t)data) % data_sz)
> +

there is no need for macro, please use static function. And
ptr_is_aligned() is probably a better form:

if (!ptr_is_aligned(data, sz)) {
    /* handle uncommon case */
}

ptr_is_aligned() can be probably reused more readily in some other places later.

>  static int btf_dump_int_data(struct btf_dump *d,
>                              const struct btf_type *t,
>                              __u32 type_id,
> @@ -1672,7 +1674,7 @@ static int btf_dump_int_data(struct btf_dump *d,
>         /* handle packed int data - accesses of integers not aligned on
>          * int boundaries can cause problems on some platforms.
>          */
> -       if (((uintptr_t)data) % sz)
> +       if (data_is_unaligned(data, sz))
>                 return btf_dump_bitfield_data(d, t, data, 0, 0);
>
>         switch (sz) {
> @@ -1739,7 +1741,7 @@ static int btf_dump_float_data(struct btf_dump *d,
>         int sz = t->size;
>
>         /* handle unaligned data; copy to local union */
> -       if (((uintptr_t)data) % sz) {
> +       if (data_is_unaligned(data, sz)) {
>                 memcpy(&fl, data, sz);
>                 flp = &fl;
>         }
> @@ -1897,7 +1899,10 @@ static int btf_dump_ptr_data(struct btf_dump *d,
>                               __u32 id,
>                               const void *data)
>  {
> -       btf_dump_type_values(d, "%p", *(void **)data);
> +       void *ptrval;

sizeof(void *) could be 4 on the host system and 8 in BTF. If you want
to preserve the speed, I'd do something like:

if (ptr_is_aligned(data, sizeof(void *)) && sizeof(void *) == d->ptr_sz) {
    btf_dump_type_values(d, "%p", *(void **)data);
} else {
    /* fetch pointer value as unaligned integer */
    if (d->ptr_sz == 4)
        printf("0x%x")
    else
        printf("0x%llx")
}

Maybe there is some cleaner way. But that should work, no?

> +
> +       memcpy(&ptrval, data, d->ptr_sz);
> +       btf_dump_type_values(d, "%p", ptrval);
>         return 0;
>  }
>
> @@ -1910,7 +1915,7 @@ static int btf_dump_get_enum_value(struct btf_dump *d,
>         int sz = t->size;
>
>         /* handle unaligned enum value */
> -       if (((uintptr_t)data) % sz) {
> +       if (data_is_unaligned(data, sz)) {
>                 *value = (__s64)btf_dump_bitfield_get_data(d, t, data, 0, 0);
>                 return 0;
>         }
> --
> 1.8.3.1
>
