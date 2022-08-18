Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA37598821
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344495AbiHRPyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344467AbiHRPyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:54:23 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C19C6516
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660837983; x=1692373983;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b+b4ROqzrj5fV+cxmcM5O/gv+FZIWRBXAvrUEIRRJ3k=;
  b=jAxr/+Tx8C1NgitsBynCR/NlU4OV4gzyuzVZ+MTggKmS10N570JWVpdm
   MujuGfmer0vg+LVqfQ0ENX0RfqVV6ALAnAQ6oyU97vC4mxISUQ/hfLZIc
   xWmcopmrZW8CWt7DeY6piFG1W0F5068lpRuLZJfHXLUi2wrLGIU6Wtjs5
   WBUYeRi71sS7LWoPcceJi1heQZsLqTjxMshQYaCT7WgjAZp7o4bxAqLQv
   JXJqaFOcvO/IBNHkM+/vfsfbBeRGI2VbO89nA5B+GvR8idl0eEOZ7HqLc
   cphjORgnuTbDE3B1+3/ueiRHJjpdUXmp5jksgCC0Qplc+mxafd2d2ctAW
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="318817384"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="318817384"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 08:52:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="676104301"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2022 08:52:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Grzegorz Nitka <grzegorz.nitka@intel.com>,
        Benjamin Mikailenko <benjamin.mikailenko@intel.com>,
        Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 1/5] ice: Implement control of FCS/CRC stripping
Date:   Thu, 18 Aug 2022 08:52:03 -0700
Message-Id: <20220818155207.996297-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220818155207.996297-1-anthony.l.nguyen@intel.com>
References: <20220818155207.996297-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The driver can allow the user to configure whether the CRC aka the FCS
(Frame Check Sequence) is DMA'd to the host as part of the receive
buffer.  The driver usually wants this feature disabled so that the
hardware checks the FCS and strips it in order to save PCI bandwidth.

Control the reception of FCS to the host using the command:
ethtool -K eth0 rx-fcs <on|off>

The default shown in ethtool -k eth0 | grep fcs; should be "off", as the
hardware will drop any frame with a bad checksum, and DMA of the
checksum is useless overhead especially for small packets.

Testing Hints:
test the FCS/CRC arrives with received packets using
tcpdump -nnpi eth0 -xxxx
and it should show crc data as the last 4 bytes of the packet. Can also
use wireshark to turn on CRC checking and check the data is correct.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Co-developed-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Co-developed-by: Benjamin Mikailenko <benjamin.mikailenko@intel.com>
Signed-off-by: Benjamin Mikailenko <benjamin.mikailenko@intel.com>
Co-developed-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
Signed-off-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         |  1 +
 drivers/net/ethernet/intel/ice/ice_base.c    |  2 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c |  5 +--
 drivers/net/ethernet/intel/ice/ice_lib.c     | 22 +++++++++++
 drivers/net/ethernet/intel/ice/ice_lib.h     |  2 +
 drivers/net/ethernet/intel/ice/ice_main.c    | 40 ++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_txrx.h    |  3 +-
 7 files changed, 69 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index cc5b85afd437..267942418847 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -854,6 +854,7 @@ ice_fetch_u64_stats_per_ring(struct u64_stats_sync *syncp,
 			     struct ice_q_stats stats, u64 *pkts, u64 *bytes);
 int ice_up(struct ice_vsi *vsi);
 int ice_down(struct ice_vsi *vsi);
+int ice_down_up(struct ice_vsi *vsi);
 int ice_vsi_cfg(struct ice_vsi *vsi);
 struct ice_vsi *ice_lb_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi);
 int ice_vsi_determine_xdp_res(struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 136d7911adb4..6f092e06054e 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -417,7 +417,7 @@ static int ice_setup_rx_ctx(struct ice_rx_ring *ring)
 	/* Strip the Ethernet CRC bytes before the packet is posted to host
 	 * memory.
 	 */
-	rlan_ctx.crcstrip = 1;
+	rlan_ctx.crcstrip = !(ring->flags & ICE_RX_FLAGS_CRC_STRIP_DIS);
 
 	/* L2TSEL flag defines the reported L2 Tags in the receive descriptor
 	 * and it needs to remain 1 for non-DVM capable configurations to not
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 0f0faa8dc7fb..ad6cffb2d3e0 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1289,10 +1289,7 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 	}
 	if (test_bit(ICE_FLAG_LEGACY_RX, change_flags)) {
 		/* down and up VSI so that changes of Rx cfg are reflected. */
-		if (!test_and_set_bit(ICE_VSI_DOWN, vsi->state)) {
-			ice_down(vsi);
-			ice_up(vsi);
-		}
+		ice_down_up(vsi);
 	}
 	/* don't allow modification of this flag when a single VF is in
 	 * promiscuous mode because it's not supported
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 679529040edd..afecf2494ad6 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1562,6 +1562,22 @@ void ice_vsi_manage_rss_lut(struct ice_vsi *vsi, bool ena)
 	kfree(lut);
 }
 
+/**
+ * ice_vsi_cfg_crc_strip - Configure CRC stripping for a VSI
+ * @vsi: VSI to be configured
+ * @disable: set to true to have FCS / CRC in the frame data
+ */
+void ice_vsi_cfg_crc_strip(struct ice_vsi *vsi, bool disable)
+{
+	int i;
+
+	ice_for_each_rxq(vsi, i)
+		if (disable)
+			vsi->rx_rings[i]->flags |= ICE_RX_FLAGS_CRC_STRIP_DIS;
+		else
+			vsi->rx_rings[i]->flags &= ~ICE_RX_FLAGS_CRC_STRIP_DIS;
+}
+
 /**
  * ice_vsi_cfg_rss_lut_key - Configure RSS params for a VSI
  * @vsi: VSI to be configured
@@ -3277,6 +3293,12 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 			 */
 			if (test_bit(ICE_FLAG_RSS_ENA, pf->flags))
 				ice_vsi_cfg_rss_lut_key(vsi);
