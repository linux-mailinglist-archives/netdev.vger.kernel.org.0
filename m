Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A6A328280
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 16:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237235AbhCAPbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 10:31:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:44010 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236663AbhCAPbK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 10:31:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 593D2B11E;
        Mon,  1 Mar 2021 15:30:16 +0000 (UTC)
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH 2/2] MIPS: Remove KVM_TE support
Date:   Mon,  1 Mar 2021 16:29:57 +0100
Message-Id: <20210301152958.3480-2-tsbogend@alpha.franken.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210301152958.3480-1-tsbogend@alpha.franken.de>
References: <20210301152958.3480-1-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After removal of the guest part of KVM TE (trap and emulate), also remove
the host part.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 arch/mips/configs/loongson3_defconfig |    1 -
 arch/mips/include/asm/kvm_host.h      |  238 ----
 arch/mips/kvm/Kconfig                 |   34 -
 arch/mips/kvm/Makefile                |    7 +-
 arch/mips/kvm/commpage.c              |   32 -
 arch/mips/kvm/commpage.h              |   24 -
 arch/mips/kvm/dyntrans.c              |  143 ---
 arch/mips/kvm/emulate.c               | 1688 +------------------------
 arch/mips/kvm/entry.c                 |   33 -
 arch/mips/kvm/interrupt.c             |  123 +-
 arch/mips/kvm/interrupt.h             |   20 -
 arch/mips/kvm/mips.c                  |   68 +-
 arch/mips/kvm/mmu.c                   |  405 ------
 arch/mips/kvm/tlb.c                   |  174 ---
 arch/mips/kvm/trap_emul.c             | 1306 -------------------
 arch/mips/kvm/vz.c                    |    5 +-
 16 files changed, 31 insertions(+), 4270 deletions(-)
 delete mode 100644 arch/mips/kvm/commpage.c
 delete mode 100644 arch/mips/kvm/commpage.h
 delete mode 100644 arch/mips/kvm/dyntrans.c
 delete mode 100644 arch/mips/kvm/trap_emul.c

diff --git a/arch/mips/configs/loongson3_defconfig b/arch/mips/configs/loongson3_defconfig
index 0e79f81217bc..e9081dd3ab20 100644
--- a/arch/mips/configs/loongson3_defconfig
+++ b/arch/mips/configs/loongson3_defconfig
@@ -39,7 +39,6 @@ CONFIG_MIPS32_O32=y
 CONFIG_MIPS32_N32=y
 CONFIG_VIRTUALIZATION=y
 CONFIG_KVM=m
-CONFIG_KVM_MIPS_VZ=y
 CONFIG_MODULES=y
 CONFIG_MODULE_FORCE_LOAD=y
 CONFIG_MODULE_UNLOAD=y
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 3a5612e7304c..603ad562d101 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -88,44 +88,10 @@
 
 #define KVM_HALT_POLL_NS_DEFAULT 500000
 
-#ifdef CONFIG_KVM_MIPS_VZ
 extern unsigned long GUESTID_MASK;
 extern unsigned long GUESTID_FIRST_VERSION;
 extern unsigned long GUESTID_VERSION_MASK;
-#endif
-
-
-/*
- * Special address that contains the comm page, used for reducing # of traps
- * This needs to be within 32Kb of 0x0 (so the zero register can be used), but
- * preferably not at 0x0 so that most kernel NULL pointer dereferences can be
- * caught.
- */
-#define KVM_GUEST_COMMPAGE_ADDR		((PAGE_SIZE > 0x8000) ?	0 : \
-					 (0x8000 - PAGE_SIZE))
 
-#define KVM_GUEST_KERNEL_MODE(vcpu)	((kvm_read_c0_guest_status(vcpu->arch.cop0) & (ST0_EXL | ST0_ERL)) || \
-					((kvm_read_c0_guest_status(vcpu->arch.cop0) & KSU_USER) == 0))
-
-#define KVM_GUEST_KUSEG			0x00000000UL
-#define KVM_GUEST_KSEG0			0x40000000UL
-#define KVM_GUEST_KSEG1			0x40000000UL
-#define KVM_GUEST_KSEG23		0x60000000UL
-#define KVM_GUEST_KSEGX(a)		((_ACAST32_(a)) & 0xe0000000)
-#define KVM_GUEST_CPHYSADDR(a)		((_ACAST32_(a)) & 0x1fffffff)
-
-#define KVM_GUEST_CKSEG0ADDR(a)		(KVM_GUEST_CPHYSADDR(a) | KVM_GUEST_KSEG0)
-#define KVM_GUEST_CKSEG1ADDR(a)		(KVM_GUEST_CPHYSADDR(a) | KVM_GUEST_KSEG1)
-#define KVM_GUEST_CKSEG23ADDR(a)	(KVM_GUEST_CPHYSADDR(a) | KVM_GUEST_KSEG23)
-
-/*
- * Map an address to a certain kernel segment
- */
-#define KVM_GUEST_KSEG0ADDR(a)		(KVM_GUEST_CPHYSADDR(a) | KVM_GUEST_KSEG0)
-#define KVM_GUEST_KSEG1ADDR(a)		(KVM_GUEST_CPHYSADDR(a) | KVM_GUEST_KSEG1)
-#define KVM_GUEST_KSEG23ADDR(a)		(KVM_GUEST_CPHYSADDR(a) | KVM_GUEST_KSEG23)
-
-#define KVM_INVALID_PAGE		0xdeadbeef
 #define KVM_INVALID_ADDR		0xdeadbeef
 
 /*
@@ -165,7 +131,6 @@ struct kvm_vcpu_stat {
 	u64 fpe_exits;
 	u64 msa_disabled_exits;
 	u64 flush_dcache_exits;
-#ifdef CONFIG_KVM_MIPS_VZ
 	u64 vz_gpsi_exits;
 	u64 vz_gsfc_exits;
 	u64 vz_hc_exits;
@@ -176,7 +141,6 @@ struct kvm_vcpu_stat {
 	u64 vz_resvd_exits;
 #ifdef CONFIG_CPU_LOONGSON64
 	u64 vz_cpucfg_exits;
-#endif
 #endif
 	u64 halt_successful_poll;
 	u64 halt_attempted_poll;
@@ -303,14 +267,6 @@ enum emulation_result {
 	EMULATE_HYPERCALL,	/* HYPCALL instruction */
 };
 
-#define mips3_paddr_to_tlbpfn(x) \
-	(((unsigned long)(x) >> MIPS3_PG_SHIFT) & MIPS3_PG_FRAME)
-#define mips3_tlbpfn_to_paddr(x) \
-	((unsigned long)((x) & MIPS3_PG_FRAME) << MIPS3_PG_SHIFT)
-
-#define MIPS3_PG_SHIFT		6
-#define MIPS3_PG_FRAME		0x3fffffc0
-
 #if defined(CONFIG_64BIT)
 #define VPN2_MASK		GENMASK(cpu_vmbits - 1, 13)
 #else
