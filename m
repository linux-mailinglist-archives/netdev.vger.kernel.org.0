Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D994440E5
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 12:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhKCL6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 07:58:04 -0400
Received: from mail-lj1-f178.google.com ([209.85.208.178]:35719 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbhKCL6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 07:58:04 -0400
Received: by mail-lj1-f178.google.com with SMTP id 1so3362122ljv.2;
        Wed, 03 Nov 2021 04:55:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=11mAUeEzHYo4WofQQnhX6tKzbvv6UrSSLpN/q7XHPV4=;
        b=aH/8Wn5j72LL3ny8DFPANyReAgyvGnbAQpbuRP6espgrJiMnohqIXDdxvBTHTzIDkM
         h5NmCqr42e4krJfJOzBjWbHK2rg+IFt/CmrMNyLRLOGVbMG8BuslFhOVrm4398+4MkkN
         3rvt0McbTJYx93C2iXW8a4GMa/et9OTznb9P9uDnZawfQvTfAnN1GaGIXWQemFbkWm9K
         sYWU/AoMsmyzW5/QflUlkn9qUsRRWcbt7RqvO1tkDHBfgPuVrKsS0LpUXadZizEl4V5Y
         LDwfHZ+v51NgMdAhMd/CgcPl3x9KNqHB0asy7XF2FgsxwZZNnCF5wQyg2cI7iYCkgXfs
         5LxQ==
X-Gm-Message-State: AOAM532gDtdcbJa57CEVucyQ20sHvzD6W7vrXNo6DvuU6Sb4SvG22TAq
        LPzzRWChrqDBKWNkvylH7xg=
X-Google-Smtp-Source: ABdhPJyPei1aKTKE69u+FCwdajtiXEz9jxZBU//xdhQs7vcHoF3KS+mS4SShXAwvvND1vpqm4oTlug==
X-Received: by 2002:a05:651c:2cf:: with SMTP id f15mr19032566ljo.170.1635940526852;
        Wed, 03 Nov 2021 04:55:26 -0700 (PDT)
Received: from kladdkakan.. (c213-102-90-208.bredband.tele2.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id g18sm161890lfv.25.2021.11.03.04.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 04:55:25 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, tongtiangen@huawei.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        luke.r.nels@gmail.com, xi.wang@gmail.com,
        linux-riscv@lists.infradead.org
Subject: [PATCH bpf-next] riscv, bpf: Fix RV32 broken build, and silence RV64 warning
Date:   Wed,  3 Nov 2021 12:54:53 +0100
Message-Id: <20211103115453.397209-1-bjorn@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 252c765bd764 ("riscv, bpf: Add BPF exception tables") only
addressed RV64, and broke the RV32 build [1]. Fix by gating the exception
tables code with CONFIG_ARCH_RV64I.

Further, silence a "-Wmissing-prototypes" warning [2] in the RV64 BPF
JIT.

[1] https://lore.kernel.org/llvm/202111020610.9oy9Rr0G-lkp@intel.com/
[2] https://lore.kernel.org/llvm/202110290334.2zdMyRq4-lkp@intel.com/

Fixes: 252c765bd764 ("riscv, bpf: Add BPF exception tables")
Signed-off-by: Björn Töpel <bjorn@kernel.org>
---
Tong/Daniel: The RV32 build has been broken since Thursday. I'll try
to fast-track a bit, and commit a quick-fix for it. Hope that's OK
with you, Tong!

I've verified the build on my machine using riscv32 GCC 9.3.0 and
riscv64 GCC 11.2.0.


Björn
---
arch/riscv/mm/extable.c         | 4 ++--
 arch/riscv/net/bpf_jit_comp64.c | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/mm/extable.c b/arch/riscv/mm/extable.c
index 18bf338303b6..ddb7d3b99e89 100644
--- a/arch/riscv/mm/extable.c
+++ b/arch/riscv/mm/extable.c
@@ -11,7 +11,7 @@
 #include <linux/module.h>
 #include <linux/uaccess.h>
 
-#ifdef CONFIG_BPF_JIT
+#if defined(CONFIG_BPF_JIT) && defined(CONFIG_ARCH_RV64I)
 int rv_bpf_fixup_exception(const struct exception_table_entry *ex, struct pt_regs *regs);
 #endif
 
@@ -23,7 +23,7 @@ int fixup_exception(struct pt_regs *regs)
 	if (!fixup)
 		return 0;
 
-#ifdef CONFIG_BPF_JIT
+#if defined(CONFIG_BPF_JIT) && defined(CONFIG_ARCH_RV64I)
 	if (regs->epc >= BPF_JIT_REGION_START && regs->epc < BPF_JIT_REGION_END)
 		return rv_bpf_fixup_exception(fixup, regs);
 #endif
diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 2ca345c7b0bf..f2a779c7e225 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -459,6 +459,8 @@ static int emit_call(bool fixed, u64 addr, struct rv_jit_context *ctx)
 #define BPF_FIXUP_OFFSET_MASK   GENMASK(26, 0)
 #define BPF_FIXUP_REG_MASK      GENMASK(31, 27)
 
+int rv_bpf_fixup_exception(const struct exception_table_entry *ex,
+				struct pt_regs *regs);
 int rv_bpf_fixup_exception(const struct exception_table_entry *ex,
 				struct pt_regs *regs)
 {

base-commit: cc0356d6a02e064387c16a83cb96fe43ef33181e
-- 
2.32.0

