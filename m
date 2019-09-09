Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB49AE10D
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 00:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbfIIWco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 18:32:44 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:44124 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfIIWcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 18:32:43 -0400
Received: by mail-pf1-f201.google.com with SMTP id b204so11545765pfb.11
        for <netdev@vger.kernel.org>; Mon, 09 Sep 2019 15:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=M+O0NRYJIUOQwM5A2IHz4DriBr4UGq0Iy2y9IwyZH3Y=;
        b=uSSJ/9dBZ4SUH8Vu83YhRkxUrHRiMrFD+WA7dlH97UhoPXhKy+qvRVsO+ZyPiinTQU
         kW2oquEGlQhnHPLYr7SnE5Hjed3eFAE/AON7FSZqmaqgDhmgDQHrhljk4122UnH/Zqbe
         0POY/rndGLopqMAisGTRXR9NO7kWf1hrTA/bkwAirAJIwYthVB5j5F8G0bXWxoIEi34w
         T1umkO9uwS4rgiGR5SVtwNBeH+FIbX4Bzy7dyei1tu7Tyx1pKaZqi3sLNMUWst1ZkfKm
         zKdqIfkYW0ENInQpeOCbg9au+eoaAc+mib239FrA3O8lkyFzF2Hh2NtE97JuvzrVFGmK
         ySjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=M+O0NRYJIUOQwM5A2IHz4DriBr4UGq0Iy2y9IwyZH3Y=;
        b=WBWMtL+HkI2M/IacwoAcO3iJQdiIkdIHKyGDabMSbAbm6htEoPk0qOmiIttt8ZxmpC
         lGkzGYbm0JgHNcr13Cy923L1IdMSrmdUOPi5MkKaXeo2h6ZsIFLjasOz5lWZCjjhK9lf
         oxH6tGcYVmkBoNliRR3mKlQt/DV4Ur1uTP+urm20pSFB48YkYdg3/b5rJLPDwvDVMd6O
         UtTboH9xySlojSnAM/mNenbln7sQtDddiGBSVEbf88mnEUTpazd5RzXRvkkU8o5Tlham
         7JbQObF+zhy8+y+DRFGa9IRKP8uThHBwAPclUTV6VHIq22Um3jP0qyOHPYQvKiWQkG5f
         faXw==
X-Gm-Message-State: APjAAAU8qhhKeboE2ElbEkuMjwiQ2kiReOrw4no4dU0A+wNcIWkKMnaa
        xATaR++Q3pT+wOrYCm0IDqXSPCiaUBmS51i0r/0=
X-Google-Smtp-Source: APXvYqxTeuYy2NwZex38o5nWcQCCKjZAMdZMxGFCfwQtbMikQBtzHTJqIJzQOMfqvPkqbuZsurBUBmTO57nF9ip9+eE=
X-Received: by 2002:a63:f048:: with SMTP id s8mr23767917pgj.26.1568068361073;
 Mon, 09 Sep 2019 15:32:41 -0700 (PDT)
Date:   Mon,  9 Sep 2019 15:32:36 -0700
Message-Id: <20190909223236.157099-1-samitolvanen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.162.g0b9fbb3734-goog
Subject: [PATCH] bpf: validate bpf_func when BPF_JIT is enabled
From:   Sami Tolvanen <samitolvanen@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Kees Cook <keescook@chromium.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With CONFIG_BPF_JIT, the kernel makes indirect calls to dynamically
generated code. This change adds basic sanity checking to ensure
we are jumping to a valid location, which narrows down the attack
surface on the stored pointer. This also prepares the code for future
Control-Flow Integrity (CFI) checking, which adds indirect call
validation to call targets that can be determined at compile-time, but
cannot validate calls to jited functions.