@@ -337,7 +293,6 @@ struct kvm_mips_tlb {
 #define KVM_MIPS_AUX_FPU	0x1
 #define KVM_MIPS_AUX_MSA	0x2
 
-#define KVM_MIPS_GUEST_TLB_SIZE	64
 struct kvm_vcpu_arch {
 	void *guest_ebase;
 	int (*vcpu_run)(struct kvm_vcpu *vcpu);
@@ -370,9 +325,6 @@ struct kvm_vcpu_arch {
 	/* COP0 State */
 	struct mips_coproc *cop0;
 
-	/* Host KSEG0 address of the EI/DI offset */
-	void *kseg0_commpage;
-
 	/* Resume PC after MMIO completion */
 	unsigned long io_pc;
 	/* GPR used as IO source/target */
@@ -398,19 +350,9 @@ struct kvm_vcpu_arch {
 	/* Bitmask of pending exceptions to be cleared */
 	unsigned long pending_exceptions_clr;
 
-	/* S/W Based TLB for guest */
-	struct kvm_mips_tlb guest_tlb[KVM_MIPS_GUEST_TLB_SIZE];
-
-	/* Guest kernel/user [partial] mm */
-	struct mm_struct guest_kernel_mm, guest_user_mm;
-
-	/* Guest ASID of last user mode execution */
-	unsigned int last_user_gasid;
-
 	/* Cache some mmu pages needed inside spinlock regions */
 	struct kvm_mmu_memory_cache mmu_page_cache;
 
-#ifdef CONFIG_KVM_MIPS_VZ
 	/* vcpu's vzguestid is different on each host cpu in an smp system */
 	u32 vzguestid[NR_CPUS];
 
@@ -421,7 +363,6 @@ struct kvm_vcpu_arch {
 
 	/* emulated guest MAAR registers */
 	unsigned long maar[6];
-#endif
 
 	/* Last CPU the VCPU state was loaded on */
 	int last_sched_cpu;
@@ -651,20 +592,6 @@ static inline void kvm_change_##name1(struct mips_coproc *cop0,		\
 	__BUILD_KVM_ATOMIC_SAVED(name, type, _reg, sel)			\
 	__BUILD_KVM_SET_WRAP(c0_guest_##name, sw_gc0_##name, type)
 
-#ifndef CONFIG_KVM_MIPS_VZ
-
-/*
- * T&E (trap & emulate software based virtualisation)
- * We generate the common accessors operating exclusively on the saved context
- * in RAM.
- */
-
-#define __BUILD_KVM_RW_HW	__BUILD_KVM_RW_SW
-#define __BUILD_KVM_SET_HW	__BUILD_KVM_SET_SW
-#define __BUILD_KVM_ATOMIC_HW	__BUILD_KVM_ATOMIC_SW
-
-#else
-
 /*
  * VZ (hardware assisted virtualisation)
  * These macros use the active guest state in VZ mode (hardware registers),
@@ -697,8 +624,6 @@ static inline void kvm_change_##name1(struct mips_coproc *cop0,		\
  */
 #define __BUILD_KVM_ATOMIC_HW	__BUILD_KVM_SET_HW
 
-#endif
-
 /*
  * Define accessors for CP0 registers that are accessible to the guest. These
  * are primarily used by common emulation code, which may need to access the
@@ -874,42 +799,9 @@ void kvm_drop_fpu(struct kvm_vcpu *vcpu);
 void kvm_lose_fpu(struct kvm_vcpu *vcpu);
 
 /* TLB handling */
-u32 kvm_get_kernel_asid(struct kvm_vcpu *vcpu);
-
-u32 kvm_get_user_asid(struct kvm_vcpu *vcpu);
-
-u32 kvm_get_commpage_asid (struct kvm_vcpu *vcpu);
-
-#ifdef CONFIG_KVM_MIPS_VZ
 int kvm_mips_handle_vz_root_tlb_fault(unsigned long badvaddr,
 				      struct kvm_vcpu *vcpu, bool write_fault);
-#endif
-extern int kvm_mips_handle_kseg0_tlb_fault(unsigned long badbaddr,
-					   struct kvm_vcpu *vcpu,
-					   bool write_fault);
-
-extern int kvm_mips_handle_commpage_tlb_fault(unsigned long badvaddr,
-					      struct kvm_vcpu *vcpu);
 
-extern int kvm_mips_handle_mapped_seg_tlb_fault(struct kvm_vcpu *vcpu,
-						struct kvm_mips_tlb *tlb,
-						unsigned long gva,
-						bool write_fault);
-
-extern enum emulation_result kvm_mips_handle_tlbmiss(u32 cause,
-						     u32 *opc,
-						     struct kvm_vcpu *vcpu,
-						     bool write_fault);
-
-extern void kvm_mips_dump_host_tlbs(void);
-extern void kvm_mips_dump_guest_tlbs(struct kvm_vcpu *vcpu);
-extern int kvm_mips_host_tlb_inv(struct kvm_vcpu *vcpu, unsigned long entryhi,
-				 bool user, bool kernel);
-
-extern int kvm_mips_guest_tlb_lookup(struct kvm_vcpu *vcpu,
-				     unsigned long entryhi);
-
-#ifdef CONFIG_KVM_MIPS_VZ
 int kvm_vz_host_tlb_inv(struct kvm_vcpu *vcpu, unsigned long entryhi);
 int kvm_vz_guest_tlb_lookup(struct kvm_vcpu *vcpu, unsigned long gva,
 			    unsigned long *gpa);
@@ -923,48 +815,13 @@ void kvm_vz_load_guesttlb(const struct kvm_mips_tlb *buf, unsigned int index,
 void kvm_loongson_clear_guest_vtlb(void);
 void kvm_loongson_clear_guest_ftlb(void);
 #endif
-#endif
-
-void kvm_mips_suspend_mm(int cpu);
-void kvm_mips_resume_mm(int cpu);
 
 /* MMU handling */
 
-/**
- * enum kvm_mips_flush - Types of MMU flushes.
- * @KMF_USER:	Flush guest user virtual memory mappings.
- *		Guest USeg only.
- * @KMF_KERN:	Flush guest kernel virtual memory mappings.
- *		Guest USeg and KSeg2/3.
- * @KMF_GPA:	Flush guest physical memory mappings.
- *		Also includes KSeg0 if KMF_KERN is set.
- */
-enum kvm_mips_flush {
-	KMF_USER	= 0x0,
-	KMF_KERN	= 0x1,
-	KMF_GPA		= 0x2,
-};
-void kvm_mips_flush_gva_pt(pgd_t *pgd, enum kvm_mips_flush flags);
 bool kvm_mips_flush_gpa_pt(struct kvm *kvm, gfn_t start_gfn, gfn_t end_gfn);
 int kvm_mips_mkclean_gpa_pt(struct kvm *kvm, gfn_t start_gfn, gfn_t end_gfn);
 pgd_t *kvm_pgd_alloc(void);
 void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu);
-void kvm_trap_emul_invalidate_gva(struct kvm_vcpu *vcpu, unsigned long addr,
-				  bool user);
-void kvm_trap_emul_gva_lockless_begin(struct kvm_vcpu *vcpu);
-void kvm_trap_emul_gva_lockless_end(struct kvm_vcpu *vcpu);
-
-enum kvm_mips_fault_result {
-	KVM_MIPS_MAPPED = 0,
-	KVM_MIPS_GVA,
-	KVM_MIPS_GPA,
-	KVM_MIPS_TLB,
-	KVM_MIPS_TLBINV,
-	KVM_MIPS_TLBMOD,
-};
-enum kvm_mips_fault_result kvm_trap_emul_gva_fault(struct kvm_vcpu *vcpu,
-						   unsigned long gva,
-						   bool write);
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 int kvm_unmap_hva_range(struct kvm *kvm,
@@ -974,7 +831,6 @@ int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 
 /* Emulation */
-int kvm_get_inst(u32 *opc, struct kvm_vcpu *vcpu, u32 *out);
 enum emulation_result update_pc(struct kvm_vcpu *vcpu, u32 cause);
 int kvm_get_badinstr(u32 *opc, struct kvm_vcpu *vcpu, u32 *out);
 int kvm_get_badinstrp(u32 *opc, struct kvm_vcpu *vcpu, u32 *out);
@@ -1006,68 +862,6 @@ static inline bool kvm_is_ifetch_fault(struct kvm_vcpu_arch *vcpu)
 	return false;
 }
 
-extern enum emulation_result kvm_mips_emulate_inst(u32 cause,
-						   u32 *opc,
-						   struct kvm_vcpu *vcpu);
-
-long kvm_mips_guest_exception_base(struct kvm_vcpu *vcpu);
-
-extern enum emulation_result kvm_mips_emulate_syscall(u32 cause,
-						      u32 *opc,
-						      struct kvm_vcpu *vcpu);
-
-extern enum emulation_result kvm_mips_emulate_tlbmiss_ld(u32 cause,
-							 u32 *opc,
-							 struct kvm_vcpu *vcpu);
-
-extern enum emulation_result kvm_mips_emulate_tlbinv_ld(u32 cause,
-							u32 *opc,
-							struct kvm_vcpu *vcpu);
-
-extern enum emulation_result kvm_mips_emulate_tlbmiss_st(u32 cause,
-							 u32 *opc,
-							 struct kvm_vcpu *vcpu);
-
-extern enum emulation_result kvm_mips_emulate_tlbinv_st(u32 cause,
-							u32 *opc,
-							struct kvm_vcpu *vcpu);
-
-extern enum emulation_result kvm_mips_emulate_tlbmod(u32 cause,
-						     u32 *opc,
-						     struct kvm_vcpu *vcpu);
-
-extern enum emulation_result kvm_mips_emulate_fpu_exc(u32 cause,
-						      u32 *opc,
-						      struct kvm_vcpu *vcpu);
-
-extern enum emulation_result kvm_mips_handle_ri(u32 cause,
-						u32 *opc,
-						struct kvm_vcpu *vcpu);
-
-extern enum emulation_result kvm_mips_emulate_ri_exc(u32 cause,
-						     u32 *opc,
-						     struct kvm_vcpu *vcpu);
-
-extern enum emulation_result kvm_mips_emulate_bp_exc(u32 cause,
-						     u32 *opc,
-						     struct kvm_vcpu *vcpu);
-
-extern enum emulation_result kvm_mips_emulate_trap_exc(u32 cause,
-						       u32 *opc,
-						       struct kvm_vcpu *vcpu);
-
-extern enum emulation_result kvm_mips_emulate_msafpe_exc(u32 cause,
-							 u32 *opc,
-							 struct kvm_vcpu *vcpu);
-
-extern enum emulation_result kvm_mips_emulate_fpe_exc(u32 cause,
-						      u32 *opc,
-						      struct kvm_vcpu *vcpu);
-
-extern enum emulation_result kvm_mips_emulate_msadis_exc(u32 cause,
-							 u32 *opc,
-							 struct kvm_vcpu *vcpu);
-
 extern enum emulation_result kvm_mips_complete_mmio_load(struct kvm_vcpu *vcpu);
 
 u32 kvm_mips_read_count(struct kvm_vcpu *vcpu);
@@ -1087,26 +881,9 @@ ktime_t kvm_mips_freeze_hrtimer(struct kvm_vcpu *vcpu, u32 *count);
 int kvm_mips_restore_hrtimer(struct kvm_vcpu *vcpu, ktime_t before,
 			     u32 count, int min_drift);
 
-#ifdef CONFIG_KVM_MIPS_VZ
 void kvm_vz_acquire_htimer(struct kvm_vcpu *vcpu);
 void kvm_vz_lose_htimer(struct kvm_vcpu *vcpu);
-#else
-static inline void kvm_vz_acquire_htimer(struct kvm_vcpu *vcpu) {}
-static inline void kvm_vz_lose_htimer(struct kvm_vcpu *vcpu) {}
-#endif
-
-enum emulation_result kvm_mips_check_privilege(u32 cause,
-					       u32 *opc,
-					       struct kvm_vcpu *vcpu);
 
-enum emulation_result kvm_mips_emulate_cache(union mips_instruction inst,
-					     u32 *opc,
-					     u32 cause,
-					     struct kvm_vcpu *vcpu);
-enum emulation_result kvm_mips_emulate_CP0(union mips_instruction inst,
-					   u32 *opc,
-					   u32 cause,
-					   struct kvm_vcpu *vcpu);
 enum emulation_result kvm_mips_emulate_store(union mips_instruction inst,
 					     u32 cause,
 					     struct kvm_vcpu *vcpu);
@@ -1117,27 +894,12 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
 /* COP0 */
 enum emulation_result kvm_mips_emul_wait(struct kvm_vcpu *vcpu);
 
-unsigned int kvm_mips_config1_wrmask(struct kvm_vcpu *vcpu);
-unsigned int kvm_mips_config3_wrmask(struct kvm_vcpu *vcpu);
-unsigned int kvm_mips_config4_wrmask(struct kvm_vcpu *vcpu);
-unsigned int kvm_mips_config5_wrmask(struct kvm_vcpu *vcpu);
-
 /* Hypercalls (hypcall.c) */
 
 enum emulation_result kvm_mips_emul_hypcall(struct kvm_vcpu *vcpu,
 					    union mips_instruction inst);
 int kvm_mips_handle_hypcall(struct kvm_vcpu *vcpu);
 
-/* Dynamic binary translation */
-extern int kvm_mips_trans_cache_index(union mips_instruction inst,
-				      u32 *opc, struct kvm_vcpu *vcpu);
-extern int kvm_mips_trans_cache_va(union mips_instruction inst, u32 *opc,
-				   struct kvm_vcpu *vcpu);
-extern int kvm_mips_trans_mfc0(union mips_instruction inst, u32 *opc,
-			       struct kvm_vcpu *vcpu);
-extern int kvm_mips_trans_mtc0(union mips_instruction inst, u32 *opc,
-			       struct kvm_vcpu *vcpu);
-
 /* Misc */
 extern void kvm_mips_dump_stats(struct kvm_vcpu *vcpu);
 extern unsigned long kvm_mips_get_ramsize(struct kvm *kvm);
diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index 032b3fca6cbb..a77297480f56 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -30,40 +30,6 @@ config KVM
 	help
 	  Support for hosting Guest kernels.
 
-choice
-	prompt "Virtualization mode"
-	depends on KVM
-	default KVM_MIPS_TE
-
-config KVM_MIPS_TE
-	bool "Trap & Emulate"
-	depends on CPU_MIPS32_R2
-	help
-	  Use trap and emulate to virtualize 32-bit guests in user mode. This
-	  does not require any special hardware Virtualization support beyond
-	  standard MIPS32 r2 or later, but it does require the guest kernel
-	  to be configured with CONFIG_KVM_GUEST=y so that it resides in the
-	  user address segment.
-
-config KVM_MIPS_VZ
-	bool "MIPS Virtualization (VZ) ASE"
-	help
-	  Use the MIPS Virtualization (VZ) ASE to virtualize guests. This
-	  supports running unmodified guest kernels (with CONFIG_KVM_GUEST=n),
-	  but requires hardware support.
-
-endchoice
-
-config KVM_MIPS_DYN_TRANS
-	bool "KVM/MIPS: Dynamic binary translation to reduce traps"
-	depends on KVM_MIPS_TE
-	default y
-	help
-	  When running in Trap & Emulate mode patch privileged
-	  instructions to reduce the number of traps.
-
-	  If unsure, say Y.
-
 config KVM_MIPS_DEBUG_COP0_COUNTERS
 	bool "Maintain counters for COP0 accesses"
 	depends on KVM
diff --git a/arch/mips/kvm/Makefile b/arch/mips/kvm/Makefile
index 506c4ac0ba1c..30cc060857c7 100644
--- a/arch/mips/kvm/Makefile
+++ b/arch/mips/kvm/Makefile
@@ -9,7 +9,7 @@ EXTRA_CFLAGS += -Ivirt/kvm -Iarch/mips/kvm
 common-objs-$(CONFIG_CPU_HAS_MSA) += msa.o
 
 kvm-objs := $(common-objs-y) mips.o emulate.o entry.o \
-	    interrupt.o stats.o commpage.o \
+	    interrupt.o stats.o \
 	    fpu.o
 kvm-objs += hypcall.o
 kvm-objs += mmu.o
@@ -17,11 +17,6 @@ ifdef CONFIG_CPU_LOONGSON64
 kvm-objs += loongson_ipi.o
 endif
 
-ifdef CONFIG_KVM_MIPS_VZ
 kvm-objs		+= vz.o
-else
-kvm-objs		+= dyntrans.o
-kvm-objs		+= trap_emul.o
-endif
 obj-$(CONFIG_KVM)	+= kvm.o
 obj-y			+= callback.o tlb.o
diff --git a/arch/mips/kvm/commpage.c b/arch/mips/kvm/commpage.c
deleted file mode 100644
index 5812e6145801..000000000000
--- a/arch/mips/kvm/commpage.c
+++ /dev/null
@@ -1,32 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * commpage, currently used for Virtual COP0 registers.
- * Mapped into the guest kernel @ KVM_GUEST_COMMPAGE_ADDR.
- *
- * Copyright (C) 2012  MIPS Technologies, Inc.  All rights reserved.
- * Authors: Sanjay Lal <sanjayl@kymasys.com>
- */
-
-#include <linux/errno.h>
-#include <linux/err.h>
-#include <linux/vmalloc.h>
-#include <linux/fs.h>
-#include <linux/memblock.h>
-#include <asm/page.h>
-#include <asm/cacheflush.h>
-#include <asm/mmu_context.h>
-
-#include <linux/kvm_host.h>
-
-#include "commpage.h"
-
-void kvm_mips_commpage_init(struct kvm_vcpu *vcpu)
-{
-	struct kvm_mips_commpage *page = vcpu->arch.kseg0_commpage;
-
-	/* Specific init values for fields */
-	vcpu->arch.cop0 = &page->cop0;
-}
diff --git a/arch/mips/kvm/commpage.h b/arch/mips/kvm/commpage.h
deleted file mode 100644
index 08c5fa2bbc0f..000000000000
--- a/arch/mips/kvm/commpage.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * KVM/MIPS: commpage: mapped into get kernel space
- *
- * Copyright (C) 2012  MIPS Technologies, Inc.  All rights reserved.
- * Authors: Sanjay Lal <sanjayl@kymasys.com>
- */
-
-#ifndef __KVM_MIPS_COMMPAGE_H__
-#define __KVM_MIPS_COMMPAGE_H__
-
-struct kvm_mips_commpage {
-	/* COP0 state is mapped into Guest kernel via commpage */
-	struct mips_coproc cop0;
-};
-
-#define KVM_MIPS_COMM_EIDI_OFFSET       0x0
-
-extern void kvm_mips_commpage_init(struct kvm_vcpu *vcpu);
-
-#endif /* __KVM_MIPS_COMMPAGE_H__ */
diff --git a/arch/mips/kvm/dyntrans.c b/arch/mips/kvm/dyntrans.c
deleted file mode 100644
index d77b61b3d6ee..000000000000
--- a/arch/mips/kvm/dyntrans.c
+++ /dev/null
@@ -1,143 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * KVM/MIPS: Binary Patching for privileged instructions, reduces traps.
- *
- * Copyright (C) 2012  MIPS Technologies, Inc.  All rights reserved.
- * Authors: Sanjay Lal <sanjayl@kymasys.com>
- */
-
-#include <linux/errno.h>
-#include <linux/err.h>
-#include <linux/highmem.h>
-#include <linux/kvm_host.h>
-#include <linux/uaccess.h>
-#include <linux/vmalloc.h>
-#include <linux/fs.h>
-#include <linux/memblock.h>
-#include <asm/cacheflush.h>
-
-#include "commpage.h"
-
-/**
- * kvm_mips_trans_replace() - Replace trapping instruction in guest memory.
- * @vcpu:	Virtual CPU.
- * @opc:	PC of instruction to replace.
- * @replace:	Instruction to write
- */
-static int kvm_mips_trans_replace(struct kvm_vcpu *vcpu, u32 *opc,
-				  union mips_instruction replace)
-{
-	unsigned long vaddr = (unsigned long)opc;
-	int err;
-
-retry:
-	/* The GVA page table is still active so use the Linux TLB handlers */
-	kvm_trap_emul_gva_lockless_begin(vcpu);
-	err = put_user(replace.word, opc);
-	kvm_trap_emul_gva_lockless_end(vcpu);
-
-	if (unlikely(err)) {
-		/*
-		 * We write protect clean pages in GVA page table so normal
-		 * Linux TLB mod handler doesn't silently dirty the page.
-		 * Its also possible we raced with a GVA invalidation.
-		 * Try to force the page to become dirty.
-		 */
-		err = kvm_trap_emul_gva_fault(vcpu, vaddr, true);
-		if (unlikely(err)) {
-			kvm_info("%s: Address unwriteable: %p\n",
-				 __func__, opc);
-			return -EFAULT;
-		}
-
-		/*
-		 * Try again. This will likely trigger a TLB refill, which will
-		 * fetch the new dirty entry from the GVA page table, which
-		 * should then succeed.
-		 */
-		goto retry;
-	}
-	__local_flush_icache_user_range(vaddr, vaddr + 4);
-
-	return 0;
-}
-
-int kvm_mips_trans_cache_index(union mips_instruction inst, u32 *opc,
-			       struct kvm_vcpu *vcpu)
-{
-	union mips_instruction nop_inst = { 0 };
-
-	/* Replace the CACHE instruction, with a NOP */
-	return kvm_mips_trans_replace(vcpu, opc, nop_inst);
-}
-
-/*
- * Address based CACHE instructions are transformed into synci(s). A little
- * heavy for just D-cache invalidates, but avoids an expensive trap
- */
-int kvm_mips_trans_cache_va(union mips_instruction inst, u32 *opc,
-			    struct kvm_vcpu *vcpu)
-{
-	union mips_instruction synci_inst = { 0 };
-
-	synci_inst.i_format.opcode = bcond_op;
-	synci_inst.i_format.rs = inst.i_format.rs;
-	synci_inst.i_format.rt = synci_op;
-	if (cpu_has_mips_r6)
-		synci_inst.i_format.simmediate = inst.spec3_format.simmediate;
-	else
-		synci_inst.i_format.simmediate = inst.i_format.simmediate;
-
-	return kvm_mips_trans_replace(vcpu, opc, synci_inst);
-}
-
-int kvm_mips_trans_mfc0(union mips_instruction inst, u32 *opc,
-			struct kvm_vcpu *vcpu)
-{
-	union mips_instruction mfc0_inst = { 0 };
-	u32 rd, sel;
-
-	rd = inst.c0r_format.rd;
-	sel = inst.c0r_format.sel;
-
-	if (rd == MIPS_CP0_ERRCTL && sel == 0) {
-		mfc0_inst.r_format.opcode = spec_op;
-		mfc0_inst.r_format.rd = inst.c0r_format.rt;
-		mfc0_inst.r_format.func = add_op;
-	} else {
-		mfc0_inst.i_format.opcode = lw_op;
-		mfc0_inst.i_format.rt = inst.c0r_format.rt;
-		mfc0_inst.i_format.simmediate = KVM_GUEST_COMMPAGE_ADDR |
-			offsetof(struct kvm_mips_commpage, cop0.reg[rd][sel]);
-#ifdef CONFIG_CPU_BIG_ENDIAN
-		if (sizeof(vcpu->arch.cop0->reg[0][0]) == 8)
-			mfc0_inst.i_format.simmediate |= 4;
-#endif
-	}
-
-	return kvm_mips_trans_replace(vcpu, opc, mfc0_inst);
-}
-
-int kvm_mips_trans_mtc0(union mips_instruction inst, u32 *opc,
-			struct kvm_vcpu *vcpu)
-{
-	union mips_instruction mtc0_inst = { 0 };
-	u32 rd, sel;
-
-	rd = inst.c0r_format.rd;
-	sel = inst.c0r_format.sel;
-
-	mtc0_inst.i_format.opcode = sw_op;
-	mtc0_inst.i_format.rt = inst.c0r_format.rt;
-	mtc0_inst.i_format.simmediate = KVM_GUEST_COMMPAGE_ADDR |
-		offsetof(struct kvm_mips_commpage, cop0.reg[rd][sel]);
-#ifdef CONFIG_CPU_BIG_ENDIAN
-	if (sizeof(vcpu->arch.cop0->reg[0][0]) == 8)
-		mtc0_inst.i_format.simmediate |= 4;
-#endif
-
-	return kvm_mips_trans_replace(vcpu, opc, mtc0_inst);
-}
diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
index d70c4f8e14e2..22e745e49b0a 100644
--- a/arch/mips/kvm/emulate.c
+++ b/arch/mips/kvm/emulate.c
@@ -30,7 +30,6 @@
 #define CONFIG_MIPS_MT
 
 #include "interrupt.h"
-#include "commpage.h"
 
 #include "trace.h"
 
@@ -276,7 +275,8 @@ int kvm_get_badinstr(u32 *opc, struct kvm_vcpu *vcpu, u32 *out)
 		*out = vcpu->arch.host_cp0_badinstr;
 		return 0;
 	} else {
-		return kvm_get_inst(opc, vcpu, out);
+		WARN_ONCE(1, "CPU doesn't have BadInstr register\n");
+		return -EINVAL;
 	}
 }
 
@@ -297,7 +297,8 @@ int kvm_get_badinstrp(u32 *opc, struct kvm_vcpu *vcpu, u32 *out)
 		*out = vcpu->arch.host_cp0_badinstrp;
 		return 0;
 	} else {
-		return kvm_get_inst(opc, vcpu, out);
+		WARN_ONCE(1, "CPU doesn't have BadInstrp register\n");
+		return -EINVAL;
 	}
 }
 
@@ -721,7 +722,7 @@ void kvm_mips_write_compare(struct kvm_vcpu *vcpu, u32 compare, bool ack)
 	 * preemption until the new value is written to prevent restore of a
 	 * GTOffset corresponding to the old CP0_Compare value.
 	 */
-	if (IS_ENABLED(CONFIG_KVM_MIPS_VZ) && delta > 0) {
+	if (delta > 0) {
 		preempt_disable();
 		write_c0_gtoffset(compare - read_c0_count());
 		back_to_back_c0_hazard();
@@ -734,7 +735,7 @@ void kvm_mips_write_compare(struct kvm_vcpu *vcpu, u32 compare, bool ack)
 
 	if (ack)
 		kvm_mips_callbacks->dequeue_timer_int(vcpu);
-	else if (IS_ENABLED(CONFIG_KVM_MIPS_VZ))
+	else
 		/*
 		 * With VZ, writing CP0_Compare acks (clears) CP0_Cause.TI, so
 		 * preserve guest CP0_Cause.TI if we don't want to ack it.
@@ -743,15 +744,13 @@ void kvm_mips_write_compare(struct kvm_vcpu *vcpu, u32 compare, bool ack)
 
 	kvm_write_c0_guest_compare(cop0, compare);
 
-	if (IS_ENABLED(CONFIG_KVM_MIPS_VZ)) {
-		if (delta > 0)
-			preempt_enable();
+	if (delta > 0)
+		preempt_enable();
 
-		back_to_back_c0_hazard();
+	back_to_back_c0_hazard();
 
-		if (!ack && cause & CAUSEF_TI)
-			kvm_write_c0_guest_cause(cop0, cause);
-	}
+	if (!ack && cause & CAUSEF_TI)
+		kvm_write_c0_guest_cause(cop0, cause);
 
 	/* resume_hrtimer() takes care of timer interrupts > count */
 	if (!dc)
@@ -762,7 +761,7 @@ void kvm_mips_write_compare(struct kvm_vcpu *vcpu, u32 compare, bool ack)
 	 * until after the new CP0_Compare is written, otherwise new guest
 	 * CP0_Count could hit new guest CP0_Compare.
 	 */
-	if (IS_ENABLED(CONFIG_KVM_MIPS_VZ) && delta <= 0)
+	if (delta <= 0)
 		write_c0_gtoffset(compare - read_c0_count());
 }
 
@@ -943,29 +942,6 @@ enum hrtimer_restart kvm_mips_count_timeout(struct kvm_vcpu *vcpu)
 	return HRTIMER_RESTART;
 }
 
-enum emulation_result kvm_mips_emul_eret(struct kvm_vcpu *vcpu)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	enum emulation_result er = EMULATE_DONE;
-
-	if (kvm_read_c0_guest_status(cop0) & ST0_ERL) {
-		kvm_clear_c0_guest_status(cop0, ST0_ERL);
-		vcpu->arch.pc = kvm_read_c0_guest_errorepc(cop0);
-	} else if (kvm_read_c0_guest_status(cop0) & ST0_EXL) {
-		kvm_debug("[%#lx] ERET to %#lx\n", vcpu->arch.pc,
-			  kvm_read_c0_guest_epc(cop0));
-		kvm_clear_c0_guest_status(cop0, ST0_EXL);
-		vcpu->arch.pc = kvm_read_c0_guest_epc(cop0);
-
-	} else {
-		kvm_err("[%#lx] ERET when MIPS_SR_EXL|MIPS_SR_ERL == 0\n",
-			vcpu->arch.pc);
-		er = EMULATE_FAIL;
-	}
-
-	return er;
-}
-
 enum emulation_result kvm_mips_emul_wait(struct kvm_vcpu *vcpu)
 {
 	kvm_debug("[%#lx] !!!WAIT!!! (%#lx)\n", vcpu->arch.pc,
@@ -991,609 +967,6 @@ enum emulation_result kvm_mips_emul_wait(struct kvm_vcpu *vcpu)
 	return EMULATE_DONE;
 }
 
-static void kvm_mips_change_entryhi(struct kvm_vcpu *vcpu,
-				    unsigned long entryhi)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	struct mm_struct *kern_mm = &vcpu->arch.guest_kernel_mm;
-	int cpu, i;
-	u32 nasid = entryhi & KVM_ENTRYHI_ASID;
-
-	if (((kvm_read_c0_guest_entryhi(cop0) & KVM_ENTRYHI_ASID) != nasid)) {
-		trace_kvm_asid_change(vcpu, kvm_read_c0_guest_entryhi(cop0) &
-				      KVM_ENTRYHI_ASID, nasid);
-
-		/*
-		 * Flush entries from the GVA page tables.
-		 * Guest user page table will get flushed lazily on re-entry to
-		 * guest user if the guest ASID actually changes.
-		 */
-		kvm_mips_flush_gva_pt(kern_mm->pgd, KMF_KERN);
-
-		/*
-		 * Regenerate/invalidate kernel MMU context.
-		 * The user MMU context will be regenerated lazily on re-entry
-		 * to guest user if the guest ASID actually changes.
-		 */
-		preempt_disable();
-		cpu = smp_processor_id();
-		get_new_mmu_context(kern_mm);
-		for_each_possible_cpu(i)
-			if (i != cpu)
-				set_cpu_context(i, kern_mm, 0);
-		preempt_enable();
-	}
-	kvm_write_c0_guest_entryhi(cop0, entryhi);
-}
-
-enum emulation_result kvm_mips_emul_tlbr(struct kvm_vcpu *vcpu)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	struct kvm_mips_tlb *tlb;
-	unsigned long pc = vcpu->arch.pc;
-	int index;
-
-	index = kvm_read_c0_guest_index(cop0);
-	if (index < 0 || index >= KVM_MIPS_GUEST_TLB_SIZE) {
-		/* UNDEFINED */
-		kvm_debug("[%#lx] TLBR Index %#x out of range\n", pc, index);
-		index &= KVM_MIPS_GUEST_TLB_SIZE - 1;
-	}
-
-	tlb = &vcpu->arch.guest_tlb[index];
-	kvm_write_c0_guest_pagemask(cop0, tlb->tlb_mask);
-	kvm_write_c0_guest_entrylo0(cop0, tlb->tlb_lo[0]);
-	kvm_write_c0_guest_entrylo1(cop0, tlb->tlb_lo[1]);
-	kvm_mips_change_entryhi(vcpu, tlb->tlb_hi);
-
-	return EMULATE_DONE;
-}
-
-/**
- * kvm_mips_invalidate_guest_tlb() - Indicates a change in guest MMU map.
- * @vcpu:	VCPU with changed mappings.
- * @tlb:	TLB entry being removed.
- *
- * This is called to indicate a single change in guest MMU mappings, so that we
- * can arrange TLB flushes on this and other CPUs.
- */
-static void kvm_mips_invalidate_guest_tlb(struct kvm_vcpu *vcpu,
-					  struct kvm_mips_tlb *tlb)
-{
-	struct mm_struct *kern_mm = &vcpu->arch.guest_kernel_mm;
-	struct mm_struct *user_mm = &vcpu->arch.guest_user_mm;
-	int cpu, i;
-	bool user;
-
-	/* No need to flush for entries which are already invalid */
-	if (!((tlb->tlb_lo[0] | tlb->tlb_lo[1]) & ENTRYLO_V))
-		return;
-	/* Don't touch host kernel page tables or TLB mappings */
-	if ((unsigned long)tlb->tlb_hi > 0x7fffffff)
-		return;
-	/* User address space doesn't need flushing for KSeg2/3 changes */
-	user = tlb->tlb_hi < KVM_GUEST_KSEG0;
-
-	preempt_disable();
-
-	/* Invalidate page table entries */
-	kvm_trap_emul_invalidate_gva(vcpu, tlb->tlb_hi & VPN2_MASK, user);
-
-	/*
-	 * Probe the shadow host TLB for the entry being overwritten, if one
-	 * matches, invalidate it
-	 */
-	kvm_mips_host_tlb_inv(vcpu, tlb->tlb_hi, user, true);
-
-	/* Invalidate the whole ASID on other CPUs */
-	cpu = smp_processor_id();
-	for_each_possible_cpu(i) {
-		if (i == cpu)
-			continue;
-		if (user)
-			set_cpu_context(i, user_mm, 0);
-		set_cpu_context(i, kern_mm, 0);
-	}
-
-	preempt_enable();
-}
-
-/* Write Guest TLB Entry @ Index */
-enum emulation_result kvm_mips_emul_tlbwi(struct kvm_vcpu *vcpu)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	int index = kvm_read_c0_guest_index(cop0);
-	struct kvm_mips_tlb *tlb = NULL;
-	unsigned long pc = vcpu->arch.pc;
-
-	if (index < 0 || index >= KVM_MIPS_GUEST_TLB_SIZE) {
-		kvm_debug("%s: illegal index: %d\n", __func__, index);
-		kvm_debug("[%#lx] COP0_TLBWI [%d] (entryhi: %#lx, entrylo0: %#lx entrylo1: %#lx, mask: %#lx)\n",
-			  pc, index, kvm_read_c0_guest_entryhi(cop0),
-			  kvm_read_c0_guest_entrylo0(cop0),
-			  kvm_read_c0_guest_entrylo1(cop0),
-			  kvm_read_c0_guest_pagemask(cop0));
-		index = (index & ~0x80000000) % KVM_MIPS_GUEST_TLB_SIZE;
-	}
-
-	tlb = &vcpu->arch.guest_tlb[index];
-
-	kvm_mips_invalidate_guest_tlb(vcpu, tlb);
-
-	tlb->tlb_mask = kvm_read_c0_guest_pagemask(cop0);
-	tlb->tlb_hi = kvm_read_c0_guest_entryhi(cop0);
-	tlb->tlb_lo[0] = kvm_read_c0_guest_entrylo0(cop0);
-	tlb->tlb_lo[1] = kvm_read_c0_guest_entrylo1(cop0);
-
-	kvm_debug("[%#lx] COP0_TLBWI [%d] (entryhi: %#lx, entrylo0: %#lx entrylo1: %#lx, mask: %#lx)\n",
-		  pc, index, kvm_read_c0_guest_entryhi(cop0),
-		  kvm_read_c0_guest_entrylo0(cop0),
-		  kvm_read_c0_guest_entrylo1(cop0),
-		  kvm_read_c0_guest_pagemask(cop0));
-
-	return EMULATE_DONE;
-}
-
-/* Write Guest TLB Entry @ Random Index */
-enum emulation_result kvm_mips_emul_tlbwr(struct kvm_vcpu *vcpu)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	struct kvm_mips_tlb *tlb = NULL;
-	unsigned long pc = vcpu->arch.pc;
-	int index;
-
-	index = prandom_u32_max(KVM_MIPS_GUEST_TLB_SIZE);
-	tlb = &vcpu->arch.guest_tlb[index];
-
-	kvm_mips_invalidate_guest_tlb(vcpu, tlb);
-
-	tlb->tlb_mask = kvm_read_c0_guest_pagemask(cop0);
-	tlb->tlb_hi = kvm_read_c0_guest_entryhi(cop0);
-	tlb->tlb_lo[0] = kvm_read_c0_guest_entrylo0(cop0);
-	tlb->tlb_lo[1] = kvm_read_c0_guest_entrylo1(cop0);
-
-	kvm_debug("[%#lx] COP0_TLBWR[%d] (entryhi: %#lx, entrylo0: %#lx entrylo1: %#lx)\n",
-		  pc, index, kvm_read_c0_guest_entryhi(cop0),
-		  kvm_read_c0_guest_entrylo0(cop0),
-		  kvm_read_c0_guest_entrylo1(cop0));
-
-	return EMULATE_DONE;
-}
-
-enum emulation_result kvm_mips_emul_tlbp(struct kvm_vcpu *vcpu)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	long entryhi = kvm_read_c0_guest_entryhi(cop0);
-	unsigned long pc = vcpu->arch.pc;
-	int index = -1;
-
-	index = kvm_mips_guest_tlb_lookup(vcpu, entryhi);
-
-	kvm_write_c0_guest_index(cop0, index);
-
-	kvm_debug("[%#lx] COP0_TLBP (entryhi: %#lx), index: %d\n", pc, entryhi,
-		  index);
-
-	return EMULATE_DONE;
-}
-
-/**
- * kvm_mips_config1_wrmask() - Find mask of writable bits in guest Config1
- * @vcpu:	Virtual CPU.
- *
- * Finds the mask of bits which are writable in the guest's Config1 CP0
- * register, by userland (currently read-only to the guest).
- */
-unsigned int kvm_mips_config1_wrmask(struct kvm_vcpu *vcpu)
-{
-	unsigned int mask = 0;
-
-	/* Permit FPU to be present if FPU is supported */
-	if (kvm_mips_guest_can_have_fpu(&vcpu->arch))
-		mask |= MIPS_CONF1_FP;
-
-	return mask;
-}
-
-/**
- * kvm_mips_config3_wrmask() - Find mask of writable bits in guest Config3
- * @vcpu:	Virtual CPU.
- *
- * Finds the mask of bits which are writable in the guest's Config3 CP0
- * register, by userland (currently read-only to the guest).
- */
-unsigned int kvm_mips_config3_wrmask(struct kvm_vcpu *vcpu)
-{
-	/* Config4 and ULRI are optional */
-	unsigned int mask = MIPS_CONF_M | MIPS_CONF3_ULRI;
-
-	/* Permit MSA to be present if MSA is supported */
-	if (kvm_mips_guest_can_have_msa(&vcpu->arch))
-		mask |= MIPS_CONF3_MSA;
-
-	return mask;
-}
-
-/**
- * kvm_mips_config4_wrmask() - Find mask of writable bits in guest Config4
- * @vcpu:	Virtual CPU.
- *
- * Finds the mask of bits which are writable in the guest's Config4 CP0
- * register, by userland (currently read-only to the guest).
- */
-unsigned int kvm_mips_config4_wrmask(struct kvm_vcpu *vcpu)
-{
-	/* Config5 is optional */
-	unsigned int mask = MIPS_CONF_M;
-
-	/* KScrExist */
-	mask |= 0xfc << MIPS_CONF4_KSCREXIST_SHIFT;
-
-	return mask;
-}
-
-/**
- * kvm_mips_config5_wrmask() - Find mask of writable bits in guest Config5
- * @vcpu:	Virtual CPU.
- *
- * Finds the mask of bits which are writable in the guest's Config5 CP0
- * register, by the guest itself.
- */
-unsigned int kvm_mips_config5_wrmask(struct kvm_vcpu *vcpu)
-{
-	unsigned int mask = 0;
-
-	/* Permit MSAEn changes if MSA supported and enabled */
-	if (kvm_mips_guest_has_msa(&vcpu->arch))
-		mask |= MIPS_CONF5_MSAEN;
-
-	/*
-	 * Permit guest FPU mode changes if FPU is enabled and the relevant
-	 * feature exists according to FIR register.
-	 */
-	if (kvm_mips_guest_has_fpu(&vcpu->arch)) {
-		if (cpu_has_fre)
-			mask |= MIPS_CONF5_FRE;
-		/* We don't support UFR or UFE */
-	}
-
-	return mask;
-}
-
-enum emulation_result kvm_mips_emulate_CP0(union mips_instruction inst,
-					   u32 *opc, u32 cause,
-					   struct kvm_vcpu *vcpu)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	enum emulation_result er = EMULATE_DONE;
-	u32 rt, rd, sel;
-	unsigned long curr_pc;
-
-	/*
-	 * Update PC and hold onto current PC in case there is
-	 * an error and we want to rollback the PC
-	 */
-	curr_pc = vcpu->arch.pc;
-	er = update_pc(vcpu, cause);
-	if (er == EMULATE_FAIL)
-		return er;
-
-	if (inst.co_format.co) {
-		switch (inst.co_format.func) {
-		case tlbr_op:	/*  Read indexed TLB entry  */
-			er = kvm_mips_emul_tlbr(vcpu);
-			break;
-		case tlbwi_op:	/*  Write indexed  */
-			er = kvm_mips_emul_tlbwi(vcpu);
-			break;
-		case tlbwr_op:	/*  Write random  */
-			er = kvm_mips_emul_tlbwr(vcpu);
-			break;
-		case tlbp_op:	/* TLB Probe */
-			er = kvm_mips_emul_tlbp(vcpu);
-			break;
-		case rfe_op:
-			kvm_err("!!!COP0_RFE!!!\n");
-			break;
-		case eret_op:
-			er = kvm_mips_emul_eret(vcpu);
-			goto dont_update_pc;
-		case wait_op:
-			er = kvm_mips_emul_wait(vcpu);
-			break;
-		case hypcall_op:
-			er = kvm_mips_emul_hypcall(vcpu, inst);
-			break;
-		}
-	} else {
-		rt = inst.c0r_format.rt;
-		rd = inst.c0r_format.rd;
-		sel = inst.c0r_format.sel;
-
-		switch (inst.c0r_format.rs) {
-		case mfc_op:
-#ifdef CONFIG_KVM_MIPS_DEBUG_COP0_COUNTERS
-			cop0->stat[rd][sel]++;
-#endif
-			/* Get reg */
-			if ((rd == MIPS_CP0_COUNT) && (sel == 0)) {
-				vcpu->arch.gprs[rt] =
-				    (s32)kvm_mips_read_count(vcpu);
-			} else if ((rd == MIPS_CP0_ERRCTL) && (sel == 0)) {
-				vcpu->arch.gprs[rt] = 0x0;
-#ifdef CONFIG_KVM_MIPS_DYN_TRANS
-				kvm_mips_trans_mfc0(inst, opc, vcpu);
-#endif
-			} else {
-				vcpu->arch.gprs[rt] = (s32)cop0->reg[rd][sel];
-
-#ifdef CONFIG_KVM_MIPS_DYN_TRANS
-				kvm_mips_trans_mfc0(inst, opc, vcpu);
-#endif
-			}
-
-			trace_kvm_hwr(vcpu, KVM_TRACE_MFC0,
-				      KVM_TRACE_COP0(rd, sel),
-				      vcpu->arch.gprs[rt]);
-			break;
-
-		case dmfc_op:
-			vcpu->arch.gprs[rt] = cop0->reg[rd][sel];
-
-			trace_kvm_hwr(vcpu, KVM_TRACE_DMFC0,
-				      KVM_TRACE_COP0(rd, sel),
-				      vcpu->arch.gprs[rt]);
-			break;
-
-		case mtc_op:
-#ifdef CONFIG_KVM_MIPS_DEBUG_COP0_COUNTERS
-			cop0->stat[rd][sel]++;
-#endif
-			trace_kvm_hwr(vcpu, KVM_TRACE_MTC0,
-				      KVM_TRACE_COP0(rd, sel),
-				      vcpu->arch.gprs[rt]);
-
-			if ((rd == MIPS_CP0_TLB_INDEX)
-			    && (vcpu->arch.gprs[rt] >=
-				KVM_MIPS_GUEST_TLB_SIZE)) {
-				kvm_err("Invalid TLB Index: %ld",
-					vcpu->arch.gprs[rt]);
-				er = EMULATE_FAIL;
-				break;
-			}
-			if ((rd == MIPS_CP0_PRID) && (sel == 1)) {
-				/*
-				 * Preserve core number, and keep the exception
-				 * base in guest KSeg0.
-				 */
-				kvm_change_c0_guest_ebase(cop0, 0x1ffff000,
-							  vcpu->arch.gprs[rt]);
-			} else if (rd == MIPS_CP0_TLB_HI && sel == 0) {
-				kvm_mips_change_entryhi(vcpu,
-							vcpu->arch.gprs[rt]);
-			}
-			/* Are we writing to COUNT */
-			else if ((rd == MIPS_CP0_COUNT) && (sel == 0)) {
-				kvm_mips_write_count(vcpu, vcpu->arch.gprs[rt]);
-				goto done;
-			} else if ((rd == MIPS_CP0_COMPARE) && (sel == 0)) {
-				/* If we are writing to COMPARE */
-				/* Clear pending timer interrupt, if any */
-				kvm_mips_write_compare(vcpu,
-						       vcpu->arch.gprs[rt],
-						       true);
-			} else if ((rd == MIPS_CP0_STATUS) && (sel == 0)) {
-				unsigned int old_val, val, change;
-
-				old_val = kvm_read_c0_guest_status(cop0);
-				val = vcpu->arch.gprs[rt];
-				change = val ^ old_val;
-
-				/* Make sure that the NMI bit is never set */
-				val &= ~ST0_NMI;
-
-				/*
-				 * Don't allow CU1 or FR to be set unless FPU
-				 * capability enabled and exists in guest
-				 * configuration.
-				 */
-				if (!kvm_mips_guest_has_fpu(&vcpu->arch))
-					val &= ~(ST0_CU1 | ST0_FR);
-
-				/*
-				 * Also don't allow FR to be set if host doesn't
-				 * support it.
-				 */
-				if (!(current_cpu_data.fpu_id & MIPS_FPIR_F64))
-					val &= ~ST0_FR;
-
-
-				/* Handle changes in FPU mode */
-				preempt_disable();
-
-				/*
-				 * FPU and Vector register state is made
-				 * UNPREDICTABLE by a change of FR, so don't
-				 * even bother saving it.
-				 */
-				if (change & ST0_FR)
-					kvm_drop_fpu(vcpu);
-
-				/*
-				 * If MSA state is already live, it is undefined
-				 * how it interacts with FR=0 FPU state, and we
-				 * don't want to hit reserved instruction
-				 * exceptions trying to save the MSA state later
-				 * when CU=1 && FR=1, so play it safe and save
-				 * it first.
-				 */
-				if (change & ST0_CU1 && !(val & ST0_FR) &&
-				    vcpu->arch.aux_inuse & KVM_MIPS_AUX_MSA)
-					kvm_lose_fpu(vcpu);
-
-				/*
-				 * Propagate CU1 (FPU enable) changes
-				 * immediately if the FPU context is already
-				 * loaded. When disabling we leave the context
-				 * loaded so it can be quickly enabled again in
-				 * the near future.
-				 */
-				if (change & ST0_CU1 &&
-				    vcpu->arch.aux_inuse & KVM_MIPS_AUX_FPU)
-					change_c0_status(ST0_CU1, val);
-
-				preempt_enable();
-
-				kvm_write_c0_guest_status(cop0, val);
-
-#ifdef CONFIG_KVM_MIPS_DYN_TRANS
-				/*
-				 * If FPU present, we need CU1/FR bits to take
-				 * effect fairly soon.
-				 */
-				if (!kvm_mips_guest_has_fpu(&vcpu->arch))
-					kvm_mips_trans_mtc0(inst, opc, vcpu);
-#endif
-			} else if ((rd == MIPS_CP0_CONFIG) && (sel == 5)) {
-				unsigned int old_val, val, change, wrmask;
-
-				old_val = kvm_read_c0_guest_config5(cop0);
-				val = vcpu->arch.gprs[rt];
-
-				/* Only a few bits are writable in Config5 */
-				wrmask = kvm_mips_config5_wrmask(vcpu);
-				change = (val ^ old_val) & wrmask;
-				val = old_val ^ change;
-
-
-				/* Handle changes in FPU/MSA modes */
-				preempt_disable();
-
-				/*
-				 * Propagate FRE changes immediately if the FPU
-				 * context is already loaded.
-				 */
-				if (change & MIPS_CONF5_FRE &&
-				    vcpu->arch.aux_inuse & KVM_MIPS_AUX_FPU)
-					change_c0_config5(MIPS_CONF5_FRE, val);
-
-				/*
-				 * Propagate MSAEn changes immediately if the
-				 * MSA context is already loaded. When disabling
-				 * we leave the context loaded so it can be
-				 * quickly enabled again in the near future.
-				 */
-				if (change & MIPS_CONF5_MSAEN &&
-				    vcpu->arch.aux_inuse & KVM_MIPS_AUX_MSA)
-					change_c0_config5(MIPS_CONF5_MSAEN,
-							  val);
-
-				preempt_enable();
-
-				kvm_write_c0_guest_config5(cop0, val);
-			} else if ((rd == MIPS_CP0_CAUSE) && (sel == 0)) {
-				u32 old_cause, new_cause;
-
-				old_cause = kvm_read_c0_guest_cause(cop0);
-				new_cause = vcpu->arch.gprs[rt];
-				/* Update R/W bits */
-				kvm_change_c0_guest_cause(cop0, 0x08800300,
-							  new_cause);
-				/* DC bit enabling/disabling timer? */
-				if ((old_cause ^ new_cause) & CAUSEF_DC) {
-					if (new_cause & CAUSEF_DC)
-						kvm_mips_count_disable_cause(vcpu);
-					else
-						kvm_mips_count_enable_cause(vcpu);
-				}
-			} else if ((rd == MIPS_CP0_HWRENA) && (sel == 0)) {
-				u32 mask = MIPS_HWRENA_CPUNUM |
-					   MIPS_HWRENA_SYNCISTEP |
-					   MIPS_HWRENA_CC |
-					   MIPS_HWRENA_CCRES;
-
-				if (kvm_read_c0_guest_config3(cop0) &
-				    MIPS_CONF3_ULRI)
-					mask |= MIPS_HWRENA_ULR;
-				cop0->reg[rd][sel] = vcpu->arch.gprs[rt] & mask;
-			} else {
-				cop0->reg[rd][sel] = vcpu->arch.gprs[rt];
-#ifdef CONFIG_KVM_MIPS_DYN_TRANS
-				kvm_mips_trans_mtc0(inst, opc, vcpu);
-#endif
-			}
-			break;
-
-		case dmtc_op:
-			kvm_err("!!!!!!![%#lx]dmtc_op: rt: %d, rd: %d, sel: %d!!!!!!\n",
-				vcpu->arch.pc, rt, rd, sel);
-			trace_kvm_hwr(vcpu, KVM_TRACE_DMTC0,
-				      KVM_TRACE_COP0(rd, sel),
-				      vcpu->arch.gprs[rt]);
-			er = EMULATE_FAIL;
-			break;
-
-		case mfmc0_op:
-#ifdef KVM_MIPS_DEBUG_COP0_COUNTERS
-			cop0->stat[MIPS_CP0_STATUS][0]++;
-#endif
-			if (rt != 0)
-				vcpu->arch.gprs[rt] =
-				    kvm_read_c0_guest_status(cop0);
-			/* EI */
-			if (inst.mfmc0_format.sc) {
-				kvm_debug("[%#lx] mfmc0_op: EI\n",
-					  vcpu->arch.pc);
-				kvm_set_c0_guest_status(cop0, ST0_IE);
-			} else {
-				kvm_debug("[%#lx] mfmc0_op: DI\n",
-					  vcpu->arch.pc);
-				kvm_clear_c0_guest_status(cop0, ST0_IE);
-			}
-
-			break;
-
-		case wrpgpr_op:
-			{
-				u32 css = cop0->reg[MIPS_CP0_STATUS][2] & 0xf;
-				u32 pss =
-				    (cop0->reg[MIPS_CP0_STATUS][2] >> 6) & 0xf;
-				/*
-				 * We don't support any shadow register sets, so
-				 * SRSCtl[PSS] == SRSCtl[CSS] = 0
-				 */
-				if (css || pss) {
-					er = EMULATE_FAIL;
-					break;
-				}
-				kvm_debug("WRPGPR[%d][%d] = %#lx\n", pss, rd,
-					  vcpu->arch.gprs[rt]);
-				vcpu->arch.gprs[rd] = vcpu->arch.gprs[rt];
-			}
-			break;
-		default:
-			kvm_err("[%#lx]MachEmulateCP0: unsupported COP0, copz: 0x%x\n",
-				vcpu->arch.pc, inst.c0r_format.rs);
-			er = EMULATE_FAIL;
-			break;
-		}
-	}
-
-done:
-	/* Rollback PC only if emulation was unsuccessful */
-	if (er == EMULATE_FAIL)
-		vcpu->arch.pc = curr_pc;
-
-dont_update_pc:
-	/*
-	 * This is for special instructions whose emulation
-	 * updates the PC, so do not overwrite the PC under
-	 * any circumstances
-	 */
-
-	return er;
-}
-
 enum emulation_result kvm_mips_emulate_store(union mips_instruction inst,
 					     u32 cause,
 					     struct kvm_vcpu *vcpu)
