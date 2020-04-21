Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45E81B1C1C
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 04:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgDUCqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 22:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725829AbgDUCqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 22:46:19 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78445C061A0E;
        Mon, 20 Apr 2020 19:46:19 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id 198so9845340lfo.7;
        Mon, 20 Apr 2020 19:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o5OcbUGHwiU1CmRyAs5hmz04gA+MaTAsH/b/sIzr7cU=;
        b=KN56EWmXtN8o0IvMzCvJH3XSM9pOdbqZ5nAD9AoPLE+MXetTf0Rykt8SGBHkjtiMS9
         lx6EJ2iYn+Pb7oDrdVUyQf7mjWvfGr6bjVmSI2zJUN4SnupxsawEOPpdj7GfJcQ+wLPk
         rX95L534Ob9XyS3Wm8xeShzZ9JidZZjbOjujWoyKdJ2xgW1/EmsUsC0L1kS9IZNVOI3r
         9wvLdfnenrs9mKqyvz1DX8++9R1cGxFuWwrrnCWOZ/6X9tCTnzD7c4Zpkh0ozM3vrIsD
         niO5m1SZibfXVqrMMxg1a9P3xw00ZBqaXUquszXVRjEM29HVQudqy7jl+E2zhaPVv0W9
         xvCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o5OcbUGHwiU1CmRyAs5hmz04gA+MaTAsH/b/sIzr7cU=;
        b=YWtBOgANUjI/n8MbEFksXwCf7ffDM30zSotpjtgZee0VTj1htfiC/u6vk1GOmaWOU7
         j0qITZf7J6/V/N0CRezWMbg3k2vEi8tsYT40KsnaWWAleOCcxxmjkKM7LHoRlt2p5FHd
         1mq9Y7N0ilIRo3ey9AAlqiUALL+kXJnqmuaeOHHsZwdiAMFl8wbcb+dVAZz+9xH7oHU1
         IH0PBdUWRVD/B+nxqyjPClyZTzhYWEMtCWT9hiSGPH5tCPXvXyj1MkvUBijNdVTVX0cF
         E5dt2jeH+aVdzjv5zLNApnMdZx9RWFIpg5t16IiSOsDDS9LI3BtBRAsLdEQ7B/LjRHoc
         8coA==
X-Gm-Message-State: AGi0PuaJWoDkf5QU0IscHS7RF+2320m4NvJpvSCAzoASuSRBFUK+B8UE
        IY7gbWnKcbJLSO/IHRSzXsJ/fW8ws7F0it/lo7U=
X-Google-Smtp-Source: APiQypIqJWu9QiVesaaTnVGOdtYMSxVQY4sEJwiueOtyt8iKdNYmFMDvnjRUOFgNvj+br6RKUBHnoBWXACbWLX9LPe0=
X-Received: by 2002:ac2:569b:: with SMTP id 27mr12499931lfr.134.1587437177744;
 Mon, 20 Apr 2020 19:46:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200418232655.23870-1-luke.r.nels@gmail.com>
In-Reply-To: <20200418232655.23870-1-luke.r.nels@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 20 Apr 2020 19:46:05 -0700
Message-ID: <CAADnVQL+--GLyaPdj2cRncQ9X-EAravt1_2fjfPhORWA-VUWuQ@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] bpf, x86: Fix encoding for lower 8-bit registers
 in BPF_STX BPF_B
To:     Luke Nelson <lukenels@cs.washington.edu>
Cc:     bpf <bpf@vger.kernel.org>, Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 18, 2020 at 4:27 PM Luke Nelson <lukenels@cs.washington.edu> wrote:
>
> This patch fixes an encoding bug in emit_stx for BPF_B when the source
> register is BPF_REG_FP.
>
> The current implementation for BPF_STX BPF_B in emit_stx saves one REX
> byte when the operands can be encoded using Mod-R/M alone. The lower 8
> bits of registers %rax, %rbx, %rcx, and %rdx can be accessed without using
> a REX prefix via %al, %bl, %cl, and %dl, respectively. Other registers,
> (e.g., %rsi, %rdi, %rbp, %rsp) require a REX prefix to use their 8-bit
> equivalents (%sil, %dil, %bpl, %spl).
>
> The current code checks if the source for BPF_STX BPF_B is BPF_REG_1
> or BPF_REG_2 (which map to %rdi and %rsi), in which case it emits the
> required REX prefix. However, it misses the case when the source is
> BPF_REG_FP (mapped to %rbp).
>
> The result is that BPF_STX BPF_B with BPF_REG_FP as the source operand
> will read from register %ch instead of the correct %bpl. This patch fixes
> the problem by fixing and refactoring the check on which registers need
> the extra REX byte. Since no BPF registers map to %rsp, there is no need
> to handle %spl.
>
> Fixes: 622582786c9e0 ("net: filter: x86: internal BPF JIT")
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>

Applied. Thanks for the fix.
It's questionable whether the verifier should have allowed such insn
in the first place, but JIT fix is good regardless.
