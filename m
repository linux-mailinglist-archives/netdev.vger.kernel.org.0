Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA1DE7CEE5
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 22:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730871AbfGaUl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 16:41:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:2709 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730760AbfGaUly (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 16:41:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jul 2019 13:41:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,331,1559545200"; 
   d="scan'208";a="323901038"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 31 Jul 2019 13:41:48 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/16] ice: Add stats for Rx drops at the port level
Date:   Wed, 31 Jul 2019 13:41:42 -0700
Message-Id: <20190731204147.8582-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731204147.8582-1-jeffrey.t.kirsher@intel.com>
References: <20190731204147.8582-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently we are not reporting dropped counts at the port level to
ethtool or netlink. This was found when debugging Rx dropped issues
and the total packets sent did not equal the total packets received
minus the rx_dropped, which was very confusing. To determine dropped
counts at the port level we need to read the PRTRPB_RDPC register.
To fix reporting we will store the dropped counts in the PF's
rx_discards. This will be reported to netlink by storing it in the
PF VSI's rx_missed_errors signaling that the receiver missed the
packet. Also, we will report this to ethtool in the rx_dropped.nic
field.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h | 1 +
 drivers/net/ethernet/intel/ice/ice_main.c       | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 3250dfc00002..87652d722a30 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -337,5 +337,6 @@
 #define VSIQF_HLUT_MAX_INDEX			15
 #define VFINT_DYN_CTLN(_i)			(0x00003800 + ((_i) * 4))
 #define VFINT_DYN_CTLN_CLEARPBA_M		BIT(1)
+#define PRTRPB_RDPC				0x000AC260
 
 #endif /* _ICE_HW_AUTOGEN_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d13f56803658..e4be9aa79337 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3297,6 +3297,8 @@ static void ice_update_vsi_stats(struct ice_vsi *vsi)
 		cur_ns->rx_errors = pf->stats.crc_errors +
 				    pf->stats.illegal_bytes;
 		cur_ns->rx_length_errors = pf->stats.rx_len_errors;
+		/* record drops from the port level */
+		cur_ns->rx_missed_errors = pf->stats.eth.rx_discards;
 	}
 }
 
@@ -3330,6 +3332,10 @@ static void ice_update_pf_stats(struct ice_pf *pf)
 			  &prev_ps->eth.rx_broadcast,
 			  &cur_ps->eth.rx_broadcast);
 
+	ice_stat_update32(hw, PRTRPB_RDPC, pf->stat_prev_loaded,
+			  &prev_ps->eth.rx_discards,
+			  &cur_ps->eth.rx_discards);
+
 	ice_stat_update40(hw, GLPRT_GOTCL(pf_id), pf->stat_prev_loaded,
 			  &prev_ps->eth.tx_bytes,
 			  &cur_ps->eth.tx_bytes);
-- 
2.21.0

