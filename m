Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B79329747
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 13:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391154AbfEXLf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 07:35:58 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35034 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391093AbfEXLfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 07:35:55 -0400
Received: by mail-wr1-f66.google.com with SMTP id m3so9670562wrv.2
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 04:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VqcAEV4T2FRNSjsrYhEUCe7efYCzuEHror9AtNeQoqs=;
        b=zkIJD0p3jKwj8QQr2WguJmMMXOrvhXyor8tkP6Zv+xyBcL6JLgbcwBRc7GuMpJjHqj
         +co5EZM6uP5izE4E9T6EYxOlXbcEq82c2uutgAoDmP3IBnh1/QXgRXbcNWo5i3msQPDp
         xhB2t78sUYslhKUBNzm/4AFbzgpszzCUuqN9rBj+I9U3TgPQnSdsSyAi4Ikn74rQB6Vv
         waG/posFv1UFxAOb/68EtnnWt3d64xfLTWN8AQ0fOzHyBD0Td94fYb/SnLe9q5E4fgD3
         cdhEUv0F9ywT1AFhpfCvh1Sq4aqYR4ir2ZLsmoCoaE7FLxX2gf++spwFQQXtEJ3Wtvhe
         XJqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VqcAEV4T2FRNSjsrYhEUCe7efYCzuEHror9AtNeQoqs=;
        b=DoG3NxEX6rAx8qCUnFVOoKvx9e01MKyuH3jHcMHOccJImSnVzgvUJvHkhq9mB0E6kE
         tw+RXmAM378ZrUhzKRh937GEc0RAhXndoV0bXALkWfdcOLiNSBY9F4ExMFcO09vrKHI2
         JD0OJj4/FQoOM/Yu78CBLLxVkbmM0xY3aP1Z2NuLdMjyTJuSR7AhOFvlFSeiYtSvpm+F
         /WvHEZ14k3bgrwDJxbYTCJVee2fTPKq0UJGhHp/KBI3og6QFFZAu16bd1P4oQt3Zvmxj
         mDUgO+2ZuxxQdX93hmnqQ0UG9yHXJXQZzxXH7YTlO0vhtyO9PyH0YY5byflfBLftskXy
         KQ4Q==
X-Gm-Message-State: APjAAAUHRfOVQA9lccsqgA7NBY8gSTDPzTwtNDfzIEgu7EU45uYGXUc9
        SSScK9SlFpVPWMga1DWbnOjHdy6PHRg=
X-Google-Smtp-Source: APXvYqxmPV+NIvLsRTbe8LTiiP2P7ZpE7d6ZP89rVJxqmL9xj1S41oUJX9sIn4ZOOX7Vb9GXYb3SEQ==
X-Received: by 2002:a5d:4fc1:: with SMTP id h1mr978590wrw.323.1558697753161;
        Fri, 24 May 2019 04:35:53 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id x22sm2462902wmi.4.2019.05.24.04.35.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 May 2019 04:35:52 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v8 bpf-next 06/16] bpf: verifier: randomize high 32-bit when BPF_F_TEST_RND_HI32 is set
Date:   Fri, 24 May 2019 12:35:16 +0100
Message-Id: <1558697726-4058-7-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558697726-4058-1-git-send-email-jiong.wang@netronome.com>
References: <1558697726-4058-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch randomizes high 32-bit of a definition when BPF_F_TEST_RND_HI32
is set.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 kernel/bpf/verifier.c | 68 ++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 57 insertions(+), 11 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d4394a8..2778417 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7640,33 +7640,79 @@ static int opt_remove_nops(struct bpf_verifier_env *env)
 	return 0;
 }
 
