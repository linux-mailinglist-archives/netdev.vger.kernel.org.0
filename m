Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 897E56394FB
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 10:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiKZJsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 04:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiKZJsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 04:48:38 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CAF20348;
        Sat, 26 Nov 2022 01:48:34 -0800 (PST)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NK6NY2zKKzmWBq;
        Sat, 26 Nov 2022 17:47:57 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 26 Nov 2022 17:48:32 +0800
Received: from ubuntu1804.huawei.com (10.67.174.61) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 26 Nov 2022 17:48:31 +0800
From:   Yang Jihong <yangjihong1@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>,
        <illusionist.neo@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <mykolal@fb.com>, <shuah@kernel.org>,
        <benjamin.tissoires@redhat.com>, <memxor@gmail.com>,
        <colin.i.king@gmail.com>, <asavkov@redhat.com>, <delyank@fb.com>,
        <bpf@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
CC:     <yangjihong1@huawei.com>
Subject: [PATCH bpf-next v3 1/4] bpf: Adapt 32-bit return value kfunc for 32-bit ARM when zext extension
Date:   Sat, 26 Nov 2022 17:45:27 +0800
Message-ID: <20221126094530.226629-2-yangjihong1@huawei.com>
X-Mailer: git-send-email 2.30.GIT
In-Reply-To: <20221126094530.226629-1-yangjihong1@huawei.com>
References: <20221126094530.226629-1-yangjihong1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.61]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For ARM32 architecture, if data width of kfunc return value is 32 bits,
need to do explicit zero extension for high 32-bit, insn_def_regno should
return dst_reg for BPF_JMP type of BPF_PSEUDO_KFUNC_CALL. Otherwise,
opt_subreg_zext_lo32_rnd_hi32 returns -EFAULT, resulting in BPF failure.

Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
---
 kernel/bpf/verifier.c | 44 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 264b3dc714cc..193ea927aa69 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1927,6 +1927,21 @@ find_kfunc_desc(const struct bpf_prog *prog, u32 func_id, u16 offset)
 		       sizeof(tab->descs[0]), kfunc_desc_cmp_by_id_off);
 }
 
+static int kfunc_desc_cmp_by_imm(const void *a, const void *b);
+
+static const struct bpf_kfunc_desc *
+find_kfunc_desc_by_imm(const struct bpf_prog *prog, s32 imm)
+{
+	struct bpf_kfunc_desc desc = {
+		.imm = imm,
+	};
+	struct bpf_kfunc_desc_tab *tab;
+
+	tab = prog->aux->kfunc_tab;
+	return bsearch(&desc, tab->descs, tab->nr_descs,
+		       sizeof(tab->descs[0]), kfunc_desc_cmp_by_imm);
+}
+
 static struct btf *__find_kfunc_desc_btf(struct bpf_verifier_env *env,
 					 s16 offset)
 {
@@ -2342,6 +2357,13 @@ static bool is_reg64(struct bpf_verifier_env *env, struct bpf_insn *insn,
 			 */
 			if (insn->src_reg == BPF_PSEUDO_CALL)
 				return false;
+
+			/* Kfunc call will reach here because of insn_has_def32,
+			 * conservatively return TRUE.
+			 */
+			if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL)
+				return true;
+
 			/* Helper call will reach here because of arg type
 			 * check, conservatively return TRUE.
 			 */
@@ -2405,10 +2427,26 @@ static bool is_reg64(struct bpf_verifier_env *env, struct bpf_insn *insn,
 }
 
 /* Return the regno defined by the insn, or -1. */
-static int insn_def_regno(const struct bpf_insn *insn)
+static int insn_def_regno(struct bpf_verifier_env *env, const struct bpf_insn *insn)
 {
 	switch (BPF_CLASS(insn->code)) {
 	case BPF_JMP:
+		if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL) {
+			const struct bpf_kfunc_desc *desc;
+
+			/* The value of desc cannot be NULL */
+			desc = find_kfunc_desc_by_imm(env->prog, insn->imm);
+
+			/* A kfunc can return void.
+			 * The btf type of the kfunc's return value needs
+			 * to be checked against "void" first
+			 */
+			if (desc->func_model.ret_size == 0)
+				return -1;
+			else
+				return insn->dst_reg;
+		}
+		fallthrough;
 	case BPF_JMP32:
 	case BPF_ST:
 		return -1;
@@ -2430,7 +2468,7 @@ static int insn_def_regno(const struct bpf_insn *insn)
 /* Return TRUE if INSN has defined any 32-bit value explicitly. */
 static bool insn_has_def32(struct bpf_verifier_env *env, struct bpf_insn *insn)
 {
-	int dst_reg = insn_def_regno(insn);
+	int dst_reg = insn_def_regno(env, insn);
 
 	if (dst_reg == -1)
 		return false;
@@ -13335,7 +13373,7 @@ static int opt_subreg_zext_lo32_rnd_hi32(struct bpf_verifier_env *env,
 		int load_reg;
 
 		insn = insns[adj_idx];
-		load_reg = insn_def_regno(&insn);
+		load_reg = insn_def_regno(env, &insn);
 		if (!aux[adj_idx].zext_dst) {
 			u8 code, class;
 			u32 imm_rnd;
-- 
2.30.GIT

