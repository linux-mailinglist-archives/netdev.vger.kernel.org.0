Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2411F26A3A
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729768AbfEVS4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:56:06 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42168 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729741AbfEVS4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 14:56:04 -0400
Received: by mail-wr1-f66.google.com with SMTP id l2so3465262wrb.9
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 11:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VM5kQ5xTvrcmLaizE6FBV/hPB0ZSdjwt/JEn0M8IaOQ=;
        b=CaUS0zwABgARMnK6mFPGgo6ia4rVXZ8q7672Cp8tXO/G3Hl38pZiql9whud6POTwv+
         HDs+bpx6wNF+QqHhZmTcBifkDDVLYP1ZDzLFBHMK5a5VuDmcJzX9kPnjBbFlutqt9Qr6
         LPxZuKll8YtZyRN7d5wNRseUE830rLeYgDiSDOoNDEfzHCAUsBlsJScJ7Y+9H+bTYo/Y
         JV88Brj72Pu8tnaX8BklvK0zc4ZPtQBS2/x8UbSscT4Pa3M1BGdnaRGnqABSbO8uerlA
         lo3ujeOug46ZSeavzIusn9O+bquPYTMbGSeBVmk/NiSmYOQzxoGN+sw9LvbIE+oabm7e
         +rWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VM5kQ5xTvrcmLaizE6FBV/hPB0ZSdjwt/JEn0M8IaOQ=;
        b=j8A0MYbydDzjklIpWPoDaq5hi0YXYCjsri4ZC422F8ZxUfrIF6N8NHkGZ7hgXrNfkS
         Ke6VJwlaHGks3kmNtTzbLmsuN4ROPJyGXc+yrrWR2ye67Cla4DJW1DCXoMFurt6osFCF
         HB00seBZKPkUDhBjeAeSowOQelIhxHaI1yeVFPIczaqEQe/qg69Y014vzS+D2WBsOkdB
         9JlV3fjba6EelWl0i3zKJixrjFbKUMvztFDt6UP6MszCLC53dd9kLo1aoITsRlrqJtXX
         eyaFpBS5geDec5cCEt6oBmmE7/HOtiSGpZ1y4Z762xjtQ7vVh9kG7hT8vFD0oxIPb0jj
         pH8g==
X-Gm-Message-State: APjAAAUfrNXbt9aFDbpHoRaeuEb9pDS16NLO7fblL4a60Hc4q3n3Q29b
        hga4+7oVhqPPxcqwo2dtD+V+sA==
X-Google-Smtp-Source: APXvYqyRMeAX2oTt+8sUCY8k6sJ0861XQxX1q7qVGyhHZy8nLXGHymhnfgI3zhijMXMtzyD9nWhU7Q==
X-Received: by 2002:a5d:4e41:: with SMTP id r1mr20065764wrt.66.1558551362677;
        Wed, 22 May 2019 11:56:02 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id t12sm16328801wro.2.2019.05.22.11.56.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 22 May 2019 11:56:01 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v7 bpf-next 12/16] s390: bpf: eliminate zero extension code-gen
Date:   Wed, 22 May 2019 19:55:08 +0100
Message-Id: <1558551312-17081-13-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558551312-17081-1-git-send-email-jiong.wang@netronome.com>
References: <1558551312-17081-1-git-send-email-jiong.wang@netronome.com>
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

