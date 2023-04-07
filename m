Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 727456DB5B6
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 23:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjDGVKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 17:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjDGVKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 17:10:43 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813729EE0
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 14:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680901842; x=1712437842;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TtELeo27OV91tG8a9NONmTG6SYbDJhpPsxD+5l5Ip9E=;
  b=K1Sv5XCJEZrJ9344frxx5WB+L42aliCemIdaNZ49NQGsqMpULUqVsWTI
   VtcFBNwm5e7XNXesRNpMTozMCLzwo1sH1yaQoHeiciKMR13IfOfI3OyWp
   8tO0sICY1P1wA9Wx7hutzm8UQM4fQDaswDz8LGGhVUd1HjhDJTaU5YqDt
   cW5sE+enEDTKfAtk2xWUYmqfnvR3daJbKx4P3b4NLU+tHSy7l1/IuKN97
   idzI+I+34osLaI4c5c6Uj8Y0X4/GQGcPtTv9t1mI7yp/TLGsxBQ5ESzz0
   8bUZ2lFwQu3gzdU5jwD3s3sk3SZozLgIJmZtyy6JcSB+0gpT8dZcEqDRH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="341819980"
X-IronPort-AV: E=Sophos;i="5.98,328,1673942400"; 
   d="scan'208";a="341819980"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 14:10:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="756834434"
X-IronPort-AV: E=Sophos;i="5.98,328,1673942400"; 
   d="scan'208";a="756834434"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga004.fm.intel.com with ESMTP; 07 Apr 2023 14:10:40 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Ahmed Zaki <ahmed.zaki@intel.com>, anthony.l.nguyen@intel.com,
        Arpana Arland <arpanax.arland@intel.com>
Subject: [PATCH net 1/1] ice: identify aRFS flows using L3/L4 dissector info
Date:   Fri,  7 Apr 2023 14:08:20 -0700
Message-Id: <20230407210820.3046220-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ahmed Zaki <ahmed.zaki@intel.com>

The flow ID passed to ice_rx_flow_steer() is computed like this:

    flow_id = skb_get_hash(skb) & flow_table->mask;

With smaller aRFS tables (for example, size 256) and higher number of
flows, there is a good chance of flow ID collisions where two or more
different flows are using the same flow ID. This results in the aRFS
destination queue constantly changing for all flows sharing that ID.

Use the full L3/L4 flow dissector info to identify the steered flow
instead of the passed flow ID.

Fixes: 28bf26724fdb ("ice: Implement aRFS")
Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_arfs.c | 44 +++++++++++++++++++++--
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_arfs.c b/drivers/net/ethernet/intel/ice/ice_arfs.c
index fba178e07600..d7ae64d21e01 100644
--- a/drivers/net/ethernet/intel/ice/ice_arfs.c
+++ b/drivers/net/ethernet/intel/ice/ice_arfs.c
@@ -345,6 +345,44 @@ ice_arfs_build_entry(struct ice_vsi *vsi, const struct flow_keys *fk,
 	return arfs_entry;
 }
 
+/**
+ * ice_arfs_cmp - compare flow to a saved ARFS entry's filter info
+ * @fltr_info: filter info of the saved ARFS entry
+ * @fk: flow dissector keys
+ *
+ * Caller must hold arfs_lock if @fltr_info belongs to arfs_fltr_list
+ */
+static bool
+ice_arfs_cmp(struct ice_fdir_fltr *fltr_info, const struct flow_keys *fk)
+{
+	bool is_ipv4;
+
+	if (!fltr_info || !fk)
+		return false;
+
+	is_ipv4 = (fltr_info->flow_type == ICE_FLTR_PTYPE_NONF_IPV4_UDP ||
+		fltr_info->flow_type == ICE_FLTR_PTYPE_NONF_IPV4_TCP);
+
+	if (fk->basic.n_proto == htons(ETH_P_IP) && is_ipv4)
+		return (fltr_info->ip.v4.proto == fk->basic.ip_proto &&
+			fltr_info->ip.v4.src_port == fk->ports.src &&
+			fltr_info->ip.v4.dst_port == fk->ports.dst &&
+			fltr_info->ip.v4.src_ip == fk->addrs.v4addrs.src &&
+			fltr_info->ip.v4.dst_ip == fk->addrs.v4addrs.dst);
+	else if (fk->basic.n_proto == htons(ETH_P_IPV6) && !is_ipv4)
+		return (fltr_info->ip.v6.proto == fk->basic.ip_proto &&
+			fltr_info->ip.v6.src_port == fk->ports.src &&
+			fltr_info->ip.v6.dst_port == fk->ports.dst &&
+			!memcmp(&fltr_info->ip.v6.src_ip,
+				&fk->addrs.v6addrs.src,
+				sizeof(struct in6_addr)) &&
+			!memcmp(&fltr_info->ip.v6.dst_ip,
+				&fk->addrs.v6addrs.dst,
+				sizeof(struct in6_addr)));
+
+	return false;
+}
+
 /**
  * ice_arfs_is_perfect_flow_set - Check to see if perfect flow is set
  * @hw: pointer to HW structure
@@ -436,17 +474,17 @@ ice_rx_flow_steer(struct net_device *netdev, const struct sk_buff *skb,
 
 	/* choose the aRFS list bucket based on skb hash */
 	idx = skb_get_hash_raw(skb) & ICE_ARFS_LST_MASK;
+
 	/* search for entry in the bucket */
 	spin_lock_bh(&vsi->arfs_lock);
 	hlist_for_each_entry(arfs_entry, &vsi->arfs_fltr_list[idx],
 			     list_entry) {
-		struct ice_fdir_fltr *fltr_info;
+		struct ice_fdir_fltr *fltr_info = &arfs_entry->fltr_info;
 
 		/* keep searching for the already existing arfs_entry flow */
-		if (arfs_entry->flow_id != flow_id)
+		if (!ice_arfs_cmp(fltr_info, &fk))
 			continue;
 
-		fltr_info = &arfs_entry->fltr_info;
 		ret = fltr_info->fltr_id;
 
 		if (fltr_info->q_index == rxq_idx ||
-- 
2.38.1

