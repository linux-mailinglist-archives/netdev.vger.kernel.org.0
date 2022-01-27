Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75EF849F623
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 10:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347567AbiA1JTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 04:19:55 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:17826 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238053AbiA1JTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 04:19:54 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JlX1z2Y97z9sTp;
        Fri, 28 Jan 2022 17:18:31 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Fri, 28 Jan
 2022 17:19:37 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
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
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH bpf-next v2 0/2] arm64, bpf: support more atomic ops
Date:   Thu, 27 Jan 2022 15:53:20 +0800
Message-ID: <20220127075322.675323-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Atomics support in bpf has already been done by "Atomics for eBPF"
patch series [1], but it only adds support for x86, and this patchset
adds support for arm64.

Patch #1 changes the type of test program from fentry/ to raw_tp/ for
atomics test, because bpf trampoline is not available for arm64 now.
After the change, atomics test will be available for arm64 and other
archs.

Patch #2 implements atomic[64]_fetch_add, atomic[64]_[fetch_]{and,or,xor}
and atomic[64]_{xchg|cmpxchg} for arm64. For no-LSE-ATOMICS case and
cpus_have_cap(ARM64_HAS_LSE_ATOMICS) case, both ./test_verifier and
"./test_progs -t atomic" are exercised and passed correspondingly.

Comments are always welcome.

Regards,
Tao

[1]: https://lore.kernel.org/bpf/20210114181751.768687-2-jackmanb@google.com/

Change Log:
v2:
  * patch #1: use two seperated ASSERT_OK() instead of ASSERT_TRUE()
  * add Acked-by tag for both patches

v1: https://lore.kernel.org/bpf/20220121135632.136976-1-houtao1@huawei.com/


Hou Tao (2):
  selftests/bpf: use raw_tp program for atomic test
  arm64, bpf: support more atomic operations

 arch/arm64/include/asm/insn.h                 |  45 +++-
 arch/arm64/lib/insn.c                         | 155 +++++++++++--
 arch/arm64/net/bpf_jit.h                      |  43 +++-
 arch/arm64/net/bpf_jit_comp.c                 | 216 ++++++++++++++----
 .../selftests/bpf/prog_tests/atomics.c        | 121 +++-------
 tools/testing/selftests/bpf/progs/atomics.c   |  28 +--
 6 files changed, 444 insertions(+), 164 deletions(-)

-- 
2.27.0

