Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753DD23229E
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgG2QYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:24:38 -0400
Received: from mga06.intel.com ([134.134.136.31]:42163 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726581AbgG2QYQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 12:24:16 -0400
IronPort-SDR: L0f1xXpYBJYBGjO/prnQSCWLnfccoTE3XX++O0I2ZVr2cAfCvHBmIbJxqH+JoVN//0bTwQkOUa
 h4aKLRhG2ptw==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="212982335"
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="212982335"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 09:24:14 -0700
IronPort-SDR: 98RNFNFpLpXdc5dyOcOcQUUKcr1wmL9Z5qnRuAHXdV8dOe39VxA2NEORjss6mq89HblVC/hGsL
 tE/BznSqmvJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="313087578"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 29 Jul 2020 09:24:14 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Tarun Singh <tarun.k.singh@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 08/15] ice: Adjust scheduler default BW weight
Date:   Wed, 29 Jul 2020 09:23:58 -0700
Message-Id: <20200729162405.1596435-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
References: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tarun Singh <tarun.k.singh@intel.com>

By default the queues are configured in legacy mode. The default
BW settings for legacy/advanced modes are different. The existing
code was using the advanced mode default value of 1 which was
incorrect. This caused the unbalanced BW sharing among siblings.
The recommended default value is applied.

Signed-off-by: Tarun Singh <tarun.k.singh@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 13 ++++++++++++-
 drivers/net/ethernet/intel/ice/ice_type.h   |  2 +-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index fd9534568bf3..35644fe6235a 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3907,7 +3907,18 @@ ice_ena_vsi_txq(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u16 q_handle,
 	 * Without setting the generic section as valid in valid_sections, the
 	 * Admin queue command will fail with error code ICE_AQ_RC_EINVAL.
 	 */
-	buf->txqs[0].info.valid_sections = ICE_AQC_ELEM_VALID_GENERIC;
+	buf->txqs[0].info.valid_sections =
+		ICE_AQC_ELEM_VALID_GENERIC | ICE_AQC_ELEM_VALID_CIR |
+		ICE_AQC_ELEM_VALID_EIR;
+	buf->txqs[0].info.generic = 0;
+	buf->txqs[0].info.cir_bw.bw_profile_idx =
+		cpu_to_le16(ICE_SCHED_DFLT_RL_PROF_ID);
+	buf->txqs[0].info.cir_bw.bw_alloc =
+		cpu_to_le16(ICE_SCHED_DFLT_BW_WT);
+	buf->txqs[0].info.eir_bw.bw_profile_idx =
+		cpu_to_le16(ICE_SCHED_DFLT_RL_PROF_ID);
+	buf->txqs[0].info.eir_bw.bw_alloc =
+		cpu_to_le16(ICE_SCHED_DFLT_BW_WT);
 
 	/* add the LAN queue */
 	status = ice_aq_add_lan_txq(hw, num_qgrps, buf, buf_size, cd);
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index e4349475790f..1eb83d9b0546 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -409,7 +409,7 @@ enum ice_rl_type {
 #define ICE_SCHED_DFLT_BW		0xFFFFFFFF	/* unlimited */
 #define ICE_SCHED_DFLT_RL_PROF_ID	0
 #define ICE_SCHED_NO_SHARED_RL_PROF_ID	0xFFFF
-#define ICE_SCHED_DFLT_BW_WT		1
+#define ICE_SCHED_DFLT_BW_WT		4
 #define ICE_SCHED_INVAL_PROF_ID		0xFFFF
 #define ICE_SCHED_DFLT_BURST_SIZE	(15 * 1024)	/* in bytes (15k) */
 
-- 
2.26.2

