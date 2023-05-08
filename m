Return-Path: <netdev+bounces-919-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9FC66FB611
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 19:46:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D855A1C20A3C
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 17:46:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87205610B;
	Mon,  8 May 2023 17:46:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775164424
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 17:46:00 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B3A35BD
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 10:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683567958; x=1715103958;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=U0tVdpDr1Rcq4oJUAykl8mhVuYZKbf/9+wVS4bXPpRE=;
  b=RpXKuTyuyGgofGRV2tg1AHjIgRiw+WZsEyOkHMxFPXXsgKrS1J83OC9b
   mOmYv5IFV29yl33VIen7mvtDM5rhDGdMZiaF+M7x6G5txRfYJuvSdb01R
   SicEzbFJOACpF/Xe4V+Jrd9uOtBNtUBa0zNlMO+y5Qj4XkuHl0hcrP0VH
   iWY/pJhB22d9GbBahiNNmDgnkokv5yU95tkZlf3QGLofQbLH/SJPg3DD8
   gikrwy+K+rmdmbjZOb6b+lErUOXyhOXs42T0kS/bWHKr21y6kVh4b1SGJ
   nSpS2Ufoge0SveQ1r2ybBv7d8yGfWKZpD0mF1Nh3vT15mSqWBGg4xn70e
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="329338869"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="329338869"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 10:45:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="788194091"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="788194091"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by FMSMGA003.fm.intel.com with ESMTP; 08 May 2023 10:45:58 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Jan Sokolowski <jan.sokolowski@intel.com>,
	anthony.l.nguyen@intel.com,
	maciej.fijalkowski@intel.com,
	daniel@iogearbox.net,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Michal Schmidt <mschmidt@redhat.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH net] ice: Fix undersized tx_flags variable
Date: Mon,  8 May 2023 10:42:25 -0700
Message-Id: <20230508174225.1707403-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jan Sokolowski <jan.sokolowski@intel.com>

As not all ICE_TX_FLAGS_* fit in current 16-bit limited
tx_flags field, some VLAN-related flags would not properly apply.

Fix that by refactoring tx_flags variable into flags only and
a separate variable that holds VLAN ID. As there is some space left,
type variable can fit between those two. Pahole reports no size
change to ice_tx_buf struct.

Fixes: aa1d3faf71a6 ("ice: Robustify cleaning/completing XDP Tx buffers")
Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Tested-by: Michal Schmidt <mschmidt@redhat.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c |  6 +++---
 drivers/net/ethernet/intel/ice/ice_txrx.c    |  8 +++-----
 drivers/net/ethernet/intel/ice/ice_txrx.h    | 12 ++++++------
 3 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index c6d4926f0fcf..6c212d0dbef3 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -932,10 +932,10 @@ ice_tx_prepare_vlan_flags_dcb(struct ice_tx_ring *tx_ring,
 	if ((first->tx_flags & ICE_TX_FLAGS_HW_VLAN ||
 	     first->tx_flags & ICE_TX_FLAGS_HW_OUTER_SINGLE_VLAN) ||
 	    skb->priority != TC_PRIO_CONTROL) {
-		first->tx_flags &= ~ICE_TX_FLAGS_VLAN_PR_M;
+		first->vid &= ~ICE_TX_VLAN_PR_M;
 		/* Mask the lower 3 bits to set the 802.1p priority */
-		first->tx_flags |= (skb->priority & 0x7) <<
-				   ICE_TX_FLAGS_VLAN_PR_S;
+		first->vid |= (skb->priority << ICE_TX_VLAN_PR_S) &
+			      ICE_TX_VLAN_PR_M;
 		/* if this is not already set it means a VLAN 0 + priority needs
 		 * to be offloaded
 		 */
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 4fcf2d07eb85..059bd911c51d 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1664,8 +1664,7 @@ ice_tx_map(struct ice_tx_ring *tx_ring, struct ice_tx_buf *first,
 
 	if (first->tx_flags & ICE_TX_FLAGS_HW_VLAN) {
 		td_cmd |= (u64)ICE_TX_DESC_CMD_IL2TAG1;
-		td_tag = (first->tx_flags & ICE_TX_FLAGS_VLAN_M) >>
-			  ICE_TX_FLAGS_VLAN_S;
+		td_tag = first->vid;
 	}
 
 	dma = dma_map_single(tx_ring->dev, skb->data, size, DMA_TO_DEVICE);
@@ -1998,7 +1997,7 @@ ice_tx_prepare_vlan_flags(struct ice_tx_ring *tx_ring, struct ice_tx_buf *first)
 	 * VLAN offloads exclusively so we only care about the VLAN ID here
 	 */
 	if (skb_vlan_tag_present(skb)) {
-		first->tx_flags |= skb_vlan_tag_get(skb) << ICE_TX_FLAGS_VLAN_S;
+		first->vid = skb_vlan_tag_get(skb);
 		if (tx_ring->flags & ICE_TX_FLAGS_RING_VLAN_L2TAG2)
 			first->tx_flags |= ICE_TX_FLAGS_HW_OUTER_SINGLE_VLAN;
 		else
@@ -2388,8 +2387,7 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 		offload.cd_qw1 |= (u64)(ICE_TX_DESC_DTYPE_CTX |
 					(ICE_TX_CTX_DESC_IL2TAG2 <<
 					ICE_TXD_CTX_QW1_CMD_S));
-		offload.cd_l2tag2 = (first->tx_flags & ICE_TX_FLAGS_VLAN_M) >>
-			ICE_TX_FLAGS_VLAN_S;
+		offload.cd_l2tag2 = first->vid;
 	}
 
 	/* set up TSO offload */
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index fff0efe28373..76a34d435025 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -127,10 +127,9 @@ static inline int ice_skb_pad(void)
 #define ICE_TX_FLAGS_IPV6	BIT(6)
 #define ICE_TX_FLAGS_TUNNEL	BIT(7)
 #define ICE_TX_FLAGS_HW_OUTER_SINGLE_VLAN	BIT(8)
-#define ICE_TX_FLAGS_VLAN_M	0xffff0000
-#define ICE_TX_FLAGS_VLAN_PR_M	0xe0000000
-#define ICE_TX_FLAGS_VLAN_PR_S	29
-#define ICE_TX_FLAGS_VLAN_S	16
+
+#define ICE_TX_VLAN_PR_M	0xe000
+#define ICE_TX_VLAN_PR_S	13
 
 #define ICE_XDP_PASS		0
 #define ICE_XDP_CONSUMED	BIT(0)
@@ -182,8 +181,9 @@ struct ice_tx_buf {
 		unsigned int gso_segs;
 		unsigned int nr_frags;	/* used for mbuf XDP */
 	};
-	u32 type:16;			/* &ice_tx_buf_type */
-	u32 tx_flags:16;
+	u32 tx_flags:12;
+	u32 type:4;			/* &ice_tx_buf_type */
+	u32 vid:16;
 	DEFINE_DMA_UNMAP_LEN(len);
 	DEFINE_DMA_UNMAP_ADDR(dma);
 };
-- 
2.38.1


