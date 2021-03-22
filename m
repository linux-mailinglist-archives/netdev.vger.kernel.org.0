Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD29344B09
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhCVQTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:19:52 -0400
Received: from mga07.intel.com ([134.134.136.100]:21216 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231593AbhCVQTa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 12:19:30 -0400
IronPort-SDR: MGZobCwmm8VgOMYrfUylQO4pSYX5tx9RgIJg4Q1pTxpVxfj4QZ9wd9YWLRZ4ZOh4Gxu9u5z3TJ
 bswqKqv6jG2Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="254301395"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="254301395"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 09:19:25 -0700
IronPort-SDR: 5c3ZiwwB78EO2tVIHQEc+MdH8/9R7WLhGysts2Xq309MQy31g6pY0Tl4vqKTzXIZSKe3gZVQ5Z
 t+7Y296RGSPQ==
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="407893525"
Received: from canguven-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.255.87.118])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 09:19:23 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        sasha.neftin@intel.com, anthony.l.nguyen@intel.com,
        linux-pci@vger.kernel.org, bhelgaas@google.com,
        netdev@vger.kernel.org, mlichvar@redhat.com,
        richardcochran@gmail.com
Subject: [PATCH next-queue v3 1/3] Revert "PCI: Make pci_enable_ptm() private"
Date:   Mon, 22 Mar 2021 09:18:20 -0700
Message-Id: <20210322161822.1546454-2-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322161822.1546454-1-vinicius.gomes@intel.com>
References: <20210322161822.1546454-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make pci_enable_ptm() accessible from the drivers.

Even if PTM still works on the platform I am using without calling
this function, it might be possible that it's not always the case.

Exposing this to the driver enables the driver to use the
'ptm_enabled' field of 'pci_dev' to check if PTM is enabled or not.

This reverts commit ac6c26da29c12fa511c877c273ed5c939dc9e96c.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/pci.h   | 3 ---
 include/linux/pci.h | 7 +++++++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index ef7c4661314f..2c61557e1cc1 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -599,11 +599,8 @@ static inline void pcie_ecrc_get_policy(char *str) { }
 
 #ifdef CONFIG_PCIE_PTM
 void pci_ptm_init(struct pci_dev *dev);
-int pci_enable_ptm(struct pci_dev *dev, u8 *granularity);
 #else
 static inline void pci_ptm_init(struct pci_dev *dev) { }
-static inline int pci_enable_ptm(struct pci_dev *dev, u8 *granularity)
-{ return -EINVAL; }
 #endif
 
 struct pci_dev_reset_methods {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 86c799c97b77..3d3dc07eac3b 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1610,6 +1610,13 @@ static inline bool pci_aer_available(void) { return false; }
 
 bool pci_ats_disabled(void);
 
+#ifdef CONFIG_PCIE_PTM
+int pci_enable_ptm(struct pci_dev *dev, u8 *granularity);
+#else
+static inline int pci_enable_ptm(struct pci_dev *dev, u8 *granularity)
+{ return -EINVAL; }
+#endif
+
 void pci_cfg_access_lock(struct pci_dev *dev);
 bool pci_cfg_access_trylock(struct pci_dev *dev);
 void pci_cfg_access_unlock(struct pci_dev *dev);
-- 
2.31.0

