Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70F04D9B4E
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 22:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437014AbfJPUPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 16:15:36 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46094 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732607AbfJPUPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 16:15:35 -0400
Received: by mail-qk1-f196.google.com with SMTP id e66so3465549qkf.13;
        Wed, 16 Oct 2019 13:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kf3hDa5YAz/XQp+IPwm8BoZ0nstruffpAZQ7AuOQYiA=;
        b=VhNFe4oLUouMjdPaNTmIq7DzEvfVsV6OjFzF+6px4TsrNsC5TAcBlnlktrlyOdlvds
         aI+TzU2SvB2q60nWqPcUMWBBqwVVdOVKaY2omRIh914AlxMlrZsKCxT5SKDfSmF9IO5/
         frwFiH1HlLGyTVBKRaK+LqTEynVZ8QtiyDrvvzaRyI2Vvyxt03ZMlFdgTjqeKGFvdm3l
         ql6RbJWwJSbgXhEJP6DpJqBEBQEtffhoLSsfW0LZCc8NpOUplPmIhJ2wU+VVmms8qONA
         F4mqyW4VK3MqKI4F0xj3HLjDNRILqlxpwkK3TuJPHJP8Rg06zmCYUU84OSJ5YCaUUuKS
         OMSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kf3hDa5YAz/XQp+IPwm8BoZ0nstruffpAZQ7AuOQYiA=;
        b=cCyrjyTYhc4RpSLvMLarQBCtZ7Tu3r2pIggsZWSdFM4IoWQrKyUEuOKn16GQxw4e7u
         nqEkrQeJKWPX+515B72BLltPJk05DgSI5UTgR2xKhCZexaB15SyetnrxU6QHOsksGrTM
         pRauOwVWiUXmNmFUwt+TZyIbvXgzn1prH8ZVuswFOxMGl7EKPP3mEctmF46Pci0CXyur
         /Vn4sk8ZfNEvCMFmUHHUJWarmfhXa+JpeXmY2xj8aYlZoMGp6XhXyqBKNRRcgvLZlQwi
         3f7yEK7FGnEMzzMrR5c+YoFD+WCKcTRcmdCNIfHLfWPKisK3YHsv9/Cos6qnwpKVV1oV
         WGQw==
X-Gm-Message-State: APjAAAXFHS/6G7DXZ4klBPNlR6CzSuLDhBoIcOxGhA3aaoa+v5eEPazN
        ghxkNUq+niUxfzsMu3Gpf32JtLhZ1sI3K88Y3ug=
X-Google-Smtp-Source: APXvYqwrQxpfhp8YRw2NyS/OgpOa0QmWwAWmewhlV9w9vh6/N/mcD5L9ud40KHPqMF7QdCUTOIQWiJZVQ26kqoexfRc=
X-Received: by 2002:a37:6d04:: with SMTP id i4mr43912301qkc.36.1571256934394;
 Wed, 16 Oct 2019 13:15:34 -0700 (PDT)
MIME-Version: 1.0
References: <20191016032505.2089704-1-ast@kernel.org> <20191016032505.2089704-10-ast@kernel.org>
In-Reply-To: <20191016032505.2089704-10-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Oct 2019 13:15:23 -0700
Message-ID: <CAEf4BzZ+p718RBxQUO5hDv3bfXz=KPcuxmLhHw3P9hHKSp4MCA@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 09/11] bpf: add support for BTF pointers to
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

On Wed, Oct 16, 2019 at 4:16 AM Alexei Starovoitov <ast@kernel.org> wrote:
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

Missed my ack from v2:

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
