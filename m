Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75E06A3073
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 15:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbjBZOtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 09:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjBZOtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 09:49:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBBE4EC8;
        Sun, 26 Feb 2023 06:47:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E87AB8068F;
        Sun, 26 Feb 2023 14:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C7AC433EF;
        Sun, 26 Feb 2023 14:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422854;
        bh=hTQd1vireLYz9d4rgwOCseeVAN4I/EL5caizAQWdz1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c+nM1z3ghflPjQlYGs17sqVqwPsuvPAFhCYA3eM4/hVFVzAfwg8gLlVqYU9adlmYz
         BflZ5PDE/2hL9aPU1uAmA30x7/WpYFNZzFbNkeqajkn6COElyr9L/Mm/CZpVEWgsc3
         9uvDtt+pzCQ4aRQWWcO0GG5nBeE5mVYcoqi7aVMY1ZICOvE6GToSEKP4+Xf/ti9gFE
         rrpSVYg9UIIHp2R/tOAKZ/WopxokKD3oIcIjhGpHX2T1YVtxId7ajxN1gwLtNYoAkG
         qIJbqAKJVpvJaWvxhlUvib7X6H1QFrzNCe7iyL9zABPXxzGP6fKmWyzQWsRqDDkFOi
         kpn24e4Hj5Bbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 18/49] ice: add missing checks for PF vsi type
Date:   Sun, 26 Feb 2023 09:46:18 -0500
Message-Id: <20230226144650.826470-18-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144650.826470-1-sashal@kernel.org>
References: <20230226144650.826470-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

[ Upstream commit 6a8d013e904ad9a66706fcc926ec9993bed7d190 ]

There were a few places we had missed checking the VSI type to make sure
it was definitely a PF VSI, before calling setup functions intended only
for the PF VSI.

This doesn't fix any explicit bugs but cleans up the code in a few
places and removes one explicit != vsi->type check that can be
superseded by this code (it's a super set)

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 72f97bb50b09c..3c6bb3f9ac780 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6159,15 +6159,12 @@ int ice_vsi_cfg(struct ice_vsi *vsi)
 {
 	int err;
 
-	if (vsi->netdev) {
+	if (vsi->netdev && vsi->type == ICE_VSI_PF) {
 		ice_set_rx_mode(vsi->netdev);
 
-		if (vsi->type != ICE_VSI_LB) {
-			err = ice_vsi_vlan_setup(vsi);
-
-			if (err)
-				return err;
-		}
+		err = ice_vsi_vlan_setup(vsi);
+		if (err)
+			return err;
 	}
 	ice_vsi_cfg_dcb_rings(vsi);
 
@@ -6348,7 +6345,7 @@ static int ice_up_complete(struct ice_vsi *vsi)
 
 	if (vsi->port_info &&
 	    (vsi->port_info->phy.link_info.link_info & ICE_AQ_LINK_UP) &&
-	    vsi->netdev) {
+	    vsi->netdev && vsi->type == ICE_VSI_PF) {
 		ice_print_link_msg(vsi, true);
 		netif_tx_start_all_queues(vsi->netdev);
 		netif_carrier_on(vsi->netdev);
@@ -6360,7 +6357,9 @@ static int ice_up_complete(struct ice_vsi *vsi)
 	 * set the baseline so counters are ready when interface is up
 	 */
 	ice_update_eth_stats(vsi);
-	ice_service_task_schedule(pf);
+
+	if (vsi->type == ICE_VSI_PF)
+		ice_service_task_schedule(pf);
 
 	return 0;
 }
-- 
2.39.0

