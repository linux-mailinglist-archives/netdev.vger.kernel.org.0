Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF179B8F2
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 01:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfHWXhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 19:37:55 -0400
Received: from mga06.intel.com ([134.134.136.31]:14902 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726991AbfHWXhx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 19:37:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 16:37:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,422,1559545200"; 
   d="scan'208";a="184354408"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 23 Aug 2019 16:37:50 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/14] ice: Allow egress control packets from PF_VSI
Date:   Fri, 23 Aug 2019 16:37:37 -0700
Message-Id: <20190823233750.7997-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190823233750.7997-1-jeffrey.t.kirsher@intel.com>
References: <20190823233750.7997-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

For control packets (i.e. LLDP packets) to be able to egress
from the main VSI, a bit has to be set in the TX_descriptor.
This should only be done for the main VSI and only if the
FW LLDP agent is disabled.  A bit to allow this also has to
be set in the VSI context.

Add the logic to add the necessary bits in the VSI context
for the PF_VSI and the TX_descriptors for control packets
egressing the PF_VSI.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c  |  7 +++++++
 drivers/net/ethernet/intel/ice/ice_txrx.c | 11 ++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 6e34c40e7840..d6279dfe029e 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1010,6 +1010,13 @@ static int ice_vsi_init(struct ice_vsi *vsi)
 			ICE_AQ_VSI_SEC_FLAG_ENA_MAC_ANTI_SPOOF;
 	}
 
+	/* Allow control frames out of main VSI */
+	if (vsi->type == ICE_VSI_PF) {
+		ctxt->info.sec_flags |= ICE_AQ_VSI_SEC_FLAG_ALLOW_DEST_OVRD;
+		ctxt->info.valid_sections |=
+			cpu_to_le16(ICE_AQ_VSI_PROP_SECURITY_VALID);
+	}
+
 	ret = ice_add_vsi(hw, vsi->idx, ctxt, NULL);
 	if (ret) {
 		dev_err(&pf->pdev->dev,
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index e5c4c9139e54..5bf5c179a738 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -2106,6 +2106,7 @@ static netdev_tx_t
 ice_xmit_frame_ring(struct sk_buff *skb, struct ice_ring *tx_ring)
 {
 	struct ice_tx_offload_params offload = { 0 };
+	struct ice_vsi *vsi = tx_ring->vsi;
 	struct ice_tx_buf *first;
 	unsigned int count;
 	int tso, csum;
@@ -2153,7 +2154,15 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_ring *tx_ring)
 	if (csum < 0)
 		goto out_drop;
 
-	if (tso || offload.cd_tunnel_params) {
+	/* allow CONTROL frames egress from main VSI if FW LLDP disabled */
+	if (unlikely(skb->priority == TC_PRIO_CONTROL &&
+		     vsi->type == ICE_VSI_PF &&
+		     vsi->port_info->is_sw_lldp))
+		offload.cd_qw1 |= (u64)(ICE_TX_DESC_DTYPE_CTX |
+					ICE_TX_CTX_DESC_SWTCH_UPLINK <<
+					ICE_TXD_CTX_QW1_CMD_S);
+
+	if (offload.cd_qw1 & ICE_TX_DESC_DTYPE_CTX) {
 		struct ice_tx_ctx_desc *cdesc;
 		int i = tx_ring->next_to_use;
 
-- 
2.21.0

