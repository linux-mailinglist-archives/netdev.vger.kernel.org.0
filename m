Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28EBF4D2EDD
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 13:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbiCIMPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 07:15:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbiCIMPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 07:15:52 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663F6108578;
        Wed,  9 Mar 2022 04:14:53 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KD9xP51dJzbcG8;
        Wed,  9 Mar 2022 20:10:01 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 9 Mar
 2022 20:14:50 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        KP Singh <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next 2/4] bpf: Introduce bpf_int_jit_abort()
Date:   Wed, 9 Mar 2022 20:33:19 +0800
Message-ID: <20220309123321.2400262-3-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220309123321.2400262-1-houtao1@huawei.com>
References: <20220309123321.2400262-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

It will be used to do cleanup for subprog which has been jited in first
pass but extra pass has not been done. The scenario is possible when
extra pass for subprog in the middle fails. The failure may lead to
oops due to inconsistent status for pack allocator (e.g. ro_hdr->size
and use_bpf_prog_pack) and memory leak in aux->jit_data.

For x86-64, bpf_int_jit_abort() will free allocated memories saved in
aux->jit_data and fall back to interpreter mode to bypass the calling
of bpf_jit_binary_pack_free() in bpf_jit_free().

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 arch/x86/net/bpf_jit_comp.c | 24 ++++++++++++++++++++++++
 include/linux/filter.h      |  1 +
 kernel/bpf/core.c           |  9 +++++++++
 kernel/bpf/verifier.c       |  3 +++
 4 files changed, 37 insertions(+)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index ec3f00be2ac5..49bc0ddd55ae 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -2244,6 +2244,30 @@ struct x64_jit_data {
 	struct jit_context ctx;
 };
 
+void bpf_int_jit_abort(struct bpf_prog *prog)
+{
+	struct x64_jit_data *jit_data = prog->aux->jit_data;
+	struct bpf_binary_header *header, *rw_header;
+
+	if (!jit_data)
+		return;
+
+	prog->bpf_func = NULL;
+	prog->jited = 0;
+	prog->jited_len = 0;
+
+	header = jit_data->header;
+	rw_header = jit_data->rw_header;
+	bpf_arch_text_copy(&header->size, &rw_header->size,
+			   sizeof(rw_header->size));
+	bpf_jit_binary_pack_free(header, rw_header);
+
+	kvfree(jit_data->addrs);
+	kfree(jit_data);
+
+	prog->aux->jit_data = NULL;
+}
+
 #define MAX_PASSES 20
 #define PADDING_PASSES (MAX_PASSES - 5)
 
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 9bf26307247f..f3a913229edd 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -945,6 +945,7 @@ u64 __bpf_call_base(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
 	 (void *)__bpf_call_base)
 
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog);
+void bpf_int_jit_abort(struct bpf_prog *prog);
 void bpf_jit_compile(struct bpf_prog *prog);
 bool bpf_jit_needs_zext(void);
 bool bpf_jit_supports_kfunc_call(void);
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index ab630f773ec1..a1841e11524c 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2636,6 +2636,15 @@ struct bpf_prog * __weak bpf_int_jit_compile(struct bpf_prog *prog)
 	return prog;
 }
 
+/*
+ * If arch JIT uses aux->jit_data to save temporary allocated status and
+ * supports subprog, it needs to override the function to free allocated
+ * memories and fall back to interpreter mode for passed prog.
+ */
+void __weak bpf_int_jit_abort(struct bpf_prog *prog)
+{
+}
+
 /* Stub for JITs that support eBPF. All cBPF code gets transformed into
  * eBPF by the kernel and is later compiled by bpf_int_jit_compile().
  */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e34264200e09..885e515cf83f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13086,6 +13086,9 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 		if (tmp != func[i] || func[i]->bpf_func != old_bpf_func) {
 			verbose(env, "JIT doesn't support bpf-to-bpf calls\n");
 			err = -ENOTSUPP;
+			/* Abort extra pass for the remaining subprogs */
+			while (++i < env->subprog_cnt)
+				bpf_int_jit_abort(func[i]);
 			goto out_free;
 		}
 		cond_resched();
-- 
2.29.2

