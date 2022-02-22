Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17E04C0537
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 00:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236216AbiBVXSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 18:18:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236205AbiBVXS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 18:18:29 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4222690FFC;
        Tue, 22 Feb 2022 15:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645571883; x=1677107883;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WqslslAFPFPcE+soxU4YWA3jCYCC0Y+ExtfYYoE+ji4=;
  b=gRiNpFmNcP4bIqSeZ8asE3oTDK+NvhzdUo0TcQXsLjxZOoy58d5tBnZm
   l2+tVfD98dMNMjG9P2Nvrs3xigYO4ef7zWHbuEQhvageSz2jrfO1/rwZG
   TMXjL2Oc78NcqlwqIAkgl8QApLLHI7P9cqpgalyr2agyUDNHYUeyl8uB2
   0ghmif+AxjdW4gGRRM/P/iO9JAtOS9FDLEaP5Sixb64FOv5buJTA0JtJv
   Oxw28rWU1gBECGSd9ky2vh6zizicyzSdZiDVGTX+UWRa/1uFuTNDTXDUP
   BfoLE4yDzEfuR0egkaV0JoFzHVHMJFaWzXiqIGBRMeTJelH3plyt3H9BG
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="231810100"
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; 
   d="scan'208";a="231810100"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 15:18:03 -0800
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; 
   d="scan'208";a="776476649"
Received: from skoppolu-mobl4.amr.corp.intel.com (HELO skuppusw-desk1.amr.corp.intel.com) ([10.252.138.103])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 15:18:02 -0800
From:   Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     "H . Peter Anvin" <hpa@zytor.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH v1 5/6] x86/tdx: Add TDX Guest event notify interrupt vector support
Date:   Tue, 22 Feb 2022 15:17:34 -0800
Message-Id: <20220222231735.268919-6-sathyanarayanan.kuppuswamy@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220222231735.268919-1-sathyanarayanan.kuppuswamy@linux.intel.com>
References: <20220222231735.268919-1-sathyanarayanan.kuppuswamy@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 arch/x86/coco/tdx.c                | 40 ++++++++++++++++++++++++++++++
 arch/x86/include/asm/hardirq.h     |  4 +++
 arch/x86/include/asm/idtentry.h    |  4 +++
 arch/x86/include/asm/irq_vectors.h |  7 +++++-
 arch/x86/include/asm/tdx.h         |  1 +
 arch/x86/kernel/irq.c              |  7 ++++++
 6 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/arch/x86/coco/tdx.c b/arch/x86/coco/tdx.c
index d18508e6150f..a6bf93d943f5 100644
--- a/arch/x86/coco/tdx.c
+++ b/arch/x86/coco/tdx.c
@@ -12,6 +12,10 @@
 #include <asm/insn.h>
 #include <asm/insn-eval.h>
 #include <asm/x86_init.h>
+#include <asm/apic.h>
+#include <asm/idtentry.h>
+#include <asm/irq_regs.h>
+#include <asm/desc.h>
 
 /* TDX module Call Leaf IDs */
 #define TDX_GET_INFO			1
@@ -49,6 +53,14 @@ static struct {
 	unsigned long attributes;
 } td_info __ro_after_init;
 
+/*
+ * Currently it will be used only by the attestation
+ * driver. So, race condition with read/write operation
+ * is not considered.
+ */
+void (*tdx_event_notify_handler)(void);
+EXPORT_SYMBOL_GPL(tdx_event_notify_handler);
+
 /*
  * Wrapper for standard use of __tdx_hypercall with no output aside from
  * return code.
@@ -91,6 +103,28 @@ static inline void tdx_module_call(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
 		panic("TDCALL %lld failed (Buggy TDX module!)\n", fn);
 }
 
+/* TDX guest event notification handler */
+DEFINE_IDTENTRY_SYSVEC(sysvec_tdx_event_notify)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	inc_irq_stat(irq_tdx_event_notify_count);
+
+	if (tdx_event_notify_handler)
+		tdx_event_notify_handler();
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
@@ -727,5 +761,11 @@ void __init tdx_early_init(void)
 
 	swiotlb_force = SWIOTLB_FORCE;
 
+	alloc_intr_gate(TDX_GUEST_EVENT_NOTIFY_VECTOR,
+			asm_sysvec_tdx_event_notify);
+
+	if (tdx_hcall_set_notify_intr(TDX_GUEST_EVENT_NOTIFY_VECTOR))
+		pr_warn("Setting event notification interrupt failed\n");
+
 	pr_info("Guest detected\n");
 }
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 275e7fd20310..3955b81f9241 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -44,6 +44,10 @@ typedef struct {
 	unsigned int irq_hv_reenlightenment_count;
 	unsigned int hyperv_stimer0_count;
 #endif
+#if IS_ENABLED(CONFIG_INTEL_TDX_GUEST)
+	unsigned int tdx_ve_count;
+	unsigned int irq_tdx_event_notify_count;
+#endif
 } ____cacheline_aligned irq_cpustat_t;
 
 DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 8ccc81d653b3..8ca55780df20 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -693,6 +693,10 @@ DECLARE_IDTENTRY_SYSVEC(HYPERVISOR_CALLBACK_VECTOR,	sysvec_xen_hvm_callback);
 DECLARE_IDTENTRY_SYSVEC(HYPERVISOR_CALLBACK_VECTOR,	sysvec_kvm_asyncpf_interrupt);
 #endif
 
+#ifdef CONFIG_INTEL_TDX_GUEST
+DECLARE_IDTENTRY_SYSVEC(TDX_GUEST_EVENT_NOTIFY_VECTOR,	sysvec_tdx_event_notify);
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
index e93ca229d512..b1eac9bcf808 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -62,6 +62,7 @@ int tdx_mcall_tdreport(void *data, void *reportdata);
 
 int tdx_hcall_get_quote(void *data);
 
+extern void (*tdx_event_notify_handler)(void);
 #else
 
 static inline void tdx_early_init(void) { };
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 766ffe3ba313..a96ecd866723 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -181,6 +181,13 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 		seq_printf(p, "%10u ",
 			   irq_stats(j)->kvm_posted_intr_wakeup_ipis);
 	seq_puts(p, "  Posted-interrupt wakeup event\n");
+#endif
+#if IS_ENABLED(CONFIG_INTEL_TDX_GUEST)
+	seq_printf(p, "%*s: ", prec, "TGN");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ",
+			   irq_stats(j)->irq_tdx_event_notify_count);
+	seq_puts(p, "  TDX Guest event notification\n");
 #endif
 	return 0;
 }
-- 
2.25.1

