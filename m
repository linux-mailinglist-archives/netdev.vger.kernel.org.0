Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06A0F176A9D
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 03:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbgCCCZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:25:12 -0500
Received: from mga14.intel.com ([192.55.52.115]:54187 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727146AbgCCCZJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:25:09 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 18:25:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="233605702"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga008.fm.intel.com with ESMTP; 02 Mar 2020 18:25:08 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 6/6] nfp: Use pci_get_dsn()
Date:   Mon,  2 Mar 2020 18:25:05 -0800
Message-Id: <20200303022506.1792776-7-jacob.e.keller@intel.com>
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

Use the newly added pci_get_dsn() function for obtaining the 64-bit
Device Serial Number in the nfp6000_read_serial and
nfp_6000_get_interface functions.

pci_get_dsn() reports the Device Serial number as a u64 value created by
combining two pci_read_config_dword functions. The lower 16 bits
represent the device interface value, and the next 48 bits represent the
serial value. Use put_unaligned_be32 and put_unaligned_be16 to convert
the serial value portion into a Big Endian formatted serial u8 array.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 .../netronome/nfp/nfpcore/nfp6000_pcie.c      | 24 +++++++------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
index b454db283aef..8fde6c1f681b 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
@@ -1247,19 +1247,16 @@ static void nfp6000_free(struct nfp_cpp *cpp)
 static int nfp6000_read_serial(struct device *dev, u8 *serial)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	int pos;
-	u32 reg;
+	u64 dsn;
 
-	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_DSN);
-	if (!pos) {
+	dsn = pci_get_dsn(pdev);
+	if (!dsn) {
 		dev_err(dev, "can't find PCIe Serial Number Capability\n");
 		return -EINVAL;
 	}
 
-	pci_read_config_dword(pdev, pos + 4, &reg);
-	put_unaligned_be16(reg >> 16, serial + 4);
-	pci_read_config_dword(pdev, pos + 8, &reg);
-	put_unaligned_be32(reg, serial);
+	put_unaligned_be32((u32)(dsn >> 32), serial);
+	put_unaligned_be16((u16)(dsn >> 16), serial + 4);
 
 	return 0;
 }
@@ -1267,18 +1264,15 @@ static int nfp6000_read_serial(struct device *dev, u8 *serial)
 static int nfp6000_get_interface(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	int pos;
-	u32 reg;
+	u64 dsn;
 
-	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_DSN);
-	if (!pos) {
+	dsn = pci_get_dsn(pdev);
+	if (!dsn) {
 		dev_err(dev, "can't find PCIe Serial Number Capability\n");
 		return -EINVAL;
 	}
 
-	pci_read_config_dword(pdev, pos + 4, &reg);
-
-	return reg & 0xffff;
+	return dsn & 0xffff;
 }
 
 static const struct nfp_cpp_operations nfp6000_pcie_ops = {
-- 
2.25.0.368.g28a2d05eebfb

