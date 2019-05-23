Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C35128D36
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 00:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388719AbfEWWdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 18:33:49 -0400
Received: from mga12.intel.com ([192.55.52.136]:19075 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388595AbfEWWdj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 18:33:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 May 2019 15:33:37 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga003.jf.intel.com with ESMTP; 23 May 2019 15:33:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 12/15] ice: Use bitfields when possible
Date:   Thu, 23 May 2019 15:33:37 -0700
Message-Id: <20190523223340.13449-13-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523223340.13449-1-jeffrey.t.kirsher@intel.com>
References: <20190523223340.13449-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

We can use bit fields to store boolean values and when the
bit fields are next to each other, the compiler will combine them
(as long as the size holds enough).

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h             | 10 +++++-----
 drivers/net/ethernet/intel/ice/ice_txrx.h        |  2 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h | 10 +++++-----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 7958f2bac8da..23e30a69f5fa 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -277,10 +277,10 @@ struct ice_vsi {
 	struct list_head tmp_sync_list;		/* MAC filters to be synced */
 	struct list_head tmp_unsync_list;	/* MAC filters to be unsynced */
 
-	u8 irqs_ready;
-	u8 current_isup;		 /* Sync 'link up' logging */
-	u8 stat_offsets_loaded;
-	u8 vlan_ena;
+	u8 irqs_ready:1;
+	u8 current_isup:1;		 /* Sync 'link up' logging */
+	u8 stat_offsets_loaded:1;
+	u8 vlan_ena:1;
 
 	/* queue information */
 	u8 tx_mapping_mode;		 /* ICE_MAP_MODE_[CONTIG|SCATTER] */
@@ -384,7 +384,7 @@ struct ice_pf {
 	struct ice_hw_port_stats stats;
 	struct ice_hw_port_stats stats_prev;
 	struct ice_hw hw;
-	u8 stat_prev_loaded;	/* has previous stats been loaded */
+	u8 stat_prev_loaded:1; /* has previous stats been loaded */
 #ifdef CONFIG_DCB
 	u16 dcbx_cap;
 #endif /* CONFIG_DCB */
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 4cff52ffefe0..ec76aba347b9 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -166,7 +166,7 @@ struct ice_ring {
 	u16 q_index;			/* Queue number of ring */
 	u16 q_handle;			/* Queue handle per TC */
 
-	u8 ring_active;			/* is ring online or not */
+	u8 ring_active:1;		/* is ring online or not */
 
 	u16 count;			/* Number of descriptors */
 	u16 reg_idx;			/* HW register index of the ring */
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 3725aea16840..60f024ae281d 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -55,8 +55,8 @@ struct ice_vf {
 	struct virtchnl_version_info vf_ver;
 	struct virtchnl_ether_addr dflt_lan_addr;
 	u16 port_vlan_id;
-	u8 pf_set_mac;			/* VF MAC address set by VMM admin */
-	u8 trusted;
+	u8 pf_set_mac:1;		/* VF MAC address set by VMM admin */
+	u8 trusted:1;
 	u16 lan_vsi_idx;		/* index into PF struct */
 	u16 lan_vsi_num;		/* ID as used by firmware */
 	u64 num_mdd_events;		/* number of MDD events detected */
@@ -65,9 +65,9 @@ struct ice_vf {
 	unsigned long vf_caps;		/* VF's adv. capabilities */
 	DECLARE_BITMAP(vf_states, ICE_VF_STATES_NBITS);	/* VF runtime states */
 	unsigned int tx_rate;		/* Tx bandwidth limit in Mbps */
-	u8 link_forced;
-	u8 link_up;			/* only valid if VF link is forced */
-	u8 spoofchk;
+	u8 link_forced:1;
+	u8 link_up:1;			/* only valid if VF link is forced */
+	u8 spoofchk:1;
 	u16 num_mac;
 	u16 num_vlan;
 	u16 num_vf_qs;			/* num of queue configured per VF */
-- 
2.21.0

