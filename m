Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A99A19B8F1
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 01:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbfHWXhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 19:37:55 -0400
Received: from mga06.intel.com ([134.134.136.31]:14901 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727061AbfHWXhx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 19:37:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 16:37:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,422,1559545200"; 
   d="scan'208";a="184354440"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 23 Aug 2019 16:37:51 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 12/14] ice: update ethtool stats on-demand
Date:   Fri, 23 Aug 2019 16:37:48 -0700
Message-Id: <20190823233750.7997-13-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190823233750.7997-1-jeffrey.t.kirsher@intel.com>
References: <20190823233750.7997-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

Users expect ethtool statistics to be updated on-demand when invoking
'ethtool -S <iface>' instead of providing a snapshot of statistics taken
once a second (the frequency of the watchdog task where stats are currently
updated).  Update stats every time 'ethtool -S <iface>' is run.

Also, fix an indentation style issue and an unnecessary local variable
initialization in ice_get_ethtool_stats() discovered while investigating
the subject issue.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         | 2 ++
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 7 +++++--
 drivers/net/ethernet/intel/ice/ice_main.c    | 6 ++----
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 99e0febd8e50..97d0f61cf52b 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -447,6 +447,8 @@ ice_find_vsi_by_type(struct ice_pf *pf, enum ice_vsi_type type)
 int ice_vsi_setup_tx_rings(struct ice_vsi *vsi);
 int ice_vsi_setup_rx_rings(struct ice_vsi *vsi);
 void ice_set_ethtool_ops(struct net_device *netdev);
+void ice_update_vsi_stats(struct ice_vsi *vsi);
+void ice_update_pf_stats(struct ice_pf *pf);
 int ice_up(struct ice_vsi *vsi);
 int ice_down(struct ice_vsi *vsi);
 int ice_vsi_cfg(struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 948a33716290..f7dd0bd03d39 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1319,14 +1319,17 @@ ice_get_ethtool_stats(struct net_device *netdev,
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
 	struct ice_ring *ring;
-	unsigned int j = 0;
+	unsigned int j;
 	int i = 0;
 	char *p;
 
+	ice_update_pf_stats(pf);
+	ice_update_vsi_stats(vsi);
+
 	for (j = 0; j < ICE_VSI_STATS_LEN; j++) {
 		p = (char *)vsi + ice_gstrings_vsi_stats[j].stat_offset;
 		data[i++] = (ice_gstrings_vsi_stats[j].sizeof_stat ==
-			    sizeof(u64)) ? *(u64 *)p : *(u32 *)p;
+			     sizeof(u64)) ? *(u64 *)p : *(u32 *)p;
 	}
 
 	/* populate per queue stats */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a0d148f590c2..6dd806b763ea 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -34,8 +34,6 @@ static const struct net_device_ops ice_netdev_ops;
 static void ice_rebuild(struct ice_pf *pf);
 
 static void ice_vsi_release_all(struct ice_pf *pf);
-static void ice_update_vsi_stats(struct ice_vsi *vsi);
-static void ice_update_pf_stats(struct ice_pf *pf);
 
 /**
  * ice_get_tx_pending - returns number of Tx descriptors not processed
@@ -3254,7 +3252,7 @@ static void ice_update_vsi_ring_stats(struct ice_vsi *vsi)
  * ice_update_vsi_stats - Update VSI stats counters
  * @vsi: the VSI to be updated
  */
-static void ice_update_vsi_stats(struct ice_vsi *vsi)
+void ice_update_vsi_stats(struct ice_vsi *vsi)
 {
 	struct rtnl_link_stats64 *cur_ns = &vsi->net_stats;
 	struct ice_eth_stats *cur_es = &vsi->eth_stats;
@@ -3290,7 +3288,7 @@ static void ice_update_vsi_stats(struct ice_vsi *vsi)
  * ice_update_pf_stats - Update PF port stats counters
  * @pf: PF whose stats needs to be updated
  */
-static void ice_update_pf_stats(struct ice_pf *pf)
+void ice_update_pf_stats(struct ice_pf *pf)
 {
 	struct ice_hw_port_stats *prev_ps, *cur_ps;
 	struct ice_hw *hw = &pf->hw;
-- 
2.21.0

