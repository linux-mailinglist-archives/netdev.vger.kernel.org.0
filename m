Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB62145762C
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 19:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbhKSSRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 13:17:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:52700 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232097AbhKSSRE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 13:17:04 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10173"; a="221683613"
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="221683613"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 10:14:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="508004016"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 19 Nov 2021 10:14:01 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com, Jan Sokolowski <jan.sokolowski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 3/4] iavf: Fix refreshing iavf adapter stats on ethtool request
Date:   Fri, 19 Nov 2021 10:12:42 -0800
Message-Id: <20211119181243.1839441-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119181243.1839441-1-anthony.l.nguyen@intel.com>
References: <20211119181243.1839441-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

Currently iavf adapter statistics are refreshed only in a
watchdog task, triggered approximately every two seconds,
which causes some ethtool requests to return outdated values.

Add explicit statistics refresh when requested by ethtool -S.

Fixes: b476b0030e61 ("iavf: Move commands processing to the separate function")
Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h         |  2 ++
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c |  3 +++
 drivers/net/ethernet/intel/iavf/iavf_main.c    | 18 ++++++++++++++++++
 .../net/ethernet/intel/iavf/iavf_virtchnl.c    |  2 ++
 4 files changed, 25 insertions(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 75635bd57cf6..bb9cc227d1e1 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -305,6 +305,7 @@ struct iavf_adapter {
 #define IAVF_FLAG_AQ_DEL_FDIR_FILTER		BIT(26)
 #define IAVF_FLAG_AQ_ADD_ADV_RSS_CFG		BIT(27)
 #define IAVF_FLAG_AQ_DEL_ADV_RSS_CFG		BIT(28)
+#define IAVF_FLAG_AQ_REQUEST_STATS		BIT(29)
 
 	/* OS defined structs */
 	struct net_device *netdev;
@@ -444,6 +445,7 @@ int iavf_up(struct iavf_adapter *adapter);
 void iavf_down(struct iavf_adapter *adapter);
 int iavf_process_config(struct iavf_adapter *adapter);
 void iavf_schedule_reset(struct iavf_adapter *adapter);
+void iavf_schedule_request_stats(struct iavf_adapter *adapter);
 void iavf_reset(struct iavf_adapter *adapter);
 void iavf_set_ethtool_ops(struct net_device *netdev);
 void iavf_update_stats(struct iavf_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index 71b23922089f..0cecaff38d04 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -354,6 +354,9 @@ static void iavf_get_ethtool_stats(struct net_device *netdev,
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 	unsigned int i;
 
+	/* Explicitly request stats refresh */
+	iavf_schedule_request_stats(adapter);
+
 	iavf_add_ethtool_stats(&data, adapter, iavf_gstrings_stats);
 
 	rcu_read_lock();
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 84680777ac12..8e96ae746c3d 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -174,6 +174,19 @@ void iavf_schedule_reset(struct iavf_adapter *adapter)
 	}
 }
 
+/**
+ * iavf_schedule_request_stats - Set the flags and schedule statistics request
+ * @adapter: board private structure
+ *
+ * Sets IAVF_FLAG_AQ_REQUEST_STATS flag so iavf_watchdog_task() will explicitly
+ * request and refresh ethtool stats
+ **/
+void iavf_schedule_request_stats(struct iavf_adapter *adapter)
+{
+	adapter->aq_required |= IAVF_FLAG_AQ_REQUEST_STATS;
+	mod_delayed_work(iavf_wq, &adapter->watchdog_task, 0);
+}
+
 /**
  * iavf_tx_timeout - Respond to a Tx Hang
  * @netdev: network interface device structure
@@ -1709,6 +1722,11 @@ static int iavf_process_aq_command(struct iavf_adapter *adapter)
 		iavf_del_adv_rss_cfg(adapter);
 		return 0;
 	}
+	if (adapter->aq_required & IAVF_FLAG_AQ_REQUEST_STATS) {
+		iavf_request_stats(adapter);
+		return 0;
+	}
+
 	return -EAGAIN;
 }
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 8c3f0f77cb57..8421cbe6a197 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -784,6 +784,8 @@ void iavf_request_stats(struct iavf_adapter *adapter)
 		/* no error message, this isn't crucial */
 		return;
 	}
+
+	adapter->aq_required &= ~IAVF_FLAG_AQ_REQUEST_STATS;
 	adapter->current_op = VIRTCHNL_OP_GET_STATS;
 	vqs.vsi_id = adapter->vsi_res->vsi_id;
 	/* queue maps are ignored for this message - only the vsi is used */
-- 
2.31.1

