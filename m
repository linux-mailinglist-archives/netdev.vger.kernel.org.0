Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABAC32DD2A
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 23:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbhCDWey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 17:34:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbhCDWel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 17:34:41 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A3EC061760
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 14:34:41 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id e7so178283ile.7
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 14:34:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Na3YOPu455NEidL4GYMHGo2WvYfOyb52BffrIYZ622Y=;
        b=ZyB5GZTDiG+3RByDMmMK/RwfcwzbDLYwmGyxtFjwC82735NihIqpaFNHK9LL+SzfyH
         JmdwqrB3O6i2w8EyQPZyroWZyysI9spedyBP56xjlsw71kLc4h9hI//OjsCUstxWyE/n
         M/r9eOoWzBKVv5BUgeSjNnNzc077bEOX6IeP5jmCjI59avpqbjPwByo7awNti2j2lgQ7
         d1GNzlFYAzj8XBTD8L2ObkOyBoCnjn7efquBTh8HIfaEn5AKeHsqQ8Khcky0SLPah7TW
         r9mx6VBSX9WEV8bNcwXYVvkLZ6pPqm9bwplN7YSkqeaU9uqmTDcCLnc2kmqfGDDJy9GT
         jxxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Na3YOPu455NEidL4GYMHGo2WvYfOyb52BffrIYZ622Y=;
        b=eL0ycwzwaBe2O7NNYLL9QewcGVqv/dsBNqvQ6WzfVsQOcaANUGAgcGmhkpPYvKo8ZM
         ovJHr2giQvvmqlzzrBIyd80FBiEMSuF1zeTX2aSashzpnIs5OKoRn1S6deR6x/M/k5fg
         tuCRGECe8nRgxwchCpMhlgTXazrjdIF0MAHIUJdeZjwfFWLj65qykKYvjsr474XDeNLg
         hd3Y+4t6rnklXVeKuqssvUMArXJtl7+O5PZ6lu0MTp7bvfHoV6FNbQc8Kvb4tx5Au5Od
         s9Kk4yvNFPI9+E1+8/cvjUf9UEr/RKVsd8z5bm967tdpumNfKGm3YTTHmdOgu/9rCljZ
         9apg==
X-Gm-Message-State: AOAM532p6BzCHKQIbq/IhcjXCpHBh0rb8OD5IN5CB1phFVq9A1XLZFaq
        wCTwIsSApXYjTyz4yYZGmgbxjQ==
X-Google-Smtp-Source: ABdhPJwnz2KTlbD2EqNS64HpAwknmXvxVVgKmRePmFKEcloLjS2OD2ZetDqhnsebxbBPtuV/dh55Sw==
X-Received: by 2002:a92:6b0f:: with SMTP id g15mr6207225ilc.144.1614897280619;
        Thu, 04 Mar 2021 14:34:40 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id s18sm399790ilt.9.2021.03.04.14.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 14:34:40 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/6] net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum header
Date:   Thu,  4 Mar 2021 16:34:31 -0600
Message-Id: <20210304223431.15045-7-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210304223431.15045-1-elder@linaro.org>
References: <20210304223431.15045-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the use of C bit-fields in the rmnet_map_ul_csum_header
structure with a single two-byte (big endian) structure member,
and use field masks to encode or get values within it.

Previously rmnet_map_ipv4_ul_csum_header() would update values in
the host byte-order fields, and then forcibly fix their byte order
using a combination of byte order operations and types.

Instead, just compute the value that needs to go into the new
structure member and save it with a simple byte-order conversion.

Make similar simplifications in rmnet_map_ipv6_ul_csum_header().

Finally, in rmnet_map_checksum_uplink_packet() a set of assignments
zeroes every field in the upload checksum header.  Replace that with
a single memset() operation.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 34 ++++++-------------
 include/linux/if_rmnet.h                      | 21 ++++++------
 2 files changed, 21 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 29d485b868a65..db76bbf000aa1 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -198,23 +198,19 @@ rmnet_map_ipv4_ul_csum_header(void *iphdr,
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
+	val = be16_encode_bits(1, MAP_CSUM_UL_ENABLED_FMASK);
 	if (ip4h->protocol == IPPROTO_UDP)
-		ul_header->udp_ind = 1;
-	else
-		ul_header->udp_ind = 0;
+		val |= be16_encode_bits(1, MAP_CSUM_UL_UDP_FMASK);
+	val |= be16_encode_bits(skb->csum_offset, MAP_CSUM_UL_OFFSET_FMASK);
 
-	/* Changing remaining fields to network order */
-	hdr++;
-	*hdr = htons((__force u16)*hdr);
+	ul_header->csum_info = htons(val);
 
 	skb->ip_summed = CHECKSUM_NONE;
 
@@ -241,24 +237,19 @@ rmnet_map_ipv6_ul_csum_header(void *ip6hdr,
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
+	val = be16_encode_bits(1, MAP_CSUM_UL_ENABLED_FMASK);
 	if (ip6h->nexthdr == IPPROTO_UDP)
-		ul_header->udp_ind = 1;
-	else
-		ul_header->udp_ind = 0;
+		val |= be16_encode_bits(1, MAP_CSUM_UL_UDP_FMASK);
+	val |= be16_encode_bits(skb->csum_offset, MAP_CSUM_UL_OFFSET_FMASK);
 
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
index 1fbb7531238b6..149d696feb520 100644
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
+	__be16 csum_info;		/* MAP_CSUM_UL_*_FMASK */
 } __aligned(1);
 
+/* csum_info field:
+ *  ENABLED:	1 = checksum computation requested
+ *  UDP:	1 = UDP checksum (zero checkum means no checksum)
+ *  OFFSET:	where (offset in bytes) to insert computed checksum
+ */
+#define MAP_CSUM_UL_OFFSET_FMASK	GENMASK(13, 0)
+#define MAP_CSUM_UL_UDP_FMASK		GENMASK(14, 14)
+#define MAP_CSUM_UL_ENABLED_FMASK	GENMASK(15, 15)
+
 #endif /* !(_LINUX_IF_RMNET_H_) */
-- 
2.20.1

