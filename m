Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5C1D188EB0
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 21:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgCQUIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 16:08:13 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:45601 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgCQUIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 16:08:13 -0400
Received: by mail-qv1-f67.google.com with SMTP id h20so7703697qvr.12;
        Tue, 17 Mar 2020 13:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3BHSfNVRFg+bWVULrv5z0Bi5NWlSAF4waOuY5S1/XrQ=;
        b=Yi3Z8METijVtgY1GXG0L10SlSeYYpMP0jbZsdzis2/p5NNZP+O8UmQDmzxk3otAIom
         Wd7bftGmv85bnl0/l1Rrbbqo5iMFYxg5bJ0fwmP7BEJOS6XihDTT87jcbpTdl1sqnCGX
         2aOnDDTLrQV+W6ER0lLVcZbeozNUlSsLKPsWh/XXJtKD53KFRul0G5LiTD0nWsb6kKNn
         9ldv2aCsMfbjB3lv6bOD1bR5Qrug2f4cTkaO+T1R7xgUNctMek+SeT+p/JgWAQ0AX/JZ
         SMcETvnYSQUk0MZBD/ldhGSd9tQP3XPawTxkIPzdB6nD7KVLI2c5u7/TwqkbOahvk9OJ
         GFuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3BHSfNVRFg+bWVULrv5z0Bi5NWlSAF4waOuY5S1/XrQ=;
        b=DZG3ihkdteSQ0BUdsrSInc4y6CvPc1esrOeaV6xjzDZy2N+wmn1Gg3DhxcMPnwbYfC
         fvzkVfVG6Rm8vAQjlAoFjoUycPX8fXoKjtgCepdw4M6M1Cp0eIznDke95sgoWLhIUFCc
         L3TJC/dhm4dvADlX2+BcAoUZRx5vswtnMIpPO8CeSjElmnQqPw0T7N2LyA45ZgX8DOcO
         Y+fgoDJ+98IIXk79GyhgO/TAErXipfpZX1f7cQ3v6J1blmWvkukMNaStJKL8F6YH150r
         QgQeJsnagXdNRJvrSK07ORit6cAoyAljs+EvpXm+as8VuoyYPKIdpfo1o1faU1F3Yuwh
         VPXQ==
X-Gm-Message-State: ANhLgQ3Mwma6dlmQJWfSDzHbT7TIx8kS6EfBJ1O/k2Og05fxD9TflHy+
        lIDVMdc+f+22XzQq31YfrLbp8KhitmgasBBbzuc=
X-Google-Smtp-Source: ADFU+vs52eqOqnBdeQoENJ7Ced5IAesdNTQUdOo4lsGHW+1Ktyc9fYnY2eAXhL0AlaM8q9H4qJjjQmWIhifepjcfvU4=
X-Received: by 2002:a0c:fa03:: with SMTP id q3mr873063qvn.228.1584475692585;
 Tue, 17 Mar 2020 13:08:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200316005559.2952646-1-kafai@fb.com> <20200316005612.2953413-1-kafai@fb.com>
In-Reply-To: <20200316005612.2953413-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Mar 2020 13:08:01 -0700
Message-ID: <CAEf4BzZmoH=nhrWCotbTT2XS8gvoh0P2HoFym7R0dbBGPK92ug@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/4] bpftool: Print as a string for char array
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 15, 2020 at 5:57 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> A char[] is currently printed as an integer array.
> This patch will print it as a string when
> 1) The array element type is an one byte int
> 2) The array element type has a BTF_INT_CHAR encoding or
>    the array element type's name is "char"
> 3) All characters is between (0x1f, 0x7f) and it is terminated
>    by a null character.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  tools/bpf/bpftool/btf_dumper.c | 41 ++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>
> diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
> index 57bd6c0fafc9..1d2d8d2cedea 100644
> --- a/tools/bpf/bpftool/btf_dumper.c
> +++ b/tools/bpf/bpftool/btf_dumper.c
> @@ -77,6 +77,42 @@ static void btf_dumper_enum(const struct btf_dumper *d,
>         jsonw_int(d->jw, value);
>  }
>
> +static bool is_str_array(const struct btf *btf, const struct btf_array *arr,
> +                        const char *s)
> +{
> +       const struct btf_type *elem_type;
> +       const char *end_s;
> +
> +       if (!arr->nelems)
> +               return false;
> +
> +       elem_type = btf__type_by_id(btf, arr->type);
> +       /* Not skipping typedef.  typedef to char does not count as
> +        * a string now.
> +        */
> +       while (elem_type && btf_is_mod(elem_type))
> +               elem_type = btf__type_by_id(btf, elem_type->type);
> +
> +       if (!elem_type || !btf_is_int(elem_type) || elem_type->size != 1)
> +               return false;
> +
> +       if (btf_int_encoding(elem_type) != BTF_INT_CHAR &&
> +           strcmp("char", btf__name_by_offset(btf, elem_type->name_off)))
> +               return false;
> +
> +       end_s = s + arr->nelems;
> +       while (s < end_s) {
> +               if (!*s)
> +                       return true;
> +               if (*s <= 0x1f || *s >= 0x7f)
> +                       return false;
> +               s++;
> +       }
> +
> +       /* '\0' is not found */
> +       return false;
> +}
> +
>  static int btf_dumper_array(const struct btf_dumper *d, __u32 type_id,
>                             const void *data)
>  {
> @@ -86,6 +122,11 @@ static int btf_dumper_array(const struct btf_dumper *d, __u32 type_id,
>         int ret = 0;
>         __u32 i;
>
> +       if (is_str_array(d->btf, arr, data)) {
> +               jsonw_string(d->jw, data);
> +               return 0;
> +       }
> +

Looks good, but curious how the string that contains ' or " will be
output in json? Will it be escaped properly or will result in
malformed JSON?

Acked-by: Andrii Nakryiko <andriin@fb.com>

>         elem_size = btf__resolve_size(d->btf, arr->type);
>         if (elem_size < 0)
>                 return elem_size;
> --
> 2.17.1
>
