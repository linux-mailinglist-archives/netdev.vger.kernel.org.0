Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573B948B496
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344864AbiAKRwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344872AbiAKRwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:52:33 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBD3C034001;
        Tue, 11 Jan 2022 09:51:25 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id e19so11669223plc.10;
        Tue, 11 Jan 2022 09:51:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dCLKPvyqwFiADeW+fUHpp9nGxWyERyIzo7SwvZQVl9s=;
        b=ZNrTBDgtZqfO/0O53VItY+K50sRyRO/na+zTvONRWtyTbwdYbhkhi5Hu2gKFEe2D/g
         Nnh8WsX5J7CCnTsCUSg9HtbUCPFWPTQ3k6mS69EuE2c8owF2ITCpxI7UJ6Jn2A4YuDCF
         9JQ+WpvwRErEy5O4WtipqJ5RG8QIsx/TdLAa8cjQ9MHBabhdnLhi2EOz3oG3jWe27Qqm
         OffY1/kCH69ThL34Jng8c4HijqodU/cJn9PApWrlSBTN7BFJNFb9fGjC1/a94h+O7lLE
         twHAdDYbAwQY360CJXEQBaiJlbbej5CHyQJ0f05Tbn80scTpsq2iIAwGGS9ChvfSfVF5
         /T3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dCLKPvyqwFiADeW+fUHpp9nGxWyERyIzo7SwvZQVl9s=;
        b=a33EPPn5yp5+VHkKFO4X9JlKQJdwa3Nk7fMPcv9PU1IB/iSBT2T6Pvm7UNUddEjaXL
         IJJaFZLPTSMI8I7HI3dgaueiGafgzJruGRdsY2WyvRhPK45mTDJON919k5PmM+f4UvZL
         nkb0sz8aniwT0zIQvaXmMQoQQMlLnA41mgsstd6G3qf9Pw12t6nrbfD+bwP4eHiOQRWv
         cl7SDjtGExJo6XbM72LRMHoMRBpGL0VpWp2SOSn5p1A7E1OYMSsVnTLQK4oWWN0/0TO4
         rKMbWW44gywALKd04R3uZs3GfQtQcGLKk8i4UD6tnmr982Z3P688f0mjBL4yc+CFEy8j
         Tx+g==
X-Gm-Message-State: AOAM530bb2hOI0sNCkxlExOZ0tz154vbkmKIxPNgOGNwwVBN/BO9xBmd
        LKpWzh60BiAl8LKQFTzGr52TkS8N/uUH+qxGrws=
X-Google-Smtp-Source: ABdhPJydex/pZa/4x+YHMH39gD/e+xj74BR+O6j9dxvaO25qdr9CmE/7L4+pz0l4wjJfYoyr/SRVhaeHRmPponx1o8s=
X-Received: by 2002:a63:7c50:: with SMTP id l16mr4997656pgn.95.1641923485232;
 Tue, 11 Jan 2022 09:51:25 -0800 (PST)
MIME-Version: 1.0
References: <20220108051121.28632-1-yichun@openresty.com>
In-Reply-To: <20220108051121.28632-1-yichun@openresty.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 11 Jan 2022 09:51:13 -0800
Message-ID: <CAADnVQLRtVtfw3GxiHskLRBV8BKgeEVOP8qbje-mRNKn9rMOFw@mail.gmail.com>
Subject: Re: [PATCH] bpf: core: Fix the call ins's offset s32 -> s16 truncation
To:     "Yichun Zhang (agentzh)" <yichun@openresty.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 7, 2022 at 9:11 PM Yichun Zhang (agentzh)
<yichun@openresty.com> wrote:
>
> The BPF interpreter always truncates the BPF CALL instruction's 32-bit
> jump offset to 16-bit. Large BPF programs run by the interpreter often
> hit this issue and result in weird behaviors when jumping to the wrong
> destination instructions.
>
> The BPF JIT compiler does not have this bug.
>
> Fixes: 1ea47e01ad6ea ("bpf: add support for bpf_call to interpreter")
> Signed-off-by: Yichun Zhang (agentzh) <yichun@openresty.com>
> ---
>  kernel/bpf/core.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 2405e39d800f..dc3c90992f33 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -59,6 +59,9 @@
>  #define CTX    regs[BPF_REG_CTX]
>  #define IMM    insn->imm
>
> +static u64 (*interpreters_args[])(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5,
> +                                 const struct bpf_insn *insn);
> +
>  /* No hurry in this branch
>   *
>   * Exported for the bpf jit load helper.
> @@ -1560,10 +1563,10 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
>                 CONT;
>
>         JMP_CALL_ARGS:
> -               BPF_R0 = (__bpf_call_base_args + insn->imm)(BPF_R1, BPF_R2,
> -                                                           BPF_R3, BPF_R4,
> -                                                           BPF_R5,
> -                                                           insn + insn->off + 1);
> +               BPF_R0 = (interpreters_args[insn->off])(BPF_R1, BPF_R2,
> +                                                       BPF_R3, BPF_R4,
> +                                                       BPF_R5,
> +                                                       insn + insn->imm + 1);
>                 CONT;
>
>         JMP_TAIL_CALL: {
> @@ -1810,9 +1813,7 @@ EVAL4(PROG_NAME_LIST, 416, 448, 480, 512)
>  void bpf_patch_call_args(struct bpf_insn *insn, u32 stack_depth)
>  {
>         stack_depth = max_t(u32, stack_depth, 1);
> -       insn->off = (s16) insn->imm;
> -       insn->imm = interpreters_args[(round_up(stack_depth, 32) / 32) - 1] -
> -               __bpf_call_base_args;
> +       insn->off = (round_up(stack_depth, 32) / 32) - 1;
>         insn->code = BPF_JMP | BPF_CALL_ARGS;

Neat. Please add a test case and resubmit.
