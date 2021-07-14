Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41BB3C81A7
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 11:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238842AbhGNJgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 05:36:03 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6924 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238337AbhGNJgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 05:36:02 -0400
Received: from dggeme751-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GPsf71mxFz7BlB;
        Wed, 14 Jul 2021 17:29:35 +0800 (CST)
Received: from k03.huawei.com (10.67.174.111) by
 dggeme751-chm.china.huawei.com (10.3.19.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 14 Jul 2021 17:33:08 +0800
From:   He Fengqing <hefengqing@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [bpf-next, v2] bpf: verifier: Fix potential memleak and UAF in bpf verifier
Date:   Wed, 14 Jul 2021 10:18:15 +0000
Message-ID: <20210714101815.164322-1-hefengqing@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.111]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme751-chm.china.huawei.com (10.3.19.97)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In bpf_patch_insn_data(), we first use the bpf_patch_insn_single() to
insert new instructions, then use adjust_insn_aux_data() to adjust
insn_aux_data. If the old env->prog have no enough room for new inserted
instructions, we use bpf_prog_realloc to construct new_prog and free the
old env->prog.

There have two errors here. First, if adjust_insn_aux_data() return
ENOMEM, we should free the new_prog. Second, if adjust_insn_aux_data()
return ENOMEM, bpf_patch_insn_data() will return NULL, and env->prog has
been freed in bpf_prog_realloc, but we will use it in bpf_check().

So in this patch, we make the adjust_insn_aux_data() never fails. In
bpf_patch_insn_data(), we first pre-malloc memory for the new
insn_aux_data, then call bpf_patch_insn_single() to insert new
instructions, at last call adjust_insn_aux_data() to adjust
insn_aux_data.

Fixes: 8041902dae52 ("bpf: adjust insn_aux_data when patching insns")

Signed-off-by: He Fengqing <hefengqing@huawei.com>

  v1->v2:
    pre-malloc memory for new insn_aux_data first, then
    adjust_insn_aux_data() will never fails.
---
 kernel/bpf/verifier.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index be38bb930bf1..07cf791510f1 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11425,10 +11425,11 @@ static void convert_pseudo_ld_imm64(struct bpf_verifier_env *env)
  * insni[off, off + cnt).  Adjust corresponding insn_aux_data by copying
  * [0, off) and [off, end) to new locations, so the patched range stays zero
  */
-static int adjust_insn_aux_data(struct bpf_verifier_env *env,
-				struct bpf_prog *new_prog, u32 off, u32 cnt)
+static void adjust_insn_aux_data(struct bpf_verifier_env *env,
+				 struct bpf_insn_aux_data *new_data,
+				 struct bpf_prog *new_prog, u32 off, u32 cnt)
 {
-	struct bpf_insn_aux_data *new_data, *old_data = env->insn_aux_data;
+	struct bpf_insn_aux_data *old_data = env->insn_aux_data;
 	struct bpf_insn *insn = new_prog->insnsi;
 	u32 old_seen = old_data[off].seen;
 	u32 prog_len;
@@ -11441,12 +11442,9 @@ static int adjust_insn_aux_data(struct bpf_verifier_env *env,
 	old_data[off].zext_dst = insn_has_def32(env, insn + off + cnt - 1);
 
 	if (cnt == 1)
-		return 0;
+		return;
 	prog_len = new_prog->len;
-	new_data = vzalloc(array_size(prog_len,
-				      sizeof(struct bpf_insn_aux_data)));
-	if (!new_data)
-		return -ENOMEM;
+
 	memcpy(new_data, old_data, sizeof(struct bpf_insn_aux_data) * off);
 	memcpy(new_data + off + cnt - 1, old_data + off,
 	       sizeof(struct bpf_insn_aux_data) * (prog_len - off - cnt + 1));
@@ -11457,7 +11455,7 @@ static int adjust_insn_aux_data(struct bpf_verifier_env *env,
 	}
 	env->insn_aux_data = new_data;
 	vfree(old_data);
-	return 0;
+	return;
 }
 
 static void adjust_subprog_starts(struct bpf_verifier_env *env, u32 off, u32 len)
@@ -11492,6 +11490,14 @@ static struct bpf_prog *bpf_patch_insn_data(struct bpf_verifier_env *env, u32 of
 					    const struct bpf_insn *patch, u32 len)
 {
 	struct bpf_prog *new_prog;
+	struct bpf_insn_aux_data *new_data = NULL;
+
+	if (len > 1) {
+		new_data = vzalloc(array_size(env->prog->len + len - 1,
+					      sizeof(struct bpf_insn_aux_data)));
+		if (!new_data)
+			return NULL;
+	}
 
 	new_prog = bpf_patch_insn_single(env->prog, off, patch, len);
 	if (IS_ERR(new_prog)) {
@@ -11499,10 +11505,12 @@ static struct bpf_prog *bpf_patch_insn_data(struct bpf_verifier_env *env, u32 of
 			verbose(env,
 				"insn %d cannot be patched due to 16-bit range\n",
 				env->insn_aux_data[off].orig_idx);
+		if (new_data)
+			vfree(new_data);
+
 		return NULL;
 	}
-	if (adjust_insn_aux_data(env, new_prog, off, len))
-		return NULL;
+	adjust_insn_aux_data(env, new_data, new_prog, off, len);
 	adjust_subprog_starts(env, off, len);
 	adjust_poke_descs(new_prog, off, len);
 	return new_prog;
-- 
2.25.1

