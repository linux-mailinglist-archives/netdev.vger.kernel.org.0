Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4437C3D6CEC
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 05:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235182AbhG0C4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 22:56:55 -0400
Received: from mga12.intel.com ([192.55.52.136]:45176 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235205AbhG0C4y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 22:56:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10057"; a="191955844"
X-IronPort-AV: E=Sophos;i="5.84,272,1620716400"; 
   d="scan'208";a="191955844"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2021 20:37:21 -0700
X-IronPort-AV: E=Sophos;i="5.84,272,1620716400"; 
   d="scan'208";a="474230302"
Received: from nmanikan-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.209.99.32])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2021 20:37:20 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        sasha.neftin@intel.com, anthony.l.nguyen@intel.com,
        linux-pci@vger.kernel.org, bhelgaas@google.com,
        netdev@vger.kernel.org, mlichvar@redhat.com,
        richardcochran@gmail.com, hch@infradead.org, helgaas@kernel.org,
        pmenzel@molgen.mpg.de
Subject: [PATCH next-queue v6 3/4] igc: Enable PCIe PTM
Date:   Mon, 26 Jul 2021 20:36:56 -0700
Message-Id: <20210727033657.39885-4-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210727033657.39885-1-vinicius.gomes@intel.com>
References: <20210727033657.39885-1-vinicius.gomes@intel.com>
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
index 4dc7c4d70929..0600c11c2d64 100644
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
@@ -6183,6 +6185,10 @@ static int igc_probe(struct pci_dev *pdev,
 
 	pci_enable_pcie_error_reporting(pdev);
 
+	err = pci_enable_ptm(pdev, NULL);
+	if (err < 0)
+		dev_info(&pdev->dev, "PCIe PTM not supported by PCIe bus/controller\n");
+
 	pci_set_master(pdev);
 
 	err = -ENOMEM;
-- 
2.32.0

