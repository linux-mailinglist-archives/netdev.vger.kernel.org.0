Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9158E4D40E4
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 06:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236134AbiCJFso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 00:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239648AbiCJFsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 00:48:25 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC2F12D933
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:47:24 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id z3so3932769plg.8
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 21:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Eo6Ay78UtfJaj+pFT4IeJlC6FzfAL4dcL6hsPGiyVns=;
        b=UngQJA1Qwd2nbsl3K8eXkwGV/ZmMqwDoKMwsYodWXvVaq7BzAQ4n464ZJ68CgwG55K
         YdsLaqrUjvhfRpA4j9hQdw/Anfn9IAj8nVEu4KzW06QI0B6/9zRF/Xr+e9X006ZbLY9O
         0fQc2RTWcG9YQM7RI0UR/CwOSnEXqaiUzSGSymivDQqVyll3Doojq8oRJg7YdlpiaTD4
         DArgWJOjdzsG2YUpseALrHWiOofkYTT4rYQZyVhsUdOS3h9hMLds62O92RHvU5h1r+bX
         FhHAILcFlxUeKO3YThZIGuca8eiG9nO72sVJVF/OW9KTHoCPO6bdEVHzIhC1uKzU0oRl
         koQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Eo6Ay78UtfJaj+pFT4IeJlC6FzfAL4dcL6hsPGiyVns=;
        b=FHI5z+rZ4yQBk5BndUIkMEHd+hlY6Aw/hmmcRBKqzii8YVMNPRmEjFweOX8fTc3Y0D
         ziBsfy9w4N3i2Ekhs4/YMkSgwVRc8FaQaTSIjsYlQs4FligLwC5DE7eBknBVvBwAa8V/
         I4e18KrqRHyRBqEOyZODCwd3F+EWTDpR6RXAkl9CWiKHtt4Eu8xjbQ3uwmVUJ2QZ3Ikf
         8bDKYRNAi2EjzUUKwQZ+M9UqCjke0QRIEtxTsFzp+XDbKR35pwV2aHQOvi/SGwKFXv/D
         frGjIautNdbE1vaGlmjsQF+hWJXfZsB8QhBWrDbzeGSrHI02Aeos+8vGgR4gji2KgboI
         uKHA==
X-Gm-Message-State: AOAM530/riCQxdDDXAppqCUm6KarfHrwY1SC1iqbRYgyXy7uQiIQG0TQ
        9h+LqQE4RcwpcxqFtgjJs2k=
X-Google-Smtp-Source: ABdhPJwvg0lyFA28nm+Q910n6d0Nlca1VENlt7y7d1mE26lYw/7wDAtxV6XUdJFHS5EgiiSOUSAMTw==
X-Received: by 2002:a17:902:7895:b0:14b:6b63:b3fa with SMTP id q21-20020a170902789500b0014b6b63b3famr3210121pll.156.1646891244148;
        Wed, 09 Mar 2022 21:47:24 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6c7:6f77:9634:183c])
        by smtp.gmail.com with ESMTPSA id 16-20020a056a00073000b004dfe2217090sm5270779pfm.200.2022.03.09.21.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 21:47:23 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v4 net-next 08/14] ipv6: Add hop-by-hop header to jumbograms in ip6_output
Date:   Wed,  9 Mar 2022 21:46:57 -0800
Message-Id: <20220310054703.849899-9-eric.dumazet@gmail.com>
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

From: Coco Li <lixiaoyan@google.com>

Instead of simply forcing a 0 payload_len in IPv6 header,
implement RFC 2675 and insert a custom extension header.

Note that only TCP stack is currently potentially generating
jumbograms, and that this extension header is purely local,
it wont be sent on a physical link.

This is needed so that packet capture (tcpdump and friends)
can properly dissect these large packets.

Signed-off-by: Coco Li <lixiaoyan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/ipv6.h  |  1 +
 net/ipv6/ip6_output.c | 22 ++++++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index 16870f86c74d3d1f5dfb7edac1e7db85f1ef6755..93b273db1c9926aba4199f486ce90778311916f5 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -144,6 +144,7 @@ struct inet6_skb_parm {
 #define IP6SKB_L3SLAVE         64
 #define IP6SKB_JUMBOGRAM      128
 #define IP6SKB_SEG6	      256
+#define IP6SKB_FAKEJUMBO      512
 };
 
 #if defined(CONFIG_NET_L3_MASTER_DEV)
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index e69fac576970a9b85fb68aa02822c0e2df67e1a2..941ceff83b616cec11c6bb7ccaf81bc041f8d9cc 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -180,7 +180,9 @@ static int __ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff
 #endif
 
 	mtu = ip6_skb_dst_mtu(skb);
-	if (skb_is_gso(skb) && !skb_gso_validate_network_len(skb, mtu))
+	if (skb_is_gso(skb) &&
+	    !(IP6CB(skb)->flags & IP6SKB_FAKEJUMBO) &&
+	    !skb_gso_validate_network_len(skb, mtu))
 		return ip6_finish_output_gso_slowpath_drop(net, sk, skb, mtu);
 
 	if ((skb->len > mtu && !skb_is_gso(skb)) ||
@@ -251,6 +253,8 @@ int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
 	struct dst_entry *dst = skb_dst(skb);
 	struct net_device *dev = dst->dev;
 	struct inet6_dev *idev = ip6_dst_idev(dst);
+	struct hop_jumbo_hdr *hop_jumbo;
+	int hoplen = sizeof(*hop_jumbo);
 	unsigned int head_room;
 	struct ipv6hdr *hdr;
 	u8  proto = fl6->flowi6_proto;
@@ -258,7 +262,7 @@ int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
 	int hlimit = -1;
 	u32 mtu;
 
-	head_room = sizeof(struct ipv6hdr) + LL_RESERVED_SPACE(dev);
+	head_room = sizeof(struct ipv6hdr) + hoplen + LL_RESERVED_SPACE(dev);
 	if (opt)
 		head_room += opt->opt_nflen + opt->opt_flen;
 
@@ -281,6 +285,20 @@ int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
 					     &fl6->saddr);
 	}
 
+	if (unlikely(seg_len > IPV6_MAXPLEN)) {
+		hop_jumbo = skb_push(skb, hoplen);
+
+		hop_jumbo->nexthdr = proto;
+		hop_jumbo->hdrlen = 0;
+		hop_jumbo->tlv_type = IPV6_TLV_JUMBO;
+		hop_jumbo->tlv_len = 4;
+		hop_jumbo->jumbo_payload_len = htonl(seg_len + hoplen);
+
+		proto = IPPROTO_HOPOPTS;
+		seg_len = 0;
+		IP6CB(skb)->flags |= IP6SKB_FAKEJUMBO;
+	}
+
 	skb_push(skb, sizeof(struct ipv6hdr));
 	skb_reset_network_header(skb);
 	hdr = ipv6_hdr(skb);
-- 
2.35.1.616.g0bdcbb4464-goog

