Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD935D47DB
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 20:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbfJKSsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 14:48:35 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41748 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728879AbfJKSsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 14:48:33 -0400
Received: by mail-qt1-f195.google.com with SMTP id v52so15263387qtb.8;
        Fri, 11 Oct 2019 11:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=73gNvNUL/eZWJNeGowy9o3vbLrHdWRug1BAZQVf5eCs=;
        b=YZ+3eVEQH7bY6Ju0z+iyn/nDScU6dBWxGflxFdyeKcKIju3wARwaNqFiadJqsssgt3
         LGijeHgLTtkBVxuwPeoGRmjvVCC8TpWmzDeXffzm2b3PqmZs0FF/64GZ+XZLJpspJ0np
         k5Yank4aH1EzIp+Yb3FJKwYXlyO3e4csr3/174XcC/axBUsCM+uUnPixqC0IaBk14PLH
         xgxYg/6Gbgd1ZIpS9yaGMTPYUgHMxnHvf9EddlK0/xdVjehys0Pyq4usmb2jwnPUjL1T
         Tso74n4+L7MAq0uiTm9VqvKG/iPnoCtNwu0Nilwm4LvZE3PUhggdG20WEZzyQISvbeyo
         qGgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=73gNvNUL/eZWJNeGowy9o3vbLrHdWRug1BAZQVf5eCs=;
        b=AN5wIX+HUW+QB2u6NfFRsCTdQljqLRVgE8wKzJbcVDqHrMV+7HHJWH1F+MyuQhtNKp
         ft1dtow2GefeRi/e4Sx6isSdwSxDNq8ERfXQPv4E07YAPncjod1jY+AWRDfHwUHvAsPg
         2WH2E34vKG/IL16DfjtPy5oBDCTnrdum3/jQtOsHkQPOLhwXPhWCm5qZ9ZAhBwz2Vmj2
         J0LvkwCa1GlvfEt+WRrTVV3dUW1kC8I5TdDj9CsqPj9KJnQzYUefNxUj0f+q+W7rrZEd
         ZxzPuSTnFHCZ3VOqxBpvFRyfIk2UhMKQ2uEppqJ9bBmG/kDjuNpjQX2rNXZQhPB6SAL0
         L/kw==
X-Gm-Message-State: APjAAAUTdPPnHeVUWSBW3WWjju+bW2XvOxCCe08OQ7Hw1nmyFItOx2T/
        g3K+pxsasfP+M+S8q+RPWViRfw5s700rJF9nkXY=
X-Google-Smtp-Source: APXvYqzMUTs/OJRnbjtzX2/9UIHuIwFI9fqMySzqt7WrUjoWWXWnqcCfs1ttD6GPiLYxUvru96AM/iewSC26F08sCqI=
X-Received: by 2002:ac8:1242:: with SMTP id g2mr18261083qtj.141.1570819710945;
 Fri, 11 Oct 2019 11:48:30 -0700 (PDT)
MIME-Version: 1.0
References: <20191010041503.2526303-1-ast@kernel.org> <20191010041503.2526303-10-ast@kernel.org>
In-Reply-To: <20191010041503.2526303-10-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Oct 2019 11:48:19 -0700
Message-ID: <CAEf4BzZ3A47KQB1uN0nu2JPdm-a+Kx0fkkkp+JRRLNs4DJJ3hw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 09/12] bpf: add support for BTF pointers to
 x86 JIT
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
> Pointer to BTF object is a pointer to kernel object or NULL.
> Such pointers can only be used by BPF_LDX instructions.
> The verifier changed their opcode from LDX|MEM|size
> to LDX|PROBE_MEM|size to make JITing easier.
> The number of entries in extable is the number of BPF_LDX insns
> that access kernel memory via "pointer to BTF type".
> Only these load instructions can fault.
> Since x86 extable is relative it has to be allocated in the same
> memory region as JITed code.
> Allocate it prior to last pass of JITing and let the last pass populate it.
> Pointer to extable in bpf_prog_aux is necessary to make page fault
> handling fast.
> Page fault handling is done in two steps:
> 1. bpf_prog_kallsyms_find() finds BPF program that page faulted.
>    It's done by walking rb tree.
> 2. then extable for given bpf program is binary searched.
> This process is similar to how page faulting is done for kernel modules.
> The exception handler skips over faulting x86 instruction and
> initializes destination register with zero. This mimics exact
> behavior of bpf_probe_read (when probe_kernel_read faults dest is zeroed).
>
> JITs for other architectures can add support in similar way.
> Until then they will reject unknown opcode and fallback to interpreter.
>
> Since extable should be aligned and placed near JITed code
> make bpf_jit_binary_alloc() return 4 byte aligned image offset,
> so that extable aligning formula in bpf_int_jit_compile() doesn't need
> to rely on internal implementation of bpf_jit_binary_alloc().
> On x86 gcc defaults to 16-byte alignment for regular kernel functions
> due to better performance. JITed code may be aligned to 16 in the future,
> but it will use 4 in the meantime.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  arch/x86/net/bpf_jit_comp.c | 97 +++++++++++++++++++++++++++++++++++--
>  include/linux/bpf.h         |  3 ++
>  include/linux/extable.h     | 10 ++++
>  kernel/bpf/core.c           | 20 +++++++-
>  kernel/bpf/verifier.c       |  1 +
>  kernel/extable.c            |  2 +
>  6 files changed, 128 insertions(+), 5 deletions(-)
>

[...]
