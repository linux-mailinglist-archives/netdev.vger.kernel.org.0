Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74C43450E1
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbhCVUcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:32:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:5504 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231939AbhCVUbb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:31:31 -0400
IronPort-SDR: osNb4H9JBH8BW80vFdJmPz9pO7mgez9LHm9cNiLRmyTJ7mA7Agp8Te3wq37GsArBR3X4rFK1Z1
 K0Y8F06EteUg==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="190438226"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="190438226"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 13:31:19 -0700
IronPort-SDR: /MtBcllNVUavli9NVTwoTZ7WylT0s5ZKsmClOnEjR54zyGkLIlo7UKZC6LB6/yIxKlx2/7OPKG
 ToGF690pFw0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="375810632"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 22 Mar 2021 13:31:18 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Haiyue Wang <haiyue.wang@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        qi.z.zhang@intel.com, Chen Bo <BoX.C.Chen@intel.com>
Subject: [PATCH net-next 17/18] iavf: Support Ethernet Type Flow Director filters
Date:   Mon, 22 Mar 2021 13:32:43 -0700
Message-Id: <20210322203244.2525310-18-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210322203244.2525310-1-anthony.l.nguyen@intel.com>
References: <20210322203244.2525310-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyue Wang <haiyue.wang@intel.com>

Support the addition and deletion of Ethernet filters.

Supported fields are: proto
Supported flow-types are: ether

Example usage:
ethtool -N ens787f0v0 flow-type ether proto 0x8863 action 6
ethtool -N ens787f0v0 flow-type ether proto 0x8864 action 7

Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Tested-by: Chen Bo <BoX.C.Chen@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/iavf/iavf_ethtool.c    | 12 ++++++++++
 drivers/net/ethernet/intel/iavf/iavf_fdir.c   | 23 ++++++++++++++++++-
 drivers/net/ethernet/intel/iavf/iavf_fdir.h   |  8 +++++++
 3 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index 8d856f5dc38e..24ee6ddb8dcb 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -861,6 +861,8 @@ static int iavf_fltr_to_ethtool_flow(enum iavf_fdir_flow_type flow)
 		return ESP_V6_FLOW;
 	case IAVF_FDIR_FLOW_IPV6_OTHER:
 		return IPV6_USER_FLOW;
+	case IAVF_FDIR_FLOW_NON_IP_L2:
+		return ETHER_FLOW;
 	default:
 		/* 0 is undefined ethtool flow */
 		return 0;
@@ -900,6 +902,8 @@ static enum iavf_fdir_flow_type iavf_ethtool_flow_to_fltr(int eth)
 		return IAVF_FDIR_FLOW_IPV6_ESP;
 	case IPV6_USER_FLOW:
 		return IAVF_FDIR_FLOW_IPV6_OTHER;
+	case ETHER_FLOW:
+		return IAVF_FDIR_FLOW_NON_IP_L2;
 	default:
 		return IAVF_FDIR_FLOW_NONE;
 	}
