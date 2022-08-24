Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6E659FFFF
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 19:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239752AbiHXRDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 13:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232679AbiHXRDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 13:03:51 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FFF70E61
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 10:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661360630; x=1692896630;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u+L0vLNCR4Jwnq7woSxzwPiCclgruK3MWnydnIlSmSY=;
  b=LhsT6eXdAZg5jcIaWy9S2urpubEUxE5yZGA9sa4F56IMUSepRpeshcdO
   +Y1tPNnBjGNW6IPdKZwBXFXOmsuy5fvpvoo+Qwc27m6BZvYb7WUv9z97a
   4PRyl3qpYFFXG01IiogWLGH04V4lCOwvZCGgcMeKMeCnZWjRKRqiABDbj
   6r7fWPSaDsHXfGgCWDOYj1gg0HwxRJIsvONoR4DzKA4dzqyL3vc1YsTlV
   zgYcHzVAsLacPqM36/26M3BXoLIRkgK1Eu/TGn7cJOYY3NI4nXksXvzmF
   zZhURDr5bzd3ii3km5ULAPtBZtBulifuUjXioPayRSgRJMhHiF2ILbss1
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="280995445"
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="280995445"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 10:03:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="937989092"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 24 Aug 2022 10:03:46 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Marcin Szycik <marcin.szycik@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Subject: [PATCH net-next 1/5] ice: Add support for ip TTL & ToS offload
Date:   Wed, 24 Aug 2022 10:03:36 -0700
Message-Id: <20220824170340.207131-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220824170340.207131-1-anthony.l.nguyen@intel.com>
References: <20220824170340.207131-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcin Szycik <marcin.szycik@linux.intel.com>

Add support for parsing TTL and ToS (Hop Limit and Traffic Class) tc fields
and matching on those fields in filters. Incomplete part of implementation
was already in place (getting enc_ip and enc_tos from flow_match_ip and
writing them to filter header).

Note: matching on ipv6 ip_ttl, enc_ttl and enc_tos is currently not
supported by the DDP package.

Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 142 +++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_tc_lib.h |   6 +
 2 files changed, 144 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index a298862857a8..42df686e0215 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -36,6 +36,10 @@ ice_tc_count_lkups(u32 flags, struct ice_tc_flower_lyr_2_4_hdrs *headers,
 		     ICE_TC_FLWR_FIELD_ENC_DEST_IPV6))
 		lkups_cnt++;
 
+	if (flags & (ICE_TC_FLWR_FIELD_ENC_IP_TOS |
+		     ICE_TC_FLWR_FIELD_ENC_IP_TTL))
+		lkups_cnt++;
+
 	if (flags & ICE_TC_FLWR_FIELD_ENC_DEST_L4_PORT)
 		lkups_cnt++;
 
@@ -64,6 +68,9 @@ ice_tc_count_lkups(u32 flags, struct ice_tc_flower_lyr_2_4_hdrs *headers,
 		     ICE_TC_FLWR_FIELD_DEST_IPV6 | ICE_TC_FLWR_FIELD_SRC_IPV6))
 		lkups_cnt++;
 
+	if (flags & (ICE_TC_FLWR_FIELD_IP_TOS | ICE_TC_FLWR_FIELD_IP_TTL))
+		lkups_cnt++;
+
 	/* is L4 (TCP/UDP/any other L4 protocol fields) specified? */
 	if (flags & (ICE_TC_FLWR_FIELD_DEST_L4_PORT |
 		     ICE_TC_FLWR_FIELD_SRC_L4_PORT))
@@ -257,6 +264,50 @@ ice_tc_fill_tunnel_outer(u32 flags, struct ice_tc_flower_fltr *fltr,
 		i++;
 	}
 
