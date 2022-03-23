Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7ABD4E526A
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 13:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243025AbiCWMrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 08:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234222AbiCWMrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 08:47:16 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 902E974869;
        Wed, 23 Mar 2022 05:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648039546; x=1679575546;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9mVo7bXFbAAHL9O6QO4mkMly0Aqh3J8U1adWdVJYqXY=;
  b=GITcGJmTQbdON68QB9adinpcJ82KbSNvabW1/wRz+yW0OfGRV2DRnkzR
   ApP1OmhA9Ge6qHl3NP6Aw3WXdI7LtexpxLH2LwpB7jBPNP6iM25br04MZ
   pP1pNoAvxsHFwg+uaj1c6/yHxN2ntAEbpXhYxqkBacmccmCabuA+/zKxi
   +0R8PSLvg3MFhUoEFIpWUEljLQH7JlNAqLVfzA+3qeE0UZVIek2LEYehb
   Tx+Z72T6qIhwnAy8EQIGaxoWtjapJgXVGN9N9C7zFn4JxwT6G4HgPhWQK
   1bAryxsQvPnoku9tPavTLB/UOeOlMymyWUe9rfN3x0P4nP4lddYD2WGJs
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="258288957"
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="258288957"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 05:45:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="717385706"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 23 Mar 2022 05:45:43 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 22NCjeuD017350;
        Wed, 23 Mar 2022 12:45:41 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH net 1/2] ice: fix 'scheduling while atomic' on aux critical err interrupt
Date:   Wed, 23 Mar 2022 13:43:52 +0100
Message-Id: <20220323124353.2762181-2-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220323124353.2762181-1-alexandr.lobakin@intel.com>
References: <20220323124353.2762181-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a kernel BUG splat on processing aux critical error
interrupts in ice_misc_intr():

[ 2100.917085] BUG: scheduling while atomic: swapper/15/0/0x00010000
...
[ 2101.060770] Call Trace:
[ 2101.063229]  <IRQ>
[ 2101.065252]  dump_stack+0x41/0x60
[ 2101.068587]  __schedule_bug.cold.100+0x4c/0x58
[ 2101.073060]  __schedule+0x6a4/0x830
[ 2101.076570]  schedule+0x35/0xa0
[ 2101.079727]  schedule_preempt_disabled+0xa/0x10
[ 2101.084284]  __mutex_lock.isra.7+0x310/0x420
[ 2101.088580]  ? ice_misc_intr+0x201/0x2e0 [ice]
[ 2101.093078]  ice_send_event_to_aux+0x25/0x70 [ice]
[ 2101.097921]  ice_misc_intr+0x220/0x2e0 [ice]
[ 2101.102232]  __handle_irq_event_percpu+0x40/0x180
[ 2101.106965]  handle_irq_event_percpu+0x30/0x80
[ 2101.111434]  handle_irq_event+0x36/0x53
[ 2101.115292]  handle_edge_irq+0x82/0x190
[ 2101.119148]  handle_irq+0x1c/0x30
[ 2101.122480]  do_IRQ+0x49/0xd0
[ 2101.125465]  common_interrupt+0xf/0xf
[ 2101.129146]  </IRQ>
...

As Andrew correctly mentioned previously[0], the following call
ladder happens:

ice_misc_intr() <- hardirq
  ice_send_event_to_aux()
    device_lock()
      mutex_lock()
        might_sleep()
          might_resched() <- oops

Add a new PF state bit which indicates that an aux critical error
occurred and serve it in ice_service_task() in process context.
The new ice_pf::oicr_err_reg is read-write in both hardirq and
process contexts, but only 3 bits of non-critical data probably
aren't worth explicit synchronizing (and they're even in the same
byte [31:24]).

[0] https://lore.kernel.org/all/YeSRUVmrdmlUXHDn@lunn.ch

Fixes: 348048e724a0e ("ice: Implement iidc operations")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Tested-by: Michal Kubiak <michal.kubiak@intel.com>
Acked-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      |  2 ++
 drivers/net/ethernet/intel/ice/ice_main.c | 25 ++++++++++++++---------
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index bea1d1e39fa2..2ca887076dd4 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -290,6 +290,7 @@ enum ice_pf_state {
 	ICE_LINK_DEFAULT_OVERRIDE_PENDING,
 	ICE_PHY_INIT_COMPLETE,
 	ICE_FD_VF_FLUSH_CTX,		/* set at FD Rx IRQ or timeout */
+	ICE_AUX_ERR_PENDING,
 	ICE_STATE_NBITS		/* must be last */
 };
 
@@ -559,6 +560,7 @@ struct ice_pf {
 	wait_queue_head_t reset_wait_queue;
 
 	u32 hw_csum_rx_error;
+	u32 oicr_err_reg;
 	u16 oicr_idx;		/* Other interrupt cause MSIX vector index */
 	u16 num_avail_sw_msix;	/* remaining MSIX SW vectors left unclaimed */
 	u16 max_pf_txqs;	/* Total Tx queues PF wide */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index b7e8744b0c0a..296f9d5f7408 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2255,6 +2255,19 @@ static void ice_service_task(struct work_struct *work)
 		return;
 	}
 
+	if (test_and_clear_bit(ICE_AUX_ERR_PENDING, pf->state)) {
+		struct iidc_event *event;
+
+		event = kzalloc(sizeof(*event), GFP_KERNEL);
+		if (event) {
+			set_bit(IIDC_EVENT_CRIT_ERR, event->type);
+			/* report the entire OICR value to AUX driver */
+			swap(event->reg, pf->oicr_err_reg);
+			ice_send_event_to_aux(pf, event);
+			kfree(event);
+		}
+	}
+
 	if (test_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags)) {
 		/* Plug aux device per request */
 		ice_plug_aux_dev(pf);
@@ -3041,17 +3054,9 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 
 #define ICE_AUX_CRIT_ERR (PFINT_OICR_PE_CRITERR_M | PFINT_OICR_HMC_ERR_M | PFINT_OICR_PE_PUSH_M)
 	if (oicr & ICE_AUX_CRIT_ERR) {
-		struct iidc_event *event;
-
+		pf->oicr_err_reg |= oicr;
+		set_bit(ICE_AUX_ERR_PENDING, pf->state);
 		ena_mask &= ~ICE_AUX_CRIT_ERR;
-		event = kzalloc(sizeof(*event), GFP_ATOMIC);
-		if (event) {
-			set_bit(IIDC_EVENT_CRIT_ERR, event->type);
-			/* report the entire OICR value to AUX driver */
-			event->reg = oicr;
-			ice_send_event_to_aux(pf, event);
-			kfree(event);
-		}
 	}
 
 	/* Report any remaining unexpected interrupts */
-- 
2.35.1

