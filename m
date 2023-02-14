Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54FFC696FC1
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 22:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbjBNVcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 16:32:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233084AbjBNVc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 16:32:27 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777CD303C2
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 13:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676410325; x=1707946325;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k5K8jvx+mmCDY7JnYCt46cFr6bSBz6D4JFFUxSdXSNI=;
  b=ZBzKqGR62DmNqEpx26rR/7/nHeGmfO8OHh2ANYzSzIzy1c1E4GocdRfJ
   kOpYIYdy5Ep2iQ6CkMB+05yUnA5wpYrW/nG5tY1uJIy5j+c8EvMAYKUo1
   7ynTYQcEXWrSWtsF3Nq+wbAxUaU0qiYztT6TCC+BfjMuhwR7wH4w7gXHp
   JGqyStoTD9hgSLjSMlqKqD+m7+82M0Ezc4OZ08JG/VbFKNFkvxUDpbXeI
   n3AmJlR+wKJYkrwTzPR/Frf1t65KT/1ZvD6Mz3r0U2J6zP6mv+DpWbV3K
   JfOt1jidiUTO7wWZSGYEhx+vlkiibY4b7VgQWaANb7FDo+NdsAKBiCYyT
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="331274582"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="331274582"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 13:30:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="733025268"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="733025268"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2023 13:30:39 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Pawel Chmielewski <pawel.chmielewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 3/5] ice: add support BIG TCP on IPv6
Date:   Tue, 14 Feb 2023 13:30:01 -0800
Message-Id: <20230214213003.2117125-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230214213003.2117125-1-anthony.l.nguyen@intel.com>
References: <20230214213003.2117125-1-anthony.l.nguyen@intel.com>
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

From: Pawel Chmielewski <pawel.chmielewski@intel.com>

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
Minimum      90th         99th         Transaction
Latency      Percentile   Percentile   Rate
Microseconds Latency      Latency      Tran/s
             Microseconds Microseconds
134          279          410          3961.584

After:
Minimum      90th         99th         Transaction
Latency      Percentile   Percentile   Rate
Microseconds Latency      Latency      Tran/s
             Microseconds Microseconds
135          178          216          6093.404

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
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      | 2 ++
 drivers/net/ethernet/intel/ice/ice_main.c | 2 ++
 drivers/net/ethernet/intel/ice/ice_txrx.c | 3 +++
 3 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 7bd50e49312c..b0e29e342401 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -123,6 +123,8 @@
 
 #define ICE_MAX_MTU	(ICE_AQ_SET_MAC_FRAME_SIZE_MAX - ICE_ETH_PKT_HDR_PAD)
 
+#define ICE_MAX_TSO_SIZE 131072
+
 #define ICE_UP_TABLE_TRANSLATE(val, i) \
 		(((val) << ICE_AQ_VSI_UP_TABLE_UP##i##_S) & \
 		  ICE_AQ_VSI_UP_TABLE_UP##i##_M)
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 0712c1055aea..eb87bb08f5ec 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3436,6 +3436,8 @@ static void ice_set_netdev_features(struct net_device *netdev)
 	 * be changed at runtime
 	 */
 	netdev->hw_features |= NETIF_F_RXFCS;
+
+	netif_set_tso_max_size(netdev, ICE_MAX_TSO_SIZE);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 466113c86e6f..c036be5eb35d 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -2327,6 +2327,9 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 
 	ice_trace(xmit_frame_ring, tx_ring, skb);
 
+	if (unlikely(ipv6_hopopt_jumbo_remove(skb)))
+		goto out_drop;
+
 	count = ice_xmit_desc_count(skb);
 	if (ice_chk_linearize(skb, count)) {
 		if (__skb_linearize(skb))
-- 
2.38.1

