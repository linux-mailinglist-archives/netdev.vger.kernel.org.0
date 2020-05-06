Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFBC1C64C7
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 02:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729699AbgEFADf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 20:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729657AbgEFADc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 20:03:32 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D39C061A10
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 17:03:32 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ms17so11019pjb.0
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 17:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Id4q2WjCYOrW61i2K14Kt2NNedsMqfC6xR/4pooTMDs=;
        b=WWgQHX+Y4p9hK1G/FEcHNTzvkaxWU0KQ8imb0c+RIKk5ZSkTMKVkHpqsV715tijoGT
         Z80hmH950M3h4QaqBw3xqEQI7fMdRBGHEKkN82NyEi9jO1C8Z9hczLrQpMZT6/QJ6stu
         UHfCqrxFw4PhETIA/3OdRRpCBlXcKXHPGGpyQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Id4q2WjCYOrW61i2K14Kt2NNedsMqfC6xR/4pooTMDs=;
        b=TztSgRhzJSOARsMjXNHdfBoQob2EGVOwUyVCDdgGSyIx6C8kBR+asgrKlMA+Aaq9oB
         ZA0A81n5cIZE7XChfNKEhx2fn1pSabu3i5xYnNiYdp9wWAzacZWBXfQMGm7DOyzP7j0U
         XaLv0DZnTLIj7oahLDChU2LnUFSPATYQJGca4upJG9pMSBIix9h9M8mGzpY27qg9/dHV
         HPkDTDzCGJ0ANPIREofLPZ7UQ8ayF6Xj3mDUdqch1mC/us55CZU6f1h8W6ipehXXGH5r
         uGrvAfnZOvoYgZHLXnbD4htswxNHfTIajPsJFWzashN+oc3YVcShYZh1om7u7LGLXUfm
         PG1w==
X-Gm-Message-State: AGi0PuavNQLp3TeUuXqKpTfhMhyHL02L4SS6H9Wy/80mQpiI5k/hJu0/
        klWe6dF8MY2Viuogl+4mNUDQCA==
X-Google-Smtp-Source: APiQypIGsXA7WERwt6mP7MtumZ6T6wthtsmMazY24L57aiRfQ7umVKhw5qH3l242C3V99Jnj+CTRdw==
X-Received: by 2002:a17:90b:3751:: with SMTP id ne17mr5833508pjb.114.1588723411567;
        Tue, 05 May 2020 17:03:31 -0700 (PDT)
Received: from localhost.localdomain (c-73-53-94-119.hsd1.wa.comcast.net. [73.53.94.119])
        by smtp.gmail.com with ESMTPSA id u3sm133912pfn.217.2020.05.05.17.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 17:03:31 -0700 (PDT)
From:   Luke Nelson <lukenels@cs.washington.edu>
X-Google-Original-From: Luke Nelson <luke.r.nels@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Luke Nelson <luke.r.nels@gmail.com>, Xi Wang <xi.wang@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, netdev@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 1/4] bpf, riscv: Enable missing verifier_zext optimizations on RV64
Date:   Tue,  5 May 2020 17:03:17 -0700
Message-Id: <20200506000320.28965-2-luke.r.nels@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506000320.28965-1-luke.r.nels@gmail.com>
References: <20200506000320.28965-1-luke.r.nels@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 66d0d5a854a6 ("riscv: bpf: eliminate zero extension code-gen")
added support for the verifier zero-extension optimization on RV64 and
commit 46dd3d7d287b ("bpf, riscv: Enable zext optimization for more
RV64G ALU ops") enabled it for more instruction cases.

However, BPF_LSH BPF_X and BPF_{LSH,RSH,ARSH} BPF_K are still missing
the optimization.

This patch enables the zero-extension optimization for these remaining
cases.

Co-developed-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
---
 arch/riscv/net/bpf_jit_comp64.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index d208a9fd6c52..e2636902a74e 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -515,7 +515,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	case BPF_ALU | BPF_LSH | BPF_X:
 	case BPF_ALU64 | BPF_LSH | BPF_X:
 		emit(is64 ? rv_sll(rd, rd, rs) : rv_sllw(rd, rd, rs), ctx);
-		if (!is64)
+		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_RSH | BPF_X:
@@ -692,19 +692,19 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	case BPF_ALU | BPF_LSH | BPF_K:
 	case BPF_ALU64 | BPF_LSH | BPF_K:
 		emit(is64 ? rv_slli(rd, rd, imm) : rv_slliw(rd, rd, imm), ctx);
-		if (!is64)
+		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_RSH | BPF_K:
 	case BPF_ALU64 | BPF_RSH | BPF_K:
 		emit(is64 ? rv_srli(rd, rd, imm) : rv_srliw(rd, rd, imm), ctx);
-		if (!is64)
+		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 	case BPF_ALU | BPF_ARSH | BPF_K:
 	case BPF_ALU64 | BPF_ARSH | BPF_K:
 		emit(is64 ? rv_srai(rd, rd, imm) : rv_sraiw(rd, rd, imm), ctx);
-		if (!is64)
+		if (!is64 && !aux->verifier_zext)
 			emit_zext_32(rd, ctx);
 		break;
 
-- 
2.17.1

