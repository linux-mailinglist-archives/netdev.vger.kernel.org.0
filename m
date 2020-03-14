Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11E55185336
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 01:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbgCNARI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 20:17:08 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33872 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgCNARI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 20:17:08 -0400
Received: by mail-qt1-f195.google.com with SMTP id 59so9255717qtb.1;
        Fri, 13 Mar 2020 17:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cbLmoFPbaR0Om8gK7/+cGCDufDcyaBbeBdOn/UU1NkE=;
        b=hA0DODKaRhdHsi+lBx3R/y+EbXWK0vSdJmXgB6egz+NpKbQtKriTMsvR3dpZ4asnXp
         PnmQ+3GqcnoVr/g59nY30jxdzsVndK0IwWISOqExuVKlJKRWoeaxd1xBBSIV5/+UZjAf
         8Fi1ETIAxJ90PM3ws4quGARAGeZcpiAxBR5S4R7YIAFB1uOwQ8ehOcwVIuiA7XxdIYix
         nH3FUM90iHThRBuInjNJmZokNKxitz52K+ecqD6O2qQNyGRQb95DREGomWDaGH7MAOob
         7hC842baWXujcqzU16z5kvf554PxEAMpsnvJDiT4Cp6sby/GasnzHtv6/T9teoh6TJEQ
         sdww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cbLmoFPbaR0Om8gK7/+cGCDufDcyaBbeBdOn/UU1NkE=;
        b=QniADXxZcFVKlzzdmNjqcCIhut+ABeptiO7jpeixaf5Kbc/WbaBLCRVCmYDGlyeIYd
         yvt2V6qa6+4u7G95/iZf9TcJfYeDQI8ICiptFtXBo0nbAPepfRisVLMUhJOSb1LyNkZE
         c1NYs5cgMY0IOTid0sKlYn/Eqlo3xBDUE03MKbdybNaxYlTRqJ9M++qbEymY9U5/yjQA
         TRX0KDKbopsiFDbMxz9j2U3MOaTusjZGjMDPunSTxNjNdK5yScm5Lb6x2sRFqbveYTDX
         ArJgYCQMEJMc+SaIIuvhGD4yttXz7HMz+i/ruQwSPjJSu1fYl9xQ8XhCWj9nyxzdytaA
         qfyw==
X-Gm-Message-State: ANhLgQ0fu6YOszRjnZ3n5Ccu1Hdms92xdFOwnWmNCCFuuRegzYXRyaWY
        pjz6AfmoUIZKi41n5PeFbxcRiIzrEwUDmSNS3X4=
X-Google-Smtp-Source: ADFU+vs2o/JJfHhyAVRGKvlHoEciqAt1hlcnVZlRQilrSRH8RjlaD/RTVPxmFKuk3ubza7vyA21aCHljgDB6uWhgDr8=
X-Received: by 2002:ac8:3f62:: with SMTP id w31mr7653920qtk.171.1584145026695;
 Fri, 13 Mar 2020 17:17:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200313233649.654954-1-kafai@fb.com>
In-Reply-To: <20200313233649.654954-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 Mar 2020 17:16:55 -0700
Message-ID: <CAEf4BzZOrYkmXixTdgyisRw8JaNmApHJ=_vmDJ5ryHovzj5e0g@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: Sanitize the bpf_struct_ops tcp-cc name
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

On Fri, Mar 13, 2020 at 4:37 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> The bpf_struct_ops tcp-cc name should be sanitized in order to
> avoid problematic chars (e.g. whitespaces).
>
> This patch reuses the bpf_obj_name_cpy() for accepting the same set
> of characters in order to keep a consistent bpf programming experience.
> A "size" param is added.  Also, the strlen is returned on success so
> that the caller (like the bpf_tcp_ca here) can error out on empty name.
> The existing callers of the bpf_obj_name_cpy() only need to change the
> testing statement to "if (err < 0)".  For all these existing callers,
> the err will be overwritten later, so no extra change is needed
> for the new strlen return value.
>
> Fixes: 0baf26b0fcd7 ("bpf: tcp: Support tcp_congestion_ops in bpf")
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  include/linux/bpf.h   |  1 +
>  kernel/bpf/syscall.c  | 24 +++++++++++++-----------
>  net/ipv4/bpf_tcp_ca.c |  7 ++-----
>  3 files changed, 16 insertions(+), 16 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 49b1a70e12c8..212991f6f2a5 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -160,6 +160,7 @@ static inline void copy_map_value(struct bpf_map *map, void *dst, void *src)
>  }
>  void copy_map_value_locked(struct bpf_map *map, void *dst, void *src,
>                            bool lock_src);
> +int bpf_obj_name_cpy(char *dst, const char *src, unsigned int size);
>
>  struct bpf_offload_dev;
>  struct bpf_offloaded_map;
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 0c7fb0d4836d..d2984bf362c2 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -696,14 +696,14 @@ int bpf_get_file_flag(int flags)
>                    offsetof(union bpf_attr, CMD##_LAST_FIELD) - \
>                    sizeof(attr->CMD##_LAST_FIELD)) != NULL
>
> -/* dst and src must have at least BPF_OBJ_NAME_LEN number of bytes.
> - * Return 0 on success and < 0 on error.
> +/* dst and src must have at least "size" number of bytes.
> + * Return strlen on success and < 0 on error.
>   */
> -static int bpf_obj_name_cpy(char *dst, const char *src)
> +int bpf_obj_name_cpy(char *dst, const char *src, unsigned int size)
>  {
> -       const char *end = src + BPF_OBJ_NAME_LEN;
> +       const char *end = src + size;
>
> -       memset(dst, 0, BPF_OBJ_NAME_LEN);
> +       memset(dst, 0, size);
>         /* Copy all isalnum(), '_' and '.' chars. */
>         while (src < end && *src) {
>                 if (!isalnum(*src) &&
> @@ -712,11 +712,11 @@ static int bpf_obj_name_cpy(char *dst, const char *src)
>                 *dst++ = *src++;
>         }
>
> -       /* No '\0' found in BPF_OBJ_NAME_LEN number of bytes */
> +       /* No '\0' found in "size" number of bytes */
>         if (src == end)
>                 return -EINVAL;
>
> -       return 0;
> +       return src - (end - size);

it's a rather convoluted way of writing (src - orig_src), maybe just
remember original src?

Either way not a big deal:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  }
>

[...]
