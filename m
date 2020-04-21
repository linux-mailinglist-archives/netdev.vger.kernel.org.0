Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5DA51B1D99
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 06:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgDUEa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 00:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725904AbgDUEaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 00:30:25 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6049C061A0F;
        Mon, 20 Apr 2020 21:30:23 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id k8so1537104ejv.3;
        Mon, 20 Apr 2020 21:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JaRV6n7+ccaKT0v01yd0l6B+jTgUwBzSELbdheC0Jd8=;
        b=M+nksk/9z+RBAC/I+whdt3ySMp6DprA4BX9reQA7ke7Rsc7Z+/wcR9fz6hLIKMACy0
         rfjojAJJNUgt0MSj4Zt86k6z/lqrP2ZmVeo8C47lOEOcFHZTMsdszEdjvkMZ4AsWbjZh
         D2yG/CmZkwds3D4UdU7ep8UJTORTr005UADm4mucoywmSXm4j/CgV2rTcc8lm3jVTJWh
         7qSnStnVOeEhOkAjqGz/s/WYA9KHz0n5Ctx8Oj6oegvZ4GNGS/SX+QrgZNI1Nnt6+13Z
         iaoAsdxUH76ViyzBVepub1KNUmaaGTVbeYD9/YHXKDFWlcBro4g908b2QhkHpqw0AulI
         xtQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JaRV6n7+ccaKT0v01yd0l6B+jTgUwBzSELbdheC0Jd8=;
        b=qIUFmM8ZfBYLwp0bk3eJlH9s4eB17GZ2zzVr03yx+FjpyKC1O/33yKG66MX9FJ4J5c
         4ZzR09MrxaScwuvs3zYU6tdECEKjuJ1qEwAVD6vT7f5xe9j1UcZr9jt+57S9lZijnfRI
         cX+cqfCGQRzkpEVAdXg8uRsGTlmOJjkBKr7UmxBHLbtTVbJ3LDoiZva699PFwA55YjU2
         EDek6657ZTolLpVJhtQPhBrMaG6VTzLEBVQitjfdIkqFFQdE2QwbXDz1RNjTeiKhaYrt
         SQ20wmxRgNrXDATEZGlpYZYep61r5PRJ32zVokE5l+1xYiB+e1KCOP/3LTgu5qm/FMy+
         0ncw==
X-Gm-Message-State: AGi0PuaoXFKjzaKxVy7wc10iPQHb8N7RT8PGEZhhs0HTH5v1ua+VujKt
        HjD6J/wLrDMIQHc8Bo0ifLvoKLvMshqbo3vWiu4=
X-Google-Smtp-Source: APiQypIMD70EtNdPatK85IUSaKOTriZ1+IxiJ4MjqkYjKGaWAZbX9pp08uyo1mYe6AKdkLOTgUPU0VUJcjgu3hKmZzw=
X-Received: by 2002:a17:906:54cd:: with SMTP id c13mr18570001ejp.307.1587443422405;
 Mon, 20 Apr 2020 21:30:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200421002804.5118-1-luke.r.nels@gmail.com>
In-Reply-To: <20200421002804.5118-1-luke.r.nels@gmail.com>
From:   Xi Wang <xi.wang@gmail.com>
Date:   Mon, 20 Apr 2020 21:29:46 -0700
Message-ID: <CAKU6vyYZqw2JgPXwQUps7SMAcT=7PRaa37yXnHCbCoK0Yt6D5Q@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf, riscv: Fix tail call count off by one in RV32
 BPF JIT
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     bpf@vger.kernel.org, Luke Nelson <luke.r.nels@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 5:28 PM Luke Nelson <lukenels@cs.washington.edu> wrote:
> This patch fixes an off by one error in the RV32 JIT handling for BPF
> tail call. Currently, the code decrements TCC before checking if it
> is less than zero. This limits the maximum number of tail calls to 32
> instead of 33 as in other JITs. The fix is to instead check the old
> value of TCC before decrementing.
>
> Fixes: 5f316b65e99f ("riscv, bpf: Add RV32G eBPF JIT")
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
> ---
>  arch/riscv/net/bpf_jit_comp32.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/net/bpf_jit_comp32.c b/arch/riscv/net/bpf_jit_comp32.c
> index 302934177760..11083d4d5f2d 100644
> --- a/arch/riscv/net/bpf_jit_comp32.c
> +++ b/arch/riscv/net/bpf_jit_comp32.c
> @@ -770,12 +770,13 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
>         emit_bcc(BPF_JGE, lo(idx_reg), RV_REG_T1, off, ctx);
>
>         /*
> -        * if ((temp_tcc = tcc - 1) < 0)
> +        * temp_tcc = tcc - 1;
> +        * if (tcc < 0)
>          *   goto out;
>          */
>         emit(rv_addi(RV_REG_T1, RV_REG_TCC, -1), ctx);
>         off = (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
> -       emit_bcc(BPF_JSLT, RV_REG_T1, RV_REG_ZERO, off, ctx);
> +       emit_bcc(BPF_JSLT, RV_REG_TCC, RV_REG_ZERO, off, ctx);

Nice catch!

Acked-by: Xi Wang <xi.wang@gmail.com>
