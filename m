Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88587301168
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 01:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbhAWAL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 19:11:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:38839 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726708AbhAWAAQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 19:00:16 -0500
IronPort-SDR: 2xw1GzKiP9EmACd6JSxI4VU9a1Mi10dAWhv4WI5UZj39C4TEQwAf25sJ2O2fUQFNGMH+t7TCBh
 5OBxAEn5+p0g==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="179670511"
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="179670511"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 15:57:02 -0800
IronPort-SDR: 5VkdfH5p2x+ovr6etyjJnsXLMf8eFHEdlgF7ndMXnc+4nXs9clmdnDTYr+vImElgLrX4o/WH5w
 AV9wPHcSVmng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="428258680"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 22 Jan 2021 15:57:02 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Nick Nunley <nicholas.d.nunley@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 2/7] ice: Implement flow for IPv6 next header (extension header)
Date:   Fri, 22 Jan 2021 15:57:29 -0800
Message-Id: <20210122235734.447240-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122235734.447240-1-anthony.l.nguyen@intel.com>
References: <20210122235734.447240-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nick Nunley <nicholas.d.nunley@intel.com>

This patch is based on a similar change to i40e by Slawomir Laba:
"i40e: Implement flow for IPv6 next header (extension header)".

When a packet contains an IPv6 header with next header which is
an extension header and not a protocol one, the kernel function
skb_transport_header called with such sk_buff will return a
pointer to the extension header and not to the TCP one.

The above explained call caused a problem with packet processing
for skb with encapsulation for tunnel with ICE_TX_CTX_EIPT_IPV6.
The extension header was not skipped at all.

The ipv6_skip_exthdr function does check if next header of the IPV6
header is an extension header and doesn't modify the l4_proto pointer
if it points to a protocol header value so its safe to omit the
comparison of exthdr and l4.hdr pointers. The ipv6_skip_exthdr can
return value -1. This means that the skipping process failed
and there is something wrong with the packet so it will be dropped.

Fixes: a4e82a81f573 ("ice: Add support for tunnel offloads")
Signed-off-by: Nick Nunley <nicholas.d.nunley@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index a2d0aad8cfdd..b6fa83c619dd 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1923,12 +1923,15 @@ int ice_tx_csum(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 				  ICE_TX_CTX_EIPT_IPV4_NO_CSUM;
 			l4_proto = ip.v4->protocol;
 		} else if (first->tx_flags & ICE_TX_FLAGS_IPV6) {
+			int ret;
+
 			tunnel |= ICE_TX_CTX_EIPT_IPV6;
 			exthdr = ip.hdr + sizeof(*ip.v6);
 			l4_proto = ip.v6->nexthdr;
-			if (l4.hdr != exthdr)
-				ipv6_skip_exthdr(skb, exthdr - skb->data,
-						 &l4_proto, &frag_off);
+			ret = ipv6_skip_exthdr(skb, exthdr - skb->data,
+					       &l4_proto, &frag_off);
+			if (ret < 0)
+				return -1;
 		}
 
 		/* define outer transport */
-- 
2.26.2

