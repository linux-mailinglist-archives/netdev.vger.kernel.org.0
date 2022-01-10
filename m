Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988B8488FC8
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 06:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbiAJF1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 00:27:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:9532 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238731AbiAJF07 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 00:26:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641792418; x=1673328418;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5spvfVY7/awR+3F1s36KHqk46jZB1r0FdwjUDAIkfT4=;
  b=XSuyD3FgsQ53+gOf5SvkKi+re2o5MKHH7jmRga4AgNllhDaT7KfSTi3F
   h+yUGpLGvmNKnWCyOU9r1t6U4rvuGoUs0smH3sEx7TisxhZFShcgE19qa
   oiv5niOS6q8Ow0mezNMUemKAkfnEaIZS9ZyR8oKjIrasMsj8+6nFV8Vtg
   6khPVcaLP7JGUnPXBxyyHJC02uKWljRPub84ZllwhaBbAF4ez8i2A9n8A
   gJgzL8hadTe6+ljiBeKM2d+vTRRocsTkPkoBBupvdfX7XqTkC+Ec9VeGh
   PINte6RAI1zygreAhLfZsx7vXf5ajQbZFOzC0LgTWqz1WFh6afp/gtt54
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="267479519"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="267479519"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 21:26:58 -0800
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="489892304"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.193.73])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 21:26:57 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 4/7] vDPA/ifcvf: implement shared irq handlers for vqs
Date:   Mon, 10 Jan 2022 13:19:44 +0800
Message-Id: <20220110051947.84901-5-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220110051947.84901-1-lingshan.zhu@intel.com>
References: <20220110051947.84901-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It has observed that a device may fail to alloc enough vectors on
some platforms, e.g., requires 16 vectors, but only 2 or 4 vector
slots allocated. The virt queues have to share a vector/irq under
such circumstances.

This irq handlers has to kick every queue because it is not
possible to tell which queue triggers the interrupt.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 64fc78eaa1a9..19e1d1cd71a3 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -37,6 +37,21 @@ static irqreturn_t ifcvf_intr_handler(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t ifcvf_shared_intr_handler(int irq, void *arg)
+{
+	struct ifcvf_hw *vf = arg;
+	struct vring_info *vring;
+	int i;
+
+	for (i = 0; i < vf->nr_vring; i++) {
+		vring = &vf->vring[i];
+		if (vring->cb.callback)
+			vf->vring->cb.callback(vring->cb.private);
+	}
+
+	return IRQ_HANDLED;
+}
+
 static void ifcvf_free_irq_vectors(void *data)
 {
 	pci_free_irq_vectors(data);
-- 
2.27.0

