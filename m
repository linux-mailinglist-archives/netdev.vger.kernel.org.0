Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABE141D056
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 02:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347414AbhI3ABs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 20:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347792AbhI3ABV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 20:01:21 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9E8C061772;
        Wed, 29 Sep 2021 16:59:38 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id y5so2704593pll.3;
        Wed, 29 Sep 2021 16:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VyMS20c3TNSQFBm8J5YMmaocwYt6vhOpPzJE3mY1y3A=;
        b=isNMTq24Q3amDqbHwP4Q5/hfbzjoNTMynkO+/NXOp9HeI0E2leqWzt1lkFsdObGkKC
         fscenVduIZ03BgIw4W4w9ncN3kOVCZFxnQFhXFPm4EVTHPQDB4aGJJq6WElL0M6yIdy1
         r7XiKtxhhgncRwy6wSJsVlEPUpMDghe3QO+tu4PW0q2RDdoV0WErI0l+EOkQi9hnXx41
         oElZW09lIDnfyijVQJF6iLqLKUMMyuKkuc01hevi+YDq4p2luoEkBiDIUogEluShHBLt
         UADuHemtAfzBHDwbKm+auG7r9cCGuy87W/HwRI4O6x8rPBvp0WvfVnZJ/z6ZxVwWwOGg
         A0kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VyMS20c3TNSQFBm8J5YMmaocwYt6vhOpPzJE3mY1y3A=;
        b=EJjQUX71lwDUfeBFlpoEQNqa0AIxZGcicXgQ1SnE7YnIy+Zv49vXT0MfNMATpjLulG
         72wPln06kCEHZ+/5X7IhijlXcSpV5t5ld5BCSlV10YFdZE9lEvfjy91igNDzCbarJovv
         svov6j4SKc9LfGzLyX15VlFHH4YlmCyfhcUAh5sIe2Q/XeCf4+3EkwvLJ6G6XlL47b88
         qYyqHTuYfB0Lwyb87+tvdouDoSDQH0jXfPhukde0bDS/VnqPFCjHOQ2x6PO3xpZcsQgf
         +SVZKwevpL72rC6N846DzBaWZdSvGx9wEDof92pvMCMQ9POEH91Wy/S0iGVf0ob6M/Jn
         0gaw==
X-Gm-Message-State: AOAM530xKpqRwzGVC4MCA/3ZHDEGOyUFwdKBGazhpnT2IyOh5A3Cb2Ft
        Q5YDlr+18cNBp6JfZfTKgA==
X-Google-Smtp-Source: ABdhPJwdlFq8/d0cKguXz1imNWsgCvPIpkoZ2SNgEI4d4gDhVdGHkjyzorsOAckV6Oke13rQ+bBxCw==
X-Received: by 2002:a17:90b:911:: with SMTP id bo17mr7453014pjb.232.1632959978316;
        Wed, 29 Sep 2021 16:59:38 -0700 (PDT)
Received: from jevburton2.c.googlers.com.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mr18sm681907pjb.17.2021.09.29.16.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 16:59:37 -0700 (PDT)
From:   Joe Burton <jevburton.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Joe Burton <jevburton@google.com>
Subject: [RFC PATCH v2 11/13] bpf: verifier inserts map tracing helper call
Date:   Wed, 29 Sep 2021 23:59:08 +0000
Message-Id: <20210929235910.1765396-12-jevburton.kernel@gmail.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
References: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Burton <jevburton@google.com>

The verifier will automatically insert a map tracing helper call after
each bpf_map_{update,delete}_elem(). Registers are preserved
appropriately to make this transparent to applications.

Signed-off-by: Joe Burton <jevburton@google.com>
---
 kernel/bpf/verifier.c | 75 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 70 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index babcb135dc0d..01a99571ecea 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12678,6 +12678,48 @@ static int fixup_kfunc_call(struct bpf_verifier_env *env,
 	return 0;
 }
 
