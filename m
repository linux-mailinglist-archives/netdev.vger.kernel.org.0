Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B46B391E03
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 19:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235242AbhEZRYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 13:24:24 -0400
Received: from mga07.intel.com ([134.134.136.100]:18168 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234443AbhEZRYA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 13:24:00 -0400
IronPort-SDR: OUelDzH6qsIvG+TWjsInmV8LTiUkiJT5QQjlqpJHH9ecrqIhwLP95O8jc4npvDmjWK4y51duaM
 xbGvpOXKt4IA==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="266415791"
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="266415791"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 10:21:27 -0700
IronPort-SDR: Xgy2JGXyhGZdHEMLIwf5DT/GILzSKoYQt7eR3yzjlts0y4ArhHx8CnLhONVFLQqn+wvPA3ltGK
 iiR8qaNehj3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="443149221"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 26 May 2021 10:21:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next 08/11] intel: call csum functions with well formatted arguments
Date:   Wed, 26 May 2021 10:23:43 -0700
Message-Id: <20210526172346.3515587-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210526172346.3515587-1-anthony.l.nguyen@intel.com>
References: <20210526172346.3515587-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The sparse build (C=2) found that there were two drivers
who had not been convered to call the csum_replace_by_diff() function
with sparse clean arguments.  Most if not all drivers force the cast
like this patch does. So these drivers are now joining the party
(a bit late), but with no functional change.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
Warning Detail:
.../igbvf/netdev.c:2059:46: warning: incorrect type in argument 2 (different base types)
.../igbvf/netdev.c:2059:46:    expected restricted __wsum [usertype] diff
.../igbvf/netdev.c:2059:46:    got restricted __be32 [usertype]
.../ixgbevf/ixgbevf_main.c:3817:46: warning: incorrect type in argument 2 (different base types)
.../ixgbevf/ixgbevf_main.c:3817:46:    expected restricted __wsum [usertype] diff
.../ixgbevf/ixgbevf_main.c:3817:46:    got restricted __be32 [usertype]
---
 drivers/net/ethernet/intel/igbvf/netdev.c         | 2 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 630c1155f196..1bbe9862a758 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2056,7 +2056,7 @@ static int igbvf_tso(struct igbvf_ring *tx_ring,
 
 	/* remove payload length from inner checksum */
 	paylen = skb->len - l4_offset;
-	csum_replace_by_diff(&l4.tcp->check, htonl(paylen));
+	csum_replace_by_diff(&l4.tcp->check, (__force __wsum)htonl(paylen));
 
 	/* MSS L4LEN IDX */
 	mss_l4len_idx = (*hdr_len - l4_offset) << E1000_ADVTXD_L4LEN_SHIFT;
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index ba2ed8a43d2d..588c3aa50d94 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -3814,7 +3814,7 @@ static int ixgbevf_tso(struct ixgbevf_ring *tx_ring,
 
 	/* remove payload length from inner checksum */
 	paylen = skb->len - l4_offset;
-	csum_replace_by_diff(&l4.tcp->check, htonl(paylen));
+	csum_replace_by_diff(&l4.tcp->check, (__force __wsum)htonl(paylen));
 
 	/* update gso size and bytecount with header size */
 	first->gso_segs = skb_shinfo(skb)->gso_segs;
-- 
2.26.2

