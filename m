Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCBD397AB6
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 21:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234799AbhFATbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 15:31:17 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:28545 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234769AbhFATbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 15:31:16 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622575774; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=atdWdNFRMalVjgDVJFXOOj8zZKGIMgbzgKNhqxH6Z2M=; b=NnYLqAbfOS82edyPR/YVGUs8QFQAg+93W19R+eS4uT1FQD8usROPt10nGsSn6qSLJoiOHGN3
 xMLPBakCYq73+dq/QvWYakZyiFl/EB+jStRtuWWH9RSWsy8/WJ4TGbqzFKxLbaH0w4mfB6rF
 KrMftHYh2GSISHi25Ao55F6orLQ=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 60b68a9b8491191eb3c2617c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 01 Jun 2021 19:29:31
 GMT
Sender: sharathv=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4BE33C43146; Tue,  1 Jun 2021 19:29:31 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from svurukal-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sharathv)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 46306C43217;
        Tue,  1 Jun 2021 19:29:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 46306C43217
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sharathv@codeaurora.org
From:   Sharath Chandra Vurukala <sharathv@codeaurora.org>
To:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org
Cc:     Sharath Chandra Vurukala <sharathv@codeaurora.org>
Subject: [PATCH net-next v8 3/3] net: ethernet: rmnet: Add support for MAPv5 egress packets
Date:   Wed,  2 Jun 2021 00:58:36 +0530
Message-Id: <1622575716-13415-4-git-send-email-sharathv@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1622575716-13415-1-git-send-email-sharathv@codeaurora.org>
References: <1622575716-13415-1-git-send-email-sharathv@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support for MAPv5 egress packets.

This involves adding the MAPv5 header and setting the csum_valid_required
in the checksum header to request HW compute the checksum.

Corresponding stats are incremented based on whether the checksum is
computed in software or HW.

New stat has been added which represents the count of packets whose
checksum is calculated by the HW.

Signed-off-by: Sharath Chandra Vurukala <sharathv@codeaurora.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h |  4 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   | 23 +++---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h    |  8 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   | 92 ++++++++++++++++++++--
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c    |  1 +
 include/uapi/linux/if_link.h                       |  1 +
 6 files changed, 111 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
index 8d8d469..8e64ca9 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
@@ -1,5 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* Copyright (c) 2013-2014, 2016-2018 The Linux Foundation. All rights reserved.
+/* Copyright (c) 2013-2014, 2016-2018, 2021 The Linux Foundation.
+ * All rights reserved.
  *
  * RMNET Data configuration engine
  */
@@ -56,6 +57,7 @@ struct rmnet_priv_stats {
 	u64 csum_fragmented_pkt;
 	u64 csum_skipped;
 	u64 csum_sw;
+	u64 csum_hw;
 };
 
 struct rmnet_priv {
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index 706a225..2504d03 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -133,7 +133,7 @@ static int rmnet_map_egress_handler(struct sk_buff *skb,
 				    struct rmnet_port *port, u8 mux_id,
 				    struct net_device *orig_dev)
 {
-	int required_headroom, additional_header_len;
+	int required_headroom, additional_header_len, csum_type = 0;
 	struct rmnet_map_header *map_header;
 
 	additional_header_len = 0;
@@ -141,18 +141,23 @@ static int rmnet_map_egress_handler(struct sk_buff *skb,
 
 	if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV4) {
 		additional_header_len = sizeof(struct rmnet_map_ul_csum_header);
-		required_headroom += additional_header_len;
+		csum_type = RMNET_FLAGS_EGRESS_MAP_CKSUMV4;
+	} else if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV5) {
+		additional_header_len = sizeof(struct rmnet_map_v5_csum_header);
+		csum_type = RMNET_FLAGS_EGRESS_MAP_CKSUMV5;
 	}
 
-	if (skb_headroom(skb) < required_headroom) {
-		if (pskb_expand_head(skb, required_headroom, 0, GFP_ATOMIC))
-			return -ENOMEM;
-	}
+	required_headroom += additional_header_len;
+
+	if (skb_cow_head(skb, required_headroom) < 0)
+		return -ENOMEM;
 
-	if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV4)
-		rmnet_map_checksum_uplink_packet(skb, orig_dev);
+	if (csum_type)
+		rmnet_map_checksum_uplink_packet(skb, port, orig_dev,
+						 csum_type);
 
