Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3336E28928E
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 21:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403891AbgJITvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 15:51:13 -0400
Received: from mga05.intel.com ([192.55.52.43]:56235 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390840AbgJITuu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 15:50:50 -0400
IronPort-SDR: w1qCiG3AJrbHpSZTfimcXSJzO/yJWuRyVF4QWgalq7actQXgPvgRXk29wA5KGD6UbigUjAM3yo
 dw4QNiCtCnjg==
X-IronPort-AV: E=McAfee;i="6000,8403,9769"; a="250225864"
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="250225864"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:50:46 -0700
IronPort-SDR: qnBWOjzlCrAn0iz4juA1IxPDmIdlUS8zYMFKRiVxpP3UruuZtN+Up+nA/7WPjpw84o9yPhVhmH
 jUXVTF6t7/+g==
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="298530884"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:50:46 -0700
From:   ira.weiny@intel.com
To:     Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Ira Weiny <ira.weiny@intel.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kexec@lists.infradead.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, devel@driverdev.osuosl.org,
        linux-efi@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        linux-um@lists.infradead.org, linux-ntfs-dev@lists.sourceforge.net,
        reiserfs-devel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, cluster-devel@redhat.com,
        ecryptfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-cachefs@redhat.com,
        samba-technical@lists.samba.org, intel-wired-lan@lists.osuosl.org
Subject: [PATCH RFC PKS/PMEM 01/58] x86/pks: Add a global pkrs option
Date:   Fri,  9 Oct 2020 12:49:36 -0700
Message-Id: <20201009195033.3208459-2-ira.weiny@intel.com>
X-Mailer: git-send-email 2.28.0.rc0.12.gb6a658bd00c9
In-Reply-To: <20201009195033.3208459-1-ira.weiny@intel.com>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

Some users, such as kmap(), sometimes requires PKS to be global.
However, updating all CPUs, and worse yet all threads is expensive.

Introduce a global PKRS state which is checked at critical times to
allow the state to enable access when global PKS is required.  To
accomplish this with minimal locking; the code is carefully designed
with the following key concepts.

1) Borrow the idea of lazy TLB invalidations from the fault handler
   code.  When enabling PKS access we anticipate that other threads are
   not yet running.  However, if they are we catch the fault and clean
   up the MSR value.

2) When disabling PKS access we force all MSR values across all CPU's.
   This is required to block access as soon as possible.[1]  However, it
   is key that we never attempt to update the per-task PKS values
   directly.  See next point.

3) Per-task PKS values never get updated with global PKS values.  This
   is key to prevent locking requirements and a nearly intractable
   problem of trying to update every task in the system.  Here are a few
   key points.

   3a) The MSR value can be updated with the global PKS value if that
   global value happened to change while the task was running.

   3b) If the task was sleeping while the global PKS was updated then
   the global value is added in when task's are scheduled.

   3c) If the global PKS value restricts access the MSR is updated as
   soon as possible[1] and the thread value is not updated which ensures
   the thread does not retain the elevated privileges after a context
   switch.

4) Follow on patches must be careful to preserve the separation of the
   thread PKRS value and the MSR value.

5) Access Disable on any individual pkey is turned into (Access Disable
   | Write Disable) to facilitate faster integration of the global value
   into the thread local MSR through a simple '&' operation.  Doing
   otherwise would result in complicated individual bit manipulation for
   each pkey.

[1] There is a race condition which is ignored which is required for
performance issues.  This potentially allows access to a thread until
the end of it's time slice.  After the context switch the global value
will be restored.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 Documentation/core-api/protection-keys.rst |  11 +-
 arch/x86/entry/common.c                    |   7 +
 arch/x86/include/asm/pkeys.h               |   6 +-
 arch/x86/include/asm/pkeys_common.h        |   8 +-
 arch/x86/kernel/process.c                  |  74 +++++++-
 arch/x86/mm/fault.c                        | 189 ++++++++++++++++-----
 arch/x86/mm/pkeys.c                        |  88 ++++++++--
 include/linux/pkeys.h                      |   6 +-
 lib/pks/pks_test.c                         |  16 +-
 9 files changed, 329 insertions(+), 76 deletions(-)

