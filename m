Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3D93E0265
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 15:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238574AbhHDNtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 09:49:49 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:12446 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238408AbhHDNtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 09:49:31 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GftKz1z7bzckq3;
        Wed,  4 Aug 2021 21:45:43 +0800 (CST)
Received: from SZX1000464847.huawei.com (10.21.59.169) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 4 Aug 2021 21:49:17 +0800
From:   Dongdong Liu <liudongdong3@huawei.com>
To:     <helgaas@kernel.org>, <hch@infradead.org>, <kw@linux.com>,
        <logang@deltatee.com>, <leon@kernel.org>,
        <linux-pci@vger.kernel.org>, <rajur@chelsio.com>,
        <hverkuil-cisco@xs4all.nl>
CC:     <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH V7 9/9] PCI/P2PDMA: Add a 10-Bit Tag check in P2PDMA
Date:   Wed, 4 Aug 2021 21:47:08 +0800
Message-ID: <1628084828-119542-10-git-send-email-liudongdong3@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1628084828-119542-1-git-send-email-liudongdong3@huawei.com>
References: <1628084828-119542-1-git-send-email-liudongdong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.21.59.169]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a 10-Bit Tag check in the P2PDMA code to ensure that a device with
10-Bit Tag Requester doesn't interact with a device that does not
support 10-BIT Tag Completer. Before that happens, the kernel should
emit a warning. "echo 0 > /sys/bus/pci/devices/.../10bit_tag" to
disable 10-BIT Tag Requester for PF device.
"echo 0 > /sys/bus/pci/devices/.../sriov_vf_10bit_tag_ctl" to disable
10-BIT Tag Requester for VF device.

Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
---
 drivers/pci/p2pdma.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 50cdde3..948f2be 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -19,6 +19,7 @@
 #include <linux/random.h>
 #include <linux/seq_buf.h>
 #include <linux/xarray.h>
+#include "pci.h"
 
 enum pci_p2pdma_map_type {
 	PCI_P2PDMA_MAP_UNKNOWN = 0,
@@ -410,6 +411,41 @@ static unsigned long map_types_idx(struct pci_dev *client)
 		(client->bus->number << 8) | client->devfn;
 }
 
+static bool check_10bit_tags_vaild(struct pci_dev *a, struct pci_dev *b,
+				   bool verbose)
+{
+	bool req;
+	bool comp;
+	u16 ctl2;
+
+	if (a->is_virtfn) {
+#ifdef CONFIG_PCI_IOV
+		req = !!(a->physfn->sriov->ctrl &
+			 PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN);
+#endif
+	} else {
+		pcie_capability_read_word(a, PCI_EXP_DEVCTL2, &ctl2);
+		req = !!(ctl2 & PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
+	}
+
+	comp = !!(b->pcie_devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_COMP);
+	if (req && (!comp)) {
+		if (verbose) {
+			pci_warn(a, "cannot be used for peer-to-peer DMA as 10-Bit Tag Requester enable is set in device (%s), but peer device (%s) does not support the 10-Bit Tag Completer\n",
+				 pci_name(a), pci_name(b));
+			if (a->is_virtfn)
+				pci_warn(a, "to disable 10-Bit Tag Requester for this device, echo 0 > /sys/bus/pci/devices/%s/sriov_vf_10bit_tag_ctl\n",
+					 pci_name(a));
+			else
+				pci_warn(a, "to disable 10-Bit Tag Requester for this device, echo 0 > /sys/bus/pci/devices/%s/10bit_tag\n",
+					 pci_name(a));
+		}
+		return false;
+	}
+
+	return true;
+}
+
 /*
  * Calculate the P2PDMA mapping type and distance between two PCI devices.
  *
@@ -532,6 +568,10 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
 	}
 done:
+	if (!check_10bit_tags_vaild(client, provider, verbose) ||
+	    !check_10bit_tags_vaild(provider, client, verbose))
+		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
+
 	rcu_read_lock();
 	p2pdma = rcu_dereference(provider->p2pdma);
 	if (p2pdma)
-- 
2.7.4