-	map_header = rmnet_map_add_map_header(skb, additional_header_len, 0);
+	map_header = rmnet_map_add_map_header(skb, additional_header_len,
+					      port, 0);
 	if (!map_header)
 		return -ENOMEM;
 
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
index 1a399bf..e5a0b38 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
@@ -43,11 +43,15 @@ enum rmnet_map_commands {
 struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
 				      struct rmnet_port *port);
 struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
-						  int hdrlen, int pad);
+						  int hdrlen,
+						  struct rmnet_port *port,
+						  int pad);
 void rmnet_map_command(struct sk_buff *skb, struct rmnet_port *port);
 int rmnet_map_checksum_downlink_packet(struct sk_buff *skb, u16 len);
 void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
-				      struct net_device *orig_dev);
+				      struct rmnet_port *port,
+				      struct net_device *orig_dev,
+				      int csum_type);
 int rmnet_map_process_next_hdr_packet(struct sk_buff *skb, u16 len);
 
 #endif /* _RMNET_MAP_H_ */
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 5c018bd..6492ec5 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -251,12 +251,69 @@ rmnet_map_ipv6_ul_csum_header(void *ip6hdr,
 }
 #endif
 
+static void rmnet_map_v5_checksum_uplink_packet(struct sk_buff *skb,
+						struct rmnet_port *port,
+						struct net_device *orig_dev)
+{
+	struct rmnet_priv *priv = netdev_priv(orig_dev);
+	struct rmnet_map_v5_csum_header *ul_header;
+
+	ul_header = skb_push(skb, sizeof(*ul_header));
+	memset(ul_header, 0, sizeof(*ul_header));
+	ul_header->header_info = u8_encode_bits(RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD,
+						MAPV5_HDRINFO_HDR_TYPE_FMASK);
+
+	if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		void *iph = ip_hdr(skb);
+		__sum16 *check;
+		void *trans;
+		u8 proto;
+
+		if (skb->protocol != htons(ETH_P_IP) &&
+		    skb->protocol != htons(ETH_P_IPV6)) {
+			priv->stats.csum_err_invalid_ip_version++;
+			goto sw_csum;
+		}
+
+		if (skb->protocol == htons(ETH_P_IP)) {
+			u16 ip_len = ((struct iphdr *)iph)->ihl * 4;
+
+			proto = ((struct iphdr *)iph)->protocol;
+			trans = iph + ip_len;
+		} else if (skb->protocol == htons(ETH_P_IPV6)) {
+#if IS_ENABLED(CONFIG_IPV6)
+			u16 ip_len = sizeof(struct ipv6hdr);
+
+			proto = ((struct ipv6hdr *)iph)->nexthdr;
+			trans = iph + ip_len;
+#else
+			priv->stats.csum_err_invalid_ip_version++;
+			goto sw_csum;
+#endif /* CONFIG_IPV6 */
+		}
+
+		check = rmnet_map_get_csum_field(proto, trans);
+		if (check) {
+			skb->ip_summed = CHECKSUM_NONE;
+			/* Ask for checksum offloading */
+			ul_header->csum_info |= MAPV5_CSUMINFO_VALID_FLAG;
+			priv->stats.csum_hw++;
+			return;
+		}
+	}
+
+sw_csum:
+	priv->stats.csum_sw++;
+}
+
 /* Adds MAP header to front of skb->data
  * Padding is calculated and set appropriately in MAP header. Mux ID is
  * initialized to 0.
  */
 struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
