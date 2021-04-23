Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B2E3691E2
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 14:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242373AbhDWMU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 08:20:27 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:34365 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242355AbhDWMU0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 08:20:26 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619180390; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=1IumT8SFsHJ7skaObCVXrUyV6nWNcwmPaOoIikuDoLQ=; b=DbN4o96iZx8r4FmNGuIhl0qoF0yVIEK7u/YTHO4sR14M3TvUrLDyeDKqaR1UmyxxafjtWeY3
 IfuqUHxTg4YAwGOkgtv8sJdyG6nxCJMyqbrCZoKl3qBnC6Cl07o1/CCrBlilRLDRpXeXeuSS
 z7xdrn6EptZyRE5LukNPSVPN21I=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 6082bb52a817abd39a2d78ef (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 23 Apr 2021 12:19:30
 GMT
Sender: sharathv=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A0FCDC43144; Fri, 23 Apr 2021 12:19:29 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from svurukal-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sharathv)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 234ADC43217;
        Fri, 23 Apr 2021 12:19:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 234ADC43217
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sharathv@codeaurora.org
From:   Sharath Chandra Vurukala <sharathv@codeaurora.org>
To:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Sharath Chandra Vurukala <sharathv@codeaurora.org>
Subject: [PATCH net-next v5 2/3] net: ethernet: rmnet: Support for ingress MAPv5 checksum offload
Date:   Fri, 23 Apr 2021 17:49:02 +0530
Message-Id: <1619180343-3943-3-git-send-email-sharathv@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1619180343-3943-1-git-send-email-sharathv@codeaurora.org>
References: <stranche@codeaurora.org linux-doc@vger.kernel.org corbet@lwn.net>
 <1619180343-3943-1-git-send-email-sharathv@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support for processing of MAPv5 downlink packets.
It involves parsing the Mapv5 packet and checking the csum header
to know whether the hardware has validated the checksum and is
valid or not.

Based on the checksum valid bit the corresponding stats are
incremented and skb->ip_summed is marked either CHECKSUM_UNNECESSARY
or left as CHEKSUM_NONE to let network stack revalidate the checksum
and update the respective snmp stats.

Current MAPV1 header has been modified, the reserved field in the
Mapv1 header is now used for next header indication.

Acked-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Acked-by: Alex Elder <elder@linaro.org>
Signed-off-by: Sharath Chandra Vurukala <sharathv@codeaurora.org>
---
 .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   | 17 ++++---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h    |  3 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   | 58 +++++++++++++++++++++-
 include/linux/if_rmnet.h                           | 27 +++++++++-
 include/uapi/linux/if_link.h                       |  1 +
 5 files changed, 97 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index 0be5ac7..706a225 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Copyright (c) 2013-2018, The Linux Foundation. All rights reserved.
+/* Copyright (c) 2013-2018, 2021, The Linux Foundation. All rights reserved.
  *
  * RMNET Data ingress/egress handler
  */
@@ -82,11 +82,16 @@ __rmnet_map_ingress_handler(struct sk_buff *skb,
 
 	skb->dev = ep->egress_dev;
 
-	/* Subtract MAP header */
-	skb_pull(skb, sizeof(struct rmnet_map_header));
-	rmnet_set_skb_proto(skb);
-
-	if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4) {
+	if ((port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV5) &&
+	    (map_header->flags & MAP_NEXT_HEADER_FLAG)) {
+		if (rmnet_map_process_next_hdr_packet(skb, len))
+			goto free_skb;
+		skb_pull(skb, sizeof(*map_header));
+		rmnet_set_skb_proto(skb);
+	} else if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4) {
+		/* Subtract MAP header */
+		skb_pull(skb, sizeof(*map_header));
+		rmnet_set_skb_proto(skb);
 		if (!rmnet_map_checksum_downlink_packet(skb, len + pad))
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 	}
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
index 2aea153..1a399bf 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* Copyright (c) 2013-2018, The Linux Foundation. All rights reserved.
+/* Copyright (c) 2013-2018, 2021, The Linux Foundation. All rights reserved.
  */
 
 #ifndef _RMNET_MAP_H_
@@ -48,5 +48,6 @@ void rmnet_map_command(struct sk_buff *skb, struct rmnet_port *port);
 int rmnet_map_checksum_downlink_packet(struct sk_buff *skb, u16 len);
 void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
 				      struct net_device *orig_dev);
+int rmnet_map_process_next_hdr_packet(struct sk_buff *skb, u16 len);
 
 #endif /* _RMNET_MAP_H_ */
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 0ac2ff8..43813cf 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Copyright (c) 2013-2018, The Linux Foundation. All rights reserved.
+/* Copyright (c) 2013-2018, 2021, The Linux Foundation. All rights reserved.
  *
  * RMNET Data MAP protocol
  */
@@ -8,6 +8,7 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <net/ip6_checksum.h>
+#include <linux/bitfield.h>
 #include "rmnet_config.h"
 #include "rmnet_map.h"
 #include "rmnet_private.h"
@@ -300,8 +301,11 @@ struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
 struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
 				      struct rmnet_port *port)
 {
+	struct rmnet_map_v5_csum_header *next_hdr = NULL;
+	unsigned char *data = skb->data;
 	struct rmnet_map_header *maph;
 	struct sk_buff *skbn;
+	u8 nexthdr_type;
 	u32 packet_len;
 
 	if (skb->len == 0)
@@ -312,6 +316,17 @@ struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
 
 	if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4)
 		packet_len += sizeof(struct rmnet_map_dl_csum_trailer);