diff --git a/Documentation/core-api/protection-keys.rst b/Documentation/core-api/protection-keys.rst
index c60366921d60..9e8a98653e13 100644
--- a/Documentation/core-api/protection-keys.rst
+++ b/Documentation/core-api/protection-keys.rst
@@ -121,9 +121,9 @@ mapping adds that mapping to the protection domain.
         int pks_key_alloc(const char * const pkey_user);
         #define PAGE_KERNEL_PKEY(pkey)
         #define _PAGE_KEY(pkey)
-        void pks_mknoaccess(int pkey);
-        void pks_mkread(int pkey);
-        void pks_mkrdwr(int pkey);
+        void pks_mknoaccess(int pkey, bool global);
+        void pks_mkread(int pkey, bool global);
+        void pks_mkrdwr(int pkey, bool global);
         void pks_key_free(int pkey);
 
 pks_key_alloc() allocates keys dynamically to allow better use of the limited
@@ -141,7 +141,10 @@ _PAGE_KEY().
 The pks_mk*() family of calls allows kernel users the ability to change the
 protections for the domain identified by the pkey specified.  3 states are
 available pks_mknoaccess(), pks_mkread(), and pks_mkrdwr() which set the access
-to none, read, and read/write respectively.
+to none, read, and read/write respectively.  'global' specifies that the
+protection should be set across all threads (logical CPU's) not just the
+current running thread/CPU.  This increases the overhead of PKS and lessens the
+protection so it should be used sparingly.
 
 Finally, pks_key_free() allows a user to return the key to the allocator for
 use by others.
diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index 324a8fd5ac10..86ad32e0095e 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -261,12 +261,19 @@ noinstr void idtentry_exit_nmi(struct pt_regs *regs, irqentry_state_t *irq_state
  * current running value and set the default PKRS value for the duration of the
  * exception.  Thus preventing exception handlers from having the elevated
  * access of the interrupted task.
+ *
+ * NOTE That the thread saved PKRS must be preserved separately to ensure
+ * global overrides do not 'stick' on a thread.
  */
 noinstr void irq_save_pkrs(irqentry_state_t *state)
 {
 	if (!cpu_feature_enabled(X86_FEATURE_PKS))
 		return;
 
+	/*
+	 * The thread_pkrs must be maintained separately to prevent global
+	 * overrides from 'sticking' on a thread.
+	 */
 	state->thread_pkrs = current->thread.saved_pkrs;
 	state->pkrs = this_cpu_read(pkrs_cache);
 	write_pkrs(INIT_PKRS_VALUE);
diff --git a/arch/x86/include/asm/pkeys.h b/arch/x86/include/asm/pkeys.h
index 79952216474e..cae0153a5480 100644
--- a/arch/x86/include/asm/pkeys.h
+++ b/arch/x86/include/asm/pkeys.h
@@ -143,9 +143,9 @@ u32 update_pkey_val(u32 pk_reg, int pkey, unsigned int flags);
 int pks_key_alloc(const char *const pkey_user);
 void pks_key_free(int pkey);
 
-void pks_mknoaccess(int pkey);
-void pks_mkread(int pkey);
-void pks_mkrdwr(int pkey);
+void pks_mknoaccess(int pkey, bool global);
+void pks_mkread(int pkey, bool global);
+void pks_mkrdwr(int pkey, bool global);
 
 #endif /* CONFIG_ARCH_HAS_SUPERVISOR_PKEYS */
 
diff --git a/arch/x86/include/asm/pkeys_common.h b/arch/x86/include/asm/pkeys_common.h
index 8961e2ddd6ff..e380679ba1bb 100644
--- a/arch/x86/include/asm/pkeys_common.h
+++ b/arch/x86/include/asm/pkeys_common.h
@@ -6,7 +6,12 @@
 #define PKR_WD_BIT 0x2
 #define PKR_BITS_PER_PKEY 2
 
-#define PKR_AD_KEY(pkey)	(PKR_AD_BIT << ((pkey) * PKR_BITS_PER_PKEY))
+/*
+ * We must define 11b as the default to make global overrides efficient.
+ * See arch/x86/kernel/process.c where the global pkrs is factored in during
+ * context switch.
+ */
+#define PKR_AD_KEY(pkey)	((PKR_WD_BIT | PKR_AD_BIT) << ((pkey) * PKR_BITS_PER_PKEY))
 
 /*
  * Define a default PKRS value for each task.
@@ -27,6 +32,7 @@
 #define        PKS_NUM_KEYS            16
 
 #ifdef CONFIG_ARCH_HAS_SUPERVISOR_PKEYS
+extern u32 pkrs_global_cache;
 DECLARE_PER_CPU(u32, pkrs_cache);
 noinstr void write_pkrs(u32 new_pkrs);
 #else
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index eb3a95a69392..58edd162d9cb 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -43,7 +43,7 @@
 #include <asm/io_bitmap.h>
 #include <asm/proto.h>
 #include <asm/frame.h>
-#include <asm/pkeys_common.h>
+#include <linux/pkeys.h>
 
 #include "process.h"
 
@@ -189,15 +189,83 @@ int copy_thread(unsigned long clone_flags, unsigned long sp, unsigned long arg,
 }
 
 #ifdef CONFIG_ARCH_HAS_SUPERVISOR_PKEYS
-DECLARE_PER_CPU(u32, pkrs_cache);
 static inline void pks_init_task(struct task_struct *tsk)
 {
 	/* New tasks get the most restrictive PKRS value */
 	tsk->thread.saved_pkrs = INIT_PKRS_VALUE;
 }
+
+extern u32 pkrs_global_cache;
+
+/**
+ * The global PKRS value can only increase access.  Because 01b and 11b both
+ * disable access.  The following truth table is our desired result for each of
+ * the pkeys when we add in the global permissions.
+ *
+ * 00 R/W    - Write enabled (all access)
+ * 10 Read   - write disabled (Read only)
+ * 01 NO Acc - access disabled
+ * 11 NO Acc - also access disabled
+ *
+ * local  global  desired   required
+ *                result    operation
+ * 00      00         00      &
+ * 00      10         00      &
+ * 00      01         00      &
+ * 00      11         00      &
+ *
+ * 10      00         00      &
+ * 10      10         10      &
+ * 10      01         10      ^ special case
+ * 10      11         10      &
+ *
+ * 01      00         00      &
+ * 01      10         10      ^ special case
+ * 01      01         01      &
+ * 01      11         01      &
+ *
+ * 11      00         00      &
+ * 11      10         10      &
+ * 11      01         01      &
+ * 11      11         11      &
+ *
+ * In order to eliminate the need to loop through each pkey and deal with the 2
+ * above special cases we force all 01b values to 11b through the API thus
+ * resulting in the simplified truth table below.
+ *
+ * 00 R/W    - Write enabled (all access)
+ * 10 Read   - write disabled (Read only)
+ * 01 NO Acc - access disabled
+ *    (Not allowed in the API always use 11)
+ * 11 NO Acc - access disabled
+ *
+ * local  global  desired   effective
+ *                result    operation
+ * 00      00         00      &
+ * 00      10         00      &
+ * 00      11         00      &
+ * 00      11         00      &
+ *
+ * 10      00         00      &
+ * 10      10         10      &
+ * 10      11         10      &
+ * 10      11         10      &
+ *
+ * 11      00         00      &
+ * 11      10         10      &
+ * 11      11         11      &
+ * 11      11         11      &
+ *
+ * 11      00         00      &
+ * 11      10         10      &
+ * 11      11         11      &
+ * 11      11         11      &
+ *
+ * Thus we can simply 'AND' in the global pkrs value.
+ */
 static inline void pks_sched_in(void)
 {
-	write_pkrs(current->thread.saved_pkrs);
+	write_pkrs(current->thread.saved_pkrs & pkrs_global_cache);
 }
 #else
 static inline void pks_init_task(struct task_struct *tsk) { }
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index dd5af9399131..4b4ff9efa298 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -32,6 +32,8 @@
 #include <asm/pgtable_areas.h>		/* VMALLOC_START, ...		*/
 #include <asm/kvm_para.h>		/* kvm_handle_async_pf		*/
 
+#include <asm-generic/mman-common.h>
+
 #define CREATE_TRACE_POINTS
 #include <asm/trace/exceptions.h>
 
@@ -995,9 +997,124 @@ mm_fault_error(struct pt_regs *regs, unsigned long error_code,
 	}
 }
 
-static int spurious_kernel_fault_check(unsigned long error_code, pte_t *pte)
+#ifdef CONFIG_ARCH_HAS_SUPERVISOR_PKEYS
+/*
+ * check if we have had a 'global' pkey update.  If so, handle this like a lazy
+ * TLB; fix up the local MSR and return
+ *
+ * See arch/x86/kernel/process.c for the explanation on how global is handled
+ * with a simple '&' operation.
+ *
+ * Also we don't update the current thread saved_pkrs because we don't want the
+ * global value to 'stick' with the thread.  Rather we want this to be valid
+ * only for the remainder of this time slice.  For subsequent time slices the
+ * global value will be factored in during schedule; see arch/x86/kernel/process.c
+ *
+ * Finally we have a trade off between performance and forcing a restriction of
+ * permissions across all CPUs on a global update.
+ *
+ * Given the following window.
+ *
+ *          Global PKRS            CPU #0                CPU #1
+ *             cache                 MSR                   MSR
+ *
+ *                  |                  |                     |
+ *   Global         |----------\       |                     |
+ *   Restriction    |           ------------> read           |             <= T1
+ *   (on CPU #0)    |                  |       |             |
+ *    ------\       |                  |       |             |
+ *           ------>|                  |       |             |
+ *                  |                  |       |             |
+ *    Update CPU #1 |--------\         |       |             |
+ *                  |         --------------\  |             |
+ *                  |                  |     --|------------>|
+ *    Global remote |                  |       |             |
+ *     MSR update   |                  |       |             |
+ *     (CPU 2-n)    |                  |       |             |
+ *                  |-----> CPU's      |       v             |
+ *   local          |       (2-N)      |     local --\       |
+ *   update         |                  |     update   ------>|(Update      <= T2
+ *    ----------------\                |                     | Incorrect)
+ *                  |  -----------\    |                     |
+ *                  |              --->|(Update OK)          |
+ *         Context  |                  |                     |
+ *         Switch   |----------\       |                     |
+ *                  |           ------------> read           |
+ *                  |                  |       |             |
+ *                  |                  |       |             |
+ *                  |                  |       v             |
+ *                  |                  |     local --\       |
+ *                  |                  |     update   ------>|(Update
+ *                  |                  |                     | Correct)
+ *
+ * We allow for a larger window of the global pkey being open because global
+ * updates should be rare and we don't want to burden normal faults with having
+ * to read the global state.
+ */
+static bool global_pkey_is_enabled(pte_t *pte, bool is_write,
+				   irqentry_state_t *irq_state)
+{
+	u8 pkey = pte_flags_pkey(pte->pte);
+	int pkey_shift = pkey * PKR_BITS_PER_PKEY;
+	u32 mask = (((1 << PKR_BITS_PER_PKEY) - 1) << pkey_shift);
+	u32 global = READ_ONCE(pkrs_global_cache);
+	u32 val;
+
+	/* Return early if global access is not valid */
+	val = (global & mask) >> pkey_shift;
+	if ((val & PKR_AD_BIT) || (is_write && (val & PKR_WD_BIT)))
+		return false;
+
+	irq_state->pkrs &= global;
+
+	return true;
+}
+
+#else /* !CONFIG_ARCH_HAS_SUPERVISOR_PKEYS */
+__always_inline bool global_pkey_is_enabled(pte_t *pte, bool is_write,
+					    irqentry_state_t *irq_state)
+{
+	return false;
+}
+#endif /* CONFIG_ARCH_HAS_SUPERVISOR_PKEYS */
+
+#ifdef CONFIG_PKS_TESTING
+bool pks_test_callback(irqentry_state_t *irq_state);
+static bool handle_pks_testing(unsigned long hw_error_code, irqentry_state_t *irq_state)
+{
+	/*
+	 * If we get a protection key exception it could be because we
+	 * are running the PKS test.  If so, pks_test_callback() will
+	 * clear the protection mechanism and return true to indicate
+	 * the fault was handled
+	 */
+	return pks_test_callback(irq_state);
+}
+#else /* !CONFIG_PKS_TESTING */
+static bool handle_pks_testing(unsigned long hw_error_code, irqentry_state_t *irq_state)
+{
+	return false;
+}
+#endif /* CONFIG_PKS_TESTING */
+
+
+static int spurious_kernel_fault_check(unsigned long error_code, pte_t *pte,
+				       irqentry_state_t *irq_state)
 {
-	if ((error_code & X86_PF_WRITE) && !pte_write(*pte))
+	bool is_write = (error_code & X86_PF_WRITE);
+
+	if (IS_ENABLED(CONFIG_ARCH_HAS_SUPERVISOR_PKEYS) &&
+	    error_code & X86_PF_PK) {
+		if (global_pkey_is_enabled(pte, is_write, irq_state))
+			return 1;
+
+		if (handle_pks_testing(error_code, irq_state))
+			return 1;
+
+		return 0;
+	}
+
+	if (is_write && !pte_write(*pte))
 		return 0;
 
 	if ((error_code & X86_PF_INSTR) && !pte_exec(*pte))
@@ -1007,7 +1124,7 @@ static int spurious_kernel_fault_check(unsigned long error_code, pte_t *pte)
 }
 
 /*
- * Handle a spurious fault caused by a stale TLB entry.
+ * Handle a spurious fault caused by a stale TLB entry or a lazy PKRS update.
  *
  * This allows us to lazily refresh the TLB when increasing the
  * permissions of a kernel page (RO -> RW or NX -> X).  Doing it
@@ -1022,13 +1139,19 @@ static int spurious_kernel_fault_check(unsigned long error_code, pte_t *pte)
  * There are no security implications to leaving a stale TLB when
  * increasing the permissions on a page.
  *
+ * Similarly, PKRS increases in permissions are done on a thread local level.
+ * But if the caller indicates the permission should be allowd globaly we can
+ * lazily update only those threads which fault and avoid a global IPI MSR
+ * update.
+ *
  * Returns non-zero if a spurious fault was handled, zero otherwise.
  *
  * See Intel Developer's Manual Vol 3 Section 4.10.4.3, bullet 3
  * (Optional Invalidation).
  */
 static noinline int
-spurious_kernel_fault(unsigned long error_code, unsigned long address)
+spurious_kernel_fault(unsigned long error_code, unsigned long address,
+		      irqentry_state_t *irq_state)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -1038,17 +1161,19 @@ spurious_kernel_fault(unsigned long error_code, unsigned long address)
 	int ret;
 
 	/*
-	 * Only writes to RO or instruction fetches from NX may cause
-	 * spurious faults.
+	 * Only PKey faults or writes to RO or instruction fetches from NX may
+	 * cause spurious faults.
 	 *
 	 * These could be from user or supervisor accesses but the TLB
 	 * is only lazily flushed after a kernel mapping protection
 	 * change, so user accesses are not expected to cause spurious
 	 * faults.
 	 */
-	if (error_code != (X86_PF_WRITE | X86_PF_PROT) &&
-	    error_code != (X86_PF_INSTR | X86_PF_PROT))
-		return 0;
+	if (!(error_code & X86_PF_PK)) {
+		if (error_code != (X86_PF_WRITE | X86_PF_PROT) &&
+		    error_code != (X86_PF_INSTR | X86_PF_PROT))
+			return 0;
+	}
 
 	pgd = init_mm.pgd + pgd_index(address);
 	if (!pgd_present(*pgd))
@@ -1059,27 +1184,31 @@ spurious_kernel_fault(unsigned long error_code, unsigned long address)
 		return 0;
 
 	if (p4d_large(*p4d))
-		return spurious_kernel_fault_check(error_code, (pte_t *) p4d);
+		return spurious_kernel_fault_check(error_code, (pte_t *) p4d,
+						   irq_state);
 
 	pud = pud_offset(p4d, address);
 	if (!pud_present(*pud))
 		return 0;
 
 	if (pud_large(*pud))
-		return spurious_kernel_fault_check(error_code, (pte_t *) pud);
+		return spurious_kernel_fault_check(error_code, (pte_t *) pud,
+						   irq_state);
 
 	pmd = pmd_offset(pud, address);
 	if (!pmd_present(*pmd))
 		return 0;
 
 	if (pmd_large(*pmd))
-		return spurious_kernel_fault_check(error_code, (pte_t *) pmd);
+		return spurious_kernel_fault_check(error_code, (pte_t *) pmd,
+						   irq_state);
 
 	pte = pte_offset_kernel(pmd, address);
 	if (!pte_present(*pte))
 		return 0;
 
-	ret = spurious_kernel_fault_check(error_code, pte);
+	ret = spurious_kernel_fault_check(error_code, pte,
+					  irq_state);
 	if (!ret)
 		return 0;
 
@@ -1087,7 +1216,8 @@ spurious_kernel_fault(unsigned long error_code, unsigned long address)
 	 * Make sure we have permissions in PMD.
 	 * If not, then there's a bug in the page tables:
 	 */
-	ret = spurious_kernel_fault_check(error_code, (pte_t *) pmd);
+	ret = spurious_kernel_fault_check(error_code, (pte_t *) pmd,
+					  irq_state);
 	WARN_ONCE(!ret, "PMD has incorrect permission bits\n");
 
 	return ret;
@@ -1150,25 +1280,6 @@ static int fault_in_kernel_space(unsigned long address)
 	return address >= TASK_SIZE_MAX;
 }
 
