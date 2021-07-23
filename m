Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24ED3D3928
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 13:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234444AbhGWK2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 06:28:11 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:15053 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232609AbhGWK1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 06:27:53 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GWRL52RXbzZrYC;
        Fri, 23 Jul 2021 19:05:01 +0800 (CST)
Received: from SZX1000464847.huawei.com (10.21.59.169) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 23 Jul 2021 19:08:25 +0800
From:   Dongdong Liu <liudongdong3@huawei.com>
To:     <helgaas@kernel.org>, <hch@infradead.org>, <kw@linux.com>,
        <logang@deltatee.com>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>
CC:     <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH V6 8/8]  PCI/P2PDMA: Add a 10-bit tag check in P2PDMA
Date:   Fri, 23 Jul 2021 19:06:42 +0800
Message-ID: <1627038402-114183-9-git-send-email-liudongdong3@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1627038402-114183-1-git-send-email-liudongdong3@huawei.com>
References: <1627038402-114183-1-git-send-email-liudongdong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.21.59.169]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a 10-Bit Tag check in the P2PDMA code to ensure that a device with
10-Bit Tag Requester doesn't interact with a device that does not
support 10-BIT tag Completer. Before that happens, the kernel should
emit a warning saying to enable a ”pci=disable_10bit_tag=“ kernel
parameter.

Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
---
 drivers/pci/p2pdma.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 50cdde3..bd93840 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -19,6 +19,7 @@
 #include <linux/random.h>
 #include <linux/seq_buf.h>
 #include <linux/xarray.h>
+#include "pci.h"
 
 enum pci_p2pdma_map_type {
 	PCI_P2PDMA_MAP_UNKNOWN = 0,
@@ -541,6 +542,39 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
 	return map_type;
 }
 
+
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
+
+			pci_warn(a, "to disable 10-Bit Tag Requester for this device, add the kernel parameter: pci=disable_10bit_tag=%s\n",
+				 pci_name(a));
+		}
+		return false;
+	}
+
+	return true;
+}
+
 /**
  * pci_p2pdma_distance_many - Determine the cumulative distance between
  *	a p2pdma provider and the clients in use.
@@ -579,6 +613,10 @@ int pci_p2pdma_distance_many(struct pci_dev *provider, struct device **clients,
 			return -1;
 		}
 
+		if (!check_10bit_tags_vaild(pci_client, provider, verbose) ||
+		    !check_10bit_tags_vaild(provider, pci_client, verbose))
+			not_supported = true;
+
 		map = calc_map_type_and_dist(provider, pci_client, &distance,
 					     verbose);
 
-- 
2.7.4

