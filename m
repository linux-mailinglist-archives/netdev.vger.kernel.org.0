Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1565331953A
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 22:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhBKVhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 16:37:15 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:58566 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229936AbhBKVhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 16:37:05 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1613079400; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=0fi/SREHhK8B8/7esa/dEqv88WxqMKR906kSR1woiPM=; b=Nq3py2Yj4PfGpna2xrYmzP0jM6dGiSPINdDHGezQHAULfXRwdYEHjkaJR+FtzdqFsgYtcAoK
 mm3Q0f59+lKq/OV7+wodPdgQLrqEQSiv6YMMhjISXvnC9aeOToUgHqrSiNmRtIsdHyCzv6I6
 LcnGgXMpdF44pDtkRPuiw5oqtFw=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 6025a34c830f898bacd2d643 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 11 Feb 2021 21:36:12
 GMT
Sender: sharathv=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9D2FBC433CA; Thu, 11 Feb 2021 21:36:12 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from svurukal-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sharathv)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DC1B4C433C6;
        Thu, 11 Feb 2021 21:36:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DC1B4C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sharathv@codeaurora.org
From:   Sharath Chandra Vurukala <sharathv@codeaurora.org>
To:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sharath Chandra Vurukala <sharathv@codeaurora.org>
Subject: [PATCH 3/3] net:ethernet:rmnet: Add support for Mapv5 Uplink packet
Date:   Fri, 12 Feb 2021 03:05:24 +0530
Message-Id: <1613079324-20166-4-git-send-email-sharathv@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1613079324-20166-1-git-send-email-sharathv@codeaurora.org>
References: <1613079324-20166-1-git-send-email-sharathv@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding Support for Mapv5 uplink packet.
Based on the configuration Request HW for csum offload
by setting the csum_valid_required of Mapv5 packet.

Signed-off-by: Sharath Chandra Vurukala <sharathv@codeaurora.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h |  3 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   | 17 +++-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h    |  4 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   | 92 ++++++++++++++++++++--
 include/uapi/linux/if_link.h                       |  1 +
 5 files changed, 105 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
