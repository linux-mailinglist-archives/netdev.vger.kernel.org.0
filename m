Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120D21D0FFD
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 12:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731117AbgEMKjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 06:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727812AbgEMKjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 06:39:04 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B88C061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 03:39:04 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id f15so6659744plr.3
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 03:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=LGYocYMvN/W/ocWLzH0hyLhcvNcumkqHUr8jtqkIExM=;
        b=PX0KUIrG9VYR1nbGQsJ7bzi+9sM9EjCN01kuHEwLtC6Ofdxgk0MouKRPgWi4RBWwWt
         aW2Mu5IE7NIYyu/KB3mXaDnPyTB2cJHzJ3otKy1tAYBQb/OpFyR6NnsNTqpKnHMLz8v7
         DNqUZWzLQnbvEQfXxJ4M/BLQhrklVRgtQ+pzovJGAkRP3fedf+x4momD9B6DaLdfQ5aC
         5nyfN2Lx9A+kPzgGimEhlAUeHYGwuR23Ydi58BVm61f9nQewiM5TyEbkgDmmBhXIp9+/
         wOx0U5Z+kLQ0ZDtghUf40vroz5t1h0hCJV1dHrtlwBh3+PqWOjFGt722dgGt1yaFXBKJ
         L3HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LGYocYMvN/W/ocWLzH0hyLhcvNcumkqHUr8jtqkIExM=;
        b=fRY7d8vz6e5yQjqo5JI9Nc51tWCcTWa8d+9uME+Xe7TDNRorX+0onoj88ZkwFPGr2r
         PJn2CqjsBMdBV0gg+u5jwzUniJ1R2lVHqy+tQQF9kA2/CMhv8uq4bFJEJNFpQSmhlIad
         ys9llAVTg1HSj4BhoEMQV69QnUQwGHXpaDumO7DjgxH3/WtjfGwwtU8OnhxaXZ7YgGGC
         TQ2jzcH8reg9OZGefTA7AYN2aWaLuhxx7sZbjO8h1zDp/y8bwPjxoKS/63FrAzC/JHBW
         I67icZFwYwlJX8IStbBQdUv8qL2vBLRP/AlDt5d29PtxU/6eNllPUEgxMHFGNbCBSNB4
         Rd7A==
X-Gm-Message-State: AOAM531czDEhVPAWC+JT5SzBFiVP2wKZfBER9OJImSVPKeH9PfYtiXmO
        25Z9CqQAWfukqMQ09yJBOuuv7GxG
X-Google-Smtp-Source: ABdhPJzbX7/H9DybCYzIchcqScSkxSBu9xzXH7QV0XgjwK4sedor60jmZxglVcroz4JJ7JYIq6laDA==
X-Received: by 2002:a17:90a:3a82:: with SMTP id b2mr8933826pjc.228.1589366343319;
        Wed, 13 May 2020 03:39:03 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y14sm14250800pff.205.2020.05.13.03.39.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 03:39:02 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec] esp6: calculate transport_header correctly when sel.family != AF_INET6
Date:   Wed, 13 May 2020 18:38:54 +0800
Message-Id: <5224dd1a6287b41e9747385154a0dff4f115590a.1589366334.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In esp6_init_state() for beet mode when x->sel.family != AF_INET6:

  x->props.header_len = sizeof(struct ip_esp_hdr) +
     crypto_aead_ivsize(aead) + IPV4_BEET_PHMAXLEN +
     (sizeof(struct ipv6hdr) - sizeof(struct iphdr))

In xfrm6_beet_gso_segment() skb->transport_header is supposed to move
to the end of the ph header for IPPROTO_BEETPH, so if x->sel.family !=
AF_INET6 and it's IPPROTO_BEETPH, it should do:

   skb->transport_header -=
      (sizeof(struct ipv6hdr) - sizeof(struct iphdr));
   skb->transport_header += ph->hdrlen * 8;

And IPV4_BEET_PHMAXLEN is only reserved for PH header, so if
x->sel.family != AF_INET6 and it's not IPPROTO_BEETPH, it should do:

   skb->transport_header -=
      (sizeof(struct ipv6hdr) - sizeof(struct iphdr));
   skb->transport_header -= IPV4_BEET_PHMAXLEN;

Thanks Sabrina for looking deep into this issue.

Fixes: 7f9e40eb18a9 ("esp6: add gso_segment for esp6 beet mode")
Reported-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv6/esp6_offload.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 9c03460..ab0eea3 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -175,24 +175,27 @@ static struct sk_buff *xfrm6_beet_gso_segment(struct xfrm_state *x,
 
 	skb->transport_header += x->props.header_len;
 
-	if (proto == IPPROTO_BEETPH) {
-		struct ip_beet_phdr *ph = (struct ip_beet_phdr *)skb->data;
+	if (x->sel.family != AF_INET6) {
+		skb->transport_header -=
+			(sizeof(struct ipv6hdr) - sizeof(struct iphdr));
 
-		skb->transport_header += ph->hdrlen * 8;
-		proto = ph->nexthdr;
-	}
+		if (proto == IPPROTO_BEETPH) {
+			struct ip_beet_phdr *ph =
+				(struct ip_beet_phdr *)skb->data;
+
+			skb->transport_header += ph->hdrlen * 8;
+			proto = ph->nexthdr;
+		} else {
+			skb->transport_header -= IPV4_BEET_PHMAXLEN;
+		}
 
-	if (x->sel.family == AF_INET6) {
+		if (proto == IPPROTO_TCP)
+			skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV6;
+	} else {
 		__be16 frag;
 
 		skb->transport_header +=
 			ipv6_skip_exthdr(skb, 0, &proto, &frag);
-	} else {
-		skb->transport_header -=
-			(sizeof(struct ipv6hdr) - sizeof(struct iphdr));
-
-		if (proto == IPPROTO_TCP)
-			skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV6;
 	}
 
 	__skb_pull(skb, skb_transport_offset(skb));
-- 
2.1.0

