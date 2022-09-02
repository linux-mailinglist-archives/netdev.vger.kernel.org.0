Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43F55AB866
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 20:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiIBSjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 14:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiIBSjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 14:39:02 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB604C00E3
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 11:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662143941; x=1693679941;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K8uXQWlT9OpkLDD4X/WKU1OyJIycvCYBHZU+4tc55C0=;
  b=N9YM2VxtyGLqYxXDKK3yriXDB6aVtmqgM3GSuwnisbvVZvQaxFs88WPU
   iRw23HQespGFdA3jjdiNCIGfRqDeuFkemvfA9JQhcIRyRq/oBfBP+M5MG
   xJumMGApo35vm+uV6MtrYfh2EhrzJhvEzL7rkf8oY2WOR0xCsVvnk8NHW
   2/JIVBUky3xGjYyXFUxYhAsGHEDHD92/Wwt248RLTPKVtVWHWk7i9gXhA
   rzgi+SVa1Jcri19JUOUsDq0MBupr2PMhk3JZHke3kQz0hqWIlrv2vhoB2
   /0KY71s0YPMo5MvVH24223ZEZspEEc2kbywOYx/lS1AQS3nnTiq6hyDEm
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10458"; a="357768800"
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="357768800"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 11:39:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="590170953"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 02 Sep 2022 11:39:00 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Jan Sokolowski <jan.sokolowski@intel.com>,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Subject: [PATCH net 1/3] i40e: Fix ADQ rate limiting for PF
Date:   Fri,  2 Sep 2022 11:38:55 -0700
Message-Id: <20220902183857.1252065-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220902183857.1252065-1-anthony.l.nguyen@intel.com>
References: <20220902183857.1252065-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

Fix HW rate limiting for ADQ.
Fallback to kernel queue selection for ADQ, as it is network stack
that decides which queue to use for transmit with ADQ configured.
Reset PF after creation of VMDq2 VSIs required for ADQ, as to
reprogram TX queue contexts in i40e_configure_tx_ring.
Without this patch PF would limit TX rate only according to TC0.

Fixes: a9ce82f744dc ("i40e: Enable 'channel' mode in mqprio for TC configs")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
Tested-by: Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 3 +++
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 9f1d5de7bf16..10c1e1ea83a1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -6659,6 +6659,9 @@ static int i40e_configure_queue_channels(struct i40e_vsi *vsi)
 			vsi->tc_seid_map[i] = ch->seid;
 		}
 	}
+
+	/* reset to reconfigure TX queue contexts */
+	i40e_do_reset(vsi->back, I40E_PF_RESET_FLAG, true);
 	return ret;
 
 err_free:
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index d4226161a3ef..69e67eb6aea7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -3688,7 +3688,8 @@ u16 i40e_lan_select_queue(struct net_device *netdev,
 	u8 prio;
 
 	/* is DCB enabled at all? */
-	if (vsi->tc_config.numtc == 1)
+	if (vsi->tc_config.numtc == 1 ||
+	    i40e_is_tc_mqprio_enabled(vsi->back))
 		return netdev_pick_tx(netdev, skb, sb_dev);
 
 	prio = skb->priority;
-- 
2.35.1

