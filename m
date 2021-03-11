Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4A0337BC1
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbhCKSIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:08:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:47785 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhCKSH7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 13:07:59 -0500
IronPort-SDR: saoAkRrQGIDQMhOHoFfZuo6jXx5v5BAhfaUCOVCid0j2SopBBDxKM8l1wG91U/N1iiC0HOmWMV
 zgroyYgN9L2A==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="188809482"
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="188809482"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 10:07:58 -0800
IronPort-SDR: G/IUQ2faq3X7tz3oY8F3TggEIAnshG+EitPlgqkU4UmJkus+LSy+vaIRdEbrcCIW4rM/KYLOPc
 33AOaLn8kizg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="409570558"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 11 Mar 2021 10:07:58 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com,
        Malli C <mallikarjuna.chilakala@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net 3/6] igc: Fix Supported Pause Frame Link Setting
Date:   Thu, 11 Mar 2021 10:09:12 -0800
Message-Id: <20210311180915.1489936-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210311180915.1489936-1-anthony.l.nguyen@intel.com>
References: <20210311180915.1489936-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>

The Supported Pause Frame always display "No" even though the Advertised
pause frame showing the correct setting based on the pause parameters via
ethtool. Set bit in link_ksettings to "Supported" for Pause Frame.

Before output:
Supported pause frame use: No

Expected output:
Supported pause frame use: Symmetric

Fixes: 8c5ad0dae93c ("igc: Add ethtool support")
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Reviewed-by: Malli C <mallikarjuna.chilakala@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 67a4aed45fc2..8722294ab90c 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1711,6 +1711,9 @@ static int igc_ethtool_get_link_ksettings(struct net_device *netdev,
 						     Autoneg);
 	}
 
+	/* Set pause flow control settings */
+	ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
+
 	switch (hw->fc.requested_mode) {
 	case igc_fc_full:
 		ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
-- 
2.26.2

