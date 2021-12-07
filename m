Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEDC46C76E
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 23:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242182AbhLGWaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 17:30:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:41415 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242160AbhLGWaS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 17:30:18 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10191"; a="237508436"
X-IronPort-AV: E=Sophos;i="5.87,295,1631602800"; 
   d="scan'208";a="237508436"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 14:26:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,295,1631602800"; 
   d="scan'208";a="605889086"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 07 Dec 2021 14:26:47 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net 5/7] ice: fix choosing UDP header type
Date:   Tue,  7 Dec 2021 14:25:42 -0800
Message-Id: <20211207222544.977843-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211207222544.977843-1-anthony.l.nguyen@intel.com>
References: <20211207222544.977843-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

In tunnels packet there can be two UDP headers:
- outer which for hw should be mark as ICE_UDP_OF
- inner which for hw should be mark as ICE_UDP_ILOS or as ICE_TCP_IL if
  inner header is of TCP type

In none tunnels packet header can be:
- UDP, which for hw should be mark as ICE_UDP_ILOS
- TCP, which for hw should be mark as ICE_TCP_IL

Change incorrect ICE_UDP_OF for none tunnel packets to ICE_UDP_ILOS.
ICE_UDP_OF is incorrect for none tunnel packets and setting it leads to
error from hw while adding this kind of recipe.

In summary, for tunnel outer port type should always be set to
ICE_UDP_OF, for none tunnel outer and tunnel inner it should always be
set to ICE_UDP_ILOS.

Fixes: 9e300987d4a8 ("ice: VXLAN and Geneve TC support")
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 27 ++++++++-------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index e5d23feb6701..384439a267ad 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -74,21 +74,13 @@ static enum ice_protocol_type ice_proto_type_from_ipv6(bool inner)
 	return inner ? ICE_IPV6_IL : ICE_IPV6_OFOS;
 }
 
-static enum ice_protocol_type
-ice_proto_type_from_l4_port(bool inner, u16 ip_proto)
+static enum ice_protocol_type ice_proto_type_from_l4_port(u16 ip_proto)
 {
-	if (inner) {
-		switch (ip_proto) {
-		case IPPROTO_UDP:
-			return ICE_UDP_ILOS;
-		}
-	} else {
-		switch (ip_proto) {
-		case IPPROTO_TCP:
-			return ICE_TCP_IL;
-		case IPPROTO_UDP:
-			return ICE_UDP_OF;
-		}
+	switch (ip_proto) {
+	case IPPROTO_TCP:
+		return ICE_TCP_IL;
+	case IPPROTO_UDP:
+		return ICE_UDP_ILOS;
 	}
 
 	return 0;
@@ -191,8 +183,9 @@ ice_tc_fill_tunnel_outer(u32 flags, struct ice_tc_flower_fltr *fltr,
 		i++;
 	}
 
-	if (flags & ICE_TC_FLWR_FIELD_ENC_DEST_L4_PORT) {
-		list[i].type = ice_proto_type_from_l4_port(false, hdr->l3_key.ip_proto);
+	if ((flags & ICE_TC_FLWR_FIELD_ENC_DEST_L4_PORT) &&
+	    hdr->l3_key.ip_proto == IPPROTO_UDP) {
+		list[i].type = ICE_UDP_OF;
 		list[i].h_u.l4_hdr.dst_port = hdr->l4_key.dst_port;
 		list[i].m_u.l4_hdr.dst_port = hdr->l4_mask.dst_port;
 		i++;
@@ -317,7 +310,7 @@ ice_tc_fill_rules(struct ice_hw *hw, u32 flags,
 		     ICE_TC_FLWR_FIELD_SRC_L4_PORT)) {
 		struct ice_tc_l4_hdr *l4_key, *l4_mask;
 
-		list[i].type = ice_proto_type_from_l4_port(inner, headers->l3_key.ip_proto);
+		list[i].type = ice_proto_type_from_l4_port(headers->l3_key.ip_proto);
 		l4_key = &headers->l4_key;
 		l4_mask = &headers->l4_mask;
 
-- 
2.31.1

