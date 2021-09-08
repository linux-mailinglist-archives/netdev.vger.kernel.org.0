Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC21403F70
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 21:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350096AbhIHTHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 15:07:54 -0400
Received: from home.keithp.com ([63.227.221.253]:35746 "EHLO elaine.keithp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350339AbhIHTHa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 15:07:30 -0400
Received: from localhost (localhost [127.0.0.1])
        by elaine.keithp.com (Postfix) with ESMTP id 4C7193F30884;
        Wed,  8 Sep 2021 12:05:52 -0700 (PDT)
X-Virus-Scanned: Debian amavisd-new at keithp.com
Received: from elaine.keithp.com ([127.0.0.1])
        by localhost (elaine.keithp.com [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id hrJI3NCUC0ro; Wed,  8 Sep 2021 12:05:51 -0700 (PDT)
Received: from keithp.com (168-103-156-98.tukw.qwest.net [168.103.156.98])
        by elaine.keithp.com (Postfix) with ESMTPSA id 2E7DD3F30890;
        Wed,  8 Sep 2021 12:05:49 -0700 (PDT)
Received: by keithp.com (Postfix, from userid 1000)
        id 65CAB1E6013C; Wed,  8 Sep 2021 12:06:09 -0700 (PDT)
From:   Keith Packard <keithpac@amazon.com>
To:     linux-kernel@vger.kernel.org
Cc:     Abbott Liu <liuwenliang@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Ben Segall <bsegall@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        bpf@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Dennis Zhou <dennis@kernel.org>, devicetree@vger.kernel.org,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ingo Molnar <mingo@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Joe Perches <joe@perches.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Keith Packard <keithpac@amazon.com>,
        KP Singh <kpsingh@kernel.org>, kvm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, Manivannan Sadhasivam <mani@kernel.org>,
        Marc Zyngier <maz@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Mel Gorman <mgorman@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Mike Rapoport <rppt@kernel.org>, netdev@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nick Desaulniers <ndesaulniers@gooogle.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Song Liu <songliubraving@fb.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        virtualization@lists.linux-foundation.org,
        "Wolfram Sang (Renesas)" <wsa+renesas@sang-engineering.com>,
        YiFei Zhu <yifeifz2@illinois.edu>, Yonghong Song <yhs@fb.com>
Subject: [PATCH v4 6/7] ARM: Use TPIDRPRW for current
Date:   Wed,  8 Sep 2021 12:06:04 -0700
Message-Id: <20210908190605.419064-7-keithpac@amazon.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210908190605.419064-1-keithpac@amazon.com>
References: <id:20210907220038.91021-1-keithpac@amazon.com>
 <20210908190605.419064-1-keithpac@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Store current task pointer in CPU thread ID register TPIDRPRW so that
accessing it doesn't depend on being able to locate thread_info off of
the kernel stack pointer.

Signed-off-by: Keith Packard <keithpac@amazon.com>
---
 arch/arm/Kconfig                 |  4 +++
 arch/arm/include/asm/assembler.h |  8 +++++
 arch/arm/include/asm/current.h   | 54 ++++++++++++++++++++++++++++++++
 arch/arm/kernel/entry-armv.S     |  4 +++
 arch/arm/kernel/setup.c          |  1 +
 arch/arm/kernel/smp.c            |  1 +
 6 files changed, 72 insertions(+)
 create mode 100644 arch/arm/include/asm/current.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 24804f11302d..414fe23fd5ac 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1172,6 +1172,10 @@ config SMP_ON_UP
 
 	  If you don't know what to do here, say Y.
 
+config CURRENT_POINTER_IN_TPIDRPRW
+	def_bool y
+	depends on (CPU_V6K || CPU_V7) && !CPU_V6
+
 config ARM_CPU_TOPOLOGY
 	bool "Support cpu topology definition"
 	depends on SMP && CPU_V7
diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index e2b1fd558bf3..ea12fe3bb589 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -209,6 +209,14 @@
 	mov	\rd, \rd, lsl #THREAD_SIZE_ORDER + PAGE_SHIFT
 	.endm
 
+/*
+ * Set current task_info
+ * @src: Source register containing task_struct pointer
+ */
+	.macro	set_current src : req
+	mcr	p15, 0, \src, c13, c0, 4
+	.endm
+
 /*
  * Increment/decrement the preempt count.
  */
diff --git a/arch/arm/include/asm/current.h b/arch/arm/include/asm/current.h
new file mode 100644
index 000000000000..ec25737855e5
--- /dev/null
+++ b/arch/arm/include/asm/current.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright © 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ *
+ * Author Keith Packard <keithpac@amazon.com>
+ */
+
+#ifndef _ASM_ARM_CURRENT_H_
+#define _ASM_ARM_CURRENT_H_
+
+#ifndef __ASSEMBLY__
+
+register unsigned long current_stack_pointer asm ("sp");
+
+/*
+ * Same as asm-generic/current.h, except that we store current
+ * in TPIDRPRW. TPIDRPRW only exists on V6K and V7
+ */
+#ifdef CONFIG_CURRENT_POINTER_IN_TPIDRPRW
+
+struct task_struct;
+
+static inline void set_current(struct task_struct *tsk)
+{
+	/* Set TPIDRPRW */
+	asm volatile("mcr p15, 0, %0, c13, c0, 4" : : "r" (tsk) : "memory");
+}
+
+static __always_inline struct task_struct *get_current(void)
+{
+	struct task_struct *tsk;
+
+	/*
+	 * Read TPIDRPRW.
+	 * We want to allow caching the value, so avoid using volatile and
+	 * instead use a fake stack read to hazard against barrier().
+	 */
+	asm("mrc p15, 0, %0, c13, c0, 4" : "=r" (tsk)
+		: "Q" (*(const unsigned long *)current_stack_pointer));
+
+	return tsk;
+}
+#define current get_current()
+#else
+
+#define set_current(tsk) do {} while (0)
+
+#include <asm-generic/current.h>
+
+#endif /* CONFIG_SMP */
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_ARM_CURRENT_H_ */
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 0ea8529a4872..db3947ee9c3e 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -761,6 +761,10 @@ ENTRY(__switch_to)
 	ldr	r6, [r2, #TI_CPU_DOMAIN]
 #endif
 	switch_tls r1, r4, r5, r3, r7
+#ifdef CONFIG_CURRENT_POINTER_IN_TPIDRPRW
+	ldr	r7, [r2, #TI_TASK]
+	set_current r7
+#endif
 #if defined(CONFIG_STACKPROTECTOR) && !defined(CONFIG_SMP)
 	ldr	r7, [r2, #TI_TASK]
 	ldr	r8, =__stack_chk_guard
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index d0dc60afe54f..2fdf8c31d6c9 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -586,6 +586,7 @@ void __init smp_setup_processor_id(void)
 	u32 mpidr = is_smp() ? read_cpuid_mpidr() & MPIDR_HWID_BITMASK : 0;
 	u32 cpu = MPIDR_AFFINITY_LEVEL(mpidr, 0);
 
+	set_current(&init_task);
 	cpu_logical_map(0) = cpu;
 	for (i = 1; i < nr_cpu_ids; ++i)
 		cpu_logical_map(i) = i == cpu ? 0 : i;
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 8ccf10b34f08..09771916442a 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -410,6 +410,7 @@ asmlinkage void secondary_start_kernel(unsigned int cpu, struct task_struct *tas
 {
 	struct mm_struct *mm = &init_mm;
 
+	set_current(task);
 	secondary_biglittle_init();
 
 	/*
-- 
2.33.0

