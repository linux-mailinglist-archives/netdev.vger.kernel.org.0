Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1824D40E2
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 06:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239652AbiCJFs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 00:48:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239639AbiCJFsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 00:48:21 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5053912E140
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:47:20 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id q29so2871867pgn.7
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 21:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bhvBzCoyUH5Q2UW9eaBJZ/pUOhsdMx7Q/qA4TYp9tCg=;
        b=Zp2FfWQMfm5g/+uCf2O371WkLZ8jkEvOzFp+CYjQnoQLv1DmpYpCrOR1xZ7lpeb07n
         roNXJTfiKGNrl10F3vP93yxx/vMyRfvK+D81XFWu1leSzfV4Oy2LL0U17b+PLhP79bZ2
         JQ7ogkzkFKKr8+Xe0vA9FP52OZC0xOs5OHc5H9/xfrYfOLcA2yFK/0URu56orTCLTXJI
         +czr8KNyY+f60+muIcqW3S5hyrgdK50NvfBa6ESCPhWgBcGueLdxTj4qThoSFzTpmcOu
         u0ThVN2w8gOHUyVtM0zZ1vZaQZ3NlHq82roKYc1GEsU+2b47cs8zN3UqSLfYsfs1DfRA
         72zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bhvBzCoyUH5Q2UW9eaBJZ/pUOhsdMx7Q/qA4TYp9tCg=;
        b=0wIWhaHD4RDKYwD0cAfXAT6RQUDbNb25W4/SeLQjJzQpnZt/yI+PtnNzse0g2CGJh/
         +x6o1WhaLpbpBkeuhi3RqgwV+FP9jtjrl+Ut5EWq2mV/iE27UDyR4lMfBsPYOjoE7L0Z
         f+69aCN2Xg3IuMdpidXLoFhrPuewKZsJQKT8pmCbyZfV+yvNSPp13j8MeisZZSjPVYrD
         4Ldxc5+rQ/zvmD1hSBUQqilZfDiafLfnLES5qIuupcrVhM/IjgBwT6sVdaK9OAJk6I8J
         NQdHfY+gWkRBkTrrdpBPw1xwEae7QANeJqQMpLTqOwuKoDomvohd7l5e7eR+WPEjOcFc
         8xdw==
X-Gm-Message-State: AOAM53261OTOIHaXQptF8vajXGwcbTY4PdQ3rQ5MFVaQ5EjG0LI5crtK
        ziLMkVS3kF4XJTYfn8wz6NE=
X-Google-Smtp-Source: ABdhPJyo59yV9HvctnugOVjsaaOEYm+oPkw2SDpIWhDHl/tQiv2qS7xJrtb5Ig0q0M4YigMriBWu1w==
X-Received: by 2002:a62:1d48:0:b0:4f6:b805:4bad with SMTP id d69-20020a621d48000000b004f6b8054badmr3362132pfd.67.1646891240226;
        Wed, 09 Mar 2022 21:47:20 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6c7:6f77:9634:183c])
        by smtp.gmail.com with ESMTPSA id 16-20020a056a00073000b004dfe2217090sm5270779pfm.200.2022.03.09.21.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 21:47:19 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v4 net-next 06/14] ipv6/gro: insert temporary HBH/jumbo header
Date:   Wed,  9 Mar 2022 21:46:55 -0800
Message-Id: <20220310054703.849899-7-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
In-Reply-To: <20220310054703.849899-1-eric.dumazet@gmail.com>
References: <20220310054703.849899-1-eric.dumazet@gmail.com>
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
2.35.1.616.g0bdcbb4464-goog

