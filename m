Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5096451BF1
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348822AbhKPAJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:09:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:18510 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233486AbhKPAGm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 19:06:42 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="220768897"
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="220768897"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 16:01:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="506163139"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 15 Nov 2021 16:00:57 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Subject: [PATCH net 10/10] iavf: Restore VLAN filters after link down
Date:   Mon, 15 Nov 2021 15:59:34 -0800
Message-Id: <20211115235934.880882-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211115235934.880882-1-anthony.l.nguyen@intel.com>
References: <20211115235934.880882-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>

Restore VLAN filters after the link is brought down, and up - since all
filters are deleted from HW during the netdev link down routine.

Fixes: ed1f5b58ea01 ("i40evf: remove VLAN filters on close")
Signed-off-by: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h      |  1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c | 35 ++++++++++++++++++---
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index e6e7c1da47fb..75635bd57cf6 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -39,6 +39,7 @@
 #include "iavf_txrx.h"
 #include "iavf_fdir.h"
 #include "iavf_adv_rss.h"
+#include <linux/bitmap.h>
 
 #define DEFAULT_DEBUG_LEVEL_SHIFT 3
 #define PFX "iavf: "
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 9ca9208aa896..336e6bf95e48 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -696,6 +696,23 @@ static void iavf_del_vlan(struct iavf_adapter *adapter, u16 vlan)
 	spin_unlock_bh(&adapter->mac_vlan_list_lock);
 }
 
+/**
+ * iavf_restore_filters
+ * @adapter: board private structure
+ *
+ * Restore existing non MAC filters when VF netdev comes back up
+ **/
+static void iavf_restore_filters(struct iavf_adapter *adapter)
+{
+	/* re-add all VLAN filters */
+	if (VLAN_ALLOWED(adapter)) {
+		u16 vid;
+
+		for_each_set_bit(vid, adapter->vsi.active_vlans, VLAN_N_VID)
+			iavf_add_vlan(adapter, vid);
+	}
+}
+
 /**
  * iavf_vlan_rx_add_vid - Add a VLAN filter to a device
  * @netdev: network device struct
@@ -709,8 +726,11 @@ static int iavf_vlan_rx_add_vid(struct net_device *netdev,
 
 	if (!VLAN_ALLOWED(adapter))
 		return -EIO;
+
 	if (iavf_add_vlan(adapter, vid) == NULL)
 		return -ENOMEM;
+
+	set_bit(vid, adapter->vsi.active_vlans);
 	return 0;
 }
 
@@ -725,11 +745,13 @@ static int iavf_vlan_rx_kill_vid(struct net_device *netdev,
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
-	if (VLAN_ALLOWED(adapter)) {
-		iavf_del_vlan(adapter, vid);
-		return 0;
-	}
-	return -EIO;
+	if (!VLAN_ALLOWED(adapter))
+		return -EIO;
+
+	iavf_del_vlan(adapter, vid);
+	clear_bit(vid, adapter->vsi.active_vlans);
+
+	return 0;
 }
 
 /**
@@ -3309,6 +3331,9 @@ static int iavf_open(struct net_device *netdev)
 
 	spin_unlock_bh(&adapter->mac_vlan_list_lock);
 
+	/* Restore VLAN filters that were removed with IFF_DOWN */
+	iavf_restore_filters(adapter);
+
 	iavf_configure(adapter);
 
 	iavf_up_complete(adapter);
-- 
2.31.1

