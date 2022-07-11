Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB590570DDB
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 01:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbiGKXFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 19:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231955AbiGKXFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 19:05:48 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D24882466
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 16:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657580747; x=1689116747;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y+uvJcs720pKJP1k0lQkfVZXojvr8q/btu3XwKllUwI=;
  b=MXooANdiHkC1wvwLLOfRIuN+x8sGag096dsg3LM1mduFJrAyu+mWw/pu
   ag+gKzmLA9Q+HcL/zWHUBFbrYJ5jF/6qBySGSPPOMmpU0rWRIolV79ABg
   tSczJD1ZRPHNayPXFBm6zrEzbY82nOl0Ys4k+RWSMkLzPnvexJeSKjEMz
   bXZWnscDNn1XuFvVcEA/aGaiqmPxjwerB+nNoJrFrlqJ4GAmcr4ANp7y2
   8+BrbFhtBuIKvsH8pgocp6JOscULBFsP/xc12hgdZeGd/gHESaka2gzMg
   OOogMWC0RRgJ6nFNSxHKBvbiDPCD+78N64+o3TlBrcYhkZZA6pxfi47Wf
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="346473369"
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="346473369"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 16:05:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="599189366"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 11 Jul 2022 16:05:46 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 1/7] iavf: Fix VLAN_V2 addition/rejection
Date:   Mon, 11 Jul 2022 16:02:37 -0700
Message-Id: <20220711230243.3123667-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220711230243.3123667-1-anthony.l.nguyen@intel.com>
References: <20220711230243.3123667-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>

Fix VLAN addition, so that PF driver does not reject whole VLAN batch.
Add VLAN reject handling, so rejected VLANs, won't litter VLAN filter
list. Fix handling of active_(c/s)vlans, so it will be possible to
re-add VLAN filters for user.
Without this patch, after changing trust to off, with VLAN filters
saturated, no VLAN is added, due to PF rejecting addition.