@@ -1623,7 +996,7 @@ enum emulation_result kvm_mips_emulate_store(union mips_instruction inst,
 		goto out_fail;
 
 	switch (inst.i_format.opcode) {
-#if defined(CONFIG_64BIT) && defined(CONFIG_KVM_MIPS_VZ)
+#if defined(CONFIG_64BIT)
 	case sd_op:
 		run->mmio.len = 8;
 		*(u64 *)data = vcpu->arch.gprs[rt];
@@ -1721,7 +1094,7 @@ enum emulation_result kvm_mips_emulate_store(union mips_instruction inst,
 			  vcpu->arch.gprs[rt], *(u32 *)data);
 		break;
 
-#if defined(CONFIG_64BIT) && defined(CONFIG_KVM_MIPS_VZ)
+#if defined(CONFIG_64BIT)
 	case sdl_op:
 		run->mmio.phys_addr = kvm_mips_callbacks->gva_to_gpa(
 					vcpu->arch.host_cp0_badvaddr) & (~0x7);
@@ -1928,7 +1301,7 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
 
 	vcpu->mmio_needed = 2;	/* signed */
 	switch (op) {
-#if defined(CONFIG_64BIT) && defined(CONFIG_KVM_MIPS_VZ)
+#if defined(CONFIG_64BIT)
 	case ld_op:
 		run->mmio.len = 8;
 		break;
@@ -2003,7 +1376,7 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
 		}
 		break;
 
-#if defined(CONFIG_64BIT) && defined(CONFIG_KVM_MIPS_VZ)
+#if defined(CONFIG_64BIT)
 	case ldl_op:
 		run->mmio.phys_addr = kvm_mips_callbacks->gva_to_gpa(
 					vcpu->arch.host_cp0_badvaddr) & (~0x7);
@@ -2135,829 +1508,20 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
 	return EMULATE_DO_MMIO;
 }
 
-#ifndef CONFIG_KVM_MIPS_VZ
-static enum emulation_result kvm_mips_guest_cache_op(int (*fn)(unsigned long),
-						     unsigned long curr_pc,
-						     unsigned long addr,
-						     struct kvm_vcpu *vcpu,
-						     u32 cause)
-{
-	int err;
-
-	for (;;) {
-		/* Carefully attempt the cache operation */
-		kvm_trap_emul_gva_lockless_begin(vcpu);
-		err = fn(addr);
-		kvm_trap_emul_gva_lockless_end(vcpu);
-
-		if (likely(!err))
-			return EMULATE_DONE;
-
-		/*
-		 * Try to handle the fault and retry, maybe we just raced with a
-		 * GVA invalidation.
-		 */
-		switch (kvm_trap_emul_gva_fault(vcpu, addr, false)) {
-		case KVM_MIPS_GVA:
-		case KVM_MIPS_GPA:
-			/* bad virtual or physical address */
-			return EMULATE_FAIL;
-		case KVM_MIPS_TLB:
-			/* no matching guest TLB */
-			vcpu->arch.host_cp0_badvaddr = addr;
-			vcpu->arch.pc = curr_pc;
-			kvm_mips_emulate_tlbmiss_ld(cause, NULL, vcpu);
-			return EMULATE_EXCEPT;
-		case KVM_MIPS_TLBINV:
-			/* invalid matching guest TLB */
-			vcpu->arch.host_cp0_badvaddr = addr;
-			vcpu->arch.pc = curr_pc;
-			kvm_mips_emulate_tlbinv_ld(cause, NULL, vcpu);
-			return EMULATE_EXCEPT;
-		default:
-			break;
-		}
-	}
-}
-
-enum emulation_result kvm_mips_emulate_cache(union mips_instruction inst,
-					     u32 *opc, u32 cause,
-					     struct kvm_vcpu *vcpu)
+enum emulation_result kvm_mips_complete_mmio_load(struct kvm_vcpu *vcpu)
 {
+	struct kvm_run *run = vcpu->run;
+	unsigned long *gpr = &vcpu->arch.gprs[vcpu->arch.io_gpr];
 	enum emulation_result er = EMULATE_DONE;
-	u32 cache, op_inst, op, base;
-	s16 offset;
-	struct kvm_vcpu_arch *arch = &vcpu->arch;
-	unsigned long va;
-	unsigned long curr_pc;
-
-	/*
-	 * Update PC and hold onto current PC in case there is
-	 * an error and we want to rollback the PC
-	 */
-	curr_pc = vcpu->arch.pc;
-	er = update_pc(vcpu, cause);
-	if (er == EMULATE_FAIL)
-		return er;
-
-	base = inst.i_format.rs;
-	op_inst = inst.i_format.rt;
-	if (cpu_has_mips_r6)
-		offset = inst.spec3_format.simmediate;
-	else
-		offset = inst.i_format.simmediate;
-	cache = op_inst & CacheOp_Cache;
-	op = op_inst & CacheOp_Op;
-
-	va = arch->gprs[base] + offset;
-
-	kvm_debug("CACHE (cache: %#x, op: %#x, base[%d]: %#lx, offset: %#x\n",
-		  cache, op, base, arch->gprs[base], offset);
 
-	/*
-	 * Treat INDEX_INV as a nop, basically issued by Linux on startup to
-	 * invalidate the caches entirely by stepping through all the
-	 * ways/indexes
-	 */
-	if (op == Index_Writeback_Inv) {
-		kvm_debug("@ %#lx/%#lx CACHE (cache: %#x, op: %#x, base[%d]: %#lx, offset: %#x\n",
-			  vcpu->arch.pc, vcpu->arch.gprs[31], cache, op, base,
-			  arch->gprs[base], offset);
-
-		if (cache == Cache_D) {
-#ifdef CONFIG_CPU_R4K_CACHE_TLB
-			r4k_blast_dcache();
-#else
-			switch (boot_cpu_type()) {
-			case CPU_CAVIUM_OCTEON3:
-				/* locally flush icache */
-				local_flush_icache_range(0, 0);
-				break;
-			default:
-				__flush_cache_all();
-				break;
-			}
-#endif
-		} else if (cache == Cache_I) {
-#ifdef CONFIG_CPU_R4K_CACHE_TLB
-			r4k_blast_icache();
-#else
-			switch (boot_cpu_type()) {
-			case CPU_CAVIUM_OCTEON3:
-				/* locally flush icache */
-				local_flush_icache_range(0, 0);
-				break;
-			default:
-				flush_icache_all();
-				break;
-			}
-#endif
-		} else {
-			kvm_err("%s: unsupported CACHE INDEX operation\n",
-				__func__);
-			return EMULATE_FAIL;
-		}
-
-#ifdef CONFIG_KVM_MIPS_DYN_TRANS
-		kvm_mips_trans_cache_index(inst, opc, vcpu);
-#endif
-		goto done;
-	}
-
-	/* XXXKYMA: Only a subset of cache ops are supported, used by Linux */
-	if (op_inst == Hit_Writeback_Inv_D || op_inst == Hit_Invalidate_D) {
-		/*
-		 * Perform the dcache part of icache synchronisation on the
-		 * guest's behalf.
-		 */
-		er = kvm_mips_guest_cache_op(protected_writeback_dcache_line,
-					     curr_pc, va, vcpu, cause);
-		if (er != EMULATE_DONE)
-			goto done;
-#ifdef CONFIG_KVM_MIPS_DYN_TRANS
-		/*
-		 * Replace the CACHE instruction, with a SYNCI, not the same,
-		 * but avoids a trap
-		 */
-		kvm_mips_trans_cache_va(inst, opc, vcpu);
-#endif
-	} else if (op_inst == Hit_Invalidate_I) {
-		/* Perform the icache synchronisation on the guest's behalf */
-		er = kvm_mips_guest_cache_op(protected_writeback_dcache_line,
-					     curr_pc, va, vcpu, cause);
-		if (er != EMULATE_DONE)
-			goto done;
-		er = kvm_mips_guest_cache_op(protected_flush_icache_line,
-					     curr_pc, va, vcpu, cause);
-		if (er != EMULATE_DONE)
-			goto done;
-
-#ifdef CONFIG_KVM_MIPS_DYN_TRANS
-		/* Replace the CACHE instruction, with a SYNCI */
-		kvm_mips_trans_cache_va(inst, opc, vcpu);
-#endif
-	} else {
-		kvm_err("NO-OP CACHE (cache: %#x, op: %#x, base[%d]: %#lx, offset: %#x\n",
-			cache, op, base, arch->gprs[base], offset);
+	if (run->mmio.len > sizeof(*gpr)) {
+		kvm_err("Bad MMIO length: %d", run->mmio.len);
 		er = EMULATE_FAIL;
+		goto done;
 	}
 
-done:
-	/* Rollback PC only if emulation was unsuccessful */
-	if (er == EMULATE_FAIL)
-		vcpu->arch.pc = curr_pc;
-	/* Guest exception needs guest to resume */
-	if (er == EMULATE_EXCEPT)
-		er = EMULATE_DONE;
-
-	return er;
-}
-
-enum emulation_result kvm_mips_emulate_inst(u32 cause, u32 *opc,
-					    struct kvm_vcpu *vcpu)
-{
-	union mips_instruction inst;
-	enum emulation_result er = EMULATE_DONE;
-	int err;
-
-	/* Fetch the instruction. */
-	if (cause & CAUSEF_BD)
-		opc += 1;
-	err = kvm_get_badinstr(opc, vcpu, &inst.word);
-	if (err)
-		return EMULATE_FAIL;
-
-	switch (inst.r_format.opcode) {
-	case cop0_op:
-		er = kvm_mips_emulate_CP0(inst, opc, cause, vcpu);
-		break;
-
-#ifndef CONFIG_CPU_MIPSR6
-	case cache_op:
-		++vcpu->stat.cache_exits;
-		trace_kvm_exit(vcpu, KVM_TRACE_EXIT_CACHE);
-		er = kvm_mips_emulate_cache(inst, opc, cause, vcpu);
-		break;
-#else
-	case spec3_op:
-		switch (inst.spec3_format.func) {
-		case cache6_op:
-			++vcpu->stat.cache_exits;
-			trace_kvm_exit(vcpu, KVM_TRACE_EXIT_CACHE);
-			er = kvm_mips_emulate_cache(inst, opc, cause,
-						    vcpu);
-			break;
-		default:
-			goto unknown;
-		}
-		break;
-unknown:
-#endif
-
-	default:
-		kvm_err("Instruction emulation not supported (%p/%#x)\n", opc,
-			inst.word);
-		kvm_arch_vcpu_dump_regs(vcpu);
-		er = EMULATE_FAIL;
-		break;
-	}
-
-	return er;
-}
-#endif /* CONFIG_KVM_MIPS_VZ */
-
-/**
- * kvm_mips_guest_exception_base() - Find guest exception vector base address.
- *
- * Returns:	The base address of the current guest exception vector, taking
- *		both Guest.CP0_Status.BEV and Guest.CP0_EBase into account.
- */
-long kvm_mips_guest_exception_base(struct kvm_vcpu *vcpu)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-
-	if (kvm_read_c0_guest_status(cop0) & ST0_BEV)
-		return KVM_GUEST_CKSEG1ADDR(0x1fc00200);
-	else
-		return kvm_read_c0_guest_ebase(cop0) & MIPS_EBASE_BASE;
-}
-
-enum emulation_result kvm_mips_emulate_syscall(u32 cause,
-					       u32 *opc,
-					       struct kvm_vcpu *vcpu)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	struct kvm_vcpu_arch *arch = &vcpu->arch;
-	enum emulation_result er = EMULATE_DONE;
-
-	if ((kvm_read_c0_guest_status(cop0) & ST0_EXL) == 0) {
-		/* save old pc */
-		kvm_write_c0_guest_epc(cop0, arch->pc);
-		kvm_set_c0_guest_status(cop0, ST0_EXL);
-
-		if (cause & CAUSEF_BD)
-			kvm_set_c0_guest_cause(cop0, CAUSEF_BD);
-		else
-			kvm_clear_c0_guest_cause(cop0, CAUSEF_BD);
-
-		kvm_debug("Delivering SYSCALL @ pc %#lx\n", arch->pc);
-
-		kvm_change_c0_guest_cause(cop0, (0xff),
-					  (EXCCODE_SYS << CAUSEB_EXCCODE));
-
-		/* Set PC to the exception entry point */
-		arch->pc = kvm_mips_guest_exception_base(vcpu) + 0x180;
-
-	} else {
-		kvm_err("Trying to deliver SYSCALL when EXL is already set\n");
-		er = EMULATE_FAIL;
-	}
-
-	return er;
-}
-
-enum emulation_result kvm_mips_emulate_tlbmiss_ld(u32 cause,
-						  u32 *opc,
-						  struct kvm_vcpu *vcpu)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	struct kvm_vcpu_arch *arch = &vcpu->arch;
-	unsigned long entryhi = (vcpu->arch.  host_cp0_badvaddr & VPN2_MASK) |
-			(kvm_read_c0_guest_entryhi(cop0) & KVM_ENTRYHI_ASID);
-
-	if ((kvm_read_c0_guest_status(cop0) & ST0_EXL) == 0) {
-		/* save old pc */
-		kvm_write_c0_guest_epc(cop0, arch->pc);
-		kvm_set_c0_guest_status(cop0, ST0_EXL);
-
-		if (cause & CAUSEF_BD)
-			kvm_set_c0_guest_cause(cop0, CAUSEF_BD);
-		else
-			kvm_clear_c0_guest_cause(cop0, CAUSEF_BD);
-
-		kvm_debug("[EXL == 0] delivering TLB MISS @ pc %#lx\n",
-			  arch->pc);
-
-		/* set pc to the exception entry point */
-		arch->pc = kvm_mips_guest_exception_base(vcpu) + 0x0;
-
-	} else {
-		kvm_debug("[EXL == 1] delivering TLB MISS @ pc %#lx\n",
-			  arch->pc);
-
-		arch->pc = kvm_mips_guest_exception_base(vcpu) + 0x180;
-	}
-
-	kvm_change_c0_guest_cause(cop0, (0xff),
-				  (EXCCODE_TLBL << CAUSEB_EXCCODE));
-
-	/* setup badvaddr, context and entryhi registers for the guest */
-	kvm_write_c0_guest_badvaddr(cop0, vcpu->arch.host_cp0_badvaddr);
-	/* XXXKYMA: is the context register used by linux??? */
-	kvm_write_c0_guest_entryhi(cop0, entryhi);
-
-	return EMULATE_DONE;
-}
-
-enum emulation_result kvm_mips_emulate_tlbinv_ld(u32 cause,
-						 u32 *opc,
-						 struct kvm_vcpu *vcpu)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	struct kvm_vcpu_arch *arch = &vcpu->arch;
-	unsigned long entryhi =
-		(vcpu->arch.host_cp0_badvaddr & VPN2_MASK) |
-		(kvm_read_c0_guest_entryhi(cop0) & KVM_ENTRYHI_ASID);
-
-	if ((kvm_read_c0_guest_status(cop0) & ST0_EXL) == 0) {
-		/* save old pc */
-		kvm_write_c0_guest_epc(cop0, arch->pc);
-		kvm_set_c0_guest_status(cop0, ST0_EXL);
-
-		if (cause & CAUSEF_BD)
-			kvm_set_c0_guest_cause(cop0, CAUSEF_BD);
-		else
-			kvm_clear_c0_guest_cause(cop0, CAUSEF_BD);
-
-		kvm_debug("[EXL == 0] delivering TLB INV @ pc %#lx\n",
-			  arch->pc);
-	} else {
-		kvm_debug("[EXL == 1] delivering TLB MISS @ pc %#lx\n",
-			  arch->pc);
-	}
-
-	/* set pc to the exception entry point */
-	arch->pc = kvm_mips_guest_exception_base(vcpu) + 0x180;
-
-	kvm_change_c0_guest_cause(cop0, (0xff),
-				  (EXCCODE_TLBL << CAUSEB_EXCCODE));
-
-	/* setup badvaddr, context and entryhi registers for the guest */
-	kvm_write_c0_guest_badvaddr(cop0, vcpu->arch.host_cp0_badvaddr);
-	/* XXXKYMA: is the context register used by linux??? */
-	kvm_write_c0_guest_entryhi(cop0, entryhi);
-
-	return EMULATE_DONE;
-}
-
-enum emulation_result kvm_mips_emulate_tlbmiss_st(u32 cause,
-						  u32 *opc,
-						  struct kvm_vcpu *vcpu)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	struct kvm_vcpu_arch *arch = &vcpu->arch;
-	unsigned long entryhi = (vcpu->arch.host_cp0_badvaddr & VPN2_MASK) |
-			(kvm_read_c0_guest_entryhi(cop0) & KVM_ENTRYHI_ASID);
-
-	if ((kvm_read_c0_guest_status(cop0) & ST0_EXL) == 0) {
-		/* save old pc */
-		kvm_write_c0_guest_epc(cop0, arch->pc);
-		kvm_set_c0_guest_status(cop0, ST0_EXL);
-
-		if (cause & CAUSEF_BD)
-			kvm_set_c0_guest_cause(cop0, CAUSEF_BD);
-		else
-			kvm_clear_c0_guest_cause(cop0, CAUSEF_BD);
-
-		kvm_debug("[EXL == 0] Delivering TLB MISS @ pc %#lx\n",
-			  arch->pc);
-
-		/* Set PC to the exception entry point */
-		arch->pc = kvm_mips_guest_exception_base(vcpu) + 0x0;
-	} else {
-		kvm_debug("[EXL == 1] Delivering TLB MISS @ pc %#lx\n",
-			  arch->pc);
-		arch->pc = kvm_mips_guest_exception_base(vcpu) + 0x180;
-	}
-
-	kvm_change_c0_guest_cause(cop0, (0xff),
-				  (EXCCODE_TLBS << CAUSEB_EXCCODE));
-
-	/* setup badvaddr, context and entryhi registers for the guest */
-	kvm_write_c0_guest_badvaddr(cop0, vcpu->arch.host_cp0_badvaddr);
-	/* XXXKYMA: is the context register used by linux??? */
-	kvm_write_c0_guest_entryhi(cop0, entryhi);
-
-	return EMULATE_DONE;
-}
-
-enum emulation_result kvm_mips_emulate_tlbinv_st(u32 cause,
-						 u32 *opc,
-						 struct kvm_vcpu *vcpu)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	struct kvm_vcpu_arch *arch = &vcpu->arch;
-	unsigned long entryhi = (vcpu->arch.host_cp0_badvaddr & VPN2_MASK) |
-		(kvm_read_c0_guest_entryhi(cop0) & KVM_ENTRYHI_ASID);
-
-	if ((kvm_read_c0_guest_status(cop0) & ST0_EXL) == 0) {
-		/* save old pc */
-		kvm_write_c0_guest_epc(cop0, arch->pc);
-		kvm_set_c0_guest_status(cop0, ST0_EXL);
-
-		if (cause & CAUSEF_BD)
-			kvm_set_c0_guest_cause(cop0, CAUSEF_BD);
-		else
-			kvm_clear_c0_guest_cause(cop0, CAUSEF_BD);
-
-		kvm_debug("[EXL == 0] Delivering TLB MISS @ pc %#lx\n",
-			  arch->pc);
-	} else {
-		kvm_debug("[EXL == 1] Delivering TLB MISS @ pc %#lx\n",
-			  arch->pc);
-	}
-
-	/* Set PC to the exception entry point */
-	arch->pc = kvm_mips_guest_exception_base(vcpu) + 0x180;
-
-	kvm_change_c0_guest_cause(cop0, (0xff),
-				  (EXCCODE_TLBS << CAUSEB_EXCCODE));
-
-	/* setup badvaddr, context and entryhi registers for the guest */
-	kvm_write_c0_guest_badvaddr(cop0, vcpu->arch.host_cp0_badvaddr);
-	/* XXXKYMA: is the context register used by linux??? */
-	kvm_write_c0_guest_entryhi(cop0, entryhi);
-
-	return EMULATE_DONE;
-}
-
-enum emulation_result kvm_mips_emulate_tlbmod(u32 cause,
-					      u32 *opc,
-					      struct kvm_vcpu *vcpu)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	unsigned long entryhi = (vcpu->arch.host_cp0_badvaddr & VPN2_MASK) |
-			(kvm_read_c0_guest_entryhi(cop0) & KVM_ENTRYHI_ASID);
-	struct kvm_vcpu_arch *arch = &vcpu->arch;
-
-	if ((kvm_read_c0_guest_status(cop0) & ST0_EXL) == 0) {
-		/* save old pc */
-		kvm_write_c0_guest_epc(cop0, arch->pc);
-		kvm_set_c0_guest_status(cop0, ST0_EXL);
-
-		if (cause & CAUSEF_BD)
-			kvm_set_c0_guest_cause(cop0, CAUSEF_BD);
-		else
-			kvm_clear_c0_guest_cause(cop0, CAUSEF_BD);
-
-		kvm_debug("[EXL == 0] Delivering TLB MOD @ pc %#lx\n",
-			  arch->pc);
-	} else {
-		kvm_debug("[EXL == 1] Delivering TLB MOD @ pc %#lx\n",
-			  arch->pc);
-	}
-
-	arch->pc = kvm_mips_guest_exception_base(vcpu) + 0x180;
-
-	kvm_change_c0_guest_cause(cop0, (0xff),
-				  (EXCCODE_MOD << CAUSEB_EXCCODE));
-
-	/* setup badvaddr, context and entryhi registers for the guest */
-	kvm_write_c0_guest_badvaddr(cop0, vcpu->arch.host_cp0_badvaddr);
-	/* XXXKYMA: is the context register used by linux??? */
-	kvm_write_c0_guest_entryhi(cop0, entryhi);
-
-	return EMULATE_DONE;
-}
-
-enum emulation_result kvm_mips_emulate_fpu_exc(u32 cause,
-					       u32 *opc,
-					       struct kvm_vcpu *vcpu)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	struct kvm_vcpu_arch *arch = &vcpu->arch;
-
-	if ((kvm_read_c0_guest_status(cop0) & ST0_EXL) == 0) {
-		/* save old pc */
-		kvm_write_c0_guest_epc(cop0, arch->pc);
-		kvm_set_c0_guest_status(cop0, ST0_EXL);
-
-		if (cause & CAUSEF_BD)
-			kvm_set_c0_guest_cause(cop0, CAUSEF_BD);
-		else
-			kvm_clear_c0_guest_cause(cop0, CAUSEF_BD);
-
-	}
-
-	arch->pc = kvm_mips_guest_exception_base(vcpu) + 0x180;
-
-	kvm_change_c0_guest_cause(cop0, (0xff),
-				  (EXCCODE_CPU << CAUSEB_EXCCODE));
-	kvm_change_c0_guest_cause(cop0, (CAUSEF_CE), (0x1 << CAUSEB_CE));
-
-	return EMULATE_DONE;
-}
-
-enum emulation_result kvm_mips_emulate_ri_exc(u32 cause,
-					      u32 *opc,
-					      struct kvm_vcpu *vcpu)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	struct kvm_vcpu_arch *arch = &vcpu->arch;
-	enum emulation_result er = EMULATE_DONE;
-
-	if ((kvm_read_c0_guest_status(cop0) & ST0_EXL) == 0) {
-		/* save old pc */
-		kvm_write_c0_guest_epc(cop0, arch->pc);
-		kvm_set_c0_guest_status(cop0, ST0_EXL);
-
-		if (cause & CAUSEF_BD)
-			kvm_set_c0_guest_cause(cop0, CAUSEF_BD);
-		else
-			kvm_clear_c0_guest_cause(cop0, CAUSEF_BD);
-
-		kvm_debug("Delivering RI @ pc %#lx\n", arch->pc);
-
-		kvm_change_c0_guest_cause(cop0, (0xff),
-					  (EXCCODE_RI << CAUSEB_EXCCODE));
-
-		/* Set PC to the exception entry point */
-		arch->pc = kvm_mips_guest_exception_base(vcpu) + 0x180;
-
-	} else {
-		kvm_err("Trying to deliver RI when EXL is already set\n");
-		er = EMULATE_FAIL;
-	}
-
-	return er;
-}
-
-enum emulation_result kvm_mips_emulate_bp_exc(u32 cause,
-					      u32 *opc,
-					      struct kvm_vcpu *vcpu)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	struct kvm_vcpu_arch *arch = &vcpu->arch;
-	enum emulation_result er = EMULATE_DONE;
-
-	if ((kvm_read_c0_guest_status(cop0) & ST0_EXL) == 0) {
-		/* save old pc */
-		kvm_write_c0_guest_epc(cop0, arch->pc);
-		kvm_set_c0_guest_status(cop0, ST0_EXL);
-
-		if (cause & CAUSEF_BD)
-			kvm_set_c0_guest_cause(cop0, CAUSEF_BD);
-		else
-			kvm_clear_c0_guest_cause(cop0, CAUSEF_BD);
-
-		kvm_debug("Delivering BP @ pc %#lx\n", arch->pc);
-
-		kvm_change_c0_guest_cause(cop0, (0xff),
-					  (EXCCODE_BP << CAUSEB_EXCCODE));
-
-		/* Set PC to the exception entry point */
-		arch->pc = kvm_mips_guest_exception_base(vcpu) + 0x180;
-
-	} else {
-		kvm_err("Trying to deliver BP when EXL is already set\n");
-		er = EMULATE_FAIL;
-	}
-
-	return er;
-}
-
-enum emulation_result kvm_mips_emulate_trap_exc(u32 cause,
-						u32 *opc,
-						struct kvm_vcpu *vcpu)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	struct kvm_vcpu_arch *arch = &vcpu->arch;
-	enum emulation_result er = EMULATE_DONE;
-
-	if ((kvm_read_c0_guest_status(cop0) & ST0_EXL) == 0) {
-		/* save old pc */
-		kvm_write_c0_guest_epc(cop0, arch->pc);
-		kvm_set_c0_guest_status(cop0, ST0_EXL);
-
-		if (cause & CAUSEF_BD)
-			kvm_set_c0_guest_cause(cop0, CAUSEF_BD);
-		else
-			kvm_clear_c0_guest_cause(cop0, CAUSEF_BD);
-
-		kvm_debug("Delivering TRAP @ pc %#lx\n", arch->pc);
-
-		kvm_change_c0_guest_cause(cop0, (0xff),
-					  (EXCCODE_TR << CAUSEB_EXCCODE));
-
-		/* Set PC to the exception entry point */
-		arch->pc = kvm_mips_guest_exception_base(vcpu) + 0x180;
-
-	} else {
-		kvm_err("Trying to deliver TRAP when EXL is already set\n");
-		er = EMULATE_FAIL;
-	}
-
-	return er;
-}
-
-enum emulation_result kvm_mips_emulate_msafpe_exc(u32 cause,
-						  u32 *opc,
-						  struct kvm_vcpu *vcpu)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	struct kvm_vcpu_arch *arch = &vcpu->arch;
-	enum emulation_result er = EMULATE_DONE;
-
-	if ((kvm_read_c0_guest_status(cop0) & ST0_EXL) == 0) {
-		/* save old pc */
-		kvm_write_c0_guest_epc(cop0, arch->pc);
-		kvm_set_c0_guest_status(cop0, ST0_EXL);
-
-		if (cause & CAUSEF_BD)
-			kvm_set_c0_guest_cause(cop0, CAUSEF_BD);
-		else
-			kvm_clear_c0_guest_cause(cop0, CAUSEF_BD);
-
-		kvm_debug("Delivering MSAFPE @ pc %#lx\n", arch->pc);
-
-		kvm_change_c0_guest_cause(cop0, (0xff),
-					  (EXCCODE_MSAFPE << CAUSEB_EXCCODE));
-
-		/* Set PC to the exception entry point */
-		arch->pc = kvm_mips_guest_exception_base(vcpu) + 0x180;
-
-	} else {
-		kvm_err("Trying to deliver MSAFPE when EXL is already set\n");
-		er = EMULATE_FAIL;
-	}
-
-	return er;
-}
-
-enum emulation_result kvm_mips_emulate_fpe_exc(u32 cause,
-					       u32 *opc,
-					       struct kvm_vcpu *vcpu)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	struct kvm_vcpu_arch *arch = &vcpu->arch;
-	enum emulation_result er = EMULATE_DONE;
-
-	if ((kvm_read_c0_guest_status(cop0) & ST0_EXL) == 0) {
-		/* save old pc */
-		kvm_write_c0_guest_epc(cop0, arch->pc);
-		kvm_set_c0_guest_status(cop0, ST0_EXL);
-
-		if (cause & CAUSEF_BD)
-			kvm_set_c0_guest_cause(cop0, CAUSEF_BD);
-		else
-			kvm_clear_c0_guest_cause(cop0, CAUSEF_BD);
-
-		kvm_debug("Delivering FPE @ pc %#lx\n", arch->pc);
-
-		kvm_change_c0_guest_cause(cop0, (0xff),
-					  (EXCCODE_FPE << CAUSEB_EXCCODE));
-
-		/* Set PC to the exception entry point */
-		arch->pc = kvm_mips_guest_exception_base(vcpu) + 0x180;
-
-	} else {
-		kvm_err("Trying to deliver FPE when EXL is already set\n");
-		er = EMULATE_FAIL;
-	}
-
-	return er;
-}
-
-enum emulation_result kvm_mips_emulate_msadis_exc(u32 cause,
-						  u32 *opc,
-						  struct kvm_vcpu *vcpu)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	struct kvm_vcpu_arch *arch = &vcpu->arch;
-	enum emulation_result er = EMULATE_DONE;
-
-	if ((kvm_read_c0_guest_status(cop0) & ST0_EXL) == 0) {
-		/* save old pc */
-		kvm_write_c0_guest_epc(cop0, arch->pc);
-		kvm_set_c0_guest_status(cop0, ST0_EXL);
-
-		if (cause & CAUSEF_BD)
-			kvm_set_c0_guest_cause(cop0, CAUSEF_BD);
-		else
-			kvm_clear_c0_guest_cause(cop0, CAUSEF_BD);
-
-		kvm_debug("Delivering MSADIS @ pc %#lx\n", arch->pc);
-
-		kvm_change_c0_guest_cause(cop0, (0xff),
-					  (EXCCODE_MSADIS << CAUSEB_EXCCODE));
-
-		/* Set PC to the exception entry point */
-		arch->pc = kvm_mips_guest_exception_base(vcpu) + 0x180;
-
-	} else {
-		kvm_err("Trying to deliver MSADIS when EXL is already set\n");
-		er = EMULATE_FAIL;
-	}
-
-	return er;
-}
-
-enum emulation_result kvm_mips_handle_ri(u32 cause, u32 *opc,
-					 struct kvm_vcpu *vcpu)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	struct kvm_vcpu_arch *arch = &vcpu->arch;
-	enum emulation_result er = EMULATE_DONE;
-	unsigned long curr_pc;
-	union mips_instruction inst;
-	int err;
-
-	/*
-	 * Update PC and hold onto current PC in case there is
-	 * an error and we want to rollback the PC
-	 */
-	curr_pc = vcpu->arch.pc;
-	er = update_pc(vcpu, cause);
-	if (er == EMULATE_FAIL)
-		return er;
-
-	/* Fetch the instruction. */
-	if (cause & CAUSEF_BD)
-		opc += 1;
-	err = kvm_get_badinstr(opc, vcpu, &inst.word);
-	if (err) {
-		kvm_err("%s: Cannot get inst @ %p (%d)\n", __func__, opc, err);
-		return EMULATE_FAIL;
-	}
-
-	if (inst.r_format.opcode == spec3_op &&
-	    inst.r_format.func == rdhwr_op &&
-	    inst.r_format.rs == 0 &&
-	    (inst.r_format.re >> 3) == 0) {
-		int usermode = !KVM_GUEST_KERNEL_MODE(vcpu);
-		int rd = inst.r_format.rd;
-		int rt = inst.r_format.rt;
-		int sel = inst.r_format.re & 0x7;
-
-		/* If usermode, check RDHWR rd is allowed by guest HWREna */
-		if (usermode && !(kvm_read_c0_guest_hwrena(cop0) & BIT(rd))) {
-			kvm_debug("RDHWR %#x disallowed by HWREna @ %p\n",
-				  rd, opc);
-			goto emulate_ri;
-		}
-		switch (rd) {
-		case MIPS_HWR_CPUNUM:		/* CPU number */
-			arch->gprs[rt] = vcpu->vcpu_id;
-			break;
-		case MIPS_HWR_SYNCISTEP:	/* SYNCI length */
-			arch->gprs[rt] = min(current_cpu_data.dcache.linesz,
-					     current_cpu_data.icache.linesz);
-			break;
-		case MIPS_HWR_CC:		/* Read count register */
-			arch->gprs[rt] = (s32)kvm_mips_read_count(vcpu);
-			break;
-		case MIPS_HWR_CCRES:		/* Count register resolution */
-			switch (current_cpu_data.cputype) {
-			case CPU_20KC:
-			case CPU_25KF:
-				arch->gprs[rt] = 1;
-				break;
-			default:
-				arch->gprs[rt] = 2;
-			}
-			break;
-		case MIPS_HWR_ULR:		/* Read UserLocal register */
-			arch->gprs[rt] = kvm_read_c0_guest_userlocal(cop0);
-			break;
-
-		default:
-			kvm_debug("RDHWR %#x not supported @ %p\n", rd, opc);
-			goto emulate_ri;
-		}
-
-		trace_kvm_hwr(vcpu, KVM_TRACE_RDHWR, KVM_TRACE_HWR(rd, sel),
-			      vcpu->arch.gprs[rt]);
-	} else {
-		kvm_debug("Emulate RI not supported @ %p: %#x\n",
-			  opc, inst.word);
-		goto emulate_ri;
-	}
-
-	return EMULATE_DONE;
-
-emulate_ri:
-	/*
-	 * Rollback PC (if in branch delay slot then the PC already points to
-	 * branch target), and pass the RI exception to the guest OS.
-	 */
-	vcpu->arch.pc = curr_pc;
-	return kvm_mips_emulate_ri_exc(cause, opc, vcpu);
-}
-
-enum emulation_result kvm_mips_complete_mmio_load(struct kvm_vcpu *vcpu)
-{
-	struct kvm_run *run = vcpu->run;
-	unsigned long *gpr = &vcpu->arch.gprs[vcpu->arch.io_gpr];
-	enum emulation_result er = EMULATE_DONE;
-
-	if (run->mmio.len > sizeof(*gpr)) {
-		kvm_err("Bad MMIO length: %d", run->mmio.len);
-		er = EMULATE_FAIL;
-		goto done;
-	}
-
-	/* Restore saved resume PC */
-	vcpu->arch.pc = vcpu->arch.io_pc;
+	/* Restore saved resume PC */
+	vcpu->arch.pc = vcpu->arch.io_pc;
 
 	switch (run->mmio.len) {
 	case 8:
@@ -3086,207 +1650,3 @@ enum emulation_result kvm_mips_complete_mmio_load(struct kvm_vcpu *vcpu)
 done:
 	return er;
 }
-
-static enum emulation_result kvm_mips_emulate_exc(u32 cause,
-						  u32 *opc,
-						  struct kvm_vcpu *vcpu)
-{
-	u32 exccode = (cause >> CAUSEB_EXCCODE) & 0x1f;
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	struct kvm_vcpu_arch *arch = &vcpu->arch;
-	enum emulation_result er = EMULATE_DONE;
-
-	if ((kvm_read_c0_guest_status(cop0) & ST0_EXL) == 0) {
-		/* save old pc */
-		kvm_write_c0_guest_epc(cop0, arch->pc);
-		kvm_set_c0_guest_status(cop0, ST0_EXL);
-
-		if (cause & CAUSEF_BD)
-			kvm_set_c0_guest_cause(cop0, CAUSEF_BD);
-		else
-			kvm_clear_c0_guest_cause(cop0, CAUSEF_BD);
-
-		kvm_change_c0_guest_cause(cop0, (0xff),
-					  (exccode << CAUSEB_EXCCODE));
-
-		/* Set PC to the exception entry point */
-		arch->pc = kvm_mips_guest_exception_base(vcpu) + 0x180;
-		kvm_write_c0_guest_badvaddr(cop0, vcpu->arch.host_cp0_badvaddr);
-
-		kvm_debug("Delivering EXC %d @ pc %#lx, badVaddr: %#lx\n",
-			  exccode, kvm_read_c0_guest_epc(cop0),
-			  kvm_read_c0_guest_badvaddr(cop0));
-	} else {
-		kvm_err("Trying to deliver EXC when EXL is already set\n");
-		er = EMULATE_FAIL;
-	}
-
-	return er;
-}
-
-enum emulation_result kvm_mips_check_privilege(u32 cause,
-					       u32 *opc,
-					       struct kvm_vcpu *vcpu)
-{
-	enum emulation_result er = EMULATE_DONE;
-	u32 exccode = (cause >> CAUSEB_EXCCODE) & 0x1f;
-	unsigned long badvaddr = vcpu->arch.host_cp0_badvaddr;
-
-	int usermode = !KVM_GUEST_KERNEL_MODE(vcpu);
-
-	if (usermode) {
-		switch (exccode) {
-		case EXCCODE_INT:
-		case EXCCODE_SYS:
-		case EXCCODE_BP:
-		case EXCCODE_RI:
-		case EXCCODE_TR:
-		case EXCCODE_MSAFPE:
-		case EXCCODE_FPE:
-		case EXCCODE_MSADIS:
-			break;
-
-		case EXCCODE_CPU:
-			if (((cause & CAUSEF_CE) >> CAUSEB_CE) == 0)
-				er = EMULATE_PRIV_FAIL;
-			break;
-
-		case EXCCODE_MOD:
-			break;
-
-		case EXCCODE_TLBL:
-			/*
-			 * We we are accessing Guest kernel space, then send an
-			 * address error exception to the guest
-			 */
-			if (badvaddr >= (unsigned long) KVM_GUEST_KSEG0) {
-				kvm_debug("%s: LD MISS @ %#lx\n", __func__,
-					  badvaddr);
-				cause &= ~0xff;
-				cause |= (EXCCODE_ADEL << CAUSEB_EXCCODE);
-				er = EMULATE_PRIV_FAIL;
-			}
-			break;
-
-		case EXCCODE_TLBS:
-			/*
-			 * We we are accessing Guest kernel space, then send an
-			 * address error exception to the guest
-			 */
-			if (badvaddr >= (unsigned long) KVM_GUEST_KSEG0) {
-				kvm_debug("%s: ST MISS @ %#lx\n", __func__,
-					  badvaddr);
-				cause &= ~0xff;
-				cause |= (EXCCODE_ADES << CAUSEB_EXCCODE);
-				er = EMULATE_PRIV_FAIL;
-			}
-			break;
-
-		case EXCCODE_ADES:
-			kvm_debug("%s: address error ST @ %#lx\n", __func__,
-				  badvaddr);
-			if ((badvaddr & PAGE_MASK) == KVM_GUEST_COMMPAGE_ADDR) {
-				cause &= ~0xff;
-				cause |= (EXCCODE_TLBS << CAUSEB_EXCCODE);
-			}
-			er = EMULATE_PRIV_FAIL;
-			break;
-		case EXCCODE_ADEL:
-			kvm_debug("%s: address error LD @ %#lx\n", __func__,
-				  badvaddr);
-			if ((badvaddr & PAGE_MASK) == KVM_GUEST_COMMPAGE_ADDR) {
-				cause &= ~0xff;
-				cause |= (EXCCODE_TLBL << CAUSEB_EXCCODE);
-			}
-			er = EMULATE_PRIV_FAIL;
-			break;
-		default:
-			er = EMULATE_PRIV_FAIL;
-			break;
-		}
-	}
-
-	if (er == EMULATE_PRIV_FAIL)
-		kvm_mips_emulate_exc(cause, opc, vcpu);
-
-	return er;
-}
-
-/*
- * User Address (UA) fault, this could happen if
- * (1) TLB entry not present/valid in both Guest and shadow host TLBs, in this
- *     case we pass on the fault to the guest kernel and let it handle it.
- * (2) TLB entry is present in the Guest TLB but not in the shadow, in this
- *     case we inject the TLB from the Guest TLB into the shadow host TLB
- */
-enum emulation_result kvm_mips_handle_tlbmiss(u32 cause,
-					      u32 *opc,
-					      struct kvm_vcpu *vcpu,
-					      bool write_fault)
-{
-	enum emulation_result er = EMULATE_DONE;
-	u32 exccode = (cause >> CAUSEB_EXCCODE) & 0x1f;
-	unsigned long va = vcpu->arch.host_cp0_badvaddr;
-	int index;
-
-	kvm_debug("kvm_mips_handle_tlbmiss: badvaddr: %#lx\n",
-		  vcpu->arch.host_cp0_badvaddr);
-
-	/*
-	 * KVM would not have got the exception if this entry was valid in the
-	 * shadow host TLB. Check the Guest TLB, if the entry is not there then
-	 * send the guest an exception. The guest exc handler should then inject
-	 * an entry into the guest TLB.
-	 */
-	index = kvm_mips_guest_tlb_lookup(vcpu,
-		      (va & VPN2_MASK) |
-		      (kvm_read_c0_guest_entryhi(vcpu->arch.cop0) &
-		       KVM_ENTRYHI_ASID));
-	if (index < 0) {
-		if (exccode == EXCCODE_TLBL) {
-			er = kvm_mips_emulate_tlbmiss_ld(cause, opc, vcpu);
-		} else if (exccode == EXCCODE_TLBS) {
-			er = kvm_mips_emulate_tlbmiss_st(cause, opc, vcpu);
-		} else {
-			kvm_err("%s: invalid exc code: %d\n", __func__,
-				exccode);
-			er = EMULATE_FAIL;
-		}
-	} else {
-		struct kvm_mips_tlb *tlb = &vcpu->arch.guest_tlb[index];
-
-		/*
-		 * Check if the entry is valid, if not then setup a TLB invalid
-		 * exception to the guest
-		 */
-		if (!TLB_IS_VALID(*tlb, va)) {
-			if (exccode == EXCCODE_TLBL) {
-				er = kvm_mips_emulate_tlbinv_ld(cause, opc,
-								vcpu);
-			} else if (exccode == EXCCODE_TLBS) {
-				er = kvm_mips_emulate_tlbinv_st(cause, opc,
-								vcpu);
-			} else {
-				kvm_err("%s: invalid exc code: %d\n", __func__,
-					exccode);
-				er = EMULATE_FAIL;
-			}
-		} else {
-			kvm_debug("Injecting hi: %#lx, lo0: %#lx, lo1: %#lx into shadow host TLB\n",
-				  tlb->tlb_hi, tlb->tlb_lo[0], tlb->tlb_lo[1]);
-			/*
-			 * OK we have a Guest TLB entry, now inject it into the
-			 * shadow host TLB
-			 */
-			if (kvm_mips_handle_mapped_seg_tlb_fault(vcpu, tlb, va,
-								 write_fault)) {
-				kvm_err("%s: handling mapped seg tlb fault for %lx, index: %u, vcpu: %p, ASID: %#lx\n",
-					__func__, va, index, vcpu,
-					read_c0_entryhi());
-				er = EMULATE_FAIL;
-			}
-		}
-	}
-
-	return er;
-}
diff --git a/arch/mips/kvm/entry.c b/arch/mips/kvm/entry.c
index 832475bf2055..8131fb2bdf97 100644
--- a/arch/mips/kvm/entry.c
+++ b/arch/mips/kvm/entry.c
@@ -305,7 +305,6 @@ static void *kvm_mips_build_enter_guest(void *addr)
 	UASM_i_LW(&p, T0, offsetof(struct kvm_vcpu_arch, pc), K1);
 	UASM_i_MTC0(&p, T0, C0_EPC);
 
-#ifdef CONFIG_KVM_MIPS_VZ
 	/* Save normal linux process pgd (VZ guarantees pgd_reg is set) */
 	if (cpu_has_ldpte)
 		UASM_i_MFC0(&p, K0, C0_PWBASE);
@@ -367,21 +366,6 @@ static void *kvm_mips_build_enter_guest(void *addr)
 	/* Set the root ASID for the Guest */
 	UASM_i_ADDIU(&p, T1, S0,
 		     offsetof(struct kvm, arch.gpa_mm.context.asid));
-#else
-	/* Set the ASID for the Guest Kernel or User */
-	UASM_i_LW(&p, T0, offsetof(struct kvm_vcpu_arch, cop0), K1);
-	UASM_i_LW(&p, T0, offsetof(struct mips_coproc, reg[MIPS_CP0_STATUS][0]),
-		  T0);
-	uasm_i_andi(&p, T0, T0, KSU_USER | ST0_ERL | ST0_EXL);
-	uasm_i_xori(&p, T0, T0, KSU_USER);
-	uasm_il_bnez(&p, &r, T0, label_kernel_asid);
-	 UASM_i_ADDIU(&p, T1, K1, offsetof(struct kvm_vcpu_arch,
-					   guest_kernel_mm.context.asid));
-	/* else user */
-	UASM_i_ADDIU(&p, T1, K1, offsetof(struct kvm_vcpu_arch,
-					  guest_user_mm.context.asid));
-	uasm_l_kernel_asid(&l, p);
-#endif
 
 	/* t1: contains the base of the ASID array, need to get the cpu id  */
 	/* smp_processor_id */
@@ -406,24 +390,9 @@ static void *kvm_mips_build_enter_guest(void *addr)
 	uasm_i_andi(&p, K0, K0, MIPS_ENTRYHI_ASID);
 #endif
 
-#ifndef CONFIG_KVM_MIPS_VZ
-	/*
-	 * Set up KVM T&E GVA pgd.
-	 * This does roughly the same as TLBMISS_HANDLER_SETUP_PGD():
-	 * - call tlbmiss_handler_setup_pgd(mm->pgd)
-	 * - but skips write into CP0_PWBase for now
-	 */
-	UASM_i_LW(&p, A0, (int)offsetof(struct mm_struct, pgd) -
-			  (int)offsetof(struct mm_struct, context.asid), T1);
-
-	UASM_i_LA(&p, T9, (unsigned long)tlbmiss_handler_setup_pgd);
-	uasm_i_jalr(&p, RA, T9);
-	 uasm_i_mtc0(&p, K0, C0_ENTRYHI);
-#else
 	/* Set up KVM VZ root ASID (!guestid) */
 	uasm_i_mtc0(&p, K0, C0_ENTRYHI);
 skip_asid_restore:
-#endif
 	uasm_i_ehb(&p);
 
 	/* Disable RDHWR access */
@@ -720,7 +689,6 @@ void *kvm_mips_build_exit(void *addr)
 		uasm_l_msa_1(&l, p);
 	}
 
