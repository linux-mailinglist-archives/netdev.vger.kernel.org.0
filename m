Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F81D3A4F4D
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 16:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhFLOkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 10:40:47 -0400
Received: from mail-io1-f42.google.com ([209.85.166.42]:39717 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbhFLOkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 10:40:45 -0400
Received: by mail-io1-f42.google.com with SMTP id f10so20205601iok.6
        for <netdev@vger.kernel.org>; Sat, 12 Jun 2021 07:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XdGocdnkWEhyGlWBEvMTXuqlG7P/EjC9lkmvGdkeF8Y=;
        b=Zm4N0uZcjB0fKwr+fcqoXcomkjX5uGAtQwpxvbw9ddhNqvUSCkXVPiDHenZ5/H4Bpg
         zIdROMvqaBPtm1ynaHGl9WiCt+K2P4bTQQueHqqhO50QnoN2hnZdtTK8sxdenRJT28hF
         BT+z3Lu913mpAh+x8OadVadY6Xihwh0ifuUvvujgm5dWHH/EDTWX4pTHq+mux0JzNTG2
         sP/0iZs0hZqwH+z0OK3Zg5CB/eKVoEYndhIoosDiRXI6+ZhgejITCkU37qrjjEjWNWpp
         zG+p2nHnmjiqvfDE4T0yMozGHXF5rOSVQBStxK6XdDWglwD4ZRmFI1lN+joRRpwvADMv
         1RBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XdGocdnkWEhyGlWBEvMTXuqlG7P/EjC9lkmvGdkeF8Y=;
        b=KhFMoRwnAW4YLkYYoMU/Vo++gxBjVQ2/u4lK1qh0bnbY+BUkIk2pSkYd2HIVmp5Cus
         7FUJ3+uBIxinyJT4hHw8s3H/v5qfl7FB0TAdLzLPQKh5s7Jue8Lxn9Rc4bthYVxfQ7I+
         zSpEQFb6mpyoDjUcJCxe9fTYaFKsizRaiseVFHgz5EQCfIIusISXZaQNPy8DtZPYFwc/
         Y8v9bmsKG68MuDePxcD+oqyv/XOEuovh8OZcSpwKOOq5hI+twC2BoT7H62ENloM7c8li
         5Qzfp7NEFf9wAy3JVmDrbwukTZmyVRwWi/y5cCZ4dBXrtxbVECB86L95dNBMQTYZY15H
         txAg==
X-Gm-Message-State: AOAM531Z5nko8dlHUZETXwLe/5JF/lQ1dgGX2zgFB5pvQmzT6cqLIF+G
        BHYKn7Wu4SV2PmfkZ+Dfhma4/w==
X-Google-Smtp-Source: ABdhPJwzos8hat4ZiV35fsZZn+J2uRBUMFuxvxkarIyMQfrAnpR2FDodp9Kfn1CqDNwjgXypQEPFVg==
X-Received: by 2002:a6b:b7d6:: with SMTP id h205mr7554507iof.188.1623508665772;
        Sat, 12 Jun 2021 07:37:45 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id k4sm5126559ior.55.2021.06.12.07.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Jun 2021 07:37:45 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/8] net: qualcomm: rmnet: drop some unary NOTs
Date:   Sat, 12 Jun 2021 09:37:35 -0500
Message-Id: <20210612143736.3498712-8-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210612143736.3498712-1-elder@linaro.org>
References: <20210612143736.3498712-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We compare a payload checksum with a pseudo checksum value for
equality in rmnet_map_ipv4_dl_csum_trailer().  Both of those values
are computed with a unary NOT (~) operation.  The result of the
comparison is the same if we omit that NOT for both values.

Remove these operations in rmnet_map_ipv6_dl_csum_trailer() also.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 610c8b5a8f46a..ed4737d0043d6 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -87,11 +87,11 @@ rmnet_map_ipv4_dl_csum_trailer(struct sk_buff *skb,
 	 * header checksum value; it is already accounted for in the
 	 * checksum value found in the trailer.
 	 */
-	ip_payload_csum = ~csum_trailer->csum_value;
+	ip_payload_csum = csum_trailer->csum_value;
 
-	pseudo_csum = ~csum_tcpudp_magic(ip4h->saddr, ip4h->daddr,
-					 ntohs(ip4h->tot_len) - ip4h->ihl * 4,
-					 ip4h->protocol, 0);
+	pseudo_csum = csum_tcpudp_magic(ip4h->saddr, ip4h->daddr,
+					ntohs(ip4h->tot_len) - ip4h->ihl * 4,
+					ip4h->protocol, 0);
 
 	/* The cast is required to ensure only the low 16 bits are examined */
 	if (ip_payload_csum != (__sum16)~pseudo_csum) {
@@ -132,13 +132,13 @@ rmnet_map_ipv6_dl_csum_trailer(struct sk_buff *skb,
 	 * checksum computed over the pseudo header.
 	 */
 	ip_header_csum = (__force __be16)ip_fast_csum(ip6h, sizeof(*ip6h) / 4);
-	ip6_payload_csum = ~csum16_sub(csum_trailer->csum_value, ip_header_csum);
+	ip6_payload_csum = csum16_sub(csum_trailer->csum_value, ip_header_csum);
 
 	length = (ip6h->nexthdr == IPPROTO_UDP) ?
 		 ntohs(((struct udphdr *)txporthdr)->len) :
 		 ntohs(ip6h->payload_len);
-	pseudo_csum = ~csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
-				       length, ip6h->nexthdr, 0);
+	pseudo_csum = csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
+				      length, ip6h->nexthdr, 0);
 
 	/* It's sufficient to compare the IP payload checksum with the
 	 * negated pseudo checksum to determine whether the packet
-- 
2.27.0

