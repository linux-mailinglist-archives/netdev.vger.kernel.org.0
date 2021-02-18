Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E7A31F300
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 00:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbhBRXYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 18:24:52 -0500
Received: from mga12.intel.com ([192.55.52.136]:20043 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229953AbhBRXYu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 18:24:50 -0500
IronPort-SDR: hgNWlfmxxr5ItzeVaAOfjpILBeKZgTgaw/qKK+Bk8fOlA8Zx4nsolGKl2VIkveYxQfkjRXaSXo
 9m6IftPc/8Pw==
X-IronPort-AV: E=McAfee;i="6000,8403,9899"; a="162823064"
X-IronPort-AV: E=Sophos;i="5.81,187,1610438400"; 
   d="scan'208";a="162823064"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2021 15:24:08 -0800
IronPort-SDR: e5UfidQk/5+yJRsCnL/7wEuT5DS2j6BBuQJEsb5w3JwLXyIZsaSkIYJwcjOlb+jnBdIeagIX3y
 Hc0Ro4jZ0lKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,187,1610438400"; 
   d="scan'208";a="581457631"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 18 Feb 2021 15:24:07 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Slawomir Laba <slawomirx.laba@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 1/8] i40e: Fix flow for IPv6 next header (extension header)
Date:   Thu, 18 Feb 2021 15:24:57 -0800
Message-Id: <20210218232504.2422834-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210218232504.2422834-1-anthony.l.nguyen@intel.com>
References: <20210218232504.2422834-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Slawomir Laba <slawomirx.laba@intel.com>

When a packet contains an IPv6 header with next header which is
an extension header and not a protocol one, the kernel function
skb_transport_header called with such sk_buff will return a
pointer to the extension header and not to the TCP one.

The above explained call caused a problem with packet processing
for skb with encapsulation for tunnel with I40E_TX_CTX_EXT_IP_IPV6.
The extension header was not skipped at all.

The ipv6_skip_exthdr function does check if next header of the IPV6
header is an extension header and doesn't modify the l4_proto pointer
if it points to a protocol header value so its safe to omit the
comparison of exthdr and l4.hdr pointers. The ipv6_skip_exthdr can
return value -1. This means that the skipping process failed
and there is something wrong with the packet so it will be dropped.

Fixes: a3fd9d8876a5 ("i40e/i40evf: Handle IPv6 extension headers in checksum offload")
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 4aca637d4a23..32d97315f3f5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -3113,13 +3113,16 @@ static int i40e_tx_enable_csum(struct sk_buff *skb, u32 *tx_flags,
 
 			l4_proto = ip.v4->protocol;
 		} else if (*tx_flags & I40E_TX_FLAGS_IPV6) {
+			int ret;
+
 			tunnel |= I40E_TX_CTX_EXT_IP_IPV6;
 
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

