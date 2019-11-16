Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC191FE8F4
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 01:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfKPAB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 19:01:26 -0500
Received: from www62.your-server.de ([213.133.104.62]:59828 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfKPAB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 19:01:26 -0500
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVlWa-0005qj-Rk; Sat, 16 Nov 2019 01:01:13 +0100
Received: from [178.197.248.45] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVlWa-0007PX-BS; Sat, 16 Nov 2019 01:01:12 +0100
Subject: Re: [PATCH v4 bpf-next 00/20] Introduce BPF trampoline
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     x86@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
References: <20191114185720.1641606-1-ast@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <04793b36-6a71-92cf-76f0-a4863300b35c@iogearbox.net>
Date:   Sat, 16 Nov 2019 01:01:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191114185720.1641606-1-ast@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25634/Fri Nov 15 10:44:37 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/14/19 7:57 PM, Alexei Starovoitov wrote:
> Introduce BPF trampoline that works as a bridge between kernel functions, BPF
> programs and other BPF programs.
> 
> The first use case is fentry/fexit BPF programs that are roughly equivalent to
> kprobe/kretprobe. Unlike k[ret]probe there is practically zero overhead to call
> a set of BPF programs before or after kernel function.
> 
> The second use case is heavily influenced by pain points in XDP development.
> BPF trampoline allows attaching similar fentry/fexit BPF program to any
> networking BPF program. It's now possible to see packets on input and output of
> any XDP, TC, lwt, cgroup programs without disturbing them. This greatly helps
> BPF-based network troubleshooting.
> 
> The third use case of BPF trampoline will be explored in the follow up patches.
> The BPF trampoline will be used to dynamicly link BPF programs. It's more
> generic mechanism than array and link list of programs used in tracing,
> networking, cgroups. In many cases it can be used as a replacement for
> bpf_tail_call-based program chaining. See [1] for long term design discussion.
> 
> v3->v4:
> - Included Peter's
>    "86/alternatives: Teach text_poke_bp() to emulate instructions" as a first patch.
>    If it changes between now and merge window, I'll rebease to newer version.
>    The patch is necessary to do s/text_poke/text_poke_bp/ in patch 3 to fix the race.
> - In patch 4 fixed bpf_trampoline creation race spotted by Andrii.
> - Added patch 15 that annotates prog->kern bpf context types. It made patches 16
>    and 17 cleaner and more generic.
> - Addressed Andrii's feedback in other patches.
> 
> v2->v3:
> - Addressed Song's and Andrii's comments
> - Fixed few minor bugs discovered while testing
> - Added one more libbpf patch
> 
> v1->v2:
> - Addressed Andrii's comments
> - Added more test for fentry/fexit to kernel functions. Including stress test
>    for maximum number of progs per trampoline.
> - Fixed a race btf_resolve_helper_id()
> - Added a patch to compare BTF types of functions arguments with actual types.
> - Added support for attaching BPF program to another BPF program via trampoline
> - Converted to use text_poke() API. That's the only viable mechanism to
>    implement BPF-to-BPF attach. BPF-to-kernel attach can be refactored to use
>    register_ftrace_direct() whenever it's available.
> 
> [1]
> https://lore.kernel.org/bpf/20191112025112.bhzmrrh2pr76ssnh@ast-mbp.dhcp.thefacebook.com/
> 
> Alexei Starovoitov (19):
>    bpf: refactor x86 JIT into helpers
>    bpf: Add bpf_arch_text_poke() helper
>    bpf: Introduce BPF trampoline
>    libbpf: Introduce btf__find_by_name_kind()
>    libbpf: Add support to attach to fentry/fexit tracing progs
>    selftest/bpf: Simple test for fentry/fexit
>    bpf: Add kernel test functions for fentry testing
>    selftests/bpf: Add test for BPF trampoline
>    selftests/bpf: Add fexit tests for BPF trampoline
>    selftests/bpf: Add combined fentry/fexit test
>    selftests/bpf: Add stress test for maximum number of progs
>    bpf: Reserve space for BPF trampoline in BPF programs
>    bpf: Fix race in btf_resolve_helper_id()
>    bpf: Annotate context types
>    bpf: Compare BTF types of functions arguments with actual types
>    bpf: Support attaching tracing BPF program to other BPF programs
>    libbpf: Add support for attaching BPF programs to other BPF programs
>    selftests/bpf: Extend test_pkt_access test
>    selftests/bpf: Add a test for attaching BPF prog to another BPF prog
>      and subprog

Applied, thanks!
