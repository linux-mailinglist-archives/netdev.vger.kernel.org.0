Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEB147C2F7
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 16:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239432AbhLUPgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 10:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239443AbhLUPgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 10:36:01 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D6FC061747;
        Tue, 21 Dec 2021 07:36:00 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id a9so27689717wrr.8;
        Tue, 21 Dec 2021 07:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I4xvaEvPhhgm/G3PxBzFOn189LbQsp3mXz6KTK9Hscw=;
        b=pb20C7sUx1QTnoXGlwt8gXcXP52QOFY7++jO7Sv0Am/2USGvB04nc728Qn8z4IzjzM
         IGEX9uKsmZJ12XHfylDx4xLBV6y747sKA2iz3cxjlU9DaYsXkDOAv/0yiR2gmm5xujiI
         VrRNIBiwPRspBHQNdPwtCcWx0WP/w7iSEHdFiPVuehAjKCOkDkDyq5o7zfoHH40f+BqI
         zT9jwPLXDNz4UkLJq9IxqAl3FR2yLeVxehTlHLuZy/7bEcdAYvp/99ssJaEuzSSB8Cuy
         3/2zzgA/ah7GaD5pTo0J3GarajbGBYs53s5ukXEjoHJYA3FAyP8tIjt1HfEM9XB2z+95
         0hQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I4xvaEvPhhgm/G3PxBzFOn189LbQsp3mXz6KTK9Hscw=;
        b=PKudjQcdpULPUhDsddUa+eY0EvF4gVY5favMudrxpi41O8Xfc7pdfQKz8ZojG+xYOt
         bT3pEVYzHRsNENeThfoelWeF+2YpgWe4PBrxaeg06rPpqaQRM4TbfjwWgLNniW4vKZnG
         pyeMeppJMqGSa8L6Z/M5jL93mt3sNwcVB7wlwyRQxG9cf3BFYgLRcMU/wtg4HP/DKb7o
         bvm6jKKzC6U+AlgXt1rFvdN4kJbqfoqXjwrwZIAwSeKQH9eqBa7VGlg/u8NBGwQu4qXg
         ErMu8kXu0g0Brh+OATPgJD0PZ3Q8GApzFXI9u/U0LazEo6foYPj5ai2hlsHIwIOLoTJR
         TkTQ==
X-Gm-Message-State: AOAM530cLtz9CpDB5uoiOuvdgzVEagz9njAbkRFV7xqQ57bkBYgtHyKl
        VVxhBP1TvlmdCO+KQLOtz+wEdYkXEck=
X-Google-Smtp-Source: ABdhPJxLNE54pXGhLwACql6bjUs5JQQNcqSYHl50lCRaTtP5PdzfaSB18zl5/Yb7lUkXXeayTj099A==
X-Received: by 2002:a05:6000:144a:: with SMTP id v10mr3048581wrx.357.1640100959416;
        Tue, 21 Dec 2021 07:35:59 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.24])
        by smtp.gmail.com with ESMTPSA id z11sm2946019wmf.9.2021.12.21.07.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 07:35:59 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC v2 07/19] ipv6/udp: add support msgdr::msg_ubuf
Date:   Tue, 21 Dec 2021 15:35:29 +0000
Message-Id: <70428063e99a4418d2e519a496ebd1096d45ac59.1640029579.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1640029579.git.asml.silence@gmail.com>
References: <cover.1640029579.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make ipv6/udp to use ubuf_info passed in struct msghdr if it was
specified.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 49 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 12 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 2f044a49afa8..822e3894dd3b 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1452,6 +1452,7 @@ static int __ip6_append_data(struct sock *sk,
 	unsigned int maxnonfragsize, headersize;
 	unsigned int wmem_alloc_delta = 0;
 	bool paged, extra_uref = false;
+	bool zc = false;
 
 	skb = skb_peek_tail(queue);
 	if (!skb) {
@@ -1516,17 +1517,37 @@ static int __ip6_append_data(struct sock *sk,
 	    rt->dst.dev->features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
 		csummode = CHECKSUM_PARTIAL;
 
-	if (flags & MSG_ZEROCOPY && length && sock_flag(sk, SOCK_ZEROCOPY)) {
-		uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
-		if (!uarg)
-			return -ENOBUFS;
-		extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
-		if (rt->dst.dev->features & NETIF_F_SG &&
-		    csummode == CHECKSUM_PARTIAL) {
-			paged = true;
-		} else {
-			uarg->zerocopy = 0;
-			skb_zcopy_set(skb, uarg, &extra_uref);
+	if ((flags & MSG_ZEROCOPY) && length) {
+		struct msghdr *msg = from;
+
+		if (getfrag == ip_generic_getfrag && msg->msg_ubuf) {
+			uarg = msg->msg_ubuf;
+			if (skb_zcopy(skb) && uarg != skb_zcopy(skb))
+				return -EINVAL;
+
+			if (rt->dst.dev->features & NETIF_F_SG &&
+				csummode == CHECKSUM_PARTIAL) {
+				paged = true;
+				zc = true;
+			} else {
+				/* Drop uarg if can't zerocopy, callers should
+				 * be able to handle it.
+				 */
+				uarg = NULL;
+			}
+		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
+			uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
+			if (!uarg)
+				return -ENOBUFS;
+			extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
+			if (rt->dst.dev->features & NETIF_F_SG &&
+			    csummode == CHECKSUM_PARTIAL) {
+				paged = true;
+				zc = true;
+			} else {
+				uarg->zerocopy = 0;
+				skb_zcopy_set(skb, uarg, &extra_uref);
+			}
 		}
 	}
 
@@ -1717,9 +1738,13 @@ static int __ip6_append_data(struct sock *sk,
 				err = -EFAULT;
 				goto error;
 			}
-		} else if (!uarg || !uarg->zerocopy) {
+		} else if (!zc) {
 			int i = skb_shinfo(skb)->nr_frags;
 
+			if (skb_shinfo(skb)->flags & SKBFL_MANAGED_FRAGS) {
+				err = -EFAULT;
+				goto error;
+			}
 			err = -ENOMEM;
 			if (!sk_page_frag_refill(sk, pfrag))
 				goto error;
-- 
2.34.1

