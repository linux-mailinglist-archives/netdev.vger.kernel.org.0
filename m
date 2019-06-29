Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99E875A93B
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 07:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbfF2F6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 01:58:33 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42514 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbfF2F6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 01:58:33 -0400
Received: by mail-pg1-f193.google.com with SMTP id t132so158330pgb.9
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 22:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GMz/JGhguuBmadqOwOECmT6KCepFdr2s3LE+nWTPh3U=;
        b=XTI0PbxjV9GUAmdru76Chy3SdUex/Q5BtDeFsQsSeA4+XVP0Tq8GtgeZkPeh5qQi21
         y17iKY29U1z9OC+zfJtDljQFo0sv2gdU2/fm4SmElPr2Sb8TpD00yv1l3bFix6ITcBrd
         2pFEKaMI0D5Uv3iHDpWfbVuWmIkwt1JXrhJJk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GMz/JGhguuBmadqOwOECmT6KCepFdr2s3LE+nWTPh3U=;
        b=q7M+Vz2Zmfb8twog67Yxrws5ii4hnGf3Z188M9Y4lL9k+0OKdklee9KOrCDAFb33Oe
         zqHmk86wxG0sorPEfKRiifcQIFThoWR0afAbnoHLXsfoJtp66e+2gpxjkmSYlRIMMVDT
         VIyWWScycUQSq0K20IZIkzbUijbJjwyDYR3XQJGnabp41b0Mqm2gDpkc23pzSQ8e02lc
         msRhjaiuk2ay+IO9sv2oleXPk+QL0oG6i8vDz8+s79pmZ0EvZJBP5CJextyltRL9C69H
         tle3CW5xFFjUY+fTZH4T0GdZPlWgC7j9wzQnGZj8nMNfS1u6H4xmoaX3jeTrK9JArHa5
         17Gg==
X-Gm-Message-State: APjAAAVsJ5JTh9BcPWvxUiOLbX6N/BKZppJ86U/1i3RslVaYpriWA90w
        f2y71H9GpyTtG3cHHdNKVkNGVw==
X-Google-Smtp-Source: APXvYqxtLsxKjNdwuwXBTjoKMfDKYOao56wA0+Q49Fe8suEbvOUMUrnOASKPsOdgmHk99dJ/XXS7Bw==
X-Received: by 2002:a63:5903:: with SMTP id n3mr8754967pgb.369.1561787912503;
        Fri, 28 Jun 2019 22:58:32 -0700 (PDT)
Received: from ryzen.cs.washington.edu ([2607:4000:200:11:717c:64f7:ecd0:38c2])
        by smtp.gmail.com with ESMTPSA id r3sm3272243pgp.51.2019.06.28.22.58.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 22:58:32 -0700 (PDT)
From:   Luke Nelson <lukenels@cs.washington.edu>
X-Google-Original-From: Luke Nelson <luke.r.nels@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Wang YanQing <udknight@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Shuah Khan <shuah@kernel.org>,
        Jiong Wang <jiong.wang@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf 2/3] bpf, x32: Fix bug with ALU64 {LSH,RSH,ARSH} BPF_K shift by 0
Date:   Fri, 28 Jun 2019 22:57:50 -0700
Message-Id: <20190629055759.28365-2-luke.r.nels@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190629055759.28365-1-luke.r.nels@gmail.com>
References: <20190629055759.28365-1-luke.r.nels@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current x32 BPF JIT does not correctly compile shift operations when
the immediate shift amount is 0. The expected behavior is for this to
be a no-op.

The following program demonstrates the bug. The expexceted result is 1,
but the current JITed code returns 2.

  r0 = 1
  r1 = 1
  r1 <<= 0
  if r1 == 1 goto end
  r0 = 2
end:
  exit

This patch simplifies the code and fixes the bug.

Fixes: 03f5781be2c7 ("bpf, x86_32: add eBPF JIT compiler for ia32")
Co-developed-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
---
 arch/x86/net/bpf_jit_comp32.c | 63 ++++-------------------------------
 1 file changed, 6 insertions(+), 57 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
