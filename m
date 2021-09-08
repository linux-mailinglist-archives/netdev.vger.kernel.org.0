Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F38B403F62
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 21:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350409AbhIHTH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 15:07:26 -0400
Received: from home.keithp.com ([63.227.221.253]:35456 "EHLO elaine.keithp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350339AbhIHTHX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 15:07:23 -0400
Received: from localhost (localhost [127.0.0.1])
        by elaine.keithp.com (Postfix) with ESMTP id 5A9873F30881;
        Wed,  8 Sep 2021 12:05:48 -0700 (PDT)
X-Virus-Scanned: Debian amavisd-new at keithp.com
Received: from elaine.keithp.com ([127.0.0.1])
        by localhost (elaine.keithp.com [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id VY1FZb1c7sU8; Wed,  8 Sep 2021 12:05:47 -0700 (PDT)
Received: from keithp.com (168-103-156-98.tukw.qwest.net [168.103.156.98])
        by elaine.keithp.com (Postfix) with ESMTPSA id 56FE93F30883;
        Wed,  8 Sep 2021 12:05:47 -0700 (PDT)
Received: by keithp.com (Postfix, from userid 1000)
        id 50A2E1E60122; Wed,  8 Sep 2021 12:06:09 -0700 (PDT)
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
Subject: [PATCH v4 1/7] ARM: Pass cpu number to secondary_start_kernel
Date:   Wed,  8 Sep 2021 12:05:59 -0700
Message-Id: <20210908190605.419064-2-keithpac@amazon.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210908190605.419064-1-keithpac@amazon.com>
References: <id:20210907220038.91021-1-keithpac@amazon.com>
 <20210908190605.419064-1-keithpac@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of pulling the CPU value out of the thread_info struct, pass
it as an argument. When first initializing secondary processors, this
is done by stashing the value in the secondary_data struct. When
restarting idle processors, the previous CPU value is passed.

Because the cpu is now known at the top of secondary_start_kernel, the
per_cpu_offset value can now be set at this point, instead of in
cpu_init where it was also incorrectly setting the per_cpu_offset for
the boot processor before that value had been computed.

Signed-off-by: Keith Packard <keithpac@amazon.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/include/asm/smp.h   |  3 ++-
 arch/arm/kernel/head-nommu.S |  1 +
 arch/arm/kernel/head.S       |  1 +
 arch/arm/kernel/setup.c      |  6 ------
 arch/arm/kernel/smp.c        | 14 +++++++++-----
 5 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index 5d508f5d56c4..86a7fd721556 100644
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -48,7 +48,7 @@ extern void set_smp_ipi_range(int ipi_base, int nr_ipi);
  * Called from platform specific assembly code, this is the
  * secondary CPU entry point.
  */
-asmlinkage void secondary_start_kernel(void);
+asmlinkage void secondary_start_kernel(unsigned int cpu);
 
 
 /*
@@ -61,6 +61,7 @@ struct secondary_data {
 	};
 	unsigned long swapper_pg_dir;
 	void *stack;
+	unsigned int cpu;
 };
 extern struct secondary_data secondary_data;
 extern void secondary_startup(void);
diff --git a/arch/arm/kernel/head-nommu.S b/arch/arm/kernel/head-nommu.S
index 0fc814bbc34b..5aa8ef42717f 100644
--- a/arch/arm/kernel/head-nommu.S
+++ b/arch/arm/kernel/head-nommu.S
@@ -114,6 +114,7 @@ ENTRY(secondary_startup)
 	add	r12, r12, r10
 	ret	r12
 1:	bl	__after_proc_init
+	ldr	r0, [r7, #16]			@ set up cpu number
 	ldr	sp, [r7, #12]			@ set up the stack pointer
 	mov	fp, #0
 	b	secondary_start_kernel
diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 7f62c5eccdf3..0e541af738e2 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -394,6 +394,7 @@ ENDPROC(secondary_startup_arm)
 
 ENTRY(__secondary_switched)
 	ldr_l	r7, secondary_data + 12		@ get secondary_data.stack
+	ldr_l	r0, secondary_data + 16		@ get secondary_data.cpu
 	mov	sp, r7
 	mov	fp, #0
 	b	secondary_start_kernel
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 73ca7797b92f..ca0201635fac 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -532,12 +532,6 @@ void notrace cpu_init(void)
 		BUG();
 	}
 
-	/*
-	 * This only works on resume and secondary cores. For booting on the
-	 * boot cpu, smp_prepare_boot_cpu is called after percpu area setup.
-	 */
-	set_my_cpu_offset(per_cpu_offset(cpu));
-
 	cpu_proc_init();
 
 	/*
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 74679240a9d8..55cb1689a4b3 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -153,6 +153,7 @@ int __cpu_up(unsigned int cpu, struct task_struct *idle)
 	secondary_data.pgdir = virt_to_phys(idmap_pgd);
 	secondary_data.swapper_pg_dir = get_arch_pgd(swapper_pg_dir);
 #endif
+	secondary_data.cpu = cpu;
 	sync_cache_w(&secondary_data);
 
 	/*
@@ -373,11 +374,14 @@ void arch_cpu_idle_dead(void)
 	 * cpu initialisation.  There's some initialisation which needs
 	 * to be repeated to undo the effects of taking the CPU offline.
 	 */
-	__asm__("mov	sp, %0\n"
+	__asm__("mov	r0, %1\n"
+	"	mov	sp, %0\n"
 	"	mov	fp, #0\n"
 	"	b	secondary_start_kernel"
 		:
-		: "r" (task_stack_page(current) + THREAD_SIZE - 8));
+		: "r" (task_stack_page(current) + THREAD_SIZE - 8),
+		  "r" (cpu)
+		: "r0");
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
@@ -400,10 +404,11 @@ static void smp_store_cpu_info(unsigned int cpuid)
  * This is the secondary CPU boot entry.  We're using this CPUs
  * idle thread stack, but a set of temporary page tables.
  */
-asmlinkage void secondary_start_kernel(void)
+asmlinkage void secondary_start_kernel(unsigned int cpu)
 {
 	struct mm_struct *mm = &init_mm;
-	unsigned int cpu;
+
+	set_my_cpu_offset(per_cpu_offset(cpu));
 
 	secondary_biglittle_init();
 
@@ -420,7 +425,6 @@ asmlinkage void secondary_start_kernel(void)
 	 * All kernel threads share the same mm context; grab a
 	 * reference and switch to it.
 	 */
-	cpu = smp_processor_id();
 	mmgrab(mm);
 	current->active_mm = mm;
 	cpumask_set_cpu(cpu, mm_cpumask(mm));
-- 
2.33.0