@@ -1025,6 +1029,10 @@ iavf_get_ethtool_fdir_entry(struct iavf_adapter *adapter,
 		fsp->m_u.usr_ip6_spec.tclass = rule->ip_mask.tclass;
 		fsp->m_u.usr_ip6_spec.l4_proto = rule->ip_mask.proto;
 		break;
+	case ETHER_FLOW:
+		fsp->h_u.ether_spec.h_proto = rule->eth_data.etype;
+		fsp->m_u.ether_spec.h_proto = rule->eth_mask.etype;
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -1197,6 +1205,10 @@ iavf_add_fdir_fltr_info(struct iavf_adapter *adapter, struct ethtool_rx_flow_spe
 		fltr->ip_mask.tclass = fsp->m_u.usr_ip6_spec.tclass;
 		fltr->ip_mask.proto = fsp->m_u.usr_ip6_spec.l4_proto;
 		break;
+	case ETHER_FLOW:
+		fltr->eth_data.etype = fsp->h_u.ether_spec.h_proto;
+		fltr->eth_mask.etype = fsp->m_u.ether_spec.h_proto;
+		break;
 	default:
 		/* not doing un-parsed flow types */
 		return -EINVAL;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_fdir.c b/drivers/net/ethernet/intel/iavf/iavf_fdir.c
index f84f2ab036d5..e1e1af136765 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_fdir.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_fdir.c
@@ -277,9 +277,19 @@ iavf_fill_fdir_eth_hdr(struct iavf_fdir_fltr *fltr,
 		       struct virtchnl_proto_hdrs *proto_hdrs)
 {
 	struct virtchnl_proto_hdr *hdr = &proto_hdrs->proto_hdr[proto_hdrs->count++];
+	struct ethhdr *ehdr = (struct ethhdr *)hdr->buffer;
 
 	VIRTCHNL_SET_PROTO_HDR_TYPE(hdr, ETH);
 
+	if (fltr->eth_mask.etype == htons(U16_MAX)) {
+		if (fltr->eth_data.etype == htons(ETH_P_IP) ||
+		    fltr->eth_data.etype == htons(ETH_P_IPV6))
+			return -EOPNOTSUPP;
+
+		ehdr->h_proto = fltr->eth_data.etype;
+		VIRTCHNL_ADD_PROTO_HDR_FIELD_BIT(hdr, ETH, ETHERTYPE);
+	}
+
 	return 0;
 }
 
@@ -351,6 +361,8 @@ int iavf_fill_fdir_add_msg(struct iavf_adapter *adapter, struct iavf_fdir_fltr *
 		err = iavf_fill_fdir_ip6_hdr(fltr, proto_hdrs) |
 		      iavf_fill_fdir_l4_hdr(fltr, proto_hdrs);
 		break;
+	case IAVF_FDIR_FLOW_NON_IP_L2:
+		break;
 	default:
 		err = -EINVAL;
 		break;
@@ -392,6 +404,8 @@ static const char *iavf_fdir_flow_proto_name(enum iavf_fdir_flow_type flow_type)
 	case IAVF_FDIR_FLOW_IPV4_OTHER:
 	case IAVF_FDIR_FLOW_IPV6_OTHER:
 		return "Other";
+	case IAVF_FDIR_FLOW_NON_IP_L2:
+		return "Ethernet";
 	default:
 		return NULL;
 	}
@@ -468,6 +482,11 @@ void iavf_print_fdir_fltr(struct iavf_adapter *adapter, struct iavf_fdir_fltr *f
 			 fltr->ip_data.proto,
 			 ntohl(fltr->ip_data.l4_header));
 		break;
+	case IAVF_FDIR_FLOW_NON_IP_L2:
+		dev_info(&adapter->pdev->dev, "Rule ID: %u eth_type: 0x%x\n",
+			 fltr->loc,
+			 ntohs(fltr->eth_data.etype));
+		break;
 	default:
 		break;
 	}
@@ -489,7 +508,9 @@ bool iavf_fdir_is_dup_fltr(struct iavf_adapter *adapter, struct iavf_fdir_fltr *
 		if (tmp->flow_type != fltr->flow_type)
 			continue;
 
-		if (!memcmp(&tmp->ip_data, &fltr->ip_data,
+		if (!memcmp(&tmp->eth_data, &fltr->eth_data,
+			    sizeof(fltr->eth_data)) &&
+		    !memcmp(&tmp->ip_data, &fltr->ip_data,
 			    sizeof(fltr->ip_data))) {
 			ret = true;
 			break;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_fdir.h b/drivers/net/ethernet/intel/iavf/iavf_fdir.h
index f5b222b40952..ad75b89cb207 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_fdir.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_fdir.h
@@ -30,6 +30,7 @@ enum iavf_fdir_flow_type {
 	IAVF_FDIR_FLOW_IPV6_AH,
 	IAVF_FDIR_FLOW_IPV6_ESP,
 	IAVF_FDIR_FLOW_IPV6_OTHER,
+	IAVF_FDIR_FLOW_NON_IP_L2,
 	/* MAX - this must be last and add anything new just above it */
 	IAVF_FDIR_FLOW_PTYPE_MAX,
 };
@@ -44,6 +45,10 @@ struct iavf_ipv6_addrs {
 	struct in6_addr dst_ip;
 };
 
+struct iavf_fdir_eth {
+	__be16 etype;
+};
+
 struct iavf_fdir_ip {
 	union {
 		struct iavf_ipv4_addrs v4_addrs;
@@ -66,6 +71,9 @@ struct iavf_fdir_fltr {
 
 	enum iavf_fdir_flow_type flow_type;
 
+	struct iavf_fdir_eth eth_data;
+	struct iavf_fdir_eth eth_mask;
+
 	struct iavf_fdir_ip ip_data;
 	struct iavf_fdir_ip ip_mask;
 
-- 
2.26.2