-#ifdef CONFIG_PKS_TESTING
-bool pks_test_callback(irqentry_state_t *irq_state);
-static bool handle_pks_testing(unsigned long hw_error_code, irqentry_state_t *irq_state)
-{
-	/*
-	 * If we get a protection key exception it could be because we
-	 * are running the PKS test.  If so, pks_test_callback() will
-	 * clear the protection mechanism and return true to indicate
-	 * the fault was handled.
-	 */
-	return (hw_error_code & X86_PF_PK) && pks_test_callback(irq_state);
-}
-#else
-static bool handle_pks_testing(unsigned long hw_error_code, irqentry_state_t *irq_state)
-{
-	return false;
-}
-#endif
-
 /*
  * Called for all faults where 'address' is part of the kernel address
  * space.  Might get called for faults that originate from *code* that
@@ -1186,9 +1297,6 @@ do_kern_addr_fault(struct pt_regs *regs, unsigned long hw_error_code,
 	    !cpu_feature_enabled(X86_FEATURE_PKS))
 		WARN_ON_ONCE(hw_error_code & X86_PF_PK);
 
-	if (handle_pks_testing(hw_error_code, irq_state))
-		return;
-
 #ifdef CONFIG_X86_32
 	/*
 	 * We can fault-in kernel-space virtual memory on-demand. The
@@ -1220,8 +1328,11 @@ do_kern_addr_fault(struct pt_regs *regs, unsigned long hw_error_code,
 	}
 #endif
 
-	/* Was the fault spurious, caused by lazy TLB invalidation? */
-	if (spurious_kernel_fault(hw_error_code, address))
+	/*
+	 * Was the fault spurious; caused by lazy TLB invalidation or PKRS
+	 * update?
+	 */
+	if (spurious_kernel_fault(hw_error_code, address, irq_state))
 		return;
 
 	/* kprobes don't want to hook the spurious faults: */
