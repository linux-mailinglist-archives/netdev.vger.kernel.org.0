Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E43319538
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 22:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhBKVhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 16:37:03 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:10041 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229674AbhBKVhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 16:37:00 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1613079394; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=cNPiRPu5EgIyJXGlACMBR68SNs+mivOtBsvTvTJtAi8=; b=rxW6LEm4tUPOjbXzBsFHZKLpxVxir0/hZ/tEyJA/zyGhXU2lZOkCZ+I0xO3MgEZhuJfxgng7
 WeEfEb0TNuqCcOGJQxXTZA1b0+Ix3fpghcXg3zQjIQE8RYtfuO6jVatHvPv8KXp2WXMiaPdw
 C2ZNjk+bNCHpA8AyUReya8bLkVg=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 6025a348e4842e9128704d56 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 11 Feb 2021 21:36:08
 GMT
Sender: sharathv=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 327CBC43462; Thu, 11 Feb 2021 21:36:08 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from svurukal-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sharathv)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 61B7FC433C6;
        Thu, 11 Feb 2021 21:36:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 61B7FC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sharathv@codeaurora.org
From:   Sharath Chandra Vurukala <sharathv@codeaurora.org>
To:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sharath Chandra Vurukala <sharathv@codeaurora.org>
Subject: [PATCH 2/3] net:ethernet:rmnet:Support for downlink MAPv5 csum offload
Date:   Fri, 12 Feb 2021 03:05:23 +0530
Message-Id: <1613079324-20166-3-git-send-email-sharathv@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1613079324-20166-1-git-send-email-sharathv@codeaurora.org>
References: <1613079324-20166-1-git-send-email-sharathv@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support for processing of Mapv5 downlink packets.
It involves parsing the Mapv5 packet and checking the csum header
to know whether the hardware has validated the checksum and is
valid or not.

Based on the checksum valid bit the corresponding stats are
incremented and skb->ip_summed is marked either CHECKSUM_UNNECESSARY
or left as CHEKSUM_NONE to let network stack revalidated the checksum
and update the respective snmp stats.

Signed-off-by: Sharath Chandra Vurukala <sharathv@codeaurora.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h |  3 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   | 19 ++++++----
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h    | 32 +++++++++++++++-
 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   | 44 +++++++++++++++++++++-
 include/linux/if_rmnet.h                           | 17 +++++++--
 include/uapi/linux/if_link.h                       |  1 +
 6 files changed, 102 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
index 8d8d469..d4d61471 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
@@ -1,5 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* Copyright (c) 2013-2014, 2016-2018 The Linux Foundation. All rights reserved.
+/* Copyright (c) 2013-2014, 2016-2018 The Linux Foundation.
+ * All rights reserved.
  *
  * RMNET Data configuration engine
  */
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index 3d7d3ab..70ad6a7 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Copyright (c) 2013-2018, The Linux Foundation. All rights reserved.
+/* Copyright (c) 2013-2018, 2021, The Linux Foundation. All rights reserved.
  *
  * RMNET Data ingress/egress handler
  */
