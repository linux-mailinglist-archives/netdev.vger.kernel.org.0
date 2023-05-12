Return-Path: <netdev+bounces-2188-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 603A2700B55
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:21:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 783C81C20EE0
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:21:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE4BA1426C;
	Fri, 12 May 2023 15:20:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FEB14262;
	Fri, 12 May 2023 15:20:11 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145E23AAD;
	Fri, 12 May 2023 08:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683904807; x=1715440807;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wWhxMWiLcPZY9NZb4EwY/NQl1nkjgZ1XPyV3TLzPC7M=;
  b=DEwBoAXZu/vqmNqmC+VA1fXIECen+IeTqxwznaWnCQ+G71qrfktjNr7R
   hgrn2Fa2cV1y02cMoDXhgILdldyOfXSEUV9Xq3BxZ34gqjDEImSUj/ufs
   AMsUflEgcEEcDzGHojCA2LlWP2wtD1wS1hLb1QPg3LbGUdT25weLLLhm4
   fmqqFikciCNhKJCLvA/zCSJWuYPFoYC4wBJDFtOBVhYyb2gPWNvZ3wCPg
   SsC6M8trMAgHSCIB7SeinqL2ZLy9NhpnU5NglwyuFVGt9GZl8mP8bg8H1
   wAo2O+AerOJHqyK7Qiu2d+ndeWLoCZSzspBbAGx1Wdyv5Q3bGog3gph3w
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="331173796"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="331173796"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 08:20:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="765196640"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="765196640"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga008.fm.intel.com with ESMTP; 12 May 2023 08:20:03 -0700
Received: from lincoln.igk.intel.com (lincoln.igk.intel.com [10.102.21.235])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id 0738A35FB7;
	Fri, 12 May 2023 16:20:00 +0100 (IST)
From: Larysa Zaremba <larysa.zaremba@intel.com>
To: bpf@vger.kernel.org
Cc: Larysa Zaremba <larysa.zaremba@intel.com>,
	Stanislav Fomichev <sdf@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yhs@fb.com>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Anatoly Burakov <anatoly.burakov@intel.com>,
	Jesper Dangaard Brouer <brouer@redhat.com>,
	Alexander Lobakin <alexandr.lobakin@intel.com>,
	Magnus Karlsson <magnus.karlsson@gmail.com>,
	Maryam Tahhan <mtahhan@redhat.com>,
	xdp-hints@xdp-project.net,
	netdev@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 03/15] ice: make RX checksum checking code more reusable
Date: Fri, 12 May 2023 17:16:27 +0200
Message-Id: <20230512151639.992033-4-larysa.zaremba@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230512151639.992033-1-larysa.zaremba@intel.com>
References: <20230512151639.992033-1-larysa.zaremba@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Previously, we only needed RX checksum flags in skb path,
hence all related code was written with skb in mind.
But with the addition of XDP hints via kfuncs to the ice driver,
the same logic will be needed in .xmo_() callbacks.

Put generic process of determining checksum status into
a separate function.

Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 71 ++++++++++++-------
 1 file changed, 46 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 1aab79dc8915..6a4fd3f3fc0a 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -104,17 +104,17 @@ ice_rx_hash_to_skb(struct ice_rx_ring *rx_ring,
 }
 
 /**
- * ice_rx_csum - Indicate in skb if checksum is good
- * @ring: the ring we care about
- * @skb: skb currently being received and modified
+ * ice_rx_csum_checked - Indicates, whether hardware has checked the checksum
  * @rx_desc: the receive descriptor
  * @ptype: the packet type decoded by hardware
+ * @csum_lvl_dst: address to put checksum level into
+ * @ring: ring for error stats, can be NULL
  *
- * skb->protocol must be set before this function is called
+ * Returns true, if hardware has checked the checksum.
  */
