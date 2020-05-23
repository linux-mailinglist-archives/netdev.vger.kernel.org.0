Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB48E1DF550
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 08:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387727AbgEWGtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 02:49:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:52994 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387710AbgEWGtE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 02:49:04 -0400
IronPort-SDR: YZeLU5LRDlk41aYQc+814BWIjUFeENcdvEIisFhot34D9JlFR7l+icMMO+0TTbORmXOjPJyKBU
 EGBYJYQ5BDTQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 23:48:51 -0700
IronPort-SDR: PKcLr2FPfYabSl4OHFpAmvJOjLPD8hWCt9wWbPpkLRu7kJ1fJPkAXBpj2pRNBM10Q/Tw3ArW3C
 he2Guwkd7Z9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="374966908"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 22 May 2020 23:48:50 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 12/16] ice: Check if unicast MAC exists before setting VF MAC
Date:   Fri, 22 May 2020 23:48:43 -0700
Message-Id: <20200523064847.3972158-13-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523064847.3972158-1-jeffrey.t.kirsher@intel.com>
References: <20200523064847.3972158-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently if a unicast MAC is set via ndo_set_vf_mac, the PF driver will
set the VF's dflt_lan_addr.addr once some basic checks have passed. The
VF is then reset. During reset the PF driver will attempt to program the
VF's MAC from the dflt_lan_addr.addr field. This fails when the MAC
already exists on the PF's switch.

This is causing the VF to be completely disabled until removing/enabling
any VFs via sysfs.

Fix this by checking if the unicast MAC exists before triggering a VF
reset directly in ndo_set_vf_mac. Also, add a check if the unicast MAC
is set to the same value as before and return 0 if that is the case.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 43 +++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index a12fce73efbc..95e8bca562e5 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -3640,6 +3640,39 @@ ice_get_vf_cfg(struct net_device *netdev, int vf_id, struct ifla_vf_info *ivi)
 	return 0;
 }
 
+/**
+ * ice_unicast_mac_exists - check if the unicast MAC exists on the PF's switch
+ * @pf: PF used to reference the switch's rules
+ * @umac: unicast MAC to compare against existing switch rules
+ *
+ * Return true on the first/any match, else return false
+ */
+static bool ice_unicast_mac_exists(struct ice_pf *pf, u8 *umac)
+{
+	struct ice_sw_recipe *mac_recipe_list =
+		&pf->hw.switch_info->recp_list[ICE_SW_LKUP_MAC];
+	struct ice_fltr_mgmt_list_entry *list_itr;
+	struct list_head *rule_head;
+	struct mutex *rule_lock; /* protect MAC filter list access */
+
+	rule_head = &mac_recipe_list->filt_rules;
+	rule_lock = &mac_recipe_list->filt_rule_lock;
+
+	mutex_lock(rule_lock);
+	list_for_each_entry(list_itr, rule_head, list_entry) {
+		u8 *existing_mac = &list_itr->fltr_info.l_data.mac.mac_addr[0];
+
+		if (ether_addr_equal(existing_mac, umac)) {
+			mutex_unlock(rule_lock);
+			return true;
+		}
+	}
+
+	mutex_unlock(rule_lock);
+
+	return false;
+}
+
 /**
  * ice_set_vf_mac
  * @netdev: network interface device structure
@@ -3663,10 +3696,20 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 	}
 
 	vf = &pf->vf[vf_id];
+	/* nothing left to do, unicast MAC already set */
+	if (ether_addr_equal(vf->dflt_lan_addr.addr, mac))
+		return 0;
+
 	ret = ice_check_vf_ready_for_cfg(vf);
 	if (ret)
 		return ret;
 
+	if (ice_unicast_mac_exists(pf, mac)) {
+		netdev_err(netdev, "Unicast MAC %pM already exists on this PF. Preventing setting VF %u unicast MAC address to %pM\n",
+			   mac, vf_id, mac);
+		return -EINVAL;
+	}
+
 	/* copy MAC into dflt_lan_addr and trigger a VF reset. The reset
 	 * flow will use the updated dflt_lan_addr and add a MAC filter
 	 * using ice_add_mac. Also set pf_set_mac to indicate that the PF has
-- 
2.26.2

