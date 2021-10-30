Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F788440942
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 15:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhJ3OAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 10:00:07 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:15319 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhJ3OAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 10:00:04 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HhLTK5kfJz90PN;
        Sat, 30 Oct 2021 21:57:25 +0800 (CST)
Received: from SZX1000464847.huawei.com (10.21.59.169) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.15; Sat, 30 Oct 2021 21:57:31 +0800
From:   Dongdong Liu <liudongdong3@huawei.com>
To:     <helgaas@kernel.org>, <hch@infradead.org>, <kw@linux.com>,
        <logang@deltatee.com>, <leon@kernel.org>,
        <linux-pci@vger.kernel.org>, <rajur@chelsio.com>,
        <hverkuil-cisco@xs4all.nl>
CC:     <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH V11 6/8] PCI/P2PDMA: Add a 10-Bit Tag check in P2PDMA
Date:   Sat, 30 Oct 2021 21:53:46 +0800
Message-ID: <20211030135348.61364-7-liudongdong3@huawei.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20211030135348.61364-1-liudongdong3@huawei.com>
References: <20211030135348.61364-1-liudongdong3@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.21.59.169]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The P2PDMA mapping should fail if a device with 10-Bit Tag Requester
interact with a device that does not support 10-Bit Tag Completer.

Add a 10-Bit Tag check in the P2PDMA code to ensure that a device with
10-Bit Tag Requester doesn't interact with a device that does not
support 10-Bit Tag Completer. Before that happens, the kernel should
emit a warning.

"echo 0 > /sys/bus/pci/devices/.../tags" to disable 10-Bit Tag
Requester for PF device.

"echo 0 > /sys/bus/pci/devices/.../sriov_vf_tags_ctl" to disable
10-Bit Tag Requester for VF device.

Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/pci/p2pdma.c | 48 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 50cdde3e9a8b..1565a31183af 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -19,6 +19,7 @@
 #include <linux/random.h>
 #include <linux/seq_buf.h>
 #include <linux/xarray.h>
+#include "pci.h"
 
 enum pci_p2pdma_map_type {
 	PCI_P2PDMA_MAP_UNKNOWN = 0,
@@ -410,6 +411,50 @@ static unsigned long map_types_idx(struct pci_dev *client)
 		(client->bus->number << 8) | client->devfn;
 }
 
+static bool pci_10bit_tags_unsupported(struct pci_dev *a,
+				       struct pci_dev *b,
+				       bool verbose)
+{
+	bool req;
+	bool comp;
+	u16 ctl;
+	const char *str = "tags";
+
+	if (a->is_virtfn) {
+#ifdef CONFIG_PCI_IOV
+		req = !!(a->physfn->sriov->ctrl &
+			 PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN);
+#endif
+	} else {
+		pcie_capability_read_word(a, PCI_EXP_DEVCTL2, &ctl);
+		req = !!(ctl & PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
+	}
+
+	comp = !!(b->devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_COMP);
+
+	/* 10-bit tags not enabled on requester */
+	if (!req)
+		return false;
+
+	 /* Completer can handle anything */
+	if (comp)
+		return false;
+
+	if (!verbose)
+		return true;
+
+	pci_warn(a, "cannot be used for peer-to-peer DMA as 10-Bit Tag Requester enable is set for this device, but peer device (%s) does not support the 10-Bit Tag Completer\n",
+		 pci_name(b));
+
+	if (a->is_virtfn)
+		str = "sriov_vf_tags_ctl";
+
+	pci_warn(a, "to disable 10-Bit Tag Requester for this device, echo 0 > /sys/bus/pci/devices/%s/%s\n",
+		 pci_name(a), str);
+
+	return true;
+}
+
 /*
  * Calculate the P2PDMA mapping type and distance between two PCI devices.
  *
@@ -532,6 +577,9 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
 	}
 done:
+	if (pci_10bit_tags_unsupported(client, provider, verbose))
+		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
+
 	rcu_read_lock();
 	p2pdma = rcu_dereference(provider->p2pdma);
 	if (p2pdma)
-- 
2.22.0

