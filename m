Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390772794C3
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 01:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729468AbgIYX3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 19:29:23 -0400
Received: from mga18.intel.com ([134.134.136.126]:29551 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729451AbgIYX3W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 19:29:22 -0400
IronPort-SDR: +ZFVZEGuGQflZRICiNMLJT1LgpMpvwPqXUpNtkieLeI43qeJ+lUSnWyCmfXVHRUwuT9xkdy/JA
 Gk6wenze5O0w==
X-IronPort-AV: E=McAfee;i="6000,8403,9755"; a="149433243"
X-IronPort-AV: E=Sophos;i="5.77,303,1596524400"; 
   d="scan'208";a="149433243"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 16:29:19 -0700
IronPort-SDR: E9KeSQKVJdntwVln+TD6rk6anaN9oFaNK+5CJ1HsOonl+BPv2ccXA4GZ/ksnTcLanGk3NNBpp+
 BPu35txJUjFQ==
X-IronPort-AV: E=Sophos;i="5.77,303,1596524400"; 
   d="scan'208";a="337051733"
Received: from msbergin-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.110.90])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 16:29:15 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        sasha.neftin@intel.com, andre.guedes@intel.com,
        anthony.l.nguyen@intel.com, linux-pci@vger.kernel.org,
        bhelgaas@google.com, netdev@vger.kernel.org
Subject: [PATCH next-queue v1 1/3] Revert "PCI: Make pci_enable_ptm() private"
Date:   Fri, 25 Sep 2020 16:28:32 -0700
Message-Id: <20200925232834.2704711-2-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925232834.2704711-1-vinicius.gomes@intel.com>
References: <20200925232834.2704711-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make pci_enable_ptm() accessible from the drivers.

Even if PTM still works on the platform I am using without calling
this this function, it might be possible that it's not always the
case.

Exposing this to the driver enables the driver to use the
'ptm_enabled' field of 'pci_dev' to check if PTM is enabled or not.

This reverts commit ac6c26da29c12fa511c877c273ed5c939dc9e96c.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/pci/pci.h   | 3 ---
 include/linux/pci.h | 7 +++++++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index fa12f7cbc1a0..8871109fe390 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -582,11 +582,8 @@ static inline void pcie_ecrc_get_policy(char *str) { }
 
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
index 835530605c0d..ec4b28153cc4 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1593,6 +1593,13 @@ static inline bool pci_aer_available(void) { return false; }
 
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
2.28.0

