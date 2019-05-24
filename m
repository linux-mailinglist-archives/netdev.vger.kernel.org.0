Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C93962974B
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 13:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391214AbfEXLgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 07:36:04 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41942 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391186AbfEXLgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 07:36:02 -0400
Received: by mail-wr1-f68.google.com with SMTP id u16so5768129wrn.8
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 04:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VM5kQ5xTvrcmLaizE6FBV/hPB0ZSdjwt/JEn0M8IaOQ=;
        b=HE6HfTwexfhrQYNOVPaPsPOo7yZXf1qVqXe8DqwwtqEgLeny+PH6NJfpVBlWx+wotX
         gaQgoq9AIhpmoOo8gOR39jaKfBY7pDm16RleK41Wtq7sPwqrCPu24v36JAidl8QAtyd6
         6Z3dEL0WYf6Lvkz5TBj3jNldZsspuVqh/GXfrtgH32oRIq40RKh9yaUTRPzH8+6Iky7y
         zhPrcHlR32zxLYYRA2NcyD7I2UkKXdFQVyDMxP2iyo2Ylt7mwHk0/QfhkHVl0fP3g4lw
         XoXfEW44J/fliYO47nu7EoLD+/kNJkcO7vieHz0u786bOB7+CPmtJ5+1YhONaDHKVODq
         VsqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VM5kQ5xTvrcmLaizE6FBV/hPB0ZSdjwt/JEn0M8IaOQ=;
        b=udoZ0FdoWJvZZm44A3Gtro1LQsaCAVmqzJ2zGMLHtoRM++fqXiEgfLtA+PYOeqLRB9
         Ajevu9JtAQ4sZdV/0kiFiIkYzLjZQJ4ltOa2x9qyANREVWyupl81xSwetLRzmfzBqhUg
         HmRWdcHK1NT1DjbnQs9Rep2QRhilGGpm1Y94BHnyzqPQZahSjVjpXLTfYJjvus6Qh9hv
         obvE4cwxuAZHUuo5BeWvo2JS5yJE5fGi44jnCzgI7pD//49eHUcrrOogQiuBlh/Lw26l
         9SN0calH6POQaCzxj4JIFKGRWo1gRzfJKjVndp/yY7ZihI7hX+fTrhZ2tDBZ8bN6dkGp
         onfg==
X-Gm-Message-State: APjAAAUzyjHP0rVr6HGHL5brDjlZOiDpgPY2f+t8GCotBiluEjoBmHnY
        fTbjS9g8m2Bp0TKC/ZhiHNEC6w==
X-Google-Smtp-Source: APXvYqzgp8cu1J5Ud1EIlg5b74eHmTPtlU0Sk0IlxA3jHR02dFNRexkj+YgebR3NeqOJ7k87EHMtjg==
X-Received: by 2002:a05:6000:41:: with SMTP id k1mr32186345wrx.332.1558697760024;
        Fri, 24 May 2019 04:36:00 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id x22sm2462902wmi.4.2019.05.24.04.35.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 May 2019 04:35:59 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v8 bpf-next 12/16] s390: bpf: eliminate zero extension code-gen
Date:   Fri, 24 May 2019 12:35:22 +0100
Message-Id: <1558697726-4058-13-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558697726-4058-1-git-send-email-jiong.wang@netronome.com>
References: <1558697726-4058-1-git-send-email-jiong.wang@netronome.com>
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