-#ifdef CONFIG_KVM_MIPS_VZ
 	/* Restore host ASID */
 	if (!cpu_has_guestid) {
 		UASM_i_LW(&p, K0, offsetof(struct kvm_vcpu_arch, host_entryhi),
@@ -764,7 +732,6 @@ void *kvm_mips_build_exit(void *addr)
 			   MIPS_GCTL1_RID_WIDTH);
 		uasm_i_mtc0(&p, T0, C0_GUESTCTL1);
 	}
-#endif
 
 	/* Now that the new EBASE has been loaded, unset BEV and KSU_USER */
 	uasm_i_addiu(&p, AT, ZERO, ~(ST0_EXL | KSU_USER | ST0_IE));
diff --git a/arch/mips/kvm/interrupt.c b/arch/mips/kvm/interrupt.c
index d28c2c9c343e..0277942279ea 100644
--- a/arch/mips/kvm/interrupt.c
+++ b/arch/mips/kvm/interrupt.c
@@ -21,119 +21,6 @@
 
 #include "interrupt.h"
 
-void kvm_mips_queue_irq(struct kvm_vcpu *vcpu, unsigned int priority)
-{
-	set_bit(priority, &vcpu->arch.pending_exceptions);
-}
-
-void kvm_mips_dequeue_irq(struct kvm_vcpu *vcpu, unsigned int priority)
-{
-	clear_bit(priority, &vcpu->arch.pending_exceptions);
-}
-
-void kvm_mips_queue_timer_int_cb(struct kvm_vcpu *vcpu)
-{
-	/*
-	 * Cause bits to reflect the pending timer interrupt,
-	 * the EXC code will be set when we are actually
-	 * delivering the interrupt:
-	 */
-	kvm_set_c0_guest_cause(vcpu->arch.cop0, (C_IRQ5 | C_TI));
-
-	/* Queue up an INT exception for the core */
-	kvm_mips_queue_irq(vcpu, MIPS_EXC_INT_TIMER);
-
-}
-
-void kvm_mips_dequeue_timer_int_cb(struct kvm_vcpu *vcpu)
-{
-	kvm_clear_c0_guest_cause(vcpu->arch.cop0, (C_IRQ5 | C_TI));
-	kvm_mips_dequeue_irq(vcpu, MIPS_EXC_INT_TIMER);
-}
-
-void kvm_mips_queue_io_int_cb(struct kvm_vcpu *vcpu,
-			      struct kvm_mips_interrupt *irq)
-{
-	int intr = (int)irq->irq;
-
-	/*
-	 * Cause bits to reflect the pending IO interrupt,
-	 * the EXC code will be set when we are actually
-	 * delivering the interrupt:
-	 */
-	kvm_set_c0_guest_cause(vcpu->arch.cop0, 1 << (intr + 8));
-	kvm_mips_queue_irq(vcpu, kvm_irq_to_priority(intr));
-}
-
-void kvm_mips_dequeue_io_int_cb(struct kvm_vcpu *vcpu,
-				struct kvm_mips_interrupt *irq)
-{
-	int intr = (int)irq->irq;
-
-	kvm_clear_c0_guest_cause(vcpu->arch.cop0, 1 << (-intr + 8));
-	kvm_mips_dequeue_irq(vcpu, kvm_irq_to_priority(-intr));
-}
-
-/* Deliver the interrupt of the corresponding priority, if possible. */
-int kvm_mips_irq_deliver_cb(struct kvm_vcpu *vcpu, unsigned int priority,
-			    u32 cause)
-{
-	int allowed = 0;
-	u32 exccode, ie;
-
-	struct kvm_vcpu_arch *arch = &vcpu->arch;
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-
-	if (priority == MIPS_EXC_MAX)
-		return 0;
-
-	ie = 1 << (kvm_priority_to_irq[priority] + 8);
-	if ((kvm_read_c0_guest_status(cop0) & ST0_IE)
-	    && (!(kvm_read_c0_guest_status(cop0) & (ST0_EXL | ST0_ERL)))
-	    && (kvm_read_c0_guest_status(cop0) & ie)) {
-		allowed = 1;
-		exccode = EXCCODE_INT;
-	}
-
-	/* Are we allowed to deliver the interrupt ??? */
-	if (allowed) {
-		if ((kvm_read_c0_guest_status(cop0) & ST0_EXL) == 0) {
-			/* save old pc */
-			kvm_write_c0_guest_epc(cop0, arch->pc);
-			kvm_set_c0_guest_status(cop0, ST0_EXL);
-
-			if (cause & CAUSEF_BD)
-				kvm_set_c0_guest_cause(cop0, CAUSEF_BD);
-			else
-				kvm_clear_c0_guest_cause(cop0, CAUSEF_BD);
-
-			kvm_debug("Delivering INT @ pc %#lx\n", arch->pc);
-
-		} else
-			kvm_err("Trying to deliver interrupt when EXL is already set\n");
-
-		kvm_change_c0_guest_cause(cop0, CAUSEF_EXCCODE,
-					  (exccode << CAUSEB_EXCCODE));
-
-		/* XXXSL Set PC to the interrupt exception entry point */
-		arch->pc = kvm_mips_guest_exception_base(vcpu);
-		if (kvm_read_c0_guest_cause(cop0) & CAUSEF_IV)
-			arch->pc += 0x200;
-		else
-			arch->pc += 0x180;
-
-		clear_bit(priority, &vcpu->arch.pending_exceptions);
-	}
-
-	return allowed;
-}
-
-int kvm_mips_irq_clear_cb(struct kvm_vcpu *vcpu, unsigned int priority,
-			  u32 cause)
-{
-	return 1;
-}
-
 void kvm_mips_deliver_interrupts(struct kvm_vcpu *vcpu, u32 cause)
 {
 	unsigned long *pending = &vcpu->arch.pending_exceptions;
@@ -145,10 +32,7 @@ void kvm_mips_deliver_interrupts(struct kvm_vcpu *vcpu, u32 cause)
 
 	priority = __ffs(*pending_clr);
 	while (priority <= MIPS_EXC_MAX) {
-		if (kvm_mips_callbacks->irq_clear(vcpu, priority, cause)) {
-			if (!KVM_MIPS_IRQ_CLEAR_ALL_AT_ONCE)
-				break;
-		}
+		kvm_mips_callbacks->irq_clear(vcpu, priority, cause);
 
 		priority = find_next_bit(pending_clr,
 					 BITS_PER_BYTE * sizeof(*pending_clr),
@@ -157,10 +41,7 @@ void kvm_mips_deliver_interrupts(struct kvm_vcpu *vcpu, u32 cause)
 
 	priority = __ffs(*pending);
 	while (priority <= MIPS_EXC_MAX) {
-		if (kvm_mips_callbacks->irq_deliver(vcpu, priority, cause)) {
-			if (!KVM_MIPS_IRQ_DELIVER_ALL_AT_ONCE)
-				break;
-		}
+		kvm_mips_callbacks->irq_deliver(vcpu, priority, cause);
 
 		priority = find_next_bit(pending,
 					 BITS_PER_BYTE * sizeof(*pending),
diff --git a/arch/mips/kvm/interrupt.h b/arch/mips/kvm/interrupt.h
index c3e878ca3e07..e529ea2bb34b 100644
--- a/arch/mips/kvm/interrupt.h
+++ b/arch/mips/kvm/interrupt.h
@@ -31,29 +31,9 @@
 
 #define C_TI        (_ULCAST_(1) << 30)
 
-#ifdef CONFIG_KVM_MIPS_VZ
-#define KVM_MIPS_IRQ_DELIVER_ALL_AT_ONCE (1)
-#define KVM_MIPS_IRQ_CLEAR_ALL_AT_ONCE   (1)
-#else
-#define KVM_MIPS_IRQ_DELIVER_ALL_AT_ONCE (0)
-#define KVM_MIPS_IRQ_CLEAR_ALL_AT_ONCE   (0)
-#endif
-
 extern u32 *kvm_priority_to_irq;
 u32 kvm_irq_to_priority(u32 irq);
 
-void kvm_mips_queue_irq(struct kvm_vcpu *vcpu, unsigned int priority);
-void kvm_mips_dequeue_irq(struct kvm_vcpu *vcpu, unsigned int priority);
 int kvm_mips_pending_timer(struct kvm_vcpu *vcpu);
 
-void kvm_mips_queue_timer_int_cb(struct kvm_vcpu *vcpu);
-void kvm_mips_dequeue_timer_int_cb(struct kvm_vcpu *vcpu);
-void kvm_mips_queue_io_int_cb(struct kvm_vcpu *vcpu,
-			      struct kvm_mips_interrupt *irq);
-void kvm_mips_dequeue_io_int_cb(struct kvm_vcpu *vcpu,
-				struct kvm_mips_interrupt *irq);
-int kvm_mips_irq_deliver_cb(struct kvm_vcpu *vcpu, unsigned int priority,
-			    u32 cause);
-int kvm_mips_irq_clear_cb(struct kvm_vcpu *vcpu, unsigned int priority,
-			  u32 cause);
 void kvm_mips_deliver_interrupts(struct kvm_vcpu *vcpu, u32 cause);
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 58a8812e2fa5..29d37ba1bea2 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -30,7 +30,6 @@
 #include <linux/kvm_host.h>
 
 #include "interrupt.h"
-#include "commpage.h"
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -58,7 +57,6 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("fpe", fpe_exits),
 	VCPU_STAT("msa_disabled", msa_disabled_exits),
 	VCPU_STAT("flush_dcache", flush_dcache_exits),
-#ifdef CONFIG_KVM_MIPS_VZ
 	VCPU_STAT("vz_gpsi", vz_gpsi_exits),
 	VCPU_STAT("vz_gsfc", vz_gsfc_exits),
 	VCPU_STAT("vz_hc", vz_hc_exits),
@@ -69,7 +67,6 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("vz_resvd", vz_resvd_exits),
 #ifdef CONFIG_CPU_LOONGSON64
 	VCPU_STAT("vz_cpucfg", vz_cpucfg_exits),
-#endif
 #endif
 	VCPU_STAT("halt_successful_poll", halt_successful_poll),
 	VCPU_STAT("halt_attempted_poll", halt_attempted_poll),
@@ -139,11 +136,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	switch (type) {
 	case KVM_VM_MIPS_AUTO:
 		break;
-#ifdef CONFIG_KVM_MIPS_VZ
 	case KVM_VM_MIPS_VZ:
-#else
-	case KVM_VM_MIPS_TE:
-#endif
 		break;
 	default:
 		/* Unsupported KVM type */
@@ -361,7 +354,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	/* TLB refill (or XTLB refill on 64-bit VZ where KX=1) */
 	refill_start = gebase;
-	if (IS_ENABLED(CONFIG_KVM_MIPS_VZ) && IS_ENABLED(CONFIG_64BIT))
+	if (IS_ENABLED(CONFIG_64BIT))
 		refill_start += 0x080;
 	refill_end = kvm_mips_build_tlb_refill_exception(refill_start, handler);
 
@@ -397,20 +390,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	flush_icache_range((unsigned long)gebase,
 			   (unsigned long)gebase + ALIGN(size, PAGE_SIZE));
 
-	/*
-	 * Allocate comm page for guest kernel, a TLB will be reserved for
-	 * mapping GVA @ 0xFFFF8000 to this page
-	 */
-	vcpu->arch.kseg0_commpage = kzalloc(PAGE_SIZE << 1, GFP_KERNEL);
-
-	if (!vcpu->arch.kseg0_commpage) {
-		err = -ENOMEM;
-		goto out_free_gebase;
-	}
-
-	kvm_debug("Allocated COMM page @ %p\n", vcpu->arch.kseg0_commpage);
-	kvm_mips_commpage_init(vcpu);
-
 	/* Init */
 	vcpu->arch.last_sched_cpu = -1;
 	vcpu->arch.last_exec_cpu = -1;
@@ -418,12 +397,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	/* Initial guest state */
 	err = kvm_mips_callbacks->vcpu_setup(vcpu);
 	if (err)
-		goto out_free_commpage;
+		goto out_free_gebase;
 
 	return 0;
 
-out_free_commpage:
-	kfree(vcpu->arch.kseg0_commpage);
 out_free_gebase:
 	kfree(gebase);
 out_uninit_vcpu:
@@ -439,7 +416,6 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 	kvm_mmu_free_memory_caches(vcpu);
 	kfree(vcpu->arch.guest_ebase);
-	kfree(vcpu->arch.kseg0_commpage);
 
 	kvm_mips_callbacks->vcpu_uninit(vcpu);
 }
@@ -1212,10 +1188,6 @@ int kvm_mips_handle_exit(struct kvm_vcpu *vcpu)
 
 	vcpu->mode = OUTSIDE_GUEST_MODE;
 
-	/* re-enable HTW before enabling interrupts */
-	if (!IS_ENABLED(CONFIG_KVM_MIPS_VZ))
-		htw_start();
-
 	/* Set a default exit reason */
 	run->exit_reason = KVM_EXIT_UNKNOWN;
 	run->ready_for_interrupt_injection = 1;
@@ -1232,22 +1204,6 @@ int kvm_mips_handle_exit(struct kvm_vcpu *vcpu)
 			cause, opc, run, vcpu);
 	trace_kvm_exit(vcpu, exccode);
 
-	if (!IS_ENABLED(CONFIG_KVM_MIPS_VZ)) {
-		/*
-		 * Do a privilege check, if in UM most of these exit conditions
-		 * end up causing an exception to be delivered to the Guest
-		 * Kernel
-		 */
-		er = kvm_mips_check_privilege(cause, opc, vcpu);
-		if (er == EMULATE_PRIV_FAIL) {
-			goto skip_emul;
-		} else if (er == EMULATE_FAIL) {
-			run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-			ret = RESUME_HOST;
-			goto skip_emul;
-		}
-	}
-
 	switch (exccode) {
 	case EXCCODE_INT:
 		kvm_debug("[%d]EXCCODE_INT @ %p\n", vcpu->vcpu_id, opc);
@@ -1357,7 +1313,6 @@ int kvm_mips_handle_exit(struct kvm_vcpu *vcpu)
 
 	}
 
-skip_emul:
 	local_irq_disable();
 
 	if (ret == RESUME_GUEST)
@@ -1406,11 +1361,6 @@ int kvm_mips_handle_exit(struct kvm_vcpu *vcpu)
 		    read_c0_config5() & MIPS_CONF5_MSAEN)
 			__kvm_restore_msacsr(&vcpu->arch);
 	}
-
-	/* Disable HTW before returning to guest or host */
-	if (!IS_ENABLED(CONFIG_KVM_MIPS_VZ))
-		htw_stop();
-
 	return ret;
 }
 
@@ -1429,10 +1379,6 @@ void kvm_own_fpu(struct kvm_vcpu *vcpu)
 	 * FR=0 FPU state, and we don't want to hit reserved instruction
 	 * exceptions trying to save the MSA state later when CU=1 && FR=1, so
 	 * play it safe and save it first.
-	 *
-	 * In theory we shouldn't ever hit this case since kvm_lose_fpu() should
-	 * get called when guest CU1 is set, however we can't trust the guest
-	 * not to clobber the status register directly via the commpage.
 	 */
 	if (cpu_has_msa && sr & ST0_CU1 && !(sr & ST0_FR) &&
 	    vcpu->arch.aux_inuse & KVM_MIPS_AUX_MSA)
@@ -1553,11 +1499,6 @@ void kvm_lose_fpu(struct kvm_vcpu *vcpu)
 
 	preempt_disable();
 	if (cpu_has_msa && vcpu->arch.aux_inuse & KVM_MIPS_AUX_MSA) {
-		if (!IS_ENABLED(CONFIG_KVM_MIPS_VZ)) {
-			set_c0_config5(MIPS_CONF5_MSAEN);
-			enable_fpu_hazard();
-		}
-
 		__kvm_save_msa(&vcpu->arch);
 		trace_kvm_aux(vcpu, KVM_TRACE_AUX_SAVE, KVM_TRACE_AUX_FPU_MSA);
 
@@ -1569,11 +1510,6 @@ void kvm_lose_fpu(struct kvm_vcpu *vcpu)
 		}
 		vcpu->arch.aux_inuse &= ~(KVM_MIPS_AUX_FPU | KVM_MIPS_AUX_MSA);
 	} else if (vcpu->arch.aux_inuse & KVM_MIPS_AUX_FPU) {
-		if (!IS_ENABLED(CONFIG_KVM_MIPS_VZ)) {
-			set_c0_status(ST0_CU1);
-			enable_fpu_hazard();
-		}
-
 		__kvm_save_fpu(&vcpu->arch);
 		vcpu->arch.aux_inuse &= ~KVM_MIPS_AUX_FPU;
 		trace_kvm_aux(vcpu, KVM_TRACE_AUX_SAVE, KVM_TRACE_AUX_FPU);
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index 3dabeda82458..190ca2451851 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -756,209 +756,6 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 	return err;
 }
 
