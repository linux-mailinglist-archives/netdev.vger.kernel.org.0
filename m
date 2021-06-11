Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE553A4940
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 21:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbhFKTIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 15:08:44 -0400
Received: from mail-io1-f54.google.com ([209.85.166.54]:39766 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbhFKTIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 15:08:37 -0400
Received: by mail-io1-f54.google.com with SMTP id f10so17760795iok.6
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qBoOhTYQId0ccnEylChHcGfk116nSyfqpAW9wezghK8=;
        b=fluZkObbAwxjzfggtAFSEfH6l9SfdNUXLwdjm3E25/LJNtHCbwMS9cm9iOeGvVuQGd
         q2HP3mjREoBDi7sxLcUpKK5xGbphnh1xqn+bdWJ2gYVeiqTT9Yg4xQu9uCDYept+wqqm
         xd19RwOKk3T2sKeoGXX0+ZHp1o9CZRXAZPULUWBgi08qTTmfPi2iBmLGODkZtmjHzMHi
         ymt1LLiOhKf3l8x5of51uLvUZjMwmcYXdHnjpT3an+a8JvJWSHsBYrHGyo/eMNLqUYU6
         2fa2U4i41TpjEw+lJbNGRHfXUR8o6m51PN7oE9UDJrGcZXVWmoEZt0w4mDeF7mtnk3oM
         rAtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qBoOhTYQId0ccnEylChHcGfk116nSyfqpAW9wezghK8=;
        b=gEziM1vl4IIM6HxRIEBuJzXBKbB7JXfVKHPbfECIWlSimWGIrqTNA+AZgZvZ3Jlc+/
         cAInBYLuok9ixmefjlpMkuCp6v6eQTzbVsbAThud4chn0+DJFaCdiOFCzF247f0EuVto
         JyYchdlT266/K2BdLQb71pAaDDlDeGyDZmaXcwo7Z2YUdla6h3zoYYT2BSrcF/7fwORv
         MLu4cNQYaWwPUcad9I9quRXYbWcOtIthFvnbBFay4lqOGszKiGuWSjgJPq+cX/w2BnSQ
         bWCEfdo5fjdugUd4vKglISnDlXodFMAPFAKXKgrsrtMlWJLjNuyPa0P62/u31jVwyCDG
         3KSw==
X-Gm-Message-State: AOAM530W9Y6OUTFX/IieLPR2w+jPmFbvpy2xTa4GIJKS4/XJHZvusVhu
        Jq4bhQ/n64KIfUz4xCUb7NMpqQ==
X-Google-Smtp-Source: ABdhPJwjvTm602BhsEYqf0UXIR5pDQm9j1qSWFPFNCssHxjJj8B7O5KHq8FzxQopoUOMKRTlYZ00hQ==
X-Received: by 2002:a05:6602:2143:: with SMTP id y3mr4364865ioy.89.1623438339234;
        Fri, 11 Jun 2021 12:05:39 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id p9sm3936566ilc.63.2021.06.11.12.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:05:38 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/8] net: qualcomm: rmnet: IPv4 header has zero checksum
Date:   Fri, 11 Jun 2021 14:05:26 -0500
Message-Id: <20210611190529.3085813-6-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210611190529.3085813-1-elder@linaro.org>
References: <20210611190529.3085813-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rmnet_map_ipv4_dl_csum_trailer(), an illegal checksum subtraction
is done, subtracting hdr_csum (in host byte order) from csum_value (in
network byte order).  Despite being illegal, it generally works,
because it turns out the value subtracted is (or should be) always 0,
which has the same representation in either byte order.

Doing illegal operations is not good form though, so fix this by
verifying the IP header checksum early in that function.  If its
checksum is non-zero, the packet will be bad, so just return an
error.  This will cause the packet to passed to the IP layer where
it can be dropped.

Thereafter, there is no need subtract the IP header checksum from
the checksum value in the trailer because we know it is zero.
Add a comment explaining this.

This type of packet error is different from other types, so add a
new statistics counter to track this condition.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 .../ethernet/qualcomm/rmnet/rmnet_config.h    |  1 +
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 41 ++++++++++++-------
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |  1 +
 3 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
