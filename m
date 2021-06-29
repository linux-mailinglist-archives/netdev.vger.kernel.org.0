Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D043B79D9
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 23:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235319AbhF2V3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 17:29:05 -0400
Received: from mga14.intel.com ([192.55.52.115]:28283 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235161AbhF2V3E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 17:29:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10030"; a="208062415"
X-IronPort-AV: E=Sophos;i="5.83,310,1616482800"; 
   d="scan'208";a="208062415"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2021 14:26:36 -0700
X-IronPort-AV: E=Sophos;i="5.83,310,1616482800"; 
   d="scan'208";a="558854665"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.4])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2021 14:26:36 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next] ice: fix Tx queue iteration for Tx timestamp enablement
Date:   Tue, 29 Jun 2021 14:26:28 -0700
Message-Id: <20210629212628.642168-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.31.1.331.gb0c09ab8796f
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver accidentally copied the ice_for_each_rxq iterator when
implementing enablement of the ptp_tx bit for the Tx rings. We still
load the Tx rings and set the ptp_tx field, but we iterate over the
count of the num_rxq.

If the number of Tx and Rx queues differ, this could either cause
a buffer overrun when accessing the tx_rings list if num_txq is greater
than num_rxq, or it could cause us to fail to enable Tx timestamps for
some rings.

This was not noticed originally as we generally have the same number of
Tx and Rx queues.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 5d5207b56ca9..e176c7484484 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -22,7 +22,7 @@ static void ice_set_tx_tstamp(struct ice_pf *pf, bool on)
 		return;
 
 	/* Set the timestamp enable flag for all the Tx rings */
-	ice_for_each_rxq(vsi, i) {
+	ice_for_each_txq(vsi, i) {
 		if (!vsi->tx_rings[i])
 			continue;
 		vsi->tx_rings[i]->ptp_tx = on;

base-commit: fff3ea006287fec848383b6144935cba5ded41a6
-- 

This is a bug fix for the PTP patches that recently merged into net-next.

2.31.1.331.gb0c09ab8796f

