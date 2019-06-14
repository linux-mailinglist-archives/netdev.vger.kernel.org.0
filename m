Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6E61468B4
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 22:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbfFNUQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 16:16:12 -0400
Received: from mga06.intel.com ([134.134.136.31]:59939 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726201AbfFNUP5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 16:15:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 13:15:56 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga004.fm.intel.com with ESMTP; 14 Jun 2019 13:15:56 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Adam Ludkiewicz <adam.ludkiewicz@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 09/12] i40e: Check if the BAR size is large enough before writing to registers
Date:   Fri, 14 Jun 2019 13:16:07 -0700
Message-Id: <20190614201610.13566-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190614201610.13566-1-jeffrey.t.kirsher@intel.com>
References: <20190614201610.13566-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Adam Ludkiewicz <adam.ludkiewicz@intel.com>

This patch fixes the problem with a kernel panic occurring when trying
to bind the i40e driver to a non-i40e port. The problem is fixed by
checking if the BAR size in the device is large enough by reading the
highest register.

Signed-off-by: Adam Ludkiewicz <adam.ludkiewicz@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 12ae4d99109b..1d78db15c65a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -14205,7 +14205,17 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pf->ioremap_len = min_t(int, pci_resource_len(pdev, 0),
 				I40E_MAX_CSR_SPACE);
-
+	/* We believe that the highest register to read is
+	 * I40E_GLGEN_STAT_CLEAR, so we check if the BAR size
+	 * is not less than that before mapping to prevent a
+	 * kernel panic.
+	 */
+	if (pf->ioremap_len < I40E_GLGEN_STAT_CLEAR) {
+		dev_err(&pdev->dev, "Cannot map registers, bar size 0x%X too small, aborting\n",
+			pf->ioremap_len);
+		err = -ENOMEM;
+		goto err_ioremap;
+	}
 	hw->hw_addr = ioremap(pci_resource_start(pdev, 0), pf->ioremap_len);
 	if (!hw->hw_addr) {
 		err = -EIO;
-- 
2.21.0