index 8e64ca98068d9..3d3cba56c5169 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
@@ -49,6 +49,7 @@ struct rmnet_pcpu_stats {
 
 struct rmnet_priv_stats {
 	u64 csum_ok;
+	u64 csum_ip4_header_bad;
 	u64 csum_valid_unset;
 	u64 csum_validation_failed;
 	u64 csum_err_bad_buffer;
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 79f1d516b5cca..40d7e0c615f9c 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -33,13 +33,21 @@ rmnet_map_ipv4_dl_csum_trailer(struct sk_buff *skb,
 			       struct rmnet_map_dl_csum_trailer *csum_trailer,
 			       struct rmnet_priv *priv)
 {
-	__sum16 *csum_field, csum_temp, pseudo_csum, hdr_csum, ip_payload_csum;
-	u16 csum_value, csum_value_final;
-	struct iphdr *ip4h;
-	void *txporthdr;
+	struct iphdr *ip4h = (struct iphdr *)skb->data;
+	void *txporthdr = skb->data + ip4h->ihl * 4;
+	__sum16 *csum_field, csum_temp, pseudo_csum;
+	__sum16 ip_payload_csum;
+	u16 csum_value_final;
 	__be16 addend;
 
-	ip4h = (struct iphdr *)(skb->data);
+	/* Computing the checksum over just the IPv4 header--including its
+	 * checksum field--should yield 0.  If it doesn't, the IP header
+	 * is bad, so return an error and let the IP layer drop it.
+	 */
+	if (ip_fast_csum(ip4h, ip4h->ihl)) {
+		priv->stats.csum_ip4_header_bad++;
+		return -EINVAL;
+	}
 
 	/* We don't support checksum offload on IPv4 fragments */
 	if (ip_is_fragment(ip4h)) {
@@ -47,25 +55,30 @@ rmnet_map_ipv4_dl_csum_trailer(struct sk_buff *skb,
 		return -EOPNOTSUPP;
 	}
 
-	txporthdr = skb->data + ip4h->ihl * 4;
-
+	/* Checksum offload is only supported for UDP and TCP protocols */
 	csum_field = rmnet_map_get_csum_field(ip4h->protocol, txporthdr);
-
 	if (!csum_field) {
 		priv->stats.csum_err_invalid_transport++;
 		return -EPROTONOSUPPORT;
 	}
 
-	/* RFC 768 - Skip IPv4 UDP packets where sender checksum field is 0 */
-	if (*csum_field == 0 && ip4h->protocol == IPPROTO_UDP) {
+	/* RFC 768: UDP checksum is optional for IPv4, and is 0 if unused */
+	if (!*csum_field && ip4h->protocol == IPPROTO_UDP) {
 		priv->stats.csum_skipped++;
 		return 0;
 	}
 
-	csum_value = ~ntohs(csum_trailer->csum_value);
-	hdr_csum = ~ip_fast_csum(ip4h, (int)ip4h->ihl);
-	ip_payload_csum = csum16_sub((__force __sum16)csum_value,
-				     (__force __be16)hdr_csum);
+	/* The checksum value in the trailer is computed over the entire
+	 * IP packet, including the IP header and payload.  To derive the
+	 * transport checksum from this, we first subract the contribution
+	 * of the IP header from the trailer checksum.  We then add the
+	 * checksum computed over the pseudo header.
+	 *
+	 * We verified above that the IP header contributes zero to the
+	 * trailer checksum.  Therefore the checksum in the trailer is
+	 * just the checksum computed over the IP payload.
+	 */
+	ip_payload_csum = (__force __sum16)~ntohs(csum_trailer->csum_value);
 
 	pseudo_csum = ~csum_tcpudp_magic(ip4h->saddr, ip4h->daddr,
 					 ntohs(ip4h->tot_len) - ip4h->ihl * 4,
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index fe13017e9a41e..6556b5381ce85 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -166,6 +166,7 @@ static const struct net_device_ops rmnet_vnd_ops = {
 
 static const char rmnet_gstrings_stats[][ETH_GSTRING_LEN] = {
 	"Checksum ok",
+	"Bad IPv4 header checksum",
 	"Checksum valid bit not set",
 	"Checksum validation failed",
 	"Checksum error bad buffer",
-- 
2.27.0

