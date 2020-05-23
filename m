Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58691DF549
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 08:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387692AbgEWGs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 02:48:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:52994 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387684AbgEWGsy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 02:48:54 -0400
IronPort-SDR: iaPj1OiAmSR6NrZC/H0dvSIHrMWa6CfJLT/fAMqLzJ39xQA6E3LACTUgOGJXfxZDjpgdPzA7Ip
 GlqwCUeYR/yw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 23:48:49 -0700
IronPort-SDR: 49dRLfzdGdt+yVza5zV8kY/J6+Lh5EGIpz7yWYtYXtLzueVo+L4D6vrbp5TG1Ep1oFFYmou1z6
 iqDULTyNnjnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="374966887"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 22 May 2020 23:48:49 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Henry Tieman <henry.w.tieman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/16] ice: Support IPv6 Flow Director filters
Date:   Fri, 22 May 2020 23:48:36 -0700
Message-Id: <20200523064847.3972158-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523064847.3972158-1-jeffrey.t.kirsher@intel.com>
References: <20200523064847.3972158-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Henry Tieman <henry.w.tieman@intel.com>

Extend supported filters to allow for IPv6 filters.

Supported fields are: src-ip, dst-ip, src-port, and dst-port
Supported flow-types are: tcp6, udp6, sctp6, ip6

Example usage:

ethtool -N eth0 flow-type tcp6 src-port 12 dst-port 13 \
src-ip fce0::1:34 dst-ip fce0::1:35 action 32

Signed-off-by: Henry Tieman <henry.w.tieman@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_ethtool_fdir.c | 391 +++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_fdir.c     | 303 ++++++++++++--
 drivers/net/ethernet/intel/ice/ice_fdir.h     |  19 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |   6 +
 drivers/net/ethernet/intel/ice/ice_type.h     |   4 +
 5 files changed, 642 insertions(+), 81 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
index 6badf2ef2255..aa85d5ad2477 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
@@ -7,6 +7,24 @@
 #include "ice_lib.h"
 #include "ice_flow.h"
 
+static struct in6_addr full_ipv6_addr_mask = {
+	.in6_u = {
+		.u6_addr8 = {
+			0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
+			0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
+		}
+	}
+};
+
+static struct in6_addr zero_ipv6_addr_mask = {
+	.in6_u = {
+		.u6_addr8 = {
+			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		}
+	}
+};
+
 /* calls to ice_flow_add_prof require the number of segments in the array
  * for segs_cnt. In this code that is one more than the index.
  */
@@ -30,6 +48,14 @@ static int ice_fltr_to_ethtool_flow(enum ice_fltr_ptype flow)
 		return SCTP_V4_FLOW;
 	case ICE_FLTR_PTYPE_NONF_IPV4_OTHER:
 		return IPV4_USER_FLOW;
+	case ICE_FLTR_PTYPE_NONF_IPV6_TCP:
+		return TCP_V6_FLOW;
+	case ICE_FLTR_PTYPE_NONF_IPV6_UDP:
+		return UDP_V6_FLOW;
+	case ICE_FLTR_PTYPE_NONF_IPV6_SCTP:
+		return SCTP_V6_FLOW;
+	case ICE_FLTR_PTYPE_NONF_IPV6_OTHER:
+		return IPV6_USER_FLOW;
 	default:
 		/* 0 is undefined ethtool flow */
 		return 0;
@@ -53,6 +79,14 @@ static enum ice_fltr_ptype ice_ethtool_flow_to_fltr(int eth)
 		return ICE_FLTR_PTYPE_NONF_IPV4_SCTP;
 	case IPV4_USER_FLOW:
 		return ICE_FLTR_PTYPE_NONF_IPV4_OTHER;
+	case TCP_V6_FLOW:
+		return ICE_FLTR_PTYPE_NONF_IPV6_TCP;
+	case UDP_V6_FLOW:
+		return ICE_FLTR_PTYPE_NONF_IPV6_UDP;
+	case SCTP_V6_FLOW:
+		return ICE_FLTR_PTYPE_NONF_IPV6_SCTP;
+	case IPV6_USER_FLOW:
+		return ICE_FLTR_PTYPE_NONF_IPV6_OTHER;
 	default:
 		return ICE_FLTR_PTYPE_NONF_NONE;
 	}
@@ -92,28 +126,64 @@ int ice_get_ethtool_fdir_entry(struct ice_hw *hw, struct ethtool_rxnfc *cmd)
 	case IPV4_USER_FLOW:
 		fsp->h_u.usr_ip4_spec.ip_ver = ETH_RX_NFC_IP4;
 		fsp->h_u.usr_ip4_spec.proto = 0;
-		fsp->h_u.usr_ip4_spec.l4_4_bytes = rule->ip.l4_header;
-		fsp->h_u.usr_ip4_spec.tos = rule->ip.tos;
-		fsp->h_u.usr_ip4_spec.ip4src = rule->ip.src_ip;
-		fsp->h_u.usr_ip4_spec.ip4dst = rule->ip.dst_ip;
-		fsp->m_u.usr_ip4_spec.ip4src = rule->mask.src_ip;
-		fsp->m_u.usr_ip4_spec.ip4dst = rule->mask.dst_ip;
+		fsp->h_u.usr_ip4_spec.l4_4_bytes = rule->ip.v4.l4_header;
+		fsp->h_u.usr_ip4_spec.tos = rule->ip.v4.tos;
+		fsp->h_u.usr_ip4_spec.ip4src = rule->ip.v4.src_ip;
+		fsp->h_u.usr_ip4_spec.ip4dst = rule->ip.v4.dst_ip;
+		fsp->m_u.usr_ip4_spec.ip4src = rule->mask.v4.src_ip;
+		fsp->m_u.usr_ip4_spec.ip4dst = rule->mask.v4.dst_ip;
 		fsp->m_u.usr_ip4_spec.ip_ver = 0xFF;
 		fsp->m_u.usr_ip4_spec.proto = 0;
-		fsp->m_u.usr_ip4_spec.l4_4_bytes = rule->mask.l4_header;
-		fsp->m_u.usr_ip4_spec.tos = rule->mask.tos;
+		fsp->m_u.usr_ip4_spec.l4_4_bytes = rule->mask.v4.l4_header;
+		fsp->m_u.usr_ip4_spec.tos = rule->mask.v4.tos;
 		break;
 	case TCP_V4_FLOW:
 	case UDP_V4_FLOW:
 	case SCTP_V4_FLOW:
