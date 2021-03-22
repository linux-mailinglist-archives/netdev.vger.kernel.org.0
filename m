Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7B8344B0D
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhCVQTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:19:55 -0400
Received: from mga05.intel.com ([192.55.52.43]:59644 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231767AbhCVQTt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 12:19:49 -0400
IronPort-SDR: e94Db2FVMEoouvVs4uFFwrS6Xp3bp6akBxZYG0p4p0/yQp3rsOgK4xyyO6Z+oiLLZTuMzHQzOD
 oFyYO74kczqg==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="275400837"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="275400837"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 09:19:25 -0700
IronPort-SDR: Y0nqPO82in7nxWUP88qKPMGpluHGuVATp+KHApGvzkz+FlnDXh0tUxvvz2h8y46Zn3lCNy4kuP
 v76dPUjw4m6g==
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="407893528"
Received: from canguven-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.255.87.118])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 09:19:24 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        sasha.neftin@intel.com, anthony.l.nguyen@intel.com,
        linux-pci@vger.kernel.org, bhelgaas@google.com,
        netdev@vger.kernel.org, mlichvar@redhat.com,
        richardcochran@gmail.com
Subject: [PATCH next-queue v3 2/3] igc: Enable PCIe PTM
Date:   Mon, 22 Mar 2021 09:18:21 -0700
Message-Id: <20210322161822.1546454-3-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322161822.1546454-1-vinicius.gomes@intel.com>
References: <20210322161822.1546454-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In practice, enabling PTM also sets the enabled_ptm flag in the PCI
device, the flag will be used for detecting if PTM is enabled before
adding support for the SYSOFFSET_PRECISE ioctl() (which is added by
implementing the getcrosststamp() PTP function).

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index f77feadde8d2..04319ffae288 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -12,6 +12,8 @@
 #include <net/pkt_sched.h>
 #include <linux/bpf_trace.h>
 #include <net/xdp_sock_drv.h>
+#include <linux/pci.h>
+
 #include <net/ipv6.h>
 
 #include "igc.h"
@@ -5792,6 +5794,10 @@ static int igc_probe(struct pci_dev *pdev,
 
 	pci_enable_pcie_error_reporting(pdev);
 
+	err = pci_enable_ptm(pdev, NULL);
+	if (err < 0)
+		dev_err(&pdev->dev, "PTM not supported\n");
+
 	pci_set_master(pdev);
 
 	err = -ENOMEM;
-- 
2.31.0

