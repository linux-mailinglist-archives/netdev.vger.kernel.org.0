Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36AAD3F6A8E
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 22:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235722AbhHXUkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 16:40:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:49509 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235258AbhHXUkB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 16:40:01 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="204530932"
X-IronPort-AV: E=Sophos;i="5.84,348,1620716400"; 
   d="scan'208";a="204530932"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 13:39:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,348,1620716400"; 
   d="scan'208";a="526819953"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Aug 2021 13:39:16 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        richardcochran@gmail.com
Subject: [PATCH net-next 2/4] PCI: Add pcie_ptm_enabled()
Date:   Tue, 24 Aug 2021 13:42:46 -0700
Message-Id: <20210824204248.2957134-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210824204248.2957134-1-anthony.l.nguyen@intel.com>
References: <20210824204248.2957134-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Add a predicate that returns if PCIe PTM (Precision Time Measurement)
is enabled.

It will only return true if it's enabled in all the ports in the path
from the device to the root.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/pci/pcie/ptm.c | 9 +++++++++
 include/linux/pci.h    | 3 +++
 2 files changed, 12 insertions(+)

diff --git a/drivers/pci/pcie/ptm.c b/drivers/pci/pcie/ptm.c
index 95d4eef2c9e8..8a4ad974c5ac 100644
--- a/drivers/pci/pcie/ptm.c
+++ b/drivers/pci/pcie/ptm.c
@@ -204,3 +204,12 @@ int pci_enable_ptm(struct pci_dev *dev, u8 *granularity)
 	return 0;
 }
 EXPORT_SYMBOL(pci_enable_ptm);
+
+bool pcie_ptm_enabled(struct pci_dev *dev)
+{
+	if (!dev)
+		return false;
+
+	return dev->ptm_enabled;
+}
+EXPORT_SYMBOL(pcie_ptm_enabled);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 21a9d244e4e4..947430637cac 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1622,9 +1622,12 @@ bool pci_ats_disabled(void);
 
 #ifdef CONFIG_PCIE_PTM
 int pci_enable_ptm(struct pci_dev *dev, u8 *granularity);
+bool pcie_ptm_enabled(struct pci_dev *dev);
 #else
 static inline int pci_enable_ptm(struct pci_dev *dev, u8 *granularity)
 { return -EINVAL; }
+static inline bool pcie_ptm_enabled(struct pci_dev *dev)
+{ return false; }
 #endif
 
 void pci_cfg_access_lock(struct pci_dev *dev);
-- 
2.26.2