-		fsp->h_u.tcp_ip4_spec.psrc = rule->ip.src_port;
-		fsp->h_u.tcp_ip4_spec.pdst = rule->ip.dst_port;
-		fsp->h_u.tcp_ip4_spec.ip4src = rule->ip.src_ip;
-		fsp->h_u.tcp_ip4_spec.ip4dst = rule->ip.dst_ip;
-		fsp->m_u.tcp_ip4_spec.psrc = rule->mask.src_port;
-		fsp->m_u.tcp_ip4_spec.pdst = rule->mask.dst_port;
-		fsp->m_u.tcp_ip4_spec.ip4src = rule->mask.src_ip;
-		fsp->m_u.tcp_ip4_spec.ip4dst = rule->mask.dst_ip;
+		fsp->h_u.tcp_ip4_spec.psrc = rule->ip.v4.src_port;
+		fsp->h_u.tcp_ip4_spec.pdst = rule->ip.v4.dst_port;
+		fsp->h_u.tcp_ip4_spec.ip4src = rule->ip.v4.src_ip;
+		fsp->h_u.tcp_ip4_spec.ip4dst = rule->ip.v4.dst_ip;
+		fsp->m_u.tcp_ip4_spec.psrc = rule->mask.v4.src_port;
+		fsp->m_u.tcp_ip4_spec.pdst = rule->mask.v4.dst_port;
+		fsp->m_u.tcp_ip4_spec.ip4src = rule->mask.v4.src_ip;
+		fsp->m_u.tcp_ip4_spec.ip4dst = rule->mask.v4.dst_ip;
+		break;
+	case IPV6_USER_FLOW:
+		fsp->h_u.usr_ip6_spec.l4_4_bytes = rule->ip.v6.l4_header;
+		fsp->h_u.usr_ip6_spec.tclass = rule->ip.v6.tc;
+		fsp->h_u.usr_ip6_spec.l4_proto = rule->ip.v6.proto;
+		memcpy(fsp->h_u.tcp_ip6_spec.ip6src, rule->ip.v6.src_ip,
+		       sizeof(struct in6_addr));
+		memcpy(fsp->h_u.tcp_ip6_spec.ip6dst, rule->ip.v6.dst_ip,
+		       sizeof(struct in6_addr));
+		memcpy(fsp->m_u.tcp_ip6_spec.ip6src, rule->mask.v6.src_ip,
+		       sizeof(struct in6_addr));
+		memcpy(fsp->m_u.tcp_ip6_spec.ip6dst, rule->mask.v6.dst_ip,
+		       sizeof(struct in6_addr));
+		fsp->m_u.usr_ip6_spec.l4_4_bytes = rule->mask.v6.l4_header;
+		fsp->m_u.usr_ip6_spec.tclass = rule->mask.v6.tc;
+		fsp->m_u.usr_ip6_spec.l4_proto = rule->mask.v6.proto;
+		break;
+	case TCP_V6_FLOW:
+	case UDP_V6_FLOW:
+	case SCTP_V6_FLOW:
+		memcpy(fsp->h_u.tcp_ip6_spec.ip6src, rule->ip.v6.src_ip,
+		       sizeof(struct in6_addr));
+		memcpy(fsp->h_u.tcp_ip6_spec.ip6dst, rule->ip.v6.dst_ip,
+		       sizeof(struct in6_addr));
+		fsp->h_u.tcp_ip6_spec.psrc = rule->ip.v6.src_port;
+		fsp->h_u.tcp_ip6_spec.pdst = rule->ip.v6.dst_port;
+		memcpy(fsp->m_u.tcp_ip6_spec.ip6src,
+		       rule->mask.v6.src_ip,
+		       sizeof(struct in6_addr));
+		memcpy(fsp->m_u.tcp_ip6_spec.ip6dst,
+		       rule->mask.v6.dst_ip,
+		       sizeof(struct in6_addr));
+		fsp->m_u.tcp_ip6_spec.psrc = rule->mask.v6.src_port;
+		fsp->m_u.tcp_ip6_spec.pdst = rule->mask.v6.dst_port;
+		fsp->h_u.tcp_ip6_spec.tclass = rule->ip.v6.tc;
+		fsp->m_u.tcp_ip6_spec.tclass = rule->mask.v6.tc;
 		break;
 	default:
 		break;
