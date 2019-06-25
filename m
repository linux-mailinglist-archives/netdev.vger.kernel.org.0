Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3C6655891
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 22:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfFYUPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 16:15:44 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39670 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbfFYUPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 16:15:44 -0400
Received: by mail-qt1-f193.google.com with SMTP id i34so19892256qta.6;
        Tue, 25 Jun 2019 13:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jL2T3LnKwFn7OXbtIUsI0f+FbKUo5CwlSQp7ffYY78Q=;
        b=ZNtuV2szwLI+JISEUwJjK2MLkjaOk2fe+1L/GrDH3UJhLl3Y5cN/8PvLgkAlLm5A5K
         XrqTyKfRNOLl5bBzCjBW3k3b5eL3eRlfLLq5G/PHY6LhHEbi9BYHqmo2gA17gdUwirNI
         RsiH/pljuE+aW9HfEBT4vm8UYHPxM3Us2xLZQo3b1NOtIbk5a/B5/JkmJJaFfEKZ7rWe
         m1I0IrdBhrsOYfK4oEg5wnYIQC624Y6n50cwBSaP3TCgccw9sY/TkAzC/QOqQxYcW/VM
         6O6T9s+XGcsiWwE74raQSDIto/4XFra42zNjiF2Z0scmPTNgY1hRie3GqkLAeaCbQat+
         4TsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jL2T3LnKwFn7OXbtIUsI0f+FbKUo5CwlSQp7ffYY78Q=;
        b=VfjeFYyGztXB9MgoqQEWL6NT4idotxRpZ7rq1tElAJvqNfzx9WjlJ6JZIa92DdUjCA
         KhA7yHvWRITNJFX6yK+yAp7UPAxTbDLfyY6XVRqNdVh2AH2y6Oe6ymfkDdivOMWuxTUD
         u9xFvosh2GPE7ta0/i3nBGzco6RRcZHc5eolBPPK4nQborlRIfvJQHKBgxIW/sHqSQIz
         d7SW/qs2Y6ZL9L0gnXqg6o59jSkgiK8i75Dy7I8G9QeA1XyU6n/2OZh1ejDk8uagEVxI
         FdqqWSU6lndbX7r55xM1UA7nePkba4wUaomPDlGUW0Q3APuTLVnd/E+zhHaVAZmaohuP
         0ypg==
X-Gm-Message-State: APjAAAViGkRN2t+xF+sdQwhf2Wav3Lk8cIVMYC0uB3shBZEe6FyQ4eHL
        Qgc/jhDaFtnzYre/rDjmgsQJSvWfSr6YIBB1HvA=
X-Google-Smtp-Source: APXvYqyogBmAFSPhvheG+29OBJGifz/bN1gBWk/8cS+qZO3IUzwYA/ovUEes0db4m2Ay44lFl/vnRjLQZprheIrkTkY=
X-Received: by 2002:ac8:1af4:: with SMTP id h49mr198257qtk.183.1561493743541;
 Tue, 25 Jun 2019 13:15:43 -0700 (PDT)
MIME-Version: 1.0
References: <1561480910-23543-1-git-send-email-jiong.wang@netronome.com>
In-Reply-To: <1561480910-23543-1-git-send-email-jiong.wang@netronome.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Tue, 25 Jun 2019 13:15:32 -0700
Message-ID: <CAPhsuW5KrJ20NAk+bdfTk_rT-G6QfanDDT9djynAVdXWO1Qc9A@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix BPF_ALU32 | BPF_ARSH on BE arches
To:     Jiong Wang <jiong.wang@netronome.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        yauheni.kaliuta@redhat.com, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 12:31 PM Jiong Wang <jiong.wang@netronome.com> wrote:
>
> Yauheni reported the following code do not work correctly on BE arches:
>
>        ALU_ARSH_X:
>                DST = (u64) (u32) ((*(s32 *) &DST) >> SRC);
>                CONT;
>        ALU_ARSH_K:
>                DST = (u64) (u32) ((*(s32 *) &DST) >> IMM);
>                CONT;
>
> and are causing failure of test_verifier test 'arsh32 on imm 2' on BE
> arches.
>
> The code is taking address and interpreting memory directly, so is not
> endianness neutral. We should instead perform standard C type casting on
> the variable. A u64 to s32 conversion will drop the high 32-bit and reserve
> the low 32-bit as signed integer, this is all we want.
>
> Fixes: 2dc6b100f928 ("bpf: interpreter support BPF_ALU | BPF_ARSH")
> Reported-by: Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>

Acked-by: Song Liu <songliubraving@fb.com>

I guess we need:

Cc: <stable@vger.kernel.org> #v5.0+


> ---
>  kernel/bpf/core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 080e2bb..f2148db 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -1364,10 +1364,10 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
>                 insn++;
>                 CONT;
>         ALU_ARSH_X:
> -               DST = (u64) (u32) ((*(s32 *) &DST) >> SRC);
> +               DST = (u64) (u32) (((s32) DST) >> SRC);
>                 CONT;
>         ALU_ARSH_K:
> -               DST = (u64) (u32) ((*(s32 *) &DST) >> IMM);
> +               DST = (u64) (u32) (((s32) DST) >> IMM);
>                 CONT;
>         ALU64_ARSH_X:
>                 (*(s64 *) &DST) >>= SRC;
> --
> 2.7.4
>
