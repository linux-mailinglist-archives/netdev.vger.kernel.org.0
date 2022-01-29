Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25FDD4AC0E8
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 15:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380107AbiBGOQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 09:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345934AbiBGONQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 09:13:16 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D410EC0401C1;
        Mon,  7 Feb 2022 06:13:15 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JsnYw5SMZz1FCwb;
        Mon,  7 Feb 2022 21:49:24 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Mon, 7 Feb
 2022 21:53:34 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <houtao1@huawei.com>, Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <jthierry@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH bpf-next v3 0/4] bpf, arm64: support more atomic ops
Date:   Sun, 30 Jan 2022 06:04:48 +0800
Message-ID: <20220129220452.194585-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
v3:
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

v1: https://lore.kernel.org/bpf/20220121135632.136976-1-houtao1@huawei.com/

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
2.27.0

