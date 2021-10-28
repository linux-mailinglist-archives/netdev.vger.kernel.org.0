Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E0643E1F0
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhJ1NXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:23:22 -0400
Received: from mail-lj1-f182.google.com ([209.85.208.182]:33763 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbhJ1NXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 09:23:19 -0400
Received: by mail-lj1-f182.google.com with SMTP id 17so7520573ljq.0;
        Thu, 28 Oct 2021 06:20:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DH8yGhC3Nvprfn3hCny0Vjdm/oIXFS546cCDILMHRkQ=;
        b=AimGwmp7A21Y+p6wKKLv4CurUz6QdesN6YyoOVgKtMM4pgrVWliIE97QaoSDAw7qsF
         LFb3NIZ+sTcSTBs7+mbDKVOfrz/vtuTYH3nBBnsvhRaZJyCAyanL/aGHbOBN8Gu0gp7J
         yRrbOKJlOpijRzzyyEQSQptTxMeNFA7tXfbJb5ho3YiyNZ4SJ1S8nvrsv8IFVYJZi3p5
         ih97JkKv9lXApCZFIIXNwakclUr7emm6S5NixYOP+5zLzrGeTrk1ZvAdOBCt1tcsG1Vc
         z1fmA78URdAdzFGnRDMT0gdzHiwA/+nwuRZbr05rrfVU7GQcUBQFHFitwpqsUqMPvrqA
         qWNg==
X-Gm-Message-State: AOAM53014wr+sbxjySBvkh7q5EQxrifFtMl89sYqvD9fnohDGRhTmsV/
        iKQZV78zOqPHp7p2ioSlHpk=
X-Google-Smtp-Source: ABdhPJy1ng4PVVuyy9CHwlwagSpRIkQogBPHHc5fdz69bIf8M2HrNFhfPRPqwRcP/TZvWBF6sxMeyw==
X-Received: by 2002:a05:651c:88d:: with SMTP id d13mr4607828ljq.399.1635427249412;
        Thu, 28 Oct 2021 06:20:49 -0700 (PDT)
Received: from kladdkakan.. ([185.213.154.234])
        by smtp.gmail.com with ESMTPSA id o9sm309616lfk.292.2021.10.28.06.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 06:20:48 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH bpf-next 3/4] riscv, libbpf: Add RISC-V (RV64) support to bpf_tracing.h
Date:   Thu, 28 Oct 2021 15:20:40 +0200
Message-Id: <20211028132041.516820-4-bjorn@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211028132041.516820-1-bjorn@kernel.org>
References: <20211028132041.516820-1-bjorn@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add macros for 64-bit RISC-V PT_REGS to bpf_tracing.h.

Signed-off-by: Björn Töpel <bjorn@kernel.org>
---
 tools/lib/bpf/bpf_tracing.h | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index d6bfbe009296..db05a5937105 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -24,6 +24,9 @@
 #elif defined(__TARGET_ARCH_sparc)
 	#define bpf_target_sparc
 	#define bpf_target_defined
+#elif defined(__TARGET_ARCH_riscv)
+	#define bpf_target_riscv
+	#define bpf_target_defined
 #else
 
 /* Fall back to what the compiler says */
@@ -48,6 +51,9 @@
 #elif defined(__sparc__)
 	#define bpf_target_sparc
 	#define bpf_target_defined
+#elif defined(__riscv) && __riscv_xlen == 64
+	#define bpf_target_riscv
+	#define bpf_target_defined
 #endif /* no compiler target */
 
 #endif
@@ -288,6 +294,32 @@ struct pt_regs;
 #define PT_REGS_IP_CORE(x) BPF_CORE_READ((x), pc)
 #endif
 
+#elif defined(bpf_target_riscv)
+
+struct pt_regs;
+#define PT_REGS_RV const volatile struct user_regs_struct
+#define PT_REGS_PARM1(x) (((PT_REGS_RV *)(x))->a0)
+#define PT_REGS_PARM2(x) (((PT_REGS_RV *)(x))->a1)
+#define PT_REGS_PARM3(x) (((PT_REGS_RV *)(x))->a2)
+#define PT_REGS_PARM4(x) (((PT_REGS_RV *)(x))->a3)
+#define PT_REGS_PARM5(x) (((PT_REGS_RV *)(x))->a4)
+#define PT_REGS_RET(x) (((PT_REGS_RV *)(x))->ra)
+#define PT_REGS_FP(x) (((PT_REGS_RV *)(x))->s5)
+#define PT_REGS_RC(x) (((PT_REGS_RV *)(x))->a5)
+#define PT_REGS_SP(x) (((PT_REGS_RV *)(x))->sp)
+#define PT_REGS_IP(x) (((PT_REGS_RV *)(x))->epc)
+
+#define PT_REGS_PARM1_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), a0)
+#define PT_REGS_PARM2_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), a1)
+#define PT_REGS_PARM3_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), a2)
+#define PT_REGS_PARM4_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), a3)
+#define PT_REGS_PARM5_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), a4)
+#define PT_REGS_RET_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), ra)
+#define PT_REGS_FP_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), fp)
+#define PT_REGS_RC_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), a5)
+#define PT_REGS_SP_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), sp)
+#define PT_REGS_IP_CORE(x) BPF_CORE_READ((PT_REGS_RV *)(x), epc)
+
 #endif
 
 #if defined(bpf_target_powerpc)
-- 
2.32.0

