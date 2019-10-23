Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA4BE2274
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 20:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389547AbfJWSYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 14:24:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:64568 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388886AbfJWSYa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 14:24:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 11:24:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,221,1569308400"; 
   d="scan'208";a="202075927"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 23 Oct 2019 11:24:28 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Arkadiusz Grubba <arkadiusz.grubba@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/11] i40e: Add ability to display VF stats along with PF core stats
Date:   Wed, 23 Oct 2019 11:24:17 -0700
Message-Id: <20191023182426.13233-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191023182426.13233-1-jeffrey.t.kirsher@intel.com>
References: <20191023182426.13233-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arkadiusz Grubba <arkadiusz.grubba@intel.com>

This change introduces the ability to display extended (enhanced)
statistics for PF interfaces.

The patch introduces new arrays defined for these
extra stats (in i40e_ethtool.c file) and enhances/extends ethtool ops
functions intended for dealing with PF stats (i.e.: i40e_get_stats_count(),
i40e_get_ethtool_stats(), i40e_get_stat_strings() ).

There have also been introduced the new build flag named
"I40E_PF_EXTRA_STATS_OFF" to exclude from the driver code all code snippets
associated with these extra stats.

Signed-off-by: Arkadiusz Grubba <arkadiusz.grubba@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 149 ++++++++++++++++++
 1 file changed, 149 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 41e1240acaea..c814c756b4bb 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -389,6 +389,7 @@ static const struct i40e_stats i40e_gstrings_pfc_stats[] = {
 
 #define I40E_GLOBAL_STATS_LEN	ARRAY_SIZE(i40e_gstrings_stats)
 
+/* Length (number) of PF core stats only (i.e. without queues / extra stats): */
 #define I40E_PF_STATS_LEN	(I40E_GLOBAL_STATS_LEN + \
 				 I40E_PFC_STATS_LEN + \
 				 I40E_VEB_STATS_LEN + \
@@ -397,6 +398,44 @@ static const struct i40e_stats i40e_gstrings_pfc_stats[] = {
 /* Length of stats for a single queue */
 #define I40E_QUEUE_STATS_LEN	ARRAY_SIZE(i40e_gstrings_queue_stats)
 
+#define I40E_STATS_NAME_VFID_EXTRA "vf___."
+#define I40E_STATS_NAME_VFID_EXTRA_LEN (sizeof(I40E_STATS_NAME_VFID_EXTRA) - 1)
+
+static struct i40e_stats i40e_gstrings_eth_stats_extra[] = {
+	I40E_VSI_STAT(I40E_STATS_NAME_VFID_EXTRA
+		      "rx_bytes", eth_stats.rx_bytes),
+	I40E_VSI_STAT(I40E_STATS_NAME_VFID_EXTRA
+		      "rx_unicast", eth_stats.rx_unicast),
+	I40E_VSI_STAT(I40E_STATS_NAME_VFID_EXTRA
+		      "rx_multicast", eth_stats.rx_multicast),
+	I40E_VSI_STAT(I40E_STATS_NAME_VFID_EXTRA
+		      "rx_broadcast", eth_stats.rx_broadcast),
+	I40E_VSI_STAT(I40E_STATS_NAME_VFID_EXTRA
+		      "rx_discards", eth_stats.rx_discards),
+	I40E_VSI_STAT(I40E_STATS_NAME_VFID_EXTRA
+		      "rx_unknown_protocol", eth_stats.rx_unknown_protocol),
+	I40E_VSI_STAT(I40E_STATS_NAME_VFID_EXTRA
+		      "tx_bytes", eth_stats.tx_bytes),
+	I40E_VSI_STAT(I40E_STATS_NAME_VFID_EXTRA
+		      "tx_unicast", eth_stats.tx_unicast),
+	I40E_VSI_STAT(I40E_STATS_NAME_VFID_EXTRA
+		      "tx_multicast", eth_stats.tx_multicast),
+	I40E_VSI_STAT(I40E_STATS_NAME_VFID_EXTRA
+		      "tx_broadcast", eth_stats.tx_broadcast),
+	I40E_VSI_STAT(I40E_STATS_NAME_VFID_EXTRA
+		      "tx_discards", eth_stats.tx_discards),
+	I40E_VSI_STAT(I40E_STATS_NAME_VFID_EXTRA
+		      "tx_errors", eth_stats.tx_errors),
+};
+
+#define I40E_STATS_EXTRA_COUNT	128  /* as for now only I40E_MAX_VF_COUNT */
+/* Following length value does not include the length values for queues stats */
+#define I40E_STATS_EXTRA_LEN	ARRAY_SIZE(i40e_gstrings_eth_stats_extra)
+/* Length (number) of PF extra stats only (i.e. without core stats / queues): */
+#define I40E_PF_STATS_EXTRA_LEN (I40E_STATS_EXTRA_COUNT * I40E_STATS_EXTRA_LEN)
+/* Length (number) of enhanced/all PF stats (i.e. core with extra stats): */
+#define I40E_PF_STATS_ENHANCE_LEN (I40E_PF_STATS_LEN + I40E_PF_STATS_EXTRA_LEN)
+
 enum i40e_ethtool_test_id {
 	I40E_ETH_TEST_REG = 0,
 	I40E_ETH_TEST_EEPROM,
@@ -2190,6 +2229,9 @@ static int i40e_get_stats_count(struct net_device *netdev)
 	 */
 	stats_len += I40E_QUEUE_STATS_LEN * 2 * netdev->num_tx_queues;
 
+	if (vsi == pf->vsi[pf->lan_vsi] && pf->hw.partition_id == 1)
+		stats_len += I40E_PF_STATS_EXTRA_LEN;
+
 	return stats_len;
 }
 
@@ -2258,6 +2300,10 @@ static void i40e_get_ethtool_stats(struct net_device *netdev,
 	struct i40e_vsi *vsi = np->vsi;
 	struct i40e_pf *pf = vsi->back;
 	struct i40e_veb *veb = NULL;
+	unsigned int vsi_idx;
+	unsigned int vf_idx;
+	unsigned int vf_id;
+	bool is_vf_valid;
 	unsigned int i;
 	bool veb_stats;
 	u64 *p = data;
@@ -2307,11 +2353,109 @@ static void i40e_get_ethtool_stats(struct net_device *netdev,
 		i40e_add_ethtool_stats(&data, &pfc, i40e_gstrings_pfc_stats);
 	}
 
+	/* As for now, we only process the SRIOV type VSIs (as extra stats to
+	 * PF core stats) which are correlated with VF LAN VSI (hence below,
+	 * in this for-loop instruction block, only VF's LAN VSIs are currently
+	 * processed).
+	 */
+	for (vf_id = 0; vf_id < pf->num_alloc_vfs; vf_id++) {
+		is_vf_valid = true;
+		for (vf_idx = 0; vf_idx < pf->num_alloc_vfs; vf_idx++)
+			if (pf->vf[vf_idx].vf_id == vf_id)
+				break;
+		if (vf_idx >= pf->num_alloc_vfs) {
+			dev_info(&pf->pdev->dev,
+				 "In the PF's array, there is no VF instance with VF_ID identifier %d or it is not set/initialized correctly yet\n",
+				 vf_id);
+			is_vf_valid = false;
+			goto check_vf;
+		}
+		vsi_idx = pf->vf[vf_idx].lan_vsi_idx;
+
+		vsi = pf->vsi[vsi_idx];
+		if (!vsi) {
+			/* It means empty field in the PF VSI array... */
+			dev_info(&pf->pdev->dev,
+				 "No LAN VSI instance referenced by VF %d or it is not set/initialized correctly yet\n",
+				 vf_id);
+			is_vf_valid = false;
+			goto check_vf;
+		}
+		if (vsi->vf_id != vf_id) {
+			dev_info(&pf->pdev->dev,
+				 "In the PF's array, there is incorrectly set/initialized LAN VSI or reference to it from VF %d is not set/initialized correctly yet\n",
+				 vf_id);
+			is_vf_valid = false;
+			goto check_vf;
+		}
+		if (vsi->vf_id != pf->vf[vf_idx].vf_id ||
+		    !i40e_find_vsi_from_id(pf, pf->vf[vsi->vf_id].lan_vsi_id)) {
+			/* Disjointed identifiers or broken references VF-VSI */
+			dev_warn(&pf->pdev->dev,
+				 "SRIOV LAN VSI (index %d in PF VSI array) with invalid VF Identifier %d (referenced by VF %d, ordered as %d in VF array)\n",
+				 vsi_idx, pf->vsi[vsi_idx]->vf_id,
+				 pf->vf[vf_idx].vf_id, vf_idx);
+			is_vf_valid = false;
+		}
+check_vf:
+		if (!is_vf_valid) {
+			i40e_add_ethtool_stats(&data, NULL,
+					       i40e_gstrings_eth_stats_extra);
+		} else {
+			i40e_update_eth_stats(vsi);
+			i40e_add_ethtool_stats(&data, vsi,
+					       i40e_gstrings_eth_stats_extra);
+		}
+	}
+	for (; vf_id < I40E_STATS_EXTRA_COUNT; vf_id++)
+		i40e_add_ethtool_stats(&data, NULL,
+				       i40e_gstrings_eth_stats_extra);
+
 check_data_pointer:
 	WARN_ONCE(data - p != i40e_get_stats_count(netdev),
 		  "ethtool stats count mismatch!");
 }
 
+/**
+ * __i40e_update_vfid_in_stats_strings - print VF num to stats names
+ * @stats_extra: array of stats structs with stats name strings
+ * @strings_num: number of stats name strings in array above (length)
+ * @vf_id: VF number to update stats name strings with
+ *
+ * Helper function to i40e_get_stat_strings() in case of extra stats.
+ **/
+static inline void
+__i40e_update_vfid_in_stats_strings(struct i40e_stats stats_extra[],
+				    int strings_num, int vf_id)
+{
+	int i;
+
+	for (i = 0; i < strings_num; i++) {
+		snprintf(stats_extra[i].stat_string,
+			 I40E_STATS_NAME_VFID_EXTRA_LEN, "vf%03d", vf_id);
+		stats_extra[i].stat_string[I40E_STATS_NAME_VFID_EXTRA_LEN -
+								       1] = '.';
+	}
+}
+
+/**
+ * i40e_update_vfid_in_stats - print VF num to stat names
+ * @stats_extra: array of stats structs with stats name strings
+ * @vf_id: VF number to update stats name strings with
+ *
+ * Helper macro to i40e_get_stat_strings() to ease use of
+ * __i40e_update_vfid_in_stats_strings() function due to extra stats.
+ *
+ * Macro to ease the use of __i40e_update_vfid_in_stats_strings by taking
+ * a static constant stats array and passing the ARRAY_SIZE(). This avoids typos
+ * by ensuring that we pass the size associated with the given stats array.
+ *
+ * The parameter @stats_extra is evaluated twice, so parameters with side
+ * effects should be avoided.
+ **/
+#define i40e_update_vfid_in_stats(stats_extra, vf_id) \
+__i40e_update_vfid_in_stats_strings(stats_extra, ARRAY_SIZE(stats_extra), vf_id)
+
 /**
  * i40e_get_stat_strings - copy stat strings into supplied buffer
  * @netdev: the netdev to collect strings for
@@ -2354,6 +2498,11 @@ static void i40e_get_stat_strings(struct net_device *netdev, u8 *data)
 	for (i = 0; i < I40E_MAX_USER_PRIORITY; i++)
 		i40e_add_stat_strings(&data, i40e_gstrings_pfc_stats, i);
 
+	for (i = 0; i < I40E_STATS_EXTRA_COUNT; i++) {
+		i40e_update_vfid_in_stats(i40e_gstrings_eth_stats_extra, i);
+		i40e_add_stat_strings(&data, i40e_gstrings_eth_stats_extra);
+	}
+
 check_data_pointer:
 	WARN_ONCE(data - p != i40e_get_stats_count(netdev) * ETH_GSTRING_LEN,
 		  "stat strings count mismatch!");
-- 
2.21.0

