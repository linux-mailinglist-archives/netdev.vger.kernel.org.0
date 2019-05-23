Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A45D0274C3
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 05:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbfEWDXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 23:23:12 -0400
Received: from mga05.intel.com ([192.55.52.43]:3447 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728237AbfEWDXL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 23:23:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 May 2019 20:23:11 -0700
X-ExtLoop1: 1
Received: from shbuild888.sh.intel.com ([10.239.147.114])
  by fmsmga007.fm.intel.com with ESMTP; 22 May 2019 20:23:10 -0700
From:   Feng Tang <feng.tang@intel.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Aaron F Brown <aaron.f.brown@intel.com>,
        intel-wired-lan@osuosl.org, netdev@vger.kernel.org
Cc:     Feng Tang <feng.tang@intel.com>
Subject: [RESEND PATCH] intel-ethernet: warn when fatal read failure happens
Date:   Thu, 23 May 2019 11:22:33 +0800
Message-Id: <20190523032233.29277-1-feng.tang@intel.com>
X-Mailer: git-send-email 2.14.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Failed in reading the HW register is very serious for igb/igc driver,
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
2.14.1

