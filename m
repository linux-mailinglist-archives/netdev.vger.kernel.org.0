Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066184B9990
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 08:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbiBQHEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 02:04:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235840AbiBQHEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 02:04:10 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A792218B15C;
        Wed, 16 Feb 2022 23:03:56 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Jzm481yJyzbncL;
        Thu, 17 Feb 2022 15:02:48 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 17 Feb
 2022 15:03:54 +0800
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
Subject: [PATCH bpf-next v4 2/4] arm64: insn: add encoders for atomic operations
Date:   Thu, 17 Feb 2022 15:22:30 +0800
Message-ID: <20220217072232.1186625-3-houtao1@huawei.com>
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

It is a preparation patch for eBPF atomic supports under arm64. eBPF
needs support atomic[64]_fetch_add, atomic[64]_[fetch_]{and,or,xor} and
atomic[64]_{xchg|cmpxchg}. The ordering semantics of eBPF atomics are
the same with the implementations in linux kernel.

Add three helpers to support LDCLR/LDEOR/LDSET/SWP, CAS and DMB
instructions. STADD/STCLR/STEOR/STSET are simply encoded as aliases for
LDADD/LDCLR/LDEOR/LDSET with XZR as the destination register, so no extra
helper is added. atomic_fetch_add() and other atomic ops needs support for
STLXR instruction, so extend enum aarch64_insn_ldst_type to do that.

