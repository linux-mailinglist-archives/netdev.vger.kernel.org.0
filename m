Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59A28238D8
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 15:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390323AbfETNyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 09:54:08 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:40421 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389909AbfETNyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 09:54:06 -0400
Received: by mail-io1-f66.google.com with SMTP id s20so11072119ioj.7
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 06:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XZw+WK9Ep7KnMxZda1w63yeDixvAfUhz3fm/WPmj3DA=;
        b=S4enJUEKqFT864sg1x+pjeXgA0rFex1SjESZsKd844hf6PlYJ/lInrfNmqEOqguWGV
         v/sA7bU/54p49Ul0mvtJoPCOE4RERlcCeEBgAqc6ixOlHzs9JxA3+4UmpSrMF15qrVL5
         6XXbFTmgqIj+AIG2gMq/b85nHyGwQmD7fjftL9zhgNLDHE2/2RNMbuNJF7lg+nfa+HBP
         10QEAwZN8k1AujAVFImb8YygjOKw2R+LlOE/RaKW8s5jIF9udsX2bzYc/O82HtUZr9ru
         NeLcGUtoPpNTkEHUelSE+L8Cms+GBrnjrD0zj6HCa/uvbBIzG64241jGNG22J3CqfMc9
         U4KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XZw+WK9Ep7KnMxZda1w63yeDixvAfUhz3fm/WPmj3DA=;
        b=i42P3fIO3rEsL1Oa9Q//b0CZTK+706Zp76HVyQGWPdPVE1dc32EDIpC/mLK8EMvewf
         6BtT81oetjt6ZWis8foAU0j0FIpx8TziPqwr/OF7tCJyFvlaI7143UCK3Ea+s+6KMln0
         x1dnaRD+4aI59tQ8+THl7gNDNSFP4fJO6un/wyVOqNlSNyDLaSbi/MiWwOgpUS0aOGAG
         0IRS6wR95zXwtyfLP/vKn24+RE4YYJgXn5jrwSnsN8C3cy6VcmYFRN4bdnDHP61I/kqe
         bRaHtnJThz0oUbWFgXUAVRN4xTUjoKa+VKeIoruJbJr8ijJtxEh2S8R8tHVLXfackNZ0
         oBbg==
X-Gm-Message-State: APjAAAXZidgk4xn0hC7ZM9YHvsLF6kxJyDQrKioAr5xewxVWmBkrISMR
        DUTArnf5SUhLpMKAr66m01Z1SQ==
X-Google-Smtp-Source: APXvYqxCHlSs84ZzkHPl2hQvL7JJVuT2q6BWjhQZwpjY6kjaOTDJrZOENVfuvB4EKMKbt3+cK9F+QQ==
X-Received: by 2002:a05:6602:4e:: with SMTP id z14mr14015532ioz.93.1558360445436;
        Mon, 20 May 2019 06:54:05 -0700 (PDT)