@@ -1492,7 +1603,7 @@ DEFINE_IDTENTRY_RAW_ERRORCODE(exc_page_fault)
 	 *
 	 * Fingers crossed.
 	 *
-	 * The async #PF handling code takes care of idtentry handling
+	 * The async #PF handling code takes care of irqentry handling
 	 * itself.
 	 */
 	if (kvm_handle_async_pf(regs, (u32)address))
diff --git a/arch/x86/mm/pkeys.c b/arch/x86/mm/pkeys.c
index 2431c68ef752..a45893069877 100644
--- a/arch/x86/mm/pkeys.c
+++ b/arch/x86/mm/pkeys.c
@@ -263,33 +263,84 @@ noinstr void write_pkrs(u32 new_pkrs)
 }
 EXPORT_SYMBOL_GPL(write_pkrs);
 
+/*
+ * NOTE: The pkrs_global_cache is _never_ stored in the per thread PKRS cache
+ * values [thread.saved_pkrs] by design
+ *
+ * This allows us to invalidate access on running threads immediately upon
+ * invalidate.  Sleeping threads will not be enabled due to the algorithm
+ * during pkrs_sched_in()
+ */
+DEFINE_SPINLOCK(pkrs_global_cache_lock);
+u32 pkrs_global_cache = INIT_PKRS_VALUE;
+EXPORT_SYMBOL_GPL(pkrs_global_cache);
+
+static inline void update_global_pkrs(int pkey, unsigned long protection)
+{
+	int pkey_shift = pkey * PKR_BITS_PER_PKEY;
+	u32 mask = (((1 << PKR_BITS_PER_PKEY) - 1) << pkey_shift);
+	u32 old_val;
+
+	spin_lock(&pkrs_global_cache_lock);
+	old_val = (pkrs_global_cache & mask) >> pkey_shift;
+	pkrs_global_cache &= ~mask;
+	if (protection & PKEY_DISABLE_ACCESS)
+		pkrs_global_cache |= PKR_AD_BIT << pkey_shift;
+	if (protection & PKEY_DISABLE_WRITE)
+		pkrs_global_cache |= PKR_WD_BIT << pkey_shift;
+
+	/*
+	 * If we are preventing access from the old value.  Force the
+	 * update on all running threads.
+	 */
+	if (((old_val == 0) && protection) ||
+	    ((old_val & PKR_WD_BIT) && (protection & PKEY_DISABLE_ACCESS))) {
+		int cpu;
+
+		for_each_online_cpu(cpu) {
+			u32 *ptr = per_cpu_ptr(&pkrs_cache, cpu);
+
+			*ptr = update_pkey_val(*ptr, pkey, protection);
+			wrmsrl_on_cpu(cpu, MSR_IA32_PKRS, *ptr);
+			put_cpu_ptr(ptr);
+		}
+	}
+	spin_unlock(&pkrs_global_cache_lock);
+}
+
 /**
  * Do not call this directly, see pks_mk*() below.
  *
  * @pkey: Key for the domain to change
  * @protection: protection bits to be used
+ * @global: should this change be made globally or not.
  *
  * Protection utilizes the same protection bits specified for User pkeys
  *     PKEY_DISABLE_ACCESS
  *     PKEY_DISABLE_WRITE
  *
  */
