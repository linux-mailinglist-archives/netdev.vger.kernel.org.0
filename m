Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E993B3B61
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 06:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhFYEDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 00:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhFYEDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 00:03:40 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DA3C061574;
        Thu, 24 Jun 2021 21:01:18 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id j2so14026974lfg.9;
        Thu, 24 Jun 2021 21:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S1GTNN1z/IkduZ5kkv4dtHHucdV9KwV0K8dsnXmmNYM=;
        b=CuIJ9nSdpHWKq9ctkFdCqNdG6yzAF5jDIHs1A/xH0zZQkVq8Gn3LiGIN29hqy1idpG
         cSX7DiU33QGYIZ3KTMuCU1M4dprCB5SEUroXbHJjLoClYSj95w3IUJVURdbQiAsYVDqv
         qQuC1V9NFP1afIPDroAABoY9AgTVMy14Hju5OAmxqCEjA/EhsMaDfMcWwJo2kIyp19Qo
         9e7hIRiUGX0swPjBzn1QbMZpuumDLDMXgVQJLv4mp26I2VrlAZ8rV6vdQ72q2kG7BVTu
         xFZaLVzup1MyidHbZHrx3EljAkGuyhdds7irHGBP6cf/6r7y1TN7Hx8GA6SCp5lobMLJ
         n2zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S1GTNN1z/IkduZ5kkv4dtHHucdV9KwV0K8dsnXmmNYM=;
        b=cZlAr1rsJunjl8NYAb/NeEvu3MIPtjmgvzcad1hto5tQUf60NOU/MpshMkKZyymLuy
         GxljL4UPAQH8kou06vrnOcE8lFHrpCyYTmS0LHswJlTZPzI+zE1f+AsAOO4jAsv9Yinm
         1LCJlpwwasfG5TfGtq/bNIBTJjspe+zvUV283SqXqOcU9Pyx74//kph7uesl+3Wk6CKr
         BZcFSR3wMtHTI8ilzvU28cocAQShakxSqcOiqix/seI5CAzA8BFCZf986/Y2IOimlgep
         tas92vHycii+mLW/Fs9vHcusKEYwWwkqkKWtqEnJI5caO/jfTMLSDZxotAzrfn9DHQvi
         4gqw==
X-Gm-Message-State: AOAM533/hzLaROUc+z1WH/YBT7SFDHj/0/fDxzEVMgweEBoN86wBAA3x
        BNgRD3DJuGEp0VfLYJ9We9rlZjxOnd+cvViV3H8=
X-Google-Smtp-Source: ABdhPJzLYV7rYqObjx7O7ZdxD6gFN8Z948ZlrxW66doL5t0jNv0vm1dKo9zaOXnzTdIOIksLAOVQIG8maiiCJoOneU8=
X-Received: by 2002:a05:6512:10cb:: with SMTP id k11mr6375062lfg.182.1624593677206;
 Thu, 24 Jun 2021 21:01:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAADnVQJux+8n-vpuK9FqTLuj4cXrp04pGkpvKaUdAPXLQ4c-PQ@mail.gmail.com>
 <20210622110026.1157847-1-ravi.bangoria@linux.ibm.com>
In-Reply-To: <20210622110026.1157847-1-ravi.bangoria@linux.ibm.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 24 Jun 2021 21:01:05 -0700
Message-ID: <CAADnVQKLwEEZJ=_=g8RfgOrt9b1XN=dM9bt515pOrru=ADQR1Q@mail.gmail.com>
Subject: Re: [PATCH] x86 bpf: Fix extable offset calculation
To:     Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 4:01 AM Ravi Bangoria
<ravi.bangoria@linux.ibm.com> wrote:
>
> commit 4c5de127598e1 ("bpf: Emit explicit NULL pointer checks
> for PROBE_LDX instructions.") is emitting couple of instructions
> before actual load. Consider those additional instructions while
> calculating extable offset.
>
> Fixes: 4c5de127598e1 ("bpf: Emit explicit NULL pointer checks for PROBE_LDX instructions.")
> Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
> ---
>  arch/x86/net/bpf_jit_comp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 2a2e290fa5d8..231a8178cc11 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -1297,7 +1297,7 @@ st:                       if (is_imm8(insn->off))
>                         emit_ldx(&prog, BPF_SIZE(insn->code), dst_reg, src_reg, insn->off);
>                         if (BPF_MODE(insn->code) == BPF_PROBE_MEM) {
>                                 struct exception_table_entry *ex;
> -                               u8 *_insn = image + proglen;
> +                               u8 *_insn = image + proglen + (u8)(start_of_ldx - temp);

Great debugging and the fix. Thanks a lot.
I've dropped (u8) cast, kept (), and applied to bpf tree.
I think it looks cleaner without that cast.
Could you send a followup patch with a selftest, so I don't make
the same mistake again ? ;)
