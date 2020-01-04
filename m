Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 598BC13003E
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 03:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbgADCuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 21:50:11 -0500
Received: from mga12.intel.com ([192.55.52.136]:64694 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727506AbgADCt5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 21:49:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jan 2020 18:49:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,393,1571727600"; 
   d="scan'208";a="369757885"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga004.jf.intel.com with ESMTP; 03 Jan 2020 18:49:54 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Mitch Williams <mitch.a.williams@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 13/16] ice: add extra check for null Rx descriptor
Date:   Fri,  3 Jan 2020 18:49:50 -0800
Message-Id: <20200104024953.2336731-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200104024953.2336731-1-jeffrey.t.kirsher@intel.com>
References: <20200104024953.2336731-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mitch Williams <mitch.a.williams@intel.com>

In the case where the hardware gives us a null Rx descriptor, it is
theoretically possible that we could call one of our skb-construction
functions with no data pointer, which would cause a panic.

In real life, this will never happen - we only get null RX
descriptors as the final descriptor in a chain of otherwise-valid
descriptors. When this happens, the skb will be extant and we'll just
call ice_add_rx_frag(), which can deal with empty data buffers.

Unfortunately, Coverity does not have intimate knowledge of our
hardware, so we must add a check here.

Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index b77514bbd7ba..fd17ace6b226 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1071,13 +1071,16 @@ static int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		ice_put_rx_buf(rx_ring, rx_buf);
 		continue;
 construct_skb:
-		if (skb)
+		if (skb) {
 			ice_add_rx_frag(rx_ring, rx_buf, skb, size);
-		else if (ice_ring_uses_build_skb(rx_ring))
-			skb = ice_build_skb(rx_ring, rx_buf, &xdp);
-		else
+		} else if (likely(xdp.data)) {
+			if (ice_ring_uses_build_skb(rx_ring))
+				skb = ice_build_skb(rx_ring, rx_buf, &xdp);
+			else
+				skb = ice_construct_skb(rx_ring, rx_buf, &xdp);
+		} else {
 			skb = ice_construct_skb(rx_ring, rx_buf, &xdp);
-
+		}
 		/* exit if we failed to retrieve a buffer */
 		if (!skb) {
 			rx_ring->rx_stats.alloc_buf_failed++;
-- 
2.24.1

