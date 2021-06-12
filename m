Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB7B3A4F4C
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 16:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbhFLOko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 10:40:44 -0400
Received: from mail-io1-f52.google.com ([209.85.166.52]:39724 "EHLO
        mail-io1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbhFLOkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 10:40:43 -0400
Received: by mail-io1-f52.google.com with SMTP id f10so20205516iok.6
        for <netdev@vger.kernel.org>; Sat, 12 Jun 2021 07:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DOiPwYtlpq2wzQJGSlttEKAlIzdpjRtakSuJWMKMdzU=;
        b=CQ3PfHIBoocPGBgi9mEMxvVt4UtAdr8escdEWJoT+CT1qDbAUTWY6U+wg0zhi8DE14
         IZS9logweGEFTcfVXiGalKYfHe48WmdKDJZVRvsrag5crzT/1y85Kwmez+LkdmUPSEYU
         hNkAqfRa85i+8GUlsB5yfxyYpeN7fHzIV4rnyQ/T6BsfLE0YO9boKQ05XVN80xueJZOu
         dAOLjJXIozl1G4s7DcwoByuXB0ihzZHXgP/4OutTULb91AjbUKxuBGbg/te/414CqOe5
         XiIRgeT8H2F+5I/2eKteEJj4MRpt5QYPT5Tuh7k6Y9QuSDq1sAJtKZNkGdI+ZmT1yILf
         vOSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DOiPwYtlpq2wzQJGSlttEKAlIzdpjRtakSuJWMKMdzU=;
        b=XQscw8KKdkZ5vK0dg6cZ67ZAiqnLmHbCMcIZM44bNXXR1Wrdfdie6QehvXx/aCA8+i
         38YxsRzI0BpDH0d1VwVHpMrGcweHipFzFXW9JwNoLfsQF30mWhOCw+qGsxajWGaoukGn
         x88iOFALPXy5bS8KrxTEHtkfPnfdNb9mpCh4gP4GAJ3VNoHUidLJRy5NsaV8pl2E9ur/
         mCN5sOAi+ycvkUTbF1kRE+1O0BDJb6cZrzqJuV58ycQ/UsN5wg/SkeKUDm+PlgqK3Cu6
         +dEucg+kLwA+nRXH4ZOYBDcBUcxb+yP/UQ7O4QB2FGGAPB3dFb9e/DLp8S2Eqg5hU7yk
         KYgQ==
X-Gm-Message-State: AOAM532XXFsrfeVZ/spcCkX9JjkMJer0UupdNY5Jrg8NulWe1HNM5GM8
        Vv1p3okb8H86RhX9GZc61wGK2g==
X-Google-Smtp-Source: ABdhPJy1Wqmi1a5LRik+J50bOeEGSAxVrCMnvKZzICc2rwMRntdaSLm5qwM9gu1IS+Mn8tlvUh4OSA==
X-Received: by 2002:a6b:f41a:: with SMTP id i26mr7289471iog.162.1623508664042;
        Sat, 12 Jun 2021 07:37:44 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id k4sm5126559ior.55.2021.06.12.07.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Jun 2021 07:37:43 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/8] net: qualcomm: rmnet: remove unneeded code
Date:   Sat, 12 Jun 2021 09:37:33 -0500
Message-Id: <20210612143736.3498712-6-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210612143736.3498712-1-elder@linaro.org>
References: <20210612143736.3498712-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous patch makes rmnet_map_ipv4_dl_csum_trailer() return
early with an error if it is determined that the computed checksum
for the IP payload does not match what was expected.

If the computed checksum *does* match the expected value, the IP
payload (i.e., the transport message), can be considered good.
There is no need to do any further processing of the message.

This means a big block of code is unnecessary for validating the
transport checksum value, and can be removed.

