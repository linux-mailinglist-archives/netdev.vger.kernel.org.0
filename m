Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3C13A4946
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 21:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbhFKTI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 15:08:57 -0400
Received: from mail-io1-f43.google.com ([209.85.166.43]:45788 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbhFKTIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 15:08:53 -0400
Received: by mail-io1-f43.google.com with SMTP id k5so22469728iow.12
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1jEKoQqd09IhMCBMusRvi4j4SzZxwB5xBIw8eYKxXpA=;
        b=Oqo3RETafwkfkNGoPxdzW/0nahkdiMknjYHn/ccLC3m3zAyZD7FMZkg7jjr4oC0IA/
         H/LtVw0T8+vkE+/DBPhIj3tB7HoNJBVjIMA9vNThbPHix151B9A7erob4v5WbDc/KX3U
         3mcFtl/qwDh6KeE9akBvU8Z1DZVFvT/lCSpfohmOru9NOsBnAlagPtQPHxMMQEmlwvIo
         /mx0X1hAJPbze/yDfGLthjjC2MeSqBFw3zBaw++w4+Z73Q5TvoydnvKuBbogFwvqpQQE
         nkmFdRiI1iP3jjG69JwvNMD8fx0cqMr99h6SL4A3PngPvEjr+gA4c/wy8RgflweQ37qq
         Awrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1jEKoQqd09IhMCBMusRvi4j4SzZxwB5xBIw8eYKxXpA=;
        b=E49qR/I4T+RezUEKCB4HDqz/7vyf9/9i/ptH+/rWMA9zPViSBsymKEp+DY7/qvaQ8j
         iTvt2vdAkIlgA9nU/cJend2AHxVXuhhGmCO6xnnOHuyj3mjGW18LXUnABQOHUFN0KelE
         czeVcHx5x5v5HHlHji2IxlRkqrl62WgH8OOo/3ECjOWakOm9DbG6gY3Xx/ktT6xGJ8PL
         qpg9UQ81HmSKakwXmUkhIJkE4M1/z5K0wTwEyeDdAkg1cHd6PPY6dne5lEwtILaDhSfh
         tkapAr+4tp+CUGUcHlnv9B5EEd9jCqcThkeDa39BiXqtX1YqmoZCRjQ7dmJ0m1Vcthoa
         n0dw==
X-Gm-Message-State: AOAM531gm5mJAeqAFV2oMPCK/iH+3UrqG8ap2WPPaj9K+ihvwjVWD9YJ
        fV/QeufyqoBPKaZgq76YlvTVvEf7MexHTIqq
X-Google-Smtp-Source: ABdhPJwnBj7e4z9vkNfrVAd+iVocsATkQIDR/jkJls4e9r+HlRJ/PW47CVG6YCjgltvjPDJcuKjiXg==
X-Received: by 2002:a05:6602:2048:: with SMTP id z8mr4292134iod.91.1623438340111;
        Fri, 11 Jun 2021 12:05:40 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id p9sm3936566ilc.63.2021.06.11.12.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:05:39 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/8] net: qualcomm: rmnet: clarify a bit of code
Date:   Fri, 11 Jun 2021 14:05:27 -0500
Message-Id: <20210611190529.3085813-7-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210611190529.3085813-1-elder@linaro.org>
References: <20210611190529.3085813-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rmnet_map_ipv6_dl_csum_trailer() there is an especially involved
line of code that determines the ones' complement sum of the IPv6
packet header (in host byte order).  Simplify that by storing the
result of computing just the header checksum in a local variable,
then using that in the original assignment.

Use the size of the IPv6 header structure as the number of bytes to
checksum, rather than computing the offset to the transport header.
And use ip_fast_csum() rather than ipa_compute_csum(), knowing that
the size of an IPv6 header (40 bytes) is a multiple of 4 bytes
greater than 16.

Add some comments to match rmnet_map_ipv4_dl_csum_trailer().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 26 ++++++++++++-------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 40d7e0c615f9c..4f93355e9a93a 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -120,27 +120,33 @@ rmnet_map_ipv6_dl_csum_trailer(struct sk_buff *skb,
 			       struct rmnet_map_dl_csum_trailer *csum_trailer,
 			       struct rmnet_priv *priv)
 {
-	__sum16 *csum_field, ip6_payload_csum, pseudo_csum, csum_temp;
+	struct ipv6hdr *ip6h = (struct ipv6hdr *)skb->data;
+	void *txporthdr = skb->data + sizeof(*ip6h);
+	__sum16 *csum_field, pseudo_csum, csum_temp;
 	u16 csum_value, csum_value_final;
 	__be16 ip6_hdr_csum, addend;
-	struct ipv6hdr *ip6h;
-	void *txporthdr;
+	__sum16 ip6_payload_csum;
+	__be16 ip_header_csum;
 	u32 length;
 
-	ip6h = (struct ipv6hdr *)(skb->data);
-
-	txporthdr = skb->data + sizeof(struct ipv6hdr);
+	/* Checksum offload is only supported for UDP and TCP protocols;
+	 * the packet cannot include any IPv6 extension headers
+	 */
 	csum_field = rmnet_map_get_csum_field(ip6h->nexthdr, txporthdr);
-
 	if (!csum_field) {
 		priv->stats.csum_err_invalid_transport++;
 		return -EPROTONOSUPPORT;
 	}
 
+	/* The checksum value in the trailer is computed over the entire
+	 * IP packet, including the IP header and payload.  To derive the
+	 * transport checksum from this, we first subract the contribution
+	 * of the IP header from the trailer checksum.  We then add the
+	 * checksum computed over the pseudo header.
+	 */
 	csum_value = ~ntohs(csum_trailer->csum_value);
-	ip6_hdr_csum = (__force __be16)
-			~ntohs((__force __be16)ip_compute_csum(ip6h,
-			       (int)(txporthdr - (void *)(skb->data))));
+	ip_header_csum = (__force __be16)ip_fast_csum(ip6h, sizeof(*ip6h) / 4);
+	ip6_hdr_csum = (__force __be16)~ntohs(ip_header_csum);
 	ip6_payload_csum = csum16_sub((__force __sum16)csum_value,
 				      ip6_hdr_csum);
 
-- 
2.27.0

