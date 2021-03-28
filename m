Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE5134BED7
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 22:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbhC1UUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 16:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhC1UUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 16:20:30 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE118C061762;
        Sun, 28 Mar 2021 13:20:29 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id h3-20020a4ae8c30000b02901b68b39e2d3so2528237ooe.9;
        Sun, 28 Mar 2021 13:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iyyf6p84HkUZhn7oEnpkYVECmHMe1tHTFg8XmIdMNhs=;
        b=YEw7HTgmy/IPze2HiaOE+9Dme9Y6qjM6+/ibiRThwHKTvwUAXPd49DkRpnKYLG/xKg
         I3kCxH2plZr8h5C5xo1mAMmdrT6F0zZ4KCjZX9nDulHOAn0MQxvm5xzyfADeun8CI+aa
         0nkZ4WGqAdgGutHjI/NKQn/Q52IQAOKKOxTU6jQqx8cDfJxLYokk4uKI0P2wH4Z9EQML
         coOlyD7mOZHElIFlpX9sFT4Ryfbh78jy9BLV4M9KrMByGxNCL/WeBCxhhbk6mg0eWAsk
         Q1id8eesmHVCT3fmvcwH2aUnnGOKegYVc7cBrZCqfdkYImbxYSDIQHVd+ftdGXczivn1
         FfbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iyyf6p84HkUZhn7oEnpkYVECmHMe1tHTFg8XmIdMNhs=;
        b=TtEMhBRxwqGp8FbXHsuLevJa/wHqvXg9NCy6Usmoth5PT8mKChiUZ63T+mDnsxSZLG
         W3wT2a8NbpsiA22vMtZydh23rfivdW17Zm21OH6mVczkSdYdku3PNw8u8UmMAtWUsEcl
         syj+aLy6QzwZOE8pGjPZvf+WPjbpae0HNXy+HYNfDaMKTW3U3g5fdx1n7Ot9/17frQyO
         jEo3Fl470W8yNj8zfDxCS3nOBl1abrQQlwFYIkIe8Z6yFbQ5oVDFWIXiEUpzEaubWLwi
         /kmcvM+pEgWD/OCfqAH1Yls/GG1/uOwU9tr5mr1lQrrClXQ66xO1D6zOjZO45M+Iueh7
         8HdQ==
X-Gm-Message-State: AOAM533L8XCn9t77AYqP8XSB/Q7LsrXAIicF1Nu9ipOj9YISxtmFahbc
        K5OgrUJGfN8NaVUhZSanYkBPq9LUZ1Dn9A==
X-Google-Smtp-Source: ABdhPJw3BAM8W3nXhpYv/JVNKXo6fWG6NQYMXdYYt5qyW1JtUsL2CXdvRoox21Oiyu/WMSLAsMh5gg==
X-Received: by 2002:a4a:9823:: with SMTP id y32mr18976075ooi.35.1616962829044;
        Sun, 28 Mar 2021 13:20:29 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:bca7:4b69:be8f:21bb])
        by smtp.gmail.com with ESMTPSA id v30sm3898240otb.23.2021.03.28.13.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 13:20:28 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v7 09/13] udp: implement ->read_sock() for sockmap
Date:   Sun, 28 Mar 2021 13:20:09 -0700
Message-Id: <20210328202013.29223-10-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
References: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This is similar to tcp_read_sock(), except we do not need
to worry about connections, we just need to retrieve skb
from UDP receive queue.

Note, the return value of ->read_sock() is unused in
sk_psock_verdict_data_ready().

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/net/udp.h   |  2 ++
 net/ipv4/af_inet.c  |  1 +
 net/ipv4/udp.c      | 35 +++++++++++++++++++++++++++++++++++
 net/ipv6/af_inet6.c |  1 +
 4 files changed, 39 insertions(+)

diff --git a/include/net/udp.h b/include/net/udp.h
index df7cc1edc200..347b62a753c3 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -329,6 +329,8 @@ struct sock *__udp6_lib_lookup(struct net *net,
 			       struct sk_buff *skb);
 struct sock *udp6_lib_lookup_skb(const struct sk_buff *skb,
 				 __be16 sport, __be16 dport);
+int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
+		  sk_read_actor_t recv_actor);
 
 /* UDP uses skb->dev_scratch to cache as much information as possible and avoid
  * possibly multiple cache miss on dequeue()
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 1355e6c0d567..f17870ee558b 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1070,6 +1070,7 @@ const struct proto_ops inet_dgram_ops = {
 	.setsockopt	   = sock_common_setsockopt,
 	.getsockopt	   = sock_common_getsockopt,
 	.sendmsg	   = inet_sendmsg,
+	.read_sock	   = udp_read_sock,
 	.recvmsg	   = inet_recvmsg,
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = inet_sendpage,
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 38952aaee3a1..04620e4d64ab 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1782,6 +1782,41 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
 }
 EXPORT_SYMBOL(__skb_recv_udp);
 
+int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
+		  sk_read_actor_t recv_actor)
+{
+	int copied = 0;
+
+	while (1) {
+		int offset = 0, err;
+		struct sk_buff *skb;
+
+		skb = __skb_recv_udp(sk, 0, 1, &offset, &err);
+		if (!skb)
+			return err;
+		if (offset < skb->len) {
+			size_t len;
+			int used;
+
+			len = skb->len - offset;
+			used = recv_actor(desc, skb, offset, len);
+			if (used <= 0) {
+				if (!copied)
+					copied = used;
+				break;
+			} else if (used <= len) {
+				copied += used;
+				offset += used;
+			}
+		}
+		if (!desc->count)
+			break;
+	}
+
+	return copied;
+}
+EXPORT_SYMBOL(udp_read_sock);
+
 /*
  * 	This should be easy, if there is something there we
  * 	return it, otherwise we block.
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 802f5111805a..71de739b4a9e 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -714,6 +714,7 @@ const struct proto_ops inet6_dgram_ops = {
 	.getsockopt	   = sock_common_getsockopt,	/* ok		*/
 	.sendmsg	   = inet6_sendmsg,		/* retpoline's sake */
 	.recvmsg	   = inet6_recvmsg,		/* retpoline's sake */
+	.read_sock	   = udp_read_sock,
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = sock_no_sendpage,
 	.set_peek_off	   = sk_set_peek_off,
-- 
2.25.1

