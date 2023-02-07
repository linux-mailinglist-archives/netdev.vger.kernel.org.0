Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB4768DDD9
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 17:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbjBGQZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 11:25:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjBGQZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 11:25:12 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626025599
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 08:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675787111; x=1707323111;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=I2pBOKC0dUujwtyCj+FFCnmPWyms8KwzC2UaOu5+CBw=;
  b=F32/JQvvKRi/JOiWgGkl3h8RSk98TpQzjBVIJjWha5aLFDAWdIgTN9bO
   cu0m1X6xWFOI6XJ3trrhaExRcy21zwB7/pTSNPaX4fzgSNb8hXXFo/Myz
   pOGao/ypw1GWyM3znvxK/OIdbElms6Jb31gp623O0qsZHgylR+lS1yCMZ
   erehRqea2yFdlQZe9cwWul54IA5inuxC0OkbHi45jK7qsLIEjCGnQ3A7i
   9qBS6wBDrwEbSDlKLDBiQ2UyEUQxIb2JZ/mfx6gy+EWoOoOKV0AhW0X79
   djY/+41CxNuWoyXho1kefb48kbNylkPdi3eHagqU3arI+T7+pAPLS6J4B
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="330842113"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="330842113"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 08:25:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="730494623"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="730494623"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga008.fm.intel.com with ESMTP; 07 Feb 2023 08:25:08 -0800
Received: from baltimore.igk.intel.com (baltimore.igk.intel.com [10.102.21.1])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id 057F537844;
        Tue,  7 Feb 2023 16:25:07 +0000 (GMT)
From:   Pawel Chmielewski <pawel.chmielewski@intel.com>
To:     netdev@vger.kernel.org
Cc:     intel-wired-lan@osuosl.org,
        Pawel Chmielewski <pawel.chmielewski@intel.com>
Subject: [PATCH net-next v2 1/1] ice: add support BIG TCP on IPv6
Date:   Tue,  7 Feb 2023 17:23:03 +0100
Message-Id: <20230207162303.140750-1-pawel.chmielewski@intel.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable sending BIG TCP packets on IPv6 in the ice driver using generic
ipv6_hopopt_jumbo_remove helper for stripping HBH header.

Tested:
netperf -t TCP_RR -H 2001:db8:0:f101::1  -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,TRANSACTION_RATE

Tested on two different setups. In both cases, the following settings were
applied after loading the changed driver:

ip link set dev enp175s0f1np1 gso_max_size 130000
ip link set dev enp175s0f1np1 gro_max_size 130000
ip link set dev enp175s0f1np1 mtu 9000

First setup:
Before:
Minimum      90th         99th         Transaction
Latency      Percentile   Percentile   Rate
Microseconds Latency      Latency      Tran/s
             Microseconds Microseconds
134          279          410          3961.584

After:
Minimum      90th         99th         Transaction
Latency      Percentile   Percentile   Rate
Microseconds Latency      Latency      Tran/s
             Microseconds Microseconds
135          178          216          6093.404

The other setup:
Before:
Minimum      90th         99th         Transaction
Latency      Percentile   Percentile   Rate
Microseconds Latency      Latency      Tran/s
             Microseconds Microseconds
218          414          478          2944.765

After:
Minimum      90th         99th         Transaction
Latency      Percentile   Percentile   Rate
Microseconds Latency      Latency      Tran/s
             Microseconds Microseconds
146          238          266          4700.596

Signed-off-by: Pawel Chmielewski <pawel.chmielewski@intel.com>
---

Changes since v1:
 * Added testing results
---
 drivers/net/ethernet/intel/ice/ice.h      | 2 ++
 drivers/net/ethernet/intel/ice/ice_main.c | 2 ++
 drivers/net/ethernet/intel/ice/ice_txrx.c | 3 +++
 3 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 3d26ff4122e0..c774fdd482cd 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -122,6 +122,8 @@
 
 #define ICE_MAX_MTU	(ICE_AQ_SET_MAC_FRAME_SIZE_MAX - ICE_ETH_PKT_HDR_PAD)
 
+#define ICE_MAX_TSO_SIZE 131072
+
 #define ICE_UP_TABLE_TRANSLATE(val, i) \
 		(((val) << ICE_AQ_VSI_UP_TABLE_UP##i##_S) & \
 		  ICE_AQ_VSI_UP_TABLE_UP##i##_M)
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 22b8ad058286..8c74a48ad0d3 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3421,6 +3421,8 @@ static void ice_set_netdev_features(struct net_device *netdev)
 	 * be changed at runtime
 	 */
 	netdev->hw_features |= NETIF_F_RXFCS;
+
+	netif_set_tso_max_size(netdev, ICE_MAX_TSO_SIZE);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index ccf09c957a1c..bef927afb766 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -2297,6 +2297,9 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 
 	ice_trace(xmit_frame_ring, tx_ring, skb);
 
+	if (unlikely(ipv6_hopopt_jumbo_remove(skb)))
+		goto out_drop;
+
 	count = ice_xmit_desc_count(skb);
 	if (ice_chk_linearize(skb, count)) {
 		if (__skb_linearize(skb))
-- 
2.37.3

