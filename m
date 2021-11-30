Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62CF4639CE
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243505AbhK3PYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:24:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245066AbhK3PX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:23:27 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A5CC061379;
        Tue, 30 Nov 2021 07:19:22 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id a18so45275010wrn.6;
        Tue, 30 Nov 2021 07:19:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=glFnrAs7mklFewoiKDwODPpbaBl+DaLALK70LzQTA2E=;
        b=MV7WRbvj07PfWujdZ0i0U8PpHdYwYDoSGYUwtPMYcFgW4tZp5H9k8sGaFrWnz9yH7/
         JdMTQK2XHWrdKevIsKDUNLsxK0B6Zehv4szXOdRBdw7IfKni78Zs8HxYIijT03+B1kuR
         oL16T/9sUR2uFS+wP77gUNuWPyRdoTbHSkpCtMJ60HUqOTObcjaCjcwu16hLaYXlKHZV
         UXeRHyh6IJGcde3jdSlPpiCEB4/Jx2l5D9CKlD2p9T5Tb++wiRk+C0tcJj7uz90fMc03
         yLY1AjyWpcRHOJNLANXwFFLh5O9O6+SHSlUc+ZyP3w7lT3YLE/4jbqguuYrQUjEIGKAE
         JaQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=glFnrAs7mklFewoiKDwODPpbaBl+DaLALK70LzQTA2E=;
        b=7iCfNpvEuG1KtbnT89nN3PDCr4u+0HoktM7e2Y1PVhYKtYy/t/DtMZCTk/I+B1eh5F
         IY5X9dXI+7hsMH3kx3KJBssEVjyu5mhVLV+5aSWFFxM+k7zaH1i6ViIgqlxz4UlfnhwS
         qzSgx8JkXqsnTSALdldAWHvh5cK7bjvCfCx1LTuWe5zLoX2ZlpHGMWX7WvK7byXOiSZG
         SXWitklPUjygEI8VOSr2yNubaICYy1t7OCBC7ltIJzTK95ffaLPuJRZtN0RV/KOWS9Cl
         +MiNj2YAancHZ/4fsdjNGdqXHWgBXnCAd091r3eB9tOL62KZG0PpMLw+FmHFZPSsgD9D
         LB6g==
X-Gm-Message-State: AOAM530QN5r93PP4kCdBCyvvQGDePI/2C3nX8tMKPd2sFzyq2IUpw4xC
        obUexRpDDZ0aukWJ19TeEGkEhCzwgFg=
X-Google-Smtp-Source: ABdhPJzW1gHvdrbgEk4gxWYoimeQ9lrv/Jn3fBElCMlalpMK3YOlWNPOxtSw+Cju7eR0BsTv0DSxeA==
X-Received: by 2002:adf:ef42:: with SMTP id c2mr40183493wrp.528.1638285561426;
        Tue, 30 Nov 2021 07:19:21 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.232.109])
        by smtp.gmail.com with ESMTPSA id d1sm16168483wrz.92.2021.11.30.07.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 07:19:20 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC 03/12] net/udp: add support msgdr::msg_ubuf
Date:   Tue, 30 Nov 2021 15:18:51 +0000
Message-Id: <26e2222a6f3316d218a3df0ca668dcd65536c1ba.1638282789.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1638282789.git.asml.silence@gmail.com>
References: <cover.1638282789.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make ipv4/udp to use ubuf_info passed in struct msghdr if it was
specified.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/net/ip.h     |  3 ++-
 net/ipv4/ip_output.c | 31 ++++++++++++++++++++++++-------
 net/ipv4/udp.c       |  2 +-
 3 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index b71e88507c4a..e9c61b83a770 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -232,7 +232,8 @@ struct sk_buff *ip_make_skb(struct sock *sk, struct flowi4 *fl4,
 					int len, int odd, struct sk_buff *skb),
 			    void *from, int length, int transhdrlen,
 			    struct ipcm_cookie *ipc, struct rtable **rtp,
