Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8957047612A
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 19:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344063AbhLOSzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 13:55:18 -0500
Received: from mga18.intel.com ([134.134.136.126]:23972 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344074AbhLOSyz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 13:54:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639594495; x=1671130495;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=794rMP6XQgkpRCYu52Qd7FPD5/Tny6GuDnO5b78YSWA=;
  b=ksv0UHo2PSuXdzcxsJcgkj7rKMnOciVd3ky4GZdmrJ1sWVf1CYH2DsWz
   Zu+D81MIL5QtmXEdhhg9Yuv/g36wxLIDMEcCgYfuvTo2iu8Yh84CfPhVd
   EeGS6jepT3lOkTat8x+b2e1pGD0DEPp40HaV88VdZLXvoPZ+D4dr28GDT
   62i8J94rC3ykL7I676cTs21UnIABj0xG7JvHl5WMfBiEkE0uoj65x1Ei2
   TSLtO3Dv91WSqh3/Nfk3UV7Z5gPByfRCThShcaDy0PycT4akU0m9F1XMg
   cAl5rYapDHxPE1hemmZdfT0+nRvApBaC8Uekn1U5hjU/AMxpnOEpMO2bh
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="226169616"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="226169616"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 10:54:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="465729959"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 15 Dec 2021 10:54:54 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 9/9] ice: use modern kernel API for kick
Date:   Wed, 15 Dec 2021 10:53:55 -0800
Message-Id: <20211215185355.3249738-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211215185355.3249738-1-anthony.l.nguyen@intel.com>
References: <20211215185355.3249738-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The kernel gained a new interface for drivers to use to combine tail
bump (doorbell) and BQL updates, attempt to use those new interfaces.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index de9247d45c39..3987a0dd0e11 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1576,6 +1576,7 @@ ice_tx_map(struct ice_tx_ring *tx_ring, struct ice_tx_buf *first,
 	struct sk_buff *skb;
 	skb_frag_t *frag;
 	dma_addr_t dma;
+	bool kick;
 
 	td_tag = off->td_l2tag1;
 	td_cmd = off->td_cmd;
@@ -1657,9 +1658,6 @@ ice_tx_map(struct ice_tx_ring *tx_ring, struct ice_tx_buf *first,
 		tx_buf = &tx_ring->tx_buf[i];
 	}
 
-	/* record bytecount for BQL */
-	netdev_tx_sent_queue(txring_txq(tx_ring), first->bytecount);
-
 	/* record SW timestamp if HW timestamp is not available */
 	skb_tx_timestamp(first->skb);
 
@@ -1688,7 +1686,10 @@ ice_tx_map(struct ice_tx_ring *tx_ring, struct ice_tx_buf *first,
 	ice_maybe_stop_tx(tx_ring, DESC_NEEDED);
 
 	/* notify HW of packet */
-	if (netif_xmit_stopped(txring_txq(tx_ring)) || !netdev_xmit_more())
+	kick = __netdev_tx_sent_queue(txring_txq(tx_ring), first->bytecount,
+				      netdev_xmit_more());
+	if (kick)
+		/* notify HW of packet */
 		writel(i, tx_ring->tail);
 
 	return;
-- 
2.31.1

