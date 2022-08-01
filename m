Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEBAA587066
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 20:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbiHAS2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 14:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbiHAS2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 14:28:13 -0400
X-Greylist: delayed 301 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 01 Aug 2022 11:28:12 PDT
Received: from aurora.tech (ec2-13-52-33-44.us-west-1.compute.amazonaws.com [13.52.33.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3327AE0CC
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 11:28:11 -0700 (PDT)
Received: by aurora.tech (Postfix, from userid 1001)
        id 3D8A61640092; Mon,  1 Aug 2022 06:37:53 -0700 (PDT)
From:   achaiken@aurora.tech
To:     jesse.brandeburg@intel.com, richardcochran@gmail.com
Cc:     spayne@aurora.tech, achaiken@aurora.tech, alison@she-devel.com,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: [PATCH] Use ixgbe_ptp_reset on linkup/linkdown for X550
Date:   Mon,  1 Aug 2022 06:37:50 -0700
Message-Id: <20220801133750.7312-1-achaiken@aurora.tech>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        RDNS_DYNAMIC,SPF_HELO_SOFTFAIL,SPF_SOFTFAIL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steve Payne <spayne@aurora.tech>

For an unknown reason, when `ixgbe_ptp_start_cyclecounter` is called
from `ixgbe_watchdog_link_is_down` the PHC on the NIC jumps backward
by a seemingly inconsistent amount, which causes discontinuities in
time synchronization. Explicitly reset the NIC's PHC to
`CLOCK_REALTIME` whenever the NIC goes up or down by calling
`ixgbe_ptp_reset` instead of the bare `ixgbe_ptp_start_cyclecounter`.

Signed-off-by: Steve Payne <spayne@aurora.tech>
Signed-off-by: Alison Chaiken <achaiken@aurora.tech>

---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 750b02bb2fdc2..ab1ec076fa75f 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -7462,7 +7462,7 @@ static void ixgbe_watchdog_link_is_up(struct ixgbe_adapter *adapter)
 	adapter->last_rx_ptp_check = jiffies;
 
 	if (test_bit(__IXGBE_PTP_RUNNING, &adapter->state))
-		ixgbe_ptp_start_cyclecounter(adapter);
+		ixgbe_ptp_reset(adapter);
 
 	switch (link_speed) {
 	case IXGBE_LINK_SPEED_10GB_FULL:
@@ -7527,7 +7527,7 @@ static void ixgbe_watchdog_link_is_down(struct ixgbe_adapter *adapter)
 		adapter->flags2 |= IXGBE_FLAG2_SEARCH_FOR_SFP;
 
 	if (test_bit(__IXGBE_PTP_RUNNING, &adapter->state))
-		ixgbe_ptp_start_cyclecounter(adapter);
+		ixgbe_ptp_reset(adapter);
 
 	e_info(drv, "NIC Link is Down\n");
 	netif_carrier_off(netdev);
-- 
2.32.0