Fixes: 92fc50859872 ("iavf: Restrict maximum VLAN filters for VIRTCHNL_VF_OFFLOAD_VLAN_V2")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h        |  9 ++-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 10 ++-
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 65 ++++++++++++++++++-
 3 files changed, 74 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 49aed3e506a6..86bc61c300a7 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -159,8 +159,12 @@ struct iavf_vlan {
 struct iavf_vlan_filter {
 	struct list_head list;
 	struct iavf_vlan vlan;
-	bool remove;		/* filter needs to be removed */
-	bool add;		/* filter needs to be added */
+	struct {
+		u8 is_new_vlan:1;	/* filter is new, wait for PF answer */
+		u8 remove:1;		/* filter needs to be removed */
+		u8 add:1;		/* filter needs to be added */
+		u8 padding:5;
+	};
 };
 
 #define IAVF_MAX_TRAFFIC_CLASS	4
@@ -520,6 +524,7 @@ int iavf_get_vf_config(struct iavf_adapter *adapter);
 int iavf_get_vf_vlan_v2_caps(struct iavf_adapter *adapter);
 int iavf_send_vf_offload_vlan_v2_msg(struct iavf_adapter *adapter);
 void iavf_set_queue_vlan_tag_loc(struct iavf_adapter *adapter);
+u16 iavf_get_num_vlans_added(struct iavf_adapter *adapter);
 void iavf_irq_enable(struct iavf_adapter *adapter, bool flush);
 void iavf_configure_queues(struct iavf_adapter *adapter);
 void iavf_deconfigure_queues(struct iavf_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index f3ecb3bca33d..2a8643e66331 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -843,7 +843,7 @@ static void iavf_restore_filters(struct iavf_adapter *adapter)
  * iavf_get_num_vlans_added - get number of VLANs added
  * @adapter: board private structure
  */
-static u16 iavf_get_num_vlans_added(struct iavf_adapter *adapter)
+u16 iavf_get_num_vlans_added(struct iavf_adapter *adapter)
 {
 	return bitmap_weight(adapter->vsi.active_cvlans, VLAN_N_VID) +
 		bitmap_weight(adapter->vsi.active_svlans, VLAN_N_VID);
@@ -906,11 +906,6 @@ static int iavf_vlan_rx_add_vid(struct net_device *netdev,
 	if (!iavf_add_vlan(adapter, IAVF_VLAN(vid, be16_to_cpu(proto))))
 		return -ENOMEM;
 
-	if (proto == cpu_to_be16(ETH_P_8021Q))
-		set_bit(vid, adapter->vsi.active_cvlans);
-	else
-		set_bit(vid, adapter->vsi.active_svlans);
-
 	return 0;
 }
 
@@ -2956,6 +2951,9 @@ static void iavf_reset_task(struct work_struct *work)
 	adapter->aq_required |= IAVF_FLAG_AQ_ADD_CLOUD_FILTER;
 	iavf_misc_irq_enable(adapter);
 
+	bitmap_clear(adapter->vsi.active_cvlans, 0, VLAN_N_VID);
+	bitmap_clear(adapter->vsi.active_svlans, 0, VLAN_N_VID);
+
 	mod_delayed_work(iavf_wq, &adapter->watchdog_task, 2);
 
 	/* We were running when the reset started, so we need to restore some
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 782450d5c12f..1603e99bae4a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -626,6 +626,33 @@ static void iavf_mac_add_reject(struct iavf_adapter *adapter)
 	spin_unlock_bh(&adapter->mac_vlan_list_lock);
 }
 
+/**
+ * iavf_vlan_add_reject
+ * @adapter: adapter structure
+ *
+ * Remove VLAN filters from list based on PF response.
+ **/
+static void iavf_vlan_add_reject(struct iavf_adapter *adapter)
+{
+	struct iavf_vlan_filter *f, *ftmp;
+
+	spin_lock_bh(&adapter->mac_vlan_list_lock);
+	list_for_each_entry_safe(f, ftmp, &adapter->vlan_filter_list, list) {
+		if (f->is_new_vlan) {
+			if (f->vlan.tpid == ETH_P_8021Q)
+				clear_bit(f->vlan.vid,
+					  adapter->vsi.active_cvlans);
+			else
+				clear_bit(f->vlan.vid,
+					  adapter->vsi.active_svlans);
+
+			list_del(&f->list);
+			kfree(f);
+		}
+	}
+	spin_unlock_bh(&adapter->mac_vlan_list_lock);
+}
+
 /**
  * iavf_add_vlans
  * @adapter: adapter structure
@@ -683,6 +710,7 @@ void iavf_add_vlans(struct iavf_adapter *adapter)
 				vvfl->vlan_id[i] = f->vlan.vid;
 				i++;
 				f->add = false;
+				f->is_new_vlan = true;
 				if (i == count)
 					break;
 			}
@@ -695,10 +723,18 @@ void iavf_add_vlans(struct iavf_adapter *adapter)
 		iavf_send_pf_msg(adapter, VIRTCHNL_OP_ADD_VLAN, (u8 *)vvfl, len);
 		kfree(vvfl);
 	} else {
+		u16 max_vlans = adapter->vlan_v2_caps.filtering.max_filters;
+		u16 current_vlans = iavf_get_num_vlans_added(adapter);
 		struct virtchnl_vlan_filter_list_v2 *vvfl_v2;
 
 		adapter->current_op = VIRTCHNL_OP_ADD_VLAN_V2;
 
+		if ((count + current_vlans) > max_vlans &&
+		    current_vlans < max_vlans) {
+			count = max_vlans - iavf_get_num_vlans_added(adapter);
+			more = true;
+		}
+
 		len = sizeof(*vvfl_v2) + ((count - 1) *
 					  sizeof(struct virtchnl_vlan_filter));
 		if (len > IAVF_MAX_AQ_BUF_SIZE) {
@@ -725,6 +761,9 @@ void iavf_add_vlans(struct iavf_adapter *adapter)
 					&adapter->vlan_v2_caps.filtering.filtering_support;
 				struct virtchnl_vlan *vlan;
 
+				if (i == count)
+					break;
+
 				/* give priority over outer if it's enabled */
 				if (filtering_support->outer)
 					vlan = &vvfl_v2->filters[i].outer;
@@ -736,8 +775,7 @@ void iavf_add_vlans(struct iavf_adapter *adapter)
 
 				i++;
 				f->add = false;
-				if (i == count)
-					break;
+				f->is_new_vlan = true;
 			}
 		}
 
@@ -2080,6 +2118,11 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 			 */
 			iavf_netdev_features_vlan_strip_set(netdev, true);
 			break;
+		case VIRTCHNL_OP_ADD_VLAN_V2:
+			iavf_vlan_add_reject(adapter);
+			dev_warn(&adapter->pdev->dev, "Failed to add VLAN filter, error %s\n",
+				 iavf_stat_str(&adapter->hw, v_retval));
+			break;
 		default:
 			dev_err(&adapter->pdev->dev, "PF returned error %d (%s) to our request %d\n",
 				v_retval, iavf_stat_str(&adapter->hw, v_retval),
@@ -2332,6 +2375,24 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		spin_unlock_bh(&adapter->adv_rss_lock);
 		}
 		break;
+	case VIRTCHNL_OP_ADD_VLAN_V2: {
+		struct iavf_vlan_filter *f;
+
+		spin_lock_bh(&adapter->mac_vlan_list_lock);
+		list_for_each_entry(f, &adapter->vlan_filter_list, list) {
+			if (f->is_new_vlan) {
+				f->is_new_vlan = false;
+				if (f->vlan.tpid == ETH_P_8021Q)
+					set_bit(f->vlan.vid,
+						adapter->vsi.active_cvlans);
+				else
+					set_bit(f->vlan.vid,
+						adapter->vsi.active_svlans);
+			}
+		}
+		spin_unlock_bh(&adapter->mac_vlan_list_lock);
+		}
+		break;
 	case VIRTCHNL_OP_ENABLE_VLAN_STRIPPING:
 		/* PF enabled vlan strip on this VF.
 		 * Update netdev->features if needed to be in sync with ethtool.
-- 
2.35.1

