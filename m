Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73B071160C
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 11:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfEBJGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 05:06:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:47595 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726391AbfEBJG0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 05:06:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 02:06:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,421,1549958400"; 
   d="scan'208";a="147615355"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 02 May 2019 02:06:23 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/15] ice: Add ability to update rx-usecs-high
Date:   Thu,  2 May 2019 02:06:13 -0700
Message-Id: <20190502090620.21281-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190502090620.21281-1-jeffrey.t.kirsher@intel.com>
References: <20190502090620.21281-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently the driver allows rx-usecs-high values to be set,
but when querying the device for rx-usecs-high the value
does not stick. This is because it was not yet implemented.
Add code to allow the user to change rx-usecs-high and
use this to set the q_vector's intrl value.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 31 +++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_lib.c     |  2 +-
 drivers/net/ethernet/intel/ice/ice_lib.h     |  1 +
 drivers/net/ethernet/intel/ice/ice_txrx.h    |  1 +
 4 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 64a4c4456ba0..f995ed599cd9 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2228,12 +2228,18 @@ static int
 ice_get_rc_coalesce(struct ethtool_coalesce *ec, enum ice_container_type c_type,
 		    struct ice_ring_container *rc)
 {
-	struct ice_pf *pf = rc->ring->vsi->back;
+	struct ice_pf *pf;
+
+	if (!rc->ring)
+		return -EINVAL;
+
+	pf = rc->ring->vsi->back;
 
 	switch (c_type) {
 	case ICE_RX_CONTAINER:
 		ec->use_adaptive_rx_coalesce = ITR_IS_DYNAMIC(rc->itr_setting);
 		ec->rx_coalesce_usecs = rc->itr_setting & ~ICE_ITR_DYNAMIC;
+		ec->rx_coalesce_usecs_high = rc->ring->q_vector->intrl;
 		break;
 	case ICE_TX_CONTAINER:
 		ec->use_adaptive_tx_coalesce = ITR_IS_DYNAMIC(rc->itr_setting);
@@ -2342,6 +2348,23 @@ ice_set_rc_coalesce(enum ice_container_type c_type, struct ethtool_coalesce *ec,
 
 	switch (c_type) {
 	case ICE_RX_CONTAINER:
+		if (ec->rx_coalesce_usecs_high > ICE_MAX_INTRL ||
+		    (ec->rx_coalesce_usecs_high &&
+		     ec->rx_coalesce_usecs_high < pf->hw.intrl_gran)) {
+			netdev_info(vsi->netdev,
+				    "Invalid value, rx-usecs-high valid values are 0 (disabled), %d-%d\n",
+				    pf->hw.intrl_gran, ICE_MAX_INTRL);
+			return -EINVAL;
+		}
+
+		if (ec->rx_coalesce_usecs_high != rc->ring->q_vector->intrl) {
+			rc->ring->q_vector->intrl = ec->rx_coalesce_usecs_high;
+			wr32(&pf->hw, GLINT_RATE(vsi->hw_base_vector +
+						 rc->ring->q_vector->v_idx),
+			     ice_intrl_usec_to_reg(ec->rx_coalesce_usecs_high,
+						   pf->hw.intrl_gran));
+		}
+
 		if (ec->rx_coalesce_usecs != itr_setting &&
 		    ec->use_adaptive_rx_coalesce) {
 			netdev_info(vsi->netdev,
@@ -2364,6 +2387,12 @@ ice_set_rc_coalesce(enum ice_container_type c_type, struct ethtool_coalesce *ec,
 		}
 		break;
 	case ICE_TX_CONTAINER:
+		if (ec->tx_coalesce_usecs_high) {
+			netdev_info(vsi->netdev,
+				    "setting tx-usecs-high is not supported\n");
+			return -EINVAL;
+		}
+
 		if (ec->tx_coalesce_usecs != itr_setting &&
 		    ec->use_adaptive_tx_coalesce) {
 			netdev_info(vsi->netdev,
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 982a3a9e9b8d..4c6ecc25aaa0 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1764,7 +1764,7 @@ int ice_vsi_cfg_lan_txqs(struct ice_vsi *vsi)
  * This function converts a decimal interrupt rate limit in usecs to the format
  * expected by firmware.
  */
-static u32 ice_intrl_usec_to_reg(u8 intrl, u8 gran)
+u32 ice_intrl_usec_to_reg(u8 intrl, u8 gran)
 {
 	u32 val = intrl / gran;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 714ace077796..a91d3553cc89 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -80,4 +80,5 @@ void ice_vsi_free_tx_rings(struct ice_vsi *vsi);
 
 int ice_vsi_manage_rss_lut(struct ice_vsi *vsi, bool ena);
 
+u32 ice_intrl_usec_to_reg(u8 intrl, u8 gran);
 #endif /* !_ICE_LIB_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index c75d9fd12a68..66e05032ee56 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -142,6 +142,7 @@ enum ice_rx_dtype {
 #define ICE_ITR_ADAPTIVE_BULK		0x0000
 
 #define ICE_DFLT_INTRL	0
+#define ICE_MAX_INTRL	236
 
 /* Legacy or Advanced Mode Queue */
 #define ICE_TX_ADVANCED	0
-- 
2.20.1