-			    struct inet_cork *cork, unsigned int flags);
+			    struct inet_cork *cork, unsigned int flags,
+			    struct ubuf_info *uarg);
 
 int ip_queue_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl);
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 9bca57ef8b83..f9aab355d283 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -948,10 +948,10 @@ static int __ip_append_data(struct sock *sk,
 			    int getfrag(void *from, char *to, int offset,
 					int len, int odd, struct sk_buff *skb),
 			    void *from, int length, int transhdrlen,
-			    unsigned int flags)
+			    unsigned int flags,
+			    struct ubuf_info *uarg)
 {
 	struct inet_sock *inet = inet_sk(sk);
-	struct ubuf_info *uarg = NULL;
 	struct sk_buff *skb;
 
 	struct ip_options *opt = cork->opt;
@@ -967,6 +967,7 @@ static int __ip_append_data(struct sock *sk,
 	unsigned int wmem_alloc_delta = 0;
 	bool paged, extra_uref = false;
 	u32 tskey = 0;
+	bool zc = false;
 
 	skb = skb_peek_tail(queue);
 
@@ -1001,7 +1002,21 @@ static int __ip_append_data(struct sock *sk,
 	    (!exthdrlen || (rt->dst.dev->features & NETIF_F_HW_ESP_TX_CSUM)))
 		csummode = CHECKSUM_PARTIAL;
 
-	if (flags & MSG_ZEROCOPY && length && sock_flag(sk, SOCK_ZEROCOPY)) {
+	if (uarg) {
+		if (skb_zcopy(skb) && uarg != skb_zcopy(skb))
+			return -EINVAL;
+
+		/* If it's not zerocopy, just drop uarg, the caller should
+		 * be able to handle it.
+		 */
+		if (rt->dst.dev->features & NETIF_F_SG &&
+		    csummode == CHECKSUM_PARTIAL) {
+			paged = true;
+			zc = true;
+		} else {
+			uarg = NULL;
+		}
+	} else if (flags & MSG_ZEROCOPY && length && sock_flag(sk, SOCK_ZEROCOPY)) {
 		uarg = msg_zerocopy_realloc(sk, length, skb_zcopy(skb));
 		if (!uarg)
 			return -ENOBUFS;
@@ -1009,6 +1024,7 @@ static int __ip_append_data(struct sock *sk,
 		if (rt->dst.dev->features & NETIF_F_SG &&
 		    csummode == CHECKSUM_PARTIAL) {
 			paged = true;
+			zc = true;
 		} else {
 			uarg->zerocopy = 0;
 			skb_zcopy_set(skb, uarg, &extra_uref);
@@ -1172,7 +1188,7 @@ static int __ip_append_data(struct sock *sk,
 				err = -EFAULT;
 				goto error;
 			}
-		} else if (!uarg || !uarg->zerocopy) {
+		} else if (!zc) {
 			int i = skb_shinfo(skb)->nr_frags;
 
 			err = -ENOMEM;
@@ -1309,7 +1325,7 @@ int ip_append_data(struct sock *sk, struct flowi4 *fl4,
 
 	return __ip_append_data(sk, fl4, &sk->sk_write_queue, &inet->cork.base,
 				sk_page_frag(sk), getfrag,
-				from, length, transhdrlen, flags);
+				from, length, transhdrlen, flags, NULL);
 }
 
 ssize_t	ip_append_page(struct sock *sk, struct flowi4 *fl4, struct page *page,
@@ -1601,7 +1617,8 @@ struct sk_buff *ip_make_skb(struct sock *sk,
 					int len, int odd, struct sk_buff *skb),
 			    void *from, int length, int transhdrlen,
 			    struct ipcm_cookie *ipc, struct rtable **rtp,
-			    struct inet_cork *cork, unsigned int flags)
+			    struct inet_cork *cork, unsigned int flags,
+			    struct ubuf_info *uarg)
 {
 	struct sk_buff_head queue;
 	int err;
@@ -1620,7 +1637,7 @@ struct sk_buff *ip_make_skb(struct sock *sk,
 
 	err = __ip_append_data(sk, fl4, &queue, cork,
 			       &current->task_frag, getfrag,
-			       from, length, transhdrlen, flags);
+			       from, length, transhdrlen, flags, uarg);
 	if (err) {
 		__ip_flush_pending_frames(sk, &queue, cork);
 		return ERR_PTR(err);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 8bcecdd6aeda..8c514bff48d4 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1247,7 +1247,7 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 		skb = ip_make_skb(sk, fl4, getfrag, msg, ulen,
 				  sizeof(struct udphdr), &ipc, &rt,
-				  &cork, msg->msg_flags);
+				  &cork, msg->msg_flags, msg->msg_ubuf);
 		err = PTR_ERR(skb);
 		if (!IS_ERR_OR_NULL(skb))
 			err = udp_send_skb(skb, fl4, &cork);
-- 
2.34.0