-static int opt_subreg_zext_lo32(struct bpf_verifier_env *env)
+static int opt_subreg_zext_lo32_rnd_hi32(struct bpf_verifier_env *env,
+					 const union bpf_attr *attr)
 {
+	struct bpf_insn *patch, zext_patch[2], rnd_hi32_patch[4];
 	struct bpf_insn_aux_data *aux = env->insn_aux_data;
+	int i, patch_len, delta = 0, len = env->prog->len;
 	struct bpf_insn *insns = env->prog->insnsi;
-	int i, delta = 0, len = env->prog->len;
-	struct bpf_insn zext_patch[2];
 	struct bpf_prog *new_prog;
+	bool rnd_hi32;
 
+	rnd_hi32 = attr->prog_flags & BPF_F_TEST_RND_HI32;
 	zext_patch[1] = BPF_ZEXT_REG(0);
+	rnd_hi32_patch[1] = BPF_ALU64_IMM(BPF_MOV, BPF_REG_AX, 0);
+	rnd_hi32_patch[2] = BPF_ALU64_IMM(BPF_LSH, BPF_REG_AX, 32);
+	rnd_hi32_patch[3] = BPF_ALU64_REG(BPF_OR, 0, BPF_REG_AX);
 	for (i = 0; i < len; i++) {
 		int adj_idx = i + delta;
 		struct bpf_insn insn;
 
-		if (!aux[adj_idx].zext_dst)
+		insn = insns[adj_idx];
+		if (!aux[adj_idx].zext_dst) {
+			u8 code, class;
+			u32 imm_rnd;
+
+			if (!rnd_hi32)
+				continue;
+
+			code = insn.code;
+			class = BPF_CLASS(code);
+			if (insn_no_def(&insn))
+				continue;
+
+			/* NOTE: arg "reg" (the fourth one) is only used for
+			 *       BPF_STX which has been ruled out in above
+			 *       check, it is safe to pass NULL here.
+			 */
+			if (is_reg64(env, &insn, insn.dst_reg, NULL, DST_OP)) {
+				if (class == BPF_LD &&
+				    BPF_MODE(code) == BPF_IMM)
+					i++;
+				continue;
+			}
+
+			/* ctx load could be transformed into wider load. */
+			if (class == BPF_LDX &&
+			    aux[adj_idx].ptr_type == PTR_TO_CTX)
+				continue;
+
+			imm_rnd = get_random_int();
+			rnd_hi32_patch[0] = insn;
+			rnd_hi32_patch[1].imm = imm_rnd;
+			rnd_hi32_patch[3].dst_reg = insn.dst_reg;
+			patch = rnd_hi32_patch;
+			patch_len = 4;
+			goto apply_patch_buffer;
+		}
+
+		if (!bpf_jit_needs_zext())
 			continue;
 
-		insn = insns[adj_idx];
 		zext_patch[0] = insn;
 		zext_patch[1].dst_reg = insn.dst_reg;
 		zext_patch[1].src_reg = insn.dst_reg;
-		new_prog = bpf_patch_insn_data(env, adj_idx, zext_patch, 2);
+		patch = zext_patch;
+		patch_len = 2;
+apply_patch_buffer:
+		new_prog = bpf_patch_insn_data(env, adj_idx, patch, patch_len);
 		if (!new_prog)
 			return -ENOMEM;
 		env->prog = new_prog;
 		insns = new_prog->insnsi;
 		aux = env->insn_aux_data;
-		delta += 2;
+		delta += patch_len - 1;
 	}
 
 	return 0;
@@ -8525,10 +8571,10 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	/* do 32-bit optimization after insn patching has done so those patched
 	 * insns could be handled correctly.
 	 */
-	if (ret == 0 && bpf_jit_needs_zext() &&
-	    !bpf_prog_is_dev_bound(env->prog->aux)) {
-		ret = opt_subreg_zext_lo32(env);
-		env->prog->aux->verifier_zext = !ret;
+	if (ret == 0 && !bpf_prog_is_dev_bound(env->prog->aux)) {
+		ret = opt_subreg_zext_lo32_rnd_hi32(env, attr);
+		env->prog->aux->verifier_zext = bpf_jit_needs_zext() ? !ret
+								     : false;
 	}
 
 	if (ret == 0)
-- 
2.7.4

