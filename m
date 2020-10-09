Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFC5289974
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 22:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391949AbgJIUKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 16:10:46 -0400
Received: from mga04.intel.com ([192.55.52.120]:43246 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403817AbgJITu7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 15:50:59 -0400
IronPort-SDR: I+kluzUq8pxlBDtt5OqAnT2WCF+BNOozZc8KJ9HRHJVfpcd0kw39MYtQEO55RaZxKxDv2NPRPB
 5bQ8ZYnMvMug==
X-IronPort-AV: E=McAfee;i="6000,8403,9769"; a="162893218"
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="162893218"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:50:56 -0700
IronPort-SDR: WlCZORaTV0ocl1yC7IDa4J4IbRZJZvP+KytzS1LtxRNRUTgHeg4W5ZWyzNndx3DpBXRsqL9R3c
 CQItA3N5s8ig==
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="462300571"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:50:55 -0700
From:   ira.weiny@intel.com
To:     Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
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
Subject: [PATCH RFC PKS/PMEM 03/58] memremap: Add zone device access protection
Date:   Fri,  9 Oct 2020 12:49:38 -0700
Message-Id: <20201009195033.3208459-4-ira.weiny@intel.com>
X-Mailer: git-send-email 2.28.0.rc0.12.gb6a658bd00c9
In-Reply-To: <20201009195033.3208459-1-ira.weiny@intel.com>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

Device managed memory exposes itself to the kernel direct map which
allows stray pointers to access these device memories.

Stray pointers to normal memory may result in a crash or other
undesirable behavior which, while unfortunate, are usually recoverable
with a reboot.  Stray access, specifically stray writes, to areas such
as non-volatile memory are permanent in nature and thus are more likely
to result in permanent user data loss vs stray access to other memory
areas.

Furthermore, we protect against reads which can help with speculative
reads to poison areas as well.  But this is a secondary reason.

Set up an infrastructure for extra device access protection. Then
implement the new protection using the new Protection Keys Supervisor
(PKS) on architectures which support it.

To enable this extra protection devices specify a flag in the pgmap to
indicate that these areas wish to use additional protection.

Kernel code which intends to access this memory can do so automatically
through the use of the kmap infrastructure calling into
dev_access_[enable|disable]() described here.  The kmap infrastructure
is implemented in a follow on patch.

In addition, users can directly enable/disable the access through
dev_access_[enable|disable]() if they have a priori knowledge of the
type of pages they are accessing.

All calls to enable/disable protection flow through
dev_access_[enable|disable]() and are nestable by the use of a per task
reference count.  This reference count does 2 things.

1) Allows a thread to nest calls to disable protection such that the
   first call to re-enable protection does not 'break' the last access of
   the pmem device memory.

2) Provides faster performance by avoiding lots of MSR writes.  For
   example, looping over a sequence of pmem pages.

In addition, we must ensure the reference count is preserved through an
exception so we add the count to irqentry_state_t and save/restore the
reference count while giving exceptions their own count should they use
a kmap call.

The following shows how this works through an exception:

    ...
            // ref == 0
            dev_access_enable()  // ref += 1 ==> disable protection
                    irq()
                            // enable protection
                            // ref = 0
                            _handler()
                                    dev_access_enable()   // ref += 1 ==> disable protection
                                    dev_access_disable()  // ref -= 1 ==> enable protection
                            // WARN_ON(ref != 0)
                            // disable protection
            do_pmem_thing()  // all good here
            dev_access_disable() // ref -= 1 ==> 0 ==> enable protection
    ...

Nested exceptions operate the same way with each exception storing the
interrupted exception state all the way down.