+	if (fltr->inner_headers.l2_key.n_proto == htons(ETH_P_IP) &&
+	    (flags & (ICE_TC_FLWR_FIELD_ENC_IP_TOS |
+		      ICE_TC_FLWR_FIELD_ENC_IP_TTL))) {
+		list[i].type = ice_proto_type_from_ipv4(false);
+
+		if (flags & ICE_TC_FLWR_FIELD_ENC_IP_TOS) {
+			list[i].h_u.ipv4_hdr.tos = hdr->l3_key.tos;
+			list[i].m_u.ipv4_hdr.tos = hdr->l3_mask.tos;
+		}
+
+		if (flags & ICE_TC_FLWR_FIELD_ENC_IP_TTL) {
+			list[i].h_u.ipv4_hdr.time_to_live = hdr->l3_key.ttl;
+			list[i].m_u.ipv4_hdr.time_to_live = hdr->l3_mask.ttl;
+		}
+
+		i++;
+	}
+
+	if (fltr->inner_headers.l2_key.n_proto == htons(ETH_P_IPV6) &&
+	    (flags & (ICE_TC_FLWR_FIELD_ENC_IP_TOS |
+		      ICE_TC_FLWR_FIELD_ENC_IP_TTL))) {
+		struct ice_ipv6_hdr *hdr_h, *hdr_m;
+
+		hdr_h = &list[i].h_u.ipv6_hdr;
+		hdr_m = &list[i].m_u.ipv6_hdr;
+		list[i].type = ice_proto_type_from_ipv6(false);
+
+		if (flags & ICE_TC_FLWR_FIELD_ENC_IP_TOS) {
+			be32p_replace_bits(&hdr_h->be_ver_tc_flow,
+					   hdr->l3_key.tos,
+					   ICE_IPV6_HDR_TC_MASK);
+			be32p_replace_bits(&hdr_m->be_ver_tc_flow,
+					   hdr->l3_mask.tos,
+					   ICE_IPV6_HDR_TC_MASK);
+		}
+
+		if (flags & ICE_TC_FLWR_FIELD_ENC_IP_TTL) {
+			hdr_h->hop_limit = hdr->l3_key.ttl;
+			hdr_m->hop_limit = hdr->l3_mask.ttl;
+		}
+
+		i++;
+	}
+
 	if ((flags & ICE_TC_FLWR_FIELD_ENC_DEST_L4_PORT) &&
 	    hdr->l3_key.ip_proto == IPPROTO_UDP) {
 		list[i].type = ICE_UDP_OF;
@@ -420,6 +471,50 @@ ice_tc_fill_rules(struct ice_hw *hw, u32 flags,
 		i++;
 	}
 
+	if (headers->l2_key.n_proto == htons(ETH_P_IP) &&
+	    (flags & (ICE_TC_FLWR_FIELD_IP_TOS | ICE_TC_FLWR_FIELD_IP_TTL))) {
+		list[i].type = ice_proto_type_from_ipv4(inner);
+
+		if (flags & ICE_TC_FLWR_FIELD_IP_TOS) {
+			list[i].h_u.ipv4_hdr.tos = headers->l3_key.tos;
+			list[i].m_u.ipv4_hdr.tos = headers->l3_mask.tos;
+		}
+
+		if (flags & ICE_TC_FLWR_FIELD_IP_TTL) {
+			list[i].h_u.ipv4_hdr.time_to_live =
+				headers->l3_key.ttl;
+			list[i].m_u.ipv4_hdr.time_to_live =
+				headers->l3_mask.ttl;
+		}
+
+		i++;
+	}
+
+	if (headers->l2_key.n_proto == htons(ETH_P_IPV6) &&
+	    (flags & (ICE_TC_FLWR_FIELD_IP_TOS | ICE_TC_FLWR_FIELD_IP_TTL))) {
+		struct ice_ipv6_hdr *hdr_h, *hdr_m;
+
+		hdr_h = &list[i].h_u.ipv6_hdr;
+		hdr_m = &list[i].m_u.ipv6_hdr;
+		list[i].type = ice_proto_type_from_ipv6(inner);
+
+		if (flags & ICE_TC_FLWR_FIELD_IP_TOS) {
+			be32p_replace_bits(&hdr_h->be_ver_tc_flow,
+					   headers->l3_key.tos,
+					   ICE_IPV6_HDR_TC_MASK);
+			be32p_replace_bits(&hdr_m->be_ver_tc_flow,
+					   headers->l3_mask.tos,
+					   ICE_IPV6_HDR_TC_MASK);
+		}
+
+		if (flags & ICE_TC_FLWR_FIELD_IP_TTL) {
+			hdr_h->hop_limit = headers->l3_key.ttl;
+			hdr_m->hop_limit = headers->l3_mask.ttl;
+		}
+
+		i++;
+	}
+
 	/* copy L4 (src, dest) port */
 	if (flags & (ICE_TC_FLWR_FIELD_DEST_L4_PORT |
 		     ICE_TC_FLWR_FIELD_SRC_L4_PORT)) {
@@ -838,6 +933,40 @@ ice_tc_set_ipv6(struct flow_match_ipv6_addrs *match,
 	return 0;
 }
 
+/**
+ * ice_tc_set_tos_ttl - Parse IP ToS/TTL from TC flower filter
+ * @match: Pointer to flow match structure
+ * @fltr: Pointer to filter structure
+ * @headers: inner or outer header fields
+ * @is_encap: set true for tunnel
+ */
+static void
+ice_tc_set_tos_ttl(struct flow_match_ip *match,
+		   struct ice_tc_flower_fltr *fltr,
+		   struct ice_tc_flower_lyr_2_4_hdrs *headers,
+		   bool is_encap)
+{
+	if (match->mask->tos) {
+		if (is_encap)
+			fltr->flags |= ICE_TC_FLWR_FIELD_ENC_IP_TOS;
+		else
+			fltr->flags |= ICE_TC_FLWR_FIELD_IP_TOS;
+
+		headers->l3_key.tos = match->key->tos;
+		headers->l3_mask.tos = match->mask->tos;
+	}
+
+	if (match->mask->ttl) {
+		if (is_encap)
+			fltr->flags |= ICE_TC_FLWR_FIELD_ENC_IP_TTL;
+		else
+			fltr->flags |= ICE_TC_FLWR_FIELD_IP_TTL;
+
+		headers->l3_key.ttl = match->key->ttl;
+		headers->l3_mask.ttl = match->mask->ttl;
+	}
+}
+
 /**
  * ice_tc_set_port - Parse ports from TC flower filter
  * @match: Flow match structure
@@ -967,10 +1096,7 @@ ice_parse_tunnel_attr(struct net_device *dev, struct flow_rule *rule,
 		struct flow_match_ip match;
 
 		flow_rule_match_enc_ip(rule, &match);
-		headers->l3_key.tos = match.key->tos;
-		headers->l3_key.ttl = match.key->ttl;
-		headers->l3_mask.tos = match.mask->tos;
-		headers->l3_mask.ttl = match.mask->ttl;
+		ice_tc_set_tos_ttl(&match, fltr, headers, true);
 	}
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_PORTS) &&
@@ -1039,6 +1165,7 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 	      BIT(FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS) |
 	      BIT(FLOW_DISSECTOR_KEY_ENC_PORTS) |
 	      BIT(FLOW_DISSECTOR_KEY_ENC_OPTS) |
+	      BIT(FLOW_DISSECTOR_KEY_IP) |
 	      BIT(FLOW_DISSECTOR_KEY_ENC_IP) |
 	      BIT(FLOW_DISSECTOR_KEY_PORTS) |
 	      BIT(FLOW_DISSECTOR_KEY_PPPOE))) {
@@ -1217,6 +1344,13 @@ ice_parse_cls_flower(struct net_device *filter_dev, struct ice_vsi *vsi,
 			return -EINVAL;
 	}
 
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IP)) {
+		struct flow_match_ip match;
+
+		flow_rule_match_ip(rule, &match);
+		ice_tc_set_tos_ttl(&match, fltr, headers, false);
+	}
+
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS)) {
 		struct flow_match_ports match;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.h b/drivers/net/ethernet/intel/ice/ice_tc_lib.h
index 91cd3d3778c7..f397ed02606d 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.h
@@ -26,9 +26,15 @@
 #define ICE_TC_FLWR_FIELD_CVLAN			BIT(19)
 #define ICE_TC_FLWR_FIELD_PPPOE_SESSID		BIT(20)
 #define ICE_TC_FLWR_FIELD_PPP_PROTO		BIT(21)
+#define ICE_TC_FLWR_FIELD_IP_TOS		BIT(22)
+#define ICE_TC_FLWR_FIELD_IP_TTL		BIT(23)
+#define ICE_TC_FLWR_FIELD_ENC_IP_TOS		BIT(24)
+#define ICE_TC_FLWR_FIELD_ENC_IP_TTL		BIT(25)
 
 #define ICE_TC_FLOWER_MASK_32   0xFFFFFFFF
 
+#define ICE_IPV6_HDR_TC_MASK 0xFF00000
+
 struct ice_indr_block_priv {
 	struct net_device *netdev;
 	struct ice_netdev_priv *np;
-- 
2.35.1

