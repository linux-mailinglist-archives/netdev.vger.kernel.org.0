Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C0A23F45D
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 23:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgHGVa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 17:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727807AbgHGV3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 17:29:48 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64EBC061D7C
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 14:29:45 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id e30so2796700pfj.0
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 14:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1TZQegrBgPNN+SZZCsJyOP7eFX7H3/9/2zydOordKRU=;
        b=ieZHYo04XCdbBogCHiXjbZeFR1bV303kMQGvEtUCo3MyCZv4PiQWUZOtUp5UOdsJms
         OBTC87r+1D0ws9FbjFeU+TDngcJIVQp/zIa7cOyLrT+Kfwkksir2bzMZMZM71wB478Ek
         KoeuqdI4fr1vD4oXtX+BT3zcMk4kACaAfsSllWPfE1XV9+yGzGNku5ufgoJtirVr8ZaS
         pKG4jrzoRlV6GzhJsAabu9U1sMqMRLkG8XujccP5ELANmH4hQZEIMJBKDEnHRH+KpJy8
         hSiEyisrJRZ8PcdacCUH3tpzWxbzlRwGl7dvUMXeAkWcUTPXKhKYFM0reJax5bPpfGFV
         iRkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1TZQegrBgPNN+SZZCsJyOP7eFX7H3/9/2zydOordKRU=;
        b=KqIWekkOsO/Fw9H44f3Zn2tox6WGpN25vnSAXRAzYaLYXDW4eB9ro72BgY5DX1JCVR
         VyhStQcTyz7BcZL2MSv8DQ0/yaiUwXfvGi54QWQzfeRnR4xc6YYTYHn+juJPkp/fhb69
         1r48nCunxQLMnlZpRzdR6jIBjs7lOSX7zBKFCVR6nfvaUORLiObU8PRiCmf5psdbWnSt
         hLWAw2yiqtKlMUOXRlhJOvuM5Vp0+KFFNTnhN2gnbfJnlJzlURKiODOHJmetOXbmUmqt
         liE1Nb5rph87Cvo86FlRNFeQMZArIj1dhnHk2jRbTw/yCl9esaKfZWlUTpKxPpyXD4zX
         zrVw==
X-Gm-Message-State: AOAM532P1JMzTFNZzHitL1Aq4U7zoN0+SmVjwHKKMvrWq9i2dr72oew2
        9tL+N8fEijoO0tRTsHyq9ZEYIRsFz3E=
X-Google-Smtp-Source: ABdhPJz+2C/PgoKritkxy8QCsvDLemjrofpIEPFwkhIfTB+Eqa7wlcLaV2OWCQg+F4nEAB7Hu1Xv9XgPH0tp
X-Received: by 2002:a17:90b:1254:: with SMTP id gx20mr16269548pjb.117.1596835785342;
 Fri, 07 Aug 2020 14:29:45 -0700 (PDT)
Date:   Fri,  7 Aug 2020 14:29:15 -0700
In-Reply-To: <20200807212916.2883031-1-jwadams@google.com>
Message-Id: <20200807212916.2883031-7-jwadams@google.com>
Mime-Version: 1.0
References: <20200807212916.2883031-1-jwadams@google.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [RFC PATCH 6/7] core/metricfs: expose x86-specific irq information
 through metricfs
From:   Jonathan Adams <jwadams@google.com>
To:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        Jonathan Adams <jwadams@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add metricfs support for displaying percpu irq counters for x86.
The top directory is /sys/kernel/debug/metricfs/irq_x86.
Then there is a subdirectory for each x86-specific irq counter.
For example:

    cat /sys/kernel/debug/metricfs/irq_x86/TLB/values

Signed-off-by: Jonathan Adams <jwadams@google.com>

---

jwadams@google.com: rebased to 5.8-pre6
	This is work originally done by another engineer at
	google, who would rather not have their name associated with
	this patchset. They're okay with me sending it under my name.
---
 arch/x86/kernel/irq.c | 80 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 181060247e3c..ffacbbc4066c 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -12,6 +12,7 @@
 #include <linux/delay.h>
 #include <linux/export.h>
 #include <linux/irq.h>
