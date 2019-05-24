Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF9542A13C
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 00:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404508AbfEXW1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 18:27:52 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40366 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404466AbfEXW1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 18:27:38 -0400
Received: by mail-wm1-f66.google.com with SMTP id 15so10556038wmg.5
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 15:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VM5kQ5xTvrcmLaizE6FBV/hPB0ZSdjwt/JEn0M8IaOQ=;
        b=RQDuWdlfYHx07X3S0rBLvVN3lYNpgVK/Hz/xKhvEoEKdEx5KVFdkpRSsPRASE0Dh0J
         iARBm6S5Z+mr3nKHvDxcprfXsIKNk1X47ghB+5HYZHGysBoSBtml31Yt0B05Dy2bJGGj
         yVbkGRajjLxgyf2Seajqedq17vWfyDXPA0/2jK2uQaytj9EJmHTRXfjhl4z0TCJV6ac/
         vqiaS7vGPsbd/+Li+bbZWAeP9Y7w0Rxr20QZBMWqeFagqRYdp+dR75hmx8VlvFDBTRyR
         NnGKEwCgEcJ8snH755Ck3Csil3pRug3p8tXPvdIbmtsknfmRhWu/1KEUpMq53222OYr2
         hlQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VM5kQ5xTvrcmLaizE6FBV/hPB0ZSdjwt/JEn0M8IaOQ=;
        b=QggoJ+zJr2nce6l2bP3qW5Fc/XJqhJXwUQQ8+tPycHNyOCWyMnYe1IedihEsVeKK2l
         jbWsPLKixx01yajoY1p5uF57tSgNc79g7Xaqqtz3bb6Xv/HoJj4eQntlCOmTc/KyzcOF
         vmAOKTqpmLyWU2vZb+WztF/01koj9tq48qv6ZU9mrl3S3QWmB8ANcnzo0psgyTiaCqjM
         1a7/zvLHPqqx7MxOQQV2MxPsRNK/74+q+T7Kj2HU9PGDioZWJaOQ0ecgPBmfR5GCF0IA
         kI5Cat3ef9l8d2RDHwIt/Xn3clt74H6r7BSyg1qucLNnqhBukW4arMeSz2MDd5Bc7VZH
         AssA==
X-Gm-Message-State: APjAAAUalUk3UMoV10GlI7JEwd0CZska/VfF4tdKPPBjXl9NYVBTSPPH
        IBFBH5MsziIVquRtniu125i8QA==
X-Google-Smtp-Source: APXvYqyk5eHbjw8XK6/UwFNXoBnhqY/KvlcdHgY0C9eguTkDd8eWkiAoLFMVFrAAxj+amBqsVjm2oQ==
X-Received: by 2002:a7b:ce1a:: with SMTP id m26mr16680656wmc.137.1558736857359;
        Fri, 24 May 2019 15:27:37 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id y10sm7194961wmg.8.2019.05.24.15.27.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 May 2019 15:27:36 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v9 bpf-next 13/17] s390: bpf: eliminate zero extension code-gen
Date:   Fri, 24 May 2019 23:25:24 +0100
Message-Id: <1558736728-7229-14-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558736728-7229-1-git-send-email-jiong.wang@netronome.com>
References: <1558736728-7229-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 arch/s390/net/bpf_jit_comp.c | 41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 5e7c630..e636728 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -299,9 +299,11 @@ static inline void reg_set_seen(struct bpf_jit *jit, u32 b1)
 
 #define EMIT_ZERO(b1)						\
 ({								\
-	/* llgfr %dst,%dst (zero extend to 64 bit) */		\
-	EMIT4(0xb9160000, b1, b1);				\
-	REG_SET_SEEN(b1);					\
+	if (!fp->aux->verifier_zext) {				\
+		/* llgfr %dst,%dst (zero extend to 64 bit) */	\
+		EMIT4(0xb9160000, b1, b1);			\
+		REG_SET_SEEN(b1);				\
+	}							\
 })
 
 /*
@@ -520,6 +522,8 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp, int i
 	case BPF_ALU | BPF_MOV | BPF_X: /* dst = (u32) src */
 		/* llgfr %dst,%src */
 		EMIT4(0xb9160000, dst_reg, src_reg);
+		if (insn_is_zext(&insn[1]))
+			insn_count = 2;
 		break;
 	case BPF_ALU64 | BPF_MOV | BPF_X: /* dst = src */
 		/* lgr %dst,%src */
@@ -528,6 +532,8 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp, int i
 	case BPF_ALU | BPF_MOV | BPF_K: /* dst = (u32) imm */
 		/* llilf %dst,imm */
 		EMIT6_IMM(0xc00f0000, dst_reg, imm);