LDADD/LDEOR/LDSET/SWP and CAS instructions are only available when LSE
atomics is enabled, so just return AARCH64_BREAK_FAULT directly in
these newly-added helpers if CONFIG_ARM64_LSE_ATOMICS is disabled.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 arch/arm64/include/asm/insn.h |  80 +++++++++++++--
 arch/arm64/lib/insn.c         | 185 +++++++++++++++++++++++++++++++---
 arch/arm64/net/bpf_jit.h      |  11 +-
 3 files changed, 253 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index 6b776c8667b2..0b6b31307e68 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -205,7 +205,9 @@ enum aarch64_insn_ldst_type {
 	AARCH64_INSN_LDST_LOAD_PAIR_POST_INDEX,
 	AARCH64_INSN_LDST_STORE_PAIR_POST_INDEX,
 	AARCH64_INSN_LDST_LOAD_EX,
+	AARCH64_INSN_LDST_LOAD_ACQ_EX,
 	AARCH64_INSN_LDST_STORE_EX,
+	AARCH64_INSN_LDST_STORE_REL_EX,
 };
 
 enum aarch64_insn_adsb_type {
@@ -280,6 +282,36 @@ enum aarch64_insn_adr_type {
 	AARCH64_INSN_ADR_TYPE_ADR,
 };
 
+enum aarch64_insn_mem_atomic_op {
+	AARCH64_INSN_MEM_ATOMIC_ADD,
+	AARCH64_INSN_MEM_ATOMIC_CLR,
+	AARCH64_INSN_MEM_ATOMIC_EOR,
+	AARCH64_INSN_MEM_ATOMIC_SET,
+	AARCH64_INSN_MEM_ATOMIC_SWP,
+};
+
+enum aarch64_insn_mem_order_type {
+	AARCH64_INSN_MEM_ORDER_NONE,
+	AARCH64_INSN_MEM_ORDER_ACQ,
+	AARCH64_INSN_MEM_ORDER_REL,
+	AARCH64_INSN_MEM_ORDER_ACQREL,
+};
+
+enum aarch64_insn_mb_type {
+	AARCH64_INSN_MB_SY,
+	AARCH64_INSN_MB_ST,
+	AARCH64_INSN_MB_LD,
+	AARCH64_INSN_MB_ISH,
+	AARCH64_INSN_MB_ISHST,
+	AARCH64_INSN_MB_ISHLD,
+	AARCH64_INSN_MB_NSH,
+	AARCH64_INSN_MB_NSHST,
+	AARCH64_INSN_MB_NSHLD,
+	AARCH64_INSN_MB_OSH,
+	AARCH64_INSN_MB_OSHST,
+	AARCH64_INSN_MB_OSHLD,
+};
+
 #define	__AARCH64_INSN_FUNCS(abbr, mask, val)				\
 static __always_inline bool aarch64_insn_is_##abbr(u32 code)		\
 {									\
@@ -303,6 +335,11 @@ __AARCH64_INSN_FUNCS(store_post,	0x3FE00C00, 0x38000400)
 __AARCH64_INSN_FUNCS(load_post,	0x3FE00C00, 0x38400400)
 __AARCH64_INSN_FUNCS(str_reg,	0x3FE0EC00, 0x38206800)
 __AARCH64_INSN_FUNCS(ldadd,	0x3F20FC00, 0x38200000)
+__AARCH64_INSN_FUNCS(ldclr,	0x3F20FC00, 0x38201000)
+__AARCH64_INSN_FUNCS(ldeor,	0x3F20FC00, 0x38202000)
+__AARCH64_INSN_FUNCS(ldset,	0x3F20FC00, 0x38203000)
+__AARCH64_INSN_FUNCS(swp,	0x3F20FC00, 0x38208000)
+__AARCH64_INSN_FUNCS(cas,	0x3FA07C00, 0x08A07C00)
 __AARCH64_INSN_FUNCS(ldr_reg,	0x3FE0EC00, 0x38606800)
 __AARCH64_INSN_FUNCS(ldr_lit,	0xBF000000, 0x18000000)
 __AARCH64_INSN_FUNCS(ldrsw_lit,	0xFF000000, 0x98000000)
@@ -474,13 +511,6 @@ u32 aarch64_insn_gen_load_store_ex(enum aarch64_insn_register reg,
 				   enum aarch64_insn_register state,
 				   enum aarch64_insn_size_type size,
 				   enum aarch64_insn_ldst_type type);
-u32 aarch64_insn_gen_ldadd(enum aarch64_insn_register result,
-			   enum aarch64_insn_register address,
-			   enum aarch64_insn_register value,
-			   enum aarch64_insn_size_type size);
-u32 aarch64_insn_gen_stadd(enum aarch64_insn_register address,
-			   enum aarch64_insn_register value,
-			   enum aarch64_insn_size_type size);
 u32 aarch64_insn_gen_add_sub_imm(enum aarch64_insn_register dst,
 				 enum aarch64_insn_register src,
 				 int imm, enum aarch64_insn_variant variant,
@@ -541,6 +571,42 @@ u32 aarch64_insn_gen_prefetch(enum aarch64_insn_register base,
 			      enum aarch64_insn_prfm_type type,
 			      enum aarch64_insn_prfm_target target,
 			      enum aarch64_insn_prfm_policy policy);
+#ifdef CONFIG_ARM64_LSE_ATOMICS
+u32 aarch64_insn_gen_atomic_ld_op(enum aarch64_insn_register result,
+				  enum aarch64_insn_register address,
+				  enum aarch64_insn_register value,
+				  enum aarch64_insn_size_type size,
+				  enum aarch64_insn_mem_atomic_op op,
+				  enum aarch64_insn_mem_order_type order);
+u32 aarch64_insn_gen_cas(enum aarch64_insn_register result,
+			 enum aarch64_insn_register address,
+			 enum aarch64_insn_register value,
+			 enum aarch64_insn_size_type size,
+			 enum aarch64_insn_mem_order_type order);
+#else
+static inline
+u32 aarch64_insn_gen_atomic_ld_op(enum aarch64_insn_register result,
+				  enum aarch64_insn_register address,
+				  enum aarch64_insn_register value,
+				  enum aarch64_insn_size_type size,
+				  enum aarch64_insn_mem_atomic_op op,
+				  enum aarch64_insn_mem_order_type order)
+{
+	return AARCH64_BREAK_FAULT;
+}
+
+static inline
+u32 aarch64_insn_gen_cas(enum aarch64_insn_register result,
+			 enum aarch64_insn_register address,
+			 enum aarch64_insn_register value,
+			 enum aarch64_insn_size_type size,
+			 enum aarch64_insn_mem_order_type order)
+{
+	return AARCH64_BREAK_FAULT;
+}
+#endif
+u32 aarch64_insn_gen_dmb(enum aarch64_insn_mb_type type);
+
 s32 aarch64_get_branch_offset(u32 insn);
 u32 aarch64_set_branch_offset(u32 insn, s32 offset);
 
diff --git a/arch/arm64/lib/insn.c b/arch/arm64/lib/insn.c
index fccfe363e567..bd119fde8504 100644
--- a/arch/arm64/lib/insn.c
+++ b/arch/arm64/lib/insn.c
@@ -578,10 +578,16 @@ u32 aarch64_insn_gen_load_store_ex(enum aarch64_insn_register reg,
 
 	switch (type) {
 	case AARCH64_INSN_LDST_LOAD_EX:
+	case AARCH64_INSN_LDST_LOAD_ACQ_EX:
 		insn = aarch64_insn_get_load_ex_value();
+		if (type == AARCH64_INSN_LDST_LOAD_ACQ_EX)
+			insn |= BIT(15);
 		break;
 	case AARCH64_INSN_LDST_STORE_EX:
+	case AARCH64_INSN_LDST_STORE_REL_EX:
 		insn = aarch64_insn_get_store_ex_value();
+		if (type == AARCH64_INSN_LDST_STORE_REL_EX)
+			insn |= BIT(15);
 		break;
 	default:
 		pr_err("%s: unknown load/store exclusive encoding %d\n", __func__, type);
@@ -603,12 +609,65 @@ u32 aarch64_insn_gen_load_store_ex(enum aarch64_insn_register reg,
 					    state);
 }
 
-u32 aarch64_insn_gen_ldadd(enum aarch64_insn_register result,
-			   enum aarch64_insn_register address,
-			   enum aarch64_insn_register value,
-			   enum aarch64_insn_size_type size)
+#ifdef CONFIG_ARM64_LSE_ATOMICS
+static u32 aarch64_insn_encode_ldst_order(enum aarch64_insn_mem_order_type type,
+					  u32 insn)
 {
-	u32 insn = aarch64_insn_get_ldadd_value();
+	u32 order;
+
+	switch (type) {
+	case AARCH64_INSN_MEM_ORDER_NONE:
+		order = 0;
+		break;
+	case AARCH64_INSN_MEM_ORDER_ACQ:
+		order = 2;
+		break;
+	case AARCH64_INSN_MEM_ORDER_REL:
+		order = 1;
+		break;
+	case AARCH64_INSN_MEM_ORDER_ACQREL:
+		order = 3;
+		break;
+	default:
+		pr_err("%s: unknown mem order %d\n", __func__, type);
+		return AARCH64_BREAK_FAULT;
+	}
+
+	insn &= ~GENMASK(23, 22);
+	insn |= order << 22;
+
+	return insn;
+}
+
+u32 aarch64_insn_gen_atomic_ld_op(enum aarch64_insn_register result,
+				  enum aarch64_insn_register address,
+				  enum aarch64_insn_register value,
+				  enum aarch64_insn_size_type size,
+				  enum aarch64_insn_mem_atomic_op op,
+				  enum aarch64_insn_mem_order_type order)
+{
+	u32 insn;
+
+	switch (op) {
+	case AARCH64_INSN_MEM_ATOMIC_ADD:
+		insn = aarch64_insn_get_ldadd_value();
+		break;
+	case AARCH64_INSN_MEM_ATOMIC_CLR:
+		insn = aarch64_insn_get_ldclr_value();
+		break;
+	case AARCH64_INSN_MEM_ATOMIC_EOR:
+		insn = aarch64_insn_get_ldeor_value();
+		break;
+	case AARCH64_INSN_MEM_ATOMIC_SET:
+		insn = aarch64_insn_get_ldset_value();
+		break;
+	case AARCH64_INSN_MEM_ATOMIC_SWP:
+		insn = aarch64_insn_get_swp_value();
+		break;
+	default:
+		pr_err("%s: unimplemented mem atomic op %d\n", __func__, op);
+		return AARCH64_BREAK_FAULT;
+	}
 
 	switch (size) {
 	case AARCH64_INSN_SIZE_32:
@@ -621,6 +680,8 @@ u32 aarch64_insn_gen_ldadd(enum aarch64_insn_register result,
 
 	insn = aarch64_insn_encode_ldst_size(size, insn);
 
+	insn = aarch64_insn_encode_ldst_order(order, insn);
+
 	insn = aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RT, insn,
 					    result);
 
@@ -631,17 +692,68 @@ u32 aarch64_insn_gen_ldadd(enum aarch64_insn_register result,
 					    value);
 }
 
-u32 aarch64_insn_gen_stadd(enum aarch64_insn_register address,
-			   enum aarch64_insn_register value,
-			   enum aarch64_insn_size_type size)
+static u32 aarch64_insn_encode_cas_order(enum aarch64_insn_mem_order_type type,
+					 u32 insn)
 {
-	/*
-	 * STADD is simply encoded as an alias for LDADD with XZR as
-	 * the destination register.
-	 */
-	return aarch64_insn_gen_ldadd(AARCH64_INSN_REG_ZR, address,
-				      value, size);
+	u32 order;
+
+	switch (type) {
+	case AARCH64_INSN_MEM_ORDER_NONE:
+		order = 0;
+		break;
+	case AARCH64_INSN_MEM_ORDER_ACQ:
+		order = BIT(22);
+		break;
+	case AARCH64_INSN_MEM_ORDER_REL:
+		order = BIT(15);
+		break;
+	case AARCH64_INSN_MEM_ORDER_ACQREL:
+		order = BIT(15) | BIT(22);
+		break;
+	default:
+		pr_err("%s: unknown mem order %d\n", __func__, type);
+		return AARCH64_BREAK_FAULT;
+	}
+
+	insn &= ~(BIT(15) | BIT(22));
+	insn |= order;
+
+	return insn;
+}
+
+u32 aarch64_insn_gen_cas(enum aarch64_insn_register result,
+			 enum aarch64_insn_register address,
+			 enum aarch64_insn_register value,
+			 enum aarch64_insn_size_type size,
+			 enum aarch64_insn_mem_order_type order)
+{
+	u32 insn;
+
+	switch (size) {
+	case AARCH64_INSN_SIZE_32:
+	case AARCH64_INSN_SIZE_64:
+		break;
+	default:
+		pr_err("%s: unimplemented size encoding %d\n", __func__, size);
+		return AARCH64_BREAK_FAULT;
+	}
+
+	insn = aarch64_insn_get_cas_value();
+
+	insn = aarch64_insn_encode_ldst_size(size, insn);
+
+	insn = aarch64_insn_encode_cas_order(order, insn);
+
+	insn = aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RT, insn,
+					    result);
+
+	insn = aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RN, insn,
+					    address);
+
+	return aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RS, insn,
+					    value);
 }
+#endif
 
 static u32 aarch64_insn_encode_prfm_imm(enum aarch64_insn_prfm_type type,
 					enum aarch64_insn_prfm_target target,
@@ -1456,3 +1568,48 @@ u32 aarch64_insn_gen_extr(enum aarch64_insn_variant variant,
 	insn = aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RN, insn, Rn);
 	return aarch64_insn_encode_register(AARCH64_INSN_REGTYPE_RM, insn, Rm);
 }
+
+u32 aarch64_insn_gen_dmb(enum aarch64_insn_mb_type type)
+{
+	u32 opt;
+	u32 insn;
+
+	switch (type) {
+	case AARCH64_INSN_MB_SY:
+		opt = 0xf;
+		break;
+	case AARCH64_INSN_MB_ST:
+		opt = 0xe;
+		break;
+	case AARCH64_INSN_MB_LD:
+		opt = 0xd;
+		break;
+	case AARCH64_INSN_MB_ISH:
+		opt = 0xb;
+		break;
+	case AARCH64_INSN_MB_ISHST:
+		opt = 0xa;
+		break;
+	case AARCH64_INSN_MB_ISHLD:
+		opt = 0x9;
+		break;
+	case AARCH64_INSN_MB_NSH:
+		opt = 0x7;
+		break;
+	case AARCH64_INSN_MB_NSHST:
+		opt = 0x6;
+		break;
+	case AARCH64_INSN_MB_NSHLD:
+		opt = 0x5;
+		break;
+	default:
+		pr_err("%s: unknown dmb type %d\n", __func__, type);
+		return AARCH64_BREAK_FAULT;
+	}
+
+	insn = aarch64_insn_get_dmb_value();
+	insn &= ~GENMASK(11, 8);
+	insn |= (opt << 8);
+
+	return insn;
+}
diff --git a/arch/arm64/net/bpf_jit.h b/arch/arm64/net/bpf_jit.h
index cc0cf0f5c7c3..9d9250c7cc72 100644
--- a/arch/arm64/net/bpf_jit.h
+++ b/arch/arm64/net/bpf_jit.h
@@ -89,9 +89,16 @@
 #define A64_STXR(sf, Rt, Rn, Rs) \
 	A64_LSX(sf, Rt, Rn, Rs, STORE_EX)
 
-/* LSE atomics */
+/*
+ * LSE atomics
+ *
+ * STADD is simply encoded as an alias for LDADD with XZR as
+ * the destination register.
+ */
 #define A64_STADD(sf, Rn, Rs) \
-	aarch64_insn_gen_stadd(Rn, Rs, A64_SIZE(sf))
+	aarch64_insn_gen_atomic_ld_op(A64_ZR, Rn, Rs, \
+		A64_SIZE(sf), AARCH64_INSN_MEM_ATOMIC_ADD, \
+		AARCH64_INSN_MEM_ORDER_NONE)
 
 /* Add/subtract (immediate) */
 #define A64_ADDSUB_IMM(sf, Rd, Rn, imm12, type) \
-- 
2.29.2

