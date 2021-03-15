Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4380433B4A6
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 14:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhCONfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 09:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbhCONfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 09:35:01 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9F2C06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 06:35:01 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id y20so15012708iot.4
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 06:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cYtxP12FPoFyXStxU+dIm5i6FSzaCM643MO9iKA6Wx4=;
        b=T8zJlH3c6GJ1K6qfFZW0U97MtWrn/qHAzbfHZ/iCc/n2mu/eSy2SQE8pcVzT4POyNt
         m6sxGdWtlxGKqvHVz2Sl60+dhjGEE7qQBkCAtjZOkoLCdZ4Dh/HM9/y6042PWF3CjibI
         yR0lBUob5tYA8EkbkFfiNfRVuiiUjmOw+l0VX2Te4FJVvPeDpAr1djgtKOQ3orLpWxOf
         UZkUjTYYLAfjsLv7Rr/Gy3D44oad+rD19Cd86zXLVuAmlaO+WdYAvfDV94WQA/drIB0R
         QdzZqs8+u6BTTVv3uNCibqWdnW1rA2qPg2JeyeTSoXnXsn3ZT874/Mx88eMt6Q/s+PGt
         RwlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cYtxP12FPoFyXStxU+dIm5i6FSzaCM643MO9iKA6Wx4=;
        b=aqXE63H0HJihu3VwYXyK4DRuwzmou4R+akna8OAIPY5v40VthWCTYhmF0FpwMn3uyu
         yxOsfwgnPhc8yeW/Z9nA/tK4Is8nirEjGzpBuEB3PEarYv//Jb91zAya3mOsKxqtHaNy
         ChfGFlFpW5nuSObmattbS8P930L/VjBqnJHxMYGufRdOHsP8eeu90sMswsCnJkr3UdpD
         cfSkZ4U1h/Zg9k54diKMi0+GOcq1ePTm5qxhqiOssJ90u/zXXakgkshg7CEKWxDJXCJi
         ou+9uUPHvwzsMPgDILmGD55/c8rCYY4X5oUTDH/9F1OyYeEpzXQgWpjMi9TnJ0G060ZU
         VnUw==
X-Gm-Message-State: AOAM530nT8gwE/Y9x/uyDTExLCsoIeaT9D6vvuPcTvi5tVdSBCLlFt4j
        cvIx8oMOwQgZ4xWn66aL3c3Hlg==
X-Google-Smtp-Source: ABdhPJwmQ1ZUCcxsgli8gUf4WZtO/WxOYjNNLJvJHU67yk3IEV0rVt4BxbMPC2qQ2/bogntrtoSQYg==
X-Received: by 2002:a02:cbb2:: with SMTP id v18mr9526215jap.4.1615815301232;
        Mon, 15 Mar 2021 06:35:01 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o23sm7127672ioo.24.2021.03.15.06.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 06:35:00 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        David.Laight@ACULAB.COM, olteanv@gmail.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v4 2/6] net: qualcomm: rmnet: simplify some byte order logic
Date:   Mon, 15 Mar 2021 08:34:51 -0500
Message-Id: <20210315133455.1576188-3-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210315133455.1576188-1-elder@linaro.org>
References: <20210315133455.1576188-1-elder@linaro.org>
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
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 22 ++++++++++---------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 21d38167f9618..bd1aa11c9ce59 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -197,12 +197,13 @@ rmnet_map_ipv4_ul_csum_header(void *iphdr,
 			      struct rmnet_map_ul_csum_header *ul_header,
 			      struct sk_buff *skb)
 {
-	struct iphdr *ip4h = (struct iphdr *)iphdr;
-	__be16 *hdr = (__be16 *)ul_header, offset;
+	__be16 *hdr = (__be16 *)ul_header;
+	struct iphdr *ip4h = iphdr;
+	u16 offset;
+
+	offset = skb_transport_header(skb) - (unsigned char *)iphdr;
+	ul_header->csum_start_offset = htons(offset);
 
-	offset = htons((__force u16)(skb_transport_header(skb) -
-				     (unsigned char *)iphdr));
-	ul_header->csum_start_offset = offset;
 	ul_header->csum_insert_offset = skb->csum_offset;
 	ul_header->csum_enabled = 1;
 	if (ip4h->protocol == IPPROTO_UDP)
@@ -239,12 +240,13 @@ rmnet_map_ipv6_ul_csum_header(void *ip6hdr,
 			      struct rmnet_map_ul_csum_header *ul_header,
 			      struct sk_buff *skb)
 {
-	struct ipv6hdr *ip6h = (struct ipv6hdr *)ip6hdr;
-	__be16 *hdr = (__be16 *)ul_header, offset;
+	__be16 *hdr = (__be16 *)ul_header;
+	struct ipv6hdr *ip6h = ip6hdr;
+	u16 offset;
+
+	offset = skb_transport_header(skb) - (unsigned char *)ip6hdr;
+	ul_header->csum_start_offset = htons(offset);
 
-	offset = htons((__force u16)(skb_transport_header(skb) -
-				     (unsigned char *)ip6hdr));
-	ul_header->csum_start_offset = offset;
 	ul_header->csum_insert_offset = skb->csum_offset;
 	ul_header->csum_enabled = 1;
 
-- 
2.27.0

