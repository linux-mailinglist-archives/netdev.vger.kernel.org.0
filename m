Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70EA56838CA
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 22:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbjAaVhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 16:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbjAaVhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 16:37:16 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015111EFEA
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 13:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675201036; x=1706737036;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BKoVqEuAa92dLzezsyfnqVS7uZjXc1GORseCLZ+Z99U=;
  b=mM7PCMh1UMH7V/0krlmTyaHw4TUcTqVf4zxFOcFw0jhCrDRr9ug58Xi7
   FOjRVPe8nX+Vvp941YqiF/5B5PhKOY967ie5DWnQdjcFplmPevdUD6+ad
   fC5M9pJ8hiVaOjScOXXZv4bEPHdA2cHOOCJb3J1bmUO2k2GCvO5BVWxYq
   QT0eLuBSYUDgeqFQzmkHu+PqH8YwHP7OrFS2IZtOmu7bi19IHXtOzoTZC
   UlSGptK+bSKS5zUXZuIZXz+jk01Q1vVg6p4o37pmob2hqsNOcFUhbXK59
   Xc+Pm3xJByAYNWOjqJicgEYMS5/zYHrvJO8FW0MJZYRcMLhXx67X+iVz6
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="327980303"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="327980303"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 13:37:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="910063018"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="910063018"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga006.fm.intel.com with ESMTP; 31 Jan 2023 13:37:13 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Karen Ostrowska <karen.ostrowska@intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net 4/6] ice: Fix disabling Rx VLAN filtering with port VLAN enabled
Date:   Tue, 31 Jan 2023 13:37:01 -0800
Message-Id: <20230131213703.1347761-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230131213703.1347761-1-anthony.l.nguyen@intel.com>
References: <20230131213703.1347761-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

If the user turns on the vf-true-promiscuous-support flag, then Rx VLAN
filtering will be disabled if the VF requests to enable promiscuous
mode. When the VF is in a port VLAN, this is the incorrect behavior
because it will allow the VF to receive traffic outside of its port VLAN
domain. Fortunately this only resulted in the VF(s) receiving broadcast
traffic outside of the VLAN domain because all of the VLAN promiscuous
rules are based on the port VLAN ID. Fix this by setting the
.disable_rx_filtering VLAN op to a no-op when a port VLAN is enabled on
the VF.

Also, make sure to make this fix for both Single VLAN Mode and Double
VLAN Mode enabled devices.

Fixes: c31af68a1b94 ("ice: Add outer_vlan_ops and VSI specific VLAN ops implementations")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Karen Ostrowska <karen.ostrowska@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c b/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
index 5ecc0ee9a78e..b1ffb81893d4 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
@@ -44,13 +44,17 @@ void ice_vf_vsi_init_vlan_ops(struct ice_vsi *vsi)
 
 		/* outer VLAN ops regardless of port VLAN config */
 		vlan_ops->add_vlan = ice_vsi_add_vlan;
-		vlan_ops->dis_rx_filtering = ice_vsi_dis_rx_vlan_filtering;
 		vlan_ops->ena_tx_filtering = ice_vsi_ena_tx_vlan_filtering;
 		vlan_ops->dis_tx_filtering = ice_vsi_dis_tx_vlan_filtering;
 
 		if (ice_vf_is_port_vlan_ena(vf)) {
 			/* setup outer VLAN ops */
 			vlan_ops->set_port_vlan = ice_vsi_set_outer_port_vlan;
+			/* all Rx traffic should be in the domain of the
+			 * assigned port VLAN, so prevent disabling Rx VLAN
+			 * filtering
+			 */
+			vlan_ops->dis_rx_filtering = noop_vlan;
 			vlan_ops->ena_rx_filtering =
 				ice_vsi_ena_rx_vlan_filtering;
 
@@ -63,6 +67,9 @@ void ice_vf_vsi_init_vlan_ops(struct ice_vsi *vsi)
 			vlan_ops->ena_insertion = ice_vsi_ena_inner_insertion;
 			vlan_ops->dis_insertion = ice_vsi_dis_inner_insertion;
 		} else {
+			vlan_ops->dis_rx_filtering =
+				ice_vsi_dis_rx_vlan_filtering;
+
 			if (!test_bit(ICE_FLAG_VF_VLAN_PRUNING, pf->flags))
 				vlan_ops->ena_rx_filtering = noop_vlan;
 			else
@@ -96,7 +103,14 @@ void ice_vf_vsi_init_vlan_ops(struct ice_vsi *vsi)
 			vlan_ops->set_port_vlan = ice_vsi_set_inner_port_vlan;
 			vlan_ops->ena_rx_filtering =
 				ice_vsi_ena_rx_vlan_filtering;
+			/* all Rx traffic should be in the domain of the
+			 * assigned port VLAN, so prevent disabling Rx VLAN
+			 * filtering
+			 */
+			vlan_ops->dis_rx_filtering = noop_vlan;
 		} else {
+			vlan_ops->dis_rx_filtering =
+				ice_vsi_dis_rx_vlan_filtering;
 			if (!test_bit(ICE_FLAG_VF_VLAN_PRUNING, pf->flags))
 				vlan_ops->ena_rx_filtering = noop_vlan;
 			else
-- 
2.38.1

