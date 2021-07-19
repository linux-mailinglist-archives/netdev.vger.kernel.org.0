Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716173CE5EA
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 18:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348443AbhGSPzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 11:55:38 -0400
Received: from mga17.intel.com ([192.55.52.151]:56128 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242662AbhGSPsN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 11:48:13 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10050"; a="191369964"
X-IronPort-AV: E=Sophos;i="5.84,252,1620716400"; 
   d="scan'208";a="191369964"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2021 09:28:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,252,1620716400"; 
   d="scan'208";a="631955281"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 19 Jul 2021 09:28:47 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Stefan Assmann <sassmann@kpanic.de>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Paolo Abeni <pabeni@redhat.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 1/3] i40e: improve locking of mac_filter_hash
Date:   Mon, 19 Jul 2021 09:31:52 -0700
Message-Id: <20210719163154.986679-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210719163154.986679-1-anthony.l.nguyen@intel.com>
References: <20210719163154.986679-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

i40e_config_vf_promiscuous_mode() calls
i40e_getnum_vf_vsi_vlan_filters() without acquiring the
mac_filter_hash_lock spinlock.

This is unsafe because mac_filter_hash may get altered in another thread
while i40e_getnum_vf_vsi_vlan_filters() traverses the hashes.

Simply adding the spinlock in i40e_getnum_vf_vsi_vlan_filters() is not
possible as it already gets called in i40e_get_vlan_list_sync() with the
spinlock held. Therefore adding a wrapper that acquires the spinlock and
call the correct function where appropriate.

Fixes: 37d318d7805f ("i40e: Remove scheduling while atomic possibility")
Fix-suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 23 ++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index eff0a30790dd..472f56b360b8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1160,12 +1160,12 @@ static int i40e_quiesce_vf_pci(struct i40e_vf *vf)
 }
 
 /**
- * i40e_getnum_vf_vsi_vlan_filters
+ * __i40e_getnum_vf_vsi_vlan_filters
  * @vsi: pointer to the vsi
  *
  * called to get the number of VLANs offloaded on this VF
  **/
-static int i40e_getnum_vf_vsi_vlan_filters(struct i40e_vsi *vsi)
+static int __i40e_getnum_vf_vsi_vlan_filters(struct i40e_vsi *vsi)
 {
 	struct i40e_mac_filter *f;
 	u16 num_vlans = 0, bkt;
@@ -1178,6 +1178,23 @@ static int i40e_getnum_vf_vsi_vlan_filters(struct i40e_vsi *vsi)
 	return num_vlans;
 }
 
+/**
+ * i40e_getnum_vf_vsi_vlan_filters
+ * @vsi: pointer to the vsi
+ *
+ * wrapper for __i40e_getnum_vf_vsi_vlan_filters() with spinlock held
+ **/
+static int i40e_getnum_vf_vsi_vlan_filters(struct i40e_vsi *vsi)
+{
+	int num_vlans;
+
+	spin_lock_bh(&vsi->mac_filter_hash_lock);
+	num_vlans = __i40e_getnum_vf_vsi_vlan_filters(vsi);
+	spin_unlock_bh(&vsi->mac_filter_hash_lock);
+
+	return num_vlans;
+}
+
 /**
  * i40e_get_vlan_list_sync
  * @vsi: pointer to the VSI
@@ -1195,7 +1212,7 @@ static void i40e_get_vlan_list_sync(struct i40e_vsi *vsi, u16 *num_vlans,
 	int bkt;
 
 	spin_lock_bh(&vsi->mac_filter_hash_lock);
-	*num_vlans = i40e_getnum_vf_vsi_vlan_filters(vsi);
+	*num_vlans = __i40e_getnum_vf_vsi_vlan_filters(vsi);
 	*vlan_list = kcalloc(*num_vlans, sizeof(**vlan_list), GFP_ATOMIC);
 	if (!(*vlan_list))
 		goto err;
-- 
2.26.2

