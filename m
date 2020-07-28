Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0F22300C0
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 06:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgG1E20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 00:28:26 -0400
Received: from mga07.intel.com ([134.134.136.100]:1399 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbgG1E2Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 00:28:25 -0400
IronPort-SDR: 2E789vOalghDd5bHevEDaQQfMJdUnlahwDYoHKX5dgkX2Ko3kOpVVkO7hZeRYFK2lVtm6bHYT4
 pdFhS39cptpg==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="215678154"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="215678154"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 21:28:25 -0700
IronPort-SDR: Jqdmku6WntOwZzSyakiBobgqgut2otCDs+LbffnGSTNdChfmmaXXo8H0jvEdux+iqgBvz7Qe5n
 OW62WYX6cBdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="290037195"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by orsmga006.jf.intel.com with ESMTP; 27 Jul 2020 21:28:17 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, alex.williamson@redhat.com, mst@redhat.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, eli@mellanox.com, shahafs@mellanox.com,
        parav@mellanox.com, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 2/6] kvm: detect assigned device via irqbypass manager
Date:   Tue, 28 Jul 2020 12:24:01 +0800
Message-Id: <20200728042405.17579-3-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200728042405.17579-1-lingshan.zhu@intel.com>
References: <20200728042405.17579-1-lingshan.zhu@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vDPA devices has dedicated backed hardware like
passthrough-ed devices. Then it is possible to setup irq
offloading to vCPU for vDPA devices. Thus this patch tries to
manipulated assigned device counters by
kvm_arch_start/end_assignment() in irqbypass manager, so that
assigned devices could be detected in update_pi_irte()

We will increase/decrease the assigned device counter in kvm/x86.
Both vDPA and VFIO would go through this code path.

Only X86 uses these counters and kvm_arch_start/end_assignment(),
so this code path only affect x86 for now.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Suggested-by: Jason Wang <jasowang@redhat.com>
---
 arch/x86/kvm/x86.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 88c593f83b28..76a2e7fd18c7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10630,11 +10630,17 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 {
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(cons, struct kvm_kernel_irqfd, consumer);
+	int ret;
 
 	irqfd->producer = prod;
+	kvm_arch_start_assignment(irqfd->kvm);
+	ret = kvm_x86_ops.update_pi_irte(irqfd->kvm,
+					 prod->irq, irqfd->gsi, 1);
+
+	if (ret)
+		kvm_arch_end_assignment(irqfd->kvm);
 
-	return kvm_x86_ops.update_pi_irte(irqfd->kvm,
-					   prod->irq, irqfd->gsi, 1);
+	return ret;
 }
 
 void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
@@ -10657,6 +10663,8 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	if (ret)
 		printk(KERN_INFO "irq bypass consumer (token %p) unregistration"
 		       " fails: %d\n", irqfd->consumer.token, ret);
+
+	kvm_arch_end_assignment(irqfd->kvm);
 }
 
 int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
-- 
2.18.4

