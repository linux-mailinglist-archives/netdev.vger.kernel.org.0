Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9E91AAD1E
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 22:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404029AbfIEUek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 16:34:40 -0400
Received: from mga06.intel.com ([134.134.136.31]:45332 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388090AbfIEUeN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 16:34:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 13:34:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,471,1559545200"; 
   d="scan'208";a="267136542"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga001.jf.intel.com with ESMTP; 05 Sep 2019 13:34:10 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/16] ice: move code closer together
Date:   Thu,  5 Sep 2019 13:33:55 -0700
Message-Id: <20190905203406.4152-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190905203406.4152-1-jeffrey.t.kirsher@intel.com>
References: <20190905203406.4152-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

This is a simple patch to move the assignment to a local variable
closer to the site where the local variable is used.  This
can help readability and also maybe performance, although the
performance enhancement is really dependent upon the compiler.

No functional change.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 4fe1b332e67e..ec581b1f0fcb 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1068,9 +1068,6 @@ static int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 			continue;
 		}
 
-		rx_ptype = le16_to_cpu(rx_desc->wb.ptype_flex_flags0) &
-			ICE_RX_FLEX_DESC_PTYPE_M;
-
 		stat_err_bits = BIT(ICE_RX_FLEX_DESC_STATUS0_L2TAG1P_S);
 		if (ice_test_staterr(rx_desc, stat_err_bits))
 			vlan_tag = le16_to_cpu(rx_desc->wb.l2tag1);
@@ -1087,6 +1084,9 @@ static int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		total_rx_bytes += skb->len;
 
 		/* populate checksum, VLAN, and protocol */
+		rx_ptype = le16_to_cpu(rx_desc->wb.ptype_flex_flags0) &
+			ICE_RX_FLEX_DESC_PTYPE_M;
+
 		ice_process_skb_fields(rx_ring, rx_desc, skb, rx_ptype);
 
 		/* send completed skb up the stack */
-- 
2.21.0

