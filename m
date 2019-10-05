Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA69FCCC55
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 20:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388105AbfJESkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 14:40:16 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37587 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387791AbfJESkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 14:40:16 -0400
Received: by mail-qt1-f193.google.com with SMTP id l3so13458492qtr.4;
        Sat, 05 Oct 2019 11:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mON69cO2JyLTRxDEuuHEP2EPR7Uadvand9Zo6W62z0A=;
        b=AndbxkxqTIiS9cvcr/WlqpnWxOEkOzsSFb4XRe4I5VLfQpbiWNSdVFp9BvCEprZ9AW
         lA7FCxv7Uh7KMzOGn6CyXYLlpy+dRQuKxvFtphZMeb7ikThIsZs7mol85UcKDFlUYhCX
         GlOtpJLH9kCrAsK6nsXnW4M7PwsK5eNEGSFGc7WSCkvcKUw5w6NTrL8+JrReBUtQjZJ7
         rY2RzMzWq/C9czoqbXXNOCzlt3XAFwg7aZ2qvlZV0F13gOUFLQzvkkR6cyS4zUB+4Rgc
         E+1OpGvQ3RB3hpRtgjpxUn8XG/cKY6hEOe/hMKIhHgCgA67wh8N63XFPXc+Wa4qzXYkq
         JurQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mON69cO2JyLTRxDEuuHEP2EPR7Uadvand9Zo6W62z0A=;
        b=NGQ4G0omxA/mR/1C0qYDeCEqWATlHBMxXmxDA9kZxBItRL4rSUqXpVhN2/jQWpGtkN
         eWIK72cCyC4/CjGDA/o17asFjrz9/7bZUTdRUCcLvyDmvkys7M6ihhGu5LS3xLz4X0hY
         1ipdOmd2+sAF0SzriSnFKO8lc0oGl4TOiuGnA60nXgnIWnXW2lE10jD84rB1sLFE5pXi
         xQrHmkqK4YL1MuI9at3NaCePXyyox8pO7LCBFtSItA+ddfG+x5NDDDvjTBpUeaTsqyIB
         QCcVoPsJU68Epraow2t5xrF0H99Dljg7dy0D5SuNlGsX+UFo8F6QLp6hsdS5rzu6HvWk
         OTTQ==
X-Gm-Message-State: APjAAAUjk6HTS+5Vkg74l8ttZ7eWZGyIXmPRf7gze6yYR3MNMQ2bFBto
        ZYDDypm7t1JaY0lWGUwQMqu0nV4/3pCoNVJNEmY=
X-Google-Smtp-Source: APXvYqz5fUhkWbmrxPEKo+qYcK4OzSlkETzd6D+kYm7jBq8GL/40WGYjg9GmIKcyYw/G8XyYWaihpBqr1vaU5b3h8Lw=
X-Received: by 2002:a0c:d284:: with SMTP id q4mr19645633qvh.228.1570300815526;
 Sat, 05 Oct 2019 11:40:15 -0700 (PDT)
MIME-Version: 1.0
References: <20191005050314.1114330-1-ast@kernel.org> <20191005050314.1114330-2-ast@kernel.org>
In-Reply-To: <20191005050314.1114330-2-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 5 Oct 2019 11:40:04 -0700
Message-ID: <CAEf4Bzb4neF6j44fqdkNh3X5=sbdkhDNctZMfEPpriv5JWWSRg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 01/10] bpf: add typecast to raw_tracepoints to
 help BTF generation
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
> Wrap existing __bpf_trace_##template() function into
> btf_trace_##template typedef and use it in type cast to
> make gcc emits this type into dwarf. Then pahole will convert it to btf.
> The "btf_trace_" prefix will be used to identify BTF enabled raw tracepoints.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/trace/bpf_probe.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/include/trace/bpf_probe.h b/include/trace/bpf_probe.h
> index d6e556c0a085..ff1a879773df 100644
> --- a/include/trace/bpf_probe.h
> +++ b/include/trace/bpf_probe.h
> @@ -74,11 +74,12 @@ static inline void bpf_test_probe_##call(void)                              \
>  {                                                                      \
>         check_trace_callback_type_##call(__bpf_trace_##template);       \
>  }                                                                      \
> +typedef void (*btf_trace_##template)(void *__data, proto);             \
>  static struct bpf_raw_event_map        __used                                  \
>         __attribute__((section("__bpf_raw_tp_map")))                    \
>  __bpf_trace_tp_map_##call = {                                          \
>         .tp             = &__tracepoint_##call,                         \
> -       .bpf_func       = (void *)__bpf_trace_##template,               \
> +       .bpf_func       = (void *)(btf_trace_##template)__bpf_trace_##template, \
>         .num_args       = COUNT_ARGS(args),                             \
>         .writable_size  = size,                                         \
>  };
> --
> 2.20.0
>
