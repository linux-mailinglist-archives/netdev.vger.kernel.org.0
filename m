Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC90B2F6331
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 15:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbhANOeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 09:34:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:24515 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727283AbhANOeG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 09:34:06 -0500
IronPort-SDR: CMNUQsfEPr3dun1n4KGA3Su7I9Bmp6PKMmHEd5ocZDZMnu+wjsl1hy94MiQhgfljs9ddlM176Z
 /QlVASuWW6zg==
X-IronPort-AV: E=McAfee;i="6000,8403,9863"; a="174868367"
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="174868367"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2021 06:33:25 -0800
IronPort-SDR: XZ9ixKMwcx//ZdclZN44goAOdYUsXXNgvPFnMNJnYhsnbZClGVKk6pQaFdlDU/VWGgFwx61c6e
 bZ4dYVjs39EA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="353919548"
Received: from silpixa00400572.ir.intel.com ([10.237.213.34])
  by fmsmga008.fm.intel.com with ESMTP; 14 Jan 2021 06:33:23 -0800
From:   Cristian Dumitrescu <cristian.dumitrescu@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn.topel@intel.com,
        maciej.fijalkowski@intel.com, edwin.verplanke@intel.com,
        cristian.dumitrescu@intel.com
Subject: [PATCH net-next 2/4] i40e: remove unnecessary cleaned_count updates
Date:   Thu, 14 Jan 2021 14:33:16 +0000
Message-Id: <20210114143318.2171-3-cristian.dumitrescu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210114143318.2171-1-cristian.dumitrescu@intel.com>
References: <20210114143318.2171-1-cristian.dumitrescu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For performance reasons, remove the redundant updates of the cleaned_count
variable, as its value can be computed based on the ring next-to-clean
variable, which is consistently udpated.

Signed-off-by: Cristian Dumitrescu <cristian.dumitrescu@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index dc11ecd1a55c..453ef30d9498 100644
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
 			break;
 		}
 
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
2.25.1

