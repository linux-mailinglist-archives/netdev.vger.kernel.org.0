Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87E931174E7
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 19:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfLISwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 13:52:10 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35933 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfLISwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 13:52:10 -0500
Received: by mail-wr1-f67.google.com with SMTP id z3so17419579wru.3;
        Mon, 09 Dec 2019 10:52:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VrIn/cd0NBSrjkRI7nYe41MomhmSsm1khFrDSSVuGQw=;
        b=kbBtQJaBeqQkiJhtTzm89chwKGwHH9gV0Z87aSVWpJZqwdwoS3kCeqzKiaInT2k2ie
         11dSU73dvI+v7Fhyz+ttBpXHBngrs1J11SovBTgV0GWs9XKZ19SJ9r1qnkkq9dsMXuLT
         GL25USRK1U375XSNmuZNKwaaxyvz5apfqFCjl2/S7a5sQ7dJxlV4+GRRYoS/E6zMIySL
         DlmdX3mSmn+n4NsfLE815w+NbIjUE5bnmMLTiCgZLoxUq5LQzXeYFu62QswSNzAVYWTt
         PaPSUx441/HMGdiQ7Fd/1Q0RKXDbSCFNscIhrEunGuoRaB9Rl8tM2ir/SjB/QCW3tDbO
         B7vw==
X-Gm-Message-State: APjAAAX3tYYv3Db+er851/sxrWTyY3iTGjCISYrhl7tF7//BgrrtNjdg
        2Ch+nbLyhUxTGNoSjxKVSrY=
X-Google-Smtp-Source: APXvYqxjcictelPS0iEBZ/W/0OeYNDomH1gcmL7U5P8NF/fYdUP5b4FCS3MIQjo+bpTIEsjRhxcgqQ==
X-Received: by 2002:a05:6000:367:: with SMTP id f7mr3675031wrf.174.1575917528356;
        Mon, 09 Dec 2019 10:52:08 -0800 (PST)
Received: from Jitter (lfbn-idf1-1-987-41.w86-238.abo.wanadoo.fr. [86.238.65.41])
        by smtp.gmail.com with ESMTPSA id a14sm394273wrx.81.2019.12.09.10.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 10:52:07 -0800 (PST)
Date:   Mon, 9 Dec 2019 19:52:07 +0100
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
Subject: [PATCH bpf 1/2] bpf, riscv: limit to 33 tail calls
Message-ID: <966fe384383bf23a0ee1efe8d7291c78a3fb832b.1575916815.git.paul.chaignon@gmail.com>
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

This patch updates the tail call limit in RISC-V's JIT compiler to allow
33 tail calls.  I tested it using the above selftest on an emulated
RISCV64.

Fixes: 2353ecc6f91f ("bpf, riscv: add BPF JIT for RV64G")
Reported-by: Mahshid Khezri <khezri.mahshid@gmail.com>
Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>
---
 arch/riscv/net/bpf_jit_comp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
index 5451ef3845f2..7fbf56aab661 100644
--- a/arch/riscv/net/bpf_jit_comp.c
+++ b/arch/riscv/net/bpf_jit_comp.c
@@ -631,14 +631,14 @@ static int emit_bpf_tail_call(int insn, struct rv_jit_context *ctx)
 		return -1;
 	emit(rv_bgeu(RV_REG_A2, RV_REG_T1, off >> 1), ctx);
 
-	/* if (--TCC < 0)
+	/* if (TCC-- < 0)
 	 *     goto out;
 	 */
 	emit(rv_addi(RV_REG_T1, tcc, -1), ctx);
 	off = (tc_ninsn - (ctx->ninsns - start_insn)) << 2;
 	if (is_13b_check(off, insn))
 		return -1;
-	emit(rv_blt(RV_REG_T1, RV_REG_ZERO, off >> 1), ctx);
+	emit(rv_blt(tcc, RV_REG_ZERO, off >> 1), ctx);
 
 	/* prog = array->ptrs[index];
 	 * if (!prog)
-- 
2.17.1

