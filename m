Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25C63B4B95
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 02:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhFZAgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 20:36:22 -0400
Received: from mga18.intel.com ([134.134.136.126]:48451 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229933AbhFZAgE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 20:36:04 -0400
IronPort-SDR: KjEYUXvcMRu5T2k84M7CctFuOWvCu4QS69Ld9KRmJ30vJz8d3SNeiSSmyWedPUsnlalwj2qQ9l
 V+9j298bqEbg==
X-IronPort-AV: E=McAfee;i="6200,9189,10026"; a="195054025"
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="195054025"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 17:33:43 -0700
IronPort-SDR: GD9oy9Nko6YOi6hnwCtLfOa7zIOwr96rjKGym9CUHF+mU6FG2czQvUuaDyNvqMxtJzGWnHQ4FI
 Qydff5sFvojw==
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="557008619"
Received: from aschmalt-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.160.59])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 17:33:43 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        vladimir.oltean@nxp.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: [PATCH net-next v4 08/12] igc: Simplify TSN flags handling
Date:   Fri, 25 Jun 2021 17:33:10 -0700
Message-Id: <20210626003314.3159402-9-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210626003314.3159402-1-vinicius.gomes@intel.com>
References: <20210626003314.3159402-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Separates the procedure done during reset from applying a
configuration, knowing when the code is executing allow us to separate
the better what changes the hardware state from what changes only the
driver state.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h      |  4 ++
 drivers/net/ethernet/intel/igc/igc_main.c |  2 +-
 drivers/net/ethernet/intel/igc/igc_tsn.c  | 71 ++++++++++++++---------
 drivers/net/ethernet/intel/igc/igc_tsn.h  |  1 +
 4 files changed, 48 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 68c7262bd172..ccd5f6b02e3a 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -290,6 +290,10 @@ extern char igc_driver_name[];
 #define IGC_FLAG_VLAN_PROMISC		BIT(15)
 #define IGC_FLAG_RX_LEGACY		BIT(16)
 #define IGC_FLAG_TSN_QBV_ENABLED	BIT(17)
+#define IGC_FLAG_TSN_PREEMPT_ENABLED	BIT(18)
+
+#define IGC_FLAG_TSN_ANY_ENABLED \
+	(IGC_FLAG_TSN_QBV_ENABLED | IGC_FLAG_TSN_PREEMPT_ENABLED)
 
 #define IGC_FLAG_RSS_FIELD_IPV4_UDP	BIT(6)
 #define IGC_FLAG_RSS_FIELD_IPV6_UDP	BIT(7)
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index b0981ea0ae63..038383519b10 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -118,7 +118,7 @@ void igc_reset(struct igc_adapter *adapter)
 	igc_ptp_reset(adapter);
 
 	/* Re-enable TSN offloading, where applicable. */
-	igc_tsn_offload_apply(adapter);
+	igc_tsn_reset(adapter);
 
 	igc_get_phy_info(hw);
 }
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index 174103c4bea6..f2dfc8059847 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -18,8 +18,21 @@ static bool is_any_launchtime(struct igc_adapter *adapter)
 	return false;
 }
 
+static unsigned int igc_tsn_new_flags(struct igc_adapter *adapter)
+{
+	unsigned int new_flags = adapter->flags & ~IGC_FLAG_TSN_ANY_ENABLED;
+
+	if (adapter->base_time)
+		new_flags |= IGC_FLAG_TSN_QBV_ENABLED;
+
+	if (is_any_launchtime(adapter))
+		new_flags |= IGC_FLAG_TSN_QBV_ENABLED;
+
+	return new_flags;
+}
+
 /* Returns the TSN specific registers to their default values after
- * TSN offloading is disabled.
+ * the adapter is reset.
  */
 static int igc_tsn_disable_offload(struct igc_adapter *adapter)
 {
@@ -27,11 +40,6 @@ static int igc_tsn_disable_offload(struct igc_adapter *adapter)
 	u32 tqavctrl;
 	int i;
 
-	if (!(adapter->flags & IGC_FLAG_TSN_QBV_ENABLED))
-		return 0;
-
-	adapter->cycle_time = 0;
-
 	wr32(IGC_TXPBS, I225_TXPBSIZE_DEFAULT);
 	wr32(IGC_DTXMXPKTSZ, IGC_DTXMXPKTSZ_DEFAULT);
 
@@ -68,9 +76,6 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 	ktime_t base_time, systim;
 	int i;
 
-	if (adapter->flags & IGC_FLAG_TSN_QBV_ENABLED)
-		return 0;
-
 	cycle = adapter->cycle_time;
 	base_time = adapter->base_time;
 
@@ -125,33 +130,41 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 	wr32(IGC_BASET_H, baset_h);
 	wr32(IGC_BASET_L, baset_l);
 
-	adapter->flags |= IGC_FLAG_TSN_QBV_ENABLED;
-
 	return 0;
 }
 
+int igc_tsn_reset(struct igc_adapter *adapter)
+{
+	unsigned int new_flags;
+	int err = 0;
+
+	new_flags = igc_tsn_new_flags(adapter);
+
+	if (!(new_flags & IGC_FLAG_TSN_ANY_ENABLED))
+		return igc_tsn_disable_offload(adapter);
+
+	err = igc_tsn_enable_offload(adapter);
+	if (err < 0)
+		return err;
+
+	adapter->flags = new_flags;
+
+	return err;
+}
+
 int igc_tsn_offload_apply(struct igc_adapter *adapter)
 {
-	bool is_any_enabled = adapter->base_time || is_any_launchtime(adapter);
-
-	if (!(adapter->flags & IGC_FLAG_TSN_QBV_ENABLED) && !is_any_enabled)
-		return 0;
-
-	if (!is_any_enabled) {
-		int err = igc_tsn_disable_offload(adapter);
-
-		if (err < 0)
-			return err;
-
-		/* The BASET registers aren't cleared when writing
-		 * into them, force a reset if the interface is
-		 * running.
-		 */
-		if (netif_running(adapter->netdev))
-			schedule_work(&adapter->reset_task);
+	int err;
 
+	if (netif_running(adapter->netdev)) {
+		schedule_work(&adapter->reset_task);
 		return 0;
 	}
 
-	return igc_tsn_enable_offload(adapter);
+	err = igc_tsn_enable_offload(adapter);
+	if (err < 0)
+		return err;
+
+	adapter->flags = igc_tsn_new_flags(adapter);
+	return 0;
 }
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.h b/drivers/net/ethernet/intel/igc/igc_tsn.h
index f76bc86ddccd..1512307f5a52 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.h
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.h
@@ -5,5 +5,6 @@
 #define _IGC_TSN_H_
 
 int igc_tsn_offload_apply(struct igc_adapter *adapter);
+int igc_tsn_reset(struct igc_adapter *adapter);
 
 #endif /* _IGC_BASE_H */
-- 
2.32.0

