Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299CC33C61C
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 19:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbhCOSuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 14:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbhCOStk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 14:49:40 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB4BC061763
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 11:49:39 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id 81so34501050iou.11
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 11:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PXbxDLQ5qzFahsfuQdQd2/oh6y0N5sQbqIGCA/JCZcI=;
        b=gcxva2A+i8wAZZUM0MJqS4HJtjOcnfep/osbYXHElsJUPfyLqq0LlOqZ7yxTsu/U3O
         X3qDUjpfYAtFVvZqW7hNgCnTx1XtIxQ2F9oqTNQQWvbRcuE92jdH9P7l1KbMMW9Mcobk
         2s6+byeIDyItyjgCkC58xd0YiK8pamcDf+UI19fkAtf09oJmr14pittbE6f3rK4pqRWZ
         3WkBcebWEJyAaztFyLqphCYnRzp7ww9Rt9C7KtwNbsU+gujsQkLQ84odRpnFum6cLmBD
         nECtX0a17koHvS55m3nsYoqDQjibk+kUMFmdjEgGXY7eDaeGq5NFdHHDvnPayOQvR7Zg
         dI3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PXbxDLQ5qzFahsfuQdQd2/oh6y0N5sQbqIGCA/JCZcI=;
        b=UEVpTEnJGv+YpAX7bthSq7u5P0qOmaVnXQCaB9dddLofnI2Lcs8cUeE/Kx7eNaE1RF
         CSC/48+NBevUhySJ+yS+/lYvfA1W9VY/qBNpaZyG+dRSZcI7DCYDTSg4QCX8+7+SgHxO
         QmUqKWiVtHmlNs7FwvfX5MOTRFihgwS/7aetIS9D78Tll+1EzfZc9Gq/e5k3NmnyRfWE
         Tz24BiDWHuACgiibWFLYxsLpdA7fIhbNJ/kPaqUDvvtZ1gx6+yq9DyypV2tjl5Ye6dI8
         XM3b2UXKltLS1bik9Oem4KvcQDopUOinink6ZltmiXpurj8LXeQjSG0p4EeEvL3GQKpi
         VjWA==
X-Gm-Message-State: AOAM533Dw+Tr34JKXaLpAbDEJoOwEYjPC25fQZ1I/AICj8ipWhVLkrFi
        jbWxq9H367nXPqPcXGq6yNtI2Q==
X-Google-Smtp-Source: ABdhPJzG2lwjHlnTmgu1x/TXnXdNoT1TErE7Cvq+6JDSdEhCn+dELPNR/j8apYR0iz7HPsxaL6KizQ==
X-Received: by 2002:a5d:9bc8:: with SMTP id d8mr680632ion.115.1615834179259;
        Mon, 15 Mar 2021 11:49:39 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id a5sm8212162ilk.14.2021.03.15.11.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 11:49:38 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        David.Laight@ACULAB.COM, olteanv@gmail.com,
        alexander.duyck@gmail.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Duyck <alexanderduyck@fb.com>
Subject: [PATCH net-next v5 6/6] net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum header
Date:   Mon, 15 Mar 2021 13:49:28 -0500
Message-Id: <20210315184928.2913264-7-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210315184928.2913264-1-elder@linaro.org>
References: <20210315184928.2913264-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the use of C bit-fields in the rmnet_map_ul_csum_header
structure with a single two-byte (big endian) structure member,
and use masks to encode or get values within it.  The content of
these fields can be accessed using simple bitwise AND and OR
operations on the (host byte order) value of the new structure
member.

Previously rmnet_map_ipv4_ul_csum_header() would update C bit-field
values in host byte order, then forcibly fix their byte order using
a combination of byte swap operations and types.

Instead, just compute the value that needs to go into the new
structure member and save it with a simple byte-order conversion.

Make similar simplifications in rmnet_map_ipv6_ul_csum_header().

Finally, in rmnet_map_checksum_uplink_packet() a set of assignments
zeroes every field in the upload checksum header.  Replace that with
a single memset() operation.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
--
v5: - Assign checksum start offset a little later (with csum_info)
v4: - Don't use u16_get_bits() to access the checksum field offset
v3: - Use BIT(x) and don't use u16_get_bits() for single-bit flags
v2: - Fixed to use u16_encode_bits() instead of be16_encode_bits()

.../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 38 +++++++------------
include/linux/if_rmnet.h                      | 21 +++++-----
2 files changed, 23 insertions(+), 36 deletions(-)

