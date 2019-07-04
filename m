Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 766EE5FE2C
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 23:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbfGDV1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 17:27:11 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35578 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbfGDV1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 17:27:10 -0400
Received: by mail-wr1-f67.google.com with SMTP id c27so7891495wrb.2
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 14:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=c4uexnLqDLKe+JQKp5mzqnabcoGZYMu89NHs0NR4zsI=;
        b=BSqXb+OL0r9jBPf3HD90kqmQ4HXtFSbw2BuCLQ4BzlPFfmMbpxonKHaOZxv4hp9pF2
         khphw7Fs6O0dMKq5eDvNBtHHm2fwuYypC1dQTNmiTzkjWPqiXbGilUnH8dszlIbelvFw
         TwXrdUo4utQt8z4yMafsf/YzGx9vFfOuLIZYn2A8ctqvBtxkTcrvsJI+kwHk0mWgn+yn
         U9bRJ1CH5u/rqVcZRXiitZoQ0sjwWRluD2K8gxlZ0kSIZrZGngBuK9+hBtfr7S+XKuh3
         OCEAZwM81G5YRzAoYYzetppOPiAhWMFeUuuS6fsjgwLA/NotihcUKUUoBnXb2cFVWr+B
         wSaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=c4uexnLqDLKe+JQKp5mzqnabcoGZYMu89NHs0NR4zsI=;
        b=tiHx8xA+S/M+WUxxKfHvJtC/fxT4g0Za5FVXObasQRsFH5lqDqR7s+iN7e2Al2s8Nt
         3SvJ+gWaYh8dvwmCJKnC1oE81RqmqDUvwnViz3wvk4O+SL34vudA65WiHS5C28NDDwJP
         UwiX+6ZoV/K7glg4J6FA5F3VwqY4eAasdxArxiZk5XwBPvpXITqfBUsPBPBB9IzdFOnK
         WnLBb6Kg6uaBxcxFP8VLsnb0n5bcvQQKRoT/QsjYCM+k7J8RIWdwFGNmkrRppxD9pXLk
         rk9L1o2VpI+1wS3+zHavYK4s2TR31ET+9ngy9b+jjiMsapAG+tpngLHKu8LK7f7gbvG0
         ft1w==
X-Gm-Message-State: APjAAAXKf34SX5H9MP4j3fsNOFAZTUAdGEKHdviRIN/CNTF+OIfCzJCA
        POhPbo0BWDcqVd0XESLQXSR9kQ==
X-Google-Smtp-Source: APXvYqwPHwjVm9DhsaBAACKETl9qv1+ndcFfoN4cTiMknKpJGLO6PMWpZTcjBTJsnJYUZHErOQfcoA==
X-Received: by 2002:a05:6000:1285:: with SMTP id f5mr324773wrx.315.1562275627849;
        Thu, 04 Jul 2019 14:27:07 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id t17sm9716654wrs.45.2019.07.04.14.27.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 04 Jul 2019 14:27:07 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     ecree@solarflare.com, naveen.n.rao@linux.vnet.ibm.com,
        andriin@fb.com, jakub.kicinski@netronome.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [RFC bpf-next 4/8] bpf: migrate convert_ctx_accesses to list patching infra
