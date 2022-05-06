Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E84A551DC34
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 17:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442994AbiEFPfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 11:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443130AbiEFPfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 11:35:18 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41F26D959
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 08:31:13 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id g184so3893640pgc.1
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 08:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vu77qaZ+HoKgSEeugLbfMjppTn8NfczBDAHApl4hhmA=;
        b=bXn4PUn0Y3pz/6Gm/tOFudd5qOKFZ9TkcABYCptw//ifw2Jx/tBOi9P8X6D4DTGS5A
         iT/A216Z0+cgr0Eqjgzv+RXAHxZXKvpLHb5/qPV8xDvIrGHHTSE/pyljUoDyr6BgJeeZ
         FZjLGjqiivUE1NS8Ix9R5ngOyUny6+rLhHfjsbEv84KY2vegOw5KYhOaTG/VXiTXQ9JL
         nG///ogWn1wSoskTtTnO1Fsk9dCJQk5RsgIZXq7uIngIPbTtH/UvMKShAEFzdWDKtzTG
         Ysolaz0vyOTmGHuA6+Ng6YBqPfLViL9vFGSnB2KuUiuZ1leX0esHWkFlyKvxPhgA8LTE
         uO4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vu77qaZ+HoKgSEeugLbfMjppTn8NfczBDAHApl4hhmA=;
        b=UAIRYfteda4n5hkQB7HG4Fi6TSZbpOgTNcmS5FCBzZDi7aVmp3mN5tY8JDVnKQ8Yy6
         WePy4d/UiLyl3O9qe6CU445sIaQXWlElnaVZ9NRL0PjxmUxYsn+nthfI6BqQSVboKWTr
         bf5YW+wLPjP3d6tqCeg9cDhLHfkQeM4GZJrmP/FxLOGeM58cosonCktwVjeanqydtY+H
         UPdVXpP9wb3ThfibzmKrjb9DYf9dIAqqnGwqyHDmV97IS3/d1ZuAR7n0I8GMQ+s+8FTp
         CFhvmUe7HpWXmLoBhaSEqBCUrSsBUd54465GpRcDp92jCukKzWypOOzQxMRE0r6zGBp8
         uyKw==
X-Gm-Message-State: AOAM530PR3SrKafLwivHMNcah7xfADht4uDXSgCKhhDooXGRK3jFIVES
        uw3z/WEBS1XmMotg+g7GVF0=
X-Google-Smtp-Source: ABdhPJwf+bG+r17ZRY7lMQNj2EDX3XbSx3sRus+3fA8w2qxA3byR+2bQ1dzj7aAYbCVxd7IeQSxSCQ==
X-Received: by 2002:a05:6a00:140f:b0:4e0:6995:9c48 with SMTP id l15-20020a056a00140f00b004e069959c48mr4130083pfu.59.1651851073489;
        Fri, 06 May 2022 08:31:13 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:709e:d3d8:321b:df52])
        by smtp.gmail.com with ESMTPSA id w4-20020a170902d70400b0015e8d4eb1bfsm1918612ply.9.2022.05.06.08.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 08:31:13 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v4 net-next 06/12] ipv6/gro: insert temporary HBH/jumbo header
Date:   Fri,  6 May 2022 08:30:42 -0700
Message-Id: <20220506153048.3695721-7-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220506153048.3695721-1-eric.dumazet@gmail.com>
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Following patch will add GRO_IPV6_MAX_SIZE, allowing gro to build
BIG TCP ipv6 packets (bigger than 64K).

This patch changes ipv6_gro_complete() to insert a HBH/jumbo header
so that resulting packet can go through IPv6/TCP stacks.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ip6_offload.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index a6a6c1539c28d242ef8c35fcd5ce900512ce912d..d12dba2dd5354dbb79bb80df4038dec2544cddeb 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -342,15 +342,43 @@ static struct sk_buff *ip4ip6_gro_receive(struct list_head *head,
 INDIRECT_CALLABLE_SCOPE int ipv6_gro_complete(struct sk_buff *skb, int nhoff)
 {
 	const struct net_offload *ops;
-	struct ipv6hdr *iph = (struct ipv6hdr *)(skb->data + nhoff);
+	struct ipv6hdr *iph;
 	int err = -ENOSYS;
+	u32 payload_len;
 
 	if (skb->encapsulation) {
 		skb_set_inner_protocol(skb, cpu_to_be16(ETH_P_IPV6));
 		skb_set_inner_network_header(skb, nhoff);
 	}
 
-	iph->payload_len = htons(skb->len - nhoff - sizeof(*iph));
+	payload_len = skb->len - nhoff - sizeof(*iph);
+	if (unlikely(payload_len > IPV6_MAXPLEN)) {
+		struct hop_jumbo_hdr *hop_jumbo;
+		int hoplen = sizeof(*hop_jumbo);
+
+		/* Move network header left */
+		memmove(skb_mac_header(skb) - hoplen, skb_mac_header(skb),
+			skb->transport_header - skb->mac_header);
+		skb->data -= hoplen;
+		skb->len += hoplen;
+		skb->mac_header -= hoplen;
+		skb->network_header -= hoplen;
+		iph = (struct ipv6hdr *)(skb->data + nhoff);
+		hop_jumbo = (struct hop_jumbo_hdr *)(iph + 1);
+
+		/* Build hop-by-hop options */
+		hop_jumbo->nexthdr = iph->nexthdr;
+		hop_jumbo->hdrlen = 0;
+		hop_jumbo->tlv_type = IPV6_TLV_JUMBO;
+		hop_jumbo->tlv_len = 4;
+		hop_jumbo->jumbo_payload_len = htonl(payload_len + hoplen);
+
+		iph->nexthdr = NEXTHDR_HOP;
+		iph->payload_len = 0;
+	} else {
+		iph = (struct ipv6hdr *)(skb->data + nhoff);
+		iph->payload_len = htons(payload_len);
+	}
 
 	nhoff += sizeof(*iph) + ipv6_exthdrs_len(iph, &ops);
 	if (WARN_ON(!ops || !ops->callbacks.gro_complete))
-- 
2.36.0.512.ge40c2bad7a-goog

