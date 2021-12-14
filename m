Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A5F474B5D
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 20:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237268AbhLNTAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 14:00:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:50835 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237265AbhLNTAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 14:00:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639508411; x=1671044411;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LQgMNq5cW+ThuBG+pXNR11I3QiVpdwg4alb8/hHGXT0=;
  b=KKGjsfT7RUr1tXvgJgsqWSSw5Bnf0UhtPJpeA9uXsJj4fQt0SquyXfKn
   q4hgDuXx5FOiwp5AccN7Ce9CG4EV62UmIXJAlfWW5wXKjhkb10sSyCi8p
   3K+noUeUwBUPe8/6cVu0OXoxltOPQ/CXt3TdpprZBC2HMv/ppXVkRfx6W
   Z02uz9HQc7hJNQraZlLVl0+9W/ybomiZ7XtvZN/d1rlvDTsipgi3w1NWU
   k8YUjkWaxrE7fFGrWFAe1yI2/mHZwreYC48fJh7URoViRVEp5tklElfki
   FcKOPcny4OMfMYggIkpokNKcPGlqpSOVF0n/LpWzue05ZkVpyQuGWLGbY
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="263200021"
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="263200021"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 10:30:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="583712734"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 14 Dec 2021 10:30:06 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jeff Guo <jia.guo@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net-next 02/12] ice: refactor PTYPE validating
Date:   Tue, 14 Dec 2021 10:28:58 -0800
Message-Id: <20211214182908.1513343-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214182908.1513343-1-anthony.l.nguyen@intel.com>
References: <20211214182908.1513343-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Guo <jia.guo@intel.com>

Since the capability of a PTYPE within a specific package could be
negotiated by checking the HW bit map, it means that there's no need
to maintain a different PTYPE list for each type of the package when
parsing PTYPE. So refactor the PTYPE validating mechanism.

Signed-off-by: Jeff Guo <jia.guo@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_flex_type.h    |  22 ++
 .../ethernet/intel/ice/ice_virtchnl_fdir.c    | 274 +-----------------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 207 ++++++-------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |   2 +
 4 files changed, 133 insertions(+), 372 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flex_type.h b/drivers/net/ethernet/intel/ice/ice_flex_type.h
index a8246fb039ca..fc087e0b5292 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_flex_type.h
@@ -202,6 +202,24 @@ enum ice_sect {
 	ICE_SECT_COUNT
 };
 
+/* Packet Type (PTYPE) values */
+#define ICE_PTYPE_MAC_PAY		1
+#define ICE_PTYPE_IPV4_PAY		23
+#define ICE_PTYPE_IPV4_UDP_PAY		24
+#define ICE_PTYPE_IPV4_TCP_PAY		26
+#define ICE_PTYPE_IPV4_SCTP_PAY		27
+#define ICE_PTYPE_IPV6_PAY		89
+#define ICE_PTYPE_IPV6_UDP_PAY		90
+#define ICE_PTYPE_IPV6_TCP_PAY		92
+#define ICE_PTYPE_IPV6_SCTP_PAY		93
+#define ICE_MAC_IPV4_ESP		160
+#define ICE_MAC_IPV6_ESP		161
+#define ICE_MAC_IPV4_AH			162
+#define ICE_MAC_IPV6_AH			163
+#define ICE_MAC_IPV4_NAT_T_ESP		164
+#define ICE_MAC_IPV6_NAT_T_ESP		165
+#define ICE_MAC_IPV4_GTPU		329
+#define ICE_MAC_IPV6_GTPU		330
 #define ICE_MAC_IPV4_GTPU_IPV4_FRAG	331
 #define ICE_MAC_IPV4_GTPU_IPV4_PAY	332
 #define ICE_MAC_IPV4_GTPU_IPV4_UDP_PAY	333
