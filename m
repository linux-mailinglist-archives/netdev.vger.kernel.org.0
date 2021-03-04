Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F379632DD29
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 23:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbhCDWew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 17:34:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232027AbhCDWeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 17:34:37 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA16C06175F
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 14:34:37 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id o11so23652567iob.1
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 14:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VDRd/k3SE2dFfwLHBJ3IM2QixWpwECC8r/K+T//z74M=;
        b=tWAVR0yakCZ7JbblHhvdUrAUdw/HKQQ+0MJzkilNGz6FKRZXu65N0zJK7UF2UGzRQi
         rcixBryYc2QViduTnMU8eveNB96pOEul3Fe3MrYHMd3mp2H6P95Rqk7b8jHTRB2UWzxz
         +/SQM82ClIpQgqi9tQNIESuGP87s7V8k5YautEZOBCMamrRs96VVVX9awMGjYxpaEcRf
         fXeKkKuBdQsimbfnDf3O5OOJ425DT+W59GAdJeZ1jifWwQ1RVUuMsBtZp2WggZ/8z3wj
         pnbU6oeJyQGaR3AtKqddwZsv4MT7nyCbRYEi2/XGAw7ixJd867oOWli7kzvAYC+aklZh
         750A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VDRd/k3SE2dFfwLHBJ3IM2QixWpwECC8r/K+T//z74M=;
        b=W8I58pwJLTvBgo8LiQXKT27RjvH5Lwc3Cel0uUV42nmhGkDucgY4XjATDuZ29G7AD6
         gTIKd3sXyfwkQKi36WOFTDDllJb1Jh3HnqPNYrvCFGyKZfC/HU/qv87Deo80R1jkqv8+
         fnDEwPHZovvcJ+WyNMqHWwpBs0YHJeZYXmI+0e0aWOL2bOLJu5O2IYzCWnj6Zc0g6Tc1
         x5rT5DrpK4bMbiBsHx63qDYLEca0pBNPJvzLCqXPqT4VBr3ZN924pmw9ZFHp1Nc4hWXU
         pkQrvlGAfaWCdJKB6SnksL3WmYVwEKIkiIpcj5oLQLh413jnS0znvq0/ZC9HJG1G2WzM
         cq5w==
X-Gm-Message-State: AOAM530KIIbFJSMRO+1drEnnZQBbC6xi+i9EcPVGQh1Ln0ioZNGh20Xx
        16M+IV+NMCmQP6g+8mqkovivNg==
X-Google-Smtp-Source: ABdhPJzut91zOjLiXLXYscqglNiYbdwfO2+JCmzKwSIjNlkV5uZSdVWatK4i7w1EtS7S1EmfAfyREQ==
X-Received: by 2002:a05:6602:2102:: with SMTP id x2mr5722603iox.83.1614897276818;
        Thu, 04 Mar 2021 14:34:36 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id s18sm399790ilt.9.2021.03.04.14.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 14:34:36 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/6] net: qualcomm: rmnet: simplify some byte order logic
Date:   Thu,  4 Mar 2021 16:34:27 -0600
Message-Id: <20210304223431.15045-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210304223431.15045-1-elder@linaro.org>
References: <20210304223431.15045-1-elder@linaro.org>
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
2.20.1