+	else if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV5) {
+		if (!(maph->flags & MAP_CMD_FLAG)) {
+			packet_len += sizeof(struct rmnet_map_v5_csum_header);
+			if (maph->flags & MAP_NEXT_HEADER_FLAG)
+				next_hdr = (struct rmnet_map_v5_csum_header *)
+						(data + sizeof(*maph));
+			else
+				/* Mapv5 data pkt without csum hdr is invalid */
+				return NULL;
+		}
+	}
 
 	if (((int)skb->len - (int)packet_len) < 0)
 		return NULL;
@@ -320,6 +335,13 @@ struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
 	if (!maph->pkt_len)
 		return NULL;
 
+	if (next_hdr) {
+		nexthdr_type = u8_get_bits(next_hdr->header_info,
+					   MAPV5_HDRINFO_HDR_TYPE_FMASK);
+		if (nexthdr_type != RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD)
+			return NULL;
+	}
+
 	skbn = alloc_skb(packet_len + RMNET_MAP_DEAGGR_SPACING, GFP_ATOMIC);
 	if (!skbn)
 		return NULL;
@@ -414,3 +436,37 @@ void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
 
 	priv->stats.csum_sw++;
 }
+
+/* Process a MAPv5 packet header */
+int rmnet_map_process_next_hdr_packet(struct sk_buff *skb,
+				      u16 len)
+{
+	struct rmnet_priv *priv = netdev_priv(skb->dev);
+	struct rmnet_map_v5_csum_header *next_hdr;
+	u8 nexthdr_type;
+	int rc = 0;
+
+	next_hdr = (struct rmnet_map_v5_csum_header *)(skb->data +
+			sizeof(struct rmnet_map_header));
+
+	nexthdr_type = u8_get_bits(next_hdr->header_info,
+				   MAPV5_HDRINFO_HDR_TYPE_FMASK);
+
+	if (nexthdr_type == RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD) {
+		if (unlikely(!(skb->dev->features & NETIF_F_RXCSUM))) {
+			priv->stats.csum_sw++;
+		} else if (next_hdr->csum_info & MAPV5_CSUMINFO_VALID_FLAG) {
+			priv->stats.csum_ok++;
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
+		} else {
+			priv->stats.csum_valid_unset++;
+		}
+
+		/* Pull csum v5 header */
+		skb_pull(skb, sizeof(struct rmnet_map_v5_csum_header));
+	} else {
+		return -EINVAL;
+	}
+
+	return rc;
+}
diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
index 4efb537..f82e37e 100644
--- a/include/linux/if_rmnet.h
+++ b/include/linux/if_rmnet.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only
- * Copyright (c) 2013-2019, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2013-2019, 2021 The Linux Foundation. All rights reserved.
  */
 
 #ifndef _LINUX_IF_RMNET_H_
@@ -14,8 +14,10 @@ struct rmnet_map_header {
 /* rmnet_map_header flags field:
  *  PAD_LEN:	number of pad bytes following packet data
  *  CMD:	1 = packet contains a MAP command; 0 = packet contains data
+ *  NEXT_HEADER	1 = packet contains V5 CSUM header 0 = no V5 CSUM header
  */
 #define MAP_PAD_LEN_MASK		GENMASK(5, 0)
+#define MAP_NEXT_HEADER_FLAG		BIT(6)
 #define MAP_CMD_FLAG			BIT(7)
 
 struct rmnet_map_dl_csum_trailer {
@@ -45,4 +47,27 @@ struct rmnet_map_ul_csum_header {
 #define MAP_CSUM_UL_UDP_FLAG		BIT(14)
 #define MAP_CSUM_UL_ENABLED_FLAG	BIT(15)
 
+/* MAP CSUM headers */
+struct rmnet_map_v5_csum_header {
+	u8 header_info;
+	u8 csum_info;
+	__be16 reserved;
+} __aligned(1);
+
+/* v5 header_info field
+ * NEXT_HEADER:  Represents whether there is any other header
+ * HEADER TYPE: represents the type of this header
+ *
+ * csum_info field
+ * CSUM_VALID_OR_REQ:
+ * 1 = for UL, checksum computation is requested.
+ * 1 = for DL, validated the checksum and has found it valid
+ */
+
+#define MAPV5_HDRINFO_NXT_HDR_FLAG	BIT(0)
+#define MAPV5_HDRINFO_HDR_TYPE_SHIFT	1
+#define MAPV5_HDRINFO_HDR_TYPE_FMASK	GENMASK(7, MAPV5_HDRINFO_HDR_TYPE_SHIFT)
+#define MAPV5_CSUMINFO_VALID_FLAG	BIT(7)
+
+#define RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD 2
 #endif /* !(_LINUX_IF_RMNET_H_) */
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 91c8dda..21529b3 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1235,6 +1235,7 @@ enum {
 #define RMNET_FLAGS_INGRESS_MAP_COMMANDS          (1U << 1)
 #define RMNET_FLAGS_INGRESS_MAP_CKSUMV4           (1U << 2)
 #define RMNET_FLAGS_EGRESS_MAP_CKSUMV4            (1U << 3)
+#define RMNET_FLAGS_INGRESS_MAP_CKSUMV5           (1U << 4)
 
 enum {
 	IFLA_RMNET_UNSPEC,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

