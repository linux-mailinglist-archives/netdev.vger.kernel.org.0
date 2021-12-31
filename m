Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBF448246B
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 15:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhLaOzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 09:55:06 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:31064 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhLaOzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 09:55:05 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JQSlL3TmQz1DK4p;
        Fri, 31 Dec 2021 22:51:42 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Fri, 31 Dec
 2021 22:55:02 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Will Deacon <will@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <houtao1@huawei.com>
Subject: [PATCH] bpf, arm64: use emit_addr_mov_i64() for BPF_PSEUDO_FUNC
Date:   Fri, 31 Dec 2021 23:10:18 +0800
Message-ID: <20211231151018.3781550-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following error is reported when running "./test_progs -t for_each"
under arm64:

    bpf_jit: multi-func JIT bug 58 != 56
    ......
    JIT doesn't support bpf-to-bpf calls

The root cause is the size of BPF_PSEUDO_FUNC instruction increases
from 2 to 3 after the address of called bpf-function is settled and
there are two bpf-to-bpf calls in test_pkt_access. The generated
instructions are shown below:

>before callback_fn is jited, its addr is 0x1-00000001
0x48:  21 00 C0 D2    movz x1, #0x1, lsl #32
0x4c:  21 00 80 F2    movk x1, #0x1

>after callback_fn is jited, its addr is 0xfffffe0017f2fb84
0x48:  E1 3F C0 92    movn x1, #0x1ff, lsl #32
0x4c:  41 FE A2 F2    movk x1, #0x17f2, lsl #16
0x50:  81 70 9F F2    movk x1, #0xfb84

Fixing it by using emit_addr_mov_i64() for BPF_PSEUDO_FUNC, so
the size of jited image will not change.

Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 arch/arm64/net/bpf_jit_comp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index f81e71f6e8bf..acfc3d4d712c 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -792,7 +792,10 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		u64 imm64;
 
 		imm64 = (u64)insn1.imm << 32 | (u32)imm;
-		emit_a64_mov_i64(dst, imm64, ctx);
+		if (bpf_pseudo_func(insn))
+			emit_addr_mov_i64(dst, imm64, ctx);
+		else
+			emit_a64_mov_i64(dst, imm64, ctx);
 
 		return 1;
 	}
-- 
2.27.0