+		if (insn_is_zext(&insn[1]))
+			insn_count = 2;
 		break;
 	case BPF_ALU64 | BPF_MOV | BPF_K: /* dst = imm */
 		/* lgfi %dst,imm */
@@ -639,6 +645,8 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp, int i
 		EMIT4(0xb9970000, REG_W0, src_reg);
 		/* llgfr %dst,%rc */
 		EMIT4(0xb9160000, dst_reg, rc_reg);
+		if (insn_is_zext(&insn[1]))
+			insn_count = 2;
 		break;
 	}
 	case BPF_ALU64 | BPF_DIV | BPF_X: /* dst = dst / src */
@@ -676,6 +684,8 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp, int i
 			      EMIT_CONST_U32(imm));
 		/* llgfr %dst,%rc */
 		EMIT4(0xb9160000, dst_reg, rc_reg);
+		if (insn_is_zext(&insn[1]))
+			insn_count = 2;
 		break;
 	}
 	case BPF_ALU64 | BPF_DIV | BPF_K: /* dst = dst / imm */
@@ -864,10 +874,13 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp, int i
 		case 16: /* dst = (u16) cpu_to_be16(dst) */
 			/* llghr %dst,%dst */
 			EMIT4(0xb9850000, dst_reg, dst_reg);
+			if (insn_is_zext(&insn[1]))
+				insn_count = 2;
 			break;
 		case 32: /* dst = (u32) cpu_to_be32(dst) */
-			/* llgfr %dst,%dst */
-			EMIT4(0xb9160000, dst_reg, dst_reg);
+			if (!fp->aux->verifier_zext)
+				/* llgfr %dst,%dst */
+				EMIT4(0xb9160000, dst_reg, dst_reg);
 			break;
 		case 64: /* dst = (u64) cpu_to_be64(dst) */
 			break;
@@ -882,12 +895,15 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp, int i
 			EMIT4_DISP(0x88000000, dst_reg, REG_0, 16);
 			/* llghr %dst,%dst */
 			EMIT4(0xb9850000, dst_reg, dst_reg);
+			if (insn_is_zext(&insn[1]))
+				insn_count = 2;
 			break;
 		case 32: /* dst = (u32) cpu_to_le32(dst) */
 			/* lrvr %dst,%dst */
 			EMIT4(0xb91f0000, dst_reg, dst_reg);
-			/* llgfr %dst,%dst */
-			EMIT4(0xb9160000, dst_reg, dst_reg);
+			if (!fp->aux->verifier_zext)
+				/* llgfr %dst,%dst */
+				EMIT4(0xb9160000, dst_reg, dst_reg);
 			break;
 		case 64: /* dst = (u64) cpu_to_le64(dst) */
 			/* lrvgr %dst,%dst */
@@ -968,16 +984,22 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp, int i
 		/* llgc %dst,0(off,%src) */
 		EMIT6_DISP_LH(0xe3000000, 0x0090, dst_reg, src_reg, REG_0, off);
 		jit->seen |= SEEN_MEM;
+		if (insn_is_zext(&insn[1]))
+			insn_count = 2;
 		break;
 	case BPF_LDX | BPF_MEM | BPF_H: /* dst = *(u16 *)(ul) (src + off) */
 		/* llgh %dst,0(off,%src) */
 		EMIT6_DISP_LH(0xe3000000, 0x0091, dst_reg, src_reg, REG_0, off);
 		jit->seen |= SEEN_MEM;
+		if (insn_is_zext(&insn[1]))
+			insn_count = 2;
 		break;
 	case BPF_LDX | BPF_MEM | BPF_W: /* dst = *(u32 *)(ul) (src + off) */
 		/* llgf %dst,off(%src) */
 		jit->seen |= SEEN_MEM;
 		EMIT6_DISP_LH(0xe3000000, 0x0016, dst_reg, src_reg, REG_0, off);
+		if (insn_is_zext(&insn[1]))
+			insn_count = 2;
 		break;
 	case BPF_LDX | BPF_MEM | BPF_DW: /* dst = *(u64 *)(ul) (src + off) */
 		/* lg %dst,0(off,%src) */
@@ -1282,6 +1304,11 @@ static int bpf_jit_prog(struct bpf_jit *jit, struct bpf_prog *fp)
 	return 0;
 }
 
+bool bpf_jit_needs_zext(void)
+{
+	return true;
+}
+
 /*
  * Compile eBPF program "fp"
  */
-- 
2.7.4