@@ -57,8 +57,8 @@ __rmnet_map_ingress_handler(struct sk_buff *skb,
 			    struct rmnet_port *port)
 {
 	struct rmnet_endpoint *ep;
+	u8 mux_id, next_hdr;
 	u16 len, pad;
-	u8 mux_id;
 
 	if (RMNET_MAP_GET_CD_BIT(skb)) {
 		if (port->data_format & RMNET_FLAGS_INGRESS_MAP_COMMANDS)
@@ -70,6 +70,7 @@ __rmnet_map_ingress_handler(struct sk_buff *skb,
 	mux_id = RMNET_MAP_GET_MUX_ID(skb);
 	pad = RMNET_MAP_GET_PAD(skb);
 	len = RMNET_MAP_GET_LENGTH(skb) - pad;
+	next_hdr = RMNET_MAP_GET_NH_BIT(skb);
 
 	if (mux_id >= RMNET_MAX_LOGICAL_EP)
 		goto free_skb;
@@ -80,15 +81,19 @@ __rmnet_map_ingress_handler(struct sk_buff *skb,
 
 	skb->dev = ep->egress_dev;
 
-	/* Subtract MAP header */
-	skb_pull(skb, sizeof(struct rmnet_map_header));
-	rmnet_set_skb_proto(skb);
-
-	if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4) {
+	if (next_hdr &&
+	    (port->data_format & (RMNET_FLAGS_INGRESS_MAP_CKSUMV5))) {
+		if (rmnet_map_process_next_hdr_packet(skb, len))
+			goto free_skb;
+	} else if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4) {
 		if (!rmnet_map_checksum_downlink_packet(skb, len + pad))
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 	}
 
+	/* Subtract MAP header */
+	skb_pull(skb, sizeof(struct rmnet_map_header));
+	rmnet_set_skb_proto(skb);
+
 	skb_trim(skb, len);
 	rmnet_deliver_skb(skb);
 	return;
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
index 576501d..55d293c 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* Copyright (c) 2013-2018, The Linux Foundation. All rights reserved.
+/* Copyright (c) 2013-2018, 2021, The Linux Foundation. All rights reserved.
  */
 
 #ifndef _RMNET_MAP_H_
@@ -23,6 +23,12 @@ struct rmnet_map_control_command {
 	};
 }  __aligned(1);
 
+enum rmnet_map_v5_header_type {
+	RMNET_MAP_HEADER_TYPE_UNKNOWN,
+	RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD = 0x2,
+	RMNET_MAP_HEADER_TYPE_ENUM_LENGTH
+};
+
 enum rmnet_map_commands {
 	RMNET_MAP_COMMAND_NONE,
 	RMNET_MAP_COMMAND_FLOW_DISABLE,
@@ -44,6 +50,9 @@ enum rmnet_map_commands {
 #define RMNET_MAP_GET_LENGTH(Y) (ntohs(((struct rmnet_map_header *) \
 					(Y)->data)->pkt_len))
 
+#define RMNET_MAP_GET_NH_BIT(Y)  (((struct rmnet_map_header *) \
+				    (Y)->data)->next_hdr)
+
 #define RMNET_MAP_COMMAND_REQUEST     0
 #define RMNET_MAP_COMMAND_ACK         1
 #define RMNET_MAP_COMMAND_UNSUPPORTED 2
@@ -55,10 +64,29 @@ enum rmnet_map_commands {
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
 				      struct net_device *orig_dev);
+int rmnet_map_process_next_hdr_packet(struct sk_buff *skb, u16 len);
+
+static u8 rmnet_map_get_next_hdr_type(struct sk_buff *skb)
+{
+	unsigned char *data = skb->data;
+
+	data += sizeof(struct rmnet_map_header);
+	return ((struct rmnet_map_v5_csum_header *)data)->header_type;
+}
+
+static inline bool rmnet_map_get_csum_valid(struct sk_buff *skb)
+{
+	unsigned char *data = skb->data;
+
+	data += sizeof(struct rmnet_map_header);
+	return ((struct rmnet_map_v5_csum_header *)data)->csum_valid_required;
+}
 
 #endif /* _RMNET_MAP_H_ */
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 21d3816..3d7e03f 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Copyright (c) 2013-2018, The Linux Foundation. All rights reserved.
+/* Copyright (c) 2013-2018, 2021, The Linux Foundation. All rights reserved.
  *
  * RMNET Data MAP protocol
  */
@@ -311,6 +311,7 @@ struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
 struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
 				      struct rmnet_port *port)
 {
+	unsigned char *data = skb->data, *next_hdr = NULL;
 	struct rmnet_map_header *maph;
 	struct sk_buff *skbn;
 	u32 packet_len;
@@ -323,6 +324,12 @@ struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
 
 	if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4)
 		packet_len += sizeof(struct rmnet_map_dl_csum_trailer);
