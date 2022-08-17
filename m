Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF7575974D8
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 19:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240908AbiHQRNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 13:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241053AbiHQRNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 13:13:43 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2459C23F
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 10:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660756418; x=1692292418;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hSIvXUmnWPwapA03vBhOm8Uccvks1ZvD45FhG4iJqt8=;
  b=Uood2Vk4LSZax4TRLxuIRlaOmPhuqV9n5/eB+HwZhZhGujlWo9gw9X7h
   1xNZeGJAwGfKKDlqZv2iPf83WsxgaC6Nuhv9WazqdJ7kt6q4X+DAXyhNI
   jg63EwXrtal85e+e9/Ta+cU3M3ebn+sleSAWiXgS0RRRgDUNvv+TgzixL
   /6i3p64TzLsQpK8xbdO3RUlyaKnfemYCkR5cv7zBr6iUn2JADlnU0gUA5
   cZKUp61rP68yXXjvU6GYtYQn5VHRNzA8uCToKCcY8BoG4JPYrwQSYNm5d
   QfwKpNrh1uVqXk7JwtfP4SW64RQggC3kMp2+FzRyJe/xOGHg9K9FLA3iA
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="291307369"
X-IronPort-AV: E=Sophos;i="5.93,243,1654585200"; 
   d="scan'208";a="291307369"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 10:13:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,243,1654585200"; 
   d="scan'208";a="558204985"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 17 Aug 2022 10:13:35 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Grzegorz Siwik <grzegorz.siwik@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>,
        Igor Raits <igor@gooddata.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net 3/5] ice: Fix clearing of promisc mode with bridge over bond
Date:   Wed, 17 Aug 2022 10:13:27 -0700
Message-Id: <20220817171329.65285-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220817171329.65285-1-anthony.l.nguyen@intel.com>
References: <20220817171329.65285-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grzegorz Siwik <grzegorz.siwik@intel.com>

When at least two interfaces are bonded and a bridge is enabled on the
bond, an error can occur when the bridge is removed and re-added. The
reason for the error is because promiscuous mode was not fully cleared from
the VLAN VSI in the hardware. With this change, promiscuous mode is
properly removed when the bridge disconnects from bonding.

[ 1033.676359] bond1: link status definitely down for interface enp95s0f0, disabling it
[ 1033.676366] bond1: making interface enp175s0f0 the new active one
[ 1033.676369] device enp95s0f0 left promiscuous mode
[ 1033.676522] device enp175s0f0 entered promiscuous mode
[ 1033.676901] ice 0000:af:00.0 enp175s0f0: Error setting Multicast promiscuous mode on VSI 6
[ 1041.795662] ice 0000:af:00.0 enp175s0f0: Error setting Multicast promiscuous mode on VSI 6
[ 1041.944826] bond1: link status definitely down for interface enp175s0f0, disabling it
[ 1041.944874] device enp175s0f0 left promiscuous mode
[ 1041.944918] bond1: now running without any active interface!

Fixes: c31af68a1b94 ("ice: Add outer_vlan_ops and VSI specific VLAN ops implementations")
Co-developed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Grzegorz Siwik <grzegorz.siwik@intel.com>
Link: https://lore.kernel.org/all/CAK8fFZ7m-KR57M_rYX6xZN39K89O=LGooYkKsu6HKt0Bs+x6xQ@mail.gmail.com/
Tested-by: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Tested-by: Igor Raits <igor@gooddata.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c  |  6 +++++-
 drivers/net/ethernet/intel/ice/ice_main.c | 12 +++++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 0d4dbca88964..733c455f6574 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -4062,7 +4062,11 @@ int ice_vsi_del_vlan_zero(struct ice_vsi *vsi)
 	if (err && err != -EEXIST)
 		return err;
 
-	return 0;
+	/* when deleting the last VLAN filter, make sure to disable the VLAN
+	 * promisc mode so the filter isn't left by accident
+	 */
+	return ice_clear_vsi_promisc(&vsi->back->hw, vsi->idx,
+				    ICE_MCAST_VLAN_PROMISC_BITS, 0);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index eb40526ee179..4ecaf40cf946 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -267,8 +267,10 @@ static int ice_set_promisc(struct ice_vsi *vsi, u8 promisc_m)
 		status = ice_fltr_set_vsi_promisc(&vsi->back->hw, vsi->idx,
 						  promisc_m, 0);
 	}
+	if (status && status != -EEXIST)
+		return status;
 
-	return status;
+	return 0;
 }
 
 /**
@@ -3573,6 +3575,14 @@ ice_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto, u16 vid)
 	while (test_and_set_bit(ICE_CFG_BUSY, vsi->state))
 		usleep_range(1000, 2000);
 
+	ret = ice_clear_vsi_promisc(&vsi->back->hw, vsi->idx,
+				    ICE_MCAST_VLAN_PROMISC_BITS, vid);
+	if (ret) {
+		netdev_err(netdev, "Error clearing multicast promiscuous mode on VSI %i\n",
+			   vsi->vsi_num);
+		vsi->current_netdev_flags |= IFF_ALLMULTI;
+	}
+
 	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
 
 	/* Make sure VLAN delete is successful before updating VLAN
-- 
2.35.1

