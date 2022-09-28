Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 637065EE6A5
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 22:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiI1Uck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 16:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbiI1Uch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 16:32:37 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24989CBAD6
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 13:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664397156; x=1695933156;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=64oAXpicUubzQqoGw9RGK+HHgd5cHUypHAmmKkvGwN4=;
  b=af8fPxHQWVGyY3+R5SfLT+wXflbnzhtgYjV1qUJPNrlTLc1RU/sSAa0E
   uqbmMDHS+dw1uowFcrW+faU6g4N+C2JGsZwI5Et06U4GviOa4XT/mW2K2
   EiOCb+qbxIHjEk+7MeAVtjrvaamZT9dEUZgZPR4HcHH9qfxjgipnyGrLn
   8d4B5bWkuL3gerbkTxaK7sTTthgqzQzl7Z9XqcuxKqhEdOcd4Wh7js/Ki
   De9reU5zL9EOO1tyel1SgUVJmF+nwADLQ9xC5ZUnqN+GqGbLLoj2HLYCn
   JuXyN13IZlmx37elJzO2GMpb08+zI7DZbemS/LxmAtM/vKPJd+UeOHR00
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="299308080"
X-IronPort-AV: E=Sophos;i="5.93,352,1654585200"; 
   d="scan'208";a="299308080"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 13:32:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="726099962"
X-IronPort-AV: E=Sophos;i="5.93,352,1654585200"; 
   d="scan'208";a="726099962"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 28 Sep 2022 13:32:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Subject: [PATCH net-next 3/3] ice: Add support for VLAN priority filters in switchdev
Date:   Wed, 28 Sep 2022 13:32:17 -0700
Message-Id: <20220928203217.411078-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220928203217.411078-1-anthony.l.nguyen@intel.com>
References: <20220928203217.411078-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>

Enable support for adding TC rules that filter on the VLAN priority
in switchdev mode.

VLAN priority are the first 3 bits of 16b switch field vector word
which contain also vlan id value within its last 12 bits.
When getting vlan priority value from tc match.key it
has to be shifted first to proper bits positions (by VLAN_PRIO_SHIFT)
and then can be added to the joint 'vlan' field in ice_vlan_hdr
in lookup element.

The mask of lookup changes accordingly.
0x0FFF - when only vlan id is added in filter
0xE000 - when only vlan priority is added in filter
0xEFFF - when both these values are specified

