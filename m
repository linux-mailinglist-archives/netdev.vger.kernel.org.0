Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E042C9017
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 22:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388660AbgK3Var (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 16:30:47 -0500
Received: from mga03.intel.com ([134.134.136.65]:5349 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388656AbgK3Vaq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 16:30:46 -0500
IronPort-SDR: Kld96QDzPyuivrp8kz4tUc6h+hhh2UHIgOYRZzoXciFfCFE18B8uBDGqcONRP+uMJcOt/gx2di
 XSBAPTh24Tnw==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="172815010"
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="172815010"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 13:29:19 -0800
IronPort-SDR: grxwwvAdLFBuA2v/10jrgtvneM/uhbs76vlGt32jIaCHqxH5qLAJMRWUYAOopsHtVkDbRqgSTD
 hF0qopGNBhYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="329719697"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 30 Nov 2020 13:29:19 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Vitaly Lifshits <vitaly.lifshits@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 4/4] e1000e: fix S0ix flow to allow S0i3.2 subset entry
Date:   Mon, 30 Nov 2020 13:29:07 -0800
Message-Id: <20201130212907.320677-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201130212907.320677-1-anthony.l.nguyen@intel.com>
References: <20201130212907.320677-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vitaly Lifshits <vitaly.lifshits@intel.com>

Change configuration in the flows to align with
architecture requirements to achieve S0i3.2 substate.

Also fix a typo in the previous commit 632fbd5eb5b0
("e1000e: fix S0ix flows for cable connected case").

Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index f413b33127f6..4333fec268b0 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6447,13 +6447,13 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
 
 	/* Ungate PGCB clock */
 	mac_data = er32(FEXTNVM9);
-	mac_data |= BIT(28);
+	mac_data &= ~BIT(28);
 	ew32(FEXTNVM9, mac_data);
 
 	/* Enable K1 off to enable mPHY Power Gating */
 	mac_data = er32(FEXTNVM6);
 	mac_data |= BIT(31);
-	ew32(FEXTNVM12, mac_data);
+	ew32(FEXTNVM6, mac_data);
 
 	/* Enable mPHY power gating for any link and speed */
 	mac_data = er32(FEXTNVM8);
@@ -6497,11 +6497,11 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
 	/* Disable K1 off */
 	mac_data = er32(FEXTNVM6);
 	mac_data &= ~BIT(31);
-	ew32(FEXTNVM12, mac_data);
+	ew32(FEXTNVM6, mac_data);
 
 	/* Disable Ungate PGCB clock */
 	mac_data = er32(FEXTNVM9);
-	mac_data &= ~BIT(28);
+	mac_data |= BIT(28);
 	ew32(FEXTNVM9, mac_data);
 
 	/* Cancel not waking from dynamic
-- 
2.26.2

