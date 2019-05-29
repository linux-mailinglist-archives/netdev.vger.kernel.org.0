Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBD12D2C4
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 02:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbfE2ARq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 20:17:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:59372 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726653AbfE2AR0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 20:17:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 May 2019 17:17:26 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 28 May 2019 17:17:26 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Feng Tang <feng.tang@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/10] igb/igc: warn when fatal read failure happens
Date:   Tue, 28 May 2019 17:17:17 -0700
Message-Id: <20190529001726.26097-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190529001726.26097-1-jeffrey.t.kirsher@intel.com>
References: <20190529001726.26097-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

Failed in read the HW register is very serious for igb/igc driver,
as its hw_addr will be set to NULL and cause the adapter be seen as
"REMOVED".

We saw the error only a few times in the MTBF test for suspend/resume,
but can hardly get any useful info to debug.

Adding WARN() so that we can get the necessary information about
where and how it happens, and use it for root causing and fixing
this "PCIe link lost issue"

This affects igb, igc.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 1 +
 drivers/net/ethernet/intel/igc/igc_main.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 39f33afc479c..e5b7e638df28 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -753,6 +753,7 @@ u32 igb_rd32(struct e1000_hw *hw, u32 reg)
 		struct net_device *netdev = igb->netdev;
 		hw->hw_addr = NULL;
 		netdev_err(netdev, "PCIe link lost\n");
+		WARN(1, "igb: Failed to read reg 0x%x!\n", reg);
 	}
 
 	return value;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 34fa0e60a780..28072b9aa932 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3934,6 +3934,7 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
 		hw->hw_addr = NULL;
 		netif_device_detach(netdev);
 		netdev_err(netdev, "PCIe link lost, device now detached\n");
+		WARN(1, "igc: Failed to read reg 0x%x!\n", reg);
 	}
 
 	return value;
-- 
2.21.0