Signed-off-by: Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 73 ++++++++++++++++-----
 drivers/net/ethernet/intel/ice/ice_tc_lib.h |  4 +-
 2 files changed, 60 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index 170e04eaad18..f68c555be4e9 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -51,11 +51,11 @@ ice_tc_count_lkups(u32 flags, struct ice_tc_flower_lyr_2_4_hdrs *headers,
 		lkups_cnt++;
 
 	/* is VLAN specified? */
-	if (flags & ICE_TC_FLWR_FIELD_VLAN)
+	if (flags & (ICE_TC_FLWR_FIELD_VLAN | ICE_TC_FLWR_FIELD_VLAN_PRIO))
 		lkups_cnt++;
 
 	/* is CVLAN specified? */
-	if (flags & ICE_TC_FLWR_FIELD_CVLAN)
+	if (flags & (ICE_TC_FLWR_FIELD_CVLAN | ICE_TC_FLWR_FIELD_CVLAN_PRIO))
 		lkups_cnt++;
 
 	/* are PPPoE options specified? */
@@ -389,7 +389,7 @@ ice_tc_fill_rules(struct ice_hw *hw, u32 flags,
 	}
 
 	/* copy VLAN info */
-	if (flags & ICE_TC_FLWR_FIELD_VLAN) {
+	if (flags & (ICE_TC_FLWR_FIELD_VLAN | ICE_TC_FLWR_FIELD_VLAN_PRIO)) {
 		vlan_tpid = be16_to_cpu(headers->vlan_hdr.vlan_tpid);
 		rule_info->vlan_type =
 				ice_check_supported_vlan_tpid(vlan_tpid);
@@ -398,15 +398,45 @@ ice_tc_fill_rules(struct ice_hw *hw, u32 flags,
 			list[i].type = ICE_VLAN_EX;
 		else
 			list[i].type = ICE_VLAN_OFOS;
-		list[i].h_u.vlan_hdr.vlan = headers->vlan_hdr.vlan_id;
-		list[i].m_u.vlan_hdr.vlan = cpu_to_be16(0xFFFF);
+
+		if (flags & ICE_TC_FLWR_FIELD_VLAN) {
+			list[i].h_u.vlan_hdr.vlan = headers->vlan_hdr.vlan_id;
+			list[i].m_u.vlan_hdr.vlan = cpu_to_be16(0x0FFF);
+		}
+
+		if (flags & ICE_TC_FLWR_FIELD_VLAN_PRIO) {
+			if (flags & ICE_TC_FLWR_FIELD_VLAN) {
+				list[i].m_u.vlan_hdr.vlan = cpu_to_be16(0xEFFF);
+			} else {
+				list[i].m_u.vlan_hdr.vlan = cpu_to_be16(0xE000);
+				list[i].h_u.vlan_hdr.vlan = 0;
+			}
+			list[i].h_u.vlan_hdr.vlan |=
+				headers->vlan_hdr.vlan_prio;
+		}
+
 		i++;
 	}
 
-	if (flags & ICE_TC_FLWR_FIELD_CVLAN) {
+	if (flags & (ICE_TC_FLWR_FIELD_CVLAN | ICE_TC_FLWR_FIELD_CVLAN_PRIO)) {
 		list[i].type = ICE_VLAN_IN;
-		list[i].h_u.vlan_hdr.vlan = headers->cvlan_hdr.vlan_id;
-		list[i].m_u.vlan_hdr.vlan = cpu_to_be16(0xFFFF);
+
+		if (flags & ICE_TC_FLWR_FIELD_CVLAN) {
+			list[i].h_u.vlan_hdr.vlan = headers->cvlan_hdr.vlan_id;
+			list[i].m_u.vlan_hdr.vlan = cpu_to_be16(0x0FFF);
+		}
+
+		if (flags & ICE_TC_FLWR_FIELD_CVLAN_PRIO) {
+			if (flags & ICE_TC_FLWR_FIELD_CVLAN) {
+				list[i].m_u.vlan_hdr.vlan = cpu_to_be16(0xEFFF);
+			} else {
+				list[i].m_u.vlan_hdr.vlan = cpu_to_be16(0xE000);
+				list[i].h_u.vlan_hdr.vlan = 0;
+			}
+			list[i].h_u.vlan_hdr.vlan |=
+				headers->cvlan_hdr.vlan_prio;
+		}
+
 		i++;
 	}
 
@@ -1280,16 +1310,22 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 		if (match.mask->vlan_id) {
 			if (match.mask->vlan_id == VLAN_VID_MASK) {
 				fltr->flags |= ICE_TC_FLWR_FIELD_VLAN;
+				headers->vlan_hdr.vlan_id =
+					cpu_to_be16(match.key->vlan_id &
+						    VLAN_VID_MASK);
 			} else {
 				NL_SET_ERR_MSG_MOD(fltr->extack, "Bad VLAN mask");
 				return -EINVAL;
 			}
 		}
 
-		headers->vlan_hdr.vlan_id =
-				cpu_to_be16(match.key->vlan_id & VLAN_VID_MASK);
-		if (match.mask->vlan_priority)
-			headers->vlan_hdr.vlan_prio = match.key->vlan_priority;
+		if (match.mask->vlan_priority) {
+			fltr->flags |= ICE_TC_FLWR_FIELD_VLAN_PRIO;
+			headers->vlan_hdr.vlan_prio =
+				cpu_to_be16((match.key->vlan_priority <<
+					     VLAN_PRIO_SHIFT) & VLAN_PRIO_MASK);
+		}
+
 		if (match.mask->vlan_tpid)
 			headers->vlan_hdr.vlan_tpid = match.key->vlan_tpid;
 	}
@@ -1307,6 +1343,9 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 		if (match.mask->vlan_id) {
 			if (match.mask->vlan_id == VLAN_VID_MASK) {
 				fltr->flags |= ICE_TC_FLWR_FIELD_CVLAN;
+				headers->cvlan_hdr.vlan_id =
+					cpu_to_be16(match.key->vlan_id &
+						    VLAN_VID_MASK);
 			} else {
 				NL_SET_ERR_MSG_MOD(fltr->extack,
 						   "Bad CVLAN mask");
@@ -1314,10 +1353,12 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 			}
 		}
 
-		headers->cvlan_hdr.vlan_id =
-				cpu_to_be16(match.key->vlan_id & VLAN_VID_MASK);
-		if (match.mask->vlan_priority)
-			headers->cvlan_hdr.vlan_prio = match.key->vlan_priority;
+		if (match.mask->vlan_priority) {
+			fltr->flags |= ICE_TC_FLWR_FIELD_CVLAN_PRIO;
+			headers->cvlan_hdr.vlan_prio =
+				cpu_to_be16((match.key->vlan_priority <<
+					     VLAN_PRIO_SHIFT) & VLAN_PRIO_MASK);
+		}
 	}
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PPPOE)) {
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.h b/drivers/net/ethernet/intel/ice/ice_tc_lib.h
index ebef34385a4f..92642faad595 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.h
@@ -31,6 +31,8 @@
 #define ICE_TC_FLWR_FIELD_ENC_IP_TOS		BIT(24)
 #define ICE_TC_FLWR_FIELD_ENC_IP_TTL		BIT(25)
 #define ICE_TC_FLWR_FIELD_L2TPV3_SESSID		BIT(26)
+#define ICE_TC_FLWR_FIELD_VLAN_PRIO		BIT(27)
+#define ICE_TC_FLWR_FIELD_CVLAN_PRIO		BIT(28)
 
 #define ICE_TC_FLOWER_MASK_32   0xFFFFFFFF
 
@@ -49,7 +51,7 @@ struct ice_tc_flower_action {
 
 struct ice_tc_vlan_hdr {
 	__be16 vlan_id; /* Only last 12 bits valid */
-	u16 vlan_prio; /* Only last 3 bits valid (valid values: 0..7) */
+	__be16 vlan_prio; /* Only last 3 bits valid (valid values: 0..7) */
 	__be16 vlan_tpid;
 };
 
-- 
2.35.1

