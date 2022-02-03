Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04ED4A7D90
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 02:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348890AbiBCBwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 20:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348901AbiBCBwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 20:52:07 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EAD9C061401
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 17:52:07 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id h14so895426plf.1
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 17:52:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lS50yp83p+SNj0vDZeMAmBxyMqJlbsYaYv7jsnPoMd0=;
        b=j8tH7nnRNC6LIo/txtZGoRt/nMFML/wLtXtNsVPey1dePxRhpCqsi/juYBkV17nirL
         ucos68b0Ft1+FIDz3HcNX6iu35clWZ+Xg4tQ0eXXeEvp/AB77hYX8paXF5Ne4YVZ86IT
         AJoN1hirpFwWffSnUWdGm2VXqNVNLWXUqkzNKayab5N7uEQ/uAqOLAxkcg9Mg87uqhAN
         X9ZqAlmr49F6SBwvY1w9XG/OcUuWdjFhADNtkhFN47oyXGoPdl1DnFd3ZlZiZzm/IlkX
         FO1cFehyYDcxKDs6Uyi0SJWXAH/aMaame2rcnkgwMFY2zrb2jd9noDrHJzrePS0OqqVb
         pukQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lS50yp83p+SNj0vDZeMAmBxyMqJlbsYaYv7jsnPoMd0=;
        b=28oGExnPv42WFEOWGmIYvZTXtxPGrNQKb8I/VWH8AkuvTLTbTmiN1Ej21Epz2S6j8U
         8OAmasFQ3P1vPTDwZoYlrDBgE/TV6twcV0hUW176PvjfgJJBuoZx4g+0u99CagnNJk5A
         rK7m1QxDl1/Mk5HhlmtBbQmF69Iz3AmtWXMwUULj674KxAje/RdoeaJzniXkbqd01vpE
         /eeGoGwx0p76llaOWlylqza6YVXEbIawactUoWc7AxQID/6/BjaxpOhMAUQ7GSMq4LF7
         3loQ13Qdthifedja0bfkKc/qT9Af4nswfdpQ9Dc2Xd4sgxy85PXJFROQSc5PdUJJ/QYF
         q3XA==
X-Gm-Message-State: AOAM5301jU4czoPolf5DxEOZKF0gj0Mjmdu/2p+oYF3HLIdkY172vnes
        l6W7l87v8mz8ve9a/XZwn34=
X-Google-Smtp-Source: ABdhPJyDUfLrLqVScSpRRpjinb4s6AOW0iltZzEeyXnH5Yf9vGaY0urZDMd4hWjN9/41jauVGfe5Fw==
X-Received: by 2002:a17:903:188:: with SMTP id z8mr32956020plg.61.1643853126806;
        Wed, 02 Feb 2022 17:52:06 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:697a:fa00:b793:ed3a])
        by smtp.gmail.com with ESMTPSA id qe16sm509611pjb.22.2022.02.02.17.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 17:52:06 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 08/15] ipv6: Add hop-by-hop header to jumbograms in ip6_output
Date:   Wed,  2 Feb 2022 17:51:33 -0800
Message-Id: <20220203015140.3022854-9-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
In-Reply-To: <20220203015140.3022854-1-eric.dumazet@gmail.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 1e0f8a31f3de175659dca9ecee9f97d8b01e2b68..d3fb87e1589997570cde9cb5d92b2222008a229d 100644
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
index 0c6c971ce0a58b50f8a9349b8507dffac9c7818c..f78ba145620560e5d7cb25aaf16fec61ddd9ed40 100644
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
2.35.0.rc2.247.g8bbb082509-goog

