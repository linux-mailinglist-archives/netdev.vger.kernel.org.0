Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB772561DA
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 22:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgH1ULK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 16:11:10 -0400
Received: from www62.your-server.de ([213.133.104.62]:42380 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgH1ULF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 16:11:05 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kBki1-0002nd-KW; Fri, 28 Aug 2020 22:10:49 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kBki1-000BPp-Dt; Fri, 28 Aug 2020 22:10:49 +0200
Subject: Re: [PATCH v3 bpf-next 0/5] bpf: Introduce minimal support for
 sleepable progs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     josef@toxicpanda.com, bpoirier@suse.com, akpm@linux-foundation.org,
        hannes@cmpxchg.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
References: <20200827220114.69225-1-alexei.starovoitov@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c88c5676-33c0-d78c-cf12-3cf32bbf6803@iogearbox.net>
Date:   Fri, 28 Aug 2020 22:10:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200827220114.69225-1-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25913/Fri Aug 28 15:19:15 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/28/20 12:01 AM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> v2->v3:
> - switched to minimal allowlist approach. Essentially that means that syscall
>    entry, few btrfs allow_error_inject functions, should_fail_bio(), and two LSM
>    hooks: file_mprotect and bprm_committed_creds are the only hooks that allow
>    attaching of sleepable BPF programs. When comprehensive analysis of LSM hooks
>    will be done this allowlist will be extended.
> - added patch 1 that fixes prototypes of two mm functions to reliably work with
>    error injection. It's also necessary for resolve_btfids tool to recognize
>    these two funcs, but that's secondary.
> 
> v1->v2:
> - split fmod_ret fix into separate patch
> - added denylist
> 
> v1:
> This patch set introduces the minimal viable support for sleepable bpf programs.
> In this patch only fentry/fexit/fmod_ret and lsm progs can be sleepable.
> Only array and pre-allocated hash and lru maps allowed.
> 
> Here is 'perf report' difference of sleepable vs non-sleepable:
>     3.86%  bench     [k] __srcu_read_unlock
>     3.22%  bench     [k] __srcu_read_lock
>     0.92%  bench     [k] bpf_prog_740d4210cdcd99a3_bench_trigger_fentry_sleep
>     0.50%  bench     [k] bpf_trampoline_10297
>     0.26%  bench     [k] __bpf_prog_exit_sleepable
>     0.21%  bench     [k] __bpf_prog_enter_sleepable
> vs
>     0.88%  bench     [k] bpf_prog_740d4210cdcd99a3_bench_trigger_fentry
>     0.84%  bench     [k] bpf_trampoline_10297
>     0.13%  bench     [k] __bpf_prog_enter
>     0.12%  bench     [k] __bpf_prog_exit
> vs
>     0.79%  bench     [k] bpf_prog_740d4210cdcd99a3_bench_trigger_fentry_sleep
>     0.72%  bench     [k] bpf_trampoline_10381
>     0.31%  bench     [k] __bpf_prog_exit_sleepable
>     0.29%  bench     [k] __bpf_prog_enter_sleepable
> 
> Sleepable vs non-sleepable program invocation overhead is only marginally higher
> due to rcu_trace. srcu approach is much slower.
> 
> Alexei Starovoitov (5):
>    mm/error_inject: Fix allow_error_inject function signatures.
>    bpf: Introduce sleepable BPF programs
>    bpf: Add bpf_copy_from_user() helper.
>    libbpf: support sleepable progs
>    selftests/bpf: Add sleepable tests
> 
>   arch/x86/net/bpf_jit_comp.c                   | 32 +++++---
>   include/linux/bpf.h                           |  4 +
>   include/uapi/linux/bpf.h                      | 16 ++++
>   init/Kconfig                                  |  1 +
>   kernel/bpf/arraymap.c                         |  1 +
>   kernel/bpf/hashtab.c                          | 12 +--
>   kernel/bpf/helpers.c                          | 22 +++++
>   kernel/bpf/syscall.c                          | 13 ++-
>   kernel/bpf/trampoline.c                       | 28 ++++++-
>   kernel/bpf/verifier.c                         | 81 ++++++++++++++++++-
>   kernel/trace/bpf_trace.c                      |  2 +
>   mm/filemap.c                                  |  8 +-
>   mm/page_alloc.c                               |  2 +-
>   tools/include/uapi/linux/bpf.h                | 16 ++++
>   tools/lib/bpf/libbpf.c                        | 25 +++++-
>   tools/testing/selftests/bpf/bench.c           |  2 +
>   .../selftests/bpf/benchs/bench_trigger.c      | 17 ++++
>   .../selftests/bpf/prog_tests/test_lsm.c       |  9 +++
>   tools/testing/selftests/bpf/progs/lsm.c       | 66 ++++++++++++++-
>   .../selftests/bpf/progs/trigger_bench.c       |  7 ++
>   20 files changed, 331 insertions(+), 33 deletions(-)

Applied, thanks!