@@ -441,6 +511,7 @@ ice_fdir_set_hw_fltr_rule(struct ice_pf *pf, struct ice_flow_seg_info *seg,
 /**
  * ice_set_init_fdir_seg
  * @seg: flow segment for programming
+ * @l3_proto: ICE_FLOW_SEG_HDR_IPV4 or ICE_FLOW_SEG_HDR_IPV6
  * @l4_proto: ICE_FLOW_SEG_HDR_TCP or ICE_FLOW_SEG_HDR_UDP
  *
  * Set the configuration for perfect filters to the provided flow segment for
@@ -449,13 +520,24 @@ ice_fdir_set_hw_fltr_rule(struct ice_pf *pf, struct ice_flow_seg_info *seg,
  */
 static int
 ice_set_init_fdir_seg(struct ice_flow_seg_info *seg,
+		      enum ice_flow_seg_hdr l3_proto,
 		      enum ice_flow_seg_hdr l4_proto)
 {
-	enum ice_flow_field src_port, dst_port;
+	enum ice_flow_field src_addr, dst_addr, src_port, dst_port;
 
 	if (!seg)
 		return -EINVAL;
 
+	if (l3_proto == ICE_FLOW_SEG_HDR_IPV4) {
+		src_addr = ICE_FLOW_FIELD_IDX_IPV4_SA;
+		dst_addr = ICE_FLOW_FIELD_IDX_IPV4_DA;
+	} else if (l3_proto == ICE_FLOW_SEG_HDR_IPV6) {
+		src_addr = ICE_FLOW_FIELD_IDX_IPV6_SA;
+		dst_addr = ICE_FLOW_FIELD_IDX_IPV6_DA;
+	} else {
+		return -EINVAL;
+	}
+
 	if (l4_proto == ICE_FLOW_SEG_HDR_TCP) {
 		src_port = ICE_FLOW_FIELD_IDX_TCP_SRC_PORT;
 		dst_port = ICE_FLOW_FIELD_IDX_TCP_DST_PORT;
@@ -466,17 +548,15 @@ ice_set_init_fdir_seg(struct ice_flow_seg_info *seg,
 		return -EINVAL;
 	}
 
-	ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_IPV4 | l4_proto);
+	ICE_FLOW_SET_HDRS(seg, l3_proto | l4_proto);
 
 	/* IP source address */
-	ice_flow_set_fld(seg, ICE_FLOW_FIELD_IDX_IPV4_SA,
-			 ICE_FLOW_FLD_OFF_INVAL, ICE_FLOW_FLD_OFF_INVAL,
-			 ICE_FLOW_FLD_OFF_INVAL, false);
+	ice_flow_set_fld(seg, src_addr, ICE_FLOW_FLD_OFF_INVAL,
+			 ICE_FLOW_FLD_OFF_INVAL, ICE_FLOW_FLD_OFF_INVAL, false);
 
 	/* IP destination address */
-	ice_flow_set_fld(seg, ICE_FLOW_FIELD_IDX_IPV4_DA,
-			 ICE_FLOW_FLD_OFF_INVAL, ICE_FLOW_FLD_OFF_INVAL,
-			 ICE_FLOW_FLD_OFF_INVAL, false);
+	ice_flow_set_fld(seg, dst_addr, ICE_FLOW_FLD_OFF_INVAL,
+			 ICE_FLOW_FLD_OFF_INVAL, ICE_FLOW_FLD_OFF_INVAL, false);
 
 	/* Layer 4 source port */
 	ice_flow_set_fld(seg, src_port, ICE_FLOW_FLD_OFF_INVAL,
@@ -521,9 +601,17 @@ ice_create_init_fdir_rule(struct ice_pf *pf, enum ice_fltr_ptype flow)
 	}
 
 	if (flow == ICE_FLTR_PTYPE_NONF_IPV4_TCP)
-		ret = ice_set_init_fdir_seg(seg, ICE_FLOW_SEG_HDR_TCP);
+		ret = ice_set_init_fdir_seg(seg, ICE_FLOW_SEG_HDR_IPV4,
+					    ICE_FLOW_SEG_HDR_TCP);
 	else if (flow == ICE_FLTR_PTYPE_NONF_IPV4_UDP)
-		ret = ice_set_init_fdir_seg(seg, ICE_FLOW_SEG_HDR_UDP);
+		ret = ice_set_init_fdir_seg(seg, ICE_FLOW_SEG_HDR_IPV4,
+					    ICE_FLOW_SEG_HDR_UDP);
+	else if (flow == ICE_FLTR_PTYPE_NONF_IPV6_TCP)
+		ret = ice_set_init_fdir_seg(seg, ICE_FLOW_SEG_HDR_IPV6,
+					    ICE_FLOW_SEG_HDR_TCP);
+	else if (flow == ICE_FLTR_PTYPE_NONF_IPV6_UDP)
+		ret = ice_set_init_fdir_seg(seg, ICE_FLOW_SEG_HDR_IPV6,
+					    ICE_FLOW_SEG_HDR_UDP);
 	else
 		ret = -EINVAL;
 	if (ret)
@@ -694,6 +782,156 @@ ice_set_fdir_ip4_usr_seg(struct ice_flow_seg_info *seg,
 	return 0;
 }
 
+/**
+ * ice_set_fdir_ip6_seg
+ * @seg: flow segment for programming
+ * @tcp_ip6_spec: mask data from ethtool
+ * @l4_proto: Layer 4 protocol to program
+ * @perfect_fltr: only valid on success; returns true if perfect filter,
+ *		  false if not
+ *
+ * Set the mask data into the flow segment to be used to program HW
+ * table based on provided L4 protocol for IPv6
+ */
+static int
+ice_set_fdir_ip6_seg(struct ice_flow_seg_info *seg,
+		     struct ethtool_tcpip6_spec *tcp_ip6_spec,
+		     enum ice_flow_seg_hdr l4_proto, bool *perfect_fltr)
+{
+	enum ice_flow_field src_port, dst_port;
+
+	/* make sure we don't have any empty rule */
+	if (!memcmp(tcp_ip6_spec->ip6src, &zero_ipv6_addr_mask,
+		    sizeof(struct in6_addr)) &&
+	    !memcmp(tcp_ip6_spec->ip6dst, &zero_ipv6_addr_mask,
+		    sizeof(struct in6_addr)) &&
+	    !tcp_ip6_spec->psrc && !tcp_ip6_spec->pdst)
+		return -EINVAL;
+
+	/* filtering on TC not supported */
+	if (tcp_ip6_spec->tclass)
+		return -EOPNOTSUPP;
+
+	if (l4_proto == ICE_FLOW_SEG_HDR_TCP) {
+		src_port = ICE_FLOW_FIELD_IDX_TCP_SRC_PORT;
+		dst_port = ICE_FLOW_FIELD_IDX_TCP_DST_PORT;
+	} else if (l4_proto == ICE_FLOW_SEG_HDR_UDP) {
+		src_port = ICE_FLOW_FIELD_IDX_UDP_SRC_PORT;
+		dst_port = ICE_FLOW_FIELD_IDX_UDP_DST_PORT;
+	} else if (l4_proto == ICE_FLOW_SEG_HDR_SCTP) {
+		src_port = ICE_FLOW_FIELD_IDX_SCTP_SRC_PORT;
+		dst_port = ICE_FLOW_FIELD_IDX_SCTP_DST_PORT;
+	} else {
+		return -EINVAL;
+	}
+
+	*perfect_fltr = true;
+	ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_IPV6 | l4_proto);
+
+	if (!memcmp(tcp_ip6_spec->ip6src, &full_ipv6_addr_mask,
+		    sizeof(struct in6_addr)))
+		ice_flow_set_fld(seg, ICE_FLOW_FIELD_IDX_IPV6_SA,
+				 ICE_FLOW_FLD_OFF_INVAL, ICE_FLOW_FLD_OFF_INVAL,
+				 ICE_FLOW_FLD_OFF_INVAL, false);
+	else if (!memcmp(tcp_ip6_spec->ip6src, &zero_ipv6_addr_mask,
+			 sizeof(struct in6_addr)))
+		*perfect_fltr = false;
+	else
+		return -EOPNOTSUPP;
+
+	if (!memcmp(tcp_ip6_spec->ip6dst, &full_ipv6_addr_mask,
+		    sizeof(struct in6_addr)))
+		ice_flow_set_fld(seg, ICE_FLOW_FIELD_IDX_IPV6_DA,
+				 ICE_FLOW_FLD_OFF_INVAL, ICE_FLOW_FLD_OFF_INVAL,
+				 ICE_FLOW_FLD_OFF_INVAL, false);
+	else if (!memcmp(tcp_ip6_spec->ip6dst, &zero_ipv6_addr_mask,
+			 sizeof(struct in6_addr)))
+		*perfect_fltr = false;
+	else
+		return -EOPNOTSUPP;
+
+	/* Layer 4 source port */
+	if (tcp_ip6_spec->psrc == htons(0xFFFF))
+		ice_flow_set_fld(seg, src_port, ICE_FLOW_FLD_OFF_INVAL,
+				 ICE_FLOW_FLD_OFF_INVAL, ICE_FLOW_FLD_OFF_INVAL,
+				 false);
+	else if (!tcp_ip6_spec->psrc)
+		*perfect_fltr = false;
+	else
+		return -EOPNOTSUPP;
+
+	/* Layer 4 destination port */
+	if (tcp_ip6_spec->pdst == htons(0xFFFF))
+		ice_flow_set_fld(seg, dst_port, ICE_FLOW_FLD_OFF_INVAL,
+				 ICE_FLOW_FLD_OFF_INVAL, ICE_FLOW_FLD_OFF_INVAL,
+				 false);
+	else if (!tcp_ip6_spec->pdst)
+		*perfect_fltr = false;
+	else
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+/**
+ * ice_set_fdir_ip6_usr_seg
+ * @seg: flow segment for programming
+ * @usr_ip6_spec: ethtool userdef packet offset
+ * @perfect_fltr: only valid on success; returns true if perfect filter,
+ *		  false if not
+ *
+ * Set the offset data into the flow segment to be used to program HW
+ * table for IPv6
+ */
+static int
+ice_set_fdir_ip6_usr_seg(struct ice_flow_seg_info *seg,
+			 struct ethtool_usrip6_spec *usr_ip6_spec,
+			 bool *perfect_fltr)
+{
+	/* filtering on Layer 4 bytes not supported */
+	if (usr_ip6_spec->l4_4_bytes)
+		return -EOPNOTSUPP;
+	/* filtering on TC not supported */
+	if (usr_ip6_spec->tclass)
+		return -EOPNOTSUPP;
+	/* filtering on Layer 4 protocol not supported */
+	if (usr_ip6_spec->l4_proto)
+		return -EOPNOTSUPP;
+	/* empty rules are not valid */
+	if (!memcmp(usr_ip6_spec->ip6src, &zero_ipv6_addr_mask,
+		    sizeof(struct in6_addr)) &&
+	    !memcmp(usr_ip6_spec->ip6dst, &zero_ipv6_addr_mask,
+		    sizeof(struct in6_addr)))
+		return -EINVAL;
+
+	*perfect_fltr = true;
+	ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_IPV6);
+
+	if (!memcmp(usr_ip6_spec->ip6src, &full_ipv6_addr_mask,
+		    sizeof(struct in6_addr)))
+		ice_flow_set_fld(seg, ICE_FLOW_FIELD_IDX_IPV6_SA,
+				 ICE_FLOW_FLD_OFF_INVAL, ICE_FLOW_FLD_OFF_INVAL,
+				 ICE_FLOW_FLD_OFF_INVAL, false);
+	else if (!memcmp(usr_ip6_spec->ip6src, &zero_ipv6_addr_mask,
+			 sizeof(struct in6_addr)))
+		*perfect_fltr = false;
+	else
+		return -EOPNOTSUPP;
+
+	if (!memcmp(usr_ip6_spec->ip6dst, &full_ipv6_addr_mask,
+		    sizeof(struct in6_addr)))
+		ice_flow_set_fld(seg, ICE_FLOW_FIELD_IDX_IPV6_DA,
+				 ICE_FLOW_FLD_OFF_INVAL, ICE_FLOW_FLD_OFF_INVAL,
+				 ICE_FLOW_FLD_OFF_INVAL, false);
+	else if (!memcmp(usr_ip6_spec->ip6dst, &zero_ipv6_addr_mask,
+			 sizeof(struct in6_addr)))
+		*perfect_fltr = false;
+	else
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
 /**
  * ice_cfg_fdir_xtrct_seq - Configure extraction sequence for the given filter
  * @pf: PF structure
@@ -742,6 +980,25 @@ ice_cfg_fdir_xtrct_seq(struct ice_pf *pf, struct ethtool_rx_flow_spec *fsp)
 		ret = ice_set_fdir_ip4_usr_seg(seg, &fsp->m_u.usr_ip4_spec,
 					       &perfect_filter);
 		break;
+	case TCP_V6_FLOW:
+		ret = ice_set_fdir_ip6_seg(seg, &fsp->m_u.tcp_ip6_spec,
+					   ICE_FLOW_SEG_HDR_TCP,
+					   &perfect_filter);
+		break;
+	case UDP_V6_FLOW:
+		ret = ice_set_fdir_ip6_seg(seg, &fsp->m_u.tcp_ip6_spec,
+					   ICE_FLOW_SEG_HDR_UDP,
+					   &perfect_filter);
+		break;
+	case SCTP_V6_FLOW:
+		ret = ice_set_fdir_ip6_seg(seg, &fsp->m_u.tcp_ip6_spec,
+					   ICE_FLOW_SEG_HDR_SCTP,
+					   &perfect_filter);
+		break;
+	case IPV6_USER_FLOW:
+		ret = ice_set_fdir_ip6_usr_seg(seg, &fsp->m_u.usr_ip6_spec,
+					       &perfect_filter);
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -910,6 +1167,14 @@ int ice_fdir_create_dflt_rules(struct ice_pf *pf)
 		return err;
 
 	err = ice_create_init_fdir_rule(pf, ICE_FLTR_PTYPE_NONF_IPV4_UDP);
+	if (err)
+		return err;
+
+	err = ice_create_init_fdir_rule(pf, ICE_FLTR_PTYPE_NONF_IPV6_TCP);
+	if (err)
+		return err;
+
+	err = ice_create_init_fdir_rule(pf, ICE_FLTR_PTYPE_NONF_IPV6_UDP);
 
 	return err;
 }
@@ -1094,28 +1359,62 @@ ice_set_fdir_input_set(struct ice_vsi *vsi, struct ethtool_rx_flow_spec *fsp,
 	case TCP_V4_FLOW:
 	case UDP_V4_FLOW:
 	case SCTP_V4_FLOW:
-		input->ip.dst_port = fsp->h_u.tcp_ip4_spec.pdst;
-		input->ip.src_port = fsp->h_u.tcp_ip4_spec.psrc;
-		input->ip.dst_ip = fsp->h_u.tcp_ip4_spec.ip4dst;
-		input->ip.src_ip = fsp->h_u.tcp_ip4_spec.ip4src;
-		input->mask.dst_port = fsp->m_u.tcp_ip4_spec.pdst;
-		input->mask.src_port = fsp->m_u.tcp_ip4_spec.psrc;
-		input->mask.dst_ip = fsp->m_u.tcp_ip4_spec.ip4dst;
-		input->mask.src_ip = fsp->m_u.tcp_ip4_spec.ip4src;
+		input->ip.v4.dst_port = fsp->h_u.tcp_ip4_spec.pdst;
+		input->ip.v4.src_port = fsp->h_u.tcp_ip4_spec.psrc;
+		input->ip.v4.dst_ip = fsp->h_u.tcp_ip4_spec.ip4dst;
+		input->ip.v4.src_ip = fsp->h_u.tcp_ip4_spec.ip4src;
+		input->mask.v4.dst_port = fsp->m_u.tcp_ip4_spec.pdst;
+		input->mask.v4.src_port = fsp->m_u.tcp_ip4_spec.psrc;
+		input->mask.v4.dst_ip = fsp->m_u.tcp_ip4_spec.ip4dst;
+		input->mask.v4.src_ip = fsp->m_u.tcp_ip4_spec.ip4src;
 		break;
 	case IPV4_USER_FLOW:
-		input->ip.dst_ip = fsp->h_u.usr_ip4_spec.ip4dst;
-		input->ip.src_ip = fsp->h_u.usr_ip4_spec.ip4src;
-		input->ip.l4_header = fsp->h_u.usr_ip4_spec.l4_4_bytes;
-		input->ip.proto = fsp->h_u.usr_ip4_spec.proto;
-		input->ip.ip_ver = fsp->h_u.usr_ip4_spec.ip_ver;
-		input->ip.tos = fsp->h_u.usr_ip4_spec.tos;
-		input->mask.dst_ip = fsp->m_u.usr_ip4_spec.ip4dst;
-		input->mask.src_ip = fsp->m_u.usr_ip4_spec.ip4src;
-		input->mask.l4_header = fsp->m_u.usr_ip4_spec.l4_4_bytes;
-		input->mask.proto = fsp->m_u.usr_ip4_spec.proto;
-		input->mask.ip_ver = fsp->m_u.usr_ip4_spec.ip_ver;
-		input->mask.tos = fsp->m_u.usr_ip4_spec.tos;
+		input->ip.v4.dst_ip = fsp->h_u.usr_ip4_spec.ip4dst;
+		input->ip.v4.src_ip = fsp->h_u.usr_ip4_spec.ip4src;
+		input->ip.v4.l4_header = fsp->h_u.usr_ip4_spec.l4_4_bytes;
+		input->ip.v4.proto = fsp->h_u.usr_ip4_spec.proto;
+		input->ip.v4.ip_ver = fsp->h_u.usr_ip4_spec.ip_ver;
+		input->ip.v4.tos = fsp->h_u.usr_ip4_spec.tos;
+		input->mask.v4.dst_ip = fsp->m_u.usr_ip4_spec.ip4dst;
+		input->mask.v4.src_ip = fsp->m_u.usr_ip4_spec.ip4src;
+		input->mask.v4.l4_header = fsp->m_u.usr_ip4_spec.l4_4_bytes;
+		input->mask.v4.proto = fsp->m_u.usr_ip4_spec.proto;
+		input->mask.v4.ip_ver = fsp->m_u.usr_ip4_spec.ip_ver;
+		input->mask.v4.tos = fsp->m_u.usr_ip4_spec.tos;
+		break;
+	case TCP_V6_FLOW:
+	case UDP_V6_FLOW:
+	case SCTP_V6_FLOW:
+		memcpy(input->ip.v6.dst_ip, fsp->h_u.usr_ip6_spec.ip6dst,
+		       sizeof(struct in6_addr));
+		memcpy(input->ip.v6.src_ip, fsp->h_u.usr_ip6_spec.ip6src,
+		       sizeof(struct in6_addr));
+		input->ip.v6.dst_port = fsp->h_u.tcp_ip6_spec.pdst;
+		input->ip.v6.src_port = fsp->h_u.tcp_ip6_spec.psrc;
+		input->ip.v6.tc = fsp->h_u.tcp_ip6_spec.tclass;
+		memcpy(input->mask.v6.dst_ip, fsp->m_u.tcp_ip6_spec.ip6dst,
+		       sizeof(struct in6_addr));
+		memcpy(input->mask.v6.src_ip, fsp->m_u.tcp_ip6_spec.ip6src,
+		       sizeof(struct in6_addr));
+		input->mask.v6.dst_port = fsp->m_u.tcp_ip6_spec.pdst;
+		input->mask.v6.src_port = fsp->m_u.tcp_ip6_spec.psrc;
+		input->mask.v6.tc = fsp->m_u.tcp_ip6_spec.tclass;
+		break;
+	case IPV6_USER_FLOW:
+		memcpy(input->ip.v6.dst_ip, fsp->h_u.usr_ip6_spec.ip6dst,
+		       sizeof(struct in6_addr));
+		memcpy(input->ip.v6.src_ip, fsp->h_u.usr_ip6_spec.ip6src,
+		       sizeof(struct in6_addr));
+		input->ip.v6.l4_header = fsp->h_u.usr_ip6_spec.l4_4_bytes;
+		input->ip.v6.tc = fsp->h_u.usr_ip6_spec.tclass;
+		input->ip.v6.proto = fsp->h_u.usr_ip6_spec.l4_proto;
+		memcpy(input->mask.v6.dst_ip, fsp->m_u.usr_ip6_spec.ip6dst,
+		       sizeof(struct in6_addr));
+		memcpy(input->mask.v6.src_ip, fsp->m_u.usr_ip6_spec.ip6src,
+		       sizeof(struct in6_addr));
+		input->mask.v6.l4_header = fsp->m_u.usr_ip6_spec.l4_4_bytes;
+		input->mask.v6.tc = fsp->m_u.usr_ip6_spec.tclass;
+		input->mask.v6.proto = fsp->m_u.usr_ip6_spec.l4_proto;
 		break;
 	default:
 		/* not doing un-parsed flow types */
diff --git a/drivers/net/ethernet/intel/ice/ice_fdir.c b/drivers/net/ethernet/intel/ice/ice_fdir.c
index 60a824363f06..d50cc6e9086e 100644
--- a/drivers/net/ethernet/intel/ice/ice_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_fdir.c
@@ -40,6 +40,52 @@ static const u8 ice_fdir_ipv4_pkt[] = {
 	0x00, 0x00
 };
 
+static const u8 ice_fdir_tcpv6_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x86, 0xDD, 0x60, 0x00,
+	0x00, 0x00, 0x00, 0x14, 0x06, 0x40, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x50, 0x00, 0x20, 0x00, 0x00, 0x00,
+	0x00, 0x00,
+};
+
+static const u8 ice_fdir_udpv6_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x86, 0xDD, 0x60, 0x00,
+	0x00, 0x00, 0x00, 0x08, 0x11, 0x40, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x08, 0x00, 0x00,
+};
+
+static const u8 ice_fdir_sctpv6_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x86, 0xDD, 0x60, 0x00,
+	0x00, 0x00, 0x00, 0x0C, 0x84, 0x40, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00,
+};
+
+static const u8 ice_fdir_ipv6_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x86, 0xDD, 0x60, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x3B, 0x40, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+};
+
 static const u8 ice_fdir_tcp4_tun_pkt[] = {
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x45, 0x00,
@@ -100,6 +146,76 @@ static const u8 ice_fdir_ip4_tun_pkt[] = {
 	0x00, 0x00, 0x00, 0x00,
 };
 
+static const u8 ice_fdir_tcp6_tun_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x45, 0x00,
+	0x00, 0x6e, 0x00, 0x00, 0x40, 0x00, 0x40, 0x11,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x04, 0x00, 0x00, 0x03, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x86, 0xdd,
+	0x60, 0x00, 0x00, 0x00, 0x00, 0x14, 0x06, 0x40,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x50, 0x00, 0x20, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+};
+
+static const u8 ice_fdir_udp6_tun_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x45, 0x00,
+	0x00, 0x62, 0x00, 0x00, 0x40, 0x00, 0x40, 0x11,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x04, 0x00, 0x00, 0x03, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x86, 0xdd,
+	0x60, 0x00, 0x00, 0x00, 0x00, 0x08, 0x11, 0x40,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+};
+
+static const u8 ice_fdir_sctp6_tun_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x45, 0x00,
+	0x00, 0x66, 0x00, 0x00, 0x40, 0x00, 0x40, 0x11,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x04, 0x00, 0x00, 0x03, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x86, 0xdd,
+	0x60, 0x00, 0x00, 0x00, 0x00, 0x0c, 0x84, 0x40,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00,
+};
+
+static const u8 ice_fdir_ip6_tun_pkt[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x45, 0x00,
+	0x00, 0x5a, 0x00, 0x00, 0x40, 0x00, 0x40, 0x11,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x04, 0x00, 0x00, 0x03, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x86, 0xdd,
+	0x60, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3b, 0x40,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+};
+
 /* Flow Director no-op training packet table */
 static const struct ice_fdir_base_pkt ice_fdir_pkt[] = {
 	{
@@ -122,6 +238,26 @@ static const struct ice_fdir_base_pkt ice_fdir_pkt[] = {
 		sizeof(ice_fdir_ipv4_pkt), ice_fdir_ipv4_pkt,
 		sizeof(ice_fdir_ip4_tun_pkt), ice_fdir_ip4_tun_pkt,
 	},
+	{
+		ICE_FLTR_PTYPE_NONF_IPV6_TCP,
+		sizeof(ice_fdir_tcpv6_pkt), ice_fdir_tcpv6_pkt,
+		sizeof(ice_fdir_tcp6_tun_pkt), ice_fdir_tcp6_tun_pkt,
+	},
+	{
+		ICE_FLTR_PTYPE_NONF_IPV6_UDP,
+		sizeof(ice_fdir_udpv6_pkt), ice_fdir_udpv6_pkt,
+		sizeof(ice_fdir_udp6_tun_pkt), ice_fdir_udp6_tun_pkt,
+	},
+	{
+		ICE_FLTR_PTYPE_NONF_IPV6_SCTP,
+		sizeof(ice_fdir_sctpv6_pkt), ice_fdir_sctpv6_pkt,
+		sizeof(ice_fdir_sctp6_tun_pkt), ice_fdir_sctp6_tun_pkt,
+	},
+	{
+		ICE_FLTR_PTYPE_NONF_IPV6_OTHER,
+		sizeof(ice_fdir_ipv6_pkt), ice_fdir_ipv6_pkt,
+		sizeof(ice_fdir_ip6_tun_pkt), ice_fdir_ip6_tun_pkt,
+	},
 };
 
 #define ICE_FDIR_NUM_PKT ARRAY_SIZE(ice_fdir_pkt)
@@ -319,6 +455,21 @@ int ice_get_fdir_cnt_all(struct ice_hw *hw)
 	return hw->func_caps.fd_fltr_guar + hw->func_caps.fd_fltr_best_effort;
 }
 
