Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E73D222160
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 13:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbgGPL1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 07:27:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:52585 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728225AbgGPL1t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 07:27:49 -0400
IronPort-SDR: B5KKWNzh1e3B1P8b8cYX77tSzk+/qFBIEKyoDUR+/tSTfDiwxoYP7FkhnPTHAmw+dA7/4NNytx
 AyPvBfLE03LQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="137485051"
X-IronPort-AV: E=Sophos;i="5.75,359,1589266800"; 
   d="scan'208";a="137485051"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 04:27:48 -0700
IronPort-SDR: pRb2f+04z5d1Ghfv9h1f6jeNhodx7VGBpRf4s24Dw0W6LoWdJ9GbitnBmFqifSoG369by4u7Li
 peATnpfJW6wA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,359,1589266800"; 
   d="scan'208";a="460442817"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by orsmga005.jf.intel.com with ESMTP; 16 Jul 2020 04:27:46 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jasowang@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 2/6] kvm: detect assigned device via irqbypass manager
Date:   Thu, 16 Jul 2020 19:23:45 +0800
Message-Id: <1594898629-18790-3-git-send-email-lingshan.zhu@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594898629-18790-1-git-send-email-lingshan.zhu@intel.com>
References: <1594898629-18790-1-git-send-email-lingshan.zhu@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vDPA devices has dedicated backed hardware like
passthrough-ed devices. Then it is possible to setup irq
offloading to vCPU for vDPA devices. Thus this patch tries to
manipulated assigned device counters via irqbypass manager.

We will increase/decrease the assigned device counter in kvm/x86.
Both vDPA and VFIO would go through this code path.

This code path only affect x86 for now.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Suggested-by: Jason Wang <jasowang@redhat.com>
---
 arch/x86/kvm/x86.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 00c88c2..20c07d3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10624,11 +10624,17 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
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
-- 
1.8.3.1

