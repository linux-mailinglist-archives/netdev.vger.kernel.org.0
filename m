Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC26D4828
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 21:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbfJKTDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 15:03:45 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45579 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728738AbfJKTDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 15:03:45 -0400
Received: by mail-qk1-f196.google.com with SMTP id z67so9827271qkb.12;
        Fri, 11 Oct 2019 12:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=acmHPkg4gjfDM0WB/4AWPyCNn4psVPOyPMoul8Q2Yvo=;
        b=HSIMQvlHETVQKolhCHyJ1tJh04z+vzoR0avIO+LQbaabkgGj7tKrCPzFGmoJ63W0Wr
         uEaPaup0rdsfEsw/vM1IuuhENesxuHTHsH4y7HRza8ZZOjIKeGpTYxk+mDzrer04CYad
         wSUvhx6mRjlv8EQO5++Wqa4WuThh7Er/pxiYqSR9Se6vjuCFfPNOMdcbp7NqxKhMkLKF
         Kv06bUK4A85X6dfGlNFV8aZK7DZ2LIFqASHaheyhCcK9Gxlz66irhyFSeYAwhdGloz99
         EAoP/gBiyc6MIVMcQo+0XJ7ufuGzsWUz/Ah+OCkBBwp1yGfa8xIQrXY4MvnqFFu02E9A
         qD2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=acmHPkg4gjfDM0WB/4AWPyCNn4psVPOyPMoul8Q2Yvo=;
        b=Y+eFdi+n7X3jXZF1U2jCaYyWvOTGHp9h7yqI823e8DdaBgzMbE9JAdf7gdOFKaouD9
         RQx3wr/T2B1tLQS/JP9RYTwLpi1rGec1cNLNMQ1/I59bfJHLZao7fpN3HQB1Z0BX4YsZ
         kHsvCpYiC8+LBFZbDMpGo299TTs7mqUI/g24JOAUWd7ORPrvApsk6X0+k97YGud722px
         7GetmD4xIta8qFku0bkU5CMdnz/IujQDzMaz2n9a7duT5rS8lIQhdaKDdUPJNk1uRqh2
         qAH0vJDsmmdKz2Xi2so6OC0Yzxd06oavHMEcwAd8cM69dquosFI8hPLc1bndWjAB0ip+
         o0AQ==
X-Gm-Message-State: APjAAAW8BGgtLt5x3iTniJaUU04P3vY9H9hhMUZ0KEKEVySnDBnTng1Y
        753LIDwoddFb6n0fllRxkz6RIOvsywB5akRJc04=
X-Google-Smtp-Source: APXvYqxstjcykfvnYXWYLGk2yRulYEhFbhIEZem13B3ioxNmcJK71tVacnwiMkJ2XZ46+SgdimcQmCzBBSCmJsL0+qk=
X-Received: by 2002:a37:b447:: with SMTP id d68mr8265478qkf.437.1570820622860;
 Fri, 11 Oct 2019 12:03:42 -0700 (PDT)
MIME-Version: 1.0
References: <20191010041503.2526303-1-ast@kernel.org> <20191010041503.2526303-12-ast@kernel.org>
In-Reply-To: <20191010041503.2526303-12-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Oct 2019 12:03:31 -0700
Message-ID: <CAEf4BzYzqMk0DW+WTzaeF4zd6sOC5xrOZrP=cvrL33Kcr=5ByQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 11/12] bpf: disallow bpf_probe_read[_str] helpers
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

On Wed, Oct 9, 2019 at 9:15 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Disallow bpf_probe_read() and bpf_probe_read_str() helpers in
> raw_tracepoint bpf programs that use in-kernel BTF to track
> types of memory accesses.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

I like it much better, thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/trace/bpf_trace.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 52f7e9d8c29b..fa5743abf842 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -700,6 +700,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>         case BPF_FUNC_map_peek_elem:
>                 return &bpf_map_peek_elem_proto;
>         case BPF_FUNC_probe_read:
> +               if (prog->aux->attach_btf_id)
> +                       return NULL;
>                 return &bpf_probe_read_proto;
>         case BPF_FUNC_ktime_get_ns:
>                 return &bpf_ktime_get_ns_proto;
> @@ -728,6 +730,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>         case BPF_FUNC_get_prandom_u32:
>                 return &bpf_get_prandom_u32_proto;
>         case BPF_FUNC_probe_read_str:
> +               if (prog->aux->attach_btf_id)
> +                       return NULL;
>                 return &bpf_probe_read_str_proto;
>  #ifdef CONFIG_CGROUPS
>         case BPF_FUNC_get_current_cgroup_id:
> --
> 2.23.0
>
