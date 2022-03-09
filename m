Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 749D54D2EDE
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 13:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbiCIMPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 07:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232720AbiCIMPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 07:15:53 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAB610E04D;
        Wed,  9 Mar 2022 04:14:53 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KD9xQ2bG0zbcGD;
        Wed,  9 Mar 2022 20:10:02 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 9 Mar
 2022 20:14:51 +0800
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
Subject: [PATCH bpf-next 3/4] bpf: Fix net.core.bpf_jit_harden race
Date:   Wed, 9 Mar 2022 20:33:20 +0800
Message-ID: <20220309123321.2400262-4-houtao1@huawei.com>
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

It is the bpf_jit_harden counterpart to commit 60b58afc96c9 ("bpf: fix
net.core.bpf_jit_enable race"). bpf_jit_harden will be tested twice
for each subprog if there are subprogs in bpf program and constant
blinding may increase the length of program, so when running
"./test_progs -t subprogs" and toggling bpf_jit_harden between 0 and 2,
jit_subprogs may fail because constant blinding increases the length
of subprog instructions during extra passs.

So cache the value of bpf_jit_blinding_enabled() during program
allocation, and use the cached value during constant blinding, subprog
JITing and args tracking of tail call.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 include/linux/filter.h | 1 +
 kernel/bpf/core.c      | 3 ++-
 kernel/bpf/verifier.c  | 5 +++--
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index f3a913229edd..605c8456467b 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -566,6 +566,7 @@ struct bpf_prog {
 				gpl_compatible:1, /* Is filter GPL compatible? */
 				cb_access:1,	/* Is control block accessed? */
 				dst_needed:1,	/* Do we need dst entry? */
+				blinding_requested:1, /* needs constant blinding */
 				blinded:1,	/* Was blinded */
 				is_func:1,	/* program is a bpf function */
 				kprobe_override:1, /* Do we override a kprobe? */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index a1841e11524c..a4b5fb095261 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -105,6 +105,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
 	fp->aux = aux;
 	fp->aux->prog = fp;
 	fp->jit_requested = ebpf_jit_enabled();
+	fp->blinding_requested = bpf_jit_blinding_enabled(fp);
 
 	INIT_LIST_HEAD_RCU(&fp->aux->ksym.lnode);
 	mutex_init(&fp->aux->used_maps_mutex);
@@ -1382,7 +1383,7 @@ struct bpf_prog *bpf_jit_blind_constants(struct bpf_prog *prog)
 	struct bpf_insn *insn;
 	int i, rewritten;
 
-	if (!bpf_jit_blinding_enabled(prog) || prog->blinded)
+	if (!prog->blinding_requested || prog->blinded)
 		return prog;
 
 	clone = bpf_prog_clone_create(prog, GFP_USER);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 885e515cf83f..ec4780bd44f1 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13024,6 +13024,7 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 		func[i]->aux->name[0] = 'F';
 		func[i]->aux->stack_depth = env->subprog_info[i].stack_depth;
 		func[i]->jit_requested = 1;
+		func[i]->blinding_requested = prog->blinding_requested;
 		func[i]->aux->kfunc_tab = prog->aux->kfunc_tab;
 		func[i]->aux->kfunc_btf_tab = prog->aux->kfunc_btf_tab;
 		func[i]->aux->linfo = prog->aux->linfo;
@@ -13150,6 +13151,7 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 out_undo_insn:
 	/* cleanup main prog to be interpreted */
 	prog->jit_requested = 0;
+	prog->blinding_requested = 0;
 	for (i = 0, insn = prog->insnsi; i < prog->len; i++, insn++) {
 		if (!bpf_pseudo_call(insn))
 			continue;
@@ -13243,7 +13245,6 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 {
 	struct bpf_prog *prog = env->prog;
 	enum bpf_attach_type eatype = prog->expected_attach_type;
-	bool expect_blinding = bpf_jit_blinding_enabled(prog);
 	enum bpf_prog_type prog_type = resolve_prog_type(prog);
 	struct bpf_insn *insn = prog->insnsi;
 	const struct bpf_func_proto *fn;
@@ -13407,7 +13408,7 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			insn->code = BPF_JMP | BPF_TAIL_CALL;
 
 			aux = &env->insn_aux_data[i + delta];
-			if (env->bpf_capable && !expect_blinding &&
+			if (env->bpf_capable && !prog->blinding_requested &&
 			    prog->jit_requested &&
 			    !bpf_map_key_poisoned(aux) &&
 			    !bpf_map_ptr_poisoned(aux) &&
-- 
2.29.2