+/**
+ * ice_pkt_insert_ipv6_addr - insert a be32 IPv6 address into a memory buffer
+ * @pkt: packet buffer
+ * @offset: offset into buffer
+ * @addr: IPv6 address to convert and insert into pkt at offset
+ */
+static void ice_pkt_insert_ipv6_addr(u8 *pkt, int offset, __be32 *addr)
+{
+	int idx;
+
+	for (idx = 0; idx < ICE_IPV6_ADDR_LEN_AS_U32; idx++)
+		memcpy(pkt + offset + idx * sizeof(*addr), &addr[idx],
+		       sizeof(*addr));
+}
+
 /**
  * ice_pkt_insert_u16 - insert a be16 value into a memory buffer
  * @pkt: packet buffer
@@ -359,7 +510,7 @@ ice_fdir_get_gen_prgm_pkt(struct ice_hw *hw, struct ice_fdir_fltr *input,
 	u16 idx;
 
 	if (input->flow_type == ICE_FLTR_PTYPE_NONF_IPV4_OTHER) {
-		switch (input->ip.proto) {
+		switch (input->ip.v4.proto) {
 		case IPPROTO_TCP:
 			flow = ICE_FLTR_PTYPE_NONF_IPV4_TCP;
 			break;
@@ -375,6 +526,23 @@ ice_fdir_get_gen_prgm_pkt(struct ice_hw *hw, struct ice_fdir_fltr *input,
 		default:
 			return ICE_ERR_PARAM;
 		}
+	} else if (input->flow_type == ICE_FLTR_PTYPE_NONF_IPV6_OTHER) {
+		switch (input->ip.v6.proto) {
+		case IPPROTO_TCP:
+			flow = ICE_FLTR_PTYPE_NONF_IPV6_TCP;
+			break;
+		case IPPROTO_UDP:
+			flow = ICE_FLTR_PTYPE_NONF_IPV6_UDP;
+			break;
+		case IPPROTO_SCTP:
+			flow = ICE_FLTR_PTYPE_NONF_IPV6_SCTP;
+			break;
+		case IPPROTO_IP:
+			flow = ICE_FLTR_PTYPE_NONF_IPV6_OTHER;
+			break;
+		default:
+			return ICE_ERR_PARAM;
+		}
 	} else {
 		flow = input->flow_type;
 	}
@@ -405,43 +573,79 @@ ice_fdir_get_gen_prgm_pkt(struct ice_hw *hw, struct ice_fdir_fltr *input,
 	switch (flow) {
 	case ICE_FLTR_PTYPE_NONF_IPV4_TCP:
 		ice_pkt_insert_u32(loc, ICE_IPV4_DST_ADDR_OFFSET,
-				   input->ip.src_ip);
+				   input->ip.v4.src_ip);
 		ice_pkt_insert_u16(loc, ICE_IPV4_TCP_DST_PORT_OFFSET,
-				   input->ip.src_port);
+				   input->ip.v4.src_port);
 		ice_pkt_insert_u32(loc, ICE_IPV4_SRC_ADDR_OFFSET,
-				   input->ip.dst_ip);
+				   input->ip.v4.dst_ip);
 		ice_pkt_insert_u16(loc, ICE_IPV4_TCP_SRC_PORT_OFFSET,
-				   input->ip.dst_port);
+				   input->ip.v4.dst_port);
 		if (frag)
 			loc[20] = ICE_FDIR_IPV4_PKT_FLAG_DF;
 		break;
 	case ICE_FLTR_PTYPE_NONF_IPV4_UDP:
 		ice_pkt_insert_u32(loc, ICE_IPV4_DST_ADDR_OFFSET,
-				   input->ip.src_ip);
+				   input->ip.v4.src_ip);
 		ice_pkt_insert_u16(loc, ICE_IPV4_UDP_DST_PORT_OFFSET,
-				   input->ip.src_port);
+				   input->ip.v4.src_port);
 		ice_pkt_insert_u32(loc, ICE_IPV4_SRC_ADDR_OFFSET,
-				   input->ip.dst_ip);
+				   input->ip.v4.dst_ip);
 		ice_pkt_insert_u16(loc, ICE_IPV4_UDP_SRC_PORT_OFFSET,
-				   input->ip.dst_port);
+				   input->ip.v4.dst_port);
 		break;
 	case ICE_FLTR_PTYPE_NONF_IPV4_SCTP:
 		ice_pkt_insert_u32(loc, ICE_IPV4_DST_ADDR_OFFSET,
-				   input->ip.src_ip);
+				   input->ip.v4.src_ip);
 		ice_pkt_insert_u16(loc, ICE_IPV4_SCTP_DST_PORT_OFFSET,
-				   input->ip.src_port);
+				   input->ip.v4.src_port);
 		ice_pkt_insert_u32(loc, ICE_IPV4_SRC_ADDR_OFFSET,
-				   input->ip.dst_ip);
+				   input->ip.v4.dst_ip);
 		ice_pkt_insert_u16(loc, ICE_IPV4_SCTP_SRC_PORT_OFFSET,
-				   input->ip.dst_port);
+				   input->ip.v4.dst_port);
 		break;
 	case ICE_FLTR_PTYPE_NONF_IPV4_OTHER:
 		ice_pkt_insert_u32(loc, ICE_IPV4_DST_ADDR_OFFSET,
-				   input->ip.src_ip);
+				   input->ip.v4.src_ip);
 		ice_pkt_insert_u32(loc, ICE_IPV4_SRC_ADDR_OFFSET,
-				   input->ip.dst_ip);
+				   input->ip.v4.dst_ip);
 		ice_pkt_insert_u16(loc, ICE_IPV4_PROTO_OFFSET, 0);
 		break;
+	case ICE_FLTR_PTYPE_NONF_IPV6_TCP:
+		ice_pkt_insert_ipv6_addr(loc, ICE_IPV6_DST_ADDR_OFFSET,
+					 input->ip.v6.src_ip);
+		ice_pkt_insert_ipv6_addr(loc, ICE_IPV6_SRC_ADDR_OFFSET,
+					 input->ip.v6.dst_ip);
+		ice_pkt_insert_u16(loc, ICE_IPV6_TCP_DST_PORT_OFFSET,
+				   input->ip.v6.src_port);
+		ice_pkt_insert_u16(loc, ICE_IPV6_TCP_SRC_PORT_OFFSET,
+				   input->ip.v6.dst_port);
+		break;
+	case ICE_FLTR_PTYPE_NONF_IPV6_UDP:
+		ice_pkt_insert_ipv6_addr(loc, ICE_IPV6_DST_ADDR_OFFSET,
+					 input->ip.v6.src_ip);
+		ice_pkt_insert_ipv6_addr(loc, ICE_IPV6_SRC_ADDR_OFFSET,
+					 input->ip.v6.dst_ip);
+		ice_pkt_insert_u16(loc, ICE_IPV6_UDP_DST_PORT_OFFSET,
+				   input->ip.v6.src_port);
+		ice_pkt_insert_u16(loc, ICE_IPV6_UDP_SRC_PORT_OFFSET,
+				   input->ip.v6.dst_port);
+		break;
+	case ICE_FLTR_PTYPE_NONF_IPV6_SCTP:
+		ice_pkt_insert_ipv6_addr(loc, ICE_IPV6_DST_ADDR_OFFSET,
+					 input->ip.v6.src_ip);
+		ice_pkt_insert_ipv6_addr(loc, ICE_IPV6_SRC_ADDR_OFFSET,
+					 input->ip.v6.dst_ip);
+		ice_pkt_insert_u16(loc, ICE_IPV6_SCTP_DST_PORT_OFFSET,
+				   input->ip.v6.src_port);
+		ice_pkt_insert_u16(loc, ICE_IPV6_SCTP_SRC_PORT_OFFSET,
+				   input->ip.v6.dst_port);
+		break;
+	case ICE_FLTR_PTYPE_NONF_IPV6_OTHER:
+		ice_pkt_insert_ipv6_addr(loc, ICE_IPV6_DST_ADDR_OFFSET,
+					 input->ip.v6.src_ip);
+		ice_pkt_insert_ipv6_addr(loc, ICE_IPV6_SRC_ADDR_OFFSET,
+					 input->ip.v6.dst_ip);
+		break;
 	default:
 		return ICE_ERR_PARAM;
 	}
@@ -527,37 +731,68 @@ ice_fdir_update_cntrs(struct ice_hw *hw, enum ice_fltr_ptype flow, bool add)
 		hw->fdir_fltr_cnt[flow] += incr;
 }
 
+/**
+ * ice_cmp_ipv6_addr - compare 2 IP v6 addresses
+ * @a: IP v6 address
+ * @b: IP v6 address
+ *
+ * Returns 0 on equal, returns non-0 if different
+ */
+static int ice_cmp_ipv6_addr(__be32 *a, __be32 *b)
+{
+	return memcmp(a, b, 4 * sizeof(__be32));
+}
+
 /**
  * ice_fdir_comp_rules - compare 2 filters
  * @a: a Flow Director filter data structure
  * @b: a Flow Director filter data structure
+ * @v6: bool true if v6 filter
  *
  * Returns true if the filters match
  */
 static bool
