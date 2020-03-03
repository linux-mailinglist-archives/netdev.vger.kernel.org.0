Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CECE176AA3
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 03:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgCCCZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:25:16 -0500
Received: from mga14.intel.com ([192.55.52.115]:54186 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727085AbgCCCZJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:25:09 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 18:25:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="233605696"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga008.fm.intel.com with ESMTP; 02 Mar 2020 18:25:08 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH v2 4/6] ice: Use pci_get_dsn()
Date:   Mon,  2 Mar 2020 18:25:03 -0800
Message-Id: <20200303022506.1792776-5-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.368.g28a2d05eebfb
In-Reply-To: <20200303022506.1792776-1-jacob.e.keller@intel.com>
References: <CABhMZUXJ_Omt-+fwa4Oz-Ly=J+NM8+8Ryv-Ad1u_bgEpDRH7RQ@mail.gmail.com>
 <20200303022506.1792776-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the open-coded implementation for reading the PCIe DSN with
pci_get_dsn().

The pci_get_dsn() function will perform two pci_read_config_dword calls
to read the lower and upper config dwords. It bitwise ORs them into
a u64 value. Instead of using put_unaligned_le32 to convert the value to
LE32 format, just use the %016llX printf specifier. This will print the
u64 correct, putting the most significant byte of the value first. Since
pci_get_dsn() correctly orders the two dwords into a u64, this should
produce equivalent results in less code.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 30 +++++++++--------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 5ae671609f98..c633519b1555 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3099,30 +3099,22 @@ static char *ice_get_opt_fw_name(struct ice_pf *pf)
 	 * followed by a EUI-64 identifier (PCIe Device Serial Number)
 	 */
 	struct pci_dev *pdev = pf->pdev;
-	char *opt_fw_filename = NULL;
-	u32 dword;
-	u8 dsn[8];
-	int pos;
+	char *opt_fw_filename;
+	u64 dsn;
 
 	/* Determine the name of the optional file using the DSN (two
 	 * dwords following the start of the DSN Capability).
 	 */
-	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_DSN);
-	if (pos) {
-		opt_fw_filename = kzalloc(NAME_MAX, GFP_KERNEL);
-		if (!opt_fw_filename)
-			return NULL;
+	dsn = pci_get_dsn(pdev);
+	if (!dsn)
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
+	snprintf(opt_fw_filename, NAME_MAX, "%sice-%016llX.pkg",
+		 ICE_DDP_PKG_PATH, dsn);
 
 	return opt_fw_filename;
 }
-- 
2.25.0.368.g28a2d05eebfb

