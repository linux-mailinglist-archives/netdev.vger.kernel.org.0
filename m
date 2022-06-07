Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96C65413D4
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 22:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354936AbiFGUHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 16:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358917AbiFGUFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 16:05:53 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4C81C4210
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 11:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654626351; x=1686162351;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5ZTuqIPtxMDeCPRQVz6YZIvr4rCjdILX9LPRpRd7TiY=;
  b=MrRTmGr4t/89mngFdtC1T4xzJcDNv2lOxZ9brB5aHiCSPLToj7XAmXRE
   /bDxtsir/FAFAwnjtDAayskpYdv3uKEJpxSVSwmxcLqQr7sEVINe58zyf
   F2/ou1o1V7cXpVrQ7+p+9I8PIiujGOoEXLboRqWwgmCxRzF9Ss0vmT3bG
   J6ifFHQcoViW6ZUzB7mItcbVTvlV4LutIdozIdVvYUIn77a4TmU6zMlpp
   fvdrH8TwK7vIM6E5kho3PTG7emSQ2SlqEsXGAvIahS7jg46c642tK3s5x
   ip0mORa/i2pmNJXTTkwaB75Q3wBFl7MJZbYk+mYvjijQMmVRtvmYwoI+y
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="340629546"
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="340629546"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 10:58:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="579699391"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 07 Jun 2022 10:58:11 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next v2 1/2] i40e: Add VF VLAN pruning
Date:   Tue,  7 Jun 2022 10:55:05 -0700
Message-Id: <20220607175506.696671-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175506.696671-1-anthony.l.nguyen@intel.com>
References: <20220607175506.696671-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

VFs by default are able to see all tagged traffic regardless of trust
and VLAN filters configured.

Add new private flag vf-vlan-pruning that allows changing of default
VF behavior for tagged traffic. When the flag is turned on
untrusted VF will only be able to receive untagged traffic
or traffic with VLAN tags it has created interfaces for

The flag is off by default and can only be changed if
there are no VFs spawned on the PF. This flag will only be effective
when no PVID is set on VF and VF is not trusted.
Add new function that computes the correct VLAN ID for VF VLAN filters
based on trust, PVID, vf-vlan-prune-disable flag and current VLAN ID.

Testing Hints:

Test 1: vf-vlan-pruning == off
==============================
1. Set the private flag
> ethtool --set-priv-flag eth0 vf-vlan-pruning off (default setting)
2. Use scapy to send any VLAN tagged traffic and make sure the VF
receives all VLAN tagged traffic that matches its destination MAC
filters (unicast, multicast, and broadcast).

Test 2: vf-vlan-pruning == on
==============================
1. Set the private flag
> ethtool --set-priv-flag eth0 vf-vlan-pruning on
2. Use scapy to send any VLAN tagged traffic and make sure the VF does
not receive any VLAN tagged traffic that matches its destination MAC
filters (unicast, multicast, and broadcast).
3. Add a VLAN filter on the VF netdev
> ip link add link eth0v0 name vlan10 type vlan id 10
4. Bring the VLAN netdev up
> ip link set vlan10 up
4. Use scapy to send traffic with VLAN 10, VLAN 11 (anything not VLAN
10), and untagged traffic. Make sure the VF only receives VLAN 10
and untagged traffic when the link partner is sending.

Test 3: vf-vlan-pruning == off && VF is in a port VLAN
==============================
1. Set the private flag
> ethtool --set-priv-flag eth0 vf-vlan-pruning off (default setting)
2. Create a VF
> echo 1 > sriov_numvfs
3. Put the VF in a port VLAN
> ip link set eth0 vf 0 vlan 10
4. Use scapy to send traffic with VLAN 10 and VLAN 11 (anything not VLAN
10) and make sure the VF only receives untagged traffic when the link
partner is sending VLAN 10 tagged traffic as the VLAN tag is expected
to be stripped by HW for port VLANs and not visible to the VF.

