Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730203A493A
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 21:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhFKTIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 15:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbhFKTHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 15:07:53 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F9EC0613A3
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:05:42 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id 5so32272439ioe.1
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5kMsHbtfUl/gFd/yKPF67UEpU7y0HdcT6eUdvozwYl4=;
        b=MR1UKLevxJ0kBzVEnTyu5RSMaakkR0f1eW2InUuTQl6S8weA9+LyD4n5klvNOOkdAk
         KXxZNAyQ+mSz2sLEQ0409GH41bWdynOnTn9QU+9G9dg+SkzEl8+fSAoH+j5GdG7DBBfX
         Q5i9tgrXWad6rzAAORb3I1/6kyHsZozQo1HfQ9ka09elIgsoFcg54LKw7AmG7b9K9rPi
         0opc9w1YzM7VvfpIwvDjAa2bxTLHHi2CVtZk4OPnpX579Oobxvu8LVRGxC/sRH5jVpiJ
         LRUnbQ782fVYla3Y6rhj32jeXXjra1TW7uCtkkDP+38YXGaYddgcc3Ozd31Yf+0leL1K
         YGkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5kMsHbtfUl/gFd/yKPF67UEpU7y0HdcT6eUdvozwYl4=;
        b=priMQyXlZJmt7f0hKTgsvRE+qtlLK4IQIlj92VvZJ+r/G6FD8g+RFivUKfR71DDE1m
         FdFP0IshKC0C5/J6P6kPHqLvOBjn4tWrNG1mbBdc/9xoubvkdTbSuelR9RLOVytoREC5
         7vWrhcLzxLfRYGIbEIGvhqk2igu+RDzDcs82OdRaLB/uQxVUGGIsjbMBS0ppLx7RKjFP
         cxISY18F12h2KjMNNG/fNL8Az3hQebdSyUJOHp93iooWbHiuuMkQq24FabXBvieVWVwe
         +d+Wl3Sf6EYqL9kx17w0EqQ8jF0UDBG791kyvZ/XI231kPtJ4G40GOluzKAj9zIHQ4dF
         YOaQ==
X-Gm-Message-State: AOAM533W9aBAkXhIq2P1JRZZIlycXGg2IdqaqT7KsBu0ea032760BMLv
        ZKoUNqImH9oilYseZI94jdlxYg==
X-Google-Smtp-Source: ABdhPJwPICaozry8HSVHveEIYhWk5Q+0pXygTkdgit/m1ogVK2Mo4kgkNoLRpHHT+0uw3Yt2JA3OFw==
X-Received: by 2002:a5d:8986:: with SMTP id m6mr4220177iol.87.1623438341965;
        Fri, 11 Jun 2021 12:05:41 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id p9sm3936566ilc.63.2021.06.11.12.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:05:41 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 8/8] net: qualcomm: rmnet: avoid unnecessary IPv6 byte-swapping
Date:   Fri, 11 Jun 2021 14:05:29 -0500
Message-Id: <20210611190529.3085813-9-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210611190529.3085813-1-elder@linaro.org>
References: <20210611190529.3085813-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the previous patch IPv4 download checksum offload code was
updated to avoid unnecessary byte swapping, based on properties of
the Internet checksum algorithm.  This patch makes comparable
changes to the IPv6 download checksum offload handling.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c    | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 39f198d7595bd..d4d23ab446ef5 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -123,10 +123,11 @@ rmnet_map_ipv6_dl_csum_trailer(struct sk_buff *skb,
 	struct ipv6hdr *ip6h = (struct ipv6hdr *)skb->data;
 	void *txporthdr = skb->data + sizeof(*ip6h);
 	__sum16 *csum_field, pseudo_csum, csum_temp;
-	u16 csum_value, csum_value_final;
 	__be16 ip6_hdr_csum, addend;
 	__sum16 ip6_payload_csum;
 	__be16 ip_header_csum;
+	u16 csum_value_final;
+	__be16 csum_value;
 	u32 length;
 
 	/* Checksum offload is only supported for UDP and TCP protocols;
@@ -144,21 +145,21 @@ rmnet_map_ipv6_dl_csum_trailer(struct sk_buff *skb,
 	 * of the IP header from the trailer checksum.  We then add the
 	 * checksum computed over the pseudo header.
 	 */
-	csum_value = ~ntohs(csum_trailer->csum_value);
+	csum_value = ~csum_trailer->csum_value;
 	ip_header_csum = (__force __be16)ip_fast_csum(ip6h, sizeof(*ip6h) / 4);
-	ip6_hdr_csum = (__force __be16)~ntohs(ip_header_csum);
+	ip6_hdr_csum = (__force __be16)~ip_header_csum;
 	ip6_payload_csum = csum16_sub((__force __sum16)csum_value,
 				      ip6_hdr_csum);
 
 	length = (ip6h->nexthdr == IPPROTO_UDP) ?
 		 ntohs(((struct udphdr *)txporthdr)->len) :
 		 ntohs(ip6h->payload_len);
-	pseudo_csum = ~(csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
-			     length, ip6h->nexthdr, 0));
-	addend = (__force __be16)ntohs((__force __be16)pseudo_csum);
+	pseudo_csum = ~csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
+				       length, ip6h->nexthdr, 0);
+	addend = (__force __be16)pseudo_csum;
 	pseudo_csum = csum16_add(ip6_payload_csum, addend);
 
-	addend = (__force __be16)ntohs((__force __be16)*csum_field);
+	addend = (__force __be16)*csum_field;
 	csum_temp = ~csum16_sub(pseudo_csum, addend);
 	csum_value_final = (__force u16)csum_temp;
 
@@ -179,7 +180,7 @@ rmnet_map_ipv6_dl_csum_trailer(struct sk_buff *skb,
 		}
 	}
 
-	if (csum_value_final == ntohs((__force __be16)*csum_field)) {
+	if (csum_value_final == (__force u16)*csum_field) {
 		priv->stats.csum_ok++;
 		return 0;
 	} else {
-- 
2.27.0