iff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
ndex c336c17e01fe4..0ac2ff828320c 100644
-- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@ -197,20 +197,16 @@ rmnet_map_ipv4_ul_csum_header(void *iphdr,
			      struct rmnet_map_ul_csum_header *ul_header,
			      struct sk_buff *skb)
{
	__be16 *hdr = (__be16 *)ul_header;
	struct iphdr *ip4h = iphdr;
	u16 val;

	ul_header->csum_start_offset = htons(skb_network_header_len(skb));
	ul_header->csum_insert_offset = skb->csum_offset;
	ul_header->csum_enabled = 1;
	val = MAP_CSUM_UL_ENABLED_FLAG;
	if (ip4h->protocol == IPPROTO_UDP)
		ul_header->udp_ind = 1;
	else
		ul_header->udp_ind = 0;
		val |= MAP_CSUM_UL_UDP_FLAG;
	val |= skb->csum_offset & MAP_CSUM_UL_OFFSET_MASK;

-	/* Changing remaining fields to network order */
-	hdr++;
-	*hdr = htons((__force u16)*hdr);
+	ul_header->csum_start_offset = htons(skb_network_header_len(skb));
+	ul_header->csum_info = htons(val);
 
 	skb->ip_summed = CHECKSUM_NONE;
 
@@ -237,21 +233,16 @@ rmnet_map_ipv6_ul_csum_header(void *ip6hdr,
 			      struct rmnet_map_ul_csum_header *ul_header,
 			      struct sk_buff *skb)
 {
-	__be16 *hdr = (__be16 *)ul_header;
 	struct ipv6hdr *ip6h = ip6hdr;
+	u16 val;
 
-	ul_header->csum_start_offset = htons(skb_network_header_len(skb));
-	ul_header->csum_insert_offset = skb->csum_offset;
-	ul_header->csum_enabled = 1;
-
+	val = MAP_CSUM_UL_ENABLED_FLAG;
 	if (ip6h->nexthdr == IPPROTO_UDP)
-		ul_header->udp_ind = 1;
-	else
-		ul_header->udp_ind = 0;
+		val |= MAP_CSUM_UL_UDP_FLAG;
+	val |= skb->csum_offset & MAP_CSUM_UL_OFFSET_MASK;
 
-	/* Changing remaining fields to network order */
-	hdr++;
-	*hdr = htons((__force u16)*hdr);
+	ul_header->csum_start_offset = htons(skb_network_header_len(skb));
+	ul_header->csum_info = htons(val);
 
 	skb->ip_summed = CHECKSUM_NONE;
 
@@ -419,10 +410,7 @@ void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
 	}
 
 sw_csum:
-	ul_header->csum_start_offset = 0;
-	ul_header->csum_insert_offset = 0;
-	ul_header->csum_enabled = 0;
-	ul_header->udp_ind = 0;
+	memset(ul_header, 0, sizeof(*ul_header));
 
 	priv->stats.csum_sw++;
 }
diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
index 941997df9e088..4efb537f57f31 100644
--- a/include/linux/if_rmnet.h
+++ b/include/linux/if_rmnet.h
@@ -33,17 +33,16 @@ struct rmnet_map_dl_csum_trailer {
 
 struct rmnet_map_ul_csum_header {
 	__be16 csum_start_offset;
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	u16 csum_insert_offset:14;
-	u16 udp_ind:1;
-	u16 csum_enabled:1;
-#elif defined (__BIG_ENDIAN_BITFIELD)
-	u16 csum_enabled:1;
-	u16 udp_ind:1;
-	u16 csum_insert_offset:14;
-#else
-#error	"Please fix <asm/byteorder.h>"
-#endif
+	__be16 csum_info;		/* MAP_CSUM_UL_* */
 } __aligned(1);
 
+/* csum_info field:
+ *  OFFSET:	where (offset in bytes) to insert computed checksum
+ *  UDP:	1 = UDP checksum (zero checkum means no checksum)
+ *  ENABLED:	1 = checksum computation requested
+ */
+#define MAP_CSUM_UL_OFFSET_MASK		GENMASK(13, 0)
+#define MAP_CSUM_UL_UDP_FLAG		BIT(14)
+#define MAP_CSUM_UL_ENABLED_FLAG	BIT(15)
+
 #endif /* !(_LINUX_IF_RMNET_H_) */
-- 
2.27.0

