Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC91A4D396F
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbiCITEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:04:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237184AbiCITEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:04:01 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FC2AEB336
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646852580; x=1678388580;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ab6KiXSpznr4jY0F65dmhERcatnoATIBQxO7OgGcFpA=;
  b=TSDyakm+xu2eWnv7WMjBlMuhmDTAnqQ42lVqs/6Wh1MC0bHBhKmz4Wu3
   wY/SOsuDYUGeuK24BO1X4Qu6Azj+oDoyLQexyXqLemOYJOjxHV02ic/hY
   11eC3bCfINXXsnSMCcU09P5SwyvyKTujzXM0D/4EEe+y6DY2teJhuqqvb
   ZtnTYkBojuStTI9SxoU95BQ0OrFOj/fAchWDyavxQyqA4sOS8Jif5areK
   3l4YOvJk7He4yE+4j3zq0gTZR9TNoH9m5L6Foklefc16NDfLo96ULdaON
   V+EX+9dvn+fxCP6/NvDpKQlLbX3T/2c+N9AO8Qdk+m/sEFK9Q+mCTooB6
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="341494165"
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="341494165"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 11:02:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="781188770"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 09 Mar 2022 11:02:59 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Amritha Nambiar <amritha.nambiar@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sudheer.mogilappagari@intel.com, sridhar.samudrala@intel.com,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Subject: [PATCH net-next 5/5] ice: Add support for outer dest MAC for ADQ tunnels
Date:   Wed,  9 Mar 2022 11:03:15 -0800
Message-Id: <20220309190315.1380414-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220309190315.1380414-1-anthony.l.nguyen@intel.com>
References: <20220309190315.1380414-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amritha Nambiar <amritha.nambiar@intel.com>

TC flower does not support matching on user specified
outer MAC address for tunnels. For ADQ tunnels, the driver
adds outer destination MAC address as lower netdev's
active unicast MAC address to filter out packets with
unrelated MAC address being delivered to ADQ VSIs.

Example:
- create tunnel device
ip l add $VXLAN_DEV type vxlan id $VXLAN_VNI dstport $VXLAN_PORT \
dev $PF
- add TC filter (in ADQ mode)

$tc filter add dev $VXLAN_DEV protocol ip parent ffff: flower \
 dst_ip $INNER_DST_IP ip_proto tcp dst_port $INNER_DST_PORT \
 enc_key_id $VXLAN_VNI hw_tc $ADQ_TC

Note: Filters with wild-card tunnel ID (when user does not
specify tunnel key) are also supported.

Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
Tested-by: Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 32 ++++++++++++++++++---
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index 424c74ca7d69..fedc310c376c 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -24,6 +24,9 @@ ice_tc_count_lkups(u32 flags, struct ice_tc_flower_lyr_2_4_hdrs *headers,
 	if (flags & ICE_TC_FLWR_FIELD_TENANT_ID)
 		lkups_cnt++;
 
+	if (flags & ICE_TC_FLWR_FIELD_ENC_DST_MAC)
+		lkups_cnt++;
+
 	if (flags & (ICE_TC_FLWR_FIELD_ENC_SRC_IPV4 |
 		     ICE_TC_FLWR_FIELD_ENC_DEST_IPV4 |
 		     ICE_TC_FLWR_FIELD_ENC_SRC_IPV6 |
@@ -148,6 +151,15 @@ ice_tc_fill_tunnel_outer(u32 flags, struct ice_tc_flower_fltr *fltr,
 		}
 	}
 
+	if (flags & ICE_TC_FLWR_FIELD_ENC_DST_MAC) {
+		list[i].type = ice_proto_type_from_mac(false);
+		ether_addr_copy(list[i].h_u.eth_hdr.dst_addr,
+				hdr->l2_key.dst_mac);
+		ether_addr_copy(list[i].m_u.eth_hdr.dst_addr,
+				hdr->l2_mask.dst_mac);
+		i++;
+	}
+
 	if (flags & (ICE_TC_FLWR_FIELD_ENC_SRC_IPV4 |
 		     ICE_TC_FLWR_FIELD_ENC_DEST_IPV4)) {
 		list[i].type = ice_proto_type_from_ipv4(false);
@@ -1064,12 +1076,24 @@ ice_handle_tclass_action(struct ice_vsi *vsi,
 	 * this code won't do anything
 	 * 2. For non-tunnel, if user didn't specify MAC address, add implicit
 	 * dest MAC to be lower netdev's active unicast MAC address
+	 * 3. For tunnel,  as of now TC-filter through flower classifier doesn't
+	 * have provision for user to specify outer DMAC, hence driver to
+	 * implicitly add outer dest MAC to be lower netdev's active unicast
+	 * MAC address.
 	 */
-	if (!(fltr->flags & ICE_TC_FLWR_FIELD_DST_MAC)) {
-		ether_addr_copy(fltr->outer_headers.l2_key.dst_mac,
-				main_vsi->netdev->dev_addr);
-		eth_broadcast_addr(fltr->outer_headers.l2_mask.dst_mac);
+	if (fltr->tunnel_type != TNL_LAST &&
+	    !(fltr->flags & ICE_TC_FLWR_FIELD_ENC_DST_MAC))
+		fltr->flags |= ICE_TC_FLWR_FIELD_ENC_DST_MAC;
+
+	if (fltr->tunnel_type == TNL_LAST &&
+	    !(fltr->flags & ICE_TC_FLWR_FIELD_DST_MAC))
 		fltr->flags |= ICE_TC_FLWR_FIELD_DST_MAC;
+
+	if (fltr->flags & (ICE_TC_FLWR_FIELD_DST_MAC |
+			   ICE_TC_FLWR_FIELD_ENC_DST_MAC)) {
+		ether_addr_copy(fltr->outer_headers.l2_key.dst_mac,
+				vsi->netdev->dev_addr);
+		memset(fltr->outer_headers.l2_mask.dst_mac, 0xff, ETH_ALEN);
 	}
 
 	/* validate specified dest MAC address, make sure either it belongs to
-- 
2.31.1

