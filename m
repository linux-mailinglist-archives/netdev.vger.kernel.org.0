Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A504B998A
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 08:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235800AbiBQHEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 02:04:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbiBQHEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 02:04:09 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE54189AA1;
        Wed, 16 Feb 2022 23:03:56 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Jzm0M2m77zZfgK;
        Thu, 17 Feb 2022 14:59:31 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 17 Feb
 2022 15:03:53 +0800
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
Subject: [PATCH bpf-next v4 1/4] arm64: move AARCH64_BREAK_FAULT into insn-def.h
Date:   Thu, 17 Feb 2022 15:22:29 +0800
Message-ID: <20220217072232.1186625-2-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220217072232.1186625-1-houtao1@huawei.com>
References: <20220217072232.1186625-1-houtao1@huawei.com>
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

If CONFIG_ARM64_LSE_ATOMICS is off, encoders for LSE-related instructions
can return AARCH64_BREAK_FAULT directly in insn.h. In order to access
AARCH64_BREAK_FAULT in insn.h, we can not include debug-monitors.h in
insn.h, because debug-monitors.h has already depends on insn.h, so just
move AARCH64_BREAK_FAULT into insn-def.h.

It will be used by the following patch to eliminate unnecessary LSE-related
encoders when CONFIG_ARM64_LSE_ATOMICS is off.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 arch/arm64/include/asm/debug-monitors.h | 12 ------------
 arch/arm64/include/asm/insn-def.h       | 14 ++++++++++++++
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/debug-monitors.h b/arch/arm64/include/asm/debug-monitors.h
index 657c921fd784..00c291067e57 100644
--- a/arch/arm64/include/asm/debug-monitors.h
+++ b/arch/arm64/include/asm/debug-monitors.h
@@ -34,18 +34,6 @@
  */
 #define BREAK_INSTR_SIZE		AARCH64_INSN_SIZE
 
-/*
- * BRK instruction encoding
- * The #imm16 value should be placed at bits[20:5] within BRK ins
- */
-#define AARCH64_BREAK_MON	0xd4200000
-
-/*
- * BRK instruction for provoking a fault on purpose
- * Unlike kgdb, #imm16 value with unallocated handler is used for faulting.
- */
-#define AARCH64_BREAK_FAULT	(AARCH64_BREAK_MON | (FAULT_BRK_IMM << 5))
-
 #define AARCH64_BREAK_KGDB_DYN_DBG	\
 	(AARCH64_BREAK_MON | (KGDB_DYN_DBG_BRK_IMM << 5))
 
diff --git a/arch/arm64/include/asm/insn-def.h b/arch/arm64/include/asm/insn-def.h
index 2c075f615c6a..1a7d0d483698 100644
--- a/arch/arm64/include/asm/insn-def.h
+++ b/arch/arm64/include/asm/insn-def.h
@@ -3,7 +3,21 @@
 #ifndef __ASM_INSN_DEF_H
 #define __ASM_INSN_DEF_H
 
+#include <asm/brk-imm.h>
+
 /* A64 instructions are always 32 bits. */
 #define	AARCH64_INSN_SIZE		4
 
+/*
+ * BRK instruction encoding
+ * The #imm16 value should be placed at bits[20:5] within BRK ins
+ */
+#define AARCH64_BREAK_MON	0xd4200000
+
+/*
+ * BRK instruction for provoking a fault on purpose
+ * Unlike kgdb, #imm16 value with unallocated handler is used for faulting.
+ */
+#define AARCH64_BREAK_FAULT	(AARCH64_BREAK_MON | (FAULT_BRK_IMM << 5))
+
 #endif /* __ASM_INSN_DEF_H */
-- 
2.29.2