-static inline void pks_update_protection(int pkey, unsigned long protection)
+static inline void pks_update_protection(int pkey, unsigned long protection,
+					 bool global)
 {
-	current->thread.saved_pkrs = update_pkey_val(current->thread.saved_pkrs,
-						     pkey, protection);
 	preempt_disable();
+	if (global)
+		update_global_pkrs(pkey, protection);
+
+	current->thread.saved_pkrs = update_pkey_val(current->thread.saved_pkrs, pkey,
+						     protection);
 	write_pkrs(current->thread.saved_pkrs);
+
 	preempt_enable();
 }
 
 /**
  * PKS access control functions
  *
- * Change the access of the domain specified by the pkey.  These are global
- * updates.  They only affects the current running thread.  It is undefined and
- * a bug for users to call this without having allocated a pkey and using it as
- * pkey here.
+ * Change the access of the domain specified by the pkey.  These may be global
+ * updates depending on the value of global.  It is undefined and a bug for
+ * users to call this without having allocated a pkey and using it as pkey
+ * here.
  *
  * pks_mknoaccess()
  *     Disable all access to the domain
@@ -299,23 +350,30 @@ static inline void pks_update_protection(int pkey, unsigned long protection)
  *     Make the domain Read/Write
  *
  * @pkey the pkey for which the access should change.
- *
+ * @global if true the access is enabled on all threads/logical cpus
  */