-						  int hdrlen, int pad)
+						  int hdrlen,
+						  struct rmnet_port *port,
+						  int pad)
 {
 	struct rmnet_map_header *map_header;
 	u32 padding, map_datalen;
@@ -267,6 +324,10 @@ struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
 			skb_push(skb, sizeof(struct rmnet_map_header));
 	memset(map_header, 0, sizeof(struct rmnet_map_header));
 
+	/* Set next_hdr bit for csum offload packets */
+	if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV5)
+		map_header->flags |= MAP_NEXT_HEADER_FLAG;
+
 	if (pad == RMNET_MAP_NO_PAD_BYTES) {
 		map_header->pkt_len = htons(map_datalen);
 		return map_header;
@@ -393,11 +454,8 @@ int rmnet_map_checksum_downlink_packet(struct sk_buff *skb, u16 len)
 	return 0;
 }
 
-/* Generates UL checksum meta info header for IPv4 and IPv6 over TCP and UDP
- * packets that are supported for UL checksum offload.
- */
-void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
-				      struct net_device *orig_dev)
+static void rmnet_map_v4_checksum_uplink_packet(struct sk_buff *skb,
+						struct net_device *orig_dev)
 {
 	struct rmnet_priv *priv = netdev_priv(orig_dev);
 	struct rmnet_map_ul_csum_header *ul_header;
@@ -416,10 +474,12 @@ void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
 
 		if (skb->protocol == htons(ETH_P_IP)) {
 			rmnet_map_ipv4_ul_csum_header(iphdr, ul_header, skb);
+			priv->stats.csum_hw++;
 			return;
 		} else if (skb->protocol == htons(ETH_P_IPV6)) {
 #if IS_ENABLED(CONFIG_IPV6)
 			rmnet_map_ipv6_ul_csum_header(iphdr, ul_header, skb);
+			priv->stats.csum_hw++;
 			return;
 #else
 			priv->stats.csum_err_invalid_ip_version++;
@@ -436,6 +496,26 @@ void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
 	priv->stats.csum_sw++;
 }
 
+/* Generates UL checksum meta info header for IPv4 and IPv6 over TCP and UDP
+ * packets that are supported for UL checksum offload.
+ */
+void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
+				      struct rmnet_port *port,
+				      struct net_device *orig_dev,
+				      int csum_type)
+{
+	switch (csum_type) {
+	case RMNET_FLAGS_EGRESS_MAP_CKSUMV4:
+		rmnet_map_v4_checksum_uplink_packet(skb, orig_dev);
+		break;
+	case RMNET_FLAGS_EGRESS_MAP_CKSUMV5:
+		rmnet_map_v5_checksum_uplink_packet(skb, port, orig_dev);
+		break;
+	default:
+		break;
+	}
+}
+
 /* Process a MAPv5 packet header */
 int rmnet_map_process_next_hdr_packet(struct sk_buff *skb,
 				      u16 len)
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index 41fbd2c..fe13017 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -174,6 +174,7 @@ static const char rmnet_gstrings_stats[][ETH_GSTRING_LEN] = {
 	"Checksum skipped on ip fragment",
 	"Checksum skipped",
 	"Checksum computed in software",
+	"Checksum computed in hardware",
 };
 
 static void rmnet_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 21529b3..1691f3a 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1236,6 +1236,7 @@ enum {
 #define RMNET_FLAGS_INGRESS_MAP_CKSUMV4           (1U << 2)
 #define RMNET_FLAGS_EGRESS_MAP_CKSUMV4            (1U << 3)
 #define RMNET_FLAGS_INGRESS_MAP_CKSUMV5           (1U << 4)
+#define RMNET_FLAGS_EGRESS_MAP_CKSUMV5            (1U << 5)
 
 enum {
 	IFLA_RMNET_UNSPEC,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

