Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08782794C4
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 01:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbgIYX3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 19:29:24 -0400
Received: from mga18.intel.com ([134.134.136.126]:29548 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729371AbgIYX3V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 19:29:21 -0400
IronPort-SDR: iDqO8qCwAIM6+3JFIAzELnubH/+IuIYbCbnvQeg95BFEUAtdpR6dafCAPuyxiY2X0fqSqmL1g+
 Gwb1p6AYSxbw==
X-IronPort-AV: E=McAfee;i="6000,8403,9755"; a="149433241"
X-IronPort-AV: E=Sophos;i="5.77,303,1596524400"; 
   d="scan'208";a="149433241"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 16:29:19 -0700
IronPort-SDR: tTeGhPdgk0iHRX2dEVJ79DjrVUIUW6OOFVMCi6g0/8RH+m1QA7CkA30HDKjTWnWdRTVtv5UJ8n
 U2u6kjeEoesA==
X-IronPort-AV: E=Sophos;i="5.77,303,1596524400"; 
   d="scan'208";a="337051737"
Received: from msbergin-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.110.90])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 16:29:15 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        sasha.neftin@intel.com, andre.guedes@intel.com,
        anthony.l.nguyen@intel.com, linux-pci@vger.kernel.org,
        bhelgaas@google.com, netdev@vger.kernel.org
Subject: [PATCH next-queue v1 2/3] igc: Enable PCIe PTM
Date:   Fri, 25 Sep 2020 16:28:33 -0700
Message-Id: <20200925232834.2704711-3-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925232834.2704711-1-vinicius.gomes@intel.com>
References: <20200925232834.2704711-1-vinicius.gomes@intel.com>
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
index 897e2d5514a1..56670ce14da8 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -10,6 +10,7 @@
 #include <linux/ip.h>
 #include <linux/pm_runtime.h>
 #include <net/pkt_sched.h>
+#include <linux/pci.h>
 
 #include <net/ipv6.h>
 
@@ -5021,6 +5022,10 @@ static int igc_probe(struct pci_dev *pdev,
 
 	pci_enable_pcie_error_reporting(pdev);
 
+	err = pci_enable_ptm(pdev, NULL);
+	if (err < 0)
+		dev_err(&pdev->dev, "PTM not supported\n");
+
 	pci_set_master(pdev);
 
 	err = -ENOMEM;
-- 
2.28.0

