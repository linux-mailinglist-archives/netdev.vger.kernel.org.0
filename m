Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E764796DB
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 23:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbhLQWHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 17:07:46 -0500
Received: from mga03.intel.com ([134.134.136.65]:43081 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhLQWHo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 17:07:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639778864; x=1671314864;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Vv25ipwT5ICoqv4GvgzKTgmTB0FbDoUwWbKgXFnyPis=;
  b=Aw6DeCQN1ElJ4pP5DGvgE5YX/8GblqBf66jDvlJRkSGHeSaW6aiRQijM
   hPh/Dqqapkr4+f97P5/BLge8C58nzihdm/p5RdSh6fBPT+AkLFe0pg8kX
   SGLTYG0U+pilhqM067OD7KNV1yvPs+Lz5w9nNeG17UKJoo4+DYQCs9Q1I
   vom4do9TaGzv+H5pdPgawqWgXvxFxNWf//EI63VAtdx81/cK+TU/sXkp7
   Uql3Ci+kQAHKJB6FQtaoTuTVpGxWO0bubcH5nYkWthCneAoq3tf4cRL4v
   Q9bMrFnjz2lWSIvr2yUn/A64llGeEuTCyeRbWoNusBSOjUeMEmzgzLkRg
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10201"; a="239794456"
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="239794456"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 14:07:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="519922264"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 17 Dec 2021 14:07:43 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 6/6] iavf: Restrict maximum VLAN filters for VIRTCHNL_VF_OFFLOAD_VLAN_V2
Date:   Fri, 17 Dec 2021 14:06:47 -0800
Message-Id: <20211217220647.875246-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211217220647.875246-1-anthony.l.nguyen@intel.com>
References: <20211217220647.875246-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

For VIRTCHNL_VF_OFFLOAD_VLAN, PF's would limit the number of VLAN
filters a VF was allowed to add. However, by the time the opcode failed,
the VLAN netdev had already been added. VIRTCHNL_VF_OFFLOAD_VLAN_V2
added the ability for a PF to tell the VF how many VLAN filters it's
allowed to add. Make changes to support that functionality.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 50 +++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index ab59c9235d03..0fbac51b7cca 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -731,6 +731,50 @@ static void iavf_restore_filters(struct iavf_adapter *adapter)
 		iavf_add_vlan(adapter, IAVF_VLAN(vid, ETH_P_8021AD));
 }
 
+/**
+ * iavf_get_num_vlans_added - get number of VLANs added
+ * @adapter: board private structure
+ */
+static u16 iavf_get_num_vlans_added(struct iavf_adapter *adapter)
+{
+	return bitmap_weight(adapter->vsi.active_cvlans, VLAN_N_VID) +
+		bitmap_weight(adapter->vsi.active_svlans, VLAN_N_VID);
+}
+
+/**
+ * iavf_get_max_vlans_allowed - get maximum VLANs allowed for this VF
+ * @adapter: board private structure
+ *
+ * This depends on the negotiated VLAN capability. For VIRTCHNL_VF_OFFLOAD_VLAN,
+ * do not impose a limit as that maintains current behavior and for
+ * VIRTCHNL_VF_OFFLOAD_VLAN_V2, use the maximum allowed sent from the PF.
+ **/
+static u16 iavf_get_max_vlans_allowed(struct iavf_adapter *adapter)
+{
+	/* don't impose any limit for VIRTCHNL_VF_OFFLOAD_VLAN since there has
+	 * never been a limit on the VF driver side
+	 */
+	if (VLAN_ALLOWED(adapter))
+		return VLAN_N_VID;
+	else if (VLAN_V2_ALLOWED(adapter))
+		return adapter->vlan_v2_caps.filtering.max_filters;
+
+	return 0;
+}
+
+/**
+ * iavf_max_vlans_added - check if maximum VLANs allowed already exist
+ * @adapter: board private structure
+ **/
+static bool iavf_max_vlans_added(struct iavf_adapter *adapter)
+{
+	if (iavf_get_num_vlans_added(adapter) <
+	    iavf_get_max_vlans_allowed(adapter))
+		return false;
+
+	return true;
+}
+
 /**
  * iavf_vlan_rx_add_vid - Add a VLAN filter to a device
  * @netdev: network device struct
@@ -745,6 +789,12 @@ static int iavf_vlan_rx_add_vid(struct net_device *netdev,
 	if (!VLAN_FILTERING_ALLOWED(adapter))
 		return -EIO;
 
+	if (iavf_max_vlans_added(adapter)) {
+		netdev_err(netdev, "Max allowed VLAN filters %u. Remove existing VLANs or disable filtering via Ethtool if supported.\n",
+			   iavf_get_max_vlans_allowed(adapter));
+		return -EIO;
+	}
+
 	if (!iavf_add_vlan(adapter, IAVF_VLAN(vid, be16_to_cpu(proto))))
 		return -ENOMEM;
 
-- 
2.31.1

