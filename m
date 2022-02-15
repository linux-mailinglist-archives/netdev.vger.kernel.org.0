Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7D14B620C
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 05:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbiBOE0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 23:26:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiBOE0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 23:26:05 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278EAA8ED5;
        Mon, 14 Feb 2022 20:25:56 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JySfn0hT3zccxL;
        Tue, 15 Feb 2022 12:24:49 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Feb 2022 12:25:53 +0800
Subject: Re: [PATCH bpf-next v3 0/4] bpf, arm64: support more atomic ops
To:     Alexei Starovoitov <ast@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <jthierry@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <20220129220452.194585-1-houtao1@huawei.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <f271a3df-e647-3c00-383c-f560ab6e2937@huawei.com>
Date:   Tue, 15 Feb 2022 12:25:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20220129220452.194585-1-houtao1@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ping ?

On 1/30/2022 6:04 AM, Hou Tao wrote:
> Hi,
>
> Atomics support in bpf has already been done by "Atomics for eBPF"
> patch series [1], but it only adds support for x86, and this patchset
> adds support for arm64.
>
> Patch #1 & patch #2 are arm64 related. Patch #1 moves the common used
> macro AARCH64_BREAK_FAULT into insn-def.h for insn.h. Patch #2 adds
> necessary encoder helpers for atomic operations.
>
> Patch #3 implements atomic[64]_fetch_add, atomic[64]_[fetch_]{and,or,xor}
> and atomic[64]_{xchg|cmpxchg} for arm64 bpf. Patch #4 changes the type of
> test program from fentry/ to raw_tp/ for atomics test.
>
> For cpus_have_cap(ARM64_HAS_LSE_ATOMICS) case and no-LSE-ATOMICS case,
> ./test_verifier, "./test_progs -t atomic", and "insmod ./test_bpf.ko"
> are exercised and passed correspondingly.
>
> Comments are always welcome.
>
> Regards,
> Tao
>
> [1]: https://lore.kernel.org/bpf/20210114181751.768687-2-jackmanb@google.com/
>
> Change Log:
> v3:
>  * split arm64 insn related code into a separated patch (from Mark)
>  * update enum name in aarch64_insn_mem_atomic_op (from Mark)
>  * consider all cases for aarch64_insn_mem_order_type and
>    aarch64_insn_mb_type (from Mark)
>  * exercise and pass "insmod ./test_bpf.ko" test (suggested by Daniel)
>  * remove aarch64_insn_gen_store_release_ex() and extend
>    aarch64_insn_ldst_type instead
>  * compile aarch64_insn_gen_atomic_ld_op(), aarch64_insn_gen_cas() and
>    emit_lse_atomic() out when CONFIG_ARM64_LSE_ATOMICS is disabled.
>
> v2: https://lore.kernel.org/bpf/20220127075322.675323-1-houtao1@huawei.com/
>   * patch #1: use two separated ASSERT_OK() instead of ASSERT_TRUE()
>   * add Acked-by tag for both patches
>
> v1: https://lore.kernel.org/bpf/20220121135632.136976-1-houtao1@huawei.com/
>
> Hou Tao (4):
>   arm64: move AARCH64_BREAK_FAULT into insn-def.h
>   arm64: insn: add encoders for atomic operations
>   bpf, arm64: support more atomic operations
>   selftests/bpf: use raw_tp program for atomic test
>
>  arch/arm64/include/asm/debug-monitors.h       |  12 -
>  arch/arm64/include/asm/insn-def.h             |  14 ++
>  arch/arm64/include/asm/insn.h                 |  80 ++++++-
>  arch/arm64/lib/insn.c                         | 185 +++++++++++++--
>  arch/arm64/net/bpf_jit.h                      |  44 +++-
>  arch/arm64/net/bpf_jit_comp.c                 | 223 ++++++++++++++----
>  .../selftests/bpf/prog_tests/atomics.c        |  91 ++-----
>  tools/testing/selftests/bpf/progs/atomics.c   |  28 +--
>  8 files changed, 517 insertions(+), 160 deletions(-)
>

