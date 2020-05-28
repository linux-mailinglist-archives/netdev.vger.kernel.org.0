Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26841E5882
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 09:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgE1HZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 03:25:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:14682 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725779AbgE1HZl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 03:25:41 -0400
IronPort-SDR: xCTVYvoJdzanS/FSr9N0CsTj2TvTwEgIoKPcOLzAXiwoxWOKJ0n7tvY8h1Fjwj9wMS9C7R26+w
 q0NouqL3exig==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 00:25:40 -0700
IronPort-SDR: zsC3AQ09C9vNsb4LZNEwmwhIR8W2Zphn0K/Biv42cYNAfmJWHx0kzW7zRT4riNn3M+QWK6+x3w
 6HyhJrbznXgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,443,1583222400"; 
   d="scan'208";a="310831097"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 28 May 2020 00:25:40 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Bruce Allan <bruce.w.allan@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/15] ice: fix signed vs unsigned comparisons
Date:   Thu, 28 May 2020 00:25:24 -0700
Message-Id: <20200528072538.1621790-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
References: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

Fix the remaining signed vs unsigned issues, which appear
when compiling with -Werror=sign-compare.

Many of these are because there is an external interface that is passing
an int to us (which we can't change) but that we (rightfully) store
and compare against as an unsigned in our data structures.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_base.c | 4 ++--
 drivers/net/ethernet/intel/ice/ice_main.c | 8 ++++----
 drivers/net/ethernet/intel/ice/ice_txrx.h | 7 ++++---
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 94d833b4e745..9452c0eb70b0 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -13,7 +13,7 @@
  */
 static int __ice_vsi_get_qs_contig(struct ice_qs_cfg *qs_cfg)
 {
-	int offset, i;
+	unsigned int offset, i;
 
 	mutex_lock(qs_cfg->qs_mutex);
 	offset = bitmap_find_next_zero_area(qs_cfg->pf_map, qs_cfg->pf_map_size,
@@ -39,7 +39,7 @@ static int __ice_vsi_get_qs_contig(struct ice_qs_cfg *qs_cfg)
  */
 static int __ice_vsi_get_qs_sc(struct ice_qs_cfg *qs_cfg)
 {
-	int i, index = 0;
+	unsigned int i, index = 0;
 
 	mutex_lock(qs_cfg->qs_mutex);
 	for (i = 0; i < qs_cfg->q_count; i++) {
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 1c255b27244c..c2da3e1a2e17 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5035,7 +5035,7 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 	struct ice_pf *pf = vsi->back;
 	u8 count = 0;
 
-	if (new_mtu == netdev->mtu) {
+	if (new_mtu == (int)netdev->mtu) {
 		netdev_warn(netdev, "MTU is already %u\n", netdev->mtu);
 		return 0;
 	}
@@ -5050,11 +5050,11 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 		}
 	}
 
-	if (new_mtu < netdev->min_mtu) {
+	if (new_mtu < (int)netdev->min_mtu) {
 		netdev_err(netdev, "new MTU invalid. min_mtu is %d\n",
 			   netdev->min_mtu);
 		return -EINVAL;
-	} else if (new_mtu > netdev->max_mtu) {
+	} else if (new_mtu > (int)netdev->max_mtu) {
 		netdev_err(netdev, "new MTU invalid. max_mtu is %d\n",
 			   netdev->min_mtu);
 		return -EINVAL;
@@ -5075,7 +5075,7 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 		return -EBUSY;
 	}
 
-	netdev->mtu = new_mtu;
+	netdev->mtu = (unsigned int)new_mtu;
 
 	/* if VSI is up, bring it down and then back up */
 	if (!test_and_set_bit(__ICE_DOWN, vsi->state)) {
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index cf21b4fe928a..e70c4619edc3 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -38,7 +38,8 @@
  */
 #if (PAGE_SIZE < 8192)
 #define ICE_2K_TOO_SMALL_WITH_PADDING \
-((NET_SKB_PAD + ICE_RXBUF_1536) > SKB_WITH_OVERHEAD(ICE_RXBUF_2048))
+	((unsigned int)(NET_SKB_PAD + ICE_RXBUF_1536) > \
+			SKB_WITH_OVERHEAD(ICE_RXBUF_2048))
 
 /**
  * ice_compute_pad - compute the padding
@@ -107,8 +108,8 @@ static inline int ice_skb_pad(void)
 #define DESC_NEEDED (MAX_SKB_FRAGS + ICE_DESCS_FOR_CTX_DESC + \
 		     ICE_DESCS_PER_CACHE_LINE + ICE_DESCS_FOR_SKB_DATA_PTR)
 #define ICE_DESC_UNUSED(R)	\
-	((((R)->next_to_clean > (R)->next_to_use) ? 0 : (R)->count) + \
-	(R)->next_to_clean - (R)->next_to_use - 1)
+	(u16)((((R)->next_to_clean > (R)->next_to_use) ? 0 : (R)->count) + \
+	      (R)->next_to_clean - (R)->next_to_use - 1)
 
 #define ICE_TX_FLAGS_TSO	BIT(0)
 #define ICE_TX_FLAGS_HW_VLAN	BIT(1)
-- 
2.26.2