-static pte_t *kvm_trap_emul_pte_for_gva(struct kvm_vcpu *vcpu,
-					unsigned long addr)
-{
-	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
-	pgd_t *pgdp;
-	int ret;
-
-	/* We need a minimum of cached pages ready for page table creation */
-	ret = kvm_mmu_topup_memory_cache(memcache, KVM_MMU_CACHE_MIN_PAGES);
-	if (ret)
-		return NULL;
-
-	if (KVM_GUEST_KERNEL_MODE(vcpu))
-		pgdp = vcpu->arch.guest_kernel_mm.pgd;
-	else
-		pgdp = vcpu->arch.guest_user_mm.pgd;
-
-	return kvm_mips_walk_pgd(pgdp, memcache, addr);
-}
-
-void kvm_trap_emul_invalidate_gva(struct kvm_vcpu *vcpu, unsigned long addr,
-				  bool user)
-{
-	pgd_t *pgdp;
-	pte_t *ptep;
-
-	addr &= PAGE_MASK << 1;
-
-	pgdp = vcpu->arch.guest_kernel_mm.pgd;
-	ptep = kvm_mips_walk_pgd(pgdp, NULL, addr);
-	if (ptep) {
-		ptep[0] = pfn_pte(0, __pgprot(0));
-		ptep[1] = pfn_pte(0, __pgprot(0));
-	}
-
-	if (user) {
-		pgdp = vcpu->arch.guest_user_mm.pgd;
-		ptep = kvm_mips_walk_pgd(pgdp, NULL, addr);
-		if (ptep) {
-			ptep[0] = pfn_pte(0, __pgprot(0));
-			ptep[1] = pfn_pte(0, __pgprot(0));
-		}
-	}
-}
-
-/*
- * kvm_mips_flush_gva_{pte,pmd,pud,pgd,pt}.
- * Flush a range of guest physical address space from the VM's GPA page tables.
- */
-
-static bool kvm_mips_flush_gva_pte(pte_t *pte, unsigned long start_gva,
-				   unsigned long end_gva)
-{
-	int i_min = pte_index(start_gva);
-	int i_max = pte_index(end_gva);
-	bool safe_to_remove = (i_min == 0 && i_max == PTRS_PER_PTE - 1);
-	int i;
-
-	/*
-	 * There's no freeing to do, so there's no point clearing individual
-	 * entries unless only part of the last level page table needs flushing.
-	 */
-	if (safe_to_remove)
-		return true;
-
-	for (i = i_min; i <= i_max; ++i) {
-		if (!pte_present(pte[i]))
-			continue;
-
-		set_pte(pte + i, __pte(0));
-	}
-	return false;
-}
-
-static bool kvm_mips_flush_gva_pmd(pmd_t *pmd, unsigned long start_gva,
-				   unsigned long end_gva)
-{
-	pte_t *pte;
-	unsigned long end = ~0ul;
-	int i_min = pmd_index(start_gva);
-	int i_max = pmd_index(end_gva);
-	bool safe_to_remove = (i_min == 0 && i_max == PTRS_PER_PMD - 1);
-	int i;
-
-	for (i = i_min; i <= i_max; ++i, start_gva = 0) {
-		if (!pmd_present(pmd[i]))
-			continue;
-
-		pte = pte_offset_kernel(pmd + i, 0);
-		if (i == i_max)
-			end = end_gva;
-
-		if (kvm_mips_flush_gva_pte(pte, start_gva, end)) {
-			pmd_clear(pmd + i);
-			pte_free_kernel(NULL, pte);
-		} else {
-			safe_to_remove = false;
-		}
-	}
-	return safe_to_remove;
-}
-
-static bool kvm_mips_flush_gva_pud(pud_t *pud, unsigned long start_gva,
-				   unsigned long end_gva)
-{
-	pmd_t *pmd;
-	unsigned long end = ~0ul;
-	int i_min = pud_index(start_gva);
-	int i_max = pud_index(end_gva);
-	bool safe_to_remove = (i_min == 0 && i_max == PTRS_PER_PUD - 1);
-	int i;
-
-	for (i = i_min; i <= i_max; ++i, start_gva = 0) {
-		if (!pud_present(pud[i]))
-			continue;
-
-		pmd = pmd_offset(pud + i, 0);
-		if (i == i_max)
-			end = end_gva;
-
-		if (kvm_mips_flush_gva_pmd(pmd, start_gva, end)) {
-			pud_clear(pud + i);
-			pmd_free(NULL, pmd);
-		} else {
-			safe_to_remove = false;
-		}
-	}
-	return safe_to_remove;
-}
-
-static bool kvm_mips_flush_gva_pgd(pgd_t *pgd, unsigned long start_gva,
-				   unsigned long end_gva)
-{
-	p4d_t *p4d;
-	pud_t *pud;
-	unsigned long end = ~0ul;
-	int i_min = pgd_index(start_gva);
-	int i_max = pgd_index(end_gva);
-	bool safe_to_remove = (i_min == 0 && i_max == PTRS_PER_PGD - 1);
-	int i;
-
-	for (i = i_min; i <= i_max; ++i, start_gva = 0) {
-		if (!pgd_present(pgd[i]))
-			continue;
-
-		p4d = p4d_offset(pgd, 0);
-		pud = pud_offset(p4d + i, 0);
-		if (i == i_max)
-			end = end_gva;
-
-		if (kvm_mips_flush_gva_pud(pud, start_gva, end)) {
-			pgd_clear(pgd + i);
-			pud_free(NULL, pud);
-		} else {
-			safe_to_remove = false;
-		}
-	}
-	return safe_to_remove;
-}
-
-void kvm_mips_flush_gva_pt(pgd_t *pgd, enum kvm_mips_flush flags)
-{
-	if (flags & KMF_GPA) {
-		/* all of guest virtual address space could be affected */
-		if (flags & KMF_KERN)
-			/* useg, kseg0, seg2/3 */
-			kvm_mips_flush_gva_pgd(pgd, 0, 0x7fffffff);
-		else
-			/* useg */
-			kvm_mips_flush_gva_pgd(pgd, 0, 0x3fffffff);
-	} else {
-		/* useg */
-		kvm_mips_flush_gva_pgd(pgd, 0, 0x3fffffff);
-
-		/* kseg2/3 */
-		if (flags & KMF_KERN)
-			kvm_mips_flush_gva_pgd(pgd, 0x60000000, 0x7fffffff);
-	}
-}
-
-static pte_t kvm_mips_gpa_pte_to_gva_unmapped(pte_t pte)
-{
-	/*
-	 * Don't leak writeable but clean entries from GPA page tables. We don't
-	 * want the normal Linux tlbmod handler to handle dirtying when KVM
-	 * accesses guest memory.
-	 */
-	if (!pte_dirty(pte))
-		pte = pte_wrprotect(pte);
-
-	return pte;
-}
-
-static pte_t kvm_mips_gpa_pte_to_gva_mapped(pte_t pte, long entrylo)
-{
-	/* Guest EntryLo overrides host EntryLo */
-	if (!(entrylo & ENTRYLO_D))
-		pte = pte_mkclean(pte);
-
-	return kvm_mips_gpa_pte_to_gva_unmapped(pte);
-}
-
-#ifdef CONFIG_KVM_MIPS_VZ
 int kvm_mips_handle_vz_root_tlb_fault(unsigned long badvaddr,
 				      struct kvm_vcpu *vcpu,
 				      bool write_fault)
