Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE343416BF
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 08:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234146AbhCSHfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 03:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234264AbhCSHfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 03:35:20 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336B0C06174A;
        Fri, 19 Mar 2021 00:35:17 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id r17so3109246pgi.0;
        Fri, 19 Mar 2021 00:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4gb5JIM22jI4WKaU2FQcVWvt6CBAIR21u6MGTRg1uIQ=;
        b=Awb0vJDQbkOAvln2v8FI+TX3CbyC4Ovqp1DEtZ3bFEmxwWF6XKiqosLl3up/UupvkA
         LjNYDg9nZIP13wD8ZrdhtryuqCT+7vW0EPEkrz9g8TNvtcG+rJu68aMtmPGuaQsy6NAB
         3Y4w0FgXk8+f5VUWbEnfQEOIM50CpNh2WglJY4XQt+nhocz8zFLj4NQJXwFD/Z4fE/lx
         WhGX1Au/xqYahnIELytysejVNgWqbhKPDeTvTXVWo05uRORh54lf6cNtha+8Nn5kQtTQ
         j0kb6ja9oYJCK/8Ozx1kMAONaycCtp4oLSGytiGN8IjWLZvGcRPl956kg1jYTjG4ernJ
         5QHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4gb5JIM22jI4WKaU2FQcVWvt6CBAIR21u6MGTRg1uIQ=;
        b=bndINTPH/vTo0kmCro98TscxLTU/k9E+wJru5ujC0RrPruI8A3DU6E6hpyT3A1QWa3
         vPzG6rOXj0GpVrF1AUTUvrvFZZkQio1CZZQs+Qghta3l2IPQSpPgWvAEkrOs5ol8Xbxq
         jWjolLyPaDnB8wyuCLInFAGNlZeZRMj90qKk5cw12OL1YZ1ROu0kGfk1gBD8RivZ5kCv
         OJqiR90evYQiq2tXSCjaEnwHt+niGbzRx6W7niHzpLA19GJ0d03ekQu2eZ5Xxnguch4y
         ntrj4CIcgleq9Qgo4ijEwFXbsz2/O4MBgJAV+I+6lA6L1/rh+u3NeLG6wb/cdaUSHnoI
         AEyA==
X-Gm-Message-State: AOAM531sPO5Z6dHQdRGqaL+nscV6ZtB1EW74Lws0j//7cNWezrCa8WGS
        bXXjHDcwlY73pLbYUd6KPA82s/g0eDS5eg==
X-Google-Smtp-Source: ABdhPJyYCd9Fk1LXcDxK1/aD8a+vfcIjmW+Bi+3RRSHXv7BHZVVdKZAT4tI1Qo1MUf08RcXOGHMxwQ==
X-Received: by 2002:a62:e10f:0:b029:1f5:42b6:7113 with SMTP id q15-20020a62e10f0000b02901f542b67113mr7997674pfh.63.1616139316489;
        Fri, 19 Mar 2021 00:35:16 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f21sm4101947pfe.6.2021.03.19.00.35.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Mar 2021 00:35:15 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH ipsec] esp: delete NETIF_F_SCTP_CRC bit from features for esp offload
Date:   Fri, 19 Mar 2021 15:35:07 +0800
Message-Id: <5f247a2ef20cae297db4d0a130515d0b7a1b8110.1616139307.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now in esp4/6_gso_segment(), before calling inner proto .gso_segment,
NETIF_F_CSUM_MASK bits are deleted, as HW won't be able to do the
csum for inner proto due to the packet encrypted already.

So the UDP/TCP packet has to do the checksum on its own .gso_segment.
But SCTP is using CRC checksum, and for that NETIF_F_SCTP_CRC should
be deleted to make SCTP do the csum in own .gso_segment as well.

In Xiumei's testing with SCTP over IPsec/veth, the packets are kept
dropping due to the wrong CRC checksum.

Reported-by: Xiumei Mu <xmu@redhat.com>
Fixes: 7862b4058b9f ("esp: Add gso handlers for esp4 and esp6")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/esp4_offload.c | 6 ++++--
 net/ipv6/esp6_offload.c | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 601f5fb..ed3de48 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -217,10 +217,12 @@ static struct sk_buff *esp4_gso_segment(struct sk_buff *skb,
 
 	if ((!(skb->dev->gso_partial_features & NETIF_F_HW_ESP) &&
 	     !(features & NETIF_F_HW_ESP)) || x->xso.dev != skb->dev)
-		esp_features = features & ~(NETIF_F_SG | NETIF_F_CSUM_MASK);
+		esp_features = features & ~(NETIF_F_SG | NETIF_F_CSUM_MASK |
+					    NETIF_F_SCTP_CRC);
 	else if (!(features & NETIF_F_HW_ESP_TX_CSUM) &&
 		 !(skb->dev->gso_partial_features & NETIF_F_HW_ESP_TX_CSUM))
-		esp_features = features & ~NETIF_F_CSUM_MASK;
+		esp_features = features & ~(NETIF_F_CSUM_MASK |
+					    NETIF_F_SCTP_CRC);
 
 	xo->flags |= XFRM_GSO_SEGMENT;
 
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 1ca516f..f35203a 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -254,9 +254,11 @@ static struct sk_buff *esp6_gso_segment(struct sk_buff *skb,
 	skb->encap_hdr_csum = 1;
 
 	if (!(features & NETIF_F_HW_ESP) || x->xso.dev != skb->dev)
-		esp_features = features & ~(NETIF_F_SG | NETIF_F_CSUM_MASK);
+		esp_features = features & ~(NETIF_F_SG | NETIF_F_CSUM_MASK |
+					    NETIF_F_SCTP_CRC);
 	else if (!(features & NETIF_F_HW_ESP_TX_CSUM))
-		esp_features = features & ~NETIF_F_CSUM_MASK;
+		esp_features = features & ~(NETIF_F_CSUM_MASK |
+					    NETIF_F_SCTP_CRC);
 
 	xo->flags |= XFRM_GSO_SEGMENT;
 
-- 
2.1.0

