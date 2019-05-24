Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE492974A
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 13:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391205AbfEXLgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 07:36:02 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52335 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391170AbfEXLgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 07:36:01 -0400
Received: by mail-wm1-f66.google.com with SMTP id y3so9046258wmm.2
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 04:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=f4W5FeA/DW4xIhHK1OTJ3eGyDxNy61HXqBC15p2OIws=;
        b=gO69D6SsNtxbWrKaHCwUa0VOTztaNtgBjaqN0x0vCVCX8/PecmF05j6p7lezjZj2Vb
         XUpW/5jldLujhjIXjXHJyqSeBqbRR4Lp74wIBS3Q4Mw05uzH50aLtPNq5m2/TcClBTDJ
         Tgu+vqPeA8SBdtf/1umBi+/3Z04keouq+w7cwiKAwYfXJcsyvs9DZwklo+asvHF33/qa
         VxZVHbS5g2zx4gmU084bGtG2dVMY4YytNjhA/Qcy+GV1ef9vJFx5wp4/2eLnBNaoeFXf
         GMO9iat42Ku5JKZ6J5ty5GsJcafdLmbOSo5oMqkp1FI2DX/JU6YPlx+lkgVxIQUoBMn5
         szzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=f4W5FeA/DW4xIhHK1OTJ3eGyDxNy61HXqBC15p2OIws=;
        b=J3XJTuMZbRoKQs6Txc/f9K2Kb+P/kYfe3EMtXn41+mC0KWiP7Ar5TSMcoQf1/1YpFA
         SpCGyMQFF14PdBLXkS0YEsNxgr6z6j1qqNHHrZGwqs3CPt16AYJfKaLBnqmIoJzkVJGP
         BEfiOvFgyx2lBBm9VHfZol0ZADVlCh+JCL+v3pxpuJ9z2be7SXPs385T2sV/ECb5rrfB
         BqA8zzpf69PXPOm4/iYTos243kLTNdPD3S/sokGljLriMZJAnhXfNwZZKHiiX5XAnC2O
         Sw0xCgn/9LZNympA+mRimRA47jmW0SM/VM6fGrAAjxsqWzggRGZsspIVxN+i29lpfZEg
         fl9Q==
X-Gm-Message-State: APjAAAX2Dz3Bl9aIaYUzUsWcUCEnj8tuICUItvlL/Patw2DrwyDNlAea
        UKuFmGTEV9PDy14EqJzubHsRVQ==
X-Google-Smtp-Source: APXvYqxCPc3iZk4QtdeO805P3yVzY/dkxZLrB7fq0h3zh/ofHgnpk0sH9iVhq6Aj4Nx1UWWivtC6aw==
X-Received: by 2002:a1c:7ed2:: with SMTP id z201mr15482739wmc.113.1558697758956;
        Fri, 24 May 2019 04:35:58 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id x22sm2462902wmi.4.2019.05.24.04.35.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 May 2019 04:35:58 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v8 bpf-next 11/16] powerpc: bpf: eliminate zero extension code-gen
Date:   Fri, 24 May 2019 12:35:21 +0100
Message-Id: <1558697726-4058-12-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558697726-4058-1-git-send-email-jiong.wang@netronome.com>
References: <1558697726-4058-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cc: Naveen N. Rao <naveen.n.rao@linux.ibm.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 arch/powerpc/net/bpf_jit_comp64.c | 36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 21a1dcd..0ebd946 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -504,6 +504,9 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 		case BPF_ALU | BPF_LSH | BPF_X: /* (u32) dst <<= (u32) src */
 			/* slw clears top 32 bits */
 			PPC_SLW(dst_reg, dst_reg, src_reg);
+			/* skip zero extension move, but set address map. */
+			if (insn_is_zext(&insn[i + 1]))
+				addrs[++i] = ctx->idx * 4;
 			break;
 		case BPF_ALU64 | BPF_LSH | BPF_X: /* dst <<= src; */
 			PPC_SLD(dst_reg, dst_reg, src_reg);
@@ -511,6 +514,8 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 		case BPF_ALU | BPF_LSH | BPF_K: /* (u32) dst <<== (u32) imm */
 			/* with imm 0, we still need to clear top 32 bits */
 			PPC_SLWI(dst_reg, dst_reg, imm);
