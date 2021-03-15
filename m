Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4318233C614
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 19:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbhCOSuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 14:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbhCOStf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 14:49:35 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5FBC06175F
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 11:49:35 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id d5so10362528iln.6
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 11:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dYz46nd8LxGdX7fvsu6maJR2XM9zulyZ7ppS5hOn0SA=;
        b=GLM4k0nd1Bu2JQTPV+3Is3ZBwQmMUM7EL0g1eCcX6kCEdhQXfspaPcdrW33QxPxq0R
         JjqeSAczLiFgq/GqqoJ6h5ln4ltkVAcjlUB4MEXzsgcEGTdRcWLacL0GfVwXzWcA8+F6
         1MtBnCWBA7T7CcSvNxExnyHGIdDoeAnPM7/fH68BEt/rCkb5Ov4PqqvqXQ7YZop/cIu4
         MpO+nADtMdw6KXaBuHrLAPj9e/ElyDiJ7rUKza7A7wrnIDW0zH9bBBcRpMl52uKNu/nL
         p9eblUJUamUe88VQ7yhdd8edLin4o78kGFPSwYg7ZDki6ekXG6YiofNCC8xES0L5T2Ft
         gI9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dYz46nd8LxGdX7fvsu6maJR2XM9zulyZ7ppS5hOn0SA=;
        b=hYpoivSxQPcmQt0BzNAp6f6fBEhI5OXB5gM0Z6I1g7Y7m5/Q5DIKSbQHRYJPJ4UAPk
         0AwZME3HA9VPB66EFVOVWMuzwmZWTKd0DxiPthA8pN8guopWb+6ICOXXW+hW+u6m2w/G
         jbgrRXnALfn7ilcHZN23XZwF33Jrt77/DaU9ZkOK/2DkHY4d9Lep2iwUE3oMN9TWD+Yi
         yFtUMo9QB4t90lXxzX9JjT7DD00LD05CanIqqBq4JexZZS8r5IzBGw26Qq8h8Bucrn9U
         9quDBokZgo+L32Ok7KnyAhHVKLAb7gSG3kbQrazJOUo4EFFMLjHEIhx+k1sHWdKnk5dT
         BXHQ==
X-Gm-Message-State: AOAM53252bFwh5jzU7mFZ9ijazlIKkEJnkFcxLpib2kajtdNe4iqH9YK
        exrNhWRwfGggZfTQcNyZZgJL5w==
X-Google-Smtp-Source: ABdhPJx0hxpr5Y6mZtZjZC1KpeigrU/YIn+UsMpYP8286jLLiUZisiW1Nn1i5s8cwkVgvVewqInmpg==
X-Received: by 2002:a92:c24a:: with SMTP id k10mr794970ilo.284.1615834174989;
        Mon, 15 Mar 2021 11:49:34 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id a5sm8212162ilk.14.2021.03.15.11.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 11:49:34 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        David.Laight@ACULAB.COM, olteanv@gmail.com,
        alexander.duyck@gmail.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v5 2/6] net: qualcomm: rmnet: simplify some byte order logic
Date:   Mon, 15 Mar 2021 13:49:24 -0500
Message-Id: <20210315184928.2913264-3-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210315184928.2913264-1-elder@linaro.org>
References: <20210315184928.2913264-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rmnet_map_ipv4_ul_csum_header() and rmnet_map_ipv6_ul_csum_header()
the offset within a packet at which checksumming should commence is
calculated.  This calculation involves byte swapping and a forced type
conversion that makes it hard to understand.

Simplify this by computing the offset in host byte order, then
converting the result when assigning it into the header field.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v5: - Use skb_network_header_len() to decide the checksum offset.

 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 21d38167f9618..0bfe69698b278 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -197,12 +197,10 @@ rmnet_map_ipv4_ul_csum_header(void *iphdr,
 			      struct rmnet_map_ul_csum_header *ul_header,
 			      struct sk_buff *skb)
 {
-	struct iphdr *ip4h = (struct iphdr *)iphdr;
-	__be16 *hdr = (__be16 *)ul_header, offset;
+	__be16 *hdr = (__be16 *)ul_header;
+	struct iphdr *ip4h = iphdr;
 
-	offset = htons((__force u16)(skb_transport_header(skb) -
-				     (unsigned char *)iphdr));
-	ul_header->csum_start_offset = offset;
+	ul_header->csum_start_offset = htons(skb_network_header_len(skb));
 	ul_header->csum_insert_offset = skb->csum_offset;
 	ul_header->csum_enabled = 1;
 	if (ip4h->protocol == IPPROTO_UDP)
@@ -239,12 +237,10 @@ rmnet_map_ipv6_ul_csum_header(void *ip6hdr,
 			      struct rmnet_map_ul_csum_header *ul_header,
 			      struct sk_buff *skb)
 {
-	struct ipv6hdr *ip6h = (struct ipv6hdr *)ip6hdr;
-	__be16 *hdr = (__be16 *)ul_header, offset;
+	__be16 *hdr = (__be16 *)ul_header;
+	struct ipv6hdr *ip6h = ip6hdr;
 
-	offset = htons((__force u16)(skb_transport_header(skb) -
-				     (unsigned char *)ip6hdr));
-	ul_header->csum_start_offset = offset;
+	ul_header->csum_start_offset = htons(skb_network_header_len(skb));
 	ul_header->csum_insert_offset = skb->csum_offset;
 	ul_header->csum_enabled = 1;
 
-- 
2.27.0

