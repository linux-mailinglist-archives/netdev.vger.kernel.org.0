Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25F3766A53D
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 22:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjAMVmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 16:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjAMVmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 16:42:20 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02103A18F;
        Fri, 13 Jan 2023 13:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673646140; x=1705182140;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FJsgMJetZIOawch957j8RF3IczdC6+QBSdd77xjNRG0=;
  b=DbWcNWxqGch+b49lfs9HlGL+S4MHG3LtMggYapW7vyf6IFpQ55Gyv0aS
   UPicf+TTpp+5MI12Fd8N0Q0kXE+H1p9pQIiKA5OuJ1tqEkNLUxKXuWjdM
   KK7zaUpA0ca+MUYB1N9on6Kwtv8k3U50Ij3I2T4MFmusEfAyj/Nsn8MfR
   /cGSw3NwXolIxEO55mVxBohT+PMsCYinM6/MITWYngwJGRZcPU1dCH26E
   hvurQtqLBnc3IQbKHw5Fu3spwr54tU9Su46oOWUX/ajvR2tUfFnErXA9d
   0kqxXSGFG/U0l7VTTT3R3zRgx5+ka8QGHz3bPNV1IdbOx7FULpVb6O4Ue
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10589"; a="351341458"
X-IronPort-AV: E=Sophos;i="5.97,214,1669104000"; 
   d="scan'208";a="351341458"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2023 13:42:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10589"; a="690629640"
X-IronPort-AV: E=Sophos;i="5.97,214,1669104000"; 
   d="scan'208";a="690629640"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 13 Jan 2023 13:42:19 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org,
        Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH net-next 1/2] ixgbe: XDP: fix checker warning from rcu pointer
Date:   Fri, 13 Jan 2023 13:42:47 -0800
Message-Id: <20230113214248.970670-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230113214248.970670-1-anthony.l.nguyen@intel.com>
References: <20230113214248.970670-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The ixgbe driver uses an older style failure mode when initializing the
XDP program and the queues. It causes some warnings when running C=2
checking builds (and it's the last one in the ethernet/intel tree).

$ make W=1 C=2 M=`pwd`/drivers/net/ethernet/intel modules
.../ixgbe_main.c:10301:25: error: incompatible types in comparison expression (different address spaces):
.../ixgbe_main.c:10301:25:    struct bpf_prog [noderef] __rcu *
.../ixgbe_main.c:10301:25:    struct bpf_prog *

Fix the problem by removing the line that tried to re-xchg "the old_prog
pointer" if there was an error, to make this driver act like the other
drivers which return the error code without "pointer restoration."

Also, update the "copy the pointer" logic to use WRITE_ONCE as many/all
the other drivers do, which required making a change in two separate
functions that write the xdp_prog variable in the ring.

The code here was modeled after the code in i40e/i40e_xdp_setup().

NOTE: Compile-tested only.

CC: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index ab8370c413f3..93699d2ae051 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6647,7 +6647,7 @@ int ixgbe_setup_rx_resources(struct ixgbe_adapter *adapter,
 			     rx_ring->queue_index, ixgbe_rx_napi_id(rx_ring)) < 0)
 		goto err;
 
-	rx_ring->xdp_prog = adapter->xdp_prog;
+	WRITE_ONCE(rx_ring->xdp_prog, adapter->xdp_prog);
 
 	return 0;
 err:
@@ -10297,14 +10297,13 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
 			synchronize_rcu();
 		err = ixgbe_setup_tc(dev, adapter->hw_tcs);
 
-		if (err) {
-			rcu_assign_pointer(adapter->xdp_prog, old_prog);
+		if (err)
 			return -EINVAL;
-		}
 	} else {
-		for (i = 0; i < adapter->num_rx_queues; i++)
-			(void)xchg(&adapter->rx_ring[i]->xdp_prog,
-			    adapter->xdp_prog);
+		for (i = 0; i < adapter->num_rx_queues; i++) {
+			WRITE_ONCE(adapter->rx_ring[i]->xdp_prog,
+				   adapter->xdp_prog);
+		}
 	}
 
 	if (old_prog)
-- 
2.38.1

