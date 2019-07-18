Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0A526D10D
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 17:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390719AbfGRPZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 11:25:03 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45397 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbfGRPZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 11:25:03 -0400
Received: by mail-io1-f65.google.com with SMTP id g20so52023659ioc.12;
        Thu, 18 Jul 2019 08:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H1j7VJD8XmRQsikkCuH6F99Eiqe77nmT42cAzuhJoBs=;
        b=EDQ1tEAlt1Q6l0TLBgYddCjHQiQXlTzi5fOWGzF4gZSYuyWeLO1kSz3972dILD5QT2
         05Kkj3id8CvppLP0xOKuUEszK/vWsxb2h12jOQq/Te7JnGed7+VUu6qPhBDjFwme5dkS
         4cmCsA3vsQcXzcTLzvzGl3FqVGfJ1q9PI6wxxkW/bq7198eSFfkiS04QwEMesSmET4TA
         BoBx5YyGzg4W2GLOmcSP2WFpT4siXmpemKD5Ghc8kv3ENkBjhtqmzJuJAcygtdgmE2EK
         j/i+k+rmA9GXDrgLxOBDkHTMVvuSxFDHROgc5jMsCOEA6YR9BGOA4DmAjNJyYRyqiY/h
         GSpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H1j7VJD8XmRQsikkCuH6F99Eiqe77nmT42cAzuhJoBs=;
        b=qSrYiU/LZfG3JePDus4OszZtzkY1vJyAUOJZA5xFN+dOqT16KPgVE4zlUOQaOuXFVG
         nwnihgLr1KsGSUZ5kPDmrn/AdxJmzv5aVBc88kpdfGe5LYX20+7og8GzH2e/UphjWuXg
         Y64rb+y+s2O6YuFG00X09Dpv9YHxvVqDRfL2PLpYmpoBSGwNxhajAV0yDYLsTypjFouh
         ARkmsOYH7S8TKZ3rcx9ttBRUFwz7LaqwyZV9fZY1T8I120lFXeC/FBXeuH9w5Uj1Pico
         te2u9ScPAyat0+/T0Y0mzAie3HVG5tXTHoVajs132ZRaEClpF5KuC6fYCs3Jt897Pufm
         QSnw==
X-Gm-Message-State: APjAAAVEp4sAr5Wn43000apOQ092Ic6Mdk6xT1ySblusBbU2wQu70+4O
        9KXmUVyAWONGQeoB7LwctL/7HUMa1Sj6oWP8rXs=
X-Google-Smtp-Source: APXvYqyZCClvtBGKRqgn6RMpnhMphfxje1xLbCrBAOtKWV55XEPRlS22GPIDGjqJZTkVcxOgBtq1OhJhFWlRUgi5Gfo=
X-Received: by 2002:a5e:8b43:: with SMTP id z3mr41112680iom.287.1563463502405;
 Thu, 18 Jul 2019 08:25:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190718150103.84837-1-iii@linux.ibm.com>
In-Reply-To: <20190718150103.84837-1-iii@linux.ibm.com>
From:   Y Song <ys114321@gmail.com>
Date:   Thu, 18 Jul 2019 08:24:26 -0700
Message-ID: <CAH3MdRXspndqWAJfqdZ5W_97B=HQndSSGCOnmijx4Y8uv8F6EA@mail.gmail.com>
Subject: Re: [PATCH bpf v2] bpf: fix narrower loads on s390
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 18, 2019 at 8:01 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> The very first check in test_pkt_md_access is failing on s390, which
> happens because loading a part of a struct __sk_buff field produces
> an incorrect result.
>
> The preprocessed code of the check is:
>
> {
>         __u8 tmp = *((volatile __u8 *)&skb->len +
>                 ((sizeof(skb->len) - sizeof(__u8)) / sizeof(__u8)));
>         if (tmp != ((*(volatile __u32 *)&skb->len) & 0xFF)) return 2;
> };
>
> clang generates the following code for it:
>
>       0:        71 21 00 03 00 00 00 00 r2 = *(u8 *)(r1 + 3)
>       1:        61 31 00 00 00 00 00 00 r3 = *(u32 *)(r1 + 0)
>       2:        57 30 00 00 00 00 00 ff r3 &= 255
>       3:        5d 23 00 1d 00 00 00 00 if r2 != r3 goto +29 <LBB0_10>
>
> Finally, verifier transforms it to:
>
>   0: (61) r2 = *(u32 *)(r1 +104)
>   1: (bc) w2 = w2
>   2: (74) w2 >>= 24
>   3: (bc) w2 = w2
>   4: (54) w2 &= 255
>   5: (bc) w2 = w2
>
> The problem is that when verifier emits the code to replace a partial
> load of a struct __sk_buff field (*(u8 *)(r1 + 3)) with a full load of
> struct sk_buff field (*(u32 *)(r1 + 104)), an optional shift and a
> bitwise AND, it assumes that the machine is little endian and
> incorrectly decides to use a shift.
>
> Adjust shift count calculation to account for endianness.
>
> Fixes: 31fd85816dbe ("bpf: permits narrower load from bpf program context fields")
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>  include/linux/filter.h | 13 +++++++++++++
>  kernel/bpf/verifier.c  |  4 ++--
>  2 files changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index ff65d22cf336..4fe88e43f0fe 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -24,6 +24,8 @@
>
>  #include <net/sch_generic.h>
>
> +#include <asm/byteorder.h>
> +
>  #include <uapi/linux/filter.h>
>  #include <uapi/linux/bpf.h>
>
> @@ -1216,4 +1218,15 @@ struct bpf_sockopt_kern {
>         s32             retval;
>  };
>
> +static inline u8 bpf_narrower_load_shift(u32 size_default, u32 size, u32 off)
> +{
> +       u8 load_off = off & (size_default - 1);
> +
> +#ifdef __LITTLE_ENDIAN
> +       return load_off * 8;
> +#else
> +       return (size_default - (load_off + size)) * 8;
> +#endif
> +}
> +
>  #endif /* __LINUX_FILTER_H__ */
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 5900cbb966b1..48edc9c9a879 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -8616,8 +8616,8 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
>                 }
>
>                 if (is_narrower_load && size < target_size) {
> -                       u8 shift = (off & (size_default - 1)) * 8;
> -
> +                       u8 shift = bpf_narrower_load_shift(size_default, size,
> +                                                          off);
>                         if (ctx_field_size <= 4) {
>                                 if (shift)
>                                         insn_buf[cnt++] = BPF_ALU32_IMM(BPF_RSH,
> --
> 2.21.0
>