+
+		/* disable or enable CRC stripping */
+		if (vsi->netdev)
+			ice_vsi_cfg_crc_strip(vsi, !!(vsi->netdev->features &
+					      NETIF_F_RXFCS));
+
 		break;
 	case ICE_VSI_VF:
 		ret = ice_vsi_alloc_q_vectors(vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 8712b1d2ceec..ec4bf0c89857 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -89,6 +89,8 @@ void ice_vsi_free_tx_rings(struct ice_vsi *vsi);
 
 void ice_vsi_manage_rss_lut(struct ice_vsi *vsi, bool ena);
 
+void ice_vsi_cfg_crc_strip(struct ice_vsi *vsi, bool disable);
+
 void ice_update_tx_ring_stats(struct ice_tx_ring *ring, u64 pkts, u64 bytes);
 
 void ice_update_rx_ring_stats(struct ice_rx_ring *ring, u64 pkts, u64 bytes);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index eb40526ee179..a827045198cc 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3374,6 +3374,11 @@ static void ice_set_netdev_features(struct net_device *netdev)
 	if (is_dvm_ena)
 		netdev->hw_features |= NETIF_F_HW_VLAN_STAG_RX |
 			NETIF_F_HW_VLAN_STAG_TX;
+
+	/* Leave CRC / FCS stripping enabled by default, but allow the value to
+	 * be changed at runtime
+	 */
+	netdev->hw_features |= NETIF_F_RXFCS;
 }
 
 /**
@@ -5977,6 +5982,16 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
 	if (ret)
 		return ret;
 
+	/* Turn on receive of FCS aka CRC, and after setting this
+	 * flag the packet data will have the 4 byte CRC appended
+	 */
+	if (changed & NETIF_F_RXFCS) {
+		ice_vsi_cfg_crc_strip(vsi, !!(features & NETIF_F_RXFCS));
+		ret = ice_down_up(vsi);
+		if (ret)
+			return ret;
+	}
+
 	if (changed & NETIF_F_NTUPLE) {
 		bool ena = !!(features & NETIF_F_NTUPLE);
 
@@ -6680,6 +6695,31 @@ int ice_down(struct ice_vsi *vsi)
 	return 0;
 }
 
+/**
+ * ice_down_up - shutdown the VSI connection and bring it up
+ * @vsi: the VSI to be reconnected
+ */
+int ice_down_up(struct ice_vsi *vsi)
+{
+	int ret;
+
+	/* if DOWN already set, nothing to do */
+	if (test_and_set_bit(ICE_VSI_DOWN, vsi->state))
+		return 0;
+
+	ret = ice_down(vsi);
+	if (ret)
+		return ret;
+
+	ret = ice_up(vsi);
+	if (ret) {
+		netdev_err(vsi->netdev, "reallocating resources failed during netdev features change, may need to reload driver\n");
+		return ret;
+	}
+
+	return 0;
+}
+
 /**
  * ice_vsi_setup_tx_rings - Allocate VSI Tx queue resources
  * @vsi: VSI having resources allocated
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index ca902af54bb4..932b5661ec4d 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -295,10 +295,11 @@ struct ice_rx_ring {
 	struct xsk_buff_pool *xsk_pool;
 	struct sk_buff *skb;
 	dma_addr_t dma;			/* physical address of ring */
-#define ICE_RX_FLAGS_RING_BUILD_SKB	BIT(1)
 	u64 cached_phctime;
 	u8 dcb_tc;			/* Traffic class of ring */
 	u8 ptp_rx;
+#define ICE_RX_FLAGS_RING_BUILD_SKB	BIT(1)
+#define ICE_RX_FLAGS_CRC_STRIP_DIS	BIT(2)
 	u8 flags;
 } ____cacheline_internodealigned_in_smp;
 
-- 
2.35.1

