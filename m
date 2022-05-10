Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49979520C19
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 05:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235478AbiEJDgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 23:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235448AbiEJDga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 23:36:30 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941291796F4
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 20:32:34 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id m12so1888065plb.4
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 20:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vu77qaZ+HoKgSEeugLbfMjppTn8NfczBDAHApl4hhmA=;
        b=C8mcxD8qnc9iOIeWKs2co+R59zOAJzjoXzyAU7fzDv3MeOjrjR+D8gmMP6pVnrvDvw
         +eAJSmYG8zhrCohfw1kqy62hAUJNwbIbVpPV1YLVIPdqf8T9XDwsyKy44GqGVD7HBOmH
         cjC23VP/80PQMyE9/tqlgRbC5X/mwJkqmaoy82kIP8B1PXkH5ElNofAYT4V2fY7WISdu
         BpdlbrrhnjfH9uGcCSLOtodIsuCkeH9JItInG6nTfY2H9mkR784pf48HncSO3bbvVFkX
         Z4vPhfDuzkhvn1Sed3CpKnwFBjaifHE4ccCMNGmpNcuwzj/ILXg6JBbnGx00INJ6o/hB
         IhdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vu77qaZ+HoKgSEeugLbfMjppTn8NfczBDAHApl4hhmA=;
        b=N2npDDdmMSEMpRx8KDa98oI1btmiBMzQLwqaAbwlWsU3P3KXLFtlFVM3ZA8sl5lSR8
         DmsVLTZQJCyNf6EGhGTy51xfYe/w+VwG5aF/LdVLRCyrWbVNxazTE3xQigBiP7zsWzK2
         WAZrl5XIoFNBnS9dOBrdPvBb18QLeAhDvsPZlDL/sLxTAB3aS3yTWI3JX8ju3qC2Jh20
         39OXiIve150Mt+OJQodoTRohi28S8QrnuDsbBc2kTo2YUukNM3JYbgZYM4gHZBCme0k5
         A1eB2PvqkjgteCTdFIRhXLiPGsssKqQbmYAWx56+PmlzoSpUYs+x2ii9R0CLW3mrfnqN
         ajrA==
X-Gm-Message-State: AOAM533eZn0PCPWIgoNqO7KjhZFcOEquB4hms0Ojc+tWEkfAxam4JAVZ
        dpEv6temSmhfb7FXOnK4GBI=
X-Google-Smtp-Source: ABdhPJzghN6YPU3Ym0gF/e8B4S+nSdT6JEjEpq9qtD7rrkafwvYMoLxJ+TEFLv1rv9VF4OQkcXOMJA==
X-Received: by 2002:a17:902:ef49:b0:15e:b6ed:4832 with SMTP id e9-20020a170902ef4900b0015eb6ed4832mr18442490plx.173.1652153554151;
        Mon, 09 May 2022 20:32:34 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id me16-20020a17090b17d000b001d77f392280sm538185pjb.30.2022.05.09.20.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 20:32:33 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v6 net-next 07/13] ipv6/gro: insert temporary HBH/jumbo header
Date:   Mon,  9 May 2022 20:32:13 -0700
Message-Id: <20220510033219.2639364-8-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220510033219.2639364-1-eric.dumazet@gmail.com>
References: <20220510033219.2639364-1-eric.dumazet@gmail.com>
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

