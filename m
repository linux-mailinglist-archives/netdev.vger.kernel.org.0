Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8C9CCC60
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 20:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388040AbfJESly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 14:41:54 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44375 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387862AbfJESlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 14:41:53 -0400
Received: by mail-qt1-f194.google.com with SMTP id u40so13394206qth.11;
        Sat, 05 Oct 2019 11:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9GAtLPAKcs7RSvLMy/hhZz5WPBQSBJn2oCBqOEurUPM=;
        b=uTCTX9bys1iU79t/ZCGPGhPoBiqolYJTjCqyNWizzRpiY0LnK48vDaD1mgagjiqxib
         cktQJ9qdgETog7qw8vfoGR0EO83x1F50ZMN8P+8q/8100IURU/cSDYtdKomXzpSQoX9e
         8HOiN1Goj5eIL7S8HrVHFnNQvwRJJY0zrnA0VHvjCKG5Z5pnrob+aY+4nl1OWN9nCvqo
         YdwG2Diy0txbOQbHiI9/exMbtPN0fAkFgNkpiMwovvK97x3auFZ8VuFWCJqjngMOUvrV
         rVpUIhWcq+qzdlKzZMcJu8E+RtllhjDbS4WVCjF+RPeZHWYylaQv/KIoIDIaBSUOv7IT
         0YeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9GAtLPAKcs7RSvLMy/hhZz5WPBQSBJn2oCBqOEurUPM=;
        b=cjEUT8WsIgzHbOMJ6D17XtELEUV0g5PsV80D7ScpS+fbZyJahyKD+dLvF2R9gXXODo
         kze04L4tumrYZwTKb9XsvL8qkCVjLLNbNwhhruZEWwjDPd0ecwfbexyh3rnwDKNaQVpC
         5IKJmkgRV/vjnsgq1K0uhLp9YI3iP2mt3VmkbjWcka1CAbjcOH3ZDHhkyMNBcWXADSwy
         f16aRiPrr+YcBRyFpljIAwgBNFjIBfaAWd5m81IYTwPcY6jBAE2Jc5Fo9cOUppfxg5O/
         9ywttz3S6bdQ25KTKjnC84ZDI8uu+SxuoMhGGT3ZFTeJlAajMYh+XSgtLUL/4zhPrXzT
         tPxQ==
X-Gm-Message-State: APjAAAU/c8fBhzYFQBuCjt6vt12vtewcUuGF8Lkp5z92Pn9Ac5O79You
        gPJmNkfqVmNIjW7eV8WFPCUQuKdZMR/uMcTOqxk=
X-Google-Smtp-Source: APXvYqxQyyWre1ksPo/Wn9LQuSe1PyG2SoA4JnvEHQ+h5maAz1LfL2kJLQ57np694I2oH1sWOWJSVwscU9yPDKtyr0w=
X-Received: by 2002:a05:6214:281:: with SMTP id l1mr19935061qvv.224.1570300912715;
 Sat, 05 Oct 2019 11:41:52 -0700 (PDT)
MIME-Version: 1.0
References: <20191005050314.1114330-1-ast@kernel.org> <20191005050314.1114330-3-ast@kernel.org>
In-Reply-To: <20191005050314.1114330-3-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 5 Oct 2019 11:41:40 -0700
Message-ID: <CAEf4BzYoRO3uSdtbWZzmbbgYc5ckSh9KRiOrnzT_JrSsWni30w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 02/10] bpf: add typecast to bpf helpers to help
 BTF generation
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 4, 2019 at 10:05 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> When pahole converts dwarf to btf it emits only used types.
> Wrap existing bpf helper functions into typedef and use it in
> typecast to make gcc emits this type into dwarf.
> Then pahole will convert it to btf.
> The "btf_#name_of_helper" types will be used to figure out
> types of arguments of bpf helpers.
> The generate code before and after is the same.
> Only dwarf and btf are different.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

It's amazing this works :)

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/filter.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index 2ce57645f3cd..d3d51d7aff2c 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -464,10 +464,11 @@ static inline bool insn_is_zext(const struct bpf_insn *insn)
>  #define BPF_CALL_x(x, name, ...)                                              \
>         static __always_inline                                                 \
>         u64 ____##name(__BPF_MAP(x, __BPF_DECL_ARGS, __BPF_V, __VA_ARGS__));   \
> +       typedef u64 (*btf_##name)(__BPF_MAP(x, __BPF_DECL_ARGS, __BPF_V, __VA_ARGS__)); \
>         u64 name(__BPF_REG(x, __BPF_DECL_REGS, __BPF_N, __VA_ARGS__));         \
>         u64 name(__BPF_REG(x, __BPF_DECL_REGS, __BPF_N, __VA_ARGS__))          \
>         {                                                                      \
> -               return ____##name(__BPF_MAP(x,__BPF_CAST,__BPF_N,__VA_ARGS__));\
> +               return ((btf_##name)____##name)(__BPF_MAP(x,__BPF_CAST,__BPF_N,__VA_ARGS__));\
>         }                                                                      \
>         static __always_inline                                                 \
>         u64 ____##name(__BPF_MAP(x, __BPF_DECL_ARGS, __BPF_V, __VA_ARGS__))
> --
> 2.20.0
>
