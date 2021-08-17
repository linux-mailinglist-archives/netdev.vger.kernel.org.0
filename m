Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127B83EF421
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 22:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbhHQUek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 16:34:40 -0400
Received: from mga05.intel.com ([192.55.52.43]:6378 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234592AbhHQUej (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 16:34:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10079"; a="301770296"
X-IronPort-AV: E=Sophos;i="5.84,329,1620716400"; 
   d="scan'208";a="301770296"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 13:34:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,329,1620716400"; 
   d="scan'208";a="593506166"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 17 Aug 2021 13:34:05 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Wang Hai <wanghai38@huawei.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net 1/1] ixgbe, xsk: clean up the resources in ixgbe_xsk_pool_enable error path
Date:   Tue, 17 Aug 2021 13:37:36 -0700
Message-Id: <20210817203736.3529939-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

In ixgbe_xsk_pool_enable(), if ixgbe_xsk_wakeup() fails,
We should restore the previous state and clean up the
resources. Add the missing clear af_xdp_zc_qps and unmap dma
to fix this bug.

Fixes: d49e286d354e ("ixgbe: add tracking of AF_XDP zero-copy state for each queue pair")
Fixes: 4a9b32f30f80 ("ixgbe: fix potential RX buffer starvation for AF_XDP")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 96dd1a4f956a..b1d22e4d5ec9 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -52,8 +52,11 @@ static int ixgbe_xsk_pool_enable(struct ixgbe_adapter *adapter,
 
 		/* Kick start the NAPI context so that receiving will start */
 		err = ixgbe_xsk_wakeup(adapter->netdev, qid, XDP_WAKEUP_RX);
-		if (err)
+		if (err) {
+			clear_bit(qid, adapter->af_xdp_zc_qps);
+			xsk_pool_dma_unmap(pool, IXGBE_RX_DMA_ATTR);
 			return err;
+		}
 	}
 
 	return 0;
-- 
2.26.2

