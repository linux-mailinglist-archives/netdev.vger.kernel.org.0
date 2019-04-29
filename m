Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68213EAB4
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 21:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729249AbfD2TOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 15:14:20 -0400
Received: from mga17.intel.com ([192.55.52.151]:61549 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729234AbfD2TON (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 15:14:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 12:14:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,410,1549958400"; 
   d="scan'208";a="341867060"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga005.fm.intel.com with ESMTP; 29 Apr 2019 12:14:10 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Stefan Assmann <sassmann@kpanic.de>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/12] i40e: print PCI vendor and device ID during probe
Date:   Mon, 29 Apr 2019 12:16:27 -0700
Message-Id: <20190429191628.31212-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190429191628.31212-1-jeffrey.t.kirsher@intel.com>
References: <20190429191628.31212-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

Printing each devices PCI vendor and device ID has the advantage of
easily revealing what hardware we're dealing with exactly. It's no
longer necessary to match the PCI bus information to the lspci output.

Helps with bug reports where no lspci output is available.

Output before
i40e 0000:08:00.0: fw 6.1.49420 api 1.7 nvm 6.80 0x80003c64 1.2007.0
and after
i40e 0000:08:00.0: fw 6.1.49420 api 1.7 nvm 6.80 0x80003c64 1.2007.0 [8086:1572] [8086:0004]

Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 9ea0556c8962..c2673d2cef8e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -14073,11 +14073,12 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 	i40e_get_oem_version(hw);
 
-	/* provide nvm, fw, api versions */
-	dev_info(&pdev->dev, "fw %d.%d.%05d api %d.%d nvm %s\n",
+	/* provide nvm, fw, api versions, vendor:device id, subsys vendor:device id */
+	dev_info(&pdev->dev, "fw %d.%d.%05d api %d.%d nvm %s [%04x:%04x] [%04x:%04x]\n",
 		 hw->aq.fw_maj_ver, hw->aq.fw_min_ver, hw->aq.fw_build,
 		 hw->aq.api_maj_ver, hw->aq.api_min_ver,
-		 i40e_nvm_version_str(hw));
+		 i40e_nvm_version_str(hw), hw->vendor_id, hw->device_id,
+		 hw->subsystem_vendor_id, hw->subsystem_device_id);
 
 	if (hw->aq.api_maj_ver == I40E_FW_API_VERSION_MAJOR &&
 	    hw->aq.api_min_ver > I40E_FW_MINOR_VERSION(hw))
-- 
2.20.1

