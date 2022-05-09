Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE59D520791
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 00:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbiEIW2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 18:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231558AbiEIW0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 18:26:05 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACB816D48A
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 15:22:10 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id l11so7592213pgt.13
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 15:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3plY4QYEdjKGAPxIOu4e/4uq96gqixpA+zmKua8m2bA=;
        b=DB473sT1fqzBvRAEfmFxAcdTRMllRh8VzJfixMhr1wztqI64ioZR8gaOZ/FucGGavM
         3YYQHXch0cPmvjj44ZZ/ZepMs5VwvuVyP3Cm8rI1c/S5oJoKhJfTvd+kcSgl2NeyAgHn
         ZuH5S3IXHm1KvrfnBrLWnek12ya7cvBe0ivXgnR8GjmllMLkcxLz+CnJZzgXySjQSgH0
         hHX44y0V+6DrTIfOxLhmiony6Atpoc1QUaXMUQGQOvv4A6e2pD/R051FAiZNU6JWP1Yo
         5qIk5dRVSIVxc/8MIpxl4gZEIe8MpZKKMhe3K/Fd6so18Xxd2AvwFAa59MlIvCFhCv4I
         PeQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3plY4QYEdjKGAPxIOu4e/4uq96gqixpA+zmKua8m2bA=;
        b=VLj2DD9xc8rrPdhtEB9lPoCSulBFTOfLmTsIpbwAeXcHEMUGZ0oC4lXyW0zVu6/7WM
         vCe7VQT+nzILhWt9f6rxDMQZiQGUGJyjEVEgoebTc+xrBGcbI9Otg1yshhd6vdjXJNYV
         XZpGAsXeCnZeVyrDV1A+7rwNnalVgnso2QvU/nrm7QXOHYgBPPoW9elHKEFlxWty/QXG
         JP9s4X6fNLzmwDiZBkNqgN7fmTeJIlch1Z930ePq/Y/8MMva9NTOa4maxlfdtmhDTd1b
         Bw9BdE3P/imf7KC5QrgP0fzMyljbU4B99LdWX8rcuQi/UEujrqMjbixB3L49/tv7U7q0
         eHiw==
X-Gm-Message-State: AOAM53183NohTq/jsAnwsq9+7M2rduffp0rO1jk/CQu8GQTFo42xhD2+
        zUSm/auO9MDtG/oQyCEqLJs=
X-Google-Smtp-Source: ABdhPJz3X9vVeYB2pcrCLx/Kd08S18GRi0jxAHf2vluQNyxbwVAJgMTC3VrDdNxFFyUXMoTT/zg2ow==
X-Received: by 2002:a63:544f:0:b0:3d8:220e:d428 with SMTP id e15-20020a63544f000000b003d8220ed428mr682693pgm.568.1652134929955;
        Mon, 09 May 2022 15:22:09 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id v11-20020a170902f0cb00b0015e8d4eb1efsm395823pla.57.2022.05.09.15.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 15:22:09 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v5 net-next 09/13] ipv6: Add hop-by-hop header to jumbograms in ip6_output
Date:   Mon,  9 May 2022 15:21:45 -0700
Message-Id: <20220509222149.1763877-10-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220509222149.1763877-1-eric.dumazet@gmail.com>
References: <20220509222149.1763877-1-eric.dumazet@gmail.com>
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

