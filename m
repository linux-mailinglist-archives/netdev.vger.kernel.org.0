Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8656F529A85
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239039AbiEQHIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240170AbiEQHIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:08:12 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3090547ADF;
        Tue, 17 May 2022 00:07:48 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4L2Ry66XbYzhZ94;
        Tue, 17 May 2022 15:07:10 +0800 (CST)
Received: from huawei.com (10.67.174.197) by kwepemi500013.china.huawei.com
 (7.221.188.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 17 May
 2022 15:07:44 +0800
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
Subject: [PATCH bpf-next v4 3/6] bpf: Move is_valid_bpf_tramp_flags() to the public trampoline code
Date:   Tue, 17 May 2022 03:18:35 -0400
Message-ID: <20220517071838.3366093-4-xukuohai@huawei.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220517071838.3366093-1-xukuohai@huawei.com>
References: <20220517071838.3366093-1-xukuohai@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.197]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

is_valid_bpf_tramp_flags() is not relevant to architecture, so move it
to the public trampoline code.

Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 arch/x86/net/bpf_jit_comp.c | 20 --------------------
 include/linux/bpf.h         |  6 ++++++
 kernel/bpf/bpf_struct_ops.c |  4 ++--
 kernel/bpf/trampoline.c     | 34 +++++++++++++++++++++++++++++++---
 4 files changed, 39 insertions(+), 25 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index a2b6d197c226..7698ef3b4821 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1922,23 +1922,6 @@ static int invoke_bpf_mod_ret(const struct btf_func_model *m, u8 **pprog,
 	return 0;
 }
 
-static bool is_valid_bpf_tramp_flags(unsigned int flags)
-{
-	if ((flags & BPF_TRAMP_F_RESTORE_REGS) &&
-	    (flags & BPF_TRAMP_F_SKIP_FRAME))
-		return false;
-
-	/*
-	 * BPF_TRAMP_F_RET_FENTRY_RET is only used by bpf_struct_ops,
-	 * and it must be used alone.
-	 */
-	if ((flags & BPF_TRAMP_F_RET_FENTRY_RET) &&
-	    (flags & ~BPF_TRAMP_F_RET_FENTRY_RET))
-		return false;
-
-	return true;
-}
-
 /* Example:
  * __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev);
  * its 'struct btf_func_model' will be nr_args=2
@@ -2017,9 +2000,6 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	if (nr_args > 6)
 		return -ENOTSUPP;
 
-	if (!is_valid_bpf_tramp_flags(flags))
-		return -EINVAL;
-
 	/* Generated trampoline stack layout:
 	 *
 	 * RBP + 8         [ return address  ]
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c107392b0ba7..5615f31b2a30 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -760,6 +760,12 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *tr, void *image, void *i
 				const struct btf_func_model *m, u32 flags,
 				struct bpf_tramp_links *tlinks,
 				void *orig_call);
+int bpf_prepare_trampoline(struct bpf_tramp_image *tr, void *image, void *image_end,
+			   const struct btf_func_model *m, u32 flags,
+			   struct bpf_tramp_links *tlinks,
+			   void *orig_call);
+
+
 /* these two functions are called from generated trampoline */
 u64 notrace __bpf_prog_enter(struct bpf_prog *prog, struct bpf_tramp_run_ctx *run_ctx);
 void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start, struct bpf_tramp_run_ctx *run_ctx);
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index d9a3c9207240..4d81675e0dd5 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -342,8 +342,8 @@ int bpf_struct_ops_prepare_trampoline(struct bpf_tramp_links *tlinks,
 	tlinks[BPF_TRAMP_FENTRY].links[0] = link;
 	tlinks[BPF_TRAMP_FENTRY].nr_links = 1;
 	flags = model->ret_size > 0 ? BPF_TRAMP_F_RET_FENTRY_RET : 0;
-	return arch_prepare_bpf_trampoline(NULL, image, image_end,
-					   model, flags, tlinks, NULL);
+	return bpf_prepare_trampoline(NULL, image, image_end, model, flags,
+				      tlinks, NULL);
 }
 
 static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 93c7675f0c9e..bef786fe307d 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -363,9 +363,9 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
 	if (ip_arg)
 		flags |= BPF_TRAMP_F_IP_ARG;
 
-	err = arch_prepare_bpf_trampoline(im, im->image, im->image + PAGE_SIZE,
-					  &tr->func.model, flags, tlinks,
-					  tr->func.addr);
+	err = bpf_prepare_trampoline(im, im->image, im->image + PAGE_SIZE,
+				     &tr->func.model, flags, tlinks,
+				     tr->func.addr);
 	if (err < 0)
 		goto out;
 
@@ -671,6 +671,34 @@ arch_prepare_bpf_trampoline(struct bpf_tramp_image *tr, void *image, void *image
 	return -ENOTSUPP;
 }
 
+static bool is_valid_bpf_tramp_flags(unsigned int flags)
+{
+	if ((flags & BPF_TRAMP_F_RESTORE_REGS) &&
+	    (flags & BPF_TRAMP_F_SKIP_FRAME))
+		return false;
+
+	/* BPF_TRAMP_F_RET_FENTRY_RET is only used by bpf_struct_ops,
+	 * and it must be used alone.
+	 */
+	if ((flags & BPF_TRAMP_F_RET_FENTRY_RET) &&
+	    (flags & ~BPF_TRAMP_F_RET_FENTRY_RET))
+		return false;
+
+	return true;
+}
+
+int bpf_prepare_trampoline(struct bpf_tramp_image *tr, void *image,
+			   void *image_end, const struct btf_func_model *m,
+			   u32 flags, struct bpf_tramp_links *tlinks,
+			   void *orig_call)
+{
+	if (!is_valid_bpf_tramp_flags(flags))
+		return -EINVAL;
+
+	return arch_prepare_bpf_trampoline(tr, image, image_end, m, flags,
+					   tlinks, orig_call);
+}
+
 static int __init init_trampolines(void)
 {
 	int i;
-- 
2.30.2