+#include <linux/metricfs.h>
 
 #include <asm/irq_stack.h>
 #include <asm/apic.h>
@@ -374,3 +375,82 @@ void fixup_irqs(void)
 	}
 }
 #endif
+
+#ifdef CONFIG_METRICFS
+#define METRICFS_ITEM(name, field, desc) \
+static void \
+metricfs_##name(struct metric_emitter *e, int cpu) \
+{ \
+	int64_t v = irq_stats(cpu)->field; \
+	METRIC_EMIT_PERCPU_INT(e, cpu, v); \
+} \
+METRIC_EXPORT_PERCPU_COUNTER(name, desc, metricfs_##name)
+
+METRICFS_ITEM(NMI, __nmi_count, "Non-maskable interrupts");
+#ifdef CONFIG_X86_LOCAL_APIC
+METRICFS_ITEM(LOC, apic_timer_irqs, "Local timer interrupts");
+METRICFS_ITEM(SPU, irq_spurious_count, "Spurious interrupts");
+METRICFS_ITEM(PMI, apic_perf_irqs, "Performance monitoring interrupts");
+METRICFS_ITEM(IWI, apic_irq_work_irqs, "IRQ work interrupts");
+METRICFS_ITEM(RTR, icr_read_retry_count, "APIC ICR read retries");
+#endif
+METRICFS_ITEM(PLT, x86_platform_ipis, "Platform interrupts");
+#ifdef CONFIG_SMP
+METRICFS_ITEM(RES, irq_resched_count, "Rescheduling interrupts");
+METRICFS_ITEM(CAL, irq_call_count, "Function call interrupts");
+METRICFS_ITEM(TLB, irq_tlb_count, "TLB shootdowns");
+#endif
+#ifdef CONFIG_X86_THERMAL_VECTOR
+METRICFS_ITEM(TRM, irq_thermal_count, "Thermal event interrupts");
+#endif
+#ifdef CONFIG_X86_MCE_THRESHOLD
+METRICFS_ITEM(THR, irq_threshold_count, "Threshold APIC interrupts");
+#endif
+#ifdef CONFIG_X86_MCE_AMD
+METRICFS_ITEM(DFR, irq_deferred_error_count, "Deferred Error APIC interrupts");
+#endif
+#ifdef CONFIG_HAVE_KVM
+METRICFS_ITEM(PIN, kvm_posted_intr_ipis, "Posted-interrupt notification event");
+METRICFS_ITEM(PIW, kvm_posted_intr_wakeup_ipis,
+	"Posted-interrupt wakeup event");
+#endif
+
+static int __init init_irq_metricfs(void)
+{
+	struct metricfs_subsys *subsys;
+
+	subsys = metricfs_create_subsys("irq_x86", NULL);
+
+	metric_init_NMI(subsys);
+#ifdef CONFIG_X86_LOCAL_APIC
+	metric_init_LOC(subsys);
+	metric_init_SPU(subsys);
+	metric_init_PMI(subsys);
+	metric_init_IWI(subsys);
+	metric_init_RTR(subsys);
+#endif
+	metric_init_PLT(subsys);
+#ifdef CONFIG_SMP
+	metric_init_RES(subsys);
+	metric_init_CAL(subsys);
+	metric_init_TLB(subsys);
+#endif
+#ifdef CONFIG_X86_THERMAL_VECTOR
+	metric_init_TRM(subsys);
+#endif
+#ifdef CONFIG_X86_MCE_THRESHOLD
+	metric_init_THR(subsys);
+#endif
+#ifdef CONFIG_X86_MCE_AMD
+	metric_init_DFR(subsys);
+#endif
+#ifdef CONFIG_HAVE_KVM
+	metric_init_PIN(subsys);
+	metric_init_PIW(subsys);
+#endif
+
+	return 0;
+}
+module_init(init_irq_metricfs);
+
+#endif
-- 
2.28.0.236.gb10cc79966-goog