@@ -972,125 +769,6 @@ int kvm_mips_handle_vz_root_tlb_fault(unsigned long badvaddr,
 	/* Invalidate this entry in the TLB */
 	return kvm_vz_host_tlb_inv(vcpu, badvaddr);
 }
-#endif
-
-/* XXXKYMA: Must be called with interrupts disabled */
-int kvm_mips_handle_kseg0_tlb_fault(unsigned long badvaddr,
-				    struct kvm_vcpu *vcpu,
-				    bool write_fault)
-{
-	unsigned long gpa;
-	pte_t pte_gpa[2], *ptep_gva;
-	int idx;
-
-	if (KVM_GUEST_KSEGX(badvaddr) != KVM_GUEST_KSEG0) {
-		kvm_err("%s: Invalid BadVaddr: %#lx\n", __func__, badvaddr);
-		kvm_mips_dump_host_tlbs();
-		return -1;
-	}
-
-	/* Get the GPA page table entry */
-	gpa = KVM_GUEST_CPHYSADDR(badvaddr);
-	idx = (badvaddr >> PAGE_SHIFT) & 1;
-	if (kvm_mips_map_page(vcpu, gpa, write_fault, &pte_gpa[idx],
-			      &pte_gpa[!idx]) < 0)
-		return -1;
-
-	/* Get the GVA page table entry */
-	ptep_gva = kvm_trap_emul_pte_for_gva(vcpu, badvaddr & ~PAGE_SIZE);
-	if (!ptep_gva) {
-		kvm_err("No ptep for gva %lx\n", badvaddr);
-		return -1;
-	}
-
-	/* Copy a pair of entries from GPA page table to GVA page table */
-	ptep_gva[0] = kvm_mips_gpa_pte_to_gva_unmapped(pte_gpa[0]);
-	ptep_gva[1] = kvm_mips_gpa_pte_to_gva_unmapped(pte_gpa[1]);
-
-	/* Invalidate this entry in the TLB, guest kernel ASID only */
-	kvm_mips_host_tlb_inv(vcpu, badvaddr, false, true);
-	return 0;
-}
-
-int kvm_mips_handle_mapped_seg_tlb_fault(struct kvm_vcpu *vcpu,
-					 struct kvm_mips_tlb *tlb,
-					 unsigned long gva,
-					 bool write_fault)
-{
-	struct kvm *kvm = vcpu->kvm;
-	long tlb_lo[2];
-	pte_t pte_gpa[2], *ptep_buddy, *ptep_gva;
-	unsigned int idx = TLB_LO_IDX(*tlb, gva);
-	bool kernel = KVM_GUEST_KERNEL_MODE(vcpu);
-
-	tlb_lo[0] = tlb->tlb_lo[0];
-	tlb_lo[1] = tlb->tlb_lo[1];
-
-	/*
-	 * The commpage address must not be mapped to anything else if the guest
-	 * TLB contains entries nearby, or commpage accesses will break.
-	 */
-	if (!((gva ^ KVM_GUEST_COMMPAGE_ADDR) & VPN2_MASK & (PAGE_MASK << 1)))
-		tlb_lo[TLB_LO_IDX(*tlb, KVM_GUEST_COMMPAGE_ADDR)] = 0;
-
-	/* Get the GPA page table entry */
-	if (kvm_mips_map_page(vcpu, mips3_tlbpfn_to_paddr(tlb_lo[idx]),
-			      write_fault, &pte_gpa[idx], NULL) < 0)
-		return -1;
-
-	/* And its GVA buddy's GPA page table entry if it also exists */
-	pte_gpa[!idx] = pfn_pte(0, __pgprot(0));
-	if (tlb_lo[!idx] & ENTRYLO_V) {
-		spin_lock(&kvm->mmu_lock);
-		ptep_buddy = kvm_mips_pte_for_gpa(kvm, NULL,
-					mips3_tlbpfn_to_paddr(tlb_lo[!idx]));
-		if (ptep_buddy)
-			pte_gpa[!idx] = *ptep_buddy;
-		spin_unlock(&kvm->mmu_lock);
-	}
-
-	/* Get the GVA page table entry pair */
-	ptep_gva = kvm_trap_emul_pte_for_gva(vcpu, gva & ~PAGE_SIZE);
-	if (!ptep_gva) {
-		kvm_err("No ptep for gva %lx\n", gva);
-		return -1;
-	}
-
-	/* Copy a pair of entries from GPA page table to GVA page table */
-	ptep_gva[0] = kvm_mips_gpa_pte_to_gva_mapped(pte_gpa[0], tlb_lo[0]);
-	ptep_gva[1] = kvm_mips_gpa_pte_to_gva_mapped(pte_gpa[1], tlb_lo[1]);
-
-	/* Invalidate this entry in the TLB, current guest mode ASID only */
-	kvm_mips_host_tlb_inv(vcpu, gva, !kernel, kernel);
-
-	kvm_debug("@ %#lx tlb_lo0: 0x%08lx tlb_lo1: 0x%08lx\n", vcpu->arch.pc,
-		  tlb->tlb_lo[0], tlb->tlb_lo[1]);
-
-	return 0;
-}
-
-int kvm_mips_handle_commpage_tlb_fault(unsigned long badvaddr,
-				       struct kvm_vcpu *vcpu)
-{
-	kvm_pfn_t pfn;
-	pte_t *ptep;
-	pgprot_t prot;
-
-	ptep = kvm_trap_emul_pte_for_gva(vcpu, badvaddr);
-	if (!ptep) {
-		kvm_err("No ptep for commpage %lx\n", badvaddr);
-		return -1;
-	}
-
-	pfn = PFN_DOWN(virt_to_phys(vcpu->arch.kseg0_commpage));
-	/* Also set valid and dirty, so refill handler doesn't have to */
-	prot = vm_get_page_prot(VM_READ|VM_WRITE|VM_SHARED);
-	*ptep = pte_mkyoung(pte_mkdirty(pfn_pte(pfn, prot)));
-
-	/* Invalidate this entry in the TLB, guest kernel ASID only */
-	kvm_mips_host_tlb_inv(vcpu, badvaddr, false, true);
-	return 0;
-}
 
 /**
  * kvm_mips_migrate_count() - Migrate timer.
@@ -1153,86 +831,3 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 
 	local_irq_restore(flags);
 }
-
-/**
- * kvm_trap_emul_gva_fault() - Safely attempt to handle a GVA access fault.
- * @vcpu:	Virtual CPU.
- * @gva:	Guest virtual address to be accessed.
- * @write:	True if write attempted (must be dirtied and made writable).
- *
- * Safely attempt to handle a GVA fault, mapping GVA pages if necessary, and
- * dirtying the page if @write so that guest instructions can be modified.
- *
- * Returns:	KVM_MIPS_MAPPED on success.
- *		KVM_MIPS_GVA if bad guest virtual address.
- *		KVM_MIPS_GPA if bad guest physical address.
- *		KVM_MIPS_TLB if guest TLB not present.
- *		KVM_MIPS_TLBINV if guest TLB present but not valid.
- *		KVM_MIPS_TLBMOD if guest TLB read only.
- */
-enum kvm_mips_fault_result kvm_trap_emul_gva_fault(struct kvm_vcpu *vcpu,
-						   unsigned long gva,
-						   bool write)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	struct kvm_mips_tlb *tlb;
-	int index;
-
-	if (KVM_GUEST_KSEGX(gva) == KVM_GUEST_KSEG0) {
-		if (kvm_mips_handle_kseg0_tlb_fault(gva, vcpu, write) < 0)
-			return KVM_MIPS_GPA;
-	} else if ((KVM_GUEST_KSEGX(gva) < KVM_GUEST_KSEG0) ||
-		   KVM_GUEST_KSEGX(gva) == KVM_GUEST_KSEG23) {
-		/* Address should be in the guest TLB */
-		index = kvm_mips_guest_tlb_lookup(vcpu, (gva & VPN2_MASK) |
-			  (kvm_read_c0_guest_entryhi(cop0) & KVM_ENTRYHI_ASID));
-		if (index < 0)
-			return KVM_MIPS_TLB;
-		tlb = &vcpu->arch.guest_tlb[index];
-
-		/* Entry should be valid, and dirty for writes */
-		if (!TLB_IS_VALID(*tlb, gva))
-			return KVM_MIPS_TLBINV;
-		if (write && !TLB_IS_DIRTY(*tlb, gva))
-			return KVM_MIPS_TLBMOD;
-
-		if (kvm_mips_handle_mapped_seg_tlb_fault(vcpu, tlb, gva, write))
-			return KVM_MIPS_GPA;
-	} else {
-		return KVM_MIPS_GVA;
-	}
-
-	return KVM_MIPS_MAPPED;
-}
-
-int kvm_get_inst(u32 *opc, struct kvm_vcpu *vcpu, u32 *out)
-{
-	int err;
-
-	if (WARN(IS_ENABLED(CONFIG_KVM_MIPS_VZ),
-		 "Expect BadInstr/BadInstrP registers to be used with VZ\n"))
-		return -EINVAL;
-
-retry:
-	kvm_trap_emul_gva_lockless_begin(vcpu);
-	err = get_user(*out, opc);
-	kvm_trap_emul_gva_lockless_end(vcpu);
-
-	if (unlikely(err)) {
-		/*
-		 * Try to handle the fault, maybe we just raced with a GVA
-		 * invalidation.
-		 */
-		err = kvm_trap_emul_gva_fault(vcpu, (unsigned long)opc,
-					      false);
-		if (unlikely(err)) {
-			kvm_err("%s: illegal address: %p\n",
-				__func__, opc);
-			return -EFAULT;
-		}
-
-		/* Hopefully it'll work now */
-		goto retry;
-	}
-	return 0;
-}
diff --git a/arch/mips/kvm/tlb.c b/arch/mips/kvm/tlb.c
index 1c1fbce3f566..1088114e5482 100644
--- a/arch/mips/kvm/tlb.c
+++ b/arch/mips/kvm/tlb.c
@@ -30,10 +30,6 @@
 #include <asm/r4kcache.h>
 #define CONFIG_MIPS_MT
 
-#define KVM_GUEST_PC_TLB    0
-#define KVM_GUEST_SP_TLB    1
-
-#ifdef CONFIG_KVM_MIPS_VZ
 unsigned long GUESTID_MASK;
 EXPORT_SYMBOL_GPL(GUESTID_MASK);
 unsigned long GUESTID_FIRST_VERSION;
@@ -50,91 +46,6 @@ static u32 kvm_mips_get_root_asid(struct kvm_vcpu *vcpu)
 	else
 		return cpu_asid(smp_processor_id(), gpa_mm);
 }
-#endif
-
-static u32 kvm_mips_get_kernel_asid(struct kvm_vcpu *vcpu)
-{
-	struct mm_struct *kern_mm = &vcpu->arch.guest_kernel_mm;
-	int cpu = smp_processor_id();
-
-	return cpu_asid(cpu, kern_mm);
-}
-
-static u32 kvm_mips_get_user_asid(struct kvm_vcpu *vcpu)
-{
-	struct mm_struct *user_mm = &vcpu->arch.guest_user_mm;
-	int cpu = smp_processor_id();
-
-	return cpu_asid(cpu, user_mm);
-}
-
-/* Structure defining an tlb entry data set. */
-
-void kvm_mips_dump_host_tlbs(void)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-
-	kvm_info("HOST TLBs:\n");
-	dump_tlb_regs();
-	pr_info("\n");
-	dump_tlb_all();
-
-	local_irq_restore(flags);
-}
-EXPORT_SYMBOL_GPL(kvm_mips_dump_host_tlbs);
-
-void kvm_mips_dump_guest_tlbs(struct kvm_vcpu *vcpu)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	struct kvm_mips_tlb tlb;
-	int i;
-
-	kvm_info("Guest TLBs:\n");
-	kvm_info("Guest EntryHi: %#lx\n", kvm_read_c0_guest_entryhi(cop0));
-
-	for (i = 0; i < KVM_MIPS_GUEST_TLB_SIZE; i++) {
-		tlb = vcpu->arch.guest_tlb[i];
-		kvm_info("TLB%c%3d Hi 0x%08lx ",
-			 (tlb.tlb_lo[0] | tlb.tlb_lo[1]) & ENTRYLO_V
-							? ' ' : '*',
-			 i, tlb.tlb_hi);
-		kvm_info("Lo0=0x%09llx %c%c attr %lx ",
-			 (u64) mips3_tlbpfn_to_paddr(tlb.tlb_lo[0]),
-			 (tlb.tlb_lo[0] & ENTRYLO_D) ? 'D' : ' ',
-			 (tlb.tlb_lo[0] & ENTRYLO_G) ? 'G' : ' ',
-			 (tlb.tlb_lo[0] & ENTRYLO_C) >> ENTRYLO_C_SHIFT);
-		kvm_info("Lo1=0x%09llx %c%c attr %lx sz=%lx\n",
-			 (u64) mips3_tlbpfn_to_paddr(tlb.tlb_lo[1]),
-			 (tlb.tlb_lo[1] & ENTRYLO_D) ? 'D' : ' ',
-			 (tlb.tlb_lo[1] & ENTRYLO_G) ? 'G' : ' ',
-			 (tlb.tlb_lo[1] & ENTRYLO_C) >> ENTRYLO_C_SHIFT,
-			 tlb.tlb_mask);
-	}
-}
-EXPORT_SYMBOL_GPL(kvm_mips_dump_guest_tlbs);
-
-int kvm_mips_guest_tlb_lookup(struct kvm_vcpu *vcpu, unsigned long entryhi)
-{
-	int i;
-	int index = -1;
-	struct kvm_mips_tlb *tlb = vcpu->arch.guest_tlb;
-
-	for (i = 0; i < KVM_MIPS_GUEST_TLB_SIZE; i++) {
-		if (TLB_HI_VPN2_HIT(tlb[i], entryhi) &&
-		    TLB_HI_ASID_HIT(tlb[i], entryhi)) {
-			index = i;
-			break;
-		}
-	}
-
-	kvm_debug("%s: entryhi: %#lx, index: %d lo0: %#lx, lo1: %#lx\n",
-		  __func__, entryhi, index, tlb[i].tlb_lo[0], tlb[i].tlb_lo[1]);
-
-	return index;
-}
-EXPORT_SYMBOL_GPL(kvm_mips_guest_tlb_lookup);
 
 static int _kvm_mips_host_tlb_inv(unsigned long entryhi)
 {
@@ -163,54 +74,6 @@ static int _kvm_mips_host_tlb_inv(unsigned long entryhi)
 	return idx;
 }
 
