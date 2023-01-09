Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA2D662B1A
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 17:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbjAIQZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 11:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbjAIQY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 11:24:58 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC844FDE
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 08:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673281497; x=1704817497;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gWEh9JInpyICmN/mACKJ1SdTrhSsBTj5xlolcqaJyrs=;
  b=BmKFaJZhPqqMOPhB1ZGxK5vDVSUOmcJ67nHox35OUX4iFY+GhygTNj55
   inCKNmTsFDvV3EsIWS4Q+cPmoUd3sfzdCDmcwRzFeTFS3qEuIuj20dLOA
   kYxeUECQeZhOVpbmor9+RvwQDeDazyiABuei7dteaSHvSYNU9eAVvQDRu
   9bBMZ94NWFbICcBZNdFsrfuo9tBykuJrG07BhMHHT2a4zsNcU7BoJpR0Y
   AQH3+Ctpzr/TK3YzVDrlhHzMI8IgeVscIThSPSdL5L4D2yILSQ0AT0Ne2
   qoa0gXg4EwFP5C0HaE1WIE6/VTDFdMRcBZjIEOns/Iz5WTq09t5AAdyZI
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="324918485"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="324918485"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 08:24:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="687258117"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="687258117"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga008.jf.intel.com with ESMTP; 09 Jan 2023 08:24:56 -0800
Received: from baltimore.igk.intel.com (baltimore.igk.intel.com [10.102.21.1])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 309GOtqu023933;
        Mon, 9 Jan 2023 16:24:55 GMT
From:   Pawel Chmielewski <pawel.chmielewski@intel.com>
To:     netdev@vger.kernel.org
Cc:     intel-wired-lan@osuosl.org,
        Pawel Chmielewski <pawel.chmielewski@intel.com>
Subject: [PATCH 1/1] ice: WiP support for BIG TCP packets
Date:   Mon,  9 Jan 2023 17:18:33 +0100
Message-Id: <20230109161833.223510-1-pawel.chmielewski@intel.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is a proof of concept for testing BIG TCP feature in ice driver.
Please see letter below.

Signed-off-by: Pawel Chmielewski <pawel.chmielewski@intel.com>
---
Hi All
I'm writing on the list, as you may be able to provide me some feedback.
I want to enable BIG TCP feature in intel ice drive, but I think I'm 
missing something.
In the code itself, I've set 128k as a maximum tso size for the netif,
and added stripping the HBH option from the header.
For testing purposes, gso_max_size & gro_max_size were set to 128k and 
mtu to 9000.
I've assumed that the ice tso offload will do the rest of the job.
However- while running netperf TCP_RR and TCP_STREAM tests,
I saw that only up to ~20% of the transmitted test packets have 
the specified size. 
Other packets to be transmitted, appear from the stack as splitted.

I've been running the following testcases:
netperf -t TCP_RR -H 2001:db8:0:f101::1  -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT
netperf -l-1 -t TCP_STREAM -H 2001:db8:0:f101::1  -- -m 128K -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT
I suspected a shrinking tcp window size, but sniffing with tcpdump showed rather big scaling factor (usually 128x).
Apart from using netperf, I also tried a simple IPv6 user space application
(with SO_SNDBUF option set to 192k and TCP_WINDOW_CLAMP to 96k) - similar results.

I'd be very grateful for any feedback/suggestions

Pawel
---
 drivers/net/ethernet/intel/ice/ice_main.c | 4 ++++
 drivers/net/ethernet/intel/ice/ice_txrx.c | 9 +++++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2b23b4714a26..4e657820e55d 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -48,6 +48,8 @@ static DEFINE_IDA(ice_aux_ida);
 DEFINE_STATIC_KEY_FALSE(ice_xdp_locking_key);
 EXPORT_SYMBOL(ice_xdp_locking_key);
 
+#define ICE_MAX_TSO_SIZE 131072
+
 /**
  * ice_hw_to_dev - Get device pointer from the hardware structure
  * @hw: pointer to the device HW structure
@@ -3422,6 +3424,8 @@ static void ice_set_netdev_features(struct net_device *netdev)
 	 * be changed at runtime
 	 */
 	netdev->hw_features |= NETIF_F_RXFCS;
+
+	netif_set_tso_max_size(netdev, ICE_MAX_TSO_SIZE);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 086f0b3ab68d..7e0ac483cad9 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -23,6 +23,9 @@
 #define FDIR_DESC_RXDID 0x40
 #define ICE_FDIR_CLEAN_DELAY 10
 
+#define HBH_HDR_SIZE sizeof(struct hop_jumbo_hdr)
+#define HBH_OFFSET ETH_HLEN + sizeof(struct ipv6hdr)
+
 /**
  * ice_prgm_fdir_fltr - Program a Flow Director filter
  * @vsi: VSI to send dummy packet
@@ -2300,6 +2303,12 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 
 	ice_trace(xmit_frame_ring, tx_ring, skb);
 
+	if (ipv6_has_hopopt_jumbo(skb)) {
+		memmove(skb->data + HBH_HDR_SIZE, skb->data, HBH_OFFSET);
+		__skb_pull(skb, HBH_HDR_SIZE);
+		skb_reset_mac_header(skb);
+	}
+
 	count = ice_xmit_desc_count(skb);
 	if (ice_chk_linearize(skb, count)) {
 		if (__skb_linearize(skb))
-- 
2.37.3