index d4d61471..8e64ca9 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* Copyright (c) 2013-2014, 2016-2018 The Linux Foundation.
+/* Copyright (c) 2013-2014, 2016-2018, 2021 The Linux Foundation.
  * All rights reserved.
  *
  * RMNET Data configuration engine
@@ -57,6 +57,7 @@ struct rmnet_priv_stats {
 	u64 csum_fragmented_pkt;
 	u64 csum_skipped;
 	u64 csum_sw;
+	u64 csum_hw;
 };
 
 struct rmnet_priv {
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index 70ad6a7..870be09 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -131,8 +131,9 @@ static int rmnet_map_egress_handler(struct sk_buff *skb,
 				    struct rmnet_port *port, u8 mux_id,
 				    struct net_device *orig_dev)
 {
-	int required_headroom, additional_header_len;
+	int required_headroom, additional_header_len, csum_type;
 	struct rmnet_map_header *map_header;
+	csum_type = 0;
 
 	additional_header_len = 0;
 	required_headroom = sizeof(struct rmnet_map_header);
@@ -140,17 +141,25 @@ static int rmnet_map_egress_handler(struct sk_buff *skb,
 	if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV4) {
 		additional_header_len = sizeof(struct rmnet_map_ul_csum_header);
 		required_headroom += additional_header_len;
+		csum_type = RMNET_FLAGS_EGRESS_MAP_CKSUMV4;
+	} else if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV5) {
+		additional_header_len = sizeof(struct rmnet_map_v5_csum_header);
+		csum_type = RMNET_FLAGS_EGRESS_MAP_CKSUMV5;
 	}
 
+	required_headroom += additional_header_len;
+
 	if (skb_headroom(skb) < required_headroom) {
 		if (pskb_expand_head(skb, required_headroom, 0, GFP_ATOMIC))
 			return -ENOMEM;
 	}
 
-	if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV4)
-		rmnet_map_checksum_uplink_packet(skb, orig_dev);
+	if (csum_type) {
+		rmnet_map_checksum_uplink_packet(skb, port, orig_dev,
+						 csum_type);
+	}
 
-	map_header = rmnet_map_add_map_header(skb, additional_header_len, 0);
+	map_header = rmnet_map_add_map_header(skb, additional_header_len, port, 0);
 	if (!map_header)
 		return -ENOMEM;
 
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
index 55d293c..9b2aef0 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
@@ -70,7 +70,9 @@ struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
 void rmnet_map_command(struct sk_buff *skb, struct rmnet_port *port);
 int rmnet_map_checksum_downlink_packet(struct sk_buff *skb, u16 len);
 void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
-				      struct net_device *orig_dev);
+				      struct rmnet_port *port,
+				      struct net_device *orig_dev,
+				      int csum_type);
 int rmnet_map_process_next_hdr_packet(struct sk_buff *skb, u16 len);
 
 static u8 rmnet_map_get_next_hdr_type(struct sk_buff *skb)
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 3d7e03f..600b9a2 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -263,12 +263,68 @@ rmnet_map_ipv6_ul_csum_header(void *ip6hdr,
 }
 #endif
 
+void rmnet_map_v5_checksum_uplink_packet(struct sk_buff *skb,
+					 struct rmnet_port *port,
+					 struct net_device *orig_dev)
+{
+	struct rmnet_priv *priv = netdev_priv(orig_dev);
+	struct rmnet_map_v5_csum_header *ul_header;
+
+	if (!(port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV5))
+		return;
+
+	ul_header = (struct rmnet_map_v5_csum_header *)
+		    skb_push(skb, sizeof(*ul_header));
+	memset(ul_header, 0, sizeof(*ul_header));
+	ul_header->header_type = RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD;
+
+	if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		void *iph = (char *)ul_header + sizeof(*ul_header);
+		__sum16 *check;
+		void *trans;
+		u8 proto;
+
+		if (skb->protocol == htons(ETH_P_IP)) {
+			u16 ip_len = ((struct iphdr *)iph)->ihl * 4;
+
+			proto = ((struct iphdr *)iph)->protocol;
+			trans = iph + ip_len;
+		}
+#if IS_ENABLED(CONFIG_IPV6)
+		else if (skb->protocol == htons(ETH_P_IPV6)) {
+			u16 ip_len = sizeof(struct ipv6hdr);
+
+			proto = ((struct ipv6hdr *)iph)->nexthdr;
+			trans = iph + ip_len;
+		}
+#endif /* CONFIG_IPV6 */
+		else {
+			priv->stats.csum_err_invalid_ip_version++;
+			goto sw_csum;
+		}
+
+		check = rmnet_map_get_csum_field(proto, trans);
+		if (check) {
+			skb->ip_summed = CHECKSUM_NONE;
+			/* Ask for checksum offloading */
+			ul_header->csum_valid_required = 1;
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
@@ -279,6 +335,11 @@ struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
 			skb_push(skb, sizeof(struct rmnet_map_header));
 	memset(map_header, 0, sizeof(struct rmnet_map_header));
 
+	/* Set next_hdr bit for csum offload packets */
+	if (port->data_format & RMNET_FLAGS_EGRESS_MAP_CKSUMV5) {
+		map_header->next_hdr = 1;
+	}
+
 	if (pad == RMNET_MAP_NO_PAD_BYTES) {
 		map_header->pkt_len = htons(map_datalen);
 		return map_header;
@@ -395,11 +456,8 @@ int rmnet_map_checksum_downlink_packet(struct sk_buff *skb, u16 len)
 	return 0;
 }
 
-/* Generates UL checksum meta info header for IPv4 and IPv6 over TCP and UDP
- * packets that are supported for UL checksum offload.
- */
-void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
-				      struct net_device *orig_dev)
+void rmnet_map_v4_checksum_uplink_packet(struct sk_buff *skb,
+					 struct net_device *orig_dev)
 {
 	struct rmnet_priv *priv = netdev_priv(orig_dev);
 	struct rmnet_map_ul_csum_header *ul_header;
@@ -418,10 +476,12 @@ void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
 
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
@@ -441,6 +501,26 @@ void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
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
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 838bd29..319865f 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1234,6 +1234,7 @@ enum {
 #define RMNET_FLAGS_INGRESS_MAP_CKSUMV4           (1U << 2)
 #define RMNET_FLAGS_EGRESS_MAP_CKSUMV4            (1U << 3)
 #define RMNET_FLAGS_INGRESS_MAP_CKSUMV5           (1U << 4)
+#define RMNET_FLAGS_EGRESS_MAP_CKSUMV5            (1U << 5)
 
 enum {
 	IFLA_RMNET_UNSPEC,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