+			if (insn_is_zext(&insn[i + 1]))
+				addrs[++i] = ctx->idx * 4;
 			break;
 		case BPF_ALU64 | BPF_LSH | BPF_K: /* dst <<== imm */
 			if (imm != 0)
@@ -518,12 +523,16 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 			break;
 		case BPF_ALU | BPF_RSH | BPF_X: /* (u32) dst >>= (u32) src */
 			PPC_SRW(dst_reg, dst_reg, src_reg);
+			if (insn_is_zext(&insn[i + 1]))
+				addrs[++i] = ctx->idx * 4;
 			break;
 		case BPF_ALU64 | BPF_RSH | BPF_X: /* dst >>= src */
 			PPC_SRD(dst_reg, dst_reg, src_reg);
 			break;
 		case BPF_ALU | BPF_RSH | BPF_K: /* (u32) dst >>= (u32) imm */
 			PPC_SRWI(dst_reg, dst_reg, imm);
+			if (insn_is_zext(&insn[i + 1]))
+				addrs[++i] = ctx->idx * 4;
 			break;
 		case BPF_ALU64 | BPF_RSH | BPF_K: /* dst >>= imm */
 			if (imm != 0)
@@ -548,6 +557,11 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 		 */
 		case BPF_ALU | BPF_MOV | BPF_X: /* (u32) dst = src */
 		case BPF_ALU64 | BPF_MOV | BPF_X: /* dst = src */
+			if (imm == 1) {
+				/* special mov32 for zext */
+				PPC_RLWINM(dst_reg, dst_reg, 0, 0, 31);
+				break;
+			}
 			PPC_MR(dst_reg, src_reg);
 			goto bpf_alu32_trunc;
 		case BPF_ALU | BPF_MOV | BPF_K: /* (u32) dst = imm */
@@ -555,11 +569,13 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 			PPC_LI32(dst_reg, imm);
 			if (imm < 0)
 				goto bpf_alu32_trunc;
+			else if (insn_is_zext(&insn[i + 1]))
+				addrs[++i] = ctx->idx * 4;
 			break;
 
 bpf_alu32_trunc:
 		/* Truncate to 32-bits */
-		if (BPF_CLASS(code) == BPF_ALU)
+		if (BPF_CLASS(code) == BPF_ALU && !fp->aux->verifier_zext)
 			PPC_RLWINM(dst_reg, dst_reg, 0, 0, 31);
 		break;
 
@@ -618,10 +634,13 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 			case 16:
 				/* zero-extend 16 bits into 64 bits */
 				PPC_RLDICL(dst_reg, dst_reg, 0, 48);
+				if (insn_is_zext(&insn[i + 1]))
+					addrs[++i] = ctx->idx * 4;
 				break;
 			case 32:
-				/* zero-extend 32 bits into 64 bits */
-				PPC_RLDICL(dst_reg, dst_reg, 0, 32);
+				if (!fp->aux->verifier_zext)
+					/* zero-extend 32 bits into 64 bits */
+					PPC_RLDICL(dst_reg, dst_reg, 0, 32);
 				break;
 			case 64:
 				/* nop */
@@ -698,14 +717,20 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 		/* dst = *(u8 *)(ul) (src + off) */
 		case BPF_LDX | BPF_MEM | BPF_B:
 			PPC_LBZ(dst_reg, src_reg, off);
+			if (insn_is_zext(&insn[i + 1]))
+				addrs[++i] = ctx->idx * 4;
 			break;
 		/* dst = *(u16 *)(ul) (src + off) */
 		case BPF_LDX | BPF_MEM | BPF_H:
 			PPC_LHZ(dst_reg, src_reg, off);
+			if (insn_is_zext(&insn[i + 1]))
+				addrs[++i] = ctx->idx * 4;
 			break;
 		/* dst = *(u32 *)(ul) (src + off) */
 		case BPF_LDX | BPF_MEM | BPF_W:
 			PPC_LWZ(dst_reg, src_reg, off);
+			if (insn_is_zext(&insn[i + 1]))
+				addrs[++i] = ctx->idx * 4;
 			break;
 		/* dst = *(u64 *)(ul) (src + off) */
 		case BPF_LDX | BPF_MEM | BPF_DW:
@@ -1046,6 +1071,11 @@ struct powerpc64_jit_data {
 	struct codegen_context ctx;
 };
 
+bool bpf_jit_needs_zext(void)
+{
+	return true;
+}
+
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 {
 	u32 proglen;
-- 
2.7.4

