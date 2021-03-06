Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240E932F800
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 04:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhCFDQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 22:16:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhCFDP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 22:15:59 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4134CC061764
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 19:15:57 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id o9so4151708iow.6
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 19:15:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cYtxP12FPoFyXStxU+dIm5i6FSzaCM643MO9iKA6Wx4=;
        b=g6WXRn347j7pmgYD2zoZKiQgCwOofJv+sDMycNiZfHjV+4kUFyOaqWKZdkkhUNvuCL
         /LW3sRYmJ+vhfn4A4JjQt6sODuznGgWlOPRvihgZorv5LKW0/CrU+BrBcZ0sDTea7En5
         HeW6hMGRwApLSX87LhzywnKtvCU/bUl39Dtj1OwgiC7b3rTDirJ8T6Z2U1t5oDdtKjfZ
         QsS9G3IQFKVcxb2c+tKbWL6B6u6f780oewXnHJFtnQ3+ybEpSITiSvV1Niw6FGf7dpti
         UzmTGSWFyDzdpa3w29sfg0+xqOXRaGb+V31kjrtiflO6NZb63K76zNZWXHD4ONgkWMaF
         iQDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cYtxP12FPoFyXStxU+dIm5i6FSzaCM643MO9iKA6Wx4=;
        b=DcqZmXpSrMGUVUMXyd8jyOwZfume9IuIOsA+UrQoeJ37YV+1QzN5gdy7mYFS6VeV+P
         3LS/lfzpFFR9aYsQyFkLruAA1JbufWx+fFpKIhQnB0AusiGYInyQSvaOJMTkLvyQeEUQ
         SQiERYArT8Jv3G4mtXn5RuFL/6Kuyrbby2mj9fszH25bpXAplNhXOyUg4IfxMyDIZkgY
         408YBhhI3pabOlR6lS92itWJy8ZJUGoDnhgOkluBckGijZMlHXxckSrsdwMFwqRAcBi+
         8sbwtWTF05U3sw8AHO+odorRi1cEaA3qyauWE5wBAz1NCB9pB7DbLFAu+OU3EqwL7d4h
         eVUg==
X-Gm-Message-State: AOAM53037hYsFL9UUcF2OVC3XzVMcIDk2iaa10sPglG5BkZNZzd3Efv1
        DCsYCMKTjvEQ7CVN5plaZZiGKA==
X-Google-Smtp-Source: ABdhPJzA7ZuEMbrE2NlnY5ZV6OrIViNoSkIfmJCitFgOOys+iYZoiJ8sHXCOu9dMBhc7RbBHV1uVIg==
X-Received: by 2002:a02:9003:: with SMTP id w3mr12920361jaf.31.1615000556740;
        Fri, 05 Mar 2021 19:15:56 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id i67sm2278693ioa.3.2021.03.05.19.15.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 19:15:56 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/6] net: qualcomm: rmnet: simplify some byte order logic
Date:   Fri,  5 Mar 2021 21:15:46 -0600
Message-Id: <20210306031550.26530-3-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210306031550.26530-1-elder@linaro.org>
References: <20210306031550.26530-1-elder@linaro.org>
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