-ice_fdir_comp_rules(struct ice_fdir_fltr *a,  struct ice_fdir_fltr *b)
+ice_fdir_comp_rules(struct ice_fdir_fltr *a,  struct ice_fdir_fltr *b, bool v6)
 {
 	enum ice_fltr_ptype flow_type = a->flow_type;
 
 	/* The calling function already checks that the two filters have the
 	 * same flow_type.
 	 */
-	if (flow_type == ICE_FLTR_PTYPE_NONF_IPV4_TCP ||
-	    flow_type == ICE_FLTR_PTYPE_NONF_IPV4_UDP ||
-	    flow_type == ICE_FLTR_PTYPE_NONF_IPV4_SCTP) {
-		if (a->ip.dst_ip == b->ip.dst_ip &&
-		    a->ip.src_ip == b->ip.src_ip &&
-		    a->ip.dst_port == b->ip.dst_port &&
-		    a->ip.src_port == b->ip.src_port)
-			return true;
-	} else if (flow_type == ICE_FLTR_PTYPE_NONF_IPV4_OTHER) {
-		if (a->ip.dst_ip == b->ip.dst_ip &&
-		    a->ip.src_ip == b->ip.src_ip &&
-		    a->ip.l4_header == b->ip.l4_header &&
-		    a->ip.proto == b->ip.proto &&
-		    a->ip.ip_ver == b->ip.ip_ver &&
-		    a->ip.tos == b->ip.tos)
-			return true;
+	if (!v6) {
+		if (flow_type == ICE_FLTR_PTYPE_NONF_IPV4_TCP ||
+		    flow_type == ICE_FLTR_PTYPE_NONF_IPV4_UDP ||
+		    flow_type == ICE_FLTR_PTYPE_NONF_IPV4_SCTP) {
+			if (a->ip.v4.dst_ip == b->ip.v4.dst_ip &&
+			    a->ip.v4.src_ip == b->ip.v4.src_ip &&
+			    a->ip.v4.dst_port == b->ip.v4.dst_port &&
+			    a->ip.v4.src_port == b->ip.v4.src_port)
+				return true;
+		} else if (flow_type == ICE_FLTR_PTYPE_NONF_IPV4_OTHER) {
+			if (a->ip.v4.dst_ip == b->ip.v4.dst_ip &&
+			    a->ip.v4.src_ip == b->ip.v4.src_ip &&
+			    a->ip.v4.l4_header == b->ip.v4.l4_header &&
+			    a->ip.v4.proto == b->ip.v4.proto &&
+			    a->ip.v4.ip_ver == b->ip.v4.ip_ver &&
+			    a->ip.v4.tos == b->ip.v4.tos)
+				return true;
+		}
+	} else {
+		if (flow_type == ICE_FLTR_PTYPE_NONF_IPV6_UDP ||
+		    flow_type == ICE_FLTR_PTYPE_NONF_IPV6_TCP ||
+		    flow_type == ICE_FLTR_PTYPE_NONF_IPV6_SCTP) {
+			if (a->ip.v6.dst_port == b->ip.v6.dst_port &&
+			    a->ip.v6.src_port == b->ip.v6.src_port &&
+			    !ice_cmp_ipv6_addr(a->ip.v6.dst_ip,
+					       b->ip.v6.dst_ip) &&
+			    !ice_cmp_ipv6_addr(a->ip.v6.src_ip,
+					       b->ip.v6.src_ip))
+				return true;
+		} else if (flow_type == ICE_FLTR_PTYPE_NONF_IPV6_OTHER) {
+			if (a->ip.v6.dst_port == b->ip.v6.dst_port &&
+			    a->ip.v6.src_port == b->ip.v6.src_port)
+				return true;
+		}
 	}
 
 	return false;
@@ -586,7 +821,9 @@ bool ice_fdir_is_dup_fltr(struct ice_hw *hw, struct ice_fdir_fltr *input)
 		    flow_type == ICE_FLTR_PTYPE_NONF_IPV4_UDP ||
 		    flow_type == ICE_FLTR_PTYPE_NONF_IPV4_SCTP ||
 		    flow_type == ICE_FLTR_PTYPE_NONF_IPV4_OTHER)
-			ret = ice_fdir_comp_rules(rule, input);
+			ret = ice_fdir_comp_rules(rule, input, false);
+		else
+			ret = ice_fdir_comp_rules(rule, input, true);
 		if (ret) {
 			if (rule->fltr_id == input->fltr_id &&
 			    rule->q_index != input->q_index)
diff --git a/drivers/net/ethernet/intel/ice/ice_fdir.h b/drivers/net/ethernet/intel/ice/ice_fdir.h
index 1a13c80e1eac..977dcbc1400d 100644
--- a/drivers/net/ethernet/intel/ice/ice_fdir.h
+++ b/drivers/net/ethernet/intel/ice/ice_fdir.h
@@ -80,6 +80,19 @@ struct ice_fdir_v4 {
 	u8 proto;
 };
 
+#define ICE_IPV6_ADDR_LEN_AS_U32		4
+
+struct ice_fdir_v6 {
+	__be32 dst_ip[ICE_IPV6_ADDR_LEN_AS_U32];
+	__be32 src_ip[ICE_IPV6_ADDR_LEN_AS_U32];
+	__be16 dst_port;
+	__be16 src_port;
+	__be32 l4_header; /* next header */
+	__be32 sec_parm_idx; /* security parameter index */
+	u8 tc;
+	u8 proto;
+};
+
 struct ice_fdir_extra {
 	u8 dst_mac[ETH_ALEN];	/* dest MAC address */
 	u32 usr_def[2];		/* user data */
@@ -91,8 +104,10 @@ struct ice_fdir_fltr {
 	struct list_head fltr_node;
 	enum ice_fltr_ptype flow_type;
 
-	struct ice_fdir_v4 ip;
-	struct ice_fdir_v4 mask;
+	union {
+		struct ice_fdir_v4 v4;
+		struct ice_fdir_v6 v6;
+	} ip, mask;
 
 	struct ice_fdir_extra ext_data;
 	struct ice_fdir_extra ext_mask;
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 16d2f599bd70..da82783d1571 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -3518,6 +3518,12 @@ static const struct ice_fd_src_dst_pair ice_fd_pairs[] = {
 	{ ICE_PROT_IPV4_IL, 2, 12 },
 	{ ICE_PROT_IPV4_IL, 2, 16 },
 
+	{ ICE_PROT_IPV6_OF_OR_S, 8, 8 },
+	{ ICE_PROT_IPV6_OF_OR_S, 8, 24 },
+
+	{ ICE_PROT_IPV6_IL, 8, 8 },
+	{ ICE_PROT_IPV6_IL, 8, 24 },
+
 	{ ICE_PROT_TCP_IL, 1, 0 },
 	{ ICE_PROT_TCP_IL, 1, 2 },
 
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index fcf1f7853a41..f1bfe8c94f1f 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -171,6 +171,10 @@ enum ice_fltr_ptype {
 	ICE_FLTR_PTYPE_NONF_IPV4_SCTP,
 	ICE_FLTR_PTYPE_NONF_IPV4_OTHER,
 	ICE_FLTR_PTYPE_FRAG_IPV4,
+	ICE_FLTR_PTYPE_NONF_IPV6_UDP,
+	ICE_FLTR_PTYPE_NONF_IPV6_TCP,
+	ICE_FLTR_PTYPE_NONF_IPV6_SCTP,
+	ICE_FLTR_PTYPE_NONF_IPV6_OTHER,
 	ICE_FLTR_PTYPE_MAX,
 };
 
-- 
2.26.2