-static void
-ice_rx_csum(struct ice_rx_ring *ring, struct sk_buff *skb,
-	    union ice_32b_rx_flex_desc *rx_desc, u16 ptype)
+static bool
+ice_rx_csum_checked(union ice_32b_rx_flex_desc *rx_desc, u16 ptype,
+		    u8 *csum_lvl_dst, struct ice_rx_ring *ring)
 {
 	struct ice_rx_ptype_decoded decoded;
 	u16 rx_status0, rx_status1;
@@ -125,20 +125,12 @@ ice_rx_csum(struct ice_rx_ring *ring, struct sk_buff *skb,
 
 	decoded = ice_decode_rx_desc_ptype(ptype);
 
-	/* Start with CHECKSUM_NONE and by default csum_level = 0 */
-	skb->ip_summed = CHECKSUM_NONE;
-	skb_checksum_none_assert(skb);
-
-	/* check if Rx checksum is enabled */
-	if (!(ring->netdev->features & NETIF_F_RXCSUM))
-		return;
-
 	/* check if HW has decoded the packet and checksum */
 	if (!(rx_status0 & BIT(ICE_RX_FLEX_DESC_STATUS0_L3L4P_S)))
-		return;
+		return false;
 
 	if (!(decoded.known && decoded.outer_ip))
-		return;
+		return false;
 
 	ipv4 = (decoded.outer_ip == ICE_RX_PTYPE_OUTER_IP) &&
 	       (decoded.outer_ip_ver == ICE_RX_PTYPE_OUTER_IPV4);
@@ -168,22 +160,51 @@ ice_rx_csum(struct ice_rx_ring *ring, struct sk_buff *skb,
 	 * we are indicating we validated the inner checksum.
 	 */
 	if (decoded.tunnel_type >= ICE_RX_PTYPE_TUNNEL_IP_GRENAT)
-		skb->csum_level = 1;
+		*csum_lvl_dst = 1;
 
 	/* Only report checksum unnecessary for TCP, UDP, or SCTP */
 	switch (decoded.inner_prot) {
 	case ICE_RX_PTYPE_INNER_PROT_TCP:
 	case ICE_RX_PTYPE_INNER_PROT_UDP:
 	case ICE_RX_PTYPE_INNER_PROT_SCTP:
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
-		break;
-	default:
-		break;
+		return true;
 	}
-	return;
+
+	return false;
 
 checksum_fail:
-	ring->vsi->back->hw_csum_rx_error++;
+	if (ring)
+		ring->vsi->back->hw_csum_rx_error++;
+
+	return false;
+}
+
+/**
+ * ice_rx_csum_into_skb - Indicate in skb if checksum is good
+ * @ring: the ring we care about
+ * @skb: skb currently being received and modified
+ * @rx_desc: the receive descriptor
+ * @ptype: the packet type decoded by hardware
+ */
+static void
+ice_rx_csum_into_skb(struct ice_rx_ring *ring, struct sk_buff *skb,
+		     union ice_32b_rx_flex_desc *rx_desc, u16 ptype)
+{
+	u8 csum_level = 0;
+
+	/* Start with CHECKSUM_NONE and by default csum_level = 0 */
+	skb->ip_summed = CHECKSUM_NONE;
+	skb_checksum_none_assert(skb);
+
+	/* check if Rx checksum is enabled */
+	if (!(ring->netdev->features & NETIF_F_RXCSUM))
+		return;
+
+	if (!ice_rx_csum_checked(rx_desc, ptype, &csum_level, ring))
+		return;
+
+	skb->ip_summed = CHECKSUM_UNNECESSARY;
+	skb->csum_level = csum_level;
 }
 
 /**
@@ -232,7 +253,7 @@ ice_process_skb_fields(struct ice_rx_ring *rx_ring,
 	/* modifies the skb - consumes the enet header */
 	skb->protocol = eth_type_trans(skb, rx_ring->netdev);
 
-	ice_rx_csum(rx_ring, skb, rx_desc, ptype);
+	ice_rx_csum_into_skb(rx_ring, skb, rx_desc, ptype);
 
 	if (rx_ring->ptp_rx)
 		ice_ptp_rx_hwts_to_skb(rx_ring, rx_desc, skb);
-- 
2.35.3


