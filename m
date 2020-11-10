Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376FF2ACF77
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 07:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731194AbgKJGKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 01:10:38 -0500
Received: from mga03.intel.com ([134.134.136.65]:17477 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727089AbgKJGKb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 01:10:31 -0500
IronPort-SDR: FvU141fKd5HZOHr/mU9XFEgFT1iSX1jEVHjrko0LtVL/rcRtATtepMOcpkivqs4knseYb6Tklq
 2Mnwy7oFxcww==
X-IronPort-AV: E=McAfee;i="6000,8403,9800"; a="170035028"
X-IronPort-AV: E=Sophos;i="5.77,465,1596524400"; 
   d="scan'208";a="170035028"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 22:10:30 -0800
IronPort-SDR: ixU8/TOHj72yFPDYg5Uuv4nE0mey6MHshR4KGVcs0j0Whiuupk6WizQFXSwIP0JMibFIpmrLRo
 fqiYcJM6+SEg==
X-IronPort-AV: E=Sophos;i="5.77,465,1596524400"; 
   d="scan'208";a="365752854"
Received: from eevans-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.97.1])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 22:10:29 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        sasha.neftin@intel.com, andre.guedes@intel.com,
        anthony.l.nguyen@intel.com, linux-pci@vger.kernel.org,
        bhelgaas@google.com, netdev@vger.kernel.org
Subject: [PATCH next-queue v2 1/3] Revert "PCI: Make pci_enable_ptm() private"
Date:   Mon,  9 Nov 2020 22:10:17 -0800
Message-Id: <20201110061019.519589-2-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20201110061019.519589-1-vinicius.gomes@intel.com>
References: <20201110061019.519589-1-vinicius.gomes@intel.com>
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

Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/pci/pci.h   | 3 ---
 include/linux/pci.h | 7 +++++++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index f86cae9aa1f4..548e93aca55b 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -581,11 +581,8 @@ static inline void pcie_ecrc_get_policy(char *str) { }
 
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
index 22207a79762c..18ce0d3eaecc 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1596,6 +1596,13 @@ static inline bool pci_aer_available(void) { return false; }
 
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
2.29.0

