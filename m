Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48CE1E9798
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 14:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbgEaMg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 08:36:26 -0400
Received: from mga12.intel.com ([192.55.52.136]:12463 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726901AbgEaMgY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 08:36:24 -0400
IronPort-SDR: GB1xVSBj5LPmFXxAhGvtHb3G2rjJ5b6AtOYsAqmcRN1qEWxWnrOc5HbgCZDUwS95joODGDG5pD
 MSRMTNV6hrPQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2020 05:36:22 -0700
IronPort-SDR: S7MywUHeCQwqNgnTRQgt1azKP75HcZLZTaf2/aSMiif3eypChC/AHGzoJj5aewmSjMyFt6nP8E
 yuxSz2/fUTiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,456,1583222400"; 
   d="scan'208";a="303345423"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 31 May 2020 05:36:22 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/14] ice: Fix transmit for all software offloaded VLANs
Date:   Sun, 31 May 2020 05:36:08 -0700
Message-Id: <20200531123619.2887469-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
References: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently the driver does not recognize when there is an 802.1AD VLAN
tag right after the dmac/smac (outermost VLAN tag). If any DCB map is
applied and/or DCB is enabled this is causing the hardware to insert a
VLAN 0 tag after the 802.1AD VLAN tag that is already in the packet.
Fix this by preventing VLAN tag 0 from being added when any VLAN is
already present after dmac/smac (software offloaded) or skb (hardware
offloaded).

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c | 28 +++++-------
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h |  2 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c    | 45 +++++---------------
 3 files changed, 21 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 3c7f604c0c49..979af197f8a3 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -791,39 +791,31 @@ void ice_update_dcb_stats(struct ice_pf *pf)
  * ice_tx_prepare_vlan_flags_dcb - prepare VLAN tagging for DCB
  * @tx_ring: ring to send buffer on
  * @first: pointer to struct ice_tx_buf
+ *
+ * This should not be called if the outer VLAN is software offloaded as the VLAN
+ * tag will already be configured with the correct ID and priority bits
  */
-int
+void
 ice_tx_prepare_vlan_flags_dcb(struct ice_ring *tx_ring,
 			      struct ice_tx_buf *first)
 {
 	struct sk_buff *skb = first->skb;
 
 	if (!test_bit(ICE_FLAG_DCB_ENA, tx_ring->vsi->back->flags))
-		return 0;
+		return;
 
 	/* Insert 802.1p priority into VLAN header */
-	if ((first->tx_flags & (ICE_TX_FLAGS_HW_VLAN | ICE_TX_FLAGS_SW_VLAN)) ||
+	if ((first->tx_flags & ICE_TX_FLAGS_HW_VLAN) ||
 	    skb->priority != TC_PRIO_CONTROL) {
 		first->tx_flags &= ~ICE_TX_FLAGS_VLAN_PR_M;
 		/* Mask the lower 3 bits to set the 802.1p priority */
 		first->tx_flags |= (skb->priority & 0x7) <<
 				   ICE_TX_FLAGS_VLAN_PR_S;
-		if (first->tx_flags & ICE_TX_FLAGS_SW_VLAN) {
-			struct vlan_ethhdr *vhdr;
-			int rc;
-
-			rc = skb_cow_head(skb, 0);
-			if (rc < 0)
-				return rc;
-			vhdr = (struct vlan_ethhdr *)skb->data;
-			vhdr->h_vlan_TCI = htons(first->tx_flags >>
-						 ICE_TX_FLAGS_VLAN_S);
-		} else {
-			first->tx_flags |= ICE_TX_FLAGS_HW_VLAN;
-		}
+		/* if this is not already set it means a VLAN 0 + priority needs
+		 * to be offloaded
+		 */
+		first->tx_flags |= ICE_TX_FLAGS_HW_VLAN;
 	}
-
-	return 0;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
index 7c42324494d2..323238669572 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
@@ -27,7 +27,7 @@ void ice_pf_dcb_recfg(struct ice_pf *pf);
 void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi);
 int ice_init_pf_dcb(struct ice_pf *pf, bool locked);
 void ice_update_dcb_stats(struct ice_pf *pf);
-int
+void
 ice_tx_prepare_vlan_flags_dcb(struct ice_ring *tx_ring,
 			      struct ice_tx_buf *first);
 void
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index cda7e05bd8ae..abdb137c8bb7 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -2053,49 +2053,25 @@ int ice_tx_csum(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
  *
  * Checks the skb and set up correspondingly several generic transmit flags
  * related to VLAN tagging for the HW, such as VLAN, DCB, etc.
- *
- * Returns error code indicate the frame should be dropped upon error and the
- * otherwise returns 0 to indicate the flags has been set properly.
  */
-static int
+static void
 ice_tx_prepare_vlan_flags(struct ice_ring *tx_ring, struct ice_tx_buf *first)
 {
 	struct sk_buff *skb = first->skb;
-	__be16 protocol = skb->protocol;
-
-	if (protocol == htons(ETH_P_8021Q) &&
-	    !(tx_ring->netdev->features & NETIF_F_HW_VLAN_CTAG_TX)) {
-		/* when HW VLAN acceleration is turned off by the user the
-		 * stack sets the protocol to 8021q so that the driver
-		 * can take any steps required to support the SW only
-		 * VLAN handling. In our case the driver doesn't need
-		 * to take any further steps so just set the protocol
-		 * to the encapsulated ethertype.
-		 */
-		skb->protocol = vlan_get_protocol(skb);
-		return 0;
-	}
 
-	/* if we have a HW VLAN tag being added, default to the HW one */
+	/* nothing left to do, software offloaded VLAN */
+	if (!skb_vlan_tag_present(skb) && eth_type_vlan(skb->protocol))
+		return;
+
+	/* currently, we always assume 802.1Q for VLAN insertion as VLAN
+	 * insertion for 802.1AD is not supported
+	 */
 	if (skb_vlan_tag_present(skb)) {
 		first->tx_flags |= skb_vlan_tag_get(skb) << ICE_TX_FLAGS_VLAN_S;
 		first->tx_flags |= ICE_TX_FLAGS_HW_VLAN;
-	} else if (protocol == htons(ETH_P_8021Q)) {
-		struct vlan_hdr *vhdr, _vhdr;
-
-		/* for SW VLAN, check the next protocol and store the tag */
-		vhdr = (struct vlan_hdr *)skb_header_pointer(skb, ETH_HLEN,
-							     sizeof(_vhdr),
-							     &_vhdr);
-		if (!vhdr)
-			return -EINVAL;
-
-		first->tx_flags |= ntohs(vhdr->h_vlan_TCI) <<
-				   ICE_TX_FLAGS_VLAN_S;
-		first->tx_flags |= ICE_TX_FLAGS_SW_VLAN;
 	}
 
-	return ice_tx_prepare_vlan_flags_dcb(tx_ring, first);
+	ice_tx_prepare_vlan_flags_dcb(tx_ring, first);
 }
 
 /**
@@ -2403,8 +2379,7 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_ring *tx_ring)
 	first->tx_flags = 0;
 
 	/* prepare the VLAN tagging flags for Tx */
-	if (ice_tx_prepare_vlan_flags(tx_ring, first))
-		goto out_drop;
+	ice_tx_prepare_vlan_flags(tx_ring, first);
 
 	/* set up TSO offload */
 	tso = ice_tso(first, &offload);
-- 
2.26.2

