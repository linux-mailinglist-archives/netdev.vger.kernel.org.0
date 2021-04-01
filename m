Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F092D351B69
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236753AbhDASI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:08:27 -0400
Received: from mga07.intel.com ([134.134.136.100]:1874 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237705AbhDASEL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 14:04:11 -0400
IronPort-SDR: o7RQZ4AnFDPghpglxUmqbNKRlE56xjT6GuvurQ6riNoo63Yx9Y8OSAvkCA3eILAE8IEwZziFyV
 m37E2V8cvO0g==
X-IronPort-AV: E=McAfee;i="6000,8403,9941"; a="256275601"
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="256275601"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 10:19:30 -0700
IronPort-SDR: pB344TSnesTmSoTn7LioQX0Xoop/xKEFqTVI8npRkHD7SBM2Fn1fGiXK2r5vDA+Uk0TV9/GHrr
 imLl1rEW3mSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="439290160"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 01 Apr 2021 10:19:30 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Eryk Rybak <eryk.roch.rybak@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net 3/3] i40e: Fix display statistics for veb_tc
Date:   Thu,  1 Apr 2021 10:21:07 -0700
Message-Id: <20210401172107.1191618-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210401172107.1191618-1-anthony.l.nguyen@intel.com>
References: <20210401172107.1191618-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eryk Rybak <eryk.roch.rybak@intel.com>

If veb-stats was enabled, the ethtool stats triggered a warning
due to invalid size: 'unexpected stat size for veb.tc_%u_tx_packets'.
This was due to an incorrect structure definition for the statistics.
Structures and functions have been improved in line with requirements
for the presentation of statistics, in particular for the functions:
'i40e_add_ethtool_stats' and 'i40e_add_stat_strings'.

Fixes: 1510ae0be2a4 ("i40e: convert VEB TC stats to use an i40e_stats array")
Signed-off-by: Eryk Rybak <eryk.roch.rybak@intel.com>
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 52 ++++++++++++++++---
 1 file changed, 46 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 2c637a5678b3..96d5202a73e8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -232,6 +232,8 @@ static void __i40e_add_stat_strings(u8 **p, const struct i40e_stats stats[],
 	I40E_STAT(struct i40e_vsi, _name, _stat)
 #define I40E_VEB_STAT(_name, _stat) \
 	I40E_STAT(struct i40e_veb, _name, _stat)
+#define I40E_VEB_TC_STAT(_name, _stat) \
+	I40E_STAT(struct i40e_cp_veb_tc_stats, _name, _stat)
 #define I40E_PFC_STAT(_name, _stat) \
 	I40E_STAT(struct i40e_pfc_stats, _name, _stat)
 #define I40E_QUEUE_STAT(_name, _stat) \
@@ -266,11 +268,18 @@ static const struct i40e_stats i40e_gstrings_veb_stats[] = {
 	I40E_VEB_STAT("veb.rx_unknown_protocol", stats.rx_unknown_protocol),
 };
 
+struct i40e_cp_veb_tc_stats {
+	u64 tc_rx_packets;
+	u64 tc_rx_bytes;
+	u64 tc_tx_packets;
+	u64 tc_tx_bytes;
+};
+
 static const struct i40e_stats i40e_gstrings_veb_tc_stats[] = {
-	I40E_VEB_STAT("veb.tc_%u_tx_packets", tc_stats.tc_tx_packets),
-	I40E_VEB_STAT("veb.tc_%u_tx_bytes", tc_stats.tc_tx_bytes),
-	I40E_VEB_STAT("veb.tc_%u_rx_packets", tc_stats.tc_rx_packets),
-	I40E_VEB_STAT("veb.tc_%u_rx_bytes", tc_stats.tc_rx_bytes),
+	I40E_VEB_TC_STAT("veb.tc_%u_tx_packets", tc_tx_packets),
+	I40E_VEB_TC_STAT("veb.tc_%u_tx_bytes", tc_tx_bytes),
+	I40E_VEB_TC_STAT("veb.tc_%u_rx_packets", tc_rx_packets),
+	I40E_VEB_TC_STAT("veb.tc_%u_rx_bytes", tc_rx_bytes),
 };
 
 static const struct i40e_stats i40e_gstrings_misc_stats[] = {
@@ -2217,6 +2226,29 @@ static int i40e_get_sset_count(struct net_device *netdev, int sset)
 	}
 }
 
+/**
+ * i40e_get_veb_tc_stats - copy VEB TC statistics to formatted structure
+ * @tc: the TC statistics in VEB structure (veb->tc_stats)
+ * @i: the index of traffic class in (veb->tc_stats) structure to copy
+ *
+ * Copy VEB TC statistics from structure of arrays (veb->tc_stats) to
+ * one dimensional structure i40e_cp_veb_tc_stats.
+ * Produce formatted i40e_cp_veb_tc_stats structure of the VEB TC
+ * statistics for the given TC.
+ **/
+static struct i40e_cp_veb_tc_stats
+i40e_get_veb_tc_stats(struct i40e_veb_tc_stats *tc, unsigned int i)
+{
+	struct i40e_cp_veb_tc_stats veb_tc = {
+		.tc_rx_packets = tc->tc_rx_packets[i],
+		.tc_rx_bytes = tc->tc_rx_bytes[i],
+		.tc_tx_packets = tc->tc_tx_packets[i],
+		.tc_tx_bytes = tc->tc_tx_bytes[i],
+	};
+
+	return veb_tc;
+}
+
 /**
  * i40e_get_pfc_stats - copy HW PFC statistics to formatted structure
  * @pf: the PF device structure
@@ -2301,8 +2333,16 @@ static void i40e_get_ethtool_stats(struct net_device *netdev,
 			       i40e_gstrings_veb_stats);
 
 	for (i = 0; i < I40E_MAX_TRAFFIC_CLASS; i++)
-		i40e_add_ethtool_stats(&data, veb_stats ? veb : NULL,
-				       i40e_gstrings_veb_tc_stats);
+		if (veb_stats) {
+			struct i40e_cp_veb_tc_stats veb_tc =
+				i40e_get_veb_tc_stats(&veb->tc_stats, i);
+
+			i40e_add_ethtool_stats(&data, &veb_tc,
+					       i40e_gstrings_veb_tc_stats);
+		} else {
+			i40e_add_ethtool_stats(&data, NULL,
+					       i40e_gstrings_veb_tc_stats);
+		}
 
 	i40e_add_ethtool_stats(&data, pf, i40e_gstrings_stats);
 
-- 
2.26.2