+	else if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV5) {
+		if (!maph->cd_bit) {
+			packet_len += sizeof(struct rmnet_map_v5_csum_header);
+			next_hdr = data + sizeof(*maph);
+		}
+	}
 
 	if (((int)skb->len - (int)packet_len) < 0)
 		return NULL;
@@ -331,6 +338,11 @@ struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
 	if (ntohs(maph->pkt_len) == 0)
 		return NULL;
 
+	if (next_hdr &&
+	    ((struct rmnet_map_v5_csum_header *)next_hdr)->header_type !=
+	     RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD)
+		return NULL;
+
 	skbn = alloc_skb(packet_len + RMNET_MAP_DEAGGR_SPACING, GFP_ATOMIC);
 	if (!skbn)
 		return NULL;
@@ -428,3 +440,33 @@ void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
 
 	priv->stats.csum_sw++;
 }
+
+/* Process a MAPv5 packet header */
+int rmnet_map_process_next_hdr_packet(struct sk_buff *skb,
+				      u16 len)
+{
+	struct rmnet_priv *priv = netdev_priv(skb->dev);
+	int rc = 0;
+
+	switch (rmnet_map_get_next_hdr_type(skb)) {
+	case RMNET_MAP_HEADER_TYPE_CSUM_OFFLOAD:
+		if (unlikely(!(skb->dev->features & NETIF_F_RXCSUM))) {
+			priv->stats.csum_sw++;
+		} else if (rmnet_map_get_csum_valid(skb)) {
+			priv->stats.csum_ok++;
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
+		} else {
+			priv->stats.csum_valid_unset++;
+		}
+
+		/* Pull csum v5 header */
+		skb_pull(skb, sizeof(struct rmnet_map_v5_csum_header));
+		break;
+	default:
+		rc = -EINVAL;
+		break;
+	}
+
+	return rc;
+}
+
diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
index 9661416..81acd0b 100644
--- a/include/linux/if_rmnet.h
+++ b/include/linux/if_rmnet.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only
- * Copyright (c) 2013-2019, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2013-2019, 2021 The Linux Foundation. All rights reserved.
  */
 
 #ifndef _LINUX_IF_RMNET_H_
@@ -8,11 +8,11 @@
 struct rmnet_map_header {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
 	u8  pad_len:6;
-	u8  reserved_bit:1;
+	u8  next_hdr:1;
 	u8  cd_bit:1;
 #elif defined (__BIG_ENDIAN_BITFIELD)
 	u8  cd_bit:1;
-	u8  reserved_bit:1;
+	u8  next_hdr:1;
 	u8  pad_len:6;
 #else
 #error	"Please fix <asm/byteorder.h>"
@@ -52,4 +52,15 @@ struct rmnet_map_ul_csum_header {
 #endif
 } __aligned(1);
 
+/* MAP CSUM headers */
+struct rmnet_map_v5_csum_header {
+	u8  next_hdr:1;
+	u8  header_type:7;
+	u8  hw_reserved:5;
+	u8  priority:1;
+	u8  hw_reserved_bit:1;
+	u8  csum_valid_required:1;
+	__be16 reserved;
+} __aligned(1);
+
 #endif /* !(_LINUX_IF_RMNET_H_) */
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 82708c6..838bd29 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1233,6 +1233,7 @@ enum {
 #define RMNET_FLAGS_INGRESS_MAP_COMMANDS          (1U << 1)
 #define RMNET_FLAGS_INGRESS_MAP_CKSUMV4           (1U << 2)
 #define RMNET_FLAGS_EGRESS_MAP_CKSUMV4            (1U << 3)
+#define RMNET_FLAGS_INGRESS_MAP_CKSUMV5           (1U << 4)
 
 enum {
 	IFLA_RMNET_UNSPEC,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

