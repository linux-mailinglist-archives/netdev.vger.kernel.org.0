Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D914176AA5
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 03:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgCCCZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:25:19 -0500
Received: from mga14.intel.com ([192.55.52.115]:54186 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727041AbgCCCZI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:25:08 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 18:25:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="233605686"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga008.fm.intel.com with ESMTP; 02 Mar 2020 18:25:07 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH v2 1/6] PCI: Introduce pci_get_dsn
Date:   Mon,  2 Mar 2020 18:25:00 -0800
Message-Id: <20200303022506.1792776-2-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.368.g28a2d05eebfb
In-Reply-To: <20200303022506.1792776-1-jacob.e.keller@intel.com>
References: <CABhMZUXJ_Omt-+fwa4Oz-Ly=J+NM8+8Ryv-Ad1u_bgEpDRH7RQ@mail.gmail.com>
 <20200303022506.1792776-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several device drivers read their Device Serial Number from the PCIe
extended config space.

Introduce a new helper function, pci_get_dsn(). This function reads the
eight bytes of the DSN and returns them as a u64. If the capability does not
exist for the device, the function returns 0.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Michael Chan <michael.chan@broadcom.com>
---
 drivers/pci/pci.c   | 34 ++++++++++++++++++++++++++++++++++
 include/linux/pci.h |  5 +++++
 2 files changed, 39 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d828ca835a98..03f50e706c0d 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -557,6 +557,40 @@ int pci_find_ext_capability(struct pci_dev *dev, int cap)
 }
 EXPORT_SYMBOL_GPL(pci_find_ext_capability);
 
+/**
+ * pci_get_dsn - Read and return the 8-byte Device Serial Number
+ * @dev: PCI device to query
+ *
+ * Looks up the PCI_EXT_CAP_ID_DSN and reads the 8 bytes of the Device Serial
+ * Number.
+ *
+ * Returns the DSN, or zero if the capability does not exist.
+ */
+u64 pci_get_dsn(struct pci_dev *dev)
+{
+	u32 dword;
+	u64 dsn;
+	int pos;
+
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_DSN);
+	if (!pos)
+		return 0;
+
+	/*
+	 * The Device Serial Number is two dwords offset 4 bytes from the
+	 * capability position. The specification says that the first dword is
+	 * the lower half, and the second dword is the upper half.
+	 */
+	pos += 4;
+	pci_read_config_dword(dev, pos, &dword);
+	dsn = (u64)dword;
+	pci_read_config_dword(dev, pos + 4, &dword);
+	dsn |= ((u64)dword) << 32;
+
+	return dsn;
+}
+EXPORT_SYMBOL_GPL(pci_get_dsn);
+
 static int __pci_find_next_ht_cap(struct pci_dev *dev, int pos, int ht_cap)
 {
 	int rc, ttl = PCI_FIND_CAP_TTL;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 3840a541a9de..d92cf2da1ae1 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1045,6 +1045,8 @@ int pci_find_ht_capability(struct pci_dev *dev, int ht_cap);
 int pci_find_next_ht_capability(struct pci_dev *dev, int pos, int ht_cap);
 struct pci_bus *pci_find_next_bus(const struct pci_bus *from);
 
+u64 pci_get_dsn(struct pci_dev *dev);
+
 struct pci_dev *pci_get_device(unsigned int vendor, unsigned int device,
 			       struct pci_dev *from);
 struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
@@ -1699,6 +1701,9 @@ static inline int pci_find_next_capability(struct pci_dev *dev, u8 post,
 static inline int pci_find_ext_capability(struct pci_dev *dev, int cap)
 { return 0; }
 
+static inline u64 pci_get_dsn(struct pci_dev *dev)
+{ return 0; }
+
 /* Power management related routines */
 static inline int pci_save_state(struct pci_dev *dev) { return 0; }
 static inline void pci_restore_state(struct pci_dev *dev) { }
-- 
2.25.0.368.g28a2d05eebfb

