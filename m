Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79D1EF0B3E
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 01:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730724AbfKFAqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 19:46:39 -0500
Received: from mga01.intel.com ([192.55.52.88]:56513 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730677AbfKFAq0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 19:46:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2019 16:46:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,271,1569308400"; 
   d="scan'208";a="403554768"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga006.fm.intel.com with ESMTP; 05 Nov 2019 16:46:24 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 13/15] ice: Get rid of ice_cleanup_header
Date:   Tue,  5 Nov 2019 16:46:18 -0800
Message-Id: <20191106004620.10416-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191106004620.10416-1-jeffrey.t.kirsher@intel.com>
References: <20191106004620.10416-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>

ice_cleanup_hdrs() has been stripped of most of its content, it only serves
as a wrapper for eth_skb_pad(). We can get rid of it altogether and
simplify the codebase.

Signed-off-by: Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 27 ++---------------------
 1 file changed, 2 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 40a29b9d3034..2c212f64d99f 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -944,27 +944,6 @@ static void ice_put_rx_buf(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
 	rx_buf->skb = NULL;
 }
 
-/**
- * ice_cleanup_headers - Correct empty headers
- * @skb: pointer to current skb being fixed
- *
- * Also address the case where we are pulling data in on pages only
- * and as such no data is present in the skb header.
- *
- * In addition if skb is not at least 60 bytes we need to pad it so that
- * it is large enough to qualify as a valid Ethernet frame.
- *
- * Returns true if an error was encountered and skb was freed.
- */
-static bool ice_cleanup_headers(struct sk_buff *skb)
-{
-	/* if eth_skb_pad returns an error the skb was freed */
-	if (eth_skb_pad(skb))
-		return true;
-
-	return false;
-}
-
 /**
  * ice_is_non_eop - process handling of non-EOP buffers
  * @rx_ring: Rx ring being processed
@@ -1124,10 +1103,8 @@ static int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		if (ice_test_staterr(rx_desc, stat_err_bits))
 			vlan_tag = le16_to_cpu(rx_desc->wb.l2tag1);
 
-		/* correct empty headers and pad skb if needed (to make valid
-		 * ethernet frame
-		 */
-		if (ice_cleanup_headers(skb)) {
+		/* pad the skb if needed, to make a valid ethernet frame */
+		if (eth_skb_pad(skb)) {
 			skb = NULL;
 			continue;
 		}
-- 
2.21.0