@@ -222,6 +240,10 @@ enum ice_sect {
 #define ICE_MAC_IPV6_GTPU_IPV6_UDP_PAY	348
 #define ICE_MAC_IPV6_GTPU_IPV6_TCP	349
 #define ICE_MAC_IPV6_GTPU_IPV6_ICMPV6	350
+#define ICE_MAC_IPV4_PFCP_SESSION	352
+#define ICE_MAC_IPV6_PFCP_SESSION	354
+#define ICE_MAC_IPV4_L2TPV3		360
+#define ICE_MAC_IPV6_L2TPV3		361
 
 /* Attributes that can modify PTYPE definitions.
  *
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
index eee180d8c024..6abf9ed1dd2e 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
@@ -47,197 +47,6 @@ struct virtchnl_fdir_fltr_conf {
 	u32 flow_id;
 };
 
-static enum virtchnl_proto_hdr_type vc_pattern_ether[] = {
-	VIRTCHNL_PROTO_HDR_ETH,
-	VIRTCHNL_PROTO_HDR_NONE,
-};
-
-static enum virtchnl_proto_hdr_type vc_pattern_ipv4[] = {
-	VIRTCHNL_PROTO_HDR_ETH,
-	VIRTCHNL_PROTO_HDR_IPV4,
-	VIRTCHNL_PROTO_HDR_NONE,
-};
-
-static enum virtchnl_proto_hdr_type vc_pattern_ipv4_tcp[] = {
-	VIRTCHNL_PROTO_HDR_ETH,
-	VIRTCHNL_PROTO_HDR_IPV4,
-	VIRTCHNL_PROTO_HDR_TCP,
-	VIRTCHNL_PROTO_HDR_NONE,
-};
-
-static enum virtchnl_proto_hdr_type vc_pattern_ipv4_udp[] = {
-	VIRTCHNL_PROTO_HDR_ETH,
-	VIRTCHNL_PROTO_HDR_IPV4,
-	VIRTCHNL_PROTO_HDR_UDP,
-	VIRTCHNL_PROTO_HDR_NONE,
-};
-
-static enum virtchnl_proto_hdr_type vc_pattern_ipv4_sctp[] = {
-	VIRTCHNL_PROTO_HDR_ETH,
-	VIRTCHNL_PROTO_HDR_IPV4,
-	VIRTCHNL_PROTO_HDR_SCTP,
-	VIRTCHNL_PROTO_HDR_NONE,
-};
-
-static enum virtchnl_proto_hdr_type vc_pattern_ipv6[] = {
-	VIRTCHNL_PROTO_HDR_ETH,
-	VIRTCHNL_PROTO_HDR_IPV6,
-	VIRTCHNL_PROTO_HDR_NONE,
-};
-
-static enum virtchnl_proto_hdr_type vc_pattern_ipv6_tcp[] = {
-	VIRTCHNL_PROTO_HDR_ETH,
-	VIRTCHNL_PROTO_HDR_IPV6,
-	VIRTCHNL_PROTO_HDR_TCP,
-	VIRTCHNL_PROTO_HDR_NONE,
-};
-
-static enum virtchnl_proto_hdr_type vc_pattern_ipv6_udp[] = {
-	VIRTCHNL_PROTO_HDR_ETH,
-	VIRTCHNL_PROTO_HDR_IPV6,
-	VIRTCHNL_PROTO_HDR_UDP,
-	VIRTCHNL_PROTO_HDR_NONE,
-};
-
-static enum virtchnl_proto_hdr_type vc_pattern_ipv6_sctp[] = {
-	VIRTCHNL_PROTO_HDR_ETH,
-	VIRTCHNL_PROTO_HDR_IPV6,
-	VIRTCHNL_PROTO_HDR_SCTP,
-	VIRTCHNL_PROTO_HDR_NONE,
-};
-
-static enum virtchnl_proto_hdr_type vc_pattern_ipv4_gtpu[] = {
-	VIRTCHNL_PROTO_HDR_ETH,
-	VIRTCHNL_PROTO_HDR_IPV4,
-	VIRTCHNL_PROTO_HDR_UDP,
-	VIRTCHNL_PROTO_HDR_GTPU_IP,
-	VIRTCHNL_PROTO_HDR_NONE,
-};
-
-static enum virtchnl_proto_hdr_type vc_pattern_ipv4_gtpu_eh[] = {
-	VIRTCHNL_PROTO_HDR_ETH,
-	VIRTCHNL_PROTO_HDR_IPV4,
-	VIRTCHNL_PROTO_HDR_UDP,
-	VIRTCHNL_PROTO_HDR_GTPU_IP,
-	VIRTCHNL_PROTO_HDR_GTPU_EH,
-	VIRTCHNL_PROTO_HDR_NONE,
-};
-
-static enum virtchnl_proto_hdr_type vc_pattern_ipv4_l2tpv3[] = {
-	VIRTCHNL_PROTO_HDR_ETH,
-	VIRTCHNL_PROTO_HDR_IPV4,
-	VIRTCHNL_PROTO_HDR_L2TPV3,
-	VIRTCHNL_PROTO_HDR_NONE,
-};
-
-static enum virtchnl_proto_hdr_type vc_pattern_ipv6_l2tpv3[] = {
-	VIRTCHNL_PROTO_HDR_ETH,
-	VIRTCHNL_PROTO_HDR_IPV6,
-	VIRTCHNL_PROTO_HDR_L2TPV3,
-	VIRTCHNL_PROTO_HDR_NONE,
-};
-
-static enum virtchnl_proto_hdr_type vc_pattern_ipv4_esp[] = {
-	VIRTCHNL_PROTO_HDR_ETH,
-	VIRTCHNL_PROTO_HDR_IPV4,
-	VIRTCHNL_PROTO_HDR_ESP,
-	VIRTCHNL_PROTO_HDR_NONE,
-};
-
-static enum virtchnl_proto_hdr_type vc_pattern_ipv6_esp[] = {
-	VIRTCHNL_PROTO_HDR_ETH,
-	VIRTCHNL_PROTO_HDR_IPV6,
-	VIRTCHNL_PROTO_HDR_ESP,
-	VIRTCHNL_PROTO_HDR_NONE,
-};
-
-static enum virtchnl_proto_hdr_type vc_pattern_ipv4_ah[] = {
-	VIRTCHNL_PROTO_HDR_ETH,
-	VIRTCHNL_PROTO_HDR_IPV4,
-	VIRTCHNL_PROTO_HDR_AH,
-	VIRTCHNL_PROTO_HDR_NONE,
-};
-
-static enum virtchnl_proto_hdr_type vc_pattern_ipv6_ah[] = {
-	VIRTCHNL_PROTO_HDR_ETH,
-	VIRTCHNL_PROTO_HDR_IPV6,
-	VIRTCHNL_PROTO_HDR_AH,
-	VIRTCHNL_PROTO_HDR_NONE,
-};
-
-static enum virtchnl_proto_hdr_type vc_pattern_ipv4_nat_t_esp[] = {
-	VIRTCHNL_PROTO_HDR_ETH,
-	VIRTCHNL_PROTO_HDR_IPV4,
-	VIRTCHNL_PROTO_HDR_UDP,
-	VIRTCHNL_PROTO_HDR_ESP,
-	VIRTCHNL_PROTO_HDR_NONE,
-};
-
-static enum virtchnl_proto_hdr_type vc_pattern_ipv6_nat_t_esp[] = {
-	VIRTCHNL_PROTO_HDR_ETH,
-	VIRTCHNL_PROTO_HDR_IPV6,
-	VIRTCHNL_PROTO_HDR_UDP,
-	VIRTCHNL_PROTO_HDR_ESP,
-	VIRTCHNL_PROTO_HDR_NONE,
-};
-
-static enum virtchnl_proto_hdr_type vc_pattern_ipv4_pfcp[] = {
-	VIRTCHNL_PROTO_HDR_ETH,
-	VIRTCHNL_PROTO_HDR_IPV4,
-	VIRTCHNL_PROTO_HDR_UDP,
-	VIRTCHNL_PROTO_HDR_PFCP,
-	VIRTCHNL_PROTO_HDR_NONE,
-};
-
-static enum virtchnl_proto_hdr_type vc_pattern_ipv6_pfcp[] = {
-	VIRTCHNL_PROTO_HDR_ETH,
-	VIRTCHNL_PROTO_HDR_IPV6,
-	VIRTCHNL_PROTO_HDR_UDP,
-	VIRTCHNL_PROTO_HDR_PFCP,
-	VIRTCHNL_PROTO_HDR_NONE,
-};
-
-struct virtchnl_fdir_pattern_match_item {
-	enum virtchnl_proto_hdr_type *list;
-	u64 input_set;
-	u64 *meta;
-};
-
-static const struct virtchnl_fdir_pattern_match_item vc_fdir_pattern_os[] = {
-	{vc_pattern_ipv4,                     0,         NULL},
-	{vc_pattern_ipv4_tcp,                 0,         NULL},
-	{vc_pattern_ipv4_udp,                 0,         NULL},
-	{vc_pattern_ipv4_sctp,                0,         NULL},
-	{vc_pattern_ipv6,                     0,         NULL},
-	{vc_pattern_ipv6_tcp,                 0,         NULL},
-	{vc_pattern_ipv6_udp,                 0,         NULL},
-	{vc_pattern_ipv6_sctp,                0,         NULL},
-};
-
-static const struct virtchnl_fdir_pattern_match_item vc_fdir_pattern_comms[] = {
-	{vc_pattern_ipv4,                     0,         NULL},
-	{vc_pattern_ipv4_tcp,                 0,         NULL},
-	{vc_pattern_ipv4_udp,                 0,         NULL},
-	{vc_pattern_ipv4_sctp,                0,         NULL},
-	{vc_pattern_ipv6,                     0,         NULL},
-	{vc_pattern_ipv6_tcp,                 0,         NULL},
-	{vc_pattern_ipv6_udp,                 0,         NULL},
-	{vc_pattern_ipv6_sctp,                0,         NULL},
-	{vc_pattern_ether,                    0,         NULL},
-	{vc_pattern_ipv4_gtpu,                0,         NULL},
-	{vc_pattern_ipv4_gtpu_eh,             0,         NULL},
-	{vc_pattern_ipv4_l2tpv3,              0,         NULL},
-	{vc_pattern_ipv6_l2tpv3,              0,         NULL},
-	{vc_pattern_ipv4_esp,                 0,         NULL},
-	{vc_pattern_ipv6_esp,                 0,         NULL},
-	{vc_pattern_ipv4_ah,                  0,         NULL},
-	{vc_pattern_ipv6_ah,                  0,         NULL},
-	{vc_pattern_ipv4_nat_t_esp,           0,         NULL},
-	{vc_pattern_ipv6_nat_t_esp,           0,         NULL},
-	{vc_pattern_ipv4_pfcp,                0,         NULL},
-	{vc_pattern_ipv6_pfcp,                0,         NULL},
-};
-
 struct virtchnl_fdir_inset_map {
 	enum virtchnl_proto_hdr_field field;
 	enum ice_flow_field fld;
@@ -910,83 +719,6 @@ ice_vc_fdir_config_input_set(struct ice_vf *vf, struct virtchnl_fdir_add *fltr,
 	return ret;
 }
 
-/**
- * ice_vc_fdir_match_pattern
- * @fltr: virtual channel add cmd buffer
- * @type: virtual channel protocol filter header type
- *
- * Matching the header type by comparing fltr and type's value.
- *
- * Return: true on success, and false on error.
- */
-static bool
-ice_vc_fdir_match_pattern(struct virtchnl_fdir_add *fltr,
-			  enum virtchnl_proto_hdr_type *type)
-{
-	struct virtchnl_proto_hdrs *proto = &fltr->rule_cfg.proto_hdrs;
-	int i = 0;
-
-	while ((i < proto->count) &&
-	       (*type == proto->proto_hdr[i].type) &&
-	       (*type != VIRTCHNL_PROTO_HDR_NONE)) {
-		type++;
-		i++;
-	}
-
-	return ((i == proto->count) && (*type == VIRTCHNL_PROTO_HDR_NONE));
-}
-
-/**
- * ice_vc_fdir_get_pattern - get while list pattern
- * @vf: pointer to the VF info
- * @len: filter list length
- *
- * Return: pointer to allowed filter list
- */
-static const struct virtchnl_fdir_pattern_match_item *
-ice_vc_fdir_get_pattern(struct ice_vf *vf, int *len)
-{
-	const struct virtchnl_fdir_pattern_match_item *item;
-	struct ice_pf *pf = vf->pf;
-	struct ice_hw *hw;
-
-	hw = &pf->hw;
-	if (!strncmp(hw->active_pkg_name, "ICE COMMS Package",
-		     sizeof(hw->active_pkg_name))) {
-		item = vc_fdir_pattern_comms;
-		*len = ARRAY_SIZE(vc_fdir_pattern_comms);
-	} else {
-		item = vc_fdir_pattern_os;
-		*len = ARRAY_SIZE(vc_fdir_pattern_os);
-	}
-
-	return item;
-}
-
-/**
- * ice_vc_fdir_search_pattern
- * @vf: pointer to the VF info
- * @fltr: virtual channel add cmd buffer
- *
- * Search for matched pattern from supported pattern list
- *
- * Return: 0 on success, and other on error.
- */
-static int
-ice_vc_fdir_search_pattern(struct ice_vf *vf, struct virtchnl_fdir_add *fltr)
-{
-	const struct virtchnl_fdir_pattern_match_item *pattern;
-	int len, i;
-
-	pattern = ice_vc_fdir_get_pattern(vf, &len);
-
-	for (i = 0; i < len; i++)
-		if (ice_vc_fdir_match_pattern(fltr, pattern[i].list))
-			return 0;
-
-	return -EINVAL;
-}
-
 /**
  * ice_vc_fdir_parse_pattern
  * @vf: pointer to the VF info
@@ -1299,11 +1031,11 @@ static int
 ice_vc_validate_fdir_fltr(struct ice_vf *vf, struct virtchnl_fdir_add *fltr,
 			  struct virtchnl_fdir_fltr_conf *conf)
 {
+	struct virtchnl_proto_hdrs *proto = &fltr->rule_cfg.proto_hdrs;
 	int ret;
 
-	ret = ice_vc_fdir_search_pattern(vf, fltr);
-	if (ret)
-		return ret;
+	if (!ice_vc_validate_pattern(vf, proto))
+		return -EINVAL;
 
 	ret = ice_vc_fdir_parse_pattern(vf, fltr, conf);
 	if (ret)
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 6427e7ec93de..596d354f714e 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -9,6 +9,7 @@
 #include "ice_flow.h"
 #include "ice_eswitch.h"
 #include "ice_virtchnl_allowlist.h"
+#include "ice_flex_pipe.h"
 
 #define FIELD_SELECTOR(proto_hdr_field) \
 		BIT((proto_hdr_field) & PROTO_HDR_FIELD_MASK)
@@ -18,18 +19,7 @@ struct ice_vc_hdr_match_type {
 	u32 ice_hdr;	/* ice headers (ICE_FLOW_SEG_HDR_XXX) */
 };
 
