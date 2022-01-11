Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3F448A4FF
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346462AbiAKBZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346285AbiAKBY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:24:59 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457EFC0611FF;
        Mon, 10 Jan 2022 17:24:56 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id s1so30124407wra.6;
        Mon, 10 Jan 2022 17:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m6AI07V5V9bxuzbKOOkycd9Y2cUTCObOibCgtj03Nis=;
        b=LXz32GX2FsenK8ogWOx5xOgq7KcpiJxFHgmyj6jS4UUJuu+yV4Folo9Pz2uwpKs2ND
         jsUjWlAA94+XO7eLG1W74qJUPN8Z2KDmhbLw5TDQ90rHZJo2PR8+BxE04BV6BbLMwAfy
         H41XjFt6UZEr6kqnvO/O/WLF/yB8J5HGpxgvboBA1P7UcgE3BYI3UcC+Cq8ymHk4Bgs+
         yOljL0SUj1pIndc8u9PyuTHdeJ3nKuVC7ujEz5vEBqdmzwUcL7MHGHn8XMxgX/wOEYi/
         TVZKrZ22ezyJiEkhIYoC0yVzqWwb+fYp9PdFGGhgCrAfMousd7cgdupeygcrJdskRCNe
         9AmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m6AI07V5V9bxuzbKOOkycd9Y2cUTCObOibCgtj03Nis=;
        b=dk4KXXzsaf1z5eLqjnCWOWVA4Amrz3edXUKaNs2LdcNTrKadPRGo55g1YEW/eWWTuO
         Itfl5E7OukO8njpLu6Lh8eYkKmtzQ6qDI8GTZvsGZje2rXsQs2Nw/YNyaWAo42fmSGBu
         azDUFfAr0O50rVLTk25QNB/jjU4rTMhEOow0ZC7tOckwwwfMn36QlFJnXxacXyL6C2Gh
         ZJ9dTOjp8RQQeTAwOH249AZTVE2M9HUqZBlBxGY659Nee4iatq3Vcxeo+PtkBu9YUxDD
         nmoEITZPNcoTQkNvIYcgJoUHZ7cMXivB9ZShpj3zcUSmufaZFXwXybbbhACT/F12hg0H
         MGzA==
X-Gm-Message-State: AOAM530X9AVSYANf7E8G16rTiQ2deN/gHZgPFncbcvEem81mc8vgYFtw
        babvBf/RGyyq+7uZodSALYnJK6vCh9w=
X-Google-Smtp-Source: ABdhPJy/ZUGcCJS0Lon/Dpa8hvO13IMCkzTAgnkRG64EN426gYS89LzrnHhzAeiD2rJLi8K3AFKPPA==
X-Received: by 2002:a05:6000:1e15:: with SMTP id bj21mr1832686wrb.118.1641864294702;
        Mon, 10 Jan 2022 17:24:54 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.73])
        by smtp.gmail.com with ESMTPSA id i8sm709886wru.26.2022.01.10.17.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 17:24:54 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 11/14] skbuff: drop null check from skb_zcopy
Date:   Tue, 11 Jan 2022 01:21:44 +0000
Message-Id: <cc77c4de5509d1b78afbff5c640f45eceb05617a.1641863490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1641863490.git.asml.silence@gmail.com>
References: <cover.1641863490.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb_zcopy() is used all around the networkong code with many of calls
sitting in generic not necessarily zerocopy paths. Many of callers
don't ever pass a NULL skb, however a NULL check inside skb_zcopy()
can't be optimised out. As with previous patch, move the check out of
the helper to a few places where it's needed.

It removes a bunch of extra ifs in non-zerocopy paths, which is nice.
E.g. before and after:

   text    data     bss     dec     hex filename
