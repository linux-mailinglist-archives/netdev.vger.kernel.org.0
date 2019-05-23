Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7648928D37
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 00:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388738AbfEWWdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 18:33:50 -0400
Received: from mga12.intel.com ([192.55.52.136]:19068 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388498AbfEWWdj (ORCPT <rfc822;netdev@vger.kernel.org>);
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
Subject: [net-next 13/15] ice: Reorganize ice_vf struct
Date:   Thu, 23 May 2019 15:33:38 -0700
Message-Id: <20190523223340.13449-14-jeffrey.t.kirsher@intel.com>
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

The ice_vf struct can be used hundreds of times in our
driver so it pays to use less memory per struct.

ice_vf prior to this commit:
  /* size: 112, cachelines: 2, members: 25 */
  /* sum members: 101, holes: 4, sum holes: 8 */
  /* bit holes: 2, sum bit holes: 11 bits */
  /* padding: 3 */
  /* last cacheline: 48 bytes */

ice_vf after this commit:
  /* size: 104, cachelines: 2, members: 25 */
  /* sum members: 100, holes: 3, sum holes: 4 */
  /* bit holes: 1, sum bit holes: 3 bits */
  /* last cacheline: 40 bytes */

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  | 21 ++++++++++++-------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 60f024ae281d..9583ad3f6fb6 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -49,29 +49,34 @@ struct ice_vf {
 	struct ice_pf *pf;
 
 	s16 vf_id;			/* VF ID in the PF space */
-	u32 driver_caps;		/* reported by VF driver */
+	u16 lan_vsi_idx;		/* index into PF struct */
 	int first_vector_idx;		/* first vector index of this VF */
 	struct ice_sw *vf_sw_id;	/* switch ID the VF VSIs connect to */
 	struct virtchnl_version_info vf_ver;
+	u32 driver_caps;		/* reported by VF driver */
 	struct virtchnl_ether_addr dflt_lan_addr;
 	u16 port_vlan_id;
 	u8 pf_set_mac:1;		/* VF MAC address set by VMM admin */
 	u8 trusted:1;
-	u16 lan_vsi_idx;		/* index into PF struct */
+	u8 spoofchk:1;
+	u8 link_forced:1;
+	u8 link_up:1;			/* only valid if VF link is forced */
+	/* VSI indices - actual VSI pointers are maintained in the PF structure
+	 * When assigned, these will be non-zero, because VSI 0 is always
+	 * the main LAN VSI for the PF.
+	 */
 	u16 lan_vsi_num;		/* ID as used by firmware */
+	unsigned int tx_rate;		/* Tx bandwidth limit in Mbps */
+	DECLARE_BITMAP(vf_states, ICE_VF_STATES_NBITS);	/* VF runtime states */
+
 	u64 num_mdd_events;		/* number of MDD events detected */
 	u64 num_inval_msgs;		/* number of continuous invalid msgs */
 	u64 num_valid_msgs;		/* number of valid msgs detected */
 	unsigned long vf_caps;		/* VF's adv. capabilities */
-	DECLARE_BITMAP(vf_states, ICE_VF_STATES_NBITS);	/* VF runtime states */
-	unsigned int tx_rate;		/* Tx bandwidth limit in Mbps */
-	u8 link_forced:1;
-	u8 link_up:1;			/* only valid if VF link is forced */
-	u8 spoofchk:1;
+	u8 num_req_qs;			/* num of queue pairs requested by VF */
 	u16 num_mac;
 	u16 num_vlan;
 	u16 num_vf_qs;			/* num of queue configured per VF */
-	u8 num_req_qs;			/* num of queue pairs requested by VF */
 };
 
 #ifdef CONFIG_PCI_IOV
-- 
2.21.0