-static const struct ice_vc_hdr_match_type ice_vc_hdr_list_os[] = {
-	{VIRTCHNL_PROTO_HDR_NONE,	ICE_FLOW_SEG_HDR_NONE},
-	{VIRTCHNL_PROTO_HDR_IPV4,	ICE_FLOW_SEG_HDR_IPV4 |
-					ICE_FLOW_SEG_HDR_IPV_OTHER},
-	{VIRTCHNL_PROTO_HDR_IPV6,	ICE_FLOW_SEG_HDR_IPV6 |
-					ICE_FLOW_SEG_HDR_IPV_OTHER},
-	{VIRTCHNL_PROTO_HDR_TCP,	ICE_FLOW_SEG_HDR_TCP},
-	{VIRTCHNL_PROTO_HDR_UDP,	ICE_FLOW_SEG_HDR_UDP},
-	{VIRTCHNL_PROTO_HDR_SCTP,	ICE_FLOW_SEG_HDR_SCTP},
-};
-
-static const struct ice_vc_hdr_match_type ice_vc_hdr_list_comms[] = {
+static const struct ice_vc_hdr_match_type ice_vc_hdr_list[] = {
 	{VIRTCHNL_PROTO_HDR_NONE,	ICE_FLOW_SEG_HDR_NONE},
 	{VIRTCHNL_PROTO_HDR_ETH,	ICE_FLOW_SEG_HDR_ETH},
 	{VIRTCHNL_PROTO_HDR_S_VLAN,	ICE_FLOW_SEG_HDR_VLAN},
@@ -67,83 +57,7 @@ struct ice_vc_hash_field_match_type {
 };
 
 static const struct
-ice_vc_hash_field_match_type ice_vc_hash_field_list_os[] = {
-	{VIRTCHNL_PROTO_HDR_IPV4, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV4_SRC),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV4_SA)},
-	{VIRTCHNL_PROTO_HDR_IPV4, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV4_DST),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV4_DA)},
-	{VIRTCHNL_PROTO_HDR_IPV4, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV4_SRC) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV4_DST),
-		ICE_FLOW_HASH_IPV4},
-	{VIRTCHNL_PROTO_HDR_IPV4, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV4_SRC) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV4_PROT),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV4_SA) |
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV4_PROT)},
-	{VIRTCHNL_PROTO_HDR_IPV4, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV4_DST) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV4_PROT),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV4_DA) |
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV4_PROT)},
-	{VIRTCHNL_PROTO_HDR_IPV4, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV4_SRC) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV4_DST) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV4_PROT),
-		ICE_FLOW_HASH_IPV4 | BIT_ULL(ICE_FLOW_FIELD_IDX_IPV4_PROT)},
-	{VIRTCHNL_PROTO_HDR_IPV4, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV4_PROT),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV4_PROT)},
-	{VIRTCHNL_PROTO_HDR_IPV6, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV6_SRC),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV6_SA)},
-	{VIRTCHNL_PROTO_HDR_IPV6, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV6_DST),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV6_DA)},
-	{VIRTCHNL_PROTO_HDR_IPV6, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV6_SRC) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV6_DST),
-		ICE_FLOW_HASH_IPV6},
-	{VIRTCHNL_PROTO_HDR_IPV6, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV6_SRC) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV6_PROT),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV6_SA) |
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV6_PROT)},
-	{VIRTCHNL_PROTO_HDR_IPV6, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV6_DST) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV6_PROT),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV6_DA) |
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV6_PROT)},
-	{VIRTCHNL_PROTO_HDR_IPV6, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV6_SRC) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV6_DST) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV6_PROT),
-		ICE_FLOW_HASH_IPV6 | BIT_ULL(ICE_FLOW_FIELD_IDX_IPV6_PROT)},
-	{VIRTCHNL_PROTO_HDR_IPV6, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_IPV6_PROT),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_IPV6_PROT)},
-	{VIRTCHNL_PROTO_HDR_TCP,
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_TCP_SRC_PORT),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_TCP_SRC_PORT)},
-	{VIRTCHNL_PROTO_HDR_TCP,
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_TCP_DST_PORT),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_TCP_DST_PORT)},
-	{VIRTCHNL_PROTO_HDR_TCP,
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_TCP_SRC_PORT) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_TCP_DST_PORT),
-		ICE_FLOW_HASH_TCP_PORT},
-	{VIRTCHNL_PROTO_HDR_UDP,
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_UDP_SRC_PORT),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_UDP_SRC_PORT)},
-	{VIRTCHNL_PROTO_HDR_UDP,
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_UDP_DST_PORT),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_UDP_DST_PORT)},
-	{VIRTCHNL_PROTO_HDR_UDP,
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_UDP_SRC_PORT) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_UDP_DST_PORT),
-		ICE_FLOW_HASH_UDP_PORT},
-	{VIRTCHNL_PROTO_HDR_SCTP,
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_SCTP_SRC_PORT),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_SCTP_SRC_PORT)},
-	{VIRTCHNL_PROTO_HDR_SCTP,
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_SCTP_DST_PORT),
-		BIT_ULL(ICE_FLOW_FIELD_IDX_SCTP_DST_PORT)},
-	{VIRTCHNL_PROTO_HDR_SCTP,
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_SCTP_SRC_PORT) |
-		FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_SCTP_DST_PORT),
-		ICE_FLOW_HASH_SCTP_PORT},
-};
-
-static const struct
-ice_vc_hash_field_match_type ice_vc_hash_field_list_comms[] = {
+ice_vc_hash_field_match_type ice_vc_hash_field_list[] = {
 	{VIRTCHNL_PROTO_HDR_ETH, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_ETH_SRC),
 		BIT_ULL(ICE_FLOW_FIELD_IDX_ETH_SA)},
 	{VIRTCHNL_PROTO_HDR_ETH, FIELD_SELECTOR(VIRTCHNL_PROTO_HDR_ETH_DST),
@@ -2555,6 +2469,100 @@ static bool ice_vc_isvalid_ring_len(u16 ring_len)
 		!(ring_len % ICE_REQ_DESC_MULTIPLE));
 }
 
