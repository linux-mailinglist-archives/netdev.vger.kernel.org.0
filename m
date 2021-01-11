Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7CC2F1DAD
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 19:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390296AbhAKSMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 13:12:22 -0500
Received: from mga17.intel.com ([192.55.52.151]:35017 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390091AbhAKSMV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 13:12:21 -0500
IronPort-SDR: sdc/Ts50gjU+lJVh0R9YpkeZgbT9JvUlDVjBg/XY8Ow9Smq+bixkD90wT7r99N0RZkkIPJH3Rr
 CrB4hj3yA+gQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9861"; a="157688214"
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="157688214"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 10:11:41 -0800
IronPort-SDR: Mohv5/ZA6vCRs2JGSYialOXSsXTIr3PGlOKUqmaKg4rqZ5SKt70ZpQJ7D1TE4tp58nRx1wKf9i
 ZR5uldA1Sa1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,339,1602572400"; 
   d="scan'208";a="498653463"
Received: from silpixa00400572.ir.intel.com ([10.237.213.34])
  by orsmga004.jf.intel.com with ESMTP; 11 Jan 2021 10:11:39 -0800
From:   Cristian Dumitrescu <cristian.dumitrescu@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn.topel@intel.com,
        maciej.fijalkowski@intel.com, cristian.dumitrescu@intel.com
Subject: [PATCH net] i40e: fix potential NULL pointer dereferencing
Date:   Mon, 11 Jan 2021 18:11:38 +0000
Message-Id: <20210111181138.49757-1-cristian.dumitrescu@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the function i40e_construct_skb_zc only frees the input xdp
buffer when the output skb is successfully built. On error, the
function i40e_clean_rx_irq_zc does not commit anything for the current
packet descriptor and simply exits the packet descriptor processing
loop, with the plan to restart the processing of this descriptor on
the next invocation. Therefore, on error the ring next-to-clean
pointer should not advance, the xdp i.e. *bi buffer should not be
freed and the current buffer info should not be invalidated by setting
*bi to NULL. Therefore, the *bi should only be set to NULL when the
function i40e_construct_skb_zc is successful, otherwise a NULL *bi
will be dereferenced when the work for the current descriptor is
eventually restarted.

Fixes: 3b4f0b66c2b3 ("i40e, xsk: Migrate to new MEM_TYPE_XSK_BUFF_POOL")
Signed-off-by: Cristian Dumitrescu <cristian.dumitrescu@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 47eb9c584a12..492ce213208d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -348,12 +348,12 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 		 * SBP is *not* set in PRT_SBPVSI (default not set).
 		 */
 		skb = i40e_construct_skb_zc(rx_ring, *bi);
-		*bi = NULL;
 		if (!skb) {
 			rx_ring->rx_stats.alloc_buff_failed++;
 			break;
 		}
 
+		*bi = NULL;
 		cleaned_count++;
 		i40e_inc_ntc(rx_ring);
 
-- 
2.25.1

