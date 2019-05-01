Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6F261094B
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 16:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbfEAOoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 10:44:21 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53938 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726965AbfEAOoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 10:44:19 -0400
Received: by mail-wm1-f65.google.com with SMTP id q15so1682745wmf.3
        for <netdev@vger.kernel.org>; Wed, 01 May 2019 07:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uEylg6KmKUveZPcda9kkJ4iLAOp2pnuAdpF2a/e8Dss=;
        b=JGSVKHaXCnPhsBLDCpUmvTIPQkmclisFxTJ00uauXvru4Wb8NNYhlsrPZfN2t9PaJ6
         I20gdEKRKuExL0kJSDuqM5GA1qxUz4y3pwbpWLkQB+UnW5es1WasDt4E2eDE9+b4Vc4n
         3fvWM/7KwUuisdC0tP1K89TchPd0e0C1NGXhz9OAxf7Sy9owIurbT4jNkPmkdi2MIM9v
         A+ghUCzcCtPxLJ3IHUHb6cQ5cslbKDPL8i/hmws2Q42F+qK6rfyJFPCnsQKY/zRTOUTJ
         u/kEd6dkt3fCHqTumKUTdv6iTiBY5xnv03BbUH6YscBJaWdjFTL2c0LjBIzo/rgfLeFb
         oCpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uEylg6KmKUveZPcda9kkJ4iLAOp2pnuAdpF2a/e8Dss=;
        b=tyifvdlnkjxmOq6ZmShJXJCjpAa03bbPr9c1/3cGoLT1pa9m1N/2/mtfcLYcfAMaN+
         XzJUzzMI9ULdC1jIbeMW6nME3QOBHBpedtHMDgb4eCi5hKFzZw2uoJt4Zp7xde5Ks+XB
         hTQ69tD5cUVFwLrVno0cEB7CGpFXpD3OU7nOP+8iDzRxX1peMYWgOt9zv+dVWdisPJXO
         v4VCbddB4jVUmhrFEitkWkwWG+qorKurfq28GPt4DaHM8ezhaYDbgkW8K/1heZe72T0I
         y65bGh9vkTyTVfTgxwSgNwwqEAM73IA5BYxf5C05a0WgAbsCMPGki3hwYZ4ujojuP5qI
         J6PA==
X-Gm-Message-State: APjAAAVEwEwNKaDbMff8JxKQh98mKkb6lRrUf4P7BYfLOKY1VXKZL6j3
        TRAnl9tpx2CncqOoc/7p7OW0ig==
X-Google-Smtp-Source: APXvYqy0HItLbvQKdqBQOWeb+9nm4fnwAdIsR0iaRJhZYL6eMO8yys+/0L285l14Tz339g+o+V/Y4Q==
X-Received: by 2002:a1c:81cc:: with SMTP id c195mr6912888wmd.61.1556721857204;
        Wed, 01 May 2019 07:44:17 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id g10sm36164976wrq.2.2019.05.01.07.44.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 01 May 2019 07:44:16 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v5 bpf-next 07/17] bpf: verifier: randomize high 32-bit when BPF_F_TEST_RND_HI32 is set
Date:   Wed,  1 May 2019 15:43:52 +0100
Message-Id: <1556721842-29836-8-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556721842-29836-1-git-send-email-jiong.wang@netronome.com>
References: <1556721842-29836-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch randomizes high 32-bit of a definition when BPF_F_TEST_RND_HI32
is set.

It does this once the flag set no matter there is hardware zero extension
support or not. Because this is a test feature and we want to deliver the
most stressful test.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 kernel/bpf/verifier.c | 69 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 58 insertions(+), 11 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 66aaaa0..6f3b8db 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7648,32 +7648,79 @@ static int opt_remove_nops(struct bpf_verifier_env *env)
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
+
+	rnd_hi32 = attr->prog_flags & BPF_F_TEST_RND_HI32;
 
 	zext_patch[1] = BPF_ALU32_IMM(BPF_ZEXT, 0, 0);
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
+		if (bpf_jit_hardware_zext())
 			continue;
 
-		insn = insns[adj_idx];
 		zext_patch[0] = insn;
 		zext_patch[1].dst_reg = insn.dst_reg;
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
@@ -8533,10 +8580,10 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	/* do 32-bit optimization after insn patching has done so those patched
 	 * insns could be handled correctly.
 	 */
-	if (ret == 0 && !bpf_jit_hardware_zext() &&
-	    !bpf_prog_is_dev_bound(env->prog->aux)) {
-		ret = opt_subreg_zext_lo32(env);
-		env->prog->aux->verifier_zext = !ret;
+	if (ret == 0 && !bpf_prog_is_dev_bound(env->prog->aux)) {
+		ret = opt_subreg_zext_lo32_rnd_hi32(env, attr);
+		env->prog->aux->verifier_zext =
+			bpf_jit_hardware_zext() ? false : !ret;
 	}
 
 	if (ret == 0)
-- 
2.7.4

