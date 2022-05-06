Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B167E51DC30
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 17:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442893AbiEFPgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 11:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443147AbiEFPfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 11:35:20 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF026D97F
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 08:31:18 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id i1so7765686plg.7
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 08:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3plY4QYEdjKGAPxIOu4e/4uq96gqixpA+zmKua8m2bA=;
        b=quDOkcghthEodUSf5oGrRLiHKEbtXNsGwqWROtrRUGR9bpoeCVbaizXn5myjD+ryaX
         ZpBbmQhfTAE+zGqijt7Rr5soHjELkEFcZyAFYrFzoF1wa2YSrij3jssdVFK7ApTSrN0F
         8qwkWGrul2TktsFyLrVeS24EpUzHWB5aMT4hyDW/+zuRwvSeGB/luVTVc/LvQLf8Hjzh
         gBvP7j/MdSc6gTG4HwOgXXvK46UQpPC9kYvQPDuuo5Wyl+h9KJslGR/hPYQCZeTmGvm5
         xHP/Cr1L6zQrgSuiequdt+hG+g7cbHkZ8NZ4Pij/CRkfpJJowJUSQ2UbhOjbBdJbxov/
         ebxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3plY4QYEdjKGAPxIOu4e/4uq96gqixpA+zmKua8m2bA=;
        b=TnrDvzU1pkIDPbL1kJxfcXnr9gcp5WE+gkWqjihSbaWEn5a+SpUpDMqcUhBkDXEB2j
         5rtdbOpnUhL6RiaXUZdh7qTDvk4+iOFON+GkoPBKXPpgwQfbHTdkaQbGByW/5kXn68Fg
         C96PqzOhBvqu83qJ8WkUPeu5t/7VYhYG3uU6rs8UO3a8Y30odrtelxP339J7NWzBmw9s
         VljQ05VO8lATYEIrvsicUkf4Gy3cIcGE6zUgkp3/6w9PJs71cv+WU6Ua1xzmb2yVn3aB
         YpcBPPHJ0wbtuFMmav2X4t+0dSchO3tI2lAY3sJ2NTAqAidjAeGgEg/x6Qiee4vpcEm3
         NMTw==
X-Gm-Message-State: AOAM531J/Of6s4I9YT64atJ++TCljT/fSKbYRg3CI5NagAjw9IHLrELD
        leLSt4qcNSm4/j2FWF8oFJXiktf9FrE=
X-Google-Smtp-Source: ABdhPJwYAKKrlOvCFNTzeSsuUIPlBWBzjxT20y+a92z9pZJy8x/5IjfAuXcfxPzOz9nY115ALvymGQ==
X-Received: by 2002:a17:902:8608:b0:158:c532:d8b2 with SMTP id f8-20020a170902860800b00158c532d8b2mr4242639plo.46.1651851078124;
        Fri, 06 May 2022 08:31:18 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:709e:d3d8:321b:df52])
        by smtp.gmail.com with ESMTPSA id w4-20020a170902d70400b0015e8d4eb1bfsm1918612ply.9.2022.05.06.08.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 08:31:17 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v4 net-next 08/12] ipv6: Add hop-by-hop header to jumbograms in ip6_output
Date:   Fri,  6 May 2022 08:30:44 -0700
Message-Id: <20220506153048.3695721-9-eric.dumazet@gmail.com>
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
index ec5ca392eaa31e83a022b1124fae6b607ba168cd..38c8203d52cbf39e523c43fe630a7b184b9991aa 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -145,6 +145,7 @@ struct inet6_skb_parm {
 #define IP6SKB_L3SLAVE         64
 #define IP6SKB_JUMBOGRAM      128
 #define IP6SKB_SEG6	      256
+#define IP6SKB_FAKEJUMBO      512
 };
 
 #if defined(CONFIG_NET_L3_MASTER_DEV)
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index afa5bd4ad167c4a40878f33773d43be85e89c32f..4081b12a01ff22ecf94a6490aef0665808407a6e 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -182,7 +182,9 @@ static int __ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff
 #endif
 
 	mtu = ip6_skb_dst_mtu(skb);
-	if (skb_is_gso(skb) && !skb_gso_validate_network_len(skb, mtu))
+	if (skb_is_gso(skb) &&
+	    !(IP6CB(skb)->flags & IP6SKB_FAKEJUMBO) &&
+	    !skb_gso_validate_network_len(skb, mtu))
 		return ip6_finish_output_gso_slowpath_drop(net, sk, skb, mtu);
 
 	if ((skb->len > mtu && !skb_is_gso(skb)) ||
@@ -252,6 +254,8 @@ int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
 	struct dst_entry *dst = skb_dst(skb);
 	struct net_device *dev = dst->dev;
 	struct inet6_dev *idev = ip6_dst_idev(dst);
+	struct hop_jumbo_hdr *hop_jumbo;
+	int hoplen = sizeof(*hop_jumbo);
 	unsigned int head_room;
 	struct ipv6hdr *hdr;
 	u8  proto = fl6->flowi6_proto;
@@ -259,7 +263,7 @@ int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
 	int hlimit = -1;
 	u32 mtu;
 
-	head_room = sizeof(struct ipv6hdr) + LL_RESERVED_SPACE(dev);
+	head_room = sizeof(struct ipv6hdr) + hoplen + LL_RESERVED_SPACE(dev);
 	if (opt)
 		head_room += opt->opt_nflen + opt->opt_flen;
 
@@ -282,6 +286,20 @@ int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
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
2.36.0.512.ge40c2bad7a-goog