Make comparable changes in rmnet_map_ipv6_dl_csum_trailer().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 75 ++++---------------
 1 file changed, 14 insertions(+), 61 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index a05124eb8602e..033b8ad3d7356 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -37,7 +37,6 @@ rmnet_map_ipv4_dl_csum_trailer(struct sk_buff *skb,
 	void *txporthdr = skb->data + ip4h->ihl * 4;
 	__sum16 *csum_field, pseudo_csum;
 	__sum16 ip_payload_csum;
-	__sum16 csum_value_final;
 
 	/* Computing the checksum over just the IPv4 header--including its
 	 * checksum field--should yield 0.  If it doesn't, the IP header
@@ -93,37 +92,15 @@ rmnet_map_ipv4_dl_csum_trailer(struct sk_buff *skb,
 	pseudo_csum = ~csum_tcpudp_magic(ip4h->saddr, ip4h->daddr,
 					 ntohs(ip4h->tot_len) - ip4h->ihl * 4,
 					 ip4h->protocol, 0);
-	pseudo_csum = csum16_add(ip_payload_csum, (__force __be16)pseudo_csum);
 
 	/* The cast is required to ensure only the low 16 bits are examined */
-	if ((__sum16)~pseudo_csum) {
+	if (ip_payload_csum != (__sum16)~pseudo_csum) {
 		priv->stats.csum_validation_failed++;
 		return -EINVAL;
 	}
-	csum_value_final = ~csum16_sub(pseudo_csum, (__force __be16)*csum_field);
 
-	if (unlikely(!csum_value_final)) {
-		switch (ip4h->protocol) {
-		case IPPROTO_UDP:
-			/* RFC 768 - DL4 1's complement rule for UDP csum 0 */
-			csum_value_final = ~csum_value_final;
-			break;
-
-		case IPPROTO_TCP:
-			/* DL4 Non-RFC compliant TCP checksum found */
-			if (*csum_field == (__force __sum16)0xFFFF)
-				csum_value_final = ~csum_value_final;
-			break;
-		}
-	}
-
-	if (csum_value_final == *csum_field) {
-		priv->stats.csum_ok++;
-		return 0;
-	} else {
-		priv->stats.csum_validation_failed++;
-		return -EINVAL;
-	}
+	priv->stats.csum_ok++;
+	return 0;
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -137,7 +114,6 @@ rmnet_map_ipv6_dl_csum_trailer(struct sk_buff *skb,
 	__sum16 *csum_field, pseudo_csum;
 	__sum16 ip6_payload_csum;
 	__be16 ip_header_csum;
-	__sum16 csum_value_final;
 	u32 length;
 
 	/* Checksum offload is only supported for UDP and TCP protocols;
@@ -154,11 +130,6 @@ rmnet_map_ipv6_dl_csum_trailer(struct sk_buff *skb,
 	 * transport checksum from this, we first subract the contribution
 	 * of the IP header from the trailer checksum.  We then add the
 	 * checksum computed over the pseudo header.
-	 *
-	 * It's sufficient to compare the IP payload checksum with the
-	 * negated pseudo checksum to determine whether the packet
-	 * checksum was good.  (See further explanation in comments
-	 * in rmnet_map_ipv4_dl_csum_trailer()).
 	 */
 	ip_header_csum = (__force __be16)ip_fast_csum(ip6h, sizeof(*ip6h) / 4);
 	ip6_payload_csum = ~csum16_sub((__force __sum16)csum_trailer->csum_value,
@@ -169,40 +140,22 @@ rmnet_map_ipv6_dl_csum_trailer(struct sk_buff *skb,
 		 ntohs(ip6h->payload_len);
 	pseudo_csum = ~csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
 				       length, ip6h->nexthdr, 0);
-	pseudo_csum = csum16_add(ip6_payload_csum, (__force __be16)pseudo_csum);
 
-	/* The cast is required to ensure only the low 16 bits are examined */
-	if ((__sum16)~pseudo_csum) {
+	/* It's sufficient to compare the IP payload checksum with the
+	 * negated pseudo checksum to determine whether the packet
+	 * checksum was good.  (See further explanation in comments
+	 * in rmnet_map_ipv4_dl_csum_trailer()).
+	 *
+	 * The cast is required to ensure only the low 16 bits are
+	 * examined.
+	 */
+	if (ip6_payload_csum != (__sum16)~pseudo_csum) {
 		priv->stats.csum_validation_failed++;
 		return -EINVAL;
 	}
 
-	csum_value_final = ~csum16_sub(pseudo_csum, (__force __be16)*csum_field);
-
-	if (unlikely(csum_value_final == 0)) {
-		switch (ip6h->nexthdr) {
-		case IPPROTO_UDP:
-			/* RFC 2460 section 8.1
-			 * DL6 One's complement rule for UDP checksum 0
-			 */
-			csum_value_final = ~csum_value_final;
-			break;
-
-		case IPPROTO_TCP:
-			/* DL6 Non-RFC compliant TCP checksum found */
-			if (*csum_field == (__force __sum16)0xFFFF)
-				csum_value_final = ~csum_value_final;
-			break;
-		}
-	}
-
-	if (csum_value_final == *csum_field) {
-		priv->stats.csum_ok++;
-		return 0;
-	} else {
-		priv->stats.csum_validation_failed++;
-		return -EINVAL;
-	}
+	priv->stats.csum_ok++;
+	return 0;
 }
 #endif
 
-- 
2.27.0

