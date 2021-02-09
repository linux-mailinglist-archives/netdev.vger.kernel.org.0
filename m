Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514DA314630
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 03:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhBICXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 21:23:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:15909 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230326AbhBICXo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 21:23:44 -0500
IronPort-SDR: WZzYQATZ8dpDpTKsjyX4/9lZRPObsoxUl2LC4OvyglH09S4ygjZkbPTbDwqX/8pbFr4kfP2XYn
 fstIdZdKR9jA==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="181960301"
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="181960301"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 18:22:48 -0800
IronPort-SDR: I4NpIcdbmlFxwrkCwDaOSTdGYQCgsQZgMxRF09DMUcYNVcGSMTS9moty05FFvfA4zQfShgM8Xv
 QyeNf5Xdrqlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="359003694"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 08 Feb 2021 18:22:45 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Cristian Dumitrescu <cristian.dumitrescu@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, bjorn.topel@intel.com,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: [PATCH net-next v2 2/5] i40e: remove unnecessary cleaned_count updates
Date:   Mon,  8 Feb 2021 18:23:20 -0800
Message-Id: <20210209022323.2440775-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210209022323.2440775-1-anthony.l.nguyen@intel.com>
References: <20210209022323.2440775-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cristian Dumitrescu <cristian.dumitrescu@intel.com>

For performance reasons, remove the redundant updates of the cleaned_count
variable, as its value can be computed based on the ring next-to-clean
variable, which is consistently updated.

Signed-off-by: Cristian Dumitrescu <cristian.dumitrescu@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 87d43407653c..99082abd3000 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -300,7 +300,6 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 			bi = i40e_rx_bi(rx_ring, next_to_clean);
 			xsk_buff_free(*bi);
 			*bi = NULL;
-			cleaned_count++;
 			next_to_clean = (next_to_clean + 1) & count_mask;
 			continue;
 		}
@@ -325,7 +324,6 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 			total_rx_bytes += size;
 			total_rx_packets++;
 
-			cleaned_count++;
 			next_to_clean = (next_to_clean + 1) & count_mask;
 			continue;
 		}
@@ -344,7 +342,6 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 		}
 
 		*bi = NULL;
-		cleaned_count++;
 		next_to_clean = (next_to_clean + 1) & count_mask;
 
 		if (eth_skb_pad(skb))
@@ -358,6 +355,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 	}
 
 	rx_ring->next_to_clean = next_to_clean;
+	cleaned_count = (next_to_clean - rx_ring->next_to_use - 1) & count_mask;
 
 	if (cleaned_count >= I40E_RX_BUFFER_WRITE)
 		failure = !i40e_alloc_rx_buffers_zc(rx_ring, cleaned_count);
-- 
2.26.2

