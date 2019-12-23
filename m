Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67F8A129AB2
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 21:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfLWUFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 15:05:52 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:34603 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfLWUFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 15:05:52 -0500
Received: by mail-qk1-f193.google.com with SMTP id j9so14821346qkk.1;
        Mon, 23 Dec 2019 12:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ssvBUwMN+nWa+FLj2K6VWBUkVk3C/c/azb6e6ns7dug=;
        b=EdUWivBiBuakwFDHuQLaNLGfDdo1I4/DvQQxaWf5KzSobz1jSlDwzxHtIxPPuRAml8
         SDla9Kwgxa+od1Rv+CbNCeWJHXWRpylGH3b79OsfBjQM1KIRaYVZAStTEXQ9BZzHAEbL
         tbU74xObaybxDYsMLS+IBeGOiw3qyc+dcmeTmUrxDOvOLg4TLj4Ecx76dImTOR9AYBiO
         iPyN6beRI5RnlLF9z1jN1CCLRVjpGJIY+TCMm1/GTMd+M8H9wxfSAOFKI3UTgsEkQlaq
         R9qLouPlq6nuuLY6istTCQZyo/te25Zv8np/nAJV8fMVqFt5cAS8GALKFo8C9bt0wO44
         Wx4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ssvBUwMN+nWa+FLj2K6VWBUkVk3C/c/azb6e6ns7dug=;
        b=FSVZIqULTa8iPVaUBuDxsG/dVzVrUHMISCFGUF7YLRDMjB2WmXqWPpiXVWEBILXvsk
         i8a0zshU1jxT3/4F3LMg3vq6C0eyCHi+kQDa02QX+i2JWcsfX2ITgYWyeFuKg8WkhY91
         vodugaaXJgiMpaeg64e4Cph43KZkalSNLrVE9ixg1Ee944c6DPgLUKqnTVrH7/rGKcUs
         10S8ZKdmPbh7/GYxNVn/7Ul80RqoluiL8evlzx5XQyFUBt3RamvEvNejUBSYNQMYQQcv
         iJoLTRMpuTjeT4NWRFN1gC5I22gRIRynbWV/8AyYYvOg9gx+J84H8huLgy+LegGN+fC2
         ef4g==
X-Gm-Message-State: APjAAAWRcfV9BKY0KBkYnijQ8USiZ+oBMHs2H/lA1EbRurOd6BEC81JD
        RZmxkycfDIIdHl5/1no1hke+Q8sDh2sQDQfO13s=
X-Google-Smtp-Source: APXvYqzy5cI2LX0G+oZ93vKgqP4d3m+cT3ddlGT09XaRrd+Jl+F/PcMdQxrH1Akh8FQU8Pc7aEaDiBQleuI2DcrzlYw=
X-Received: by 2002:a37:a685:: with SMTP id p127mr29061450qke.449.1577131550891;
 Mon, 23 Dec 2019 12:05:50 -0800 (PST)
MIME-Version: 1.0
References: <20191221062556.1182261-1-kafai@fb.com> <20191221062604.1182843-1-kafai@fb.com>
In-Reply-To: <20191221062604.1182843-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 Dec 2019 12:05:40 -0800
Message-ID: <CAEf4Bzam8yp9ciDDY0jye+zE1jM-sbe1+LSjby9ChRvWbeXmbw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 04/11] bpf: Support bitfield read access in btf_struct_access
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 10:26 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch allows bitfield access as a scalar.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  kernel/bpf/btf.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 6e652643849b..da73b63acfc5 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3744,10 +3744,6 @@ int btf_struct_access(struct bpf_verifier_log *log,
>         }
>
>         for_each_member(i, t, member) {
> -               if (btf_member_bitfield_size(t, member))
> -                       /* bitfields are not supported yet */
> -                       continue;
> -
>                 /* offset of the field in bytes */
>                 moff = btf_member_bit_offset(t, member) / 8;
>                 if (off + size <= moff)
> @@ -3757,6 +3753,12 @@ int btf_struct_access(struct bpf_verifier_log *log,
>                 if (off < moff)
>                         continue;
>
> +               if (btf_member_bitfield_size(t, member)) {
> +                       if (off == moff && off + size <= t->size)
> +                               return SCALAR_VALUE;
> +                       continue;
> +               }

Shouldn't this check be done before (off < moff) above?

Imagine this situation:

struct {
  int :16;
  int x:8;
};

Compiler will generate 4-byte load with offset 0, and then bit shifts
to extract third byte. From kernel perspective, you'll see that off=0,
but moff=2, which will get skipped.

So there are two problems, I think:
1. if member is bitfield, special handle that before (off < moff) case.
2. off == moff is too precise, I think it should be `off <= moff`, but
also check that it covers entire bitfield, e.g.:

  (off + size) * 8 >= btf_member_bit_offset(t, member) +
btf_member_bitfield_size(t, member)

Make sense or am I missing anything?

> +
>                 /* type of the field */
>                 mtype = btf_type_by_id(btf_vmlinux, member->type);
>                 mname = __btf_name_by_offset(btf_vmlinux, member->name_off);
> --
> 2.17.1
>