8521472       0       0 8521472  820700 arch/x86/boot/bzImage
8521056       0       0 8521056  820560 arch/x86/boot/bzImage
delta=416B

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h | 2 +-
 net/core/dev.c         | 2 +-
 net/core/skbuff.c      | 3 ++-
 net/ipv4/ip_output.c   | 7 +++++--
 net/ipv4/tcp.c         | 5 ++++-
 net/ipv6/ip6_output.c  | 7 +++++--
 6 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 8a7d0d03a100..7fd2b44aada0 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1469,7 +1469,7 @@ static inline struct skb_shared_hwtstamps *skb_hwtstamps(struct sk_buff *skb)
 
 static inline struct ubuf_info *skb_zcopy(struct sk_buff *skb)
 {
-	bool is_zcopy = skb && skb_shinfo(skb)->flags & SKBFL_ZEROCOPY_ENABLE;
+	bool is_zcopy = skb_shinfo(skb)->flags & SKBFL_ZEROCOPY_ENABLE;
 
 	return is_zcopy ? skb_uarg(skb) : NULL;
 }
diff --git a/net/core/dev.c b/net/core/dev.c
index 83a4089990a0..877ebc0f72bd 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2239,7 +2239,7 @@ void dev_queue_xmit_nit(struct sk_buff *skb, struct net_device *dev)
 	}
 out_unlock:
 	if (pt_prev) {
-		if (!skb_orphan_frags_rx(skb2, GFP_ATOMIC))
+		if (!skb2 || !skb_orphan_frags_rx(skb2, GFP_ATOMIC))
 			pt_prev->func(skb2, skb->dev, pt_prev, skb->dev);
 		else
 			kfree_skb(skb2);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e514a36bcffc..a9b8ac38dc1a 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -890,7 +890,8 @@ EXPORT_SYMBOL(skb_dump);
  */
 void skb_tx_error(struct sk_buff *skb)
 {
-	skb_zcopy_clear(skb, true);
+	if (skb)
+		skb_zcopy_clear(skb, true);
 }
 EXPORT_SYMBOL(skb_tx_error);
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 87d4472545a5..b63f307cc5ab 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1001,10 +1001,13 @@ static int __ip_append_data(struct sock *sk,
 		csummode = CHECKSUM_PARTIAL;
 
 	if (flags & MSG_ZEROCOPY && length && sock_flag(sk, SOCK_ZEROCOPY)) {
-		uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
+		if (skb)
+			uarg = skb_zcopy(skb);
+		extra_uref = !uarg; /* only ref on new uarg */
+
+		uarg = msg_zerocopy_realloc(sk, length, uarg);
 		if (!uarg)
 			return -ENOBUFS;
-		extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
 		if (rt->dst.dev->features & NETIF_F_SG &&
 		    csummode == CHECKSUM_PARTIAL) {
 			paged = true;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 3b75836db19b..f35e49ea08ec 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1188,7 +1188,10 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 	if (flags & MSG_ZEROCOPY && size && sock_flag(sk, SOCK_ZEROCOPY)) {
 		skb = tcp_write_queue_tail(sk);
-		uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb));
+		if (skb)
+			uarg = skb_zcopy(skb);
+
+		uarg = msg_zerocopy_realloc(sk, size, uarg);
 		if (!uarg) {
 			err = -ENOBUFS;
 			goto out_err;
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 9881b61da493..41abe83c3419 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1513,10 +1513,13 @@ static int __ip6_append_data(struct sock *sk,
 		csummode = CHECKSUM_PARTIAL;
 
 	if (flags & MSG_ZEROCOPY && length && sock_flag(sk, SOCK_ZEROCOPY)) {
-		uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
+		if (skb)
+			uarg = skb_zcopy(skb);
+		extra_uref = !uarg; /* only ref on new uarg */
+
+		uarg = msg_zerocopy_realloc(sk, length, uarg);
 		if (!uarg)
 			return -ENOBUFS;
-		extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
 		if (rt->dst.dev->features & NETIF_F_SG &&
 		    csummode == CHECKSUM_PARTIAL) {
 			paged = true;
-- 
2.34.1

