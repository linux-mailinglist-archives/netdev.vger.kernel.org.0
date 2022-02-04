Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A19CD4A94AD
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 08:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353265AbiBDHmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 02:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234310AbiBDHmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 02:42:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E13DC061714;
        Thu,  3 Feb 2022 23:42:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB4C9B817E5;
        Fri,  4 Feb 2022 07:42:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44D0C340EB;
        Fri,  4 Feb 2022 07:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643960529;
        bh=Kp4NxRJMhPOrk6yCLmuMuuK4NgUYV4IbJR5q0vDERwg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Mf+Yh0ao1IESxOx9bUslgQDJ/crTGytTfE2ICKsuJBoYFSimt1sHPJzOtRauvpEf4
         PJniz64kRtHRYhJVOJMdIQzG9lFiDwJ9ymo7nCpSyBbU+CQesxcTiUAOZbtMobgzOP
         6vNcvrTLykaykyJSEtpk4k+f30zWrMN9dJMDH6ZDDmxCNp9SKCWVgpTrRWy7FudZV0
         iH7j2nP4shtv0qXNRO2cW62ulfTTPg4crgB64MrHREULX5F8XtmR5cHapwOr1tD/jO
         meN6bKfdF/t0EA91FCRGB3jIOLcnHnAJc+xsrURKv69Q4yT651siBbU4+va+kZqLo6
         O9HrNmpRrAhYA==
Received: by mail-yb1-f172.google.com with SMTP id c6so16316562ybk.3;
        Thu, 03 Feb 2022 23:42:09 -0800 (PST)
X-Gm-Message-State: AOAM531J16bhlPBff1eT1aHwvFSa9txZSuU7QpWPLsR6b+lGbJI8x9g7
        6YFApAk08zoK3NrPaMhMgukVpKvk4mM/pTUF/WU=
X-Google-Smtp-Source: ABdhPJwSMGxOlip1L6UgkfCgoG8NGTIl8TBqIJgfFKT446WFXImJphA5HC0F8VhEp1CaHrjKKdwxh8bG0ZZzGLnVYTs=
X-Received: by 2002:a5b:54b:: with SMTP id r11mr1769676ybp.282.1643960528738;
 Thu, 03 Feb 2022 23:42:08 -0800 (PST)
MIME-Version: 1.0
References: <20220201062803.2675204-1-song@kernel.org> <20220201062803.2675204-5-song@kernel.org>
In-Reply-To: <20220201062803.2675204-5-song@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Thu, 3 Feb 2022 23:41:57 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5uG98fPostcQYw9Kk9DTczOw6LJUJRb8NfiDVVgJcHwQ@mail.gmail.com>
Message-ID: <CAPhsuW5uG98fPostcQYw9Kk9DTczOw6LJUJRb8NfiDVVgJcHwQ@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 4/9] bpf: use prog->jited_len in bpf_prog_ksym_set_addr()
To:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 10:31 PM Song Liu <song@kernel.org> wrote:
>
> Using prog->jited_len is simpler and more accurate than current
> estimation (header + header->size).
>
> Signed-off-by: Song Liu <song@kernel.org>

Hmm... CI [1] reports error on test_progs 159/tailcalls, and bisect points to
this one. However, I couldn't figure out why this breaks tail call.
round_up(PAGE_SIZE) does fix it though. But that won't be accurate, right?

Any suggestions on what could be the reason for these failures?

Thanks,
Song

[1] https://github.com/kernel-patches/bpf/runs/5060194776?check_suite_focus=true

> ---
>  kernel/bpf/core.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 14199228a6f0..e3fe53df0a71 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -537,13 +537,10 @@ long bpf_jit_limit_max __read_mostly;
>  static void
>  bpf_prog_ksym_set_addr(struct bpf_prog *prog)
>  {
> -       const struct bpf_binary_header *hdr = bpf_jit_binary_hdr(prog);
> -       unsigned long addr = (unsigned long)hdr;
> -
>         WARN_ON_ONCE(!bpf_prog_ebpf_jited(prog));
>
>         prog->aux->ksym.start = (unsigned long) prog->bpf_func;
> -       prog->aux->ksym.end   = addr + hdr->size;
> +       prog->aux->ksym.end   = prog->aux->ksym.start + prog->jited_len;
>  }
>
>  static void
> --
> 2.30.2
>
