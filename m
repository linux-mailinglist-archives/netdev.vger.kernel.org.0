Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070D82ACF72
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 07:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732054AbgKJGKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 01:10:33 -0500
Received: from mga03.intel.com ([134.134.136.65]:17481 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731819AbgKJGKb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 01:10:31 -0500
IronPort-SDR: 32nn60UCSg58ohVffRd8ldXp1NCaRFPU3esIg9cPvVhwSzCNJpKpEv+WpUP4yFfE2A1RRZd9L1
 R8zSfgM6FYoA==
X-IronPort-AV: E=McAfee;i="6000,8403,9800"; a="170035030"
X-IronPort-AV: E=Sophos;i="5.77,465,1596524400"; 
   d="scan'208";a="170035030"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 22:10:31 -0800
IronPort-SDR: iUivQAjkrEcf0jQ+f4phyPmr4GKHHhFdBNbhrywSbUkfxAhMjNYMhWzzGbIwSB/28015p2VQSk
 6PGfyPFo8E3g==
X-IronPort-AV: E=Sophos;i="5.77,465,1596524400"; 
   d="scan'208";a="365752866"
Received: from eevans-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.97.1])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 22:10:30 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        sasha.neftin@intel.com, andre.guedes@intel.com,
        anthony.l.nguyen@intel.com, linux-pci@vger.kernel.org,
        bhelgaas@google.com, netdev@vger.kernel.org
Subject: [PATCH next-queue v2 2/3] igc: Enable PCIe PTM
Date:   Mon,  9 Nov 2020 22:10:18 -0800
Message-Id: <20201110061019.519589-3-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20201110061019.519589-1-vinicius.gomes@intel.com>
References: <20201110061019.519589-1-vinicius.gomes@intel.com>
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
 drivers/net/ethernet/intel/igc/igc_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 9112dff075cf..cb4ffa90230c 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -10,6 +10,7 @@
 #include <linux/ip.h>
 #include <linux/pm_runtime.h>
 #include <net/pkt_sched.h>
+#include <linux/pci.h>
 
 #include <net/ipv6.h>
 
@@ -5017,6 +5018,10 @@ static int igc_probe(struct pci_dev *pdev,
 
 	pci_enable_pcie_error_reporting(pdev);
 
+	err = pci_enable_ptm(pdev, NULL);
+	if (err < 0)
+		dev_err(&pdev->dev, "PTM not supported\n");
+
 	pci_set_master(pdev);
 
 	err = -ENOMEM;
-- 
2.29.0

