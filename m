Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4783E1FBE
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 02:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242895AbhHFAKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 20:10:32 -0400
Received: from mga04.intel.com ([192.55.52.120]:45292 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242777AbhHFAKX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 20:10:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10067"; a="212422379"
X-IronPort-AV: E=Sophos;i="5.84,299,1620716400"; 
   d="scan'208";a="212422379"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2021 17:10:08 -0700
X-IronPort-AV: E=Sophos;i="5.84,299,1620716400"; 
   d="scan'208";a="420562732"
Received: from rmgular-mobl2.amr.corp.intel.com (HELO skuppusw-desk1.amr.corp.intel.com) ([10.251.138.25])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2021 17:10:07 -0700
From:   Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Peter H Anvin <hpa@zytor.com>, Dave Hansen <dave.hansen@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v4 5/7] x86/tdx: Add TDX Guest event notify interrupt vector support
Date:   Thu,  5 Aug 2021 17:09:43 -0700
Message-Id: <20210806000946.2951441-6-sathyanarayanan.kuppuswamy@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210806000946.2951441-1-sathyanarayanan.kuppuswamy@linux.intel.com>
References: <20210806000946.2951441-1-sathyanarayanan.kuppuswamy@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allocate 0xec IRQ vector address for TDX guest to receive the event
completion notification from VMM. Since this vector address will be
sent to VMM via hypercall, allocate a fixed address and move
LOCAL_TIMER_VECTOR vector address by 1 byte. Also add related IDT
handler to process the notification event.

It will be mainly used by attestation driver to receive Quote event
completion notification from host.

Add support to track the notification event status via /proc/interrupts.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
---

Changes since v3:
 * None

 arch/x86/include/asm/hardirq.h     |  1 +
 arch/x86/include/asm/idtentry.h    |  4 +++
 arch/x86/include/asm/irq_vectors.h |  7 ++++-
 arch/x86/include/asm/tdx.h         |  2 ++
 arch/x86/kernel/irq.c              |  7 +++++
 arch/x86/kernel/tdx.c              | 41 ++++++++++++++++++++++++++++++
 6 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 07d79fa9c5c6..40d0534e7d82 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -46,6 +46,7 @@ typedef struct {
 #endif
 #if IS_ENABLED(CONFIG_INTEL_TDX_GUEST)
 	unsigned int tdg_ve_count;
+	unsigned int irq_tdg_event_notify_count;
 #endif
 } ____cacheline_aligned irq_cpustat_t;
 
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 8ccc81d653b3..6f3472a88e9c 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -693,6 +693,10 @@ DECLARE_IDTENTRY_SYSVEC(HYPERVISOR_CALLBACK_VECTOR,	sysvec_xen_hvm_callback);
 DECLARE_IDTENTRY_SYSVEC(HYPERVISOR_CALLBACK_VECTOR,	sysvec_kvm_asyncpf_interrupt);
 #endif
 
+#ifdef CONFIG_INTEL_TDX_GUEST
+DECLARE_IDTENTRY_SYSVEC(TDX_GUEST_EVENT_NOTIFY_VECTOR,	sysvec_tdg_event_notify);
+#endif
+
 #undef X86_TRAP_OTHER
 
 #endif
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 43dcb9284208..82ac0c0a34b1 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -104,7 +104,12 @@
 #define HYPERV_STIMER0_VECTOR		0xed
 #endif
 
-#define LOCAL_TIMER_VECTOR		0xec
+#if IS_ENABLED(CONFIG_INTEL_TDX_GUEST)
+/* Vector on which TDX Guest event notification is delivered */
+#define TDX_GUEST_EVENT_NOTIFY_VECTOR	0xec
+#endif
+
+#define LOCAL_TIMER_VECTOR		0xeb
 
 #define NR_VECTORS			 256
 
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 34d14766b3bc..74c930869ee4 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -99,6 +99,8 @@ int tdx_mcall_tdreport(u64 data, u64 reportdata);
 
 int tdx_hcall_get_quote(u64 data);
 
+extern void (*tdg_event_notify_handler)(void);
+
 /*
  * To support I/O port access in decompressor or early kernel init
  * code, since #VE exception handler cannot be used, use paravirt
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 669869bd46ec..a4fe53c8c18f 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -182,11 +182,18 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 			   irq_stats(j)->kvm_posted_intr_wakeup_ipis);
 	seq_puts(p, "  Posted-interrupt wakeup event\n");
 #endif
+
 #if IS_ENABLED(CONFIG_INTEL_TDX_GUEST)
 	seq_printf(p, "%*s: ", prec, "TGV");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->tdg_ve_count);
 	seq_puts(p, "  TDX Guest VE event\n");
+
+	seq_printf(p, "%*s: ", prec, "TGN");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ",
+			   irq_stats(j)->irq_tdg_event_notify_count);
+	seq_puts(p, "  TDX Guest event notification\n");
 #endif
 	return 0;
 }
diff --git a/arch/x86/kernel/tdx.c b/arch/x86/kernel/tdx.c
index 9fca354e014c..1276027daa1c 100644
--- a/arch/x86/kernel/tdx.c
+++ b/arch/x86/kernel/tdx.c
@@ -9,6 +9,11 @@
 
 #include <asm/tdx.h>
 #include <asm/i8259.h>
+#include <asm/apic.h>
+#include <asm/idtentry.h>
+#include <asm/irq_regs.h>
+#include <asm/desc.h>
+#include <asm/idtentry.h>
 #include <asm/vmx.h>
 #include <asm/insn.h>
 #include <asm/insn-eval.h>
@@ -55,6 +60,14 @@ static struct {
 
 unsigned int tdg_disable_prot = -1;
 
+/*
+ * Currently it will be used only by the attestation
+ * driver. So, race condition with read/write operation
+ * is not considered.
+ */
+void (*tdg_event_notify_handler)(void);
+EXPORT_SYMBOL_GPL(tdg_event_notify_handler);
+
 /*
  * Wrapper for standard use of __tdx_hypercall with BUG_ON() check
  * for TDCALL error.
@@ -151,6 +164,28 @@ bool tdg_debug_enabled(void)
 	return td_info.attributes & BIT(0);
 }
 
+/* TDX guest event notification handler */
+DEFINE_IDTENTRY_SYSVEC(sysvec_tdg_event_notify)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	inc_irq_stat(irq_tdg_event_notify_count);
+
+	if (tdg_event_notify_handler)
+		tdg_event_notify_handler();
+
+	/*
+	 * The hypervisor requires that the APIC EOI should be acked.
+	 * If the APIC EOI is not acked, the APIC ISR bit for the
+	 * TDX_GUEST_EVENT_NOTIFY_VECTOR will not be cleared and then it
+	 * will block the interrupt whose vector is lower than
+	 * TDX_GUEST_EVENT_NOTIFY_VECTOR.
+	 */
+	ack_APIC_irq();
+
+	set_irq_regs(old_regs);
+}
+
 /*
  * tdx_mcall_tdreport() - Generate TDREPORT_STRUCT using TDCALL.
  *
@@ -686,5 +721,11 @@ void __init tdx_early_init(void)
 		add_taint(TAINT_CONF_NO_LOCKDOWN, LOCKDEP_STILL_OK);
 	}
 
+	alloc_intr_gate(TDX_GUEST_EVENT_NOTIFY_VECTOR,
+			asm_sysvec_tdg_event_notify);
+
+	if (tdx_hcall_set_notify_intr(TDX_GUEST_EVENT_NOTIFY_VECTOR))
+		pr_warn("Setting event notification interrupt failed\n");
+
 	pr_info("Guest initialized\n");
 }
-- 
2.25.1

