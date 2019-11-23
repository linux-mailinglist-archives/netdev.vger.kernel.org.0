Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A17AD1080C0
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 22:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfKWVNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 16:13:25 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:32913 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfKWVNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 16:13:24 -0500
Received: by mail-lj1-f195.google.com with SMTP id t5so11335468ljk.0;
        Sat, 23 Nov 2019 13:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ny60vTjb8B7F74H+UvyL8nJBzvp0lTLR06ghkLsh3K0=;
        b=u14wDT/38xCQld69d3CiNpwOHSf9yUsgK3snETGyMs7PxiUMDDCIRwPvtPqNtF3E1G
         CspBuwkc3ZX2cikLS8bA9sqLE6i4ajofUrac1Z6sPLASnYhwJDOAJGa/LRGwGMcQR+bE
         S5Z7sy1xNWEc5FtRGciT3soOS8I2Ga3ZNMvAQadj8TyrkmB0G8P2UQrw1TsjTAN6aCfN
         ZScAo+pa2c8XhkkNZsfH43shbTjTzZLeLmzNwBYxbch+xCULyCk/wj6skf+qNcWtxDhX
         H4bGMgrddu1rI3swaUNbJ1Z0p4nzWLoEa7Z7+FzcL3N8fLFrr2f7yhbwL7olV2dFwXf6
         QNHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ny60vTjb8B7F74H+UvyL8nJBzvp0lTLR06ghkLsh3K0=;
        b=CJW95msmWhV4lYjaUY4NsE0ApiJf3xaxSozj+EvIECs/jTygNDdV6Yhu0wlro4wTnR
         gEuTgd/I3jJk78zaKxQt1t/X6S4zWlAfwnqXD0dW1LOS/jmZqNwM1Qm7MXnV8h+a8/n5
         M/uXfrHhOVgRprkkZ4Y5ZvmwNQLOJT6m54TuGjH96FMYDj6NnbJDdwus7jlftsN3wc2v
         bAMftM8WCu3/dEqwY+RwOmi0gmBQfaLRgo9i3DHsVOaG+238mceL9BK2BvBn7p9D8bDw
         Crhkle9TAKc5Bt28FnVzYrctYv3mLc5DNOrolUGajnybPywDVFchKqHmvPmWAoFzqWsS
         48fg==
X-Gm-Message-State: APjAAAXfea2jL2FEqOX+jiTVFp6gRPUm9m7u9ARz1oYu0YHbMVUfAwEw
        6337VPbAu7fhn+wZwQhIJFYluuvGDWLB2P3gRxI=
X-Google-Smtp-Source: APXvYqx151eBqF7mIyrydIosrdIQqCIdcQX5cCt6TIofHkt+xt4SDVKwByBLPfl+JWwMCb0raW2OXa9Q7htgiUCHDT8=
X-Received: by 2002:a2e:574d:: with SMTP id r13mr16638205ljd.10.1574543602154;
 Sat, 23 Nov 2019 13:13:22 -0800 (PST)
MIME-Version: 1.0
References: <20191123202504.1502696-1-kafai@fb.com>
In-Reply-To: <20191123202504.1502696-1-kafai@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 23 Nov 2019 13:13:11 -0800
Message-ID: <CAADnVQJVLdfMYZx4xJz3PLHusASxLMb9YVS+Nyqzu_Q2MRX0GA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Introduce BPF_TRACE_x helper for the
 tracing tests
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 23, 2019 at 12:25 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> For BPF_PROG_TYPE_TRACING, the bpf_prog's ctx is an array of u64.
> This patch borrows the idea from BPF_CALL_x in filter.h to
> convert a u64 to the arg type of the traced function.
>
> The new BPF_TRACE_x has an arg to specify the return type of a bpf_prog.
> It will be used in the future TCP-ops bpf_prog that may return "void".
>
> The new macros are defined in the new header file "bpf_trace_helpers.h".
> It is under selftests/bpf/ for now.  It could be moved to libbpf later
> after seeing more upcoming non-tracing use cases.
>
> The tests are changed to use these new macros also.  Hence,
> the k[s]u8/16/32/64 are no longer needed and they are removed
> from the bpf_helpers.h.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  tools/lib/bpf/bpf_helpers.h                   | 13 ---
>  .../testing/selftests/bpf/bpf_trace_helpers.h | 58 +++++++++++++
>  .../testing/selftests/bpf/progs/fentry_test.c | 72 ++++------------
>  .../selftests/bpf/progs/fexit_bpf2bpf.c       | 27 ++----
>  .../testing/selftests/bpf/progs/fexit_test.c  | 83 +++++--------------
>  tools/testing/selftests/bpf/progs/kfree_skb.c | 43 +++-------
>  .../selftests/bpf/progs/test_overhead.c       | 16 ++--
>  7 files changed, 125 insertions(+), 187 deletions(-)

Very nice cleanup!
Applied. Thanks!
