Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F14E50D2BF
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 17:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbiDXPht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 11:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240452AbiDXPbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 11:31:24 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4F6170E3F;
        Sun, 24 Apr 2022 08:28:23 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KmX615WTxzGp53;
        Sun, 24 Apr 2022 23:25:45 +0800 (CST)
Received: from huawei.com (10.67.174.197) by kwepemi500013.china.huawei.com
 (7.221.188.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sun, 24 Apr
 2022 23:28:19 +0800
From:   Xu Kuohai <xukuohai@huawei.com>
To:     <bpf@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        Mark Brown <broonie@kernel.org>,
        Delyan Kratunov <delyank@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: [PATCH bpf-next v3 4/7] bpf, arm64: Impelment bpf_arch_text_poke() for arm64
Date:   Sun, 24 Apr 2022 11:40:25 -0400
Message-ID: <20220424154028.1698685-5-xukuohai@huawei.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220424154028.1698685-1-xukuohai@huawei.com>
References: <20220424154028.1698685-1-xukuohai@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.197]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Impelment bpf_arch_text_poke() for arm64, so bpf trampoline code can use
it to replace nop with jump, or replace jump with nop.

Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 arch/arm64/net/bpf_jit_comp.c | 63 +++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 8ab4035dea27..3f9bdfec54c4 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -9,6 +9,7 @@
 
 #include <linux/bitfield.h>
 #include <linux/bpf.h>
+#include <linux/memory.h>
 #include <linux/filter.h>
 #include <linux/printk.h>
 #include <linux/slab.h>
@@ -18,6 +19,7 @@
 #include <asm/cacheflush.h>
 #include <asm/debug-monitors.h>
 #include <asm/insn.h>
+#include <asm/patching.h>
 #include <asm/set_memory.h>
 
 #include "bpf_jit.h"
@@ -1529,3 +1531,64 @@ void bpf_jit_free_exec(void *addr)
 {
 	return vfree(addr);
 }
+
+static int gen_branch_or_nop(enum aarch64_insn_branch_type type, void *ip,
+			     void *addr, u32 *insn)
+{
+	if (!addr)
+		*insn = aarch64_insn_gen_nop();
+	else
+		*insn = aarch64_insn_gen_branch_imm((unsigned long)ip,
+						    (unsigned long)addr,
+						    type);
+
+	return *insn != AARCH64_BREAK_FAULT ? 0 : -EFAULT;
+}
+
+int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type poke_type,
+		       void *old_addr, void *new_addr)
+{
+	int ret;
+	u32 old_insn;
+	u32 new_insn;
+	u32 replaced;
+	enum aarch64_insn_branch_type branch_type;
+
+	if (!is_bpf_text_address((long)ip))
+		/* Only poking bpf text is supported. Since kernel function
+		 * entry is set up by ftrace, we reply on ftrace to poke kernel
+		 * functions. For kernel funcitons, bpf_arch_text_poke() is only
+		 * called after a failed poke with ftrace. In this case, there
+		 * is probably something wrong with fentry, so there is nothing
+		 * we can do here. See register_fentry, unregister_fentry and
+		 * modify_fentry for details.
+		 */
+		return -EINVAL;
+
+	if (poke_type == BPF_MOD_CALL)
+		branch_type = AARCH64_INSN_BRANCH_LINK;
+	else
+		branch_type = AARCH64_INSN_BRANCH_NOLINK;
+
+	if (gen_branch_or_nop(branch_type, ip, old_addr, &old_insn) < 0)
+		return -EFAULT;
+
+	if (gen_branch_or_nop(branch_type, ip, new_addr, &new_insn) < 0)
+		return -EFAULT;
+
+	mutex_lock(&text_mutex);
+	if (aarch64_insn_read(ip, &replaced)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (replaced != old_insn) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	ret = aarch64_insn_patch_text_nosync((void *)ip, new_insn);
+out:
+	mutex_unlock(&text_mutex);
+	return ret;
+}
-- 
2.30.2

