Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 997CC8A9F1
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbfHLVwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:52:40 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:52431 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727577AbfHLVwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 17:52:38 -0400
Received: by mail-pg1-f202.google.com with SMTP id h3so65405393pgc.19
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 14:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nhdP3qLGadfkBXXgzu2XRajPFFK4fSn/Au7TvOHqv+g=;
        b=l0vrvwIHmSzOktb7Rq3EdrK6pdsP3Ma3RCqx5BQ6NP0yweIZWAU2Q/lHhoKvWSxp6n
         hb/8hiCQkymuV+MMOHey9h69MdrERLD0hZ/gfrxdEVFUhiSHtWnAoQhOg6NXS1/OG/rA
         9o28P2Qois3wr22QlsgANra7Ffshp6GNOzF/SQl3ww6PwmpI9RZSp1Zd+eSsUyOy8Xh9
         8/gU6pTbRK5x5aBYeVeLkGgRxNa6mKkBFuZUTSejia6ABf36q3l92lLkASTPqArWoGUx
         FVz/lju2Dg6bsdjVY2St8Tc9hDr5mfAQ/LOxOKiurkoCnULUdwHJkriMSFsS0OH/LIWd
         78Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nhdP3qLGadfkBXXgzu2XRajPFFK4fSn/Au7TvOHqv+g=;
        b=thw2V53ZUDkrfRvwIcwO9UjDt3ziLSuwutlzgbe1tc0WbOoEgSK2yHsSN0ZYgp8SSU
         yBwt++isDeblV2d1wx8+V3edm/NJwF9jvn8bAOtcvRw4qfrcaoTwKaX1vnVbuf2Vfm16
         s/ORaVoMYSC4WjiKtIRS/Bk6yWQOtRSjM9qPqiUmOrnN6et+hQWTq7uVWdjYSXtXVldp
         jASL9cjJhByRhfnp4u5GGxI3t0kiTi21nLkjtkubc51/gvi/zE5nYo1DpN+vN+jIgtmr
         OHyVk1oAJH+B3WIT9WTFEUjG7jMhjbhQvQGb4hGA7Oj5Th3fTOv28363jQTPm/lxuemf
         ZjCg==
X-Gm-Message-State: APjAAAXB1x3YQcn4/w9M3+Iq5uX4eK5NB2DVVz2Xp7wwjV612etEvUta
        r6uTDiXelT5EIs4cj66npimVkqP1CY1J27Zf+xM=
X-Google-Smtp-Source: APXvYqwjy4xajDSecFizcMZwjTAAh0pv2jT2DdR94TnRtiSiK/C8DMNalg6ERPgxV3Xo/RWyTVhpKrSzLDDIluqa8Bk=
X-Received: by 2002:a65:6406:: with SMTP id a6mr26645041pgv.393.1565646757703;
 Mon, 12 Aug 2019 14:52:37 -0700 (PDT)
Date:   Mon, 12 Aug 2019 14:50:44 -0700
In-Reply-To: <20190812215052.71840-1-ndesaulniers@google.com>
Message-Id: <20190812215052.71840-11-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20190812215052.71840-1-ndesaulniers@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH 11/16] x86: prefer __section from compiler_attributes.h
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     akpm@linux-foundation.org
Cc:     sedat.dilek@gmail.com, jpoimboe@redhat.com, yhs@fb.com,
        miguel.ojeda.sandonis@gmail.com,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Armijn Hemel <armijn@tjaldur.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Juergen Gross <jgross@suse.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Enrico Weigelt <info@metux.net>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Hannes Reinecke <hare@suse.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Pu Wen <puwen@hygon.cn>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 arch/x86/include/asm/cache.h       | 2 +-
 arch/x86/include/asm/intel-mid.h   | 2 +-
 arch/x86/include/asm/iommu_table.h | 5 ++---
 arch/x86/include/asm/irqflags.h    | 2 +-
 arch/x86/include/asm/mem_encrypt.h | 2 +-
 arch/x86/kernel/cpu/cpu.h          | 3 +--
 6 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/cache.h b/arch/x86/include/asm/cache.h