Test 4: Change vf-vlan-pruning while VFs are created
==============================
echo 0 > sriov_numvfs
ethtool --set-priv-flag eth0 vf-vlan-pruning off
echo 1 > sriov_numvfs
ethtool --set-priv-flag eth0 vf-vlan-pruning on (expect failure)

Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h        |   1 +
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |   9 ++
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 135 +++++++++++++++++-
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    |   8 +-
 4 files changed, 147 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 18558a019353..57f4ec4f8d2f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -565,6 +565,7 @@ struct i40e_pf {
 #define I40E_FLAG_DISABLE_FW_LLDP		BIT(24)
 #define I40E_FLAG_RS_FEC			BIT(25)
 #define I40E_FLAG_BASE_R_FEC			BIT(26)
+#define I40E_FLAG_VF_VLAN_PRUNING		BIT(27)
 /* TOTAL_PORT_SHUTDOWN
  * Allows to physically disable the link on the NIC's port.
  * If enabled, (after link down request from the OS)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 610f00cbaff9..c65e9e2dcb42 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -457,6 +457,8 @@ static const struct i40e_priv_flags i40e_gstrings_priv_flags[] = {
 	I40E_PRIV_FLAG("disable-fw-lldp", I40E_FLAG_DISABLE_FW_LLDP, 0),
 	I40E_PRIV_FLAG("rs-fec", I40E_FLAG_RS_FEC, 0),
 	I40E_PRIV_FLAG("base-r-fec", I40E_FLAG_BASE_R_FEC, 0),
+	I40E_PRIV_FLAG("vf-vlan-pruning",
+		       I40E_FLAG_VF_VLAN_PRUNING, 0),
 };
 
 #define I40E_PRIV_FLAGS_STR_LEN ARRAY_SIZE(i40e_gstrings_priv_flags)
@@ -5285,6 +5287,13 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 		return -EOPNOTSUPP;
 	}
 
+	if ((changed_flags & I40E_FLAG_VF_VLAN_PRUNING) &&
+	    pf->num_alloc_vfs) {
+		dev_warn(&pf->pdev->dev,
+			 "Changing vf-vlan-pruning flag while VF(s) are active is not supported\n");
+		return -EOPNOTSUPP;
+	}
+
 	if ((changed_flags & new_flags &
 	     I40E_FLAG_LINK_DOWN_ON_CLOSE_ENABLED) &&
 	    (new_flags & I40E_FLAG_MFP_ENABLED))
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 332a608dbaa6..1599ac538e7f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -1368,6 +1368,114 @@ static int i40e_correct_mac_vlan_filters(struct i40e_vsi *vsi,
 	return 0;
 }
 
+/**
+ * i40e_get_vf_new_vlan - Get new vlan id on a vf
+ * @vsi: the vsi to configure
+ * @new_mac: new mac filter to be added
+ * @f: existing mac filter, replaced with new_mac->f if new_mac is not NULL
+ * @vlan_filters: the number of active VLAN filters
+ * @trusted: flag if the VF is trusted
+ *
+ * Get new VLAN id based on current VLAN filters, trust, PVID
+ * and vf-vlan-prune-disable flag.
+ *
+ * Returns the value of the new vlan filter or
+ * the old value if no new filter is needed.
+ */
+static s16 i40e_get_vf_new_vlan(struct i40e_vsi *vsi,
+				struct i40e_new_mac_filter *new_mac,
+				struct i40e_mac_filter *f,
+				int vlan_filters,
+				bool trusted)
+{
+	s16 pvid = le16_to_cpu(vsi->info.pvid);
+	struct i40e_pf *pf = vsi->back;
+	bool is_any;
+
+	if (new_mac)
+		f = new_mac->f;
+
+	if (pvid && f->vlan != pvid)
+		return pvid;
+
+	is_any = (trusted ||
+		  !(pf->flags & I40E_FLAG_VF_VLAN_PRUNING));
+
+	if ((vlan_filters && f->vlan == I40E_VLAN_ANY) ||
+	    (!is_any && !vlan_filters && f->vlan == I40E_VLAN_ANY) ||
+	    (is_any && !vlan_filters && f->vlan == 0)) {
+		if (is_any)
+			return I40E_VLAN_ANY;
+		else
+			return 0;
+	}
+
+	return f->vlan;
+}
+
+/**
+ * i40e_correct_vf_mac_vlan_filters - Correct non-VLAN VF filters if necessary
+ * @vsi: the vsi to configure
+ * @tmp_add_list: list of filters ready to be added
+ * @tmp_del_list: list of filters ready to be deleted
+ * @vlan_filters: the number of active VLAN filters
+ * @trusted: flag if the VF is trusted
+ *
+ * Correct VF VLAN filters based on current VLAN filters, trust, PVID
+ * and vf-vlan-prune-disable flag.
+ *
+ * In case of memory allocation failure return -ENOMEM. Otherwise, return 0.
+ *
+ * This function is only expected to be called from within
+ * i40e_sync_vsi_filters.
+ *
+ * NOTE: This function expects to be called while under the
+ * mac_filter_hash_lock
+ */
+static int i40e_correct_vf_mac_vlan_filters(struct i40e_vsi *vsi,
+					    struct hlist_head *tmp_add_list,
+					    struct hlist_head *tmp_del_list,
+					    int vlan_filters,
+					    bool trusted)
+{
+	struct i40e_mac_filter *f, *add_head;
+	struct i40e_new_mac_filter *new_mac;
+	struct hlist_node *h;
+	int bkt, new_vlan;
+
+	hlist_for_each_entry(new_mac, tmp_add_list, hlist) {
+		new_mac->f->vlan = i40e_get_vf_new_vlan(vsi, new_mac, NULL,
+							vlan_filters, trusted);
+	}
+
+	hash_for_each_safe(vsi->mac_filter_hash, bkt, h, f, hlist) {
+		new_vlan = i40e_get_vf_new_vlan(vsi, NULL, f, vlan_filters,
+						trusted);
+		if (new_vlan != f->vlan) {
+			add_head = i40e_add_filter(vsi, f->macaddr, new_vlan);
+			if (!add_head)
+				return -ENOMEM;
+			/* Create a temporary i40e_new_mac_filter */
+			new_mac = kzalloc(sizeof(*new_mac), GFP_ATOMIC);
+			if (!new_mac)
+				return -ENOMEM;
+			new_mac->f = add_head;
+			new_mac->state = add_head->state;
+
+			/* Add the new filter to the tmp list */
+			hlist_add_head(&new_mac->hlist, tmp_add_list);
+
+			/* Put the original filter into the delete list */
+			f->state = I40E_FILTER_REMOVE;
+			hash_del(&f->hlist);
+			hlist_add_head(&f->hlist, tmp_del_list);
+		}
+	}
+
+	vsi->has_vlan_filter = !!vlan_filters;
+	return 0;
+}
+
 /**
  * i40e_rm_default_mac_filter - Remove the default MAC filter set by NVM
  * @vsi: the PF Main VSI - inappropriate for any other VSI
@@ -2423,10 +2531,14 @@ int i40e_sync_vsi_filters(struct i40e_vsi *vsi)
 				vlan_filters++;
 		}
 
-		retval = i40e_correct_mac_vlan_filters(vsi,
-						       &tmp_add_list,
-						       &tmp_del_list,
-						       vlan_filters);
+		if (vsi->type != I40E_VSI_SRIOV)
+			retval = i40e_correct_mac_vlan_filters
+				(vsi, &tmp_add_list, &tmp_del_list,
+				 vlan_filters);
+		else
+			retval = i40e_correct_vf_mac_vlan_filters
+				(vsi, &tmp_add_list, &tmp_del_list,
+				 vlan_filters, pf->vf[vsi->vf_id].trusted);
 
 		hlist_for_each_entry(new, &tmp_add_list, hlist)
 			netdev_hw_addr_refcnt(new->f, vsi->netdev, 1);
@@ -2855,8 +2967,21 @@ int i40e_add_vlan_all_mac(struct i40e_vsi *vsi, s16 vid)
 	int bkt;
 
 	hash_for_each_safe(vsi->mac_filter_hash, bkt, h, f, hlist) {
-		if (f->state == I40E_FILTER_REMOVE)
+		/* If we're asked to add a filter that has been marked for
+		 * removal, it is safe to simply restore it to active state.
+		 * __i40e_del_filter will have simply deleted any filters which
+		 * were previously marked NEW or FAILED, so if it is currently
+		 * marked REMOVE it must have previously been ACTIVE. Since we
+		 * haven't yet run the sync filters task, just restore this
+		 * filter to the ACTIVE state so that the sync task leaves it
+		 * in place.
+		 */
+		if (f->state == I40E_FILTER_REMOVE && f->vlan == vid) {
+			f->state = I40E_FILTER_ACTIVE;
+			continue;
+		} else if (f->state == I40E_FILTER_REMOVE) {
 			continue;
+		}
 		add_f = i40e_add_filter(vsi, f->macaddr, vid);
 		if (!add_f) {
 			dev_info(&vsi->back->pdev->dev,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 2606e8f0f19b..9949469333d5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -4349,6 +4349,7 @@ int i40e_ndo_set_vf_port_vlan(struct net_device *netdev, int vf_id,
 		/* duplicate request, so just return success */
 		goto error_pvid;
 
+	i40e_vlan_stripping_enable(vsi);
 	i40e_vc_reset_vf(vf, true);
 	/* During reset the VF got a new VSI, so refresh a pointer. */
 	vsi = pf->vsi[vf->lan_vsi_idx];
@@ -4364,7 +4365,7 @@ int i40e_ndo_set_vf_port_vlan(struct net_device *netdev, int vf_id,
 	 * MAC addresses deleted.
 	 */
 	if ((!(vlan_id || qos) ||
-	    vlanprio != le16_to_cpu(vsi->info.pvid)) &&
+	     vlanprio != le16_to_cpu(vsi->info.pvid)) &&
 	    vsi->info.pvid) {
 		ret = i40e_add_vlan_all_mac(vsi, I40E_VLAN_ANY);
 		if (ret) {
@@ -4727,6 +4728,11 @@ int i40e_ndo_set_vf_trust(struct net_device *netdev, int vf_id, bool setting)
 		goto out;
 
 	vf->trusted = setting;
+
+	/* request PF to sync mac/vlan filters for the VF */
+	set_bit(__I40E_MACVLAN_SYNC_PENDING, pf->state);
+	pf->vsi[vf->lan_vsi_idx]->flags |= I40E_VSI_FLAG_FILTER_CHANGED;
+
 	i40e_vc_reset_vf(vf, true);
 	dev_info(&pf->pdev->dev, "VF %u is now %strusted\n",
 		 vf_id, setting ? "" : "un");
-- 
2.35.1