The pkey value is never free'ed as this optimizes the implementation to
be either on or off using a static branch conditional in the fast paths.

Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 arch/x86/entry/common.c      | 21 +++++++++
 include/linux/entry-common.h |  3 ++
 include/linux/memremap.h     |  1 +
 include/linux/mm.h           | 43 +++++++++++++++++
 include/linux/sched.h        |  3 ++
 init/init_task.c             |  3 ++
 kernel/fork.c                |  3 ++
 mm/Kconfig                   | 13 ++++++
 mm/memremap.c                | 90 ++++++++++++++++++++++++++++++++++++
 9 files changed, 180 insertions(+)

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index 86ad32e0095e..3680724c1a4d 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -264,12 +264,27 @@ noinstr void idtentry_exit_nmi(struct pt_regs *regs, irqentry_state_t *irq_state
  *
  * NOTE That the thread saved PKRS must be preserved separately to ensure
  * global overrides do not 'stick' on a thread.
+ *
+ * Furthermore, Zone Device Access Protection maintains access in a re-entrant
+ * manner through a reference count which also needs to be maintained should
+ * exception handlers use those interfaces for memory access.  Here we start
+ * off the exception handler ref count to 0 and ensure it is 0 when the
+ * exception is done.  Then restore it for the interrupted task.
  */
 noinstr void irq_save_pkrs(irqentry_state_t *state)
 {
 	if (!cpu_feature_enabled(X86_FEATURE_PKS))
 		return;
 
+#ifdef CONFIG_ZONE_DEVICE_ACCESS_PROTECTION
+	/*
+	 * Save the ref count of the current running process and set it to 0
+	 * for any irq users to properly track re-entrance
+	 */
+	state->pkrs_ref = current->dev_page_access_ref;
+	current->dev_page_access_ref = 0;
+#endif
+
 	/*
 	 * The thread_pkrs must be maintained separately to prevent global
 	 * overrides from 'sticking' on a thread.
@@ -286,6 +301,12 @@ noinstr void irq_restore_pkrs(irqentry_state_t *state)
 
 	write_pkrs(state->pkrs);
 	current->thread.saved_pkrs = state->thread_pkrs;
+
+#ifdef CONFIG_ZONE_DEVICE_ACCESS_PROTECTION
+	WARN_ON_ONCE(current->dev_page_access_ref != 0);
+	/* Restore the interrupted process reference */
+	current->dev_page_access_ref = state->pkrs_ref;
+#endif
 }
 #endif /* CONFIG_ARCH_HAS_SUPERVISOR_PKEYS */
 
diff --git a/include/linux/entry-common.h b/include/linux/entry-common.h
index c3b361ffa059..06743cce2dbf 100644
--- a/include/linux/entry-common.h
+++ b/include/linux/entry-common.h
@@ -343,6 +343,9 @@ void irqentry_exit_to_user_mode(struct pt_regs *regs);
 #ifndef irqentry_state
 typedef struct irqentry_state {
 #ifdef CONFIG_ARCH_HAS_SUPERVISOR_PKEYS
+#ifdef CONFIG_ZONE_DEVICE_ACCESS_PROTECTION
+	unsigned int pkrs_ref;
+#endif
 	u32 pkrs;
 	u32 thread_pkrs;
 #endif
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index e5862746751b..b6713ee7b218 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -89,6 +89,7 @@ struct dev_pagemap_ops {
 };
 
 #define PGMAP_ALTMAP_VALID	(1 << 0)
+#define PGMAP_PROT_ENABLED	(1 << 1)
 
 /**
  * struct dev_pagemap - metadata for ZONE_DEVICE mappings
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 16b799a0522c..9e845515ff15 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1141,6 +1141,49 @@ static inline bool is_pci_p2pdma_page(const struct page *page)
 		page->pgmap->type == MEMORY_DEVICE_PCI_P2PDMA;
 }
 
+#ifdef CONFIG_ZONE_DEVICE_ACCESS_PROTECTION
+DECLARE_STATIC_KEY_FALSE(dev_protection_static_key);
+
+/*
+ * We make page_is_access_protected() as quick as possible.
+ *    1) If no mappings have been enabled with extra protection we skip this
+ *       entirely
+ *    2) Skip pages which are not ZONE_DEVICE
+ *    3) Only then check if this particular page was mapped with extra
+ *       protections.
+ */
+static inline bool page_is_access_protected(struct page *page)
+{
+	if (!static_branch_unlikely(&dev_protection_static_key))
+		return false;
+	if (!is_zone_device_page(page))
+		return false;
+	if (page->pgmap->flags & PGMAP_PROT_ENABLED)
+		return true;
+	return false;
+}
+
+void __dev_access_enable(bool global);
+void __dev_access_disable(bool global);
+static __always_inline void dev_access_enable(bool global)
+{
+	if (static_branch_unlikely(&dev_protection_static_key))
+		__dev_access_enable(global);
+}
+static __always_inline void dev_access_disable(bool global)
+{
+	if (static_branch_unlikely(&dev_protection_static_key))
+		__dev_access_disable(global);
+}
+#else
+static inline bool page_is_access_protected(struct page *page)
+{
+	return false;
+}
+static inline void dev_access_enable(bool global) { }
+static inline void dev_access_disable(bool global) { }
+#endif /* CONFIG_ZONE_DEVICE_ACCESS_PROTECTION */
+
 /* 127: arbitrary random number, small enough to assemble well */
 #define page_ref_zero_or_close_to_overflow(page) \
 	((unsigned int) page_ref_count(page) + 127u <= 127u)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index afe01e232935..25d97ab6c757 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1315,6 +1315,9 @@ struct task_struct {
 	struct callback_head		mce_kill_me;
 #endif
 
+#ifdef CONFIG_ZONE_DEVICE_ACCESS_PROTECTION
+	unsigned int			dev_page_access_ref;
+#endif
 	/*
 	 * New fields for task_struct should be added above here, so that
 	 * they are included in the randomized portion of task_struct.
diff --git a/init/init_task.c b/init/init_task.c
index f6889fce64af..9b39f25de59b 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -209,6 +209,9 @@ struct task_struct init_task
 #ifdef CONFIG_SECCOMP
 	.seccomp	= { .filter_count = ATOMIC_INIT(0) },
 #endif
+#ifdef CONFIG_ZONE_DEVICE_ACCESS_PROTECTION
+	.dev_page_access_ref = 0,
+#endif
 };
 EXPORT_SYMBOL(init_task);
 
diff --git a/kernel/fork.c b/kernel/fork.c
index da8d360fb032..b6a3ee328a89 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -940,6 +940,9 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 
 #ifdef CONFIG_MEMCG
 	tsk->active_memcg = NULL;
+#endif
+#ifdef CONFIG_ZONE_DEVICE_ACCESS_PROTECTION
+	tsk->dev_page_access_ref = 0;
 #endif
 	return tsk;
 
diff --git a/mm/Kconfig b/mm/Kconfig
index 1b9bc004d9bc..01dd75720ae6 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -794,6 +794,19 @@ config ZONE_DEVICE
 
 	  If FS_DAX is enabled, then say Y.
 
+config ZONE_DEVICE_ACCESS_PROTECTION
+	bool "Device memory access protection"
+	depends on ZONE_DEVICE
+	depends on ARCH_HAS_SUPERVISOR_PKEYS
+
+	help
+	  Enable the option of having access protections on device memory
+	  areas.  This protects against access to device memory which is not
+	  intended such as stray writes.  This feature is particularly useful
+	  to protect against corruption of persistent memory.
+
+	  If in doubt, say 'Y'.
+
 config DEV_PAGEMAP_OPS
 	bool
 
diff --git a/mm/memremap.c b/mm/memremap.c
index fbfc79fd9c24..edad2aa0bd24 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -6,12 +6,16 @@
 #include <linux/memory_hotplug.h>
 #include <linux/mm.h>
 #include <linux/pfn_t.h>
+#include <linux/pkeys.h>
 #include <linux/swap.h>
 #include <linux/mmzone.h>
 #include <linux/swapops.h>
 #include <linux/types.h>
 #include <linux/wait_bit.h>
 #include <linux/xarray.h>
+#include <uapi/asm-generic/mman-common.h>
+
+#define PKEY_INVALID (INT_MIN)
 
 static DEFINE_XARRAY(pgmap_array);
 
@@ -67,6 +71,89 @@ static void devmap_managed_enable_put(void)
 }
 #endif /* CONFIG_DEV_PAGEMAP_OPS */
 
+#ifdef CONFIG_ZONE_DEVICE_ACCESS_PROTECTION
+/*
+ * Note; all devices which have asked for protections share the same key.  The
+ * key may, or may not, have been provided by the core.  If not, protection
+ * will remain disabled.  The key acquisition is attempted at init time and
+ * never again.  So we don't have to worry about dev_page_pkey changing.
+ */
+static int dev_page_pkey = PKEY_INVALID;
+DEFINE_STATIC_KEY_FALSE(dev_protection_static_key);
+EXPORT_SYMBOL(dev_protection_static_key);
+
+static pgprot_t dev_pgprot_get(struct dev_pagemap *pgmap, pgprot_t prot)
+{
+	if (pgmap->flags & PGMAP_PROT_ENABLED && dev_page_pkey != PKEY_INVALID) {
+		pgprotval_t val = pgprot_val(prot);
+
+		static_branch_inc(&dev_protection_static_key);
+		prot = __pgprot(val | _PAGE_PKEY(dev_page_pkey));
+	}
+	return prot;
+}
+
+static void dev_pgprot_put(struct dev_pagemap *pgmap)
+{
+	if (pgmap->flags & PGMAP_PROT_ENABLED && dev_page_pkey != PKEY_INVALID)
+		static_branch_dec(&dev_protection_static_key);
+}
+
+void __dev_access_disable(bool global)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	if (!--current->dev_page_access_ref)
+		pks_mknoaccess(dev_page_pkey, global);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(__dev_access_disable);
+
+void __dev_access_enable(bool global)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	/* 0 clears the PKEY_DISABLE_ACCESS bit, allowing access */
+	if (!current->dev_page_access_ref++)
+		pks_mkrdwr(dev_page_pkey, global);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(__dev_access_enable);
+
+/**
+ * dev_access_protection_init: Configure a PKS key domain for device pages
+ *
+ * The domain defaults to the protected state.  Device page mappings should set
+ * the PGMAP_PROT_ENABLED flag when mapping pages.
+ *
+ * Note the pkey is never free'ed.  This is run at init time and we either get
+ * the key or we do not.  We need to do this to maintian a constant key (or
+ * not) as device memory is added or removed.
+ */
+static int __init __dev_access_protection_init(void)
+{
+	int pkey = pks_key_alloc("Device Memory");
+
+	if (pkey < 0)
+		return 0;
+
+	dev_page_pkey = pkey;
+
+	return 0;
+}
+subsys_initcall(__dev_access_protection_init);
+#else
+static pgprot_t dev_pgprot_get(struct dev_pagemap *pgmap, pgprot_t prot)
+{
+	return prot;
+}
+static void dev_pgprot_put(struct dev_pagemap *pgmap)
+{
+}
+#endif /* CONFIG_ZONE_DEVICE_ACCESS_PROTECTION */
+
 static void pgmap_array_delete(struct resource *res)
 {
 	xa_store_range(&pgmap_array, PHYS_PFN(res->start), PHYS_PFN(res->end),
@@ -156,6 +243,7 @@ void memunmap_pages(struct dev_pagemap *pgmap)
 	pgmap_array_delete(res);
 	WARN_ONCE(pgmap->altmap.alloc, "failed to free all reserved pages\n");
 	devmap_managed_enable_put();
+	dev_pgprot_put(pgmap);
 }
 EXPORT_SYMBOL_GPL(memunmap_pages);
 
@@ -191,6 +279,8 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
 	int error, is_ram;
 	bool need_devmap_managed = true;
 
+	params.pgprot = dev_pgprot_get(pgmap, params.pgprot);
+
 	switch (pgmap->type) {
 	case MEMORY_DEVICE_PRIVATE:
 		if (!IS_ENABLED(CONFIG_DEVICE_PRIVATE)) {
-- 
2.28.0.rc0.12.gb6a658bd00c9

