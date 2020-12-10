Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162852D5008
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 02:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731373AbgLJBEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 20:04:50 -0500
Received: from mga12.intel.com ([192.55.52.136]:15984 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731069AbgLJBEb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 20:04:31 -0500
IronPort-SDR: ZHroS4JpGCmgb23l94i/PZndT2+l9TU2hSbhSrL5VxF3e0PDwSZfwOU5f1uVdezqvL2sxgZMYe
 v0PaIBL2UIBA==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="153414669"
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="153414669"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 17:03:00 -0800
IronPort-SDR: P4MdqiBcGQrStOBsOjCRKafVkE9bTBLnpeJJTVM7msqjKwwR6Xcce4Q4j3uY9Z7i7I4261p33A
 xgp479NTyM6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="338203385"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 09 Dec 2020 17:02:59 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sven Auhagen <sven.auhagen@voleatech.de>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [net 4/9] igb: skb add metasize for xdp
Date:   Wed,  9 Dec 2020 17:02:47 -0800
Message-Id: <20201210010252.4029245-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201210010252.4029245-1-anthony.l.nguyen@intel.com>
References: <20201210010252.4029245-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

add metasize if it is set in xdp

Fixes: 9cbc948b5a20 ("igb: add XDP support")
Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index a0a310a75cc5..8e412aaba0e3 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8357,6 +8357,7 @@ static struct sk_buff *igb_build_skb(struct igb_ring *rx_ring,
 				SKB_DATA_ALIGN(xdp->data_end -
 					       xdp->data_hard_start);
 #endif
+	unsigned int metasize = xdp->data - xdp->data_meta;
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
@@ -8371,6 +8372,9 @@ static struct sk_buff *igb_build_skb(struct igb_ring *rx_ring,
 	skb_reserve(skb, xdp->data - xdp->data_hard_start);
 	__skb_put(skb, xdp->data_end - xdp->data);
 
+	if (metasize)
+		skb_metadata_set(skb, metasize);
+
 	/* pull timestamp out of packet data */
 	if (igb_test_staterr(rx_desc, E1000_RXDADV_STAT_TSIP)) {
 		igb_ptp_rx_pktstamp(rx_ring->q_vector, skb->data, skb);
-- 
2.26.2

