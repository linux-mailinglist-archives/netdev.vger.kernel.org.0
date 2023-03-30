Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241396D0C20
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 19:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbjC3RCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 13:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbjC3RCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 13:02:45 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FA8D33E
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 10:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680195755; x=1711731755;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lVRuippaEnQ9RVoRi4Rs4lhmYTUEZT0Oo5IARlmHcXc=;
  b=E0y37t/lgKQrrkAMh8qol0Rpj5pelCtS5kOgtYc60Q/LMeONsmZMAZUE
   raLHRy+cO8wYHrPiiZOw42quxPxMYiXVZbPAV3xFVKsMqbB8+8rzunRgM
   5kf9LWMbhZ98L6F7JEuk3hdmir0vtXMRuIv5B/2yRz6SlYf/npfy0LtY2
   EgTlF4fCAtDAVmFz/USqH9epqQ/RROfuls/qy0+Zz56jGjLzfufoX+g7R
   L3AAfl1JGywfBJt7hRdY9JOSEcnri9Rft+1gwp6qIjXszCp2VrUHxz5wt
   qkoWVN05gHlpX4IwBykY5/dNfCOZAPg0+/61nrxqwCti2bQJ3dhsLJR7b
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="325180476"
X-IronPort-AV: E=Sophos;i="5.98,305,1673942400"; 
   d="scan'208";a="325180476"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 10:02:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="808730078"
X-IronPort-AV: E=Sophos;i="5.98,305,1673942400"; 
   d="scan'208";a="808730078"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga004.jf.intel.com with ESMTP; 30 Mar 2023 10:02:33 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        anthony.l.nguyen@intel.com,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>
Subject: [PATCH net-next 1/1] i40e: Add support for VF to specify its primary MAC address
Date:   Thu, 30 Mar 2023 10:00:22 -0700
Message-Id: <20230330170022.2503673-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>

Currently in the i40e driver there is no implementation of different
MAC address handling depending on whether it is a legacy or primary.
Introduce new checks for VF to be able to specify its primary MAC
address based on the VIRTCHNL_ETHER_ADDR_PRIMARY type.

Primary MAC address are treated differently compared to legacy
ones in a scenario where:
1. If a unicast MAC is being added and it's specified as
VIRTCHNL_ETHER_ADDR_PRIMARY, then replace the current
default_lan_addr.addr.
2. If a unicast MAC is being deleted and it's type
is specified as VIRTCHNL_ETHER_ADDR_PRIMARY, then zero the
hw_lan_addr.addr.

Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 74 ++++++++++++++++++-
 1 file changed, 70 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 8a4587585acd..be59ba3774e1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2914,6 +2914,72 @@ static inline int i40e_check_vf_permission(struct i40e_vf *vf,
 	return 0;
 }
 
+/**
+ * i40e_vc_ether_addr_type - get type of virtchnl_ether_addr
+ * @vc_ether_addr: used to extract the type
+ **/
+static u8
+i40e_vc_ether_addr_type(struct virtchnl_ether_addr *vc_ether_addr)
+{
+	return vc_ether_addr->type & VIRTCHNL_ETHER_ADDR_TYPE_MASK;
+}
+
+/**
+ * i40e_is_vc_addr_legacy
+ * @vc_ether_addr: VIRTCHNL structure that contains MAC and type
+ *
+ * check if the MAC address is from an older VF
+ **/
+static bool
+i40e_is_vc_addr_legacy(struct virtchnl_ether_addr *vc_ether_addr)
+{
+	return i40e_vc_ether_addr_type(vc_ether_addr) ==
+		VIRTCHNL_ETHER_ADDR_LEGACY;
+}
+
+/**
+ * i40e_is_vc_addr_primary
+ * @vc_ether_addr: VIRTCHNL structure that contains MAC and type
+ *
+ * check if the MAC address is the VF's primary MAC
+ * This function should only be called when the MAC address in
+ * virtchnl_ether_addr is a valid unicast MAC
+ **/
+static bool
+i40e_is_vc_addr_primary(struct virtchnl_ether_addr *vc_ether_addr)
+{
+	return i40e_vc_ether_addr_type(vc_ether_addr) ==
+		VIRTCHNL_ETHER_ADDR_PRIMARY;
+}
+
+/**
+ * i40e_update_vf_mac_addr
+ * @vf: VF to update
+ * @vc_ether_addr: structure from VIRTCHNL with MAC to add
+ *
+ * update the VF's cached hardware MAC if allowed
+ **/
+static void
+i40e_update_vf_mac_addr(struct i40e_vf *vf,
+			struct virtchnl_ether_addr *vc_ether_addr)
+{
+	u8 *mac_addr = vc_ether_addr->addr;
+
+	if (!is_valid_ether_addr(mac_addr))
+		return;
+
+	/* If request to add MAC filter is a primary request update its default
+	 * MAC address with the requested one. If it is a legacy request then
+	 * check if current default is empty if so update the default MAC
+	 */
+	if (i40e_is_vc_addr_primary(vc_ether_addr)) {
+		ether_addr_copy(vf->default_lan_addr.addr, mac_addr);
+	} else if (i40e_is_vc_addr_legacy(vc_ether_addr)) {
+		if (is_zero_ether_addr(vf->default_lan_addr.addr))
+			ether_addr_copy(vf->default_lan_addr.addr, mac_addr);
+	}
+}
+
 /**
  * i40e_vc_add_mac_addr_msg
  * @vf: pointer to the VF info
@@ -2965,11 +3031,8 @@ static int i40e_vc_add_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 				spin_unlock_bh(&vsi->mac_filter_hash_lock);
 				goto error_param;
 			}
-			if (is_valid_ether_addr(al->list[i].addr) &&
-			    is_zero_ether_addr(vf->default_lan_addr.addr))
-				ether_addr_copy(vf->default_lan_addr.addr,
-						al->list[i].addr);
 		}
+		i40e_update_vf_mac_addr(vf, &al->list[i]);
 	}
 	spin_unlock_bh(&vsi->mac_filter_hash_lock);
 
@@ -3032,6 +3095,9 @@ static int i40e_vc_del_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 
 	spin_unlock_bh(&vsi->mac_filter_hash_lock);
 
+	if (was_unimac_deleted)
+		eth_zero_addr(vf->default_lan_addr.addr);
+
 	/* program the updated filter list */
 	ret = i40e_sync_vsi_filters(vsi);
 	if (ret)
-- 
2.38.1

