Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 126E4508E71
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 19:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381092AbiDTRcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 13:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381094AbiDTRcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 13:32:03 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E939E46B0F;
        Wed, 20 Apr 2022 10:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650475756; x=1682011756;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=okP95UrQIanvdcD+EtP4ivdyN/wVqj7tuFHBGJdRWnE=;
  b=QCEIzdAnqZ0Cw9Y5/ThwB+1PZjC/vwju1Yqxys/XlUeQfNex7XtsJCgM
   ow0o7rhanyPn3KjZ/Ebgj062z0JJq5Kp5fTtAvC2tEGGHaOjqCDyN4yBy
   87ZU1oMfMYMK3nKBcDUQ0mbF66lrLcZMgZS3y0uo+zx7ndd5TCscYEhKA
   Zjbg1iBRgDXsRj2nWkWnGVuSqkWIMgyAvhTDfeydrn+tx22F/QuEcMNDy
   Lr3Htwq3JOR2nfduBXGerMuoy8P7rfVDfY6KaTap72CL5RhhsxMDjcKgS
   oNfAYKir6f3Y51mj/h+DHAsC0tU/haK0maYksM/5HHZftICmd6V6/AONa
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="244037004"
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="244037004"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 10:29:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="727594578"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 20 Apr 2022 10:29:15 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Xiaomeng Tong <xiam0nd.tong@gmail.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        stable@vger.kernel.org, Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net 2/2] i40e: i40e_main: fix a missing check on list iterator
Date:   Wed, 20 Apr 2022 10:26:24 -0700
Message-Id: <20220420172624.931237-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220420172624.931237-1-anthony.l.nguyen@intel.com>
References: <20220420172624.931237-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

The bug is here:
	ret = i40e_add_macvlan_filter(hw, ch->seid, vdev->dev_addr, &aq_err);

The list iterator 'ch' will point to a bogus position containing
HEAD if the list is empty or no element is found. This case must
be checked before any use of the iterator, otherwise it will
lead to a invalid memory access.

To fix this bug, use a new variable 'iter' as the list iterator,
while use the origin variable 'ch' as a dedicated pointer to
point to the found element.

Cc: stable@vger.kernel.org
Fixes: 1d8d80b4e4ff6 ("i40e: Add macvlan support on i40e")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 27 +++++++++++----------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 6778df2177a1..98871f014994 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -7549,42 +7549,43 @@ static void i40e_free_macvlan_channels(struct i40e_vsi *vsi)
 static int i40e_fwd_ring_up(struct i40e_vsi *vsi, struct net_device *vdev,
 			    struct i40e_fwd_adapter *fwd)
 {
+	struct i40e_channel *ch = NULL, *ch_tmp, *iter;
 	int ret = 0, num_tc = 1,  i, aq_err;
-	struct i40e_channel *ch, *ch_tmp;
 	struct i40e_pf *pf = vsi->back;
 	struct i40e_hw *hw = &pf->hw;
 
-	if (list_empty(&vsi->macvlan_list))
-		return -EINVAL;
-
 	/* Go through the list and find an available channel */
-	list_for_each_entry_safe(ch, ch_tmp, &vsi->macvlan_list, list) {
-		if (!i40e_is_channel_macvlan(ch)) {
-			ch->fwd = fwd;
+	list_for_each_entry_safe(iter, ch_tmp, &vsi->macvlan_list, list) {
+		if (!i40e_is_channel_macvlan(iter)) {
+			iter->fwd = fwd;
 			/* record configuration for macvlan interface in vdev */
 			for (i = 0; i < num_tc; i++)
 				netdev_bind_sb_channel_queue(vsi->netdev, vdev,
 							     i,
-							     ch->num_queue_pairs,
-							     ch->base_queue);
-			for (i = 0; i < ch->num_queue_pairs; i++) {
+							     iter->num_queue_pairs,
+							     iter->base_queue);
+			for (i = 0; i < iter->num_queue_pairs; i++) {
 				struct i40e_ring *tx_ring, *rx_ring;
 				u16 pf_q;
 
-				pf_q = ch->base_queue + i;
+				pf_q = iter->base_queue + i;
 
 				/* Get to TX ring ptr */
 				tx_ring = vsi->tx_rings[pf_q];
-				tx_ring->ch = ch;
+				tx_ring->ch = iter;
 
 				/* Get the RX ring ptr */
 				rx_ring = vsi->rx_rings[pf_q];
-				rx_ring->ch = ch;
+				rx_ring->ch = iter;
 			}
+			ch = iter;
 			break;
 		}
 	}
 
+	if (!ch)
+		return -EINVAL;
+
 	/* Guarantee all rings are updated before we update the
 	 * MAC address filter.
 	 */
-- 
2.31.1