+/**
+ * ice_vc_validate_pattern
+ * @vf: pointer to the VF info
+ * @proto: virtchnl protocol headers
+ *
+ * validate the pattern is supported or not.
+ *
+ * Return: true on success, false on error.
+ */
+bool
+ice_vc_validate_pattern(struct ice_vf *vf, struct virtchnl_proto_hdrs *proto)
+{
+	bool is_ipv4 = false;
+	bool is_ipv6 = false;
+	bool is_udp = false;
+	u16 ptype = -1;
+	int i = 0;
+
+	while (i < proto->count &&
+	       proto->proto_hdr[i].type != VIRTCHNL_PROTO_HDR_NONE) {
+		switch (proto->proto_hdr[i].type) {
+		case VIRTCHNL_PROTO_HDR_ETH:
+			ptype = ICE_PTYPE_MAC_PAY;
+			break;
+		case VIRTCHNL_PROTO_HDR_IPV4:
+			ptype = ICE_PTYPE_IPV4_PAY;
+			is_ipv4 = true;
+			break;
+		case VIRTCHNL_PROTO_HDR_IPV6:
+			ptype = ICE_PTYPE_IPV6_PAY;
+			is_ipv6 = true;
+			break;
+		case VIRTCHNL_PROTO_HDR_UDP:
+			if (is_ipv4)
+				ptype = ICE_PTYPE_IPV4_UDP_PAY;
+			else if (is_ipv6)
+				ptype = ICE_PTYPE_IPV6_UDP_PAY;
+			is_udp = true;
+			break;
+		case VIRTCHNL_PROTO_HDR_TCP:
+			if (is_ipv4)
+				ptype = ICE_PTYPE_IPV4_TCP_PAY;
+			else if (is_ipv6)
+				ptype = ICE_PTYPE_IPV6_TCP_PAY;
+			break;
+		case VIRTCHNL_PROTO_HDR_SCTP:
+			if (is_ipv4)
+				ptype = ICE_PTYPE_IPV4_SCTP_PAY;
+			else if (is_ipv6)
+				ptype = ICE_PTYPE_IPV6_SCTP_PAY;
+			break;
+		case VIRTCHNL_PROTO_HDR_GTPU_IP:
+		case VIRTCHNL_PROTO_HDR_GTPU_EH:
+			if (is_ipv4)
+				ptype = ICE_MAC_IPV4_GTPU;
+			else if (is_ipv6)
+				ptype = ICE_MAC_IPV6_GTPU;
+			goto out;
+		case VIRTCHNL_PROTO_HDR_L2TPV3:
+			if (is_ipv4)
+				ptype = ICE_MAC_IPV4_L2TPV3;
+			else if (is_ipv6)
+				ptype = ICE_MAC_IPV6_L2TPV3;
+			goto out;
+		case VIRTCHNL_PROTO_HDR_ESP:
+			if (is_ipv4)
+				ptype = is_udp ? ICE_MAC_IPV4_NAT_T_ESP :
+						ICE_MAC_IPV4_ESP;
+			else if (is_ipv6)
+				ptype = is_udp ? ICE_MAC_IPV6_NAT_T_ESP :
+						ICE_MAC_IPV6_ESP;
+			goto out;
+		case VIRTCHNL_PROTO_HDR_AH:
+			if (is_ipv4)
+				ptype = ICE_MAC_IPV4_AH;
+			else if (is_ipv6)
+				ptype = ICE_MAC_IPV6_AH;
+			goto out;
+		case VIRTCHNL_PROTO_HDR_PFCP:
+			if (is_ipv4)
+				ptype = ICE_MAC_IPV4_PFCP_SESSION;
+			else if (is_ipv6)
+				ptype = ICE_MAC_IPV6_PFCP_SESSION;
+			goto out;
+		default:
+			break;
+		}
+		i++;
+	}
+
+out:
+	return ice_hw_ptype_ena(&vf->pf->hw, ptype);
+}
+
 /**
  * ice_vc_parse_rss_cfg - parses hash fields and headers from
  * a specific virtchnl RSS cfg
@@ -2578,18 +2586,10 @@ ice_vc_parse_rss_cfg(struct ice_hw *hw, struct virtchnl_rss_cfg *rss_cfg,
 	const struct ice_vc_hdr_match_type *hdr_list;
 	int i, hf_list_len, hdr_list_len;
 
-	if (!strncmp(hw->active_pkg_name, "ICE COMMS Package",
-		     sizeof(hw->active_pkg_name))) {
-		hf_list = ice_vc_hash_field_list_comms;
-		hf_list_len = ARRAY_SIZE(ice_vc_hash_field_list_comms);
-		hdr_list = ice_vc_hdr_list_comms;
-		hdr_list_len = ARRAY_SIZE(ice_vc_hdr_list_comms);
-	} else {
-		hf_list = ice_vc_hash_field_list_os;
-		hf_list_len = ARRAY_SIZE(ice_vc_hash_field_list_os);
-		hdr_list = ice_vc_hdr_list_os;
-		hdr_list_len = ARRAY_SIZE(ice_vc_hdr_list_os);
-	}
+	hf_list = ice_vc_hash_field_list;
+	hf_list_len = ARRAY_SIZE(ice_vc_hash_field_list);
+	hdr_list = ice_vc_hdr_list;
+	hdr_list_len = ARRAY_SIZE(ice_vc_hdr_list);
 
 	for (i = 0; i < rss_cfg->proto_hdrs.count; i++) {
 		struct virtchnl_proto_hdr *proto_hdr =
@@ -2691,6 +2691,11 @@ static int ice_vc_handle_rss_cfg(struct ice_vf *vf, u8 *msg, bool add)
 		goto error_param;
 	}
 
+	if (!ice_vc_validate_pattern(vf, &rss_cfg->proto_hdrs)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
+
 	if (rss_cfg->rss_algorithm == VIRTCHNL_RSS_ALG_R_ASYMMETRIC) {
 		struct ice_vsi_ctx *ctx;
 		enum ice_status status;
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 7e28ecbbe7af..752487a1bdd6 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -203,6 +203,8 @@ void
 ice_vf_lan_overflow_event(struct ice_pf *pf, struct ice_rq_event_info *event);
 void ice_print_vfs_mdd_events(struct ice_pf *pf);
 void ice_print_vf_rx_mdd_event(struct ice_vf *vf);
+bool
+ice_vc_validate_pattern(struct ice_vf *vf, struct virtchnl_proto_hdrs *proto);
 struct ice_vsi *ice_vf_ctrl_vsi_setup(struct ice_vf *vf);
 int
 ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
-- 
2.31.1