-int kvm_mips_host_tlb_inv(struct kvm_vcpu *vcpu, unsigned long va,
-			  bool user, bool kernel)
-{
-	/*
-	 * Initialize idx_user and idx_kernel to workaround bogus
-	 * maybe-initialized warning when using GCC 6.
-	 */
-	int idx_user = 0, idx_kernel = 0;
-	unsigned long flags, old_entryhi;
-
-	local_irq_save(flags);
-
-	old_entryhi = read_c0_entryhi();
-
-	if (user)
-		idx_user = _kvm_mips_host_tlb_inv((va & VPN2_MASK) |
-						  kvm_mips_get_user_asid(vcpu));
-	if (kernel)
-		idx_kernel = _kvm_mips_host_tlb_inv((va & VPN2_MASK) |
-						kvm_mips_get_kernel_asid(vcpu));
-
-	write_c0_entryhi(old_entryhi);
-	mtc0_tlbw_hazard();
-
-	local_irq_restore(flags);
-
-	/*
-	 * We don't want to get reserved instruction exceptions for missing tlb
-	 * entries.
-	 */
-	if (cpu_has_vtag_icache)
-		flush_icache_all();
-
-	if (user && idx_user >= 0)
-		kvm_debug("%s: Invalidated guest user entryhi %#lx @ idx %d\n",
-			  __func__, (va & VPN2_MASK) |
-				    kvm_mips_get_user_asid(vcpu), idx_user);
-	if (kernel && idx_kernel >= 0)
-		kvm_debug("%s: Invalidated guest kernel entryhi %#lx @ idx %d\n",
-			  __func__, (va & VPN2_MASK) |
-				    kvm_mips_get_kernel_asid(vcpu), idx_kernel);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(kvm_mips_host_tlb_inv);
-
-#ifdef CONFIG_KVM_MIPS_VZ
-
 /* GuestID management */
 
 /**
@@ -661,40 +524,3 @@ void kvm_loongson_clear_guest_ftlb(void)
 }
 EXPORT_SYMBOL_GPL(kvm_loongson_clear_guest_ftlb);
 #endif
-
-#endif
-
-/**
- * kvm_mips_suspend_mm() - Suspend the active mm.
- * @cpu		The CPU we're running on.
- *
- * Suspend the active_mm, ready for a switch to a KVM guest virtual address
- * space. This is left active for the duration of guest context, including time
- * with interrupts enabled, so we need to be careful not to confuse e.g. cache
- * management IPIs.
- *
- * kvm_mips_resume_mm() should be called before context switching to a different
- * process so we don't need to worry about reference counting.
- *
- * This needs to be in static kernel code to avoid exporting init_mm.
- */
-void kvm_mips_suspend_mm(int cpu)
-{
-	cpumask_clear_cpu(cpu, mm_cpumask(current->active_mm));
-	current->active_mm = &init_mm;
-}
-EXPORT_SYMBOL_GPL(kvm_mips_suspend_mm);
-
-/**
- * kvm_mips_resume_mm() - Resume the current process mm.
- * @cpu		The CPU we're running on.
- *
- * Resume the mm of the current process, after a switch back from a KVM guest
- * virtual address space (see kvm_mips_suspend_mm()).
- */
-void kvm_mips_resume_mm(int cpu)
-{
-	cpumask_set_cpu(cpu, mm_cpumask(current->mm));
-	current->active_mm = current->mm;
-}
-EXPORT_SYMBOL_GPL(kvm_mips_resume_mm);
diff --git a/arch/mips/kvm/trap_emul.c b/arch/mips/kvm/trap_emul.c
deleted file mode 100644
index 0788c00d7e94..000000000000
--- a/arch/mips/kvm/trap_emul.c
+++ /dev/null
@@ -1,1306 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * KVM/MIPS: Deliver/Emulate exceptions to the guest kernel
- *
- * Copyright (C) 2012  MIPS Technologies, Inc.  All rights reserved.
- * Authors: Sanjay Lal <sanjayl@kymasys.com>
- */
-
-#include <linux/errno.h>
-#include <linux/err.h>
-#include <linux/kvm_host.h>
-#include <linux/log2.h>
-#include <linux/uaccess.h>
-#include <linux/vmalloc.h>
-#include <asm/mmu_context.h>
-#include <asm/pgalloc.h>
-
-#include "interrupt.h"
-
-static gpa_t kvm_trap_emul_gva_to_gpa_cb(gva_t gva)
-{
-	gpa_t gpa;
-	gva_t kseg = KSEGX(gva);
-	gva_t gkseg = KVM_GUEST_KSEGX(gva);
-
-	if ((kseg == CKSEG0) || (kseg == CKSEG1))
-		gpa = CPHYSADDR(gva);
-	else if (gkseg == KVM_GUEST_KSEG0)
-		gpa = KVM_GUEST_CPHYSADDR(gva);
-	else {
-		kvm_err("%s: cannot find GPA for GVA: %#lx\n", __func__, gva);
-		kvm_mips_dump_host_tlbs();
-		gpa = KVM_INVALID_ADDR;
-	}
-
-	kvm_debug("%s: gva %#lx, gpa: %#llx\n", __func__, gva, gpa);
-
-	return gpa;
-}
-
-static int kvm_trap_emul_no_handler(struct kvm_vcpu *vcpu)
-{
-	u32 __user *opc = (u32 __user *) vcpu->arch.pc;
-	u32 cause = vcpu->arch.host_cp0_cause;
-	u32 exccode = (cause & CAUSEF_EXCCODE) >> CAUSEB_EXCCODE;
-	unsigned long badvaddr = vcpu->arch.host_cp0_badvaddr;
-	u32 inst = 0;
-
-	/*
-	 *  Fetch the instruction.
-	 */
-	if (cause & CAUSEF_BD)
-		opc += 1;
-	kvm_get_badinstr(opc, vcpu, &inst);
-
-	kvm_err("Exception Code: %d not handled @ PC: %p, inst: 0x%08x BadVaddr: %#lx Status: %#x\n",
-		exccode, opc, inst, badvaddr,
-		kvm_read_c0_guest_status(vcpu->arch.cop0));
-	kvm_arch_vcpu_dump_regs(vcpu);
-	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-	return RESUME_HOST;
-}
-
-static int kvm_trap_emul_handle_cop_unusable(struct kvm_vcpu *vcpu)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	u32 __user *opc = (u32 __user *) vcpu->arch.pc;
-	u32 cause = vcpu->arch.host_cp0_cause;
-	enum emulation_result er = EMULATE_DONE;
-	int ret = RESUME_GUEST;
-
-	if (((cause & CAUSEF_CE) >> CAUSEB_CE) == 1) {
-		/* FPU Unusable */
-		if (!kvm_mips_guest_has_fpu(&vcpu->arch) ||
-		    (kvm_read_c0_guest_status(cop0) & ST0_CU1) == 0) {
-			/*
-			 * Unusable/no FPU in guest:
-			 * deliver guest COP1 Unusable Exception
-			 */
-			er = kvm_mips_emulate_fpu_exc(cause, opc, vcpu);
-		} else {
-			/* Restore FPU state */
-			kvm_own_fpu(vcpu);
-			er = EMULATE_DONE;
-		}
-	} else {
-		er = kvm_mips_emulate_inst(cause, opc, vcpu);
-	}
-
-	switch (er) {
-	case EMULATE_DONE:
-		ret = RESUME_GUEST;
-		break;
-
-	case EMULATE_FAIL:
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		ret = RESUME_HOST;
-		break;
-
-	case EMULATE_WAIT:
-		vcpu->run->exit_reason = KVM_EXIT_INTR;
-		ret = RESUME_HOST;
-		break;
-
-	case EMULATE_HYPERCALL:
-		ret = kvm_mips_handle_hypcall(vcpu);
-		break;
-
-	default:
-		BUG();
-	}
-	return ret;
-}
-
-static int kvm_mips_bad_load(u32 cause, u32 *opc, struct kvm_vcpu *vcpu)
-{
-	enum emulation_result er;
-	union mips_instruction inst;
-	int err;
-
-	/* A code fetch fault doesn't count as an MMIO */
-	if (kvm_is_ifetch_fault(&vcpu->arch)) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		return RESUME_HOST;
-	}
-
-	/* Fetch the instruction. */
-	if (cause & CAUSEF_BD)
-		opc += 1;
-	err = kvm_get_badinstr(opc, vcpu, &inst.word);
-	if (err) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		return RESUME_HOST;
-	}
-
-	/* Emulate the load */
-	er = kvm_mips_emulate_load(inst, cause, vcpu);
-	if (er == EMULATE_FAIL) {
-		kvm_err("Emulate load from MMIO space failed\n");
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-	} else {
-		vcpu->run->exit_reason = KVM_EXIT_MMIO;
-	}
-	return RESUME_HOST;
-}
-
-static int kvm_mips_bad_store(u32 cause, u32 *opc, struct kvm_vcpu *vcpu)
-{
-	enum emulation_result er;
-	union mips_instruction inst;
-	int err;
-
-	/* Fetch the instruction. */
-	if (cause & CAUSEF_BD)
-		opc += 1;
-	err = kvm_get_badinstr(opc, vcpu, &inst.word);
-	if (err) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		return RESUME_HOST;
-	}
-
-	/* Emulate the store */
-	er = kvm_mips_emulate_store(inst, cause, vcpu);
-	if (er == EMULATE_FAIL) {
-		kvm_err("Emulate store to MMIO space failed\n");
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-	} else {
-		vcpu->run->exit_reason = KVM_EXIT_MMIO;
-	}
-	return RESUME_HOST;
-}
-
-static int kvm_mips_bad_access(u32 cause, u32 *opc,
-			       struct kvm_vcpu *vcpu, bool store)
-{
-	if (store)
-		return kvm_mips_bad_store(cause, opc, vcpu);
-	else
-		return kvm_mips_bad_load(cause, opc, vcpu);
-}
-
-static int kvm_trap_emul_handle_tlb_mod(struct kvm_vcpu *vcpu)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	u32 __user *opc = (u32 __user *) vcpu->arch.pc;
-	unsigned long badvaddr = vcpu->arch.host_cp0_badvaddr;
-	u32 cause = vcpu->arch.host_cp0_cause;
-	struct kvm_mips_tlb *tlb;
-	unsigned long entryhi;
-	int index;
-
-	if (KVM_GUEST_KSEGX(badvaddr) < KVM_GUEST_KSEG0
-	    || KVM_GUEST_KSEGX(badvaddr) == KVM_GUEST_KSEG23) {
-		/*
-		 * First find the mapping in the guest TLB. If the failure to
-		 * write was due to the guest TLB, it should be up to the guest
-		 * to handle it.
-		 */
-		entryhi = (badvaddr & VPN2_MASK) |
-			  (kvm_read_c0_guest_entryhi(cop0) & KVM_ENTRYHI_ASID);
-		index = kvm_mips_guest_tlb_lookup(vcpu, entryhi);
-
-		/*
-		 * These should never happen.
-		 * They would indicate stale host TLB entries.
-		 */
-		if (unlikely(index < 0)) {
-			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-			return RESUME_HOST;
-		}
-		tlb = vcpu->arch.guest_tlb + index;
-		if (unlikely(!TLB_IS_VALID(*tlb, badvaddr))) {
-			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-			return RESUME_HOST;
-		}
-
-		/*
-		 * Guest entry not dirty? That would explain the TLB modified
-		 * exception. Relay that on to the guest so it can handle it.
-		 */
-		if (!TLB_IS_DIRTY(*tlb, badvaddr)) {
-			kvm_mips_emulate_tlbmod(cause, opc, vcpu);
-			return RESUME_GUEST;
-		}
-
-		if (kvm_mips_handle_mapped_seg_tlb_fault(vcpu, tlb, badvaddr,
-							 true))
-			/* Not writable, needs handling as MMIO */
-			return kvm_mips_bad_store(cause, opc, vcpu);
-		return RESUME_GUEST;
-	} else if (KVM_GUEST_KSEGX(badvaddr) == KVM_GUEST_KSEG0) {
-		if (kvm_mips_handle_kseg0_tlb_fault(badvaddr, vcpu, true) < 0)
-			/* Not writable, needs handling as MMIO */
-			return kvm_mips_bad_store(cause, opc, vcpu);
-		return RESUME_GUEST;
-	} else {
-		/* host kernel addresses are all handled as MMIO */
-		return kvm_mips_bad_store(cause, opc, vcpu);
-	}
-}
-
-static int kvm_trap_emul_handle_tlb_miss(struct kvm_vcpu *vcpu, bool store)
-{
-	struct kvm_run *run = vcpu->run;
-	u32 __user *opc = (u32 __user *) vcpu->arch.pc;
-	unsigned long badvaddr = vcpu->arch.host_cp0_badvaddr;
-	u32 cause = vcpu->arch.host_cp0_cause;
-	enum emulation_result er = EMULATE_DONE;
-	int ret = RESUME_GUEST;
-
-	if (((badvaddr & PAGE_MASK) == KVM_GUEST_COMMPAGE_ADDR)
-	    && KVM_GUEST_KERNEL_MODE(vcpu)) {
-		if (kvm_mips_handle_commpage_tlb_fault(badvaddr, vcpu) < 0) {
-			run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-			ret = RESUME_HOST;
-		}
-	} else if (KVM_GUEST_KSEGX(badvaddr) < KVM_GUEST_KSEG0
-		   || KVM_GUEST_KSEGX(badvaddr) == KVM_GUEST_KSEG23) {
-		kvm_debug("USER ADDR TLB %s fault: cause %#x, PC: %p, BadVaddr: %#lx\n",
-			  store ? "ST" : "LD", cause, opc, badvaddr);
-
-		/*
-		 * User Address (UA) fault, this could happen if
-		 * (1) TLB entry not present/valid in both Guest and shadow host
-		 *     TLBs, in this case we pass on the fault to the guest
-		 *     kernel and let it handle it.
-		 * (2) TLB entry is present in the Guest TLB but not in the
-		 *     shadow, in this case we inject the TLB from the Guest TLB
-		 *     into the shadow host TLB
-		 */
-
-		er = kvm_mips_handle_tlbmiss(cause, opc, vcpu, store);
-		if (er == EMULATE_DONE)
-			ret = RESUME_GUEST;
-		else {
-			run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-			ret = RESUME_HOST;
-		}
-	} else if (KVM_GUEST_KSEGX(badvaddr) == KVM_GUEST_KSEG0) {
-		/*
-		 * All KSEG0 faults are handled by KVM, as the guest kernel does
-		 * not expect to ever get them
-		 */
-		if (kvm_mips_handle_kseg0_tlb_fault(badvaddr, vcpu, store) < 0)
-			ret = kvm_mips_bad_access(cause, opc, vcpu, store);
-	} else if (KVM_GUEST_KERNEL_MODE(vcpu)
-		   && (KSEGX(badvaddr) == CKSEG0 || KSEGX(badvaddr) == CKSEG1)) {
-		/*
-		 * With EVA we may get a TLB exception instead of an address
-		 * error when the guest performs MMIO to KSeg1 addresses.
-		 */
-		ret = kvm_mips_bad_access(cause, opc, vcpu, store);
-	} else {
-		kvm_err("Illegal TLB %s fault address , cause %#x, PC: %p, BadVaddr: %#lx\n",
-			store ? "ST" : "LD", cause, opc, badvaddr);
-		kvm_mips_dump_host_tlbs();
-		kvm_arch_vcpu_dump_regs(vcpu);
-		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		ret = RESUME_HOST;
-	}
-	return ret;
-}
-
-static int kvm_trap_emul_handle_tlb_st_miss(struct kvm_vcpu *vcpu)
-{
-	return kvm_trap_emul_handle_tlb_miss(vcpu, true);
-}
-
-static int kvm_trap_emul_handle_tlb_ld_miss(struct kvm_vcpu *vcpu)
-{
-	return kvm_trap_emul_handle_tlb_miss(vcpu, false);
-}
-
-static int kvm_trap_emul_handle_addr_err_st(struct kvm_vcpu *vcpu)
-{
-	u32 __user *opc = (u32 __user *) vcpu->arch.pc;
-	unsigned long badvaddr = vcpu->arch.host_cp0_badvaddr;
-	u32 cause = vcpu->arch.host_cp0_cause;
-	int ret = RESUME_GUEST;
-
-	if (KVM_GUEST_KERNEL_MODE(vcpu)
-	    && (KSEGX(badvaddr) == CKSEG0 || KSEGX(badvaddr) == CKSEG1)) {
-		ret = kvm_mips_bad_store(cause, opc, vcpu);
-	} else {
-		kvm_err("Address Error (STORE): cause %#x, PC: %p, BadVaddr: %#lx\n",
-			cause, opc, badvaddr);
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		ret = RESUME_HOST;
-	}
-	return ret;
-}
-
-static int kvm_trap_emul_handle_addr_err_ld(struct kvm_vcpu *vcpu)
-{
-	u32 __user *opc = (u32 __user *) vcpu->arch.pc;
-	unsigned long badvaddr = vcpu->arch.host_cp0_badvaddr;
-	u32 cause = vcpu->arch.host_cp0_cause;
-	int ret = RESUME_GUEST;
-
-	if (KSEGX(badvaddr) == CKSEG0 || KSEGX(badvaddr) == CKSEG1) {
-		ret = kvm_mips_bad_load(cause, opc, vcpu);
-	} else {
-		kvm_err("Address Error (LOAD): cause %#x, PC: %p, BadVaddr: %#lx\n",
-			cause, opc, badvaddr);
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		ret = RESUME_HOST;
-	}
-	return ret;
-}
-
-static int kvm_trap_emul_handle_syscall(struct kvm_vcpu *vcpu)
-{
-	u32 __user *opc = (u32 __user *) vcpu->arch.pc;
-	u32 cause = vcpu->arch.host_cp0_cause;
-	enum emulation_result er = EMULATE_DONE;
-	int ret = RESUME_GUEST;
-
-	er = kvm_mips_emulate_syscall(cause, opc, vcpu);
-	if (er == EMULATE_DONE)
-		ret = RESUME_GUEST;
-	else {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		ret = RESUME_HOST;
-	}
-	return ret;
-}
-
-static int kvm_trap_emul_handle_res_inst(struct kvm_vcpu *vcpu)
-{
-	u32 __user *opc = (u32 __user *) vcpu->arch.pc;
-	u32 cause = vcpu->arch.host_cp0_cause;
-	enum emulation_result er = EMULATE_DONE;
-	int ret = RESUME_GUEST;
-
-	er = kvm_mips_handle_ri(cause, opc, vcpu);
-	if (er == EMULATE_DONE)
-		ret = RESUME_GUEST;
-	else {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		ret = RESUME_HOST;
-	}
-	return ret;
-}
-
-static int kvm_trap_emul_handle_break(struct kvm_vcpu *vcpu)
-{
-	u32 __user *opc = (u32 __user *) vcpu->arch.pc;
-	u32 cause = vcpu->arch.host_cp0_cause;
-	enum emulation_result er = EMULATE_DONE;
-	int ret = RESUME_GUEST;
-
-	er = kvm_mips_emulate_bp_exc(cause, opc, vcpu);
-	if (er == EMULATE_DONE)
-		ret = RESUME_GUEST;
-	else {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		ret = RESUME_HOST;
-	}
-	return ret;
-}
-
-static int kvm_trap_emul_handle_trap(struct kvm_vcpu *vcpu)
-{
-	u32 __user *opc = (u32 __user *)vcpu->arch.pc;
-	u32 cause = vcpu->arch.host_cp0_cause;
-	enum emulation_result er = EMULATE_DONE;
-	int ret = RESUME_GUEST;
-
-	er = kvm_mips_emulate_trap_exc(cause, opc, vcpu);
-	if (er == EMULATE_DONE) {
-		ret = RESUME_GUEST;
-	} else {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		ret = RESUME_HOST;
-	}
-	return ret;
-}
-
-static int kvm_trap_emul_handle_msa_fpe(struct kvm_vcpu *vcpu)
-{
-	u32 __user *opc = (u32 __user *)vcpu->arch.pc;
-	u32 cause = vcpu->arch.host_cp0_cause;
-	enum emulation_result er = EMULATE_DONE;
-	int ret = RESUME_GUEST;
-
-	er = kvm_mips_emulate_msafpe_exc(cause, opc, vcpu);
-	if (er == EMULATE_DONE) {
-		ret = RESUME_GUEST;
-	} else {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		ret = RESUME_HOST;
-	}
-	return ret;
-}
-
-static int kvm_trap_emul_handle_fpe(struct kvm_vcpu *vcpu)
-{
-	u32 __user *opc = (u32 __user *)vcpu->arch.pc;
-	u32 cause = vcpu->arch.host_cp0_cause;
-	enum emulation_result er = EMULATE_DONE;
-	int ret = RESUME_GUEST;
-
-	er = kvm_mips_emulate_fpe_exc(cause, opc, vcpu);
-	if (er == EMULATE_DONE) {
-		ret = RESUME_GUEST;
-	} else {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		ret = RESUME_HOST;
-	}
-	return ret;
-}
-
-/**
- * kvm_trap_emul_handle_msa_disabled() - Guest used MSA while disabled in root.
- * @vcpu:	Virtual CPU context.
- *
- * Handle when the guest attempts to use MSA when it is disabled.
- */
-static int kvm_trap_emul_handle_msa_disabled(struct kvm_vcpu *vcpu)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	u32 __user *opc = (u32 __user *) vcpu->arch.pc;
-	u32 cause = vcpu->arch.host_cp0_cause;
-	enum emulation_result er = EMULATE_DONE;
-	int ret = RESUME_GUEST;
-
-	if (!kvm_mips_guest_has_msa(&vcpu->arch) ||
-	    (kvm_read_c0_guest_status(cop0) & (ST0_CU1 | ST0_FR)) == ST0_CU1) {
-		/*
-		 * No MSA in guest, or FPU enabled and not in FR=1 mode,
-		 * guest reserved instruction exception
-		 */
-		er = kvm_mips_emulate_ri_exc(cause, opc, vcpu);
-	} else if (!(kvm_read_c0_guest_config5(cop0) & MIPS_CONF5_MSAEN)) {
-		/* MSA disabled by guest, guest MSA disabled exception */
-		er = kvm_mips_emulate_msadis_exc(cause, opc, vcpu);
-	} else {
-		/* Restore MSA/FPU state */
-		kvm_own_msa(vcpu);
-		er = EMULATE_DONE;
-	}
-
-	switch (er) {
-	case EMULATE_DONE:
-		ret = RESUME_GUEST;
-		break;
-
-	case EMULATE_FAIL:
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		ret = RESUME_HOST;
-		break;
-
-	default:
-		BUG();
-	}
-	return ret;
-}
-
-static int kvm_trap_emul_hardware_enable(void)
-{
-	return 0;
-}
-
-static void kvm_trap_emul_hardware_disable(void)
-{
-}
-
-static int kvm_trap_emul_check_extension(struct kvm *kvm, long ext)
-{
-	int r;
-
-	switch (ext) {
-	case KVM_CAP_MIPS_TE:
-		r = 1;
-		break;
-	case KVM_CAP_IOEVENTFD:
-		r = 1;
-		break;
-	default:
-		r = 0;
-		break;
-	}
-
-	return r;
-}
-
-static int kvm_trap_emul_vcpu_init(struct kvm_vcpu *vcpu)
-{
-	struct mm_struct *kern_mm = &vcpu->arch.guest_kernel_mm;
-	struct mm_struct *user_mm = &vcpu->arch.guest_user_mm;
-
-	/*
-	 * Allocate GVA -> HPA page tables.
-	 * MIPS doesn't use the mm_struct pointer argument.
-	 */
-	kern_mm->pgd = pgd_alloc(kern_mm);
-	if (!kern_mm->pgd)
-		return -ENOMEM;
-
-	user_mm->pgd = pgd_alloc(user_mm);
-	if (!user_mm->pgd) {
-		pgd_free(kern_mm, kern_mm->pgd);
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-static void kvm_mips_emul_free_gva_pt(pgd_t *pgd)
-{
-	/* Don't free host kernel page tables copied from init_mm.pgd */
-	const unsigned long end = 0x80000000;
-	unsigned long pgd_va, pud_va, pmd_va;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-	int i, j, k;
-
-	for (i = 0; i < USER_PTRS_PER_PGD; i++) {
-		if (pgd_none(pgd[i]))
-			continue;
-
-		pgd_va = (unsigned long)i << PGDIR_SHIFT;
-		if (pgd_va >= end)
-			break;
-		p4d = p4d_offset(pgd, 0);
-		pud = pud_offset(p4d + i, 0);
-		for (j = 0; j < PTRS_PER_PUD; j++) {
-			if (pud_none(pud[j]))
-				continue;
-
-			pud_va = pgd_va | ((unsigned long)j << PUD_SHIFT);
-			if (pud_va >= end)
-				break;
-			pmd = pmd_offset(pud + j, 0);
-			for (k = 0; k < PTRS_PER_PMD; k++) {
-				if (pmd_none(pmd[k]))
-					continue;
-
-				pmd_va = pud_va | (k << PMD_SHIFT);
-				if (pmd_va >= end)
-					break;
-				pte = pte_offset_kernel(pmd + k, 0);
-				pte_free_kernel(NULL, pte);
-			}
-			pmd_free(NULL, pmd);
-		}
-		pud_free(NULL, pud);
-	}
-	pgd_free(NULL, pgd);
-}
-
-static void kvm_trap_emul_vcpu_uninit(struct kvm_vcpu *vcpu)
-{
-	kvm_mips_emul_free_gva_pt(vcpu->arch.guest_kernel_mm.pgd);
-	kvm_mips_emul_free_gva_pt(vcpu->arch.guest_user_mm.pgd);
-}
-
-static int kvm_trap_emul_vcpu_setup(struct kvm_vcpu *vcpu)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	u32 config, config1;
-	int vcpu_id = vcpu->vcpu_id;
-
-	/* Start off the timer at 100 MHz */
-	kvm_mips_init_count(vcpu, 100*1000*1000);
-
-	/*
-	 * Arch specific stuff, set up config registers properly so that the
-	 * guest will come up as expected
-	 */
-#ifndef CONFIG_CPU_MIPSR6
-	/* r2-r5, simulate a MIPS 24kc */
-	kvm_write_c0_guest_prid(cop0, 0x00019300);
-#else
-	/* r6+, simulate a generic QEMU machine */
-	kvm_write_c0_guest_prid(cop0, 0x00010000);
-#endif
-	/*
-	 * Have config1, Cacheable, noncoherent, write-back, write allocate.
-	 * Endianness, arch revision & virtually tagged icache should match
-	 * host.
-	 */
-	config = read_c0_config() & MIPS_CONF_AR;
-	config |= MIPS_CONF_M | CONF_CM_CACHABLE_NONCOHERENT | MIPS_CONF_MT_TLB;
-#ifdef CONFIG_CPU_BIG_ENDIAN
-	config |= CONF_BE;
-#endif
-	if (cpu_has_vtag_icache)
-		config |= MIPS_CONF_VI;
-	kvm_write_c0_guest_config(cop0, config);
-
-	/* Read the cache characteristics from the host Config1 Register */
-	config1 = (read_c0_config1() & ~0x7f);
-
-	/* DCache line size not correctly reported in Config1 on Octeon CPUs */
-	if (cpu_dcache_line_size()) {
-		config1 &= ~MIPS_CONF1_DL;
-		config1 |= ((ilog2(cpu_dcache_line_size()) - 1) <<
-			    MIPS_CONF1_DL_SHF) & MIPS_CONF1_DL;
-	}
-
-	/* Set up MMU size */
-	config1 &= ~(0x3f << 25);
-	config1 |= ((KVM_MIPS_GUEST_TLB_SIZE - 1) << 25);
-
-	/* We unset some bits that we aren't emulating */
-	config1 &= ~(MIPS_CONF1_C2 | MIPS_CONF1_MD | MIPS_CONF1_PC |
-		     MIPS_CONF1_WR | MIPS_CONF1_CA);
-	kvm_write_c0_guest_config1(cop0, config1);
-
-	/* Have config3, no tertiary/secondary caches implemented */
-	kvm_write_c0_guest_config2(cop0, MIPS_CONF_M);
-	/* MIPS_CONF_M | (read_c0_config2() & 0xfff) */
-
-	/* Have config4, UserLocal */
-	kvm_write_c0_guest_config3(cop0, MIPS_CONF_M | MIPS_CONF3_ULRI);
-
-	/* Have config5 */
-	kvm_write_c0_guest_config4(cop0, MIPS_CONF_M);
-
-	/* No config6 */
-	kvm_write_c0_guest_config5(cop0, 0);
-
-	/* Set Wait IE/IXMT Ignore in Config7, IAR, AR */
-	kvm_write_c0_guest_config7(cop0, (MIPS_CONF7_WII) | (1 << 10));
-
-	/* Status */
-	kvm_write_c0_guest_status(cop0, ST0_BEV | ST0_ERL);
-
-	/*
-	 * Setup IntCtl defaults, compatibility mode for timer interrupts (HW5)
-	 */
-	kvm_write_c0_guest_intctl(cop0, 0xFC000000);
-
-	/* Put in vcpu id as CPUNum into Ebase Reg to handle SMP Guests */
-	kvm_write_c0_guest_ebase(cop0, KVM_GUEST_KSEG0 |
-				       (vcpu_id & MIPS_EBASE_CPUNUM));
-
-	/* Put PC at guest reset vector */
-	vcpu->arch.pc = KVM_GUEST_CKSEG1ADDR(0x1fc00000);
-
-	return 0;
-}
-
-static void kvm_trap_emul_flush_shadow_all(struct kvm *kvm)
-{
-	/* Flush GVA page tables and invalidate GVA ASIDs on all VCPUs */
-	kvm_flush_remote_tlbs(kvm);
-}
-
-static void kvm_trap_emul_flush_shadow_memslot(struct kvm *kvm,
-					const struct kvm_memory_slot *slot)
-{
-	kvm_trap_emul_flush_shadow_all(kvm);
-}
-
-static u64 kvm_trap_emul_get_one_regs[] = {
-	KVM_REG_MIPS_CP0_INDEX,
-	KVM_REG_MIPS_CP0_ENTRYLO0,
-	KVM_REG_MIPS_CP0_ENTRYLO1,
-	KVM_REG_MIPS_CP0_CONTEXT,
-	KVM_REG_MIPS_CP0_USERLOCAL,
-	KVM_REG_MIPS_CP0_PAGEMASK,
-	KVM_REG_MIPS_CP0_WIRED,
-	KVM_REG_MIPS_CP0_HWRENA,
-	KVM_REG_MIPS_CP0_BADVADDR,
-	KVM_REG_MIPS_CP0_COUNT,
-	KVM_REG_MIPS_CP0_ENTRYHI,
-	KVM_REG_MIPS_CP0_COMPARE,
-	KVM_REG_MIPS_CP0_STATUS,
-	KVM_REG_MIPS_CP0_INTCTL,
-	KVM_REG_MIPS_CP0_CAUSE,
-	KVM_REG_MIPS_CP0_EPC,
-	KVM_REG_MIPS_CP0_PRID,
-	KVM_REG_MIPS_CP0_EBASE,
-	KVM_REG_MIPS_CP0_CONFIG,
-	KVM_REG_MIPS_CP0_CONFIG1,
-	KVM_REG_MIPS_CP0_CONFIG2,
-	KVM_REG_MIPS_CP0_CONFIG3,
-	KVM_REG_MIPS_CP0_CONFIG4,
-	KVM_REG_MIPS_CP0_CONFIG5,
-	KVM_REG_MIPS_CP0_CONFIG7,
-	KVM_REG_MIPS_CP0_ERROREPC,
-	KVM_REG_MIPS_CP0_KSCRATCH1,
-	KVM_REG_MIPS_CP0_KSCRATCH2,
-	KVM_REG_MIPS_CP0_KSCRATCH3,
-	KVM_REG_MIPS_CP0_KSCRATCH4,
-	KVM_REG_MIPS_CP0_KSCRATCH5,
-	KVM_REG_MIPS_CP0_KSCRATCH6,
-
-	KVM_REG_MIPS_COUNT_CTL,
-	KVM_REG_MIPS_COUNT_RESUME,
-	KVM_REG_MIPS_COUNT_HZ,
-};
-
-static unsigned long kvm_trap_emul_num_regs(struct kvm_vcpu *vcpu)
-{
-	return ARRAY_SIZE(kvm_trap_emul_get_one_regs);
-}
-
-static int kvm_trap_emul_copy_reg_indices(struct kvm_vcpu *vcpu,
-					  u64 __user *indices)
-{
-	if (copy_to_user(indices, kvm_trap_emul_get_one_regs,
-			 sizeof(kvm_trap_emul_get_one_regs)))
-		return -EFAULT;
-	indices += ARRAY_SIZE(kvm_trap_emul_get_one_regs);
-
-	return 0;
-}
-
-static int kvm_trap_emul_get_one_reg(struct kvm_vcpu *vcpu,
-				     const struct kvm_one_reg *reg,
-				     s64 *v)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-
-	switch (reg->id) {
-	case KVM_REG_MIPS_CP0_INDEX:
-		*v = (long)kvm_read_c0_guest_index(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_ENTRYLO0:
-		*v = kvm_read_c0_guest_entrylo0(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_ENTRYLO1:
-		*v = kvm_read_c0_guest_entrylo1(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_CONTEXT:
-		*v = (long)kvm_read_c0_guest_context(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_USERLOCAL:
-		*v = (long)kvm_read_c0_guest_userlocal(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_PAGEMASK:
-		*v = (long)kvm_read_c0_guest_pagemask(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_WIRED:
-		*v = (long)kvm_read_c0_guest_wired(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_HWRENA:
-		*v = (long)kvm_read_c0_guest_hwrena(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_BADVADDR:
-		*v = (long)kvm_read_c0_guest_badvaddr(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_ENTRYHI:
-		*v = (long)kvm_read_c0_guest_entryhi(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_COMPARE:
-		*v = (long)kvm_read_c0_guest_compare(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_STATUS:
-		*v = (long)kvm_read_c0_guest_status(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_INTCTL:
-		*v = (long)kvm_read_c0_guest_intctl(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_CAUSE:
-		*v = (long)kvm_read_c0_guest_cause(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_EPC:
-		*v = (long)kvm_read_c0_guest_epc(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_PRID:
-		*v = (long)kvm_read_c0_guest_prid(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_EBASE:
-		*v = (long)kvm_read_c0_guest_ebase(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_CONFIG:
-		*v = (long)kvm_read_c0_guest_config(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_CONFIG1:
-		*v = (long)kvm_read_c0_guest_config1(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_CONFIG2:
-		*v = (long)kvm_read_c0_guest_config2(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_CONFIG3:
-		*v = (long)kvm_read_c0_guest_config3(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_CONFIG4:
-		*v = (long)kvm_read_c0_guest_config4(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_CONFIG5:
-		*v = (long)kvm_read_c0_guest_config5(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_CONFIG7:
-		*v = (long)kvm_read_c0_guest_config7(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_COUNT:
-		*v = kvm_mips_read_count(vcpu);
-		break;
-	case KVM_REG_MIPS_COUNT_CTL:
-		*v = vcpu->arch.count_ctl;
-		break;
-	case KVM_REG_MIPS_COUNT_RESUME:
-		*v = ktime_to_ns(vcpu->arch.count_resume);
-		break;
-	case KVM_REG_MIPS_COUNT_HZ:
-		*v = vcpu->arch.count_hz;
-		break;
-	case KVM_REG_MIPS_CP0_ERROREPC:
-		*v = (long)kvm_read_c0_guest_errorepc(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_KSCRATCH1:
-		*v = (long)kvm_read_c0_guest_kscratch1(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_KSCRATCH2:
-		*v = (long)kvm_read_c0_guest_kscratch2(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_KSCRATCH3:
-		*v = (long)kvm_read_c0_guest_kscratch3(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_KSCRATCH4:
-		*v = (long)kvm_read_c0_guest_kscratch4(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_KSCRATCH5:
-		*v = (long)kvm_read_c0_guest_kscratch5(cop0);
-		break;
-	case KVM_REG_MIPS_CP0_KSCRATCH6:
-		*v = (long)kvm_read_c0_guest_kscratch6(cop0);
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int kvm_trap_emul_set_one_reg(struct kvm_vcpu *vcpu,
-				     const struct kvm_one_reg *reg,
-				     s64 v)
-{
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	int ret = 0;
-	unsigned int cur, change;
-
-	switch (reg->id) {
-	case KVM_REG_MIPS_CP0_INDEX:
-		kvm_write_c0_guest_index(cop0, v);
-		break;
-	case KVM_REG_MIPS_CP0_ENTRYLO0:
-		kvm_write_c0_guest_entrylo0(cop0, v);
-		break;
-	case KVM_REG_MIPS_CP0_ENTRYLO1:
-		kvm_write_c0_guest_entrylo1(cop0, v);
-		break;
-	case KVM_REG_MIPS_CP0_CONTEXT:
-		kvm_write_c0_guest_context(cop0, v);
-		break;
-	case KVM_REG_MIPS_CP0_USERLOCAL:
-		kvm_write_c0_guest_userlocal(cop0, v);
-		break;
-	case KVM_REG_MIPS_CP0_PAGEMASK:
-		kvm_write_c0_guest_pagemask(cop0, v);
-		break;
-	case KVM_REG_MIPS_CP0_WIRED:
-		kvm_write_c0_guest_wired(cop0, v);
-		break;
-	case KVM_REG_MIPS_CP0_HWRENA:
-		kvm_write_c0_guest_hwrena(cop0, v);
-		break;
-	case KVM_REG_MIPS_CP0_BADVADDR:
-		kvm_write_c0_guest_badvaddr(cop0, v);
-		break;
-	case KVM_REG_MIPS_CP0_ENTRYHI:
-		kvm_write_c0_guest_entryhi(cop0, v);
-		break;
-	case KVM_REG_MIPS_CP0_STATUS:
-		kvm_write_c0_guest_status(cop0, v);
-		break;
-	case KVM_REG_MIPS_CP0_INTCTL:
-		/* No VInt, so no VS, read-only for now */
-		break;
-	case KVM_REG_MIPS_CP0_EPC:
-		kvm_write_c0_guest_epc(cop0, v);
-		break;
-	case KVM_REG_MIPS_CP0_PRID:
-		kvm_write_c0_guest_prid(cop0, v);
-		break;
-	case KVM_REG_MIPS_CP0_EBASE:
-		/*
-		 * Allow core number to be written, but the exception base must
-		 * remain in guest KSeg0.
-		 */
-		kvm_change_c0_guest_ebase(cop0, 0x1ffff000 | MIPS_EBASE_CPUNUM,
-					  v);
-		break;
-	case KVM_REG_MIPS_CP0_COUNT:
-		kvm_mips_write_count(vcpu, v);
-		break;
-	case KVM_REG_MIPS_CP0_COMPARE:
-		kvm_mips_write_compare(vcpu, v, false);
-		break;
-	case KVM_REG_MIPS_CP0_CAUSE:
-		/*
-		 * If the timer is stopped or started (DC bit) it must look
-		 * atomic with changes to the interrupt pending bits (TI, IRQ5).
-		 * A timer interrupt should not happen in between.
-		 */
-		if ((kvm_read_c0_guest_cause(cop0) ^ v) & CAUSEF_DC) {
-			if (v & CAUSEF_DC) {
-				/* disable timer first */
-				kvm_mips_count_disable_cause(vcpu);
-				kvm_change_c0_guest_cause(cop0, (u32)~CAUSEF_DC,
-							  v);
-			} else {
-				/* enable timer last */
-				kvm_change_c0_guest_cause(cop0, (u32)~CAUSEF_DC,
-							  v);
-				kvm_mips_count_enable_cause(vcpu);
-			}
-		} else {
-			kvm_write_c0_guest_cause(cop0, v);
-		}
-		break;
-	case KVM_REG_MIPS_CP0_CONFIG:
-		/* read-only for now */
-		break;
-	case KVM_REG_MIPS_CP0_CONFIG1:
-		cur = kvm_read_c0_guest_config1(cop0);
-		change = (cur ^ v) & kvm_mips_config1_wrmask(vcpu);
-		if (change) {
-			v = cur ^ change;
-			kvm_write_c0_guest_config1(cop0, v);
-		}
-		break;
-	case KVM_REG_MIPS_CP0_CONFIG2:
-		/* read-only for now */
-		break;
-	case KVM_REG_MIPS_CP0_CONFIG3:
-		cur = kvm_read_c0_guest_config3(cop0);
-		change = (cur ^ v) & kvm_mips_config3_wrmask(vcpu);
-		if (change) {
-			v = cur ^ change;
-			kvm_write_c0_guest_config3(cop0, v);
-		}
-		break;
-	case KVM_REG_MIPS_CP0_CONFIG4:
-		cur = kvm_read_c0_guest_config4(cop0);
-		change = (cur ^ v) & kvm_mips_config4_wrmask(vcpu);
-		if (change) {
-			v = cur ^ change;
-			kvm_write_c0_guest_config4(cop0, v);
-		}
-		break;
-	case KVM_REG_MIPS_CP0_CONFIG5:
-		cur = kvm_read_c0_guest_config5(cop0);
-		change = (cur ^ v) & kvm_mips_config5_wrmask(vcpu);
-		if (change) {
-			v = cur ^ change;
-			kvm_write_c0_guest_config5(cop0, v);
-		}
-		break;
-	case KVM_REG_MIPS_CP0_CONFIG7:
-		/* writes ignored */
-		break;
-	case KVM_REG_MIPS_COUNT_CTL:
-		ret = kvm_mips_set_count_ctl(vcpu, v);
-		break;
-	case KVM_REG_MIPS_COUNT_RESUME:
-		ret = kvm_mips_set_count_resume(vcpu, v);
-		break;
-	case KVM_REG_MIPS_COUNT_HZ:
-		ret = kvm_mips_set_count_hz(vcpu, v);
-		break;
-	case KVM_REG_MIPS_CP0_ERROREPC:
-		kvm_write_c0_guest_errorepc(cop0, v);
-		break;
-	case KVM_REG_MIPS_CP0_KSCRATCH1:
-		kvm_write_c0_guest_kscratch1(cop0, v);
-		break;
-	case KVM_REG_MIPS_CP0_KSCRATCH2:
-		kvm_write_c0_guest_kscratch2(cop0, v);
-		break;
-	case KVM_REG_MIPS_CP0_KSCRATCH3:
-		kvm_write_c0_guest_kscratch3(cop0, v);
-		break;
-	case KVM_REG_MIPS_CP0_KSCRATCH4:
-		kvm_write_c0_guest_kscratch4(cop0, v);
-		break;
-	case KVM_REG_MIPS_CP0_KSCRATCH5:
-		kvm_write_c0_guest_kscratch5(cop0, v);
-		break;
-	case KVM_REG_MIPS_CP0_KSCRATCH6:
-		kvm_write_c0_guest_kscratch6(cop0, v);
-		break;
-	default:
-		return -EINVAL;
-	}
-	return ret;
-}
-
-static int kvm_trap_emul_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
-{
-	struct mm_struct *kern_mm = &vcpu->arch.guest_kernel_mm;
-	struct mm_struct *user_mm = &vcpu->arch.guest_user_mm;
-	struct mm_struct *mm;
-
-	/*
-	 * Were we in guest context? If so, restore the appropriate ASID based
-	 * on the mode of the Guest (Kernel/User).
-	 */
-	if (current->flags & PF_VCPU) {
-		mm = KVM_GUEST_KERNEL_MODE(vcpu) ? kern_mm : user_mm;
-		check_switch_mmu_context(mm);
-		kvm_mips_suspend_mm(cpu);
-		ehb();
-	}
-
-	return 0;
-}
-
-static int kvm_trap_emul_vcpu_put(struct kvm_vcpu *vcpu, int cpu)
-{
-	kvm_lose_fpu(vcpu);
-
-	if (current->flags & PF_VCPU) {
-		/* Restore normal Linux process memory map */
-		check_switch_mmu_context(current->mm);
-		kvm_mips_resume_mm(cpu);
-		ehb();
-	}
-
-	return 0;
-}
-
-static void kvm_trap_emul_check_requests(struct kvm_vcpu *vcpu, int cpu,
-					 bool reload_asid)
-{
-	struct mm_struct *kern_mm = &vcpu->arch.guest_kernel_mm;
-	struct mm_struct *user_mm = &vcpu->arch.guest_user_mm;
-	struct mm_struct *mm;
-	int i;
-
-	if (likely(!kvm_request_pending(vcpu)))
-		return;
-
-	if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu)) {
-		/*
-		 * Both kernel & user GVA mappings must be invalidated. The
-		 * caller is just about to check whether the ASID is stale
-		 * anyway so no need to reload it here.
-		 */
-		kvm_mips_flush_gva_pt(kern_mm->pgd, KMF_GPA | KMF_KERN);
-		kvm_mips_flush_gva_pt(user_mm->pgd, KMF_GPA | KMF_USER);
-		for_each_possible_cpu(i) {
-			set_cpu_context(i, kern_mm, 0);
-			set_cpu_context(i, user_mm, 0);
-		}
-
-		/* Generate new ASID for current mode */
-		if (reload_asid) {
-			mm = KVM_GUEST_KERNEL_MODE(vcpu) ? kern_mm : user_mm;
-			get_new_mmu_context(mm);
-			htw_stop();
-			write_c0_entryhi(cpu_asid(cpu, mm));
-			TLBMISS_HANDLER_SETUP_PGD(mm->pgd);
-			htw_start();
-		}
-	}
-}
-
-/**
- * kvm_trap_emul_gva_lockless_begin() - Begin lockless access to GVA space.
- * @vcpu:	VCPU pointer.
- *
- * Call before a GVA space access outside of guest mode, to ensure that
- * asynchronous TLB flush requests are handled or delayed until completion of
- * the GVA access (as indicated by a matching kvm_trap_emul_gva_lockless_end()).
- *
- * Should be called with IRQs already enabled.
- */
-void kvm_trap_emul_gva_lockless_begin(struct kvm_vcpu *vcpu)
-{
-	/* We re-enable IRQs in kvm_trap_emul_gva_lockless_end() */
-	WARN_ON_ONCE(irqs_disabled());
-
-	/*
-	 * The caller is about to access the GVA space, so we set the mode to
-	 * force TLB flush requests to send an IPI, and also disable IRQs to
-	 * delay IPI handling until kvm_trap_emul_gva_lockless_end().
-	 */
-	local_irq_disable();
-
-	/*
-	 * Make sure the read of VCPU requests is not reordered ahead of the
-	 * write to vcpu->mode, or we could miss a TLB flush request while
-	 * the requester sees the VCPU as outside of guest mode and not needing
-	 * an IPI.
-	 */
-	smp_store_mb(vcpu->mode, READING_SHADOW_PAGE_TABLES);
-
-	/*
-	 * If a TLB flush has been requested (potentially while
-	 * OUTSIDE_GUEST_MODE and assumed immediately effective), perform it
-	 * before accessing the GVA space, and be sure to reload the ASID if
-	 * necessary as it'll be immediately used.
-	 *
-	 * TLB flush requests after this check will trigger an IPI due to the
-	 * mode change above, which will be delayed due to IRQs disabled.
-	 */
-	kvm_trap_emul_check_requests(vcpu, smp_processor_id(), true);
-}
-
-/**
- * kvm_trap_emul_gva_lockless_end() - End lockless access to GVA space.
- * @vcpu:	VCPU pointer.
- *
- * Called after a GVA space access outside of guest mode. Should have a matching
- * call to kvm_trap_emul_gva_lockless_begin().
- */
-void kvm_trap_emul_gva_lockless_end(struct kvm_vcpu *vcpu)
-{
-	/*
-	 * Make sure the write to vcpu->mode is not reordered in front of GVA
-	 * accesses, or a TLB flush requester may not think it necessary to send
-	 * an IPI.
-	 */
-	smp_store_release(&vcpu->mode, OUTSIDE_GUEST_MODE);
-
-	/*
-	 * Now that the access to GVA space is complete, its safe for pending
-	 * TLB flush request IPIs to be handled (which indicates completion).
-	 */
-	local_irq_enable();
-}
-
-static void kvm_trap_emul_vcpu_reenter(struct kvm_vcpu *vcpu)
-{
-	struct mm_struct *kern_mm = &vcpu->arch.guest_kernel_mm;
-	struct mm_struct *user_mm = &vcpu->arch.guest_user_mm;
-	struct mm_struct *mm;
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	int i, cpu = smp_processor_id();
-	unsigned int gasid;
-
-	/*
-	 * No need to reload ASID, IRQs are disabled already so there's no rush,
-	 * and we'll check if we need to regenerate below anyway before
-	 * re-entering the guest.
-	 */
-	kvm_trap_emul_check_requests(vcpu, cpu, false);
-
-	if (KVM_GUEST_KERNEL_MODE(vcpu)) {
-		mm = kern_mm;
-	} else {
-		mm = user_mm;
-
-		/*
-		 * Lazy host ASID regeneration / PT flush for guest user mode.
-		 * If the guest ASID has changed since the last guest usermode
-		 * execution, invalidate the stale TLB entries and flush GVA PT
-		 * entries too.
-		 */
-		gasid = kvm_read_c0_guest_entryhi(cop0) & KVM_ENTRYHI_ASID;
-		if (gasid != vcpu->arch.last_user_gasid) {
-			kvm_mips_flush_gva_pt(user_mm->pgd, KMF_USER);
-			for_each_possible_cpu(i)
-				set_cpu_context(i, user_mm, 0);
-			vcpu->arch.last_user_gasid = gasid;
-		}
-	}
-
-	/*
-	 * Check if ASID is stale. This may happen due to a TLB flush request or
-	 * a lazy user MM invalidation.
-	 */
-	check_mmu_context(mm);
-}
-
-static int kvm_trap_emul_vcpu_run(struct kvm_vcpu *vcpu)
-{
-	int cpu = smp_processor_id();
-	int r;
-
-	/* Check if we have any exceptions/interrupts pending */
-	kvm_mips_deliver_interrupts(vcpu,
-				    kvm_read_c0_guest_cause(vcpu->arch.cop0));
-
-	kvm_trap_emul_vcpu_reenter(vcpu);
-
-	/*
-	 * We use user accessors to access guest memory, but we don't want to
-	 * invoke Linux page faulting.
-	 */
-	pagefault_disable();
-
-	/* Disable hardware page table walking while in guest */
-	htw_stop();
-
-	/*
-	 * While in guest context we're in the guest's address space, not the
-	 * host process address space, so we need to be careful not to confuse
-	 * e.g. cache management IPIs.
-	 */
-	kvm_mips_suspend_mm(cpu);
-
-	r = vcpu->arch.vcpu_run(vcpu);
-
-	/* We may have migrated while handling guest exits */
-	cpu = smp_processor_id();
-
-	/* Restore normal Linux process memory map */
-	check_switch_mmu_context(current->mm);
-	kvm_mips_resume_mm(cpu);
-
-	htw_start();
-
-	pagefault_enable();
-
-	return r;
-}
-
-static struct kvm_mips_callbacks kvm_trap_emul_callbacks = {
-	/* exit handlers */
-	.handle_cop_unusable = kvm_trap_emul_handle_cop_unusable,
-	.handle_tlb_mod = kvm_trap_emul_handle_tlb_mod,
-	.handle_tlb_st_miss = kvm_trap_emul_handle_tlb_st_miss,
-	.handle_tlb_ld_miss = kvm_trap_emul_handle_tlb_ld_miss,
-	.handle_addr_err_st = kvm_trap_emul_handle_addr_err_st,
-	.handle_addr_err_ld = kvm_trap_emul_handle_addr_err_ld,
-	.handle_syscall = kvm_trap_emul_handle_syscall,
-	.handle_res_inst = kvm_trap_emul_handle_res_inst,
-	.handle_break = kvm_trap_emul_handle_break,
-	.handle_trap = kvm_trap_emul_handle_trap,
-	.handle_msa_fpe = kvm_trap_emul_handle_msa_fpe,
-	.handle_fpe = kvm_trap_emul_handle_fpe,
-	.handle_msa_disabled = kvm_trap_emul_handle_msa_disabled,
-	.handle_guest_exit = kvm_trap_emul_no_handler,
-
-	.hardware_enable = kvm_trap_emul_hardware_enable,
-	.hardware_disable = kvm_trap_emul_hardware_disable,
-	.check_extension = kvm_trap_emul_check_extension,
-	.vcpu_init = kvm_trap_emul_vcpu_init,
-	.vcpu_uninit = kvm_trap_emul_vcpu_uninit,
-	.vcpu_setup = kvm_trap_emul_vcpu_setup,
-	.flush_shadow_all = kvm_trap_emul_flush_shadow_all,
-	.flush_shadow_memslot = kvm_trap_emul_flush_shadow_memslot,
-	.gva_to_gpa = kvm_trap_emul_gva_to_gpa_cb,
-	.queue_timer_int = kvm_mips_queue_timer_int_cb,
-	.dequeue_timer_int = kvm_mips_dequeue_timer_int_cb,
-	.queue_io_int = kvm_mips_queue_io_int_cb,
-	.dequeue_io_int = kvm_mips_dequeue_io_int_cb,
-	.irq_deliver = kvm_mips_irq_deliver_cb,
-	.irq_clear = kvm_mips_irq_clear_cb,
-	.num_regs = kvm_trap_emul_num_regs,
-	.copy_reg_indices = kvm_trap_emul_copy_reg_indices,
-	.get_one_reg = kvm_trap_emul_get_one_reg,
-	.set_one_reg = kvm_trap_emul_set_one_reg,
-	.vcpu_load = kvm_trap_emul_vcpu_load,
-	.vcpu_put = kvm_trap_emul_vcpu_put,
-	.vcpu_run = kvm_trap_emul_vcpu_run,
-	.vcpu_reenter = kvm_trap_emul_vcpu_reenter,
-};
-
-int kvm_mips_emulation_init(struct kvm_mips_callbacks **install_callbacks)
-{
-	*install_callbacks = &kvm_trap_emul_callbacks;
-	return 0;
-}
diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index 2ffbe9264a31..d0d03bddbbba 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -292,9 +292,8 @@ static int kvm_vz_irq_clear_cb(struct kvm_vcpu *vcpu, unsigned int priority,
 	switch (priority) {
 	case MIPS_EXC_INT_TIMER:
 		/*
-		 * Call to kvm_write_c0_guest_compare() clears Cause.TI in
-		 * kvm_mips_emulate_CP0(). Explicitly clear irq associated with
-		 * Cause.IP[IPTI] if GuestCtl2 virtual interrupt register not
+		 * Explicitly clear irq associated with Cause.IP[IPTI]
+		 * if GuestCtl2 virtual interrupt register not
 		 * supported or if not using GuestCtl2 Hardware Clear.
 		 */
 		if (cpu_has_guestctl2) {
-- 
2.29.2