+int get_map_tracing_patchlet(
+		void *map_func,
+		void *map_trace_func,
+		const int nregs,
+		struct bpf_prog *prog,
+		struct bpf_insn *insn_buf,
+		int *extra_stack)
+{
+	const int stack_offset = -1 * (int16_t) prog->aux->stack_depth;
+	const int reg_size_bytes = 8;
+	int cnt = 0, i;
+
+	/* push args onto the stack so that we can invoke the tracer after */
+	for (i = 0; i < nregs; i++)
+		insn_buf[cnt++] = BPF_STX_MEM(
+				BPF_DW, BPF_REG_FP,
+				BPF_REG_1 + i,
+				stack_offset - (i + 1) * reg_size_bytes);
+
+	insn_buf[cnt++] = BPF_EMIT_CALL(map_func);
+
+	for (i = 0; i < nregs; i++)
+		insn_buf[cnt++] = BPF_LDX_MEM(
+				BPF_DW, BPF_REG_1 + i,
+				BPF_REG_FP,
+				stack_offset - (i + 1) * reg_size_bytes);
+
+	/* save return code from map update */
+	insn_buf[cnt++] = BPF_STX_MEM(BPF_DW, BPF_REG_FP, BPF_REG_0,
+				      stack_offset - reg_size_bytes);
+
+	/* invoke tracing helper */
+	insn_buf[cnt++] = BPF_EMIT_CALL(map_trace_func);
+
+	/* restore return code from map update */
+	insn_buf[cnt++] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_FP,
+				      stack_offset - reg_size_bytes);
+
+	*extra_stack = max_t(int, *extra_stack, nregs * reg_size_bytes);
+	return cnt;
+}
+
 /* Do various post-verification rewrites in a single program pass.
  * These rewrites simplify JIT and interpreter implementations.
  */
@@ -12694,7 +12736,7 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 	struct bpf_insn insn_buf[16];
 	struct bpf_prog *new_prog;
 	struct bpf_map *map_ptr;
-	int i, ret, cnt, delta = 0;
+	int i, ret, cnt, delta = 0, extra_stack = 0;
 
 	for (i = 0; i < insn_cnt; i++, insn++) {
 		/* Make divide-by-zero exceptions impossible. */
@@ -12998,11 +13040,23 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 				insn->imm = BPF_CALL_IMM(ops->map_lookup_elem);
 				continue;
 			case BPF_FUNC_map_update_elem:
-				insn->imm = BPF_CALL_IMM(ops->map_update_elem);
-				continue;
+				cnt = get_map_tracing_patchlet(
+						ops->map_update_elem,
+						bpf_trace_map_update_elem,
+						/*nregs=*/4, prog, insn_buf,
+						&extra_stack);
+				if (cnt < 0)
+					return cnt;
+				goto patch_map_ops_tracing;
 			case BPF_FUNC_map_delete_elem:
-				insn->imm = BPF_CALL_IMM(ops->map_delete_elem);
-				continue;
+				cnt = get_map_tracing_patchlet(
+						ops->map_delete_elem,
+						bpf_trace_map_delete_elem,
+						/*nregs=*/2, prog, insn_buf,
+						&extra_stack);
+				if (cnt < 0)
+					return cnt;
+				goto patch_map_ops_tracing;
 			case BPF_FUNC_map_push_elem:
 				insn->imm = BPF_CALL_IMM(ops->map_push_elem);
 				continue;
@@ -13018,6 +13072,16 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			}
 
 			goto patch_call_imm;
+patch_map_ops_tracing:
+			new_prog = bpf_patch_insn_data(env, i + delta,
+						       insn_buf, cnt);
+			if (!new_prog)
+				return -ENOMEM;
+
+			delta    += cnt - 1;
+			env->prog = prog = new_prog;
+			insn      = new_prog->insnsi + i + delta;
+			continue;
 		}
 
 		/* Implement bpf_jiffies64 inline. */
@@ -13092,6 +13156,7 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 	}
 
 	sort_kfunc_descs_by_imm(env->prog);
+	prog->aux->stack_depth += extra_stack;
 
 	return 0;
 }
-- 
2.33.0.685.g46640cef36-goog

