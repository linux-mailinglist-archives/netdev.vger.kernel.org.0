Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 985AF33C8D5
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 22:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhCOVwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 17:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhCOVv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 17:51:58 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6457C061762
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 14:51:57 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id a7so35024507iok.12
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 14:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dYz46nd8LxGdX7fvsu6maJR2XM9zulyZ7ppS5hOn0SA=;
        b=KAOd5kiIrxkZEhIbWKaKi/NmupuaMayU7csMeknMQUxH21tpxWsbeuR9rHD77Lknm0
         KN9VTxpk8jyZEPjvbtNfyHIKMZuiT+O5/UX+LiVITxIogmODtSiOozK+pdqT15bx9Y2e
         KbIJtY8O3/ujZ05FqvV03UYHE83jW6tH+waCtDtVxhUR/SQ8nfrPCK5Srt8TcpGx302N
         6K0wH7D/qQj6kmnIPRFA88Kp9J4bBcqpjYHRr6biMS1SbCD12Ego0zaiINKtdRRjMYb8
         RNYYv28ykbs6uUtVMwlZdAdkpiQwbQauMG1ssAuMuNMKtN4StHCpfo8ZB23YhASRBAKq
         EpGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dYz46nd8LxGdX7fvsu6maJR2XM9zulyZ7ppS5hOn0SA=;
        b=ISjwzMdLcFMiopJiuTzWvI/WW6xL92oa2SMuCfpVuuZxyRndQSNEBWauM68hUH0mCh
         MBBdoo1ffC6lGSxdttaGo6ZYRBGbMJVQFzHG1TFZSvE+c85qqCt8cCteS8bmEITRlyf7
         42DfMaONmcvbRq1Nj02QoeWV4Gx0QcI8bb+HupYcLaxgv3S4Ycbwy3tG+llBCv7MGixa
         M/+Ef7hDuwt8ncGLGwrDY0lh7FCqZdKD19XzFpGhzuGQ1MfvLwmo9uRjISoWZJpSNSsR
         riI8vKOosk88roMLxdkSzMEHP/5uCOx1QcW3KDKMXDTAbTaTyN7jnyaufBBf1OgZXkEQ
         ZxVw==
X-Gm-Message-State: AOAM530uIJ6ztak4P4R4zGK4m4jyO+JUkJkhHFplpgQoxNeIRmqy/uCf
        +8DCYC45pLAQjA9AMk0BCrMjNA==
X-Google-Smtp-Source: ABdhPJw9tx8wxfPaeBvrUqf3t2M7EqJawUsKl3NDckGT/MYj9lhbGpSUZScVGzTuKUwPDQV/f7ScAQ==
X-Received: by 2002:a5d:9917:: with SMTP id x23mr1204682iol.22.1615845117314;
        Mon, 15 Mar 2021 14:51:57 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id y3sm7424625iot.15.2021.03.15.14.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 14:51:57 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        David.Laight@ACULAB.COM, olteanv@gmail.com,
        alexander.duyck@gmail.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v6 2/6] net: qualcomm: rmnet: simplify some byte order logic
Date:   Mon, 15 Mar 2021 16:51:47 -0500
Message-Id: <20210315215151.3029676-3-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210315215151.3029676-1-elder@linaro.org>
References: <20210315215151.3029676-1-elder@linaro.org>
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

