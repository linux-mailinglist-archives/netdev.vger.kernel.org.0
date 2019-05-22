Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B114226A37
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbfEVS4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:56:01 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54055 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729679AbfEVSz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 14:55:57 -0400
Received: by mail-wm1-f66.google.com with SMTP id 198so3273418wme.3
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 11:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ncqbrt/07UxSSRx11KfiCqsSMYm+iMTRE09QQPITNZE=;
        b=axaxDQWnKToE0QyxZlKW0MKYmtmzujKfebY3ogIT21rp2pn1EYtxgq6GG8Isy6lsPI
         3KaPwNZTMff1gGNcnxxGf/Hc+pXA29/drDgBqHTJulJ0EIJmBQ5PJkZOqql4J0gCEdNv
         EjxRw67zA1/vmweqPPlQ37cPgrcDzaRyS6fIntSD1C59juReHCUBzmzF08CpNwG8GwxR
         FTF1BizH3J0/xW+1rp2tJyzFh8mH71cAR6daPCCiHjihWNXMyIz3cedNGgUAAeJFx1f6
         0QbepybanwGy1UpCwbZ1k5S8r0mmn73QBujWX7Fo1wWiEoNavtn96e9QbjwMkzKQASYe
         Cb0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ncqbrt/07UxSSRx11KfiCqsSMYm+iMTRE09QQPITNZE=;
        b=brGcVvFSCBBTnSkWMXkH4v1+Pgg7tHcD7jP/F4T8w9F0hiFY2ki147Zy4DOTRFfI3a
         WgQkObYcOF/BVpoEk52BZD+X3n832Av/0t2hOGfYjypXytTZ+j8QPlf79JT5FBSkuiJ/
         ZtR+4tjFZ/NV2Xw49GfIo7UXN9sZm5kHdrRXfYyVGDtZ0mWuG1YBGvRTT5fAcGIrDpf3
         nrrxS90ql/Un+mKJef+zOBHf9+8JgTIz7k2Vxt1fMbc0yZu1m7FzQqGOHHa2ERsFFAJA
         qGJOan++bAJl6nlFWRLn5/E3WFse6dCPHWKUKuwdR+YTgdGjRNyOtymjAwKoQnPxDVyy
         BHyw==
X-Gm-Message-State: APjAAAUIC0UlD/B/GaM0f26OcAl5IA2aYCroUJ9iXCSWjTxHZoAKFiYx
        rfZcgoQIThhIUKI30m4E0R7fQg==
X-Google-Smtp-Source: APXvYqyiPS8Ia/Qph5I07WpwV9NCzJovkoSkcusTXVfbRIAVxPEMXjI1FzHsqeDlP0y5U0L5aH5BhA==
X-Received: by 2002:a1c:200a:: with SMTP id g10mr8841759wmg.121.1558551355598;
        Wed, 22 May 2019 11:55:55 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id t12sm16328801wro.2.2019.05.22.11.55.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 22 May 2019 11:55:54 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v7 bpf-next 06/16] bpf: verifier: randomize high 32-bit when BPF_F_TEST_RND_HI32 is set
Date:   Wed, 22 May 2019 19:55:02 +0100
Message-Id: <1558551312-17081-7-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558551312-17081-1-git-send-email-jiong.wang@netronome.com>
References: <1558551312-17081-1-git-send-email-jiong.wang@netronome.com>
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
index 560e17d..0a8cab8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7621,33 +7621,79 @@ static int opt_remove_nops(struct bpf_verifier_env *env)
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
@@ -8507,10 +8553,10 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
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