-void pks_mknoaccess(int pkey)
+void pks_mknoaccess(int pkey, bool global)
 {
-	pks_update_protection(pkey, PKEY_DISABLE_ACCESS);
+	/*
+	 * We force disable access to be 11b
+	 * (PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE)
+	 * instaed of 01b See arch/x86/kernel/process.c where the global pkrs
+	 * is factored in during context switch.
+	 */
+	pks_update_protection(pkey, PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE,
+			      global);
 }
 EXPORT_SYMBOL_GPL(pks_mknoaccess);
 
-void pks_mkread(int pkey)
+void pks_mkread(int pkey, bool global)
 {
-	pks_update_protection(pkey, PKEY_DISABLE_WRITE);
+	pks_update_protection(pkey, PKEY_DISABLE_WRITE, global);
 }
 EXPORT_SYMBOL_GPL(pks_mkread);
 
-void pks_mkrdwr(int pkey)
+void pks_mkrdwr(int pkey, bool global)
 {
-	pks_update_protection(pkey, 0);
+	pks_update_protection(pkey, 0, global);
 }
 EXPORT_SYMBOL_GPL(pks_mkrdwr);
 
@@ -377,7 +435,7 @@ void pks_key_free(int pkey)
 		return;
 
 	/* Restore to default of no access */
