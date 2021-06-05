Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0629C39C455
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 02:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhFEA0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 20:26:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:53213 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230169AbhFEAZ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 20:25:57 -0400
IronPort-SDR: NVvloYRae+ZyU/Smh5gJU4K8UPtSNmUNrsByjpF8IVtxPbCkm5UdCewVwj0FiRZSnQa1TpRRoi
 aIFAxwqWa33g==
X-IronPort-AV: E=McAfee;i="6200,9189,10005"; a="191505928"
X-IronPort-AV: E=Sophos;i="5.83,249,1616482800"; 
   d="scan'208";a="191505928"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 17:24:10 -0700
IronPort-SDR: z6QmGzKs64cXTDVV87TY/wK9bX5xy67uCv27SJu+wez5AAGE0rFUvgrJFALvjN1CRaCzZ3KaQ2
 V3OWxFj+duvw==
X-IronPort-AV: E=Sophos;i="5.83,249,1616482800"; 
   d="scan'208";a="446862953"
Received: from lmrivera-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.251.24.65])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 17:24:09 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        sasha.neftin@intel.com, anthony.l.nguyen@intel.com,
        linux-pci@vger.kernel.org, bhelgaas@google.com,
        netdev@vger.kernel.org, mlichvar@redhat.com,
        richardcochran@gmail.com, hch@infradead.org, helgaas@kernel.org
Subject: [PATCH next-queue v5 3/4] igc: Enable PCIe PTM
Date:   Fri,  4 Jun 2021 17:23:55 -0700
Message-Id: <20210605002356.3996853-4-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210605002356.3996853-1-vinicius.gomes@intel.com>
References: <20210605002356.3996853-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enables PCIe PTM (Precision Time Measurement) support in the igc
driver. Notifies the PCI devices that PCIe PTM should be enabled.

PCIe PTM is similar protocol to PTP (Precision Time Protocol) running
in the PCIe fabric, it allows devices to report time measurements from
their internal clocks and the correlation with the PCIe root clock.

The i225 NIC exposes some registers that expose those time
measurements, those registers will be used, in later patches, to
implement the PTP_SYS_OFFSET_PRECISE ioctl().

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index a05e6d8ec660..f23d0303e53b 100644
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
@@ -5864,6 +5866,10 @@ static int igc_probe(struct pci_dev *pdev,
 
 	pci_enable_pcie_error_reporting(pdev);
 
+	err = pci_enable_ptm(pdev, NULL);
+	if (err < 0)
+		dev_err(&pdev->dev, "PTM not supported\n");
+
 	pci_set_master(pdev);
 
 	err = -ENOMEM;
-- 
2.31.1

