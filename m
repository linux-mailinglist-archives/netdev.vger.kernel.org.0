Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA264B13D2
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 18:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245021AbiBJRFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 12:05:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245014AbiBJRFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 12:05:30 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D55EC10
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644512731; x=1676048731;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PCKFBEHlyT3JrL6cE5gDuCBIgM7fjHKJ3YouUhlTrpE=;
  b=doYpiFUAjqbROK7OgSM6w9eL18S7HN2U+05f5yxjpmEscdUeLqEBBun0
   A3AfpekK2yXgnOZWJc00IQiLRUAJUATzXE9MnbKksaqPOJ3y+RInrIItI
   ZfeXoHqcKYSZAjtYgyIY60JAFO3Vp4Dx1s/BvXVDyRIK8sgcqOltYh00p
   M6kLOzPQkMDp17qBR2Cv8UU2cEjU5LZAZL7H6IMOm2HpT2edHxjz+b1Xh
   09TkyuhQSbQB3gJMNCOJCK2XH+yAg/nMuDJGJ1FPDmEKEMPDMyoIBNL83
   cGgr3lKFfhq+JOH3Sq62UOLCPCq8jWZbgo614gtr7lqrMdRP5G4bg2u5o
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10254"; a="312825107"
X-IronPort-AV: E=Sophos;i="5.88,359,1635231600"; 
   d="scan'208";a="312825107"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 09:05:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,359,1635231600"; 
   d="scan'208";a="622742935"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Feb 2022 09:05:21 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 2/4] ice: fix IPIP and SIT TSO offload
Date:   Thu, 10 Feb 2022 09:05:13 -0800
Message-Id: <20220210170515.2609656-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220210170515.2609656-1-anthony.l.nguyen@intel.com>
References: <20220210170515.2609656-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The driver was avoiding offload for IPIP (at least) frames due to
parsing the inner header offsets incorrectly when trying to check
lengths.

This length check works for VXLAN frames but fails on IPIP frames
because skb_transport_offset points to the inner header in IPIP
frames, which meant the subtraction of transport_header from
inner_network_header returns a negative value (-20).

With the code before this patch, everything continued to work, but GSO
was being used to segment, causing throughputs of 1.5Gb/s per thread.
After this patch, throughput is more like 10Gb/s per thread for IPIP
traffic.

Fixes: e94d44786693 ("ice: Implement filter sync, NDO operations and bump version")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
Testing Hints: test IPIP tunnel and VXLAN tunnel, both should use TSO.

 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |  1 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 25 +++++++++++++------
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
index d981dc6f2323..85a612838a89 100644
--- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
+++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
@@ -568,6 +568,7 @@ struct ice_tx_ctx_desc {
 			(0x3FFFFULL << ICE_TXD_CTX_QW1_TSO_LEN_S)
 
 #define ICE_TXD_CTX_QW1_MSS_S	50
+#define ICE_TXD_CTX_MIN_MSS	64
 
 #define ICE_TXD_CTX_QW1_VSI_S	50
 #define ICE_TXD_CTX_QW1_VSI_M	(0x3FFULL << ICE_TXD_CTX_QW1_VSI_S)
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 30814435f779..3b751d8b4056 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -8525,6 +8525,7 @@ ice_features_check(struct sk_buff *skb,
 		   struct net_device __always_unused *netdev,
 		   netdev_features_t features)
 {
+	bool gso = skb_is_gso(skb);
 	size_t len;
 
 	/* No point in doing any of this if neither checksum nor GSO are
@@ -8537,24 +8538,32 @@ ice_features_check(struct sk_buff *skb,
 	/* We cannot support GSO if the MSS is going to be less than
 	 * 64 bytes. If it is then we need to drop support for GSO.
 	 */
-	if (skb_is_gso(skb) && (skb_shinfo(skb)->gso_size < 64))
+	if (gso && (skb_shinfo(skb)->gso_size < ICE_TXD_CTX_MIN_MSS))
 		features &= ~NETIF_F_GSO_MASK;
 
-	len = skb_network_header(skb) - skb->data;
+	len = skb_network_offset(skb);
 	if (len > ICE_TXD_MACLEN_MAX || len & 0x1)
 		goto out_rm_features;
 
-	len = skb_transport_header(skb) - skb_network_header(skb);
+	len = skb_network_header_len(skb);
 	if (len > ICE_TXD_IPLEN_MAX || len & 0x1)
 		goto out_rm_features;
 
 	if (skb->encapsulation) {
-		len = skb_inner_network_header(skb) - skb_transport_header(skb);
-		if (len > ICE_TXD_L4LEN_MAX || len & 0x1)
-			goto out_rm_features;
+		/* this must work for VXLAN frames AND IPIP/SIT frames, and in
+		 * the case of IPIP frames, the transport header pointer is
+		 * after the inner header! So check to make sure that this
+		 * is a GRE or UDP_TUNNEL frame before doing that math.
+		 */
+		if (gso && (skb_shinfo(skb)->gso_type &
+			    (SKB_GSO_GRE | SKB_GSO_UDP_TUNNEL))) {
+			len = skb_inner_network_header(skb) -
+			      skb_transport_header(skb);
+			if (len > ICE_TXD_L4LEN_MAX || len & 0x1)
+				goto out_rm_features;
+		}
 
-		len = skb_inner_transport_header(skb) -
-		      skb_inner_network_header(skb);
+		len = skb_inner_network_header_len(skb);
 		if (len > ICE_TXD_IPLEN_MAX || len & 0x1)
 			goto out_rm_features;
 	}
-- 
2.31.1