index abe08690a887..bb9f4bf4ec02 100644
--- a/arch/x86/include/asm/cache.h
+++ b/arch/x86/include/asm/cache.h
@@ -8,7 +8,7 @@
 #define L1_CACHE_SHIFT	(CONFIG_X86_L1_CACHE_SHIFT)
 #define L1_CACHE_BYTES	(1 << L1_CACHE_SHIFT)
 
-#define __read_mostly __attribute__((__section__(".data..read_mostly")))
+#define __read_mostly __section(.data..read_mostly)
 
 #define INTERNODE_CACHE_SHIFT CONFIG_X86_INTERNODE_CACHE_SHIFT
 #define INTERNODE_CACHE_BYTES (1 << INTERNODE_CACHE_SHIFT)
diff --git a/arch/x86/include/asm/intel-mid.h b/arch/x86/include/asm/intel-mid.h
index 8e5af119dc2d..f51f04aefe1b 100644
--- a/arch/x86/include/asm/intel-mid.h
+++ b/arch/x86/include/asm/intel-mid.h
@@ -43,7 +43,7 @@ struct devs_id {
 
 #define sfi_device(i)								\
 	static const struct devs_id *const __intel_mid_sfi_##i##_dev __used	\
-	__attribute__((__section__(".x86_intel_mid_dev.init"))) = &i
+	__section(.x86_intel_mid_dev.init) = &i
 
 /**
 * struct mid_sd_board_info - template for SD device creation
diff --git a/arch/x86/include/asm/iommu_table.h b/arch/x86/include/asm/iommu_table.h
index 1fb3fd1a83c2..7d190710eb92 100644
--- a/arch/x86/include/asm/iommu_table.h
+++ b/arch/x86/include/asm/iommu_table.h
@@ -50,9 +50,8 @@ struct iommu_table_entry {
 
 #define __IOMMU_INIT(_detect, _depend, _early_init, _late_init, _finish)\
 	static const struct iommu_table_entry				\
-		__iommu_entry_##_detect __used				\
-	__attribute__ ((unused, __section__(".iommu_table"),		\
-			aligned((sizeof(void *)))))	\
+		__iommu_entry_##_detect __used __section(.iommu_table)	\
+		__aligned((sizeof(void *)))				\
 	= {_detect, _depend, _early_init, _late_init,			\
 	   _finish ? IOMMU_FINISH_IF_DETECTED : 0}
 /*
diff --git a/arch/x86/include/asm/irqflags.h b/arch/x86/include/asm/irqflags.h
index 8a0e56e1dcc9..68db90bca813 100644
--- a/arch/x86/include/asm/irqflags.h
+++ b/arch/x86/include/asm/irqflags.h
@@ -9,7 +9,7 @@
 #include <asm/nospec-branch.h>
 
 /* Provide __cpuidle; we can't safely include <linux/cpu.h> */
-#define __cpuidle __attribute__((__section__(".cpuidle.text")))
+#define __cpuidle __section(.cpuidle.text)
 
 /*
  * Interrupt control:
diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index 0c196c47d621..db2cd3709148 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -50,7 +50,7 @@ void __init mem_encrypt_free_decrypted_mem(void);
 bool sme_active(void);
 bool sev_active(void);
 
-#define __bss_decrypted __attribute__((__section__(".bss..decrypted")))
+#define __bss_decrypted __section(.bss..decrypted)
 
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index c0e2407abdd6..7ff9dc41a603 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -38,8 +38,7 @@ struct _tlb_table {
 
 #define cpu_dev_register(cpu_devX) \
 	static const struct cpu_dev *const __cpu_dev_##cpu_devX __used \
-	__attribute__((__section__(".x86_cpu_dev.init"))) = \
-	&cpu_devX;
+	__section(.x86_cpu_dev.init) = &cpu_devX;
 
 extern const struct cpu_dev *const __x86_cpu_dev_start[],
 			    *const __x86_cpu_dev_end[];
-- 
2.23.0.rc1.153.gdeed80330f-goog

