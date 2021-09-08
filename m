Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C440403F69
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 21:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351396AbhIHTHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 15:07:49 -0400
Received: from home.keithp.com ([63.227.221.253]:35810 "EHLO elaine.keithp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350403AbhIHTHb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 15:07:31 -0400
Received: from localhost (localhost [127.0.0.1])
        by elaine.keithp.com (Postfix) with ESMTP id D07AF3F3088E;
        Wed,  8 Sep 2021 12:05:52 -0700 (PDT)
X-Virus-Scanned: Debian amavisd-new at keithp.com
Received: from elaine.keithp.com ([127.0.0.1])
        by localhost (elaine.keithp.com [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id V1Qx1SNyqjFn; Wed,  8 Sep 2021 12:05:52 -0700 (PDT)
Received: from keithp.com (168-103-156-98.tukw.qwest.net [168.103.156.98])
        by elaine.keithp.com (Postfix) with ESMTPSA id 72B553F3088D;
        Wed,  8 Sep 2021 12:05:50 -0700 (PDT)
Received: by keithp.com (Postfix, from userid 1000)
        id 6A4821E6013D; Wed,  8 Sep 2021 12:06:09 -0700 (PDT)
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
Subject: [PATCH v4 7/7] ARM: Move thread_info into task_struct (v7 only)
Date:   Wed,  8 Sep 2021 12:06:05 -0700
Message-Id: <20210908190605.419064-8-keithpac@amazon.com>
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

This avoids many stack overflow attacks which modified the thread_info
structure by moving that into the task_struct as is done is almost all
other architectures.

This also involved removing the 'cpu' member from the thread_info
struct and using the one added to the task_struct instead by the
THREAD_INFO_IN_TASK code.

This code is currently enabled only for v7 hardware as most other ARM
architectures do not have the TPIDRPRW register that is used to
store the current value. It could probably be enabled for v6k
architectures as well, but I haven't tested that.

With the TPIDRPRW register, the kernel can identify the current
cpu. Without that register, there's a circular dependency between the
current cpu and 'current' — know one and you can find the
other. Leaving the thread_info in the kernel stack lets you find the
cpu number independently.

Signed-off-by: Keith Packard <keithpac@amazon.com>
---
 arch/arm/Kconfig                   |  1 +
 arch/arm/include/asm/assembler.h   |  4 ++++
 arch/arm/include/asm/smp.h         |  4 ++++
 arch/arm/include/asm/thread_info.h | 12 +++++++++++-
 arch/arm/kernel/asm-offsets.c      |  4 ++++
 arch/arm/kernel/entry-armv.S       |  4 ++++
 arch/arm/vfp/vfpmodule.c           |  9 +++++++++
 7 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 414fe23fd5ac..5846b4f5444b 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -128,6 +128,7 @@ config ARM
 	select RTC_LIB
 	select SET_FS
 	select SYS_SUPPORTS_APM_EMULATION
+	select THREAD_INFO_IN_TASK if CURRENT_POINTER_IN_TPIDRPRW
 	# Above selects are sorted alphabetically; please add new ones
 	# according to that.  Thanks.
 	help
diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index ea12fe3bb589..b23d2b87184a 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -203,10 +203,14 @@
  * Get current thread_info.
  */
 	.macro	get_thread_info, rd
+#ifdef CONFIG_THREAD_INFO_IN_TASK
+	mrc	p15, 0, \rd, c13, c0, 4
+#else
  ARM(	mov	\rd, sp, lsr #THREAD_SIZE_ORDER + PAGE_SHIFT	)
  THUMB(	mov	\rd, sp			)
  THUMB(	lsr	\rd, \rd, #THREAD_SIZE_ORDER + PAGE_SHIFT	)
 	mov	\rd, \rd, lsl #THREAD_SIZE_ORDER + PAGE_SHIFT
+#endif
 	.endm
 
 /*
diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index d43b64635d77..beb3872645d9 100644
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -15,7 +15,11 @@
 # error "<asm/smp.h> included in non-SMP build"
 #endif
 
+#ifdef CONFIG_THREAD_INFO_IN_TASK
+#define raw_smp_processor_id() (current->cpu)
+#else
 #define raw_smp_processor_id() (current_thread_info()->cpu)
+#endif
 
 struct seq_file;
 
diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index 70d4cbc49ae1..6b67703ca16a 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -55,8 +55,10 @@ struct thread_info {
 	unsigned long		flags;		/* low level flags */
 	int			preempt_count;	/* 0 => preemptable, <0 => bug */
 	mm_segment_t		addr_limit;	/* address limit */
+#ifndef CONFIG_THREAD_INFO_IN_TASK
 	struct task_struct	*task;		/* main task structure */
 	__u32			cpu;		/* cpu */
+#endif
 	__u32			cpu_domain;	/* cpu domain */
 #ifdef CONFIG_STACKPROTECTOR_PER_TASK
 	unsigned long		stack_canary;
@@ -75,14 +77,21 @@ struct thread_info {
 #endif
 };
 
+#ifdef CONFIG_THREAD_INFO_IN_TASK
+#define INIT_THREAD_INFO_TASK(tsk)
+#else
+#define INIT_THREAD_INFO_TASK(tsk) .task = &tsk,
+#endif
+
 #define INIT_THREAD_INFO(tsk)						\
 {									\
-	.task		= &tsk,						\
+	INIT_THREAD_INFO_TASK(tsk)					\
 	.flags		= 0,						\
 	.preempt_count	= INIT_PREEMPT_COUNT,				\
 	.addr_limit	= KERNEL_DS,					\
 }
 
+#ifndef CONFIG_THREAD_INFO_IN_TASK
 /*
  * how to get the thread information struct from C
  */
@@ -93,6 +102,7 @@ static inline struct thread_info *current_thread_info(void)
 	return (struct thread_info *)
 		(current_stack_pointer & ~(THREAD_SIZE - 1));
 }
+#endif
 
 #define thread_saved_pc(tsk)	\
 	((unsigned long)(task_thread_info(tsk)->cpu_context.pc))
diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
index 70993af22d80..2a6745f7423e 100644
--- a/arch/arm/kernel/asm-offsets.c
+++ b/arch/arm/kernel/asm-offsets.c
@@ -44,8 +44,12 @@ int main(void)
   DEFINE(TI_FLAGS,		offsetof(struct thread_info, flags));
   DEFINE(TI_PREEMPT,		offsetof(struct thread_info, preempt_count));
   DEFINE(TI_ADDR_LIMIT,		offsetof(struct thread_info, addr_limit));
+#ifdef CONFIG_THREAD_INFO_IN_TASK
+  DEFINE(TI_CPU,		offsetof(struct task_struct, cpu));
+#else
   DEFINE(TI_TASK,		offsetof(struct thread_info, task));
   DEFINE(TI_CPU,		offsetof(struct thread_info, cpu));
+#endif
   DEFINE(TI_CPU_DOMAIN,		offsetof(struct thread_info, cpu_domain));
   DEFINE(TI_CPU_SAVE,		offsetof(struct thread_info, cpu_context));
   DEFINE(TI_USED_CP,		offsetof(struct thread_info, used_cp));
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index db3947ee9c3e..5ae687c8c7b8 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -762,9 +762,13 @@ ENTRY(__switch_to)
 #endif
 	switch_tls r1, r4, r5, r3, r7
 #ifdef CONFIG_CURRENT_POINTER_IN_TPIDRPRW
+#ifdef CONFIG_THREAD_INFO_IN_TASK
+	set_current r2
+#else
 	ldr	r7, [r2, #TI_TASK]
 	set_current r7
 #endif
+#endif
 #if defined(CONFIG_STACKPROTECTOR) && !defined(CONFIG_SMP)
 	ldr	r7, [r2, #TI_TASK]
 	ldr	r8, =__stack_chk_guard
diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index d7a3818da671..84a691da59fa 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -158,7 +158,12 @@ static void vfp_thread_copy(struct thread_info *thread)
  */
 static int vfp_notifier(struct notifier_block *self, unsigned long cmd, void *v)
 {
+#ifdef CONFIG_THREAD_INFO_IN_TASK
+	struct task_struct *tsk = v;
+	struct thread_info *thread = &tsk->thread_info;
+#else
 	struct thread_info *thread = v;
+#endif
 	u32 fpexc;
 #ifdef CONFIG_SMP
 	unsigned int cpu;
@@ -169,7 +174,11 @@ static int vfp_notifier(struct notifier_block *self, unsigned long cmd, void *v)
 		fpexc = fmrx(FPEXC);
 
 #ifdef CONFIG_SMP
+#ifdef CONFIG_THREAD_INFO_IN_TASK
+		cpu = tsk->cpu;
+#else
 		cpu = thread->cpu;
+#endif
 
 		/*
 		 * On SMP, if VFP is enabled, save the old state in
-- 
2.33.0

