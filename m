Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B98B172B7E
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 23:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730454AbgB0Wgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 17:36:46 -0500
Received: from mga18.intel.com ([134.134.136.126]:49955 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730420AbgB0Wgo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 17:36:44 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Feb 2020 14:36:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,493,1574150400"; 
   d="scan'208";a="238568424"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by orsmga003.jf.intel.com with ESMTP; 27 Feb 2020 14:36:44 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     linux-pci@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 4/5] ice: use pci_get_dsn
Date:   Thu, 27 Feb 2020 14:36:34 -0800
Message-Id: <20200227223635.1021197-6-jacob.e.keller@intel.com>
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
 drivers/net/ethernet/intel/ice/ice_main.c | 32 ++++++++++-------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 5ae671609f98..77b56dcae331 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3099,30 +3099,26 @@ static char *ice_get_opt_fw_name(struct ice_pf *pf)
 	 * followed by a EUI-64 identifier (PCIe Device Serial Number)
 	 */
 	struct pci_dev *pdev = pf->pdev;
-	char *opt_fw_filename = NULL;
-	u32 dword;
+	char *opt_fw_filename;
 	u8 dsn[8];
-	int pos;
+	int err;
 
 	/* Determine the name of the optional file using the DSN (two
 	 * dwords following the start of the DSN Capability).
 	 */
-	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_DSN);
-	if (pos) {
-		opt_fw_filename = kzalloc(NAME_MAX, GFP_KERNEL);
-		if (!opt_fw_filename)
-			return NULL;
+	err = pci_get_dsn(pdev, dsn);
+	if (err)
+		return NULL;
 
-		pci_read_config_dword(pdev, pos + 4, &dword);
-		put_unaligned_le32(dword, &dsn[0]);
-		pci_read_config_dword(pdev, pos + 8, &dword);
-		put_unaligned_le32(dword, &dsn[4]);
-		snprintf(opt_fw_filename, NAME_MAX,
-			 "%sice-%02x%02x%02x%02x%02x%02x%02x%02x.pkg",
-			 ICE_DDP_PKG_PATH,
-			 dsn[7], dsn[6], dsn[5], dsn[4],
-			 dsn[3], dsn[2], dsn[1], dsn[0]);
-	}
+	opt_fw_filename = kzalloc(NAME_MAX, GFP_KERNEL);
+	if (!opt_fw_filename)
+		return NULL;
+
+	snprintf(opt_fw_filename, NAME_MAX,
+		 "%sice-%02x%02x%02x%02x%02x%02x%02x%02x.pkg",
+		 ICE_DDP_PKG_PATH,
+		 dsn[7], dsn[6], dsn[5], dsn[4],
+		 dsn[3], dsn[2], dsn[1], dsn[0]);
 
 	return opt_fw_filename;
 }
-- 
2.25.0.368.g28a2d05eebfb

