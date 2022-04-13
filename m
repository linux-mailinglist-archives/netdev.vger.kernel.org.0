Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F43B4FEE9E
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 07:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbiDMFkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 01:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbiDMFkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 01:40:01 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCC731518;
        Tue, 12 Apr 2022 22:37:40 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KdWXG0f14zgYYm;
        Wed, 13 Apr 2022 13:35:42 +0800 (CST)
Received: from huawei.com (10.67.174.197) by kwepemi500013.china.huawei.com
 (7.221.188.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 13 Apr
 2022 13:37:30 +0800
From:   Xu Kuohai <xukuohai@huawei.com>
To:     <bpf@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
CC:     Will Deacon <will@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, <x86@kernel.org>,
        <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Peter Collingbourne <pcc@google.com>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Steven Price <steven.price@arm.com>,
        Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Delyan Kratunov <delyank@fb.com>
Subject: [PATCH bpf-next 2/5] bpf: Move is_valid_bpf_tramp_flags() to the public trampoline code
Date:   Wed, 13 Apr 2022 01:49:56 -0400
Message-ID: <20220413054959.1053668-3-xukuohai@huawei.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220413054959.1053668-1-xukuohai@huawei.com>
References: <20220413054959.1053668-1-xukuohai@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.197]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

is_valid_bpf_tramp_flags() is not relevant to architecture, so move it
to the public trampoline code.

Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
---
 arch/x86/net/bpf_jit_comp.c | 20 --------------------
 include/linux/bpf.h         |  5 +++++
 kernel/bpf/bpf_struct_ops.c |  4 ++--
 kernel/bpf/trampoline.c     | 36 +++++++++++++++++++++++++++++++++---
 4 files changed, 40 insertions(+), 25 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 8fe35ed11fd6..774f05f92737 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1900,23 +1900,6 @@ static int invoke_bpf_mod_ret(const struct btf_func_model *m, u8 **pprog,
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
@@ -1995,9 +1978,6 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	if (nr_args > 6)
 		return -ENOTSUPP;
 
-	if (!is_valid_bpf_tramp_flags(flags))
-		return -EINVAL;
-
 	/* Generated trampoline stack layout:
 	 *
 	 * RBP + 8         [ return address  ]
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index bdb5298735ce..c650b7fe87ee 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -706,6 +706,11 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *tr, void *image, void *i
 				const struct btf_func_model *m, u32 flags,
 				struct bpf_tramp_progs *tprogs,
 				void *orig_call);
+int bpf_prepare_trampoline(struct bpf_tramp_image *tr, void *image, void *image_end,
+			   const struct btf_func_model *m, u32 flags,
+			   struct bpf_tramp_progs *tprogs,
+			   void *orig_call);
+
 /* these two functions are called from generated trampoline */
 u64 notrace __bpf_prog_enter(struct bpf_prog *prog);
 void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start);
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 21069dbe9138..5f9bdd530df2 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -325,8 +325,8 @@ int bpf_struct_ops_prepare_trampoline(struct bpf_tramp_progs *tprogs,
 	tprogs[BPF_TRAMP_FENTRY].progs[0] = prog;
 	tprogs[BPF_TRAMP_FENTRY].nr_progs = 1;
 	flags = model->ret_size > 0 ? BPF_TRAMP_F_RET_FENTRY_RET : 0;
-	return arch_prepare_bpf_trampoline(NULL, image, image_end,
-					   model, flags, tprogs, NULL);
+	return bpf_prepare_trampoline(NULL, image, image_end, model, flags,
+				      tprogs, NULL);
 }
 
 static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index ada97751ae1b..6bd61f9cff7a 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -360,9 +360,9 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
 	if (ip_arg)
 		flags |= BPF_TRAMP_F_IP_ARG;
 
-	err = arch_prepare_bpf_trampoline(im, im->image, im->image + PAGE_SIZE,
-					  &tr->func.model, flags, tprogs,
-					  tr->func.addr);
+	err = bpf_prepare_trampoline(im, im->image, im->image + PAGE_SIZE,
+				     &tr->func.model, flags, tprogs,
+				     tr->func.addr);
 	if (err < 0)
 		goto out;
 
@@ -641,6 +641,36 @@ arch_prepare_bpf_trampoline(struct bpf_tramp_image *tr, void *image, void *image
 	return -ENOTSUPP;
 }
 
+static bool is_valid_bpf_tramp_flags(unsigned int flags)
+{
+	if ((flags & BPF_TRAMP_F_RESTORE_REGS) &&
+	    (flags & BPF_TRAMP_F_SKIP_FRAME))
+		return false;
+
+	/*
+	 * BPF_TRAMP_F_RET_FENTRY_RET is only used by bpf_struct_ops,
+	 * and it must be used alone.
+	 */
+	if ((flags & BPF_TRAMP_F_RET_FENTRY_RET) &&
+	    (flags & ~BPF_TRAMP_F_RET_FENTRY_RET))
+		return false;
+
+	return true;
+}
+
+int
+bpf_prepare_trampoline(struct bpf_tramp_image *tr, void *image, void *image_end,
+		       const struct btf_func_model *m, u32 flags,
+		       struct bpf_tramp_progs *tprogs,
+		       void *orig_call)
+{
+	if (!is_valid_bpf_tramp_flags(flags))
+		return -EINVAL;
+
+	return arch_prepare_bpf_trampoline(tr, image, image_end, m, flags,
+					   tprogs, orig_call);
+}
+
 static int __init init_trampolines(void)
 {
 	int i;
-- 
2.30.2

