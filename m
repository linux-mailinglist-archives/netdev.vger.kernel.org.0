Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3747D176A9A
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 03:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbgCCCZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:25:09 -0500
Received: from mga14.intel.com ([192.55.52.115]:54186 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727075AbgCCCZI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:25:08 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 18:25:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="233605689"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga008.fm.intel.com with ESMTP; 02 Mar 2020 18:25:07 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH v2 2/6] bnxt_en: Use pci_get_dsn()
Date:   Mon,  2 Mar 2020 18:25:01 -0800
Message-Id: <20200303022506.1792776-3-jacob.e.keller@intel.com>
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

Use of put_unaligned_le64 should be correct. pci_get_dsn() will perform
two pci_read_config_dword calls. The first dword will be placed in the
first 32 bits of the u64, while the second dword will be placed in the
upper 32 bits of the u64.

On Little Endian systems, the least significant byte comes first, which
will be the least significant byte of the first dword, followed by the
least significant byte of the second dword. Since the _le32 variations
do not perform byte swapping, we will correctly copy the dwords into the
dsn[] array in the same order as before.

On Big Endian systems, the most significant byte of the second dword
will come first. put_unaligned_le64 will perform a CPU_TO_LE64, which
will swap things correctly before copying. This should also end up with
the correct bytes in the dsn[] array.

While at it, fix a small typo in the netdev_info error message when the
DSN cannot be read.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Cc: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 597e6fd5bfea..49874079084d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11755,20 +11755,16 @@ static int bnxt_init_mac_addr(struct bnxt *bp)
 static int bnxt_pcie_dsn_get(struct bnxt *bp, u8 dsn[])
 {
 	struct pci_dev *pdev = bp->pdev;
-	int pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_DSN);
-	u32 dw;
+	u64 qword;
 
-	if (!pos) {
-		netdev_info(bp->dev, "Unable do read adapter's DSN");
+	qword = pci_get_dsn(pdev);
+	if (!qword) {
+		netdev_info(bp->dev, "Unable to read adapter's DSN");
 		return -EOPNOTSUPP;
 	}
 
-	/* DSN (two dw) is at an offset of 4 from the cap pos */
-	pos += 4;
-	pci_read_config_dword(pdev, pos, &dw);
-	put_unaligned_le32(dw, &dsn[0]);
-	pci_read_config_dword(pdev, pos + 4, &dw);
-	put_unaligned_le32(dw, &dsn[4]);
+	put_unaligned_le64(qword, dsn);
+
 	bp->flags |= BNXT_FLAG_DSN_VALID;
 	return 0;
 }
-- 
2.25.0.368.g28a2d05eebfb

