Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3DD73A4943
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 21:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhFKTIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 15:08:49 -0400
Received: from mail-io1-f43.google.com ([209.85.166.43]:41711 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbhFKTIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 15:08:46 -0400
Received: by mail-io1-f43.google.com with SMTP id p66so30415430iod.8
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xQ8UF2rlnCWAYB0xLk3oBUl3NTh+oujcDIz3DNhAnpo=;
        b=UEMHF8P4VjbABDccJ6fPGtQSycydNVCzERiATqZHKB3FvCpPL6shlgBesVFL20Ki4i
         F9Nt3Je/Nv4mQO+svBJ1lnp+QUyhsl09QJeyRJ1xk3UjfadTuRSl7kyTcgBqx0MIRNdy
         vxCpt9BMo24/TY8unkCpNbOwY3g0NB5y/5/CqoaWyXDvvRC0e4iA6Tmt03dnAzcNIJLa
         MEInNRmsYKefLFJ7Wlmk4NxstzMbBQDAbqS9inzz4+EJlBvgiwt6SwHKNGi9kX3nomMu
         xibfEYUzWXnhjCfZk6fSfQOF2RWjyeJ6O024DAnPFyApSkj9Bn2JPr3FjjyE+IOq/l1V
         wMwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xQ8UF2rlnCWAYB0xLk3oBUl3NTh+oujcDIz3DNhAnpo=;
        b=C2Zw68Oa8j2EhsM7KNfKJ6/2rnWHfgWqoA6GXRszHnqZ7eW99arLnhgzDRgWvPaD91
         F0rHXMj8GpeqYSdGif92l7SF3oiX1ZLcYBdchkALfjtxwOQs6sgZQDE6XO14t9tGEciq
         QJZ/rf0qOeS7qqaLkyyGxr0wy4Ghv3i0mtSpWZnSUlQTqrpz1nhUcj/WPK8KD0XWaL62
         S4Mdne2rgpLLmk1QCtUmlR97LoIT+YuPrWbSRUuPaHRr+jTQkvQvJOxF+OuFoN6Z/Aj7
         7xmXs8yCAzYR9/RLWXrD0djGIfjnxuVNIYNsLovMWCxgiGPqjYWId17JQoXXqnM91Sml
         C+1w==
X-Gm-Message-State: AOAM532QcdAbZG6WhnuNu9mn9KfVULEDhHQYbAAtv9Z2gKQizIni/RyA
        R0tuJHVIO1hTLBqrVQXCy4M3XQ==
X-Google-Smtp-Source: ABdhPJyOFHRdLIjpbk1Yd8ilavoGTZ44/rLxxqkxDU0akZF5hUdowaN50j3y4dtTHTS47KEh3k/3TA==
X-Received: by 2002:a05:6638:1602:: with SMTP id x2mr5241197jas.130.1623438336455;
        Fri, 11 Jun 2021 12:05:36 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id p9sm3936566ilc.63.2021.06.11.12.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:05:36 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/8] net: qualcomm: rmnet: eliminate some ifdefs
Date:   Fri, 11 Jun 2021 14:05:23 -0500
Message-Id: <20210611190529.3085813-3-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210611190529.3085813-1-elder@linaro.org>
References: <20210611190529.3085813-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If IPV6 is not enabled in the kernel configuration, the RMNet
checksum code indicates a buffer containing an IPv6 packet is not
supported.  The same thing happens if a buffer contains something
other than an IPv4 or IPv6 packet.

We can rearrange things a bit in two functions so that some #ifdef
calls can simply be eliminated.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 54 ++++++++-----------
 1 file changed, 23 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 34bd1a98a1015..b8e504ac7fb1e 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -431,21 +431,15 @@ int rmnet_map_checksum_downlink_packet(struct sk_buff *skb, u16 len)
 		return -EINVAL;
 	}
 
-	if (skb->protocol == htons(ETH_P_IP)) {
+	if (skb->protocol == htons(ETH_P_IP))
 		return rmnet_map_ipv4_dl_csum_trailer(skb, csum_trailer, priv);
-	} else if (skb->protocol == htons(ETH_P_IPV6)) {
-#if IS_ENABLED(CONFIG_IPV6)
+
+	if (IS_ENABLED(CONFIG_IPV6) && skb->protocol == htons(ETH_P_IPV6))
 		return rmnet_map_ipv6_dl_csum_trailer(skb, csum_trailer, priv);
-#else
-		priv->stats.csum_err_invalid_ip_version++;
-		return -EPROTONOSUPPORT;
-#endif
-	} else {
-		priv->stats.csum_err_invalid_ip_version++;
-		return -EPROTONOSUPPORT;
-	}
 
-	return 0;
+	priv->stats.csum_err_invalid_ip_version++;
+
+	return -EPROTONOSUPPORT;
 }
 
 static void rmnet_map_v4_checksum_uplink_packet(struct sk_buff *skb,
@@ -462,28 +456,26 @@ static void rmnet_map_v4_checksum_uplink_packet(struct sk_buff *skb,
 		     (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM))))
 		goto sw_csum;
 
-	if (skb->ip_summed == CHECKSUM_PARTIAL) {
-		iphdr = (char *)ul_header +
-			sizeof(struct rmnet_map_ul_csum_header);
+	if (skb->ip_summed != CHECKSUM_PARTIAL)
+		goto sw_csum;
 
-		if (skb->protocol == htons(ETH_P_IP)) {
-			rmnet_map_ipv4_ul_csum_header(iphdr, ul_header, skb);
-			priv->stats.csum_hw++;
-			return;
-		} else if (skb->protocol == htons(ETH_P_IPV6)) {
-#if IS_ENABLED(CONFIG_IPV6)
-			rmnet_map_ipv6_ul_csum_header(iphdr, ul_header, skb);
-			priv->stats.csum_hw++;
-			return;
-#else
-			priv->stats.csum_err_invalid_ip_version++;
-			goto sw_csum;
-#endif
-		} else {
-			priv->stats.csum_err_invalid_ip_version++;
-		}
+	iphdr = (char *)ul_header +
+		sizeof(struct rmnet_map_ul_csum_header);
+
+	if (skb->protocol == htons(ETH_P_IP)) {
+		rmnet_map_ipv4_ul_csum_header(iphdr, ul_header, skb);
+		priv->stats.csum_hw++;
+		return;
+	}
+
+	if (IS_ENABLED(CONFIG_IPV6) && skb->protocol == htons(ETH_P_IPV6)) {
+		rmnet_map_ipv6_ul_csum_header(iphdr, ul_header, skb);
+		priv->stats.csum_hw++;
+		return;
 	}
 
+	priv->stats.csum_err_invalid_ip_version++;
+
 sw_csum:
 	memset(ul_header, 0, sizeof(*ul_header));
 
-- 
2.27.0

