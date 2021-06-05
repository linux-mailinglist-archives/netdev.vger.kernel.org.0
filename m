Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5DF39C452
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 02:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhFEAZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 20:25:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:53213 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229982AbhFEAZ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 20:25:56 -0400
IronPort-SDR: NB3dN6AhtBD7Qp1raN+X/h1DhkPmKvaYXvmBypOF5xE5MnfwyWT5kC5MuB+NSs2sx51P1qKWP7
 02cWKkJOxWOQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10005"; a="191505924"
X-IronPort-AV: E=Sophos;i="5.83,249,1616482800"; 
   d="scan'208";a="191505924"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 17:24:09 -0700
IronPort-SDR: xaSbUVUjApKeJ2mgjJhrrTMU2VJ4yS9BRpBy75wjpenLgTMRSyQUqCMzUq3MBEBhIMcIuTCVdo
 K0ekVQYxpYoA==
X-IronPort-AV: E=Sophos;i="5.83,249,1616482800"; 
   d="scan'208";a="446862945"
Received: from lmrivera-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.251.24.65])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 17:24:08 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        sasha.neftin@intel.com, anthony.l.nguyen@intel.com,
        linux-pci@vger.kernel.org, bhelgaas@google.com,
        netdev@vger.kernel.org, mlichvar@redhat.com,
        richardcochran@gmail.com, hch@infradead.org, helgaas@kernel.org
Subject: [PATCH next-queue v5 1/4] Revert "PCI: Make pci_enable_ptm() private"
Date:   Fri,  4 Jun 2021 17:23:53 -0700
Message-Id: <20210605002356.3996853-2-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210605002356.3996853-1-vinicius.gomes@intel.com>
References: <20210605002356.3996853-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make pci_enable_ptm() accessible from the drivers.

Exposing this to the driver enables the driver to use the
'ptm_enabled' field of 'pci_dev' to check if PTM is enabled or not.

This reverts commit ac6c26da29c1 ("PCI: Make pci_enable_ptm() private").

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/pci.h   | 3 ---
 include/linux/pci.h | 7 +++++++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 37c913bbc6e1..32dab36c717e 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -593,11 +593,8 @@ static inline void pcie_ecrc_get_policy(char *str) { }
 
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
index c20211e59a57..a687dda262dd 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1617,6 +1617,13 @@ static inline bool pci_aer_available(void) { return false; }
 
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
2.31.1