index f34ef513f4f9..1d12d2174085 100644
--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -894,27 +894,10 @@ static inline void emit_ia32_lsh_i64(const u8 dst[], const u32 val,
 	}
 	/* Do LSH operation */
 	if (val < 32) {
-		/* shl dreg_hi,imm8 */
-		EMIT3(0xC1, add_1reg(0xE0, dreg_hi), val);
-		/* mov ebx,dreg_lo */
-		EMIT2(0x8B, add_2reg(0xC0, dreg_lo, IA32_EBX));
+		/* shld dreg_hi,dreg_lo,imm8 */
+		EMIT4(0x0F, 0xA4, add_2reg(0xC0, dreg_hi, dreg_lo), val);
 		/* shl dreg_lo,imm8 */
 		EMIT3(0xC1, add_1reg(0xE0, dreg_lo), val);
-
-		/* IA32_ECX = 32 - val */
-		/* mov ecx,val */
-		EMIT2(0xB1, val);
-		/* movzx ecx,ecx */
-		EMIT3(0x0F, 0xB6, add_2reg(0xC0, IA32_ECX, IA32_ECX));
-		/* neg ecx */
-		EMIT2(0xF7, add_1reg(0xD8, IA32_ECX));
-		/* add ecx,32 */
-		EMIT3(0x83, add_1reg(0xC0, IA32_ECX), 32);
-
-		/* shr ebx,cl */
-		EMIT2(0xD3, add_1reg(0xE8, IA32_EBX));
-		/* or dreg_hi,ebx */
-		EMIT2(0x09, add_2reg(0xC0, dreg_hi, IA32_EBX));
 	} else if (val >= 32 && val < 64) {
 		u32 value = val - 32;
 
@@ -960,27 +943,10 @@ static inline void emit_ia32_rsh_i64(const u8 dst[], const u32 val,
 
 	/* Do RSH operation */
 	if (val < 32) {
-		/* shr dreg_lo,imm8 */
-		EMIT3(0xC1, add_1reg(0xE8, dreg_lo), val);
-		/* mov ebx,dreg_hi */
-		EMIT2(0x8B, add_2reg(0xC0, dreg_hi, IA32_EBX));
+		/* shrd dreg_lo,dreg_hi,imm8 */
+		EMIT4(0x0F, 0xAC, add_2reg(0xC0, dreg_lo, dreg_hi), val);
 		/* shr dreg_hi,imm8 */
 		EMIT3(0xC1, add_1reg(0xE8, dreg_hi), val);
-
-		/* IA32_ECX = 32 - val */
-		/* mov ecx,val */
-		EMIT2(0xB1, val);
-		/* movzx ecx,ecx */
-		EMIT3(0x0F, 0xB6, add_2reg(0xC0, IA32_ECX, IA32_ECX));
-		/* neg ecx */
-		EMIT2(0xF7, add_1reg(0xD8, IA32_ECX));
-		/* add ecx,32 */
-		EMIT3(0x83, add_1reg(0xC0, IA32_ECX), 32);
-
-		/* shl ebx,cl */
-		EMIT2(0xD3, add_1reg(0xE0, IA32_EBX));
-		/* or dreg_lo,ebx */
-		EMIT2(0x09, add_2reg(0xC0, dreg_lo, IA32_EBX));
 	} else if (val >= 32 && val < 64) {
 		u32 value = val - 32;
 
@@ -1025,27 +991,10 @@ static inline void emit_ia32_arsh_i64(const u8 dst[], const u32 val,
 	}
 	/* Do RSH operation */
 	if (val < 32) {
-		/* shr dreg_lo,imm8 */
-		EMIT3(0xC1, add_1reg(0xE8, dreg_lo), val);
-		/* mov ebx,dreg_hi */
-		EMIT2(0x8B, add_2reg(0xC0, dreg_hi, IA32_EBX));
+		/* shrd dreg_lo,dreg_hi,imm8 */
+		EMIT4(0x0F, 0xAC, add_2reg(0xC0, dreg_lo, dreg_hi), val);
 		/* ashr dreg_hi,imm8 */
 		EMIT3(0xC1, add_1reg(0xF8, dreg_hi), val);
-
-		/* IA32_ECX = 32 - val */
-		/* mov ecx,val */
-		EMIT2(0xB1, val);
-		/* movzx ecx,ecx */
-		EMIT3(0x0F, 0xB6, add_2reg(0xC0, IA32_ECX, IA32_ECX));
-		/* neg ecx */
-		EMIT2(0xF7, add_1reg(0xD8, IA32_ECX));
-		/* add ecx,32 */
-		EMIT3(0x83, add_1reg(0xC0, IA32_ECX), 32);
-
-		/* shl ebx,cl */
-		EMIT2(0xD3, add_1reg(0xE0, IA32_EBX));
-		/* or dreg_lo,ebx */
-		EMIT2(0x09, add_2reg(0xC0, dreg_lo, IA32_EBX));
 	} else if (val >= 32 && val < 64) {
 		u32 value = val - 32;
 
-- 
2.20.1

