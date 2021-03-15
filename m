Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB0933B4AE
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 14:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhCONfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 09:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhCONfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 09:35:05 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE2FC06175F
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 06:35:05 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id n14so33368000iog.3
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 06:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9wMFcNuOVXwXfZ6AijxvuqRZ/xlVmx3dzuXhVIw9piE=;
        b=VFz1SVaLgdPj7f1Blere5/zlo9Q2YANYLg/vbJnJntFNyuwjMP/xLfvubtjZB8V/Sm
         AWYVcK9wHMxEyQKxhVbWC4Csp2U8QUyrGzeCUfsOSa3jqn+ZKnWfRnvja/9vj7hJzxXK
         Y+wvB5WEtZHOUlvJzgo3Vg/KFMmcaHNBNWe6HlCm4QWQah72mv0s5o8CWnbBZTW2NYAX
         CDtHvYz9hf1ZjA3koZAwhW4Hul+LfGZPSGV1QOUnCLkswPKBtjPOvIFKIDNG+TRwje4d
         lWSEbKgpXo0q2zJ1aICH+Gsdc74CZSLbEp7ioUzhW2UhHkn7XZo13GkAG+fzRzjpeR2D
         IShw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9wMFcNuOVXwXfZ6AijxvuqRZ/xlVmx3dzuXhVIw9piE=;
        b=Rd7VRJy5haCiN4YcgEMhMfFNI796QpzoqTYSUnL0FwKdRgmGlk4UmysJCetAUI0+6O
         80/lZiUF8U6PcYwev5TZiPfPBvnj3ygUbNpPWp0GEoa7ytSH1l6+cGSk2EmvZSj2e/wb
         KMrY9557K0hHAfEt7XNXfKtW4DfmA+BzOZ6weYwmbLlSOPcUGURtLtFvECahw4oWyGS4
         YXKzi3ptKBMcPOXf9Hk6qCUSsYM+SG1B6gQ4eUPZvfbSE/82pqFNGQJ6E0zGaFqj+FI5
         jUlh9FMdkfeaTFkvfhHP34/GgGlsiiSrV5gqA/ey3FagUsGFApRV5OlaEjME3vl/ZVh2
         UMYg==
X-Gm-Message-State: AOAM530fKYTfePxKI1uFr5PuSPD8/I1oa6a+mpBA/ldw3IQpOLtdPKVw
        QTsiSySrEXTBsAeT8NeaKdd2YA==
X-Google-Smtp-Source: ABdhPJz2vOJO5r5D1BTGVqZTEUcYR/Wt2AduP5+CEWjiKD1qfDC2YlCn3LTrQ4wGa7ebkzZ2tOzAmg==
X-Received: by 2002:a5d:93c2:: with SMTP id j2mr7444285ioo.166.1615815305317;
        Mon, 15 Mar 2021 06:35:05 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o23sm7127672ioo.24.2021.03.15.06.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 06:35:05 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        David.Laight@ACULAB.COM, olteanv@gmail.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v4 6/6] net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum header
Date:   Mon, 15 Mar 2021 08:34:55 -0500
Message-Id: <20210315133455.1576188-7-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210315133455.1576188-1-elder@linaro.org>
References: <20210315133455.1576188-1-elder@linaro.org>
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
---
v4: - Don't use u16_get_bits() to access the checksum field offset
v3: - Use BIT(x) and don't use u16_get_bits() for single-bit flags
v2: - Fixed to use u16_encode_bits() instead of be16_encode_bits().

 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 34 ++++++-------------
 include/linux/if_rmnet.h                      | 21 ++++++------
 2 files changed, 21 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 3df23365497c4..bdb6ab6dad83d 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -197,23 +197,19 @@ rmnet_map_ipv4_ul_csum_header(void *iphdr,
 			      struct rmnet_map_ul_csum_header *ul_header,
 			      struct sk_buff *skb)
 {
-	__be16 *hdr = (__be16 *)ul_header;
 	struct iphdr *ip4h = iphdr;
 	u16 offset;
+	u16 val;
 
 	offset = skb_transport_header(skb) - (unsigned char *)iphdr;
 	ul_header->csum_start_offset = htons(offset);
 
-	ul_header->csum_insert_offset = skb->csum_offset;
-	ul_header->csum_enabled = 1;
+	val = MAP_CSUM_UL_ENABLED_FLAG;
 	if (ip4h->protocol == IPPROTO_UDP)
-		ul_header->udp_ind = 1;
-	else
-		ul_header->udp_ind = 0;
+		val |= MAP_CSUM_UL_UDP_FLAG;
+	val |= skb->csum_offset & MAP_CSUM_UL_OFFSET_MASK;
 
-	/* Changing remaining fields to network order */
-	hdr++;
-	*hdr = htons((__force u16)*hdr);
+	ul_header->csum_info = htons(val);
 
 	skb->ip_summed = CHECKSUM_NONE;
 
@@ -240,24 +236,19 @@ rmnet_map_ipv6_ul_csum_header(void *ip6hdr,
 			      struct rmnet_map_ul_csum_header *ul_header,
 			      struct sk_buff *skb)
 {
-	__be16 *hdr = (__be16 *)ul_header;
 	struct ipv6hdr *ip6h = ip6hdr;
 	u16 offset;
+	u16 val;
 
 	offset = skb_transport_header(skb) - (unsigned char *)ip6hdr;
 	ul_header->csum_start_offset = htons(offset);
 
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
+	ul_header->csum_info = htons(val);
 
 	skb->ip_summed = CHECKSUM_NONE;
 
@@ -425,10 +416,7 @@ void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
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

