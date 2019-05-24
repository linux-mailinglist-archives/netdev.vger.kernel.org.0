Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A84382A136
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 00:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404438AbfEXW1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 18:27:34 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43528 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404423AbfEXW1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 18:27:31 -0400
Received: by mail-wr1-f68.google.com with SMTP id l17so2982078wrm.10
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 15:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VqcAEV4T2FRNSjsrYhEUCe7efYCzuEHror9AtNeQoqs=;
        b=O36MfpDCmAyTZ2x9mr/lrjRYj64EoU9+4oJd4kESI9t+UyPCMLmAwLOwQKIFgz32C5
         wYJJ4eRD9MNwmALxlTiLWlxubRwWlDt4rHLcNd0qI0sLCRJzzTUeds99NM5VC1lmpOdy
         McAsw1SSDcwM5LWLr7VVm0+GCL4sg5xHtY2atvEQhjFcyWBkXEslyn22XQyU/53Am8Vy
         Q4hD3LNtYo4V/l5ZlcnWLKnge+KIVJ6fS8OQlNeQXWuPx2jAfcJ1ERruKlFoMqLGZGDt
         FG4XYbAbT/fNp//cg7dpfOgTlxWM+PKfSkQaLQe9r4kE4z4cxBoPub2pGJxt3xwa2Cr4
         UOcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VqcAEV4T2FRNSjsrYhEUCe7efYCzuEHror9AtNeQoqs=;
        b=OkwcStyj2PETA7p91TPdrVMy31jikQE5nKD69+yIzvgmjbKPqb03giI2U0pPTCgREY
         anVp/EUWRXX1UHbAtjoX6sdEKpOVteAzAvCEhHnODoKkgDvz09/IRdBkzsxPKgn0CiZc
         plX+73tkG/nzGnINsJuAyYYdvridROTiCpT/udEWZn+VACyoMgDJPIEkfx7rN0Sw86QO
         Ke5FzomiibRcg2L/i2/WmQ0Wqfkg/lkd7cCjltLo8x4sZlS5dTI5LSsdA2U8wCtPDO80
         Tn/Lrft9RiG2PeJTHwX/gqCUyQNYlFFDbq294TCDyMeZL3RB5jmtQ0F2Lk71nod1jZb/
         eJ1A==
X-Gm-Message-State: APjAAAXLzdF2CJtruvnpxrV3B8AhggrU29az4o5lCobvuZrXdWIIXU8X
        qQchRxsq2BQIzWF+/UCBGXa2Eg==
X-Google-Smtp-Source: APXvYqyB/QBDwCCe3vxL2deTqj+MUeSeyjw++8kDdCZnFL9e5dYNZ7nPfy1pQdCCeO3Y2gFMLV/mpg==
X-Received: by 2002:adf:d4c2:: with SMTP id w2mr3037696wrk.167.1558736849598;
        Fri, 24 May 2019 15:27:29 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id y10sm7194961wmg.8.2019.05.24.15.27.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 May 2019 15:27:28 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v9 bpf-next 07/17] bpf: verifier: randomize high 32-bit when BPF_F_TEST_RND_HI32 is set
Date:   Fri, 24 May 2019 23:25:18 +0100
Message-Id: <1558736728-7229-8-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558736728-7229-1-git-send-email-jiong.wang@netronome.com>
References: <1558736728-7229-1-git-send-email-jiong.wang@netronome.com>
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

