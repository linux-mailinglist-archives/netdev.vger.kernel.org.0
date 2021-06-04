Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925B339C349
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 00:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhFDWMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 18:12:02 -0400
Received: from mga05.intel.com ([192.55.52.43]:24251 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229930AbhFDWLx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 18:11:53 -0400
IronPort-SDR: e+dNJ09oymJqK2Bb81/QRmJgdE55O69ETcpu16iUAtZR6vYBqdOO5WbNRTrRGQGKZDxWl859O8
 OTKlbvu6kJMA==
X-IronPort-AV: E=McAfee;i="6200,9189,10005"; a="290007348"
X-IronPort-AV: E=Sophos;i="5.83,249,1616482800"; 
   d="scan'208";a="290007348"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 15:10:06 -0700
IronPort-SDR: xuzL01V2nMA+eYKEDD5UdRsBwS51/ycgmAtkBQ4qOxUrH7d9tdB60HkynLeFFHmyK+EvmXHFnA
 Ya9HAbcsHN7w==
X-IronPort-AV: E=Sophos;i="5.83,249,1616482800"; 
   d="scan'208";a="439326618"
Received: from lmrivera-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.251.24.65])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 15:10:05 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        sasha.neftin@intel.com, anthony.l.nguyen@intel.com,
        linux-pci@vger.kernel.org, bhelgaas@google.com,
        netdev@vger.kernel.org, mlichvar@redhat.com,
        richardcochran@gmail.com, hch@infradead.org, helgaas@kernel.org
Subject: [PATCH next-queue v4 2/4] PCI: Add pcie_ptm_enabled()
Date:   Fri,  4 Jun 2021 15:09:31 -0700
Message-Id: <20210604220933.3974558-3-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210604220933.3974558-1-vinicius.gomes@intel.com>
References: <20210604220933.3974558-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds a predicate that returns if PCIe PTM (Precision Time Measurement)
is enabled.

It will only return true if it's enabled in all the ports in the path
from the device to the root.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
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
index a687dda262dd..fe7f264b2b15 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1619,9 +1619,12 @@ bool pci_ats_disabled(void);
 
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
2.31.1