Date:   Thu,  4 Jul 2019 22:26:47 +0100
Message-Id: <1562275611-31790-5-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com>
References: <1562275611-31790-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch migrate convert_ctx_accesses to new list patching
infrastructure. pre-patch is used for generating prologue, because what we
really want to do is insert the prog before prog start without touching
the first insn.

Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 kernel/bpf/verifier.c | 98 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 58 insertions(+), 40 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2026d64..2d16e85 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8631,41 +8631,59 @@ static int opt_subreg_zext_lo32_rnd_hi32(struct bpf_verifier_env *env,
 static int convert_ctx_accesses(struct bpf_verifier_env *env)
 {
 	const struct bpf_verifier_ops *ops = env->ops;
-	int i, cnt, size, ctx_field_size, delta = 0;
-	const int insn_cnt = env->prog->len;
 	struct bpf_insn insn_buf[16], *insn;
 	u32 target_size, size_default, off;
-	struct bpf_prog *new_prog;
+	struct bpf_list_insn *list, *elem;
+	int cnt, size, ctx_field_size;
 	enum bpf_access_type type;
 	bool is_narrower_load;
+	int ret = 0;
+
+	list = bpf_create_list_insn(env->prog);
+	if (IS_ERR(list))
+		return PTR_ERR(list);
+	elem = list;
 
 	if (ops->gen_prologue || env->seen_direct_write) {
 		if (!ops->gen_prologue) {
 			verbose(env, "bpf verifier is misconfigured\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto free_list_ret;
 		}
 		cnt = ops->gen_prologue(insn_buf, env->seen_direct_write,
 					env->prog);
 		if (cnt >= ARRAY_SIZE(insn_buf)) {
 			verbose(env, "bpf verifier is misconfigured\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto free_list_ret;
 		} else if (cnt) {
-			new_prog = bpf_patch_insn_data(env, 0, insn_buf, cnt);
-			if (!new_prog)
-				return -ENOMEM;
+			struct bpf_list_insn *new_hdr;
 
-			env->prog = new_prog;
-			delta += cnt - 1;
+			/* "gen_prologue" generates patch buffer, we want to use
+			 * pre-patch buffer because we don't want to touch the
+			 * insn/aux at start offset.
+			 */
+			new_hdr = bpf_prepatch_list_insn(list, insn_buf,
+							 cnt - 1);
+			if (IS_ERR(new_hdr)) {
+				ret = -ENOMEM;
+				goto free_list_ret;
+			}
+			/* Update list head, so new pre-patched nodes could be
+			 * freed by destroyer.
+			 */
+			list = new_hdr;
 		}
 	}
 
 	if (bpf_prog_is_dev_bound(env->prog->aux))
-		return 0;
+		goto linearize_list_ret;
 
-	insn = env->prog->insnsi + delta;
-
-	for (i = 0; i < insn_cnt; i++, insn++) {
+	for (; elem; elem = elem->next) {
 		bpf_convert_ctx_access_t convert_ctx_access;
+		struct bpf_insn_aux_data *aux;
+
+		insn = &elem->insn;
 
 		if (insn->code == (BPF_LDX | BPF_MEM | BPF_B) ||
 		    insn->code == (BPF_LDX | BPF_MEM | BPF_H) ||
@@ -8680,8 +8698,8 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 		else
 			continue;
 
-		if (type == BPF_WRITE &&
-		    env->insn_aux_data[i + delta].sanitize_stack_off) {
+		aux = &env->insn_aux_data[elem->orig_idx - 1];
+		if (type == BPF_WRITE && aux->sanitize_stack_off) {
 			struct bpf_insn patch[] = {
 				/* Sanitize suspicious stack slot with zero.
 				 * There are no memory dependencies for this store,
@@ -8689,8 +8707,7 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 				 * constant of zero
 				 */
 				BPF_ST_MEM(BPF_DW, BPF_REG_FP,
-					   env->insn_aux_data[i + delta].sanitize_stack_off,
-					   0),
+					   aux->sanitize_stack_off, 0),
 				/* the original STX instruction will immediately
 				 * overwrite the same stack slot with appropriate value
 				 */
@@ -8698,17 +8715,15 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 			};
 
 			cnt = ARRAY_SIZE(patch);
-			new_prog = bpf_patch_insn_data(env, i + delta, patch, cnt);
-			if (!new_prog)
-				return -ENOMEM;
-
-			delta    += cnt - 1;
-			env->prog = new_prog;
-			insn      = new_prog->insnsi + i + delta;
+			elem = bpf_patch_list_insn(elem, patch, cnt);
+			if (IS_ERR(elem)) {
+				ret = PTR_ERR(elem);
+				goto free_list_ret;
+			}
 			continue;
 		}
 
-		switch (env->insn_aux_data[i + delta].ptr_type) {
+		switch (aux->ptr_type) {
 		case PTR_TO_CTX:
 			if (!ops->convert_ctx_access)
 				continue;
@@ -8728,7 +8743,7 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 			continue;
 		}
 
-		ctx_field_size = env->insn_aux_data[i + delta].ctx_field_size;
+		ctx_field_size = aux->ctx_field_size;
 		size = BPF_LDST_BYTES(insn);
 
 		/* If the read access is a narrower load of the field,
@@ -8744,7 +8759,8 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 
 			if (type == BPF_WRITE) {
 				verbose(env, "bpf verifier narrow ctx access misconfigured\n");
-				return -EINVAL;
+				ret = -EINVAL;
+				goto free_list_ret;
 			}
 
 			size_code = BPF_H;
@@ -8763,7 +8779,8 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 		if (cnt == 0 || cnt >= ARRAY_SIZE(insn_buf) ||
 		    (ctx_field_size && !target_size)) {
 			verbose(env, "bpf verifier is misconfigured\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto free_list_ret;
 		}
 
 		if (is_narrower_load && size < target_size) {
@@ -8786,18 +8803,19 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 			}
 		}
 
-		new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, cnt);
-		if (!new_prog)
-			return -ENOMEM;
-
-		delta += cnt - 1;
-
-		/* keep walking new program and skip insns we just inserted */
-		env->prog = new_prog;
-		insn      = new_prog->insnsi + i + delta;
+		elem = bpf_patch_list_insn(elem, insn_buf, cnt);
+		if (IS_ERR(elem)) {
+			ret = PTR_ERR(elem);
+			goto free_list_ret;
+		}
 	}
-
-	return 0;
+linearize_list_ret:
+	env = verifier_linearize_list_insn(env, list);
+	if (IS_ERR(env))
+		ret = PTR_ERR(env);
+free_list_ret:
+	bpf_destroy_list_insn(list);
+	return ret;
 }
 
 static int jit_subprogs(struct bpf_verifier_env *env)
-- 
2.7.4

