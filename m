Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC8DF172B85
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 23:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730468AbgB0Wgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 17:36:53 -0500
Received: from mga18.intel.com ([134.134.136.126]:49955 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730279AbgB0Wgm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 17:36:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Feb 2020 14:36:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,493,1574150400"; 
   d="scan'208";a="238568408"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by orsmga003.jf.intel.com with ESMTP; 27 Feb 2020 14:36:42 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     linux-pci@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        QLogic-Storage-Upstream@cavium.com,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH 1/5] pci: introduce pci_get_dsn
Date:   Thu, 27 Feb 2020 14:36:31 -0800
Message-Id: <20200227223635.1021197-3-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.368.g28a2d05eebfb
In-Reply-To: <20200227223635.1021197-1-jacob.e.keller@intel.com>
References: <20200227223635.1021197-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several device drivers read their Device Serial Number from the PCIe
extended config space.

Introduce a new helper function, pci_get_dsn, which will read the
eight bytes of the DSN into the provided buffer.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: QLogic-Storage-Upstream@cavium.com
Cc: Michael Chan <michael.chan@broadcom.com>
---
 drivers/pci/pci.c   | 33 +++++++++++++++++++++++++++++++++
 include/linux/pci.h |  5 +++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d828ca835a98..12d8101724d7 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -33,6 +33,7 @@
 #include <linux/pci-ats.h>
 #include <asm/setup.h>
 #include <asm/dma.h>
+#include <asm/unaligned.h>
 #include <linux/aer.h>
 #include "pci.h"
 
@@ -557,6 +558,38 @@ int pci_find_ext_capability(struct pci_dev *dev, int cap)
 }
 EXPORT_SYMBOL_GPL(pci_find_ext_capability);
 
+/**
+ * pci_get_dsn - Read the 8-byte Device Serial Number
+ * @dev: PCI device to query
+ * @dsn: storage for the DSN. Must be at least 8 bytes
+ *
+ * Looks up the PCI_EXT_CAP_ID_DSN and reads the 8 bytes into the dsn storage.
+ * Returns -EOPNOTSUPP if the device does not have the capability.
+ */
+int pci_get_dsn(struct pci_dev *dev, u8 dsn[])
+{
+	u32 dword;
+	int pos;
+
+
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_DSN);
+	if (!pos)
+		return -EOPNOTSUPP;
+
+	/*
+	 * The Device Serial Number is two dwords offset 4 bytes from the
+	 * capability position.
+	 */
+	pos += 4;
+	pci_read_config_dword(dev, pos, &dword);
+	put_unaligned_le32(dword, &dsn[0]);
+	pci_read_config_dword(dev, pos + 4, &dword);
+	put_unaligned_le32(dword, &dsn[4]);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_get_dsn);
+
 static int __pci_find_next_ht_cap(struct pci_dev *dev, int pos, int ht_cap)
 {
 	int rc, ttl = PCI_FIND_CAP_TTL;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 3840a541a9de..883562323df3 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1045,6 +1045,8 @@ int pci_find_ht_capability(struct pci_dev *dev, int ht_cap);
 int pci_find_next_ht_capability(struct pci_dev *dev, int pos, int ht_cap);
 struct pci_bus *pci_find_next_bus(const struct pci_bus *from);
 
+int pci_get_dsn(struct pci_dev *dev, u8 dsn[]);
+
 struct pci_dev *pci_get_device(unsigned int vendor, unsigned int device,
 			       struct pci_dev *from);
 struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
@@ -1699,6 +1701,9 @@ static inline int pci_find_next_capability(struct pci_dev *dev, u8 post,
 static inline int pci_find_ext_capability(struct pci_dev *dev, int cap)
 { return 0; }
 
+static inline int pci_get_dsn(struct pci_dev *dev, u8 dsn[])
+{ return -EOPNOTSUPP; }
+
 /* Power management related routines */
 static inline int pci_save_state(struct pci_dev *dev) { return 0; }
 static inline void pci_restore_state(struct pci_dev *dev) { }
-- 
2.25.0.368.g28a2d05eebfb