-	pks_mknoaccess(pkey);
+	pks_mknoaccess(pkey, true);
 	pks_key_users[pkey] = NULL;
 	__clear_bit(pkey, &pks_key_allocation_map);
 }
diff --git a/include/linux/pkeys.h b/include/linux/pkeys.h
index f9552bd9341f..8f3bfec83949 100644
--- a/include/linux/pkeys.h
+++ b/include/linux/pkeys.h
@@ -57,15 +57,15 @@ static inline int pks_key_alloc(const char * const pkey_user)
 static inline void pks_key_free(int pkey)
 {
 }
-static inline void pks_mknoaccess(int pkey)
+static inline void pks_mknoaccess(int pkey, bool global)
 {
 	WARN_ON_ONCE(1);
 }
-static inline void pks_mkread(int pkey)
+static inline void pks_mkread(int pkey, bool global)
 {
 	WARN_ON_ONCE(1);
 }
-static inline void pks_mkrdwr(int pkey)
+static inline void pks_mkrdwr(int pkey, bool global)
 {
 	WARN_ON_ONCE(1);
 }
diff --git a/lib/pks/pks_test.c b/lib/pks/pks_test.c
index d7dbf92527bd..286c8b8457da 100644
--- a/lib/pks/pks_test.c
+++ b/lib/pks/pks_test.c
@@ -163,12 +163,12 @@ static void check_exception(irqentry_state_t *irq_state)
 	 * Check we can update the value during exception without affecting the
 	 * calling thread.  The calling thread is checked after exception...
 	 */
