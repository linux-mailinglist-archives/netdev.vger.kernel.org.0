Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D7D39BC98
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 18:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhFDQLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 12:11:30 -0400
Received: from mga04.intel.com ([192.55.52.120]:16626 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229958AbhFDQLa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 12:11:30 -0400
IronPort-SDR: kntF3PtvLYbKdERymteXc6wFER/ctZ9WsrjgooZKfOd9iVWnn3VuniohxmBf6/UEjGHiBhrTlB
 wn0wq6n4O9jA==
X-IronPort-AV: E=McAfee;i="6200,9189,10005"; a="202460189"
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="202460189"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 09:06:04 -0700
IronPort-SDR: ZhiglMDCQ+syBP5gGGfFRZfaV4VTtTUTG3MZ8NUyCHFCyvIVW3TGUkz+41LTFPMaEPS+2Fdm/7
 9P+s5V2Ukb8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="475511744"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Jun 2021 09:05:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 5/6] ice: Allow all LLDP packets from PF to Tx
Date:   Fri,  4 Jun 2021 09:08:15 -0700
Message-Id: <20210604160816.3391716-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210604160816.3391716-1-anthony.l.nguyen@intel.com>
References: <20210604160816.3391716-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

Currently in the ice driver, the check whether to
allow a LLDP packet to egress the interface from the
PF_VSI is being based on the SKB's priority field.
It checks to see if the packets priority is equal to
TC_PRIO_CONTROL.  Injected LLDP packets do not always
meet this condition.

SCAPY defaults to a sk_buff->protocol value of ETH_P_ALL
(0x0003) and does not set the priority field.  There will
be other injection methods (even ones used by end users)
that will not correctly configure the socket so that
SKB fields are correctly populated.

Then ethernet header has to have to correct value for
the protocol though.

Add a check to also allow packets whose ethhdr->h_proto
matches ETH_P_LLDP (0x88CC).

Fixes: 0c3a6101ff2d ("ice: Allow egress control packets from PF_VSI")
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 93e5d9ebfd74..04748aa4c7c8 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -2149,6 +2149,7 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_ring *tx_ring)
 	struct ice_tx_offload_params offload = { 0 };
 	struct ice_vsi *vsi = tx_ring->vsi;
 	struct ice_tx_buf *first;
+	struct ethhdr *eth;
 	unsigned int count;
 	int tso, csum;
 
@@ -2195,7 +2196,9 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_ring *tx_ring)
 		goto out_drop;
 
 	/* allow CONTROL frames egress from main VSI if FW LLDP disabled */
-	if (unlikely(skb->priority == TC_PRIO_CONTROL &&
+	eth = (struct ethhdr *)skb_mac_header(skb);
+	if (unlikely((skb->priority == TC_PRIO_CONTROL ||
+		      eth->h_proto == htons(ETH_P_LLDP)) &&
 		     vsi->type == ICE_VSI_PF &&
 		     vsi->port_info->qos_cfg.is_sw_lldp))
 		offload.cd_qw1 |= (u64)(ICE_TX_DESC_DTYPE_CTX |
-- 
2.26.2

