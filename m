Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8521C172B80
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 23:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730460AbgB0Wgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 17:36:48 -0500
Received: from mga18.intel.com ([134.134.136.126]:49955 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730422AbgB0Wgp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 17:36:45 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Feb 2020 14:36:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,493,1574150400"; 
   d="scan'208";a="238568429"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by orsmga003.jf.intel.com with ESMTP; 27 Feb 2020 14:36:44 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     linux-pci@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 5/5] ixgbe: use pci_get_dsn
Date:   Thu, 27 Feb 2020 14:36:35 -0800
Message-Id: <20200227223635.1021197-7-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.368.g28a2d05eebfb
In-Reply-To: <20200227223635.1021197-1-jacob.e.keller@intel.com>
References: <20200227223635.1021197-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the open-coded implementation for reading the PCIe DSN with
pci_get_dsn.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
index ccd852ad62a4..74ee12b87fc3 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
@@ -968,7 +968,7 @@ int ixgbe_fcoe_get_hbainfo(struct net_device *netdev,
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 	struct ixgbe_hw *hw = &adapter->hw;
-	int i, pos;
+	int i, err;
 	u8 buf[8];
 
 	if (!info)
@@ -985,19 +985,15 @@ int ixgbe_fcoe_get_hbainfo(struct net_device *netdev,
 	/* Serial Number */
 
 	/* Get the PCI-e Device Serial Number Capability */
-	pos = pci_find_ext_capability(adapter->pdev, PCI_EXT_CAP_ID_DSN);
-	if (pos) {
-		pos += 4;
-		for (i = 0; i < 8; i++)
-			pci_read_config_byte(adapter->pdev, pos + i, &buf[i]);
-
+	err = pci_get_dsn(adapter->pdev, buf);
+	if (err)
+		snprintf(info->serial_number, sizeof(info->serial_number),
+			 "Unknown");
+	else
 		snprintf(info->serial_number, sizeof(info->serial_number),
 			 "%02X%02X%02X%02X%02X%02X%02X%02X",
 			 buf[7], buf[6], buf[5], buf[4],
 			 buf[3], buf[2], buf[1], buf[0]);
-	} else
-		snprintf(info->serial_number, sizeof(info->serial_number),
-			 "Unknown");
 
 	/* Hardware Version */
 	snprintf(info->hardware_version,
-- 
2.25.0.368.g28a2d05eebfb

