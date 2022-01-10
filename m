Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D1F488FC1
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 06:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238724AbiAJF0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 00:26:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:9493 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238713AbiAJF0C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 00:26:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641792362; x=1673328362;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5spvfVY7/awR+3F1s36KHqk46jZB1r0FdwjUDAIkfT4=;
  b=ToawxGRYS7xVrljPNBkdryk3uoGkbyGPy0nmxuwxEPAr18eWUYbvzhv2
   WgtgJGs+NXFA/Nhz53f1ebcKuNxSHWOqe3EnQm6trb1S5ipYaTGtzHNqx
   xLvbQQ5P9B0b3Q8ZxTh+0S2kmv6HRZpnkEy+NuI2fQlCac9SETpKxUpJL
   TGWth0RFGec3vV8Eenq159MqPIXbHRBP6vwexzBdAbReZKk9vxusEgDT9
   2N2DgjsYWQfZDuHSVUYoKhsd6tYa6U3gi7a48VTZSFqB9RlhK80dFZWkY
   mGAPB74pUKtiTe/6CQo1UDqr7OAZYF2Bf52lJkJKGI4Ft91THLyVc4KGR
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="267479405"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="267479405"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 21:26:02 -0800
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="622559796"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.193.73])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 21:26:00 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     netdev@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 4/7] vDPA/ifcvf: implement shared irq handlers for vqs
Date:   Mon, 10 Jan 2022 13:18:48 +0800
Message-Id: <20220110051851.84807-5-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220110051851.84807-1-lingshan.zhu@intel.com>
References: <20220110051851.84807-1-lingshan.zhu@intel.com>
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