Received: from localhost.localdomain (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.gmail.com with ESMTPSA id n17sm6581185ioa.0.2019.05.20.06.54.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 06:54:04 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     arnd@arndb.de, subashab@codeaurora.org, david.brown@linaro.org,
        agross@kernel.org, davem@davemloft.net
Cc:     bjorn.andersson@linaro.org, ilias.apalodimas@linaro.org,
        cpratapa@codeaurora.org, syadagir@codeaurora.org,
        evgreen@chromium.org, benchan@google.com, ejcaruso@google.com,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum header
Date:   Mon, 20 May 2019 08:53:50 -0500
Message-Id: <20190520135354.18628-5-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190520135354.18628-1-elder@linaro.org>
References: <20190520135354.18628-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the use of C bit-fields in the rmnet_map_ul_csum_header
structure with a single integral structure member, and use field
masks to encode or get values within that member.

Note that the previous C bit-fields were defined with CPU local
endianness.  Their values were computed and then forecfully converted
to network byte order in rmnet_map_ipv4_ul_csum_header().  Simplify
that function, and properly define the new csum_info member as a big
endian value.

Make similar simplifications in rmnet_map_ipv6_ul_csum_header().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 .../net/ethernet/qualcomm/rmnet/rmnet_map.h   |  9 ++--
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 50 ++++++++-----------
 2 files changed, 26 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
index a56209645c81..f3231c26badd 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
@@ -60,11 +60,14 @@ struct rmnet_map_dl_csum_trailer {
 
 struct rmnet_map_ul_csum_header {
 	__be16 csum_start_offset;
-	u16 csum_insert_offset:14;
-	u16 udp_ip4_ind:1;
-	u16 csum_enabled:1;
+	__be16 csum_info;	/* RMNET_MAP_UL_* */
 } __aligned(1);
 
+/* NOTE:  These field masks are defined in CPU byte order */
+#define RMNET_MAP_UL_CSUM_INSERT_FMASK	GENMASK(13, 0)
+#define RMNET_MAP_UL_CSUM_UDP_FMASK	GENMASK(14, 14)   /* 0: IP; 1: UDP */
+#define RMNET_MAP_UL_CSUM_ENABLED_FMASK	GENMASK(15, 15)
+
 #define RMNET_MAP_COMMAND_REQUEST     0
 #define RMNET_MAP_COMMAND_ACK         1
 #define RMNET_MAP_COMMAND_UNSUPPORTED 2
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 10d2d582a9ce..72b64114505a 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -207,22 +207,18 @@ rmnet_map_ipv4_ul_csum_header(void *iphdr,
 			      struct rmnet_map_ul_csum_header *ul_header,
 			      struct sk_buff *skb)
 {
-	struct iphdr *ip4h = (struct iphdr *)iphdr;
-	__be16 *hdr = (__be16 *)ul_header, offset;
+	struct iphdr *ip4h = iphdr;
+	u16 offset;
+	u16 val;
 
-	offset = htons((__force u16)(skb_transport_header(skb) -
-				     (unsigned char *)iphdr));
-	ul_header->csum_start_offset = offset;
-	ul_header->csum_insert_offset = skb->csum_offset;
-	ul_header->csum_enabled = 1;
+	offset = skb_transport_header(skb) - (unsigned char *)iphdr;
+	ul_header->csum_start_offset = htons(offset);
+
+	val = u16_encode_bits(skb->csum_offset, RMNET_MAP_UL_CSUM_INSERT_FMASK);
+	val |= RMNET_MAP_UL_CSUM_ENABLED_FMASK;
 	if (ip4h->protocol == IPPROTO_UDP)
-		ul_header->udp_ip4_ind = 1;
-	else
-		ul_header->udp_ip4_ind = 0;
-
-	/* Changing remaining fields to network order */
-	hdr++;
-	*hdr = htons((__force u16)*hdr);
+		val |= RMNET_MAP_UL_CSUM_UDP_FMASK;
+	ul_header->csum_info = htons(val);
 
 	skb->ip_summed = CHECKSUM_NONE;
 
@@ -249,18 +245,16 @@ rmnet_map_ipv6_ul_csum_header(void *ip6hdr,
 			      struct rmnet_map_ul_csum_header *ul_header,
 			      struct sk_buff *skb)
 {
-	__be16 *hdr = (__be16 *)ul_header, offset;
+	u16 offset;
+	u16 val;
 
-	offset = htons((__force u16)(skb_transport_header(skb) -
-				     (unsigned char *)ip6hdr));
-	ul_header->csum_start_offset = offset;
-	ul_header->csum_insert_offset = skb->csum_offset;
-	ul_header->csum_enabled = 1;
-	ul_header->udp_ip4_ind = 0;
+	offset = skb_transport_header(skb) - (unsigned char *)ip6hdr;
+	ul_header->csum_start_offset = htons(offset);
 
-	/* Changing remaining fields to network order */
-	hdr++;
-	*hdr = htons((__force u16)*hdr);
+	val = u16_encode_bits(skb->csum_offset, RMNET_MAP_UL_CSUM_INSERT_FMASK);
+	val |= RMNET_MAP_UL_CSUM_ENABLED_FMASK;
+	/* Not UDP, so that field is 0 */
+	ul_header->csum_info = htons(val);
 
 	skb->ip_summed = CHECKSUM_NONE;
 
@@ -400,8 +394,7 @@ void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
 	struct rmnet_map_ul_csum_header *ul_header;
 	void *iphdr;
 
-	ul_header = (struct rmnet_map_ul_csum_header *)
-		    skb_push(skb, sizeof(struct rmnet_map_ul_csum_header));
+	ul_header = skb_push(skb, sizeof(*ul_header));
 
 	if (unlikely(!(orig_dev->features &
 		     (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM))))
@@ -428,10 +421,7 @@ void rmnet_map_checksum_uplink_packet(struct sk_buff *skb,
 	}
 
 sw_csum:
-	ul_header->csum_start_offset = 0;
-	ul_header->csum_insert_offset = 0;
-	ul_header->csum_enabled = 0;
-	ul_header->udp_ip4_ind = 0;
+	memset(ul_header, 0, sizeof(*ul_header));
 
 	priv->stats.csum_sw++;
 }
-- 
2.20.1

