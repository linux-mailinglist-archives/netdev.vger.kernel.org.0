Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250CC33C8DE
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 22:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbhCOVwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 17:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbhCOVwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 17:52:02 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46125C06175F
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 14:52:02 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id h18so10843554ils.2
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 14:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v7N6p1x0BsH0iM7+7iNRHjfZcm0BfhMj037soR+6HF4=;
        b=poW1YMS4YSxaLKEiHkfDczYRpqjgHVgtW4F8oj4a78qxH0zHERoYJ65kHX3saRWU8p
         SpOhu/1bOxZlp+4PZxOMRBGzZ7LHESr7/QUG7FxrxE618vxSEn7G9lgXlNgJ2NsBgTKk
         gqjmxWmyL6Plw2ZRbUKZrpEzJ0Er7SCmELP2JN1vG1siq4wGMUPgI+yS7QIhKFyZ/Arm
         42kAJUpxzU1EbUY2mtvYAX0e8IVnKLAZTshpovvj34m7gg21m0yx3Ahn0WAHj3nvIuwx
         us8ySMRvf33t20j7ObYagpY1Bx2qCbFq6a0rqSaVIZtl5y6J/tZjLuRaynAC5KTsy0eb
         yj8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v7N6p1x0BsH0iM7+7iNRHjfZcm0BfhMj037soR+6HF4=;
        b=dW0SiybYPukuOcKDPc6cSGLa8r/ldAwPVFRWycsCOvCnWNPBnlmf2AEZhnx0OS+CAx
         tqHxzki9FGPVUbf2w40bq+LwjbYOWvXj8MmPu1DwLJdiWO0UNafO93mgpkWzcPfIdtv6
         Qvdnr9YbtSB0dHW2J1e0nDka5H+XC96CMuE/8TDLZTiXohkEfHYPT77EFiGqQHz1p83g
         VmXMctc6qhKja1nKfl3AWBf6B4PcEGJJZjYSsfpsdl3MsPzeQfi6e5IwascOTlA31I+9
         /uWoqe3WFutk7RpGabd6IwX78nejqixpKKiQms8EadMhiduamg3aiXCSn0fGo1KVYzzt
         oI3Q==
X-Gm-Message-State: AOAM530HwdW3bZex9AUB+GpHFiPNfmyvshP1a0ekcupp9Pdz/KYGP3cO
        UXKHBqnyZY/NABNOM3vBHcjsrg==
X-Google-Smtp-Source: ABdhPJyx+YoXdoYx4vHWnNanw0Rzp9ouALpv/wl8rCTdgBVFzLBgFd/HLFX6xZm/+7GWJqe5yfwxKQ==
X-Received: by 2002:a92:c690:: with SMTP id o16mr1375597ilg.256.1615845121704;
        Mon, 15 Mar 2021 14:52:01 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id y3sm7424625iot.15.2021.03.15.14.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 14:52:01 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        David.Laight@ACULAB.COM, olteanv@gmail.com,
        alexander.duyck@gmail.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Duyck <alexanderduyck@fb.com>
Subject: [PATCH net-next v6 6/6] net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum header
Date:   Mon, 15 Mar 2021 16:51:51 -0500
Message-Id: <20210315215151.3029676-7-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210315215151.3029676-1-elder@linaro.org>
References: <20210315215151.3029676-1-elder@linaro.org>
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
---
v5: - Assign checksum start offset a little later (with csum_info)
v4: - Don't use u16_get_bits() to access the checksum field offset
v3: - Use BIT(x) and don't use u16_get_bits() for single-bit flags
v2: - Fixed to use u16_encode_bits() instead of be16_encode_bits()

 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 38 +++++++------------
 include/linux/if_rmnet.h                      | 21 +++++-----
 2 files changed, 23 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index c336c17e01fe4..0ac2ff828320c 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -197,20 +197,16 @@ rmnet_map_ipv4_ul_csum_header(void *iphdr,
 			      struct rmnet_map_ul_csum_header *ul_header,
 			      struct sk_buff *skb)
 {
-	__be16 *hdr = (__be16 *)ul_header;
 	struct iphdr *ip4h = iphdr;
+	u16 val;
 
-	ul_header->csum_start_offset = htons(skb_network_header_len(skb));
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

