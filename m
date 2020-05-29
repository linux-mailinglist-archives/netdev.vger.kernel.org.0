Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3291E7507
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 06:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgE2EkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 00:40:20 -0400
Received: from mga03.intel.com ([134.134.136.65]:40325 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbgE2EkQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 00:40:16 -0400
IronPort-SDR: c+EVsYV1kZECgZaLU1hlL++r/2F0rNiyhsdn2FMHiqyxEVhivwmtTQ1dwLtAG/y+8V43ZsmlRL
 nNz6HaX78uDA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 21:40:05 -0700
IronPort-SDR: gq0c3JNW5oS1iARMrLrFjTG6GUInZHMck6ol2aBjAhslhSMOS8xiX/4QiNZwW97Fh20j8jVlsd
 BGgD1x7N00cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="414850919"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 28 May 2020 21:40:05 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jason Yan <yanaijie@huawei.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/17] igb: make igb_set_fc_watermarks() return void
Date:   Thu, 28 May 2020 21:39:54 -0700
Message-Id: <20200529044004.3725307-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529044004.3725307-1-jeffrey.t.kirsher@intel.com>
References: <20200529044004.3725307-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Yan <yanaijie@huawei.com>

This function always return 0 now, we can make it return void to
simplify the code. This fixes the following coccicheck warning:

drivers/net/ethernet/intel/igb/e1000_mac.c:728:5-12: Unneeded variable:
"ret_val". Return "0" on line 751

Signed-off-by: Jason Yan <yanaijie@huawei.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igb/e1000_mac.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_mac.c b/drivers/net/ethernet/intel/igb/e1000_mac.c
index 79ee0a747260..3254737c07a3 100644
--- a/drivers/net/ethernet/intel/igb/e1000_mac.c
+++ b/drivers/net/ethernet/intel/igb/e1000_mac.c
@@ -12,7 +12,7 @@
 #include "igb.h"
 
 static s32 igb_set_default_fc(struct e1000_hw *hw);
-static s32 igb_set_fc_watermarks(struct e1000_hw *hw);
+static void igb_set_fc_watermarks(struct e1000_hw *hw);
 
 /**
  *  igb_get_bus_info_pcie - Get PCIe bus information
@@ -687,7 +687,7 @@ s32 igb_setup_link(struct e1000_hw *hw)
 
 	wr32(E1000_FCTTV, hw->fc.pause_time);
 
-	ret_val = igb_set_fc_watermarks(hw);
+	igb_set_fc_watermarks(hw);
 
 out:
 
@@ -723,9 +723,8 @@ void igb_config_collision_dist(struct e1000_hw *hw)
  *  flow control XON frame transmission is enabled, then set XON frame
  *  tansmission as well.
  **/
-static s32 igb_set_fc_watermarks(struct e1000_hw *hw)
+static void igb_set_fc_watermarks(struct e1000_hw *hw)
 {
-	s32 ret_val = 0;
 	u32 fcrtl = 0, fcrth = 0;
 
 	/* Set the flow control receive threshold registers.  Normally,
@@ -747,8 +746,6 @@ static s32 igb_set_fc_watermarks(struct e1000_hw *hw)
 	}
 	wr32(E1000_FCRTL, fcrtl);
 	wr32(E1000_FCRTH, fcrth);
-
-	return ret_val;
 }
 
 /**
-- 
2.26.2

