Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39AF84761D4
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 20:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbhLOTfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 14:35:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:59494 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231877AbhLOTft (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 14:35:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639596949; x=1671132949;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=64fFA/H/oJmoFdzArxYdPQyQYLPJYH7D1RqPzJ65Hl4=;
  b=YSvxmZkIRUA4iFl1g3ECi/Z8LewWkUHbqKJnGCcAClox2e6nSqBL9Ntl
   hQW+ef/8BKdRo6EevCa9FbSspHWswdDAlX9HzD5Dg2j3ZzXBu6oipfxPC
   c3zRPdhKJIGTvV4pPjjjoovIJSnZ+2NkOVdhNskemw/1sDcvnJAYpzAwR
   mhFO7avsujzXEOGhulxt1sLEaBp/kF8ipX3M4P436v0KfcKg4g9dx5EYd
   nfZVPdhtM6PO0IJUcDbw52QF3fFHaCeHFBQ8DgoBgbK2B0YHvhHndMxSb
   Jah3r5fJo7Bv7Ne5ZGYOctvKFrk2vr1YsfBGDknojQ2dk0necHs9Vc4Sx
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="236856413"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="236856413"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 11:35:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="465746705"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 15 Dec 2021 11:35:30 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Cyril Novikov <cnovikov@lynx.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net 5/5] ixgbe: set X550 MDIO speed before talking to PHY
Date:   Wed, 15 Dec 2021 11:34:34 -0800
Message-Id: <20211215193434.3253664-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211215193434.3253664-1-anthony.l.nguyen@intel.com>
References: <20211215193434.3253664-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cyril Novikov <cnovikov@lynx.com>

The MDIO bus speed must be initialized before talking to the PHY the first
time in order to avoid talking to it using a speed that the PHY doesn't
support.

This fixes HW initialization error -17 (IXGBE_ERR_PHY_ADDR_INVALID) on
Denverton CPUs (a.k.a. the Atom C3000 family) on ports with a 10Gb network
plugged in. On those devices, HLREG0[MDCSPD] resets to 1, which combined
with the 10Gb network results in a 24MHz MDIO speed, which is apparently
too fast for the connected PHY. PHY register reads over MDIO bus return
garbage, leading to initialization failure.

Reproduced with Linux kernel 4.19 and 5.15-rc7. Can be reproduced using
the following setup:

* Use an Atom C3000 family system with at least one X552 LAN on the SoC
* Disable PXE or other BIOS network initialization if possible
  (the interface must not be initialized before Linux boots)
* Connect a live 10Gb Ethernet cable to an X550 port
* Power cycle (not reset, doesn't always work) the system and boot Linux
* Observe: ixgbe interfaces w/ 10GbE cables plugged in fail with error -17

Fixes: e84db7272798 ("ixgbe: Introduce function to control MDIO speed")
Signed-off-by: Cyril Novikov <cnovikov@lynx.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
index 9724ffb16518..e4b50c7781ff 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
@@ -3405,6 +3405,9 @@ static s32 ixgbe_reset_hw_X550em(struct ixgbe_hw *hw)
 	/* flush pending Tx transactions */
 	ixgbe_clear_tx_pending(hw);
 
+	/* set MDIO speed before talking to the PHY in case it's the 1st time */
+	ixgbe_set_mdio_speed(hw);
+
 	/* PHY ops must be identified and initialized prior to reset */
 	status = hw->phy.ops.init(hw);
 	if (status == IXGBE_ERR_SFP_NOT_SUPPORTED ||
-- 
2.31.1

