Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB41512BCB
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 12:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbfECKoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 06:44:25 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55391 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727261AbfECKnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 06:43:52 -0400
Received: by mail-wm1-f66.google.com with SMTP id y2so6208781wmi.5
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 03:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=URszv7/t7QfVZUhW0Uggw2iCKFbU+bZsnFS6vq2iMu0=;
        b=gCmkMzLq+4d8OMDZcK3SuIIpZzR7oeVaJw1sj/oswdNSztjGHDJdTDhaLkww9nT4dL
         9+WJL2XdIvGLmai/O07m6j8g3hXTwNsZMYRnBXXF1s8MJImuA8YwS1bt831ocV0hlN/U
         PUmFXJOkD7avuNBCmmhI8yrvjZ42ErTMLpPFSpGG29YmjKwBXtK/tqFkd4dsSP/m6bgN
         yxDu2mD+SHVPjbp0mZJacf/wRTHoQ7WK1GzLm0FnWppH83zHw6RQvVoGXRZeE1OcqhFW
         3DaLc4AvbAy0EVGveDplOuOlcsd2ANlhBjNtz9UOnO6qz9pIZ02IN0eJnemhyd/LzZdH
         /Zyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=URszv7/t7QfVZUhW0Uggw2iCKFbU+bZsnFS6vq2iMu0=;
        b=QCLhD6DDRffNJgPplxTxvY6GzXYbuYrRqp3KqzUdVu8XTOWkfj31EmY6nnAjSIAU5Q
         aZmNl68AP0hyXTETPkp5ovNfszcqHGNE1RGwig7OZ/gj4oPmL7FSPBHWoAB8IxkZCDzx
         5WpimDmsULd247MibV/e4FgigimrMfzxaJVo6pSO3QR6r3j67YfESxwHt3fAlVoIB0ED
         /WNqk0/A0mb9Fd+d0vAKpql1o1YT5GQQvrbMViuxA29YwaEz+sf456fCnfTn7iuUpew2
         +r3DdHlWhsVIRMGw7DdFmMIOvPyszUuH/aDZkyQ+8d+uDR5sXU96gHfAdYuyV6PDIDaf
         IYkg==
X-Gm-Message-State: APjAAAUvnn9coESFXdm8lmoFjbH2Zs1yQQo0O4zkGdnFTpC7tq3ume79
        RxKWKDSrmeO4T6TMFxBdU+y0rg==
X-Google-Smtp-Source: APXvYqx5/wFlr9efZAyheV4bxwliZnPxzHL3nwMdWviqU7NPlMuG8DD6eBF70unGFB1L8YoYasXbUg==
X-Received: by 2002:a1c:f901:: with SMTP id x1mr5987805wmh.136.1556880230835;
        Fri, 03 May 2019 03:43:50 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id r29sm1716999wra.56.2019.05.03.03.43.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 03 May 2019 03:43:49 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v6 bpf-next 07/17] bpf: verifier: randomize high 32-bit when BPF_F_TEST_RND_HI32 is set
Date:   Fri,  3 May 2019 11:42:34 +0100
Message-Id: <1556880164-10689-8-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
References: <1556880164-10689-1-git-send-email-jiong.wang@netronome.com>
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
index 999da02..31ffbef 100644
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

