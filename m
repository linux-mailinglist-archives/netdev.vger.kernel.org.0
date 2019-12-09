Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B7E1174E9
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 19:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfLISwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 13:52:55 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44999 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfLISwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 13:52:55 -0500
Received: by mail-wr1-f67.google.com with SMTP id q10so17384525wrm.11;
        Mon, 09 Dec 2019 10:52:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uY4cn+xIFLZ0Oi5hmbU8L9lvpdrHAajc90wxqBq3LmY=;
        b=eq1mxZg32c83Kjzodfycm7yf+xlFElXlzuFZcbZCX7I0wXR7rm3AaXgjXgphy2S5g2
         umfuF5tPnYDLlxiasuFApdlZFequJCZwRH2ss8BJF5s7nU+UGl6hvyQl3NDzyFR3nNac
         qC+ZtkaDBzECy0/WaBRL2zo8VPaP5GThSl3FnHFYMPX1TlsXYxzgsLbZNFIfIlc5ndPZ
         bMvlqyG1MMz8prJCwOq8ei+SF7/up134GovfMrsdnI3i3Iu5OdEYnwsTCsMRYIdzKbbe
         aRoS0433jP8Pc64mNY5FEaeB3XlJ8XmUETLsy0kxLh5qInVRMhxIS1im6AJdMdkN+AZC
         oEGg==
X-Gm-Message-State: APjAAAWnz+futS/jY2rTWeXlxlR/M6+Nj/G+ZAuBlJWENWkkFXg0Nds8
        H7JgAZ1+y6HrKl43DQBjdC8=
X-Google-Smtp-Source: APXvYqwNShettKgA+gWe7hTfRTlXnGom6hHNhYffFHiwOv6OPhFWKwdvz4bHtVbdJSvPwjDh5fMNuQ==
X-Received: by 2002:a5d:4fd0:: with SMTP id h16mr3575944wrw.255.1575917573091;
        Mon, 09 Dec 2019 10:52:53 -0800 (PST)
Received: from Jitter (lfbn-idf1-1-987-41.w86-238.abo.wanadoo.fr. [86.238.65.41])
        by smtp.gmail.com with ESMTPSA id s10sm438169wrw.12.2019.12.09.10.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 10:52:52 -0800 (PST)
Date:   Mon, 9 Dec 2019 19:52:52 +0100
From:   Paul Chaignon <paul.chaignon@orange.com>
To:     Paul Burton <paulburton@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     Mahshid Khezri <khezri.mahshid@gmail.com>, paul.chaignon@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf 2/2] bpf, mips: limit to 33 tail calls
Message-ID: <b8eb2caac1c25453c539248e56ca22f74b5316af.1575916815.git.paul.chaignon@gmail.com>
References: <cover.1575916815.git.paul.chaignon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1575916815.git.paul.chaignon@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All BPF JIT compilers except RISC-V's and MIPS' enforce a 33-tail calls
limit at runtime.  In addition, a test was recently added, in tailcalls2,
to check this limit.

This patch updates the tail call limit in MIPS' JIT compiler to allow
33 tail calls.

Fixes: b6bd53f9c4e8 ("MIPS: Add missing file for eBPF JIT.")
Reported-by: Mahshid Khezri <khezri.mahshid@gmail.com>
Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>
---
 arch/mips/net/ebpf_jit.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/mips/net/ebpf_jit.c b/arch/mips/net/ebpf_jit.c
index 46b76751f3a5..3ec69d9cbe88 100644
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -604,6 +604,7 @@ static void emit_const_to_reg(struct jit_ctx *ctx, int dst, u64 value)
 static int emit_bpf_tail_call(struct jit_ctx *ctx, int this_idx)
 {
 	int off, b_off;
+	int tcc_reg;
 
 	ctx->flags |= EBPF_SEEN_TC;
 	/*
@@ -616,14 +617,14 @@ static int emit_bpf_tail_call(struct jit_ctx *ctx, int this_idx)
 	b_off = b_imm(this_idx + 1, ctx);
 	emit_instr(ctx, bne, MIPS_R_AT, MIPS_R_ZERO, b_off);
 	/*
-	 * if (--TCC < 0)
+	 * if (TCC-- < 0)
 	 *     goto out;
 	 */
 	/* Delay slot */
-	emit_instr(ctx, daddiu, MIPS_R_T5,
-		   (ctx->flags & EBPF_TCC_IN_V1) ? MIPS_R_V1 : MIPS_R_S4, -1);
+	tcc_reg = (ctx->flags & EBPF_TCC_IN_V1) ? MIPS_R_V1 : MIPS_R_S4;
+	emit_instr(ctx, daddiu, MIPS_R_T5, tcc_reg, -1);
 	b_off = b_imm(this_idx + 1, ctx);
-	emit_instr(ctx, bltz, MIPS_R_T5, b_off);
+	emit_instr(ctx, bltz, tcc_reg, b_off);
 	/*
 	 * prog = array->ptrs[index];
 	 * if (prog == NULL)
-- 
2.17.1