-	pks_mkrdwr(test_armed_key);
+	pks_mkrdwr(test_armed_key, false);
 	if (!check_pkrs(test_armed_key, 0)) {
 		pr_err("     FAIL: exception did not change register to 0\n");
 		test_exception_ctx->pass = false;
 	}
-	pks_mknoaccess(test_armed_key);
+	pks_mknoaccess(test_armed_key, false);
 	if (!check_pkrs(test_armed_key, PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE)) {
 		pr_err("     FAIL: exception did not change register to 0x3\n");
 		test_exception_ctx->pass = false;
@@ -314,13 +314,13 @@ static int run_access_test(struct pks_test_ctx *ctx,
 {
 	switch (test->mode) {
 		case PKS_TEST_NO_ACCESS:
-			pks_mknoaccess(ctx->pkey);
+			pks_mknoaccess(ctx->pkey, false);
 			break;
 		case PKS_TEST_RDWR:
-			pks_mkrdwr(ctx->pkey);
+			pks_mkrdwr(ctx->pkey, false);
 			break;
 		case PKS_TEST_RDONLY:
-			pks_mkread(ctx->pkey);
+			pks_mkread(ctx->pkey, false);
 			break;
 		default:
 			pr_err("BUG in test invalid mode\n");
@@ -476,7 +476,7 @@ static void run_exception_test(void)
 		goto free_context;
 	}
 
-	pks_mkread(ctx->pkey);
+	pks_mkread(ctx->pkey, false);
 
 	spin_lock(&test_lock);
 	WRITE_ONCE(test_exception_ctx, ctx);
@@ -556,7 +556,7 @@ static void crash_it(void)
 		return;
 	}
 
-	pks_mknoaccess(ctx->pkey);
+	pks_mknoaccess(ctx->pkey, false);
 
 	spin_lock(&test_lock);
 	WRITE_ONCE(test_armed_key, 0);
@@ -618,7 +618,7 @@ static ssize_t pks_write_file(struct file *file, const char __user *user_buf,
 	/* start of context switch test */
 	if (!strcmp(buf, "1")) {
 		/* Ensure a known state to test context switch */
-		pks_mknoaccess(ctx->pkey);
+		pks_mknoaccess(ctx->pkey, false);
 	}
 
 	/* After context switch msr should be restored */
-- 
2.28.0.rc0.12.gb6a658bd00c9

