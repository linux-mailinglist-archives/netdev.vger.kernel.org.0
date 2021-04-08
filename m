Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3917358B6F
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 19:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbhDHReX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 13:34:23 -0400
Received: from mga18.intel.com ([134.134.136.126]:25282 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232387AbhDHReK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 13:34:10 -0400
IronPort-SDR: JtVK2DoYtK/4mksj49LTTmltYJPJ2DH46fU3szt3phcYwuW6Y4L6Y4lrGC2LcgB4p6FzZAAx3E
 AJ4QjbxsG8ow==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="181132907"
X-IronPort-AV: E=Sophos;i="5.82,207,1613462400"; 
   d="scan'208";a="181132907"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 10:33:57 -0700
IronPort-SDR: sXzD/FmhQRHtErjuAkuc43KbEL9+GG6I7WQrUHcd0evNCxgNiPt7GpnN1riAEg1uGg90TpPyvt
 ffxKDqRWbpNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,207,1613462400"; 
   d="scan'208";a="422343448"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 08 Apr 2021 10:33:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net 2/6] i40e: Fix sparse errors in i40e_txrx.c
Date:   Thu,  8 Apr 2021 10:35:33 -0700
Message-Id: <20210408173537.3519606-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210408173537.3519606-1-anthony.l.nguyen@intel.com>
References: <20210408173537.3519606-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

Remove error handling through pointers. Instead use plain int
to return value from i40e_run_xdp(...).

Previously:
- sparse errors were produced during compilation:
i40e_txrx.c:2338 i40e_run_xdp() error: (-2147483647) too low for ERR_PTR
i40e_txrx.c:2558 i40e_clean_rx_irq() error: 'skb' dereferencing possible ERR_PTR()

- sk_buff* was used to return value, but it has never had valid
pointer to sk_buff. Returned value was always int handled as
a pointer.

Fixes: 0c8493d90b6b ("i40e: add XDP support for pass and drop actions")
Fixes: 2e6893123830 ("i40e: split XDP_TX tail and XDP_REDIRECT map flushing")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 5747a99122fb..06b4271219b1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2295,8 +2295,7 @@ int i40e_xmit_xdp_tx_ring(struct xdp_buff *xdp, struct i40e_ring *xdp_ring)
  * @rx_ring: Rx ring being processed
  * @xdp: XDP buffer containing the frame
  **/
-static struct sk_buff *i40e_run_xdp(struct i40e_ring *rx_ring,
-				    struct xdp_buff *xdp)
+static int i40e_run_xdp(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 {
 	int err, result = I40E_XDP_PASS;
 	struct i40e_ring *xdp_ring;
@@ -2335,7 +2334,7 @@ static struct sk_buff *i40e_run_xdp(struct i40e_ring *rx_ring,
 	}
 xdp_out:
 	rcu_read_unlock();
-	return ERR_PTR(-result);
+	return result;
 }
 
 /**
@@ -2448,6 +2447,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 	unsigned int xdp_xmit = 0;
 	bool failure = false;
 	struct xdp_buff xdp;
+	int xdp_res = 0;
 
 #if (PAGE_SIZE < 8192)
 	frame_sz = i40e_rx_frame_truesize(rx_ring, 0);
@@ -2513,12 +2513,10 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 			/* At larger PAGE_SIZE, frame_sz depend on len size */
 			xdp.frame_sz = i40e_rx_frame_truesize(rx_ring, size);
 #endif
-			skb = i40e_run_xdp(rx_ring, &xdp);
+			xdp_res = i40e_run_xdp(rx_ring, &xdp);
 		}
 
-		if (IS_ERR(skb)) {
-			unsigned int xdp_res = -PTR_ERR(skb);
-
+		if (xdp_res) {
 			if (xdp_res & (I40E_XDP_TX | I40E_XDP_REDIR)) {
 				xdp_xmit |= xdp_res;
 				i40e_rx_buffer_flip(rx_ring, rx_buffer, size);
-- 
2.26.2

