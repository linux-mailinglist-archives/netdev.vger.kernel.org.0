Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177AE3A4F46
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 16:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbhFLOjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 10:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbhFLOjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 10:39:43 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B366CC0617AF
        for <netdev@vger.kernel.org>; Sat, 12 Jun 2021 07:37:43 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id b14so8145475ilq.7
        for <netdev@vger.kernel.org>; Sat, 12 Jun 2021 07:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zqP3IpX5KiQhhBmq87TLRiNjOJuyARey26hrbTcZL4g=;
        b=YN2AbRlAhsPS28DfKh+3EBOg+vNu9MCYfZ/Px/yQYsbPwaareJ5ft5GitViE0CiXnH
         V1o3G16d5IZIEdRoV9rThJDOF2DHtT6D2gKMUXm0FqqFFLCEQ2MrOcVFYz2kSbPl7uVg
         ssW3xE1TMHYEkcLaK2Plxbx6Kw1uv14O3BRXpnmJCpeMRMbpR9LWCHz8CmzYV6j7r5Ei
         52I5x0btjz0dLoJjrkk6FgL8WpOwj6eOxJhwQrHmI7BRLNYS9ThF4C3oYC0JWv/xeg8r
         zmT1PFPxctNvgCKOeYfpb5QCWDpH6Jp/1C1TxxWYCLOZjSxhzl7ezwbLoi3NMjupeiBN
         jHuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zqP3IpX5KiQhhBmq87TLRiNjOJuyARey26hrbTcZL4g=;
        b=pGv4E/QSfvHnfFNBXRKogJ+lNrrDMvlUqbmreGibFtZRlCTno6OQtlAqZJBuSy2fQh
         dQgR12sxvyMQSX/Z6WFcm88vEyVZ+slddmU2NqOJOuonScojNbQo3wBII1B6Rdnrn1vO
         d9YaLPhGq6U9Z6o6GctE5W38wgzqncjm7O5TDm4tFrEjiVOMZbBkLe0+2UBmO+BEUpBh
         MvGd8+x5AAsFjNzKHiSGEvIyIFwZ8/4BrinwqZ7ae17vaTArEUIx14k+2OisczEYhPWl
         9Vw9BQ7dpDc7ozY4061fiDidTn+BOToVY7ROr/qo50rkOPFtVKPPiCYsrd4AfD1EiTyL
         f6cQ==
X-Gm-Message-State: AOAM532s8Qd9XQ9HTmKfmORUzzMeqVh+5y2Fh2OBpTcjhLJB/pJfi25Z
        3/QML1o7noLVDLJyNKluZn+xAA==
X-Google-Smtp-Source: ABdhPJzmaBqVA0LpY/Jq90qug0Mzn4wc3+2ImXe4zBXj58V+wt0HoWqhu9E8TD+ISN72yqM9E6yvmQ==
X-Received: by 2002:a05:6e02:66e:: with SMTP id l14mr7195684ilt.211.1623508663139;
        Sat, 12 Jun 2021 07:37:43 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id k4sm5126559ior.55.2021.06.12.07.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Jun 2021 07:37:42 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/8] net: qualcomm: rmnet: return earlier for bad checksum
Date:   Sat, 12 Jun 2021 09:37:32 -0500
Message-Id: <20210612143736.3498712-5-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210612143736.3498712-1-elder@linaro.org>
References: <20210612143736.3498712-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rmnet_map_ipv4_dl_csum_trailer(), if the sum of the trailer
checksum and the pseudo checksum is non-zero, checksum validation
has failed.  We can return an error as soon as we know that.

We can do the same thing in rmnet_map_ipv6_dl_csum_trailer().

Add some comments that explain where we're headed.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 36 ++++++++++++++-----
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 51909b8fa8a80..a05124eb8602e 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -76,6 +76,17 @@ rmnet_map_ipv4_dl_csum_trailer(struct sk_buff *skb,
 	 * We verified above that the IP header contributes zero to the
 	 * trailer checksum.  Therefore the checksum in the trailer is
 	 * just the checksum computed over the IP payload.
+
+	 * If the IP payload arrives intact, adding the pseudo header
+	 * checksum to the IP payload checksum will yield 0xffff (negative
+	 * zero).  This means the trailer checksum and the pseudo checksum
+	 * are additive inverses of each other.  Put another way, the
+	 * message passes the checksum test if the trailer checksum value
+	 * is the negated pseudo header checksum.
+	 *
+	 * Knowing this, we don't even need to examine the transport
+	 * header checksum value; it is already accounted for in the
+	 * checksum value found in the trailer.
 	 */
 	ip_payload_csum = (__force __sum16)~csum_trailer->csum_value;
 
@@ -84,11 +95,11 @@ rmnet_map_ipv4_dl_csum_trailer(struct sk_buff *skb,
 					 ip4h->protocol, 0);
 	pseudo_csum = csum16_add(ip_payload_csum, (__force __be16)pseudo_csum);
 
-	/* The trailer checksum *includes* the checksum in the transport
-	 * header.  Adding that to the pseudo checksum will yield 0xffff
-	 * ("negative 0") if the message arrived intact.
-	 */
-	WARN_ON((__sum16)~pseudo_csum);
+	/* The cast is required to ensure only the low 16 bits are examined */
+	if ((__sum16)~pseudo_csum) {
+		priv->stats.csum_validation_failed++;
+		return -EINVAL;
+	}
 	csum_value_final = ~csum16_sub(pseudo_csum, (__force __be16)*csum_field);
 
 	if (unlikely(!csum_value_final)) {
@@ -143,6 +154,11 @@ rmnet_map_ipv6_dl_csum_trailer(struct sk_buff *skb,
 	 * transport checksum from this, we first subract the contribution
 	 * of the IP header from the trailer checksum.  We then add the
 	 * checksum computed over the pseudo header.
+	 *
+	 * It's sufficient to compare the IP payload checksum with the
+	 * negated pseudo checksum to determine whether the packet
+	 * checksum was good.  (See further explanation in comments
+	 * in rmnet_map_ipv4_dl_csum_trailer()).
 	 */
 	ip_header_csum = (__force __be16)ip_fast_csum(ip6h, sizeof(*ip6h) / 4);
 	ip6_payload_csum = ~csum16_sub((__force __sum16)csum_trailer->csum_value,
@@ -155,10 +171,12 @@ rmnet_map_ipv6_dl_csum_trailer(struct sk_buff *skb,
 				       length, ip6h->nexthdr, 0);
 	pseudo_csum = csum16_add(ip6_payload_csum, (__force __be16)pseudo_csum);
 
-	/* Adding the payload checksum to the pseudo checksum yields 0xffff
-	 * ("negative 0") if the message arrived intact.
-	 */
-	WARN_ON((__sum16)~pseudo_csum);
+	/* The cast is required to ensure only the low 16 bits are examined */
+	if ((__sum16)~pseudo_csum) {
+		priv->stats.csum_validation_failed++;
+		return -EINVAL;
+	}
+
 	csum_value_final = ~csum16_sub(pseudo_csum, (__force __be16)*csum_field);
 
 	if (unlikely(csum_value_final == 0)) {
-- 
2.27.0