In addition, this change adds a weak arch_bpf_jit_check_func function,
which architectures that implement BPF JIT can override to perform
additional validation, such as verifying that the pointer points to
the correct memory region.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 include/linux/filter.h | 26 ++++++++++++++++++++++++--
 kernel/bpf/core.c      | 25 +++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 92c6e31fb008..abfb0e1b21a8 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -511,7 +511,10 @@ struct sock_fprog_kern {
 	struct sock_filter	*filter;
 };
 
+#define BPF_BINARY_HEADER_MAGIC	0x05de0e82
+
 struct bpf_binary_header {
+	u32 magic;
 	u32 pages;
 	/* Some arches need word alignment for their instructions */
 	u8 image[] __aligned(4);
@@ -553,20 +556,39 @@ struct sk_filter {
 
 DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
 
+#ifdef CONFIG_BPF_JIT
+/*
+ * With JIT, the kernel makes an indirect call to dynamically generated
+ * code. Use bpf_call_func to perform additional validation of the call
+ * target to narrow down attack surface. Architectures implementing BPF
+ * JIT can override arch_bpf_jit_check_func for arch-specific checking.
+ */
+extern unsigned int bpf_call_func(const struct bpf_prog *prog,
+				  const void *ctx);
+
+extern bool arch_bpf_jit_check_func(const struct bpf_prog *prog);
+#else
+static inline unsigned int bpf_call_func(const struct bpf_prog *prog,
+					 const void *ctx)
+{
+	return prog->bpf_func(ctx, prog->insnsi);
+}
+#endif
+
 #define BPF_PROG_RUN(prog, ctx)	({				\
 	u32 ret;						\
 	cant_sleep();						\
 	if (static_branch_unlikely(&bpf_stats_enabled_key)) {	\
 		struct bpf_prog_stats *stats;			\
 		u64 start = sched_clock();			\
-		ret = (*(prog)->bpf_func)(ctx, (prog)->insnsi);	\
+		ret = bpf_call_func(prog, ctx);			\
 		stats = this_cpu_ptr(prog->aux->stats);		\
 		u64_stats_update_begin(&stats->syncp);		\
 		stats->cnt++;					\
 		stats->nsecs += sched_clock() - start;		\
 		u64_stats_update_end(&stats->syncp);		\
 	} else {						\
-		ret = (*(prog)->bpf_func)(ctx, (prog)->insnsi);	\
+		ret = bpf_call_func(prog, ctx);			\
 	}							\
 	ret; })
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 66088a9e9b9e..7aad58f67105 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -792,6 +792,30 @@ void __weak bpf_jit_free_exec(void *addr)
 	module_memfree(addr);
 }
 
+#ifdef CONFIG_BPF_JIT
+bool __weak arch_bpf_jit_check_func(const struct bpf_prog *prog)
+{
+	return true;
+}
+
+unsigned int bpf_call_func(const struct bpf_prog *prog, const void *ctx)
+{
+	const struct bpf_binary_header *hdr = bpf_jit_binary_hdr(prog);
+
+	if (!IS_ENABLED(CONFIG_BPF_JIT_ALWAYS_ON) && !prog->jited)
+		return prog->bpf_func(ctx, prog->insnsi);
+
+	if (unlikely(hdr->magic != BPF_BINARY_HEADER_MAGIC ||
+		     !arch_bpf_jit_check_func(prog))) {
+		WARN(1, "attempt to jump to an invalid address");
+		return 0;
+	}
+
+	return prog->bpf_func(ctx, prog->insnsi);
+}
+EXPORT_SYMBOL_GPL(bpf_call_func);
+#endif
+
 struct bpf_binary_header *
 bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
 		     unsigned int alignment,
@@ -818,6 +842,7 @@ bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
 	/* Fill space with illegal/arch-dep instructions. */
 	bpf_fill_ill_insns(hdr, size);
 
+	hdr->magic = BPF_BINARY_HEADER_MAGIC;
 	hdr->pages = pages;
 	hole = min_t(unsigned int, size - (proglen + sizeof(*hdr)),
 		     PAGE_SIZE - sizeof(*hdr));
-- 
2.23.0.162.g0b9fbb3734-goog

