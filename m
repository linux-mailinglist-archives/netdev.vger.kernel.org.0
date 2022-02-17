Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0080F4B998C
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 08:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235847AbiBQHEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 02:04:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiBQHEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 02:04:09 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603D51897DF;
        Wed, 16 Feb 2022 23:03:55 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Jzm465DW6zbncn;
        Thu, 17 Feb 2022 15:02:46 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 17 Feb
 2022 15:03:52 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>, Will Deacon <will@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH bpf-next v4 0/4] bpf, arm64: support more atomic ops
Date:   Thu, 17 Feb 2022 15:22:28 +0800
Message-ID: <20220217072232.1186625-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Atomics support in bpf has already been done by "Atomics for eBPF"
patch series [1], but it only adds support for x86, and this patchset
adds support for arm64.

Patch #1 & patch #2 are arm64 related. Patch #1 moves the common used
macro AARCH64_BREAK_FAULT into insn-def.h for insn.h. Patch #2 adds
necessary encoder helpers for atomic operations.

Patch #3 implements atomic[64]_fetch_add, atomic[64]_[fetch_]{and,or,xor}
and atomic[64]_{xchg|cmpxchg} for arm64 bpf. Patch #4 changes the type of
test program from fentry/ to raw_tp/ for atomics test.

For cpus_have_cap(ARM64_HAS_LSE_ATOMICS) case and no-LSE-ATOMICS case,
./test_verifier, "./test_progs -t atomic", and "insmod ./test_bpf.ko"
are exercised and passed correspondingly.

Comments are always welcome.

Regards,
Tao

[1]: https://lore.kernel.org/bpf/20210114181751.768687-2-jackmanb@google.com/

Change Log:
v4:
 * patch #2: update A64_STADD() accordingly to fix build failure after
   applying patch #1 & patch #2.

v3: https://lore.kernel.org/bpf/20220129220452.194585-1-houtao1@huawei.com/
 * split arm64 insn related code into a separated patch (from Mark)
 * update enum name in aarch64_insn_mem_atomic_op (from Mark)
 * consider all cases for aarch64_insn_mem_order_type and
   aarch64_insn_mb_type (from Mark)
 * exercise and pass "insmod ./test_bpf.ko" test (suggested by Daniel)
 * remove aarch64_insn_gen_store_release_ex() and extend
   aarch64_insn_ldst_type instead
 * compile aarch64_insn_gen_atomic_ld_op(), aarch64_insn_gen_cas() and
   emit_lse_atomic() out when CONFIG_ARM64_LSE_ATOMICS is disabled.

v2: https://lore.kernel.org/bpf/20220127075322.675323-1-houtao1@huawei.com/
  * patch #1: use two separated ASSERT_OK() instead of ASSERT_TRUE()
  * add Acked-by tag for both patches

v1: https://lore.kernel.org/bpf/20220121135632.136976-1-houtao1@huawei.com

Hou Tao (4):
  arm64: move AARCH64_BREAK_FAULT into insn-def.h
  arm64: insn: add encoders for atomic operations
  bpf, arm64: support more atomic operations
  selftests/bpf: use raw_tp program for atomic test

 arch/arm64/include/asm/debug-monitors.h       |  12 -
 arch/arm64/include/asm/insn-def.h             |  14 ++
 arch/arm64/include/asm/insn.h                 |  80 ++++++-
 arch/arm64/lib/insn.c                         | 185 +++++++++++++--
 arch/arm64/net/bpf_jit.h                      |  44 +++-
 arch/arm64/net/bpf_jit_comp.c                 | 223 ++++++++++++++----
 .../selftests/bpf/prog_tests/atomics.c        |  91 ++-----
 tools/testing/selftests/bpf/progs/atomics.c   |  28 +--
 8 files changed, 517 insertions(+), 160 deletions(-)

-- 
2.29.2

