Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3506E4FE825
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 20:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358754AbiDLSl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 14:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358744AbiDLSlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 14:41:50 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D9E2FE43
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 11:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649788772; x=1681324772;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Aum5oiBx8khJMAwar9RS3K4vNYt0NEeJ3VrC7y54gW8=;
  b=X2Z9H1J8zZCHlEQhHfBqVezW7ggJiVHdZ7WzsfxH5MXzaN1Scvh9s8JI
   jTW6Xp5v0GSdjJwpk1zNiWsbIcuNo9Yo77yaxaBDBRjiDM/Bu1He1AaPU
   ZJm31mhvhf3ppDy5PYF+0rZIO2eU4AJ0HKRpzB3EnmQw+zPlED9TcMZ8h
   iniH/ZF1pdCQaKpk4P1D3o9jGpUKD2Fo8CYx0scgt8x19aXYKR53EGsDY
   4ufyw3vo9N+vsSQGsWDiaicfl6o0T+Hxh3Ly/1Y7f+iOKXpEdhJjkEmob
   T+kbPi/xOj5MuPxawvADSGNVNA/Op02i7KMDFU0eqbHx0YkH41qAoyGBs
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="322919267"
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="322919267"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 11:39:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="590453082"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 12 Apr 2022 11:39:29 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 2/5] ice: Add mpls+tso support
Date:   Tue, 12 Apr 2022 11:36:33 -0700
Message-Id: <20220412183636.1408915-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220412183636.1408915-1-anthony.l.nguyen@intel.com>
References: <20220412183636.1408915-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Damato <jdamato@fastly.com>

Attempt to add mpls+tso support.

I don't have ice hardware available to test myself, but I just implemented
this feature in i40e and thought it might be useful to implement for ice
while this is fresh in my brain.

Hoping some one at intel will be able to test this on my behalf.

Signed-off-by: Joe Damato <jdamato@fastly.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c |  4 +++-
 drivers/net/ethernet/intel/ice/ice_txrx.c | 29 ++++++++++++++++-------
 2 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d768925785ca..fbefcb08fa64 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3329,7 +3329,9 @@ static void ice_set_netdev_features(struct net_device *netdev)
 			      vlano_features | tso_features;
 
 	/* add support for HW_CSUM on packets with MPLS header */
-	netdev->mpls_features =  NETIF_F_HW_CSUM;
+	netdev->mpls_features =  NETIF_F_HW_CSUM |
+				 NETIF_F_TSO     |
+				 NETIF_F_TSO6;
 
 	/* enable features */
 	netdev->features |= netdev->hw_features;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index f9bf008471c9..3f8b7274ed2f 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -8,6 +8,7 @@
 #include <linux/prefetch.h>
 #include <linux/bpf_trace.h>
 #include <net/dsfield.h>
+#include <net/mpls.h>
 #include <net/xdp.h>
 #include "ice_txrx_lib.h"
 #include "ice_lib.h"
@@ -1748,18 +1749,24 @@ int ice_tx_csum(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 	if (skb->ip_summed != CHECKSUM_PARTIAL)
 		return 0;
 
-	ip.hdr = skb_network_header(skb);
-	l4.hdr = skb_transport_header(skb);
+	protocol = vlan_get_protocol(skb);
+
+	if (eth_p_mpls(protocol))
+		ip.hdr = skb_inner_network_header(skb);
+	else
+		ip.hdr = skb_network_header(skb);
+	l4.hdr = skb_checksum_start(skb);
 
 	/* compute outer L2 header size */
 	l2_len = ip.hdr - skb->data;
 	offset = (l2_len / 2) << ICE_TX_DESC_LEN_MACLEN_S;
 
-	protocol = vlan_get_protocol(skb);
-
-	if (protocol == htons(ETH_P_IP))
+	/* set the tx_flags to indicate the IP protocol type. this is
+	 * required so that checksum header computation below is accurate.
+	 */
+	if (ip.v4->version == 4)
 		first->tx_flags |= ICE_TX_FLAGS_IPV4;
-	else if (protocol == htons(ETH_P_IPV6))
+	else if (ip.v6->version == 6)
 		first->tx_flags |= ICE_TX_FLAGS_IPV6;
 
 	if (skb->encapsulation) {
@@ -1957,6 +1964,7 @@ int ice_tso(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 		unsigned char *hdr;
 	} l4;
 	u64 cd_mss, cd_tso_len;
+	__be16 protocol;
 	u32 paylen;
 	u8 l4_start;
 	int err;
@@ -1972,8 +1980,13 @@ int ice_tso(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 		return err;
 
 	/* cppcheck-suppress unreadVariable */
-	ip.hdr = skb_network_header(skb);
-	l4.hdr = skb_transport_header(skb);
+	protocol = vlan_get_protocol(skb);
+
+	if (eth_p_mpls(protocol))
+		ip.hdr = skb_inner_network_header(skb);
+	else
+		ip.hdr = skb_network_header(skb);
+	l4.hdr = skb_checksum_start(skb);
 
 	/* initialize outer IP header fields */
 	if (ip.v4->version == 4) {
-- 
2.31.1

