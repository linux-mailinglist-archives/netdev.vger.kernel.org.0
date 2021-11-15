Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D4A450A89
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 18:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhKORJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 12:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbhKORI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 12:08:57 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0171C061746
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:06:01 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id y8so9533007plg.1
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XsV80a8a3PHq3K/cQdOJIdaSw2AE9+fZVk2+oac9vDA=;
        b=WqhIS1doKx9avYwCR4VL4w6J16hIuS6dp5FALbcu/gvS8BG9kV3wB0y5B/qVRgHAy3
         WCeLkV9eUlD3pRLZ+ScZLU4sZ/UYuIMez0osf+E0teh51BRtQEX4pURqkmuNY3axW7fY
         PePKbKpCcFGVrYWTxHCS3VacnaTHVUanlvTAm+4wf/vMoxvwbMneQmijRwaAcABErBYc
         xI5eqgSAhCNsU6vVEydI/kOf3Hx8Q+aN1tZg8CuQaLkPbfCmj1JHfWOwa0MsLlGRC28Z
         ubdSwGdIC2LJ5OtmVs74GvkTaMwK5EzEbuJzyALlxZqEg+XqtSDL8p5UAGbpsnkIKZxB
         dYlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XsV80a8a3PHq3K/cQdOJIdaSw2AE9+fZVk2+oac9vDA=;
        b=M0VGvPAQfR9LQnj4/A2BoOBgAX7MQP9AoyMVmMTEeVYAyWZrPInuBx6+g99Mqs9uZ4
         e3yNu7blk01ZHfrrnRv0XUmjKEmRYzNZGOQn9yIIBzeKkFSL8+p3XLVEZQuvOXGoiAwn
         /At01y3xmu9Lun9ktn5Iv6k+5be5J/ecSX02DSV2LLL+SrRvHoIl7RZ52R3dQwBfitKu
         jcyHQAKXlvstSpVjl/7LHNNFMbf2LefqEZbGydyUv+cNh7240io+xKzVkQJFp3CoMFrs
         aYLckNhVALR/ZApT6K+lP9KzAsy6pQaa+8mVhXVf+sF/O7KL6q+GODfG1kEc+6j9AWf2
         XHbg==
X-Gm-Message-State: AOAM533lBPRil1caLilpMeleETrQvsSsLS+OpFS7qOkKrTjZR2rNBQI4
        qCfDTTbrPzr6phyL0gh4vBo=
X-Google-Smtp-Source: ABdhPJyKXxOwHCJ09wAd4QwfqQ58Wu/gNqWYusykGlWqo3fNSolEs4EIHkb6eFPifh4LS9XBT6xhWw==
X-Received: by 2002:a17:90a:ce14:: with SMTP id f20mr39184205pju.121.1636995961487;
        Mon, 15 Nov 2021 09:06:01 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id y28sm15971845pfa.208.2021.11.15.09.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 09:06:01 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/4] net: gro: move skb_gro_receive_list to udp_offload.c
Date:   Mon, 15 Nov 2021 09:05:52 -0800
Message-Id: <20211115170554.3645322-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115170554.3645322-1-eric.dumazet@gmail.com>
References: <20211115170554.3645322-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This helper is used once, no need to keep it in fat net/core/skbuff.c

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h |  1 -
 net/core/skbuff.c         | 26 --------------------------
 net/ipv4/udp_offload.c    | 27 +++++++++++++++++++++++++++
 3 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d95c9839ce90d611f4b729c7c54e277446259c7a..ce6ee1453dbc3691fab13ee079347fbd49e587d3 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2903,7 +2903,6 @@ struct net_device *dev_get_by_napi_id(unsigned int napi_id);
 int netdev_get_name(struct net *net, char *name, int ifindex);
 int dev_restart(struct net_device *dev);
 int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb);
-int skb_gro_receive_list(struct sk_buff *p, struct sk_buff *skb);
 
 
 static inline int dev_hard_header(struct sk_buff *skb, struct net_device *dev,
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1c4f2a2e52550eef6eb6002314813983abb2e266..68b13bc77b749dbacf739a71ef7a1b5f48d89e0c 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3920,32 +3920,6 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(skb_segment_list);
 
-int skb_gro_receive_list(struct sk_buff *p, struct sk_buff *skb)
-{
-	if (unlikely(p->len + skb->len >= 65536))
-		return -E2BIG;
-
-	if (NAPI_GRO_CB(p)->last == p)
-		skb_shinfo(p)->frag_list = skb;
-	else
-		NAPI_GRO_CB(p)->last->next = skb;
-
-	skb_pull(skb, skb_gro_offset(skb));
-
-	NAPI_GRO_CB(p)->last = skb;
-	NAPI_GRO_CB(p)->count++;
-	p->data_len += skb->len;
-
-	/* sk owenrship - if any - completely transferred to the aggregated packet */
-	skb->destructor = NULL;
-	p->truesize += skb->truesize;
-	p->len += skb->len;
-
-	NAPI_GRO_CB(skb)->same_flow = 1;
-
-	return 0;
-}
-
 /**
  *	skb_segment - Perform protocol segmentation on skb.
  *	@head_skb: buffer to segment
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 7fbf9975e8c0e9f0aa6a707bb63b55628ca6add8..cbeb8965d1b771b4d50c888a42279287904304e9 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -425,6 +425,33 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
 	return segs;
 }
 
+static int skb_gro_receive_list(struct sk_buff *p, struct sk_buff *skb)
+{
+	if (unlikely(p->len + skb->len >= 65536))
+		return -E2BIG;
+
+	if (NAPI_GRO_CB(p)->last == p)
+		skb_shinfo(p)->frag_list = skb;
+	else
+		NAPI_GRO_CB(p)->last->next = skb;
+
+	skb_pull(skb, skb_gro_offset(skb));
+
+	NAPI_GRO_CB(p)->last = skb;
+	NAPI_GRO_CB(p)->count++;
+	p->data_len += skb->len;
+
+	/* sk owenrship - if any - completely transferred to the aggregated packet */
+	skb->destructor = NULL;
+	p->truesize += skb->truesize;
+	p->len += skb->len;
+
+	NAPI_GRO_CB(skb)->same_flow = 1;
+
+	return 0;
+}
+
+
 #define UDP_GRO_CNT_MAX 64
 static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
 					       struct sk_buff *skb)
-- 
2.34.0.rc1.387.gb447b232ab-goog

