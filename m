Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2063752696C
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 20:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383380AbiEMSe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 14:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383362AbiEMSek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 14:34:40 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACD460AA1
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:34:28 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d22so8730163plr.9
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cslyE/h2GayksW0X34WfIUpqvmWiqAld+qx7dUc3Duo=;
        b=VdX5Xs+aPC2B0cWoXPAIjXkv5ABzyvuHNXk66PYJo42hATI2F8TzprvU8zbOgqm1og
         R6rB/twc948k1Epj5nKH6mzMK3NQGbw56PXmK5YfnH3JoC/OcYop/s3cOcKlMZWj06dA
         TsadIJ8infWMKzk1v1Vo4oaNUfNKCsbn4gmjd5sBwBlH8HfzefRVKu9zgKhc/ITc7J7p
         G/XORzOcv9XDb2Ur1PoGYDdDEfIZnsOPNag1prDZQ4qStIU7iNvDcjWR8npMACl6y/CJ
         wyi43MPgi00QTNzKdWZiy06uOrhUKP7kBaf9SelRez1R/BtXdudaXtCxJlgpBkb/ueIz
         HTgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cslyE/h2GayksW0X34WfIUpqvmWiqAld+qx7dUc3Duo=;
        b=iI0FVr2MeC2r/bnxsLYbDlQQTVvXEoSUGPtRZvajUxacrvuVbEMKYbq8+lvA60jvI8
         OropLXnp3TfEqKaMzlGq5lZ6RWa8c0krFq3/KMJbg3WJYGu3i1y45VUzCXXOAA69vUfl
         0KT0s+5AgPQmzeW51/613c40h/K9TUHlUPHNmMFwe2iXF4DDkEecoZkVJKxuEB/PuwoD
         pxEe8Fg5HM/e7tGkeZtf8iUc/UX3JZ9tIrlHuOO4iKbIowRbkRBAUX2D7PaVaebyWmW3
         Cs/YmJHcSs74zjR5a7bZnBTkArgrVUJOXjpd7w/+olNUX5vlMPbtCMOFiAWroZHHhmHr
         842A==
X-Gm-Message-State: AOAM530uVf2PbNDio2bLsd6mzrJlHL0X8DuBHbbg+FmRBk+6XVD6oT7T
        +xU4s06hjwaB8gs3rzTEM14=
X-Google-Smtp-Source: ABdhPJykCTcayo7tZ4/ZGyorsVMEy7A/dA9GtfvMbK7YZgCOA0aBkk1zitLlznyx2qokprW3OC8UIQ==
X-Received: by 2002:a17:902:8698:b0:158:99d4:6256 with SMTP id g24-20020a170902869800b0015899d46256mr6217173plo.104.1652466868390;
        Fri, 13 May 2022 11:34:28 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c436:3fa3:479f:a7a])
        by smtp.gmail.com with ESMTPSA id q13-20020aa7842d000000b0050dc76281cesm2053566pfn.168.2022.05.13.11.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 11:34:28 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v7 net-next 09/13] ipv6: Add hop-by-hop header to jumbograms in ip6_output
Date:   Fri, 13 May 2022 11:34:04 -0700
Message-Id: <20220513183408.686447-10-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
In-Reply-To: <20220513183408.686447-1-eric.dumazet@gmail.com>
References: <20220513183408.686447-1-eric.dumazet@gmail.com>
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
Acked-by: Alexander Duyck <alexanderduyck@fb.com>
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
2.36.0.550.gb090851708-goog

