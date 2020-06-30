Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84B320EAEC
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgF3B2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:28:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:7475 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728456AbgF3B1y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 21:27:54 -0400
IronPort-SDR: kaHpfaveOMdIPUEDkRGf65C9pwOxFy8tAldDCw494Cq7WfzRGUtf/DxZEMI2LT2P2yRSpdItYv
 fMM9lvNHCvzQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="134413755"
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="134413755"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 18:27:51 -0700
IronPort-SDR: ZLf6CNytQCwXJd8Q3IB4PxEVhJyqFFJagyY3z7sH1W8V5CihlU4u2gcaEW3p4tMunfD+Lqjcks
 8q3/z9fPn93A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="425017727"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 29 Jun 2020 18:27:50 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 13/13] igc: Remove checking media type during MAC initialization
Date:   Mon, 29 Jun 2020 18:27:48 -0700
Message-Id: <20200630012748.518705-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200630012748.518705-1-jeffrey.t.kirsher@intel.com>
References: <20200630012748.518705-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

i225 device support only copper mode.
There is no point to check media type in the
igc_config_fc_after_link_up() method.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_mac.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_mac.c b/drivers/net/ethernet/intel/igc/igc_mac.c
index 9a5e44ef45f4..b47e7b0a6398 100644
--- a/drivers/net/ethernet/intel/igc/igc_mac.c
+++ b/drivers/net/ethernet/intel/igc/igc_mac.c
@@ -468,10 +468,8 @@ s32 igc_config_fc_after_link_up(struct igc_hw *hw)
 	 * so we had to force link.  In this case, we need to force the
 	 * configuration of the MAC to match the "fc" parameter.
 	 */
-	if (mac->autoneg_failed) {
-		if (hw->phy.media_type == igc_media_type_copper)
-			ret_val = igc_force_mac_fc(hw);
-	}
+	if (mac->autoneg_failed)
+		ret_val = igc_force_mac_fc(hw);
 
 	if (ret_val) {
 		hw_dbg("Error forcing flow control settings\n");
@@ -483,7 +481,7 @@ s32 igc_config_fc_after_link_up(struct igc_hw *hw)
 	 * has completed, and if so, how the PHY and link partner has
 	 * flow control configured.
 	 */
-	if (hw->phy.media_type == igc_media_type_copper && mac->autoneg) {
+	if (mac->autoneg) {
 		/* Read the MII Status Register and check to see if AutoNeg
 		 * has completed.  We read this twice because this reg has
 		 * some "sticky" (latched) bits.
-- 
2.26.2

